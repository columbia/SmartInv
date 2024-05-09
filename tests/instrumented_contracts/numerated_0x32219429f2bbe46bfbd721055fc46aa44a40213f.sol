1 // NovaDefi.com
2 
3 // SPDX-License-Identifier: MIT
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 
6 
7 
8 pragma solidity ^0.6.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // File: @openzeppelin/contracts/math/SafeMath.sol
85 
86 
87 
88 pragma solidity ^0.6.0;
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `+` operator.
109      *
110      * Requirements:
111      *
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b <= a, errorMessage);
147         uint256 c = a - b;
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `*` operator.
157      *
158      * Requirements:
159      *
160      * - Multiplication cannot overflow.
161      */
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164         // benefit is lost if 'b' is also tested.
165         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166         if (a == 0) {
167             return 0;
168         }
169 
170         uint256 c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         return div(a, b, "SafeMath: division by zero");
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b > 0, errorMessage);
206         uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225         return mod(a, b, "SafeMath: modulo by zero");
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts with custom message when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b != 0, errorMessage);
242         return a % b;
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 
250 pragma solidity ^0.6.2;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
391 
392 
393 
394 pragma solidity ^0.6.0;
395 
396 
397 
398 
399 /**
400  * @title SafeERC20
401  * @dev Wrappers around ERC20 operations that throw on failure (when the token
402  * contract returns false). Tokens that return no value (and instead revert or
403  * throw on failure) are also supported, non-reverting calls are assumed to be
404  * successful.
405  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
406  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
407  */
408 library SafeERC20 {
409     using SafeMath for uint256;
410     using Address for address;
411 
412     function safeTransfer(IERC20 token, address to, uint256 value) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
414     }
415 
416     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
417         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
418     }
419 
420     /**
421      * @dev Deprecated. This function has issues similar to the ones found in
422      * {IERC20-approve}, and its usage is discouraged.
423      *
424      * Whenever possible, use {safeIncreaseAllowance} and
425      * {safeDecreaseAllowance} instead.
426      */
427     function safeApprove(IERC20 token, address spender, uint256 value) internal {
428         // safeApprove should only be called when setting an initial allowance,
429         // or when resetting it to zero. To increase and decrease it, use
430         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
431         // solhint-disable-next-line max-line-length
432         require((value == 0) || (token.allowance(address(this), spender) == 0),
433             "SafeERC20: approve from non-zero to non-zero allowance"
434         );
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
436     }
437 
438     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
439         uint256 newAllowance = token.allowance(address(this), spender).add(value);
440         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
441     }
442 
443     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
444         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
445         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
446     }
447 
448     /**
449      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
450      * on the return value: the return value is optional (but if data is returned, it must not be false).
451      * @param token The token targeted by the call.
452      * @param data The call data (encoded using abi.encode or one of its variants).
453      */
454     function _callOptionalReturn(IERC20 token, bytes memory data) private {
455         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
456         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
457         // the target address contains contract code and also asserts for success in the low-level call.
458 
459         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
460         if (returndata.length > 0) { // Return data is optional
461             // solhint-disable-next-line max-line-length
462             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
468 
469 
470 
471 pragma solidity ^0.6.0;
472 
473 /**
474  * @dev Library for managing
475  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
476  * types.
477  *
478  * Sets have the following properties:
479  *
480  * - Elements are added, removed, and checked for existence in constant time
481  * (O(1)).
482  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
483  *
484  * ```
485  * contract Example {
486  *     // Add the library methods
487  *     using EnumerableSet for EnumerableSet.AddressSet;
488  *
489  *     // Declare a set state variable
490  *     EnumerableSet.AddressSet private mySet;
491  * }
492  * ```
493  *
494  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
495  * (`UintSet`) are supported.
496  */
497 library EnumerableSet {
498     // To implement this library for multiple types with as little code
499     // repetition as possible, we write it in terms of a generic Set type with
500     // bytes32 values.
501     // The Set implementation uses private functions, and user-facing
502     // implementations (such as AddressSet) are just wrappers around the
503     // underlying Set.
504     // This means that we can only create new EnumerableSets for types that fit
505     // in bytes32.
506 
507     struct Set {
508         // Storage of set values
509         bytes32[] _values;
510 
511         // Position of the value in the `values` array, plus 1 because index 0
512         // means a value is not in the set.
513         mapping (bytes32 => uint256) _indexes;
514     }
515 
516     /**
517      * @dev Add a value to a set. O(1).
518      *
519      * Returns true if the value was added to the set, that is if it was not
520      * already present.
521      */
522     function _add(Set storage set, bytes32 value) private returns (bool) {
523         if (!_contains(set, value)) {
524             set._values.push(value);
525             // The value is stored at length-1, but we add 1 to all indexes
526             // and use 0 as a sentinel value
527             set._indexes[value] = set._values.length;
528             return true;
529         } else {
530             return false;
531         }
532     }
533 
534     /**
535      * @dev Removes a value from a set. O(1).
536      *
537      * Returns true if the value was removed from the set, that is if it was
538      * present.
539      */
540     function _remove(Set storage set, bytes32 value) private returns (bool) {
541         // We read and store the value's index to prevent multiple reads from the same storage slot
542         uint256 valueIndex = set._indexes[value];
543 
544         if (valueIndex != 0) { // Equivalent to contains(set, value)
545             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
546             // the array, and then remove the last element (sometimes called as 'swap and pop').
547             // This modifies the order of the array, as noted in {at}.
548 
549             uint256 toDeleteIndex = valueIndex - 1;
550             uint256 lastIndex = set._values.length - 1;
551 
552             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
553             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
554 
555             bytes32 lastvalue = set._values[lastIndex];
556 
557             // Move the last value to the index where the value to delete is
558             set._values[toDeleteIndex] = lastvalue;
559             // Update the index for the moved value
560             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
561 
562             // Delete the slot where the moved value was stored
563             set._values.pop();
564 
565             // Delete the index for the deleted slot
566             delete set._indexes[value];
567 
568             return true;
569         } else {
570             return false;
571         }
572     }
573 
574     /**
575      * @dev Returns true if the value is in the set. O(1).
576      */
577     function _contains(Set storage set, bytes32 value) private view returns (bool) {
578         return set._indexes[value] != 0;
579     }
580 
581     /**
582      * @dev Returns the number of values on the set. O(1).
583      */
584     function _length(Set storage set) private view returns (uint256) {
585         return set._values.length;
586     }
587 
588    /**
589     * @dev Returns the value stored at position `index` in the set. O(1).
590     *
591     * Note that there are no guarantees on the ordering of values inside the
592     * array, and it may change when more values are added or removed.
593     *
594     * Requirements:
595     *
596     * - `index` must be strictly less than {length}.
597     */
598     function _at(Set storage set, uint256 index) private view returns (bytes32) {
599         require(set._values.length > index, "EnumerableSet: index out of bounds");
600         return set._values[index];
601     }
602 
603     // AddressSet
604 
605     struct AddressSet {
606         Set _inner;
607     }
608 
609     /**
610      * @dev Add a value to a set. O(1).
611      *
612      * Returns true if the value was added to the set, that is if it was not
613      * already present.
614      */
615     function add(AddressSet storage set, address value) internal returns (bool) {
616         return _add(set._inner, bytes32(uint256(value)));
617     }
618 
619     /**
620      * @dev Removes a value from a set. O(1).
621      *
622      * Returns true if the value was removed from the set, that is if it was
623      * present.
624      */
625     function remove(AddressSet storage set, address value) internal returns (bool) {
626         return _remove(set._inner, bytes32(uint256(value)));
627     }
628 
629     /**
630      * @dev Returns true if the value is in the set. O(1).
631      */
632     function contains(AddressSet storage set, address value) internal view returns (bool) {
633         return _contains(set._inner, bytes32(uint256(value)));
634     }
635 
636     /**
637      * @dev Returns the number of values in the set. O(1).
638      */
639     function length(AddressSet storage set) internal view returns (uint256) {
640         return _length(set._inner);
641     }
642 
643    /**
644     * @dev Returns the value stored at position `index` in the set. O(1).
645     *
646     * Note that there are no guarantees on the ordering of values inside the
647     * array, and it may change when more values are added or removed.
648     *
649     * Requirements:
650     *
651     * - `index` must be strictly less than {length}.
652     */
653     function at(AddressSet storage set, uint256 index) internal view returns (address) {
654         return address(uint256(_at(set._inner, index)));
655     }
656 
657 
658     // UintSet
659 
660     struct UintSet {
661         Set _inner;
662     }
663 
664     /**
665      * @dev Add a value to a set. O(1).
666      *
667      * Returns true if the value was added to the set, that is if it was not
668      * already present.
669      */
670     function add(UintSet storage set, uint256 value) internal returns (bool) {
671         return _add(set._inner, bytes32(value));
672     }
673 
674     /**
675      * @dev Removes a value from a set. O(1).
676      *
677      * Returns true if the value was removed from the set, that is if it was
678      * present.
679      */
680     function remove(UintSet storage set, uint256 value) internal returns (bool) {
681         return _remove(set._inner, bytes32(value));
682     }
683 
684     /**
685      * @dev Returns true if the value is in the set. O(1).
686      */
687     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
688         return _contains(set._inner, bytes32(value));
689     }
690 
691     /**
692      * @dev Returns the number of values on the set. O(1).
693      */
694     function length(UintSet storage set) internal view returns (uint256) {
695         return _length(set._inner);
696     }
697 
698    /**
699     * @dev Returns the value stored at position `index` in the set. O(1).
700     *
701     * Note that there are no guarantees on the ordering of values inside the
702     * array, and it may change when more values are added or removed.
703     *
704     * Requirements:
705     *
706     * - `index` must be strictly less than {length}.
707     */
708     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
709         return uint256(_at(set._inner, index));
710     }
711 }
712 
713 // File: @openzeppelin/contracts/GSN/Context.sol
714 
715 
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
743 
744 pragma solidity ^0.6.0;
745 
746 /**
747  * @dev Contract module which provides a basic access control mechanism, where
748  * there is an account (an owner) that can be granted exclusive access to
749  * specific functions.
750  *
751  * By default, the owner account will be the one that deploys the contract. This
752  * can later be changed with {transferOwnership}.
753  *
754  * This module is used through inheritance. It will make available the modifier
755  * `onlyOwner`, which can be applied to your functions to restrict their use to
756  * the owner.
757  */
758 contract Ownable is Context {
759     address private _owner;
760 
761     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
762 
763     /**
764      * @dev Initializes the contract setting the deployer as the initial owner.
765      */
766     constructor () internal {
767         address msgSender = _msgSender();
768         _owner = msgSender;
769         emit OwnershipTransferred(address(0), msgSender);
770     }
771 
772     /**
773      * @dev Returns the address of the current owner.
774      */
775     function owner() public view returns (address) {
776         return _owner;
777     }
778 
779     /**
780      * @dev Throws if called by any account other than the owner.
781      */
782     modifier onlyOwner() {
783         require(_owner == _msgSender(), "Ownable: caller is not the owner");
784         _;
785     }
786 
787     /**
788      * @dev Leaves the contract without owner. It will not be possible to call
789      * `onlyOwner` functions anymore. Can only be called by the current owner.
790      *
791      * NOTE: Renouncing ownership will leave the contract without an owner,
792      * thereby removing any functionality that is only available to the owner.
793      */
794     function renounceOwnership() public virtual onlyOwner {
795         emit OwnershipTransferred(_owner, address(0));
796         _owner = address(0);
797     }
798 
799     /**
800      * @dev Transfers ownership of the contract to a new account (`newOwner`).
801      * Can only be called by the current owner.
802      */
803     function transferOwnership(address newOwner) public virtual onlyOwner {
804         require(newOwner != address(0), "Ownable: new owner is the zero address");
805         emit OwnershipTransferred(_owner, newOwner);
806         _owner = newOwner;
807     }
808 }
809 
810 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
811 
812 
813 
814 pragma solidity ^0.6.0;
815 
816 
817 
818 
819 
820 /**
821  * @dev Implementation of the {IERC20} interface.
822  *
823  * This implementation is agnostic to the way tokens are created. This means
824  * that a supply mechanism has to be added in a derived contract using {_mint}.
825  * For a generic mechanism see {ERC20PresetMinterPauser}.
826  *
827  * TIP: For a detailed writeup see our guide
828  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
829  * to implement supply mechanisms].
830  *
831  * We have followed general OpenZeppelin guidelines: functions revert instead
832  * of returning `false` on failure. This behavior is nonetheless conventional
833  * and does not conflict with the expectations of ERC20 applications.
834  *
835  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
836  * This allows applications to reconstruct the allowance for all accounts just
837  * by listening to said events. Other implementations of the EIP may not emit
838  * these events, as it isn't required by the specification.
839  *
840  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
841  * functions have been added to mitigate the well-known issues around setting
842  * allowances. See {IERC20-approve}.
843  */
844 contract ERC20 is Context, IERC20 {
845     using SafeMath for uint256;
846     using Address for address;
847 
848     mapping (address => uint256) private _balances;
849 
850     mapping (address => mapping (address => uint256)) private _allowances;
851 
852     uint256 private _totalSupply;
853 
854     string private _name;
855     string private _symbol;
856     uint8 private _decimals;
857 
858     /**
859      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
860      * a default value of 18.
861      *
862      * To select a different value for {decimals}, use {_setupDecimals}.
863      *
864      * All three of these values are immutable: they can only be set once during
865      * construction.
866      */
867     constructor (string memory name, string memory symbol) public {
868         _name = name;
869         _symbol = symbol;
870         _decimals = 18;
871     }
872 
873     /**
874      * @dev Returns the name of the token.
875      */
876     function name() public view returns (string memory) {
877         return _name;
878     }
879 
880     /**
881      * @dev Returns the symbol of the token, usually a shorter version of the
882      * name.
883      */
884     function symbol() public view returns (string memory) {
885         return _symbol;
886     }
887 
888     /**
889      * @dev Returns the number of decimals used to get its user representation.
890      * For example, if `decimals` equals `2`, a balance of `505` tokens should
891      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
892      *
893      * Tokens usually opt for a value of 18, imitating the relationship between
894      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
895      * called.
896      *
897      * NOTE: This information is only used for _display_ purposes: it in
898      * no way affects any of the arithmetic of the contract, including
899      * {IERC20-balanceOf} and {IERC20-transfer}.
900      */
901     function decimals() public view returns (uint8) {
902         return _decimals;
903     }
904 
905     /**
906      * @dev See {IERC20-totalSupply}.
907      */
908     function totalSupply() public view override returns (uint256) {
909         return _totalSupply;
910     }
911 
912     /**
913      * @dev See {IERC20-balanceOf}.
914      */
915     function balanceOf(address account) public view override returns (uint256) {
916         return _balances[account];
917     }
918 
919     /**
920      * @dev See {IERC20-transfer}.
921      *
922      * Requirements:
923      *
924      * - `recipient` cannot be the zero address.
925      * - the caller must have a balance of at least `amount`.
926      */
927     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
928         _transfer(_msgSender(), recipient, amount);
929         return true;
930     }
931 
932     /**
933      * @dev See {IERC20-allowance}.
934      */
935     function allowance(address owner, address spender) public view virtual override returns (uint256) {
936         return _allowances[owner][spender];
937     }
938 
939     /**
940      * @dev See {IERC20-approve}.
941      *
942      * Requirements:
943      *
944      * - `spender` cannot be the zero address.
945      */
946     function approve(address spender, uint256 amount) public virtual override returns (bool) {
947         _approve(_msgSender(), spender, amount);
948         return true;
949     }
950 
951     /**
952      * @dev See {IERC20-transferFrom}.
953      *
954      * Emits an {Approval} event indicating the updated allowance. This is not
955      * required by the EIP. See the note at the beginning of {ERC20};
956      *
957      * Requirements:
958      * - `sender` and `recipient` cannot be the zero address.
959      * - `sender` must have a balance of at least `amount`.
960      * - the caller must have allowance for ``sender``'s tokens of at least
961      * `amount`.
962      */
963     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
964         _transfer(sender, recipient, amount);
965         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
966         return true;
967     }
968 
969     /**
970      * @dev Atomically increases the allowance granted to `spender` by the caller.
971      *
972      * This is an alternative to {approve} that can be used as a mitigation for
973      * problems described in {IERC20-approve}.
974      *
975      * Emits an {Approval} event indicating the updated allowance.
976      *
977      * Requirements:
978      *
979      * - `spender` cannot be the zero address.
980      */
981     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
982         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
983         return true;
984     }
985 
986     /**
987      * @dev Atomically decreases the allowance granted to `spender` by the caller.
988      *
989      * This is an alternative to {approve} that can be used as a mitigation for
990      * problems described in {IERC20-approve}.
991      *
992      * Emits an {Approval} event indicating the updated allowance.
993      *
994      * Requirements:
995      *
996      * - `spender` cannot be the zero address.
997      * - `spender` must have allowance for the caller of at least
998      * `subtractedValue`.
999      */
1000     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1001         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1002         return true;
1003     }
1004 
1005     /**
1006      * @dev Moves tokens `amount` from `sender` to `recipient`.
1007      *
1008      * This is internal function is equivalent to {transfer}, and can be used to
1009      * e.g. implement automatic token fees, slashing mechanisms, etc.
1010      *
1011      * Emits a {Transfer} event.
1012      *
1013      * Requirements:
1014      *
1015      * - `sender` cannot be the zero address.
1016      * - `recipient` cannot be the zero address.
1017      * - `sender` must have a balance of at least `amount`.
1018      */
1019     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1020         require(sender != address(0), "ERC20: transfer from the zero address");
1021         require(recipient != address(0), "ERC20: transfer to the zero address");
1022 
1023         _beforeTokenTransfer(sender, recipient, amount);
1024 
1025         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1026         _balances[recipient] = _balances[recipient].add(amount);
1027         emit Transfer(sender, recipient, amount);
1028     }
1029 
1030     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1031      * the total supply.
1032      *
1033      * Emits a {Transfer} event with `from` set to the zero address.
1034      *
1035      * Requirements
1036      *
1037      * - `to` cannot be the zero address.
1038      */
1039     function _mint(address account, uint256 amount) internal virtual {
1040         require(account != address(0), "ERC20: mint to the zero address");
1041 
1042         _beforeTokenTransfer(address(0), account, amount);
1043 
1044         _totalSupply = _totalSupply.add(amount);
1045         _balances[account] = _balances[account].add(amount);
1046         emit Transfer(address(0), account, amount);
1047     }
1048 
1049     /**
1050      * @dev Destroys `amount` tokens from `account`, reducing the
1051      * total supply.
1052      *
1053      * Emits a {Transfer} event with `to` set to the zero address.
1054      *
1055      * Requirements
1056      *
1057      * - `account` cannot be the zero address.
1058      * - `account` must have at least `amount` tokens.
1059      */
1060     function _burn(address account, uint256 amount) internal virtual {
1061         require(account != address(0), "ERC20: burn from the zero address");
1062 
1063         _beforeTokenTransfer(account, address(0), amount);
1064 
1065         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1066         _totalSupply = _totalSupply.sub(amount);
1067         emit Transfer(account, address(0), amount);
1068     }
1069 
1070     /**
1071      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1072      *
1073      * This is internal function is equivalent to `approve`, and can be used to
1074      * e.g. set automatic allowances for certain subsystems, etc.
1075      *
1076      * Emits an {Approval} event.
1077      *
1078      * Requirements:
1079      *
1080      * - `owner` cannot be the zero address.
1081      * - `spender` cannot be the zero address.
1082      */
1083     function _approve(address owner, address spender, uint256 amount) internal virtual {
1084         require(owner != address(0), "ERC20: approve from the zero address");
1085         require(spender != address(0), "ERC20: approve to the zero address");
1086 
1087         _allowances[owner][spender] = amount;
1088         emit Approval(owner, spender, amount);
1089     }
1090 
1091     /**
1092      * @dev Sets {decimals} to a value other than the default one of 18.
1093      *
1094      * WARNING: This function should only be called from the constructor. Most
1095      * applications that interact with token contracts will not expect
1096      * {decimals} to ever change, and may work incorrectly if it does.
1097      */
1098     function _setupDecimals(uint8 decimals_) internal {
1099         _decimals = decimals_;
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before any transfer of tokens. This includes
1104      * minting and burning.
1105      *
1106      * Calling conditions:
1107      *
1108      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1109      * will be to transferred to `to`.
1110      * - when `from` is zero, `amount` tokens will be minted for `to`.
1111      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1112      * - `from` and `to` are never both zero.
1113      *
1114      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1115      */
1116     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1117 }
1118 
1119 // File: contracts/NovaToken.sol
1120 
1121 pragma solidity 0.6.12;
1122 
1123 
1124 
1125 
1126 // NovaToken with Governance.
1127 contract NovaToken is ERC20("NovaToken", "NOVA"), Ownable {
1128     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1129     function mint(address _to, uint256 _amount) public onlyOwner {
1130         _mint(_to, _amount);
1131     }
1132 }
1133 
1134 // File: contracts/curve/ICurveFiCurve.sol
1135 
1136 pragma solidity ^0.6.12;
1137 
1138 interface ICurveFiCurve {
1139     // All we care about is the ratio of each coin
1140     function balances(int128 arg0) external returns (uint256 out);
1141 }
1142 
1143 // File: contracts/MasterChef.sol
1144 
1145 pragma solidity 0.6.12;
1146 
1147 
1148 
1149 
1150 
1151 
1152 
1153 
1154 // MasterChef was the master of nova. He now governs over NOVAS. He can make Novas and he is a fair guy.
1155 //
1156 // Note that it's ownable and the owner wields tremendous power. The ownership
1157 // will be transferred to a governance smart contract once NOVAS is sufficiently
1158 // distributed and the community can show to govern itself.
1159 //
1160 // Have fun reading it. Hopefully it's bug-free. God bless.
1161 contract MasterChef is Ownable {
1162     using SafeMath for uint256;
1163     using SafeERC20 for IERC20;
1164 
1165     // Info of each user.
1166     struct UserInfo {
1167         uint256 amount; // How many LP tokens the user has provided.
1168         uint256 rewardDebt; // Reward debt. See explanation below.
1169         //
1170         // We do some fancy math here. Basically, any point in time, the amount of NOVAs
1171         // entitled to a user but is pending to be distributed is:
1172         //
1173         //   pending reward = (user.amount * pool.accNovaPerShare) - user.rewardDebt
1174         //
1175         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1176         //   1. The pool's `accNovaPerShare` (and `lastRewardBlock`) gets updated.
1177         //   2. User receives the pending reward sent to his/her address.
1178         //   3. User's `amount` gets updated.
1179         //   4. User's `rewardDebt` gets updated.
1180     }
1181 
1182     // Info of each pool.
1183     struct PoolInfo {
1184         IERC20 lpToken; // Address of LP token contract.
1185         uint256 allocPoint; // How many allocation points assigned to this pool. NOVAs to distribute per block.
1186         uint256 lastRewardBlock; // Last block number that NOVAs distribution occurs.
1187         uint256 accNovaPerShare; // Accumulated NOVAs per share, times 1e12. See below.
1188     }
1189 
1190     // The NOVA TOKEN!
1191     NovaToken public nova;
1192     // Dev fund (2%, initially)
1193     uint256 public devFundDivRate = 25;
1194     // Dev address.
1195     address public devaddr;
1196     // Block number when bonus NOVA period ends.
1197     uint256 public bonusEndBlock;
1198     // NOVA tokens created per block.
1199     uint256 public novaPerBlock;
1200     // Bonus muliplier for early nova makers.
1201     uint256 public constant BONUS_MULTIPLIER = 10;
1202 
1203     // Info of each pool.
1204     PoolInfo[] public poolInfo;
1205     // Info of each user that stakes LP tokens.
1206     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1207     // Total allocation points. Must be the sum of all allocation points in all pools.
1208     uint256 public totalAllocPoint = 0;
1209     // The block number when NOVA mining starts.
1210     uint256 public startBlock;
1211 
1212     // Events
1213     event Recovered(address token, uint256 amount);
1214     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1215     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1216     event EmergencyWithdraw(
1217         address indexed user,
1218         uint256 indexed pid,
1219         uint256 amount
1220     );
1221 
1222     constructor(
1223         NovaToken _nova,
1224         address _devaddr,
1225         uint256 _novaPerBlock,
1226         uint256 _startBlock,
1227         uint256 _bonusEndBlock
1228     ) public {
1229         nova = _nova;
1230         devaddr = _devaddr;
1231         novaPerBlock = _novaPerBlock;
1232         bonusEndBlock = _bonusEndBlock;
1233         startBlock = _startBlock;
1234     }
1235 
1236     function poolLength() external view returns (uint256) {
1237         return poolInfo.length;
1238     }
1239 
1240     // Add a new lp to the pool. Can only be called by the owner.
1241     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1242     function add(
1243         uint256 _allocPoint,
1244         IERC20 _lpToken,
1245         bool _withUpdate
1246     ) public onlyOwner {
1247         if (_withUpdate) {
1248             massUpdatePools();
1249         }
1250         uint256 lastRewardBlock = block.number > startBlock
1251             ? block.number
1252             : startBlock;
1253         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1254         poolInfo.push(
1255             PoolInfo({
1256                 lpToken: _lpToken,
1257                 allocPoint: _allocPoint,
1258                 lastRewardBlock: lastRewardBlock,
1259                 accNovaPerShare: 0
1260             })
1261         );
1262     }
1263 
1264     // Update the given pool's NOVA allocation point. Can only be called by the owner.
1265     function set(
1266         uint256 _pid,
1267         uint256 _allocPoint,
1268         bool _withUpdate
1269     ) public onlyOwner {
1270         if (_withUpdate) {
1271             massUpdatePools();
1272         }
1273         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1274             _allocPoint
1275         );
1276         poolInfo[_pid].allocPoint = _allocPoint;
1277     }
1278 
1279     // Return reward multiplier over the given _from to _to block.
1280     function getMultiplier(uint256 _from, uint256 _to)
1281         public
1282         view
1283         returns (uint256)
1284     {
1285         if (_to <= bonusEndBlock) {
1286             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1287         } else if (_from >= bonusEndBlock) {
1288             return _to.sub(_from);
1289         } else {
1290             return
1291                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1292                     _to.sub(bonusEndBlock)
1293                 );
1294         }
1295     }
1296 
1297     // View function to see pending NOVAs on frontend.
1298     function pendingNova(uint256 _pid, address _user)
1299         external
1300         view
1301         returns (uint256)
1302     {
1303         PoolInfo storage pool = poolInfo[_pid];
1304         UserInfo storage user = userInfo[_pid][_user];
1305         uint256 accNovaPerShare = pool.accNovaPerShare;
1306         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1307         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1308             uint256 multiplier = getMultiplier(
1309                 pool.lastRewardBlock,
1310                 block.number
1311             );
1312             uint256 novaReward = multiplier
1313                 .mul(novaPerBlock)
1314                 .mul(pool.allocPoint)
1315                 .div(totalAllocPoint);
1316             accNovaPerShare = accNovaPerShare.add(
1317                 novaReward.mul(1e12).div(lpSupply)
1318             );
1319         }
1320         return
1321             user.amount.mul(accNovaPerShare).div(1e12).sub(user.rewardDebt);
1322     }
1323 
1324     // Update reward vairables for all pools. Be careful of gas spending!
1325     function massUpdatePools() public {
1326         uint256 length = poolInfo.length;
1327         for (uint256 pid = 0; pid < length; ++pid) {
1328             updatePool(pid);
1329         }
1330     }
1331 
1332     // Update reward variables of the given pool to be up-to-date.
1333     function updatePool(uint256 _pid) public {
1334         PoolInfo storage pool = poolInfo[_pid];
1335         if (block.number <= pool.lastRewardBlock) {
1336             return;
1337         }
1338         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1339         if (lpSupply == 0) {
1340             pool.lastRewardBlock = block.number;
1341             return;
1342         }
1343         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1344         uint256 novaReward = multiplier
1345             .mul(novaPerBlock)
1346             .mul(pool.allocPoint)
1347             .div(totalAllocPoint);
1348         nova.mint(devaddr, novaReward.div(devFundDivRate));
1349         nova.mint(address(this), novaReward);
1350         pool.accNovaPerShare = pool.accNovaPerShare.add(
1351             novaReward.mul(1e12).div(lpSupply)
1352         );
1353         pool.lastRewardBlock = block.number;
1354     }
1355 
1356     // Deposit LP tokens to MasterChef for NOVA allocation.
1357     function deposit(uint256 _pid, uint256 _amount) public {
1358         PoolInfo storage pool = poolInfo[_pid];
1359         UserInfo storage user = userInfo[_pid][msg.sender];
1360         updatePool(_pid);
1361         if (user.amount > 0) {
1362             uint256 pending = user
1363                 .amount
1364                 .mul(pool.accNovaPerShare)
1365                 .div(1e12)
1366                 .sub(user.rewardDebt);
1367             safeNovaTransfer(msg.sender, pending);
1368         }
1369         pool.lpToken.safeTransferFrom(
1370             address(msg.sender),
1371             address(this),
1372             _amount
1373         );
1374         user.amount = user.amount.add(_amount);
1375         user.rewardDebt = user.amount.mul(pool.accNovaPerShare).div(1e12);
1376         emit Deposit(msg.sender, _pid, _amount);
1377     }
1378 
1379     // Withdraw LP tokens from MasterChef.
1380     function withdraw(uint256 _pid, uint256 _amount) public {
1381         PoolInfo storage pool = poolInfo[_pid];
1382         UserInfo storage user = userInfo[_pid][msg.sender];
1383         require(user.amount >= _amount, "withdraw: not good");
1384         updatePool(_pid);
1385         uint256 pending = user.amount.mul(pool.accNovaPerShare).div(1e12).sub(
1386             user.rewardDebt
1387         );
1388         safeNovaTransfer(msg.sender, pending);
1389         user.amount = user.amount.sub(_amount);
1390         user.rewardDebt = user.amount.mul(pool.accNovaPerShare).div(1e12);
1391         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1392         emit Withdraw(msg.sender, _pid, _amount);
1393     }
1394 
1395     // Withdraw without caring about rewards. EMERGENCY ONLY.
1396     function emergencyWithdraw(uint256 _pid) public {
1397         PoolInfo storage pool = poolInfo[_pid];
1398         UserInfo storage user = userInfo[_pid][msg.sender];
1399         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1400         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1401         user.amount = 0;
1402         user.rewardDebt = 0;
1403     }
1404 
1405     // Safe nova transfer function, just in case if rounding error causes pool to not have enough NOVAs.
1406     function safeNovaTransfer(address _to, uint256 _amount) internal {
1407         uint256 novaBal = nova.balanceOf(address(this));
1408         if (_amount > novaBal) {
1409             nova.transfer(_to, novaBal);
1410         } else {
1411             nova.transfer(_to, _amount);
1412         }
1413     }
1414 
1415     // Update dev address by the previous dev.
1416     function dev(address _devaddr) public {
1417         require(msg.sender == devaddr, "dev: wut?");
1418         devaddr = _devaddr;
1419     }
1420 
1421     // **** Additional functions separate from the original masterchef contract ****
1422 
1423     function setNovaPerBlock(uint256 _novaPerBlock) public onlyOwner {
1424         require(_novaPerBlock > 0, "!novaPerBlock-0");
1425 
1426         novaPerBlock = _novaPerBlock;
1427     }
1428 
1429     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1430         bonusEndBlock = _bonusEndBlock;
1431     }
1432 
1433     function setDevFundDivRate(uint256 _devFundDivRate) public onlyOwner {
1434         require(_devFundDivRate > 0, "!devFundDivRate-0");
1435         devFundDivRate = _devFundDivRate;
1436     }
1437 }