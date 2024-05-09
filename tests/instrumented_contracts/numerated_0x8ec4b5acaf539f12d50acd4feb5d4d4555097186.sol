1 /*
2 
3     ____             __        __     ____                 
4    / __ \____  _____/ /_____  / /_   / __ \_________  ____ 
5   / /_/ / __ \/ ___/ //_/ _ \/ __/  / / / / ___/ __ \/ __ \
6  / _, _/ /_/ / /__/ ,< /  __/ /_   / /_/ / /  / /_/ / /_/ /
7 /_/ |_|\____/\___/_/|_|\___/\__/  /_____/_/   \____/ .___/ 
8                                                   /_/      
9 
10 v1.2
11 
12 If you haven't read our Medium articles, I HIGHLY suggest you do so. There's also
13 some pretty cool diagrams that you can check out in order to understand what this is.
14 
15 If you got any questions, feel free to join our tg group listed here. Anyone can
16 help answer questions, or just @ the dev, sycore0, and he (I) will get back to
17 you ASAP. I always answer, even if you're trying to sell me shit.
18 
19 Much love my fellow humans, and enjoy.
20 
21 web: rocketbunny.io
22 tg: @RocketBunnyChat
23 
24 */
25 
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
29 // SPDX-License-Identifier: MIT
30 
31 
32 
33 pragma solidity ^0.6.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 // File: @openzeppelin/contracts/math/SafeMath.sol
110 
111 
112 
113 pragma solidity ^0.6.0;
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189         // benefit is lost if 'b' is also tested.
190         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191         if (a == 0) {
192             return 0;
193         }
194 
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts on
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
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 // File: @openzeppelin/contracts/utils/Address.sol
272 
273 
274 
275 pragma solidity ^0.6.2;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies in extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         uint256 size;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { size := extcodesize(account) }
306         return size > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352       return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
416 
417 
418 
419 pragma solidity ^0.6.0;
420 
421 
422 
423 
424 /**
425  * @title SafeERC20
426  * @dev Wrappers around ERC20 operations that throw on failure (when the token
427  * contract returns false). Tokens that return no value (and instead revert or
428  * throw on failure) are also supported, non-reverting calls are assumed to be
429  * successful.
430  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
431  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
432  */
433 library SafeERC20 {
434     using SafeMath for uint256;
435     using Address for address;
436 
437     function safeTransfer(IERC20 token, address to, uint256 value) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
439     }
440 
441     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
442         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
443     }
444 
445     /**
446      * @dev Deprecated. This function has issues similar to the ones found in
447      * {IERC20-approve}, and its usage is discouraged.
448      *
449      * Whenever possible, use {safeIncreaseAllowance} and
450      * {safeDecreaseAllowance} instead.
451      */
452     function safeApprove(IERC20 token, address spender, uint256 value) internal {
453         // safeApprove should only be called when setting an initial allowance,
454         // or when resetting it to zero. To increase and decrease it, use
455         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
456         // solhint-disable-next-line max-line-length
457         require((value == 0) || (token.allowance(address(this), spender) == 0),
458             "SafeERC20: approve from non-zero to non-zero allowance"
459         );
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
461     }
462 
463     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
464         uint256 newAllowance = token.allowance(address(this), spender).add(value);
465         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
466     }
467 
468     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
469         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
470         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
471     }
472 
473     /**
474      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
475      * on the return value: the return value is optional (but if data is returned, it must not be false).
476      * @param token The token targeted by the call.
477      * @param data The call data (encoded using abi.encode or one of its variants).
478      */
479     function _callOptionalReturn(IERC20 token, bytes memory data) private {
480         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
481         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
482         // the target address contains contract code and also asserts for success in the low-level call.
483 
484         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
485         if (returndata.length > 0) { // Return data is optional
486             // solhint-disable-next-line max-line-length
487             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
488         }
489     }
490 }
491 
492 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
493 
494 
495 
496 pragma solidity ^0.6.0;
497 
498 /**
499  * @dev Library for managing
500  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
501  * types.
502  *
503  * Sets have the following properties:
504  *
505  * - Elements are added, removed, and checked for existence in constant time
506  * (O(1)).
507  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
508  *
509  * ```
510  * contract Example {
511  *     // Add the library methods
512  *     using EnumerableSet for EnumerableSet.AddressSet;
513  *
514  *     // Declare a set state variable
515  *     EnumerableSet.AddressSet private mySet;
516  * }
517  * ```
518  *
519  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
520  * (`UintSet`) are supported.
521  */
522 library EnumerableSet {
523     // To implement this library for multiple types with as little code
524     // repetition as possible, we write it in terms of a generic Set type with
525     // bytes32 values.
526     // The Set implementation uses private functions, and user-facing
527     // implementations (such as AddressSet) are just wrappers around the
528     // underlying Set.
529     // This means that we can only create new EnumerableSets for types that fit
530     // in bytes32.
531 
532     struct Set {
533         // Storage of set values
534         bytes32[] _values;
535 
536         // Position of the value in the `values` array, plus 1 because index 0
537         // means a value is not in the set.
538         mapping (bytes32 => uint256) _indexes;
539     }
540 
541     /**
542      * @dev Add a value to a set. O(1).
543      *
544      * Returns true if the value was added to the set, that is if it was not
545      * already present.
546      */
547     function _add(Set storage set, bytes32 value) private returns (bool) {
548         if (!_contains(set, value)) {
549             set._values.push(value);
550             // The value is stored at length-1, but we add 1 to all indexes
551             // and use 0 as a sentinel value
552             set._indexes[value] = set._values.length;
553             return true;
554         } else {
555             return false;
556         }
557     }
558 
559     /**
560      * @dev Removes a value from a set. O(1).
561      *
562      * Returns true if the value was removed from the set, that is if it was
563      * present.
564      */
565     function _remove(Set storage set, bytes32 value) private returns (bool) {
566         // We read and store the value's index to prevent multiple reads from the same storage slot
567         uint256 valueIndex = set._indexes[value];
568 
569         if (valueIndex != 0) { // Equivalent to contains(set, value)
570             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
571             // the array, and then remove the last element (sometimes called as 'swap and pop').
572             // This modifies the order of the array, as noted in {at}.
573 
574             uint256 toDeleteIndex = valueIndex - 1;
575             uint256 lastIndex = set._values.length - 1;
576 
577             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
578             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
579 
580             bytes32 lastvalue = set._values[lastIndex];
581 
582             // Move the last value to the index where the value to delete is
583             set._values[toDeleteIndex] = lastvalue;
584             // Update the index for the moved value
585             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
586 
587             // Delete the slot where the moved value was stored
588             set._values.pop();
589 
590             // Delete the index for the deleted slot
591             delete set._indexes[value];
592 
593             return true;
594         } else {
595             return false;
596         }
597     }
598 
599     /**
600      * @dev Returns true if the value is in the set. O(1).
601      */
602     function _contains(Set storage set, bytes32 value) private view returns (bool) {
603         return set._indexes[value] != 0;
604     }
605 
606     /**
607      * @dev Returns the number of values on the set. O(1).
608      */
609     function _length(Set storage set) private view returns (uint256) {
610         return set._values.length;
611     }
612 
613    /**
614     * @dev Returns the value stored at position `index` in the set. O(1).
615     *
616     * Note that there are no guarantees on the ordering of values inside the
617     * array, and it may change when more values are added or removed.
618     *
619     * Requirements:
620     *
621     * - `index` must be strictly less than {length}.
622     */
623     function _at(Set storage set, uint256 index) private view returns (bytes32) {
624         require(set._values.length > index, "EnumerableSet: index out of bounds");
625         return set._values[index];
626     }
627 
628     // AddressSet
629 
630     struct AddressSet {
631         Set _inner;
632     }
633 
634     /**
635      * @dev Add a value to a set. O(1).
636      *
637      * Returns true if the value was added to the set, that is if it was not
638      * already present.
639      */
640     function add(AddressSet storage set, address value) internal returns (bool) {
641         return _add(set._inner, bytes32(uint256(value)));
642     }
643 
644     /**
645      * @dev Removes a value from a set. O(1).
646      *
647      * Returns true if the value was removed from the set, that is if it was
648      * present.
649      */
650     function remove(AddressSet storage set, address value) internal returns (bool) {
651         return _remove(set._inner, bytes32(uint256(value)));
652     }
653 
654     /**
655      * @dev Returns true if the value is in the set. O(1).
656      */
657     function contains(AddressSet storage set, address value) internal view returns (bool) {
658         return _contains(set._inner, bytes32(uint256(value)));
659     }
660 
661     /**
662      * @dev Returns the number of values in the set. O(1).
663      */
664     function length(AddressSet storage set) internal view returns (uint256) {
665         return _length(set._inner);
666     }
667 
668    /**
669     * @dev Returns the value stored at position `index` in the set. O(1).
670     *
671     * Note that there are no guarantees on the ordering of values inside the
672     * array, and it may change when more values are added or removed.
673     *
674     * Requirements:
675     *
676     * - `index` must be strictly less than {length}.
677     */
678     function at(AddressSet storage set, uint256 index) internal view returns (address) {
679         return address(uint256(_at(set._inner, index)));
680     }
681 
682 
683     // UintSet
684 
685     struct UintSet {
686         Set _inner;
687     }
688 
689     /**
690      * @dev Add a value to a set. O(1).
691      *
692      * Returns true if the value was added to the set, that is if it was not
693      * already present.
694      */
695     function add(UintSet storage set, uint256 value) internal returns (bool) {
696         return _add(set._inner, bytes32(value));
697     }
698 
699     /**
700      * @dev Removes a value from a set. O(1).
701      *
702      * Returns true if the value was removed from the set, that is if it was
703      * present.
704      */
705     function remove(UintSet storage set, uint256 value) internal returns (bool) {
706         return _remove(set._inner, bytes32(value));
707     }
708 
709     /**
710      * @dev Returns true if the value is in the set. O(1).
711      */
712     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
713         return _contains(set._inner, bytes32(value));
714     }
715 
716     /**
717      * @dev Returns the number of values on the set. O(1).
718      */
719     function length(UintSet storage set) internal view returns (uint256) {
720         return _length(set._inner);
721     }
722 
723    /**
724     * @dev Returns the value stored at position `index` in the set. O(1).
725     *
726     * Note that there are no guarantees on the ordering of values inside the
727     * array, and it may change when more values are added or removed.
728     *
729     * Requirements:
730     *
731     * - `index` must be strictly less than {length}.
732     */
733     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
734         return uint256(_at(set._inner, index));
735     }
736 }
737 
738 // File: @openzeppelin/contracts/GSN/Context.sol
739 
740 
741 
742 pragma solidity ^0.6.0;
743 
744 /*
745  * @dev Provides information about the current execution context, including the
746  * sender of the transaction and its data. While these are generally available
747  * via msg.sender and msg.data, they should not be accessed in such a direct
748  * manner, since when dealing with GSN meta-transactions the account sending and
749  * paying for execution may not be the actual sender (as far as an application
750  * is concerned).
751  *
752  * This contract is only required for intermediate, library-like contracts.
753  */
754 abstract contract Context {
755     function _msgSender() internal view virtual returns (address payable) {
756         return msg.sender;
757     }
758 
759     function _msgData() internal view virtual returns (bytes memory) {
760         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
761         return msg.data;
762     }
763 }
764 
765 // File: @openzeppelin/contracts/access/Ownable.sol
766 
767 
768 
769 pragma solidity ^0.6.0;
770 
771 /**
772  * @dev Contract module which provides a basic access control mechanism, where
773  * there is an account (an owner) that can be granted exclusive access to
774  * specific functions.
775  *
776  * By default, the owner account will be the one that deploys the contract. This
777  * can later be changed with {transferOwnership}.
778  *
779  * This module is used through inheritance. It will make available the modifier
780  * `onlyOwner`, which can be applied to your functions to restrict their use to
781  * the owner.
782  */
783 contract Ownable is Context {
784     address private _owner;
785 
786     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
787 
788     /**
789      * @dev Initializes the contract setting the deployer as the initial owner.
790      */
791     constructor () internal {
792         address msgSender = _msgSender();
793         _owner = msgSender;
794         emit OwnershipTransferred(address(0), msgSender);
795     }
796 
797     /**
798      * @dev Returns the address of the current owner.
799      */
800     function owner() public view returns (address) {
801         return _owner;
802     }
803 
804     /**
805      * @dev Throws if called by any account other than the owner.
806      */
807     modifier onlyOwner() {
808         require(_owner == _msgSender(), "Ownable: caller is not the owner");
809         _;
810     }
811 
812     /**
813      * @dev Leaves the contract without owner. It will not be possible to call
814      * `onlyOwner` functions anymore. Can only be called by the current owner.
815      *
816      * NOTE: Renouncing ownership will leave the contract without an owner,
817      * thereby removing any functionality that is only available to the owner.
818      */
819     function renounceOwnership() public virtual onlyOwner {
820         emit OwnershipTransferred(_owner, address(0));
821         _owner = address(0);
822     }
823 
824     /**
825      * @dev Transfers ownership of the contract to a new account (`newOwner`).
826      * Can only be called by the current owner.
827      */
828     function transferOwnership(address newOwner) public virtual onlyOwner {
829         require(newOwner != address(0), "Ownable: new owner is the zero address");
830         emit OwnershipTransferred(_owner, newOwner);
831         _owner = newOwner;
832     }
833 }
834 
835 // File: contracts/VendingMachine.sol
836 
837 
838 pragma solidity 0.6.12;
839 
840 
841 
842 
843 
844 
845 // VendingMachine distributes the ERC20 rewards based on staked LP to each user.
846 //
847 // Cloned from https://github.com/SashimiProject/sashimiswap/blob/master/contracts/MasterChef.sol
848 // Modified by LTO Network to work for non-mintable ERC20.
849 contract RocketDropV1point2 is Ownable {
850     using SafeMath for uint256;
851     using SafeERC20 for IERC20;
852 
853     // Info of each user.
854     struct UserInfo {
855         uint256 amount;     // How many LP tokens the user has provided.
856         uint256 rewardDebt; // Reward debt. See explanation below.
857         uint256 depositStamp;
858         //
859         // We do some fancy math here. Basically, any point in time, the amount of ERC20s
860         // entitled to a user but is pending to be distributed is:
861         //
862         //   pending reward = (user.amount * pool.accERC20PerShare) - user.rewardDebt
863         //
864         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
865         //   1. The pool's `accERC20PerShare` (and `lastRewardBlock`) gets updated.
866         //   2. User receives the pending reward sent to his/her address.
867         //   3. User's `amount` gets updated.
868         //   4. User's `rewardDebt` gets updated.
869     }
870 
871     // Info of each pool.
872     struct PoolInfo {
873         IERC20 lpToken;             // Address of LP token contract.
874         uint256 lastRewardBlock;    // Last block number that ERC20s distribution occurs.
875         uint256 accERC20PerShare;   // Accumulated ERC20s per share, times 1e36.
876         IERC20 rewardToken;         // pool specific reward token.
877         uint256 startBlock;         // pool specific block number when rewards start
878         uint256 endBlock;           // pool specific block number when rewards end
879         uint256 rewardPerBlock;     // pool specific reward per block
880         uint256 paidOut;            // total paid out by pool
881         uint256 tokensStaked;       // allows the same token to be staked across different pools
882         uint256 gasAmount;          // eth fee charged on deposits and withdrawals (per pool)
883         uint256 minStake;           // minimum tokens allowed to be staked
884         uint256 maxStake;           // max tokens allowed to be staked
885         address payable partnerTreasury;    // allows eth fee to be split with a partner on transfer
886         uint256 partnerPercent;     // eth fee percent of partner split, 2 decimals (ie 10000 = 100.00%, 1002 = 10.02%)
887     }
888 
889     // extra parameters for pools; optional
890     struct PoolExtras {
891         uint256 totalStakers;
892         uint256 maxStakers;
893         uint256 lpTokenFee;         // divide by 1000 ie 150 is 1.5%
894         uint256 lockPeriod;         // time in blocks needed before withdrawal
895         IERC20 accessToken;
896         uint256 accessTokenMin;
897         bool accessTokenRequired;
898     }
899 
900     // default eth fee for deposits and withdrawals
901     uint256 public gasAmount = 2000000000000000;
902     address payable public treasury;
903     IERC20 public accessToken;
904     uint256 public accessTokenMin;
905     bool public accessTokenRequired = false;
906 
907     // vars to keep track of $bunny
908     IERC20 public rocketBunny;
909     //uint256 rocketBunnyYield;
910     //uint256 public rocketBunnyHeld;
911 
912     // Info of each pool.
913     PoolInfo[] public poolInfo;
914     PoolExtras[] public poolExtras;
915     // Info of each user that stakes LP tokens.
916     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
917 
918     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
919     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
920     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
921 
922     constructor(IERC20 rocketBunnyAddress) public {
923         rocketBunny = rocketBunnyAddress;
924         treasury = msg.sender;
925     }
926 
927     // Number of LP pools
928     function poolLength() external view returns (uint256) {
929         return poolInfo.length;
930     }
931 
932     function currentBlock() external view returns (uint256) {
933         return block.number;
934     }
935 
936     // Fund the farm, increase the end block
937     function initialFund(uint256 _pid, uint256 _amount, uint256 _startBlock) public {
938         require(poolInfo[_pid].startBlock == 0, "initialFund: initial funding already complete");
939         IERC20 erc20;
940         erc20 = poolInfo[_pid].rewardToken;
941 
942         uint256 startTokenBalance = erc20.balanceOf(address(this));
943         erc20.safeTransferFrom(address(msg.sender), address(this), _amount);
944         uint256 endTokenBalance = erc20.balanceOf(address(this));
945         uint256 trueDepositedTokens = endTokenBalance.sub(startTokenBalance);
946 
947         poolInfo[_pid].lastRewardBlock = _startBlock;
948         poolInfo[_pid].startBlock = _startBlock;
949         poolInfo[_pid].endBlock = _startBlock.add(trueDepositedTokens.div(poolInfo[_pid].rewardPerBlock));
950     }
951 
952     // Fund the farm, increase the end block
953     function fundMore(uint256 _pid, uint256 _amount) public {
954         require(block.number < poolInfo[_pid].endBlock, "fundMore: pool closed or use initialFund() first");
955         IERC20 erc20;
956         erc20 = poolInfo[_pid].rewardToken;
957 
958         uint256 startTokenBalance = erc20.balanceOf(address(this));
959         erc20.safeTransferFrom(address(msg.sender), address(this), _amount);
960         uint256 endTokenBalance = erc20.balanceOf(address(this));
961         uint256 trueDepositedTokens = endTokenBalance.sub(startTokenBalance);
962 
963         poolInfo[_pid].endBlock += trueDepositedTokens.div(poolInfo[_pid].rewardPerBlock);
964     }
965 
966     // Add a new lp to the pool. Can only be called by the owner.
967     // rewards are calculated per pool, so you can add the same lpToken multiple times
968     function add(IERC20 _lpToken, IERC20 _rewardToken, uint256 _rewardPerBlock, bool _withUpdate) public onlyOwner {
969         if (_withUpdate) {
970             massUpdatePools();
971         }
972         //###
973         poolInfo.push(PoolInfo({
974             lpToken: _lpToken,
975             lastRewardBlock: 0,
976             accERC20PerShare: 0,
977             rewardToken: _rewardToken,
978             startBlock: 0,
979             endBlock: 0,
980             rewardPerBlock: _rewardPerBlock,
981             paidOut: 0,
982             tokensStaked: 0,
983             gasAmount: gasAmount,   // defaults to global gas/eth fee
984             minStake: 0,
985             maxStake: ~uint256(0),
986             partnerTreasury: treasury,
987             partnerPercent: 0
988         }));
989 
990         poolExtras.push(PoolExtras({
991             totalStakers: 0,
992             maxStakers: ~uint256(0),
993             lpTokenFee: 0,
994             lockPeriod: 0,
995             accessTokenRequired: false,
996             accessToken: IERC20(address(0)),
997             accessTokenMin: 0
998         }));
999     }
1000 
1001     //####
1002     // Update the given pool's ERC20 reward per block. Can only be called by the owner.
1003     function set(uint256 _pid, uint256 _rewardPerBlock, bool _withUpdate) public onlyOwner {
1004         //updatePool(_pid);   // prevents taking existing rewards from current stakers
1005         if (_withUpdate) {
1006             updatePool(_pid);
1007         }
1008         poolInfo[_pid].rewardPerBlock = _rewardPerBlock;
1009         updatePool(_pid);
1010     }
1011 
1012     // Pool adjustment functions
1013     function minStake(uint256 _pid, uint256 _minStake) public onlyOwner {
1014         poolInfo[_pid].minStake = _minStake;
1015     }
1016 
1017     function maxStake(uint256 _pid, uint256 _maxStake) public onlyOwner {
1018         poolInfo[_pid].maxStake = _maxStake;
1019     }
1020 
1021     function maxStakersAdj(uint256 _pid, uint256 _maxStakers) public onlyOwner {
1022         poolExtras[_pid].maxStakers = _maxStakers;
1023     }
1024 
1025     function lpTokenFeeAdj(uint256 _pid, uint256 _lpTokenFee) public onlyOwner {
1026         poolExtras[_pid].lpTokenFee = _lpTokenFee;
1027     }
1028 
1029     function lockPeriodAdj(uint256 _pid, uint256 _lockPeriod) public onlyOwner {
1030         poolExtras[_pid].lockPeriod = _lockPeriod;
1031     }
1032 
1033     function poolAccessTokenReq(uint256 _pid, bool _accessTokenRequired) public onlyOwner {
1034         poolExtras[_pid].accessTokenRequired = _accessTokenRequired;
1035     }
1036 
1037     function poolAccessTokenAddy(uint256 _pid, IERC20 _accessToken) public onlyOwner {
1038         poolExtras[_pid].accessToken = _accessToken;
1039     }
1040 
1041     function poolAccessTokenMin(uint256 _pid, uint256 _accessTokenMin) public onlyOwner {
1042         poolExtras[_pid].accessTokenMin = _accessTokenMin;
1043     }
1044     // END Pool adjustment functions
1045 
1046     // View function to see deposited LP for a user.
1047     function deposited(uint256 _pid, address _user) external view returns (uint256) {
1048         UserInfo storage user = userInfo[_pid][_user];
1049         return user.amount;
1050     }
1051 
1052     // View function to see pending ERC20s for a user.
1053     function pending(uint256 _pid, address _user) external view returns (uint256) {
1054         PoolInfo storage pool = poolInfo[_pid];
1055         UserInfo storage user = userInfo[_pid][_user];
1056         uint256 accERC20PerShare = pool.accERC20PerShare;
1057         
1058         uint256 lpSupply = pool.tokensStaked;
1059 
1060         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1061             uint256 lastBlock = block.number < pool.endBlock ? block.number : pool.endBlock;
1062             uint256 nrOfBlocks = lastBlock.sub(pool.lastRewardBlock);
1063             uint256 erc20Reward = nrOfBlocks.mul(pool.rewardPerBlock);
1064             accERC20PerShare = accERC20PerShare.add(erc20Reward.mul(1e36).div(lpSupply));
1065         }
1066 
1067         return user.amount.mul(accERC20PerShare).div(1e36).sub(user.rewardDebt);
1068     }
1069 
1070     // View function for total reward the farm has yet to pay out.
1071     function totalPending(uint256 _pid) external view returns (uint256) {
1072         if (block.number <= poolInfo[_pid].startBlock) {
1073             return 0;
1074         }
1075 
1076         uint256 lastBlock = block.number < poolInfo[_pid].endBlock ? block.number : poolInfo[_pid].endBlock;
1077         return poolInfo[_pid].rewardPerBlock.mul(lastBlock - poolInfo[_pid].startBlock).sub(poolInfo[_pid].paidOut);
1078     }
1079 
1080     // Update reward variables for all pools. Be careful of gas spending!
1081     function massUpdatePools() public {
1082         uint256 length = poolInfo.length;
1083         for (uint256 pid = 0; pid < length; ++pid) {
1084             updatePool(pid);
1085         }
1086     }
1087 
1088     // Update reward variables of the given pool to be up-to-date.
1089     function updatePool(uint256 _pid) public {
1090         PoolInfo storage pool = poolInfo[_pid];
1091         uint256 lastBlock = block.number < pool.endBlock ? block.number : pool.endBlock;
1092 
1093         if (lastBlock <= pool.lastRewardBlock) {
1094             return;
1095         }
1096         uint256 lpSupply = pool.tokensStaked;
1097         if (lpSupply == 0) {
1098             pool.lastRewardBlock = lastBlock;
1099             return;
1100         }
1101 
1102         uint256 nrOfBlocks = lastBlock.sub(pool.lastRewardBlock);
1103         uint256 erc20Reward = nrOfBlocks.mul(pool.rewardPerBlock);
1104 
1105         pool.accERC20PerShare = pool.accERC20PerShare.add(erc20Reward.mul(1e36).div(lpSupply));
1106         pool.lastRewardBlock = lastBlock;
1107     }
1108 
1109     // Deposit LP tokens to VendingMachine for ERC20 allocation.
1110     function deposit(uint256 _pid, uint256 _amount) public payable {
1111         if(accessTokenRequired){
1112             require(accessToken.balanceOf(msg.sender) >= accessTokenMin, 'Must have minimum amount of access token!');
1113         }
1114         PoolExtras storage poolEx = poolExtras[_pid];
1115 
1116         if(poolEx.accessTokenRequired){
1117             require(poolEx.accessToken.balanceOf(msg.sender) >= poolEx.accessTokenMin, 'Must have minimum amount of access token!');
1118         }
1119         require(poolEx.totalStakers < poolEx.maxStakers, 'Max stakers reached!');
1120 
1121         PoolInfo storage pool = poolInfo[_pid];
1122         uint256 poolGasAmount = pool.gasAmount;
1123         require(msg.value >= poolGasAmount, 'Correct gas amount must be sent!');
1124         require(_amount >= pool.minStake && _amount <= pool.maxStake, 'Min/Max stake required!');
1125 
1126         UserInfo storage user = userInfo[_pid][msg.sender];
1127         updatePool(_pid);
1128         if (user.amount > 0) {
1129             uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
1130             erc20Transfer(msg.sender, _pid, pendingAmount);
1131         }
1132 
1133         uint256 startTokenBalance = pool.lpToken.balanceOf(address(this));
1134         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1135         uint256 endTokenBalance = pool.lpToken.balanceOf(address(this));
1136         uint256 depositFee = poolEx.lpTokenFee.mul(endTokenBalance).div(1000);
1137         uint256 trueDepositedTokens = endTokenBalance.sub(startTokenBalance).sub(depositFee);
1138 
1139         user.amount = user.amount.add(trueDepositedTokens);
1140         user.depositStamp = block.number;
1141         pool.tokensStaked = pool.tokensStaked.add(trueDepositedTokens);
1142         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
1143         
1144         // remit eth fee according to partner status 
1145         if (pool.partnerPercent == 0) {
1146             treasury.transfer(msg.value);
1147         } else {
1148             uint256 totalAmount = msg.value;
1149             uint256 partnerAmount = totalAmount.mul(pool.partnerPercent).div(10000);
1150             uint256 treasuryAmount = totalAmount.sub(partnerAmount);
1151             treasury.transfer(treasuryAmount);
1152             pool.partnerTreasury.transfer(partnerAmount);
1153         }
1154         
1155         poolEx.totalStakers = poolEx.totalStakers.add(1);
1156         emit Deposit(msg.sender, _pid, _amount);
1157     }
1158 
1159     // Withdraw LP tokens from VendingMachine.
1160     function withdraw(uint256 _pid, uint256 _amount) public payable {
1161         if(accessTokenRequired){
1162             require(accessToken.balanceOf(msg.sender) >= accessTokenMin, 'Must have minimum amount of access token!');
1163         }
1164         PoolExtras storage poolEx = poolExtras[_pid];
1165         PoolInfo storage pool = poolInfo[_pid];
1166         uint256 poolGasAmount = pool.gasAmount;
1167         require(msg.value >= poolGasAmount, 'Correct gas amount must be sent!');
1168 
1169         UserInfo storage user = userInfo[_pid][msg.sender];
1170         require(user.amount >= _amount, "withdraw: can't withdraw more than deposit");
1171         updatePool(_pid);
1172         uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
1173         erc20Transfer(msg.sender, _pid, pendingAmount);
1174         user.amount = user.amount.sub(_amount);
1175         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
1176         
1177         if(_amount > 0){
1178             require(user.depositStamp.add(poolEx.lockPeriod) >= block.number,'Lock period not fulfilled');
1179             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1180             pool.tokensStaked = pool.tokensStaked.sub(_amount);
1181         }
1182 
1183         // remit eth fee according to partner status 
1184         if (pool.partnerPercent == 0) {
1185             treasury.transfer(msg.value);
1186         } else {
1187             uint256 totalAmount = msg.value;
1188             uint256 partnerAmount = totalAmount.mul(pool.partnerPercent).div(10000);
1189             uint256 treasuryAmount = totalAmount.sub(partnerAmount);
1190             treasury.transfer(treasuryAmount);
1191             pool.partnerTreasury.transfer(partnerAmount);
1192         }
1193 
1194         if(user.amount == 0){
1195             poolEx.totalStakers = poolEx.totalStakers.sub(1);
1196         }
1197         emit Withdraw(msg.sender, _pid, _amount);
1198     }
1199 
1200     // Withdraw without caring about rewards. EMERGENCY ONLY.
1201     function emergencyWithdraw(uint256 _pid) public {
1202         PoolInfo storage pool = poolInfo[_pid];
1203         PoolExtras storage poolEx = poolExtras[_pid];
1204         UserInfo storage user = userInfo[_pid][msg.sender];
1205         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1206         pool.tokensStaked = pool.tokensStaked.sub(user.amount);
1207         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1208         user.amount = 0;
1209         user.rewardDebt = 0;
1210         poolEx.totalStakers = poolEx.totalStakers.sub(1);
1211     }
1212 
1213     // Transfer ERC20 and update the required ERC20 to payout all rewards
1214     function erc20Transfer(address _to, uint256 _pid, uint256 _amount) internal {
1215         IERC20 erc20;
1216         erc20 = poolInfo[_pid].rewardToken;
1217         erc20.transfer(_to, _amount);
1218         poolInfo[_pid].paidOut += _amount;
1219     }
1220     
1221     // adjust default/global gas fee
1222     function adjustGasGlobal(uint256 newgas) public onlyOwner {
1223         gasAmount = newgas;
1224     }
1225 
1226     // access token settings
1227     function changeAccessToken(IERC20 newToken) public onlyOwner {
1228         accessToken = newToken;
1229     }
1230     function changeAccessMin(uint256 newMin) public onlyOwner {
1231         accessTokenMin = newMin;
1232     }
1233     function changeAccessTknReq(bool setting) public onlyOwner {
1234         accessTokenRequired = setting;
1235     }
1236 
1237     // adjust pool gas/eth fee
1238     function adjustPoolGas(uint256 _pid, uint256 newgas) public onlyOwner {
1239         poolInfo[_pid].gasAmount = newgas;
1240     }
1241 
1242     function adjustBlockReward(uint256 _pid, uint256 newReward) public onlyOwner {
1243         poolInfo[_pid].rewardPerBlock = newReward;
1244     }
1245 
1246     function adjustEndBlock(uint256 _pid, uint256 newBlock) public onlyOwner {
1247         poolInfo[_pid].endBlock = newBlock;
1248     }
1249 
1250     function adjustLastBlock(uint256 _pid, uint256 newBlock) public onlyOwner {
1251         poolInfo[_pid].lastRewardBlock = newBlock;
1252     }
1253     
1254     function withdrawAnyToken(address _recipient, address _ERC20address, uint256 _amount) public onlyOwner returns(bool) {
1255         IERC20(_ERC20address).transfer(_recipient, _amount); //use of the _ERC20 traditional transfer
1256         return true;
1257     }
1258 
1259     function transferExtraBunny(address _recipient) public onlyOwner {
1260         uint256 length = poolInfo.length;
1261         uint256 bunnyHeld;
1262         uint256 bunnyBalance = rocketBunny.balanceOf(address(this));
1263         for (uint256 pid = 0; pid < length; ++pid) {
1264             if(poolInfo[pid].lpToken == rocketBunny){
1265                 bunnyHeld = bunnyHeld.add(poolInfo[pid].tokensStaked);
1266             }
1267         }
1268         uint256 bunnyYield = bunnyBalance.sub(bunnyHeld);
1269         rocketBunny.transfer(_recipient, bunnyYield);
1270     }
1271 
1272     // change global treasury
1273     function changeTreasury(address payable newTreasury) public onlyOwner {
1274         treasury = newTreasury;
1275     }
1276 
1277     function changePartnerTreasury(uint256 _pid, address payable newTreasury) public onlyOwner {
1278         poolInfo[_pid].partnerTreasury = newTreasury;
1279     }
1280     
1281     function changePartnerPercent(uint256 _pid, uint256 newPercent) public onlyOwner {
1282         poolInfo[_pid].partnerPercent = newPercent;
1283     }
1284 
1285     function transfer() public onlyOwner {
1286         treasury.transfer(address(this).balance);
1287     }
1288 }