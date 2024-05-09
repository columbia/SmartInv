1 /*
2 
3     ____             __        __     ____                 
4    / __ \____  _____/ /_____  / /_   / __ \_________  ____ 
5   / /_/ / __ \/ ___/ //_/ _ \/ __/  / / / / ___/ __ \/ __ \
6  / _, _/ /_/ / /__/ ,< /  __/ /_   / /_/ / /  / /_/ / /_/ /
7 /_/ |_|\____/\___/_/|_|\___/\__/  /_____/_/   \____/ .___/ 
8                                                   /_/      
9 
10 That's right you haters, this is ROCKET DROP: the ONLY farming solution that let's you
11 stake ANY kind of token for ANY kind of yield.
12 
13 This will be the bedrock of the Rocket Bunny and Corlibri community.
14 
15 If you haven't read our Medium articles, I HIGHLY suggest you do so. There's also
16 some pretty cool diagrams that you can check out in order to understand what this is.
17 
18 If you got any questions, feel free to join our tg group listed here. Anyone can
19 help answer questions, or just @ the dev, sycore0, and he (I) will get back to
20 you ASAP. I always answer, even if you're trying to sell me shit.
21 
22 Much love my fellow humans, and enjoy.
23 
24 web: rocketbunny.io
25 tg: @RocketBunnyChat
26 
27 */
28 
29 
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 // SPDX-License-Identifier: MIT
33 
34 
35 
36 pragma solidity ^0.6.0;
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 // File: @openzeppelin/contracts/math/SafeMath.sol
113 
114 
115 
116 pragma solidity ^0.6.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b > 0, errorMessage);
234         uint256 c = a / b;
235         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         return mod(a, b, "SafeMath: modulo by zero");
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/utils/Address.sol
275 
276 
277 
278 pragma solidity ^0.6.2;
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies in extcodesize, which returns 0 for contracts in
303         // construction, since the code is only stored at the end of the
304         // constructor execution.
305 
306         uint256 size;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { size := extcodesize(account) }
309         return size > 0;
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332         (bool success, ) = recipient.call{ value: amount }("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain`call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355       return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
365         return _functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         return _functionCallWithValue(target, data, value, errorMessage);
392     }
393 
394     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
395         require(isContract(target), "Address: call to non-contract");
396 
397         // solhint-disable-next-line avoid-low-level-calls
398         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 // solhint-disable-next-line no-inline-assembly
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
419 
420 
421 
422 pragma solidity ^0.6.0;
423 
424 
425 
426 
427 /**
428  * @title SafeERC20
429  * @dev Wrappers around ERC20 operations that throw on failure (when the token
430  * contract returns false). Tokens that return no value (and instead revert or
431  * throw on failure) are also supported, non-reverting calls are assumed to be
432  * successful.
433  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
434  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
435  */
436 library SafeERC20 {
437     using SafeMath for uint256;
438     using Address for address;
439 
440     function safeTransfer(IERC20 token, address to, uint256 value) internal {
441         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
442     }
443 
444     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
445         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
446     }
447 
448     /**
449      * @dev Deprecated. This function has issues similar to the ones found in
450      * {IERC20-approve}, and its usage is discouraged.
451      *
452      * Whenever possible, use {safeIncreaseAllowance} and
453      * {safeDecreaseAllowance} instead.
454      */
455     function safeApprove(IERC20 token, address spender, uint256 value) internal {
456         // safeApprove should only be called when setting an initial allowance,
457         // or when resetting it to zero. To increase and decrease it, use
458         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
459         // solhint-disable-next-line max-line-length
460         require((value == 0) || (token.allowance(address(this), spender) == 0),
461             "SafeERC20: approve from non-zero to non-zero allowance"
462         );
463         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
464     }
465 
466     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
467         uint256 newAllowance = token.allowance(address(this), spender).add(value);
468         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469     }
470 
471     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
472         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
473         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
474     }
475 
476     /**
477      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
478      * on the return value: the return value is optional (but if data is returned, it must not be false).
479      * @param token The token targeted by the call.
480      * @param data The call data (encoded using abi.encode or one of its variants).
481      */
482     function _callOptionalReturn(IERC20 token, bytes memory data) private {
483         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
484         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
485         // the target address contains contract code and also asserts for success in the low-level call.
486 
487         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
488         if (returndata.length > 0) { // Return data is optional
489             // solhint-disable-next-line max-line-length
490             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
491         }
492     }
493 }
494 
495 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
496 
497 
498 
499 pragma solidity ^0.6.0;
500 
501 /**
502  * @dev Library for managing
503  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
504  * types.
505  *
506  * Sets have the following properties:
507  *
508  * - Elements are added, removed, and checked for existence in constant time
509  * (O(1)).
510  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
511  *
512  * ```
513  * contract Example {
514  *     // Add the library methods
515  *     using EnumerableSet for EnumerableSet.AddressSet;
516  *
517  *     // Declare a set state variable
518  *     EnumerableSet.AddressSet private mySet;
519  * }
520  * ```
521  *
522  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
523  * (`UintSet`) are supported.
524  */
525 library EnumerableSet {
526     // To implement this library for multiple types with as little code
527     // repetition as possible, we write it in terms of a generic Set type with
528     // bytes32 values.
529     // The Set implementation uses private functions, and user-facing
530     // implementations (such as AddressSet) are just wrappers around the
531     // underlying Set.
532     // This means that we can only create new EnumerableSets for types that fit
533     // in bytes32.
534 
535     struct Set {
536         // Storage of set values
537         bytes32[] _values;
538 
539         // Position of the value in the `values` array, plus 1 because index 0
540         // means a value is not in the set.
541         mapping (bytes32 => uint256) _indexes;
542     }
543 
544     /**
545      * @dev Add a value to a set. O(1).
546      *
547      * Returns true if the value was added to the set, that is if it was not
548      * already present.
549      */
550     function _add(Set storage set, bytes32 value) private returns (bool) {
551         if (!_contains(set, value)) {
552             set._values.push(value);
553             // The value is stored at length-1, but we add 1 to all indexes
554             // and use 0 as a sentinel value
555             set._indexes[value] = set._values.length;
556             return true;
557         } else {
558             return false;
559         }
560     }
561 
562     /**
563      * @dev Removes a value from a set. O(1).
564      *
565      * Returns true if the value was removed from the set, that is if it was
566      * present.
567      */
568     function _remove(Set storage set, bytes32 value) private returns (bool) {
569         // We read and store the value's index to prevent multiple reads from the same storage slot
570         uint256 valueIndex = set._indexes[value];
571 
572         if (valueIndex != 0) { // Equivalent to contains(set, value)
573             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
574             // the array, and then remove the last element (sometimes called as 'swap and pop').
575             // This modifies the order of the array, as noted in {at}.
576 
577             uint256 toDeleteIndex = valueIndex - 1;
578             uint256 lastIndex = set._values.length - 1;
579 
580             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
581             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
582 
583             bytes32 lastvalue = set._values[lastIndex];
584 
585             // Move the last value to the index where the value to delete is
586             set._values[toDeleteIndex] = lastvalue;
587             // Update the index for the moved value
588             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
589 
590             // Delete the slot where the moved value was stored
591             set._values.pop();
592 
593             // Delete the index for the deleted slot
594             delete set._indexes[value];
595 
596             return true;
597         } else {
598             return false;
599         }
600     }
601 
602     /**
603      * @dev Returns true if the value is in the set. O(1).
604      */
605     function _contains(Set storage set, bytes32 value) private view returns (bool) {
606         return set._indexes[value] != 0;
607     }
608 
609     /**
610      * @dev Returns the number of values on the set. O(1).
611      */
612     function _length(Set storage set) private view returns (uint256) {
613         return set._values.length;
614     }
615 
616    /**
617     * @dev Returns the value stored at position `index` in the set. O(1).
618     *
619     * Note that there are no guarantees on the ordering of values inside the
620     * array, and it may change when more values are added or removed.
621     *
622     * Requirements:
623     *
624     * - `index` must be strictly less than {length}.
625     */
626     function _at(Set storage set, uint256 index) private view returns (bytes32) {
627         require(set._values.length > index, "EnumerableSet: index out of bounds");
628         return set._values[index];
629     }
630 
631     // AddressSet
632 
633     struct AddressSet {
634         Set _inner;
635     }
636 
637     /**
638      * @dev Add a value to a set. O(1).
639      *
640      * Returns true if the value was added to the set, that is if it was not
641      * already present.
642      */
643     function add(AddressSet storage set, address value) internal returns (bool) {
644         return _add(set._inner, bytes32(uint256(value)));
645     }
646 
647     /**
648      * @dev Removes a value from a set. O(1).
649      *
650      * Returns true if the value was removed from the set, that is if it was
651      * present.
652      */
653     function remove(AddressSet storage set, address value) internal returns (bool) {
654         return _remove(set._inner, bytes32(uint256(value)));
655     }
656 
657     /**
658      * @dev Returns true if the value is in the set. O(1).
659      */
660     function contains(AddressSet storage set, address value) internal view returns (bool) {
661         return _contains(set._inner, bytes32(uint256(value)));
662     }
663 
664     /**
665      * @dev Returns the number of values in the set. O(1).
666      */
667     function length(AddressSet storage set) internal view returns (uint256) {
668         return _length(set._inner);
669     }
670 
671    /**
672     * @dev Returns the value stored at position `index` in the set. O(1).
673     *
674     * Note that there are no guarantees on the ordering of values inside the
675     * array, and it may change when more values are added or removed.
676     *
677     * Requirements:
678     *
679     * - `index` must be strictly less than {length}.
680     */
681     function at(AddressSet storage set, uint256 index) internal view returns (address) {
682         return address(uint256(_at(set._inner, index)));
683     }
684 
685 
686     // UintSet
687 
688     struct UintSet {
689         Set _inner;
690     }
691 
692     /**
693      * @dev Add a value to a set. O(1).
694      *
695      * Returns true if the value was added to the set, that is if it was not
696      * already present.
697      */
698     function add(UintSet storage set, uint256 value) internal returns (bool) {
699         return _add(set._inner, bytes32(value));
700     }
701 
702     /**
703      * @dev Removes a value from a set. O(1).
704      *
705      * Returns true if the value was removed from the set, that is if it was
706      * present.
707      */
708     function remove(UintSet storage set, uint256 value) internal returns (bool) {
709         return _remove(set._inner, bytes32(value));
710     }
711 
712     /**
713      * @dev Returns true if the value is in the set. O(1).
714      */
715     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
716         return _contains(set._inner, bytes32(value));
717     }
718 
719     /**
720      * @dev Returns the number of values on the set. O(1).
721      */
722     function length(UintSet storage set) internal view returns (uint256) {
723         return _length(set._inner);
724     }
725 
726    /**
727     * @dev Returns the value stored at position `index` in the set. O(1).
728     *
729     * Note that there are no guarantees on the ordering of values inside the
730     * array, and it may change when more values are added or removed.
731     *
732     * Requirements:
733     *
734     * - `index` must be strictly less than {length}.
735     */
736     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
737         return uint256(_at(set._inner, index));
738     }
739 }
740 
741 // File: @openzeppelin/contracts/GSN/Context.sol
742 
743 
744 
745 pragma solidity ^0.6.0;
746 
747 /*
748  * @dev Provides information about the current execution context, including the
749  * sender of the transaction and its data. While these are generally available
750  * via msg.sender and msg.data, they should not be accessed in such a direct
751  * manner, since when dealing with GSN meta-transactions the account sending and
752  * paying for execution may not be the actual sender (as far as an application
753  * is concerned).
754  *
755  * This contract is only required for intermediate, library-like contracts.
756  */
757 abstract contract Context {
758     function _msgSender() internal view virtual returns (address payable) {
759         return msg.sender;
760     }
761 
762     function _msgData() internal view virtual returns (bytes memory) {
763         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
764         return msg.data;
765     }
766 }
767 
768 // File: @openzeppelin/contracts/access/Ownable.sol
769 
770 
771 
772 pragma solidity ^0.6.0;
773 
774 /**
775  * @dev Contract module which provides a basic access control mechanism, where
776  * there is an account (an owner) that can be granted exclusive access to
777  * specific functions.
778  *
779  * By default, the owner account will be the one that deploys the contract. This
780  * can later be changed with {transferOwnership}.
781  *
782  * This module is used through inheritance. It will make available the modifier
783  * `onlyOwner`, which can be applied to your functions to restrict their use to
784  * the owner.
785  */
786 contract Ownable is Context {
787     address private _owner;
788 
789     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
790 
791     /**
792      * @dev Initializes the contract setting the deployer as the initial owner.
793      */
794     constructor () internal {
795         address msgSender = _msgSender();
796         _owner = msgSender;
797         emit OwnershipTransferred(address(0), msgSender);
798     }
799 
800     /**
801      * @dev Returns the address of the current owner.
802      */
803     function owner() public view returns (address) {
804         return _owner;
805     }
806 
807     /**
808      * @dev Throws if called by any account other than the owner.
809      */
810     modifier onlyOwner() {
811         require(_owner == _msgSender(), "Ownable: caller is not the owner");
812         _;
813     }
814 
815     /**
816      * @dev Leaves the contract without owner. It will not be possible to call
817      * `onlyOwner` functions anymore. Can only be called by the current owner.
818      *
819      * NOTE: Renouncing ownership will leave the contract without an owner,
820      * thereby removing any functionality that is only available to the owner.
821      */
822     function renounceOwnership() public virtual onlyOwner {
823         emit OwnershipTransferred(_owner, address(0));
824         _owner = address(0);
825     }
826 
827     /**
828      * @dev Transfers ownership of the contract to a new account (`newOwner`).
829      * Can only be called by the current owner.
830      */
831     function transferOwnership(address newOwner) public virtual onlyOwner {
832         require(newOwner != address(0), "Ownable: new owner is the zero address");
833         emit OwnershipTransferred(_owner, newOwner);
834         _owner = newOwner;
835     }
836 }
837 
838 // File: contracts/VendingMachine.sol
839 
840 
841 pragma solidity 0.6.12;
842 
843 
844 
845 
846 
847 
848 // VendingMachine distributes the ERC20 rewards based on staked LP to each user.
849 //
850 // Cloned from https://github.com/SashimiProject/sashimiswap/blob/master/contracts/MasterChef.sol
851 // Modified by LTO Network to work for non-mintable ERC20.
852 contract RocketDropV1 is Ownable {
853     using SafeMath for uint256;
854     using SafeERC20 for IERC20;
855 
856     // Info of each user.
857     struct UserInfo {
858         uint256 amount;     // How many LP tokens the user has provided.
859         uint256 rewardDebt; // Reward debt. See explanation below.
860         //
861         // We do some fancy math here. Basically, any point in time, the amount of ERC20s
862         // entitled to a user but is pending to be distributed is:
863         //
864         //   pending reward = (user.amount * pool.accERC20PerShare) - user.rewardDebt
865         //
866         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
867         //   1. The pool's `accERC20PerShare` (and `lastRewardBlock`) gets updated.
868         //   2. User receives the pending reward sent to his/her address.
869         //   3. User's `amount` gets updated.
870         //   4. User's `rewardDebt` gets updated.
871     }
872 
873     // Info of each pool.
874     struct PoolInfo {
875         IERC20 lpToken;             // Address of LP token contract.
876         uint256 lastRewardBlock;    // Last block number that ERC20s distribution occurs.
877         uint256 accERC20PerShare;   // Accumulated ERC20s per share, times 1e36.
878         IERC20 rewardToken;         // pool specific reward token.
879         uint256 startBlock;         // pool specific block number when rewards start
880         uint256 endBlock;           // pool specific block number when rewards end
881         uint256 rewardPerBlock;     // pool specific reward per block
882         uint256 paidOut;            // total paid out by pool
883         uint256 tokensStaked;       // allows the same token to be staked across different pools
884         uint256 gasAmount;          // eth fee charged on deposits and withdrawals (per pool)
885         uint256 minStake;           // minimum tokens allowed to be staked
886         uint256 maxStake;           // max tokens allowed to be staked
887         address payable partnerTreasury;    // allows eth fee to be split with a partner on transfer
888         uint256 partnerPercent;     // eth fee percent of partner split, 2 decimals (ie 10000 = 100.00%, 1002 = 10.02%)
889     }
890 
891     // default eth fee for deposits and withdrawals
892     uint256 public gasAmount = 2000000000000000;
893     address payable public treasury;
894     IERC20 public accessToken;
895     uint256 public accessTokenMin;
896     bool public accessTokenRequired = false;
897 
898     // vars to keep track of $bunny
899     IERC20 public rocketBunny;
900     //uint256 rocketBunnyYield;
901     //uint256 public rocketBunnyHeld;
902 
903     // Info of each pool.
904     PoolInfo[] public poolInfo;
905     // Info of each user that stakes LP tokens.
906     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
907 
908     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
909     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
910     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
911 
912     constructor(IERC20 rocketBunnyAddress) public {
913         rocketBunny = rocketBunnyAddress;
914         treasury = msg.sender;
915     }
916 
917     // Number of LP pools
918     function poolLength() external view returns (uint256) {
919         return poolInfo.length;
920     }
921 
922     function currentBlock() external view returns (uint256) {
923         return block.number;
924     }
925 
926     // Fund the farm, increase the end block
927     function initialFund(uint256 _pid, uint256 _amount, uint256 _startBlock) public {
928         require(poolInfo[_pid].startBlock == 0, "initialFund: initial funding already complete");
929         IERC20 erc20;
930         erc20 = poolInfo[_pid].rewardToken;
931         erc20.safeTransferFrom(address(msg.sender), address(this), _amount);
932         poolInfo[_pid].lastRewardBlock = _startBlock;
933         poolInfo[_pid].startBlock = _startBlock;
934         poolInfo[_pid].endBlock = _startBlock.add(_amount.div(poolInfo[_pid].rewardPerBlock));
935     }
936 
937     // Fund the farm, increase the end block
938     function fundMore(uint256 _pid, uint256 _amount) public {
939         require(block.number < poolInfo[_pid].endBlock, "fundMore: pool closed or use initialFund() first");
940         IERC20 erc20;
941         erc20 = poolInfo[_pid].rewardToken;
942         erc20.safeTransferFrom(address(msg.sender), address(this), _amount);
943         poolInfo[_pid].endBlock += _amount.div(poolInfo[_pid].rewardPerBlock);
944     }
945 
946     // Add a new lp to the pool. Can only be called by the owner.
947     // rewards are calculated per pool, so you can add the same lpToken multiple times
948     function add(IERC20 _lpToken, IERC20 _rewardToken, uint256 _rewardPerBlock, bool _withUpdate) public onlyOwner {
949         if (_withUpdate) {
950             massUpdatePools();
951         }
952         //###
953         poolInfo.push(PoolInfo({
954             lpToken: _lpToken,
955             lastRewardBlock: 0,
956             accERC20PerShare: 0,
957             rewardToken: _rewardToken,
958             startBlock: 0,
959             endBlock: 0,
960             rewardPerBlock: _rewardPerBlock,
961             paidOut: 0,
962             tokensStaked: 0,
963             gasAmount: gasAmount,   // defaults to global gas/eth fee
964             minStake: 0,
965             maxStake: ~uint256(0),
966             partnerTreasury: treasury,
967             partnerPercent: 0
968         }));
969     }
970 
971     //####
972     // Update the given pool's ERC20 reward per block. Can only be called by the owner.
973     function set(uint256 _pid, uint256 _rewardPerBlock, bool _withUpdate) public onlyOwner {
974         updatePool(_pid);   // prevents taking existing rewards from current stakers
975         poolInfo[_pid].rewardPerBlock = _rewardPerBlock;
976         if (_withUpdate) {
977             updatePool(_pid);
978         }
979     }
980 
981     function minStake(uint256 _pid, uint256 _minStake) public onlyOwner {
982         poolInfo[_pid].minStake = _minStake;
983     }
984 
985     function maxStake(uint256 _pid, uint256 _maxStake) public onlyOwner {
986         poolInfo[_pid].maxStake = _maxStake;
987     }
988 
989     // View function to see deposited LP for a user.
990     function deposited(uint256 _pid, address _user) external view returns (uint256) {
991         UserInfo storage user = userInfo[_pid][_user];
992         return user.amount;
993     }
994 
995     // View function to see pending ERC20s for a user.
996     function pending(uint256 _pid, address _user) external view returns (uint256) {
997         PoolInfo storage pool = poolInfo[_pid];
998         UserInfo storage user = userInfo[_pid][_user];
999         uint256 accERC20PerShare = pool.accERC20PerShare;
1000         
1001         uint256 lpSupply = pool.tokensStaked;
1002 
1003         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1004             uint256 lastBlock = block.number < pool.endBlock ? block.number : pool.endBlock;
1005             uint256 nrOfBlocks = lastBlock.sub(pool.lastRewardBlock);
1006             uint256 erc20Reward = nrOfBlocks.mul(pool.rewardPerBlock);
1007             accERC20PerShare = accERC20PerShare.add(erc20Reward.mul(1e36).div(lpSupply));
1008         }
1009 
1010         return user.amount.mul(accERC20PerShare).div(1e36).sub(user.rewardDebt);
1011     }
1012 
1013     // View function for total reward the farm has yet to pay out.
1014     function totalPending(uint256 _pid) external view returns (uint256) {
1015         if (block.number <= poolInfo[_pid].startBlock) {
1016             return 0;
1017         }
1018 
1019         uint256 lastBlock = block.number < poolInfo[_pid].endBlock ? block.number : poolInfo[_pid].endBlock;
1020         return poolInfo[_pid].rewardPerBlock.mul(lastBlock - poolInfo[_pid].startBlock).sub(poolInfo[_pid].paidOut);
1021     }
1022 
1023     // Update reward variables for all pools. Be careful of gas spending!
1024     function massUpdatePools() public {
1025         uint256 length = poolInfo.length;
1026         for (uint256 pid = 0; pid < length; ++pid) {
1027             updatePool(pid);
1028         }
1029     }
1030 
1031     // Update reward variables of the given pool to be up-to-date.
1032     function updatePool(uint256 _pid) public {
1033         PoolInfo storage pool = poolInfo[_pid];
1034         uint256 lastBlock = block.number < pool.endBlock ? block.number : pool.endBlock;
1035 
1036         if (lastBlock <= pool.lastRewardBlock) {
1037             return;
1038         }
1039         uint256 lpSupply = pool.tokensStaked;
1040         if (lpSupply == 0) {
1041             pool.lastRewardBlock = lastBlock;
1042             return;
1043         }
1044 
1045         uint256 nrOfBlocks = lastBlock.sub(pool.lastRewardBlock);
1046         uint256 erc20Reward = nrOfBlocks.mul(pool.rewardPerBlock);
1047 
1048         pool.accERC20PerShare = pool.accERC20PerShare.add(erc20Reward.mul(1e36).div(lpSupply));
1049         pool.lastRewardBlock = block.number;
1050     }
1051 
1052     // Deposit LP tokens to VendingMachine for ERC20 allocation.
1053     function deposit(uint256 _pid, uint256 _amount) public payable {
1054         if(accessTokenRequired){
1055             require(accessToken.balanceOf(msg.sender) >= accessTokenMin, 'Must have minimum amount of access token!');
1056         }
1057         PoolInfo storage pool = poolInfo[_pid];
1058         uint256 poolGasAmount = pool.gasAmount;
1059         require(msg.value >= poolGasAmount, 'Correct gas amount must be sent!');
1060         require(_amount >= pool.minStake && _amount <= pool.maxStake, 'Min/Max stake required!');
1061 
1062         UserInfo storage user = userInfo[_pid][msg.sender];
1063         updatePool(_pid);
1064         if (user.amount > 0) {
1065             uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
1066             erc20Transfer(msg.sender, _pid, pendingAmount);
1067         }
1068 
1069         uint256 startTokenBalance = pool.lpToken.balanceOf(address(this));
1070         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1071         uint256 endTokenBalance = pool.lpToken.balanceOf(address(this));
1072         uint256 trueDepositedTokens = endTokenBalance.sub(startTokenBalance);
1073 
1074         user.amount = user.amount.add(trueDepositedTokens);
1075         pool.tokensStaked = pool.tokensStaked.add(trueDepositedTokens);
1076         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
1077         
1078         // remit eth fee according to partner status 
1079         if (pool.partnerPercent == 0) {
1080             treasury.transfer(msg.value);
1081         } else {
1082             uint256 totalAmount = msg.value;
1083             uint256 partnerAmount = totalAmount.mul(pool.partnerPercent).div(10000);
1084             uint256 treasuryAmount = totalAmount.sub(partnerAmount);
1085             treasury.transfer(treasuryAmount);
1086             pool.partnerTreasury.transfer(partnerAmount);
1087         }
1088         
1089         emit Deposit(msg.sender, _pid, _amount);
1090     }
1091 
1092     // Withdraw LP tokens from VendingMachine.
1093     function withdraw(uint256 _pid, uint256 _amount) public payable {
1094         if(accessTokenRequired){
1095             require(accessToken.balanceOf(msg.sender) >= accessTokenMin, 'Must have minimum amount of access token!');
1096         }
1097         PoolInfo storage pool = poolInfo[_pid];
1098         uint256 poolGasAmount = pool.gasAmount;
1099         require(msg.value >= poolGasAmount, 'Correct gas amount must be sent!');
1100 
1101         UserInfo storage user = userInfo[_pid][msg.sender];
1102         require(user.amount >= _amount, "withdraw: can't withdraw more than deposit");
1103         updatePool(_pid);
1104         uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
1105         erc20Transfer(msg.sender, _pid, pendingAmount);
1106         user.amount = user.amount.sub(_amount);
1107         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
1108         
1109         if(_amount > 0){
1110             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1111             pool.tokensStaked = pool.tokensStaked.sub(_amount);
1112         }
1113 
1114         // remit eth fee according to partner status 
1115         if (pool.partnerPercent == 0) {
1116             treasury.transfer(msg.value);
1117         } else {
1118             uint256 totalAmount = msg.value;
1119             uint256 partnerAmount = totalAmount.mul(pool.partnerPercent).div(10000);
1120             uint256 treasuryAmount = totalAmount.sub(partnerAmount);
1121             treasury.transfer(treasuryAmount);
1122             pool.partnerTreasury.transfer(partnerAmount);
1123         }
1124 
1125         emit Withdraw(msg.sender, _pid, _amount);
1126     }
1127 
1128     // Withdraw without caring about rewards. EMERGENCY ONLY.
1129     function emergencyWithdraw(uint256 _pid) public {
1130         PoolInfo storage pool = poolInfo[_pid];
1131         UserInfo storage user = userInfo[_pid][msg.sender];
1132         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1133         pool.tokensStaked = pool.tokensStaked.sub(user.amount);
1134         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1135         user.amount = 0;
1136         user.rewardDebt = 0;
1137     }
1138 
1139     // Transfer ERC20 and update the required ERC20 to payout all rewards
1140     function erc20Transfer(address _to, uint256 _pid, uint256 _amount) internal {
1141         IERC20 erc20;
1142         erc20 = poolInfo[_pid].rewardToken;
1143         erc20.transfer(_to, _amount);
1144         poolInfo[_pid].paidOut += _amount;
1145     }
1146     
1147     // adjust default/global gas fee
1148     function adjustGasGlobal(uint256 newgas) public onlyOwner {
1149         gasAmount = newgas;
1150     }
1151 
1152     // access token settings
1153     function changeAccessToken(IERC20 newToken) public onlyOwner {
1154         accessToken = newToken;
1155     }
1156     function changeAccessMin(uint256 newMin) public onlyOwner {
1157         accessTokenMin = newMin;
1158     }
1159     function changeAccessTknReq(bool setting) public onlyOwner {
1160         accessTokenRequired = setting;
1161     }
1162 
1163     // adjust pool gas/eth fee
1164     function adjustPoolGas(uint256 _pid, uint256 newgas) public onlyOwner {
1165         poolInfo[_pid].gasAmount = newgas;
1166     }
1167 
1168     function transferExtraBunny(address _recipient) public onlyOwner {
1169         uint256 length = poolInfo.length;
1170         uint256 bunnyHeld;
1171         uint256 bunnyBalance = rocketBunny.balanceOf(address(this));
1172         for (uint256 pid = 0; pid < length; ++pid) {
1173             if(poolInfo[pid].lpToken == rocketBunny){
1174                 bunnyHeld = bunnyHeld.add(poolInfo[pid].tokensStaked);
1175             }
1176         }
1177         uint256 bunnyYield = bunnyBalance.sub(bunnyHeld);
1178         rocketBunny.transfer(_recipient, bunnyYield);
1179     }
1180 
1181     // change global treasury
1182     function changeTreasury(address payable newTreasury) public onlyOwner {
1183         treasury = newTreasury;
1184     }
1185 
1186     function changePartnerTreasury(uint256 _pid, address payable newTreasury) public onlyOwner {
1187         poolInfo[_pid].partnerTreasury = newTreasury;
1188     }
1189     
1190     function changePartnerPercent(uint256 _pid, uint256 newPercent) public onlyOwner {
1191         poolInfo[_pid].partnerPercent = newPercent;
1192     }
1193 
1194     function transfer() public onlyOwner {
1195         treasury.transfer(address(this).balance);
1196     }
1197 }