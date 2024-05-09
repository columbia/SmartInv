1 pragma solidity 0.6.12;
2 
3 
4 // SPDX-License-Identifier: MIT
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
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
287         (bool success, ) = recipient.call{ value: amount }("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain`call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310       return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         return _functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         return _functionCallWithValue(target, data, value, errorMessage);
347     }
348 
349     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
350         require(isContract(target), "Address: call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 /**
374  * @title SafeERC20
375  * @dev Wrappers around ERC20 operations that throw on failure (when the token
376  * contract returns false). Tokens that return no value (and instead revert or
377  * throw on failure) are also supported, non-reverting calls are assumed to be
378  * successful.
379  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
380  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
381  */
382 library SafeERC20 {
383     using SafeMath for uint256;
384     using Address for address;
385 
386     function safeTransfer(IERC20 token, address to, uint256 value) internal {
387         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
388     }
389 
390     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
391         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
392     }
393 
394     /**
395      * @dev Deprecated. This function has issues similar to the ones found in
396      * {IERC20-approve}, and its usage is discouraged.
397      *
398      * Whenever possible, use {safeIncreaseAllowance} and
399      * {safeDecreaseAllowance} instead.
400      */
401     function safeApprove(IERC20 token, address spender, uint256 value) internal {
402         // safeApprove should only be called when setting an initial allowance,
403         // or when resetting it to zero. To increase and decrease it, use
404         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
405         // solhint-disable-next-line max-line-length
406         require((value == 0) || (token.allowance(address(this), spender) == 0),
407             "SafeERC20: approve from non-zero to non-zero allowance"
408         );
409         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
410     }
411 
412     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
413         uint256 newAllowance = token.allowance(address(this), spender).add(value);
414         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
415     }
416 
417     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
418         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
419         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
420     }
421 
422     /**
423      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
424      * on the return value: the return value is optional (but if data is returned, it must not be false).
425      * @param token The token targeted by the call.
426      * @param data The call data (encoded using abi.encode or one of its variants).
427      */
428     function _callOptionalReturn(IERC20 token, bytes memory data) private {
429         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
430         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
431         // the target address contains contract code and also asserts for success in the low-level call.
432 
433         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
434         if (returndata.length > 0) { // Return data is optional
435             // solhint-disable-next-line max-line-length
436             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
437         }
438     }
439 }
440 
441 /**
442  * @dev Library for managing
443  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
444  * types.
445  *
446  * Sets have the following properties:
447  *
448  * - Elements are added, removed, and checked for existence in constant time
449  * (O(1)).
450  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
451  *
452  * ```
453  * contract Example {
454  *     // Add the library methods
455  *     using EnumerableSet for EnumerableSet.AddressSet;
456  *
457  *     // Declare a set state variable
458  *     EnumerableSet.AddressSet private mySet;
459  * }
460  * ```
461  *
462  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
463  * (`UintSet`) are supported.
464  */
465 library EnumerableSet {
466     // To implement this library for multiple types with as little code
467     // repetition as possible, we write it in terms of a generic Set type with
468     // bytes32 values.
469     // The Set implementation uses private functions, and user-facing
470     // implementations (such as AddressSet) are just wrappers around the
471     // underlying Set.
472     // This means that we can only create new EnumerableSets for types that fit
473     // in bytes32.
474 
475     struct Set {
476         // Storage of set values
477         bytes32[] _values;
478 
479         // Position of the value in the `values` array, plus 1 because index 0
480         // means a value is not in the set.
481         mapping (bytes32 => uint256) _indexes;
482     }
483 
484     /**
485      * @dev Add a value to a set. O(1).
486      *
487      * Returns true if the value was added to the set, that is if it was not
488      * already present.
489      */
490     function _add(Set storage set, bytes32 value) private returns (bool) {
491         if (!_contains(set, value)) {
492             set._values.push(value);
493             // The value is stored at length-1, but we add 1 to all indexes
494             // and use 0 as a sentinel value
495             set._indexes[value] = set._values.length;
496             return true;
497         } else {
498             return false;
499         }
500     }
501 
502     /**
503      * @dev Removes a value from a set. O(1).
504      *
505      * Returns true if the value was removed from the set, that is if it was
506      * present.
507      */
508     function _remove(Set storage set, bytes32 value) private returns (bool) {
509         // We read and store the value's index to prevent multiple reads from the same storage slot
510         uint256 valueIndex = set._indexes[value];
511 
512         if (valueIndex != 0) { // Equivalent to contains(set, value)
513             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
514             // the array, and then remove the last element (sometimes called as 'swap and pop').
515             // This modifies the order of the array, as noted in {at}.
516 
517             uint256 toDeleteIndex = valueIndex - 1;
518             uint256 lastIndex = set._values.length - 1;
519 
520             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
521             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
522 
523             bytes32 lastvalue = set._values[lastIndex];
524 
525             // Move the last value to the index where the value to delete is
526             set._values[toDeleteIndex] = lastvalue;
527             // Update the index for the moved value
528             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
529 
530             // Delete the slot where the moved value was stored
531             set._values.pop();
532 
533             // Delete the index for the deleted slot
534             delete set._indexes[value];
535 
536             return true;
537         } else {
538             return false;
539         }
540     }
541 
542     /**
543      * @dev Returns true if the value is in the set. O(1).
544      */
545     function _contains(Set storage set, bytes32 value) private view returns (bool) {
546         return set._indexes[value] != 0;
547     }
548 
549     /**
550      * @dev Returns the number of values on the set. O(1).
551      */
552     function _length(Set storage set) private view returns (uint256) {
553         return set._values.length;
554     }
555 
556    /**
557     * @dev Returns the value stored at position `index` in the set. O(1).
558     *
559     * Note that there are no guarantees on the ordering of values inside the
560     * array, and it may change when more values are added or removed.
561     *
562     * Requirements:
563     *
564     * - `index` must be strictly less than {length}.
565     */
566     function _at(Set storage set, uint256 index) private view returns (bytes32) {
567         require(set._values.length > index, "EnumerableSet: index out of bounds");
568         return set._values[index];
569     }
570 
571     // AddressSet
572 
573     struct AddressSet {
574         Set _inner;
575     }
576 
577     /**
578      * @dev Add a value to a set. O(1).
579      *
580      * Returns true if the value was added to the set, that is if it was not
581      * already present.
582      */
583     function add(AddressSet storage set, address value) internal returns (bool) {
584         return _add(set._inner, bytes32(uint256(value)));
585     }
586 
587     /**
588      * @dev Removes a value from a set. O(1).
589      *
590      * Returns true if the value was removed from the set, that is if it was
591      * present.
592      */
593     function remove(AddressSet storage set, address value) internal returns (bool) {
594         return _remove(set._inner, bytes32(uint256(value)));
595     }
596 
597     /**
598      * @dev Returns true if the value is in the set. O(1).
599      */
600     function contains(AddressSet storage set, address value) internal view returns (bool) {
601         return _contains(set._inner, bytes32(uint256(value)));
602     }
603 
604     /**
605      * @dev Returns the number of values in the set. O(1).
606      */
607     function length(AddressSet storage set) internal view returns (uint256) {
608         return _length(set._inner);
609     }
610 
611    /**
612     * @dev Returns the value stored at position `index` in the set. O(1).
613     *
614     * Note that there are no guarantees on the ordering of values inside the
615     * array, and it may change when more values are added or removed.
616     *
617     * Requirements:
618     *
619     * - `index` must be strictly less than {length}.
620     */
621     function at(AddressSet storage set, uint256 index) internal view returns (address) {
622         return address(uint256(_at(set._inner, index)));
623     }
624 
625 
626     // UintSet
627 
628     struct UintSet {
629         Set _inner;
630     }
631 
632     /**
633      * @dev Add a value to a set. O(1).
634      *
635      * Returns true if the value was added to the set, that is if it was not
636      * already present.
637      */
638     function add(UintSet storage set, uint256 value) internal returns (bool) {
639         return _add(set._inner, bytes32(value));
640     }
641 
642     /**
643      * @dev Removes a value from a set. O(1).
644      *
645      * Returns true if the value was removed from the set, that is if it was
646      * present.
647      */
648     function remove(UintSet storage set, uint256 value) internal returns (bool) {
649         return _remove(set._inner, bytes32(value));
650     }
651 
652     /**
653      * @dev Returns true if the value is in the set. O(1).
654      */
655     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
656         return _contains(set._inner, bytes32(value));
657     }
658 
659     /**
660      * @dev Returns the number of values on the set. O(1).
661      */
662     function length(UintSet storage set) internal view returns (uint256) {
663         return _length(set._inner);
664     }
665 
666    /**
667     * @dev Returns the value stored at position `index` in the set. O(1).
668     *
669     * Note that there are no guarantees on the ordering of values inside the
670     * array, and it may change when more values are added or removed.
671     *
672     * Requirements:
673     *
674     * - `index` must be strictly less than {length}.
675     */
676     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
677         return uint256(_at(set._inner, index));
678     }
679 }
680 
681 /*
682  * @dev Provides information about the current execution context, including the
683  * sender of the transaction and its data. While these are generally available
684  * via msg.sender and msg.data, they should not be accessed in such a direct
685  * manner, since when dealing with GSN meta-transactions the account sending and
686  * paying for execution may not be the actual sender (as far as an application
687  * is concerned).
688  *
689  * This contract is only required for intermediate, library-like contracts.
690  */
691 abstract contract Context {
692     function _msgSender() internal view virtual returns (address payable) {
693         return msg.sender;
694     }
695 
696     function _msgData() internal view virtual returns (bytes memory) {
697         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
698         return msg.data;
699     }
700 }
701 
702 /**
703  * @dev Contract module which provides a basic access control mechanism, where
704  * there is an account (an owner) that can be granted exclusive access to
705  * specific functions.
706  *
707  * By default, the owner account will be the one that deploys the contract. This
708  * can later be changed with {transferOwnership}.
709  *
710  * This module is used through inheritance. It will make available the modifier
711  * `onlyOwner`, which can be applied to your functions to restrict their use to
712  * the owner.
713  */
714 contract Ownable is Context {
715     address private _owner;
716 
717     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
718 
719     /**
720      * @dev Initializes the contract setting the deployer as the initial owner.
721      */
722     constructor () internal {
723         address msgSender = _msgSender();
724         _owner = msgSender;
725         emit OwnershipTransferred(address(0), msgSender);
726     }
727 
728     /**
729      * @dev Returns the address of the current owner.
730      */
731     function owner() public view returns (address) {
732         return _owner;
733     }
734 
735     /**
736      * @dev Throws if called by any account other than the owner.
737      */
738     modifier onlyOwner() {
739         require(_owner == _msgSender(), "Ownable: caller is not the owner");
740         _;
741     }
742 
743     /**
744      * @dev Leaves the contract without owner. It will not be possible to call
745      * `onlyOwner` functions anymore. Can only be called by the current owner.
746      *
747      * NOTE: Renouncing ownership will leave the contract without an owner,
748      * thereby removing any functionality that is only available to the owner.
749      */
750     function renounceOwnership() public virtual onlyOwner {
751         emit OwnershipTransferred(_owner, address(0));
752         _owner = address(0);
753     }
754 
755     /**
756      * @dev Transfers ownership of the contract to a new account (`newOwner`).
757      * Can only be called by the current owner.
758      */
759     function transferOwnership(address newOwner) public virtual onlyOwner {
760         require(newOwner != address(0), "Ownable: new owner is the zero address");
761         emit OwnershipTransferred(_owner, newOwner);
762         _owner = newOwner;
763     }
764 }
765 
766 /**
767  * @dev Implementation of the {IERC20} interface.
768  *
769  * This implementation is agnostic to the way tokens are created. This means
770  * that a supply mechanism has to be added in a derived contract using {_mint}.
771  * For a generic mechanism see {ERC20PresetMinterPauser}.
772  *
773  * TIP: For a detailed writeup see our guide
774  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
775  * to implement supply mechanisms].
776  *
777  * We have followed general OpenZeppelin guidelines: functions revert instead
778  * of returning `false` on failure. This behavior is nonetheless conventional
779  * and does not conflict with the expectations of ERC20 applications.
780  *
781  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
782  * This allows applications to reconstruct the allowance for all accounts just
783  * by listening to said events. Other implementations of the EIP may not emit
784  * these events, as it isn't required by the specification.
785  *
786  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
787  * functions have been added to mitigate the well-known issues around setting
788  * allowances. See {IERC20-approve}.
789  */
790 contract ERC20 is Context, IERC20 {
791     using SafeMath for uint256;
792     using Address for address;
793 
794     mapping (address => uint256) private _balances;
795 
796     mapping (address => mapping (address => uint256)) private _allowances;
797 
798     uint256 private _totalSupply;
799 
800     string private _name;
801     string private _symbol;
802     uint8 private _decimals;
803 
804     /**
805      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
806      * a default value of 18.
807      *
808      * To select a different value for {decimals}, use {_setupDecimals}.
809      *
810      * All three of these values are immutable: they can only be set once during
811      * construction.
812      */
813     constructor (string memory name, string memory symbol) public {
814         _name = name;
815         _symbol = symbol;
816         _decimals = 18;
817     }
818 
819     /**
820      * @dev Returns the name of the token.
821      */
822     function name() public view returns (string memory) {
823         return _name;
824     }
825 
826     /**
827      * @dev Returns the symbol of the token, usually a shorter version of the
828      * name.
829      */
830     function symbol() public view returns (string memory) {
831         return _symbol;
832     }
833 
834     /**
835      * @dev Returns the number of decimals used to get its user representation.
836      * For example, if `decimals` equals `2`, a balance of `505` tokens should
837      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
838      *
839      * Tokens usually opt for a value of 18, imitating the relationship between
840      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
841      * called.
842      *
843      * NOTE: This information is only used for _display_ purposes: it in
844      * no way affects any of the arithmetic of the contract, including
845      * {IERC20-balanceOf} and {IERC20-transfer}.
846      */
847     function decimals() public view returns (uint8) {
848         return _decimals;
849     }
850 
851     /**
852      * @dev See {IERC20-totalSupply}.
853      */
854     function totalSupply() public view override returns (uint256) {
855         return _totalSupply;
856     }
857 
858     /**
859      * @dev See {IERC20-balanceOf}.
860      */
861     function balanceOf(address account) public view override returns (uint256) {
862         return _balances[account];
863     }
864 
865     /**
866      * @dev See {IERC20-transfer}.
867      *
868      * Requirements:
869      *
870      * - `recipient` cannot be the zero address.
871      * - the caller must have a balance of at least `amount`.
872      */
873     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
874         _transfer(_msgSender(), recipient, amount);
875         return true;
876     }
877 
878     /**
879      * @dev See {IERC20-allowance}.
880      */
881     function allowance(address owner, address spender) public view virtual override returns (uint256) {
882         return _allowances[owner][spender];
883     }
884 
885     /**
886      * @dev See {IERC20-approve}.
887      *
888      * Requirements:
889      *
890      * - `spender` cannot be the zero address.
891      */
892     function approve(address spender, uint256 amount) public virtual override returns (bool) {
893         _approve(_msgSender(), spender, amount);
894         return true;
895     }
896 
897     /**
898      * @dev See {IERC20-transferFrom}.
899      *
900      * Emits an {Approval} event indicating the updated allowance. This is not
901      * required by the EIP. See the note at the beginning of {ERC20};
902      *
903      * Requirements:
904      * - `sender` and `recipient` cannot be the zero address.
905      * - `sender` must have a balance of at least `amount`.
906      * - the caller must have allowance for ``sender``'s tokens of at least
907      * `amount`.
908      */
909     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
910         _transfer(sender, recipient, amount);
911         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
912         return true;
913     }
914 
915     /**
916      * @dev Atomically increases the allowance granted to `spender` by the caller.
917      *
918      * This is an alternative to {approve} that can be used as a mitigation for
919      * problems described in {IERC20-approve}.
920      *
921      * Emits an {Approval} event indicating the updated allowance.
922      *
923      * Requirements:
924      *
925      * - `spender` cannot be the zero address.
926      */
927     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
928         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
929         return true;
930     }
931 
932     /**
933      * @dev Atomically decreases the allowance granted to `spender` by the caller.
934      *
935      * This is an alternative to {approve} that can be used as a mitigation for
936      * problems described in {IERC20-approve}.
937      *
938      * Emits an {Approval} event indicating the updated allowance.
939      *
940      * Requirements:
941      *
942      * - `spender` cannot be the zero address.
943      * - `spender` must have allowance for the caller of at least
944      * `subtractedValue`.
945      */
946     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
947         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
948         return true;
949     }
950 
951     /**
952      * @dev Moves tokens `amount` from `sender` to `recipient`.
953      *
954      * This is internal function is equivalent to {transfer}, and can be used to
955      * e.g. implement automatic token fees, slashing mechanisms, etc.
956      *
957      * Emits a {Transfer} event.
958      *
959      * Requirements:
960      *
961      * - `sender` cannot be the zero address.
962      * - `recipient` cannot be the zero address.
963      * - `sender` must have a balance of at least `amount`.
964      */
965     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
966         require(sender != address(0), "ERC20: transfer from the zero address");
967         require(recipient != address(0), "ERC20: transfer to the zero address");
968 
969         _beforeTokenTransfer(sender, recipient, amount);
970 
971         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
972         _balances[recipient] = _balances[recipient].add(amount);
973         emit Transfer(sender, recipient, amount);
974     }
975 
976     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
977      * the total supply.
978      *
979      * Emits a {Transfer} event with `from` set to the zero address.
980      *
981      * Requirements
982      *
983      * - `to` cannot be the zero address.
984      */
985     function _mint(address account, uint256 amount) internal virtual {
986         require(account != address(0), "ERC20: mint to the zero address");
987 
988         _beforeTokenTransfer(address(0), account, amount);
989 
990         _totalSupply = _totalSupply.add(amount);
991         _balances[account] = _balances[account].add(amount);
992         emit Transfer(address(0), account, amount);
993     }
994 
995     /**
996      * @dev Destroys `amount` tokens from `account`, reducing the
997      * total supply.
998      *
999      * Emits a {Transfer} event with `to` set to the zero address.
1000      *
1001      * Requirements
1002      *
1003      * - `account` cannot be the zero address.
1004      * - `account` must have at least `amount` tokens.
1005      */
1006     function _burn(address account, uint256 amount) internal virtual {
1007         require(account != address(0), "ERC20: burn from the zero address");
1008 
1009         _beforeTokenTransfer(account, address(0), amount);
1010 
1011         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1012         _totalSupply = _totalSupply.sub(amount);
1013         emit Transfer(account, address(0), amount);
1014     }
1015 
1016     /**
1017      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1018      *
1019      * This is internal function is equivalent to `approve`, and can be used to
1020      * e.g. set automatic allowances for certain subsystems, etc.
1021      *
1022      * Emits an {Approval} event.
1023      *
1024      * Requirements:
1025      *
1026      * - `owner` cannot be the zero address.
1027      * - `spender` cannot be the zero address.
1028      */
1029     function _approve(address owner, address spender, uint256 amount) internal virtual {
1030         require(owner != address(0), "ERC20: approve from the zero address");
1031         require(spender != address(0), "ERC20: approve to the zero address");
1032 
1033         _allowances[owner][spender] = amount;
1034         emit Approval(owner, spender, amount);
1035     }
1036 
1037     /**
1038      * @dev Sets {decimals} to a value other than the default one of 18.
1039      *
1040      * WARNING: This function should only be called from the constructor. Most
1041      * applications that interact with token contracts will not expect
1042      * {decimals} to ever change, and may work incorrectly if it does.
1043      */
1044     function _setupDecimals(uint8 decimals_) internal {
1045         _decimals = decimals_;
1046     }
1047 
1048     /**
1049      * @dev Hook that is called before any transfer of tokens. This includes
1050      * minting and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1055      * will be to transferred to `to`.
1056      * - when `from` is zero, `amount` tokens will be minted for `to`.
1057      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1058      * - `from` and `to` are never both zero.
1059      *
1060      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1061      */
1062     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1063 }
1064 
1065 // TrumpToken with Governance.
1066 contract TrumpToken is ERC20("trumpswap.finance", "TRUMP"), Ownable {
1067     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1068     function mint(address _to, uint256 _amount) public onlyOwner {
1069         _mint(_to, _amount);
1070         _moveDelegates(address(0), _delegates[_to], _amount);
1071     }
1072 
1073     //  transfers delegate authority when sending a token.
1074     // https://medium.com/bulldax-finance/sushiswap-delegation-double-spending-bug-5adcc7b3830f
1075     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
1076       super._transfer(sender, recipient, amount);
1077       _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1078     }
1079 
1080     // Copied and modified from YAM code:
1081     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1082     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1083     // Which is copied and modified from COMPOUND:
1084     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1085 
1086     /// @notice A record of each accounts delegate
1087     mapping (address => address) internal _delegates;
1088 
1089     /// @notice A checkpoint for marking number of votes from a given block
1090     struct Checkpoint {
1091         uint32 fromBlock;
1092         uint256 votes;
1093     }
1094 
1095     /// @notice A record of votes checkpoints for each account, by index
1096     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1097 
1098     /// @notice The number of checkpoints for each account
1099     mapping (address => uint32) public numCheckpoints;
1100 
1101     /// @notice The EIP-712 typehash for the contract's domain
1102     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1103 
1104     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1105     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1106 
1107     /// @notice A record of states for signing / validating signatures
1108     mapping (address => uint) public nonces;
1109 
1110       /// @notice An event thats emitted when an account changes its delegate
1111     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1112 
1113     /// @notice An event thats emitted when a delegate account's vote balance changes
1114     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1115 
1116     /**
1117      * @notice Delegate votes from `msg.sender` to `delegatee`
1118      * @param delegator The address to get delegatee for
1119      */
1120     function delegates(address delegator)
1121         external
1122         view
1123         returns (address)
1124     {
1125         return _delegates[delegator];
1126     }
1127 
1128    /**
1129     * @notice Delegate votes from `msg.sender` to `delegatee`
1130     * @param delegatee The address to delegate votes to
1131     */
1132     function delegate(address delegatee) external {
1133         return _delegate(msg.sender, delegatee);
1134     }
1135 
1136     /**
1137      * @notice Delegates votes from signatory to `delegatee`
1138      * @param delegatee The address to delegate votes to
1139      * @param nonce The contract state required to match the signature
1140      * @param expiry The time at which to expire the signature
1141      * @param v The recovery byte of the signature
1142      * @param r Half of the ECDSA signature pair
1143      * @param s Half of the ECDSA signature pair
1144      */
1145     function delegateBySig(
1146         address delegatee,
1147         uint nonce,
1148         uint expiry,
1149         uint8 v,
1150         bytes32 r,
1151         bytes32 s
1152     )
1153         external
1154     {
1155         bytes32 domainSeparator = keccak256(
1156             abi.encode(
1157                 DOMAIN_TYPEHASH,
1158                 keccak256(bytes(name())),
1159                 getChainId(),
1160                 address(this)
1161             )
1162         );
1163 
1164         bytes32 structHash = keccak256(
1165             abi.encode(
1166                 DELEGATION_TYPEHASH,
1167                 delegatee,
1168                 nonce,
1169                 expiry
1170             )
1171         );
1172 
1173         bytes32 digest = keccak256(
1174             abi.encodePacked(
1175                 "\x19\x01",
1176                 domainSeparator,
1177                 structHash
1178             )
1179         );
1180 
1181         address signatory = ecrecover(digest, v, r, s);
1182         require(signatory != address(0), "TRUMP::delegateBySig: invalid signature");
1183         require(nonce == nonces[signatory]++, "TRUMP::delegateBySig: invalid nonce");
1184         require(now <= expiry, "TRUMP::delegateBySig: signature expired");
1185         return _delegate(signatory, delegatee);
1186     }
1187 
1188     /**
1189      * @notice Gets the current votes balance for `account`
1190      * @param account The address to get votes balance
1191      * @return The number of current votes for `account`
1192      */
1193     function getCurrentVotes(address account)
1194         external
1195         view
1196         returns (uint256)
1197     {
1198         uint32 nCheckpoints = numCheckpoints[account];
1199         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1200     }
1201 
1202     /**
1203      * @notice Determine the prior number of votes for an account as of a block number
1204      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1205      * @param account The address of the account to check
1206      * @param blockNumber The block number to get the vote balance at
1207      * @return The number of votes the account had as of the given block
1208      */
1209     function getPriorVotes(address account, uint blockNumber)
1210         external
1211         view
1212         returns (uint256)
1213     {
1214         require(blockNumber < block.number, "TRUMP::getPriorVotes: not yet determined");
1215 
1216         uint32 nCheckpoints = numCheckpoints[account];
1217         if (nCheckpoints == 0) {
1218             return 0;
1219         }
1220 
1221         // First check most recent balance
1222         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1223             return checkpoints[account][nCheckpoints - 1].votes;
1224         }
1225 
1226         // Next check implicit zero balance
1227         if (checkpoints[account][0].fromBlock > blockNumber) {
1228             return 0;
1229         }
1230 
1231         uint32 lower = 0;
1232         uint32 upper = nCheckpoints - 1;
1233         while (upper > lower) {
1234             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1235             Checkpoint memory cp = checkpoints[account][center];
1236             if (cp.fromBlock == blockNumber) {
1237                 return cp.votes;
1238             } else if (cp.fromBlock < blockNumber) {
1239                 lower = center;
1240             } else {
1241                 upper = center - 1;
1242             }
1243         }
1244         return checkpoints[account][lower].votes;
1245     }
1246 
1247     function _delegate(address delegator, address delegatee)
1248         internal
1249     {
1250         address currentDelegate = _delegates[delegator];
1251         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying TRUMPs (not scaled);
1252         _delegates[delegator] = delegatee;
1253 
1254         emit DelegateChanged(delegator, currentDelegate, delegatee);
1255 
1256         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1257     }
1258 
1259     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1260         if (srcRep != dstRep && amount > 0) {
1261             if (srcRep != address(0)) {
1262                 // decrease old representative
1263                 uint32 srcRepNum = numCheckpoints[srcRep];
1264                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1265                 uint256 srcRepNew = srcRepOld.sub(amount);
1266                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1267             }
1268 
1269             if (dstRep != address(0)) {
1270                 // increase new representative
1271                 uint32 dstRepNum = numCheckpoints[dstRep];
1272                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1273                 uint256 dstRepNew = dstRepOld.add(amount);
1274                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1275             }
1276         }
1277     }
1278 
1279     function _writeCheckpoint(
1280         address delegatee,
1281         uint32 nCheckpoints,
1282         uint256 oldVotes,
1283         uint256 newVotes
1284     )
1285         internal
1286     {
1287         uint32 blockNumber = safe32(block.number, "TRUMP::_writeCheckpoint: block number exceeds 32 bits");
1288 
1289         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1290             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1291         } else {
1292             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1293             numCheckpoints[delegatee] = nCheckpoints + 1;
1294         }
1295 
1296         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1297     }
1298 
1299     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1300         require(n < 2**32, errorMessage);
1301         return uint32(n);
1302     }
1303 
1304     function getChainId() internal pure returns (uint) {
1305         uint256 chainId;
1306         assembly { chainId := chainid() }
1307         return chainId;
1308     }
1309 }
1310 
1311 interface IMigratorChef {
1312     // Perform LP token migration from legacy UniswapV2 to TrumpSwap.
1313     // Take the current LP token address and return the new LP token address.
1314     // Migrator should have full access to the caller's LP token.
1315     // Return the new LP token address.
1316     //
1317     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1318     // TrumpSwap must mint EXACTLY the same amount of TrumpSwap LP tokens or
1319     // else something bad will happen. Traditional UniswapV2 does not
1320     // do that so be careful!
1321     function migrate(IERC20 token) external returns (IERC20);
1322 }
1323 
1324 // MasterChef is the master of Trump. He can make Trump and he is a fair guy.
1325 //
1326 // Note that it's ownable and the owner wields tremendous power. The ownership
1327 // will be transferred to a governance smart contract once TRUMP is sufficiently
1328 // distributed and the community can show to govern itself.
1329 //
1330 // Have fun reading it. Hopefully it's bug-free. God bless.
1331 contract MasterChef is Ownable {
1332     using SafeMath for uint256;
1333     using SafeERC20 for IERC20;
1334 
1335     // Info of each user.
1336     struct UserInfo {
1337         uint256 amount;     // How many LP tokens the user has provided.
1338         uint256 rewardDebt; // Reward debt. See explanation below.
1339         //
1340         // We do some fancy math here. Basically, any point in time, the amount of TRUMPs
1341         // entitled to a user but is pending to be distributed is:
1342         //
1343         //   pending reward = (user.amount * pool.accTrumpPerShare) - user.rewardDebt
1344         //
1345         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1346         //   1. The pool's `accTrumpPerShare` (and `lastRewardBlock`) gets updated.
1347         //   2. User receives the pending reward sent to his/her address.
1348         //   3. User's `amount` gets updated.
1349         //   4. User's `rewardDebt` gets updated.
1350     }
1351 
1352     // Info of each pool.
1353     struct PoolInfo {
1354         IERC20 lpToken;           // Address of LP token contract.
1355         uint256 allocPoint;       // How many allocation points assigned to this pool. TRUMPs to distribute per block.
1356         uint256 lastRewardBlock;  // Last block number that TRUMPs distribution occurs.
1357         uint256 accTrumpPerShare; // Accumulated TRUMPs per share, times 1e12. See below.
1358     }
1359 
1360     mapping(address => address) nodes;
1361     mapping(address => uint256) referrerEarned;
1362 
1363     // The TRUMP TOKEN!
1364     TrumpToken public trump;
1365     // Dev address.
1366     address public devaddr;
1367     // Block number when bonus TRUMP period ends.
1368     uint256 public bonusEndBlock;
1369     // TRUMP tokens created per block.
1370     uint256 public trumpPerBlock;
1371     // Bonus muliplier for early token makers.
1372     uint256 public BONUS_MULTIPLIER;
1373 
1374     uint256 public initial_token_supply;
1375 
1376     bool initialized = false;
1377 
1378     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1379     IMigratorChef public migrator;
1380 
1381     // Info of each pool.
1382     PoolInfo[] public poolInfo;
1383     // Info of each user that stakes LP tokens.
1384     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1385     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1386     uint256 public totalAllocPoint = 0;
1387     // The block number when TRUMP mining starts.
1388     uint256 public startBlock;
1389 
1390     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1391     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1392     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1393 
1394     constructor(
1395         TrumpToken _trump,
1396         address _devaddr,
1397         uint256 _initial_token_supply,
1398         uint256 _bonus_multiplier,
1399         uint256 _trumpPerBlock,
1400         uint256 _startBlock,
1401         uint256 _bonusEndBlock
1402     ) public {
1403         trump = _trump;
1404         devaddr = _devaddr;
1405         initial_token_supply = _initial_token_supply;
1406         BONUS_MULTIPLIER = _bonus_multiplier;
1407         trumpPerBlock = _trumpPerBlock;
1408         bonusEndBlock = _bonusEndBlock;
1409         startBlock = _startBlock;
1410     }
1411 
1412     function setReferrer(address referrer) public {
1413         require(referrer != address(0), "Invalid referrer!");
1414         require(referrer != msg.sender, "Referrer can not be itself!");
1415         require(nodes[msg.sender] == address(0), "Can not change referrer address!");
1416         address referee = referrer;
1417         for (uint256 i=0;i<3;i++) {
1418             referee = nodes[referee];
1419             if (referee == address(0)) {
1420                 break;
1421             }
1422             require(referee != msg.sender, "setReferrer: Bad referrer!");
1423         }
1424         nodes[msg.sender] = referrer;
1425     }
1426 
1427     function getReferrer(address _addr) external view returns (address) {
1428         return nodes[_addr];
1429     }
1430 
1431     function getReferrerEarned(address _referrer) external view returns (uint256) {
1432         return referrerEarned[_referrer];
1433     }
1434 
1435     function poolLength() external view returns (uint256) {
1436         return poolInfo.length;
1437     }
1438 
1439     // Add a new lp to the pool. Can only be called by the owner.
1440     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1441     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1442         if (_withUpdate) {
1443             massUpdatePools();
1444         }
1445         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1446         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1447         poolInfo.push(PoolInfo({
1448             lpToken: _lpToken,
1449             allocPoint: _allocPoint,
1450             lastRewardBlock: lastRewardBlock,
1451             accTrumpPerShare: 0
1452         }));
1453     }
1454 
1455     // Update the given pool's TRUMP allocation point. Can only be called by the owner.
1456     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1457         if (_withUpdate) {
1458             massUpdatePools();
1459         }
1460         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1461         poolInfo[_pid].allocPoint = _allocPoint;
1462     }
1463 
1464     // Set the migrator contract. Can only be called by the owner.
1465     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1466         migrator = _migrator;
1467     }
1468 
1469     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1470     function migrate(uint256 _pid) public {
1471         require(address(migrator) != address(0), "migrate: no migrator");
1472         PoolInfo storage pool = poolInfo[_pid];
1473         IERC20 lpToken = pool.lpToken;
1474         uint256 bal = lpToken.balanceOf(address(this));
1475         lpToken.safeApprove(address(migrator), bal);
1476         IERC20 newLpToken = migrator.migrate(lpToken);
1477         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1478         pool.lpToken = newLpToken;
1479     }
1480 
1481     // Return reward multiplier over the given _from to _to block.
1482     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1483         if (_to <= bonusEndBlock) {
1484             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1485         } else if (_from >= bonusEndBlock) {
1486             return _to.sub(_from);
1487         } else {
1488             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1489                 _to.sub(bonusEndBlock)
1490             );
1491         }
1492     }
1493 
1494     // View function to see pending TRUMPs on frontend.
1495     function pendingTrump(uint256 _pid, address _user) external view returns (uint256) {
1496         PoolInfo storage pool = poolInfo[_pid];
1497         UserInfo storage user = userInfo[_pid][_user];
1498         uint256 accTrumpPerShare = pool.accTrumpPerShare;
1499         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1500         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1501             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1502             uint256 trumpReward = multiplier.mul(trumpPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1503             accTrumpPerShare = accTrumpPerShare.add(trumpReward.mul(1e12).div(lpSupply));
1504         }
1505         return user.amount.mul(accTrumpPerShare).div(1e12).sub(user.rewardDebt);
1506     }
1507 
1508     // Update reward vairables for all pools. Be careful of gas spending!
1509     function massUpdatePools() public {
1510         uint256 length = poolInfo.length;
1511         for (uint256 pid = 0; pid < length; ++pid) {
1512             updatePool(pid);
1513         }
1514     }
1515 
1516     // Update reward variables of the given pool to be up-to-date.
1517     function updatePool(uint256 _pid) public {
1518         PoolInfo storage pool = poolInfo[_pid];
1519         if (block.number <= pool.lastRewardBlock) {
1520             return;
1521         }
1522         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1523         if (lpSupply == 0) {
1524             pool.lastRewardBlock = block.number;
1525             return;
1526         }
1527         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1528         uint256 trumpReward = multiplier.mul(trumpPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1529         trump.mint(devaddr, trumpReward.div(10));
1530         trump.mint(address(this), trumpReward);
1531         pool.accTrumpPerShare = pool.accTrumpPerShare.add(trumpReward.mul(1e12).div(lpSupply));
1532         pool.lastRewardBlock = block.number;
1533     }
1534 
1535     function mintInitialToken(address to) public onlyOwner {
1536         require(to != address(0), "init: bad address");
1537         require(!initialized, "init: already initialized");
1538         trump.mint(to, initial_token_supply);
1539         initialized = true;
1540     }
1541 
1542     // Deposit LP tokens to MasterChef for TRUMP allocation.
1543     function deposit(uint256 _pid, uint256 _amount) public {
1544         PoolInfo storage pool = poolInfo[_pid];
1545         UserInfo storage user = userInfo[_pid][msg.sender];
1546         updatePool(_pid);
1547         if (user.amount > 0) {
1548             bool hasReferrer = false;
1549             uint[3] memory rewardPercents = [uint(10), uint(5), uint(4)];
1550             uint256 pending = user.amount.mul(pool.accTrumpPerShare).div(1e12).sub(user.rewardDebt);
1551             safeTrumpTransfer(msg.sender, pending);
1552 
1553             address referrer = msg.sender;
1554             uint onePercentReward = pending.mul(1e12).div(100);
1555             for (uint256 i=0;i<3;i++) {
1556                 referrer = nodes[referrer];
1557                 if (referrer == address(0)) {
1558                     break;
1559                 }
1560                 if (!hasReferrer) {
1561                     hasReferrer = true;
1562                 }
1563                 uint reward = onePercentReward.mul(rewardPercents[i]).div(1e12);
1564                 trump.mint(referrer, reward);
1565                 referrerEarned[referrer] += reward;
1566             }
1567             if (hasReferrer) {
1568                 trump.mint(msg.sender, onePercentReward.mul(1).div(1e12));
1569             }
1570         }
1571         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1572         user.amount = user.amount.add(_amount);
1573         user.rewardDebt = user.amount.mul(pool.accTrumpPerShare).div(1e12);
1574         emit Deposit(msg.sender, _pid, _amount);
1575     }
1576 
1577     // Withdraw LP tokens from MasterChef.
1578     function withdraw(uint256 _pid, uint256 _amount) public {
1579         PoolInfo storage pool = poolInfo[_pid];
1580         UserInfo storage user = userInfo[_pid][msg.sender];
1581         require(user.amount >= _amount, "withdraw: not good");
1582         updatePool(_pid);
1583         uint256 pending = user.amount.mul(pool.accTrumpPerShare).div(1e12).sub(user.rewardDebt);
1584         safeTrumpTransfer(msg.sender, pending);
1585         user.amount = user.amount.sub(_amount);
1586         user.rewardDebt = user.amount.mul(pool.accTrumpPerShare).div(1e12);
1587         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1588         emit Withdraw(msg.sender, _pid, _amount);
1589     }
1590 
1591     // Withdraw without caring about rewards. EMERGENCY ONLY.
1592     function emergencyWithdraw(uint256 _pid) public {
1593         PoolInfo storage pool = poolInfo[_pid];
1594         UserInfo storage user = userInfo[_pid][msg.sender];
1595         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1596         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1597         user.amount = 0;
1598         user.rewardDebt = 0;
1599     }
1600 
1601     // Safe Trump transfer function, just in case if rounding error causes pool to not have enough TRUMPs.
1602     function safeTrumpTransfer(address _to, uint256 _amount) internal {
1603         uint256 trumpBal = trump.balanceOf(address(this));
1604         if (_amount > trumpBal) {
1605             trump.transfer(_to, trumpBal);
1606         } else {
1607             trump.transfer(_to, _amount);
1608         }
1609     }
1610 
1611     // Update dev address by the previous dev.
1612     function dev(address _devaddr) public {
1613         require(msg.sender == devaddr, "dev: wut?");
1614         devaddr = _devaddr;
1615     }
1616 }