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
78 
79 
80 
81 pragma solidity ^0.6.0;
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
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
320         return functionCall(target, data, "Address: low-level call failed");
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
386 
387 pragma solidity ^0.6.0;
388 
389 
390 
391 
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure (when the token
395  * contract returns false). Tokens that return no value (and instead revert or
396  * throw on failure) are also supported, non-reverting calls are assumed to be
397  * successful.
398  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
399  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
400  */
401 library SafeERC20 {
402     using SafeMath for uint256;
403     using Address for address;
404 
405     function safeTransfer(IERC20 token, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
407     }
408 
409     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     /**
414      * @dev Deprecated. This function has issues similar to the ones found in
415      * {IERC20-approve}, and its usage is discouraged.
416      *
417      * Whenever possible, use {safeIncreaseAllowance} and
418      * {safeDecreaseAllowance} instead.
419      */
420     function safeApprove(IERC20 token, address spender, uint256 value) internal {
421         // safeApprove should only be called when setting an initial allowance,
422         // or when resetting it to zero. To increase and decrease it, use
423         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
424         // solhint-disable-next-line max-line-length
425         require((value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
429     }
430 
431     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).add(value);
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
437         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
439     }
440 
441     /**
442      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
443      * on the return value: the return value is optional (but if data is returned, it must not be false).
444      * @param token The token targeted by the call.
445      * @param data The call data (encoded using abi.encode or one of its variants).
446      */
447     function _callOptionalReturn(IERC20 token, bytes memory data) private {
448         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
449         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
450         // the target address contains contract code and also asserts for success in the low-level call.
451 
452         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
453         if (returndata.length > 0) { // Return data is optional
454             // solhint-disable-next-line max-line-length
455             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
456         }
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
461 
462 
463 
464 pragma solidity ^0.6.0;
465 
466 /**
467  * @dev Library for managing
468  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
469  * types.
470  *
471  * Sets have the following properties:
472  *
473  * - Elements are added, removed, and checked for existence in constant time
474  * (O(1)).
475  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
476  *
477  * ```
478  * contract Example {
479  *     // Add the library methods
480  *     using EnumerableSet for EnumerableSet.AddressSet;
481  *
482  *     // Declare a set state variable
483  *     EnumerableSet.AddressSet private mySet;
484  * }
485  * ```
486  *
487  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
488  * (`UintSet`) are supported.
489  */
490 library EnumerableSet {
491     // To implement this library for multiple types with as little code
492     // repetition as possible, we write it in terms of a generic Set type with
493     // bytes32 values.
494     // The Set implementation uses private functions, and user-facing
495     // implementations (such as AddressSet) are just wrappers around the
496     // underlying Set.
497     // This means that we can only create new EnumerableSets for types that fit
498     // in bytes32.
499 
500     struct Set {
501         // Storage of set values
502         bytes32[] _values;
503 
504         // Position of the value in the `values` array, plus 1 because index 0
505         // means a value is not in the set.
506         mapping (bytes32 => uint256) _indexes;
507     }
508 
509     /**
510      * @dev Add a value to a set. O(1).
511      *
512      * Returns true if the value was added to the set, that is if it was not
513      * already present.
514      */
515     function _add(Set storage set, bytes32 value) private returns (bool) {
516         if (!_contains(set, value)) {
517             set._values.push(value);
518             // The value is stored at length-1, but we add 1 to all indexes
519             // and use 0 as a sentinel value
520             set._indexes[value] = set._values.length;
521             return true;
522         } else {
523             return false;
524         }
525     }
526 
527     /**
528      * @dev Removes a value from a set. O(1).
529      *
530      * Returns true if the value was removed from the set, that is if it was
531      * present.
532      */
533     function _remove(Set storage set, bytes32 value) private returns (bool) {
534         // We read and store the value's index to prevent multiple reads from the same storage slot
535         uint256 valueIndex = set._indexes[value];
536 
537         if (valueIndex != 0) { // Equivalent to contains(set, value)
538             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
539             // the array, and then remove the last element (sometimes called as 'swap and pop').
540             // This modifies the order of the array, as noted in {at}.
541 
542             uint256 toDeleteIndex = valueIndex - 1;
543             uint256 lastIndex = set._values.length - 1;
544 
545             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
546             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
547 
548             bytes32 lastvalue = set._values[lastIndex];
549 
550             // Move the last value to the index where the value to delete is
551             set._values[toDeleteIndex] = lastvalue;
552             // Update the index for the moved value
553             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
554 
555             // Delete the slot where the moved value was stored
556             set._values.pop();
557 
558             // Delete the index for the deleted slot
559             delete set._indexes[value];
560 
561             return true;
562         } else {
563             return false;
564         }
565     }
566 
567     /**
568      * @dev Returns true if the value is in the set. O(1).
569      */
570     function _contains(Set storage set, bytes32 value) private view returns (bool) {
571         return set._indexes[value] != 0;
572     }
573 
574     /**
575      * @dev Returns the number of values on the set. O(1).
576      */
577     function _length(Set storage set) private view returns (uint256) {
578         return set._values.length;
579     }
580 
581     /**
582      * @dev Returns the value stored at position `index` in the set. O(1).
583      *
584      * Note that there are no guarantees on the ordering of values inside the
585      * array, and it may change when more values are added or removed.
586      *
587      * Requirements:
588      *
589      * - `index` must be strictly less than {length}.
590      */
591     function _at(Set storage set, uint256 index) private view returns (bytes32) {
592         require(set._values.length > index, "EnumerableSet: index out of bounds");
593         return set._values[index];
594     }
595 
596     // AddressSet
597 
598     struct AddressSet {
599         Set _inner;
600     }
601 
602     /**
603      * @dev Add a value to a set. O(1).
604      *
605      * Returns true if the value was added to the set, that is if it was not
606      * already present.
607      */
608     function add(AddressSet storage set, address value) internal returns (bool) {
609         return _add(set._inner, bytes32(uint256(value)));
610     }
611 
612     /**
613      * @dev Removes a value from a set. O(1).
614      *
615      * Returns true if the value was removed from the set, that is if it was
616      * present.
617      */
618     function remove(AddressSet storage set, address value) internal returns (bool) {
619         return _remove(set._inner, bytes32(uint256(value)));
620     }
621 
622     /**
623      * @dev Returns true if the value is in the set. O(1).
624      */
625     function contains(AddressSet storage set, address value) internal view returns (bool) {
626         return _contains(set._inner, bytes32(uint256(value)));
627     }
628 
629     /**
630      * @dev Returns the number of values in the set. O(1).
631      */
632     function length(AddressSet storage set) internal view returns (uint256) {
633         return _length(set._inner);
634     }
635 
636     /**
637      * @dev Returns the value stored at position `index` in the set. O(1).
638      *
639      * Note that there are no guarantees on the ordering of values inside the
640      * array, and it may change when more values are added or removed.
641      *
642      * Requirements:
643      *
644      * - `index` must be strictly less than {length}.
645      */
646     function at(AddressSet storage set, uint256 index) internal view returns (address) {
647         return address(uint256(_at(set._inner, index)));
648     }
649 
650 
651     // UintSet
652 
653     struct UintSet {
654         Set _inner;
655     }
656 
657     /**
658      * @dev Add a value to a set. O(1).
659      *
660      * Returns true if the value was added to the set, that is if it was not
661      * already present.
662      */
663     function add(UintSet storage set, uint256 value) internal returns (bool) {
664         return _add(set._inner, bytes32(value));
665     }
666 
667     /**
668      * @dev Removes a value from a set. O(1).
669      *
670      * Returns true if the value was removed from the set, that is if it was
671      * present.
672      */
673     function remove(UintSet storage set, uint256 value) internal returns (bool) {
674         return _remove(set._inner, bytes32(value));
675     }
676 
677     /**
678      * @dev Returns true if the value is in the set. O(1).
679      */
680     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
681         return _contains(set._inner, bytes32(value));
682     }
683 
684     /**
685      * @dev Returns the number of values on the set. O(1).
686      */
687     function length(UintSet storage set) internal view returns (uint256) {
688         return _length(set._inner);
689     }
690 
691     /**
692      * @dev Returns the value stored at position `index` in the set. O(1).
693      *
694      * Note that there are no guarantees on the ordering of values inside the
695      * array, and it may change when more values are added or removed.
696      *
697      * Requirements:
698      *
699      * - `index` must be strictly less than {length}.
700      */
701     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
702         return uint256(_at(set._inner, index));
703     }
704 }
705 
706 // File: @openzeppelin/contracts/GSN/Context.sol
707 
708 
709 
710 pragma solidity ^0.6.0;
711 
712 /*
713  * @dev Provides information about the current execution context, including the
714  * sender of the transaction and its data. While these are generally available
715  * via msg.sender and msg.data, they should not be accessed in such a direct
716  * manner, since when dealing with GSN meta-transactions the account sending and
717  * paying for execution may not be the actual sender (as far as an application
718  * is concerned).
719  *
720  * This contract is only required for intermediate, library-like contracts.
721  */
722 abstract contract Context {
723     function _msgSender() internal view virtual returns (address payable) {
724         return msg.sender;
725     }
726 
727     function _msgData() internal view virtual returns (bytes memory) {
728         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
729         return msg.data;
730     }
731 }
732 
733 // File: @openzeppelin/contracts/access/Ownable.sol
734 
735 
736 
737 pragma solidity ^0.6.0;
738 
739 /**
740  * @dev Contract module which provides a basic access control mechanism, where
741  * there is an account (an owner) that can be granted exclusive access to
742  * specific functions.
743  *
744  * By default, the owner account will be the one that deploys the contract. This
745  * can later be changed with {transferOwnership}.
746  *
747  * This module is used through inheritance. It will make available the modifier
748  * `onlyOwner`, which can be applied to your functions to restrict their use to
749  * the owner.
750  */
751 contract Ownable is Context {
752     address private _owner;
753 
754     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
755 
756     /**
757      * @dev Initializes the contract setting the deployer as the initial owner.
758      */
759     constructor () internal {
760         address msgSender = _msgSender();
761         _owner = msgSender;
762         emit OwnershipTransferred(address(0), msgSender);
763     }
764 
765     /**
766      * @dev Returns the address of the current owner.
767      */
768     function owner() public view returns (address) {
769         return _owner;
770     }
771 
772     /**
773      * @dev Throws if called by any account other than the owner.
774      */
775     modifier onlyOwner() {
776         require(_owner == _msgSender(), "Ownable: caller is not the owner");
777         _;
778     }
779 
780     /**
781      * @dev Leaves the contract without owner. It will not be possible to call
782      * `onlyOwner` functions anymore. Can only be called by the current owner.
783      *
784      * NOTE: Renouncing ownership will leave the contract without an owner,
785      * thereby removing any functionality that is only available to the owner.
786      */
787     function renounceOwnership() public virtual onlyOwner {
788         emit OwnershipTransferred(_owner, address(0));
789         _owner = address(0);
790     }
791 
792     /**
793      * @dev Transfers ownership of the contract to a new account (`newOwner`).
794      * Can only be called by the current owner.
795      */
796     function transferOwnership(address newOwner) public virtual onlyOwner {
797         require(newOwner != address(0), "Ownable: new owner is the zero address");
798         emit OwnershipTransferred(_owner, newOwner);
799         _owner = newOwner;
800     }
801 }
802 
803 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
804 
805 
806 
807 pragma solidity ^0.6.0;
808 
809 
810 
811 
812 
813 /**
814  * @dev Implementation of the {IERC20} interface.
815  *
816  * This implementation is agnostic to the way tokens are created. This means
817  * that a supply mechanism has to be added in a derived contract using {_mint}.
818  * For a generic mechanism see {ERC20PresetMinterPauser}.
819  *
820  * TIP: For a detailed writeup see our guide
821  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
822  * to implement supply mechanisms].
823  *
824  * We have followed general OpenZeppelin guidelines: functions revert instead
825  * of returning `false` on failure. This behavior is nonetheless conventional
826  * and does not conflict with the expectations of ERC20 applications.
827  *
828  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
829  * This allows applications to reconstruct the allowance for all accounts just
830  * by listening to said events. Other implementations of the EIP may not emit
831  * these events, as it isn't required by the specification.
832  *
833  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
834  * functions have been added to mitigate the well-known issues around setting
835  * allowances. See {IERC20-approve}.
836  */
837 contract ERC20 is Context, IERC20 {
838     using SafeMath for uint256;
839     using Address for address;
840 
841     mapping (address => uint256) private _balances;
842 
843     mapping (address => mapping (address => uint256)) private _allowances;
844 
845     uint256 private _totalSupply;
846 
847     string private _name;
848     string private _symbol;
849     uint8 private _decimals;
850 
851     /**
852      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
853      * a default value of 18.
854      *
855      * To select a different value for {decimals}, use {_setupDecimals}.
856      *
857      * All three of these values are immutable: they can only be set once during
858      * construction.
859      */
860     constructor (string memory name, string memory symbol) public {
861         _name = name;
862         _symbol = symbol;
863         _decimals = 18;
864     }
865 
866     /**
867      * @dev Returns the name of the token.
868      */
869     function name() public view returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev Returns the symbol of the token, usually a shorter version of the
875      * name.
876      */
877     function symbol() public view returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev Returns the number of decimals used to get its user representation.
883      * For example, if `decimals` equals `2`, a balance of `505` tokens should
884      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
885      *
886      * Tokens usually opt for a value of 18, imitating the relationship between
887      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
888      * called.
889      *
890      * NOTE: This information is only used for _display_ purposes: it in
891      * no way affects any of the arithmetic of the contract, including
892      * {IERC20-balanceOf} and {IERC20-transfer}.
893      */
894     function decimals() public view returns (uint8) {
895         return _decimals;
896     }
897 
898     /**
899      * @dev See {IERC20-totalSupply}.
900      */
901     function totalSupply() public view override returns (uint256) {
902         return _totalSupply;
903     }
904 
905     /**
906      * @dev See {IERC20-balanceOf}.
907      */
908     function balanceOf(address account) public view override returns (uint256) {
909         return _balances[account];
910     }
911 
912     /**
913      * @dev See {IERC20-transfer}.
914      *
915      * Requirements:
916      *
917      * - `recipient` cannot be the zero address.
918      * - the caller must have a balance of at least `amount`.
919      */
920     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
921         _transfer(_msgSender(), recipient, amount);
922         return true;
923     }
924 
925     /**
926      * @dev See {IERC20-allowance}.
927      */
928     function allowance(address owner, address spender) public view virtual override returns (uint256) {
929         return _allowances[owner][spender];
930     }
931 
932     /**
933      * @dev See {IERC20-approve}.
934      *
935      * Requirements:
936      *
937      * - `spender` cannot be the zero address.
938      */
939     function approve(address spender, uint256 amount) public virtual override returns (bool) {
940         _approve(_msgSender(), spender, amount);
941         return true;
942     }
943 
944     /**
945      * @dev See {IERC20-transferFrom}.
946      *
947      * Emits an {Approval} event indicating the updated allowance. This is not
948      * required by the EIP. See the note at the beginning of {ERC20};
949      *
950      * Requirements:
951      * - `sender` and `recipient` cannot be the zero address.
952      * - `sender` must have a balance of at least `amount`.
953      * - the caller must have allowance for ``sender``'s tokens of at least
954      * `amount`.
955      */
956     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
957         _transfer(sender, recipient, amount);
958         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
959         return true;
960     }
961 
962     /**
963      * @dev Atomically increases the allowance granted to `spender` by the caller.
964      *
965      * This is an alternative to {approve} that can be used as a mitigation for
966      * problems described in {IERC20-approve}.
967      *
968      * Emits an {Approval} event indicating the updated allowance.
969      *
970      * Requirements:
971      *
972      * - `spender` cannot be the zero address.
973      */
974     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
975         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
976         return true;
977     }
978 
979     /**
980      * @dev Atomically decreases the allowance granted to `spender` by the caller.
981      *
982      * This is an alternative to {approve} that can be used as a mitigation for
983      * problems described in {IERC20-approve}.
984      *
985      * Emits an {Approval} event indicating the updated allowance.
986      *
987      * Requirements:
988      *
989      * - `spender` cannot be the zero address.
990      * - `spender` must have allowance for the caller of at least
991      * `subtractedValue`.
992      */
993     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
994         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
995         return true;
996     }
997 
998     /**
999      * @dev Moves tokens `amount` from `sender` to `recipient`.
1000      *
1001      * This is internal function is equivalent to {transfer}, and can be used to
1002      * e.g. implement automatic token fees, slashing mechanisms, etc.
1003      *
1004      * Emits a {Transfer} event.
1005      *
1006      * Requirements:
1007      *
1008      * - `sender` cannot be the zero address.
1009      * - `recipient` cannot be the zero address.
1010      * - `sender` must have a balance of at least `amount`.
1011      */
1012     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1013         require(sender != address(0), "ERC20: transfer from the zero address");
1014         require(recipient != address(0), "ERC20: transfer to the zero address");
1015 
1016         _beforeTokenTransfer(sender, recipient, amount);
1017 
1018         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1019         _balances[recipient] = _balances[recipient].add(amount);
1020         emit Transfer(sender, recipient, amount);
1021     }
1022 
1023     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1024      * the total supply.
1025      *
1026      * Emits a {Transfer} event with `from` set to the zero address.
1027      *
1028      * Requirements
1029      *
1030      * - `to` cannot be the zero address.
1031      */
1032     function _mint(address account, uint256 amount) internal virtual {
1033         require(account != address(0), "ERC20: mint to the zero address");
1034 
1035         _beforeTokenTransfer(address(0), account, amount);
1036 
1037         _totalSupply = _totalSupply.add(amount);
1038         _balances[account] = _balances[account].add(amount);
1039         emit Transfer(address(0), account, amount);
1040     }
1041 
1042     /**
1043      * @dev Destroys `amount` tokens from `account`, reducing the
1044      * total supply.
1045      *
1046      * Emits a {Transfer} event with `to` set to the zero address.
1047      *
1048      * Requirements
1049      *
1050      * - `account` cannot be the zero address.
1051      * - `account` must have at least `amount` tokens.
1052      */
1053     function _burn(address account, uint256 amount) internal virtual {
1054         require(account != address(0), "ERC20: burn from the zero address");
1055 
1056         _beforeTokenTransfer(account, address(0), amount);
1057 
1058         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1059         _totalSupply = _totalSupply.sub(amount);
1060         emit Transfer(account, address(0), amount);
1061     }
1062 
1063     /**
1064      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1065      *
1066      * This is internal function is equivalent to `approve`, and can be used to
1067      * e.g. set automatic allowances for certain subsystems, etc.
1068      *
1069      * Emits an {Approval} event.
1070      *
1071      * Requirements:
1072      *
1073      * - `owner` cannot be the zero address.
1074      * - `spender` cannot be the zero address.
1075      */
1076     function _approve(address owner, address spender, uint256 amount) internal virtual {
1077         require(owner != address(0), "ERC20: approve from the zero address");
1078         require(spender != address(0), "ERC20: approve to the zero address");
1079 
1080         _allowances[owner][spender] = amount;
1081         emit Approval(owner, spender, amount);
1082     }
1083 
1084     /**
1085      * @dev Sets {decimals} to a value other than the default one of 18.
1086      *
1087      * WARNING: This function should only be called from the constructor. Most
1088      * applications that interact with token contracts will not expect
1089      * {decimals} to ever change, and may work incorrectly if it does.
1090      */
1091     function _setupDecimals(uint8 decimals_) internal {
1092         _decimals = decimals_;
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any transfer of tokens. This includes
1097      * minting and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1102      * will be to transferred to `to`.
1103      * - when `from` is zero, `amount` tokens will be minted for `to`.
1104      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1110 }
1111 
1112 
1113 pragma solidity 0.6.12;
1114 
1115 
1116 
1117 
1118 contract AidToken is ERC20("AidToken", "Aid"), Ownable {
1119     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1120     function mint(address _to, uint256 _amount) public onlyOwner {
1121         _mint(_to, _amount);
1122         _moveDelegates(address(0), _delegates[_to], _amount);
1123     }
1124 
1125     // Copied and modified from YAM code:
1126     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1127     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1128     // Which is copied and modified from COMPOUND:
1129     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1130 
1131     /// @notice A record of each accounts delegate
1132     mapping (address => address) internal _delegates;
1133 
1134     /// @notice A checkpoint for marking number of votes from a given block
1135     struct Checkpoint {
1136         uint32 fromBlock;
1137         uint256 votes;
1138     }
1139 
1140     /// @notice A record of votes checkpoints for each account, by index
1141     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1142 
1143     /// @notice The number of checkpoints for each account
1144     mapping (address => uint32) public numCheckpoints;
1145 
1146     /// @notice The EIP-712 typehash for the contract's domain
1147     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1148 
1149     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1150     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1151 
1152     /// @notice A record of states for signing / validating signatures
1153     mapping (address => uint) public nonces;
1154 
1155     /// @notice An event thats emitted when an account changes its delegate
1156     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1157 
1158     /// @notice An event thats emitted when a delegate account's vote balance changes
1159     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1160 
1161     /**
1162      * @notice Delegate votes from `msg.sender` to `delegatee`
1163      * @param delegator The address to get delegatee for
1164      */
1165     function delegates(address delegator)
1166     external
1167     view
1168     returns (address)
1169     {
1170         return _delegates[delegator];
1171     }
1172 
1173     /**
1174      * @notice Delegate votes from `msg.sender` to `delegatee`
1175      * @param delegatee The address to delegate votes to
1176      */
1177     function delegate(address delegatee) external {
1178         return _delegate(msg.sender, delegatee);
1179     }
1180 
1181     /**
1182      * @notice Delegates votes from signatory to `delegatee`
1183      * @param delegatee The address to delegate votes to
1184      * @param nonce The contract state required to match the signature
1185      * @param expiry The time at which to expire the signature
1186      * @param v The recovery byte of the signature
1187      * @param r Half of the ECDSA signature pair
1188      * @param s Half of the ECDSA signature pair
1189      */
1190     function delegateBySig(
1191         address delegatee,
1192         uint nonce,
1193         uint expiry,
1194         uint8 v,
1195         bytes32 r,
1196         bytes32 s
1197     )
1198     external
1199     {
1200         bytes32 domainSeparator = keccak256(
1201             abi.encode(
1202                 DOMAIN_TYPEHASH,
1203                 keccak256(bytes(name())),
1204                 getChainId(),
1205                 address(this)
1206             )
1207         );
1208 
1209         bytes32 structHash = keccak256(
1210             abi.encode(
1211                 DELEGATION_TYPEHASH,
1212                 delegatee,
1213                 nonce,
1214                 expiry
1215             )
1216         );
1217 
1218         bytes32 digest = keccak256(
1219             abi.encodePacked(
1220                 "\x19\x01",
1221                 domainSeparator,
1222                 structHash
1223             )
1224         );
1225 
1226         address signatory = ecrecover(digest, v, r, s);
1227         require(signatory != address(0), "Aid::delegateBySig: invalid signature");
1228         require(nonce == nonces[signatory]++, "Aid::delegateBySig: invalid nonce");
1229         require(now <= expiry, "Aid::delegateBySig: signature expired");
1230         return _delegate(signatory, delegatee);
1231     }
1232 
1233     /**
1234      * @notice Gets the current votes balance for `account`
1235      * @param account The address to get votes balance
1236      * @return The number of current votes for `account`
1237      */
1238     function getCurrentVotes(address account)
1239     external
1240     view
1241     returns (uint256)
1242     {
1243         uint32 nCheckpoints = numCheckpoints[account];
1244         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1245     }
1246 
1247     /**
1248      * @notice Determine the prior number of votes for an account as of a block number
1249      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1250      * @param account The address of the account to check
1251      * @param blockNumber The block number to get the vote balance at
1252      * @return The number of votes the account had as of the given block
1253      */
1254     function getPriorVotes(address account, uint blockNumber)
1255     external
1256     view
1257     returns (uint256)
1258     {
1259         require(blockNumber < block.number, "Aid::getPriorVotes: not yet determined");
1260 
1261         uint32 nCheckpoints = numCheckpoints[account];
1262         if (nCheckpoints == 0) {
1263             return 0;
1264         }
1265 
1266         // First check most recent balance
1267         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1268             return checkpoints[account][nCheckpoints - 1].votes;
1269         }
1270 
1271         // Next check implicit zero balance
1272         if (checkpoints[account][0].fromBlock > blockNumber) {
1273             return 0;
1274         }
1275 
1276         uint32 lower = 0;
1277         uint32 upper = nCheckpoints - 1;
1278         while (upper > lower) {
1279             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1280             Checkpoint memory cp = checkpoints[account][center];
1281             if (cp.fromBlock == blockNumber) {
1282                 return cp.votes;
1283             } else if (cp.fromBlock < blockNumber) {
1284                 lower = center;
1285             } else {
1286                 upper = center - 1;
1287             }
1288         }
1289         return checkpoints[account][lower].votes;
1290     }
1291 
1292     function _delegate(address delegator, address delegatee)
1293     internal
1294     {
1295         address currentDelegate = _delegates[delegator];
1296         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying Aids (not scaled);
1297         _delegates[delegator] = delegatee;
1298 
1299         emit DelegateChanged(delegator, currentDelegate, delegatee);
1300 
1301         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1302     }
1303 
1304     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1305         if (srcRep != dstRep && amount > 0) {
1306             if (srcRep != address(0)) {
1307                 // decrease old representative
1308                 uint32 srcRepNum = numCheckpoints[srcRep];
1309                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1310                 uint256 srcRepNew = srcRepOld.sub(amount);
1311                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1312             }
1313 
1314             if (dstRep != address(0)) {
1315                 // increase new representative
1316                 uint32 dstRepNum = numCheckpoints[dstRep];
1317                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1318                 uint256 dstRepNew = dstRepOld.add(amount);
1319                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1320             }
1321         }
1322     }
1323 
1324     function _writeCheckpoint(
1325         address delegatee,
1326         uint32 nCheckpoints,
1327         uint256 oldVotes,
1328         uint256 newVotes
1329     )
1330     internal
1331     {
1332         uint32 blockNumber = safe32(block.number, "Aid::_writeCheckpoint: block number exceeds 32 bits");
1333 
1334         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1335             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1336         } else {
1337             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1338             numCheckpoints[delegatee] = nCheckpoints + 1;
1339         }
1340 
1341         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1342     }
1343 
1344     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1345         require(n < 2**32, errorMessage);
1346         return uint32(n);
1347     }
1348 
1349     function getChainId() internal pure returns (uint) {
1350         uint256 chainId;
1351         assembly { chainId := chainid() }
1352         return chainId;
1353     }
1354 }
1355 
1356 // File: contracts/MasterChef.sol
1357 
1358 pragma solidity 0.6.12;
1359 
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 interface IMigratorChef {
1368     // Perform LP token migration from legacy UniswapV2 to AidSwap.
1369     // Take the current LP token address and return the new LP token address.
1370     // Migrator should have full access to the caller's LP token.
1371     // Return the new LP token address.
1372     //
1373     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1374     // AidSwap must mint EXACTLY the same amount of AidSwap LP tokens or
1375     // else something bad will happen. Traditional UniswapV2 does not
1376     // do that so be careful!
1377     function migrate(IERC20 token) external returns (IERC20);
1378 }
1379 
1380 // MasterChef is the master of Aid. He can make Aid and he is a fair guy.
1381 //
1382 // Note that it's ownable and the owner wields tremendous power. The ownership
1383 // will be transferred to a governance smart contract once Aid is sufficiently
1384 // distributed and the community can show to govern itself.
1385 //
1386 // Have fun reading it. Hopefully it's bug-free. God bless.
1387 contract MasterChef is Ownable {
1388     using SafeMath for uint256;
1389     using SafeERC20 for IERC20;
1390 
1391     // Info of each user.
1392     struct UserInfo {
1393         uint256 amount;     // How many LP tokens the user has provided.
1394         uint256 rewardDebt; // Reward debt. See explanation below.
1395         //
1396         // We do some fancy math here. Basically, any point in time, the amount of Aids
1397         // entitled to a user but is pending to be distributed is:
1398         //
1399         //   pending reward = (user.amount * pool.accAidPerShare) - user.rewardDebt
1400         //
1401         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1402         //   1. The pool's `accAidPerShare` (and `lastRewardBlock`) gets updated.
1403         //   2. User receives the pending reward sent to his/her address.
1404         //   3. User's `amount` gets updated.
1405         //   4. User's `rewardDebt` gets updated.
1406     }
1407 
1408     // Info of each pool.
1409     struct PoolInfo {
1410         IERC20 lpToken;           // Address of LP token contract.
1411         uint256 allocPoint;       // How many allocation points assigned to this pool. Aids to distribute per block.
1412         uint256 lastRewardBlock;  // Last block number that Aids distribution occurs.
1413         uint256 accAidPerShare; // Accumulated Aids per share, times 1e12. See below.
1414     }
1415 
1416     // The Aid TOKEN!
1417     AidToken public Aid;
1418     // Dev address.
1419     address public devaddr;
1420     // Aid tokens created per block.
1421     uint256 public AidPerBlock;
1422     // Bonus muliplier for early Aid makers.
1423     IMigratorChef public migrator;
1424 
1425     // Info of each pool.
1426     PoolInfo[] public poolInfo;
1427     // Info of each user that stakes LP tokens.
1428     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1429     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1430     uint256 public totalAllocPoint = 0;
1431     // The block number when Aid mining starts.
1432     uint256 public startBlock;
1433 
1434     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1435     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1436     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1437 
1438     constructor(
1439         AidToken _Aid,
1440         address _devaddr,
1441         uint256 _AidPerBlock
1442     ) public {
1443         Aid = _Aid;
1444         devaddr = _devaddr;
1445         AidPerBlock = _AidPerBlock;
1446         startBlock = block.number;
1447     }
1448 
1449     function poolLength() external view returns (uint256) {
1450         return poolInfo.length;
1451     }
1452 
1453     // Add a new lp to the pool. Can only be called by the owner.
1454     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1455     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1456         if (_withUpdate) {
1457             massUpdatePools();
1458         }
1459         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1460         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1461         poolInfo.push(PoolInfo({
1462         lpToken: _lpToken,
1463         allocPoint: _allocPoint,
1464         lastRewardBlock: lastRewardBlock,
1465         accAidPerShare: 0
1466         }));
1467     }
1468 
1469     // Update the given pool's Aid allocation point. Can only be called by the owner.
1470     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1471         if (_withUpdate) {
1472             massUpdatePools();
1473         }
1474         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1475         poolInfo[_pid].allocPoint = _allocPoint;
1476     }
1477 
1478 
1479     // Return reward multiplier over the given _from to _to block.
1480     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1481         return _to.sub(_from);
1482     }
1483 
1484     // View function to see pending Aids on frontend.
1485     function pendingAid(uint256 _pid, address _user) external view returns (uint256) {
1486         PoolInfo storage pool = poolInfo[_pid];
1487         UserInfo storage user = userInfo[_pid][_user];
1488         uint256 accAidPerShare = pool.accAidPerShare;
1489         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1490         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1491             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1492             uint256 AidReward = multiplier.mul(AidPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1493             accAidPerShare = accAidPerShare.add(AidReward.mul(1e12).div(lpSupply));
1494         }
1495         return user.amount.mul(accAidPerShare).div(1e12).sub(user.rewardDebt);
1496     }
1497 
1498     // Update reward vairables for all pools. Be careful of gas spending!
1499     function massUpdatePools() public {
1500         uint256 length = poolInfo.length;
1501         for (uint256 pid = 0; pid < length; ++pid) {
1502             updatePool(pid);
1503         }
1504     }
1505 
1506     // Update reward variables of the given pool to be up-to-date.
1507     function updatePool(uint256 _pid) public {
1508         PoolInfo storage pool = poolInfo[_pid];
1509         if (block.number <= pool.lastRewardBlock) {
1510             return;
1511         }
1512         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1513         if (lpSupply == 0) {
1514             pool.lastRewardBlock = block.number;
1515             return;
1516         }
1517         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1518         uint256 AidReward = multiplier.mul(AidPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1519         Aid.mint(devaddr, AidReward.div(10));
1520         Aid.mint(address(this), AidReward);
1521         pool.accAidPerShare = pool.accAidPerShare.add(AidReward.mul(1e12).div(lpSupply));
1522         pool.lastRewardBlock = block.number;
1523     }
1524 
1525     // Deposit LP tokens to MasterChef for Aid allocation.
1526     function deposit(uint256 _pid, uint256 _amount) public {
1527         PoolInfo storage pool = poolInfo[_pid];
1528         UserInfo storage user = userInfo[_pid][msg.sender];
1529         updatePool(_pid);
1530         if (user.amount > 0) {
1531             uint256 pending = user.amount.mul(pool.accAidPerShare).div(1e12).sub(user.rewardDebt);
1532             safeAidTransfer(msg.sender, pending);
1533         }
1534         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1535         user.amount = user.amount.add(_amount);
1536         user.rewardDebt = user.amount.mul(pool.accAidPerShare).div(1e12);
1537         emit Deposit(msg.sender, _pid, _amount);
1538     }
1539 
1540     // Withdraw LP tokens from MasterChef.
1541     function withdraw(uint256 _pid, uint256 _amount) public {
1542         PoolInfo storage pool = poolInfo[_pid];
1543         UserInfo storage user = userInfo[_pid][msg.sender];
1544         require(user.amount >= _amount, "withdraw: not good");
1545         updatePool(_pid);
1546         uint256 pending = user.amount.mul(pool.accAidPerShare).div(1e12).sub(user.rewardDebt);
1547         safeAidTransfer(msg.sender, pending);
1548         user.amount = user.amount.sub(_amount);
1549         user.rewardDebt = user.amount.mul(pool.accAidPerShare).div(1e12);
1550         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1551         emit Withdraw(msg.sender, _pid, _amount);
1552     }
1553 
1554     // Withdraw without caring about rewards. EMERGENCY ONLY.
1555     function emergencyWithdraw(uint256 _pid) public {
1556         PoolInfo storage pool = poolInfo[_pid];
1557         UserInfo storage user = userInfo[_pid][msg.sender];
1558         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1559         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1560         user.amount = 0;
1561         user.rewardDebt = 0;
1562     }
1563     
1564 
1565     // Safe Aid transfer function, just in case if rounding error causes pool to not have enough Aids.
1566     function safeAidTransfer(address _to, uint256 _amount) internal {
1567         uint256 AidBal = Aid.balanceOf(address(this));
1568         if (_amount > AidBal) {
1569             Aid.transfer(_to, AidBal);
1570         } else {
1571             Aid.transfer(_to, _amount);
1572         }
1573     }
1574 
1575     // Update dev address by the previous dev.
1576     function dev(address _devaddr) public {
1577         require(msg.sender == devaddr, "dev: wut?");
1578         devaddr = _devaddr;
1579     }
1580 }