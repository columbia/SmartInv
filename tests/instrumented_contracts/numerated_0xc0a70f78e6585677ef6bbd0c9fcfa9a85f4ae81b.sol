1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.6.12;
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
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
287         (bool success, ) = recipient.call{ value: amount }("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain`call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         return _functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         return _functionCallWithValue(target, data, value, errorMessage);
347     }
348 
349     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
350         require(isContract(target), "Address: call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 /**
374  * @title SafeERC20
375  * @dev Wrappers around ERC20 operations that throw on failure (when the token
376  * contract returns false). Tokens that return no value (and instead revert or
377  * throw on failure) are also supported, non-reverting calls are assumed to be
378  * successful.
379  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
380  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
381  */
382 library SafeERC20 {
383     using SafeMath for uint256;
384     using Address for address;
385 
386     function safeTransfer(IERC20 token, address to, uint256 value) internal {
387         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
388     }
389 
390     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
391         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
392     }
393 
394     /**
395      * @dev Deprecated. This function has issues similar to the ones found in
396      * {IERC20-approve}, and its usage is discouraged.
397      *
398      * Whenever possible, use {safeIncreaseAllowance} and
399      * {safeDecreaseAllowance} instead.
400      */
401     function safeApprove(IERC20 token, address spender, uint256 value) internal {
402         // safeApprove should only be called when setting an initial allowance,
403         // or when resetting it to zero. To increase and decrease it, use
404         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
405         // solhint-disable-next-line max-line-length
406         require((value == 0) || (token.allowance(address(this), spender) == 0),
407             "SafeERC20: approve from non-zero to non-zero allowance"
408         );
409         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
410     }
411 
412     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
413         uint256 newAllowance = token.allowance(address(this), spender).add(value);
414         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
415     }
416 
417     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
418         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
419         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
420     }
421 
422     /**
423      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
424      * on the return value: the return value is optional (but if data is returned, it must not be false).
425      * @param token The token targeted by the call.
426      * @param data The call data (encoded using abi.encode or one of its variants).
427      */
428     function _callOptionalReturn(IERC20 token, bytes memory data) private {
429         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
430         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
431         // the target address contains contract code and also asserts for success in the low-level call.
432 
433         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
434         if (returndata.length > 0) { // Return data is optional
435             // solhint-disable-next-line max-line-length
436             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
437         }
438     }
439 }
440 
441 /**
442  * @dev Library for managing
443  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
444  * types.
445  *
446  * Sets have the following properties:
447  *
448  * - Elements are added, removed, and checked for existence in constant time
449  * (O(1)).
450  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
451  *
452  * ```
453  * contract Example {
454  *     // Add the library methods
455  *     using EnumerableSet for EnumerableSet.AddressSet;
456  *
457  *     // Declare a set state variable
458  *     EnumerableSet.AddressSet private mySet;
459  * }
460  * ```
461  *
462  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
463  * (`UintSet`) are supported.
464  */
465 library EnumerableSet {
466     // To implement this library for multiple types with as little code
467     // repetition as possible, we write it in terms of a generic Set type with
468     // bytes32 values.
469     // The Set implementation uses private functions, and user-facing
470     // implementations (such as AddressSet) are just wrappers around the
471     // underlying Set.
472     // This means that we can only create new EnumerableSets for types that fit
473     // in bytes32.
474 
475     struct Set {
476         // Storage of set values
477         bytes32[] _values;
478 
479         // Position of the value in the `values` array, plus 1 because index 0
480         // means a value is not in the set.
481         mapping (bytes32 => uint256) _indexes;
482     }
483 
484     /**
485      * @dev Add a value to a set. O(1).
486      *
487      * Returns true if the value was added to the set, that is if it was not
488      * already present.
489      */
490     function _add(Set storage set, bytes32 value) private returns (bool) {
491         if (!_contains(set, value)) {
492             set._values.push(value);
493             // The value is stored at length-1, but we add 1 to all indexes
494             // and use 0 as a sentinel value
495             set._indexes[value] = set._values.length;
496             return true;
497         } else {
498             return false;
499         }
500     }
501 
502     /**
503      * @dev Removes a value from a set. O(1).
504      *
505      * Returns true if the value was removed from the set, that is if it was
506      * present.
507      */
508     function _remove(Set storage set, bytes32 value) private returns (bool) {
509         // We read and store the value's index to prevent multiple reads from the same storage slot
510         uint256 valueIndex = set._indexes[value];
511 
512         if (valueIndex != 0) { // Equivalent to contains(set, value)
513             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
514             // the array, and then remove the last element (sometimes called as 'swap and pop').
515             // This modifies the order of the array, as noted in {at}.
516 
517             uint256 toDeleteIndex = valueIndex - 1;
518             uint256 lastIndex = set._values.length - 1;
519 
520             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
521             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
522 
523             bytes32 lastvalue = set._values[lastIndex];
524 
525             // Move the last value to the index where the value to delete is
526             set._values[toDeleteIndex] = lastvalue;
527             // Update the index for the moved value
528             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
529 
530             // Delete the slot where the moved value was stored
531             set._values.pop();
532 
533             // Delete the index for the deleted slot
534             delete set._indexes[value];
535 
536             return true;
537         } else {
538             return false;
539         }
540     }
541 
542     /**
543      * @dev Returns true if the value is in the set. O(1).
544      */
545     function _contains(Set storage set, bytes32 value) private view returns (bool) {
546         return set._indexes[value] != 0;
547     }
548 
549     /**
550      * @dev Returns the number of values on the set. O(1).
551      */
552     function _length(Set storage set) private view returns (uint256) {
553         return set._values.length;
554     }
555 
556     /**
557      * @dev Returns the value stored at position `index` in the set. O(1).
558      *
559      * Note that there are no guarantees on the ordering of values inside the
560      * array, and it may change when more values are added or removed.
561      *
562      * Requirements:
563      *
564      * - `index` must be strictly less than {length}.
565      */
566     function _at(Set storage set, uint256 index) private view returns (bytes32) {
567         require(set._values.length > index, "EnumerableSet: index out of bounds");
568         return set._values[index];
569     }
570 
571     // AddressSet
572 
573     struct AddressSet {
574         Set _inner;
575     }
576 
577     /**
578      * @dev Add a value to a set. O(1).
579      *
580      * Returns true if the value was added to the set, that is if it was not
581      * already present.
582      */
583     function add(AddressSet storage set, address value) internal returns (bool) {
584         return _add(set._inner, bytes32(uint256(value)));
585     }
586 
587     /**
588      * @dev Removes a value from a set. O(1).
589      *
590      * Returns true if the value was removed from the set, that is if it was
591      * present.
592      */
593     function remove(AddressSet storage set, address value) internal returns (bool) {
594         return _remove(set._inner, bytes32(uint256(value)));
595     }
596 
597     /**
598      * @dev Returns true if the value is in the set. O(1).
599      */
600     function contains(AddressSet storage set, address value) internal view returns (bool) {
601         return _contains(set._inner, bytes32(uint256(value)));
602     }
603 
604     /**
605      * @dev Returns the number of values in the set. O(1).
606      */
607     function length(AddressSet storage set) internal view returns (uint256) {
608         return _length(set._inner);
609     }
610 
611     /**
612      * @dev Returns the value stored at position `index` in the set. O(1).
613      *
614      * Note that there are no guarantees on the ordering of values inside the
615      * array, and it may change when more values are added or removed.
616      *
617      * Requirements:
618      *
619      * - `index` must be strictly less than {length}.
620      */
621     function at(AddressSet storage set, uint256 index) internal view returns (address) {
622         return address(uint256(_at(set._inner, index)));
623     }
624 
625 
626     // UintSet
627 
628     struct UintSet {
629         Set _inner;
630     }
631 
632     /**
633      * @dev Add a value to a set. O(1).
634      *
635      * Returns true if the value was added to the set, that is if it was not
636      * already present.
637      */
638     function add(UintSet storage set, uint256 value) internal returns (bool) {
639         return _add(set._inner, bytes32(value));
640     }
641 
642     /**
643      * @dev Removes a value from a set. O(1).
644      *
645      * Returns true if the value was removed from the set, that is if it was
646      * present.
647      */
648     function remove(UintSet storage set, uint256 value) internal returns (bool) {
649         return _remove(set._inner, bytes32(value));
650     }
651 
652     /**
653      * @dev Returns true if the value is in the set. O(1).
654      */
655     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
656         return _contains(set._inner, bytes32(value));
657     }
658 
659     /**
660      * @dev Returns the number of values on the set. O(1).
661      */
662     function length(UintSet storage set) internal view returns (uint256) {
663         return _length(set._inner);
664     }
665 
666     /**
667      * @dev Returns the value stored at position `index` in the set. O(1).
668      *
669      * Note that there are no guarantees on the ordering of values inside the
670      * array, and it may change when more values are added or removed.
671      *
672      * Requirements:
673      *
674      * - `index` must be strictly less than {length}.
675      */
676     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
677         return uint256(_at(set._inner, index));
678     }
679 }
680 
681 /**
682  * @dev Interface of the ERC165 standard, as defined in the
683  * https://eips.ethereum.org/EIPS/eip-165[EIP].
684  *
685  * Implementers can declare support of contract interfaces, which can then be
686  * queried by others ({ERC165Checker}).
687  *
688  * For an implementation, see {ERC165}.
689  */
690 interface IERC165 {
691     /**
692      * @dev Returns true if this contract implements the interface defined by
693      * `interfaceId`. See the corresponding
694      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
695      * to learn more about how these ids are created.
696      *
697      * This function call must use less than 30 000 gas.
698      */
699     function supportsInterface(bytes4 interfaceId) external view returns (bool);
700 }
701 
702 /**
703  * @dev Implementation of the {IERC165} interface.
704  *
705  * Contracts may inherit from this and call {_registerInterface} to declare
706  * their support of an interface.
707  */
708 abstract contract ERC165 is IERC165 {
709     /*
710      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
711      */
712     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
713 
714     /**
715      * @dev Mapping of interface ids to whether or not it's supported.
716      */
717     mapping(bytes4 => bool) private _supportedInterfaces;
718 
719     constructor () internal {
720         // Derived contracts need only register support for their own interfaces,
721         // we register support for ERC165 itself here
722         _registerInterface(_INTERFACE_ID_ERC165);
723     }
724 
725     /**
726      * @dev See {IERC165-supportsInterface}.
727      *
728      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
729      */
730     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
731         return _supportedInterfaces[interfaceId];
732     }
733 
734     /**
735      * @dev Registers the contract as an implementer of the interface defined by
736      * `interfaceId`. Support of the actual ERC165 interface is automatic and
737      * registering its interface id is not required.
738      *
739      * See {IERC165-supportsInterface}.
740      *
741      * Requirements:
742      *
743      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
744      */
745     function _registerInterface(bytes4 interfaceId) internal virtual {
746         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
747         _supportedInterfaces[interfaceId] = true;
748     }
749 }
750 
751 /**
752     @title ERC-1155 Multi Token Standard
753     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
754     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
755  */
756 interface IERC1155 is IERC165 {
757     /**
758         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
759         The `_operator` argument MUST be msg.sender.
760         The `_from` argument MUST be the address of the holder whose balance is decreased.
761         The `_to` argument MUST be the address of the recipient whose balance is increased.
762         The `_id` argument MUST be the token type being transferred.
763         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
764         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
765         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
766     */
767     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
768 
769     /**
770         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
771         The `_operator` argument MUST be msg.sender.
772         The `_from` argument MUST be the address of the holder whose balance is decreased.
773         The `_to` argument MUST be the address of the recipient whose balance is increased.
774         The `_ids` argument MUST be the list of tokens being transferred.
775         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
776         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
777         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
778     */
779     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
780 
781     /**
782         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
783     */
784     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
785 
786     /**
787         @dev MUST emit when the URI is updated for a token ID.
788         URIs are defined in RFC 3986.
789         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
790     */
791     event URI(string _value, uint256 indexed _id);
792 
793     /**
794         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
795         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
796         MUST revert if `_to` is the zero address.
797         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
798         MUST revert on any other error.
799         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
800         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
801         @param _from    Source address
802         @param _to      Target address
803         @param _id      ID of the token type
804         @param _value   Transfer amount
805         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
806     */
807     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
808 
809     /**
810         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
811         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
812         MUST revert if `_to` is the zero address.
813         MUST revert if length of `_ids` is not the same as length of `_values`.
814         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
815         MUST revert on any other error.
816         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
817         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
818         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
819         @param _from    Source address
820         @param _to      Target address
821         @param _ids     IDs of each token type (order and length must match _values array)
822         @param _values  Transfer amounts per token type (order and length must match _ids array)
823         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
824     */
825     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
826 
827     /**
828         @notice Get the balance of an account's Tokens.
829         @param _owner  The address of the token holder
830         @param _id     ID of the Token
831         @return        The _owner's balance of the Token type requested
832      */
833     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
834 
835     /**
836         @notice Get the balance of multiple account/token pairs
837         @param _owners The addresses of the token holders
838         @param _ids    ID of the Tokens
839         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
840      */
841     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
842 
843     /**
844         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
845         @dev MUST emit the ApprovalForAll event on success.
846         @param _operator  Address to add to the set of authorized operators
847         @param _approved  True if the operator is approved, false to revoke approval
848     */
849     function setApprovalForAll(address _operator, bool _approved) external;
850 
851     /**
852         @notice Queries the approval status of an operator for a given owner.
853         @param _owner     The owner of the Tokens
854         @param _operator  Address of authorized operator
855         @return           True if the operator is approved, false if not
856     */
857     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
858 }
859 
860 /**
861  * _Available since v3.1._
862  */
863 interface IERC1155Receiver is IERC165 {
864     /**
865         @dev Handles the receipt of a single ERC1155 token type. This function is
866         called at the end of a `safeTransferFrom` after the balance has been updated.
867         To accept the transfer, this must return
868         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
869         (i.e. 0xf23a6e61, or its own function selector).
870         @param operator The address which initiated the transfer (i.e. msg.sender)
871         @param from The address which previously owned the token
872         @param id The ID of the token being transferred
873         @param value The amount of tokens being transferred
874         @param data Additional data with no specified format
875         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
876     */
877     function onERC1155Received(
878         address operator,
879         address from,
880         uint256 id,
881         uint256 value,
882         bytes calldata data
883     )
884     external
885     returns(bytes4);
886 
887     /**
888         @dev Handles the receipt of a multiple ERC1155 token types. This function
889         is called at the end of a `safeBatchTransferFrom` after the balances have
890         been updated. To accept the transfer(s), this must return
891         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
892         (i.e. 0xbc197c81, or its own function selector).
893         @param operator The address which initiated the batch transfer (i.e. msg.sender)
894         @param from The address which previously owned the token
895         @param ids An array containing ids of each token being transferred (order and length must match values array)
896         @param values An array containing amounts of each token being transferred (order and length must match ids array)
897         @param data Additional data with no specified format
898         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
899     */
900     function onERC1155BatchReceived(
901         address operator,
902         address from,
903         uint256[] calldata ids,
904         uint256[] calldata values,
905         bytes calldata data
906     )
907     external
908     returns(bytes4);
909 }
910 
911 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
912     constructor() internal {
913         _registerInterface(
914             ERC1155Receiver(0).onERC1155Received.selector ^
915             ERC1155Receiver(0).onERC1155BatchReceived.selector
916         );
917     }
918 }
919 
920 /*
921  * @dev Provides information about the current execution context, including the
922  * sender of the transaction and its data. While these are generally available
923  * via msg.sender and msg.data, they should not be accessed in such a direct
924  * manner, since when dealing with GSN meta-transactions the account sending and
925  * paying for execution may not be the actual sender (as far as an application
926  * is concerned).
927  *
928  * This contract is only required for intermediate, library-like contracts.
929  */
930 abstract contract Context {
931     function _msgSender() internal view virtual returns (address payable) {
932         return msg.sender;
933     }
934 
935     function _msgData() internal view virtual returns (bytes memory) {
936         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
937         return msg.data;
938     }
939 }
940 
941 /**
942  * @dev Contract module which provides a basic access control mechanism, where
943  * there is an account (an owner) that can be granted exclusive access to
944  * specific functions.
945  *
946  * By default, the owner account will be the one that deploys the contract. This
947  * can later be changed with {transferOwnership}.
948  *
949  * This module is used through inheritance. It will make available the modifier
950  * `onlyOwner`, which can be applied to your functions to restrict their use to
951  * the owner.
952  */
953 contract Ownable is Context {
954     address private _owner;
955 
956     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
957 
958     /**
959      * @dev Initializes the contract setting the deployer as the initial owner.
960      */
961     constructor () internal {
962         address msgSender = _msgSender();
963         _owner = msgSender;
964         emit OwnershipTransferred(address(0), msgSender);
965     }
966 
967     /**
968      * @dev Returns the address of the current owner.
969      */
970     function owner() public view returns (address) {
971         return _owner;
972     }
973 
974     /**
975      * @dev Throws if called by any account other than the owner.
976      */
977     modifier onlyOwner() {
978         require(_owner == _msgSender(), "Ownable: caller is not the owner");
979         _;
980     }
981 
982     /**
983      * @dev Leaves the contract without owner. It will not be possible to call
984      * `onlyOwner` functions anymore. Can only be called by the current owner.
985      *
986      * NOTE: Renouncing ownership will leave the contract without an owner,
987      * thereby removing any functionality that is only available to the owner.
988      */
989     function renounceOwnership() public virtual onlyOwner {
990         emit OwnershipTransferred(_owner, address(0));
991         _owner = address(0);
992     }
993 
994     /**
995      * @dev Transfers ownership of the contract to a new account (`newOwner`).
996      * Can only be called by the current owner.
997      */
998     function transferOwnership(address newOwner) public virtual onlyOwner {
999         require(newOwner != address(0), "Ownable: new owner is the zero address");
1000         emit OwnershipTransferred(_owner, newOwner);
1001         _owner = newOwner;
1002     }
1003 }
1004 
1005 /**
1006  * @dev Implementation of the {IERC20} interface.
1007  *
1008  * This implementation is agnostic to the way tokens are created. This means
1009  * that a supply mechanism has to be added in a derived contract using {_mint}.
1010  * For a generic mechanism see {ERC20PresetMinterPauser}.
1011  *
1012  * TIP: For a detailed writeup see our guide
1013  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1014  * to implement supply mechanisms].
1015  *
1016  * We have followed general OpenZeppelin guidelines: functions revert instead
1017  * of returning `false` on failure. This behavior is nonetheless conventional
1018  * and does not conflict with the expectations of ERC20 applications.
1019  *
1020  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1021  * This allows applications to reconstruct the allowance for all accounts just
1022  * by listening to said events. Other implementations of the EIP may not emit
1023  * these events, as it isn't required by the specification.
1024  *
1025  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1026  * functions have been added to mitigate the well-known issues around setting
1027  * allowances. See {IERC20-approve}.
1028  */
1029 contract ERC20 is Context, IERC20 {
1030     using SafeMath for uint256;
1031     using Address for address;
1032 
1033     mapping (address => uint256) private _balances;
1034 
1035     mapping (address => mapping (address => uint256)) private _allowances;
1036 
1037     uint256 private _totalSupply;
1038 
1039     string private _name;
1040     string private _symbol;
1041     uint8 private _decimals;
1042 
1043     /**
1044      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1045      * a default value of 18.
1046      *
1047      * To select a different value for {decimals}, use {_setupDecimals}.
1048      *
1049      * All three of these values are immutable: they can only be set once during
1050      * construction.
1051      */
1052     constructor (string memory name, string memory symbol) public {
1053         _name = name;
1054         _symbol = symbol;
1055         _decimals = 18;
1056     }
1057 
1058     /**
1059      * @dev Returns the name of the token.
1060      */
1061     function name() public view returns (string memory) {
1062         return _name;
1063     }
1064 
1065     /**
1066      * @dev Returns the symbol of the token, usually a shorter version of the
1067      * name.
1068      */
1069     function symbol() public view returns (string memory) {
1070         return _symbol;
1071     }
1072 
1073     /**
1074      * @dev Returns the number of decimals used to get its user representation.
1075      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1076      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1077      *
1078      * Tokens usually opt for a value of 18, imitating the relationship between
1079      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1080      * called.
1081      *
1082      * NOTE: This information is only used for _display_ purposes: it in
1083      * no way affects any of the arithmetic of the contract, including
1084      * {IERC20-balanceOf} and {IERC20-transfer}.
1085      */
1086     function decimals() public view returns (uint8) {
1087         return _decimals;
1088     }
1089 
1090     /**
1091      * @dev See {IERC20-totalSupply}.
1092      */
1093     function totalSupply() public view override returns (uint256) {
1094         return _totalSupply;
1095     }
1096 
1097     /**
1098      * @dev See {IERC20-balanceOf}.
1099      */
1100     function balanceOf(address account) public view override returns (uint256) {
1101         return _balances[account];
1102     }
1103 
1104     /**
1105      * @dev See {IERC20-transfer}.
1106      *
1107      * Requirements:
1108      *
1109      * - `recipient` cannot be the zero address.
1110      * - the caller must have a balance of at least `amount`.
1111      */
1112     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1113         _transfer(_msgSender(), recipient, amount);
1114         return true;
1115     }
1116 
1117     /**
1118      * @dev See {IERC20-allowance}.
1119      */
1120     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1121         return _allowances[owner][spender];
1122     }
1123 
1124     /**
1125      * @dev See {IERC20-approve}.
1126      *
1127      * Requirements:
1128      *
1129      * - `spender` cannot be the zero address.
1130      */
1131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1132         _approve(_msgSender(), spender, amount);
1133         return true;
1134     }
1135 
1136     /**
1137      * @dev See {IERC20-transferFrom}.
1138      *
1139      * Emits an {Approval} event indicating the updated allowance. This is not
1140      * required by the EIP. See the note at the beginning of {ERC20};
1141      *
1142      * Requirements:
1143      * - `sender` and `recipient` cannot be the zero address.
1144      * - `sender` must have a balance of at least `amount`.
1145      * - the caller must have allowance for ``sender``'s tokens of at least
1146      * `amount`.
1147      */
1148     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1149         _transfer(sender, recipient, amount);
1150         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1151         return true;
1152     }
1153 
1154     /**
1155      * @dev Atomically increases the allowance granted to `spender` by the caller.
1156      *
1157      * This is an alternative to {approve} that can be used as a mitigation for
1158      * problems described in {IERC20-approve}.
1159      *
1160      * Emits an {Approval} event indicating the updated allowance.
1161      *
1162      * Requirements:
1163      *
1164      * - `spender` cannot be the zero address.
1165      */
1166     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1167         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1168         return true;
1169     }
1170 
1171     /**
1172      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1173      *
1174      * This is an alternative to {approve} that can be used as a mitigation for
1175      * problems described in {IERC20-approve}.
1176      *
1177      * Emits an {Approval} event indicating the updated allowance.
1178      *
1179      * Requirements:
1180      *
1181      * - `spender` cannot be the zero address.
1182      * - `spender` must have allowance for the caller of at least
1183      * `subtractedValue`.
1184      */
1185     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1187         return true;
1188     }
1189 
1190     /**
1191      * @dev Moves tokens `amount` from `sender` to `recipient`.
1192      *
1193      * This is internal function is equivalent to {transfer}, and can be used to
1194      * e.g. implement automatic token fees, slashing mechanisms, etc.
1195      *
1196      * Emits a {Transfer} event.
1197      *
1198      * Requirements:
1199      *
1200      * - `sender` cannot be the zero address.
1201      * - `recipient` cannot be the zero address.
1202      * - `sender` must have a balance of at least `amount`.
1203      */
1204     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1205         require(sender != address(0), "ERC20: transfer from the zero address");
1206         require(recipient != address(0), "ERC20: transfer to the zero address");
1207 
1208         _beforeTokenTransfer(sender, recipient, amount);
1209 
1210         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1211         _balances[recipient] = _balances[recipient].add(amount);
1212         emit Transfer(sender, recipient, amount);
1213     }
1214 
1215     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1216      * the total supply.
1217      *
1218      * Emits a {Transfer} event with `from` set to the zero address.
1219      *
1220      * Requirements
1221      *
1222      * - `to` cannot be the zero address.
1223      */
1224     function _mint(address account, uint256 amount) internal virtual {
1225         require(account != address(0), "ERC20: mint to the zero address");
1226 
1227         _beforeTokenTransfer(address(0), account, amount);
1228 
1229         _totalSupply = _totalSupply.add(amount);
1230         _balances[account] = _balances[account].add(amount);
1231         emit Transfer(address(0), account, amount);
1232     }
1233 
1234     /**
1235      * @dev Destroys `amount` tokens from `account`, reducing the
1236      * total supply.
1237      *
1238      * Emits a {Transfer} event with `to` set to the zero address.
1239      *
1240      * Requirements
1241      *
1242      * - `account` cannot be the zero address.
1243      * - `account` must have at least `amount` tokens.
1244      */
1245     function _burn(address account, uint256 amount) internal virtual {
1246         require(account != address(0), "ERC20: burn from the zero address");
1247 
1248         _beforeTokenTransfer(account, address(0), amount);
1249 
1250         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1251         _totalSupply = _totalSupply.sub(amount);
1252         emit Transfer(account, address(0), amount);
1253     }
1254 
1255     /**
1256      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1257      *
1258      * This is internal function is equivalent to `approve`, and can be used to
1259      * e.g. set automatic allowances for certain subsystems, etc.
1260      *
1261      * Emits an {Approval} event.
1262      *
1263      * Requirements:
1264      *
1265      * - `owner` cannot be the zero address.
1266      * - `spender` cannot be the zero address.
1267      */
1268     function _approve(address owner, address spender, uint256 amount) internal virtual {
1269         require(owner != address(0), "ERC20: approve from the zero address");
1270         require(spender != address(0), "ERC20: approve to the zero address");
1271 
1272         _allowances[owner][spender] = amount;
1273         emit Approval(owner, spender, amount);
1274     }
1275 
1276     /**
1277      * @dev Sets {decimals} to a value other than the default one of 18.
1278      *
1279      * WARNING: This function should only be called from the constructor. Most
1280      * applications that interact with token contracts will not expect
1281      * {decimals} to ever change, and may work incorrectly if it does.
1282      */
1283     function _setupDecimals(uint8 decimals_) internal {
1284         _decimals = decimals_;
1285     }
1286 
1287     /**
1288      * @dev Hook that is called before any transfer of tokens. This includes
1289      * minting and burning.
1290      *
1291      * Calling conditions:
1292      *
1293      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1294      * will be to transferred to `to`.
1295      * - when `from` is zero, `amount` tokens will be minted for `to`.
1296      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1297      * - `from` and `to` are never both zero.
1298      *
1299      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1300      */
1301     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1302 }
1303 
1304 contract GovernanceContract is Ownable {
1305 
1306     mapping(address => bool) public governanceContracts;
1307 
1308     event GovernanceContractAdded(address addr);
1309     event GovernanceContractRemoved(address addr);
1310 
1311     modifier onlyGovernanceContracts() {
1312         require(governanceContracts[msg.sender]);
1313         _;
1314     }
1315 
1316 
1317     function addAddressToGovernanceContract(address addr) onlyOwner public returns(bool success) {
1318         if (!governanceContracts[addr]) {
1319             governanceContracts[addr] = true;
1320             emit GovernanceContractAdded(addr);
1321             success = true;
1322         }
1323     }
1324 
1325 
1326     function removeAddressFromGovernanceContract(address addr) onlyOwner public returns(bool success) {
1327         if (governanceContracts[addr]) {
1328             governanceContracts[addr] = false;
1329             emit GovernanceContractRemoved(addr);
1330             success = true;
1331         }
1332     }
1333 }
1334 
1335 contract MilkyWayToken is ERC20("MilkyWay Token by SpaceSwap v2", "MILK2"), GovernanceContract {
1336 
1337     uint256 private _totalBurned;
1338 
1339     /**
1340      * @dev See {IERC20-totalSupply}.
1341      */
1342     function totalBurned() public view returns (uint256) {
1343         return _totalBurned;
1344     }
1345 
1346 
1347     /// @notice Creates `_amount` token to `_to`. Must only be called by the  Governance Contracts
1348     function mint(address _to, uint256 _amount) public onlyGovernanceContracts virtual returns (bool) {
1349         _mint(_to, _amount);
1350         _moveDelegates(address(0), _delegates[_to], _amount);
1351         return true;
1352     }
1353 
1354     /// @notice Creates `_amount` token to `_to`. Must only be called by the Governance Contracts
1355     function burn(address _to, uint256 _amount) public onlyGovernanceContracts virtual returns (bool) {
1356         _burn(_to, _amount);
1357         _totalBurned = _totalBurned.add(_amount);
1358         _moveDelegates(_delegates[_to], address(0), _amount);
1359         return true;
1360     }
1361 
1362     // Copied and modified from YAM code:
1363     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1364     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1365     // Which is copied and modified from COMPOUND:
1366     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1367 
1368     // @notice A record of each accounts delegate
1369     mapping (address => address) internal _delegates;
1370 
1371     /// @notice A checkpoint for marking number of votes from a given block
1372     struct Checkpoint {
1373         uint32 fromBlock;
1374         uint256 votes;
1375     }
1376 
1377     /// @notice A record of votes checkpoints for each account, by index
1378     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1379 
1380     /// @notice The number of checkpoints for each account
1381     mapping (address => uint32) public numCheckpoints;
1382 
1383     /// @notice The EIP-712 typehash for the contract's domain
1384     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1385 
1386     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1387     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1388 
1389     /// @notice A record of states for signing / validating signatures
1390     mapping (address => uint) public nonces;
1391 
1392     /// @notice An event that's emitted when an account changes its delegate
1393     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1394 
1395     /// @notice An event that's emitted when a delegate account's vote balance changes
1396     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1397 
1398     /**
1399      * @notice Delegate votes from `msg.sender` to `delegatee`
1400      * @param delegator The address to get delegatee for
1401      */
1402     function delegates(address delegator)
1403     external
1404     view
1405     returns (address)
1406     {
1407         return _delegates[delegator];
1408     }
1409 
1410     /**
1411      * @notice Delegate votes from `msg.sender` to `delegatee`
1412      * @param delegatee The address to delegate votes to
1413      */
1414     function delegate(address delegatee) external {
1415         return _delegate(msg.sender, delegatee);
1416     }
1417 
1418     /**
1419      * @notice Delegates votes from signatory to `delegatee`
1420      * @param delegatee The address to delegate votes to
1421      * @param nonce The contract state required to match the signature
1422      * @param expiry The time at which to expire the signature
1423      * @param v The recovery byte of the signature
1424      * @param r Half of the ECDSA signature pair
1425      * @param s Half of the ECDSA signature pair
1426      */
1427     function delegateBySig(
1428         address delegatee,
1429         uint nonce,
1430         uint expiry,
1431         uint8 v,
1432         bytes32 r,
1433         bytes32 s
1434     )
1435     external
1436     {
1437         bytes32 domainSeparator = keccak256(
1438             abi.encode(
1439                 DOMAIN_TYPEHASH,
1440                 keccak256(bytes(name())),
1441                 getChainId(),
1442                 address(this)
1443             )
1444         );
1445 
1446         bytes32 structHash = keccak256(
1447             abi.encode(
1448                 DELEGATION_TYPEHASH,
1449                 delegatee,
1450                 nonce,
1451                 expiry
1452             )
1453         );
1454 
1455         bytes32 digest = keccak256(
1456             abi.encodePacked(
1457                 "\x19\x01",
1458                 domainSeparator,
1459                 structHash
1460             )
1461         );
1462 
1463         address signatory = ecrecover(digest, v, r, s);
1464         require(signatory != address(0), "MILKYWAY::delegateBySig: invalid signature");
1465         require(nonce == nonces[signatory]++, "MILKYWAY::delegateBySig: invalid nonce");
1466         require(now <= expiry, "MILKYWAY::delegateBySig: signature expired");
1467         return _delegate(signatory, delegatee);
1468     }
1469 
1470     /**
1471      * @notice Gets the current votes balance for `account`
1472      * @param account The address to get votes balance
1473      * @return The number of current votes for `account`
1474      */
1475     function getCurrentVotes(address account)
1476     external
1477     view
1478     returns (uint256)
1479     {
1480         uint32 nCheckpoints = numCheckpoints[account];
1481         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1482     }
1483 
1484     /**
1485      * @notice Determine the prior number of votes for an account as of a block number
1486      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1487      * @param account The address of the account to check
1488      * @param blockNumber The block number to get the vote balance at
1489      * @return The number of votes the account had as of the given block
1490      */
1491     function getPriorVotes(address account, uint blockNumber)
1492     external
1493     view
1494     returns (uint256)
1495     {
1496         require(blockNumber < block.number, "MILKYWAY::getPriorVotes: not yet determined");
1497 
1498         uint32 nCheckpoints = numCheckpoints[account];
1499         if (nCheckpoints == 0) {
1500             return 0;
1501         }
1502 
1503         // First check most recent balance
1504         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1505             return checkpoints[account][nCheckpoints - 1].votes;
1506         }
1507 
1508         // Next check implicit zero balance
1509         if (checkpoints[account][0].fromBlock > blockNumber) {
1510             return 0;
1511         }
1512 
1513         uint32 lower = 0;
1514         uint32 upper = nCheckpoints - 1;
1515         while (upper > lower) {
1516             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1517             Checkpoint memory cp = checkpoints[account][center];
1518             if (cp.fromBlock == blockNumber) {
1519                 return cp.votes;
1520             } else if (cp.fromBlock < blockNumber) {
1521                 lower = center;
1522             } else {
1523                 upper = center - 1;
1524             }
1525         }
1526         return checkpoints[account][lower].votes;
1527     }
1528 
1529     function _delegate(address delegator, address delegatee) internal {
1530         address currentDelegate = _delegates[delegator];
1531         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MILKYWAY (not scaled);
1532         _delegates[delegator] = delegatee;
1533 
1534         emit DelegateChanged(delegator, currentDelegate, delegatee);
1535 
1536         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1537     }
1538 
1539     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1540         if (srcRep != dstRep && amount > 0) {
1541             if (srcRep != address(0)) {
1542                 // decrease old representative
1543                 uint32 srcRepNum = numCheckpoints[srcRep];
1544                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1545                 uint256 srcRepNew = srcRepOld.sub(amount);
1546                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1547             }
1548 
1549             if (dstRep != address(0)) {
1550                 // increase new representative
1551                 uint32 dstRepNum = numCheckpoints[dstRep];
1552                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1553                 uint256 dstRepNew = dstRepOld.add(amount);
1554                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1555             }
1556         }
1557     }
1558 
1559     function _writeCheckpoint(
1560         address delegatee,
1561         uint32 nCheckpoints,
1562         uint256 oldVotes,
1563         uint256 newVotes
1564     )
1565     internal
1566     {
1567         uint32 blockNumber = safe32(block.number, "MILKYWAY::_writeCheckpoint: block number exceeds 32 bits");
1568 
1569         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1570             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1571         } else {
1572             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1573             numCheckpoints[delegatee] = nCheckpoints + 1;
1574         }
1575 
1576         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1577     }
1578 
1579     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1580         require(n < 2**32, errorMessage);
1581         return uint32(n);
1582     }
1583 
1584     function getChainId() internal pure returns (uint) {
1585         uint256 chainId;
1586         assembly { chainId := chainid() }
1587         return chainId;
1588     }
1589 }
1590 
1591 
1592 /**
1593 // Note that it's ownable and the owner wields tremendous power. The ownership
1594 // will be transferred to a governance smart contract once MILKYWAY is sufficiently
1595 // distributed and the community can show to govern itself.
1596 //
1597 // Have fun reading it. Hopefully it's bug-free. God bless.
1598 */
1599 contract GalaxyNFT is Ownable, ERC1155Receiver {
1600     using SafeMath for uint256;
1601     using SafeERC20 for IERC20;
1602 
1603 
1604 
1605     // Info of each user.
1606     struct UserInfo {
1607         uint256 amount;     // How many NFT tokens the user has provided.
1608         uint256 rewardDebt; // Reward debt. See explanation below.
1609     }
1610 
1611     // Info of each pool.
1612     struct PoolInfo {
1613         uint256 nftId;           // NFT ID
1614         uint256 allocPoint;       // How many allocation points assigned to this pool. MILK2s to distribute per block.
1615         uint256 lastRewardBlock;  // Last block number that MILK2s distribution occurs.
1616         uint256 accMilkPerShare; // Accumulated MILK2s per share, times 1e12. See below.
1617     }
1618 
1619     // The MILKYWAY_Token!
1620     MilkyWayToken public milk;
1621 
1622     IERC1155 public NFTToken;
1623 
1624     IERC20 public lpToken;
1625 
1626     // Dev address.
1627     address public devAddr;
1628 
1629     // Distribution address.
1630     address public distributor;
1631 
1632     // The block number when MILK2 mining starts.
1633     uint256 public startBlock;
1634 
1635     uint256 internal milkPerBlock = 250; // 2.5
1636 
1637     // Info of each pool.
1638     PoolInfo[] public poolInfo;
1639 
1640     // Info of each user that stakes NFT tokens.
1641     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1642 
1643     // Total allocation points. Must be the sum of all allocation points in all pools.
1644     uint256 public totalAllocPoint = 0;
1645 
1646     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1647     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1648     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1649 
1650 
1651     constructor(MilkyWayToken _milk, IERC1155 _nft, address _devAddr, address _distributor, uint256 _startBlock, IERC20 _lpToken) public{
1652         milk = _milk;
1653         NFTToken = _nft;
1654         devAddr = _devAddr;
1655         distributor = _distributor;
1656         startBlock = _startBlock;
1657         lpToken = _lpToken;
1658     }
1659 
1660 
1661     function setMilkPerBlock(uint256 _newAmount) public onlyOwner{
1662         milkPerBlock = _newAmount;
1663     }
1664 
1665 
1666     // view length of liquidity pools
1667     function poolLength() external view returns (uint256) {
1668         return poolInfo.length;
1669     }
1670 
1671 
1672     function approvalNFTTransfers() public onlyOwner {
1673         NFTToken.setApprovalForAll(address(this), true);
1674     }
1675 
1676 
1677     // Add a new NFT to the pool. Can only be called by the owner.
1678     // XXX DO NOT add the same NFT token more than once. Rewards will be messed up if you do.
1679     function addFarmingToken(uint256 _allocPoint, uint256 _nftId, bool _withUpdate) public onlyOwner {
1680         if (_withUpdate) {
1681             massUpdatePools();
1682         }
1683         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1684         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1685         poolInfo.push(PoolInfo({nftId: _nftId,
1686                                 allocPoint: _allocPoint,
1687                                 lastRewardBlock: lastRewardBlock,
1688                                 accMilkPerShare: 0
1689         }));
1690     }
1691 
1692 
1693     // Update the given pool's MILK2 allocation point. Can only be called by the owner.
1694     function setFarmingToken(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1695         if (_withUpdate) {
1696             massUpdatePools();
1697         }
1698         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1699         poolInfo[_pid].allocPoint = _allocPoint;
1700     }
1701 
1702 
1703     // Return reward multiplier over the given _from to _to block.
1704     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1705         return _to.sub(_from).mul(milkPerBlock);
1706     }
1707 
1708 
1709     // View current block reward in MILK2s
1710     function getCurrentBlockReward() public view returns (uint256) {
1711         return milkPerBlock;
1712     }
1713 
1714 
1715     // View function to see pending MILK2s on frontend.
1716     function pendingMilk(uint256 _pid, address _user) external view returns (uint256) {
1717         PoolInfo storage pool = poolInfo[_pid];
1718         UserInfo storage user = userInfo[_pid][_user];
1719         uint256 accMilkPerShare = pool.accMilkPerShare;
1720         uint256 NFTSupply = NFTToken.balanceOf(address(this), pool.nftId);
1721 
1722         if (block.number > pool.lastRewardBlock && NFTSupply != 0) {
1723             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1724             uint256 milkReward = (multiplier.mul(1e16)).mul(pool.allocPoint).div(totalAllocPoint);
1725             accMilkPerShare = accMilkPerShare.add(milkReward.mul(1e12).div(NFTSupply));
1726         }
1727         return user.amount.mul(accMilkPerShare).div(1e12).sub(user.rewardDebt);
1728     }
1729 
1730 
1731     // Update reward variables for all pools. Be careful of gas spending!
1732     function massUpdatePools() public {
1733         uint256 length = poolInfo.length;
1734         for (uint256 pid = 0; pid < length; ++pid) {
1735             updatePool(pid);
1736         }
1737     }
1738 
1739 
1740     // Update reward variables of the given pool to be up-to-date.
1741     function updatePool(uint256 _pid) public {
1742         PoolInfo storage pool = poolInfo[_pid];
1743 
1744         if (block.number <= pool.lastRewardBlock) {
1745             return;
1746         }
1747         uint256 NFTSupply = NFTToken.balanceOf(address(this), pool.nftId);
1748         if (NFTSupply == 0) {
1749             pool.lastRewardBlock = block.number;
1750             return;
1751         }
1752         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1753         uint256 milkReward = multiplier.mul(1e16).mul(pool.allocPoint).div(totalAllocPoint);
1754         milk.mint(devAddr, milkReward.mul(3).div(100)); // 3% developers
1755         milk.mint(distributor, milkReward.div(100)); // 1% shakeHolders
1756         milk.mint(address(this), milkReward);
1757         pool.accMilkPerShare = pool.accMilkPerShare.add(milkReward.mul(1e12).div(NFTSupply));
1758         pool.lastRewardBlock = block.number;
1759     }
1760 
1761 
1762     // Deposit NFT tokens to Interstellar for MILK allocation.
1763     function depositFarmingToken(uint256 _pid, uint256 _amount) public {
1764         require(lpToken.balanceOf(msg.sender) > 0, "Insufficient LPtoken balance");
1765         PoolInfo storage pool = poolInfo[_pid];
1766         UserInfo storage user = userInfo[_pid][msg.sender];
1767         updatePool(_pid);
1768 
1769         if (user.amount > 0) {
1770             uint256 pending = user.amount.mul(pool.accMilkPerShare).div(1e12).sub(user.rewardDebt);
1771             safeMilkTransfer(msg.sender, pending);
1772         }
1773 
1774         NFTToken.safeTransferFrom(address(msg.sender), address(this), pool.nftId, _amount, ""); //
1775         user.amount = user.amount.add(_amount);
1776         user.rewardDebt = user.amount.mul(pool.accMilkPerShare).div(1e12);
1777         emit Deposit(msg.sender, _pid, _amount);
1778     }
1779 
1780     // Withdraw NFT tokens from Interstellar.
1781     function withdrawFarmingToken(uint256 _pid, uint256 _amount) public {
1782         require(lpToken.balanceOf(msg.sender) > 0, "Insufficient LPtoken balance");
1783         PoolInfo storage pool = poolInfo[_pid];
1784         UserInfo storage user = userInfo[_pid][msg.sender];
1785         require(user.amount >= _amount, "withdraw: not good");
1786         updatePool(_pid);
1787         uint256 pending = user.amount.mul(pool.accMilkPerShare).div(1e12).sub(user.rewardDebt);
1788         safeMilkTransfer(msg.sender, pending);
1789         user.amount = user.amount.sub(_amount);
1790         user.rewardDebt = user.amount.mul(pool.accMilkPerShare).div(1e12);
1791         NFTToken.safeTransferFrom(address(this), address(msg.sender), pool.nftId, _amount, "");
1792     emit Withdraw(msg.sender, _pid, _amount);
1793     }
1794 
1795     // Withdraw without caring about rewards. EMERGENCY ONLY.
1796     function emergencyWithdrawFarmingToken(uint256 _pid) public {
1797         PoolInfo storage pool = poolInfo[_pid];
1798         UserInfo storage user = userInfo[_pid][msg.sender];
1799         NFTToken.safeTransferFrom(address(this), address(msg.sender), pool.nftId, user.amount, "");
1800         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1801         user.amount = 0;
1802         user.rewardDebt = 0;
1803     }
1804 
1805 
1806     // Safe milk2 transfer function, just in case if rounding error causes pool to not have enough MILK2s.
1807     function safeMilkTransfer(address _to, uint256 _amount) internal {
1808         uint256 milkBal = milk.balanceOf(address(this));
1809         if (_amount > milkBal) {
1810             milk.transfer(_to, milkBal);
1811         } else {
1812             milk.transfer(_to, _amount);
1813         }
1814     }
1815 
1816 
1817     // Update dev address by the previous dev.
1818     function setDevAddress(address _devAddr) public {
1819         require(msg.sender == devAddr, "dev: wut?");
1820         devAddr = _devAddr;
1821     }
1822 
1823 
1824     // Update distributor address by the previous dev.
1825     function updateDistributor(address _distributor) public {
1826         require(msg.sender == devAddr, "dev: wut?");
1827         distributor = _distributor;
1828     }
1829 
1830 
1831     function onERC1155Received(address, address, uint256, uint256, bytes calldata) external override returns (bytes4) {
1832         return IERC1155Receiver.onERC1155Received.selector;
1833     }
1834 
1835 
1836     function onERC1155BatchReceived(address, address, uint256[] calldata, uint256[] calldata , bytes calldata) external override returns (bytes4) {
1837         return IERC1155Receiver.onERC1155BatchReceived.selector;
1838     }
1839 
1840 }