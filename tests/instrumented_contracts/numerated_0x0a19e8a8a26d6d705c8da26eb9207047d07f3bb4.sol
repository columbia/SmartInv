1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 // File: @openzeppelin/contracts/math/SafeMath.sol
78 pragma solidity ^0.6.0;
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 pragma solidity ^0.6.2;
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
260         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
261         // for accounts without code, i.e. `keccak256('')`
262         bytes32 codehash;
263         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { codehash := extcodehash(account) }
266         return (codehash != accountHash && codehash != 0x0);
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return _functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         return _functionCallWithValue(target, data, value, errorMessage);
349     }
350 
351     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
352         require(isContract(target), "Address: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 // solhint-disable-next-line no-inline-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
376 pragma solidity ^0.6.0;
377 /**
378  * @title SafeERC20
379  * @dev Wrappers around ERC20 operations that throw on failure (when the token
380  * contract returns false). Tokens that return no value (and instead revert or
381  * throw on failure) are also supported, non-reverting calls are assumed to be
382  * successful.
383  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
384  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
385  */
386 library SafeERC20 {
387     using SafeMath for uint256;
388     using Address for address;
389 
390     function safeTransfer(IERC20 token, address to, uint256 value) internal {
391         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
392     }
393 
394     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
395         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
396     }
397 
398     /**
399      * @dev Deprecated. This function has issues similar to the ones found in
400      * {IERC20-approve}, and its usage is discouraged.
401      *
402      * Whenever possible, use {safeIncreaseAllowance} and
403      * {safeDecreaseAllowance} instead.
404      */
405     function safeApprove(IERC20 token, address spender, uint256 value) internal {
406         // safeApprove should only be called when setting an initial allowance,
407         // or when resetting it to zero. To increase and decrease it, use
408         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
409         // solhint-disable-next-line max-line-length
410         require((value == 0) || (token.allowance(address(this), spender) == 0),
411             "SafeERC20: approve from non-zero to non-zero allowance"
412         );
413         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
414     }
415 
416     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
417         uint256 newAllowance = token.allowance(address(this), spender).add(value);
418         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
419     }
420 
421     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
422         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
423         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
424     }
425 
426     /**
427      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
428      * on the return value: the return value is optional (but if data is returned, it must not be false).
429      * @param token The token targeted by the call.
430      * @param data The call data (encoded using abi.encode or one of its variants).
431      */
432     function _callOptionalReturn(IERC20 token, bytes memory data) private {
433         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
434         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
435         // the target address contains contract code and also asserts for success in the low-level call.
436 
437         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
438         if (returndata.length > 0) { // Return data is optional
439             // solhint-disable-next-line max-line-length
440             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
441         }
442     }
443 }
444 
445 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
446 pragma solidity ^0.6.0;
447 
448 /**
449  * @dev Library for managing
450  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
451  * types.
452  *
453  * Sets have the following properties:
454  *
455  * - Elements are added, removed, and checked for existence in constant time
456  * (O(1)).
457  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
458  *
459  * ```
460  * contract Example {
461  *     // Add the library methods
462  *     using EnumerableSet for EnumerableSet.AddressSet;
463  *
464  *     // Declare a set state variable
465  *     EnumerableSet.AddressSet private mySet;
466  * }
467  * ```
468  *
469  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
470  * (`UintSet`) are supported.
471  */
472 library EnumerableSet {
473     // To implement this library for multiple types with as little code
474     // repetition as possible, we write it in terms of a generic Set type with
475     // bytes32 values.
476     // The Set implementation uses private functions, and user-facing
477     // implementations (such as AddressSet) are just wrappers around the
478     // underlying Set.
479     // This means that we can only create new EnumerableSets for types that fit
480     // in bytes32.
481 
482     struct Set {
483         // Storage of set values
484         bytes32[] _values;
485 
486         // Position of the value in the `values` array, plus 1 because index 0
487         // means a value is not in the set.
488         mapping (bytes32 => uint256) _indexes;
489     }
490 
491     /**
492      * @dev Add a value to a set. O(1).
493      *
494      * Returns true if the value was added to the set, that is if it was not
495      * already present.
496      */
497     function _add(Set storage set, bytes32 value) private returns (bool) {
498         if (!_contains(set, value)) {
499             set._values.push(value);
500             // The value is stored at length-1, but we add 1 to all indexes
501             // and use 0 as a sentinel value
502             set._indexes[value] = set._values.length;
503             return true;
504         } else {
505             return false;
506         }
507     }
508 
509     /**
510      * @dev Removes a value from a set. O(1).
511      *
512      * Returns true if the value was removed from the set, that is if it was
513      * present.
514      */
515     function _remove(Set storage set, bytes32 value) private returns (bool) {
516         // We read and store the value's index to prevent multiple reads from the same storage slot
517         uint256 valueIndex = set._indexes[value];
518 
519         if (valueIndex != 0) { // Equivalent to contains(set, value)
520             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
521             // the array, and then remove the last element (sometimes called as 'swap and pop').
522             // This modifies the order of the array, as noted in {at}.
523 
524             uint256 toDeleteIndex = valueIndex - 1;
525             uint256 lastIndex = set._values.length - 1;
526 
527             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
528             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
529 
530             bytes32 lastvalue = set._values[lastIndex];
531 
532             // Move the last value to the index where the value to delete is
533             set._values[toDeleteIndex] = lastvalue;
534             // Update the index for the moved value
535             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
536 
537             // Delete the slot where the moved value was stored
538             set._values.pop();
539 
540             // Delete the index for the deleted slot
541             delete set._indexes[value];
542 
543             return true;
544         } else {
545             return false;
546         }
547     }
548 
549     /**
550      * @dev Returns true if the value is in the set. O(1).
551      */
552     function _contains(Set storage set, bytes32 value) private view returns (bool) {
553         return set._indexes[value] != 0;
554     }
555 
556     /**
557      * @dev Returns the number of values on the set. O(1).
558      */
559     function _length(Set storage set) private view returns (uint256) {
560         return set._values.length;
561     }
562 
563     /**
564      * @dev Returns the value stored at position `index` in the set. O(1).
565      *
566      * Note that there are no guarantees on the ordering of values inside the
567      * array, and it may change when more values are added or removed.
568      *
569      * Requirements:
570      *
571      * - `index` must be strictly less than {length}.
572      */
573     function _at(Set storage set, uint256 index) private view returns (bytes32) {
574         require(set._values.length > index, "EnumerableSet: index out of bounds");
575         return set._values[index];
576     }
577 
578     // AddressSet
579 
580     struct AddressSet {
581         Set _inner;
582     }
583 
584     /**
585      * @dev Add a value to a set. O(1).
586      *
587      * Returns true if the value was added to the set, that is if it was not
588      * already present.
589      */
590     function add(AddressSet storage set, address value) internal returns (bool) {
591         return _add(set._inner, bytes32(uint256(value)));
592     }
593 
594     /**
595      * @dev Removes a value from a set. O(1).
596      *
597      * Returns true if the value was removed from the set, that is if it was
598      * present.
599      */
600     function remove(AddressSet storage set, address value) internal returns (bool) {
601         return _remove(set._inner, bytes32(uint256(value)));
602     }
603 
604     /**
605      * @dev Returns true if the value is in the set. O(1).
606      */
607     function contains(AddressSet storage set, address value) internal view returns (bool) {
608         return _contains(set._inner, bytes32(uint256(value)));
609     }
610 
611     /**
612      * @dev Returns the number of values in the set. O(1).
613      */
614     function length(AddressSet storage set) internal view returns (uint256) {
615         return _length(set._inner);
616     }
617 
618     /**
619      * @dev Returns the value stored at position `index` in the set. O(1).
620      *
621      * Note that there are no guarantees on the ordering of values inside the
622      * array, and it may change when more values are added or removed.
623      *
624      * Requirements:
625      *
626      * - `index` must be strictly less than {length}.
627      */
628     function at(AddressSet storage set, uint256 index) internal view returns (address) {
629         return address(uint256(_at(set._inner, index)));
630     }
631 
632 
633     // UintSet
634 
635     struct UintSet {
636         Set _inner;
637     }
638 
639     /**
640      * @dev Add a value to a set. O(1).
641      *
642      * Returns true if the value was added to the set, that is if it was not
643      * already present.
644      */
645     function add(UintSet storage set, uint256 value) internal returns (bool) {
646         return _add(set._inner, bytes32(value));
647     }
648 
649     /**
650      * @dev Removes a value from a set. O(1).
651      *
652      * Returns true if the value was removed from the set, that is if it was
653      * present.
654      */
655     function remove(UintSet storage set, uint256 value) internal returns (bool) {
656         return _remove(set._inner, bytes32(value));
657     }
658 
659     /**
660      * @dev Returns true if the value is in the set. O(1).
661      */
662     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
663         return _contains(set._inner, bytes32(value));
664     }
665 
666     /**
667      * @dev Returns the number of values on the set. O(1).
668      */
669     function length(UintSet storage set) internal view returns (uint256) {
670         return _length(set._inner);
671     }
672 
673     /**
674      * @dev Returns the value stored at position `index` in the set. O(1).
675      *
676      * Note that there are no guarantees on the ordering of values inside the
677      * array, and it may change when more values are added or removed.
678      *
679      * Requirements:
680      *
681      * - `index` must be strictly less than {length}.
682      */
683     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
684         return uint256(_at(set._inner, index));
685     }
686 }
687 
688 // File: @openzeppelin/contracts/GSN/Context.sol
689 
690 pragma solidity ^0.6.0;
691 /*
692  * @dev Provides information about the current execution context, including the
693  * sender of the transaction and its data. While these are generally available
694  * via msg.sender and msg.data, they should not be accessed in such a direct
695  * manner, since when dealing with GSN meta-transactions the account sending and
696  * paying for execution may not be the actual sender (as far as an application
697  * is concerned).
698  *
699  * This contract is only required for intermediate, library-like contracts.
700  */
701 abstract contract Context {
702     function _msgSender() internal view virtual returns (address payable) {
703         return msg.sender;
704     }
705 
706     function _msgData() internal view virtual returns (bytes memory) {
707         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
708         return msg.data;
709     }
710 }
711 
712 // File: @openzeppelin/contracts/access/Ownable.sol
713 
714 
715 
716 pragma solidity ^0.6.0;
717 
718 /**
719  * @dev Contract module which provides a basic access control mechanism, where
720  * there is an account (an owner) that can be granted exclusive access to
721  * specific functions.
722  *
723  * By default, the owner account will be the one that deploys the contract. This
724  * can later be changed with {transferOwnership}.
725  *
726  * This module is used through inheritance. It will make available the modifier
727  * `onlyOwner`, which can be applied to your functions to restrict their use to
728  * the owner.
729  */
730 contract Ownable is Context {
731     address private _owner;
732 
733     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
734 
735     /**
736      * @dev Initializes the contract setting the deployer as the initial owner.
737      */
738     constructor () internal {
739         address msgSender = _msgSender();
740         _owner = msgSender;
741         emit OwnershipTransferred(address(0), msgSender);
742     }
743 
744     /**
745      * @dev Returns the address of the current owner.
746      */
747     function owner() public view returns (address) {
748         return _owner;
749     }
750 
751     /**
752      * @dev Throws if called by any account other than the owner.
753      */
754     modifier onlyOwner() {
755         require(_owner == _msgSender(), "Ownable: caller is not the owner");
756         _;
757     }
758 
759     /**
760      * @dev Leaves the contract without owner. It will not be possible to call
761      * `onlyOwner` functions anymore. Can only be called by the current owner.
762      *
763      * NOTE: Renouncing ownership will leave the contract without an owner,
764      * thereby removing any functionality that is only available to the owner.
765      */
766     function renounceOwnership() public virtual onlyOwner {
767         emit OwnershipTransferred(_owner, address(0));
768         _owner = address(0);
769     }
770 
771     /**
772      * @dev Transfers ownership of the contract to a new account (`newOwner`).
773      * Can only be called by the current owner.
774      */
775     function transferOwnership(address newOwner) public virtual onlyOwner {
776         require(newOwner != address(0), "Ownable: new owner is the zero address");
777         emit OwnershipTransferred(_owner, newOwner);
778         _owner = newOwner;
779     }
780 }
781 
782 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
783 
784 pragma solidity ^0.6.0;
785 
786 /**
787  * @dev Implementation of the {IERC20} interface.
788  *
789  * This implementation is agnostic to the way tokens are created. This means
790  * that a supply mechanism has to be added in a derived contract using {_mint}.
791  * For a generic mechanism see {ERC20PresetMinterPauser}.
792  *
793  * TIP: For a detailed writeup see our guide
794  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
795  * to implement supply mechanisms].
796  *
797  * We have followed general OpenZeppelin guidelines: functions revert instead
798  * of returning `false` on failure. This behavior is nonetheless conventional
799  * and does not conflict with the expectations of ERC20 applications.
800  *
801  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
802  * This allows applications to reconstruct the allowance for all accounts just
803  * by listening to said events. Other implementations of the EIP may not emit
804  * these events, as it isn't required by the specification.
805  *
806  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
807  * functions have been added to mitigate the well-known issues around setting
808  * allowances. See {IERC20-approve}.
809  */
810 contract ERC20 is Context, IERC20 {
811     using SafeMath for uint256;
812     using Address for address;
813 
814     mapping (address => uint256) private _balances;
815 
816     mapping (address => mapping (address => uint256)) private _allowances;
817 
818     uint256 private _totalSupply;
819 
820     string private _name;
821     string private _symbol;
822     uint8 private _decimals;
823 
824     /**
825      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
826      * a default value of 18.
827      *
828      * To select a different value for {decimals}, use {_setupDecimals}.
829      *
830      * All three of these values are immutable: they can only be set once during
831      * construction.
832      */
833     constructor (string memory name, string memory symbol) public {
834         _name = name;
835         _symbol = symbol;
836         _decimals = 18;
837     }
838 
839     /**
840      * @dev Returns the name of the token.
841      */
842     function name() public view returns (string memory) {
843         return _name;
844     }
845 
846     /**
847      * @dev Returns the symbol of the token, usually a shorter version of the
848      * name.
849      */
850     function symbol() public view returns (string memory) {
851         return _symbol;
852     }
853 
854     /**
855      * @dev Returns the number of decimals used to get its user representation.
856      * For example, if `decimals` equals `2`, a balance of `505` tokens should
857      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
858      *
859      * Tokens usually opt for a value of 18, imitating the relationship between
860      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
861      * called.
862      *
863      * NOTE: This information is only used for _display_ purposes: it in
864      * no way affects any of the arithmetic of the contract, including
865      * {IERC20-balanceOf} and {IERC20-transfer}.
866      */
867     function decimals() public view returns (uint8) {
868         return _decimals;
869     }
870 
871     /**
872      * @dev See {IERC20-totalSupply}.
873      */
874     function totalSupply() public view override returns (uint256) {
875         return _totalSupply;
876     }
877 
878     /**
879      * @dev See {IERC20-balanceOf}.
880      */
881     function balanceOf(address account) public view override returns (uint256) {
882         return _balances[account];
883     }
884 
885     /**
886      * @dev See {IERC20-transfer}.
887      *
888      * Requirements:
889      *
890      * - `recipient` cannot be the zero address.
891      * - the caller must have a balance of at least `amount`.
892      */
893     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
894         _transfer(_msgSender(), recipient, amount);
895         return true;
896     }
897 
898     /**
899      * @dev See {IERC20-allowance}.
900      */
901     function allowance(address owner, address spender) public view virtual override returns (uint256) {
902         return _allowances[owner][spender];
903     }
904 
905     /**
906      * @dev See {IERC20-approve}.
907      *
908      * Requirements:
909      *
910      * - `spender` cannot be the zero address.
911      */
912     function approve(address spender, uint256 amount) public virtual override returns (bool) {
913         _approve(_msgSender(), spender, amount);
914         return true;
915     }
916 
917     /**
918      * @dev See {IERC20-transferFrom}.
919      *
920      * Emits an {Approval} event indicating the updated allowance. This is not
921      * required by the EIP. See the note at the beginning of {ERC20};
922      *
923      * Requirements:
924      * - `sender` and `recipient` cannot be the zero address.
925      * - `sender` must have a balance of at least `amount`.
926      * - the caller must have allowance for ``sender``'s tokens of at least
927      * `amount`.
928      */
929     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
930         _transfer(sender, recipient, amount);
931         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
932         return true;
933     }
934 
935     /**
936      * @dev Atomically increases the allowance granted to `spender` by the caller.
937      *
938      * This is an alternative to {approve} that can be used as a mitigation for
939      * problems described in {IERC20-approve}.
940      *
941      * Emits an {Approval} event indicating the updated allowance.
942      *
943      * Requirements:
944      *
945      * - `spender` cannot be the zero address.
946      */
947     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
948         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
949         return true;
950     }
951 
952     /**
953      * @dev Atomically decreases the allowance granted to `spender` by the caller.
954      *
955      * This is an alternative to {approve} that can be used as a mitigation for
956      * problems described in {IERC20-approve}.
957      *
958      * Emits an {Approval} event indicating the updated allowance.
959      *
960      * Requirements:
961      *
962      * - `spender` cannot be the zero address.
963      * - `spender` must have allowance for the caller of at least
964      * `subtractedValue`.
965      */
966     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
967         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
968         return true;
969     }
970 
971     /**
972      * @dev Moves tokens `amount` from `sender` to `recipient`.
973      *
974      * This is internal function is equivalent to {transfer}, and can be used to
975      * e.g. implement automatic token fees, slashing mechanisms, etc.
976      *
977      * Emits a {Transfer} event.
978      *
979      * Requirements:
980      *
981      * - `sender` cannot be the zero address.
982      * - `recipient` cannot be the zero address.
983      * - `sender` must have a balance of at least `amount`.
984      */
985     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
986         require(sender != address(0), "ERC20: transfer from the zero address");
987         require(recipient != address(0), "ERC20: transfer to the zero address");
988 
989         _beforeTokenTransfer(sender, recipient, amount);
990 
991         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
992         _balances[recipient] = _balances[recipient].add(amount);
993         emit Transfer(sender, recipient, amount);
994     }
995 
996     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
997      * the total supply.
998      *
999      * Emits a {Transfer} event with `from` set to the zero address.
1000      *
1001      * Requirements
1002      *
1003      * - `to` cannot be the zero address.
1004      */
1005     function _mint(address account, uint256 amount) internal virtual {
1006         require(account != address(0), "ERC20: mint to the zero address");
1007 
1008         _beforeTokenTransfer(address(0), account, amount);
1009 
1010         _totalSupply = _totalSupply.add(amount);
1011         _balances[account] = _balances[account].add(amount);
1012         emit Transfer(address(0), account, amount);
1013     }
1014 
1015     /**
1016      * @dev Destroys `amount` tokens from `account`, reducing the
1017      * total supply.
1018      *
1019      * Emits a {Transfer} event with `to` set to the zero address.
1020      *
1021      * Requirements
1022      *
1023      * - `account` cannot be the zero address.
1024      * - `account` must have at least `amount` tokens.
1025      */
1026     function _burn(address account, uint256 amount) internal virtual {
1027         require(account != address(0), "ERC20: burn from the zero address");
1028 
1029         _beforeTokenTransfer(account, address(0), amount);
1030 
1031         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1032         _totalSupply = _totalSupply.sub(amount);
1033         emit Transfer(account, address(0), amount);
1034     }
1035 
1036     /**
1037      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1038      *
1039      * This is internal function is equivalent to `approve`, and can be used to
1040      * e.g. set automatic allowances for certain subsystems, etc.
1041      *
1042      * Emits an {Approval} event.
1043      *
1044      * Requirements:
1045      *
1046      * - `owner` cannot be the zero address.
1047      * - `spender` cannot be the zero address.
1048      */
1049     function _approve(address owner, address spender, uint256 amount) internal virtual {
1050         require(owner != address(0), "ERC20: approve from the zero address");
1051         require(spender != address(0), "ERC20: approve to the zero address");
1052 
1053         _allowances[owner][spender] = amount;
1054         emit Approval(owner, spender, amount);
1055     }
1056 
1057     /**
1058      * @dev Sets {decimals} to a value other than the default one of 18.
1059      *
1060      * WARNING: This function should only be called from the constructor. Most
1061      * applications that interact with token contracts will not expect
1062      * {decimals} to ever change, and may work incorrectly if it does.
1063      */
1064     function _setupDecimals(uint8 decimals_) internal {
1065         _decimals = decimals_;
1066     }
1067 
1068     /**
1069      * @dev Hook that is called before any transfer of tokens. This includes
1070      * minting and burning.
1071      *
1072      * Calling conditions:
1073      *
1074      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1075      * will be to transferred to `to`.
1076      * - when `from` is zero, `amount` tokens will be minted for `to`.
1077      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1078      * - `from` and `to` are never both zero.
1079      *
1080      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1081      */
1082     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1083 }
1084 
1085 // File: contracts/MilkyWayToken.sol
1086 
1087 pragma solidity 0.6.12;
1088 
1089 // MilkyWayToken with Governance.
1090 contract MilkyWayToken is ERC20("MilkyWayToken", "MILK"), Ownable {
1091     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (todo Name).
1092     function mint(address _to, uint256 _amount) public onlyOwner {
1093         _mint(_to, _amount);
1094         _moveDelegates(address(0), _delegates[_to], _amount);
1095     }
1096 
1097     // Copied and modified from YAM code:
1098     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1099     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1100     // Which is copied and modified from COMPOUND:
1101     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1102 
1103     /// @notice A record of each accounts delegate
1104     mapping (address => address) internal _delegates;
1105 
1106     /// @notice A checkpoint for marking number of votes from a given block
1107     struct Checkpoint {
1108         uint32 fromBlock;
1109         uint256 votes;
1110     }
1111 
1112     /// @notice A record of votes checkpoints for each account, by index
1113     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1114 
1115     /// @notice The number of checkpoints for each account
1116     mapping (address => uint32) public numCheckpoints;
1117 
1118     /// @notice The EIP-712 typehash for the contract's domain
1119     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1120 
1121     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1122     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1123 
1124     /// @notice A record of states for signing / validating signatures
1125     mapping (address => uint) public nonces;
1126 
1127     /// @notice An event thats emitted when an account changes its delegate
1128     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1129 
1130     /// @notice An event thats emitted when a delegate account's vote balance changes
1131     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1132 
1133     /**
1134      * @notice Delegate votes from `msg.sender` to `delegatee`
1135      * @param delegator The address to get delegatee for
1136      */
1137     function delegates(address delegator)
1138     external
1139     view
1140     returns (address)
1141     {
1142         return _delegates[delegator];
1143     }
1144 
1145     /**
1146      * @notice Delegate votes from `msg.sender` to `delegatee`
1147      * @param delegatee The address to delegate votes to
1148      */
1149     function delegate(address delegatee) external {
1150         return _delegate(msg.sender, delegatee);
1151     }
1152 
1153     /**
1154      * @notice Delegates votes from signatory to `delegatee`
1155      * @param delegatee The address to delegate votes to
1156      * @param nonce The contract state required to match the signature
1157      * @param expiry The time at which to expire the signature
1158      * @param v The recovery byte of the signature
1159      * @param r Half of the ECDSA signature pair
1160      * @param s Half of the ECDSA signature pair
1161      */
1162     function delegateBySig(
1163         address delegatee,
1164         uint nonce,
1165         uint expiry,
1166         uint8 v,
1167         bytes32 r,
1168         bytes32 s
1169     )
1170     external
1171     {
1172         bytes32 domainSeparator = keccak256(
1173             abi.encode(
1174                 DOMAIN_TYPEHASH,
1175                 keccak256(bytes(name())),
1176                 getChainId(),
1177                 address(this)
1178             )
1179         );
1180 
1181         bytes32 structHash = keccak256(
1182             abi.encode(
1183                 DELEGATION_TYPEHASH,
1184                 delegatee,
1185                 nonce,
1186                 expiry
1187             )
1188         );
1189 
1190         bytes32 digest = keccak256(
1191             abi.encodePacked(
1192                 "\x19\x01",
1193                 domainSeparator,
1194                 structHash
1195             )
1196         );
1197 
1198         address signatory = ecrecover(digest, v, r, s);
1199         require(signatory != address(0), "MILKYWAY::delegateBySig: invalid signature");
1200         require(nonce == nonces[signatory]++, "MILKYWAY::delegateBySig: invalid nonce");
1201         require(now <= expiry, "MILKYWAY::delegateBySig: signature expired");
1202         return _delegate(signatory, delegatee);
1203     }
1204 
1205     /**
1206      * @notice Gets the current votes balance for `account`
1207      * @param account The address to get votes balance
1208      * @return The number of current votes for `account`
1209      */
1210     function getCurrentVotes(address account)
1211     external
1212     view
1213     returns (uint256)
1214     {
1215         uint32 nCheckpoints = numCheckpoints[account];
1216         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1217     }
1218 
1219     /**
1220      * @notice Determine the prior number of votes for an account as of a block number
1221      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1222      * @param account The address of the account to check
1223      * @param blockNumber The block number to get the vote balance at
1224      * @return The number of votes the account had as of the given block
1225      */
1226     function getPriorVotes(address account, uint blockNumber)
1227     external
1228     view
1229     returns (uint256)
1230     {
1231         require(blockNumber < block.number, "MILKYWAY::getPriorVotes: not yet determined");
1232 
1233         uint32 nCheckpoints = numCheckpoints[account];
1234         if (nCheckpoints == 0) {
1235             return 0;
1236         }
1237 
1238         // First check most recent balance
1239         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1240             return checkpoints[account][nCheckpoints - 1].votes;
1241         }
1242 
1243         // Next check implicit zero balance
1244         if (checkpoints[account][0].fromBlock > blockNumber) {
1245             return 0;
1246         }
1247 
1248         uint32 lower = 0;
1249         uint32 upper = nCheckpoints - 1;
1250         while (upper > lower) {
1251             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1252             Checkpoint memory cp = checkpoints[account][center];
1253             if (cp.fromBlock == blockNumber) {
1254                 return cp.votes;
1255             } else if (cp.fromBlock < blockNumber) {
1256                 lower = center;
1257             } else {
1258                 upper = center - 1;
1259             }
1260         }
1261         return checkpoints[account][lower].votes;
1262     }
1263 
1264     function _delegate(address delegator, address delegatee)
1265     internal
1266     {
1267         address currentDelegate = _delegates[delegator];
1268         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MILKYWAYs (not scaled);
1269         _delegates[delegator] = delegatee;
1270 
1271         emit DelegateChanged(delegator, currentDelegate, delegatee);
1272 
1273         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1274     }
1275 
1276     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1277         if (srcRep != dstRep && amount > 0) {
1278             if (srcRep != address(0)) {
1279                 // decrease old representative
1280                 uint32 srcRepNum = numCheckpoints[srcRep];
1281                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1282                 uint256 srcRepNew = srcRepOld.sub(amount);
1283                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1284             }
1285 
1286             if (dstRep != address(0)) {
1287                 // increase new representative
1288                 uint32 dstRepNum = numCheckpoints[dstRep];
1289                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1290                 uint256 dstRepNew = dstRepOld.add(amount);
1291                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1292             }
1293         }
1294     }
1295 
1296     function _writeCheckpoint(
1297         address delegatee,
1298         uint32 nCheckpoints,
1299         uint256 oldVotes,
1300         uint256 newVotes
1301     )
1302     internal
1303     {
1304         uint32 blockNumber = safe32(block.number, "MILKYWAY::_writeCheckpoint: block number exceeds 32 bits");
1305 
1306         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1307             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1308         } else {
1309             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1310             numCheckpoints[delegatee] = nCheckpoints + 1;
1311         }
1312 
1313         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1314     }
1315 
1316     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1317         require(n < 2**32, errorMessage);
1318         return uint32(n);
1319     }
1320 
1321     function getChainId() internal pure returns (uint) {
1322         uint256 chainId;
1323         assembly { chainId := chainid() }
1324         return chainId;
1325     }
1326 }// File: contracts/Interstellar.sol
1327 
1328 pragma solidity 0.6.12;
1329 
1330 interface IMigratorInterstellar {
1331     // Perform LP token migration from legacy UniswapV2 to SpaceSwap.
1332     // Take the current LP token address and return the new LP token address.
1333     // Migrator should have full access to the caller's LP token.
1334     // Return the new LP token address.
1335     //
1336     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1337     // SpaceSwap must mint EXACTLY the same amount of SpaceSwap LP tokens or
1338     // else something bad will happen. Traditional UniswapV2 does not
1339     // do that so be careful!
1340     function migrate(IERC20 token) external returns (IERC20);
1341 }
1342 
1343 // Interstellar is the master of MILKIWAY. He can make MILKIWAY and he is a fair guy.
1344 //
1345 // Note that it's ownable and the owner wields tremendous power. The ownership
1346 // will be transferred to a governance smart contract once MILKIWAY is sufficiently
1347 // distributed and the community can show to govern itself.
1348 //
1349 // Have fun reading it. Hopefully it's bug-free. God bless.
1350 contract Interstellar is Ownable {
1351     using SafeMath for uint256;
1352     using SafeERC20 for IERC20;
1353 
1354     // Info of each user.
1355     struct UserInfo {
1356         uint256 amount;     // How many LP tokens the user has provided.
1357         uint256 rewardDebt; // Reward debt. See explanation below.
1358         //
1359         // We do some fancy math here. Basically, any point in time, the amount of Milks
1360         // entitled to a user but is pending to be distributed is:
1361         //
1362         //   pending reward = (user.amount * pool.accMilkPerShare) - user.rewardDebt
1363         //
1364         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1365         //   1. The pool's `accMilkPerShare` (and `lastRewardBlock`) gets updated.
1366         //   2. User receives the pending reward sent to his/her address.
1367         //   3. User's `amount` gets updated.
1368         //   4. User's `rewardDebt` gets updated.
1369     }
1370 
1371     // Info of each pool.
1372     struct PoolInfo {
1373         IERC20 lpToken;           // Address of LP token contract.
1374         uint256 allocPoint;       // How many allocation points assigned to this pool. MILKs to distribute per block.
1375         uint256 lastRewardBlock;  // Last block number that MILKs distribution occurs.
1376         uint256 accMilkPerShare; // Accumulated MILKs per share, times 1e12. See below.
1377     }
1378 
1379     // The MILKIWAY TOKEN!
1380     MilkyWayToken public milk;
1381     // Dev address.
1382     address public devaddr;
1383     // Block number when bonus MILK period ends.
1384     uint256 public bonusEndBlock;
1385     // MILK tokens created per block.
1386     uint256 public milkPerBlock;
1387     // Bonus muliplier for early milk makers.
1388     uint256 public constant BONUS_MULTIPLIER = 10;
1389     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1390     IMigratorInterstellar public migrator;
1391 
1392     // Info of each pool.
1393     PoolInfo[] public poolInfo;
1394     // Info of each user that stakes LP tokens.
1395     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1396     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1397     uint256 public totalAllocPoint = 0;
1398     // The block number when MILK mining starts.
1399     uint256 public startBlock;
1400 
1401     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1402     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1403     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1404 
1405     constructor(
1406         MilkyWayToken _milk,
1407         address _devaddr,
1408         uint256 _milkPerBlock,
1409         uint256 _startBlock,
1410         uint256 _bonusEndBlock
1411     ) public {
1412         milk = _milk;
1413         devaddr = _devaddr;
1414         milkPerBlock = _milkPerBlock;
1415         bonusEndBlock = _bonusEndBlock;
1416         startBlock = _startBlock;
1417     }
1418 
1419     function poolLength() external view returns (uint256) {
1420         return poolInfo.length;
1421     }
1422 
1423     // Add a new lp to the pool. Can only be called by the owner.
1424     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1425     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1426         if (_withUpdate) {
1427             massUpdatePools();
1428         }
1429         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1430         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1431         poolInfo.push(PoolInfo({
1432         lpToken: _lpToken,
1433         allocPoint: _allocPoint,
1434         lastRewardBlock: lastRewardBlock,
1435         accMilkPerShare: 0
1436         }));
1437     }
1438 
1439     // Update the given pool's MILK allocation point. Can only be called by the owner.
1440     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1441         if (_withUpdate) {
1442             massUpdatePools();
1443         }
1444         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1445         poolInfo[_pid].allocPoint = _allocPoint;
1446     }
1447 
1448     // Set the migrator contract. Can only be called by the owner.
1449     function setMigrator(IMigratorInterstellar _migrator) public onlyOwner {
1450         migrator = _migrator;
1451     }
1452 
1453     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1454     function migrate(uint256 _pid) public {
1455         require(address(migrator) != address(0), "migrate: no migrator");
1456         PoolInfo storage pool = poolInfo[_pid];
1457         IERC20 lpToken = pool.lpToken;
1458         uint256 bal = lpToken.balanceOf(address(this));
1459         lpToken.safeApprove(address(migrator), bal);
1460         IERC20 newLpToken = migrator.migrate(lpToken);
1461         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1462         pool.lpToken = newLpToken;
1463     }
1464 
1465     // Return reward multiplier over the given _from to _to block.
1466     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1467         if (_to <= bonusEndBlock) {
1468             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1469         } else if (_from >= bonusEndBlock) {
1470             return _to.sub(_from);
1471         } else {
1472             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1473                 _to.sub(bonusEndBlock)
1474             );
1475         }
1476     }
1477 
1478     // View function to see pending MILKs on frontend.
1479     function pendingMilk(uint256 _pid, address _user) external view returns (uint256) {
1480         PoolInfo storage pool = poolInfo[_pid];
1481         UserInfo storage user = userInfo[_pid][_user];
1482         uint256 accMilkPerShare = pool.accMilkPerShare;
1483         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1484         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1485             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1486             uint256 milkReward = multiplier.mul(milkPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1487             accMilkPerShare = accMilkPerShare.add(milkReward.mul(1e12).div(lpSupply));
1488         }
1489         return user.amount.mul(accMilkPerShare).div(1e12).sub(user.rewardDebt);
1490     }
1491 
1492     // Update reward vairables for all pools. Be careful of gas spending!
1493     function massUpdatePools() public {
1494         uint256 length = poolInfo.length;
1495         for (uint256 pid = 0; pid < length; ++pid) {
1496             updatePool(pid);
1497         }
1498     }
1499 
1500     // Update reward variables of the given pool to be up-to-date.
1501        function updatePool(uint256 _pid) public {
1502         PoolInfo storage pool = poolInfo[_pid];
1503         if (block.number <= pool.lastRewardBlock) {
1504             return;
1505         }
1506         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1507         if (lpSupply == 0) {
1508             pool.lastRewardBlock = block.number;
1509             return;
1510         }
1511         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1512         uint256 milkReward = multiplier.mul(milkPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1513         milk.mint(devaddr, milkReward.mul(3).div(100)); // todo
1514         milk.mint(address(this), milkReward);
1515         pool.accMilkPerShare = pool.accMilkPerShare.add(milkReward.mul(1e12).div(lpSupply));
1516         pool.lastRewardBlock = block.number;
1517     }
1518 
1519 
1520     // Deposit LP tokens to Interstellar for MILK allocation.
1521     function deposit(uint256 _pid, uint256 _amount) public {
1522         PoolInfo storage pool = poolInfo[_pid];
1523         UserInfo storage user = userInfo[_pid][msg.sender];
1524         updatePool(_pid);
1525         if (user.amount > 0) {
1526             uint256 pending = user.amount.mul(pool.accMilkPerShare).div(1e12).sub(user.rewardDebt);
1527             safeMilkTransfer(msg.sender, pending);
1528         }
1529         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1530         user.amount = user.amount.add(_amount);
1531         user.rewardDebt = user.amount.mul(pool.accMilkPerShare).div(1e12);
1532         emit Deposit(msg.sender, _pid, _amount);
1533     }
1534 
1535     // Withdraw LP tokens from Interstellar.
1536     function withdraw(uint256 _pid, uint256 _amount) public {
1537         PoolInfo storage pool = poolInfo[_pid];
1538         UserInfo storage user = userInfo[_pid][msg.sender];
1539         require(user.amount >= _amount, "withdraw: not good");
1540         updatePool(_pid);
1541         uint256 pending = user.amount.mul(pool.accMilkPerShare).div(1e12).sub(user.rewardDebt);
1542         safeMilkTransfer(msg.sender, pending);
1543         user.amount = user.amount.sub(_amount);
1544         user.rewardDebt = user.amount.mul(pool.accMilkPerShare).div(1e12);
1545         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1546         emit Withdraw(msg.sender, _pid, _amount);
1547     }
1548 
1549     // Withdraw without caring about rewards. EMERGENCY ONLY.
1550     function emergencyWithdraw(uint256 _pid) public {
1551         PoolInfo storage pool = poolInfo[_pid];
1552         UserInfo storage user = userInfo[_pid][msg.sender];
1553         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1554         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1555         user.amount = 0;
1556         user.rewardDebt = 0;
1557     }
1558 
1559     // Safe milk transfer function, just in case if rounding error causes pool to not have enough MILKs.
1560     function safeMilkTransfer(address _to, uint256 _amount) internal {
1561         uint256 milkBal = milk.balanceOf(address(this));
1562         if (_amount > milkBal) {
1563             milk.transfer(_to, milkBal);
1564         } else {
1565             milk.transfer(_to, _amount);
1566         }
1567     }
1568 
1569     // Update dev address by the previous dev.
1570     function dev(address _devaddr) public {
1571         require(msg.sender == devaddr, "dev: wut?");
1572         devaddr = _devaddr;
1573     }
1574 }