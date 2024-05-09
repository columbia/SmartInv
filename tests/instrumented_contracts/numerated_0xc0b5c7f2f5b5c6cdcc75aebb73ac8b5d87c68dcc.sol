1 /*
2 https://powerpool.finance/
3 
4           wrrrw r wrr
5          ppwr rrr wppr0       prwwwrp                                 prwwwrp                   wr0
6         rr 0rrrwrrprpwp0      pp   pr  prrrr0 pp   0r  prrrr0  0rwrrr pp   pr  prrrr0  prrrr0    r0
7         rrp pr   wr00rrp      prwww0  pp   wr pp w00r prwwwpr  0rw    prwww0  pp   wr pp   wr    r0
8         r0rprprwrrrp pr0      pp      wr   pr pp rwwr wr       0r     pp      wr   pr wr   pr    r0
9          prwr wrr0wpwr        00        www0   0w0ww    www0   0w     00        www0    www0   0www0
10           wrr ww0rrrr
11 
12 */
13 
14 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.6.0;
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 // File: @openzeppelin/contracts/math/SafeMath.sol
95 
96 pragma solidity ^0.6.0;
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations with added overflow
100  * checks.
101  *
102  * Arithmetic operations in Solidity wrap on overflow. This can easily result
103  * in bugs, because programmers usually assume that an overflow raises an
104  * error, which is the standard behavior in high level programming languages.
105  * `SafeMath` restores this intuition by reverting the transaction when an
106  * operation overflows.
107  *
108  * Using this library instead of the unchecked operations eliminates an entire
109  * class of bugs, so it's recommended to use it always.
110  */
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `+` operator.
117      *
118      * Requirements:
119      *
120      * - Addition cannot overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b <= a, errorMessage);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      *
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts on
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
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return mod(a, b, "SafeMath: modulo by zero");
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b != 0, errorMessage);
250         return a % b;
251     }
252 }
253 
254 // File: @openzeppelin/contracts/utils/Address.sol
255 
256 pragma solidity ^0.6.2;
257 
258 /**
259  * @dev Collection of functions related to the address type
260  */
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
281         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
282         // for accounts without code, i.e. `keccak256('')`
283         bytes32 codehash;
284         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
285         // solhint-disable-next-line no-inline-assembly
286         assembly { codehash := extcodehash(account) }
287         return (codehash != accountHash && codehash != 0x0);
288     }
289 
290     /**
291      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292      * `recipient`, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by `transfer`, making them unable to receive funds via
297      * `transfer`. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to `recipient`, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      */
306     function sendValue(address payable recipient, uint256 amount) internal {
307         require(address(this).balance >= amount, "Address: insufficient balance");
308 
309         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
310         (bool success, ) = recipient.call{ value: amount }("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain`call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333       return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338      * `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
343         return _functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
368         require(address(this).balance >= value, "Address: insufficient balance for call");
369         return _functionCallWithValue(target, data, value, errorMessage);
370     }
371 
372     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
373         require(isContract(target), "Address: call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383 
384                 // solhint-disable-next-line no-inline-assembly
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
397 
398 pragma solidity ^0.6.0;
399 
400 
401 
402 
403 /**
404  * @title SafeERC20
405  * @dev Wrappers around ERC20 operations that throw on failure (when the token
406  * contract returns false). Tokens that return no value (and instead revert or
407  * throw on failure) are also supported, non-reverting calls are assumed to be
408  * successful.
409  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
410  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
411  */
412 library SafeERC20 {
413     using SafeMath for uint256;
414     using Address for address;
415 
416     function safeTransfer(IERC20 token, address to, uint256 value) internal {
417         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
418     }
419 
420     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
421         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
422     }
423 
424     /**
425      * @dev Deprecated. This function has issues similar to the ones found in
426      * {IERC20-approve}, and its usage is discouraged.
427      *
428      * Whenever possible, use {safeIncreaseAllowance} and
429      * {safeDecreaseAllowance} instead.
430      */
431     function safeApprove(IERC20 token, address spender, uint256 value) internal {
432         // safeApprove should only be called when setting an initial allowance,
433         // or when resetting it to zero. To increase and decrease it, use
434         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
435         // solhint-disable-next-line max-line-length
436         require((value == 0) || (token.allowance(address(this), spender) == 0),
437             "SafeERC20: approve from non-zero to non-zero allowance"
438         );
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
440     }
441 
442     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).add(value);
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
448         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
449         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
450     }
451 
452     /**
453      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
454      * on the return value: the return value is optional (but if data is returned, it must not be false).
455      * @param token The token targeted by the call.
456      * @param data The call data (encoded using abi.encode or one of its variants).
457      */
458     function _callOptionalReturn(IERC20 token, bytes memory data) private {
459         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
460         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
461         // the target address contains contract code and also asserts for success in the low-level call.
462 
463         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
464         if (returndata.length > 0) { // Return data is optional
465             // solhint-disable-next-line max-line-length
466             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
467         }
468     }
469 }
470 
471 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
472 
473 pragma solidity ^0.6.0;
474 
475 /**
476  * @dev Library for managing
477  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
478  * types.
479  *
480  * Sets have the following properties:
481  *
482  * - Elements are added, removed, and checked for existence in constant time
483  * (O(1)).
484  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
485  *
486  * ```
487  * contract Example {
488  *     // Add the library methods
489  *     using EnumerableSet for EnumerableSet.AddressSet;
490  *
491  *     // Declare a set state variable
492  *     EnumerableSet.AddressSet private mySet;
493  * }
494  * ```
495  *
496  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
497  * (`UintSet`) are supported.
498  */
499 library EnumerableSet {
500     // To implement this library for multiple types with as little code
501     // repetition as possible, we write it in terms of a generic Set type with
502     // bytes32 values.
503     // The Set implementation uses private functions, and user-facing
504     // implementations (such as AddressSet) are just wrappers around the
505     // underlying Set.
506     // This means that we can only create new EnumerableSets for types that fit
507     // in bytes32.
508 
509     struct Set {
510         // Storage of set values
511         bytes32[] _values;
512 
513         // Position of the value in the `values` array, plus 1 because index 0
514         // means a value is not in the set.
515         mapping (bytes32 => uint256) _indexes;
516     }
517 
518     /**
519      * @dev Add a value to a set. O(1).
520      *
521      * Returns true if the value was added to the set, that is if it was not
522      * already present.
523      */
524     function _add(Set storage set, bytes32 value) private returns (bool) {
525         if (!_contains(set, value)) {
526             set._values.push(value);
527             // The value is stored at length-1, but we add 1 to all indexes
528             // and use 0 as a sentinel value
529             set._indexes[value] = set._values.length;
530             return true;
531         } else {
532             return false;
533         }
534     }
535 
536     /**
537      * @dev Removes a value from a set. O(1).
538      *
539      * Returns true if the value was removed from the set, that is if it was
540      * present.
541      */
542     function _remove(Set storage set, bytes32 value) private returns (bool) {
543         // We read and store the value's index to prevent multiple reads from the same storage slot
544         uint256 valueIndex = set._indexes[value];
545 
546         if (valueIndex != 0) { // Equivalent to contains(set, value)
547             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
548             // the array, and then remove the last element (sometimes called as 'swap and pop').
549             // This modifies the order of the array, as noted in {at}.
550 
551             uint256 toDeleteIndex = valueIndex - 1;
552             uint256 lastIndex = set._values.length - 1;
553 
554             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
555             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
556 
557             bytes32 lastvalue = set._values[lastIndex];
558 
559             // Move the last value to the index where the value to delete is
560             set._values[toDeleteIndex] = lastvalue;
561             // Update the index for the moved value
562             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
563 
564             // Delete the slot where the moved value was stored
565             set._values.pop();
566 
567             // Delete the index for the deleted slot
568             delete set._indexes[value];
569 
570             return true;
571         } else {
572             return false;
573         }
574     }
575 
576     /**
577      * @dev Returns true if the value is in the set. O(1).
578      */
579     function _contains(Set storage set, bytes32 value) private view returns (bool) {
580         return set._indexes[value] != 0;
581     }
582 
583     /**
584      * @dev Returns the number of values on the set. O(1).
585      */
586     function _length(Set storage set) private view returns (uint256) {
587         return set._values.length;
588     }
589 
590    /**
591     * @dev Returns the value stored at position `index` in the set. O(1).
592     *
593     * Note that there are no guarantees on the ordering of values inside the
594     * array, and it may change when more values are added or removed.
595     *
596     * Requirements:
597     *
598     * - `index` must be strictly less than {length}.
599     */
600     function _at(Set storage set, uint256 index) private view returns (bytes32) {
601         require(set._values.length > index, "EnumerableSet: index out of bounds");
602         return set._values[index];
603     }
604 
605     // AddressSet
606 
607     struct AddressSet {
608         Set _inner;
609     }
610 
611     /**
612      * @dev Add a value to a set. O(1).
613      *
614      * Returns true if the value was added to the set, that is if it was not
615      * already present.
616      */
617     function add(AddressSet storage set, address value) internal returns (bool) {
618         return _add(set._inner, bytes32(uint256(value)));
619     }
620 
621     /**
622      * @dev Removes a value from a set. O(1).
623      *
624      * Returns true if the value was removed from the set, that is if it was
625      * present.
626      */
627     function remove(AddressSet storage set, address value) internal returns (bool) {
628         return _remove(set._inner, bytes32(uint256(value)));
629     }
630 
631     /**
632      * @dev Returns true if the value is in the set. O(1).
633      */
634     function contains(AddressSet storage set, address value) internal view returns (bool) {
635         return _contains(set._inner, bytes32(uint256(value)));
636     }
637 
638     /**
639      * @dev Returns the number of values in the set. O(1).
640      */
641     function length(AddressSet storage set) internal view returns (uint256) {
642         return _length(set._inner);
643     }
644 
645    /**
646     * @dev Returns the value stored at position `index` in the set. O(1).
647     *
648     * Note that there are no guarantees on the ordering of values inside the
649     * array, and it may change when more values are added or removed.
650     *
651     * Requirements:
652     *
653     * - `index` must be strictly less than {length}.
654     */
655     function at(AddressSet storage set, uint256 index) internal view returns (address) {
656         return address(uint256(_at(set._inner, index)));
657     }
658 
659 
660     // UintSet
661 
662     struct UintSet {
663         Set _inner;
664     }
665 
666     /**
667      * @dev Add a value to a set. O(1).
668      *
669      * Returns true if the value was added to the set, that is if it was not
670      * already present.
671      */
672     function add(UintSet storage set, uint256 value) internal returns (bool) {
673         return _add(set._inner, bytes32(value));
674     }
675 
676     /**
677      * @dev Removes a value from a set. O(1).
678      *
679      * Returns true if the value was removed from the set, that is if it was
680      * present.
681      */
682     function remove(UintSet storage set, uint256 value) internal returns (bool) {
683         return _remove(set._inner, bytes32(value));
684     }
685 
686     /**
687      * @dev Returns true if the value is in the set. O(1).
688      */
689     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
690         return _contains(set._inner, bytes32(value));
691     }
692 
693     /**
694      * @dev Returns the number of values on the set. O(1).
695      */
696     function length(UintSet storage set) internal view returns (uint256) {
697         return _length(set._inner);
698     }
699 
700    /**
701     * @dev Returns the value stored at position `index` in the set. O(1).
702     *
703     * Note that there are no guarantees on the ordering of values inside the
704     * array, and it may change when more values are added or removed.
705     *
706     * Requirements:
707     *
708     * - `index` must be strictly less than {length}.
709     */
710     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
711         return uint256(_at(set._inner, index));
712     }
713 }
714 
715 // File: @openzeppelin/contracts/GSN/Context.sol
716 
717 pragma solidity ^0.6.0;
718 
719 /*
720  * @dev Provides information about the current execution context, including the
721  * sender of the transaction and its data. While these are generally available
722  * via msg.sender and msg.data, they should not be accessed in such a direct
723  * manner, since when dealing with GSN meta-transactions the account sending and
724  * paying for execution may not be the actual sender (as far as an application
725  * is concerned).
726  *
727  * This contract is only required for intermediate, library-like contracts.
728  */
729 abstract contract Context {
730     function _msgSender() internal view virtual returns (address payable) {
731         return msg.sender;
732     }
733 
734     function _msgData() internal view virtual returns (bytes memory) {
735         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
736         return msg.data;
737     }
738 }
739 
740 // File: @openzeppelin/contracts/access/Ownable.sol
741 
742 
743 pragma solidity ^0.6.0;
744 
745 /**
746  * @dev Contract module which provides a basic access control mechanism, where
747  * there is an account (an owner) that can be granted exclusive access to
748  * specific functions.
749  *
750  * By default, the owner account will be the one that deploys the contract. This
751  * can later be changed with {transferOwnership}.
752  *
753  * This module is used through inheritance. It will make available the modifier
754  * `onlyOwner`, which can be applied to your functions to restrict their use to
755  * the owner.
756  */
757 contract Ownable is Context {
758     address private _owner;
759 
760     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
761 
762     /**
763      * @dev Initializes the contract setting the deployer as the initial owner.
764      */
765     constructor () internal {
766         address msgSender = _msgSender();
767         _owner = msgSender;
768         emit OwnershipTransferred(address(0), msgSender);
769     }
770 
771     /**
772      * @dev Returns the address of the current owner.
773      */
774     function owner() public view returns (address) {
775         return _owner;
776     }
777 
778     /**
779      * @dev Throws if called by any account other than the owner.
780      */
781     modifier onlyOwner() {
782         require(_owner == _msgSender(), "Ownable: caller is not the owner");
783         _;
784     }
785 
786     /**
787      * @dev Leaves the contract without owner. It will not be possible to call
788      * `onlyOwner` functions anymore. Can only be called by the current owner.
789      *
790      * NOTE: Renouncing ownership will leave the contract without an owner,
791      * thereby removing any functionality that is only available to the owner.
792      */
793     function renounceOwnership() public virtual onlyOwner {
794         emit OwnershipTransferred(_owner, address(0));
795         _owner = address(0);
796     }
797 
798     /**
799      * @dev Transfers ownership of the contract to a new account (`newOwner`).
800      * Can only be called by the current owner.
801      */
802     function transferOwnership(address newOwner) public virtual onlyOwner {
803         require(newOwner != address(0), "Ownable: new owner is the zero address");
804         emit OwnershipTransferred(_owner, newOwner);
805         _owner = newOwner;
806     }
807 }
808 
809 // File: contracts/IMigrator.sol
810 
811 pragma solidity 0.6.12;
812 
813 
814 
815 interface IMigrator {
816     // Perform LP token migration from legacy UniswapV2 to PowerSwap.
817     // Take the current LP token address and return the new LP token address.
818     // Migrator should have full access to the caller's LP token.
819     // Return the new LP token address.
820     //
821     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
822     // PowerSwap must mint EXACTLY the same amount of PowerSwap LP tokens or
823     // else something bad will happen. Traditional UniswapV2 does not
824     // do that so be careful!
825     function migrate(IERC20 token, uint8 poolType) external returns (IERC20);
826 }
827 
828 // File: contracts/Checkpoints.sol
829 
830 pragma solidity 0.6.12;
831 
832 contract Checkpoints {
833     /// @notice Official record of token balances for each account
834     mapping (address => uint96) internal balances;
835 
836     /// @notice A checkpoint for marking number of votes from a given block
837     struct Checkpoint {
838         uint32 fromBlock;
839         uint96 votes;
840     }
841 
842     /// @notice A record of votes checkpoints for each account, by index
843     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
844 
845     /// @notice The number of checkpoints for each account
846     mapping (address => uint32) public numCheckpoints;
847 
848     /// @notice An event thats emitted when a delegate account's vote balance changes
849     event CheckpointBalanceChanged(address indexed delegate, uint previousBalance, uint newBalance);
850 
851     constructor() public {
852 
853     }
854 
855     /**
856      * @notice Get the number of tokens held by the `account`
857      * @param account The address of the account to get the balance of
858      * @return The number of tokens held
859      */
860     function balanceOf(address account) external view returns (uint) {
861         return balances[account];
862     }
863 
864     /// @dev The exact copy from CVP token
865     /**
866      * @notice Gets the current votes balance for `account`
867      * @param account The address to get votes balance
868      * @return The number of current votes for `account`
869      */
870     function getCurrentVotes(address account) external view returns (uint96) {
871         uint32 nCheckpoints = numCheckpoints[account];
872         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
873     }
874 
875     /// @dev The exact copy from CVP token
876     /**
877      * @notice Determine the prior number of votes for an account as of a block number
878      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
879      * @param account The address of the account to check
880      * @param blockNumber The block number to get the vote balance at
881      * @return The number of votes the account had as of the given block
882      */
883     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
884         require(blockNumber < block.number, "Checkpoints::getPriorVotes: not yet determined");
885 
886         uint32 nCheckpoints = numCheckpoints[account];
887         if (nCheckpoints == 0) {
888             return 0;
889         }
890 
891         // First check most recent balance
892         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
893             return checkpoints[account][nCheckpoints - 1].votes;
894         }
895 
896         // Next check implicit zero balance
897         if (checkpoints[account][0].fromBlock > blockNumber) {
898             return 0;
899         }
900 
901         uint32 lower = 0;
902         uint32 upper = nCheckpoints - 1;
903         while (upper > lower) {
904             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
905             Checkpoint memory cp = checkpoints[account][center];
906             if (cp.fromBlock == blockNumber) {
907                 return cp.votes;
908             } else if (cp.fromBlock < blockNumber) {
909                 lower = center;
910             } else {
911                 upper = center - 1;
912             }
913         }
914         return checkpoints[account][lower].votes;
915     }
916 
917     /**
918      * @notice Writes checkpoint number, old and new balance to checkpoint for account address
919      * @param account The address to write balance
920      * @param balance New account balance
921      */
922     function _writeBalance(address account, uint96 balance) internal {
923         uint32 srcRepNum = numCheckpoints[account];
924         uint96 srcRepOld = srcRepNum > 0 ? checkpoints[account][srcRepNum - 1].votes : 0;
925         uint96 srcRepNew = safe96(balance, "Checkpoints::_writeBalance: vote amount overflow");
926         _writeCheckpoint(account, srcRepNum, srcRepOld, srcRepNew);
927     }
928 
929     /// @dev A copy from CVP token, only the event name changed
930     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
931       uint32 blockNumber = safe32(block.number, "Checkpoints::_writeCheckpoint: block number exceeds 32 bits");
932 
933       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
934           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
935       } else {
936           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
937           numCheckpoints[delegatee] = nCheckpoints + 1;
938       }
939 
940       emit CheckpointBalanceChanged(delegatee, oldVotes, newVotes);
941     }
942 
943     /// @dev The exact copy from CVP token
944     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
945         require(n < 2**32, errorMessage);
946         return uint32(n);
947     }
948 
949     /// @dev The exact copy from CVP token
950     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
951         require(n < 2**96, errorMessage);
952         return uint96(n);
953     }
954 
955     /// @dev The exact copy from CVP token
956     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
957         uint96 c = a + b;
958         require(c >= a, errorMessage);
959         return c;
960     }
961 
962     /// @dev The exact copy from CVP token
963     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
964         require(b <= a, errorMessage);
965         return a - b;
966     }
967 }
968 
969 // File: contracts/LPMining.sol
970 
971 pragma solidity 0.6.12;
972 
973 
974 
975 
976 
977 
978 
979 
980 
981 // Note that LPMining is ownable and the owner wields tremendous power. The ownership
982 // will be transferred to a governance smart contract
983 // and the community can show to govern itself.
984 contract LPMining is Ownable, Checkpoints {
985     using SafeMath for uint256;
986     using SafeERC20 for IERC20;
987 
988     // Info of each user.
989     struct UserInfo {
990         uint256 amount;     // How many LP tokens the user has provided.
991         uint256 rewardDebt; // Reward debt. See explanation below.
992         //
993         // We do some fancy math here. Basically, any point in time, the amount of CVPs
994         // entitled to a user but is pending to be distributed is:
995         //
996         //   pending reward = (user.amount * pool.accCvpPerShare) - user.rewardDebt
997         //
998         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
999         //   1. The pool's `accCvpPerShare` (and `lastRewardBlock`) gets updated.
1000         //   2. User receives the pending reward sent to his/her address.
1001         //   3. User's `amount` gets updated.
1002         //   4. User's `rewardDebt` gets updated.
1003     }
1004 
1005     // Info of each pool.
1006     struct PoolInfo {
1007         IERC20 lpToken;           // Address of LP token contract.
1008         uint256 allocPoint;       // How many allocation points assigned to this pool. CVPs to distribute per block.
1009         uint256 lastRewardBlock;  // Last block number that CVPs distribution occurs.
1010         uint256 accCvpPerShare;   // Accumulated CVPs per share, times 1e12. See below.
1011         bool votesEnabled;        // Pool enabled to write votes
1012         uint8 poolType;           // Pool type (1 For Uniswap, 2 for Balancer)
1013     }
1014 
1015     // The CVP TOKEN!
1016     IERC20 public cvp;
1017     // Reservoir address.
1018     address public reservoir;
1019     // CVP tokens reward per block.
1020     uint256 public cvpPerBlock;
1021     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1022     IMigrator public migrator;
1023 
1024     // Info of each pool.
1025     PoolInfo[] public poolInfo;
1026     // Pid of each pool by its address
1027     mapping(address => uint256) public poolPidByAddress;
1028     // Info of each user that stakes LP tokens.
1029     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1030     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1031     uint256 public totalAllocPoint = 0;
1032     // The block number when CVP mining starts.
1033     uint256 public startBlock;
1034 
1035     event AddLpToken(address indexed lpToken, uint256 indexed pid, uint256 allocPoint);
1036     event SetLpToken(address indexed lpToken, uint256 indexed pid, uint256 allocPoint);
1037     event SetMigrator(address indexed migrator);
1038     event SetCvpPerBlock(uint256 cvpPerBlock);
1039     event MigrateLpToken(address indexed oldLpToken, address indexed newLpToken, uint256 indexed pid);
1040 
1041     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1042     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1043     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1044     event CheckpointPoolVotes(address indexed user, uint256 indexed pid, uint256 votes, uint256 price);
1045     event CheckpointTotalVotes(address indexed user, uint256 votes);
1046 
1047     constructor(
1048         IERC20 _cvp,
1049         address _reservoir,
1050         uint256 _cvpPerBlock,
1051         uint256 _startBlock
1052     ) public {
1053         cvp = _cvp;
1054         reservoir = _reservoir;
1055         cvpPerBlock = _cvpPerBlock;
1056         startBlock = _startBlock;
1057 
1058         emit SetCvpPerBlock(_cvpPerBlock);
1059     }
1060 
1061     function poolLength() external view returns (uint256) {
1062         return poolInfo.length;
1063     }
1064 
1065     // Add a new lp to the pool. Can only be called by the owner.
1066     function add(uint256 _allocPoint, IERC20 _lpToken, uint8 _poolType, bool _votesEnabled, bool _withUpdate) public onlyOwner {
1067         require(!isLpTokenAdded(_lpToken), "add: Lp token already added");
1068 
1069         if (_withUpdate) {
1070             massUpdatePools();
1071         }
1072         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1073         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1074 
1075         uint256 pid = poolInfo.length;
1076         poolInfo.push(PoolInfo({
1077             lpToken: _lpToken,
1078             allocPoint: _allocPoint,
1079             lastRewardBlock: lastRewardBlock,
1080             accCvpPerShare: 0,
1081             votesEnabled: _votesEnabled,
1082             poolType: _poolType
1083         }));
1084         poolPidByAddress[address(_lpToken)] = pid;
1085 
1086         emit AddLpToken(address(_lpToken), pid, _allocPoint);
1087     }
1088 
1089     // Update the given pool's CVP allocation point. Can only be called by the owner.
1090     function set(uint256 _pid, uint256 _allocPoint, uint8 _poolType, bool _votesEnabled, bool _withUpdate) public onlyOwner {
1091         if (_withUpdate) {
1092             massUpdatePools();
1093         }
1094         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1095         poolInfo[_pid].allocPoint = _allocPoint;
1096         poolInfo[_pid].votesEnabled = _votesEnabled;
1097         poolInfo[_pid].poolType = _poolType;
1098 
1099         emit SetLpToken(address(poolInfo[_pid].lpToken), _pid, _allocPoint);
1100     }
1101 
1102     // Set the migrator contract. Can only be called by the owner.
1103     function setMigrator(IMigrator _migrator) public onlyOwner {
1104         migrator = _migrator;
1105 
1106         emit SetMigrator(address(_migrator));
1107     }
1108 
1109     // Set CVP reward per block. Can only be called by the owner.
1110     function setCvpPerBlock(uint256 _cvpPerBlock) public onlyOwner {
1111         cvpPerBlock = _cvpPerBlock;
1112 
1113         emit SetCvpPerBlock(_cvpPerBlock);
1114     }
1115 
1116     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1117     function migrate(uint256 _pid) public {
1118         require(address(migrator) != address(0), "migrate: no migrator");
1119         PoolInfo storage pool = poolInfo[_pid];
1120         IERC20 lpToken = pool.lpToken;
1121         uint256 bal = lpToken.balanceOf(address(this));
1122         lpToken.safeApprove(address(migrator), bal);
1123         IERC20 newLpToken = migrator.migrate(lpToken, pool.poolType);
1124         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1125         pool.lpToken = newLpToken;
1126 
1127         delete poolPidByAddress[address(lpToken)];
1128         poolPidByAddress[address(newLpToken)] = _pid;
1129 
1130         emit MigrateLpToken(address(lpToken), address(newLpToken), _pid);
1131     }
1132 
1133     // Return reward multiplier over the given _from to _to block.
1134     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1135         return _to.sub(_from);
1136     }
1137 
1138     // View function to see pending CVPs on frontend.
1139     function pendingCvp(uint256 _pid, address _user) external view returns (uint256) {
1140         PoolInfo storage pool = poolInfo[_pid];
1141         UserInfo storage user = userInfo[_pid][_user];
1142         uint256 accCvpPerShare = pool.accCvpPerShare;
1143         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1144         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1145             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1146             uint256 cvpReward = multiplier.mul(cvpPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1147             accCvpPerShare = accCvpPerShare.add(cvpReward.mul(1e12).div(lpSupply));
1148         }
1149         return user.amount.mul(accCvpPerShare).div(1e12).sub(user.rewardDebt);
1150     }
1151 
1152     // Return bool - is Lp Token added or not
1153     function isLpTokenAdded(IERC20 _lpToken) public view returns (bool) {
1154         uint256 pid = poolPidByAddress[address(_lpToken)];
1155         return poolInfo.length > pid && address(poolInfo[pid].lpToken) == address(_lpToken);
1156     }
1157 
1158     // Update reward variables for all pools. Be careful of gas spending!
1159     function massUpdatePools() public {
1160         uint256 length = poolInfo.length;
1161         for (uint256 pid = 0; pid < length; ++pid) {
1162             updatePool(pid);
1163         }
1164     }
1165 
1166     // Update reward variables of the given pool to be up-to-date.
1167     function updatePool(uint256 _pid) public {
1168         PoolInfo storage pool = poolInfo[_pid];
1169         if (block.number <= pool.lastRewardBlock) {
1170             return;
1171         }
1172         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1173         if (lpSupply == 0) {
1174             pool.lastRewardBlock = block.number;
1175             return;
1176         }
1177         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1178         uint256 cvpReward = multiplier.mul(cvpPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1179         cvp.transferFrom(reservoir, address(this), cvpReward);
1180         pool.accCvpPerShare = pool.accCvpPerShare.add(cvpReward.mul(1e12).div(lpSupply));
1181         pool.lastRewardBlock = block.number;
1182     }
1183 
1184     // Deposit LP tokens to LPMining for CVP allocation.
1185     function deposit(uint256 _pid, uint256 _amount) public {
1186         PoolInfo storage pool = poolInfo[_pid];
1187         UserInfo storage user = userInfo[_pid][msg.sender];
1188         updatePool(_pid);
1189         if (user.amount > 0) {
1190             uint256 pending = user.amount.mul(pool.accCvpPerShare).div(1e12).sub(user.rewardDebt);
1191             if(pending > 0) {
1192                 safeCvpTransfer(msg.sender, pending);
1193             }
1194         }
1195         if(_amount > 0) {
1196             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1197             user.amount = user.amount.add(_amount);
1198         }
1199         user.rewardDebt = user.amount.mul(pool.accCvpPerShare).div(1e12);
1200         emit Deposit(msg.sender, _pid, _amount);
1201 
1202         checkpointVotes(msg.sender);
1203     }
1204 
1205     // Withdraw LP tokens from LPMining.
1206     function withdraw(uint256 _pid, uint256 _amount) public {
1207         PoolInfo storage pool = poolInfo[_pid];
1208         UserInfo storage user = userInfo[_pid][msg.sender];
1209         require(user.amount >= _amount, "withdraw: not good");
1210         updatePool(_pid);
1211         uint256 pending = user.amount.mul(pool.accCvpPerShare).div(1e12).sub(user.rewardDebt);
1212         if(pending > 0) {
1213             safeCvpTransfer(msg.sender, pending);
1214         }
1215         if(_amount > 0) {
1216             user.amount = user.amount.sub(_amount);
1217             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1218         }
1219         user.rewardDebt = user.amount.mul(pool.accCvpPerShare).div(1e12);
1220         emit Withdraw(msg.sender, _pid, _amount);
1221 
1222         checkpointVotes(msg.sender);
1223     }
1224 
1225     // Withdraw without caring about rewards. EMERGENCY ONLY.
1226     function emergencyWithdraw(uint256 _pid) public {
1227         PoolInfo storage pool = poolInfo[_pid];
1228         UserInfo storage user = userInfo[_pid][msg.sender];
1229         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1230         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1231         user.amount = 0;
1232         user.rewardDebt = 0;
1233 
1234         checkpointVotes(msg.sender);
1235     }
1236 
1237     // Write votes at current block
1238     function checkpointVotes(address _user) public {
1239         uint256 length = poolInfo.length;
1240 
1241         uint256 totalVotesBalance = 0;
1242         for (uint256 pid = 0; pid < length; ++pid) {
1243             PoolInfo storage pool = poolInfo[pid];
1244 
1245             uint256 userLpTokenBalance = userInfo[pid][_user].amount;
1246             if (userLpTokenBalance == 0 || !pool.votesEnabled) {
1247                 continue;
1248             }
1249             uint256 lpTokenTotalSupply = pool.lpToken.totalSupply();
1250             if (lpTokenTotalSupply == 0) {
1251                 continue;
1252             }
1253 
1254             uint256 lpCvpBalance = cvp.balanceOf(address(pool.lpToken));
1255             uint256 lpCvpPrice = lpCvpBalance.mul(1e12).div(lpTokenTotalSupply);
1256             uint256 lpVotesBalance = userLpTokenBalance.mul(lpCvpPrice).div(1e12);
1257 
1258             totalVotesBalance = totalVotesBalance.add(lpVotesBalance);
1259             emit CheckpointPoolVotes(_user, pid, lpVotesBalance, lpCvpPrice);
1260         }
1261 
1262         emit CheckpointTotalVotes(_user, totalVotesBalance);
1263 
1264         _writeBalance(_user, safe96(totalVotesBalance, "LPMining::checkpointVotes: Amount overflow"));
1265     }
1266 
1267     // Safe cvp transfer function, just in case if rounding error causes pool to not have enough CVPs.
1268     function safeCvpTransfer(address _to, uint256 _amount) internal {
1269         uint256 cvpBal = cvp.balanceOf(address(this));
1270         if (_amount > cvpBal) {
1271             cvp.transfer(_to, cvpBal);
1272         } else {
1273             cvp.transfer(_to, _amount);
1274         }
1275     }
1276 }