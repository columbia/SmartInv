1 pragma solidity ^0.6.0;
2 pragma solidity ^0.6.0;
3 pragma solidity ^0.6.2;
4 pragma solidity ^0.6.0;
5 pragma solidity ^0.6.0;
6 pragma solidity ^0.6.0;
7 pragma solidity ^0.6.0;
8 pragma solidity ^0.6.0;
9 pragma solidity 0.6.12;
10 pragma solidity 0.6.12;
11 
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2020-08-26
15 */
16 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 // File: @openzeppelin/contracts/math/SafeMath.sol
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return div(a, b, "SafeMath: division by zero");
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
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
388 /**
389  * @title SafeERC20
390  * @dev Wrappers around ERC20 operations that throw on failure (when the token
391  * contract returns false). Tokens that return no value (and instead revert or
392  * throw on failure) are also supported, non-reverting calls are assumed to be
393  * successful.
394  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
395  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
396  */
397 library SafeERC20 {
398     using SafeMath for uint256;
399     using Address for address;
400 
401     function safeTransfer(IERC20 token, address to, uint256 value) internal {
402         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
403     }
404 
405     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
407     }
408 
409     /**
410      * @dev Deprecated. This function has issues similar to the ones found in
411      * {IERC20-approve}, and its usage is discouraged.
412      *
413      * Whenever possible, use {safeIncreaseAllowance} and
414      * {safeDecreaseAllowance} instead.
415      */
416     function safeApprove(IERC20 token, address spender, uint256 value) internal {
417         // safeApprove should only be called when setting an initial allowance,
418         // or when resetting it to zero. To increase and decrease it, use
419         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
420         // solhint-disable-next-line max-line-length
421         require((value == 0) || (token.allowance(address(this), spender) == 0),
422             "SafeERC20: approve from non-zero to non-zero allowance"
423         );
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
425     }
426 
427     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
428         uint256 newAllowance = token.allowance(address(this), spender).add(value);
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
430     }
431 
432     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
433         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     /**
438      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
439      * on the return value: the return value is optional (but if data is returned, it must not be false).
440      * @param token The token targeted by the call.
441      * @param data The call data (encoded using abi.encode or one of its variants).
442      */
443     function _callOptionalReturn(IERC20 token, bytes memory data) private {
444         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
445         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
446         // the target address contains contract code and also asserts for success in the low-level call.
447 
448         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
449         if (returndata.length > 0) { // Return data is optional
450             // solhint-disable-next-line max-line-length
451             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
452         }
453     }
454 }
455 
456 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
457 /**
458  * @dev Library for managing
459  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
460  * types.
461  *
462  * Sets have the following properties:
463  *
464  * - Elements are added, removed, and checked for existence in constant time
465  * (O(1)).
466  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
467  *
468  * ```
469  * contract Example {
470  *     // Add the library methods
471  *     using EnumerableSet for EnumerableSet.AddressSet;
472  *
473  *     // Declare a set state variable
474  *     EnumerableSet.AddressSet private mySet;
475  * }
476  * ```
477  *
478  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
479  * (`UintSet`) are supported.
480  */
481 library EnumerableSet {
482     // To implement this library for multiple types with as little code
483     // repetition as possible, we write it in terms of a generic Set type with
484     // bytes32 values.
485     // The Set implementation uses private functions, and user-facing
486     // implementations (such as AddressSet) are just wrappers around the
487     // underlying Set.
488     // This means that we can only create new EnumerableSets for types that fit
489     // in bytes32.
490 
491     struct Set {
492         // Storage of set values
493         bytes32[] _values;
494 
495         // Position of the value in the `values` array, plus 1 because index 0
496         // means a value is not in the set.
497         mapping (bytes32 => uint256) _indexes;
498     }
499 
500     /**
501      * @dev Add a value to a set. O(1).
502      *
503      * Returns true if the value was added to the set, that is if it was not
504      * already present.
505      */
506     function _add(Set storage set, bytes32 value) private returns (bool) {
507         if (!_contains(set, value)) {
508             set._values.push(value);
509             // The value is stored at length-1, but we add 1 to all indexes
510             // and use 0 as a sentinel value
511             set._indexes[value] = set._values.length;
512             return true;
513         } else {
514             return false;
515         }
516     }
517 
518     /**
519      * @dev Removes a value from a set. O(1).
520      *
521      * Returns true if the value was removed from the set, that is if it was
522      * present.
523      */
524     function _remove(Set storage set, bytes32 value) private returns (bool) {
525         // We read and store the value's index to prevent multiple reads from the same storage slot
526         uint256 valueIndex = set._indexes[value];
527 
528         if (valueIndex != 0) { // Equivalent to contains(set, value)
529             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
530             // the array, and then remove the last element (sometimes called as 'swap and pop').
531             // This modifies the order of the array, as noted in {at}.
532 
533             uint256 toDeleteIndex = valueIndex - 1;
534             uint256 lastIndex = set._values.length - 1;
535 
536             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
537             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
538 
539             bytes32 lastvalue = set._values[lastIndex];
540 
541             // Move the last value to the index where the value to delete is
542             set._values[toDeleteIndex] = lastvalue;
543             // Update the index for the moved value
544             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
545 
546             // Delete the slot where the moved value was stored
547             set._values.pop();
548 
549             // Delete the index for the deleted slot
550             delete set._indexes[value];
551 
552             return true;
553         } else {
554             return false;
555         }
556     }
557 
558     /**
559      * @dev Returns true if the value is in the set. O(1).
560      */
561     function _contains(Set storage set, bytes32 value) private view returns (bool) {
562         return set._indexes[value] != 0;
563     }
564 
565     /**
566      * @dev Returns the number of values on the set. O(1).
567      */
568     function _length(Set storage set) private view returns (uint256) {
569         return set._values.length;
570     }
571 
572    /**
573     * @dev Returns the value stored at position `index` in the set. O(1).
574     *
575     * Note that there are no guarantees on the ordering of values inside the
576     * array, and it may change when more values are added or removed.
577     *
578     * Requirements:
579     *
580     * - `index` must be strictly less than {length}.
581     */
582     function _at(Set storage set, uint256 index) private view returns (bytes32) {
583         require(set._values.length > index, "EnumerableSet: index out of bounds");
584         return set._values[index];
585     }
586 
587     // AddressSet
588 
589     struct AddressSet {
590         Set _inner;
591     }
592 
593     /**
594      * @dev Add a value to a set. O(1).
595      *
596      * Returns true if the value was added to the set, that is if it was not
597      * already present.
598      */
599     function add(AddressSet storage set, address value) internal returns (bool) {
600         return _add(set._inner, bytes32(uint256(value)));
601     }
602 
603     /**
604      * @dev Removes a value from a set. O(1).
605      *
606      * Returns true if the value was removed from the set, that is if it was
607      * present.
608      */
609     function remove(AddressSet storage set, address value) internal returns (bool) {
610         return _remove(set._inner, bytes32(uint256(value)));
611     }
612 
613     /**
614      * @dev Returns true if the value is in the set. O(1).
615      */
616     function contains(AddressSet storage set, address value) internal view returns (bool) {
617         return _contains(set._inner, bytes32(uint256(value)));
618     }
619 
620     /**
621      * @dev Returns the number of values in the set. O(1).
622      */
623     function length(AddressSet storage set) internal view returns (uint256) {
624         return _length(set._inner);
625     }
626 
627    /**
628     * @dev Returns the value stored at position `index` in the set. O(1).
629     *
630     * Note that there are no guarantees on the ordering of values inside the
631     * array, and it may change when more values are added or removed.
632     *
633     * Requirements:
634     *
635     * - `index` must be strictly less than {length}.
636     */
637     function at(AddressSet storage set, uint256 index) internal view returns (address) {
638         return address(uint256(_at(set._inner, index)));
639     }
640 
641 
642     // UintSet
643 
644     struct UintSet {
645         Set _inner;
646     }
647 
648     /**
649      * @dev Add a value to a set. O(1).
650      *
651      * Returns true if the value was added to the set, that is if it was not
652      * already present.
653      */
654     function add(UintSet storage set, uint256 value) internal returns (bool) {
655         return _add(set._inner, bytes32(value));
656     }
657 
658     /**
659      * @dev Removes a value from a set. O(1).
660      *
661      * Returns true if the value was removed from the set, that is if it was
662      * present.
663      */
664     function remove(UintSet storage set, uint256 value) internal returns (bool) {
665         return _remove(set._inner, bytes32(value));
666     }
667 
668     /**
669      * @dev Returns true if the value is in the set. O(1).
670      */
671     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
672         return _contains(set._inner, bytes32(value));
673     }
674 
675     /**
676      * @dev Returns the number of values on the set. O(1).
677      */
678     function length(UintSet storage set) internal view returns (uint256) {
679         return _length(set._inner);
680     }
681 
682    /**
683     * @dev Returns the value stored at position `index` in the set. O(1).
684     *
685     * Note that there are no guarantees on the ordering of values inside the
686     * array, and it may change when more values are added or removed.
687     *
688     * Requirements:
689     *
690     * - `index` must be strictly less than {length}.
691     */
692     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
693         return uint256(_at(set._inner, index));
694     }
695 }
696 
697 // File: @openzeppelin/contracts/GSN/Context.sol
698 /*
699  * @dev Provides information about the current execution context, including the
700  * sender of the transaction and its data. While these are generally available
701  * via msg.sender and msg.data, they should not be accessed in such a direct
702  * manner, since when dealing with GSN meta-transactions the account sending and
703  * paying for execution may not be the actual sender (as far as an application
704  * is concerned).
705  *
706  * This contract is only required for intermediate, library-like contracts.
707  */
708 abstract contract Context {
709     function _msgSender() internal view virtual returns (address payable) {
710         return msg.sender;
711     }
712 
713     function _msgData() internal view virtual returns (bytes memory) {
714         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
715         return msg.data;
716     }
717 }
718 
719 // File: @openzeppelin/contracts/access/Ownable.sol
720 /**
721  * @dev Contract module which provides a basic access control mechanism, where
722  * there is an account (an owner) that can be granted exclusive access to
723  * specific functions.
724  *
725  * By default, the owner account will be the one that deploys the contract. This
726  * can later be changed with {transferOwnership}.
727  *
728  * This module is used through inheritance. It will make available the modifier
729  * `onlyOwner`, which can be applied to your functions to restrict their use to
730  * the owner.
731  */
732 contract Ownable is Context {
733     address private _owner;
734 
735     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
736 
737     /**
738      * @dev Initializes the contract setting the deployer as the initial owner.
739      */
740     constructor () internal {
741         address msgSender = _msgSender();
742         _owner = msgSender;
743         emit OwnershipTransferred(address(0), msgSender);
744     }
745 
746     /**
747      * @dev Returns the address of the current owner.
748      */
749     function owner() public view returns (address) {
750         return _owner;
751     }
752 
753     /**
754      * @dev Throws if called by any account other than the owner.
755      */
756     modifier onlyOwner() {
757         require(_owner == _msgSender(), "Ownable: caller is not the owner");
758         _;
759     }
760 
761     /**
762      * @dev Leaves the contract without owner. It will not be possible to call
763      * `onlyOwner` functions anymore. Can only be called by the current owner.
764      *
765      * NOTE: Renouncing ownership will leave the contract without an owner,
766      * thereby removing any functionality that is only available to the owner.
767      */
768     function renounceOwnership() public virtual onlyOwner {
769         emit OwnershipTransferred(_owner, address(0));
770         _owner = address(0);
771     }
772 
773     /**
774      * @dev Transfers ownership of the contract to a new account (`newOwner`).
775      * Can only be called by the current owner.
776      */
777     function transferOwnership(address newOwner) public virtual onlyOwner {
778         require(newOwner != address(0), "Ownable: new owner is the zero address");
779         emit OwnershipTransferred(_owner, newOwner);
780         _owner = newOwner;
781     }
782 }
783 
784 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
785 /**
786  * @dev Implementation of the {IERC20} interface.
787  *
788  * This implementation is agnostic to the way tokens are created. This means
789  * that a supply mechanism has to be added in a derived contract using {_mint}.
790  * For a generic mechanism see {ERC20PresetMinterPauser}.
791  *
792  * TIP: For a detailed writeup see our guide
793  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
794  * to implement supply mechanisms].
795  *
796  * We have followed general OpenZeppelin guidelines: functions revert instead
797  * of returning `false` on failure. This behavior is nonetheless conventional
798  * and does not conflict with the expectations of ERC20 applications.
799  *
800  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
801  * This allows applications to reconstruct the allowance for all accounts just
802  * by listening to said events. Other implementations of the EIP may not emit
803  * these events, as it isn't required by the specification.
804  *
805  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
806  * functions have been added to mitigate the well-known issues around setting
807  * allowances. See {IERC20-approve}.
808  */
809 contract ERC20 is Context, IERC20 {
810     using SafeMath for uint256;
811     using Address for address;
812 
813     mapping (address => uint256) private _balances;
814 
815     mapping (address => mapping (address => uint256)) private _allowances;
816 
817     uint256 private _totalSupply;
818 
819     string private _name;
820     string private _symbol;
821     uint8 private _decimals;
822 
823     /**
824      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
825      * a default value of 18.
826      *
827      * To select a different value for {decimals}, use {_setupDecimals}.
828      *
829      * All three of these values are immutable: they can only be set once during
830      * construction.
831      */
832     constructor (string memory name, string memory symbol) public {
833         _name = name;
834         _symbol = symbol;
835         _decimals = 18;
836     }
837 
838     /**
839      * @dev Returns the name of the token.
840      */
841     function name() public view returns (string memory) {
842         return _name;
843     }
844 
845     /**
846      * @dev Returns the symbol of the token, usually a shorter version of the
847      * name.
848      */
849     function symbol() public view returns (string memory) {
850         return _symbol;
851     }
852 
853     /**
854      * @dev Returns the number of decimals used to get its user representation.
855      * For example, if `decimals` equals `2`, a balance of `505` tokens should
856      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
857      *
858      * Tokens usually opt for a value of 18, imitating the relationship between
859      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
860      * called.
861      *
862      * NOTE: This information is only used for _display_ purposes: it in
863      * no way affects any of the arithmetic of the contract, including
864      * {IERC20-balanceOf} and {IERC20-transfer}.
865      */
866     function decimals() public view returns (uint8) {
867         return _decimals;
868     }
869 
870     /**
871      * @dev See {IERC20-totalSupply}.
872      */
873     function totalSupply() public view override returns (uint256) {
874         return _totalSupply;
875     }
876 
877     /**
878      * @dev See {IERC20-balanceOf}.
879      */
880     function balanceOf(address account) public view override returns (uint256) {
881         return _balances[account];
882     }
883 
884     /**
885      * @dev See {IERC20-transfer}.
886      *
887      * Requirements:
888      *
889      * - `recipient` cannot be the zero address.
890      * - the caller must have a balance of at least `amount`.
891      */
892     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
893         _transfer(_msgSender(), recipient, amount);
894         return true;
895     }
896 
897     /**
898      * @dev See {IERC20-allowance}.
899      */
900     function allowance(address owner, address spender) public view virtual override returns (uint256) {
901         return _allowances[owner][spender];
902     }
903 
904     /**
905      * @dev See {IERC20-approve}.
906      *
907      * Requirements:
908      *
909      * - `spender` cannot be the zero address.
910      */
911     function approve(address spender, uint256 amount) public virtual override returns (bool) {
912         _approve(_msgSender(), spender, amount);
913         return true;
914     }
915 
916     /**
917      * @dev See {IERC20-transferFrom}.
918      *
919      * Emits an {Approval} event indicating the updated allowance. This is not
920      * required by the EIP. See the note at the beginning of {ERC20};
921      *
922      * Requirements:
923      * - `sender` and `recipient` cannot be the zero address.
924      * - `sender` must have a balance of at least `amount`.
925      * - the caller must have allowance for ``sender``'s tokens of at least
926      * `amount`.
927      */
928     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
929         _transfer(sender, recipient, amount);
930         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
931         return true;
932     }
933 
934     /**
935      * @dev Atomically increases the allowance granted to `spender` by the caller.
936      *
937      * This is an alternative to {approve} that can be used as a mitigation for
938      * problems described in {IERC20-approve}.
939      *
940      * Emits an {Approval} event indicating the updated allowance.
941      *
942      * Requirements:
943      *
944      * - `spender` cannot be the zero address.
945      */
946     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
947         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
948         return true;
949     }
950 
951     /**
952      * @dev Atomically decreases the allowance granted to `spender` by the caller.
953      *
954      * This is an alternative to {approve} that can be used as a mitigation for
955      * problems described in {IERC20-approve}.
956      *
957      * Emits an {Approval} event indicating the updated allowance.
958      *
959      * Requirements:
960      *
961      * - `spender` cannot be the zero address.
962      * - `spender` must have allowance for the caller of at least
963      * `subtractedValue`.
964      */
965     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
966         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
967         return true;
968     }
969 
970     /**
971      * @dev Moves tokens `amount` from `sender` to `recipient`.
972      *
973      * This is internal function is equivalent to {transfer}, and can be used to
974      * e.g. implement automatic token fees, slashing mechanisms, etc.
975      *
976      * Emits a {Transfer} event.
977      *
978      * Requirements:
979      *
980      * - `sender` cannot be the zero address.
981      * - `recipient` cannot be the zero address.
982      * - `sender` must have a balance of at least `amount`.
983      */
984     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
985         require(sender != address(0), "ERC20: transfer from the zero address");
986         require(recipient != address(0), "ERC20: transfer to the zero address");
987 
988         _beforeTokenTransfer(sender, recipient, amount);
989 
990         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
991         _balances[recipient] = _balances[recipient].add(amount);
992         emit Transfer(sender, recipient, amount);
993     }
994 
995     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
996      * the total supply.
997      *
998      * Emits a {Transfer} event with `from` set to the zero address.
999      *
1000      * Requirements
1001      *
1002      * - `to` cannot be the zero address.
1003      */
1004     function _mint(address account, uint256 amount) internal virtual {
1005         require(account != address(0), "ERC20: mint to the zero address");
1006 
1007         _beforeTokenTransfer(address(0), account, amount);
1008 
1009         _totalSupply = _totalSupply.add(amount);
1010         _balances[account] = _balances[account].add(amount);
1011         emit Transfer(address(0), account, amount);
1012     }
1013 
1014     /**
1015      * @dev Destroys `amount` tokens from `account`, reducing the
1016      * total supply.
1017      *
1018      * Emits a {Transfer} event with `to` set to the zero address.
1019      *
1020      * Requirements
1021      *
1022      * - `account` cannot be the zero address.
1023      * - `account` must have at least `amount` tokens.
1024      */
1025     function _burn(address account, uint256 amount) internal virtual {
1026         require(account != address(0), "ERC20: burn from the zero address");
1027 
1028         _beforeTokenTransfer(account, address(0), amount);
1029 
1030         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1031         _totalSupply = _totalSupply.sub(amount);
1032         emit Transfer(account, address(0), amount);
1033     }
1034 
1035     /**
1036      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1037      *
1038      * This is internal function is equivalent to `approve`, and can be used to
1039      * e.g. set automatic allowances for certain subsystems, etc.
1040      *
1041      * Emits an {Approval} event.
1042      *
1043      * Requirements:
1044      *
1045      * - `owner` cannot be the zero address.
1046      * - `spender` cannot be the zero address.
1047      */
1048     function _approve(address owner, address spender, uint256 amount) internal virtual {
1049         require(owner != address(0), "ERC20: approve from the zero address");
1050         require(spender != address(0), "ERC20: approve to the zero address");
1051 
1052         _allowances[owner][spender] = amount;
1053         emit Approval(owner, spender, amount);
1054     }
1055 
1056     /**
1057      * @dev Sets {decimals} to a value other than the default one of 18.
1058      *
1059      * WARNING: This function should only be called from the constructor. Most
1060      * applications that interact with token contracts will not expect
1061      * {decimals} to ever change, and may work incorrectly if it does.
1062      */
1063     function _setupDecimals(uint8 decimals_) internal {
1064         _decimals = decimals_;
1065     }
1066 
1067     /**
1068      * @dev Hook that is called before any transfer of tokens. This includes
1069      * minting and burning.
1070      *
1071      * Calling conditions:
1072      *
1073      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1074      * will be to transferred to `to`.
1075      * - when `from` is zero, `amount` tokens will be minted for `to`.
1076      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1077      * - `from` and `to` are never both zero.
1078      *
1079      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1080      */
1081     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1082 }
1083 
1084 // File: contracts/GemToken.sol
1085 // GemToken with Governance.
1086 contract GemToken is ERC20("GemToken", "GEM"), Ownable {
1087     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterSmith).
1088     function mint(address _to, uint256 _amount) public onlyOwner {
1089         _mint(_to, _amount);
1090         _moveDelegates(address(0), _delegates[_to], _amount);
1091     }
1092 
1093     // Copied and modified from YAM code:
1094     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1095     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1096     // Which is copied and modified from COMPOUND:
1097     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1098 
1099     /// @notice A record of each accounts delegate
1100     mapping (address => address) internal _delegates;
1101 
1102     /// @notice A checkpoint for marking number of votes from a given block
1103     struct Checkpoint {
1104         uint32 fromBlock;
1105         uint256 votes;
1106     }
1107 
1108     /// @notice A record of votes checkpoints for each account, by index
1109     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1110 
1111     /// @notice The number of checkpoints for each account
1112     mapping (address => uint32) public numCheckpoints;
1113 
1114     /// @notice The EIP-712 typehash for the contract's domain
1115     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1116 
1117     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1118     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1119 
1120     /// @notice A record of states for signing / validating signatures
1121     mapping (address => uint) public nonces;
1122 
1123       /// @notice An event thats emitted when an account changes its delegate
1124     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1125 
1126     /// @notice An event thats emitted when a delegate account's vote balance changes
1127     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1128 
1129     /**
1130      * @notice Delegate votes from `msg.sender` to `delegatee`
1131      * @param delegator The address to get delegatee for
1132      */
1133     function delegates(address delegator)
1134         external
1135         view
1136         returns (address)
1137     {
1138         return _delegates[delegator];
1139     }
1140 
1141    /**
1142     * @notice Delegate votes from `msg.sender` to `delegatee`
1143     * @param delegatee The address to delegate votes to
1144     */
1145     function delegate(address delegatee) external {
1146         return _delegate(msg.sender, delegatee);
1147     }
1148 
1149     /**
1150      * @notice Delegates votes from signatory to `delegatee`
1151      * @param delegatee The address to delegate votes to
1152      * @param nonce The contract state required to match the signature
1153      * @param expiry The time at which to expire the signature
1154      * @param v The recovery byte of the signature
1155      * @param r Half of the ECDSA signature pair
1156      * @param s Half of the ECDSA signature pair
1157      */
1158     function delegateBySig(
1159         address delegatee,
1160         uint nonce,
1161         uint expiry,
1162         uint8 v,
1163         bytes32 r,
1164         bytes32 s
1165     )
1166         external
1167     {
1168         bytes32 domainSeparator = keccak256(
1169             abi.encode(
1170                 DOMAIN_TYPEHASH,
1171                 keccak256(bytes(name())),
1172                 getChainId(),
1173                 address(this)
1174             )
1175         );
1176 
1177         bytes32 structHash = keccak256(
1178             abi.encode(
1179                 DELEGATION_TYPEHASH,
1180                 delegatee,
1181                 nonce,
1182                 expiry
1183             )
1184         );
1185 
1186         bytes32 digest = keccak256(
1187             abi.encodePacked(
1188                 "\x19\x01",
1189                 domainSeparator,
1190                 structHash
1191             )
1192         );
1193 
1194         address signatory = ecrecover(digest, v, r, s);
1195         require(signatory != address(0), "GEM::delegateBySig: invalid signature");
1196         require(nonce == nonces[signatory]++, "GEM::delegateBySig: invalid nonce");
1197         require(now <= expiry, "GEM::delegateBySig: signature expired");
1198         return _delegate(signatory, delegatee);
1199     }
1200 
1201     /**
1202      * @notice Gets the current votes balance for `account`
1203      * @param account The address to get votes balance
1204      * @return The number of current votes for `account`
1205      */
1206     function getCurrentVotes(address account)
1207         external
1208         view
1209         returns (uint256)
1210     {
1211         uint32 nCheckpoints = numCheckpoints[account];
1212         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1213     }
1214 
1215     /**
1216      * @notice Determine the prior number of votes for an account as of a block number
1217      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1218      * @param account The address of the account to check
1219      * @param blockNumber The block number to get the vote balance at
1220      * @return The number of votes the account had as of the given block
1221      */
1222     function getPriorVotes(address account, uint blockNumber)
1223         external
1224         view
1225         returns (uint256)
1226     {
1227         require(blockNumber < block.number, "GEM::getPriorVotes: not yet determined");
1228 
1229         uint32 nCheckpoints = numCheckpoints[account];
1230         if (nCheckpoints == 0) {
1231             return 0;
1232         }
1233 
1234         // First check most recent balance
1235         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1236             return checkpoints[account][nCheckpoints - 1].votes;
1237         }
1238 
1239         // Next check implicit zero balance
1240         if (checkpoints[account][0].fromBlock > blockNumber) {
1241             return 0;
1242         }
1243 
1244         uint32 lower = 0;
1245         uint32 upper = nCheckpoints - 1;
1246         while (upper > lower) {
1247             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1248             Checkpoint memory cp = checkpoints[account][center];
1249             if (cp.fromBlock == blockNumber) {
1250                 return cp.votes;
1251             } else if (cp.fromBlock < blockNumber) {
1252                 lower = center;
1253             } else {
1254                 upper = center - 1;
1255             }
1256         }
1257         return checkpoints[account][lower].votes;
1258     }
1259 
1260     function _delegate(address delegator, address delegatee)
1261         internal
1262     {
1263         address currentDelegate = _delegates[delegator];
1264         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying GEMs (not scaled);
1265         _delegates[delegator] = delegatee;
1266 
1267         emit DelegateChanged(delegator, currentDelegate, delegatee);
1268 
1269         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1270     }
1271 
1272     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1273         if (srcRep != dstRep && amount > 0) {
1274             if (srcRep != address(0)) {
1275                 // decrease old representative
1276                 uint32 srcRepNum = numCheckpoints[srcRep];
1277                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1278                 uint256 srcRepNew = srcRepOld.sub(amount);
1279                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1280             }
1281 
1282             if (dstRep != address(0)) {
1283                 // increase new representative
1284                 uint32 dstRepNum = numCheckpoints[dstRep];
1285                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1286                 uint256 dstRepNew = dstRepOld.add(amount);
1287                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1288             }
1289         }
1290     }
1291 
1292     function _writeCheckpoint(
1293         address delegatee,
1294         uint32 nCheckpoints,
1295         uint256 oldVotes,
1296         uint256 newVotes
1297     )
1298         internal
1299     {
1300         uint32 blockNumber = safe32(block.number, "GEM::_writeCheckpoint: block number exceeds 32 bits");
1301 
1302         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1303             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1304         } else {
1305             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1306             numCheckpoints[delegatee] = nCheckpoints + 1;
1307         }
1308 
1309         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1310     }
1311 
1312     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1313         require(n < 2**32, errorMessage);
1314         return uint32(n);
1315     }
1316 
1317     function getChainId() internal pure returns (uint) {
1318         uint256 chainId;
1319         assembly { chainId := chainid() }
1320         return chainId;
1321     }
1322 }
1323 
1324 // File: contracts/MasterSmith.sol
1325 interface IMigratorSmith {
1326     // Perform LP token migration from legacy UniswapV2 to GemSwap.
1327     // Take the current LP token address and return the new LP token address.
1328     // Migrator should have full access to the caller's LP token.
1329     // Return the new LP token address.
1330     //
1331     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1332     // GemSwap must mint EXACTLY the same amount of GemSwap LP tokens or
1333     // else something bad will happen. Traditional UniswapV2 does not
1334     // do that so be careful!
1335     function migrate(IERC20 token) external returns (IERC20);
1336 }
1337 
1338 // MasterSmith is the master of Gem. He can make Gem and he is a fair guy.
1339 //
1340 // Note that it's ownable and the owner wields tremendous power. The ownership
1341 // will be transferred to a governance smart contract once GEM is sufficiently
1342 // distributed and the community can show to govern itself.
1343 //
1344 // Have fun reading it. Hopefully it's bug-free. God bless.
1345 contract MasterSmith is Ownable {
1346     using SafeMath for uint256;
1347     using SafeERC20 for IERC20;
1348 
1349     // Info of each user.
1350     struct UserInfo {
1351         uint256 amount;     // How many LP tokens the user has provided.
1352         uint256 rewardDebt; // Reward debt. See explanation below.
1353         //
1354         // We do some fancy math here. Basically, any point in time, the amount of GEMs
1355         // entitled to a user but is pending to be distributed is:
1356         //
1357         //   pending reward = (user.amount * pool.accGemPerShare) - user.rewardDebt
1358         //
1359         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1360         //   1. The pool's `accGemPerShare` (and `lastRewardBlock`) gets updated.
1361         //   2. User receives the pending reward sent to his/her address.
1362         //   3. User's `amount` gets updated.
1363         //   4. User's `rewardDebt` gets updated.
1364     }
1365 
1366     // Info of each pool.
1367     struct PoolInfo {
1368         IERC20 lpToken;           // Address of LP token contract.
1369         uint256 allocPoint;       // How many allocation points assigned to this pool. GEMs to distribute per block.
1370         uint256 lastRewardBlock;  // Last block number that GEMs distribution occurs.
1371         uint256 accGemPerShare; // Accumulated GEMs per share, times 1e12. See below.
1372     }
1373 
1374     // The GEM TOKEN!
1375     GemToken public gem;
1376     // Block number when bonus GEM period ends.
1377     uint256 public rewardEndBlock;
1378     // GEM tokens created per block.
1379     uint256 public gemPerBlock;
1380     // Bonus muliplier for early gem makers.
1381     uint256 public constant REWARD_MULTIPLIER = 1;
1382     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1383     IMigratorSmith public migrator;
1384 
1385     // Info of each pool.
1386     PoolInfo[] public poolInfo;
1387     // Info of each user that stakes LP tokens.
1388     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1389     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1390     uint256 public totalAllocPoint = 0;
1391     // The block number when GEM mining starts.
1392     uint256 public startBlock;
1393 
1394     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1395     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1396     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1397 
1398     constructor(
1399         GemToken _gem,
1400         uint256 _gemPerBlock,
1401         uint256 _startBlock,
1402         uint256 _rewardEndBlock
1403     ) public {
1404         gem = _gem;
1405         gemPerBlock = _gemPerBlock;
1406         rewardEndBlock = _rewardEndBlock;
1407         startBlock = _startBlock;
1408     }
1409 
1410     function poolLength() external view returns (uint256) {
1411         return poolInfo.length;
1412     }
1413 
1414     // Add a new lp to the pool. Can only be called by the owner.
1415     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1416     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1417         if (_withUpdate) {
1418             massUpdatePools();
1419         }
1420         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1421         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1422         poolInfo.push(PoolInfo({
1423             lpToken: _lpToken,
1424             allocPoint: _allocPoint,
1425             lastRewardBlock: lastRewardBlock,
1426             accGemPerShare: 0
1427         }));
1428     }
1429 
1430     // Update the given pool's GEM allocation point. Can only be called by the owner.
1431     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1432         if (_withUpdate) {
1433             massUpdatePools();
1434         }
1435         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1436         poolInfo[_pid].allocPoint = _allocPoint;
1437     }
1438 
1439     // Set the migrator contract. Can only be called by the owner.
1440     function setMigrator(IMigratorSmith _migrator) public onlyOwner {
1441         migrator = _migrator;
1442     }
1443 
1444     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1445     function migrate(uint256 _pid) public {
1446         require(address(migrator) != address(0), "migrate: no migrator");
1447         PoolInfo storage pool = poolInfo[_pid];
1448         IERC20 lpToken = pool.lpToken;
1449         uint256 bal = lpToken.balanceOf(address(this));
1450         lpToken.safeApprove(address(migrator), bal);
1451         IERC20 newLpToken = migrator.migrate(lpToken);
1452         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1453         pool.lpToken = newLpToken;
1454     }
1455 
1456     // Return reward multiplier over the given _from to _to block.
1457     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1458         if (_to <= rewardEndBlock) {
1459             return _to.sub(_from).mul(REWARD_MULTIPLIER);
1460         } else if (_from >= rewardEndBlock) {
1461             return 0;
1462         } else {
1463             return rewardEndBlock.sub(_from).mul(REWARD_MULTIPLIER);
1464         }
1465     }
1466 
1467     // View function to see pending GEMs on frontend.
1468     function pendingGem(uint256 _pid, address _user) external view returns (uint256) {
1469         PoolInfo storage pool = poolInfo[_pid];
1470         UserInfo storage user = userInfo[_pid][_user];
1471         uint256 accGemPerShare = pool.accGemPerShare;
1472         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1473         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1474             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1475             uint256 gemReward = multiplier.mul(gemPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1476             accGemPerShare = accGemPerShare.add(gemReward.mul(1e12).div(lpSupply));
1477         }
1478         return user.amount.mul(accGemPerShare).div(1e12).sub(user.rewardDebt);
1479     }
1480 
1481     // Update reward vairables for all pools. Be careful of gas spending!
1482     function massUpdatePools() public {
1483         uint256 length = poolInfo.length;
1484         for (uint256 pid = 0; pid < length; ++pid) {
1485             updatePool(pid);
1486         }
1487     }
1488 
1489     // Update reward variables of the given pool to be up-to-date.
1490     function updatePool(uint256 _pid) public {
1491         PoolInfo storage pool = poolInfo[_pid];
1492         if (block.number <= pool.lastRewardBlock) {
1493             return;
1494         }
1495         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1496         if (lpSupply == 0) {
1497             pool.lastRewardBlock = block.number;
1498             return;
1499         }
1500         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1501         uint256 gemReward = multiplier.mul(gemPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1502         gem.mint(address(this), gemReward);
1503         pool.accGemPerShare = pool.accGemPerShare.add(gemReward.mul(1e12).div(lpSupply));
1504         pool.lastRewardBlock = block.number;
1505     }
1506 
1507     // Deposit LP tokens to MasterSmith for GEM allocation.
1508     function deposit(uint256 _pid, uint256 _amount) public {
1509         PoolInfo storage pool = poolInfo[_pid];
1510         UserInfo storage user = userInfo[_pid][msg.sender];
1511         updatePool(_pid);
1512         if (user.amount > 0) {
1513             uint256 pending = user.amount.mul(pool.accGemPerShare).div(1e12).sub(user.rewardDebt);
1514             safeGemTransfer(msg.sender, pending);
1515         }
1516         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1517         user.amount = user.amount.add(_amount);
1518         user.rewardDebt = user.amount.mul(pool.accGemPerShare).div(1e12);
1519         emit Deposit(msg.sender, _pid, _amount);
1520     }
1521 
1522     // Withdraw LP tokens from MasterSmith.
1523     function withdraw(uint256 _pid, uint256 _amount) public {
1524         PoolInfo storage pool = poolInfo[_pid];
1525         UserInfo storage user = userInfo[_pid][msg.sender];
1526         require(user.amount >= _amount, "withdraw: not good");
1527         updatePool(_pid);
1528         uint256 pending = user.amount.mul(pool.accGemPerShare).div(1e12).sub(user.rewardDebt);
1529         safeGemTransfer(msg.sender, pending);
1530         user.amount = user.amount.sub(_amount);
1531         user.rewardDebt = user.amount.mul(pool.accGemPerShare).div(1e12);
1532         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1533         emit Withdraw(msg.sender, _pid, _amount);
1534     }
1535 
1536     // Withdraw without caring about rewards. EMERGENCY ONLY.
1537     function emergencyWithdraw(uint256 _pid) public {
1538         PoolInfo storage pool = poolInfo[_pid];
1539         UserInfo storage user = userInfo[_pid][msg.sender];
1540         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1541         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1542         user.amount = 0;
1543         user.rewardDebt = 0;
1544     }
1545 
1546     // Safe gem transfer function, just in case if rounding error causes pool to not have enough GEMs.
1547     function safeGemTransfer(address _to, uint256 _amount) internal {
1548         uint256 gemBal = gem.balanceOf(address(this));
1549         if (_amount > gemBal) {
1550             gem.transfer(_to, gemBal);
1551         } else {
1552             gem.transfer(_to, _amount);
1553         }
1554     }
1555 }