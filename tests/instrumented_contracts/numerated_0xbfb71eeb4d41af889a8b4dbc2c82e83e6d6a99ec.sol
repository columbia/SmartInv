1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
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
81 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
82 
83 pragma solidity ^0.6.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
242 
243 pragma solidity ^0.6.2;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
384 
385 pragma solidity ^0.6.0;
386 
387 
388 
389 
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
458 // File: @openzeppelin\contracts\utils\EnumerableSet.sol
459 
460 pragma solidity ^0.6.0;
461 
462 /**
463  * @dev Library for managing
464  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
465  * types.
466  *
467  * Sets have the following properties:
468  *
469  * - Elements are added, removed, and checked for existence in constant time
470  * (O(1)).
471  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
472  *
473  * ```
474  * contract Example {
475  *     // Add the library methods
476  *     using EnumerableSet for EnumerableSet.AddressSet;
477  *
478  *     // Declare a set state variable
479  *     EnumerableSet.AddressSet private mySet;
480  * }
481  * ```
482  *
483  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
484  * (`UintSet`) are supported.
485  */
486 library EnumerableSet {
487     // To implement this library for multiple types with as little code
488     // repetition as possible, we write it in terms of a generic Set type with
489     // bytes32 values.
490     // The Set implementation uses private functions, and user-facing
491     // implementations (such as AddressSet) are just wrappers around the
492     // underlying Set.
493     // This means that we can only create new EnumerableSets for types that fit
494     // in bytes32.
495 
496     struct Set {
497         // Storage of set values
498         bytes32[] _values;
499 
500         // Position of the value in the `values` array, plus 1 because index 0
501         // means a value is not in the set.
502         mapping (bytes32 => uint256) _indexes;
503     }
504 
505     /**
506      * @dev Add a value to a set. O(1).
507      *
508      * Returns true if the value was added to the set, that is if it was not
509      * already present.
510      */
511     function _add(Set storage set, bytes32 value) private returns (bool) {
512         if (!_contains(set, value)) {
513             set._values.push(value);
514             // The value is stored at length-1, but we add 1 to all indexes
515             // and use 0 as a sentinel value
516             set._indexes[value] = set._values.length;
517             return true;
518         } else {
519             return false;
520         }
521     }
522 
523     /**
524      * @dev Removes a value from a set. O(1).
525      *
526      * Returns true if the value was removed from the set, that is if it was
527      * present.
528      */
529     function _remove(Set storage set, bytes32 value) private returns (bool) {
530         // We read and store the value's index to prevent multiple reads from the same storage slot
531         uint256 valueIndex = set._indexes[value];
532 
533         if (valueIndex != 0) { // Equivalent to contains(set, value)
534             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
535             // the array, and then remove the last element (sometimes called as 'swap and pop').
536             // This modifies the order of the array, as noted in {at}.
537 
538             uint256 toDeleteIndex = valueIndex - 1;
539             uint256 lastIndex = set._values.length - 1;
540 
541             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
542             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
543 
544             bytes32 lastvalue = set._values[lastIndex];
545 
546             // Move the last value to the index where the value to delete is
547             set._values[toDeleteIndex] = lastvalue;
548             // Update the index for the moved value
549             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
550 
551             // Delete the slot where the moved value was stored
552             set._values.pop();
553 
554             // Delete the index for the deleted slot
555             delete set._indexes[value];
556 
557             return true;
558         } else {
559             return false;
560         }
561     }
562 
563     /**
564      * @dev Returns true if the value is in the set. O(1).
565      */
566     function _contains(Set storage set, bytes32 value) private view returns (bool) {
567         return set._indexes[value] != 0;
568     }
569 
570     /**
571      * @dev Returns the number of values on the set. O(1).
572      */
573     function _length(Set storage set) private view returns (uint256) {
574         return set._values.length;
575     }
576 
577    /**
578     * @dev Returns the value stored at position `index` in the set. O(1).
579     *
580     * Note that there are no guarantees on the ordering of values inside the
581     * array, and it may change when more values are added or removed.
582     *
583     * Requirements:
584     *
585     * - `index` must be strictly less than {length}.
586     */
587     function _at(Set storage set, uint256 index) private view returns (bytes32) {
588         require(set._values.length > index, "EnumerableSet: index out of bounds");
589         return set._values[index];
590     }
591 
592     // AddressSet
593 
594     struct AddressSet {
595         Set _inner;
596     }
597 
598     /**
599      * @dev Add a value to a set. O(1).
600      *
601      * Returns true if the value was added to the set, that is if it was not
602      * already present.
603      */
604     function add(AddressSet storage set, address value) internal returns (bool) {
605         return _add(set._inner, bytes32(uint256(value)));
606     }
607 
608     /**
609      * @dev Removes a value from a set. O(1).
610      *
611      * Returns true if the value was removed from the set, that is if it was
612      * present.
613      */
614     function remove(AddressSet storage set, address value) internal returns (bool) {
615         return _remove(set._inner, bytes32(uint256(value)));
616     }
617 
618     /**
619      * @dev Returns true if the value is in the set. O(1).
620      */
621     function contains(AddressSet storage set, address value) internal view returns (bool) {
622         return _contains(set._inner, bytes32(uint256(value)));
623     }
624 
625     /**
626      * @dev Returns the number of values in the set. O(1).
627      */
628     function length(AddressSet storage set) internal view returns (uint256) {
629         return _length(set._inner);
630     }
631 
632    /**
633     * @dev Returns the value stored at position `index` in the set. O(1).
634     *
635     * Note that there are no guarantees on the ordering of values inside the
636     * array, and it may change when more values are added or removed.
637     *
638     * Requirements:
639     *
640     * - `index` must be strictly less than {length}.
641     */
642     function at(AddressSet storage set, uint256 index) internal view returns (address) {
643         return address(uint256(_at(set._inner, index)));
644     }
645 
646 
647     // UintSet
648 
649     struct UintSet {
650         Set _inner;
651     }
652 
653     /**
654      * @dev Add a value to a set. O(1).
655      *
656      * Returns true if the value was added to the set, that is if it was not
657      * already present.
658      */
659     function add(UintSet storage set, uint256 value) internal returns (bool) {
660         return _add(set._inner, bytes32(value));
661     }
662 
663     /**
664      * @dev Removes a value from a set. O(1).
665      *
666      * Returns true if the value was removed from the set, that is if it was
667      * present.
668      */
669     function remove(UintSet storage set, uint256 value) internal returns (bool) {
670         return _remove(set._inner, bytes32(value));
671     }
672 
673     /**
674      * @dev Returns true if the value is in the set. O(1).
675      */
676     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
677         return _contains(set._inner, bytes32(value));
678     }
679 
680     /**
681      * @dev Returns the number of values on the set. O(1).
682      */
683     function length(UintSet storage set) internal view returns (uint256) {
684         return _length(set._inner);
685     }
686 
687    /**
688     * @dev Returns the value stored at position `index` in the set. O(1).
689     *
690     * Note that there are no guarantees on the ordering of values inside the
691     * array, and it may change when more values are added or removed.
692     *
693     * Requirements:
694     *
695     * - `index` must be strictly less than {length}.
696     */
697     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
698         return uint256(_at(set._inner, index));
699     }
700 }
701 
702 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
703 
704 pragma solidity ^0.6.0;
705 
706 /*
707  * @dev Provides information about the current execution context, including the
708  * sender of the transaction and its data. While these are generally available
709  * via msg.sender and msg.data, they should not be accessed in such a direct
710  * manner, since when dealing with GSN meta-transactions the account sending and
711  * paying for execution may not be the actual sender (as far as an application
712  * is concerned).
713  *
714  * This contract is only required for intermediate, library-like contracts.
715  */
716 abstract contract Context {
717     function _msgSender() internal view virtual returns (address payable) {
718         return msg.sender;
719     }
720 
721     function _msgData() internal view virtual returns (bytes memory) {
722         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
723         return msg.data;
724     }
725 }
726 
727 // File: @openzeppelin\contracts\access\Ownable.sol
728 
729 pragma solidity ^0.6.0;
730 
731 /**
732  * @dev Contract module which provides a basic access control mechanism, where
733  * there is an account (an owner) that can be granted exclusive access to
734  * specific functions.
735  *
736  * By default, the owner account will be the one that deploys the contract. This
737  * can later be changed with {transferOwnership}.
738  *
739  * This module is used through inheritance. It will make available the modifier
740  * `onlyOwner`, which can be applied to your functions to restrict their use to
741  * the owner.
742  */
743 contract Ownable is Context {
744     address private _owner;
745 
746     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
747 
748     /**
749      * @dev Initializes the contract setting the deployer as the initial owner.
750      */
751     constructor () internal {
752         address msgSender = _msgSender();
753         _owner = msgSender;
754         emit OwnershipTransferred(address(0), msgSender);
755     }
756 
757     /**
758      * @dev Returns the address of the current owner.
759      */
760     function owner() public view returns (address) {
761         return _owner;
762     }
763 
764     /**
765      * @dev Throws if called by any account other than the owner.
766      */
767     modifier onlyOwner() {
768         require(_owner == _msgSender(), "Ownable: caller is not the owner");
769         _;
770     }
771 
772     /**
773      * @dev Leaves the contract without owner. It will not be possible to call
774      * `onlyOwner` functions anymore. Can only be called by the current owner.
775      *
776      * NOTE: Renouncing ownership will leave the contract without an owner,
777      * thereby removing any functionality that is only available to the owner.
778      */
779     function renounceOwnership() public virtual onlyOwner {
780         emit OwnershipTransferred(_owner, address(0));
781         _owner = address(0);
782     }
783 
784     /**
785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
786      * Can only be called by the current owner.
787      */
788     function transferOwnership(address newOwner) public virtual onlyOwner {
789         require(newOwner != address(0), "Ownable: new owner is the zero address");
790         emit OwnershipTransferred(_owner, newOwner);
791         _owner = newOwner;
792     }
793 }
794 
795 // File: contracts\SakeToken.sol
796 
797 pragma solidity 0.6.12;
798 
799 
800 
801 
802 
803 
804 // SakeToken with Governance.
805 contract SakeToken is Context, IERC20, Ownable {
806     using SafeMath for uint256;
807     using Address for address;
808 
809     mapping (address => uint256) private _balances;
810 
811     mapping (address => mapping (address => uint256)) private _allowances;
812 
813     uint256 private _totalSupply;
814 
815     string private _name = "SakeToken";
816     string private _symbol = "SAKE";
817     uint8 private _decimals = 18;
818 
819     /**
820      * @dev Returns the name of the token.
821      */
822     function name() public view returns (string memory) {
823         return _name;
824     }
825 
826     /**
827      * @dev Returns the symbol of the token, usually a shorter version of the
828      * name.
829      */
830     function symbol() public view returns (string memory) {
831         return _symbol;
832     }
833 
834     /**
835      * @dev Returns the number of decimals used to get its user representation.
836      * For example, if `decimals` equals `2`, a balance of `505` tokens should
837      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
838      *
839      * Tokens usually opt for a value of 18, imitating the relationship between
840      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
841      * called.
842      *
843      * NOTE: This information is only used for _display_ purposes: it in
844      * no way affects any of the arithmetic of the contract, including
845      * {IERC20-balanceOf} and {IERC20-transfer}.
846      */
847     function decimals() public view returns (uint8) {
848         return _decimals;
849     }
850 
851     /**
852      * @dev See {IERC20-totalSupply}.
853      */
854     function totalSupply() public view override returns (uint256) {
855         return _totalSupply;
856     }
857 
858     /**
859      * @dev See {IERC20-balanceOf}.
860      */
861     function balanceOf(address account) public view override returns (uint256) {
862         return _balances[account];
863     }
864 
865     /**
866      * @dev See {IERC20-transfer}.
867      *
868      * Requirements:
869      *
870      * - `recipient` cannot be the zero address.
871      * - the caller must have a balance of at least `amount`.
872      */
873     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
874         _transfer(_msgSender(), recipient, amount);
875         return true;
876     }
877 
878     /**
879      * @dev See {IERC20-allowance}.
880      */
881     function allowance(address owner, address spender) public view virtual override returns (uint256) {
882         return _allowances[owner][spender];
883     }
884 
885     /**
886      * @dev See {IERC20-approve}.
887      *
888      * Requirements:
889      *
890      * - `spender` cannot be the zero address.
891      */
892     function approve(address spender, uint256 amount) public virtual override returns (bool) {
893         _approve(_msgSender(), spender, amount);
894         return true;
895     }
896 
897     /**
898      * @dev See {IERC20-transferFrom}.
899      *
900      * Emits an {Approval} event indicating the updated allowance. This is not
901      * required by the EIP. See the note at the beginning of {ERC20};
902      *
903      * Requirements:
904      * - `sender` and `recipient` cannot be the zero address.
905      * - `sender` must have a balance of at least `amount`.
906      * - the caller must have allowance for ``sender``'s tokens of at least
907      * `amount`.
908      */
909     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
910         _transfer(sender, recipient, amount);
911         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
912         return true;
913     }
914 
915     /**
916      * @dev Atomically increases the allowance granted to `spender` by the caller.
917      *
918      * This is an alternative to {approve} that can be used as a mitigation for
919      * problems described in {IERC20-approve}.
920      *
921      * Emits an {Approval} event indicating the updated allowance.
922      *
923      * Requirements:
924      *
925      * - `spender` cannot be the zero address.
926      */
927     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
928         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
929         return true;
930     }
931 
932     /**
933      * @dev Atomically decreases the allowance granted to `spender` by the caller.
934      *
935      * This is an alternative to {approve} that can be used as a mitigation for
936      * problems described in {IERC20-approve}.
937      *
938      * Emits an {Approval} event indicating the updated allowance.
939      *
940      * Requirements:
941      *
942      * - `spender` cannot be the zero address.
943      * - `spender` must have allowance for the caller of at least
944      * `subtractedValue`.
945      */
946     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
947         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
948         return true;
949     }
950 
951     /**
952      * @dev Moves tokens `amount` from `sender` to `recipient`.
953      *
954      * This is internal function is equivalent to {transfer}, and can be used to
955      * e.g. implement automatic token fees, slashing mechanisms, etc.
956      *
957      * Emits a {Transfer} event.
958      *
959      * Requirements:
960      *
961      * - `sender` cannot be the zero address.
962      * - `recipient` cannot be the zero address.
963      * - `sender` must have a balance of at least `amount`.
964      */
965     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
966         require(sender != address(0), "ERC20: transfer from the zero address");
967         require(recipient != address(0), "ERC20: transfer to the zero address");
968 
969         _beforeTokenTransfer(sender, recipient, amount);
970 
971         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
972         _balances[recipient] = _balances[recipient].add(amount);
973         emit Transfer(sender, recipient, amount);
974 
975         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
976     }
977 
978     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
979      * the total supply.
980      *
981      * Emits a {Transfer} event with `from` set to the zero address.
982      *
983      * Requirements
984      *
985      * - `to` cannot be the zero address.
986      */
987     function _mint(address account, uint256 amount) internal virtual {
988         require(account != address(0), "ERC20: mint to the zero address");
989 
990         _beforeTokenTransfer(address(0), account, amount);
991 
992         _totalSupply = _totalSupply.add(amount);
993         _balances[account] = _balances[account].add(amount);
994         emit Transfer(address(0), account, amount);
995     }
996 
997     /**
998      * @dev Destroys `amount` tokens from `account`, reducing the
999      * total supply.
1000      *
1001      * Emits a {Transfer} event with `to` set to the zero address.
1002      *
1003      * Requirements
1004      *
1005      * - `account` cannot be the zero address.
1006      * - `account` must have at least `amount` tokens.
1007      */
1008     function _burn(address account, uint256 amount) internal virtual {
1009         require(account != address(0), "ERC20: burn from the zero address");
1010 
1011         _beforeTokenTransfer(account, address(0), amount);
1012 
1013         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1014         _totalSupply = _totalSupply.sub(amount);
1015         emit Transfer(account, address(0), amount);
1016     }
1017 
1018     /**
1019      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1020      *
1021      * This is internal function is equivalent to `approve`, and can be used to
1022      * e.g. set automatic allowances for certain subsystems, etc.
1023      *
1024      * Emits an {Approval} event.
1025      *
1026      * Requirements:
1027      *
1028      * - `owner` cannot be the zero address.
1029      * - `spender` cannot be the zero address.
1030      */
1031     function _approve(address owner, address spender, uint256 amount) internal virtual {
1032         require(owner != address(0), "ERC20: approve from the zero address");
1033         require(spender != address(0), "ERC20: approve to the zero address");
1034 
1035         _allowances[owner][spender] = amount;
1036         emit Approval(owner, spender, amount);
1037     }
1038 
1039     /**
1040      * @dev Sets {decimals} to a value other than the default one of 18.
1041      *
1042      * WARNING: This function should only be called from the constructor. Most
1043      * applications that interact with token contracts will not expect
1044      * {decimals} to ever change, and may work incorrectly if it does.
1045      */
1046     function _setupDecimals(uint8 decimals_) internal {
1047         _decimals = decimals_;
1048     }
1049 
1050     /**
1051      * @dev Hook that is called before any transfer of tokens. This includes
1052      * minting and burning.
1053      *
1054      * Calling conditions:
1055      *
1056      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1057      * will be to transferred to `to`.
1058      * - when `from` is zero, `amount` tokens will be minted for `to`.
1059      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1060      * - `from` and `to` are never both zero.
1061      *
1062      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1063      */
1064     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1065 
1066     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (SakeMaster).
1067     function mint(address _to, uint256 _amount) public onlyOwner {
1068         _mint(_to, _amount);
1069         _moveDelegates(address(0), _delegates[_to], _amount);
1070     }
1071 
1072     // Copied and modified from YAM code:
1073     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1074     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1075     // Which is copied and modified from COMPOUND:
1076     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1077 
1078     /// @notice A record of each accounts delegate
1079     mapping (address => address) internal _delegates;
1080 
1081     /// @notice A checkpoint for marking number of votes from a given block
1082     struct Checkpoint {
1083         uint32 fromBlock;
1084         uint256 votes;
1085     }
1086 
1087     /// @notice A record of votes checkpoints for each account, by index
1088     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1089 
1090     /// @notice The number of checkpoints for each account
1091     mapping (address => uint32) public numCheckpoints;
1092 
1093     /// @notice The EIP-712 typehash for the contract's domain
1094     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1095 
1096     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1097     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1098 
1099     /// @notice A record of states for signing / validating signatures
1100     mapping (address => uint) public nonces;
1101 
1102     /// @notice An event thats emitted when an account changes its delegate
1103     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1104 
1105     /// @notice An event thats emitted when a delegate account's vote balance changes
1106     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1107 
1108     /**
1109      * @notice Delegate votes from `msg.sender` to `delegatee`
1110      * @param delegator The address to get delegatee for
1111      */
1112     function delegates(address delegator)
1113         external
1114         view
1115         returns (address)
1116     {
1117         return _delegates[delegator];
1118     }
1119 
1120    /**
1121     * @notice Delegate votes from `msg.sender` to `delegatee`
1122     * @param delegatee The address to delegate votes to
1123     */
1124     function delegate(address delegatee) external {
1125         return _delegate(msg.sender, delegatee);
1126     }
1127 
1128     /**
1129      * @notice Delegates votes from signatory to `delegatee`
1130      * @param delegatee The address to delegate votes to
1131      * @param nonce The contract state required to match the signature
1132      * @param expiry The time at which to expire the signature
1133      * @param v The recovery byte of the signature
1134      * @param r Half of the ECDSA signature pair
1135      * @param s Half of the ECDSA signature pair
1136      */
1137     function delegateBySig(
1138         address delegatee,
1139         uint nonce,
1140         uint expiry,
1141         uint8 v,
1142         bytes32 r,
1143         bytes32 s
1144     )
1145         external
1146     {
1147         bytes32 domainSeparator = keccak256(
1148             abi.encode(
1149                 DOMAIN_TYPEHASH,
1150                 keccak256(bytes(name())),
1151                 getChainId(),
1152                 address(this)
1153             )
1154         );
1155 
1156         bytes32 structHash = keccak256(
1157             abi.encode(
1158                 DELEGATION_TYPEHASH,
1159                 delegatee,
1160                 nonce,
1161                 expiry
1162             )
1163         );
1164 
1165         bytes32 digest = keccak256(
1166             abi.encodePacked(
1167                 "\x19\x01",
1168                 domainSeparator,
1169                 structHash
1170             )
1171         );
1172 
1173         address signatory = ecrecover(digest, v, r, s);
1174         require(signatory != address(0), "SAKE::delegateBySig: invalid signature");
1175         require(nonce == nonces[signatory]++, "SAKE::delegateBySig: invalid nonce");
1176         require(now <= expiry, "SAKE::delegateBySig: signature expired");
1177         return _delegate(signatory, delegatee);
1178     }
1179 
1180     /**
1181      * @notice Gets the current votes balance for `account`
1182      * @param account The address to get votes balance
1183      * @return The number of current votes for `account`
1184      */
1185     function getCurrentVotes(address account)
1186         external
1187         view
1188         returns (uint256)
1189     {
1190         uint32 nCheckpoints = numCheckpoints[account];
1191         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1192     }
1193 
1194     /**
1195      * @notice Determine the prior number of votes for an account as of a block number
1196      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1197      * @param account The address of the account to check
1198      * @param blockNumber The block number to get the vote balance at
1199      * @return The number of votes the account had as of the given block
1200      */
1201     function getPriorVotes(address account, uint blockNumber)
1202         external
1203         view
1204         returns (uint256)
1205     {
1206         require(blockNumber < block.number, "SAKE::getPriorVotes: not yet determined");
1207 
1208         uint32 nCheckpoints = numCheckpoints[account];
1209         if (nCheckpoints == 0) {
1210             return 0;
1211         }
1212 
1213         // First check most recent balance
1214         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1215             return checkpoints[account][nCheckpoints - 1].votes;
1216         }
1217 
1218         // Next check implicit zero balance
1219         if (checkpoints[account][0].fromBlock > blockNumber) {
1220             return 0;
1221         }
1222 
1223         uint32 lower = 0;
1224         uint32 upper = nCheckpoints - 1;
1225         while (upper > lower) {
1226             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1227             Checkpoint memory cp = checkpoints[account][center];
1228             if (cp.fromBlock == blockNumber) {
1229                 return cp.votes;
1230             } else if (cp.fromBlock < blockNumber) {
1231                 lower = center;
1232             } else {
1233                 upper = center - 1;
1234             }
1235         }
1236         return checkpoints[account][lower].votes;
1237     }
1238 
1239     function _delegate(address delegator, address delegatee)
1240         internal
1241     {
1242         address currentDelegate = _delegates[delegator];
1243         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SAKEs (not scaled);
1244         _delegates[delegator] = delegatee;
1245 
1246         emit DelegateChanged(delegator, currentDelegate, delegatee);
1247 
1248         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1249     }
1250 
1251     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1252         if (srcRep != dstRep && amount > 0) {
1253             if (srcRep != address(0)) {
1254                 // decrease old representative
1255                 uint32 srcRepNum = numCheckpoints[srcRep];
1256                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1257                 uint256 srcRepNew = srcRepOld.sub(amount);
1258                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1259             }
1260 
1261             if (dstRep != address(0)) {
1262                 // increase new representative
1263                 uint32 dstRepNum = numCheckpoints[dstRep];
1264                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1265                 uint256 dstRepNew = dstRepOld.add(amount);
1266                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1267             }
1268         }
1269     }
1270 
1271     function _writeCheckpoint(
1272         address delegatee,
1273         uint32 nCheckpoints,
1274         uint256 oldVotes,
1275         uint256 newVotes
1276     )
1277         internal
1278     {
1279         uint32 blockNumber = safe32(block.number, "SAKE::_writeCheckpoint: block number exceeds 32 bits");
1280 
1281         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1282             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1283         } else {
1284             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1285             numCheckpoints[delegatee] = nCheckpoints + 1;
1286         }
1287 
1288         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1289     }
1290 
1291     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1292         require(n < 2**32, errorMessage);
1293         return uint32(n);
1294     }
1295 
1296     function getChainId() internal pure returns (uint) {
1297         uint256 chainId;
1298         assembly { chainId := chainid() }
1299         return chainId;
1300     }
1301 }
1302 
1303 // File: contracts\SakeMasterV2.sol
1304 
1305 pragma solidity 0.6.12;
1306 
1307 
1308 
1309 
1310 
1311 
1312 
1313 // SakeMaster is the master of Sake. He can make Sake and he is a fair guy.
1314 //
1315 // Note that it's ownable and the owner wields tremendous power. The ownership
1316 // will be transferred to a governance smart contract once SAKE is sufficiently
1317 // distributed and the community can show to govern itself.
1318 //
1319 // Have fun reading it. Hopefully it's bug-free. God bless.
1320 contract SakeMasterV2 is Ownable {
1321     using SafeMath for uint256;
1322     using SafeERC20 for IERC20;
1323 
1324     // Info of each user.
1325     struct UserInfo {
1326         uint256 amount; // How many LP tokens the user has provided.
1327         uint256 amountStoken; // How many S tokens the user has provided.
1328         uint256 amountLPtoken; // How many LP tokens the user has provided.
1329         uint256 pengdingSake; // record sake amount when user withdraw lp.
1330         uint256 rewardDebt; // Reward debt. See explanation below.
1331         uint256 lastWithdrawBlock; // user last withdraw time;
1332 
1333         //
1334         // We do some fancy math here. Basically, any point in time, the amount of SAKEs
1335         // entitled to a user but is pending to be distributed is:
1336         //
1337         //   pending reward = (user.amount * pool.accSakePerShare) - user.rewardDebt
1338         //
1339         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1340         //   1. The pool's `accSakePerShare` (and `lastRewardBlock`) gets updated.
1341         //   2. User receives the pending reward sent to his/her address.
1342         //   3. User's `amount` gets updated.
1343         //   4. User's `rewardDebt` gets updated.
1344     }
1345 
1346     // Info of each pool.
1347     struct PoolInfo {
1348         IERC20 lpToken; // Address of LP token contract.
1349         IERC20 sToken; // Address of S token contract.
1350         uint256 allocPoint; // How many allocation points assigned to this pool. SAKEs to distribute per block.
1351         uint256 lastRewardBlock; // Last block number that SAKEs distribution occurs.
1352         uint256 accSakePerShare; // Accumulated SAKEs per share, times 1e12. See below.
1353         uint256 multiplierSToken; // times 1e8;
1354         bool sakeLockSwitch; // true-have sake withdraw interval,default 1 months;false-no withdraw interval,but have sake withdraw fee,default 10%
1355     }
1356 
1357     // The SAKE TOKEN!
1358     SakeToken public sake;
1359     // sakeMaker address.
1360     address public sakeMaker;
1361     // admin address.
1362     address public admin;
1363     // receive sake fee address
1364     address public sakeFeeAddress;
1365     // Block number when trade mining speed up period ends.
1366     uint256 public tradeMiningSpeedUpEndBlock;
1367     // Block number when phase II yield farming period ends.
1368     uint256 public yieldFarmingIIEndBlock;
1369     // Block number when trade mining period ends.
1370     uint256 public tradeMiningEndBlock;
1371     // trade mining speed end block num,about 1 months.
1372     uint256 public tradeMiningSpeedUpEndBlockNum = 192000;
1373     // phase II yield farming end block num,about 6 months.
1374     uint256 public yieldFarmingIIEndBlockNum = 1152000;
1375     // trade mining end block num,about 12 months.
1376     uint256 public tradeMiningEndBlockNum = 2304000;
1377     // SAKE tokens created per block for phase II yield farming.
1378     uint256 public sakePerBlockYieldFarming = 5 * 10**18;
1379     // SAKE tokens created per block for trade mining.
1380     uint256 public sakePerBlockTradeMining = 10 * 10**18;
1381     // Bonus muliplier for trade mining.
1382     uint256 public constant BONUS_MULTIPLIER = 2;
1383     // withdraw block num interval,about 1 months.
1384     uint256 public withdrawInterval = 192000;
1385     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1386     uint256 public totalAllocPoint = 0;
1387     // The block number when SAKE mining starts.
1388     uint256 public startBlock;
1389     // The ratio of withdraw lp fee(default is 0%)
1390     uint8 public lpFeeRatio = 0;
1391     // The ratio of withdraw sake fee if no withdraw interval(default is 10%)
1392     uint8 public sakeFeeRatio = 10;
1393 
1394     // Info of each pool.
1395     PoolInfo[] public poolInfo;
1396     // Info of each user that stakes LP tokens and S tokens.
1397     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1398 
1399     event Deposit(address indexed user, uint256 indexed pid, uint256 amountLPtoken, uint256 amountStoken);
1400     event Withdraw(address indexed user, uint256 indexed pid, uint256 amountLPtoken);
1401     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amountLPtoken);
1402 
1403     constructor(
1404         SakeToken _sake,
1405         address _admin,
1406         address _sakeMaker,
1407         address _sakeFeeAddress,
1408         uint256 _startBlock
1409     ) public {
1410         sake = _sake;
1411         admin = _admin;
1412         sakeMaker = _sakeMaker;
1413         sakeFeeAddress = _sakeFeeAddress;
1414         startBlock = _startBlock;
1415         tradeMiningSpeedUpEndBlock = startBlock.add(tradeMiningSpeedUpEndBlockNum);
1416         yieldFarmingIIEndBlock = startBlock.add(yieldFarmingIIEndBlockNum);
1417         tradeMiningEndBlock = startBlock.add(tradeMiningEndBlockNum);
1418     }
1419 
1420     function poolLength() external view returns (uint256) {
1421         return poolInfo.length;
1422     }
1423 
1424     // XXX DO NOT add the same LP token more than once.
1425     function _checkValidity(IERC20 _lpToken, IERC20 _sToken) internal view {
1426         for (uint256 i = 0; i < poolInfo.length; i++) {
1427             require(poolInfo[i].lpToken != _lpToken && poolInfo[i].sToken != _sToken, "pool exist");
1428         }
1429     }
1430 
1431     // Add a new lp to the pool. Can only be called by the admin.
1432     function add(
1433         uint256 _allocPoint,
1434         uint256 _multiplierSToken,
1435         IERC20 _lpToken,
1436         IERC20 _sToken,
1437         bool _withUpdate
1438     ) public {
1439         require(msg.sender == admin, "add:Call must come from admin.");
1440         if (_withUpdate) {
1441             massUpdatePools();
1442         }
1443         _checkValidity(_lpToken, _sToken);
1444         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1445         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1446         poolInfo.push(
1447             PoolInfo({
1448                 lpToken: _lpToken,
1449                 sToken: _sToken,
1450                 allocPoint: _allocPoint,
1451                 multiplierSToken: _multiplierSToken,
1452                 lastRewardBlock: lastRewardBlock,
1453                 accSakePerShare: 0,
1454                 sakeLockSwitch: true
1455             })
1456         );
1457     }
1458 
1459     // Update the given pool's SAKE allocation point. Can only be called by the admin.
1460     function set(
1461         uint256 _pid,
1462         uint256 _allocPoint,
1463         bool _withUpdate
1464     ) public {
1465         require(msg.sender == admin, "set:Call must come from admin.");
1466         if (_withUpdate) {
1467             massUpdatePools();
1468         }
1469         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1470         poolInfo[_pid].allocPoint = _allocPoint;
1471     }
1472 
1473     function setMultiplierSToken(
1474         uint256 _pid,
1475         uint256 _multiplierSToken,
1476         bool _withUpdate
1477     ) public {
1478         require(msg.sender == admin, "sms:Call must come from admin.");
1479         if (_withUpdate) {
1480             massUpdatePools();
1481         }
1482         poolInfo[_pid].multiplierSToken = _multiplierSToken;
1483     }
1484 
1485     // set sake withdraw switch. Can only be called by the admin.
1486     function setSakeLockSwitch(
1487         uint256 _pid,
1488         bool _sakeLockSwitch,
1489         bool _withUpdate
1490     ) public {
1491         require(msg.sender == admin, "s:Call must come from admin.");
1492         if (_withUpdate) {
1493             massUpdatePools();
1494         }
1495         poolInfo[_pid].sakeLockSwitch = _sakeLockSwitch;
1496     }
1497 
1498     // Return reward multiplier over the given _from to _to block.
1499     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256 multipY, uint256 multipT) {
1500         uint256 _toFinalY = _to > yieldFarmingIIEndBlock ? yieldFarmingIIEndBlock : _to;
1501         uint256 _toFinalT = _to > tradeMiningEndBlock ? tradeMiningEndBlock : _to;
1502         // phase II yield farming multiplier
1503         if (_from >= yieldFarmingIIEndBlock) {
1504             multipY = 0;
1505         } else {
1506             multipY = _toFinalY.sub(_from);
1507         }
1508         // trade mining multiplier
1509         if (_from >= tradeMiningEndBlock) {
1510             multipT = 0;
1511         } else {
1512             if (_toFinalT <= tradeMiningSpeedUpEndBlock) {
1513                 multipT = _toFinalT.sub(_from).mul(BONUS_MULTIPLIER);
1514             } else {
1515                 if (_from < tradeMiningSpeedUpEndBlock) {
1516                     multipT = tradeMiningSpeedUpEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1517                         _toFinalT.sub(tradeMiningSpeedUpEndBlock)
1518                     );
1519                 } else {
1520                     multipT = _toFinalT.sub(_from);
1521                 }
1522             }
1523         }
1524     }
1525 
1526     function getSakePerBlock(uint256 blockNum) public view returns (uint256) {
1527         if (blockNum <= tradeMiningSpeedUpEndBlock) {
1528             return sakePerBlockYieldFarming.add(sakePerBlockTradeMining.mul(BONUS_MULTIPLIER));
1529         } else if (blockNum > tradeMiningSpeedUpEndBlock && blockNum <= yieldFarmingIIEndBlock) {
1530             return sakePerBlockYieldFarming.add(sakePerBlockTradeMining);
1531         } else if (blockNum > yieldFarmingIIEndBlock && blockNum <= tradeMiningEndBlock) {
1532             return sakePerBlockTradeMining;
1533         } else {
1534             return 0;
1535         }
1536     }
1537 
1538     // Handover the saketoken mintage right.
1539     function handoverSakeMintage(address newOwner) public onlyOwner {
1540         sake.transferOwnership(newOwner);
1541     }
1542 
1543     // View function to see pending SAKEs on frontend.
1544     function pendingSake(uint256 _pid, address _user) external view returns (uint256) {
1545         PoolInfo storage pool = poolInfo[_pid];
1546         UserInfo storage user = userInfo[_pid][_user];
1547         uint256 accSakePerShare = pool.accSakePerShare;
1548         uint256 lpTokenSupply = pool.lpToken.balanceOf(address(this));
1549         uint256 sTokenSupply = pool.sToken.balanceOf(address(this));
1550         if (block.number > pool.lastRewardBlock && lpTokenSupply != 0) {
1551             uint256 totalSupply = lpTokenSupply.add(sTokenSupply.mul(pool.multiplierSToken).div(1e8));
1552             (uint256 multipY, uint256 multipT) = getMultiplier(pool.lastRewardBlock, block.number);
1553             uint256 sakeRewardY = multipY.mul(sakePerBlockYieldFarming).mul(pool.allocPoint).div(totalAllocPoint);
1554             uint256 sakeRewardT = multipT.mul(sakePerBlockTradeMining).mul(pool.allocPoint).div(totalAllocPoint);
1555             uint256 sakeReward = sakeRewardY.add(sakeRewardT);
1556             accSakePerShare = accSakePerShare.add(sakeReward.mul(1e12).div(totalSupply));
1557         }
1558         return user.amount.mul(accSakePerShare).div(1e12).add(user.pengdingSake).sub(user.rewardDebt);
1559     }
1560 
1561     // Update reward vairables for all pools. Be careful of gas spending!
1562     function massUpdatePools() public {
1563         uint256 length = poolInfo.length;
1564         for (uint256 pid = 0; pid < length; ++pid) {
1565             updatePool(pid);
1566         }
1567     }
1568 
1569     // Update reward variables of the given pool to be up-to-date.
1570     function updatePool(uint256 _pid) public {
1571         PoolInfo storage pool = poolInfo[_pid];
1572         if (block.number <= pool.lastRewardBlock) {
1573             return;
1574         }
1575         uint256 lpTokenSupply = pool.lpToken.balanceOf(address(this));
1576         uint256 sTokenSupply = pool.sToken.balanceOf(address(this));
1577         if (lpTokenSupply == 0) {
1578             pool.lastRewardBlock = block.number;
1579             return;
1580         }
1581         (uint256 multipY, uint256 multipT) = getMultiplier(pool.lastRewardBlock, block.number);
1582         if (multipY == 0 && multipT == 0) {
1583             pool.lastRewardBlock = block.number;
1584             return;
1585         }
1586         uint256 sakeRewardY = multipY.mul(sakePerBlockYieldFarming).mul(pool.allocPoint).div(totalAllocPoint);
1587         uint256 sakeRewardT = multipT.mul(sakePerBlockTradeMining).mul(pool.allocPoint).div(totalAllocPoint);
1588         uint256 sakeReward = sakeRewardY.add(sakeRewardT);
1589         uint256 totalSupply = lpTokenSupply.add(sTokenSupply.mul(pool.multiplierSToken).div(1e8));
1590         if (sake.owner() == address(this)) {
1591             sake.mint(address(this), sakeRewardT);
1592         }
1593         pool.accSakePerShare = pool.accSakePerShare.add(sakeReward.mul(1e12).div(totalSupply));
1594         pool.lastRewardBlock = block.number;
1595     }
1596 
1597     // Deposit LP tokens to SakeMasterV2 for SAKE allocation.
1598     function deposit(
1599         uint256 _pid,
1600         uint256 _amountlpToken,
1601         uint256 _amountsToken
1602     ) public {
1603         PoolInfo storage pool = poolInfo[_pid];
1604         UserInfo storage user = userInfo[_pid][msg.sender];
1605         if (_amountlpToken <= 0 && user.pengdingSake == 0) {
1606             require(user.amountLPtoken > 0, "deposit:invalid");
1607         }
1608         updatePool(_pid);
1609         uint256 pending = user.amount.mul(pool.accSakePerShare).div(1e12).add(user.pengdingSake).sub(user.rewardDebt);
1610         uint256 _originAmountStoken = user.amountStoken;
1611         user.amountLPtoken = user.amountLPtoken.add(_amountlpToken);
1612         user.amountStoken = user.amountStoken.add(_amountsToken);
1613         user.amount = user.amount.add(_amountlpToken.add(_amountsToken.mul(pool.multiplierSToken).div(1e8)));
1614         user.pengdingSake = pending;
1615         if (pool.sakeLockSwitch) {
1616             if (block.number > (user.lastWithdrawBlock.add(withdrawInterval))) {
1617                 user.lastWithdrawBlock = block.number;
1618                 user.pengdingSake = 0;
1619                 user.amountStoken = _amountsToken;
1620                 user.amount = user.amountLPtoken.add(_amountsToken.mul(pool.multiplierSToken).div(1e8));
1621                 pool.sToken.safeTransfer(address(1), _originAmountStoken);
1622                 if (pending > 0) {
1623                     _safeSakeTransfer(msg.sender, pending);
1624                 }
1625             }
1626         } else {
1627             user.lastWithdrawBlock = block.number;
1628             user.pengdingSake = 0;
1629             if (_amountlpToken == 0 && _amountsToken == 0) {
1630                 user.amountStoken = 0;
1631                 user.amount = user.amountLPtoken;
1632                 pool.sToken.safeTransfer(address(1), _originAmountStoken);
1633             }
1634             if (pending > 0) {
1635                 uint256 sakeFee = pending.mul(sakeFeeRatio).div(100);
1636                 uint256 sakeToUser = pending.sub(sakeFee);
1637                 _safeSakeTransfer(msg.sender, sakeToUser);
1638                 _safeSakeTransfer(sakeFeeAddress, sakeFee);
1639             }
1640         }
1641         user.rewardDebt = user.amount.mul(pool.accSakePerShare).div(1e12);
1642         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amountlpToken);
1643         pool.sToken.safeTransferFrom(address(msg.sender), address(this), _amountsToken);
1644         emit Deposit(msg.sender, _pid, _amountlpToken, _amountsToken);
1645     }
1646 
1647     // Withdraw LP tokens from SakeMaster.
1648     function withdraw(uint256 _pid, uint256 _amountLPtoken) public {
1649         PoolInfo storage pool = poolInfo[_pid];
1650         UserInfo storage user = userInfo[_pid][msg.sender];
1651         require(user.amountLPtoken >= _amountLPtoken, "withdraw: LP amount not enough");
1652         updatePool(_pid);
1653         uint256 pending = user.amount.mul(pool.accSakePerShare).div(1e12).add(user.pengdingSake).sub(user.rewardDebt);
1654         user.amountLPtoken = user.amountLPtoken.sub(_amountLPtoken);
1655         uint256 _amountStoken = user.amountStoken;
1656         user.amountStoken = 0;
1657         user.amount = user.amountLPtoken;
1658         user.rewardDebt = user.amount.mul(pool.accSakePerShare).div(1e12);
1659         if (pool.sakeLockSwitch) {
1660             if (block.number > (user.lastWithdrawBlock.add(withdrawInterval))) {
1661                 user.lastWithdrawBlock = block.number;
1662                 user.pengdingSake = 0;
1663                 _safeSakeTransfer(msg.sender, pending);
1664             } else {
1665                 user.pengdingSake = pending;
1666             }
1667         } else {
1668             user.lastWithdrawBlock = block.number;
1669             user.pengdingSake = 0;
1670             uint256 sakeFee = pending.mul(sakeFeeRatio).div(100);
1671             uint256 sakeToUser = pending.sub(sakeFee);
1672             _safeSakeTransfer(msg.sender, sakeToUser);
1673             _safeSakeTransfer(sakeFeeAddress, sakeFee);
1674         }
1675         uint256 lpTokenFee;
1676         uint256 lpTokenToUser;
1677         if (block.number < tradeMiningEndBlock) {
1678             lpTokenFee = _amountLPtoken.mul(lpFeeRatio).div(100);
1679             pool.lpToken.safeTransfer(sakeMaker, lpTokenFee);
1680         }
1681         lpTokenToUser = _amountLPtoken.sub(lpTokenFee);
1682         pool.lpToken.safeTransfer(address(msg.sender), lpTokenToUser);
1683         pool.sToken.safeTransfer(address(1), _amountStoken);
1684         emit Withdraw(msg.sender, _pid, lpTokenToUser);
1685     }
1686 
1687     // Withdraw without caring about rewards. EMERGENCY ONLY.
1688     function emergencyWithdraw(uint256 _pid) public {
1689         PoolInfo storage pool = poolInfo[_pid];
1690         UserInfo storage user = userInfo[_pid][msg.sender];
1691         require(user.amountLPtoken > 0, "withdraw: LP amount not enough");
1692         uint256 _amountLPtoken = user.amountLPtoken;
1693         uint256 _amountStoken = user.amountStoken;
1694         user.amount = 0;
1695         user.amountLPtoken = 0;
1696         user.amountStoken = 0;
1697         user.rewardDebt = 0;
1698 
1699         uint256 lpTokenFee;
1700         uint256 lpTokenToUser;
1701         if (block.number < tradeMiningEndBlock) {
1702             lpTokenFee = _amountLPtoken.mul(lpFeeRatio).div(100);
1703             pool.lpToken.safeTransfer(sakeMaker, lpTokenFee);
1704         }
1705         lpTokenToUser = _amountLPtoken.sub(lpTokenFee);
1706         pool.lpToken.safeTransfer(address(msg.sender), lpTokenToUser);
1707         pool.sToken.safeTransfer(address(1), _amountStoken);
1708         emit EmergencyWithdraw(msg.sender, _pid, lpTokenToUser);
1709     }
1710 
1711     // Safe sake transfer function, just in case if rounding error causes pool to not have enough SAKEs.
1712     function _safeSakeTransfer(address _to, uint256 _amount) internal {
1713         uint256 sakeBal = sake.balanceOf(address(this));
1714         if (_amount > sakeBal) {
1715             sake.transfer(_to, sakeBal);
1716         } else {
1717             sake.transfer(_to, _amount);
1718         }
1719     }
1720 
1721     // Update admin address by owner.
1722     function setAdmin(address _adminaddr) public onlyOwner {
1723         require(_adminaddr != address(0), "invalid address");
1724         admin = _adminaddr;
1725     }
1726 
1727     // Update sakeMaker address by admin.
1728     function setSakeMaker(address _sakeMaker) public {
1729         require(msg.sender == admin, "sm:Call must come from admin.");
1730         require(_sakeMaker != address(0), "invalid address");
1731         sakeMaker = _sakeMaker;
1732     }
1733 
1734     // Update sakeFee address by admin.
1735     function setSakeFeeAddress(address _sakeFeeAddress) public {
1736         require(msg.sender == admin, "sf:Call must come from admin.");
1737         require(_sakeFeeAddress != address(0), "invalid address");
1738         sakeFeeAddress = _sakeFeeAddress;
1739     }
1740 
1741     // update tradeMiningSpeedUpEndBlock by owner
1742     function setTradeMiningSpeedUpEndBlock(uint256 _endBlock) public {
1743         require(msg.sender == admin, "tmsu:Call must come from admin.");
1744         require(_endBlock > startBlock, "invalid endBlock");
1745         tradeMiningSpeedUpEndBlock = _endBlock;
1746     }
1747 
1748     // update yieldFarmingIIEndBlock by owner
1749     function setYieldFarmingIIEndBlock(uint256 _endBlock) public {
1750         require(msg.sender == admin, "yf:Call must come from admin.");
1751         require(_endBlock > startBlock, "invalid endBlock");
1752         yieldFarmingIIEndBlock = _endBlock;
1753     }
1754 
1755     // update tradeMiningEndBlock by owner
1756     function setTradeMiningEndBlock(uint256 _endBlock) public {
1757         require(msg.sender == admin, "tm:Call must come from admin.");
1758         require(_endBlock > startBlock, "invalid endBlock");
1759         tradeMiningEndBlock = _endBlock;
1760     }
1761 
1762     function setSakeFeeRatio(uint8 newRatio) public {
1763         require(msg.sender == admin, "sfr:Call must come from admin.");
1764         require(newRatio >= 0 && newRatio <= 100, "invalid ratio");
1765         sakeFeeRatio = newRatio;
1766     }
1767 
1768     function setLpFeeRatio(uint8 newRatio) public {
1769         require(msg.sender == admin, "lp:Call must come from admin.");
1770         require(newRatio >= 0 && newRatio <= 100, "invalid ratio");
1771         lpFeeRatio = newRatio;
1772     }
1773 
1774     function setWithdrawInterval(uint256 _blockNum) public {
1775         require(msg.sender == admin, "i:Call must come from admin.");
1776         withdrawInterval = _blockNum;
1777     }
1778 
1779     // set sakePerBlock phase II yield farming
1780     function setSakePerBlockYieldFarming(uint256 _sakePerBlockYieldFarming, bool _withUpdate) public {
1781         require(msg.sender == admin, "yield:Call must come from admin.");
1782         if (_withUpdate) {
1783             massUpdatePools();
1784         }
1785         sakePerBlockYieldFarming = _sakePerBlockYieldFarming;
1786     }
1787 
1788     // set sakePerBlock trade mining
1789     function setSakePerBlockTradeMining(uint256 _sakePerBlockTradeMining, bool _withUpdate) public {
1790         require(msg.sender == admin, "trade:Call must come from admin.");
1791         if (_withUpdate) {
1792             massUpdatePools();
1793         }
1794         sakePerBlockTradeMining = _sakePerBlockTradeMining;
1795     }
1796 }