1 
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 pragma solidity ^0.6.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.6.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 pragma solidity ^0.6.2;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
267         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
268         // for accounts without code, i.e. `keccak256('')`
269         bytes32 codehash;
270         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { codehash := extcodehash(account) }
273         return (codehash != accountHash && codehash != 0x0);
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain`call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319       return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         return _functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         return _functionCallWithValue(target, data, value, errorMessage);
356     }
357 
358     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
359         require(isContract(target), "Address: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 // solhint-disable-next-line no-inline-assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 
382 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
383 
384 pragma solidity ^0.6.0;
385 
386 
387 
388 
389 /**
390  * @title SafeERC20
391  * @dev Wrappers around ERC20 operations that throw on failure (when the token
392  * contract returns false). Tokens that return no value (and instead revert or
393  * throw on failure) are also supported, non-reverting calls are assumed to be
394  * successful.
395  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
396  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
397  */
398 library SafeERC20 {
399     using SafeMath for uint256;
400     using Address for address;
401 
402     function safeTransfer(IERC20 token, address to, uint256 value) internal {
403         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
404     }
405 
406     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
407         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
408     }
409 
410     /**
411      * @dev Deprecated. This function has issues similar to the ones found in
412      * {IERC20-approve}, and its usage is discouraged.
413      *
414      * Whenever possible, use {safeIncreaseAllowance} and
415      * {safeDecreaseAllowance} instead.
416      */
417     function safeApprove(IERC20 token, address spender, uint256 value) internal {
418         // safeApprove should only be called when setting an initial allowance,
419         // or when resetting it to zero. To increase and decrease it, use
420         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
421         // solhint-disable-next-line max-line-length
422         require((value == 0) || (token.allowance(address(this), spender) == 0),
423             "SafeERC20: approve from non-zero to non-zero allowance"
424         );
425         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
426     }
427 
428     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
429         uint256 newAllowance = token.allowance(address(this), spender).add(value);
430         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
431     }
432 
433     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
434         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
436     }
437 
438     /**
439      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
440      * on the return value: the return value is optional (but if data is returned, it must not be false).
441      * @param token The token targeted by the call.
442      * @param data The call data (encoded using abi.encode or one of its variants).
443      */
444     function _callOptionalReturn(IERC20 token, bytes memory data) private {
445         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
446         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
447         // the target address contains contract code and also asserts for success in the low-level call.
448 
449         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
450         if (returndata.length > 0) { // Return data is optional
451             // solhint-disable-next-line max-line-length
452             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
453         }
454     }
455 }
456 
457 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
458 
459 pragma solidity ^0.6.0;
460 
461 /**
462  * @dev Library for managing
463  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
464  * types.
465  *
466  * Sets have the following properties:
467  *
468  * - Elements are added, removed, and checked for existence in constant time
469  * (O(1)).
470  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
471  *
472  * ```
473  * contract Example {
474  *     // Add the library methods
475  *     using EnumerableSet for EnumerableSet.AddressSet;
476  *
477  *     // Declare a set state variable
478  *     EnumerableSet.AddressSet private mySet;
479  * }
480  * ```
481  *
482  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
483  * (`UintSet`) are supported.
484  */
485 library EnumerableSet {
486     // To implement this library for multiple types with as little code
487     // repetition as possible, we write it in terms of a generic Set type with
488     // bytes32 values.
489     // The Set implementation uses private functions, and user-facing
490     // implementations (such as AddressSet) are just wrappers around the
491     // underlying Set.
492     // This means that we can only create new EnumerableSets for types that fit
493     // in bytes32.
494 
495     struct Set {
496         // Storage of set values
497         bytes32[] _values;
498 
499         // Position of the value in the `values` array, plus 1 because index 0
500         // means a value is not in the set.
501         mapping (bytes32 => uint256) _indexes;
502     }
503 
504     /**
505      * @dev Add a value to a set. O(1).
506      *
507      * Returns true if the value was added to the set, that is if it was not
508      * already present.
509      */
510     function _add(Set storage set, bytes32 value) private returns (bool) {
511         if (!_contains(set, value)) {
512             set._values.push(value);
513             // The value is stored at length-1, but we add 1 to all indexes
514             // and use 0 as a sentinel value
515             set._indexes[value] = set._values.length;
516             return true;
517         } else {
518             return false;
519         }
520     }
521 
522     /**
523      * @dev Removes a value from a set. O(1).
524      *
525      * Returns true if the value was removed from the set, that is if it was
526      * present.
527      */
528     function _remove(Set storage set, bytes32 value) private returns (bool) {
529         // We read and store the value's index to prevent multiple reads from the same storage slot
530         uint256 valueIndex = set._indexes[value];
531 
532         if (valueIndex != 0) { // Equivalent to contains(set, value)
533             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
534             // the array, and then remove the last element (sometimes called as 'swap and pop').
535             // This modifies the order of the array, as noted in {at}.
536 
537             uint256 toDeleteIndex = valueIndex - 1;
538             uint256 lastIndex = set._values.length - 1;
539 
540             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
541             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
542 
543             bytes32 lastvalue = set._values[lastIndex];
544 
545             // Move the last value to the index where the value to delete is
546             set._values[toDeleteIndex] = lastvalue;
547             // Update the index for the moved value
548             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
549 
550             // Delete the slot where the moved value was stored
551             set._values.pop();
552 
553             // Delete the index for the deleted slot
554             delete set._indexes[value];
555 
556             return true;
557         } else {
558             return false;
559         }
560     }
561 
562     /**
563      * @dev Returns true if the value is in the set. O(1).
564      */
565     function _contains(Set storage set, bytes32 value) private view returns (bool) {
566         return set._indexes[value] != 0;
567     }
568 
569     /**
570      * @dev Returns the number of values on the set. O(1).
571      */
572     function _length(Set storage set) private view returns (uint256) {
573         return set._values.length;
574     }
575 
576    /**
577     * @dev Returns the value stored at position `index` in the set. O(1).
578     *
579     * Note that there are no guarantees on the ordering of values inside the
580     * array, and it may change when more values are added or removed.
581     *
582     * Requirements:
583     *
584     * - `index` must be strictly less than {length}.
585     */
586     function _at(Set storage set, uint256 index) private view returns (bytes32) {
587         require(set._values.length > index, "EnumerableSet: index out of bounds");
588         return set._values[index];
589     }
590 
591     // AddressSet
592 
593     struct AddressSet {
594         Set _inner;
595     }
596 
597     /**
598      * @dev Add a value to a set. O(1).
599      *
600      * Returns true if the value was added to the set, that is if it was not
601      * already present.
602      */
603     function add(AddressSet storage set, address value) internal returns (bool) {
604         return _add(set._inner, bytes32(uint256(value)));
605     }
606 
607     /**
608      * @dev Removes a value from a set. O(1).
609      *
610      * Returns true if the value was removed from the set, that is if it was
611      * present.
612      */
613     function remove(AddressSet storage set, address value) internal returns (bool) {
614         return _remove(set._inner, bytes32(uint256(value)));
615     }
616 
617     /**
618      * @dev Returns true if the value is in the set. O(1).
619      */
620     function contains(AddressSet storage set, address value) internal view returns (bool) {
621         return _contains(set._inner, bytes32(uint256(value)));
622     }
623 
624     /**
625      * @dev Returns the number of values in the set. O(1).
626      */
627     function length(AddressSet storage set) internal view returns (uint256) {
628         return _length(set._inner);
629     }
630 
631    /**
632     * @dev Returns the value stored at position `index` in the set. O(1).
633     *
634     * Note that there are no guarantees on the ordering of values inside the
635     * array, and it may change when more values are added or removed.
636     *
637     * Requirements:
638     *
639     * - `index` must be strictly less than {length}.
640     */
641     function at(AddressSet storage set, uint256 index) internal view returns (address) {
642         return address(uint256(_at(set._inner, index)));
643     }
644 
645 
646     // UintSet
647 
648     struct UintSet {
649         Set _inner;
650     }
651 
652     /**
653      * @dev Add a value to a set. O(1).
654      *
655      * Returns true if the value was added to the set, that is if it was not
656      * already present.
657      */
658     function add(UintSet storage set, uint256 value) internal returns (bool) {
659         return _add(set._inner, bytes32(value));
660     }
661 
662     /**
663      * @dev Removes a value from a set. O(1).
664      *
665      * Returns true if the value was removed from the set, that is if it was
666      * present.
667      */
668     function remove(UintSet storage set, uint256 value) internal returns (bool) {
669         return _remove(set._inner, bytes32(value));
670     }
671 
672     /**
673      * @dev Returns true if the value is in the set. O(1).
674      */
675     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
676         return _contains(set._inner, bytes32(value));
677     }
678 
679     /**
680      * @dev Returns the number of values on the set. O(1).
681      */
682     function length(UintSet storage set) internal view returns (uint256) {
683         return _length(set._inner);
684     }
685 
686    /**
687     * @dev Returns the value stored at position `index` in the set. O(1).
688     *
689     * Note that there are no guarantees on the ordering of values inside the
690     * array, and it may change when more values are added or removed.
691     *
692     * Requirements:
693     *
694     * - `index` must be strictly less than {length}.
695     */
696     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
697         return uint256(_at(set._inner, index));
698     }
699 }
700 
701 // File: @openzeppelin/contracts/GSN/Context.sol
702 
703 pragma solidity ^0.6.0;
704 
705 /*
706  * @dev Provides information about the current execution context, including the
707  * sender of the transaction and its data. While these are generally available
708  * via msg.sender and msg.data, they should not be accessed in such a direct
709  * manner, since when dealing with GSN meta-transactions the account sending and
710  * paying for execution may not be the actual sender (as far as an application
711  * is concerned).
712  *
713  * This contract is only required for intermediate, library-like contracts.
714  */
715 abstract contract Context {
716     function _msgSender() internal view virtual returns (address payable) {
717         return msg.sender;
718     }
719 
720     function _msgData() internal view virtual returns (bytes memory) {
721         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
722         return msg.data;
723     }
724 }
725 
726 // File: @openzeppelin/contracts/access/Ownable.sol
727 
728 pragma solidity ^0.6.0;
729 
730 /**
731  * @dev Contract module which provides a basic access control mechanism, where
732  * there is an account (an owner) that can be granted exclusive access to
733  * specific functions.
734  *
735  * By default, the owner account will be the one that deploys the contract. This
736  * can later be changed with {transferOwnership}.
737  *
738  * This module is used through inheritance. It will make available the modifier
739  * `onlyOwner`, which can be applied to your functions to restrict their use to
740  * the owner.
741  */
742 contract Ownable is Context {
743     address private _owner;
744 
745     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
746 
747     /**
748      * @dev Initializes the contract setting the deployer as the initial owner.
749      */
750     constructor () internal {
751         address msgSender = _msgSender();
752         _owner = msgSender;
753         emit OwnershipTransferred(address(0), msgSender);
754     }
755 
756     /**
757      * @dev Returns the address of the current owner.
758      */
759     function owner() public view returns (address) {
760         return _owner;
761     }
762 
763     /**
764      * @dev Throws if called by any account other than the owner.
765      */
766     modifier onlyOwner() {
767         require(_owner == _msgSender(), "Ownable: caller is not the owner");
768         _;
769     }
770 
771     /**
772      * @dev Leaves the contract without owner. It will not be possible to call
773      * `onlyOwner` functions anymore. Can only be called by the current owner.
774      *
775      * NOTE: Renouncing ownership will leave the contract without an owner,
776      * thereby removing any functionality that is only available to the owner.
777      */
778     function renounceOwnership() public virtual onlyOwner {
779         emit OwnershipTransferred(_owner, address(0));
780         _owner = address(0);
781     }
782 
783     /**
784      * @dev Transfers ownership of the contract to a new account (`newOwner`).
785      * Can only be called by the current owner.
786      */
787     function transferOwnership(address newOwner) public virtual onlyOwner {
788         require(newOwner != address(0), "Ownable: new owner is the zero address");
789         emit OwnershipTransferred(_owner, newOwner);
790         _owner = newOwner;
791     }
792 }
793 
794 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
795 
796 pragma solidity ^0.6.0;
797 
798 
799 
800 
801 
802 /**
803  * @dev Implementation of the {IERC20} interface.
804  *
805  * This implementation is agnostic to the way tokens are created. This means
806  * that a supply mechanism has to be added in a derived contract using {_mint}.
807  * For a generic mechanism see {ERC20PresetMinterPauser}.
808  *
809  * TIP: For a detailed writeup see our guide
810  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
811  * to implement supply mechanisms].
812  *
813  * We have followed general OpenZeppelin guidelines: functions revert instead
814  * of returning `false` on failure. This behavior is nonetheless conventional
815  * and does not conflict with the expectations of ERC20 applications.
816  *
817  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
818  * This allows applications to reconstruct the allowance for all accounts just
819  * by listening to said events. Other implementations of the EIP may not emit
820  * these events, as it isn't required by the specification.
821  *
822  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
823  * functions have been added to mitigate the well-known issues around setting
824  * allowances. See {IERC20-approve}.
825  */
826 contract ERC20 is Context, IERC20 {
827     using SafeMath for uint256;
828     using Address for address;
829 
830     mapping (address => uint256) private _balances;
831 
832     mapping (address => mapping (address => uint256)) private _allowances;
833 
834     uint256 private _totalSupply;
835 
836     string private _name;
837     string private _symbol;
838     uint8 private _decimals;
839 
840     /**
841      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
842      * a default value of 18.
843      *
844      * To select a different value for {decimals}, use {_setupDecimals}.
845      *
846      * All three of these values are immutable: they can only be set once during
847      * construction.
848      */
849     constructor (string memory name, string memory symbol) public {
850         _name = name;
851         _symbol = symbol;
852         _decimals = 18;
853     }
854 
855     /**
856      * @dev Returns the name of the token.
857      */
858     function name() public view returns (string memory) {
859         return _name;
860     }
861 
862     /**
863      * @dev Returns the symbol of the token, usually a shorter version of the
864      * name.
865      */
866     function symbol() public view returns (string memory) {
867         return _symbol;
868     }
869 
870     /**
871      * @dev Returns the number of decimals used to get its user representation.
872      * For example, if `decimals` equals `2`, a balance of `505` tokens should
873      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
874      *
875      * Tokens usually opt for a value of 18, imitating the relationship between
876      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
877      * called.
878      *
879      * NOTE: This information is only used for _display_ purposes: it in
880      * no way affects any of the arithmetic of the contract, including
881      * {IERC20-balanceOf} and {IERC20-transfer}.
882      */
883     function decimals() public view returns (uint8) {
884         return _decimals;
885     }
886 
887     /**
888      * @dev See {IERC20-totalSupply}.
889      */
890     function totalSupply() public view override returns (uint256) {
891         return _totalSupply;
892     }
893 
894     /**
895      * @dev See {IERC20-balanceOf}.
896      */
897     function balanceOf(address account) public view override returns (uint256) {
898         return _balances[account];
899     }
900 
901     /**
902      * @dev See {IERC20-transfer}.
903      *
904      * Requirements:
905      *
906      * - `recipient` cannot be the zero address.
907      * - the caller must have a balance of at least `amount`.
908      */
909     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
910         _transfer(_msgSender(), recipient, amount);
911         return true;
912     }
913 
914     /**
915      * @dev See {IERC20-allowance}.
916      */
917     function allowance(address owner, address spender) public view virtual override returns (uint256) {
918         return _allowances[owner][spender];
919     }
920 
921     /**
922      * @dev See {IERC20-approve}.
923      *
924      * Requirements:
925      *
926      * - `spender` cannot be the zero address.
927      */
928     function approve(address spender, uint256 amount) public virtual override returns (bool) {
929         _approve(_msgSender(), spender, amount);
930         return true;
931     }
932 
933     /**
934      * @dev See {IERC20-transferFrom}.
935      *
936      * Emits an {Approval} event indicating the updated allowance. This is not
937      * required by the EIP. See the note at the beginning of {ERC20};
938      *
939      * Requirements:
940      * - `sender` and `recipient` cannot be the zero address.
941      * - `sender` must have a balance of at least `amount`.
942      * - the caller must have allowance for ``sender``'s tokens of at least
943      * `amount`.
944      */
945     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
946         _transfer(sender, recipient, amount);
947         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
948         return true;
949     }
950 
951     /**
952      * @dev Atomically increases the allowance granted to `spender` by the caller.
953      *
954      * This is an alternative to {approve} that can be used as a mitigation for
955      * problems described in {IERC20-approve}.
956      *
957      * Emits an {Approval} event indicating the updated allowance.
958      *
959      * Requirements:
960      *
961      * - `spender` cannot be the zero address.
962      */
963     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
964         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
965         return true;
966     }
967 
968     /**
969      * @dev Atomically decreases the allowance granted to `spender` by the caller.
970      *
971      * This is an alternative to {approve} that can be used as a mitigation for
972      * problems described in {IERC20-approve}.
973      *
974      * Emits an {Approval} event indicating the updated allowance.
975      *
976      * Requirements:
977      *
978      * - `spender` cannot be the zero address.
979      * - `spender` must have allowance for the caller of at least
980      * `subtractedValue`.
981      */
982     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
983         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
984         return true;
985     }
986 
987     /**
988      * @dev Moves tokens `amount` from `sender` to `recipient`.
989      *
990      * This is internal function is equivalent to {transfer}, and can be used to
991      * e.g. implement automatic token fees, slashing mechanisms, etc.
992      *
993      * Emits a {Transfer} event.
994      *
995      * Requirements:
996      *
997      * - `sender` cannot be the zero address.
998      * - `recipient` cannot be the zero address.
999      * - `sender` must have a balance of at least `amount`.
1000      */
1001     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1002         require(sender != address(0), "ERC20: transfer from the zero address");
1003         require(recipient != address(0), "ERC20: transfer to the zero address");
1004 
1005         _beforeTokenTransfer(sender, recipient, amount);
1006 
1007         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1008         _balances[recipient] = _balances[recipient].add(amount);
1009         emit Transfer(sender, recipient, amount);
1010     }
1011 
1012     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1013      * the total supply.
1014      *
1015      * Emits a {Transfer} event with `from` set to the zero address.
1016      *
1017      * Requirements
1018      *
1019      * - `to` cannot be the zero address.
1020      */
1021     function _mint(address account, uint256 amount) internal virtual {
1022         require(account != address(0), "ERC20: mint to the zero address");
1023 
1024         _beforeTokenTransfer(address(0), account, amount);
1025 
1026         _totalSupply = _totalSupply.add(amount);
1027         _balances[account] = _balances[account].add(amount);
1028         emit Transfer(address(0), account, amount);
1029     }
1030 
1031     /**
1032      * @dev Destroys `amount` tokens from `account`, reducing the
1033      * total supply.
1034      *
1035      * Emits a {Transfer} event with `to` set to the zero address.
1036      *
1037      * Requirements
1038      *
1039      * - `account` cannot be the zero address.
1040      * - `account` must have at least `amount` tokens.
1041      */
1042     function _burn(address account, uint256 amount) internal virtual {
1043         require(account != address(0), "ERC20: burn from the zero address");
1044 
1045         _beforeTokenTransfer(account, address(0), amount);
1046 
1047         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1048         _totalSupply = _totalSupply.sub(amount);
1049         emit Transfer(account, address(0), amount);
1050     }
1051 
1052     /**
1053      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1054      *
1055      * This is internal function is equivalent to `approve`, and can be used to
1056      * e.g. set automatic allowances for certain subsystems, etc.
1057      *
1058      * Emits an {Approval} event.
1059      *
1060      * Requirements:
1061      *
1062      * - `owner` cannot be the zero address.
1063      * - `spender` cannot be the zero address.
1064      */
1065     function _approve(address owner, address spender, uint256 amount) internal virtual {
1066         require(owner != address(0), "ERC20: approve from the zero address");
1067         require(spender != address(0), "ERC20: approve to the zero address");
1068 
1069         _allowances[owner][spender] = amount;
1070         emit Approval(owner, spender, amount);
1071     }
1072 
1073     /**
1074      * @dev Sets {decimals} to a value other than the default one of 18.
1075      *
1076      * WARNING: This function should only be called from the constructor. Most
1077      * applications that interact with token contracts will not expect
1078      * {decimals} to ever change, and may work incorrectly if it does.
1079      */
1080     function _setupDecimals(uint8 decimals_) internal {
1081         _decimals = decimals_;
1082     }
1083 
1084     /**
1085      * @dev Hook that is called before any transfer of tokens. This includes
1086      * minting and burning.
1087      *
1088      * Calling conditions:
1089      *
1090      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1091      * will be to transferred to `to`.
1092      * - when `from` is zero, `amount` tokens will be minted for `to`.
1093      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1094      * - `from` and `to` are never both zero.
1095      *
1096      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1097      */
1098     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1099 }
1100 
1101 // File: contracts/MoonToken.sol
1102 
1103 pragma solidity 0.6.12;
1104 
1105 
1106 
1107 
1108 // MoonToken with Governance.
1109 contract MoonToken is ERC20("MoonToken", "MOON"), Ownable {
1110     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1111     function mint(address _to, uint256 _amount) public onlyOwner {
1112         _mint(_to, _amount);
1113         _moveDelegates(address(0), _delegates[_to], _amount);
1114     }
1115 
1116     //  transfers delegate authority when sending a token.
1117     // https://medium.com/bulldax-finance/sushiswap-delegation-double-spending-bug-5adcc7b3830f
1118     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
1119       super._transfer(sender, recipient, amount);
1120       _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1121     }
1122 
1123     /// @notice A record of each accounts delegate
1124     mapping (address => address) internal _delegates;
1125 
1126     /// @notice A checkpoint for marking number of votes from a given block
1127     struct Checkpoint {
1128         uint32 fromBlock;
1129         uint256 votes;
1130     }
1131 
1132     /// @notice A record of votes checkpoints for each account, by index
1133     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1134 
1135     /// @notice The number of checkpoints for each account
1136     mapping (address => uint32) public numCheckpoints;
1137 
1138     /// @notice The EIP-712 typehash for the contract's domain
1139     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1140 
1141     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1142     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1143 
1144     /// @notice A record of states for signing / validating signatures
1145     mapping (address => uint) public nonces;
1146 
1147       /// @notice An event thats emitted when an account changes its delegate
1148     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1149 
1150     /// @notice An event thats emitted when a delegate account's vote balance changes
1151     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1152 
1153     /**
1154      * @notice Delegate votes from `msg.sender` to `delegatee`
1155      * @param delegator The address to get delegatee for
1156      */
1157     function delegates(address delegator)
1158         external
1159         view
1160         returns (address)
1161     {
1162         return _delegates[delegator];
1163     }
1164 
1165    /**
1166     * @notice Delegate votes from `msg.sender` to `delegatee`
1167     * @param delegatee The address to delegate votes to
1168     */
1169     function delegate(address delegatee) external {
1170         return _delegate(msg.sender, delegatee);
1171     }
1172 
1173     /**
1174      * @notice Delegates votes from signatory to `delegatee`
1175      * @param delegatee The address to delegate votes to
1176      * @param nonce The contract state required to match the signature
1177      * @param expiry The time at which to expire the signature
1178      * @param v The recovery byte of the signature
1179      * @param r Half of the ECDSA signature pair
1180      * @param s Half of the ECDSA signature pair
1181      */
1182     function delegateBySig(
1183         address delegatee,
1184         uint nonce,
1185         uint expiry,
1186         uint8 v,
1187         bytes32 r,
1188         bytes32 s
1189     )
1190         external
1191     {
1192         bytes32 domainSeparator = keccak256(
1193             abi.encode(
1194                 DOMAIN_TYPEHASH,
1195                 keccak256(bytes(name())),
1196                 getChainId(),
1197                 address(this)
1198             )
1199         );
1200 
1201         bytes32 structHash = keccak256(
1202             abi.encode(
1203                 DELEGATION_TYPEHASH,
1204                 delegatee,
1205                 nonce,
1206                 expiry
1207             )
1208         );
1209 
1210         bytes32 digest = keccak256(
1211             abi.encodePacked(
1212                 "\x19\x01",
1213                 domainSeparator,
1214                 structHash
1215             )
1216         );
1217 
1218         address signatory = ecrecover(digest, v, r, s);
1219         require(signatory != address(0), "MOON::delegateBySig: invalid signature");
1220         require(nonce == nonces[signatory]++, "MOON::delegateBySig: invalid nonce");
1221         require(now <= expiry, "MOON::delegateBySig: signature expired");
1222         return _delegate(signatory, delegatee);
1223     }
1224 
1225     /**
1226      * @notice Gets the current votes balance for `account`
1227      * @param account The address to get votes balance
1228      * @return The number of current votes for `account`
1229      */
1230     function getCurrentVotes(address account)
1231         external
1232         view
1233         returns (uint256)
1234     {
1235         uint32 nCheckpoints = numCheckpoints[account];
1236         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1237     }
1238 
1239     /**
1240      * @notice Determine the prior number of votes for an account as of a block number
1241      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1242      * @param account The address of the account to check
1243      * @param blockNumber The block number to get the vote balance at
1244      * @return The number of votes the account had as of the given block
1245      */
1246     function getPriorVotes(address account, uint blockNumber)
1247         external
1248         view
1249         returns (uint256)
1250     {
1251         require(blockNumber < block.number, "MOON::getPriorVotes: not yet determined");
1252 
1253         uint32 nCheckpoints = numCheckpoints[account];
1254         if (nCheckpoints == 0) {
1255             return 0;
1256         }
1257 
1258         // First check most recent balance
1259         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1260             return checkpoints[account][nCheckpoints - 1].votes;
1261         }
1262 
1263         // Next check implicit zero balance
1264         if (checkpoints[account][0].fromBlock > blockNumber) {
1265             return 0;
1266         }
1267 
1268         uint32 lower = 0;
1269         uint32 upper = nCheckpoints - 1;
1270         while (upper > lower) {
1271             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1272             Checkpoint memory cp = checkpoints[account][center];
1273             if (cp.fromBlock == blockNumber) {
1274                 return cp.votes;
1275             } else if (cp.fromBlock < blockNumber) {
1276                 lower = center;
1277             } else {
1278                 upper = center - 1;
1279             }
1280         }
1281         return checkpoints[account][lower].votes;
1282     }
1283 
1284     function _delegate(address delegator, address delegatee)
1285         internal
1286     {
1287         address currentDelegate = _delegates[delegator];
1288         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MOONs (not scaled);
1289         _delegates[delegator] = delegatee;
1290 
1291         emit DelegateChanged(delegator, currentDelegate, delegatee);
1292 
1293         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1294     }
1295 
1296     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1297         if (srcRep != dstRep && amount > 0) {
1298             if (srcRep != address(0)) {
1299                 // decrease old representative
1300                 uint32 srcRepNum = numCheckpoints[srcRep];
1301                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1302                 uint256 srcRepNew = srcRepOld.sub(amount);
1303                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1304             }
1305 
1306             if (dstRep != address(0)) {
1307                 // increase new representative
1308                 uint32 dstRepNum = numCheckpoints[dstRep];
1309                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1310                 uint256 dstRepNew = dstRepOld.add(amount);
1311                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1312             }
1313         }
1314     }
1315 
1316     function _writeCheckpoint(
1317         address delegatee,
1318         uint32 nCheckpoints,
1319         uint256 oldVotes,
1320         uint256 newVotes
1321     )
1322         internal
1323     {
1324         uint32 blockNumber = safe32(block.number, "MOON::_writeCheckpoint: block number exceeds 32 bits");
1325 
1326         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1327             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1328         } else {
1329             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1330             numCheckpoints[delegatee] = nCheckpoints + 1;
1331         }
1332 
1333         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1334     }
1335 
1336     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1337         require(n < 2**32, errorMessage);
1338         return uint32(n);
1339     }
1340 
1341     function getChainId() internal pure returns (uint) {
1342         uint256 chainId;
1343         assembly { chainId := chainid() }
1344         return chainId;
1345     }
1346 }
1347 
1348 // File: contracts/MasterStar.sol
1349 
1350 pragma solidity 0.6.12;
1351 
1352 
1353 
1354 
1355 
1356 
1357 
1358 
1359 interface IMigratorStar {
1360     // Perform LP token migration from legacy UniswapV2 to MoonSwap.
1361     // Take the current LP token address and return the new LP token address.
1362     // Migrator should have full access to the caller's LP token.
1363     // Return the new LP token address.
1364     // Move Asset to conflux chain mint cToken
1365     function migrate(IERC20 token) external returns (IERC20);
1366 }
1367 
1368 // MasterStar is the master of Moon. He can make Moon and he is a fair guy.
1369 //
1370 // Note that it's ownable and the owner wields tremendous power. The ownership
1371 // will be transferred to a governance smart contract once Moon is sufficiently
1372 // distributed and the community can show to govern itself.
1373 //
1374 // Have fun reading it. Hopefully it's bug-free. God bless.
1375 contract MasterStar is Ownable {
1376     using SafeMath for uint256;
1377     using SafeERC20 for IERC20;
1378 
1379     // Info of each user.
1380     struct UserInfo {
1381         uint256 amount;     // How many LP tokens the user has provided.
1382         uint256 rewardDebt; // Reward debt. See explanation below.
1383         //
1384         // We do some fancy math here. Basically, any point in time, the amount of Moons
1385         // entitled to a user but is pending to be distributed is:
1386         //
1387         //   pending reward = (user.amount * pool.accMoonPerShare) - user.rewardDebt
1388         //
1389         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1390         //   1. The pool's `accMoonPerShare` (and `lastRewardBlock`) gets updated.
1391         //   2. User receives the pending reward sent to his/her address.
1392         //   3. User's `amount` gets updated.
1393         //   4. User's `rewardDebt` gets updated.
1394     }
1395 
1396     // Info of each pool.
1397     struct PoolInfo {
1398         IERC20 lpToken;           // Address of LP token contract.
1399         uint256 allocPoint;       // How many allocation points assigned to this pool. Moons to distribute per block.
1400         uint256 lastRewardBlock;  // Last block number that Moons distribution occurs.
1401         uint256 accTokenPerShare; // Accumulated Moons per share, times 1e12. See below.
1402         uint256 tokenPerBlock; //  Flag halve block amount
1403         bool finishMigrate; // migrate crosschain finish pause
1404         uint256 lockCrosschainAmount; // flag crosschain amount
1405     }
1406 
1407     // The Moon TOKEN!
1408     MoonToken public token;
1409     // Dev address.
1410     address public devaddr;
1411     // Early bird plan Lp address.
1412     address public earlybirdLpAddr;
1413     // Block number when genesis bonus Moon period ends.
1414     uint256 public genesisEndBlock;
1415     // Moon tokens created per block. the
1416     uint256 public firstTokenPerBlock;
1417     // Moon tokens created per block. the current halve logic
1418     uint256 public currentTokenPerBlock;
1419     // Bonus muliplier for early Token makers.
1420     uint256 public constant BONUS_MULTIPLIER = 10;
1421     // Total Miner Token
1422     uint256 public constant MAX_TOKEN_MINER = 1e18 * 1e8; // 100 million
1423     // Early bird plan Lp Mint Moon Token
1424     uint256 public constant BIRD_LP_MINT_TOKEN_NUM = 1250000 * 1e18;
1425     // Total Miner Token
1426     uint256 public totalMinerToken;
1427     // Genesis Miner BlockNum
1428     uint256 public genesisMinerBlockNum = 50000;
1429     // halve blocknum
1430     uint256 public halveBlockNum = 5000000;
1431     // Total mint block num
1432     uint256 public totalMinerBlockNum = genesisMinerBlockNum + halveBlockNum * 4; // About four years
1433     // Flag Start Miner block
1434     uint256 public firstMinerBlock;
1435     // max miner block, it is end miner
1436     uint256 public maxMinerBlock;
1437     // lastHalveBlock
1438     uint256 public lastHalveBlock;
1439     // migrate moon crosschain pool manager
1440     mapping(uint256 => address) public migratePoolAddrs;
1441     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1442     IMigratorStar public migrator;
1443 
1444     // Info of each pool.
1445     PoolInfo[] public poolInfo;
1446     // Info of each user that stakes LP tokens.
1447     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1448     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1449     uint256 public totalAllocPoint = 0;
1450     // The block number when Token mining starts.
1451     uint256 public startBlock;
1452     mapping(address => uint256) internal poolIndexs;
1453 
1454     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1455     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1456     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1457     event TokenConvert(address indexed user, uint256 indexed pid, address to, uint256 amount);
1458     event MigrateWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1459 
1460     constructor(
1461         MoonToken _moon,
1462         address _devaddr,
1463         uint256 _tokenPerBlock,
1464         uint256 _startBlock
1465     ) public {
1466         token = _moon;
1467         devaddr = _devaddr;
1468         firstTokenPerBlock = _tokenPerBlock; // 100000000000000000000  1e18
1469         currentTokenPerBlock = firstTokenPerBlock;
1470         startBlock = _startBlock;
1471     }
1472 
1473     function poolLength() external view returns (uint256) {
1474         return poolInfo.length;
1475     }
1476 
1477     // admin mint early bird Lp token only once
1478     function mintEarlybirdToken(address to) public onlyOwner {
1479       require(earlybirdLpAddr == address(0) && to != address(0), "mint early bird token once");
1480       earlybirdLpAddr = to;
1481       totalMinerToken = totalMinerToken.add(BIRD_LP_MINT_TOKEN_NUM);
1482       token.mint(earlybirdLpAddr, BIRD_LP_MINT_TOKEN_NUM);
1483     }
1484 
1485     // Add a new lp to the pool. Can only be called by the owner.
1486     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1487     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1488         if (_withUpdate) {
1489             massUpdatePools();
1490         }
1491         require(poolIndexs[address(_lpToken)] < 1, "LpToken exists");
1492         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1493         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1494         poolInfo.push(PoolInfo({
1495             lpToken: _lpToken,
1496             allocPoint: _allocPoint,
1497             lastRewardBlock: lastRewardBlock,
1498             tokenPerBlock: currentTokenPerBlock,
1499             accTokenPerShare: 0,
1500             finishMigrate: false,
1501             lockCrosschainAmount:0
1502         }));
1503 
1504         poolIndexs[address(_lpToken)] = poolInfo.length;
1505     }
1506 
1507     // Update the given pool's Token allocation point. Can only be called by the owner.
1508     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1509         if (_withUpdate) {
1510             massUpdatePools();
1511         }
1512         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1513         poolInfo[_pid].allocPoint = _allocPoint;
1514     }
1515 
1516     // Set the migrator contract. Can only be called by the owner.
1517     function setMigrator(IMigratorStar _migrator) public onlyOwner {
1518         migrator = _migrator;
1519     }
1520 
1521     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1522     function migrate(uint256 _pid) public {
1523         require(address(migrator) != address(0), "migrate: no migrator");
1524         require(migratePoolAddrs[_pid] != address(0), "migrate: no cmoon address");
1525         PoolInfo storage pool = poolInfo[_pid];
1526         IERC20 lpToken = pool.lpToken;
1527         uint256 bal = lpToken.balanceOf(address(this));
1528         lpToken.safeApprove(address(migrator), bal);
1529         IERC20 newLpToken = migrator.migrate(lpToken);
1530         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1531         pool.lpToken = newLpToken;
1532         pool.finishMigrate = true;
1533     }
1534 
1535     // when migrate must set pool cross chain
1536     function setCrosschain(uint256 _pid, address cmoonAddr) public onlyOwner {
1537         PoolInfo storage pool = poolInfo[_pid];
1538         require(cmoonAddr != address(0), "address invalid");
1539         migratePoolAddrs[_pid] = cmoonAddr;
1540     }
1541 
1542     // View function to see pending Token on frontend.
1543     function pendingToken(uint256 _pid, address _user) external view returns (uint256) {
1544         PoolInfo storage pool = poolInfo[_pid];
1545         UserInfo storage user = userInfo[_pid][_user];
1546         uint256 accTokenPerShare = pool.accTokenPerShare;
1547         //uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1548         uint256 lpSupply = pool.lockCrosschainAmount.add(pool.lpToken.balanceOf(address(this)));
1549         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1550             (uint256 genesisPoolReward, uint256 productionPoolReward) = _getPoolReward(pool, pool.tokenPerBlock, pool.tokenPerBlock.div(2));
1551             (, uint256 lpStakeTokenNum) =
1552               _assignPoolReward(genesisPoolReward, productionPoolReward);
1553             accTokenPerShare = accTokenPerShare.add(lpStakeTokenNum.mul(1e12).div(lpSupply));
1554         }
1555         return user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
1556     }
1557 
1558     // Update reward vairables for all pools. Be careful of gas spending!
1559     function massUpdatePools() public {
1560         uint256 length = poolInfo.length;
1561         for (uint256 pid = 0; pid < length; ++pid) {
1562             updatePool(pid);
1563         }
1564     }
1565 
1566     // Update reward variables of the given pool to be up-to-date.
1567     function updatePool(uint256 _pid) public {
1568         PoolInfo storage pool = poolInfo[_pid];
1569         if (block.number <= pool.lastRewardBlock) {
1570             return;
1571         }
1572         uint256 lpSupply = pool.lockCrosschainAmount.add(pool.lpToken.balanceOf(address(this)));
1573         //uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1574         if (lpSupply == 0) {
1575             pool.lastRewardBlock = block.number;
1576             return;
1577         }
1578 
1579         (uint256 genesisPoolReward, uint256 productionPoolReward) =
1580             _getPoolReward(pool, pool.tokenPerBlock, pool.tokenPerBlock.div(2));
1581         totalMinerToken = totalMinerToken.add(genesisPoolReward).add(productionPoolReward);
1582 
1583         (uint256 devTokenNum, uint256 lpStakeTokenNum) =
1584           _assignPoolReward(genesisPoolReward, productionPoolReward);
1585 
1586 
1587         if(devTokenNum > 0){
1588           token.mint(devaddr, devTokenNum);
1589         }
1590 
1591         if(lpStakeTokenNum > 0){
1592           token.mint(address(this), lpStakeTokenNum);
1593         }
1594 
1595         pool.accTokenPerShare = pool.accTokenPerShare.add(lpStakeTokenNum.mul(1e12).div(lpSupply));
1596         pool.lastRewardBlock = block.number > maxMinerBlock ? maxMinerBlock : block.number;
1597 
1598         // when migrate, and user cross
1599         if(lpStakeTokenNum > 0 && pool.finishMigrate){
1600             _transferMigratePoolAddr(_pid, pool.accTokenPerShare);
1601         }
1602 
1603         if(block.number <= maxMinerBlock && (
1604           (lastHalveBlock > 0 && block.number > lastHalveBlock &&  block.number.sub(lastHalveBlock) >= halveBlockNum) ||
1605           (lastHalveBlock == 0 && block.number > genesisEndBlock && block.number.sub(genesisEndBlock) >= halveBlockNum)
1606         )){
1607             lastHalveBlock = lastHalveBlock == 0 ?
1608                 genesisEndBlock.add(halveBlockNum) : lastHalveBlock.add(halveBlockNum);
1609             currentTokenPerBlock = currentTokenPerBlock.div(2);
1610             pool.tokenPerBlock = currentTokenPerBlock;
1611         }
1612     }
1613 
1614     // Deposit LP tokens to MasterStar for Token allocation.
1615     function deposit(uint256 _pid, uint256 _amount) public {
1616         PoolInfo storage pool = poolInfo[_pid];
1617         require(!pool.finishMigrate, "migrate not deposit");
1618         UserInfo storage user = userInfo[_pid][msg.sender];
1619         updatePool(_pid);
1620         if (user.amount > 0) {
1621             uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1622             safeTokenTransfer(msg.sender, pending);
1623         }
1624         if(firstMinerBlock == 0 && _amount > 0){ // first deposit
1625            firstMinerBlock = block.number > startBlock ? block.number : startBlock;
1626            genesisEndBlock = firstMinerBlock.add(genesisMinerBlockNum);
1627            maxMinerBlock = firstMinerBlock.add(totalMinerBlockNum);
1628         }
1629         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1630         user.amount = user.amount.add(_amount);
1631         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1632         emit Deposit(msg.sender, _pid, _amount);
1633     }
1634 
1635     // Withdraw LP tokens from MasterStar.
1636     function withdraw(uint256 _pid, uint256 _amount) public {
1637         PoolInfo storage pool = poolInfo[_pid];
1638         UserInfo storage user = userInfo[_pid][msg.sender];
1639         require(_amount > 0, "user amount is zero");
1640         require(user.amount >= _amount, "withdraw: not good");
1641         updatePool(_pid);
1642         uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1643         safeTokenTransfer(msg.sender, pending);
1644         user.amount = user.amount.sub(_amount);
1645         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1646         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1647         emit Withdraw(msg.sender, _pid, _amount);
1648         if(pool.finishMigrate) { // finish migrate record user withdraw lpToken
1649             pool.lockCrosschainAmount = pool.lockCrosschainAmount.add(_amount);
1650             _depositMigratePoolAddr(_pid, pool.accTokenPerShare, _amount);
1651 
1652             emit MigrateWithdraw(msg.sender, _pid, _amount);
1653         }
1654     }
1655 
1656     // Withdraw without caring about rewards. EMERGENCY ONLY.
1657     function emergencyWithdraw(uint256 _pid) public {
1658         PoolInfo storage pool = poolInfo[_pid];
1659         UserInfo storage user = userInfo[_pid][msg.sender];
1660         uint256 _amount = user.amount;
1661         require(_amount > 0, "user amount is zero");
1662         user.amount = 0;
1663         user.rewardDebt = 0;
1664 
1665         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1666         emit EmergencyWithdraw(msg.sender, _pid, _amount);
1667         if(pool.finishMigrate){ //finish migrate record user withdraw lpToken
1668             pool.lockCrosschainAmount = pool.lockCrosschainAmount.add(_amount);
1669             _depositMigratePoolAddr(_pid, pool.accTokenPerShare, _amount);
1670 
1671             emit MigrateWithdraw(msg.sender, _pid, _amount);
1672         }
1673     }
1674 
1675     // Safe Token transfer function, just in case if rounding error causes pool to not have enough Tokens.
1676     function safeTokenTransfer(address _to, uint256 _amount) internal {
1677         uint256 tokenBal = token.balanceOf(address(this));
1678         if (_amount > tokenBal) {
1679             token.transfer(_to, tokenBal);
1680         } else {
1681             token.transfer(_to, _amount);
1682         }
1683     }
1684 
1685     //  users convert LpToken crosschain conflux
1686     function tokenConvert(uint256 _pid, address _to) public {
1687       PoolInfo storage pool = poolInfo[_pid];
1688       require(pool.finishMigrate, "migrate is not finish");
1689       UserInfo storage user = userInfo[_pid][msg.sender];
1690       uint256 _amount = user.amount;
1691       require(_amount > 0, "user amount is zero");
1692       updatePool(_pid);
1693       uint256 pending = _amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1694       safeTokenTransfer(msg.sender, pending);
1695       user.amount = 0;
1696       user.rewardDebt = 0;
1697       pool.lpToken.safeTransfer(_to, _amount);
1698 
1699       pool.lockCrosschainAmount = pool.lockCrosschainAmount.add(_amount);
1700       _depositMigratePoolAddr(_pid, pool.accTokenPerShare, _amount);
1701       emit TokenConvert(msg.sender, _pid, _to, _amount);
1702 
1703     }
1704 
1705     // Update dev address by the previous dev.
1706     function dev(address _devaddr) public {
1707         require(msg.sender == devaddr, "dev: wut?");
1708         devaddr = _devaddr;
1709     }
1710 
1711     // after migrate, deposit LpToken same amount
1712     function _depositMigratePoolAddr(uint256 _pid, uint256 _poolAccTokenPerShare, uint256 _amount) internal
1713     {
1714       address migratePoolAddr = migratePoolAddrs[_pid];
1715       require(migratePoolAddr != address(0), "address invaid");
1716 
1717       UserInfo storage user = userInfo[_pid][migratePoolAddr];
1718       user.amount = user.amount.add(_amount);
1719       user.rewardDebt = user.amount.mul(_poolAccTokenPerShare).div(1e12);
1720     }
1721 
1722     // after migrate, mint LpToken's moon to address
1723     function _transferMigratePoolAddr(uint256 _pid, uint256 _poolAccTokenPerShare) internal
1724     {
1725         address migratePoolAddr = migratePoolAddrs[_pid];
1726         require(migratePoolAddr != address(0), "address invaid");
1727 
1728         UserInfo storage user = userInfo[_pid][migratePoolAddr];
1729         if(user.amount > 0){
1730           uint256 pending = user.amount.mul(_poolAccTokenPerShare).div(1e12).sub(user.rewardDebt);
1731           safeTokenTransfer(migratePoolAddr, pending);
1732 
1733           user.rewardDebt = user.amount.mul(_poolAccTokenPerShare).div(1e12);
1734         }
1735     }
1736 
1737     function _getPoolReward(PoolInfo memory pool,
1738       uint256 beforeTokenPerBlock,
1739       uint256 afterTokenPerBlock) internal view returns(uint256, uint256){
1740       (uint256 genesisBlocknum, uint256 beforeBlocknum, uint256 afterBlocknum)
1741           = _getPhaseBlocknum(pool);
1742       uint256 _genesisPoolReward = genesisBlocknum.mul(BONUS_MULTIPLIER).mul(firstTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1743       uint256 _beforePoolReward = beforeBlocknum.mul(beforeTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1744       uint256 _afterPoolReward = afterBlocknum.mul(afterTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1745       uint256 _productionPoolReward = _beforePoolReward.add(_afterPoolReward);
1746       // ignore genesis poolReward
1747       if(totalMinerToken.add(_productionPoolReward) > MAX_TOKEN_MINER){
1748         _productionPoolReward = totalMinerToken > MAX_TOKEN_MINER ? 0 : MAX_TOKEN_MINER.sub(totalMinerToken);
1749       }
1750 
1751       return (_genesisPoolReward, _productionPoolReward);
1752     }
1753 
1754     function _getPhaseBlocknum(PoolInfo memory pool) internal view returns(
1755       uint256 genesisBlocknum,
1756       uint256 beforeBlocknum,
1757       uint256 afterBlocknum
1758     ){
1759       genesisBlocknum = 0;
1760       beforeBlocknum = 0;
1761       afterBlocknum = 0;
1762 
1763       uint256 minCurrentBlock = maxMinerBlock > block.number ? block.number : maxMinerBlock;
1764 
1765       if(minCurrentBlock <= genesisEndBlock){
1766         genesisBlocknum = minCurrentBlock.sub(pool.lastRewardBlock);
1767       }else if(pool.lastRewardBlock >= genesisEndBlock){
1768         // when genesisEndBlock end, start halve logic
1769         uint256 expectHalveBlock = lastHalveBlock.add(halveBlockNum);
1770         if(minCurrentBlock <= expectHalveBlock){
1771           beforeBlocknum = minCurrentBlock.sub(pool.lastRewardBlock);
1772         }else if(pool.lastRewardBlock >= expectHalveBlock){
1773           //distance next halve
1774           beforeBlocknum = minCurrentBlock.sub(pool.lastRewardBlock);
1775         }else{
1776           beforeBlocknum = expectHalveBlock.sub(pool.lastRewardBlock);
1777           afterBlocknum = minCurrentBlock.sub(expectHalveBlock);
1778         }
1779       }else{
1780           genesisBlocknum = genesisEndBlock.sub(pool.lastRewardBlock);
1781           beforeBlocknum = minCurrentBlock.sub(genesisEndBlock);
1782       }
1783    }
1784 
1785    function _assignPoolReward(uint256 genesisPoolReward, uint256 productionPoolReward) internal view returns(
1786     uint256 devTokenNum,
1787     uint256 lpStakeTokenNum
1788    ) {
1789      if(genesisPoolReward > 0){
1790        // genesis period ratio 10 90 update
1791        devTokenNum = devTokenNum.add(genesisPoolReward.mul(10).div(100));
1792        lpStakeTokenNum = lpStakeTokenNum.add(genesisPoolReward.sub(devTokenNum));
1793      }
1794 
1795      if(productionPoolReward > 0){
1796        // Production period ratio 10 90
1797        devTokenNum = devTokenNum.add(productionPoolReward.mul(10).div(100));
1798        lpStakeTokenNum = lpStakeTokenNum.add(productionPoolReward.sub(devTokenNum));
1799      }
1800    }
1801 }
