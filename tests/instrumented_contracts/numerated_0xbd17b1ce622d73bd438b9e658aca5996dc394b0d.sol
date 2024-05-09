1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 
6 pragma solidity ^0.6.0;
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
84 
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
246 
247 
248 pragma solidity ^0.6.2;
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
390 
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
467 
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
713 
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
740 
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
810 
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
1117 // File: contracts/PickleToken.sol
1118 
1119 pragma solidity 0.6.12;
1120 
1121 
1122 
1123 
1124 // PickleToken with Governance.
1125 contract PickleToken is ERC20("PickleToken", "PICKLE"), Ownable {
1126     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1127     function mint(address _to, uint256 _amount) public onlyOwner {
1128         _mint(_to, _amount);
1129     }
1130 }
1131 
1132 // File: contracts/curve/ICurveFiCurve.sol
1133 
1134 pragma solidity ^0.6.12;
1135 
1136 interface ICurveFiCurve {
1137     // All we care about is the ratio of each coin
1138     function balances(int128 arg0) external returns (uint256 out);
1139 }
1140 
1141 // File: contracts/MasterChef.sol
1142 
1143 pragma solidity 0.6.12;
1144 
1145 
1146 
1147 
1148 
1149 
1150 
1151 
1152 // MasterChef was the master of pickle. He now governs over PICKLES. He can make Pickles and he is a fair guy.
1153 //
1154 // Note that it's ownable and the owner wields tremendous power. The ownership
1155 // will be transferred to a governance smart contract once PICKLES is sufficiently
1156 // distributed and the community can show to govern itself.
1157 //
1158 // Have fun reading it. Hopefully it's bug-free. God bless.
1159 contract MasterChef is Ownable {
1160     using SafeMath for uint256;
1161     using SafeERC20 for IERC20;
1162 
1163     // Info of each user.
1164     struct UserInfo {
1165         uint256 amount; // How many LP tokens the user has provided.
1166         uint256 rewardDebt; // Reward debt. See explanation below.
1167         //
1168         // We do some fancy math here. Basically, any point in time, the amount of PICKLEs
1169         // entitled to a user but is pending to be distributed is:
1170         //
1171         //   pending reward = (user.amount * pool.accPicklePerShare) - user.rewardDebt
1172         //
1173         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1174         //   1. The pool's `accPicklePerShare` (and `lastRewardBlock`) gets updated.
1175         //   2. User receives the pending reward sent to his/her address.
1176         //   3. User's `amount` gets updated.
1177         //   4. User's `rewardDebt` gets updated.
1178     }
1179 
1180     // Info of each pool.
1181     struct PoolInfo {
1182         IERC20 lpToken; // Address of LP token contract.
1183         uint256 allocPoint; // How many allocation points assigned to this pool. PICKLEs to distribute per block.
1184         uint256 lastRewardBlock; // Last block number that PICKLEs distribution occurs.
1185         uint256 accPicklePerShare; // Accumulated PICKLEs per share, times 1e12. See below.
1186     }
1187 
1188     // The PICKLE TOKEN!
1189     PickleToken public pickle;
1190     // Dev fund (2%, initially)
1191     uint256 public devFundDivRate = 50;
1192     // Dev address.
1193     address public devaddr;
1194     // Block number when bonus PICKLE period ends.
1195     uint256 public bonusEndBlock;
1196     // PICKLE tokens created per block.
1197     uint256 public picklePerBlock;
1198     // Bonus muliplier for early pickle makers.
1199     uint256 public constant BONUS_MULTIPLIER = 10;
1200 
1201     // Info of each pool.
1202     PoolInfo[] public poolInfo;
1203     // Info of each user that stakes LP tokens.
1204     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1205     // Total allocation points. Must be the sum of all allocation points in all pools.
1206     uint256 public totalAllocPoint = 0;
1207     // The block number when PICKLE mining starts.
1208     uint256 public startBlock;
1209 
1210     // Events
1211     event Recovered(address token, uint256 amount);
1212     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1213     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1214     event EmergencyWithdraw(
1215         address indexed user,
1216         uint256 indexed pid,
1217         uint256 amount
1218     );
1219 
1220     constructor(
1221         PickleToken _pickle,
1222         address _devaddr,
1223         uint256 _picklePerBlock,
1224         uint256 _startBlock,
1225         uint256 _bonusEndBlock
1226     ) public {
1227         pickle = _pickle;
1228         devaddr = _devaddr;
1229         picklePerBlock = _picklePerBlock;
1230         bonusEndBlock = _bonusEndBlock;
1231         startBlock = _startBlock;
1232     }
1233 
1234     function poolLength() external view returns (uint256) {
1235         return poolInfo.length;
1236     }
1237 
1238     // Add a new lp to the pool. Can only be called by the owner.
1239     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1240     function add(
1241         uint256 _allocPoint,
1242         IERC20 _lpToken,
1243         bool _withUpdate
1244     ) public onlyOwner {
1245         if (_withUpdate) {
1246             massUpdatePools();
1247         }
1248         uint256 lastRewardBlock = block.number > startBlock
1249             ? block.number
1250             : startBlock;
1251         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1252         poolInfo.push(
1253             PoolInfo({
1254                 lpToken: _lpToken,
1255                 allocPoint: _allocPoint,
1256                 lastRewardBlock: lastRewardBlock,
1257                 accPicklePerShare: 0
1258             })
1259         );
1260     }
1261 
1262     // Update the given pool's PICKLE allocation point. Can only be called by the owner.
1263     function set(
1264         uint256 _pid,
1265         uint256 _allocPoint,
1266         bool _withUpdate
1267     ) public onlyOwner {
1268         if (_withUpdate) {
1269             massUpdatePools();
1270         }
1271         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1272             _allocPoint
1273         );
1274         poolInfo[_pid].allocPoint = _allocPoint;
1275     }
1276 
1277     // Return reward multiplier over the given _from to _to block.
1278     function getMultiplier(uint256 _from, uint256 _to)
1279         public
1280         view
1281         returns (uint256)
1282     {
1283         if (_to <= bonusEndBlock) {
1284             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1285         } else if (_from >= bonusEndBlock) {
1286             return _to.sub(_from);
1287         } else {
1288             return
1289                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1290                     _to.sub(bonusEndBlock)
1291                 );
1292         }
1293     }
1294 
1295     // View function to see pending PICKLEs on frontend.
1296     function pendingPickle(uint256 _pid, address _user)
1297         external
1298         view
1299         returns (uint256)
1300     {
1301         PoolInfo storage pool = poolInfo[_pid];
1302         UserInfo storage user = userInfo[_pid][_user];
1303         uint256 accPicklePerShare = pool.accPicklePerShare;
1304         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1305         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1306             uint256 multiplier = getMultiplier(
1307                 pool.lastRewardBlock,
1308                 block.number
1309             );
1310             uint256 pickleReward = multiplier
1311                 .mul(picklePerBlock)
1312                 .mul(pool.allocPoint)
1313                 .div(totalAllocPoint);
1314             accPicklePerShare = accPicklePerShare.add(
1315                 pickleReward.mul(1e12).div(lpSupply)
1316             );
1317         }
1318         return
1319             user.amount.mul(accPicklePerShare).div(1e12).sub(user.rewardDebt);
1320     }
1321 
1322     // Update reward vairables for all pools. Be careful of gas spending!
1323     function massUpdatePools() public {
1324         uint256 length = poolInfo.length;
1325         for (uint256 pid = 0; pid < length; ++pid) {
1326             updatePool(pid);
1327         }
1328     }
1329 
1330     // Update reward variables of the given pool to be up-to-date.
1331     function updatePool(uint256 _pid) public {
1332         PoolInfo storage pool = poolInfo[_pid];
1333         if (block.number <= pool.lastRewardBlock) {
1334             return;
1335         }
1336         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1337         if (lpSupply == 0) {
1338             pool.lastRewardBlock = block.number;
1339             return;
1340         }
1341         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1342         uint256 pickleReward = multiplier
1343             .mul(picklePerBlock)
1344             .mul(pool.allocPoint)
1345             .div(totalAllocPoint);
1346         pickle.mint(devaddr, pickleReward.div(devFundDivRate));
1347         pickle.mint(address(this), pickleReward);
1348         pool.accPicklePerShare = pool.accPicklePerShare.add(
1349             pickleReward.mul(1e12).div(lpSupply)
1350         );
1351         pool.lastRewardBlock = block.number;
1352     }
1353 
1354     // Deposit LP tokens to MasterChef for PICKLE allocation.
1355     function deposit(uint256 _pid, uint256 _amount) public {
1356         PoolInfo storage pool = poolInfo[_pid];
1357         UserInfo storage user = userInfo[_pid][msg.sender];
1358         updatePool(_pid);
1359         if (user.amount > 0) {
1360             uint256 pending = user
1361                 .amount
1362                 .mul(pool.accPicklePerShare)
1363                 .div(1e12)
1364                 .sub(user.rewardDebt);
1365             safePickleTransfer(msg.sender, pending);
1366         }
1367         pool.lpToken.safeTransferFrom(
1368             address(msg.sender),
1369             address(this),
1370             _amount
1371         );
1372         user.amount = user.amount.add(_amount);
1373         user.rewardDebt = user.amount.mul(pool.accPicklePerShare).div(1e12);
1374         emit Deposit(msg.sender, _pid, _amount);
1375     }
1376 
1377     // Withdraw LP tokens from MasterChef.
1378     function withdraw(uint256 _pid, uint256 _amount) public {
1379         PoolInfo storage pool = poolInfo[_pid];
1380         UserInfo storage user = userInfo[_pid][msg.sender];
1381         require(user.amount >= _amount, "withdraw: not good");
1382         updatePool(_pid);
1383         uint256 pending = user.amount.mul(pool.accPicklePerShare).div(1e12).sub(
1384             user.rewardDebt
1385         );
1386         safePickleTransfer(msg.sender, pending);
1387         user.amount = user.amount.sub(_amount);
1388         user.rewardDebt = user.amount.mul(pool.accPicklePerShare).div(1e12);
1389         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1390         emit Withdraw(msg.sender, _pid, _amount);
1391     }
1392 
1393     // Withdraw without caring about rewards. EMERGENCY ONLY.
1394     function emergencyWithdraw(uint256 _pid) public {
1395         PoolInfo storage pool = poolInfo[_pid];
1396         UserInfo storage user = userInfo[_pid][msg.sender];
1397         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1398         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1399         user.amount = 0;
1400         user.rewardDebt = 0;
1401     }
1402 
1403     // Safe pickle transfer function, just in case if rounding error causes pool to not have enough PICKLEs.
1404     function safePickleTransfer(address _to, uint256 _amount) internal {
1405         uint256 pickleBal = pickle.balanceOf(address(this));
1406         if (_amount > pickleBal) {
1407             pickle.transfer(_to, pickleBal);
1408         } else {
1409             pickle.transfer(_to, _amount);
1410         }
1411     }
1412 
1413     // Update dev address by the previous dev.
1414     function dev(address _devaddr) public {
1415         require(msg.sender == devaddr, "dev: wut?");
1416         devaddr = _devaddr;
1417     }
1418 
1419     // **** Additional functions separate from the original masterchef contract ****
1420 
1421     function setPicklePerBlock(uint256 _picklePerBlock) public onlyOwner {
1422         require(_picklePerBlock > 0, "!picklePerBlock-0");
1423 
1424         picklePerBlock = _picklePerBlock;
1425     }
1426 
1427     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1428         bonusEndBlock = _bonusEndBlock;
1429     }
1430 
1431     function setDevFundDivRate(uint256 _devFundDivRate) public onlyOwner {
1432         require(_devFundDivRate > 0, "!devFundDivRate-0");
1433         devFundDivRate = _devFundDivRate;
1434     }
1435 }