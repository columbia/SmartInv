1 /**
2  *Submitted for verificsaion at Etherscan.io on 2020-09-24
3 */
4 
5 /**
6  *Submitted for verificsaion at Etherscan.io on 2020-09-09
7 */
8 
9 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.6.0;
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicsaing whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicsaing whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicsaing whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 // File: @openzeppelin/contracts/math/SafeMath.sol
90 
91 
92 
93 pragma solidity ^0.6.0;
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the multiplicsaion of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplicsaion cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b, "SafeMath: multiplicsaion overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts on
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
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         return div(a, b, "SafeMath: division by zero");
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return mod(a, b, "SafeMath: modulo by zero");
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts with custom message when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b != 0, errorMessage);
247         return a % b;
248     }
249 }
250 
251 // File: @openzeppelin/contracts/utils/Address.sol
252 
253 
254 
255 pragma solidity ^0.6.2;
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
280         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
281         // for accounts without code, i.e. `keccak256('')`
282         bytes32 codehash;
283         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { codehash := extcodehash(account) }
286         return (codehash != accountHash && codehash != 0x0);
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain`call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332       return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
396 
397 
398 
399 pragma solidity ^0.6.0;
400 
401 
402 
403 
404 /**
405  * @title SafeERC20
406  * @dev Wrappers around ERC20 operations that throw on failure (when the token
407  * contract returns false). Tokens that return no value (and instead revert or
408  * throw on failure) are also supported, non-reverting calls are assumed to be
409  * successful.
410  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
411  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
412  */
413 library SafeERC20 {
414     using SafeMath for uint256;
415     using Address for address;
416 
417     function safeTransfer(IERC20 token, address to, uint256 value) internal {
418         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
419     }
420 
421     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
422         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
423     }
424 
425     /**
426      * @dev Deprecsaed. This function has issues similar to the ones found in
427      * {IERC20-approve}, and its usage is discouraged.
428      *
429      * Whenever possible, use {safeIncreaseAllowance} and
430      * {safeDecreaseAllowance} instead.
431      */
432     function safeApprove(IERC20 token, address spender, uint256 value) internal {
433         // safeApprove should only be called when setting an initial allowance,
434         // or when resetting it to zero. To increase and decrease it, use
435         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
436         // solhint-disable-next-line max-line-length
437         require((value == 0) || (token.allowance(address(this), spender) == 0),
438             "SafeERC20: approve from non-zero to non-zero allowance"
439         );
440         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
441     }
442 
443     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
444         uint256 newAllowance = token.allowance(address(this), spender).add(value);
445         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
446     }
447 
448     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
449         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
450         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
451     }
452 
453     /**
454      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
455      * on the return value: the return value is optional (but if data is returned, it must not be false).
456      * @param token The token targeted by the call.
457      * @param data The call data (encoded using abi.encode or one of its variants).
458      */
459     function _callOptionalReturn(IERC20 token, bytes memory data) private {
460         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
461         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
462         // the target address contains contract code and also asserts for success in the low-level call.
463 
464         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
465         if (returndata.length > 0) { // Return data is optional
466             // solhint-disable-next-line max-line-length
467             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
468         }
469     }
470 }
471 
472 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
473 
474 
475 
476 pragma solidity ^0.6.0;
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
720 
721 
722 pragma solidity ^0.6.0;
723 
724 /*
725  * @dev Provides information about the current execution context, including the
726  * sender of the transaction and its data. While these are generally available
727  * via msg.sender and msg.data, they should not be accessed in such a direct
728  * manner, since when dealing with GSN meta-transactions the account sending and
729  * paying for execution may not be the actual sender (as far as an applicsaion
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
748 
749 pragma solidity ^0.6.0;
750 
751 /**
752  * @dev Contract module which provides a basic access control mechanism, where
753  * there is an account (an owner) that can be granted exclusive access to
754  * specific functions.
755  *
756  * By default, the owner account will be the one that deploys the contract. This
757  * can later be changed with {transferOwnership}.
758  *
759  * This module is used through inheritance. It will make available the modifier
760  * `onlyOwner`, which can be applied to your functions to restrict their use to
761  * the owner.
762  */
763 contract Ownable is Context {
764     address private _owner;
765 
766     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
767 
768     /**
769      * @dev Initializes the contract setting the deployer as the initial owner.
770      */
771     constructor () internal {
772         address msgSender = _msgSender();
773         _owner = msgSender;
774         emit OwnershipTransferred(address(0), msgSender);
775     }
776 
777     /**
778      * @dev Returns the address of the current owner.
779      */
780     function owner() public view returns (address) {
781         return _owner;
782     }
783 
784     /**
785      * @dev Throws if called by any account other than the owner.
786      */
787     modifier onlyOwner() {
788         require(_owner == _msgSender(), "Ownable: caller is not the owner");
789         _;
790     }
791 
792     /**
793      * @dev Leaves the contract without owner. It will not be possible to call
794      * `onlyOwner` functions anymore. Can only be called by the current owner.
795      *
796      * NOTE: Renouncing ownership will leave the contract without an owner,
797      * thereby removing any functionality that is only available to the owner.
798      */
799     function renounceOwnership() public virtual onlyOwner {
800         emit OwnershipTransferred(_owner, address(0));
801         _owner = address(0);
802     }
803 
804     /**
805      * @dev Transfers ownership of the contract to a new account (`newOwner`).
806      * Can only be called by the current owner.
807      */
808     function transferOwnership(address newOwner) public virtual onlyOwner {
809         require(newOwner != address(0), "Ownable: new owner is the zero address");
810         emit OwnershipTransferred(_owner, newOwner);
811         _owner = newOwner;
812     }
813 }
814 
815 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
816 
817 
818 
819 pragma solidity ^0.6.0;
820 
821 
822 
823 
824 
825 /**
826  * @dev Implementation of the {IERC20} interface.
827  *
828  * This implementation is agnostic to the way tokens are created. This means
829  * that a supply mechanism has to be added in a derived contract using {_mint}.
830  * For a generic mechanism see {ERC20PresetMinterPauser}.
831  *
832  * TIP: For a detailed writeup see our guide
833  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
834  * to implement supply mechanisms].
835  *
836  * We have followed general OpenZeppelin guidelines: functions revert instead
837  * of returning `false` on failure. This behavior is nonetheless conventional
838  * and does not conflict with the expectations of ERC20 applicsaions.
839  *
840  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
841  * This allows applicsaions to reconstruct the allowance for all accounts just
842  * by listening to said events. Other implementations of the EIP may not emit
843  * these events, as it isn't required by the specificsaion.
844  *
845  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
846  * functions have been added to mitigate the well-known issues around setting
847  * allowances. See {IERC20-approve}.
848  */
849 contract ERC20 is Context, IERC20 {
850     using SafeMath for uint256;
851     using Address for address;
852 
853     mapping (address => uint256) private _balances;
854 
855     mapping (address => mapping (address => uint256)) private _allowances;
856 
857     uint256 private _totalSupply;
858 
859     string private _name;
860     string private _symbol;
861     uint8 private _decimals;
862 
863     /**
864      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
865      * a default value of 18.
866      *
867      * To select a different value for {decimals}, use {_setupDecimals}.
868      *
869      * All three of these values are immutable: they can only be set once during
870      * construction.
871      */
872     constructor (string memory name, string memory symbol) public {
873         _name = name;
874         _symbol = symbol;
875         _decimals = 18;
876     }
877 
878     /**
879      * @dev Returns the name of the token.
880      */
881     function name() public view returns (string memory) {
882         return _name;
883     }
884 
885     /**
886      * @dev Returns the symbol of the token, usually a shorter version of the
887      * name.
888      */
889     function symbol() public view returns (string memory) {
890         return _symbol;
891     }
892 
893     /**
894      * @dev Returns the number of decimals used to get its user representation.
895      * For example, if `decimals` equals `2`, a balance of `505` tokens should
896      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
897      *
898      * Tokens usually opt for a value of 18, imitating the relationship between
899      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
900      * called.
901      *
902      * NOTE: This information is only used for _display_ purposes: it in
903      * no way affects any of the arithmetic of the contract, including
904      * {IERC20-balanceOf} and {IERC20-transfer}.
905      */
906     function decimals() public view returns (uint8) {
907         return _decimals;
908     }
909 
910     /**
911      * @dev See {IERC20-totalSupply}.
912      */
913     function totalSupply() public view override returns (uint256) {
914         return _totalSupply;
915     }
916 
917     /**
918      * @dev See {IERC20-balanceOf}.
919      */
920     function balanceOf(address account) public view override returns (uint256) {
921         return _balances[account];
922     }
923 
924     /**
925      * @dev See {IERC20-transfer}.
926      *
927      * Requirements:
928      *
929      * - `recipient` cannot be the zero address.
930      * - the caller must have a balance of at least `amount`.
931      */
932     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
933         _transfer(_msgSender(), recipient, amount);
934         return true;
935     }
936 
937     /**
938      * @dev See {IERC20-allowance}.
939      */
940     function allowance(address owner, address spender) public view virtual override returns (uint256) {
941         return _allowances[owner][spender];
942     }
943 
944     /**
945      * @dev See {IERC20-approve}.
946      *
947      * Requirements:
948      *
949      * - `spender` cannot be the zero address.
950      */
951     function approve(address spender, uint256 amount) public virtual override returns (bool) {
952         _approve(_msgSender(), spender, amount);
953         return true;
954     }
955 
956     /**
957      * @dev See {IERC20-transferFrom}.
958      *
959      * Emits an {Approval} event indicsaing the updated allowance. This is not
960      * required by the EIP. See the note at the beginning of {ERC20};
961      *
962      * Requirements:
963      * - `sender` and `recipient` cannot be the zero address.
964      * - `sender` must have a balance of at least `amount`.
965      * - the caller must have allowance for ``sender``'s tokens of at least
966      * `amount`.
967      */
968     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
969         _transfer(sender, recipient, amount);
970         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
971         return true;
972     }
973 
974     /**
975      * @dev Atomically increases the allowance granted to `spender` by the caller.
976      *
977      * This is an alternative to {approve} that can be used as a mitigation for
978      * problems described in {IERC20-approve}.
979      *
980      * Emits an {Approval} event indicsaing the updated allowance.
981      *
982      * Requirements:
983      *
984      * - `spender` cannot be the zero address.
985      */
986     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
987         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
988         return true;
989     }
990 
991     /**
992      * @dev Atomically decreases the allowance granted to `spender` by the caller.
993      *
994      * This is an alternative to {approve} that can be used as a mitigation for
995      * problems described in {IERC20-approve}.
996      *
997      * Emits an {Approval} event indicsaing the updated allowance.
998      *
999      * Requirements:
1000      *
1001      * - `spender` cannot be the zero address.
1002      * - `spender` must have allowance for the caller of at least
1003      * `subtractedValue`.
1004      */
1005     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1006         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1007         return true;
1008     }
1009 
1010     /**
1011      * @dev Moves tokens `amount` from `sender` to `recipient`.
1012      *
1013      * This is internal function is equivalent to {transfer}, and can be used to
1014      * e.g. implement automatic token fees, slashing mechanisms, etc.
1015      *
1016      * Emits a {Transfer} event.
1017      *
1018      * Requirements:
1019      *
1020      * - `sender` cannot be the zero address.
1021      * - `recipient` cannot be the zero address.
1022      * - `sender` must have a balance of at least `amount`.
1023      */
1024     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1025         require(sender != address(0), "ERC20: transfer from the zero address");
1026         require(recipient != address(0), "ERC20: transfer to the zero address");
1027 
1028         _beforeTokenTransfer(sender, recipient, amount);
1029 
1030         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1031         _balances[recipient] = _balances[recipient].add(amount);
1032         emit Transfer(sender, recipient, amount);
1033     }
1034 
1035     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1036      * the total supply.
1037      *
1038      * Emits a {Transfer} event with `from` set to the zero address.
1039      *
1040      * Requirements
1041      *
1042      * - `to` cannot be the zero address.
1043      */
1044     function _mint(address account, uint256 amount) internal virtual {
1045         require(account != address(0), "ERC20: mint to the zero address");
1046 
1047         _beforeTokenTransfer(address(0), account, amount);
1048 
1049         _totalSupply = _totalSupply.add(amount);
1050         _balances[account] = _balances[account].add(amount);
1051         emit Transfer(address(0), account, amount);
1052     }
1053 
1054     /**
1055      * @dev Destroys `amount` tokens from `account`, reducing the
1056      * total supply.
1057      *
1058      * Emits a {Transfer} event with `to` set to the zero address.
1059      *
1060      * Requirements
1061      *
1062      * - `account` cannot be the zero address.
1063      * - `account` must have at least `amount` tokens.
1064      */
1065     function _burn(address account, uint256 amount) internal virtual {
1066         require(account != address(0), "ERC20: burn from the zero address");
1067 
1068         _beforeTokenTransfer(account, address(0), amount);
1069 
1070         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1071         _totalSupply = _totalSupply.sub(amount);
1072         emit Transfer(account, address(0), amount);
1073     }
1074 
1075     /**
1076      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1077      *
1078      * This is internal function is equivalent to `approve`, and can be used to
1079      * e.g. set automatic allowances for certain subsystems, etc.
1080      *
1081      * Emits an {Approval} event.
1082      *
1083      * Requirements:
1084      *
1085      * - `owner` cannot be the zero address.
1086      * - `spender` cannot be the zero address.
1087      */
1088     function _approve(address owner, address spender, uint256 amount) internal virtual {
1089         require(owner != address(0), "ERC20: approve from the zero address");
1090         require(spender != address(0), "ERC20: approve to the zero address");
1091 
1092         _allowances[owner][spender] = amount;
1093         emit Approval(owner, spender, amount);
1094     }
1095 
1096     /**
1097      * @dev Sets {decimals} to a value other than the default one of 18.
1098      *
1099      * WARNING: This function should only be called from the constructor. Most
1100      * applicsaions that interact with token contracts will not expect
1101      * {decimals} to ever change, and may work incorrectly if it does.
1102      */
1103     function _setupDecimals(uint8 decimals_) internal {
1104         _decimals = decimals_;
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before any transfer of tokens. This includes
1109      * minting and burning.
1110      *
1111      * Calling conditions:
1112      *
1113      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1114      * will be to transferred to `to`.
1115      * - when `from` is zero, `amount` tokens will be minted for `to`.
1116      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1117      * - `from` and `to` are never both zero.
1118      *
1119      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1120      */
1121     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1122 }
1123 
1124 // File: contracts/CsaToken.sol
1125 
1126 pragma solidity 0.6.12;
1127 
1128 
1129 // CsaToken with Governance.
1130 contract CsaToken is ERC20("CsaToken", "CSA"), Ownable {
1131     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1132     function mint(address _to, uint256 _amount) public onlyOwner {
1133         _mint(_to, _amount);
1134     }
1135 }
1136 
1137 // File: contracts/MasterChef.sol
1138 
1139 pragma solidity 0.6.12;
1140 
1141 
1142 
1143 
1144 
1145 
1146 
1147 
1148 interface IMigratorChef {
1149     // Perform LP token migration from legacy UniswapV2 to CatSwap.
1150     // Take the current LP token address and return the new LP token address.
1151     // Migrator should have full access to the caller's LP token.
1152     // Return the new LP token address.
1153     //
1154     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1155     // CatSwap must mint EXACTLY the same amount of CatSwap LP tokens or
1156     // else something bad will happen. Traditional UniswapV2 does not
1157     // do that so be careful!
1158     function migrate(IERC20 token) external returns (IERC20);
1159 }
1160 
1161 // MasterChef is the master of Csa. He can make Csa and he is a fair guy.
1162 //
1163 // Note that it's ownable and the owner wields tremendous power. The ownership
1164 // will be transferred to a governance smart contract once Csa is sufficiently
1165 // distributed and the community can show to govern itself.
1166 //
1167 // Have fun reading it. Hopefully it's bug-free. God bless.
1168 contract MasterChef is Ownable {
1169     using SafeMath for uint256;
1170     using SafeERC20 for IERC20;
1171 
1172     // Info of each user.
1173     struct UserInfo {
1174         uint256 amount;     // How many LP tokens the user has provided.
1175         uint256 rewardDebt; // Reward debt. See explanation below.
1176         //
1177         // We do some fancy math here. Basically, any point in time, the amount of CATs
1178         // entitled to a user but is pending to be distributed is:
1179         //
1180         //   pending reward = (user.amount * pool.accCatPerShare) - user.rewardDebt
1181         //
1182         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1183         //   1. The pool's `accCatPerShare` (and `lastRewardBlock`) gets updated.
1184         //   2. User receives the pending reward sent to his/her address.
1185         //   3. User's `amount` gets updated.
1186         //   4. User's `rewardDebt` gets updated.
1187     }
1188 
1189     // Info of each pool.
1190     struct PoolInfo {
1191         IERC20 lpToken;           // Address of LP token contract.
1192         uint256 allocPoint;       // How many allocsaion points assigned to this pool. CATs to distribute per block.
1193         uint256 lastRewardBlock;  // Last block number that CATs distribution occurs.
1194         uint256 accCatPerShare; // Accumulated CATs per share, times 1e12. See below.
1195     }
1196 
1197     // The Csa TOKEN!
1198     CsaToken public Csa;
1199 
1200     // Block number when bonus Csa period ends.
1201     uint256 public bonusEndBlock;
1202     // Csa tokens created per block.
1203     uint256 public csaPerBlock;
1204     // Bonus muliplier for early Csa makers.
1205     uint256 public constant BONUS_MULTIPLIER = 1;
1206     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1207     IMigratorChef public migrator;
1208 
1209     // Info of each pool.
1210     PoolInfo[] public poolInfo;
1211     // Info of each user that stakes LP tokens.
1212     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1213     // Total allocsaion poitns. Must be the sum of all allocsaion points in all pools.
1214     uint256 public totalAllocPoint = 0;
1215     // The block number when Csa mining starts.
1216     uint256 public startBlock;
1217 
1218     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1219     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1220     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1221 
1222     constructor(
1223         CsaToken _csa,
1224         uint256 _csaPerBlock,
1225         uint256 _startBlock,
1226         uint256 _bonusEndBlock
1227     ) public {
1228         Csa = _csa;
1229         csaPerBlock = _csaPerBlock;
1230         bonusEndBlock = _bonusEndBlock;
1231         startBlock = _startBlock;
1232     }
1233 
1234     function poolLength() external view returns (uint256) {
1235         return poolInfo.length;
1236     }
1237 
1238     //set BbonusEndBlock
1239     function setEndParam(uint256 _amount) public onlyOwner {
1240         bonusEndBlock = _amount;
1241     }
1242 
1243     //set CatPerBlock
1244     function setPerParam(uint256 _amount) public onlyOwner {
1245         csaPerBlock = _amount;
1246     }
1247 
1248     // Add a new lp to the pool. Can only be called by the owner.
1249     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1250     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1251         if (_withUpdate) {
1252             massUpdatePools();
1253         }
1254         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1255         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1256         poolInfo.push(PoolInfo({
1257             lpToken: _lpToken,
1258             allocPoint: _allocPoint,
1259             lastRewardBlock: lastRewardBlock,
1260             accCatPerShare: 0
1261         }));
1262     }
1263 
1264     // Update the given pool's Csa allocsaion point. Can only be called by the owner.
1265     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1266         if (_withUpdate) {
1267             massUpdatePools();
1268         }
1269         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1270         poolInfo[_pid].allocPoint = _allocPoint;
1271     }
1272 
1273     // Set the migrator contract. Can only be called by the owner.
1274     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1275         migrator = _migrator;
1276     }
1277 
1278     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1279     function migrate(uint256 _pid) public {
1280         require(address(migrator) != address(0), "migrate: no migrator");
1281         PoolInfo storage pool = poolInfo[_pid];
1282         IERC20 lpToken = pool.lpToken;
1283         uint256 bal = lpToken.balanceOf(address(this));
1284         lpToken.safeApprove(address(migrator), bal);
1285         IERC20 newLpToken = migrator.migrate(lpToken);
1286         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1287         pool.lpToken = newLpToken;
1288     }
1289 
1290     // Return reward multiplier over the given _from to _to block.
1291     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1292         if (_to <= bonusEndBlock) {
1293             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1294         } else if (_from >= bonusEndBlock) {
1295             return _to.sub(_from);
1296         } else {
1297             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1298                 _to.sub(bonusEndBlock)
1299             );
1300         }
1301     }
1302 
1303     // View function to see pending CATs on frontend.
1304     function pendingCat(uint256 _pid, address _user) external view returns (uint256) {
1305         PoolInfo storage pool = poolInfo[_pid];
1306         UserInfo storage user = userInfo[_pid][_user];
1307         uint256 accCatPerShare = pool.accCatPerShare;
1308         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1309         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1310             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1311             uint256 csaReward = multiplier.mul(csaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1312             accCatPerShare = accCatPerShare.add(csaReward.mul(1e12).div(lpSupply));
1313         }
1314         return user.amount.mul(accCatPerShare).div(1e12).sub(user.rewardDebt);
1315     }
1316 
1317     // Update reward vairables for all pools. Be careful of gas spending!
1318     function massUpdatePools() public {
1319         uint256 length = poolInfo.length;
1320         for (uint256 pid = 0; pid < length; ++pid) {
1321             updatePool(pid);
1322         }
1323     }
1324 
1325     // Update reward variables of the given pool to be up-to-date.
1326     function updatePool(uint256 _pid) public {
1327         PoolInfo storage pool = poolInfo[_pid];
1328         if (block.number <= pool.lastRewardBlock) {
1329             return;
1330         }
1331         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1332         if (lpSupply == 0) {
1333             pool.lastRewardBlock = block.number;
1334             return;
1335         }
1336         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1337         uint256 csaReward = multiplier.mul(csaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1338         Csa.mint(address(this), csaReward);
1339         pool.accCatPerShare = pool.accCatPerShare.add(csaReward.mul(1e12).div(lpSupply));
1340         pool.lastRewardBlock = block.number;
1341     }
1342 
1343     // Deposit LP tokens to MasterChef for Csa allocsaion.
1344     function deposit(uint256 _pid, uint256 _amount) public {
1345         PoolInfo storage pool = poolInfo[_pid];
1346         UserInfo storage user = userInfo[_pid][msg.sender];
1347         updatePool(_pid);
1348         if (user.amount > 0) {
1349             uint256 pending = user.amount.mul(pool.accCatPerShare).div(1e12).sub(user.rewardDebt);
1350             safeCatTransfer(msg.sender, pending);
1351         }
1352         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1353         user.amount = user.amount.add(_amount);
1354         user.rewardDebt = user.amount.mul(pool.accCatPerShare).div(1e12);
1355         emit Deposit(msg.sender, _pid, _amount);
1356     }
1357 
1358     // Withdraw LP tokens from MasterChef.
1359     function withdraw(uint256 _pid, uint256 _amount) public {
1360         PoolInfo storage pool = poolInfo[_pid];
1361         UserInfo storage user = userInfo[_pid][msg.sender];
1362         require(user.amount >= _amount, "withdraw: not good");
1363         updatePool(_pid);
1364         uint256 pending = user.amount.mul(pool.accCatPerShare).div(1e12).sub(user.rewardDebt);
1365         safeCatTransfer(msg.sender, pending);
1366         user.amount = user.amount.sub(_amount);
1367         user.rewardDebt = user.amount.mul(pool.accCatPerShare).div(1e12);
1368         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1369         emit Withdraw(msg.sender, _pid, _amount);
1370     }
1371 
1372     // Withdraw without caring about rewards. EMERGENCY ONLY.
1373     function emergencyWithdraw(uint256 _pid) public {
1374         PoolInfo storage pool = poolInfo[_pid];
1375         UserInfo storage user = userInfo[_pid][msg.sender];
1376         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1377         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1378         user.amount = 0;
1379         user.rewardDebt = 0;
1380     }
1381 
1382     // Safe Csa transfer function, just in case if rounding error causes pool to not have enough CATs.
1383     function safeCatTransfer(address _to, uint256 _amount) internal {
1384         uint256 csaBal = Csa.balanceOf(address(this));
1385         if (_amount > csaBal) {
1386             Csa.transfer(_to, csaBal);
1387         } else {
1388             Csa.transfer(_to, _amount);
1389         }
1390     }
1391 }