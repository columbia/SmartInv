1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: @openzeppelin/contracts/math/SafeMath.sol
80 
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
267         // This method relies in extcodesize, which returns 0 for contracts in
268         // construction, since the code is only stored at the end of the
269         // constructor execution.
270 
271         uint256 size;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { size := extcodesize(account) }
274         return size > 0;
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
383 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
384 
385 
386 pragma solidity ^0.6.0;
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
702 // File: @openzeppelin/contracts/GSN/Context.sol
703 
704 
705 pragma solidity ^0.6.0;
706 
707 /*
708  * @dev Provides information about the current execution context, including the
709  * sender of the transaction and its data. While these are generally available
710  * via msg.sender and msg.data, they should not be accessed in such a direct
711  * manner, since when dealing with GSN meta-transactions the account sending and
712  * paying for execution may not be the actual sender (as far as an application
713  * is concerned).
714  *
715  * This contract is only required for intermediate, library-like contracts.
716  */
717 abstract contract Context {
718     function _msgSender() internal view virtual returns (address payable) {
719         return msg.sender;
720     }
721 
722     function _msgData() internal view virtual returns (bytes memory) {
723         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
724         return msg.data;
725     }
726 }
727 
728 // File: @openzeppelin/contracts/access/Ownable.sol
729 
730 
731 pragma solidity ^0.6.0;
732 
733 /**
734  * @dev Contract module which provides a basic access control mechanism, where
735  * there is an account (an owner) that can be granted exclusive access to
736  * specific functions.
737  *
738  * By default, the owner account will be the one that deploys the contract. This
739  * can later be changed with {transferOwnership}.
740  *
741  * This module is used through inheritance. It will make available the modifier
742  * `onlyOwner`, which can be applied to your functions to restrict their use to
743  * the owner.
744  */
745 contract Ownable is Context {
746     address private _owner;
747 
748     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
749 
750     /**
751      * @dev Initializes the contract setting the deployer as the initial owner.
752      */
753     constructor () internal {
754         address msgSender = _msgSender();
755         _owner = msgSender;
756         emit OwnershipTransferred(address(0), msgSender);
757     }
758 
759     /**
760      * @dev Returns the address of the current owner.
761      */
762     function owner() public view returns (address) {
763         return _owner;
764     }
765 
766     /**
767      * @dev Throws if called by any account other than the owner.
768      */
769     modifier onlyOwner() {
770         require(_owner == _msgSender(), "Ownable: caller is not the owner");
771         _;
772     }
773 
774     /**
775      * @dev Leaves the contract without owner. It will not be possible to call
776      * `onlyOwner` functions anymore. Can only be called by the current owner.
777      *
778      * NOTE: Renouncing ownership will leave the contract without an owner,
779      * thereby removing any functionality that is only available to the owner.
780      */
781     function renounceOwnership() public virtual onlyOwner {
782         emit OwnershipTransferred(_owner, address(0));
783         _owner = address(0);
784     }
785 
786     /**
787      * @dev Transfers ownership of the contract to a new account (`newOwner`).
788      * Can only be called by the current owner.
789      */
790     function transferOwnership(address newOwner) public virtual onlyOwner {
791         require(newOwner != address(0), "Ownable: new owner is the zero address");
792         emit OwnershipTransferred(_owner, newOwner);
793         _owner = newOwner;
794     }
795 }
796 
797 // File: @openzeppelin/contracts/math/Math.sol
798 
799 
800 pragma solidity ^0.6.0;
801 
802 /**
803  * @dev Standard math utilities missing in the Solidity language.
804  */
805 library Math {
806     /**
807      * @dev Returns the largest of two numbers.
808      */
809     function max(uint256 a, uint256 b) internal pure returns (uint256) {
810         return a >= b ? a : b;
811     }
812 
813     /**
814      * @dev Returns the smallest of two numbers.
815      */
816     function min(uint256 a, uint256 b) internal pure returns (uint256) {
817         return a < b ? a : b;
818     }
819 
820     /**
821      * @dev Returns the average of two numbers. The result is rounded towards
822      * zero.
823      */
824     function average(uint256 a, uint256 b) internal pure returns (uint256) {
825         // (a + b) / 2 can overflow, so we distribute
826         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
827     }
828 }
829 
830 // File: contracts/ReentrancyGuardPausable.sol
831 
832 
833 pragma solidity ^0.6.0;
834 
835 
836 /**
837  * @dev Contract module that helps prevent reentrant calls to a function.
838  *
839  * Reuse openzeppelin's ReentrancyGuard with Pausable feature
840  */
841 contract ReentrancyGuardPausable {
842     // Booleans are more expensive than uint256 or any type that takes up a full
843     // word because each write operation emits an extra SLOAD to first read the
844     // slot's contents, replace the bits taken up by the boolean, and then write
845     // back. This is the compiler's defense against contract upgrades and
846     // pointer aliasing, and it cannot be disabled.
847 
848     // The values being non-zero value makes deployment a bit more expensive,
849     // but in exchange the refund on every call to nonReentrant will be lower in
850     // amount. Since refunds are capped to a percentage of the total
851     // transaction's gas, it is best to keep them low in cases like this one, to
852     // increase the likelihood of the full refund coming into effect.
853     uint256 private constant _NOT_ENTERED = 1;
854     uint256 private constant _ENTERED_OR_PAUSED = 2;
855 
856     uint256 private _status;
857 
858     constructor () internal {
859         _status = _NOT_ENTERED;
860     }
861 
862     /**
863      * @dev Prevents a contract from calling itself, directly or indirectly.
864      * Calling a `nonReentrant` function from another `nonReentrant`
865      * function is not supported. It is possible to prevent this from happening
866      * by making the `nonReentrant` function external, and make it call a
867      * `private` function that does the actual work.
868      */
869     modifier nonReentrantAndUnpaused() {
870         // On the first call to nonReentrant, _notEntered will be true
871         require(_status != _ENTERED_OR_PAUSED, "ReentrancyGuard: reentrant call or paused");
872 
873         // Any calls to nonReentrant after this point will fail
874         _status = _ENTERED_OR_PAUSED;
875 
876         _;
877 
878         // By storing the original value once again, a refund is triggered (see
879         // https://eips.ethereum.org/EIPS/eip-2200)
880         _status = _NOT_ENTERED;
881     }
882 
883     function _pause() internal {
884         _status = _ENTERED_OR_PAUSED;
885     }
886 
887     function _unpause() internal {
888         _status = _NOT_ENTERED;
889     }
890 }
891 
892 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
893 
894 
895 pragma solidity ^0.6.0;
896 
897 
898 /**
899  * @dev Implementation of the {IERC20} interface.
900  *
901  * This implementation is agnostic to the way tokens are created. This means
902  * that a supply mechanism has to be added in a derived contract using {_mint}.
903  * For a generic mechanism see {ERC20PresetMinterPauser}.
904  *
905  * TIP: For a detailed writeup see our guide
906  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
907  * to implement supply mechanisms].
908  *
909  * We have followed general OpenZeppelin guidelines: functions revert instead
910  * of returning `false` on failure. This behavior is nonetheless conventional
911  * and does not conflict with the expectations of ERC20 applications.
912  *
913  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
914  * This allows applications to reconstruct the allowance for all accounts just
915  * by listening to said events. Other implementations of the EIP may not emit
916  * these events, as it isn't required by the specification.
917  *
918  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
919  * functions have been added to mitigate the well-known issues around setting
920  * allowances. See {IERC20-approve}.
921  */
922 contract ERC20 is Context, IERC20 {
923     using SafeMath for uint256;
924     using Address for address;
925 
926     mapping (address => uint256) private _balances;
927 
928     mapping (address => mapping (address => uint256)) private _allowances;
929 
930     uint256 private _totalSupply;
931 
932     string private _name;
933     string private _symbol;
934     uint8 private _decimals;
935 
936     /**
937      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
938      * a default value of 18.
939      *
940      * To select a different value for {decimals}, use {_setupDecimals}.
941      *
942      * All three of these values are immutable: they can only be set once during
943      * construction.
944      */
945     constructor (string memory name, string memory symbol) public {
946         _name = name;
947         _symbol = symbol;
948         _decimals = 18;
949     }
950 
951     /**
952      * @dev Returns the name of the token.
953      */
954     function name() public view returns (string memory) {
955         return _name;
956     }
957 
958     /**
959      * @dev Returns the symbol of the token, usually a shorter version of the
960      * name.
961      */
962     function symbol() public view returns (string memory) {
963         return _symbol;
964     }
965 
966     /**
967      * @dev Returns the number of decimals used to get its user representation.
968      * For example, if `decimals` equals `2`, a balance of `505` tokens should
969      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
970      *
971      * Tokens usually opt for a value of 18, imitating the relationship between
972      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
973      * called.
974      *
975      * NOTE: This information is only used for _display_ purposes: it in
976      * no way affects any of the arithmetic of the contract, including
977      * {IERC20-balanceOf} and {IERC20-transfer}.
978      */
979     function decimals() public view returns (uint8) {
980         return _decimals;
981     }
982 
983     /**
984      * @dev See {IERC20-totalSupply}.
985      */
986     function totalSupply() public view override returns (uint256) {
987         return _totalSupply;
988     }
989 
990     /**
991      * @dev See {IERC20-balanceOf}.
992      */
993     function balanceOf(address account) public view override returns (uint256) {
994         return _balances[account];
995     }
996 
997     /**
998      * @dev See {IERC20-transfer}.
999      *
1000      * Requirements:
1001      *
1002      * - `recipient` cannot be the zero address.
1003      * - the caller must have a balance of at least `amount`.
1004      */
1005     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1006         _transfer(_msgSender(), recipient, amount);
1007         return true;
1008     }
1009 
1010     /**
1011      * @dev See {IERC20-allowance}.
1012      */
1013     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1014         return _allowances[owner][spender];
1015     }
1016 
1017     /**
1018      * @dev See {IERC20-approve}.
1019      *
1020      * Requirements:
1021      *
1022      * - `spender` cannot be the zero address.
1023      */
1024     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1025         _approve(_msgSender(), spender, amount);
1026         return true;
1027     }
1028 
1029     /**
1030      * @dev See {IERC20-transferFrom}.
1031      *
1032      * Emits an {Approval} event indicating the updated allowance. This is not
1033      * required by the EIP. See the note at the beginning of {ERC20};
1034      *
1035      * Requirements:
1036      * - `sender` and `recipient` cannot be the zero address.
1037      * - `sender` must have a balance of at least `amount`.
1038      * - the caller must have allowance for ``sender``'s tokens of at least
1039      * `amount`.
1040      */
1041     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1042         _transfer(sender, recipient, amount);
1043         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1044         return true;
1045     }
1046 
1047     /**
1048      * @dev Atomically increases the allowance granted to `spender` by the caller.
1049      *
1050      * This is an alternative to {approve} that can be used as a mitigation for
1051      * problems described in {IERC20-approve}.
1052      *
1053      * Emits an {Approval} event indicating the updated allowance.
1054      *
1055      * Requirements:
1056      *
1057      * - `spender` cannot be the zero address.
1058      */
1059     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1060         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1061         return true;
1062     }
1063 
1064     /**
1065      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1066      *
1067      * This is an alternative to {approve} that can be used as a mitigation for
1068      * problems described in {IERC20-approve}.
1069      *
1070      * Emits an {Approval} event indicating the updated allowance.
1071      *
1072      * Requirements:
1073      *
1074      * - `spender` cannot be the zero address.
1075      * - `spender` must have allowance for the caller of at least
1076      * `subtractedValue`.
1077      */
1078     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1079         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1080         return true;
1081     }
1082 
1083     /**
1084      * @dev Moves tokens `amount` from `sender` to `recipient`.
1085      *
1086      * This is internal function is equivalent to {transfer}, and can be used to
1087      * e.g. implement automatic token fees, slashing mechanisms, etc.
1088      *
1089      * Emits a {Transfer} event.
1090      *
1091      * Requirements:
1092      *
1093      * - `sender` cannot be the zero address.
1094      * - `recipient` cannot be the zero address.
1095      * - `sender` must have a balance of at least `amount`.
1096      */
1097     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1098         require(sender != address(0), "ERC20: transfer from the zero address");
1099         require(recipient != address(0), "ERC20: transfer to the zero address");
1100 
1101         _beforeTokenTransfer(sender, recipient, amount);
1102 
1103         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1104         _balances[recipient] = _balances[recipient].add(amount);
1105         emit Transfer(sender, recipient, amount);
1106     }
1107 
1108     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1109      * the total supply.
1110      *
1111      * Emits a {Transfer} event with `from` set to the zero address.
1112      *
1113      * Requirements
1114      *
1115      * - `to` cannot be the zero address.
1116      */
1117     function _mint(address account, uint256 amount) internal virtual {
1118         require(account != address(0), "ERC20: mint to the zero address");
1119 
1120         _beforeTokenTransfer(address(0), account, amount);
1121 
1122         _totalSupply = _totalSupply.add(amount);
1123         _balances[account] = _balances[account].add(amount);
1124         emit Transfer(address(0), account, amount);
1125     }
1126 
1127     /**
1128      * @dev Destroys `amount` tokens from `account`, reducing the
1129      * total supply.
1130      *
1131      * Emits a {Transfer} event with `to` set to the zero address.
1132      *
1133      * Requirements
1134      *
1135      * - `account` cannot be the zero address.
1136      * - `account` must have at least `amount` tokens.
1137      */
1138     function _burn(address account, uint256 amount) internal virtual {
1139         require(account != address(0), "ERC20: burn from the zero address");
1140 
1141         _beforeTokenTransfer(account, address(0), amount);
1142 
1143         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1144         _totalSupply = _totalSupply.sub(amount);
1145         emit Transfer(account, address(0), amount);
1146     }
1147 
1148     /**
1149      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1150      *
1151      * This internal function is equivalent to `approve`, and can be used to
1152      * e.g. set automatic allowances for certain subsystems, etc.
1153      *
1154      * Emits an {Approval} event.
1155      *
1156      * Requirements:
1157      *
1158      * - `owner` cannot be the zero address.
1159      * - `spender` cannot be the zero address.
1160      */
1161     function _approve(address owner, address spender, uint256 amount) internal virtual {
1162         require(owner != address(0), "ERC20: approve from the zero address");
1163         require(spender != address(0), "ERC20: approve to the zero address");
1164 
1165         _allowances[owner][spender] = amount;
1166         emit Approval(owner, spender, amount);
1167     }
1168 
1169     /**
1170      * @dev Sets {decimals} to a value other than the default one of 18.
1171      *
1172      * WARNING: This function should only be called from the constructor. Most
1173      * applications that interact with token contracts will not expect
1174      * {decimals} to ever change, and may work incorrectly if it does.
1175      */
1176     function _setupDecimals(uint8 decimals_) internal {
1177         _decimals = decimals_;
1178     }
1179 
1180     /**
1181      * @dev Hook that is called before any transfer of tokens. This includes
1182      * minting and burning.
1183      *
1184      * Calling conditions:
1185      *
1186      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1187      * will be to transferred to `to`.
1188      * - when `from` is zero, `amount` tokens will be minted for `to`.
1189      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1190      * - `from` and `to` are never both zero.
1191      *
1192      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1193      */
1194     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1195 }
1196 
1197 // File: contracts/EqualToken.sol
1198 
1199 pragma solidity 0.6.12;
1200 
1201 
1202 // EqualToken with Governance.
1203 contract EqualToken is ERC20("Equalizer", "EQL"), Ownable {
1204     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1205     function mint(address _to, uint256 _amount) public onlyOwner {
1206         _mint(_to, _amount);
1207         _moveDelegates(address(0), _delegates[_to], _amount);
1208     }
1209 
1210     function burn(uint256 _amount) public {
1211         _burn(msg.sender, _amount);
1212         _moveDelegates(_delegates[msg.sender], address(0), _amount);
1213     }
1214 
1215     // Copied and modified from YAM code:
1216     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1217     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1218     // Which is copied and modified from COMPOUND:
1219     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1220 
1221     /// @notice A record of each accounts delegate
1222     mapping (address => address) internal _delegates;
1223 
1224     /// @notice A checkpoint for marking number of votes from a given block
1225     struct Checkpoint {
1226         uint32 fromBlock;
1227         uint256 votes;
1228     }
1229 
1230     /// @notice A record of votes checkpoints for each account, by index
1231     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1232 
1233     /// @notice The number of checkpoints for each account
1234     mapping (address => uint32) public numCheckpoints;
1235 
1236     /// @notice The EIP-712 typehash for the contract's domain
1237     /* solium-disable-next-line  */
1238     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1239 
1240     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1241     /* solium-disable-next-line  */
1242     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1243 
1244     /// @notice A record of states for signing / validating signatures
1245     mapping (address => uint) public nonces;
1246 
1247       /// @notice An event thats emitted when an account changes its delegate
1248     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1249 
1250     /// @notice An event thats emitted when a delegate account's vote balance changes
1251     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1252 
1253     /**
1254      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1255      * @param dst The address of the destination account
1256      * @param amount The number of tokens to transfer
1257      * @return Whether or not the transfer succeeded
1258      */
1259     function transfer(address dst, uint256 amount) public override returns (bool) {
1260         bool success = super.transfer(dst, amount);
1261         if (success) {
1262             _moveDelegates(_delegates[msg.sender], _delegates[dst], amount);
1263         }
1264         return success;
1265     }
1266 
1267     /**
1268      * @notice Transfer `amount` tokens from `src` to `dst`
1269      * @param src The address of the source account
1270      * @param dst The address of the destination account
1271      * @param amount The number of tokens to transfer
1272      * @return Whether or not the transfer succeeded
1273      */
1274     function transferFrom(address src, address dst, uint256 amount) public override returns (bool) {
1275         bool success = super.transferFrom(src, dst, amount);
1276         if (success) {
1277             _moveDelegates(_delegates[src], _delegates[dst], amount);
1278         }
1279         return success;
1280     }
1281 
1282     /**
1283      * @notice Delegate votes from `msg.sender` to `delegatee`
1284      * @param delegator The address to get delegatee for
1285      */
1286     function delegates(address delegator)
1287         external
1288         view
1289         returns (address)
1290     {
1291         return _delegates[delegator];
1292     }
1293 
1294    /**
1295     * @notice Delegate votes from `msg.sender` to `delegatee`
1296     * @param delegatee The address to delegate votes to
1297     */
1298     function delegate(address delegatee) external {
1299         return _delegate(msg.sender, delegatee);
1300     }
1301 
1302     /**
1303      * @notice Delegates votes from signatory to `delegatee`
1304      * @param delegatee The address to delegate votes to
1305      * @param nonce The contract state required to match the signature
1306      * @param expiry The time at which to expire the signature
1307      * @param v The recovery byte of the signature
1308      * @param r Half of the ECDSA signature pair
1309      * @param s Half of the ECDSA signature pair
1310      */
1311     function delegateBySig(
1312         address delegatee,
1313         uint nonce,
1314         uint expiry,
1315         uint8 v,
1316         bytes32 r,
1317         bytes32 s
1318     )
1319         external
1320     {
1321         bytes32 domainSeparator = keccak256(
1322             abi.encode(
1323                 DOMAIN_TYPEHASH,
1324                 keccak256(bytes(name())),
1325                 getChainId(),
1326                 address(this)
1327             )
1328         );
1329 
1330         bytes32 structHash = keccak256(
1331             abi.encode(
1332                 DELEGATION_TYPEHASH,
1333                 delegatee,
1334                 nonce,
1335                 expiry
1336             )
1337         );
1338 
1339         bytes32 digest = keccak256(
1340             abi.encodePacked(
1341                 "\x19\x01",
1342                 domainSeparator,
1343                 structHash
1344             )
1345         );
1346 
1347         address signatory = ecrecover(digest, v, r, s);
1348         require(signatory != address(0), "Equal::delegateBySig: invalid signature");
1349         require(nonce == nonces[signatory]++, "Equal::delegateBySig: invalid nonce");
1350         require(now <= expiry, "Equal::delegateBySig: signature expired");
1351         return _delegate(signatory, delegatee);
1352     }
1353 
1354     /**
1355      * @notice Gets the current votes balance for `account`
1356      * @param account The address to get votes balance
1357      * @return The number of current votes for `account`
1358      */
1359     function getCurrentVotes(address account)
1360         external
1361         view
1362         returns (uint256)
1363     {
1364         uint32 nCheckpoints = numCheckpoints[account];
1365         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1366     }
1367 
1368     /**
1369      * @notice Determine the prior number of votes for an account as of a block number
1370      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1371      * @param account The address of the account to check
1372      * @param blockNumber The block number to get the vote balance at
1373      * @return The number of votes the account had as of the given block
1374      */
1375     function getPriorVotes(address account, uint blockNumber)
1376         external
1377         view
1378         returns (uint256)
1379     {
1380         require(blockNumber < block.number, "Equal::getPriorVotes: not yet determined");
1381 
1382         uint32 nCheckpoints = numCheckpoints[account];
1383         if (nCheckpoints == 0) {
1384             return 0;
1385         }
1386 
1387         // First check most recent balance
1388         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1389             return checkpoints[account][nCheckpoints - 1].votes;
1390         }
1391 
1392         // Next check implicit zero balance
1393         if (checkpoints[account][0].fromBlock > blockNumber) {
1394             return 0;
1395         }
1396 
1397         uint32 lower = 0;
1398         uint32 upper = nCheckpoints - 1;
1399         while (upper > lower) {
1400             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1401             Checkpoint memory cp = checkpoints[account][center];
1402             if (cp.fromBlock == blockNumber) {
1403                 return cp.votes;
1404             } else if (cp.fromBlock < blockNumber) {
1405                 lower = center;
1406             } else {
1407                 upper = center - 1;
1408             }
1409         }
1410         return checkpoints[account][lower].votes;
1411     }
1412 
1413     function _delegate(address delegator, address delegatee)
1414         internal
1415     {
1416         address currentDelegate = _delegates[delegator];
1417         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying Equal (not scaled);
1418         _delegates[delegator] = delegatee;
1419 
1420         emit DelegateChanged(delegator, currentDelegate, delegatee);
1421 
1422         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1423     }
1424 
1425     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1426         if (srcRep != dstRep && amount > 0) {
1427             if (srcRep != address(0)) {
1428                 // decrease old representative
1429                 uint32 srcRepNum = numCheckpoints[srcRep];
1430                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1431                 uint256 srcRepNew = srcRepOld.sub(amount);
1432                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1433             }
1434 
1435             if (dstRep != address(0)) {
1436                 // increase new representative
1437                 uint32 dstRepNum = numCheckpoints[dstRep];
1438                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1439                 uint256 dstRepNew = dstRepOld.add(amount);
1440                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1441             }
1442         }
1443     }
1444 
1445     function _writeCheckpoint(
1446         address delegatee,
1447         uint32 nCheckpoints,
1448         uint256 oldVotes,
1449         uint256 newVotes
1450     )
1451         internal
1452     {
1453         uint32 blockNumber = safe32(block.number, "Equal::_writeCheckpoint: block number exceeds 32 bits");
1454 
1455         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1456             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1457         } else {
1458             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1459             numCheckpoints[delegatee] = nCheckpoints + 1;
1460         }
1461 
1462         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1463     }
1464 
1465     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1466         require(n < 2**32, errorMessage);
1467         return uint32(n);
1468     }
1469 
1470     function getChainId() internal pure returns (uint) {
1471         uint256 chainId;
1472         /* solium-disable-next-line  */
1473         assembly { chainId := chainid() }
1474         return chainId;
1475     }
1476 }
1477 
1478 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
1479 
1480 pragma solidity >=0.5.0;
1481 
1482 interface IUniswapV2Pair {
1483     event Approval(address indexed owner, address indexed spender, uint value);
1484     event Transfer(address indexed from, address indexed to, uint value);
1485 
1486     function name() external pure returns (string memory);
1487     function symbol() external pure returns (string memory);
1488     function decimals() external pure returns (uint8);
1489     function totalSupply() external view returns (uint);
1490     function balanceOf(address owner) external view returns (uint);
1491     function allowance(address owner, address spender) external view returns (uint);
1492 
1493     function approve(address spender, uint value) external returns (bool);
1494     function transfer(address to, uint value) external returns (bool);
1495     function transferFrom(address from, address to, uint value) external returns (bool);
1496 
1497     function DOMAIN_SEPARATOR() external view returns (bytes32);
1498     function PERMIT_TYPEHASH() external pure returns (bytes32);
1499     function nonces(address owner) external view returns (uint);
1500 
1501     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1502 
1503     event Mint(address indexed sender, uint amount0, uint amount1);
1504     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1505     event Swap(
1506         address indexed sender,
1507         uint amount0In,
1508         uint amount1In,
1509         uint amount0Out,
1510         uint amount1Out,
1511         address indexed to
1512     );
1513     event Sync(uint112 reserve0, uint112 reserve1);
1514 
1515     function MINIMUM_LIQUIDITY() external pure returns (uint);
1516     function factory() external view returns (address);
1517     function token0() external view returns (address);
1518     function token1() external view returns (address);
1519     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1520     function price0CumulativeLast() external view returns (uint);
1521     function price1CumulativeLast() external view returns (uint);
1522     function kLast() external view returns (uint);
1523 
1524     function mint(address to) external returns (uint liquidity);
1525     function burn(address to) external returns (uint amount0, uint amount1);
1526     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1527     function skim(address to) external;
1528     function sync() external;
1529 
1530     function initialize(address, address) external;
1531 }
1532 
1533 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
1534 
1535 pragma solidity >=0.5.0;
1536 
1537 interface IUniswapV2Factory {
1538     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1539 
1540     // SMARTXXX: function feeTo() external view returns (address);
1541     // SMARTXXX: function feeToSetter() external view returns (address);
1542     function feeInfoSetter() external view returns (address);
1543 
1544     function getPair(address tokenA, address tokenB) external view returns (address pair);
1545     function allPairs(uint) external view returns (address pair);
1546     function allPairsLength() external view returns (uint);
1547 
1548     function createPair(address tokenA, address tokenB) external returns (address pair);
1549 
1550     // SMARTXXX: function setFeeTo(address) external;
1551     function setFeeInfo(address, uint32, uint32) external;
1552     // SMARTXXX: function setFeeToSetter(address) external;
1553     function setFeeInfoSetter(address) external;
1554 
1555     // SMARTXXX: fee info getter
1556     function getFeeInfo() external view returns (address, uint32, uint32);
1557 }
1558 
1559 // File: contracts/EqualBurner.sol
1560 
1561 pragma solidity 0.6.12;
1562 
1563 
1564 contract EqualBurner is Ownable {
1565 
1566     using SafeMath for uint256;
1567     using SafeERC20 for IERC20;
1568 
1569     address public equal;
1570     address public weth;
1571     address public master;
1572     IUniswapV2Factory public factory;
1573     bool public noFrontRun = false;
1574 
1575     constructor (address _equal, address _weth, address _master, IUniswapV2Factory _factory) public {
1576         equal = _equal;
1577         weth = _weth;
1578         master = _master;
1579         factory = _factory;
1580     }
1581 
1582     function setNoFrontRun(bool _noFrontRun) public onlyOwner {
1583         noFrontRun = _noFrontRun;
1584     }
1585 
1586     /*
1587      * @dev Convert the fee of trading-pair token0/token1 to EQUAL and
1588      * return the value.  The fee will be locked in the contract forever.
1589      */
1590     function burn(
1591         address _tokenA,
1592         address _tokenB
1593     )
1594         external
1595         returns (uint256 equalAmount)
1596     {
1597         if (noFrontRun) {
1598             // solium-disable-next-line
1599             require(msg.sender == tx.origin, "must burn from a user tx");
1600         }
1601 
1602         require(msg.sender == master, "only master can burn");
1603         (address token0, address token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA);
1604 
1605         IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(token0, token1));
1606         uint256 bal = pair.balanceOf(address(this));
1607         if (bal == 0) {
1608             return 0;
1609         }
1610         pair.transfer(address(pair), bal);
1611         uint256 amount0;
1612         uint256 amount1;
1613         (amount0, amount1) = pair.burn(address(this));
1614         uint256 wethAmount = 0;
1615         equalAmount = 0;
1616         if (token0 == address(equal)) {
1617             equalAmount = equalAmount.add(amount0);
1618         } else {
1619             wethAmount = wethAmount.add(_toWETH(token0, amount0));
1620         }
1621 
1622         if (token1 == address(equal)) {
1623             equalAmount = equalAmount.add(amount1);
1624         } else {
1625             wethAmount = wethAmount.add(_toWETH(token1, amount1));
1626         }
1627 
1628         equalAmount = equalAmount.add(_toEQUALFromWETH(wethAmount));
1629         EqualToken(equal).burn(equalAmount);
1630     }
1631 
1632     function _toWETH(address token, uint256 amountIn) internal returns (uint256) {
1633         if (token == weth) {
1634             IERC20(token).safeTransfer(factory.getPair(weth, address(equal)), amountIn);
1635             return amountIn;
1636         }
1637         IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(token, weth));
1638         if (address(pair) == address(0)) {
1639             return 0;
1640         }
1641         uint256 reserveIn;
1642         uint256 reserveOut;
1643         address token0 = pair.token0();
1644         {
1645         (uint reserve0, uint reserve1,) = pair.getReserves();
1646         (reserveIn, reserveOut) = token0 == token ? (reserve0, reserve1) : (reserve1, reserve0);
1647         }
1648         uint amountInWithFee = amountIn.mul(997);
1649         uint numerator = amountInWithFee.mul(reserveOut);
1650         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1651         uint amountOut = numerator / denominator;
1652         (uint amount0Out, uint amount1Out) = token0 == token ? (uint(0), amountOut) : (amountOut, uint(0));
1653         IERC20(token).safeTransfer(address(pair), amountIn);
1654         pair.swap(amount0Out, amount1Out, factory.getPair(weth, address(equal)), new bytes(0));
1655         return amountOut;
1656     }
1657 
1658     function _toEQUALFromWETH(uint256 amountIn) internal returns (uint256) {
1659         IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(weth, address(equal)));
1660         (uint reserve0, uint reserve1,) = pair.getReserves();
1661         address token0 = pair.token0();
1662         (uint reserveIn, uint reserveOut) = token0 == weth ? (reserve0, reserve1) : (reserve1, reserve0);
1663         uint amountInWithFee = amountIn.mul(997);
1664         uint numerator = amountInWithFee.mul(reserveOut);
1665         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1666         uint amountOut = numerator / denominator;
1667         (uint amount0Out, uint amount1Out) = token0 == weth ? (uint(0), amountOut) : (amountOut, uint(0));
1668         pair.swap(amount0Out, amount1Out, address(this), new bytes(0));
1669         return amountOut;
1670     }
1671 }
1672 
1673 // File: contracts/uniswapv2/libraries/SafeMath.sol
1674 
1675 pragma solidity =0.6.12;
1676 
1677 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
1678 
1679 library SafeMathUniswap {
1680     function add(uint x, uint y) internal pure returns (uint z) {
1681         require((z = x + y) >= x, 'ds-math-add-overflow');
1682     }
1683 
1684     function sub(uint x, uint y) internal pure returns (uint z) {
1685         require((z = x - y) <= x, 'ds-math-sub-underflow');
1686     }
1687 
1688     function mul(uint x, uint y) internal pure returns (uint z) {
1689         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
1690     }
1691 }
1692 
1693 // File: contracts/uniswapv2/libraries/UniswapV2Library.sol
1694 
1695 pragma solidity >=0.5.0;
1696 
1697 
1698 
1699 library UniswapV2Library {
1700     using SafeMathUniswap for uint;
1701 
1702     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1703     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1704         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1705         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1706         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1707     }
1708 
1709     // calculates the CREATE2 address for a pair without making any external calls
1710     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1711         (address token0, address token1) = sortTokens(tokenA, tokenB);
1712         pair = address(uint(keccak256(abi.encodePacked(
1713                 hex'ff',
1714                 factory,
1715                 keccak256(abi.encodePacked(token0, token1)),
1716                 hex'1c879dcd3af04306445addd2c308bd4d26010c7ca84c959c3564d4f6957ab20c' // init code hash
1717             ))));
1718     }
1719 
1720     // fetches and sorts the reserves for a pair
1721     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1722         (address token0,) = sortTokens(tokenA, tokenB);
1723         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1724         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1725     }
1726 
1727     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1728     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1729         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1730         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1731         amountB = amountA.mul(reserveB) / reserveA;
1732     }
1733 
1734     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1735     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
1736         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
1737         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1738         uint amountInWithFee = amountIn.mul(997);
1739         uint numerator = amountInWithFee.mul(reserveOut);
1740         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1741         amountOut = numerator / denominator;
1742     }
1743 
1744     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
1745     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
1746         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
1747         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1748         uint numerator = reserveIn.mul(amountOut).mul(1000);
1749         uint denominator = reserveOut.sub(amountOut).mul(997);
1750         amountIn = (numerator / denominator).add(1);
1751     }
1752 
1753     // performs chained getAmountOut calculations on any number of pairs
1754     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
1755         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1756         amounts = new uint[](path.length);
1757         amounts[0] = amountIn;
1758         for (uint i; i < path.length - 1; i++) {
1759             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
1760             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
1761         }
1762     }
1763 
1764     // performs chained getAmountIn calculations on any number of pairs
1765     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
1766         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1767         amounts = new uint[](path.length);
1768         amounts[amounts.length - 1] = amountOut;
1769         for (uint i = path.length - 1; i > 0; i--) {
1770             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
1771             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
1772         }
1773     }
1774 }
1775 
1776 // File: contracts/Equalizer.sol
1777 
1778 pragma solidity 0.6.12;
1779 
1780 
1781 // Note that it's ownable and the owner wields tremendous power. The ownership
1782 // will be transferred to a governance equal contract once EQUAL is sufficiently
1783 // distributed and the community can show to govern itself.
1784 //
1785 // Have fun reading it. Hopefully it's bug-free. God bless.
1786 contract Equalizer is ReentrancyGuardPausable, Ownable {
1787     using SafeMath for uint256;
1788     using SafeERC20 for IERC20;
1789     using SafeERC20 for EqualToken;
1790 
1791     // Info of each user.
1792     struct UserInfo {
1793         uint256 amount;     // How many LP tokens the user has provided.
1794         uint256 rewardDebt; // Reward debt. See explanation below.
1795         //
1796         // We do some fancy math here. Basically, any point in time, the amount of EQUALs
1797         // entitled to a user but is pending to be distributed is:
1798         //
1799         //   pending reward = (user.amount * pool.accEqualPerShare) - user.rewardDebt
1800         //
1801         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1802         //   1. The pool's `accEqualPerShare` (and `lastRewardBlock`) gets updated.
1803         //   2. User receives the pending reward sent to his/her address.
1804         //   3. User's `amount` gets updated.
1805         //   4. User's `rewardDebt` gets updated.
1806     }
1807 
1808     // Info of each pool.
1809     struct PoolInfo {
1810         IERC20 lpToken;           // Address of LP token contract.
1811         uint256 lastRewardBlock;  // Last block number that EQUALs distribution occurs.
1812         uint256 lastRewardRound;  // Last adjust round
1813         uint256 accEqualPerShare; // Accumulated EQUALs per share, times 1e12. See below.
1814         uint256 allocPointGain;   // Extra gain of the pool.
1815         mapping (uint256 => uint256) allocPoints; // roundNumber => allocPoint mapping via EQUAL burn
1816         mapping (address => UserInfo) userInfo; // Info of each user that stakes LP tokens.
1817     }
1818 
1819     // Allocation adjust round.
1820     struct AllocAdjustRound {
1821         uint256 allocPointDecayNumerator;
1822         uint256 totalAllocPoint;
1823         uint256 endBlock; // inclusive
1824     }
1825 
1826     // The EQUAL TOKEN!
1827     EqualToken public equal;
1828     // Dev address.
1829     address public devaddr;
1830     // EQUAL tokens created per block.
1831     uint256 public genesisEqualPerBlock;
1832     // The block number when EQUAL mining starts.
1833     uint256 public startBlock;
1834     // The number of blocks per weight adjust ment
1835     uint256 public allocAdjustBlocks;
1836     // All rounds of allocation
1837     AllocAdjustRound[] public rounds;
1838     // Mapping of trading-pair to pool info.
1839     mapping (address => mapping (address => PoolInfo)) public poolInfo;
1840     // The number of blocks per epoch.
1841     uint256 public blocksInGenesisEpoch;
1842     // Uniswap factory.
1843     IUniswapV2Factory public factory;
1844     address weth;
1845     // Burner that burns trading fee in the unit of EQUAL.
1846     EqualBurner burner;
1847     // Global alloc point decay numerator (denom is 1e12)
1848     uint256 public allocPointDecayNumerator;
1849     // Burn equal directly efficiency (denom is 1e12)
1850     uint256 public burnEqualEfficiency = 1e12;
1851 
1852     event Deposit(address indexed user, address indexed lpToken, uint256 amount);
1853     event Withdraw(address indexed user, address indexed lpToken, uint256 amount);
1854     event EmergencyWithdraw(address indexed user, address indexed lpToken, uint256 amount);
1855     event NewRound(uint256 number, uint256 prevTotalAllocPoint, uint256 endBlock);
1856     event Burn(address indexed initiator, address indexed lpToken, uint256 amount);
1857 
1858     constructor(
1859         EqualToken _equal,
1860         address _devaddr,
1861         uint256 _genesisEqualPerBlock,
1862         uint256 _startBlock,
1863         uint256 _blocksInGenesisEpoch,
1864         uint256 _allocAdjustBlocks,
1865         address _weth,
1866         IUniswapV2Factory _factory
1867     ) public {
1868         equal = _equal;
1869         devaddr = _devaddr;
1870         genesisEqualPerBlock = _genesisEqualPerBlock;
1871         startBlock = _startBlock;
1872         blocksInGenesisEpoch = _blocksInGenesisEpoch;
1873         allocAdjustBlocks = _allocAdjustBlocks;
1874 
1875         // We allow genesis round to setup alloc by owner.
1876         rounds.push(AllocAdjustRound({
1877             allocPointDecayNumerator: 0,
1878             totalAllocPoint: 0,
1879             endBlock: _startBlock - 1
1880         }));
1881         factory = _factory;
1882         weth = _weth;
1883     }
1884 
1885     function _getOrInitPool(address _tokenA, address _tokenB) internal returns (PoolInfo storage) {
1886         (address token0, address token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA);
1887         PoolInfo storage pool = poolInfo[token0][token1];
1888 
1889         if (pool.lpToken == IERC20(0x0)) {
1890             pool.lpToken = IERC20(factory.getPair(token0, token1));
1891             require(pool.lpToken != IERC20(0x0), "lp token not exist");
1892         }
1893         return pool;
1894     }
1895 
1896     function _getPool(address _tokenA, address _tokenB) internal view returns (PoolInfo storage) {
1897         PoolInfo storage pool = _getPoolSafe(_tokenA, _tokenB);
1898         require(pool.lpToken != IERC20(0x0), "lp token not exist");
1899         return pool;
1900     }
1901 
1902     function _getPoolSafe(address _tokenA, address _tokenB) internal view returns (PoolInfo storage) {
1903         (address token0, address token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA);
1904         PoolInfo storage pool = poolInfo[token0][token1];
1905         return pool;
1906     }
1907 
1908     function _setPoolGenesisAlloc(
1909         address _token0,
1910         address _token1,
1911         uint256 _allocPoint,
1912         uint256 _blockNumber
1913     )
1914         internal
1915     {
1916         require(_blockNumber < startBlock, "cannot change alloc after startBlock");
1917         PoolInfo storage pool = _getOrInitPool(_token0, _token1);
1918 
1919         rounds[0].totalAllocPoint = rounds[0].totalAllocPoint.sub(pool.allocPoints[0]).add(_allocPoint);
1920         pool.allocPoints[0] = _allocPoint;
1921     }
1922 
1923     /****************************************************
1924      * Owner's public methods
1925      ****************************************************/
1926     function setCorePairAllocPointMultiplier(uint256 _m) external onlyOwner {
1927         PoolInfo storage pool = _getOrInitPool(weth, address(equal));
1928         pool.allocPointGain = _m;
1929         // Will be applied to next trade fee calculation.
1930     }
1931 
1932     function setAllocAdjustBlocks(uint256 _blocks) external onlyOwner {
1933         allocAdjustBlocks = _blocks;
1934         // Will be applied to next round.
1935     }
1936 
1937     function setAllocPointDecayNumerator(uint256 _decay) external onlyOwner {
1938         require(_decay < 1e12, "decay must < 1.0");
1939         allocPointDecayNumerator = _decay;
1940         // Will be applied to next round.
1941     }
1942 
1943     function setPoolAllocPointGain(address _token0, address _token1, uint256 _gain) external onlyOwner {
1944         PoolInfo storage pool = _getOrInitPool(_token0, _token1);
1945         pool.allocPointGain = _gain;
1946         // Will be applied to next trade fee calculation.
1947     }
1948 
1949     // Setup pool allocation for genesis round.
1950     function setPoolGenesisAlloc(
1951         address _token0,
1952         address _token1,
1953         uint256 _allocPoint) external onlyOwner
1954     {
1955         _setPoolGenesisAlloc(_token0, _token1, _allocPoint, block.number);
1956     }
1957 
1958     // Setup burner that converts the trading fee to EQUAL.
1959     function setBurner(EqualBurner _burner) external onlyOwner {
1960         burner = _burner;
1961     }
1962 
1963     // Setup burn efficiency of equal directly.
1964     function setBurnEqualEfficiency(uint256 _eff) external onlyOwner {
1965         burnEqualEfficiency = _eff;
1966     }
1967 
1968     // Only applies to deposit/withdraw/burn, but not emergency withdraw.
1969     function pause() external onlyOwner {
1970         _pause();
1971     }
1972 
1973     function unpause() external onlyOwner {
1974         _unpause();
1975     }
1976 
1977     /*
1978      * Get the EQUAL block reward according to quasi-fixed-supply block distribution model,
1979      * where after each epoch, reward per block halves and # of blocks in the epoch doubles.
1980      */
1981     function getEqualBlockReward(uint256 _from, uint256 _to) public view returns (uint256) {
1982         if (_from > _to) {
1983             return 0;
1984         }
1985 
1986         uint256 blocksPerEpoch = blocksInGenesisEpoch;
1987         uint256 epochBegin = startBlock;
1988         uint256 epochEnd = epochBegin + blocksPerEpoch - 1;
1989         uint256 rewardPerBlock = genesisEqualPerBlock;
1990         uint256 totalRewards = 0;
1991         while (_to >= epochBegin) {
1992             uint256 left = Math.max(epochBegin, _from);
1993             uint256 right = Math.min(epochEnd, _to);
1994             if (right >= left) {
1995                 totalRewards += (right - left + 1) * rewardPerBlock;
1996             }
1997 
1998             rewardPerBlock = rewardPerBlock / 2;
1999             blocksPerEpoch = blocksPerEpoch * 2;
2000             epochBegin = epochEnd + 1;
2001             epochEnd = epochBegin + blocksPerEpoch - 1;
2002         }
2003         return totalRewards;
2004     }
2005 
2006     /*
2007      * Get the number of EQUAL reward of the pool with the blocks starting
2008      * from lastRewardBlock to _blockNumber.  If the number of rounds exceed _maxIter, it will stop
2009      * and return the corresponding rewards, and block and round visited.
2010      *
2011      * If the alloc point of some rounds of the pool is zero, it will automatically apply
2012      * exponential-moving-average (EMA) algorithm to evaulate the decayed alloc point.
2013      *
2014      * A couple of invariants we will maintain
2015      *
2016      * - rounds[rounds.length - 2].endBlock < block.Number <= rounds[rounds.length - 1].endBlock
2017      *   This is achieved by calling _updateRounds() for _updatePool().
2018      *
2019      * - rounds[lastRewardRound - 1].endBlock < lastRewardBlock <= rounds[lastRewardRound].endBlock
2020      *   This is achieved by updating lastRewardBlock and lastRewardRound atomically.
2021      *
2022      * - sum(pool.allocPoints[i] of all pools) <= rounds.totalAllocPoint[i] for all i
2023      *   This is achieved by EMA calculation in _getEqualReward() and _burnEqual().
2024      */
2025     function _getEqualReward(
2026         PoolInfo storage _pool,
2027         uint256 _maxIter,
2028         uint256 _blockNumber
2029     )
2030         internal
2031         view
2032         returns (uint256 equalReward, uint256 lastRewardBlock, uint256 lastRewardRound, bool updatePrevAllocPoint, uint256 prevAllocPoint)
2033     {
2034         equalReward = 0;
2035         lastRewardBlock = _pool.lastRewardBlock;
2036         lastRewardRound = _pool.lastRewardRound;
2037         updatePrevAllocPoint = false;
2038         // No need to set prevAllocPoint
2039 
2040         uint256 startRound = _pool.lastRewardRound;
2041         // If prevAllocPoint happens to be zero for the startRound, we will use decay * pprevAllocPoint,
2042         // which is still zero.
2043         uint256 pprevAllocPoint = 0;
2044         uint256 roundLen = rounds.length;
2045 
2046         for (uint256 round = startRound; round < roundLen; round++) {
2047             if (round == 0) {
2048                 continue;
2049             }
2050 
2051             uint256 endBlock = rounds[round].endBlock;
2052             if (endBlock > _blockNumber) {
2053                 endBlock = _blockNumber;
2054             }
2055 
2056             // If no EQUAL is burned in the round, then no EQUAL will be distributed.
2057             prevAllocPoint = 0;
2058             updatePrevAllocPoint = false;
2059             uint256 prevTotalAllocPoint = rounds[round - 1].totalAllocPoint;
2060             if (prevTotalAllocPoint != 0) {
2061                 if (round <= startRound + 1) {
2062                     prevAllocPoint = _pool.allocPoints[round - 1];
2063                 } // gas saving.  prevAllocPoint will be zero for  > startRound + 1.
2064 
2065                 // If prevAllocPoint is zero, use decayed allocPoint from previous previous round.
2066                 // Otherwise, the decayed allocPoint should be already counted (A1).
2067                 // For users that have not called _updatePool() for a while, to save gas,
2068                 // we allow some alloc points to be zero as long as the prev alloc point of
2069                 // last reward round is correct and stored so that they can be used by
2070                 // the next call of _getEqualReward().
2071                 // This means that the caller MUST update the previous alloc point
2072                 // otherwise assumption A1 will be broken.
2073                 if (prevAllocPoint == 0) {
2074                     prevAllocPoint = pprevAllocPoint.mul(rounds[round - 1].allocPointDecayNumerator).div(1e12);
2075                     updatePrevAllocPoint = true;
2076                 }
2077 
2078                 uint256 roundReward = getEqualBlockReward(lastRewardBlock + 1, endBlock)
2079                     .mul(prevAllocPoint)
2080                     .div(prevTotalAllocPoint);
2081                 equalReward = equalReward.add(roundReward);
2082 
2083                 // If round reward is < 1e12, will terminate all calculation and break.
2084                 // Note that round must > startRound to make sure the alloc point of startRound is applied.
2085                 // After startRound + 1, the rest rounds will only have the decayed alloc points.
2086                 // This means that the rest roundReward will <= current roundReward.
2087                 // Since the number is too small, all rewards are discarded to save gas.
2088                 if (roundReward < 1e12 && round >= startRound + 1 && round != roundLen - 1) {
2089                     lastRewardBlock = _blockNumber;
2090                     lastRewardRound = roundLen - 1;
2091                     updatePrevAllocPoint = false;  // set prev alloc of roundLen - 1 as 0
2092                     break;
2093                 }
2094             }
2095             lastRewardBlock = endBlock;
2096             lastRewardRound = round;
2097             pprevAllocPoint = prevAllocPoint;
2098 
2099             if (lastRewardBlock == _blockNumber || round.sub(startRound) >= _maxIter) {
2100                 break;
2101             }
2102         }
2103     }
2104 
2105     /*
2106      * Start a new round for new alloc points.  Will evaluate the totalAllocPoint using EMA.
2107      */
2108     function _startNewRound(
2109         uint256 _prevEndBlock,
2110         uint256 _blockNumber
2111     )
2112         internal
2113     {
2114         uint256 roundNumber = rounds.length - 1;
2115         uint256 prevTotalAllocPoint = rounds[roundNumber].totalAllocPoint;
2116         uint256 decay = allocPointDecayNumerator;
2117 
2118         AllocAdjustRound memory newRound = AllocAdjustRound({
2119             allocPointDecayNumerator: decay,
2120             totalAllocPoint: prevTotalAllocPoint.mul(decay).div(1e12),
2121             endBlock: Math.max(_prevEndBlock + allocAdjustBlocks, _blockNumber)
2122         });
2123         rounds.push(newRound);
2124         emit NewRound(roundNumber + 1, prevTotalAllocPoint, newRound.endBlock);
2125     }
2126 
2127     /* Check if a new round is needed to make sure the endBlock of last round >= _blockNumber */
2128     function _updateRounds(uint256 _blockNumber) internal {
2129         uint256 roundNumber = rounds.length - 1;
2130         if (rounds[roundNumber].endBlock < _blockNumber) {
2131             _startNewRound(rounds[roundNumber].endBlock, _blockNumber);
2132         }
2133     }
2134 
2135     /*
2136      * Convert burned EQUAL to alloc point of the current round.  It will automatically update the
2137      * pool to make sure the pool's alloc points are up-to-date so that we could correctly evaluate
2138      * current round alloc point based on EMA.
2139      */
2140     function _burnEqual(
2141         PoolInfo storage _pool,
2142         uint256 _amount,
2143         uint256 _blockNumber
2144     )
2145         internal
2146     {
2147         _updatePool(_pool, 255, _blockNumber);
2148 
2149         // Make sure allocPoint[roundNumber - 1] is valid, i.e., it is evaluated by EMA.
2150         require(_blockNumber == _pool.lastRewardBlock, "need to updatePool() manually");
2151 
2152         uint256 roundNumber = rounds.length - 1;
2153         uint256 num = _pool.allocPointGain.add(1e12);
2154 
2155         uint256 allocPoint = _pool.allocPoints[roundNumber];
2156         if (allocPoint == 0) {
2157             // First set, need to add decayed alloc point from previous round.
2158             allocPoint = _pool.allocPoints[roundNumber - 1]
2159                 .mul(rounds[roundNumber].allocPointDecayNumerator).div(1e12);
2160         }
2161         _pool.allocPoints[roundNumber] = allocPoint.add(_amount.mul(num).div(1e12));
2162         rounds[roundNumber].totalAllocPoint = rounds[roundNumber].totalAllocPoint.add(_amount.mul(num).div(1e12));
2163         emit Burn(msg.sender, address(_pool.lpToken), _amount);
2164     }
2165 
2166     // View function to see pending EQUALs on frontend.
2167     function _pendingEqual(
2168         address _token0,
2169         address _token1,
2170         address _user,
2171         uint256 _maxIter,
2172         uint256 _blockNumber
2173     )
2174         internal
2175         view
2176         returns (uint256)
2177     {
2178         PoolInfo storage pool = _getPool(_token0, _token1);
2179         UserInfo storage user = pool.userInfo[_user];
2180 
2181         uint256 accEqualPerShare = pool.accEqualPerShare;
2182         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2183         if (_blockNumber > pool.lastRewardBlock && lpSupply != 0) {
2184             (uint256 equalReward,,,,) = _getEqualReward(pool, _maxIter, _blockNumber);
2185             accEqualPerShare = accEqualPerShare.add(equalReward.mul(9e11).div(lpSupply));
2186         }
2187         return user.amount.mul(accEqualPerShare).div(1e12).sub(user.rewardDebt);
2188     }
2189 
2190     function pendingEqual(
2191         address _token0,
2192         address _token1,
2193         address _user,
2194         uint256 _maxIter
2195     )
2196         external
2197         view
2198         returns (uint256)
2199     {
2200         return _pendingEqual(_token0, _token1, _user, _maxIter, block.number);
2201     }
2202 
2203     function _updatePool(PoolInfo storage _pool, uint256 _maxIter, uint256 _blockNumber) internal {
2204         if (_blockNumber <= _pool.lastRewardBlock) {
2205             return;
2206         }
2207 
2208         _updateRounds(_blockNumber);
2209 
2210         uint256 equalReward;
2211         uint256 prevAllocPoint;
2212         bool updatePrevAllocPoint;
2213         (
2214             equalReward,
2215             _pool.lastRewardBlock,
2216             _pool.lastRewardRound,
2217             updatePrevAllocPoint,
2218             prevAllocPoint
2219         ) = _getEqualReward(_pool, _maxIter, _blockNumber);
2220         if (updatePrevAllocPoint) {
2221             _pool.allocPoints[_pool.lastRewardRound - 1] = prevAllocPoint;
2222         }
2223 
2224         uint256 lpSupply = _pool.lpToken.balanceOf(address(this));
2225         if (equalReward == 0 || lpSupply == 0) {
2226             return;
2227         }
2228 
2229         equal.mint(devaddr, equalReward.div(10));
2230         uint256 lpReward = equalReward.sub(equalReward.div(10));
2231         equal.mint(address(this), lpReward);
2232         _pool.accEqualPerShare = _pool.accEqualPerShare.add(lpReward.mul(1e12).div(lpSupply));
2233     }
2234 
2235     // Update reward variables of the given pool to be up-to-date.
2236     function updatePool(address _token0, address _token1, uint256 _maxIter) public nonReentrantAndUnpaused {
2237         PoolInfo storage pool = _getOrInitPool(_token0, _token1);
2238         _updatePool(pool, _maxIter, block.number);
2239     }
2240 
2241     // Deposit LP tokens to Equalizer for EQUAL allocation.
2242     function _deposit(
2243         address _token0,
2244         address _token1,
2245         uint256 _amount,
2246         address _to,
2247         bool _burnFee,
2248         uint256 _blockNumber
2249     )
2250         internal
2251     {
2252         PoolInfo storage pool = _getOrInitPool(_token0, _token1);
2253         UserInfo storage user = pool.userInfo[_to];
2254 
2255         // TODO: Optimize round iterations
2256         _updatePool(pool, 255, _blockNumber);
2257 
2258         if (_burnFee) {
2259             uint256 amount = burner.burn(
2260                 _token0,
2261                 _token1
2262             );
2263             _burnEqual(pool, amount, _blockNumber);
2264         }
2265 
2266         if (user.amount > 0) {
2267             uint256 pending = user.amount.mul(pool.accEqualPerShare).div(1e12).sub(user.rewardDebt);
2268             if (pending > 0) {
2269                 safeEqualTransfer(_to, pending);
2270             }
2271         }
2272 
2273         if (_amount > 0) {
2274             pool.lpToken.safeTransferFrom(msg.sender, address(this), _amount);
2275             user.amount = user.amount.add(_amount);
2276         }
2277         user.rewardDebt = user.amount.mul(pool.accEqualPerShare).div(1e12);
2278         emit Deposit(_to, address(pool.lpToken), _amount);
2279     }
2280 
2281     // Deposit LP tokens to Equalizer for EQUAL allocation.
2282     function depositTo(
2283         address _token0,
2284         address _token1,
2285         uint256 _amount,
2286         address _to,
2287         bool _burnFee
2288     )
2289         public
2290         nonReentrantAndUnpaused
2291     {
2292         _deposit(_token0, _token1, _amount, _to, _burnFee, block.number);
2293     }
2294 
2295     function deposit(
2296         address _token0,
2297         address _token1,
2298         uint256 _amount,
2299         bool _burnFee
2300     )
2301         public
2302         nonReentrantAndUnpaused
2303     {
2304         _deposit(_token0, _token1, _amount, msg.sender, _burnFee, block.number);
2305     }
2306 
2307     // Withdraw LP tokens from Master.
2308     function _withdraw(
2309         address _token0,
2310         address _token1,
2311         uint256 _amount,
2312         bool _burnFee,
2313         uint256 _blockNumber
2314     )
2315         internal
2316     {
2317         PoolInfo storage pool = _getOrInitPool(_token0, _token1);
2318         UserInfo storage user = pool.userInfo[msg.sender];
2319         require(user.amount >= _amount, "withdraw: not good");
2320 
2321         // TODO: Optimize round iterations
2322         _updatePool(pool, 255, _blockNumber);
2323 
2324         if (_burnFee) {
2325             uint256 amount = burner.burn(
2326                 _token0,
2327                 _token1
2328             );
2329             _burnEqual(pool, amount, _blockNumber);
2330         }
2331 
2332         uint256 pending = user.amount.mul(pool.accEqualPerShare).div(1e12).sub(user.rewardDebt);
2333         if (pending > 0) {
2334             safeEqualTransfer(msg.sender, pending);
2335         }
2336         if (_amount > 0) {
2337             user.amount = user.amount.sub(_amount);
2338             pool.lpToken.safeTransfer(address(msg.sender), _amount);
2339         }
2340         user.rewardDebt = user.amount.mul(pool.accEqualPerShare).div(1e12);
2341         emit Withdraw(msg.sender, address(pool.lpToken), _amount);
2342     }
2343 
2344     function withdraw(address _token0, address _token1, uint256 _amount, bool _burnFee) public nonReentrantAndUnpaused {
2345         _withdraw(_token0, _token1, _amount, _burnFee, block.number);
2346     }
2347 
2348     // Withdraw without caring about rewards. EMERGENCY ONLY.
2349     function emergencyWithdraw(address _token0, address _token1) public {
2350         PoolInfo storage pool = _getOrInitPool(_token0, _token1);
2351         UserInfo storage user = pool.userInfo[msg.sender];
2352         uint256 amount = user.amount;
2353         user.amount = 0;
2354         user.rewardDebt = 0;
2355         pool.lpToken.safeTransfer(address(msg.sender), amount);
2356         emit EmergencyWithdraw(msg.sender, address(pool.lpToken), amount);
2357     }
2358 
2359     // Safe equal transfer function, just in case if rounding error causes pool to not have enough EQUALs.
2360     function safeEqualTransfer(address _to, uint256 _amount) internal {
2361         uint256 equalBal = equal.balanceOf(address(this));
2362         if (_amount > equalBal) {
2363             equal.transfer(_to, equalBal);
2364         } else {
2365             equal.transfer(_to, _amount);
2366         }
2367     }
2368 
2369     // Update dev address by the previous dev.
2370     function dev(address _devaddr) public {
2371         require(msg.sender == devaddr, "dev: wut?");
2372         require(_devaddr != address(0x0), "_devaddr cannot be 0x0");
2373         devaddr = _devaddr;
2374     }
2375 
2376     /*
2377      * @dev Convert the tokens of the pair to EQUAL via ETH/EQUAL pair.
2378     *  Use burned EQUAL as alloc points.
2379      */
2380     function _buyBackAndBurn(
2381         address _tokenA,
2382         address _tokenB,
2383         uint256 _blockNumber
2384     )
2385         internal
2386     {
2387         // Convert to EQUAL via swap.
2388         uint256 amount = burner.burn(
2389             _tokenA,
2390             _tokenB
2391         );
2392 
2393         // Burn
2394         PoolInfo storage pool = _getOrInitPool(_tokenA, _tokenB);
2395         _burnEqual(pool, amount, _blockNumber);
2396     }
2397 
2398     function buyBackAndBurn(address _tokenA, address _tokenB) external nonReentrantAndUnpaused {
2399         _buyBackAndBurn(_tokenA, _tokenB, block.number);
2400     }
2401 
2402     function _burnEqualAsFee(
2403         address _token0,
2404         address _token1,
2405         uint256 _amount,
2406         uint256 _blockNumber
2407     )
2408         internal
2409     {
2410         equal.safeTransferFrom(msg.sender, address(this), _amount);
2411         equal.burn(_amount);
2412 
2413         PoolInfo storage pool = _getOrInitPool(_token0, _token1);
2414         _burnEqual(pool, _amount.mul(burnEqualEfficiency).div(1e12), _blockNumber);
2415     }
2416 
2417     function burnEqualAsFee(address _token0, address _token1, uint256 _amount) external nonReentrantAndUnpaused {
2418         _burnEqualAsFee(_token0, _token1, _amount, block.number);
2419     }
2420 
2421     function getLastRoundAllocPoint(
2422         address _token0,
2423         address _token1
2424     )
2425         public
2426         view
2427         returns (uint256 prevAllocPoint)
2428     {
2429         PoolInfo storage pool = _getPool(_token0, _token1);
2430 
2431         uint256 roundLen = rounds.length;
2432         uint256 startRound = pool.lastRewardRound;
2433 
2434         if (startRound == 0) {
2435             startRound = 1;
2436         }
2437 
2438         prevAllocPoint = 0;
2439         for (uint256 round = startRound; round < roundLen; round++) {
2440             if (pool.allocPoints[round - 1] != 0) {
2441                 prevAllocPoint = pool.allocPoints[round - 1];
2442             } else {
2443                 prevAllocPoint = prevAllocPoint.mul(rounds[round - 1].allocPointDecayNumerator).div(1e12);
2444             }
2445         }
2446     }
2447 
2448     /****************************************************
2449      * View only external methods (for display purpose)
2450      ****************************************************/
2451 
2452     function getCurrentRoundAllocPoint(
2453         address _token0,
2454         address _token1
2455     )
2456         public
2457         view
2458         returns (uint256 allocPoint)
2459     {
2460         PoolInfo storage pool = _getPool(_token0, _token1);
2461 
2462         uint256 roundLen = rounds.length;
2463         uint256 startRound = pool.lastRewardRound;
2464 
2465         if (startRound != 0) {
2466             allocPoint = pool.allocPoints[startRound - 1];
2467         }
2468         for (uint256 round = startRound; round < roundLen; round++) {
2469             if (pool.allocPoints[round] != 0) {
2470                 allocPoint = pool.allocPoints[round];
2471             } else {
2472                 allocPoint = allocPoint.mul(rounds[round].allocPointDecayNumerator).div(1e12);
2473             }
2474         }
2475     }
2476 
2477     function getRoundLengthAndLastEndBlock() external view returns (
2478         uint256 length,
2479         uint256 endBlock
2480     )
2481     {
2482         length = rounds.length;
2483         endBlock = rounds[length - 1].endBlock;
2484     }
2485 
2486     function getPoolAndUserInfo(address token0, address token1, address user) external view returns (
2487         uint256 lastAllocPoint,
2488         uint256 currentAllocPoint,
2489         uint256 userInfoAmount,
2490         uint256 pending,
2491         uint256 allocPointGain
2492     )
2493     {
2494         PoolInfo storage info = _getPoolSafe(token0, token1);
2495         if (info.lpToken != IERC20(0x0)) {
2496             lastAllocPoint = getLastRoundAllocPoint(token0, token1);
2497             currentAllocPoint = getCurrentRoundAllocPoint(token0, token1);
2498             userInfoAmount = info.userInfo[user].amount;
2499             pending = _pendingEqual(token0, token1, user, 255, block.number);
2500             allocPointGain = info.allocPointGain;
2501         }
2502     }
2503 
2504     function getAPY(address token0, address token1) external view returns (uint256) {
2505         PoolInfo storage pool = _getPoolSafe(token0, token1);
2506         if (pool.lpToken == IERC20(0x0)) {
2507             return 0;
2508         }
2509         if (token0 == weth || token1 == weth) {
2510             // token - eth pair
2511             address token = token0 == weth ? token1 : token0;
2512             (uint reserve0, uint reserve1) = UniswapV2Library.getReserves(address(factory), token, weth);
2513             if (reserve0 == 0 || reserve1 == 0) {
2514                 return 0;
2515             }
2516             uint256 totalSupply = pool.lpToken.totalSupply() == 0 ? 1 : pool.lpToken.totalSupply();
2517             // 1 lp token price
2518             uint256 totalEth = reserve1.mul(2 * 1e18).div(totalSupply);
2519             return _getTokenAPY(pool, totalEth, token0, token1);
2520         } else if (factory.getPair(token0, weth) != address(0x0) && factory.getPair(token1, weth) != address(0x0)) {
2521             // token0-token1 and have token0-eth eth-token1
2522             (uint256 reserve0, uint256 reserve1) = UniswapV2Library.getReserves(address(factory), token0, token1);
2523             if (reserve0 == 0 || reserve1 == 0) {
2524                 return 0;
2525             }
2526             uint256 totalSupply = pool.lpToken.totalSupply() == 0 ? 1 : pool.lpToken.totalSupply();
2527             // 1 lp token price
2528             // token0-eth
2529             (uint256 reToken, uint256 reEth) = UniswapV2Library.getReserves(address(factory), token0, weth);
2530             if (reToken == 0 || reEth == 0) {
2531                 return 0;
2532             }
2533             uint256 totalEth = UniswapV2Library.quote(reserve0.mul(1e18).div(totalSupply), reToken, reEth);
2534             // eth-token1
2535             (reToken, reEth) = UniswapV2Library.getReserves(address(factory), token1, weth);
2536             if (reToken == 0 || reEth == 0) {
2537                 return 0;
2538             }
2539             totalEth = totalEth.add(UniswapV2Library.quote(reserve1.mul(1e18).div(totalSupply), reToken, reEth));
2540             return _getTokenAPY(pool, totalEth, token0, token1);
2541         }
2542         return 0;
2543     }
2544 
2545     function _getTokenAPY(PoolInfo memory pool,uint256 stakeTotalEth, address token0, address token1)
2546         internal
2547         view
2548         returns (uint256)
2549     {
2550         if (stakeTotalEth == 0) {
2551             return 0;
2552         }
2553         // 1 lp token earned
2554         uint256 totalAllocPoint = rounds[rounds.length - 1].totalAllocPoint;
2555         uint256 blockEarned = totalAllocPoint == 0 ? 0 :
2556             getEqualBlockReward(block.number, block.number)
2557             .mul(1e18).mul(9).div(10)
2558             .mul(getLastRoundAllocPoint(token0, token1))
2559             .div(totalAllocPoint);
2560         uint256 lpSupply = Math.max(pool.lpToken.balanceOf(address(this)), 1);
2561         uint256 perTokenEarned = blockEarned.div(lpSupply);
2562         if (perTokenEarned == 0) {
2563             return 0;
2564         }
2565         (uint256 reEqual, uint256 reEqualETH) = UniswapV2Library.getReserves(address(factory), address(equal), weth);
2566         if (reEqual == 0 || reEqualETH == 0) {
2567             return 0;
2568         }
2569         uint256 earnedETH = UniswapV2Library.quote(perTokenEarned, reEqual, reEqualETH);
2570         // apy
2571         return earnedETH.mul(1e18).div(stakeTotalEth).mul(4 * 60 * 24 * 365);
2572     }
2573 
2574     function getUserInfoAmount(address _tokenA, address _tokenB) external view returns (uint256) {
2575         PoolInfo storage info = _getPoolSafe(_tokenA, _tokenB);
2576         if (info.lpToken != IERC20(0x0)) {
2577             return info.userInfo[msg.sender].amount;
2578         }
2579         return 0;
2580     }
2581 
2582     function getPool(address _tokenA, address _tokenB)
2583         external
2584         view
2585         returns (
2586             address lpToken,
2587             uint256 lastRewardBlock,
2588             uint256 lastRewardRound,
2589             uint256 accEqualPerShare,
2590             uint256 allocPointGain
2591         )
2592     {
2593         PoolInfo storage pool = _getPoolSafe(_tokenA, _tokenB);
2594         lpToken = address(pool.lpToken);
2595         lastRewardBlock = pool.lastRewardBlock;
2596         lastRewardRound = pool.lastRewardRound;
2597         accEqualPerShare = pool.accEqualPerShare;
2598         allocPointGain = pool.allocPointGain;
2599     }
2600 
2601     function getPoolAllocPoint(address _tokenA, address _tokenB, uint256 index)
2602         external
2603         view
2604         returns (uint256)
2605     {
2606         PoolInfo storage pool = _getPoolSafe(_tokenA, _tokenB);
2607         return pool.allocPoints[index];
2608     }
2609 
2610     function getPoolUserInfo(address _tokenA, address _tokenB, address _address)
2611         external
2612         view
2613         returns (uint256 amount, uint256 rewardDebt)
2614     {
2615         PoolInfo storage pool = _getPoolSafe(_tokenA, _tokenB);
2616         UserInfo memory userInfo = pool.userInfo[_address];
2617         amount = userInfo.amount;
2618         rewardDebt = userInfo.rewardDebt;
2619     }
2620 }