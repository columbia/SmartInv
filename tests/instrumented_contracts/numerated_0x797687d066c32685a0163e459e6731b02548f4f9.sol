1 /* 
2 Contact us at our telegram: t.me/minionfarm
3 forked from ROT and SUSHI and YUNO and Kimchi
4 */
5 
6 pragma solidity ^0.6.5;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 // File: @openzeppelin/contracts/math/SafeMath.sol
83 
84 // SPDX-License-Identifier: MIT
85 
86 pragma solidity ^0.6.0;
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      *
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Address.sol
245 
246 // SPDX-License-Identifier: MIT
247 
248 pragma solidity ^0.6.5;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
273         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
274         // for accounts without code, i.e. `keccak256('')`
275         bytes32 codehash;
276         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
277         // solhint-disable-next-line no-inline-assembly
278         assembly { codehash := extcodehash(account) }
279         return (codehash != accountHash && codehash != 0x0);
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
302         (bool success, ) = recipient.call{ value: amount }("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain`call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325       return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
335         return _functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         return _functionCallWithValue(target, data, value, errorMessage);
362     }
363 
364     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
365         require(isContract(target), "Address: call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 // solhint-disable-next-line no-inline-assembly
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
389 
390 // SPDX-License-Identifier: MIT
391 
392 pragma solidity ^0.6.0;
393 
394 
395 
396 
397 /**
398  * @title SafeERC20
399  * @dev Wrappers around ERC20 operations that throw on failure (when the token
400  * contract returns false). Tokens that return no value (and instead revert or
401  * throw on failure) are also supported, non-reverting calls are assumed to be
402  * successful.
403  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
404  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
405  */
406 library SafeERC20 {
407     using SafeMath for uint256;
408     using Address for address;
409 
410     function safeTransfer(IERC20 token, address to, uint256 value) internal {
411         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
412     }
413 
414     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
415         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
416     }
417 
418     /**
419      * @dev Deprecated. This function has issues similar to the ones found in
420      * {IERC20-approve}, and its usage is discouraged.
421      *
422      * Whenever possible, use {safeIncreaseAllowance} and
423      * {safeDecreaseAllowance} instead.
424      */
425     function safeApprove(IERC20 token, address spender, uint256 value) internal {
426         // safeApprove should only be called when setting an initial allowance,
427         // or when resetting it to zero. To increase and decrease it, use
428         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
429         // solhint-disable-next-line max-line-length
430         require((value == 0) || (token.allowance(address(this), spender) == 0),
431             "SafeERC20: approve from non-zero to non-zero allowance"
432         );
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
434     }
435 
436     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
437         uint256 newAllowance = token.allowance(address(this), spender).add(value);
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
439     }
440 
441     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
442         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
443         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
444     }
445 
446     /**
447      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
448      * on the return value: the return value is optional (but if data is returned, it must not be false).
449      * @param token The token targeted by the call.
450      * @param data The call data (encoded using abi.encode or one of its variants).
451      */
452     function _callOptionalReturn(IERC20 token, bytes memory data) private {
453         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
454         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
455         // the target address contains contract code and also asserts for success in the low-level call.
456 
457         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
458         if (returndata.length > 0) { // Return data is optional
459             // solhint-disable-next-line max-line-length
460             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
466 
467 // SPDX-License-Identifier: MIT
468 
469 pragma solidity ^0.6.0;
470 
471 /**
472  * @dev Library for managing
473  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
474  * types.
475  *
476  * Sets have the following properties:
477  *
478  * - Elements are added, removed, and checked for existence in constant time
479  * (O(1)).
480  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
481  *
482  * ```
483  * contract Example {
484  *     // Add the library methods
485  *     using EnumerableSet for EnumerableSet.AddressSet;
486  *
487  *     // Declare a set state variable
488  *     EnumerableSet.AddressSet private mySet;
489  * }
490  * ```
491  *
492  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
493  * (`UintSet`) are supported.
494  */
495 library EnumerableSet {
496     // To implement this library for multiple types with as little code
497     // repetition as possible, we write it in terms of a generic Set type with
498     // bytes32 values.
499     // The Set implementation uses private functions, and user-facing
500     // implementations (such as AddressSet) are just wrappers around the
501     // underlying Set.
502     // This means that we can only create new EnumerableSets for types that fit
503     // in bytes32.
504 
505     struct Set {
506         // Storage of set values
507         bytes32[] _values;
508 
509         // Position of the value in the `values` array, plus 1 because index 0
510         // means a value is not in the set.
511         mapping (bytes32 => uint256) _indexes;
512     }
513 
514     /**
515      * @dev Add a value to a set. O(1).
516      *
517      * Returns true if the value was added to the set, that is if it was not
518      * already present.
519      */
520     function _add(Set storage set, bytes32 value) private returns (bool) {
521         if (!_contains(set, value)) {
522             set._values.push(value);
523             // The value is stored at length-1, but we add 1 to all indexes
524             // and use 0 as a sentinel value
525             set._indexes[value] = set._values.length;
526             return true;
527         } else {
528             return false;
529         }
530     }
531 
532     /**
533      * @dev Removes a value from a set. O(1).
534      *
535      * Returns true if the value was removed from the set, that is if it was
536      * present.
537      */
538     function _remove(Set storage set, bytes32 value) private returns (bool) {
539         // We read and store the value's index to prevent multiple reads from the same storage slot
540         uint256 valueIndex = set._indexes[value];
541 
542         if (valueIndex != 0) { // Equivalent to contains(set, value)
543             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
544             // the array, and then remove the last element (sometimes called as 'swap and pop').
545             // This modifies the order of the array, as noted in {at}.
546 
547             uint256 toDeleteIndex = valueIndex - 1;
548             uint256 lastIndex = set._values.length - 1;
549 
550             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
551             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
552 
553             bytes32 lastvalue = set._values[lastIndex];
554 
555             // Move the last value to the index where the value to delete is
556             set._values[toDeleteIndex] = lastvalue;
557             // Update the index for the moved value
558             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
559 
560             // Delete the slot where the moved value was stored
561             set._values.pop();
562 
563             // Delete the index for the deleted slot
564             delete set._indexes[value];
565 
566             return true;
567         } else {
568             return false;
569         }
570     }
571 
572     /**
573      * @dev Returns true if the value is in the set. O(1).
574      */
575     function _contains(Set storage set, bytes32 value) private view returns (bool) {
576         return set._indexes[value] != 0;
577     }
578 
579     /**
580      * @dev Returns the number of values on the set. O(1).
581      */
582     function _length(Set storage set) private view returns (uint256) {
583         return set._values.length;
584     }
585 
586    /**
587     * @dev Returns the value stored at position `index` in the set. O(1).
588     *
589     * Note that there are no guarantees on the ordering of values inside the
590     * array, and it may change when more values are added or removed.
591     *
592     * Requirements:
593     *
594     * - `index` must be strictly less than {length}.
595     */
596     function _at(Set storage set, uint256 index) private view returns (bytes32) {
597         require(set._values.length > index, "EnumerableSet: index out of bounds");
598         return set._values[index];
599     }
600 
601     // AddressSet
602 
603     struct AddressSet {
604         Set _inner;
605     }
606 
607     /**
608      * @dev Add a value to a set. O(1).
609      *
610      * Returns true if the value was added to the set, that is if it was not
611      * already present.
612      */
613     function add(AddressSet storage set, address value) internal returns (bool) {
614         return _add(set._inner, bytes32(uint256(value)));
615     }
616 
617     /**
618      * @dev Removes a value from a set. O(1).
619      *
620      * Returns true if the value was removed from the set, that is if it was
621      * present.
622      */
623     function remove(AddressSet storage set, address value) internal returns (bool) {
624         return _remove(set._inner, bytes32(uint256(value)));
625     }
626 
627     /**
628      * @dev Returns true if the value is in the set. O(1).
629      */
630     function contains(AddressSet storage set, address value) internal view returns (bool) {
631         return _contains(set._inner, bytes32(uint256(value)));
632     }
633 
634     /**
635      * @dev Returns the number of values in the set. O(1).
636      */
637     function length(AddressSet storage set) internal view returns (uint256) {
638         return _length(set._inner);
639     }
640 
641    /**
642     * @dev Returns the value stored at position `index` in the set. O(1).
643     *
644     * Note that there are no guarantees on the ordering of values inside the
645     * array, and it may change when more values are added or removed.
646     *
647     * Requirements:
648     *
649     * - `index` must be strictly less than {length}.
650     */
651     function at(AddressSet storage set, uint256 index) internal view returns (address) {
652         return address(uint256(_at(set._inner, index)));
653     }
654 
655 
656     // UintSet
657 
658     struct UintSet {
659         Set _inner;
660     }
661 
662     /**
663      * @dev Add a value to a set. O(1).
664      *
665      * Returns true if the value was added to the set, that is if it was not
666      * already present.
667      */
668     function add(UintSet storage set, uint256 value) internal returns (bool) {
669         return _add(set._inner, bytes32(value));
670     }
671 
672     /**
673      * @dev Removes a value from a set. O(1).
674      *
675      * Returns true if the value was removed from the set, that is if it was
676      * present.
677      */
678     function remove(UintSet storage set, uint256 value) internal returns (bool) {
679         return _remove(set._inner, bytes32(value));
680     }
681 
682     /**
683      * @dev Returns true if the value is in the set. O(1).
684      */
685     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
686         return _contains(set._inner, bytes32(value));
687     }
688 
689     /**
690      * @dev Returns the number of values on the set. O(1).
691      */
692     function length(UintSet storage set) internal view returns (uint256) {
693         return _length(set._inner);
694     }
695 
696    /**
697     * @dev Returns the value stored at position `index` in the set. O(1).
698     *
699     * Note that there are no guarantees on the ordering of values inside the
700     * array, and it may change when more values are added or removed.
701     *
702     * Requirements:
703     *
704     * - `index` must be strictly less than {length}.
705     */
706     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
707         return uint256(_at(set._inner, index));
708     }
709 }
710 
711 // File: @openzeppelin/contracts/GSN/Context.sol
712 
713 // SPDX-License-Identifier: MIT
714 
715 pragma solidity ^0.6.0;
716 
717 /*
718  * @dev Provides information about the current execution context, including the
719  * sender of the transaction and its data. While these are generally available
720  * via msg.sender and msg.data, they should not be accessed in such a direct
721  * manner, since when dealing with GSN meta-transactions the account sending and
722  * paying for execution may not be the actual sender (as far as an application
723  * is concerned).
724  *
725  * This contract is only required for intermediate, library-like contracts.
726  */
727 abstract contract Context {
728     function _msgSender() internal view virtual returns (address payable) {
729         return msg.sender;
730     }
731 
732     function _msgData() internal view virtual returns (bytes memory) {
733         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
734         return msg.data;
735     }
736 }
737 
738 // File: @openzeppelin/contracts/access/Ownable.sol
739 
740 // SPDX-License-Identifier: MIT
741 
742 pragma solidity ^0.6.0;
743 
744 /**
745  * @dev Contract module which provides a basic access control mechanism, where
746  * there is an account (an owner) that can be granted exclusive access to
747  * specific functions.
748  *
749  * By default, the owner account will be the one that deploys the contract. This
750  * can later be changed with {transferOwnership}.
751  *
752  * This module is used through inheritance. It will make available the modifier
753  * `onlyOwner`, which can be applied to your functions to restrict their use to
754  * the owner.
755  */
756 contract Ownable is Context {
757     address private _owner;
758 
759     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
760 
761     /**
762      * @dev Initializes the contract setting the deployer as the initial owner.
763      */
764     constructor () internal {
765         address msgSender = _msgSender();
766         _owner = msgSender;
767         emit OwnershipTransferred(address(0), msgSender);
768     }
769 
770     /**
771      * @dev Returns the address of the current owner.
772      */
773     function owner() public view returns (address) {
774         return _owner;
775     }
776 
777     /**
778      * @dev Throws if called by any account other than the owner.
779      */
780     modifier onlyOwner() {
781         require(_owner == _msgSender(), "Ownable: caller is not the owner");
782         _;
783     }
784 
785     /**
786      * @dev Leaves the contract without owner. It will not be possible to call
787      * `onlyOwner` functions anymore. Can only be called by the current owner.
788      *
789      * NOTE: Renouncing ownership will leave the contract without an owner,
790      * thereby removing any functionality that is only available to the owner.
791      */
792     function renounceOwnership() public virtual onlyOwner {
793         emit OwnershipTransferred(_owner, address(0));
794         _owner = address(0);
795     }
796 
797     /**
798      * @dev Transfers ownership of the contract to a new account (`newOwner`).
799      * Can only be called by the current owner.
800      */
801     function transferOwnership(address newOwner) public virtual onlyOwner {
802         require(newOwner != address(0), "Ownable: new owner is the zero address");
803         emit OwnershipTransferred(_owner, newOwner);
804         _owner = newOwner;
805     }
806 }
807 
808 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
809 
810 // SPDX-License-Identifier: MIT
811 
812 pragma solidity ^0.6.0;
813 
814 
815 
816 
817 
818 /**
819  * @dev Implementation of the {IERC20} interface.
820  *
821  * This implementation is agnostic to the way tokens are created. This means
822  * that a supply mechanism has to be added in a derived contract using {_mint}.
823  * For a generic mechanism see {ERC20PresetMinterPauser}.
824  *
825  * TIP: For a detailed writeup see our guide
826  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
827  * to implement supply mechanisms].
828  *
829  * We have followed general OpenZeppelin guidelines: functions revert instead
830  * of returning `false` on failure. This behavior is nonetheless conventional
831  * and does not conflict with the expectations of ERC20 applications.
832  *
833  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
834  * This allows applications to reconstruct the allowance for all accounts just
835  * by listening to said events. Other implementations of the EIP may not emit
836  * these events, as it isn't required by the specification.
837  *
838  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
839  * functions have been added to mitigate the well-known issues around setting
840  * allowances. See {IERC20-approve}.
841  */
842 contract ERC20 is Context, IERC20 {
843     using SafeMath for uint256;
844     using Address for address;
845 
846     mapping (address => uint256) private _balances;
847 
848     mapping (address => mapping (address => uint256)) private _allowances;
849 
850     uint256 private _totalSupply;
851 
852     string private _name;
853     string private _symbol;
854     uint8 private _decimals;
855 
856     /**
857      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
858      * a default value of 18.
859      *
860      * To select a different value for {decimals}, use {_setupDecimals}.
861      *
862      * All three of these values are immutable: they can only be set once during
863      * construction.
864      */
865     constructor (string memory name, string memory symbol) public {
866         _name = name;
867         _symbol = symbol;
868         _decimals = 18;
869     }
870 
871     /**
872      * @dev Returns the name of the token.
873      */
874     function name() public view returns (string memory) {
875         return _name;
876     }
877 
878     /**
879      * @dev Returns the symbol of the token, usually a shorter version of the
880      * name.
881      */
882     function symbol() public view returns (string memory) {
883         return _symbol;
884     }
885 
886     /**
887      * @dev Returns the number of decimals used to get its user representation.
888      * For example, if `decimals` equals `2`, a balance of `505` tokens should
889      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
890      *
891      * Tokens usually opt for a value of 18, imitating the relationship between
892      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
893      * called.
894      *
895      * NOTE: This information is only used for _display_ purposes: it in
896      * no way affects any of the arithmetic of the contract, including
897      * {IERC20-balanceOf} and {IERC20-transfer}.
898      */
899     function decimals() public view returns (uint8) {
900         return _decimals;
901     }
902 
903     /**
904      * @dev See {IERC20-totalSupply}.
905      */
906     function totalSupply() public view override returns (uint256) {
907         return _totalSupply;
908     }
909 
910     /**
911      * @dev See {IERC20-balanceOf}.
912      */
913     function balanceOf(address account) public view override returns (uint256) {
914         return _balances[account];
915     }
916 
917     /**
918      * @dev See {IERC20-transfer}.
919      *
920      * Requirements:
921      *
922      * - `recipient` cannot be the zero address.
923      * - the caller must have a balance of at least `amount`.
924      */
925     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
926         _transfer(_msgSender(), recipient, amount);
927         return true;
928     }
929 
930     /**
931      * @dev See {IERC20-allowance}.
932      */
933     function allowance(address owner, address spender) public view virtual override returns (uint256) {
934         return _allowances[owner][spender];
935     }
936 
937     /**
938      * @dev See {IERC20-approve}.
939      *
940      * Requirements:
941      *
942      * - `spender` cannot be the zero address.
943      */
944     function approve(address spender, uint256 amount) public virtual override returns (bool) {
945         _approve(_msgSender(), spender, amount);
946         return true;
947     }
948 
949     /**
950      * @dev See {IERC20-transferFrom}.
951      *
952      * Emits an {Approval} event indicating the updated allowance. This is not
953      * required by the EIP. See the note at the beginning of {ERC20};
954      *
955      * Requirements:
956      * - `sender` and `recipient` cannot be the zero address.
957      * - `sender` must have a balance of at least `amount`.
958      * - the caller must have allowance for ``sender``'s tokens of at least
959      * `amount`.
960      */
961     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
962         _transfer(sender, recipient, amount);
963         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
964         return true;
965     }
966 
967     /**
968      * @dev Atomically increases the allowance granted to `spender` by the caller.
969      *
970      * This is an alternative to {approve} that can be used as a mitigation for
971      * problems described in {IERC20-approve}.
972      *
973      * Emits an {Approval} event indicating the updated allowance.
974      *
975      * Requirements:
976      *
977      * - `spender` cannot be the zero address.
978      */
979     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
980         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
981         return true;
982     }
983 
984     /**
985      * @dev Atomically decreases the allowance granted to `spender` by the caller.
986      *
987      * This is an alternative to {approve} that can be used as a mitigation for
988      * problems described in {IERC20-approve}.
989      *
990      * Emits an {Approval} event indicating the updated allowance.
991      *
992      * Requirements:
993      *
994      * - `spender` cannot be the zero address.
995      * - `spender` must have allowance for the caller of at least
996      * `subtractedValue`.
997      */
998     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
999         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1000         return true;
1001     }
1002 
1003     /**
1004      * @dev Moves tokens `amount` from `sender` to `recipient`.
1005      *
1006      * This is internal function is equivalent to {transfer}, and can be used to
1007      * e.g. implement automatic token fees, slashing mechanisms, etc.
1008      *
1009      * Emits a {Transfer} event.
1010      *
1011      * Requirements:
1012      *
1013      * - `sender` cannot be the zero address.
1014      * - `recipient` cannot be the zero address.
1015      * - `sender` must have a balance of at least `amount`.
1016      */
1017     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1018         require(sender != address(0), "ERC20: transfer from the zero address");
1019         require(recipient != address(0), "ERC20: transfer to the zero address");
1020 
1021         _beforeTokenTransfer(sender, recipient, amount);
1022 
1023         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1024         _balances[recipient] = _balances[recipient].add(amount);
1025         emit Transfer(sender, recipient, amount);
1026     }
1027 
1028     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1029      * the total supply.
1030      *
1031      * Emits a {Transfer} event with `from` set to the zero address.
1032      *
1033      * Requirements
1034      *
1035      * - `to` cannot be the zero address.
1036      */
1037     function _mint(address account, uint256 amount) internal virtual {
1038         require(account != address(0), "ERC20: mint to the zero address");
1039 
1040         _beforeTokenTransfer(address(0), account, amount);
1041 
1042         _totalSupply = _totalSupply.add(amount);
1043         _balances[account] = _balances[account].add(amount);
1044         emit Transfer(address(0), account, amount);
1045     }
1046 
1047     /**
1048      * @dev Destroys `amount` tokens from `account`, reducing the
1049      * total supply.
1050      *
1051      * Emits a {Transfer} event with `to` set to the zero address.
1052      *
1053      * Requirements
1054      *
1055      * - `account` cannot be the zero address.
1056      * - `account` must have at least `amount` tokens.
1057      */
1058     function _burn(address account, uint256 amount) internal virtual {
1059         require(account != address(0), "ERC20: burn from the zero address");
1060 
1061         _beforeTokenTransfer(account, address(0), amount);
1062 
1063         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1064         _totalSupply = _totalSupply.sub(amount);
1065         emit Transfer(account, address(0), amount);
1066     }
1067 
1068     /**
1069      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1070      *
1071      * This is internal function is equivalent to `approve`, and can be used to
1072      * e.g. set automatic allowances for certain subsystems, etc.
1073      *
1074      * Emits an {Approval} event.
1075      *
1076      * Requirements:
1077      *
1078      * - `owner` cannot be the zero address.
1079      * - `spender` cannot be the zero address.
1080      */
1081     function _approve(address owner, address spender, uint256 amount) internal virtual {
1082         require(owner != address(0), "ERC20: approve from the zero address");
1083         require(spender != address(0), "ERC20: approve to the zero address");
1084 
1085         _allowances[owner][spender] = amount;
1086         emit Approval(owner, spender, amount);
1087     }
1088 
1089     /**
1090      * @dev Sets {decimals} to a value other than the default one of 18.
1091      *
1092      * WARNING: This function should only be called from the constructor. Most
1093      * applications that interact with token contracts will not expect
1094      * {decimals} to ever change, and may work incorrectly if it does.
1095      */
1096     function _setupDecimals(uint8 decimals_) internal {
1097         _decimals = decimals_;
1098     }
1099 
1100     /**
1101      * @dev Hook that is called before any transfer of tokens. This includes
1102      * minting and burning.
1103      *
1104      * Calling conditions:
1105      *
1106      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1107      * will be to transferred to `to`.
1108      * - when `from` is zero, `amount` tokens will be minted for `to`.
1109      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1110      * - `from` and `to` are never both zero.
1111      *
1112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1113      */
1114     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1115 }
1116 
1117 pragma solidity ^0.6.5;
1118 
1119 // MinionToken with Governance.
1120 contract MinionFarm is ERC20("minion.farm", "MNNF"), Ownable {
1121 
1122     // minion is an exact copy of SUSHI 
1123     using SafeMath for uint256;
1124 
1125     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1126         return super.transfer(recipient, amount);
1127     }
1128 
1129     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {      
1130         return super.transferFrom(sender, recipient, amount);
1131     }
1132 
1133     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (Reactor).
1134     function mint(address _to, uint256 _amount) public onlyOwner {
1135         _mint(_to, _amount);
1136         _moveDelegates(address(0), _delegates[_to], _amount);
1137     }
1138 
1139     // Copied and modified from YAM code:
1140     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1141     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1142     // Which is copied and modified from COMPOUND:
1143     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1144 
1145     /// @notice A record of each accounts delegate
1146     mapping (address => address) internal _delegates;
1147 
1148     /// @notice A checkpoint for marking number of votes from a given block
1149     struct Checkpoint {
1150         uint32 fromBlock;
1151         uint256 votes;
1152     }
1153 
1154     /// @notice A record of votes checkpoints for each account, by index
1155     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1156 
1157     /// @notice The number of checkpoints for each account
1158     mapping (address => uint32) public numCheckpoints;
1159 
1160     /// @notice The EIP-712 typehash for the contract's domain
1161     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1162 
1163     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1164     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1165 
1166     /// @notice A record of states for signing / validating signatures
1167     mapping (address => uint) public nonces;
1168 
1169       /// @notice An event thats emitted when an account changes its delegate
1170     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1171 
1172     /// @notice An event thats emitted when a delegate account's vote balance changes
1173     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1174 
1175     /**
1176      * @notice Delegate votes from `msg.sender` to `delegatee`
1177      * @param delegator The address to get delegatee for
1178      */
1179     function delegates(address delegator)
1180         external
1181         view
1182         returns (address)
1183     {
1184         return _delegates[delegator];
1185     }
1186 
1187    /**
1188     * @notice Delegate votes from `msg.sender` to `delegatee`
1189     * @param delegatee The address to delegate votes to
1190     */
1191     function delegate(address delegatee) external {
1192         return _delegate(msg.sender, delegatee);
1193     }
1194 
1195     /**
1196      * @notice Delegates votes from signatory to `delegatee`
1197      * @param delegatee The address to delegate votes to
1198      * @param nonce The contract state required to match the signature
1199      * @param expiry The time at which to expire the signature
1200      * @param v The recovery byte of the signature
1201      * @param r Half of the ECDSA signature pair
1202      * @param s Half of the ECDSA signature pair
1203      */
1204     function delegateBySig(
1205         address delegatee,
1206         uint nonce,
1207         uint expiry,
1208         uint8 v,
1209         bytes32 r,
1210         bytes32 s
1211     )
1212         external
1213     {
1214         bytes32 domainSeparator = keccak256(
1215             abi.encode(
1216                 DOMAIN_TYPEHASH,
1217                 keccak256(bytes(name())),
1218                 getChainId(),
1219                 address(this)
1220             )
1221         );
1222 
1223         bytes32 structHash = keccak256(
1224             abi.encode(
1225                 DELEGATION_TYPEHASH,
1226                 delegatee,
1227                 nonce,
1228                 expiry
1229             )
1230         );
1231 
1232         bytes32 digest = keccak256(
1233             abi.encodePacked(
1234                 "\x19\x01",
1235                 domainSeparator,
1236                 structHash
1237             )
1238         );
1239 
1240         address signatory = ecrecover(digest, v, r, s);
1241         require(signatory != address(0), "MINION::delegateBySig: invalid signature");
1242         require(nonce == nonces[signatory]++, "MINION::delegateBySig: invalid nonce");
1243         require(now <= expiry, "MINION::delegateBySig: signature expired");
1244         return _delegate(signatory, delegatee);
1245     }
1246 
1247     /**
1248      * @notice Gets the current votes balance for `account`
1249      * @param account The address to get votes balance
1250      * @return The number of current votes for `account`
1251      */
1252     function getCurrentVotes(address account)
1253         external
1254         view
1255         returns (uint256)
1256     {
1257         uint32 nCheckpoints = numCheckpoints[account];
1258         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1259     }
1260 
1261     /**
1262      * @notice Determine the prior number of votes for an account as of a block number
1263      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1264      * @param account The address of the account to check
1265      * @param blockNumber The block number to get the vote balance at
1266      * @return The number of votes the account had as of the given block
1267      */
1268     function getPriorVotes(address account, uint blockNumber)
1269         external
1270         view
1271         returns (uint256)
1272     {
1273         require(blockNumber < block.number, "MINION::getPriorVotes: not yet determined");
1274 
1275         uint32 nCheckpoints = numCheckpoints[account];
1276         if (nCheckpoints == 0) {
1277             return 0;
1278         }
1279 
1280         // First check most recent balance
1281         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1282             return checkpoints[account][nCheckpoints - 1].votes;
1283         }
1284 
1285         // Next check implicit zero balance
1286         if (checkpoints[account][0].fromBlock > blockNumber) {
1287             return 0;
1288         }
1289 
1290         uint32 lower = 0;
1291         uint32 upper = nCheckpoints - 1;
1292         while (upper > lower) {
1293             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1294             Checkpoint memory cp = checkpoints[account][center];
1295             if (cp.fromBlock == blockNumber) {
1296                 return cp.votes;
1297             } else if (cp.fromBlock < blockNumber) {
1298                 lower = center;
1299             } else {
1300                 upper = center - 1;
1301             }
1302         }
1303         return checkpoints[account][lower].votes;
1304     }
1305 
1306     function _delegate(address delegator, address delegatee)
1307         internal
1308     {
1309         address currentDelegate = _delegates[delegator];
1310         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MINIONs (not scaled);
1311         _delegates[delegator] = delegatee;
1312 
1313         emit DelegateChanged(delegator, currentDelegate, delegatee);
1314 
1315         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1316     }
1317 
1318     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1319         if (srcRep != dstRep && amount > 0) {
1320             if (srcRep != address(0)) {
1321                 // decrease old representative
1322                 uint32 srcRepNum = numCheckpoints[srcRep];
1323                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1324                 uint256 srcRepNew = srcRepOld.sub(amount);
1325                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1326             }
1327 
1328             if (dstRep != address(0)) {
1329                 // increase new representative
1330                 uint32 dstRepNum = numCheckpoints[dstRep];
1331                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1332                 uint256 dstRepNew = dstRepOld.add(amount);
1333                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1334             }
1335         }
1336     }
1337 
1338     function _writeCheckpoint(
1339         address delegatee,
1340         uint32 nCheckpoints,
1341         uint256 oldVotes,
1342         uint256 newVotes
1343     )
1344         internal
1345     {
1346         uint32 blockNumber = safe32(block.number, "MINION::_writeCheckpoint: block number exceeds 32 bits");
1347 
1348         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1349             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1350         } else {
1351             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1352             numCheckpoints[delegatee] = nCheckpoints + 1;
1353         }
1354 
1355         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1356     }
1357 
1358     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1359         require(n < 2**32, errorMessage);
1360         return uint32(n);
1361     }
1362 
1363     function getChainId() internal pure returns (uint) {
1364         uint256 chainId;
1365         assembly { chainId := chainid() }
1366         return chainId;
1367     }
1368 }
1369 
1370 // File: contracts/Reactor.sol
1371 
1372 pragma solidity ^0.6.5;
1373 
1374 
1375 interface IMigratorChef {
1376     // Perform LP token migration from legacy UniswapV2 to MinionSwap.
1377     // Take the current LP token address and return the new LP token address.
1378     // Migrator should have full access to the caller's LP token.
1379     // Return the new LP token address.
1380     //
1381     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1382     // MinionSwap must mint EXACTLY the same amount of MinionSwap LP tokens or
1383     // else something bad will happen. Traditional UniswapV2 does not
1384     // do that so be careful!
1385     function migrate(IERC20 token) external returns (IERC20);
1386 }
1387 
1388 // Reactor is an exact copy of SushiSwap
1389 // we have commented an few lines to remove the dev fund
1390 // the rest is exactly the same
1391 
1392 // Reactor is the master of Minion. He can make Minion and he is a fair guy.
1393 //
1394 // Note that it's ownable and the owner wields tremendous power. The ownership
1395 // will be transferred to a governance smart contract once MINION is sufficiently
1396 // distributed and the community can show to govern itself.
1397 //
1398 // Have fun reading it. Hopefully it's bug-free. God bless.
1399 contract Reactor is Ownable {
1400     using SafeMath for uint256;
1401     using SafeERC20 for IERC20;
1402 
1403     // Info of each user.
1404     struct UserInfo {
1405         uint256 amount;     // How many LP tokens the user has provided.
1406         uint256 rewardDebt; // Reward debt. See explanation below.
1407         //
1408         // We do some fancy math here. Basically, any point in time, the amount of MINIONs
1409         // entitled to a user but is pending to be distributed is:
1410         //
1411         //   pending reward = (user.amount * pool.accMinionPerShare) - user.rewardDebt
1412         //
1413         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1414         //   1. The pool's `accMinionPerShare` (and `lastRewardBlock`) gets updated.
1415         //   2. User receives the pending reward sent to his/her address.
1416         //   3. User's `amount` gets updated.
1417         //   4. User's `rewardDebt` gets updated.
1418     }
1419 
1420     // Info of each pool.
1421     struct PoolInfo {
1422         IERC20 lpToken;           // Address of LP token contract.
1423         uint256 allocPoint;       // How many allocation points assigned to this pool. MINIONs to distribute per block.
1424         uint256 lastRewardBlock;  // Last block number that MINIONs distribution occurs.
1425         uint256 accMinionPerShare; // Accumulated MINIONs per share, times 1e12. See below.
1426         bool taxable; // Accumulated MINIONs per share, times 1e12. See below.
1427     }
1428 
1429     // The MINION TOKEN!
1430     MinionFarm public minion;
1431 
1432     address private devaddr;
1433 
1434     // Block number when bonus MINION period ends.
1435     uint256 public bonusEndBlock;
1436     // MINION tokens created per block.
1437     uint256 public minionPerBlock;
1438     // Bonus muliplier for early minion makers.
1439     uint256 public constant BONUS_MULTIPLIER = 1;
1440     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1441     IMigratorChef public migrator;
1442 
1443     // Info of each pool.
1444     PoolInfo[] public poolInfo;
1445     // Info of each user that stakes LP tokens.
1446     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1447     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1448     uint256 public totalAllocPoint = 0;
1449     // The block number when MINION mining starts.
1450     uint256 public startBlock;
1451 
1452     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1453     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1454     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1455 
1456     constructor(
1457         MinionFarm _minion,
1458         address _devaddr,
1459         uint256 _minionPerBlock,
1460         uint256 _startBlock,
1461         uint256 _bonusEndBlock
1462     ) public {
1463         minion = _minion;
1464         devaddr = _devaddr;
1465         minionPerBlock = _minionPerBlock;
1466         bonusEndBlock = _bonusEndBlock;
1467         startBlock = _startBlock;
1468     }
1469 
1470     function poolLength() external view returns (uint256) {
1471         return poolInfo.length;
1472     }
1473 
1474     // Add a new lp to the pool. Can only be called by the owner.
1475     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1476     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, bool _taxable, uint256 _startBlock) public onlyOwner {
1477         if (_withUpdate) {
1478             massUpdatePools();
1479         }
1480         uint256 lastRewardBlock = _startBlock;
1481         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1482         poolInfo.push(PoolInfo({
1483             lpToken: _lpToken,
1484             allocPoint: _allocPoint,
1485             lastRewardBlock: lastRewardBlock,
1486             accMinionPerShare: 0,
1487             taxable: _taxable
1488         }));
1489     }
1490 
1491     // Update the given pool's MINION allocation point. Can only be called by the owner.
1492     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate, bool _taxable, uint256 _startBlock) public onlyOwner {
1493         if (_withUpdate) {
1494             massUpdatePools();
1495         }
1496         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1497         poolInfo[_pid].allocPoint = _allocPoint;
1498         poolInfo[_pid].taxable = _taxable;
1499         poolInfo[_pid].lastRewardBlock = _startBlock;
1500     }
1501 
1502     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1503         bonusEndBlock = _bonusEndBlock;
1504     }
1505 
1506     // Set the migrator contract. Can only be called by the owner.
1507     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1508         migrator = _migrator;
1509     }
1510 
1511     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1512     function migrate(uint256 _pid) public {
1513         require(address(migrator) != address(0), "migrate: no migrator");
1514         PoolInfo storage pool = poolInfo[_pid];
1515         IERC20 lpToken = pool.lpToken;
1516         uint256 bal = lpToken.balanceOf(address(this));
1517         lpToken.safeApprove(address(migrator), bal);
1518         IERC20 newLpToken = migrator.migrate(lpToken);
1519         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1520         pool.lpToken = newLpToken;
1521     }
1522 
1523     // Return reward multiplier over the given _from to _to block.
1524     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1525         if (_to <= bonusEndBlock) {
1526             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1527         } else if (_from >= bonusEndBlock) {
1528             return _to.sub(_from);
1529         } else {
1530             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1531                 _to.sub(bonusEndBlock)
1532             );
1533         }
1534     }
1535 
1536     // View function to see pending MINIONs on frontend.
1537     function pendingMinion(uint256 _pid, address _user) external view returns (uint256) {
1538         PoolInfo storage pool = poolInfo[_pid];
1539         UserInfo storage user = userInfo[_pid][_user];
1540         uint256 accMinionPerShare = pool.accMinionPerShare;
1541         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1542         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1543             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1544             uint256 minionReward = multiplier.mul(minionPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1545             accMinionPerShare = accMinionPerShare.add(minionReward.mul(1e12).div(lpSupply));
1546         }
1547         return user.amount.mul(accMinionPerShare).div(1e12).sub(user.rewardDebt);
1548     }
1549 
1550     // Update reward variables for all pools. Be careful of gas spending!
1551     function massUpdatePools() public {
1552         uint256 length = poolInfo.length;
1553         for (uint256 pid = 0; pid < length; ++pid) {
1554             updatePool(pid);
1555         }
1556     }
1557 
1558     // Update reward variables of the given pool to be up-to-date.
1559     function updatePool(uint256 _pid) public {
1560         PoolInfo storage pool = poolInfo[_pid];
1561         if (block.number <= pool.lastRewardBlock) {
1562             return;
1563         }
1564         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1565         if (lpSupply == 0) {
1566             pool.lastRewardBlock = block.number;
1567             return;
1568         }
1569         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1570         uint256 minionReward = multiplier.mul(minionPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1571         minion.mint(address(devaddr), minionReward.mul(10).div(100));
1572         minion.mint(address(this), minionReward);
1573         pool.accMinionPerShare = pool.accMinionPerShare.add(minionReward.mul(1e12).div(lpSupply));
1574         pool.lastRewardBlock = block.number;
1575     }
1576 
1577     // Deposit LP tokens to Reactor for MINION allocation.
1578     function deposit(uint256 _pid, uint256 _amount) public {
1579         PoolInfo storage pool = poolInfo[_pid];
1580         UserInfo storage user = userInfo[_pid][msg.sender];
1581         updatePool(_pid);
1582         if (user.amount > 0) {
1583             uint256 pending = user.amount.mul(pool.accMinionPerShare).div(1e12).sub(user.rewardDebt);
1584             safeMinionTransfer(msg.sender, pending);
1585         }
1586         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1587         user.amount = user.amount.add(_amount);
1588         user.rewardDebt = user.amount.mul(pool.accMinionPerShare).div(1e12);
1589         emit Deposit(msg.sender, _pid, _amount);
1590     }
1591 
1592     // Withdraw LP tokens from Reactor.
1593     function withdraw(uint256 _pid, uint256 _amount) public {
1594         PoolInfo storage pool = poolInfo[_pid];
1595         UserInfo storage user = userInfo[_pid][msg.sender];
1596         require(user.amount >= _amount, "withdraw: not good");
1597         updatePool(_pid);
1598         uint256 pending = user.amount.mul(pool.accMinionPerShare).div(1e12).sub(user.rewardDebt);
1599         safeMinionTransfer(msg.sender, pending);
1600         user.amount = user.amount.sub(_amount);
1601         user.rewardDebt = user.amount.mul(pool.accMinionPerShare).div(1e12);
1602         if (pool.taxable) {
1603             pool.lpToken.safeTransfer(address(devaddr), _amount.mul(25).div(10000));
1604             emit Withdraw(devaddr, _pid,  _amount.mul(25).div(10000));   
1605             pool.lpToken.safeTransfer(address(msg.sender), _amount.sub(_amount.mul(25).div(10000)));
1606             emit Withdraw(msg.sender, _pid, _amount.sub(_amount.mul(25).div(10000)));
1607         } else {
1608             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1609             emit Withdraw(msg.sender, _pid, _amount);
1610         }
1611 
1612     }
1613 
1614     // Withdraw without caring about rewards. EMERGENCY ONLY.
1615     function emergencyWithdraw(uint256 _pid) public {
1616         PoolInfo storage pool = poolInfo[_pid];
1617         UserInfo storage user = userInfo[_pid][msg.sender];
1618         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1619         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1620         user.amount = 0;
1621         user.rewardDebt = 0;
1622     }
1623 
1624     // Safe minion transfer function, just in case if rounding error causes pool to not have enough MINIONs.
1625     function safeMinionTransfer(address _to, uint256 _amount) internal {
1626         uint256 minionBal = minion.balanceOf(address(this));
1627         if (_amount > minionBal) {
1628             minion.transfer(_to, minionBal);
1629         } else {
1630             minion.transfer(_to, _amount);
1631         }
1632     }
1633 }
1634 
1635 /* 
1636 Contact us at our telegram: t.me/minionfarm
1637 forked from ROT and SUSHI and YUNO and Kimchi
1638 */