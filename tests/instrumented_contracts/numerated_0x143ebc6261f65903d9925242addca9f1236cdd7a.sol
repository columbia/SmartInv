1 /* website: padthai.finance
2 **
3 **    ▄███████▄    ▄████████ ████████▄      ███        ▄█    █▄       ▄████████  ▄█
4 **   ███    ███   ███    ███ ███   ▀███ ▀█████████▄   ███    ███     ███    ███ ███
5 **   ███    ███   ███    ███ ███    ███    ▀███▀▀██   ███    ███     ███    ███ ███▌
6 **   ███    ███   ███    ███ ███    ███     ███   ▀  ▄███▄▄▄▄███▄▄   ███    ███ ███▌
7 ** ▀█████████▀  ▀███████████ ███    ███     ███     ▀▀███▀▀▀▀███▀  ▀███████████ ███▌
8 **   ███          ███    ███ ███    ███     ███       ███    ███     ███    ███ ███
9 **   ███          ███    ███ ███   ▄███     ███       ███    ███     ███    ███ ███
10 **  ▄████▀        ███    █▀  ████████▀     ▄████▀     ███    █▀      ███    █▀  █▀
11 **
12  */
13 
14 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
15 
16 
17 pragma solidity ^0.6.0;
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 // File: @openzeppelin/contracts/math/SafeMath.sol
94 
95 
96 
97 pragma solidity ^0.6.0;
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations with added overflow
101  * checks.
102  *
103  * Arithmetic operations in Solidity wrap on overflow. This can easily result
104  * in bugs, because programmers usually assume that an overflow raises an
105  * error, which is the standard behavior in high level programming languages.
106  * `SafeMath` restores this intuition by reverting the transaction when an
107  * operation overflows.
108  *
109  * Using this library instead of the unchecked operations eliminates an entire
110  * class of bugs, so it's recommended to use it always.
111  */
112 library SafeMath {
113     /**
114      * @dev Returns the addition of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `+` operator.
118      *
119      * Requirements:
120      *
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the multiplication of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `*` operator.
166      *
167      * Requirements:
168      *
169      * - Multiplication cannot overflow.
170      */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts with custom message when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/utils/Address.sol
256 
257 
258 pragma solidity ^0.6.2;
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
283         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
284         // for accounts without code, i.e. `keccak256('')`
285         bytes32 codehash;
286         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
287         // solhint-disable-next-line no-inline-assembly
288         assembly { codehash := extcodehash(account) }
289         return (codehash != accountHash && codehash != 0x0);
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
312         (bool success, ) = recipient.call{ value: amount }("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain`call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335       return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
345         return _functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
370         require(address(this).balance >= value, "Address: insufficient balance for call");
371         return _functionCallWithValue(target, data, value, errorMessage);
372     }
373 
374     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
375         require(isContract(target), "Address: call to non-contract");
376 
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 // solhint-disable-next-line no-inline-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
399 
400 
401 pragma solidity ^0.6.0;
402 
403 
404 
405 
406 /**
407  * @title SafeERC20
408  * @dev Wrappers around ERC20 operations that throw on failure (when the token
409  * contract returns false). Tokens that return no value (and instead revert or
410  * throw on failure) are also supported, non-reverting calls are assumed to be
411  * successful.
412  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
413  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
414  */
415 library SafeERC20 {
416     using SafeMath for uint256;
417     using Address for address;
418 
419     function safeTransfer(IERC20 token, address to, uint256 value) internal {
420         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
421     }
422 
423     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
424         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
425     }
426 
427     /**
428      * @dev Deprecated. This function has issues similar to the ones found in
429      * {IERC20-approve}, and its usage is discouraged.
430      *
431      * Whenever possible, use {safeIncreaseAllowance} and
432      * {safeDecreaseAllowance} instead.
433      */
434     function safeApprove(IERC20 token, address spender, uint256 value) internal {
435         // safeApprove should only be called when setting an initial allowance,
436         // or when resetting it to zero. To increase and decrease it, use
437         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
438         // solhint-disable-next-line max-line-length
439         require((value == 0) || (token.allowance(address(this), spender) == 0),
440             "SafeERC20: approve from non-zero to non-zero allowance"
441         );
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
443     }
444 
445     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
446         uint256 newAllowance = token.allowance(address(this), spender).add(value);
447         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
448     }
449 
450     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
451         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
452         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
453     }
454 
455     /**
456      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
457      * on the return value: the return value is optional (but if data is returned, it must not be false).
458      * @param token The token targeted by the call.
459      * @param data The call data (encoded using abi.encode or one of its variants).
460      */
461     function _callOptionalReturn(IERC20 token, bytes memory data) private {
462         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
463         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
464         // the target address contains contract code and also asserts for success in the low-level call.
465 
466         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
467         if (returndata.length > 0) { // Return data is optional
468             // solhint-disable-next-line max-line-length
469             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
470         }
471     }
472 }
473 
474 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
475 
476 
477 pragma solidity ^0.6.0;
478 
479 /**
480  * @dev Library for managing
481  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
482  * types.
483  *
484  * Sets have the following properties:
485  *
486  * - Elements are added, removed, and checked for existence in constant time
487  * (O(1)).
488  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
489  *
490  * ```
491  * contract Example {
492  *     // Add the library methods
493  *     using EnumerableSet for EnumerableSet.AddressSet;
494  *
495  *     // Declare a set state variable
496  *     EnumerableSet.AddressSet private mySet;
497  * }
498  * ```
499  *
500  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
501  * (`UintSet`) are supported.
502  */
503 library EnumerableSet {
504     // To implement this library for multiple types with as little code
505     // repetition as possible, we write it in terms of a generic Set type with
506     // bytes32 values.
507     // The Set implementation uses private functions, and user-facing
508     // implementations (such as AddressSet) are just wrappers around the
509     // underlying Set.
510     // This means that we can only create new EnumerableSets for types that fit
511     // in bytes32.
512 
513     struct Set {
514         // Storage of set values
515         bytes32[] _values;
516 
517         // Position of the value in the `values` array, plus 1 because index 0
518         // means a value is not in the set.
519         mapping (bytes32 => uint256) _indexes;
520     }
521 
522     /**
523      * @dev Add a value to a set. O(1).
524      *
525      * Returns true if the value was added to the set, that is if it was not
526      * already present.
527      */
528     function _add(Set storage set, bytes32 value) private returns (bool) {
529         if (!_contains(set, value)) {
530             set._values.push(value);
531             // The value is stored at length-1, but we add 1 to all indexes
532             // and use 0 as a sentinel value
533             set._indexes[value] = set._values.length;
534             return true;
535         } else {
536             return false;
537         }
538     }
539 
540     /**
541      * @dev Removes a value from a set. O(1).
542      *
543      * Returns true if the value was removed from the set, that is if it was
544      * present.
545      */
546     function _remove(Set storage set, bytes32 value) private returns (bool) {
547         // We read and store the value's index to prevent multiple reads from the same storage slot
548         uint256 valueIndex = set._indexes[value];
549 
550         if (valueIndex != 0) { // Equivalent to contains(set, value)
551             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
552             // the array, and then remove the last element (sometimes called as 'swap and pop').
553             // This modifies the order of the array, as noted in {at}.
554 
555             uint256 toDeleteIndex = valueIndex - 1;
556             uint256 lastIndex = set._values.length - 1;
557 
558             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
559             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
560 
561             bytes32 lastvalue = set._values[lastIndex];
562 
563             // Move the last value to the index where the value to delete is
564             set._values[toDeleteIndex] = lastvalue;
565             // Update the index for the moved value
566             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
567 
568             // Delete the slot where the moved value was stored
569             set._values.pop();
570 
571             // Delete the index for the deleted slot
572             delete set._indexes[value];
573 
574             return true;
575         } else {
576             return false;
577         }
578     }
579 
580     /**
581      * @dev Returns true if the value is in the set. O(1).
582      */
583     function _contains(Set storage set, bytes32 value) private view returns (bool) {
584         return set._indexes[value] != 0;
585     }
586 
587     /**
588      * @dev Returns the number of values on the set. O(1).
589      */
590     function _length(Set storage set) private view returns (uint256) {
591         return set._values.length;
592     }
593 
594    /**
595     * @dev Returns the value stored at position `index` in the set. O(1).
596     *
597     * Note that there are no guarantees on the ordering of values inside the
598     * array, and it may change when more values are added or removed.
599     *
600     * Requirements:
601     *
602     * - `index` must be strictly less than {length}.
603     */
604     function _at(Set storage set, uint256 index) private view returns (bytes32) {
605         require(set._values.length > index, "EnumerableSet: index out of bounds");
606         return set._values[index];
607     }
608 
609     // AddressSet
610 
611     struct AddressSet {
612         Set _inner;
613     }
614 
615     /**
616      * @dev Add a value to a set. O(1).
617      *
618      * Returns true if the value was added to the set, that is if it was not
619      * already present.
620      */
621     function add(AddressSet storage set, address value) internal returns (bool) {
622         return _add(set._inner, bytes32(uint256(value)));
623     }
624 
625     /**
626      * @dev Removes a value from a set. O(1).
627      *
628      * Returns true if the value was removed from the set, that is if it was
629      * present.
630      */
631     function remove(AddressSet storage set, address value) internal returns (bool) {
632         return _remove(set._inner, bytes32(uint256(value)));
633     }
634 
635     /**
636      * @dev Returns true if the value is in the set. O(1).
637      */
638     function contains(AddressSet storage set, address value) internal view returns (bool) {
639         return _contains(set._inner, bytes32(uint256(value)));
640     }
641 
642     /**
643      * @dev Returns the number of values in the set. O(1).
644      */
645     function length(AddressSet storage set) internal view returns (uint256) {
646         return _length(set._inner);
647     }
648 
649    /**
650     * @dev Returns the value stored at position `index` in the set. O(1).
651     *
652     * Note that there are no guarantees on the ordering of values inside the
653     * array, and it may change when more values are added or removed.
654     *
655     * Requirements:
656     *
657     * - `index` must be strictly less than {length}.
658     */
659     function at(AddressSet storage set, uint256 index) internal view returns (address) {
660         return address(uint256(_at(set._inner, index)));
661     }
662 
663 
664     // UintSet
665 
666     struct UintSet {
667         Set _inner;
668     }
669 
670     /**
671      * @dev Add a value to a set. O(1).
672      *
673      * Returns true if the value was added to the set, that is if it was not
674      * already present.
675      */
676     function add(UintSet storage set, uint256 value) internal returns (bool) {
677         return _add(set._inner, bytes32(value));
678     }
679 
680     /**
681      * @dev Removes a value from a set. O(1).
682      *
683      * Returns true if the value was removed from the set, that is if it was
684      * present.
685      */
686     function remove(UintSet storage set, uint256 value) internal returns (bool) {
687         return _remove(set._inner, bytes32(value));
688     }
689 
690     /**
691      * @dev Returns true if the value is in the set. O(1).
692      */
693     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
694         return _contains(set._inner, bytes32(value));
695     }
696 
697     /**
698      * @dev Returns the number of values on the set. O(1).
699      */
700     function length(UintSet storage set) internal view returns (uint256) {
701         return _length(set._inner);
702     }
703 
704    /**
705     * @dev Returns the value stored at position `index` in the set. O(1).
706     *
707     * Note that there are no guarantees on the ordering of values inside the
708     * array, and it may change when more values are added or removed.
709     *
710     * Requirements:
711     *
712     * - `index` must be strictly less than {length}.
713     */
714     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
715         return uint256(_at(set._inner, index));
716     }
717 }
718 
719 // File: @openzeppelin/contracts/GSN/Context.sol
720 
721 
722 pragma solidity ^0.6.0;
723 
724 /*
725  * @dev Provides information about the current execution context, including the
726  * sender of the transaction and its data. While these are generally available
727  * via msg.sender and msg.data, they should not be accessed in such a direct
728  * manner, since when dealing with GSN meta-transactions the account sending and
729  * paying for execution may not be the actual sender (as far as an application
730  * is concerned).
731  *
732  * This contract is only required for intermediate, library-like contracts.
733  */
734 abstract contract Context {
735     function _msgSender() internal view virtual returns (address payable) {
736         return msg.sender;
737     }
738 
739     function _msgData() internal view virtual returns (bytes memory) {
740         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
741         return msg.data;
742     }
743 }
744 
745 // File: @openzeppelin/contracts/access/Ownable.sol
746 
747 
748 pragma solidity ^0.6.0;
749 
750 /**
751  * @dev Contract module which provides a basic access control mechanism, where
752  * there is an account (an owner) that can be granted exclusive access to
753  * specific functions.
754  *
755  * By default, the owner account will be the one that deploys the contract. This
756  * can later be changed with {transferOwnership}.
757  *
758  * This module is used through inheritance. It will make available the modifier
759  * `onlyOwner`, which can be applied to your functions to restrict their use to
760  * the owner.
761  */
762 contract Ownable is Context {
763     address private _owner;
764 
765     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
766 
767     /**
768      * @dev Initializes the contract setting the deployer as the initial owner.
769      */
770     constructor () internal {
771         address msgSender = _msgSender();
772         _owner = msgSender;
773         emit OwnershipTransferred(address(0), msgSender);
774     }
775 
776     /**
777      * @dev Returns the address of the current owner.
778      */
779     function owner() public view returns (address) {
780         return _owner;
781     }
782 
783     /**
784      * @dev Throws if called by any account other than the owner.
785      */
786     modifier onlyOwner() {
787         require(_owner == _msgSender(), "Ownable: caller is not the owner");
788         _;
789     }
790 
791     /**
792      * @dev Leaves the contract without owner. It will not be possible to call
793      * `onlyOwner` functions anymore. Can only be called by the current owner.
794      *
795      * NOTE: Renouncing ownership will leave the contract without an owner,
796      * thereby removing any functionality that is only available to the owner.
797      */
798     function renounceOwnership() public virtual onlyOwner {
799         emit OwnershipTransferred(_owner, address(0));
800         _owner = address(0);
801     }
802 
803     /**
804      * @dev Transfers ownership of the contract to a new account (`newOwner`).
805      * Can only be called by the current owner.
806      */
807     function transferOwnership(address newOwner) public virtual onlyOwner {
808         require(newOwner != address(0), "Ownable: new owner is the zero address");
809         emit OwnershipTransferred(_owner, newOwner);
810         _owner = newOwner;
811     }
812 }
813 
814 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
815 
816 
817 pragma solidity ^0.6.0;
818 
819 
820 
821 
822 
823 /**
824  * @dev Implementation of the {IERC20} interface.
825  *
826  * This implementation is agnostic to the way tokens are created. This means
827  * that a supply mechanism has to be added in a derived contract using {_mint}.
828  * For a generic mechanism see {ERC20PresetMinterPauser}.
829  *
830  * TIP: For a detailed writeup see our guide
831  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
832  * to implement supply mechanisms].
833  *
834  * We have followed general OpenZeppelin guidelines: functions revert instead
835  * of returning `false` on failure. This behavior is nonetheless conventional
836  * and does not conflict with the expectations of ERC20 applications.
837  *
838  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
839  * This allows applications to reconstruct the allowance for all accounts just
840  * by listening to said events. Other implementations of the EIP may not emit
841  * these events, as it isn't required by the specification.
842  *
843  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
844  * functions have been added to mitigate the well-known issues around setting
845  * allowances. See {IERC20-approve}.
846  */
847 contract ERC20 is Context, IERC20 {
848     using SafeMath for uint256;
849     using Address for address;
850 
851     mapping (address => uint256) private _balances;
852 
853     mapping (address => mapping (address => uint256)) private _allowances;
854 
855     uint256 private _totalSupply;
856 
857     string private _name;
858     string private _symbol;
859     uint8 private _decimals;
860 
861     /**
862      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
863      * a default value of 18.
864      *
865      * To select a different value for {decimals}, use {_setupDecimals}.
866      *
867      * All three of these values are immutable: they can only be set once during
868      * construction.
869      */
870     constructor (string memory name, string memory symbol) public {
871         _name = name;
872         _symbol = symbol;
873         _decimals = 18;
874     }
875 
876     /**
877      * @dev Returns the name of the token.
878      */
879     function name() public view returns (string memory) {
880         return _name;
881     }
882 
883     /**
884      * @dev Returns the symbol of the token, usually a shorter version of the
885      * name.
886      */
887     function symbol() public view returns (string memory) {
888         return _symbol;
889     }
890 
891     /**
892      * @dev Returns the number of decimals used to get its user representation.
893      * For example, if `decimals` equals `2`, a balance of `505` tokens should
894      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
895      *
896      * Tokens usually opt for a value of 18, imitating the relationship between
897      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
898      * called.
899      *
900      * NOTE: This information is only used for _display_ purposes: it in
901      * no way affects any of the arithmetic of the contract, including
902      * {IERC20-balanceOf} and {IERC20-transfer}.
903      */
904     function decimals() public view returns (uint8) {
905         return _decimals;
906     }
907 
908     /**
909      * @dev See {IERC20-totalSupply}.
910      */
911     function totalSupply() public view override returns (uint256) {
912         return _totalSupply;
913     }
914 
915     /**
916      * @dev See {IERC20-balanceOf}.
917      */
918     function balanceOf(address account) public view override returns (uint256) {
919         return _balances[account];
920     }
921 
922     /**
923      * @dev See {IERC20-transfer}.
924      *
925      * Requirements:
926      *
927      * - `recipient` cannot be the zero address.
928      * - the caller must have a balance of at least `amount`.
929      */
930     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
931         _transfer(_msgSender(), recipient, amount);
932         return true;
933     }
934 
935     /**
936      * @dev See {IERC20-allowance}.
937      */
938     function allowance(address owner, address spender) public view virtual override returns (uint256) {
939         return _allowances[owner][spender];
940     }
941 
942     /**
943      * @dev See {IERC20-approve}.
944      *
945      * Requirements:
946      *
947      * - `spender` cannot be the zero address.
948      */
949     function approve(address spender, uint256 amount) public virtual override returns (bool) {
950         _approve(_msgSender(), spender, amount);
951         return true;
952     }
953 
954     /**
955      * @dev See {IERC20-transferFrom}.
956      *
957      * Emits an {Approval} event indicating the updated allowance. This is not
958      * required by the EIP. See the note at the beginning of {ERC20};
959      *
960      * Requirements:
961      * - `sender` and `recipient` cannot be the zero address.
962      * - `sender` must have a balance of at least `amount`.
963      * - the caller must have allowance for ``sender``'s tokens of at least
964      * `amount`.
965      */
966     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
967         _transfer(sender, recipient, amount);
968         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
969         return true;
970     }
971 
972     /**
973      * @dev Atomically increases the allowance granted to `spender` by the caller.
974      *
975      * This is an alternative to {approve} that can be used as a mitigation for
976      * problems described in {IERC20-approve}.
977      *
978      * Emits an {Approval} event indicating the updated allowance.
979      *
980      * Requirements:
981      *
982      * - `spender` cannot be the zero address.
983      */
984     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
985         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
986         return true;
987     }
988 
989     /**
990      * @dev Atomically decreases the allowance granted to `spender` by the caller.
991      *
992      * This is an alternative to {approve} that can be used as a mitigation for
993      * problems described in {IERC20-approve}.
994      *
995      * Emits an {Approval} event indicating the updated allowance.
996      *
997      * Requirements:
998      *
999      * - `spender` cannot be the zero address.
1000      * - `spender` must have allowance for the caller of at least
1001      * `subtractedValue`.
1002      */
1003     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1004         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1005         return true;
1006     }
1007 
1008     /**
1009      * @dev Moves tokens `amount` from `sender` to `recipient`.
1010      *
1011      * This is internal function is equivalent to {transfer}, and can be used to
1012      * e.g. implement automatic token fees, slashing mechanisms, etc.
1013      *
1014      * Emits a {Transfer} event.
1015      *
1016      * Requirements:
1017      *
1018      * - `sender` cannot be the zero address.
1019      * - `recipient` cannot be the zero address.
1020      * - `sender` must have a balance of at least `amount`.
1021      */
1022     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1023         require(sender != address(0), "ERC20: transfer from the zero address");
1024         require(recipient != address(0), "ERC20: transfer to the zero address");
1025 
1026         _beforeTokenTransfer(sender, recipient, amount);
1027 
1028         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1029         _balances[recipient] = _balances[recipient].add(amount);
1030         emit Transfer(sender, recipient, amount);
1031     }
1032 
1033     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1034      * the total supply.
1035      *
1036      * Emits a {Transfer} event with `from` set to the zero address.
1037      *
1038      * Requirements
1039      *
1040      * - `to` cannot be the zero address.
1041      */
1042     function _mint(address account, uint256 amount) internal virtual {
1043         require(account != address(0), "ERC20: mint to the zero address");
1044 
1045         _beforeTokenTransfer(address(0), account, amount);
1046 
1047         _totalSupply = _totalSupply.add(amount);
1048         _balances[account] = _balances[account].add(amount);
1049         emit Transfer(address(0), account, amount);
1050     }
1051 
1052     /**
1053      * @dev Destroys `amount` tokens from `account`, reducing the
1054      * total supply.
1055      *
1056      * Emits a {Transfer} event with `to` set to the zero address.
1057      *
1058      * Requirements
1059      *
1060      * - `account` cannot be the zero address.
1061      * - `account` must have at least `amount` tokens.
1062      */
1063     function _burn(address account, uint256 amount) internal virtual {
1064         require(account != address(0), "ERC20: burn from the zero address");
1065 
1066         _beforeTokenTransfer(account, address(0), amount);
1067 
1068         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1069         _totalSupply = _totalSupply.sub(amount);
1070         emit Transfer(account, address(0), amount);
1071     }
1072 
1073     /**
1074      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1075      *
1076      * This is internal function is equivalent to `approve`, and can be used to
1077      * e.g. set automatic allowances for certain subsystems, etc.
1078      *
1079      * Emits an {Approval} event.
1080      *
1081      * Requirements:
1082      *
1083      * - `owner` cannot be the zero address.
1084      * - `spender` cannot be the zero address.
1085      */
1086     function _approve(address owner, address spender, uint256 amount) internal virtual {
1087         require(owner != address(0), "ERC20: approve from the zero address");
1088         require(spender != address(0), "ERC20: approve to the zero address");
1089 
1090         _allowances[owner][spender] = amount;
1091         emit Approval(owner, spender, amount);
1092     }
1093 
1094     /**
1095      * @dev Sets {decimals} to a value other than the default one of 18.
1096      *
1097      * WARNING: This function should only be called from the constructor. Most
1098      * applications that interact with token contracts will not expect
1099      * {decimals} to ever change, and may work incorrectly if it does.
1100      */
1101     function _setupDecimals(uint8 decimals_) internal {
1102         _decimals = decimals_;
1103     }
1104 
1105     /**
1106      * @dev Hook that is called before any transfer of tokens. This includes
1107      * minting and burning.
1108      *
1109      * Calling conditions:
1110      *
1111      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1112      * will be to transferred to `to`.
1113      * - when `from` is zero, `amount` tokens will be minted for `to`.
1114      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1115      * - `from` and `to` are never both zero.
1116      *
1117      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1118      */
1119     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1120 }
1121 
1122 // File: contracts/PadThaiToken.sol
1123 
1124 /* website: padthai.finance
1125 **
1126 **    ▄███████▄    ▄████████ ████████▄      ███        ▄█    █▄       ▄████████  ▄█
1127 **   ███    ███   ███    ███ ███   ▀███ ▀█████████▄   ███    ███     ███    ███ ███
1128 **   ███    ███   ███    ███ ███    ███    ▀███▀▀██   ███    ███     ███    ███ ███▌
1129 **   ███    ███   ███    ███ ███    ███     ███   ▀  ▄███▄▄▄▄███▄▄   ███    ███ ███▌
1130 ** ▀█████████▀  ▀███████████ ███    ███     ███     ▀▀███▀▀▀▀███▀  ▀███████████ ███▌
1131 **   ███          ███    ███ ███    ███     ███       ███    ███     ███    ███ ███
1132 **   ███          ███    ███ ███   ▄███     ███       ███    ███     ███    ███ ███
1133 **  ▄████▀        ███    █▀  ████████▀     ▄████▀     ███    █▀      ███    █▀  █▀
1134 **
1135  */
1136 pragma solidity 0.6.12;
1137 
1138 
1139 
1140 contract PadThaiToken is ERC20("padthai.finance", "PADTHAI"), Ownable {
1141     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (PadThaiChef).
1142     function mint(address _to, uint256 _amount) public onlyOwner {
1143         _mint(_to, _amount);
1144     }
1145 }
1146 
1147 // File: contracts/PadThaiChef.sol
1148 
1149 
1150 pragma solidity 0.6.12;
1151 
1152 
1153 
1154 
1155 
1156 
1157 
1158 // PadThaiChef is the master of Padthai. He can make Padthai and he is a fair guy.
1159 //
1160 // Note that it's ownable and the owner wields tremendous power. The ownership
1161 // will be transferred to a governance smart contract once PADTHAI is sufficiently
1162 // distributed and the community can show to govern itself.
1163 //
1164 // Have fun reading it. Hopefully it's bug-free. God bless.
1165 contract PadThaiChef is Ownable {
1166     using SafeMath for uint256;
1167     using SafeERC20 for IERC20;
1168 
1169     // Info of each user.
1170     struct UserInfo {
1171         uint256 amount;     // How many LP tokens the user has provided.
1172         uint256 rewardDebt; // Reward debt. See explanation below.
1173         //
1174         // We do some fancy math here. Basically, any point in time, the amount of PADTHAIs
1175         // entitled to a user but is pending to be distributed is:
1176         //
1177         //   pending reward = (user.amount * pool.accPadthaiPerShare) - user.rewardDebt
1178         //
1179         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1180         //   1. The pool's `accPadthaiPerShare` (and `lastRewardBlock`) gets updated.
1181         //   2. User receives the pending reward sent to his/her address.
1182         //   3. User's `amount` gets updated.
1183         //   4. User's `rewardDebt` gets updated.
1184     }
1185 
1186     // Info of each pool.
1187     struct PoolInfo {
1188         IERC20 lpToken;           // Address of LP token contract.
1189         uint256 allocPoint;       // How many allocation points assigned to this pool. PADTHAIs to distribute per block.
1190         uint256 lastRewardBlock;  // Last block number that PADTHAIs distribution occurs.
1191         uint256 accPadthaiPerShare; // Accumulated PADTHAIs per share, times 1e12. See below.
1192     }
1193 
1194     // The PADTHAI TOKEN!
1195     PadThaiToken public padthai;
1196     // Dev address.
1197     address public devaddr;
1198     // Block number when bonus PADTHAI period ends.
1199     uint256 public bonusEndBlock;
1200     // PADTHAI tokens created per block.
1201     uint256 public padthaiPerBlock;
1202     // Bonus muliplier for early padthai makers.
1203     uint256 public constant BONUS_MULTIPLIER = 10;
1204 
1205     // Info of each pool.
1206     PoolInfo[] public poolInfo;
1207     // Info of each user that stakes LP tokens.
1208     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1209     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1210     uint256 public totalAllocPoint = 0;
1211     // The block number when PADTHAI mining starts.
1212     uint256 public startBlock;
1213 
1214     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1215     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1216     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1217 
1218     constructor(
1219         PadThaiToken _padthai,
1220         address _devaddr,
1221         uint256 _padthaiPerBlock,
1222         uint256 _startBlock,
1223         uint256 _bonusEndBlock
1224     ) public {
1225         padthai = _padthai;
1226         devaddr = _devaddr;
1227         padthaiPerBlock = _padthaiPerBlock;
1228         bonusEndBlock = _bonusEndBlock;
1229         startBlock = _startBlock;
1230     }
1231 
1232     function poolLength() external view returns (uint256) {
1233         return poolInfo.length;
1234     }
1235 
1236     // PeckShield Audit recommendation
1237     // DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1238     function checkPoolDuplicate (IERC20 _lpToken) public {
1239         uint256 length = poolInfo.length ;
1240         for (uint256 _pid = 0; _pid < length; ++_pid) {
1241             require(poolInfo[_pid].lpToken != _lpToken, "add:existingpool?");
1242         }
1243     }
1244 
1245     // Add a new lp to the pool. Can only be called by the owner.
1246     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1247         if (_withUpdate) {
1248             massUpdatePools();
1249         }
1250         checkPoolDuplicate (_lpToken);
1251         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1252         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1253         poolInfo.push(PoolInfo({
1254             lpToken: _lpToken,
1255             allocPoint: _allocPoint,
1256             lastRewardBlock: lastRewardBlock,
1257             accPadthaiPerShare: 0
1258         }));
1259     }
1260 
1261     // Update the given pool's PADTHAI allocation point. Can only be called by the owner.
1262     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1263         if (_withUpdate) {
1264             massUpdatePools();
1265         }
1266         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1267         poolInfo[_pid].allocPoint = _allocPoint;
1268     }
1269 
1270     // Return reward multiplier over the given _from to _to block.
1271     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1272         if (_to <= bonusEndBlock) {
1273             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1274         } else if (_from >= bonusEndBlock) {
1275             return _to.sub(_from);
1276         } else {
1277             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1278                 _to.sub(bonusEndBlock)
1279             );
1280         }
1281     }
1282 
1283     // View function to see pending PADTHAIs on frontend.
1284     function pendingPadthai(uint256 _pid, address _user) external view returns (uint256) {
1285         PoolInfo storage pool = poolInfo[_pid];
1286         UserInfo storage user = userInfo[_pid][_user];
1287         uint256 accPadthaiPerShare = pool.accPadthaiPerShare;
1288         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1289         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1290             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1291             uint256 padthaiReward = multiplier.mul(padthaiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1292             accPadthaiPerShare = accPadthaiPerShare.add(padthaiReward.mul(1e12).div(lpSupply));
1293         }
1294         return user.amount.mul(accPadthaiPerShare).div(1e12).sub(user.rewardDebt);
1295     }
1296 
1297     // Update reward vairables for all pools. Be careful of gas spending!
1298     function massUpdatePools() public {
1299         uint256 length = poolInfo.length;
1300         for (uint256 pid = 0; pid < length; ++pid) {
1301             updatePool(pid);
1302         }
1303     }
1304 
1305     // Update reward variables of the given pool to be up-to-date.
1306     function updatePool(uint256 _pid) public {
1307         PoolInfo storage pool = poolInfo[_pid];
1308         if (block.number <= pool.lastRewardBlock) {
1309             return;
1310         }
1311         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1312         if (lpSupply == 0) {
1313             pool.lastRewardBlock = block.number;
1314             return;
1315         }
1316         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1317         uint256 padthaiReward = multiplier.mul(padthaiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1318         padthai.mint(devaddr, padthaiReward.div(10));
1319         padthai.mint(address(this), padthaiReward);
1320         pool.accPadthaiPerShare = pool.accPadthaiPerShare.add(padthaiReward.mul(1e12).div(lpSupply));
1321         pool.lastRewardBlock = block.number;
1322     }
1323 
1324     // Deposit LP tokens to PadThaiChef for PADTHAI allocation.
1325     function deposit(uint256 _pid, uint256 _amount) public {
1326         PoolInfo storage pool = poolInfo[_pid];
1327         UserInfo storage user = userInfo[_pid][msg.sender];
1328         updatePool(_pid);
1329         if (user.amount > 0) {
1330             uint256 pending = user.amount.mul(pool.accPadthaiPerShare).div(1e12).sub(user.rewardDebt);
1331             safePadthaiTransfer(msg.sender, pending);
1332         }
1333         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1334         user.amount = user.amount.add(_amount);
1335         user.rewardDebt = user.amount.mul(pool.accPadthaiPerShare).div(1e12);
1336         emit Deposit(msg.sender, _pid, _amount);
1337     }
1338 
1339     // Withdraw LP tokens from PadThaiChef.
1340     function withdraw(uint256 _pid, uint256 _amount) public {
1341         PoolInfo storage pool = poolInfo[_pid];
1342         UserInfo storage user = userInfo[_pid][msg.sender];
1343         require(user.amount >= _amount, "withdraw: not good");
1344         updatePool(_pid);
1345         uint256 pending = user.amount.mul(pool.accPadthaiPerShare).div(1e12).sub(user.rewardDebt);
1346         safePadthaiTransfer(msg.sender, pending);
1347         user.amount = user.amount.sub(_amount);
1348         user.rewardDebt = user.amount.mul(pool.accPadthaiPerShare).div(1e12);
1349         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1350         emit Withdraw(msg.sender, _pid, _amount);
1351     }
1352 
1353     // Withdraw without caring about rewards. EMERGENCY ONLY.
1354     function emergencyWithdraw(uint256 _pid) public {
1355         PoolInfo storage pool = poolInfo[_pid];
1356         UserInfo storage user = userInfo[_pid][msg.sender];
1357         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1358         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1359         user.amount = 0;
1360         user.rewardDebt = 0;
1361     }
1362 
1363     // Safe padthai transfer function, just in case if rounding error causes pool to not have enough PADTHAIs.
1364     function safePadthaiTransfer(address _to, uint256 _amount) internal {
1365         uint256 padthaiBal = padthai.balanceOf(address(this));
1366         if (_amount > padthaiBal) {
1367             padthai.transfer(_to, padthaiBal);
1368         } else {
1369             padthai.transfer(_to, _amount);
1370         }
1371     }
1372 
1373     // Update dev address by the previous dev.
1374     function dev(address _devaddr) public {
1375         require(msg.sender == devaddr, "dev: wut?");
1376         devaddr = _devaddr;
1377     }
1378 }