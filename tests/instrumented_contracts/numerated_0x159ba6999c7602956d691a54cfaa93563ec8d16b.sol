1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.6.0;
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 pragma solidity ^0.6.0;
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
235 pragma solidity ^0.6.2;
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
259         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
260         // for accounts without code, i.e. `keccak256('')`
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { codehash := extcodehash(account) }
265         return (codehash != accountHash && codehash != 0x0);
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
288         (bool success, ) = recipient.call{ value: amount }("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain`call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
321         return _functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but also transferring `value` wei to `target`.
327      *
328      * Requirements:
329      *
330      * - the calling contract must have an ETH balance of at least `value`.
331      * - the called Solidity function must be `payable`.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341      * with `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         return _functionCallWithValue(target, data, value, errorMessage);
348     }
349 
350     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
351         require(isContract(target), "Address: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
355         if (success) {
356             return returndata;
357         } else {
358             // Look for revert reason and bubble it up if present
359             if (returndata.length > 0) {
360                 // The easiest way to bubble the revert reason is using memory via assembly
361 
362                 // solhint-disable-next-line no-inline-assembly
363                 assembly {
364                     let returndata_size := mload(returndata)
365                     revert(add(32, returndata), returndata_size)
366                 }
367             } else {
368                 revert(errorMessage);
369             }
370         }
371     }
372 }
373 
374 pragma solidity ^0.6.0;
375 /**
376  * @title SafeERC20
377  * @dev Wrappers around ERC20 operations that throw on failure (when the token
378  * contract returns false). Tokens that return no value (and instead revert or
379  * throw on failure) are also supported, non-reverting calls are assumed to be
380  * successful.
381  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
382  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
383  */
384 library SafeERC20 {
385     using SafeMath for uint256;
386     using Address for address;
387 
388     function safeTransfer(IERC20 token, address to, uint256 value) internal {
389         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
390     }
391 
392     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
393         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
394     }
395 
396     /**
397      * @dev Deprecated. This function has issues similar to the ones found in
398      * {IERC20-approve}, and its usage is discouraged.
399      *
400      * Whenever possible, use {safeIncreaseAllowance} and
401      * {safeDecreaseAllowance} instead.
402      */
403     function safeApprove(IERC20 token, address spender, uint256 value) internal {
404         // safeApprove should only be called when setting an initial allowance,
405         // or when resetting it to zero. To increase and decrease it, use
406         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
407         // solhint-disable-next-line max-line-length
408         require((value == 0) || (token.allowance(address(this), spender) == 0),
409             "SafeERC20: approve from non-zero to non-zero allowance"
410         );
411         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
412     }
413 
414     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
415         uint256 newAllowance = token.allowance(address(this), spender).add(value);
416         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
417     }
418 
419     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
420         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
421         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
422     }
423 
424     /**
425      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
426      * on the return value: the return value is optional (but if data is returned, it must not be false).
427      * @param token The token targeted by the call.
428      * @param data The call data (encoded using abi.encode or one of its variants).
429      */
430     function _callOptionalReturn(IERC20 token, bytes memory data) private {
431         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
432         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
433         // the target address contains contract code and also asserts for success in the low-level call.
434 
435         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
436         if (returndata.length > 0) { // Return data is optional
437             // solhint-disable-next-line max-line-length
438             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
439         }
440     }
441 }
442 
443 pragma solidity ^0.6.0;
444 /**
445  * @dev Library for managing
446  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
447  * types.
448  *
449  * Sets have the following properties:
450  *
451  * - Elements are added, removed, and checked for existence in constant time
452  * (O(1)).
453  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
454  *
455  * ```
456  * contract Example {
457  *     // Add the library methods
458  *     using EnumerableSet for EnumerableSet.AddressSet;
459  *
460  *     // Declare a set state variable
461  *     EnumerableSet.AddressSet private mySet;
462  * }
463  * ```
464  *
465  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
466  * (`UintSet`) are supported.
467  */
468 library EnumerableSet {
469     // To implement this library for multiple types with as little code
470     // repetition as possible, we write it in terms of a generic Set type with
471     // bytes32 values.
472     // The Set implementation uses private functions, and user-facing
473     // implementations (such as AddressSet) are just wrappers around the
474     // underlying Set.
475     // This means that we can only create new EnumerableSets for types that fit
476     // in bytes32.
477 
478     struct Set {
479         // Storage of set values
480         bytes32[] _values;
481 
482         // Position of the value in the `values` array, plus 1 because index 0
483         // means a value is not in the set.
484         mapping (bytes32 => uint256) _indexes;
485     }
486 
487     /**
488      * @dev Add a value to a set. O(1).
489      *
490      * Returns true if the value was added to the set, that is if it was not
491      * already present.
492      */
493     function _add(Set storage set, bytes32 value) private returns (bool) {
494         if (!_contains(set, value)) {
495             set._values.push(value);
496             // The value is stored at length-1, but we add 1 to all indexes
497             // and use 0 as a sentinel value
498             set._indexes[value] = set._values.length;
499             return true;
500         } else {
501             return false;
502         }
503     }
504 
505     /**
506      * @dev Removes a value from a set. O(1).
507      *
508      * Returns true if the value was removed from the set, that is if it was
509      * present.
510      */
511     function _remove(Set storage set, bytes32 value) private returns (bool) {
512         // We read and store the value's index to prevent multiple reads from the same storage slot
513         uint256 valueIndex = set._indexes[value];
514 
515         if (valueIndex != 0) { // Equivalent to contains(set, value)
516             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
517             // the array, and then remove the last element (sometimes called as 'swap and pop').
518             // This modifies the order of the array, as noted in {at}.
519 
520             uint256 toDeleteIndex = valueIndex - 1;
521             uint256 lastIndex = set._values.length - 1;
522 
523             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
524             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
525 
526             bytes32 lastvalue = set._values[lastIndex];
527 
528             // Move the last value to the index where the value to delete is
529             set._values[toDeleteIndex] = lastvalue;
530             // Update the index for the moved value
531             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
532 
533             // Delete the slot where the moved value was stored
534             set._values.pop();
535 
536             // Delete the index for the deleted slot
537             delete set._indexes[value];
538 
539             return true;
540         } else {
541             return false;
542         }
543     }
544 
545     /**
546      * @dev Returns true if the value is in the set. O(1).
547      */
548     function _contains(Set storage set, bytes32 value) private view returns (bool) {
549         return set._indexes[value] != 0;
550     }
551 
552     /**
553      * @dev Returns the number of values on the set. O(1).
554      */
555     function _length(Set storage set) private view returns (uint256) {
556         return set._values.length;
557     }
558 
559     /**
560      * @dev Returns the value stored at position `index` in the set. O(1).
561      *
562      * Note that there are no guarantees on the ordering of values inside the
563      * array, and it may change when more values are added or removed.
564      *
565      * Requirements:
566      *
567      * - `index` must be strictly less than {length}.
568      */
569     function _at(Set storage set, uint256 index) private view returns (bytes32) {
570         require(set._values.length > index, "EnumerableSet: index out of bounds");
571         return set._values[index];
572     }
573 
574     // AddressSet
575 
576     struct AddressSet {
577         Set _inner;
578     }
579 
580     /**
581      * @dev Add a value to a set. O(1).
582      *
583      * Returns true if the value was added to the set, that is if it was not
584      * already present.
585      */
586     function add(AddressSet storage set, address value) internal returns (bool) {
587         return _add(set._inner, bytes32(uint256(value)));
588     }
589 
590     /**
591      * @dev Removes a value from a set. O(1).
592      *
593      * Returns true if the value was removed from the set, that is if it was
594      * present.
595      */
596     function remove(AddressSet storage set, address value) internal returns (bool) {
597         return _remove(set._inner, bytes32(uint256(value)));
598     }
599 
600     /**
601      * @dev Returns true if the value is in the set. O(1).
602      */
603     function contains(AddressSet storage set, address value) internal view returns (bool) {
604         return _contains(set._inner, bytes32(uint256(value)));
605     }
606 
607     /**
608      * @dev Returns the number of values in the set. O(1).
609      */
610     function length(AddressSet storage set) internal view returns (uint256) {
611         return _length(set._inner);
612     }
613 
614     /**
615      * @dev Returns the value stored at position `index` in the set. O(1).
616      *
617      * Note that there are no guarantees on the ordering of values inside the
618      * array, and it may change when more values are added or removed.
619      *
620      * Requirements:
621      *
622      * - `index` must be strictly less than {length}.
623      */
624     function at(AddressSet storage set, uint256 index) internal view returns (address) {
625         return address(uint256(_at(set._inner, index)));
626     }
627 
628 
629     // UintSet
630 
631     struct UintSet {
632         Set _inner;
633     }
634 
635     /**
636      * @dev Add a value to a set. O(1).
637      *
638      * Returns true if the value was added to the set, that is if it was not
639      * already present.
640      */
641     function add(UintSet storage set, uint256 value) internal returns (bool) {
642         return _add(set._inner, bytes32(value));
643     }
644 
645     /**
646      * @dev Removes a value from a set. O(1).
647      *
648      * Returns true if the value was removed from the set, that is if it was
649      * present.
650      */
651     function remove(UintSet storage set, uint256 value) internal returns (bool) {
652         return _remove(set._inner, bytes32(value));
653     }
654 
655     /**
656      * @dev Returns true if the value is in the set. O(1).
657      */
658     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
659         return _contains(set._inner, bytes32(value));
660     }
661 
662     /**
663      * @dev Returns the number of values on the set. O(1).
664      */
665     function length(UintSet storage set) internal view returns (uint256) {
666         return _length(set._inner);
667     }
668 
669     /**
670      * @dev Returns the value stored at position `index` in the set. O(1).
671      *
672      * Note that there are no guarantees on the ordering of values inside the
673      * array, and it may change when more values are added or removed.
674      *
675      * Requirements:
676      *
677      * - `index` must be strictly less than {length}.
678      */
679     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
680         return uint256(_at(set._inner, index));
681     }
682 }
683 
684 pragma solidity ^0.6.0;
685 /*
686  * @dev Provides information about the current execution context, including the
687  * sender of the transaction and its data. While these are generally available
688  * via msg.sender and msg.data, they should not be accessed in such a direct
689  * manner, since when dealing with GSN meta-transactions the account sending and
690  * paying for execution may not be the actual sender (as far as an application
691  * is concerned).
692  *
693  * This contract is only required for intermediate, library-like contracts.
694  */
695 abstract contract Context {
696     function _msgSender() internal view virtual returns (address payable) {
697         return msg.sender;
698     }
699 
700     function _msgData() internal view virtual returns (bytes memory) {
701         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
702         return msg.data;
703     }
704 }
705 
706 pragma solidity ^0.6.0;
707 /**
708  * @dev Contract module which provides a basic access control mechanism, where
709  * there is an account (an owner) that can be granted exclusive access to
710  * specific functions.
711  *
712  * By default, the owner account will be the one that deploys the contract. This
713  * can later be changed with {transferOwnership}.
714  *
715  * This module is used through inheritance. It will make available the modifier
716  * `onlyOwner`, which can be applied to your functions to restrict their use to
717  * the owner.
718  */
719 contract Ownable is Context {
720     address private _owner;
721 
722     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
723 
724     /**
725      * @dev Initializes the contract setting the deployer as the initial owner.
726      */
727     constructor () internal {
728         address msgSender = _msgSender();
729         _owner = msgSender;
730         emit OwnershipTransferred(address(0), msgSender);
731     }
732 
733     /**
734      * @dev Returns the address of the current owner.
735      */
736     function owner() public view returns (address) {
737         return _owner;
738     }
739 
740     /**
741      * @dev Throws if called by any account other than the owner.
742      */
743     modifier onlyOwner() {
744         require(_owner == _msgSender(), "Ownable: caller is not the owner");
745         _;
746     }
747 
748     /**
749      * @dev Leaves the contract without owner. It will not be possible to call
750      * `onlyOwner` functions anymore. Can only be called by the current owner.
751      *
752      * NOTE: Renouncing ownership will leave the contract without an owner,
753      * thereby removing any functionality that is only available to the owner.
754      */
755     function renounceOwnership() public virtual onlyOwner {
756         emit OwnershipTransferred(_owner, address(0));
757         _owner = address(0);
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (`newOwner`).
762      * Can only be called by the current owner.
763      */
764     function transferOwnership(address newOwner) public virtual onlyOwner {
765         require(newOwner != address(0), "Ownable: new owner is the zero address");
766         emit OwnershipTransferred(_owner, newOwner);
767         _owner = newOwner;
768     }
769 }
770 
771 pragma solidity ^0.6.0;
772 /**
773  * @dev Implementation of the {IERC20} interface.
774  *
775  * This implementation is agnostic to the way tokens are created. This means
776  * that a supply mechanism has to be added in a derived contract using {_mint}.
777  * For a generic mechanism see {ERC20PresetMinterPauser}.
778  *
779  * TIP: For a detailed writeup see our guide
780  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
781  * to implement supply mechanisms].
782  *
783  * We have followed general OpenZeppelin guidelines: functions revert instead
784  * of returning `false` on failure. This behavior is nonetheless conventional
785  * and does not conflict with the expectations of ERC20 applications.
786  *
787  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
788  * This allows applications to reconstruct the allowance for all accounts just
789  * by listening to said events. Other implementations of the EIP may not emit
790  * these events, as it isn't required by the specification.
791  *
792  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
793  * functions have been added to mitigate the well-known issues around setting
794  * allowances. See {IERC20-approve}.
795  */
796 contract ERC20 is Context, IERC20 {
797     using SafeMath for uint256;
798     using Address for address;
799 
800     mapping (address => uint256) private _balances;
801 
802     mapping (address => mapping (address => uint256)) private _allowances;
803 
804     uint256 private _totalSupply;
805 
806     string private _name;
807     string private _symbol;
808     uint8 private _decimals;
809 
810     /**
811      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
812      * a default value of 18.
813      *
814      * To select a different value for {decimals}, use {_setupDecimals}.
815      *
816      * All three of these values are immutable: they can only be set once during
817      * construction.
818      */
819     constructor (string memory name, string memory symbol) public {
820         _name = name;
821         _symbol = symbol;
822         _decimals = 18;
823     }
824 
825     /**
826      * @dev Returns the name of the token.
827      */
828     function name() public view returns (string memory) {
829         return _name;
830     }
831 
832     /**
833      * @dev Returns the symbol of the token, usually a shorter version of the
834      * name.
835      */
836     function symbol() public view returns (string memory) {
837         return _symbol;
838     }
839 
840     /**
841      * @dev Returns the number of decimals used to get its user representation.
842      * For example, if `decimals` equals `2`, a balance of `505` tokens should
843      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
844      *
845      * Tokens usually opt for a value of 18, imitating the relationship between
846      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
847      * called.
848      *
849      * NOTE: This information is only used for _display_ purposes: it in
850      * no way affects any of the arithmetic of the contract, including
851      * {IERC20-balanceOf} and {IERC20-transfer}.
852      */
853     function decimals() public view returns (uint8) {
854         return _decimals;
855     }
856 
857     /**
858      * @dev See {IERC20-totalSupply}.
859      */
860     function totalSupply() public view override returns (uint256) {
861         return _totalSupply;
862     }
863 
864     /**
865      * @dev See {IERC20-balanceOf}.
866      */
867     function balanceOf(address account) public view override returns (uint256) {
868         return _balances[account];
869     }
870 
871     /**
872      * @dev See {IERC20-transfer}.
873      *
874      * Requirements:
875      *
876      * - `recipient` cannot be the zero address.
877      * - the caller must have a balance of at least `amount`.
878      */
879     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
880         _transfer(_msgSender(), recipient, amount);
881         return true;
882     }
883 
884     /**
885      * @dev See {IERC20-allowance}.
886      */
887     function allowance(address owner, address spender) public view virtual override returns (uint256) {
888         return _allowances[owner][spender];
889     }
890 
891     /**
892      * @dev See {IERC20-approve}.
893      *
894      * Requirements:
895      *
896      * - `spender` cannot be the zero address.
897      */
898     function approve(address spender, uint256 amount) public virtual override returns (bool) {
899         _approve(_msgSender(), spender, amount);
900         return true;
901     }
902 
903     /**
904      * @dev See {IERC20-transferFrom}.
905      *
906      * Emits an {Approval} event indicating the updated allowance. This is not
907      * required by the EIP. See the note at the beginning of {ERC20};
908      *
909      * Requirements:
910      * - `sender` and `recipient` cannot be the zero address.
911      * - `sender` must have a balance of at least `amount`.
912      * - the caller must have allowance for ``sender``'s tokens of at least
913      * `amount`.
914      */
915     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
916         _transfer(sender, recipient, amount);
917         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
918         return true;
919     }
920 
921     /**
922      * @dev Atomically increases the allowance granted to `spender` by the caller.
923      *
924      * This is an alternative to {approve} that can be used as a mitigation for
925      * problems described in {IERC20-approve}.
926      *
927      * Emits an {Approval} event indicating the updated allowance.
928      *
929      * Requirements:
930      *
931      * - `spender` cannot be the zero address.
932      */
933     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
934         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
935         return true;
936     }
937 
938     /**
939      * @dev Atomically decreases the allowance granted to `spender` by the caller.
940      *
941      * This is an alternative to {approve} that can be used as a mitigation for
942      * problems described in {IERC20-approve}.
943      *
944      * Emits an {Approval} event indicating the updated allowance.
945      *
946      * Requirements:
947      *
948      * - `spender` cannot be the zero address.
949      * - `spender` must have allowance for the caller of at least
950      * `subtractedValue`.
951      */
952     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
953         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
954         return true;
955     }
956 
957     /**
958      * @dev Moves tokens `amount` from `sender` to `recipient`.
959      *
960      * This is internal function is equivalent to {transfer}, and can be used to
961      * e.g. implement automatic token fees, slashing mechanisms, etc.
962      *
963      * Emits a {Transfer} event.
964      *
965      * Requirements:
966      *
967      * - `sender` cannot be the zero address.
968      * - `recipient` cannot be the zero address.
969      * - `sender` must have a balance of at least `amount`.
970      */
971     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
972         require(sender != address(0), "ERC20: transfer from the zero address");
973         require(recipient != address(0), "ERC20: transfer to the zero address");
974 
975         _beforeTokenTransfer(sender, recipient, amount);
976 
977         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
978         _balances[recipient] = _balances[recipient].add(amount);
979         emit Transfer(sender, recipient, amount);
980     }
981 
982     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
983      * the total supply.
984      *
985      * Emits a {Transfer} event with `from` set to the zero address.
986      *
987      * Requirements
988      *
989      * - `to` cannot be the zero address.
990      */
991     function _mint(address account, uint256 amount) internal virtual {
992         require(account != address(0), "ERC20: mint to the zero address");
993 
994         _beforeTokenTransfer(address(0), account, amount);
995 
996         _totalSupply = _totalSupply.add(amount);
997         _balances[account] = _balances[account].add(amount);
998         emit Transfer(address(0), account, amount);
999     }
1000 
1001     /**
1002      * @dev Destroys `amount` tokens from `account`, reducing the
1003      * total supply.
1004      *
1005      * Emits a {Transfer} event with `to` set to the zero address.
1006      *
1007      * Requirements
1008      *
1009      * - `account` cannot be the zero address.
1010      * - `account` must have at least `amount` tokens.
1011      */
1012     function _burn(address account, uint256 amount) internal virtual {
1013         require(account != address(0), "ERC20: burn from the zero address");
1014 
1015         _beforeTokenTransfer(account, address(0), amount);
1016 
1017         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1018         _totalSupply = _totalSupply.sub(amount);
1019         emit Transfer(account, address(0), amount);
1020     }
1021 
1022     /**
1023      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1024      *
1025      * This is internal function is equivalent to `approve`, and can be used to
1026      * e.g. set automatic allowances for certain subsystems, etc.
1027      *
1028      * Emits an {Approval} event.
1029      *
1030      * Requirements:
1031      *
1032      * - `owner` cannot be the zero address.
1033      * - `spender` cannot be the zero address.
1034      */
1035     function _approve(address owner, address spender, uint256 amount) internal virtual {
1036         require(owner != address(0), "ERC20: approve from the zero address");
1037         require(spender != address(0), "ERC20: approve to the zero address");
1038 
1039         _allowances[owner][spender] = amount;
1040         emit Approval(owner, spender, amount);
1041     }
1042 
1043     /**
1044      * @dev Sets {decimals} to a value other than the default one of 18.
1045      *
1046      * WARNING: This function should only be called from the constructor. Most
1047      * applications that interact with token contracts will not expect
1048      * {decimals} to ever change, and may work incorrectly if it does.
1049      */
1050     function _setupDecimals(uint8 decimals_) internal {
1051         _decimals = decimals_;
1052     }
1053 
1054     /**
1055      * @dev Hook that is called before any transfer of tokens. This includes
1056      * minting and burning.
1057      *
1058      * Calling conditions:
1059      *
1060      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1061      * will be to transferred to `to`.
1062      * - when `from` is zero, `amount` tokens will be minted for `to`.
1063      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1064      * - `from` and `to` are never both zero.
1065      *
1066      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1067      */
1068     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1069 }
1070 
1071 pragma solidity 0.6.12;
1072 contract GovernanceContract is Ownable {
1073 
1074     mapping(address => bool) public governanceContracts;
1075 
1076     event GovernanceContractAdded(address addr);
1077     event GovernanceContractRemoved(address addr);
1078 
1079     modifier onlyGovernanceContracts() {
1080         require(governanceContracts[msg.sender]);
1081         _;
1082     }
1083 
1084 
1085     function addAddressToGovernanceContract(address addr) onlyOwner public returns(bool success) {
1086         if (!governanceContracts[addr]) {
1087             governanceContracts[addr] = true;
1088             emit GovernanceContractAdded(addr);
1089             success = true;
1090         }
1091     }
1092 
1093 
1094     function removeAddressFromGovernanceContract(address addr) onlyOwner public returns(bool success) {
1095         if (governanceContracts[addr]) {
1096             governanceContracts[addr] = false;
1097             emit GovernanceContractRemoved(addr);
1098             success = true;
1099         }
1100     }
1101 }
1102 
1103 pragma solidity 0.6.12;
1104 contract MilkyWayToken is ERC20("MilkyWay Token by SpaceSwap v2", "MILK2"), GovernanceContract {
1105 
1106     uint256 private _totalBurned;
1107 
1108     /**
1109      * @dev See {IERC20-totalSupply}.
1110      */
1111     function totalBurned() public view returns (uint256) {
1112         return _totalBurned;
1113     }
1114 
1115 
1116     /// @notice Creates `_amount` token to `_to`. Must only be called by the  Governance Contracts
1117     function mint(address _to, uint256 _amount) public onlyGovernanceContracts virtual returns (bool) {
1118         _mint(_to, _amount);
1119         _moveDelegates(address(0), _delegates[_to], _amount);
1120         return true;
1121     }
1122 
1123     /// @notice Creates `_amount` token to `_to`. Must only be called by the Governance Contracts
1124     function burn(address _to, uint256 _amount) public onlyGovernanceContracts virtual returns (bool) {
1125         _burn(_to, _amount);
1126         _totalBurned = _totalBurned.add(_amount);
1127         _moveDelegates(_delegates[_to], address(0), _amount);
1128         return true;
1129     }
1130 
1131     // Copied and modified from YAM code:
1132     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1133     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1134     // Which is copied and modified from COMPOUND:
1135     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1136 
1137     // @notice A record of each accounts delegate
1138     mapping (address => address) internal _delegates;
1139 
1140     /// @notice A checkpoint for marking number of votes from a given block
1141     struct Checkpoint {
1142         uint32 fromBlock;
1143         uint256 votes;
1144     }
1145 
1146     /// @notice A record of votes checkpoints for each account, by index
1147     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1148 
1149     /// @notice The number of checkpoints for each account
1150     mapping (address => uint32) public numCheckpoints;
1151 
1152     /// @notice The EIP-712 typehash for the contract's domain
1153     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1154 
1155     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1156     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1157 
1158     /// @notice A record of states for signing / validating signatures
1159     mapping (address => uint) public nonces;
1160 
1161     /// @notice An event that's emitted when an account changes its delegate
1162     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1163 
1164     /// @notice An event that's emitted when a delegate account's vote balance changes
1165     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1166 
1167     /**
1168      * @notice Delegate votes from `msg.sender` to `delegatee`
1169      * @param delegator The address to get delegatee for
1170      */
1171     function delegates(address delegator)
1172     external
1173     view
1174     returns (address)
1175     {
1176         return _delegates[delegator];
1177     }
1178 
1179     /**
1180      * @notice Delegate votes from `msg.sender` to `delegatee`
1181      * @param delegatee The address to delegate votes to
1182      */
1183     function delegate(address delegatee) external {
1184         return _delegate(msg.sender, delegatee);
1185     }
1186 
1187     /**
1188      * @notice Delegates votes from signatory to `delegatee`
1189      * @param delegatee The address to delegate votes to
1190      * @param nonce The contract state required to match the signature
1191      * @param expiry The time at which to expire the signature
1192      * @param v The recovery byte of the signature
1193      * @param r Half of the ECDSA signature pair
1194      * @param s Half of the ECDSA signature pair
1195      */
1196     function delegateBySig(
1197         address delegatee,
1198         uint nonce,
1199         uint expiry,
1200         uint8 v,
1201         bytes32 r,
1202         bytes32 s
1203     )
1204     external
1205     {
1206         bytes32 domainSeparator = keccak256(
1207             abi.encode(
1208                 DOMAIN_TYPEHASH,
1209                 keccak256(bytes(name())),
1210                 getChainId(),
1211                 address(this)
1212             )
1213         );
1214 
1215         bytes32 structHash = keccak256(
1216             abi.encode(
1217                 DELEGATION_TYPEHASH,
1218                 delegatee,
1219                 nonce,
1220                 expiry
1221             )
1222         );
1223 
1224         bytes32 digest = keccak256(
1225             abi.encodePacked(
1226                 "\x19\x01",
1227                 domainSeparator,
1228                 structHash
1229             )
1230         );
1231 
1232         address signatory = ecrecover(digest, v, r, s);
1233         require(signatory != address(0), "MILKYWAY::delegateBySig: invalid signature");
1234         require(nonce == nonces[signatory]++, "MILKYWAY::delegateBySig: invalid nonce");
1235         require(now <= expiry, "MILKYWAY::delegateBySig: signature expired");
1236         return _delegate(signatory, delegatee);
1237     }
1238 
1239     /**
1240      * @notice Gets the current votes balance for `account`
1241      * @param account The address to get votes balance
1242      * @return The number of current votes for `account`
1243      */
1244     function getCurrentVotes(address account)
1245     external
1246     view
1247     returns (uint256)
1248     {
1249         uint32 nCheckpoints = numCheckpoints[account];
1250         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1251     }
1252 
1253     /**
1254      * @notice Determine the prior number of votes for an account as of a block number
1255      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1256      * @param account The address of the account to check
1257      * @param blockNumber The block number to get the vote balance at
1258      * @return The number of votes the account had as of the given block
1259      */
1260     function getPriorVotes(address account, uint blockNumber)
1261     external
1262     view
1263     returns (uint256)
1264     {
1265         require(blockNumber < block.number, "MILKYWAY::getPriorVotes: not yet determined");
1266 
1267         uint32 nCheckpoints = numCheckpoints[account];
1268         if (nCheckpoints == 0) {
1269             return 0;
1270         }
1271 
1272         // First check most recent balance
1273         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1274             return checkpoints[account][nCheckpoints - 1].votes;
1275         }
1276 
1277         // Next check implicit zero balance
1278         if (checkpoints[account][0].fromBlock > blockNumber) {
1279             return 0;
1280         }
1281 
1282         uint32 lower = 0;
1283         uint32 upper = nCheckpoints - 1;
1284         while (upper > lower) {
1285             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1286             Checkpoint memory cp = checkpoints[account][center];
1287             if (cp.fromBlock == blockNumber) {
1288                 return cp.votes;
1289             } else if (cp.fromBlock < blockNumber) {
1290                 lower = center;
1291             } else {
1292                 upper = center - 1;
1293             }
1294         }
1295         return checkpoints[account][lower].votes;
1296     }
1297 
1298     function _delegate(address delegator, address delegatee) internal {
1299         address currentDelegate = _delegates[delegator];
1300         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MILKYWAY (not scaled);
1301         _delegates[delegator] = delegatee;
1302 
1303         emit DelegateChanged(delegator, currentDelegate, delegatee);
1304 
1305         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1306     }
1307 
1308     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1309         if (srcRep != dstRep && amount > 0) {
1310             if (srcRep != address(0)) {
1311                 // decrease old representative
1312                 uint32 srcRepNum = numCheckpoints[srcRep];
1313                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1314                 uint256 srcRepNew = srcRepOld.sub(amount);
1315                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1316             }
1317 
1318             if (dstRep != address(0)) {
1319                 // increase new representative
1320                 uint32 dstRepNum = numCheckpoints[dstRep];
1321                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1322                 uint256 dstRepNew = dstRepOld.add(amount);
1323                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1324             }
1325         }
1326     }
1327 
1328     function _writeCheckpoint(
1329         address delegatee,
1330         uint32 nCheckpoints,
1331         uint256 oldVotes,
1332         uint256 newVotes
1333     )
1334     internal
1335     {
1336         uint32 blockNumber = safe32(block.number, "MILKYWAY::_writeCheckpoint: block number exceeds 32 bits");
1337 
1338         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1339             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1340         } else {
1341             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1342             numCheckpoints[delegatee] = nCheckpoints + 1;
1343         }
1344 
1345         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1346     }
1347 
1348     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1349         require(n < 2**32, errorMessage);
1350         return uint32(n);
1351     }
1352 
1353     function getChainId() internal pure returns (uint) {
1354         uint256 chainId;
1355         assembly { chainId := chainid() }
1356         return chainId;
1357     }
1358 }
1359 
1360 
1361 /**
1362 // Note that it's ownable and the owner wields tremendous power. The ownership
1363 // will be transferred to a governance smart contract once MILKYWAY is sufficiently
1364 // distributed and the community can show to govern itself.
1365 //
1366 // Have fun reading it. Hopefully it's bug-free. God bless.
1367 */
1368 contract Gravity is Ownable {
1369     using SafeMath for uint256;
1370     using SafeERC20 for IERC20;
1371 
1372     // Info of each user.
1373     struct UserInfo {
1374         uint256 amount;     // How many LP tokens the user has provided.
1375         uint256 rewardDebt; // Reward debt. See explanation below.
1376     }
1377 
1378     // Info of each pool.
1379     struct PoolInfo {
1380         IERC20 lpToken;           // Address of LP token contract.
1381         uint256 allocPoint;       // How many allocation points assigned to this pool. MILK2s to distribute per block.
1382         uint256 lastRewardBlock;  // Last block number that MILK2s distribution occurs.
1383         uint256 accMilkPerShare; // Accumulated MILK2s per share, times 1e12. See below.
1384     }
1385 
1386 
1387     // The MILKYWAY_Token!
1388     MilkyWayToken public milk;
1389 
1390     // Dev address.
1391     address public devAddr;
1392 
1393     // Distribution address.
1394     address public distributor;
1395 
1396     // The block number when MILK2 mining starts.
1397     uint256 public startFirstPhaseBlock;
1398 
1399     // The block number when MILK2 mining starts.
1400     uint256 public startSecondPhaseBlock;
1401 
1402     // The block number when MILK2 mining starts.
1403     uint256 public startThirdPhaseBlock;
1404 
1405     // Block number when bonus MILK2 period ends.
1406     uint256 public bonusEndBlock;
1407 
1408     // Bonus multiplier for early milk2 makers.
1409     uint256[4] private milkPerBlocks = [20, 10, 5, 2];
1410 
1411     // Info of each pool.
1412     PoolInfo[] public poolInfo;
1413 
1414     // Info of each user that stakes LP tokens.
1415     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1416 
1417     // Total allocation points. Must be the sum of all allocation points in all pools.
1418     uint256 public totalAllocPoint = 0;
1419 
1420 
1421     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1422     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1423     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1424 
1425 
1426     constructor(
1427         MilkyWayToken _milk,
1428         address _devAddr,
1429         address _distributor,
1430         uint256 _startFirstPhaseBlock
1431     ) public {
1432         milk = _milk;
1433         devAddr = _devAddr;
1434         distributor = _distributor;
1435         startFirstPhaseBlock = _startFirstPhaseBlock;
1436         startSecondPhaseBlock = startFirstPhaseBlock.add(10000);
1437         startThirdPhaseBlock = startSecondPhaseBlock.add(30000);
1438         bonusEndBlock = startThirdPhaseBlock.add(60000);
1439     }
1440 
1441     // view length of liquidity pools
1442     function poolLength() external view returns (uint256) {
1443         return poolInfo.length;
1444     }
1445 
1446 
1447     // Add a new lp to the pool. Can only be called by the owner.
1448     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1449     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1450         if (_withUpdate) {
1451             massUpdatePools();
1452         }
1453         uint256 lastRewardBlock = block.number > startFirstPhaseBlock ? block.number : startFirstPhaseBlock;
1454         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1455         poolInfo.push(PoolInfo({
1456         lpToken: _lpToken,
1457         allocPoint: _allocPoint,
1458         lastRewardBlock: lastRewardBlock,
1459         accMilkPerShare: 0
1460         }));
1461     }
1462 
1463 
1464     // Update the given pool's MILK2 allocation point. Can only be called by the owner.
1465     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1466         if (_withUpdate) {
1467             massUpdatePools();
1468         }
1469         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1470         poolInfo[_pid].allocPoint = _allocPoint;
1471     }
1472 
1473 
1474     // Return reward multiplier over the given _from to _to block.
1475     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1476         if (_to <= startFirstPhaseBlock) { // 0
1477             return  _to.sub(_from).mul(milkPerBlocks[3]);
1478         }
1479         else if (_to <= startSecondPhaseBlock) { // + 10,000 blocks
1480             return _to.sub(_from).mul(milkPerBlocks[0]);
1481         }
1482         else if (_to <= startThirdPhaseBlock) { // + 40,000 blocks
1483             return _to.sub(_from).mul(milkPerBlocks[1]);
1484         }
1485         else if (_to <= bonusEndBlock) { // + 40,000 blocks
1486             return _to.sub(_from).mul(milkPerBlocks[2]);
1487         }
1488         else  { // + 100,000 blocks
1489             return _to.sub(_from).mul(milkPerBlocks[3]);
1490         }
1491     }
1492 
1493 
1494     // View current block reward in MILK2s
1495     function getCurrentBlockReward(uint256 _currentBlock) public view returns (uint256) {
1496         if (_currentBlock <= startFirstPhaseBlock) {
1497             return 0;
1498         }
1499         else if (_currentBlock <= startSecondPhaseBlock) {
1500             return milkPerBlocks[0];
1501         }
1502         else if (_currentBlock <= startThirdPhaseBlock) {
1503             return milkPerBlocks[1];
1504         }
1505         else if (_currentBlock <= bonusEndBlock) {
1506             return milkPerBlocks[2];
1507         }
1508         else {
1509             return milkPerBlocks[3];
1510         }
1511     }
1512 
1513 
1514     // View function to see pending MILK2s on frontend.
1515     function pendingMilk(uint256 _pid, address _user) external view returns (uint256) {
1516         PoolInfo storage pool = poolInfo[_pid];
1517         UserInfo storage user = userInfo[_pid][_user];
1518         uint256 accMilkPerShare = pool.accMilkPerShare;
1519         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1520 
1521         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1522             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1523             uint256 milkReward = (multiplier.mul(1e18)).mul(pool.allocPoint).div(totalAllocPoint);
1524             accMilkPerShare = accMilkPerShare.add(milkReward.mul(1e12).div(lpSupply));
1525         }
1526 
1527         return user.amount.mul(accMilkPerShare).div(1e12).sub(user.rewardDebt);
1528     }
1529 
1530 
1531     // Update reward variables for all pools. Be careful of gas spending!
1532     function massUpdatePools() public {
1533         uint256 length = poolInfo.length;
1534         for (uint256 pid = 0; pid < length; ++pid) {
1535             updatePool(pid);
1536         }
1537     }
1538 
1539 
1540     // Update reward variables of the given pool to be up-to-date.
1541     function updatePool(uint256 _pid) public {
1542         PoolInfo storage pool = poolInfo[_pid];
1543 
1544         if (block.number <= pool.lastRewardBlock) {
1545             return;
1546         }
1547 
1548         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1549 
1550         if (lpSupply == 0) {
1551             pool.lastRewardBlock = block.number;
1552             return;
1553         }
1554 
1555         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1556         uint256 milkReward = multiplier.mul(1e18).mul(pool.allocPoint).div(totalAllocPoint);
1557         milk.mint(devAddr, milkReward.mul(3).div(100)); // 3% developers
1558         milk.mint(distributor, milkReward.div(100)); // 1% shakeHolders
1559         milk.mint(address(this), milkReward);
1560         pool.accMilkPerShare = pool.accMilkPerShare.add(milkReward.mul(1e12).div(lpSupply));
1561         pool.lastRewardBlock = block.number;
1562     }
1563 
1564 
1565     // Deposit LP tokens to Interstellar for MILK allocation.
1566     function deposit(uint256 _pid, uint256 _amount) public {
1567         PoolInfo storage pool = poolInfo[_pid];
1568         UserInfo storage user = userInfo[_pid][msg.sender];
1569 
1570         updatePool(_pid);
1571         if (user.amount > 0) {
1572             uint256 pending = user.amount.mul(pool.accMilkPerShare).div(1e12).sub(user.rewardDebt);
1573             safeMilkTransfer(msg.sender, pending);
1574         }
1575 
1576         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1577         user.amount = user.amount.add(_amount);
1578         user.rewardDebt = user.amount.mul(pool.accMilkPerShare).div(1e12);
1579         emit Deposit(msg.sender, _pid, _amount);
1580     }
1581 
1582 
1583     // Withdraw LP tokens from Interstellar.
1584     function withdraw(uint256 _pid, uint256 _amount) public {
1585         PoolInfo storage pool = poolInfo[_pid];
1586         UserInfo storage user = userInfo[_pid][msg.sender];
1587         require(user.amount >= _amount, "withdraw: not good");
1588         updatePool(_pid);
1589         uint256 pending = user.amount.mul(pool.accMilkPerShare).div(1e12).sub(user.rewardDebt);
1590         safeMilkTransfer(msg.sender, pending);
1591         user.amount = user.amount.sub(_amount);
1592         user.rewardDebt = user.amount.mul(pool.accMilkPerShare).div(1e12);
1593         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1594         emit Withdraw(msg.sender, _pid, _amount);
1595     }
1596 
1597 
1598     // Withdraw without caring about rewards. EMERGENCY ONLY.
1599     function emergencyWithdraw(uint256 _pid) public {
1600         PoolInfo storage pool = poolInfo[_pid];
1601         UserInfo storage user = userInfo[_pid][msg.sender];
1602         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1603         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1604         user.amount = 0;
1605         user.rewardDebt = 0;
1606     }
1607 
1608 
1609     // Safe milk2 transfer function, just in case if rounding error causes pool to not have enough MILK2s.
1610     function safeMilkTransfer(address _to, uint256 _amount) internal {
1611         uint256 milkBal = milk.balanceOf(address(this));
1612         if (_amount > milkBal) {
1613             milk.transfer(_to, milkBal);
1614         } else {
1615             milk.transfer(_to, _amount);
1616         }
1617     }
1618 
1619 
1620     // Update dev address by the previous dev.
1621     function dev(address _devAddr) public {
1622         require(msg.sender == devAddr, "dev: wut?");
1623         devAddr = _devAddr;
1624     }
1625 
1626 
1627     // Update distributor address by the previous dev.
1628     function updateDistributor(address _distributor) public {
1629         require(msg.sender == devAddr, "dev: wut?");
1630         distributor = _distributor;
1631     }
1632 
1633 }