1 /*** MOOswap.org
2  * █████████████████████   █████████████████████   █████████████████████            
3  * ███      ███      ███   ███               ███   ███               ███ 
4  * ███      ███      ███   ███               ███   ███               ███
5  * ███      ███      ███   ███     █   █     ███   ███               ███
6  * ███      ███      ███   ███     █████     ███   ███               ███
7  * ███      ███      ███   ███     █████     ███   ███               ███
8  * ███      ███      ███   ███               ███   ███               ███
9  * ███      ███      ███   ███               ███   ███               ███
10  * ███      ███      ███   █████████████████████   █████████████████████
11 // SPDX-License-Identifier: MIT
12 //File: @openzeppelin/contracts/token/ERC20/IERC20.sol
13 pragma solidity ^0.6.0;
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 // File: @openzeppelin/contracts/math/SafeMath.sol
90 pragma solidity ^0.6.0;
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      *
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         return sub(a, b, "SafeMath: subtraction overflow");
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b <= a, errorMessage);
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      *
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b > 0, errorMessage);
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return mod(a, b, "SafeMath: modulo by zero");
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts with custom message when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b != 0, errorMessage);
243         return a % b;
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/Address.sol
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
389 pragma solidity ^0.6.0;
390 /**
391  * @title SafeERC20
392  * @dev Wrappers around ERC20 operations that throw on failure (when the token
393  * contract returns false). Tokens that return no value (and instead revert or
394  * throw on failure) are also supported, non-reverting calls are assumed to be
395  * successful.
396  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
397  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
398  */
399 library SafeERC20 {
400     using SafeMath for uint256;
401     using Address for address;
402 
403     function safeTransfer(IERC20 token, address to, uint256 value) internal {
404         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
405     }
406 
407     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
408         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
409     }
410 
411     /**
412      * @dev Deprecated. This function has issues similar to the ones found in
413      * {IERC20-approve}, and its usage is discouraged.
414      *
415      * Whenever possible, use {safeIncreaseAllowance} and
416      * {safeDecreaseAllowance} instead.
417      */
418     function safeApprove(IERC20 token, address spender, uint256 value) internal {
419         // safeApprove should only be called when setting an initial allowance,
420         // or when resetting it to zero. To increase and decrease it, use
421         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
422         // solhint-disable-next-line max-line-length
423         require((value == 0) || (token.allowance(address(this), spender) == 0),
424             "SafeERC20: approve from non-zero to non-zero allowance"
425         );
426         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
427     }
428 
429     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
430         uint256 newAllowance = token.allowance(address(this), spender).add(value);
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
432     }
433 
434     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     /**
440      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
441      * on the return value: the return value is optional (but if data is returned, it must not be false).
442      * @param token The token targeted by the call.
443      * @param data The call data (encoded using abi.encode or one of its variants).
444      */
445     function _callOptionalReturn(IERC20 token, bytes memory data) private {
446         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
447         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
448         // the target address contains contract code and also asserts for success in the low-level call.
449 
450         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
451         if (returndata.length > 0) { // Return data is optional
452             // solhint-disable-next-line max-line-length
453             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
454         }
455     }
456 }
457 
458 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
459 pragma solidity ^0.6.0;
460 /**
461  * @dev Library for managing
462  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
463  * types.
464  *
465  * Sets have the following properties:
466  *
467  * - Elements are added, removed, and checked for existence in constant time
468  * (O(1)).
469  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
470  *
471  * ```
472  * contract Example {
473  *     // Add the library methods
474  *     using EnumerableSet for EnumerableSet.AddressSet;
475  *
476  *     // Declare a set state variable
477  *     EnumerableSet.AddressSet private mySet;
478  * }
479  * ```
480  *
481  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
482  * (`UintSet`) are supported.
483  */
484 library EnumerableSet {
485     // To implement this library for multiple types with as little code
486     // repetition as possible, we write it in terms of a generic Set type with
487     // bytes32 values.
488     // The Set implementation uses private functions, and user-facing
489     // implementations (such as AddressSet) are just wrappers around the
490     // underlying Set.
491     // This means that we can only create new EnumerableSets for types that fit
492     // in bytes32.
493 
494     struct Set {
495         // Storage of set values
496         bytes32[] _values;
497 
498         // Position of the value in the `values` array, plus 1 because index 0
499         // means a value is not in the set.
500         mapping (bytes32 => uint256) _indexes;
501     }
502 
503     /**
504      * @dev Add a value to a set. O(1).
505      *
506      * Returns true if the value was added to the set, that is if it was not
507      * already present.
508      */
509     function _add(Set storage set, bytes32 value) private returns (bool) {
510         if (!_contains(set, value)) {
511             set._values.push(value);
512             // The value is stored at length-1, but we add 1 to all indexes
513             // and use 0 as a sentinel value
514             set._indexes[value] = set._values.length;
515             return true;
516         } else {
517             return false;
518         }
519     }
520 
521     /**
522      * @dev Removes a value from a set. O(1).
523      *
524      * Returns true if the value was removed from the set, that is if it was
525      * present.
526      */
527     function _remove(Set storage set, bytes32 value) private returns (bool) {
528         // We read and store the value's index to prevent multiple reads from the same storage slot
529         uint256 valueIndex = set._indexes[value];
530 
531         if (valueIndex != 0) { // Equivalent to contains(set, value)
532             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
533             // the array, and then remove the last element (sometimes called as 'swap and pop').
534             // This modifies the order of the array, as noted in {at}.
535 
536             uint256 toDeleteIndex = valueIndex - 1;
537             uint256 lastIndex = set._values.length - 1;
538 
539             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
540             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
541 
542             bytes32 lastvalue = set._values[lastIndex];
543 
544             // Move the last value to the index where the value to delete is
545             set._values[toDeleteIndex] = lastvalue;
546             // Update the index for the moved value
547             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
548 
549             // Delete the slot where the moved value was stored
550             set._values.pop();
551 
552             // Delete the index for the deleted slot
553             delete set._indexes[value];
554 
555             return true;
556         } else {
557             return false;
558         }
559     }
560 
561     /**
562      * @dev Returns true if the value is in the set. O(1).
563      */
564     function _contains(Set storage set, bytes32 value) private view returns (bool) {
565         return set._indexes[value] != 0;
566     }
567 
568     /**
569      * @dev Returns the number of values on the set. O(1).
570      */
571     function _length(Set storage set) private view returns (uint256) {
572         return set._values.length;
573     }
574 
575    /**
576     * @dev Returns the value stored at position `index` in the set. O(1).
577     *
578     * Note that there are no guarantees on the ordering of values inside the
579     * array, and it may change when more values are added or removed.
580     *
581     * Requirements:
582     *
583     * - `index` must be strictly less than {length}.
584     */
585     function _at(Set storage set, uint256 index) private view returns (bytes32) {
586         require(set._values.length > index, "EnumerableSet: index out of bounds");
587         return set._values[index];
588     }
589 
590     // AddressSet
591 
592     struct AddressSet {
593         Set _inner;
594     }
595 
596     /**
597      * @dev Add a value to a set. O(1).
598      *
599      * Returns true if the value was added to the set, that is if it was not
600      * already present.
601      */
602     function add(AddressSet storage set, address value) internal returns (bool) {
603         return _add(set._inner, bytes32(uint256(value)));
604     }
605 
606     /**
607      * @dev Removes a value from a set. O(1).
608      *
609      * Returns true if the value was removed from the set, that is if it was
610      * present.
611      */
612     function remove(AddressSet storage set, address value) internal returns (bool) {
613         return _remove(set._inner, bytes32(uint256(value)));
614     }
615 
616     /**
617      * @dev Returns true if the value is in the set. O(1).
618      */
619     function contains(AddressSet storage set, address value) internal view returns (bool) {
620         return _contains(set._inner, bytes32(uint256(value)));
621     }
622 
623     /**
624      * @dev Returns the number of values in the set. O(1).
625      */
626     function length(AddressSet storage set) internal view returns (uint256) {
627         return _length(set._inner);
628     }
629 
630    /**
631     * @dev Returns the value stored at position `index` in the set. O(1).
632     *
633     * Note that there are no guarantees on the ordering of values inside the
634     * array, and it may change when more values are added or removed.
635     *
636     * Requirements:
637     *
638     * - `index` must be strictly less than {length}.
639     */
640     function at(AddressSet storage set, uint256 index) internal view returns (address) {
641         return address(uint256(_at(set._inner, index)));
642     }
643 
644 
645     // UintSet
646     struct UintSet {
647         Set _inner;
648     }
649 
650     /**
651      * @dev Add a value to a set. O(1).
652      *
653      * Returns true if the value was added to the set, that is if it was not
654      * already present.
655      */
656     function add(UintSet storage set, uint256 value) internal returns (bool) {
657         return _add(set._inner, bytes32(value));
658     }
659 
660     /**
661      * @dev Removes a value from a set. O(1).
662      *
663      * Returns true if the value was removed from the set, that is if it was
664      * present.
665      */
666     function remove(UintSet storage set, uint256 value) internal returns (bool) {
667         return _remove(set._inner, bytes32(value));
668     }
669 
670     /**
671      * @dev Returns true if the value is in the set. O(1).
672      */
673     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
674         return _contains(set._inner, bytes32(value));
675     }
676 
677     /**
678      * @dev Returns the number of values on the set. O(1).
679      */
680     function length(UintSet storage set) internal view returns (uint256) {
681         return _length(set._inner);
682     }
683 
684    /**
685     * @dev Returns the value stored at position `index` in the set. O(1).
686     *
687     * Note that there are no guarantees on the ordering of values inside the
688     * array, and it may change when more values are added or removed.
689     *
690     * Requirements:
691     *
692     * - `index` must be strictly less than {length}.
693     */
694     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
695         return uint256(_at(set._inner, index));
696     }
697 }
698 
699 // File: @openzeppelin/contracts/GSN/Context.sol
700 pragma solidity ^0.6.0;
701 /*
702  * @dev Provides information about the current execution context, including the
703  * sender of the transaction and its data. While these are generally available
704  * via msg.sender and msg.data, they should not be accessed in such a direct
705  * manner, since when dealing with GSN meta-transactions the account sending and
706  * paying for execution may not be the actual sender (as far as an application
707  * is concerned).
708  *
709  * This contract is only required for intermediate, library-like contracts.
710  */
711 abstract contract Context {
712     function _msgSender() internal view virtual returns (address payable) {
713         return msg.sender;
714     }
715 
716     function _msgData() internal view virtual returns (bytes memory) {
717         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
718         return msg.data;
719     }
720 }
721 
722 // File: @openzeppelin/contracts/access/Ownable.sol
723 pragma solidity ^0.6.0;
724 
725 /**
726  * @dev Contract module which provides a basic access control mechanism, where
727  * there is an account (an owner) that can be granted exclusive access to
728  * specific functions.
729  *
730  * By default, the owner account will be the one that deploys the contract. This
731  * can later be changed with {transferOwnership}.
732  *
733  * This module is used through inheritance. It will make available the modifier
734  * `onlyOwner`, which can be applied to your functions to restrict their use to
735  * the owner.
736  */
737 contract Ownable is Context {
738     address private _owner;
739 
740     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
741 
742     /**
743      * @dev Initializes the contract setting the deployer as the initial owner.
744      */
745     constructor () internal {
746         address msgSender = _msgSender();
747         _owner = msgSender;
748         emit OwnershipTransferred(address(0), msgSender);
749     }
750 
751     /**
752      * @dev Returns the address of the current owner.
753      */
754     function owner() public view returns (address) {
755         return _owner;
756     }
757 
758     /**
759      * @dev Throws if called by any account other than the owner.
760      */
761     modifier onlyOwner() {
762         require(_owner == _msgSender(), "Ownable: caller is not the owner");
763         _;
764     }
765 
766     /**
767      * @dev Leaves the contract without owner. It will not be possible to call
768      * `onlyOwner` functions anymore. Can only be called by the current owner.
769      *
770      * NOTE: Renouncing ownership will leave the contract without an owner,
771      * thereby removing any functionality that is only available to the owner.
772      */
773     function renounceOwnership() public virtual onlyOwner {
774         emit OwnershipTransferred(_owner, address(0));
775         _owner = address(0);
776     }
777 
778     /**
779      * @dev Transfers ownership of the contract to a new account (`newOwner`).
780      * Can only be called by the current owner.
781      */
782     function transferOwnership(address newOwner) public virtual onlyOwner {
783         require(newOwner != address(0), "Ownable: new owner is the zero address");
784         emit OwnershipTransferred(_owner, newOwner);
785         _owner = newOwner;
786     }
787 }
788 
789 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
790 pragma solidity ^0.6.0;
791 /**
792  * @dev Implementation of the {IERC20} interface.
793  *
794  * This implementation is agnostic to the way tokens are created. This means
795  * that a supply mechanism has to be added in a derived contract using {_mint}.
796  * For a generic mechanism see {ERC20PresetMinterPauser}.
797  *
798  * TIP: For a detailed writeup see our guide
799  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
800  * to implement supply mechanisms].
801  *
802  * We have followed general OpenZeppelin guidelines: functions revert instead
803  * of returning `false` on failure. This behavior is nonetheless conventional
804  * and does not conflict with the expectations of ERC20 applications.
805  *
806  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
807  * This allows applications to reconstruct the allowance for all accounts just
808  * by listening to said events. Other implementations of the EIP may not emit
809  * these events, as it isn't required by the specification.
810  *
811  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
812  * functions have been added to mitigate the well-known issues around setting
813  * allowances. See {IERC20-approve}.
814  */
815 contract ERC20 is Context, IERC20 {
816     using SafeMath for uint256;
817     using Address for address;
818 
819     mapping (address => uint256) private _balances;
820 
821     mapping (address => mapping (address => uint256)) private _allowances;
822 
823     uint256 private _totalSupply;
824 
825     string private _name;
826     string private _symbol;
827     uint8 private _decimals;
828 
829     /**
830      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
831      * a default value of 18.
832      *
833      * To select a different value for {decimals}, use {_setupDecimals}.
834      *
835      * All three of these values are immutable: they can only be set once during
836      * construction.
837      */
838     constructor (string memory name, string memory symbol) public {
839         _name = name;
840         _symbol = symbol;
841         _decimals = 18;
842     }
843 
844     /**
845      * @dev Returns the name of the token.
846      */
847     function name() public view returns (string memory) {
848         return _name;
849     }
850 
851     /**
852      * @dev Returns the symbol of the token, usually a shorter version of the
853      * name.
854      */
855     function symbol() public view returns (string memory) {
856         return _symbol;
857     }
858 
859     /**
860      * @dev Returns the number of decimals used to get its user representation.
861      * For example, if `decimals` equals `2`, a balance of `505` tokens should
862      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
863      *
864      * Tokens usually opt for a value of 18, imitating the relationship between
865      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
866      * called.
867      *
868      * NOTE: This information is only used for _display_ purposes: it in
869      * no way affects any of the arithmetic of the contract, including
870      * {IERC20-balanceOf} and {IERC20-transfer}.
871      */
872     function decimals() public view returns (uint8) {
873         return _decimals;
874     }
875 
876     /**
877      * @dev See {IERC20-totalSupply}.
878      */
879     function totalSupply() public view override returns (uint256) {
880         return _totalSupply;
881     }
882 
883     /**
884      * @dev See {IERC20-balanceOf}.
885      */
886     function balanceOf(address account) public view override returns (uint256) {
887         return _balances[account];
888     }
889 
890     /**
891      * @dev See {IERC20-transfer}.
892      *
893      * Requirements:
894      *
895      * - `recipient` cannot be the zero address.
896      * - the caller must have a balance of at least `amount`.
897      */
898     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
899         _transfer(_msgSender(), recipient, amount);
900         return true;
901     }
902 
903     /**
904      * @dev See {IERC20-allowance}.
905      */
906     function allowance(address owner, address spender) public view virtual override returns (uint256) {
907         return _allowances[owner][spender];
908     }
909 
910     /**
911      * @dev See {IERC20-approve}.
912      *
913      * Requirements:
914      *
915      * - `spender` cannot be the zero address.
916      */
917     function approve(address spender, uint256 amount) public virtual override returns (bool) {
918         _approve(_msgSender(), spender, amount);
919         return true;
920     }
921 
922     /**
923      * @dev See {IERC20-transferFrom}.
924      *
925      * Emits an {Approval} event indicating the updated allowance. This is not
926      * required by the EIP. See the note at the beginning of {ERC20};
927      *
928      * Requirements:
929      * - `sender` and `recipient` cannot be the zero address.
930      * - `sender` must have a balance of at least `amount`.
931      * - the caller must have allowance for ``sender``'s tokens of at least
932      * `amount`.
933      */
934     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
935         _transfer(sender, recipient, amount);
936         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
937         return true;
938     }
939 
940     /**
941      * @dev Atomically increases the allowance granted to `spender` by the caller.
942      *
943      * This is an alternative to {approve} that can be used as a mitigation for
944      * problems described in {IERC20-approve}.
945      *
946      * Emits an {Approval} event indicating the updated allowance.
947      *
948      * Requirements:
949      *
950      * - `spender` cannot be the zero address.
951      */
952     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
953         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
954         return true;
955     }
956 
957     /**
958      * @dev Atomically decreases the allowance granted to `spender` by the caller.
959      *
960      * This is an alternative to {approve} that can be used as a mitigation for
961      * problems described in {IERC20-approve}.
962      *
963      * Emits an {Approval} event indicating the updated allowance.
964      *
965      * Requirements:
966      *
967      * - `spender` cannot be the zero address.
968      * - `spender` must have allowance for the caller of at least
969      * `subtractedValue`.
970      */
971     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
972         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
973         return true;
974     }
975 
976     /**
977      * @dev Moves tokens `amount` from `sender` to `recipient`.
978      *
979      * This is internal function is equivalent to {transfer}, and can be used to
980      * e.g. implement automatic token fees, slashing mechanisms, etc.
981      *
982      * Emits a {Transfer} event.
983      *
984      * Requirements:
985      *
986      * - `sender` cannot be the zero address.
987      * - `recipient` cannot be the zero address.
988      * - `sender` must have a balance of at least `amount`.
989      */
990     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
991         require(sender != address(0), "ERC20: transfer from the zero address");
992         require(recipient != address(0), "ERC20: transfer to the zero address");
993 
994         _beforeTokenTransfer(sender, recipient, amount);
995 
996         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
997         _balances[recipient] = _balances[recipient].add(amount);
998         emit Transfer(sender, recipient, amount);
999     }
1000 
1001     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1002      * the total supply.
1003      *
1004      * Emits a {Transfer} event with `from` set to the zero address.
1005      *
1006      * Requirements
1007      *
1008      * - `to` cannot be the zero address.
1009      */
1010     function _mint(address account, uint256 amount) internal virtual {
1011         require(account != address(0), "ERC20: mint to the zero address");
1012 
1013         _beforeTokenTransfer(address(0), account, amount);
1014 
1015         _totalSupply = _totalSupply.add(amount);
1016         _balances[account] = _balances[account].add(amount);
1017         emit Transfer(address(0), account, amount);
1018     }
1019 
1020     /**
1021      * @dev Destroys `amount` tokens from `account`, reducing the
1022      * total supply.
1023      *
1024      * Emits a {Transfer} event with `to` set to the zero address.
1025      *
1026      * Requirements
1027      *
1028      * - `account` cannot be the zero address.
1029      * - `account` must have at least `amount` tokens.
1030      */
1031     function _burn(address account, uint256 amount) internal virtual {
1032         require(account != address(0), "ERC20: burn from the zero address");
1033 
1034         _beforeTokenTransfer(account, address(0), amount);
1035 
1036         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1037         _totalSupply = _totalSupply.sub(amount);
1038         emit Transfer(account, address(0), amount);
1039     }
1040 
1041     /**
1042      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1043      *
1044      * This is internal function is equivalent to `approve`, and can be used to
1045      * e.g. set automatic allowances for certain subsystems, etc.
1046      *
1047      * Emits an {Approval} event.
1048      *
1049      * Requirements:
1050      *
1051      * - `owner` cannot be the zero address.
1052      * - `spender` cannot be the zero address.
1053      */
1054     function _approve(address owner, address spender, uint256 amount) internal virtual {
1055         require(owner != address(0), "ERC20: approve from the zero address");
1056         require(spender != address(0), "ERC20: approve to the zero address");
1057 
1058         _allowances[owner][spender] = amount;
1059         emit Approval(owner, spender, amount);
1060     }
1061 
1062     /**
1063      * @dev Sets {decimals} to a value other than the default one of 18.
1064      *
1065      * WARNING: This function should only be called from the constructor. Most
1066      * applications that interact with token contracts will not expect
1067      * {decimals} to ever change, and may work incorrectly if it does.
1068      */
1069     function _setupDecimals(uint8 decimals_) internal {
1070         _decimals = decimals_;
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before any transfer of tokens. This includes
1075      * minting and burning.
1076      *
1077      * Calling conditions:
1078      *
1079      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1080      * will be to transferred to `to`.
1081      * - when `from` is zero, `amount` tokens will be minted for `to`.
1082      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1083      * - `from` and `to` are never both zero.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1088 }
1089 
1090 
1091 // File: contracts/MOOswapToken.sol
1092 pragma solidity 0.6.12;
1093 contract MOOswapToken is ERC20("MOOswap.org", "MOO"), Ownable {
1094     using SafeMath for uint256;
1095     uint8 public FeeRate = 4;
1096     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1097         uint256 feeAmount = amount.mul(FeeRate).div(100);
1098         _burn(msg.sender, feeAmount);
1099         return super.transfer(recipient, amount.sub(feeAmount));
1100     }
1101     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1102         uint256 feeAmount = amount.mul(FeeRate).div(100);
1103         _burn(sender, feeAmount);
1104         return super.transferFrom(sender, recipient, amount.sub(feeAmount));
1105     }
1106     
1107      /**
1108      * @dev Chef distributes newly generated MOOswapToken to each farmmers
1109      * "onlyOwner" :: for the one who worries about the function, this distribute process is only done by MasterChef contract for farming process
1110      */
1111     function distribute(address _to, uint256 _amount) public onlyOwner {
1112         _mint(_to, _amount);
1113         _moveDelegates(address(0), _delegates[_to], _amount);
1114     }
1115     
1116     /**
1117      * @dev Burning token for deflanationary features
1118      */
1119     function burn(address _from, uint256 _amount) public {
1120         _burn(_from, _amount);
1121     }
1122     
1123     /**
1124      * @dev Tokenomic decition from governance
1125      */
1126     function changeFeeRate(uint8 _feerate) public onlyOwner {
1127         FeeRate = _feerate;
1128     }
1129     
1130     mapping (address => address) internal _delegates;
1131     struct Checkpoint {
1132         uint32 fromBlock;
1133         uint256 votes;
1134     }
1135 
1136     /// @notice A record of votes checkpoints for each account, by index
1137     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1138     /// @notice The number of checkpoints for each account
1139     mapping (address => uint32) public numCheckpoints;
1140     /// @notice The EIP-712 typehash for the contract's domain
1141     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1142     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1143     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1144     /// @notice A record of states for signing / validating signatures
1145     mapping (address => uint) public nonces;
1146     /// @notice An event thats emitted when an account changes its delegate
1147     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1148     /// @notice An event thats emitted when a delegate account's vote balance changes
1149     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1150     
1151     /**
1152      * @notice Delegate votes from `msg.sender` to `delegatee`
1153      * @param delegator The address to get delegatee for
1154      */
1155     function delegates(address delegator)
1156         external
1157         view
1158         returns (address)
1159     {
1160         return _delegates[delegator];
1161     }
1162 
1163    /**
1164     * @notice Delegate votes from `msg.sender` to `delegatee`
1165     * @param delegatee The address to delegate votes to
1166     */
1167     function delegate(address delegatee) external {
1168         return _delegate(msg.sender, delegatee);
1169     }
1170 
1171     /**
1172      * @notice Delegates votes from signatory to `delegatee`
1173      * @param delegatee The address to delegate votes to
1174      * @param nonce The contract state required to match the signature
1175      * @param expiry The time at which to expire the signature
1176      * @param v The recovery byte of the signature
1177      * @param r Half of the ECDSA signature pair
1178      * @param s Half of the ECDSA signature pair
1179      */
1180     function delegateBySig(
1181         address delegatee,
1182         uint nonce,
1183         uint expiry,
1184         uint8 v,
1185         bytes32 r,
1186         bytes32 s
1187     )
1188         external
1189     {
1190         bytes32 domainSeparator = keccak256(
1191             abi.encode(
1192                 DOMAIN_TYPEHASH,
1193                 keccak256(bytes(name())),
1194                 getChainId(),
1195                 address(this)
1196             )
1197         );
1198 
1199         bytes32 structHash = keccak256(
1200             abi.encode(
1201                 DELEGATION_TYPEHASH,
1202                 delegatee,
1203                 nonce,
1204                 expiry
1205             )
1206         );
1207 
1208         bytes32 digest = keccak256(
1209             abi.encodePacked(
1210                 "\x19\x01",
1211                 domainSeparator,
1212                 structHash
1213             )
1214         );
1215 
1216         address signatory = ecrecover(digest, v, r, s);
1217         require(signatory != address(0), "MOOswap.org::delegateBySig: invalid signature");
1218         require(nonce == nonces[signatory]++, "MOOswap.org::delegateBySig: invalid nonce");
1219         require(now <= expiry, "MOOswap.org::delegateBySig: signature expired");
1220         return _delegate(signatory, delegatee);
1221     }
1222 
1223     /**
1224      * @notice Gets the current votes balance for `account`
1225      * @param account The address to get votes balance
1226      * @return The number of current votes for `account`
1227      */
1228     function getCurrentVotes(address account)
1229         external
1230         view
1231         returns (uint256)
1232     {
1233         uint32 nCheckpoints = numCheckpoints[account];
1234         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1235     }
1236 
1237     /**
1238      * @notice Determine the prior number of votes for an account as of a block number
1239      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1240      * @param account The address of the account to check
1241      * @param blockNumber The block number to get the vote balance at
1242      * @return The number of votes the account had as of the given block
1243      */
1244     function getPriorVotes(address account, uint blockNumber)
1245         external
1246         view
1247         returns (uint256)
1248     {
1249         require(blockNumber < block.number, "MOOswap.org::getPriorVotes: not yet determined");
1250 
1251         uint32 nCheckpoints = numCheckpoints[account];
1252         if (nCheckpoints == 0) {
1253             return 0;
1254         }
1255         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1256             return checkpoints[account][nCheckpoints - 1].votes;
1257         }
1258         if (checkpoints[account][0].fromBlock > blockNumber) {
1259             return 0;
1260         }
1261 
1262         uint32 lower = 0;
1263         uint32 upper = nCheckpoints - 1;
1264         while (upper > lower) {
1265             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1266             Checkpoint memory cp = checkpoints[account][center];
1267             if (cp.fromBlock == blockNumber) {
1268                 return cp.votes;
1269             } else if (cp.fromBlock < blockNumber) {
1270                 lower = center;
1271             } else {
1272                 upper = center - 1;
1273             }
1274         }
1275         return checkpoints[account][lower].votes;
1276     }
1277 
1278     function _delegate(address delegator, address delegatee)
1279         internal
1280     {
1281         address currentDelegate = _delegates[delegator];
1282         uint256 delegatorBalance = balanceOf(delegator);
1283         _delegates[delegator] = delegatee;
1284         emit DelegateChanged(delegator, currentDelegate, delegatee);
1285         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1286     }
1287 
1288     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1289         if (srcRep != dstRep && amount > 0) {
1290             if (srcRep != address(0)) {
1291                 // decrease old representative
1292                 uint32 srcRepNum = numCheckpoints[srcRep];
1293                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1294                 uint256 srcRepNew = srcRepOld.sub(amount);
1295                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1296             }
1297             if (dstRep != address(0)) {
1298                 // increase new representative
1299                 uint32 dstRepNum = numCheckpoints[dstRep];
1300                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1301                 uint256 dstRepNew = dstRepOld.add(amount);
1302                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1303             }
1304         }
1305     }
1306 
1307     function _writeCheckpoint(
1308         address delegatee,
1309         uint32 nCheckpoints,
1310         uint256 oldVotes,
1311         uint256 newVotes
1312     )
1313         internal
1314     {
1315         uint32 blockNumber = safe32(block.number, "MOOswap.org::_writeCheckpoint: block number exceeds 32 bits");
1316         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1317             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1318         } else {
1319             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1320             numCheckpoints[delegatee] = nCheckpoints + 1;
1321         }
1322         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1323     }
1324 
1325     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1326         require(n < 2**32, errorMessage);
1327         return uint32(n);
1328     }
1329 
1330     function getChainId() internal pure returns (uint) {
1331         uint256 chainId;
1332         assembly { chainId := chainid() }
1333         return chainId;
1334     }
1335 }