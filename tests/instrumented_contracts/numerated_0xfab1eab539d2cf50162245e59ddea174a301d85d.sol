1 pragma solidity ^0.6.0;
2 /*
3        https://MagicLiquidity.com
4     
5                     ____ 
6                   .'* *.'
7                __/_*_*(_
8               / _______ \
9              _\_)/___\(_/_ 
10             / _((\- -/))_ \
11             \ \())(-)(()/ /
12              ' \(((()))/ '
13             / ' \)).))/ ' \
14            / _ \ - | - /_  \
15           (   ( .;''';. .'  )
16           _\"__ /    )\ __"/_
17             \/  \   ' /  \/
18              .'  '...' ' )
19               / /  |  \ \
20              / .   .   . \
21             /   .     .   \
22            /   /   |   \   \
23          .'   /    b    '.  '.
24      _.-'    /     Bb     '-. '-._ 
25  _.-'       |      BBb       '-.  '-. 
26 (________mrf\____.dBBBb.________)____)
27 
28 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
29             THE GREAT WIZARD
30 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
31 
32  */
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly { codehash := extcodehash(account) }
297         return (codehash != accountHash && codehash != 0x0);
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
320         (bool success, ) = recipient.call{ value: amount }("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 
324     /**
325      * @dev Performs a Solidity function call using a low level `call`. A
326      * plain`call` is an unsafe replacement for a function call: use this
327      * function instead.
328      *
329      * If `target` reverts with a revert reason, it is bubbled up by this
330      * function (like regular Solidity function calls).
331      *
332      * Returns the raw returned data. To convert to the expected return value,
333      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
334      *
335      * Requirements:
336      *
337      * - `target` must be a contract.
338      * - calling `target` with `data` must not revert.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
343       return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
353         return _functionCallWithValue(target, data, 0, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but also transferring `value` wei to `target`.
359      *
360      * Requirements:
361      *
362      * - the calling contract must have an ETH balance of at least `value`.
363      * - the called Solidity function must be `payable`.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         return _functionCallWithValue(target, data, value, errorMessage);
380     }
381 
382     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
383         require(isContract(target), "Address: call to non-contract");
384 
385         // solhint-disable-next-line avoid-low-level-calls
386         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 // solhint-disable-next-line no-inline-assembly
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
407 
408 /**
409  * @title SafeERC20
410  * @dev Wrappers around ERC20 operations that throw on failure (when the token
411  * contract returns false). Tokens that return no value (and instead revert or
412  * throw on failure) are also supported, non-reverting calls are assumed to be
413  * successful.
414  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
415  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
416  */
417 library SafeERC20 {
418     using SafeMath for uint256;
419     using Address for address;
420 
421     function safeTransfer(IERC20 token, address to, uint256 value) internal {
422         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
423     }
424 
425     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
426         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
427     }
428 
429     /**
430      * @dev Deprecated. This function has issues similar to the ones found in
431      * {IERC20-approve}, and its usage is discouraged.
432      *
433      * Whenever possible, use {safeIncreaseAllowance} and
434      * {safeDecreaseAllowance} instead.
435      */
436     function safeApprove(IERC20 token, address spender, uint256 value) internal {
437         // safeApprove should only be called when setting an initial allowance,
438         // or when resetting it to zero. To increase and decrease it, use
439         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
440         // solhint-disable-next-line max-line-length
441         require((value == 0) || (token.allowance(address(this), spender) == 0),
442             "SafeERC20: approve from non-zero to non-zero allowance"
443         );
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
445     }
446 
447     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
448         uint256 newAllowance = token.allowance(address(this), spender).add(value);
449         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
450     }
451 
452     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
453         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
454         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
455     }
456 
457     /**
458      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
459      * on the return value: the return value is optional (but if data is returned, it must not be false).
460      * @param token The token targeted by the call.
461      * @param data The call data (encoded using abi.encode or one of its variants).
462      */
463     function _callOptionalReturn(IERC20 token, bytes memory data) private {
464         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
465         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
466         // the target address contains contract code and also asserts for success in the low-level call.
467 
468         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
469         if (returndata.length > 0) { // Return data is optional
470             // solhint-disable-next-line max-line-length
471             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
472         }
473     }
474 }
475 
476 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
477 
478 /**
479  * @dev Library for managing
480  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
481  * types.
482  *
483  * Sets have the following properties:
484  *
485  * - Elements are added, removed, and checked for existence in constant time
486  * (O(1)).
487  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
488  *
489  * ```
490  * contract Example {
491  *     // Add the library methods
492  *     using EnumerableSet for EnumerableSet.AddressSet;
493  *
494  *     // Declare a set state variable
495  *     EnumerableSet.AddressSet private mySet;
496  * }
497  * ```
498  *
499  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
500  * (`UintSet`) are supported.
501  */
502 library EnumerableSet {
503     // To implement this library for multiple types with as little code
504     // repetition as possible, we write it in terms of a generic Set type with
505     // bytes32 values.
506     // The Set implementation uses private functions, and user-facing
507     // implementations (such as AddressSet) are just wrappers around the
508     // underlying Set.
509     // This means that we can only create new EnumerableSets for types that fit
510     // in bytes32.
511 
512     struct Set {
513         // Storage of set values
514         bytes32[] _values;
515 
516         // Position of the value in the `values` array, plus 1 because index 0
517         // means a value is not in the set.
518         mapping (bytes32 => uint256) _indexes;
519     }
520 
521     /**
522      * @dev Add a value to a set. O(1).
523      *
524      * Returns true if the value was added to the set, that is if it was not
525      * already present.
526      */
527     function _add(Set storage set, bytes32 value) private returns (bool) {
528         if (!_contains(set, value)) {
529             set._values.push(value);
530             // The value is stored at length-1, but we add 1 to all indexes
531             // and use 0 as a sentinel value
532             set._indexes[value] = set._values.length;
533             return true;
534         } else {
535             return false;
536         }
537     }
538 
539     /**
540      * @dev Removes a value from a set. O(1).
541      *
542      * Returns true if the value was removed from the set, that is if it was
543      * present.
544      */
545     function _remove(Set storage set, bytes32 value) private returns (bool) {
546         // We read and store the value's index to prevent multiple reads from the same storage slot
547         uint256 valueIndex = set._indexes[value];
548 
549         if (valueIndex != 0) { // Equivalent to contains(set, value)
550             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
551             // the array, and then remove the last element (sometimes called as 'swap and pop').
552             // This modifies the order of the array, as noted in {at}.
553 
554             uint256 toDeleteIndex = valueIndex - 1;
555             uint256 lastIndex = set._values.length - 1;
556 
557             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
558             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
559 
560             bytes32 lastvalue = set._values[lastIndex];
561 
562             // Move the last value to the index where the value to delete is
563             set._values[toDeleteIndex] = lastvalue;
564             // Update the index for the moved value
565             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
566 
567             // Delete the slot where the moved value was stored
568             set._values.pop();
569 
570             // Delete the index for the deleted slot
571             delete set._indexes[value];
572 
573             return true;
574         } else {
575             return false;
576         }
577     }
578 
579     /**
580      * @dev Returns true if the value is in the set. O(1).
581      */
582     function _contains(Set storage set, bytes32 value) private view returns (bool) {
583         return set._indexes[value] != 0;
584     }
585 
586     /**
587      * @dev Returns the number of values on the set. O(1).
588      */
589     function _length(Set storage set) private view returns (uint256) {
590         return set._values.length;
591     }
592 
593    /**
594     * @dev Returns the value stored at position `index` in the set. O(1).
595     *
596     * Note that there are no guarantees on the ordering of values inside the
597     * array, and it may change when more values are added or removed.
598     *
599     * Requirements:
600     *
601     * - `index` must be strictly less than {length}.
602     */
603     function _at(Set storage set, uint256 index) private view returns (bytes32) {
604         require(set._values.length > index, "EnumerableSet: index out of bounds");
605         return set._values[index];
606     }
607 
608     // AddressSet
609 
610     struct AddressSet {
611         Set _inner;
612     }
613 
614     /**
615      * @dev Add a value to a set. O(1).
616      *
617      * Returns true if the value was added to the set, that is if it was not
618      * already present.
619      */
620     function add(AddressSet storage set, address value) internal returns (bool) {
621         return _add(set._inner, bytes32(uint256(value)));
622     }
623 
624     /**
625      * @dev Removes a value from a set. O(1).
626      *
627      * Returns true if the value was removed from the set, that is if it was
628      * present.
629      */
630     function remove(AddressSet storage set, address value) internal returns (bool) {
631         return _remove(set._inner, bytes32(uint256(value)));
632     }
633 
634     /**
635      * @dev Returns true if the value is in the set. O(1).
636      */
637     function contains(AddressSet storage set, address value) internal view returns (bool) {
638         return _contains(set._inner, bytes32(uint256(value)));
639     }
640 
641     /**
642      * @dev Returns the number of values in the set. O(1).
643      */
644     function length(AddressSet storage set) internal view returns (uint256) {
645         return _length(set._inner);
646     }
647 
648    /**
649     * @dev Returns the value stored at position `index` in the set. O(1).
650     *
651     * Note that there are no guarantees on the ordering of values inside the
652     * array, and it may change when more values are added or removed.
653     *
654     * Requirements:
655     *
656     * - `index` must be strictly less than {length}.
657     */
658     function at(AddressSet storage set, uint256 index) internal view returns (address) {
659         return address(uint256(_at(set._inner, index)));
660     }
661 
662 
663     // UintSet
664 
665     struct UintSet {
666         Set _inner;
667     }
668 
669     /**
670      * @dev Add a value to a set. O(1).
671      *
672      * Returns true if the value was added to the set, that is if it was not
673      * already present.
674      */
675     function add(UintSet storage set, uint256 value) internal returns (bool) {
676         return _add(set._inner, bytes32(value));
677     }
678 
679     /**
680      * @dev Removes a value from a set. O(1).
681      *
682      * Returns true if the value was removed from the set, that is if it was
683      * present.
684      */
685     function remove(UintSet storage set, uint256 value) internal returns (bool) {
686         return _remove(set._inner, bytes32(value));
687     }
688 
689     /**
690      * @dev Returns true if the value is in the set. O(1).
691      */
692     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
693         return _contains(set._inner, bytes32(value));
694     }
695 
696     /**
697      * @dev Returns the number of values on the set. O(1).
698      */
699     function length(UintSet storage set) internal view returns (uint256) {
700         return _length(set._inner);
701     }
702 
703    /**
704     * @dev Returns the value stored at position `index` in the set. O(1).
705     *
706     * Note that there are no guarantees on the ordering of values inside the
707     * array, and it may change when more values are added or removed.
708     *
709     * Requirements:
710     *
711     * - `index` must be strictly less than {length}.
712     */
713     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
714         return uint256(_at(set._inner, index));
715     }
716 }
717 
718 // File: @openzeppelin/contracts/GSN/Context.sol
719 
720 /*
721  * @dev Provides information about the current execution context, including the
722  * sender of the transaction and its data. While these are generally available
723  * via msg.sender and msg.data, they should not be accessed in such a direct
724  * manner, since when dealing with GSN meta-transactions the account sending and
725  * paying for execution may not be the actual sender (as far as an application
726  * is concerned).
727  *
728  * This contract is only required for intermediate, library-like contracts.
729  */
730 abstract contract Context {
731     function _msgSender() internal view virtual returns (address payable) {
732         return msg.sender;
733     }
734 
735     function _msgData() internal view virtual returns (bytes memory) {
736         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
737         return msg.data;
738     }
739 }
740 
741 // File: @openzeppelin/contracts/access/Ownable.sol
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
1060      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1061      *
1062      * This is internal function is equivalent to `approve`, and can be used to
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
1108 // RainbowToken with Governance.
1109 contract RainbowToken is ERC20("RainbowToken", "RAINBOW"), Ownable {
1110     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1111     function mint(address _to, uint256 _amount) public onlyOwner {
1112         _mint(_to, _amount);
1113         _moveDelegates(address(0), _delegates[_to], _amount);
1114     }
1115 
1116     // Copied and modified from SUSHI code:
1117     // https://etherscan.io/address/0xc2edad668740f1aa35e4d8f227fb8e17dca888cd#code
1118     // Which is copied and modified from YAM code:
1119     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1120     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1121     // Which is copied and modified from COMPOUND:
1122     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1123 
1124     /// @notice A record of each accounts delegate
1125     mapping (address => address) internal _delegates;
1126 
1127     /// @notice A checkpoint for marking number of votes from a given block
1128     struct Checkpoint {
1129         uint32 fromBlock;
1130         uint256 votes;
1131     }
1132 
1133     /// @notice A record of votes checkpoints for each account, by index
1134     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1135 
1136     /// @notice The number of checkpoints for each account
1137     mapping (address => uint32) public numCheckpoints;
1138 
1139     /// @notice The EIP-712 typehash for the contract's domain
1140     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1141 
1142     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1143     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1144 
1145     /// @notice A record of states for signing / validating signatures
1146     mapping (address => uint) public nonces;
1147 
1148       /// @notice An event thats emitted when an account changes its delegate
1149     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1150 
1151     /// @notice An event thats emitted when a delegate account's vote balance changes
1152     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1153 
1154     /**
1155      * @notice Delegate votes from `msg.sender` to `delegatee`
1156      * @param delegator The address to get delegatee for
1157      */
1158     function delegates(address delegator)
1159         external
1160         view
1161         returns (address)
1162     {
1163         return _delegates[delegator];
1164     }
1165 
1166    /**
1167     * @notice Delegate votes from `msg.sender` to `delegatee`
1168     * @param delegatee The address to delegate votes to
1169     */
1170     function delegate(address delegatee) external {
1171         return _delegate(msg.sender, delegatee);
1172     }
1173 
1174     /**
1175      * @notice Delegates votes from signatory to `delegatee`
1176      * @param delegatee The address to delegate votes to
1177      * @param nonce The contract state required to match the signature
1178      * @param expiry The time at which to expire the signature
1179      * @param v The recovery byte of the signature
1180      * @param r Half of the ECDSA signature pair
1181      * @param s Half of the ECDSA signature pair
1182      */
1183     function delegateBySig(
1184         address delegatee,
1185         uint nonce,
1186         uint expiry,
1187         uint8 v,
1188         bytes32 r,
1189         bytes32 s
1190     )
1191         external
1192     {
1193         bytes32 domainSeparator = keccak256(
1194             abi.encode(
1195                 DOMAIN_TYPEHASH,
1196                 keccak256(bytes(name())),
1197                 getChainId(),
1198                 address(this)
1199             )
1200         );
1201 
1202         bytes32 structHash = keccak256(
1203             abi.encode(
1204                 DELEGATION_TYPEHASH,
1205                 delegatee,
1206                 nonce,
1207                 expiry
1208             )
1209         );
1210 
1211         bytes32 digest = keccak256(
1212             abi.encodePacked(
1213                 "\x19\x01",
1214                 domainSeparator,
1215                 structHash
1216             )
1217         );
1218 
1219         address signatory = ecrecover(digest, v, r, s);
1220         require(signatory != address(0), "RAINBOW::delegateBySig: invalid signature");
1221         require(nonce == nonces[signatory]++, "RAINBOW::delegateBySig: invalid nonce");
1222         require(now <= expiry, "RAINBOW::delegateBySig: signature expired");
1223         return _delegate(signatory, delegatee);
1224     }
1225 
1226     /**
1227      * @notice Gets the current votes balance for `account`
1228      * @param account The address to get votes balance
1229      * @return The number of current votes for `account`
1230      */
1231     function getCurrentVotes(address account)
1232         external
1233         view
1234         returns (uint256)
1235     {
1236         uint32 nCheckpoints = numCheckpoints[account];
1237         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1238     }
1239 
1240     /**
1241      * @notice Determine the prior number of votes for an account as of a block number
1242      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1243      * @param account The address of the account to check
1244      * @param blockNumber The block number to get the vote balance at
1245      * @return The number of votes the account had as of the given block
1246      */
1247     function getPriorVotes(address account, uint blockNumber)
1248         external
1249         view
1250         returns (uint256)
1251     {
1252         require(blockNumber < block.number, "RAINBOW::getPriorVotes: not yet determined");
1253 
1254         uint32 nCheckpoints = numCheckpoints[account];
1255         if (nCheckpoints == 0) {
1256             return 0;
1257         }
1258 
1259         // First check most recent balance
1260         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1261             return checkpoints[account][nCheckpoints - 1].votes;
1262         }
1263 
1264         // Next check implicit zero balance
1265         if (checkpoints[account][0].fromBlock > blockNumber) {
1266             return 0;
1267         }
1268 
1269         uint32 lower = 0;
1270         uint32 upper = nCheckpoints - 1;
1271         while (upper > lower) {
1272             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1273             Checkpoint memory cp = checkpoints[account][center];
1274             if (cp.fromBlock == blockNumber) {
1275                 return cp.votes;
1276             } else if (cp.fromBlock < blockNumber) {
1277                 lower = center;
1278             } else {
1279                 upper = center - 1;
1280             }
1281         }
1282         return checkpoints[account][lower].votes;
1283     }
1284 
1285     function _delegate(address delegator, address delegatee)
1286         internal
1287     {
1288         address currentDelegate = _delegates[delegator];
1289         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying RAINBOWs (not scaled);
1290         _delegates[delegator] = delegatee;
1291 
1292         emit DelegateChanged(delegator, currentDelegate, delegatee);
1293 
1294         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1295     }
1296 
1297     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1298         if (srcRep != dstRep && amount > 0) {
1299             if (srcRep != address(0)) {
1300                 // decrease old representative
1301                 uint32 srcRepNum = numCheckpoints[srcRep];
1302                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1303                 uint256 srcRepNew = srcRepOld.sub(amount);
1304                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1305             }
1306 
1307             if (dstRep != address(0)) {
1308                 // increase new representative
1309                 uint32 dstRepNum = numCheckpoints[dstRep];
1310                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1311                 uint256 dstRepNew = dstRepOld.add(amount);
1312                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1313             }
1314         }
1315     }
1316 
1317     function _writeCheckpoint(
1318         address delegatee,
1319         uint32 nCheckpoints,
1320         uint256 oldVotes,
1321         uint256 newVotes
1322     )
1323         internal
1324     {
1325         uint32 blockNumber = safe32(block.number, "RAINBOW::_writeCheckpoint: block number exceeds 32 bits");
1326 
1327         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1328             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1329         } else {
1330             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1331             numCheckpoints[delegatee] = nCheckpoints + 1;
1332         }
1333 
1334         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1335     }
1336 
1337     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1338         require(n < 2**32, errorMessage);
1339         return uint32(n);
1340     }
1341 
1342     function getChainId() internal pure returns (uint) {
1343         uint256 chainId;
1344         assembly { chainId := chainid() }
1345         return chainId;
1346     }
1347 }
1348 
1349 interface IMigratorChef {
1350     // Perform LP token migration from legacy UniswapV2 to SushiSwap.
1351     // Take the current LP token address and return the new LP token address.
1352     // Migrator should have full access to the caller's LP token.
1353     // Return the new LP token address.
1354     //
1355     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1356     // SushiSwap must mint EXACTLY the same amount of SushiSwap LP tokens or
1357     // else something bad will happen. Traditional UniswapV2 does not
1358     // do that so be careful!
1359     function migrate(IERC20 token) external returns (IERC20);
1360 }
1361 
1362 // GreatWizard.sol
1363 // Modified from SUSHI contracts/MasterChef.sol
1364 // ------------------------------------------------
1365 // Note that this contract is ownable and the owner wields tremendous power. The ownership
1366 // will be transferred to a governance smart contract once RAINBOW is sufficiently
1367 // distributed and the community can show to govern itself.
1368 //
1369 // Have fun reading it. Hopefully it's bug-free. God bless.
1370 contract GreatWizard is Ownable {
1371     using SafeMath for uint256;
1372     using SafeERC20 for IERC20;
1373 
1374     // Info of each user.
1375     struct UserInfo {
1376         uint256 amount;     // How many LP tokens the user has provided.
1377         uint256 rewardDebt; // Reward debt. See explanation below.
1378         //
1379         // We do some fancy math here. Basically, any point in time, the amount of RAINBOWs
1380         // entitled to a user but is pending to be distributed is:
1381         //
1382         //   pending reward = (user.amount * pool.accRainbowsPerShare) - user.rewardDebt
1383         //
1384         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1385         //   1. The pool's `accRainbowsPerShare` (and `lastRewardBlock`) gets updated.
1386         //   2. User receives the pending reward sent to his/her address.
1387         //   3. User's `amount` gets updated.
1388         //   4. User's `rewardDebt` gets updated.
1389     }
1390 
1391     // Info of each pool.
1392     struct PoolInfo {
1393         IERC20 lpToken;           // Address of LP token contract.
1394         uint256 allocPoint;       // How many allocation points assigned to this pool. RAINBOWs to distribute per block.
1395         uint256 lastRewardBlock;  // Last block number where RAINBOWs distribution occured.
1396         uint256 accRainbowsPerShare; // Accumulated RAINBOWs per share, times 1e12. See below.
1397     }
1398 
1399     // The RAINBOW TOKEN!
1400     RainbowToken public rainbow;
1401     // Dev address.
1402     address public devaddr;
1403     // Block number when bonus RAINBOW period ends.
1404     uint256 public bonusEndBlock;
1405     // RAINBOW tokens created per block.
1406     uint256 public rainbowsPerBlock;
1407     // Bonus muliplier for early wizards.
1408     uint256 public constant BONUS_MULTIPLIER = 10;
1409     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1410     IMigratorChef public migrator; // TODOBOW: Remove?
1411 
1412     // Info of each pool.
1413     PoolInfo[] public poolInfo;
1414     // Info of each user that stakes LP tokens.
1415     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1416     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1417     uint256 public totalAllocPoint = 0;
1418     // The block number when RAINBOW mining starts.
1419     uint256 public startBlock;
1420 
1421     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1422     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1423     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1424 
1425     constructor(
1426         RainbowToken _rainbow,
1427         address _devaddr,
1428         uint256 _rainbowsPerBlock,
1429         uint256 _startBlock,
1430         uint256 _bonusEndBlock
1431     ) public {
1432         rainbow = _rainbow;
1433         devaddr = _devaddr;
1434         rainbowsPerBlock = _rainbowsPerBlock;
1435         bonusEndBlock = _bonusEndBlock;
1436         startBlock = _startBlock;
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
1449         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1450         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1451         poolInfo.push(PoolInfo({
1452             lpToken: _lpToken,
1453             allocPoint: _allocPoint,
1454             lastRewardBlock: lastRewardBlock,
1455             accRainbowsPerShare: 0
1456         }));
1457     }
1458 
1459     // Update the given pool's RAINBOW allocation point. Can only be called by the owner.
1460     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1461         if (_withUpdate) {
1462             massUpdatePools();
1463         }
1464         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1465         poolInfo[_pid].allocPoint = _allocPoint;
1466     }
1467 
1468     // Set the migrator contract. Can only be called by the owner.
1469     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1470         migrator = _migrator;
1471     }
1472 
1473     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1474     function migrate(uint256 _pid) public {
1475         require(address(migrator) != address(0), "migrate: no migrator");
1476         PoolInfo storage pool = poolInfo[_pid];
1477         IERC20 lpToken = pool.lpToken;
1478         uint256 bal = lpToken.balanceOf(address(this));
1479         lpToken.safeApprove(address(migrator), bal);
1480         IERC20 newLpToken = migrator.migrate(lpToken);
1481         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1482         pool.lpToken = newLpToken;
1483     }
1484 
1485     // Return reward multiplier over the given _from to _to block.
1486     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1487         if (_to <= bonusEndBlock) {
1488             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1489         } else if (_from >= bonusEndBlock) {
1490             return _to.sub(_from);
1491         } else {
1492             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1493                 _to.sub(bonusEndBlock)
1494             );
1495         }
1496     }
1497 
1498     // View function to see pending RAINBOWs on frontend.
1499     function pendingRainbows(uint256 _pid, address _user) external view returns (uint256) {
1500         PoolInfo storage pool = poolInfo[_pid];
1501         UserInfo storage user = userInfo[_pid][_user];
1502         uint256 accRainbowsPerShare = pool.accRainbowsPerShare;
1503         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1504         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1505             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1506             uint256 rainbowReward = multiplier.mul(rainbowsPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1507             accRainbowsPerShare = accRainbowsPerShare.add(rainbowReward.mul(1e12).div(lpSupply));
1508         }
1509         return user.amount.mul(accRainbowsPerShare).div(1e12).sub(user.rewardDebt);
1510     }
1511 
1512     // Update reward vairables for all pools. Be careful of gas spending!
1513     function massUpdatePools() public {
1514         uint256 length = poolInfo.length;
1515         for (uint256 pid = 0; pid < length; ++pid) {
1516             updatePool(pid);
1517         }
1518     }
1519 
1520     // Update reward variables of the given pool to be up-to-date.
1521     function updatePool(uint256 _pid) public {
1522         PoolInfo storage pool = poolInfo[_pid];
1523         if (block.number <= pool.lastRewardBlock) {
1524             return;
1525         }
1526         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1527         if (lpSupply == 0) {
1528             pool.lastRewardBlock = block.number;
1529             return;
1530         }
1531         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1532         uint256 rainbowReward = multiplier.mul(rainbowsPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1533         rainbow.mint(devaddr, rainbowReward.div(10));
1534         rainbow.mint(address(this), rainbowReward);
1535         pool.accRainbowsPerShare = pool.accRainbowsPerShare.add(rainbowReward.mul(1e12).div(lpSupply));
1536         pool.lastRewardBlock = block.number;
1537     }
1538 
1539     // Deposit LP tokens to GreatWizard for RAINBOW allocation.
1540     function deposit(uint256 _pid, uint256 _amount) public {
1541         PoolInfo storage pool = poolInfo[_pid];
1542         UserInfo storage user = userInfo[_pid][msg.sender];
1543         updatePool(_pid);
1544         if (user.amount > 0) {
1545             uint256 pending = user.amount.mul(pool.accRainbowsPerShare).div(1e12).sub(user.rewardDebt);
1546             safeRainbowTransfer(msg.sender, pending);
1547         }
1548         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1549         user.amount = user.amount.add(_amount);
1550         user.rewardDebt = user.amount.mul(pool.accRainbowsPerShare).div(1e12);
1551         emit Deposit(msg.sender, _pid, _amount);
1552     }
1553 
1554     // Withdraw LP tokens from GreatWizard.
1555     function withdraw(uint256 _pid, uint256 _amount) public {
1556         PoolInfo storage pool = poolInfo[_pid];
1557         UserInfo storage user = userInfo[_pid][msg.sender];
1558         require(user.amount >= _amount, "withdraw: not good");
1559         updatePool(_pid);
1560         uint256 pending = user.amount.mul(pool.accRainbowsPerShare).div(1e12).sub(user.rewardDebt);
1561         safeRainbowTransfer(msg.sender, pending);
1562         user.amount = user.amount.sub(_amount);
1563         user.rewardDebt = user.amount.mul(pool.accRainbowsPerShare).div(1e12);
1564         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1565         emit Withdraw(msg.sender, _pid, _amount);
1566     }
1567 
1568     // Withdraw without caring about rewards. EMERGENCY ONLY.
1569     function emergencyWithdraw(uint256 _pid) public {
1570         PoolInfo storage pool = poolInfo[_pid];
1571         UserInfo storage user = userInfo[_pid][msg.sender];
1572         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1573         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1574         user.amount = 0;
1575         user.rewardDebt = 0;
1576     }
1577 
1578     // Safe rainbow transfer function, just in case if rounding error causes pool to not have enough RAINBOWs.
1579     function safeRainbowTransfer(address _to, uint256 _amount) internal {
1580         uint256 rainbowBal = rainbow.balanceOf(address(this));
1581         if (_amount > rainbowBal) {
1582             rainbow.transfer(_to, rainbowBal);
1583         } else {
1584             rainbow.transfer(_to, _amount);
1585         }
1586     }
1587 
1588     // Update dev address by the current dev.
1589     function dev(address _devaddr) public {
1590         require(msg.sender == devaddr, "Must be set by current dev");
1591         devaddr = _devaddr;
1592     }
1593 }