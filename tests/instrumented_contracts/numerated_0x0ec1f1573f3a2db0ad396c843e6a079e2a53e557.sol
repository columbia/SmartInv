1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT + WTFPL
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 pragma solidity ^0.6.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 
246 pragma solidity ^0.6.0;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
387 
388 
389 
390 pragma solidity ^0.6.0;
391 
392 
393 
394 
395 /**
396  * @title SafeERC20
397  * @dev Wrappers around ERC20 operations that throw on failure (when the token
398  * contract returns false). Tokens that return no value (and instead revert or
399  * throw on failure) are also supported, non-reverting calls are assumed to be
400  * successful.
401  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
402  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
403  */
404 library SafeERC20 {
405     using SafeMath for uint256;
406     using Address for address;
407 
408     function safeTransfer(IERC20 token, address to, uint256 value) internal {
409         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
410     }
411 
412     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
414     }
415 
416     /**
417      * @dev Deprecated. This function has issues similar to the ones found in
418      * {IERC20-approve}, and its usage is discouraged.
419      *
420      * Whenever possible, use {safeIncreaseAllowance} and
421      * {safeDecreaseAllowance} instead.
422      */
423     function safeApprove(IERC20 token, address spender, uint256 value) internal {
424         // safeApprove should only be called when setting an initial allowance,
425         // or when resetting it to zero. To increase and decrease it, use
426         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
427         // solhint-disable-next-line max-line-length
428         require((value == 0) || (token.allowance(address(this), spender) == 0),
429             "SafeERC20: approve from non-zero to non-zero allowance"
430         );
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
432     }
433 
434     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).add(value);
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     /**
445      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
446      * on the return value: the return value is optional (but if data is returned, it must not be false).
447      * @param token The token targeted by the call.
448      * @param data The call data (encoded using abi.encode or one of its variants).
449      */
450     function _callOptionalReturn(IERC20 token, bytes memory data) private {
451         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
452         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
453         // the target address contains contract code and also asserts for success in the low-level call.
454 
455         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
456         if (returndata.length > 0) { // Return data is optional
457             // solhint-disable-next-line max-line-length
458             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
459         }
460     }
461 }
462 
463 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
464 
465 
466 
467 pragma solidity ^0.6.0;
468 
469 /**
470  * @dev Library for managing
471  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
472  * types.
473  *
474  * Sets have the following properties:
475  *
476  * - Elements are added, removed, and checked for existence in constant time
477  * (O(1)).
478  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
479  *
480  * ```
481  * contract Example {
482  *     // Add the library methods
483  *     using EnumerableSet for EnumerableSet.AddressSet;
484  *
485  *     // Declare a set state variable
486  *     EnumerableSet.AddressSet private mySet;
487  * }
488  * ```
489  *
490  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
491  * (`UintSet`) are supported.
492  */
493 library EnumerableSet {
494     // To implement this library for multiple types with as little code
495     // repetition as possible, we write it in terms of a generic Set type with
496     // bytes32 values.
497     // The Set implementation uses private functions, and user-facing
498     // implementations (such as AddressSet) are just wrappers around the
499     // underlying Set.
500     // This means that we can only create new EnumerableSets for types that fit
501     // in bytes32.
502 
503     struct Set {
504         // Storage of set values
505         bytes32[] _values;
506 
507         // Position of the value in the `values` array, plus 1 because index 0
508         // means a value is not in the set.
509         mapping (bytes32 => uint256) _indexes;
510     }
511 
512     /**
513      * @dev Add a value to a set. O(1).
514      *
515      * Returns true if the value was added to the set, that is if it was not
516      * already present.
517      */
518     function _add(Set storage set, bytes32 value) private returns (bool) {
519         if (!_contains(set, value)) {
520             set._values.push(value);
521             // The value is stored at length-1, but we add 1 to all indexes
522             // and use 0 as a sentinel value
523             set._indexes[value] = set._values.length;
524             return true;
525         } else {
526             return false;
527         }
528     }
529 
530     /**
531      * @dev Removes a value from a set. O(1).
532      *
533      * Returns true if the value was removed from the set, that is if it was
534      * present.
535      */
536     function _remove(Set storage set, bytes32 value) private returns (bool) {
537         // We read and store the value's index to prevent multiple reads from the same storage slot
538         uint256 valueIndex = set._indexes[value];
539 
540         if (valueIndex != 0) { // Equivalent to contains(set, value)
541             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
542             // the array, and then remove the last element (sometimes called as 'swap and pop').
543             // This modifies the order of the array, as noted in {at}.
544 
545             uint256 toDeleteIndex = valueIndex - 1;
546             uint256 lastIndex = set._values.length - 1;
547 
548             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
549             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
550 
551             bytes32 lastvalue = set._values[lastIndex];
552 
553             // Move the last value to the index where the value to delete is
554             set._values[toDeleteIndex] = lastvalue;
555             // Update the index for the moved value
556             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
557 
558             // Delete the slot where the moved value was stored
559             set._values.pop();
560 
561             // Delete the index for the deleted slot
562             delete set._indexes[value];
563 
564             return true;
565         } else {
566             return false;
567         }
568     }
569 
570     /**
571      * @dev Returns true if the value is in the set. O(1).
572      */
573     function _contains(Set storage set, bytes32 value) private view returns (bool) {
574         return set._indexes[value] != 0;
575     }
576 
577     /**
578      * @dev Returns the number of values on the set. O(1).
579      */
580     function _length(Set storage set) private view returns (uint256) {
581         return set._values.length;
582     }
583 
584    /**
585     * @dev Returns the value stored at position `index` in the set. O(1).
586     *
587     * Note that there are no guarantees on the ordering of values inside the
588     * array, and it may change when more values are added or removed.
589     *
590     * Requirements:
591     *
592     * - `index` must be strictly less than {length}.
593     */
594     function _at(Set storage set, uint256 index) private view returns (bytes32) {
595         require(set._values.length > index, "EnumerableSet: index out of bounds");
596         return set._values[index];
597     }
598 
599     // AddressSet
600 
601     struct AddressSet {
602         Set _inner;
603     }
604 
605     /**
606      * @dev Add a value to a set. O(1).
607      *
608      * Returns true if the value was added to the set, that is if it was not
609      * already present.
610      */
611     function add(AddressSet storage set, address value) internal returns (bool) {
612         return _add(set._inner, bytes32(uint256(value)));
613     }
614 
615     /**
616      * @dev Removes a value from a set. O(1).
617      *
618      * Returns true if the value was removed from the set, that is if it was
619      * present.
620      */
621     function remove(AddressSet storage set, address value) internal returns (bool) {
622         return _remove(set._inner, bytes32(uint256(value)));
623     }
624 
625     /**
626      * @dev Returns true if the value is in the set. O(1).
627      */
628     function contains(AddressSet storage set, address value) internal view returns (bool) {
629         return _contains(set._inner, bytes32(uint256(value)));
630     }
631 
632     /**
633      * @dev Returns the number of values in the set. O(1).
634      */
635     function length(AddressSet storage set) internal view returns (uint256) {
636         return _length(set._inner);
637     }
638 
639    /**
640     * @dev Returns the value stored at position `index` in the set. O(1).
641     *
642     * Note that there are no guarantees on the ordering of values inside the
643     * array, and it may change when more values are added or removed.
644     *
645     * Requirements:
646     *
647     * - `index` must be strictly less than {length}.
648     */
649     function at(AddressSet storage set, uint256 index) internal view returns (address) {
650         return address(uint256(_at(set._inner, index)));
651     }
652 
653 
654     // UintSet
655 
656     struct UintSet {
657         Set _inner;
658     }
659 
660     /**
661      * @dev Add a value to a set. O(1).
662      *
663      * Returns true if the value was added to the set, that is if it was not
664      * already present.
665      */
666     function add(UintSet storage set, uint256 value) internal returns (bool) {
667         return _add(set._inner, bytes32(value));
668     }
669 
670     /**
671      * @dev Removes a value from a set. O(1).
672      *
673      * Returns true if the value was removed from the set, that is if it was
674      * present.
675      */
676     function remove(UintSet storage set, uint256 value) internal returns (bool) {
677         return _remove(set._inner, bytes32(value));
678     }
679 
680     /**
681      * @dev Returns true if the value is in the set. O(1).
682      */
683     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
684         return _contains(set._inner, bytes32(value));
685     }
686 
687     /**
688      * @dev Returns the number of values on the set. O(1).
689      */
690     function length(UintSet storage set) internal view returns (uint256) {
691         return _length(set._inner);
692     }
693 
694    /**
695     * @dev Returns the value stored at position `index` in the set. O(1).
696     *
697     * Note that there are no guarantees on the ordering of values inside the
698     * array, and it may change when more values are added or removed.
699     *
700     * Requirements:
701     *
702     * - `index` must be strictly less than {length}.
703     */
704     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
705         return uint256(_at(set._inner, index));
706     }
707 }
708 
709 // File: @openzeppelin/contracts/GSN/Context.sol
710 
711 
712 
713 pragma solidity ^0.6.0;
714 
715 /*
716  * @dev Provides information about the current execution context, including the
717  * sender of the transaction and its data. While these are generally available
718  * via msg.sender and msg.data, they should not be accessed in such a direct
719  * manner, since when dealing with GSN meta-transactions the account sending and
720  * paying for execution may not be the actual sender (as far as an application
721  * is concerned).
722  *
723  * This contract is only required for intermediate, library-like contracts.
724  */
725 abstract contract Context {
726     function _msgSender() internal view virtual returns (address payable) {
727         return msg.sender;
728     }
729 
730     function _msgData() internal view virtual returns (bytes memory) {
731         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
732         return msg.data;
733     }
734 }
735 
736 // File: @openzeppelin/contracts/access/Ownable.sol
737 
738 
739 
740 pragma solidity ^0.6.0;
741 
742 /**
743  * @dev Contract module which provides a basic access control mechanism, where
744  * there is an account (an owner) that can be granted exclusive access to
745  * specific functions.
746  *
747  * By default, the owner account will be the one that deploys the contract. This
748  * can later be changed with {transferOwnership}.
749  *
750  * This module is used through inheritance. It will make available the modifier
751  * `onlyOwner`, which can be applied to your functions to restrict their use to
752  * the owner.
753  */
754 contract Ownable is Context {
755     address private _owner;
756 
757     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
758 
759     /**
760      * @dev Initializes the contract setting the deployer as the initial owner.
761      */
762     constructor () internal {
763         address msgSender = _msgSender();
764         _owner = msgSender;
765         emit OwnershipTransferred(address(0), msgSender);
766     }
767 
768     /**
769      * @dev Returns the address of the current owner.
770      */
771     function owner() public view returns (address) {
772         return _owner;
773     }
774 
775     /**
776      * @dev Throws if called by any account other than the owner.
777      */
778     modifier onlyOwner() {
779         require(_owner == _msgSender(), "Ownable: caller is not the owner");
780         _;
781     }
782 
783     /**
784      * @dev Leaves the contract without owner. It will not be possible to call
785      * `onlyOwner` functions anymore. Can only be called by the current owner.
786      *
787      * NOTE: Renouncing ownership will leave the contract without an owner,
788      * thereby removing any functionality that is only available to the owner.
789      */
790     function renounceOwnership() public virtual onlyOwner {
791         emit OwnershipTransferred(_owner, address(0));
792         _owner = address(0);
793     }
794 
795     /**
796      * @dev Transfers ownership of the contract to a new account (`newOwner`).
797      * Can only be called by the current owner.
798      */
799     function transferOwnership(address newOwner) public virtual onlyOwner {
800         require(newOwner != address(0), "Ownable: new owner is the zero address");
801         emit OwnershipTransferred(_owner, newOwner);
802         _owner = newOwner;
803     }
804 }
805 
806 // File: contracts/SakeToken.sol
807 
808 pragma solidity 0.6.12;
809 
810 
811 
812 
813 
814 
815 // SakeToken with Governance.
816 contract SakeToken is Context, IERC20, Ownable {
817     using SafeMath for uint256;
818     using Address for address;
819 
820     mapping (address => uint256) private _balances;
821 
822     mapping (address => mapping (address => uint256)) private _allowances;
823 
824     uint256 private _totalSupply;
825 
826     string private _name = "SakeToken";
827     string private _symbol = "SAKE";
828     uint8 private _decimals = 18;
829 
830     /**
831      * @dev Returns the name of the token.
832      */
833     function name() public view returns (string memory) {
834         return _name;
835     }
836 
837     /**
838      * @dev Returns the symbol of the token, usually a shorter version of the
839      * name.
840      */
841     function symbol() public view returns (string memory) {
842         return _symbol;
843     }
844 
845     /**
846      * @dev Returns the number of decimals used to get its user representation.
847      * For example, if `decimals` equals `2`, a balance of `505` tokens should
848      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
849      *
850      * Tokens usually opt for a value of 18, imitating the relationship between
851      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
852      * called.
853      *
854      * NOTE: This information is only used for _display_ purposes: it in
855      * no way affects any of the arithmetic of the contract, including
856      * {IERC20-balanceOf} and {IERC20-transfer}.
857      */
858     function decimals() public view returns (uint8) {
859         return _decimals;
860     }
861 
862     /**
863      * @dev See {IERC20-totalSupply}.
864      */
865     function totalSupply() public view override returns (uint256) {
866         return _totalSupply;
867     }
868 
869     /**
870      * @dev See {IERC20-balanceOf}.
871      */
872     function balanceOf(address account) public view override returns (uint256) {
873         return _balances[account];
874     }
875 
876     /**
877      * @dev See {IERC20-transfer}.
878      *
879      * Requirements:
880      *
881      * - `recipient` cannot be the zero address.
882      * - the caller must have a balance of at least `amount`.
883      */
884     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
885         _transfer(_msgSender(), recipient, amount);
886         return true;
887     }
888 
889     /**
890      * @dev See {IERC20-allowance}.
891      */
892     function allowance(address owner, address spender) public view virtual override returns (uint256) {
893         return _allowances[owner][spender];
894     }
895 
896     /**
897      * @dev See {IERC20-approve}.
898      *
899      * Requirements:
900      *
901      * - `spender` cannot be the zero address.
902      */
903     function approve(address spender, uint256 amount) public virtual override returns (bool) {
904         _approve(_msgSender(), spender, amount);
905         return true;
906     }
907 
908     /**
909      * @dev See {IERC20-transferFrom}.
910      *
911      * Emits an {Approval} event indicating the updated allowance. This is not
912      * required by the EIP. See the note at the beginning of {ERC20};
913      *
914      * Requirements:
915      * - `sender` and `recipient` cannot be the zero address.
916      * - `sender` must have a balance of at least `amount`.
917      * - the caller must have allowance for ``sender``'s tokens of at least
918      * `amount`.
919      */
920     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
921         _transfer(sender, recipient, amount);
922         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
923         return true;
924     }
925 
926     /**
927      * @dev Atomically increases the allowance granted to `spender` by the caller.
928      *
929      * This is an alternative to {approve} that can be used as a mitigation for
930      * problems described in {IERC20-approve}.
931      *
932      * Emits an {Approval} event indicating the updated allowance.
933      *
934      * Requirements:
935      *
936      * - `spender` cannot be the zero address.
937      */
938     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
939         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
940         return true;
941     }
942 
943     /**
944      * @dev Atomically decreases the allowance granted to `spender` by the caller.
945      *
946      * This is an alternative to {approve} that can be used as a mitigation for
947      * problems described in {IERC20-approve}.
948      *
949      * Emits an {Approval} event indicating the updated allowance.
950      *
951      * Requirements:
952      *
953      * - `spender` cannot be the zero address.
954      * - `spender` must have allowance for the caller of at least
955      * `subtractedValue`.
956      */
957     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
958         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
959         return true;
960     }
961 
962     /**
963      * @dev Moves tokens `amount` from `sender` to `recipient`.
964      *
965      * This is internal function is equivalent to {transfer}, and can be used to
966      * e.g. implement automatic token fees, slashing mechanisms, etc.
967      *
968      * Emits a {Transfer} event.
969      *
970      * Requirements:
971      *
972      * - `sender` cannot be the zero address.
973      * - `recipient` cannot be the zero address.
974      * - `sender` must have a balance of at least `amount`.
975      */
976     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
977         require(sender != address(0), "ERC20: transfer from the zero address");
978         require(recipient != address(0), "ERC20: transfer to the zero address");
979 
980         _beforeTokenTransfer(sender, recipient, amount);
981 
982         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
983         _balances[recipient] = _balances[recipient].add(amount);
984         emit Transfer(sender, recipient, amount);
985 
986         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
987     }
988 
989     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
990      * the total supply.
991      *
992      * Emits a {Transfer} event with `from` set to the zero address.
993      *
994      * Requirements
995      *
996      * - `to` cannot be the zero address.
997      */
998     function _mint(address account, uint256 amount) internal virtual {
999         require(account != address(0), "ERC20: mint to the zero address");
1000 
1001         _beforeTokenTransfer(address(0), account, amount);
1002 
1003         _totalSupply = _totalSupply.add(amount);
1004         _balances[account] = _balances[account].add(amount);
1005         emit Transfer(address(0), account, amount);
1006     }
1007 
1008     /**
1009      * @dev Destroys `amount` tokens from `account`, reducing the
1010      * total supply.
1011      *
1012      * Emits a {Transfer} event with `to` set to the zero address.
1013      *
1014      * Requirements
1015      *
1016      * - `account` cannot be the zero address.
1017      * - `account` must have at least `amount` tokens.
1018      */
1019     function _burn(address account, uint256 amount) internal virtual {
1020         require(account != address(0), "ERC20: burn from the zero address");
1021 
1022         _beforeTokenTransfer(account, address(0), amount);
1023 
1024         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1025         _totalSupply = _totalSupply.sub(amount);
1026         emit Transfer(account, address(0), amount);
1027     }
1028 
1029     /**
1030      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1031      *
1032      * This is internal function is equivalent to `approve`, and can be used to
1033      * e.g. set automatic allowances for certain subsystems, etc.
1034      *
1035      * Emits an {Approval} event.
1036      *
1037      * Requirements:
1038      *
1039      * - `owner` cannot be the zero address.
1040      * - `spender` cannot be the zero address.
1041      */
1042     function _approve(address owner, address spender, uint256 amount) internal virtual {
1043         require(owner != address(0), "ERC20: approve from the zero address");
1044         require(spender != address(0), "ERC20: approve to the zero address");
1045 
1046         _allowances[owner][spender] = amount;
1047         emit Approval(owner, spender, amount);
1048     }
1049 
1050     /**
1051      * @dev Sets {decimals} to a value other than the default one of 18.
1052      *
1053      * WARNING: This function should only be called from the constructor. Most
1054      * applications that interact with token contracts will not expect
1055      * {decimals} to ever change, and may work incorrectly if it does.
1056      */
1057     function _setupDecimals(uint8 decimals_) internal {
1058         _decimals = decimals_;
1059     }
1060 
1061     /**
1062      * @dev Hook that is called before any transfer of tokens. This includes
1063      * minting and burning.
1064      *
1065      * Calling conditions:
1066      *
1067      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1068      * will be to transferred to `to`.
1069      * - when `from` is zero, `amount` tokens will be minted for `to`.
1070      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1071      * - `from` and `to` are never both zero.
1072      *
1073      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1074      */
1075     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1076 
1077     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (SakeMaster).
1078     function mint(address _to, uint256 _amount) public onlyOwner {
1079         _mint(_to, _amount);
1080         _moveDelegates(address(0), _delegates[_to], _amount);
1081     }
1082 
1083     // Copied and modified from YAM code:
1084     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1085     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1086     // Which is copied and modified from COMPOUND:
1087     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1088 
1089     /// @notice A record of each accounts delegate
1090     mapping (address => address) internal _delegates;
1091 
1092     /// @notice A checkpoint for marking number of votes from a given block
1093     struct Checkpoint {
1094         uint32 fromBlock;
1095         uint256 votes;
1096     }
1097 
1098     /// @notice A record of votes checkpoints for each account, by index
1099     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1100 
1101     /// @notice The number of checkpoints for each account
1102     mapping (address => uint32) public numCheckpoints;
1103 
1104     /// @notice The EIP-712 typehash for the contract's domain
1105     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1106 
1107     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1108     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1109 
1110     /// @notice A record of states for signing / validating signatures
1111     mapping (address => uint) public nonces;
1112 
1113     /// @notice An event thats emitted when an account changes its delegate
1114     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1115 
1116     /// @notice An event thats emitted when a delegate account's vote balance changes
1117     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1118 
1119     /**
1120      * @notice Delegate votes from `msg.sender` to `delegatee`
1121      * @param delegator The address to get delegatee for
1122      */
1123     function delegates(address delegator)
1124         external
1125         view
1126         returns (address)
1127     {
1128         return _delegates[delegator];
1129     }
1130 
1131    /**
1132     * @notice Delegate votes from `msg.sender` to `delegatee`
1133     * @param delegatee The address to delegate votes to
1134     */
1135     function delegate(address delegatee) external {
1136         return _delegate(msg.sender, delegatee);
1137     }
1138 
1139     /**
1140      * @notice Delegates votes from signatory to `delegatee`
1141      * @param delegatee The address to delegate votes to
1142      * @param nonce The contract state required to match the signature
1143      * @param expiry The time at which to expire the signature
1144      * @param v The recovery byte of the signature
1145      * @param r Half of the ECDSA signature pair
1146      * @param s Half of the ECDSA signature pair
1147      */
1148     function delegateBySig(
1149         address delegatee,
1150         uint nonce,
1151         uint expiry,
1152         uint8 v,
1153         bytes32 r,
1154         bytes32 s
1155     )
1156         external
1157     {
1158         bytes32 domainSeparator = keccak256(
1159             abi.encode(
1160                 DOMAIN_TYPEHASH,
1161                 keccak256(bytes(name())),
1162                 getChainId(),
1163                 address(this)
1164             )
1165         );
1166 
1167         bytes32 structHash = keccak256(
1168             abi.encode(
1169                 DELEGATION_TYPEHASH,
1170                 delegatee,
1171                 nonce,
1172                 expiry
1173             )
1174         );
1175 
1176         bytes32 digest = keccak256(
1177             abi.encodePacked(
1178                 "\x19\x01",
1179                 domainSeparator,
1180                 structHash
1181             )
1182         );
1183 
1184         address signatory = ecrecover(digest, v, r, s);
1185         require(signatory != address(0), "SAKE::delegateBySig: invalid signature");
1186         require(nonce == nonces[signatory]++, "SAKE::delegateBySig: invalid nonce");
1187         require(now <= expiry, "SAKE::delegateBySig: signature expired");
1188         return _delegate(signatory, delegatee);
1189     }
1190 
1191     /**
1192      * @notice Gets the current votes balance for `account`
1193      * @param account The address to get votes balance
1194      * @return The number of current votes for `account`
1195      */
1196     function getCurrentVotes(address account)
1197         external
1198         view
1199         returns (uint256)
1200     {
1201         uint32 nCheckpoints = numCheckpoints[account];
1202         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1203     }
1204 
1205     /**
1206      * @notice Determine the prior number of votes for an account as of a block number
1207      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1208      * @param account The address of the account to check
1209      * @param blockNumber The block number to get the vote balance at
1210      * @return The number of votes the account had as of the given block
1211      */
1212     function getPriorVotes(address account, uint blockNumber)
1213         external
1214         view
1215         returns (uint256)
1216     {
1217         require(blockNumber < block.number, "SAKE::getPriorVotes: not yet determined");
1218 
1219         uint32 nCheckpoints = numCheckpoints[account];
1220         if (nCheckpoints == 0) {
1221             return 0;
1222         }
1223 
1224         // First check most recent balance
1225         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1226             return checkpoints[account][nCheckpoints - 1].votes;
1227         }
1228 
1229         // Next check implicit zero balance
1230         if (checkpoints[account][0].fromBlock > blockNumber) {
1231             return 0;
1232         }
1233 
1234         uint32 lower = 0;
1235         uint32 upper = nCheckpoints - 1;
1236         while (upper > lower) {
1237             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1238             Checkpoint memory cp = checkpoints[account][center];
1239             if (cp.fromBlock == blockNumber) {
1240                 return cp.votes;
1241             } else if (cp.fromBlock < blockNumber) {
1242                 lower = center;
1243             } else {
1244                 upper = center - 1;
1245             }
1246         }
1247         return checkpoints[account][lower].votes;
1248     }
1249 
1250     function _delegate(address delegator, address delegatee)
1251         internal
1252     {
1253         address currentDelegate = _delegates[delegator];
1254         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SAKEs (not scaled);
1255         _delegates[delegator] = delegatee;
1256 
1257         emit DelegateChanged(delegator, currentDelegate, delegatee);
1258 
1259         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1260     }
1261 
1262     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1263         if (srcRep != dstRep && amount > 0) {
1264             if (srcRep != address(0)) {
1265                 // decrease old representative
1266                 uint32 srcRepNum = numCheckpoints[srcRep];
1267                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1268                 uint256 srcRepNew = srcRepOld.sub(amount);
1269                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1270             }
1271 
1272             if (dstRep != address(0)) {
1273                 // increase new representative
1274                 uint32 dstRepNum = numCheckpoints[dstRep];
1275                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1276                 uint256 dstRepNew = dstRepOld.add(amount);
1277                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1278             }
1279         }
1280     }
1281 
1282     function _writeCheckpoint(
1283         address delegatee,
1284         uint32 nCheckpoints,
1285         uint256 oldVotes,
1286         uint256 newVotes
1287     )
1288         internal
1289     {
1290         uint32 blockNumber = safe32(block.number, "SAKE::_writeCheckpoint: block number exceeds 32 bits");
1291 
1292         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1293             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1294         } else {
1295             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1296             numCheckpoints[delegatee] = nCheckpoints + 1;
1297         }
1298 
1299         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1300     }
1301 
1302     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1303         require(n < 2**32, errorMessage);
1304         return uint32(n);
1305     }
1306 
1307     function getChainId() internal pure returns (uint) {
1308         uint256 chainId;
1309         assembly { chainId := chainid() }
1310         return chainId;
1311     }
1312 }
1313 
1314 // File: contracts/SakeMaster.sol
1315 
1316 pragma solidity 0.6.12;
1317 
1318 
1319 
1320 
1321 
1322 
1323 
1324 interface IMigratorChef {
1325     // Perform LP token migration from legacy UniswapV2 to SakeSwap.
1326     // Take the current LP token address and return the new LP token address.
1327     // Migrator should have full access to the caller's LP token.
1328     // Return the new LP token address.
1329     //
1330     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1331     // SakeSwap must mint EXACTLY the same amount of SakeSwap LP tokens or
1332     // else something bad will happen. Traditional UniswapV2 does not
1333     // do that so be careful!
1334     function migrate(IERC20 token) external returns (IERC20);
1335 }
1336 
1337 // SakeMaster is the master of Sake. He can make Sake and he is a fair guy.
1338 //
1339 // Note that it's ownable and the owner wields tremendous power. The ownership
1340 // will be transferred to a governance smart contract once SAKE is sufficiently
1341 // distributed and the community can show to govern itself.
1342 //
1343 // Have fun reading it. Hopefully it's bug-free. God bless.
1344 contract SakeMaster is Ownable {
1345     using SafeMath for uint256;
1346     using SafeERC20 for IERC20;
1347 
1348     // Info of each user.
1349     struct UserInfo {
1350         uint256 amount; // How many LP tokens the user has provided.
1351         uint256 rewardDebt; // Reward debt. See explanation below.
1352         //
1353         // We do some fancy math here. Basically, any point in time, the amount of SAKEs
1354         // entitled to a user but is pending to be distributed is:
1355         //
1356         //   pending reward = (user.amount * pool.accSakePerShare) - user.rewardDebt
1357         //
1358         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1359         //   1. The pool's `accSakePerShare` (and `lastRewardBlock`) gets updated.
1360         //   2. User receives the pending reward sent to his/her address.
1361         //   3. User's `amount` gets updated.
1362         //   4. User's `rewardDebt` gets updated.
1363     }
1364 
1365     // Info of each pool.
1366     struct PoolInfo {
1367         IERC20 lpToken; // Address of LP token contract.
1368         uint256 allocPoint; // How many allocation points assigned to this pool. SAKEs to distribute per block.
1369         uint256 lastRewardBlock; // Last block number that SAKEs distribution occurs.
1370         uint256 accSakePerShare; // Accumulated SAKEs per share, times 1e12. See below.
1371     }
1372 
1373     // The SAKE TOKEN!
1374     SakeToken public sake;
1375     // Dev address.
1376     address public devaddr;
1377     // Block number when beta test period ends.
1378     uint256 public betaTestEndBlock;
1379     // Block number when bonus SAKE period ends.
1380     uint256 public bonusEndBlock;
1381     // Block number when mint SAKE period ends.
1382     uint256 public mintEndBlock;
1383     // SAKE tokens created per block.
1384     uint256 public sakePerBlock;
1385     // Bonus muliplier for 5~20 days sake makers.
1386     uint256 public constant BONUSONE_MULTIPLIER = 20;
1387     // Bonus muliplier for 20~35 sake makers.
1388     uint256 public constant BONUSTWO_MULTIPLIER = 2;
1389     // beta test block num,about 5 days.
1390     uint256 public constant BETATEST_BLOCKNUM = 35000;
1391     // Bonus block num,about 15 days.
1392     uint256 public constant BONUS_BLOCKNUM = 100000;
1393     // mint end block num,about 30 days.
1394     uint256 public constant MINTEND_BLOCKNUM = 200000;
1395     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1396     IMigratorChef public migrator;
1397 
1398     // Info of each pool.
1399     PoolInfo[] public poolInfo;
1400     // Info of each user that stakes LP tokens.
1401     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1402     // Record whether the pair has been added.
1403     mapping(address => uint256) public lpTokenPID;
1404     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1405     uint256 public totalAllocPoint = 0;
1406     // The block number when SAKE mining starts.
1407     uint256 public startBlock;
1408 
1409     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1410     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1411     event EmergencyWithdraw(
1412         address indexed user,
1413         uint256 indexed pid,
1414         uint256 amount
1415     );
1416 
1417     constructor(
1418         SakeToken _sake,
1419         address _devaddr,
1420         uint256 _sakePerBlock,
1421         uint256 _startBlock
1422     ) public {
1423         sake = _sake;
1424         devaddr = _devaddr;
1425         sakePerBlock = _sakePerBlock;
1426         startBlock = _startBlock;
1427         betaTestEndBlock = startBlock.add(BETATEST_BLOCKNUM);
1428         bonusEndBlock = startBlock.add(BONUS_BLOCKNUM).add(BETATEST_BLOCKNUM);
1429         mintEndBlock = startBlock.add(MINTEND_BLOCKNUM).add(BETATEST_BLOCKNUM);
1430     }
1431 
1432     function poolLength() external view returns (uint256) {
1433         return poolInfo.length;
1434     }
1435 
1436     // Add a new lp to the pool. Can only be called by the owner.
1437     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1438     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1439         if (_withUpdate) {
1440             massUpdatePools();
1441         }
1442         require(lpTokenPID[address(_lpToken)] == 0, "SakeMaster:duplicate add.");
1443         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1444         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1445         poolInfo.push(
1446             PoolInfo({
1447                 lpToken: _lpToken,
1448                 allocPoint: _allocPoint,
1449                 lastRewardBlock: lastRewardBlock,
1450                 accSakePerShare: 0
1451             })
1452         );
1453         lpTokenPID[address(_lpToken)] = poolInfo.length;
1454     }
1455 
1456     // Update the given pool's SAKE allocation point. Can only be called by the owner.
1457     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1458         if (_withUpdate) {
1459             massUpdatePools();
1460         }
1461         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1462         poolInfo[_pid].allocPoint = _allocPoint;
1463     }
1464 
1465     // Set the migrator contract. Can only be called by the owner.
1466     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1467         migrator = _migrator;
1468     }
1469 
1470     // Handover the saketoken mintage right.
1471     function handoverSakeMintage(address newOwner) public onlyOwner {
1472         sake.transferOwnership(newOwner);
1473     }
1474 
1475     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1476     function migrate(uint256 _pid) public {
1477         require(address(migrator) != address(0), "migrate: no migrator");
1478         PoolInfo storage pool = poolInfo[_pid];
1479         IERC20 lpToken = pool.lpToken;
1480         uint256 bal = lpToken.balanceOf(address(this));
1481         lpToken.safeApprove(address(migrator), bal);
1482         IERC20 newLpToken = migrator.migrate(lpToken);
1483         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1484         pool.lpToken = newLpToken;
1485     }
1486 
1487     // Return reward multiplier over the given _from to _to block.
1488     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1489         uint256 _toFinal = _to > mintEndBlock ? mintEndBlock : _to;
1490         if (_toFinal <= betaTestEndBlock) {
1491              return _toFinal.sub(_from);
1492         }else if (_from >= mintEndBlock) {
1493             return 0;
1494         } else if (_toFinal <= bonusEndBlock) {
1495             if (_from < betaTestEndBlock) {
1496                 return betaTestEndBlock.sub(_from).add(_toFinal.sub(betaTestEndBlock).mul(BONUSONE_MULTIPLIER));
1497             } else {
1498                 return _toFinal.sub(_from).mul(BONUSONE_MULTIPLIER);
1499             }
1500         } else {
1501             if (_from < betaTestEndBlock) {
1502                 return betaTestEndBlock.sub(_from).add(bonusEndBlock.sub(betaTestEndBlock).mul(BONUSONE_MULTIPLIER)).add(
1503                     (_toFinal.sub(bonusEndBlock).mul(BONUSTWO_MULTIPLIER)));
1504             } else if (betaTestEndBlock <= _from && _from < bonusEndBlock) {
1505                 return bonusEndBlock.sub(_from).mul(BONUSONE_MULTIPLIER).add(_toFinal.sub(bonusEndBlock).mul(BONUSTWO_MULTIPLIER));
1506             } else {
1507                 return _toFinal.sub(_from).mul(BONUSTWO_MULTIPLIER);
1508             }
1509         } 
1510     }
1511 
1512     // View function to see pending SAKEs on frontend.
1513     function pendingSake(uint256 _pid, address _user) external view returns (uint256) {
1514         PoolInfo storage pool = poolInfo[_pid];
1515         UserInfo storage user = userInfo[_pid][_user];
1516         uint256 accSakePerShare = pool.accSakePerShare;
1517         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1518         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1519             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1520             uint256 sakeReward = multiplier.mul(sakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1521             accSakePerShare = accSakePerShare.add(sakeReward.mul(1e12).div(lpSupply));
1522         }
1523         return user.amount.mul(accSakePerShare).div(1e12).sub(user.rewardDebt);
1524     }
1525 
1526     // Update reward vairables for all pools. Be careful of gas spending!
1527     function massUpdatePools() public {
1528         uint256 length = poolInfo.length;
1529         for (uint256 pid = 0; pid < length; ++pid) {
1530             updatePool(pid);
1531         }
1532     }
1533 
1534     // Update reward variables of the given pool to be up-to-date.
1535     function updatePool(uint256 _pid) public {
1536         PoolInfo storage pool = poolInfo[_pid];
1537         if (block.number <= pool.lastRewardBlock) {
1538             return;
1539         }
1540         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1541         if (lpSupply == 0) {
1542             pool.lastRewardBlock = block.number;
1543             return;
1544         }
1545         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1546         if (multiplier == 0) {
1547             pool.lastRewardBlock = block.number;
1548             return;
1549         }
1550         uint256 sakeReward = multiplier.mul(sakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1551         sake.mint(devaddr, sakeReward.div(15));
1552         sake.mint(address(this), sakeReward);
1553         pool.accSakePerShare = pool.accSakePerShare.add(sakeReward.mul(1e12).div(lpSupply));
1554         pool.lastRewardBlock = block.number;
1555     }
1556 
1557     // Deposit LP tokens to SakeMaster for SAKE allocation.
1558     function deposit(uint256 _pid, uint256 _amount) public {
1559         PoolInfo storage pool = poolInfo[_pid];
1560         UserInfo storage user = userInfo[_pid][msg.sender];
1561         updatePool(_pid);
1562         uint256 pending = user.amount.mul(pool.accSakePerShare).div(1e12).sub(user.rewardDebt);
1563         user.amount = user.amount.add(_amount);
1564         user.rewardDebt = user.amount.mul(pool.accSakePerShare).div(1e12);
1565         if (pending > 0) safeSakeTransfer(msg.sender, pending);
1566         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1567         emit Deposit(msg.sender, _pid, _amount);
1568     }
1569 
1570     // Withdraw LP tokens from SakeMaster.
1571     function withdraw(uint256 _pid, uint256 _amount) public {
1572         PoolInfo storage pool = poolInfo[_pid];
1573         UserInfo storage user = userInfo[_pid][msg.sender];
1574         require(user.amount >= _amount, "withdraw: not good");
1575         updatePool(_pid);
1576         uint256 pending = user.amount.mul(pool.accSakePerShare).div(1e12).sub(user.rewardDebt);
1577         user.amount = user.amount.sub(_amount);
1578         user.rewardDebt = user.amount.mul(pool.accSakePerShare).div(1e12);
1579         safeSakeTransfer(msg.sender, pending);
1580         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1581         emit Withdraw(msg.sender, _pid, _amount);
1582     }
1583 
1584     // Withdraw without caring about rewards. EMERGENCY ONLY.
1585     function emergencyWithdraw(uint256 _pid) public {
1586         PoolInfo storage pool = poolInfo[_pid];
1587         UserInfo storage user = userInfo[_pid][msg.sender];
1588         require(user.amount > 0, "emergencyWithdraw: not good");
1589         uint256 _amount = user.amount;
1590         user.amount = 0;
1591         user.rewardDebt = 0;
1592         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1593         emit EmergencyWithdraw(msg.sender, _pid, _amount);
1594     }
1595 
1596     // Safe sake transfer function, just in case if rounding error causes pool to not have enough SAKEs.
1597     function safeSakeTransfer(address _to, uint256 _amount) internal {
1598         uint256 sakeBal = sake.balanceOf(address(this));
1599         if (_amount > sakeBal) {
1600             sake.transfer(_to, sakeBal);
1601         } else {
1602             sake.transfer(_to, _amount);
1603         }
1604     }
1605 
1606     // Update dev address by the previous dev.
1607     function dev(address _devaddr) public {
1608         require(msg.sender == devaddr, "dev: wut?");
1609         devaddr = _devaddr;
1610     }
1611 }