1 pragma solidity ^0.6.0;
2 /**
3  * @dev Interface of the ERC20 standard as defined in the EIP.
4  */
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 // File: @openzeppelin/contracts/math/SafeMath.sol
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Address.sol
235 
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
264         assembly {codehash := extcodehash(account)}
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
288         (bool success,) = recipient.call{value : amount}("");
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
354         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
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
374 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
375 
376 /**
377  * @title SafeERC20
378  * @dev Wrappers around ERC20 operations that throw on failure (when the token
379  * contract returns false). Tokens that return no value (and instead revert or
380  * throw on failure) are also supported, non-reverting calls are assumed to be
381  * successful.
382  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
383  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
384  */
385 library SafeERC20 {
386     using SafeMath for uint256;
387     using Address for address;
388 
389     function safeTransfer(IERC20 token, address to, uint256 value) internal {
390         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
391     }
392 
393     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
394         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
395     }
396 
397     /**
398      * @dev Deprecated. This function has issues similar to the ones found in
399      * {IERC20-approve}, and its usage is discouraged.
400      *
401      * Whenever possible, use {safeIncreaseAllowance} and
402      * {safeDecreaseAllowance} instead.
403      */
404     function safeApprove(IERC20 token, address spender, uint256 value) internal {
405         // safeApprove should only be called when setting an initial allowance,
406         // or when resetting it to zero. To increase and decrease it, use
407         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
408         // solhint-disable-next-line max-line-length
409         require((value == 0) || (token.allowance(address(this), spender) == 0),
410             "SafeERC20: approve from non-zero to non-zero allowance"
411         );
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
413     }
414 
415     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).add(value);
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
418     }
419 
420     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     /**
426      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
427      * on the return value: the return value is optional (but if data is returned, it must not be false).
428      * @param token The token targeted by the call.
429      * @param data The call data (encoded using abi.encode or one of its variants).
430      */
431     function _callOptionalReturn(IERC20 token, bytes memory data) private {
432         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
433         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
434         // the target address contains contract code and also asserts for success in the low-level call.
435 
436         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
437         if (returndata.length > 0) {// Return data is optional
438             // solhint-disable-next-line max-line-length
439             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
440         }
441     }
442 }
443 
444 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
445 
446 /**
447  * @dev Library for managing
448  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
449  * types.
450  *
451  * Sets have the following properties:
452  *
453  * - Elements are added, removed, and checked for existence in constant time
454  * (O(1)).
455  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
456  *
457  * ```
458  * contract Example {
459  *     // Add the library methods
460  *     using EnumerableSet for EnumerableSet.AddressSet;
461  *
462  *     // Declare a set state variable
463  *     EnumerableSet.AddressSet private mySet;
464  * }
465  * ```
466  *
467  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
468  * (`UintSet`) are supported.
469  */
470 library EnumerableSet {
471     // To implement this library for multiple types with as little code
472     // repetition as possible, we write it in terms of a generic Set type with
473     // bytes32 values.
474     // The Set implementation uses private functions, and user-facing
475     // implementations (such as AddressSet) are just wrappers around the
476     // underlying Set.
477     // This means that we can only create new EnumerableSets for types that fit
478     // in bytes32.
479 
480     struct Set {
481         // Storage of set values
482         bytes32[] _values;
483 
484         // Position of the value in the `values` array, plus 1 because index 0
485         // means a value is not in the set.
486         mapping(bytes32 => uint256) _indexes;
487     }
488 
489     /**
490      * @dev Add a value to a set. O(1).
491      *
492      * Returns true if the value was added to the set, that is if it was not
493      * already present.
494      */
495     function _add(Set storage set, bytes32 value) private returns (bool) {
496         if (!_contains(set, value)) {
497             set._values.push(value);
498             // The value is stored at length-1, but we add 1 to all indexes
499             // and use 0 as a sentinel value
500             set._indexes[value] = set._values.length;
501             return true;
502         } else {
503             return false;
504         }
505     }
506 
507     /**
508      * @dev Removes a value from a set. O(1).
509      *
510      * Returns true if the value was removed from the set, that is if it was
511      * present.
512      */
513     function _remove(Set storage set, bytes32 value) private returns (bool) {
514         // We read and store the value's index to prevent multiple reads from the same storage slot
515         uint256 valueIndex = set._indexes[value];
516 
517         if (valueIndex != 0) {// Equivalent to contains(set, value)
518             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
519             // the array, and then remove the last element (sometimes called as 'swap and pop').
520             // This modifies the order of the array, as noted in {at}.
521 
522             uint256 toDeleteIndex = valueIndex - 1;
523             uint256 lastIndex = set._values.length - 1;
524 
525             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
526             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
527 
528             bytes32 lastvalue = set._values[lastIndex];
529 
530             // Move the last value to the index where the value to delete is
531             set._values[toDeleteIndex] = lastvalue;
532             // Update the index for the moved value
533             set._indexes[lastvalue] = toDeleteIndex + 1;
534             // All indexes are 1-based
535 
536             // Delete the slot where the moved value was stored
537             set._values.pop();
538 
539             // Delete the index for the deleted slot
540             delete set._indexes[value];
541 
542             return true;
543         } else {
544             return false;
545         }
546     }
547 
548     /**
549      * @dev Returns true if the value is in the set. O(1).
550      */
551     function _contains(Set storage set, bytes32 value) private view returns (bool) {
552         return set._indexes[value] != 0;
553     }
554 
555     /**
556      * @dev Returns the number of values on the set. O(1).
557      */
558     function _length(Set storage set) private view returns (uint256) {
559         return set._values.length;
560     }
561 
562     /**
563      * @dev Returns the value stored at position `index` in the set. O(1).
564      *
565      * Note that there are no guarantees on the ordering of values inside the
566      * array, and it may change when more values are added or removed.
567      *
568      * Requirements:
569      *
570      * - `index` must be strictly less than {length}.
571      */
572     function _at(Set storage set, uint256 index) private view returns (bytes32) {
573         require(set._values.length > index, "EnumerableSet: index out of bounds");
574         return set._values[index];
575     }
576 
577     // AddressSet
578 
579     struct AddressSet {
580         Set _inner;
581     }
582 
583     /**
584      * @dev Add a value to a set. O(1).
585      *
586      * Returns true if the value was added to the set, that is if it was not
587      * already present.
588      */
589     function add(AddressSet storage set, address value) internal returns (bool) {
590         return _add(set._inner, bytes32(uint256(value)));
591     }
592 
593     /**
594      * @dev Removes a value from a set. O(1).
595      *
596      * Returns true if the value was removed from the set, that is if it was
597      * present.
598      */
599     function remove(AddressSet storage set, address value) internal returns (bool) {
600         return _remove(set._inner, bytes32(uint256(value)));
601     }
602 
603     /**
604      * @dev Returns true if the value is in the set. O(1).
605      */
606     function contains(AddressSet storage set, address value) internal view returns (bool) {
607         return _contains(set._inner, bytes32(uint256(value)));
608     }
609 
610     /**
611      * @dev Returns the number of values in the set. O(1).
612      */
613     function length(AddressSet storage set) internal view returns (uint256) {
614         return _length(set._inner);
615     }
616 
617     /**
618      * @dev Returns the value stored at position `index` in the set. O(1).
619      *
620      * Note that there are no guarantees on the ordering of values inside the
621      * array, and it may change when more values are added or removed.
622      *
623      * Requirements:
624      *
625      * - `index` must be strictly less than {length}.
626      */
627     function at(AddressSet storage set, uint256 index) internal view returns (address) {
628         return address(uint256(_at(set._inner, index)));
629     }
630 
631 
632     // UintSet
633 
634     struct UintSet {
635         Set _inner;
636     }
637 
638     /**
639      * @dev Add a value to a set. O(1).
640      *
641      * Returns true if the value was added to the set, that is if it was not
642      * already present.
643      */
644     function add(UintSet storage set, uint256 value) internal returns (bool) {
645         return _add(set._inner, bytes32(value));
646     }
647 
648     /**
649      * @dev Removes a value from a set. O(1).
650      *
651      * Returns true if the value was removed from the set, that is if it was
652      * present.
653      */
654     function remove(UintSet storage set, uint256 value) internal returns (bool) {
655         return _remove(set._inner, bytes32(value));
656     }
657 
658     /**
659      * @dev Returns true if the value is in the set. O(1).
660      */
661     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
662         return _contains(set._inner, bytes32(value));
663     }
664 
665     /**
666      * @dev Returns the number of values on the set. O(1).
667      */
668     function length(UintSet storage set) internal view returns (uint256) {
669         return _length(set._inner);
670     }
671 
672     /**
673      * @dev Returns the value stored at position `index` in the set. O(1).
674      *
675      * Note that there are no guarantees on the ordering of values inside the
676      * array, and it may change when more values are added or removed.
677      *
678      * Requirements:
679      *
680      * - `index` must be strictly less than {length}.
681      */
682     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
683         return uint256(_at(set._inner, index));
684     }
685 }
686 
687 // File: @openzeppelin/contracts/GSN/Context.sol
688 
689 /*
690  * @dev Provides information about the current execution context, including the
691  * sender of the transaction and its data. While these are generally available
692  * via msg.sender and msg.data, they should not be accessed in such a direct
693  * manner, since when dealing with GSN meta-transactions the account sending and
694  * paying for execution may not be the actual sender (as far as an application
695  * is concerned).
696  *
697  * This contract is only required for intermediate, library-like contracts.
698  */
699 abstract contract Context {
700     function _msgSender() internal view virtual returns (address payable) {
701         return msg.sender;
702     }
703 
704     function _msgData() internal view virtual returns (bytes memory) {
705         this;
706         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
707         return msg.data;
708     }
709 }
710 
711 // File: @openzeppelin/contracts/access/Ownable.sol
712 
713 /**
714  * @dev Contract module which provides a basic access control mechanism, where
715  * there is an account (an owner) that can be granted exclusive access to
716  * specific functions.
717  *
718  * By default, the owner account will be the one that deploys the contract. This
719  * can later be changed with {transferOwnership}.
720  *
721  * This module is used through inheritance. It will make available the modifier
722  * `onlyOwner`, which can be applied to your functions to restrict their use to
723  * the owner.
724  */
725 contract Ownable is Context {
726     address private _owner;
727 
728     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
729 
730     /**
731      * @dev Initializes the contract setting the deployer as the initial owner.
732      */
733     constructor () internal {
734         address msgSender = _msgSender();
735         _owner = msgSender;
736         emit OwnershipTransferred(address(0), msgSender);
737     }
738 
739     /**
740      * @dev Returns the address of the current owner.
741      */
742     function owner() public view returns (address) {
743         return _owner;
744     }
745 
746     /**
747      * @dev Throws if called by any account other than the owner.
748      */
749     modifier onlyOwner() {
750         require(_owner == _msgSender(), "Ownable: caller is not the owner");
751         _;
752     }
753 
754     /**
755      * @dev Leaves the contract without owner. It will not be possible to call
756      * `onlyOwner` functions anymore. Can only be called by the current owner.
757      *
758      * NOTE: Renouncing ownership will leave the contract without an owner,
759      * thereby removing any functionality that is only available to the owner.
760      */
761     function renounceOwnership() public virtual onlyOwner {
762         emit OwnershipTransferred(_owner, address(0));
763         _owner = address(0);
764     }
765 
766     /**
767      * @dev Transfers ownership of the contract to a new account (`newOwner`).
768      * Can only be called by the current owner.
769      */
770     function transferOwnership(address newOwner) public virtual onlyOwner {
771         require(newOwner != address(0), "Ownable: new owner is the zero address");
772         emit OwnershipTransferred(_owner, newOwner);
773         _owner = newOwner;
774     }
775 }
776 
777 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
778 
779 /**
780  * @dev Implementation of the {IERC20} interface.
781  *
782  * This implementation is agnostic to the way tokens are created. This means
783  * that a supply mechanism has to be added in a derived contract using {_mint}.
784  * For a generic mechanism see {ERC20PresetMinterPauser}.
785  *
786  * TIP: For a detailed writeup see our guide
787  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
788  * to implement supply mechanisms].
789  *
790  * We have followed general OpenZeppelin guidelines: functions revert instead
791  * of returning `false` on failure. This behavior is nonetheless conventional
792  * and does not conflict with the expectations of ERC20 applications.
793  *
794  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
795  * This allows applications to reconstruct the allowance for all accounts just
796  * by listening to said events. Other implementations of the EIP may not emit
797  * these events, as it isn't required by the specification.
798  *
799  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
800  * functions have been added to mitigate the well-known issues around setting
801  * allowances. See {IERC20-approve}.
802  */
803 contract ERC20 is Context, IERC20 {
804     using SafeMath for uint256;
805     using Address for address;
806 
807     mapping(address => uint256) private _balances;
808 
809     mapping(address => mapping(address => uint256)) private _allowances;
810 
811     uint256 private _totalSupply;
812 
813     string private _name;
814     string private _symbol;
815     uint8 private _decimals;
816 
817     /**
818      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
819      * a default value of 18.
820      *
821      * To select a different value for {decimals}, use {_setupDecimals}.
822      *
823      * All three of these values are immutable: they can only be set once during
824      * construction.
825      */
826     constructor (string memory name, string memory symbol) public {
827         _name = name;
828         _symbol = symbol;
829         _decimals = 18;
830     }
831 
832     /**
833      * @dev Returns the name of the token.
834      */
835     function name() public view returns (string memory) {
836         return _name;
837     }
838 
839     /**
840      * @dev Returns the symbol of the token, usually a shorter version of the
841      * name.
842      */
843     function symbol() public view returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev Returns the number of decimals used to get its user representation.
849      * For example, if `decimals` equals `2`, a balance of `505` tokens should
850      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
851      *
852      * Tokens usually opt for a value of 18, imitating the relationship between
853      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
854      * called.
855      *
856      * NOTE: This information is only used for _display_ purposes: it in
857      * no way affects any of the arithmetic of the contract, including
858      * {IERC20-balanceOf} and {IERC20-transfer}.
859      */
860     function decimals() public view returns (uint8) {
861         return _decimals;
862     }
863 
864     /**
865      * @dev See {IERC20-totalSupply}.
866      */
867     function totalSupply() public view override returns (uint256) {
868         return _totalSupply;
869     }
870 
871     /**
872      * @dev See {IERC20-balanceOf}.
873      */
874     function balanceOf(address account) public view override returns (uint256) {
875         return _balances[account];
876     }
877 
878     /**
879      * @dev See {IERC20-transfer}.
880      *
881      * Requirements:
882      *
883      * - `recipient` cannot be the zero address.
884      * - the caller must have a balance of at least `amount`.
885      */
886     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
887         _transfer(_msgSender(), recipient, amount);
888         return true;
889     }
890 
891     /**
892      * @dev See {IERC20-allowance}.
893      */
894     function allowance(address owner, address spender) public view virtual override returns (uint256) {
895         return _allowances[owner][spender];
896     }
897 
898     /**
899      * @dev See {IERC20-approve}.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function approve(address spender, uint256 amount) public virtual override returns (bool) {
906         _approve(_msgSender(), spender, amount);
907         return true;
908     }
909 
910     /**
911      * @dev See {IERC20-transferFrom}.
912      *
913      * Emits an {Approval} event indicating the updated allowance. This is not
914      * required by the EIP. See the note at the beginning of {ERC20};
915      *
916      * Requirements:
917      * - `sender` and `recipient` cannot be the zero address.
918      * - `sender` must have a balance of at least `amount`.
919      * - the caller must have allowance for ``sender``'s tokens of at least
920      * `amount`.
921      */
922     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
923         _transfer(sender, recipient, amount);
924         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
925         return true;
926     }
927 
928     /**
929      * @dev Atomically increases the allowance granted to `spender` by the caller.
930      *
931      * This is an alternative to {approve} that can be used as a mitigation for
932      * problems described in {IERC20-approve}.
933      *
934      * Emits an {Approval} event indicating the updated allowance.
935      *
936      * Requirements:
937      *
938      * - `spender` cannot be the zero address.
939      */
940     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
941         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
942         return true;
943     }
944 
945     /**
946      * @dev Atomically decreases the allowance granted to `spender` by the caller.
947      *
948      * This is an alternative to {approve} that can be used as a mitigation for
949      * problems described in {IERC20-approve}.
950      *
951      * Emits an {Approval} event indicating the updated allowance.
952      *
953      * Requirements:
954      *
955      * - `spender` cannot be the zero address.
956      * - `spender` must have allowance for the caller of at least
957      * `subtractedValue`.
958      */
959     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
960         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
961         return true;
962     }
963 
964     /**
965      * @dev Moves tokens `amount` from `sender` to `recipient`.
966      *
967      * This is internal function is equivalent to {transfer}, and can be used to
968      * e.g. implement automatic token fees, slashing mechanisms, etc.
969      *
970      * Emits a {Transfer} event.
971      *
972      * Requirements:
973      *
974      * - `sender` cannot be the zero address.
975      * - `recipient` cannot be the zero address.
976      * - `sender` must have a balance of at least `amount`.
977      */
978     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
979         require(sender != address(0), "ERC20: transfer from the zero address");
980         require(recipient != address(0), "ERC20: transfer to the zero address");
981 
982         _beforeTokenTransfer(sender, recipient, amount);
983 
984         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
985         _balances[recipient] = _balances[recipient].add(amount);
986         emit Transfer(sender, recipient, amount);
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
1075     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1076 }
1077 
1078 contract ZyxToken is ERC20("ZyxToken", "ZYX"), Ownable {
1079 
1080     string public LastZyxId = "";
1081     string public LastZYXAddress = "";
1082 
1083 
1084     function mint(address _to, uint256 _amount) public onlyOwner {
1085         _mint(_to, _amount);
1086         _moveDelegates(address(0), _delegates[_to], _amount);
1087     }
1088 
1089     function burn(address _account, uint256 _amount) public onlyOwner {
1090         _burn(_account, _amount);
1091         _moveDelegates(_delegates[_account], address(0), _amount);
1092     }
1093 
1094     function mintBridge(address _to, uint256 _amount, string calldata last_zyx_id) public onlyOwner {
1095         _mint(_to, _amount);
1096         _moveDelegates(address(0), _delegates[_to], _amount);
1097         LastZyxId = last_zyx_id;
1098     }
1099 
1100     function burnBridge(address _account, uint256 _amount, string calldata last_zyx_address) public onlyOwner {
1101         _burn(_account, _amount);
1102         _moveDelegates(_delegates[_account], address(0), _amount);
1103         LastZYXAddress = last_zyx_address;
1104     }
1105 
1106     mapping(address => address) internal _delegates;
1107 
1108     /// @notice A checkpoint for marking number of votes from a given block
1109     struct Checkpoint {
1110         uint32 fromBlock;
1111         uint256 votes;
1112     }
1113 
1114     /// @notice A record of votes checkpoints for each account, by index
1115     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1116 
1117     /// @notice The number of checkpoints for each account
1118     mapping(address => uint32) public numCheckpoints;
1119 
1120     /// @notice The EIP-712 typehash for the contract's domain
1121     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1122 
1123     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1124     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1125 
1126     /// @notice A record of states for signing / validating signatures
1127     mapping(address => uint) public nonces;
1128 
1129     /// @notice An event thats emitted when an account changes its delegate
1130     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1131 
1132     /// @notice An event thats emitted when a delegate account's vote balance changes
1133     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1134 
1135     /**
1136      * @notice Delegate votes from `msg.sender` to `delegatee`
1137      * @param delegator The address to get delegatee for
1138      */
1139     function delegates(address delegator)
1140     external
1141     view
1142     returns (address)
1143     {
1144         return _delegates[delegator];
1145     }
1146 
1147     /**
1148      * @notice Delegate votes from `msg.sender` to `delegatee`
1149      * @param delegatee The address to delegate votes to
1150      */
1151     function delegate(address delegatee) external {
1152         return _delegate(msg.sender, delegatee);
1153     }
1154 
1155     /**
1156      * @notice Delegates votes from signatory to `delegatee`
1157      * @param delegatee The address to delegate votes to
1158      * @param nonce The contract state required to match the signature
1159      * @param expiry The time at which to expire the signature
1160      * @param v The recovery byte of the signature
1161      * @param r Half of the ECDSA signature pair
1162      * @param s Half of the ECDSA signature pair
1163      */
1164     function delegateBySig(
1165         address delegatee,
1166         uint nonce,
1167         uint expiry,
1168         uint8 v,
1169         bytes32 r,
1170         bytes32 s
1171     )
1172     external
1173     {
1174         bytes32 domainSeparator = keccak256(
1175             abi.encode(
1176                 DOMAIN_TYPEHASH,
1177                 keccak256(bytes(name())),
1178                 getChainId(),
1179                 address(this)
1180             )
1181         );
1182 
1183         bytes32 structHash = keccak256(
1184             abi.encode(
1185                 DELEGATION_TYPEHASH,
1186                 delegatee,
1187                 nonce,
1188                 expiry
1189             )
1190         );
1191 
1192         bytes32 digest = keccak256(
1193             abi.encodePacked(
1194                 "\x19\x01",
1195                 domainSeparator,
1196                 structHash
1197             )
1198         );
1199 
1200         address signatory = ecrecover(digest, v, r, s);
1201         require(signatory != address(0), "ZYX::delegateBySig: invalid signature");
1202         require(nonce == nonces[signatory]++, "ZYX::delegateBySig: invalid nonce");
1203         require(now <= expiry, "ZYX::delegateBySig: signature expired");
1204         return _delegate(signatory, delegatee);
1205     }
1206 
1207     /**
1208      * @notice Gets the current votes balance for `account`
1209      * @param account The address to get votes balance
1210      * @return The number of current votes for `account`
1211      */
1212     function getCurrentVotes(address account)
1213     external
1214     view
1215     returns (uint256)
1216     {
1217         uint32 nCheckpoints = numCheckpoints[account];
1218         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1219     }
1220 
1221     /**
1222      * @notice Determine the prior number of votes for an account as of a block number
1223      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1224      * @param account The address of the account to check
1225      * @param blockNumber The block number to get the vote balance at
1226      * @return The number of votes the account had as of the given block
1227      */
1228     function getPriorVotes(address account, uint blockNumber)
1229 
1230     external
1231     view
1232     returns (uint256)
1233     {
1234         require(blockNumber < block.number, "ZYX::getPriorVotes: not yet determined");
1235 
1236         uint32 nCheckpoints = numCheckpoints[account];
1237         if (nCheckpoints == 0) {
1238             return 0;
1239         }
1240 
1241         // First check most recent balance
1242         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1243             return checkpoints[account][nCheckpoints - 1].votes;
1244         }
1245 
1246         // Next check implicit zero balance
1247         if (checkpoints[account][0].fromBlock > blockNumber) {
1248             return 0;
1249         }
1250 
1251         uint32 lower = 0;
1252         uint32 upper = nCheckpoints - 1;
1253         while (upper > lower) {
1254             uint32 center = upper - (upper - lower) / 2;
1255             // ceil, avoiding overflow
1256             Checkpoint memory cp = checkpoints[account][center];
1257             if (cp.fromBlock == blockNumber) {
1258                 return cp.votes;
1259             } else if (cp.fromBlock < blockNumber) {
1260                 lower = center;
1261             } else {
1262                 upper = center - 1;
1263             }
1264         }
1265         return checkpoints[account][lower].votes;
1266     }
1267 
1268     function _delegate(address delegator, address delegatee)
1269     internal
1270     {
1271         address currentDelegate = _delegates[delegator];
1272         uint256 delegatorBalance = balanceOf(delegator);
1273         _delegates[delegator] = delegatee;
1274 
1275         emit DelegateChanged(delegator, currentDelegate, delegatee);
1276 
1277         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1278     }
1279 
1280     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1281         if (srcRep != dstRep && amount > 0) {
1282             if (srcRep != address(0)) {
1283                 // decrease old representative
1284                 uint32 srcRepNum = numCheckpoints[srcRep];
1285                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1286                 uint256 srcRepNew = srcRepOld.sub(amount);
1287                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1288             }
1289 
1290             if (dstRep != address(0)) {
1291                 // increase new representative
1292                 uint32 dstRepNum = numCheckpoints[dstRep];
1293                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1294                 uint256 dstRepNew = dstRepOld.add(amount);
1295                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1296             }
1297         }
1298     }
1299 
1300     function _writeCheckpoint(
1301         address delegatee,
1302         uint32 nCheckpoints,
1303         uint256 oldVotes,
1304         uint256 newVotes
1305     )
1306     internal
1307     {
1308         uint32 blockNumber = safe32(block.number, "ZYX::_writeCheckpoint: block number exceeds 32 bits");
1309 
1310         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1311             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1312         } else {
1313             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1314             numCheckpoints[delegatee] = nCheckpoints + 1;
1315         }
1316 
1317         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1318     }
1319 
1320     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1321         require(n < 2 ** 32, errorMessage);
1322         return uint32(n);
1323     }
1324 
1325     function getChainId() internal pure returns (uint) {
1326         uint256 chainId;
1327         assembly {chainId := chainid()}
1328         return chainId;
1329     }
1330 }
1331 
1332 contract ZyxTokenManager is Ownable {
1333     using SafeMath for uint256;
1334     using SafeERC20 for IERC20;
1335 
1336     struct LastDeposits {
1337         uint256 amount;
1338         uint256 rewardIndex;
1339     }
1340 
1341     // Info of each user.
1342     struct UserInfo {
1343         uint256 totalAmount;             // How many LP tokens the user has provided.
1344         uint256 amount;
1345         uint256 reward;                  // Reward to withdraw
1346         uint256 lastRewardBlock;
1347         LastDeposits[] lastDeposits;
1348     }
1349 
1350     uint256 public totalLpTokens = 0;
1351 
1352 
1353     // Info of each pool.
1354     struct PoolInfo {
1355         IERC20 lpToken;
1356         uint256 totalSupplyLp;
1357     }
1358 
1359     struct Reward {
1360         uint256 block;
1361         uint256 amount;
1362         uint256 totalLp;
1363     }
1364 
1365     ZyxToken public zyx;
1366     // Info of each pool.
1367     PoolInfo[] public poolInfo;
1368     // Rewards info
1369     Reward[] public rewards;
1370 
1371 
1372     // Info of each user that stakes LP tokens.
1373     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1374 
1375     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1376     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1377     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1378 
1379 
1380     constructor(
1381         ZyxToken _zyx
1382     ) public {
1383         zyx = _zyx;
1384         rewards.push(
1385             Reward({
1386         block : block.number,
1387         amount : 0,
1388         totalLp : 0
1389         }));
1390     }
1391 
1392     function poolLength() external view returns (uint256) {
1393         return poolInfo.length;
1394     }
1395 
1396     function rewardsLength() external view returns (uint256) {
1397         return rewards.length;
1398     }
1399 
1400     function lastDeposits(uint256 _pid) external view returns (uint256,uint256) {
1401         UserInfo storage user = userInfo[_pid][msg.sender];
1402         return (user.lastDeposits[0].amount,user.lastDeposits[0].rewardIndex);
1403     }
1404 
1405     // Add a new lp to the pool. Can only be called by the owner.
1406     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1407     function add(IERC20 _lpToken) public onlyOwner {
1408         poolInfo.push(PoolInfo({
1409         lpToken : _lpToken,
1410         totalSupplyLp : 0
1411         }));
1412     }
1413 
1414     function calcReward(uint _pid, address sender) private returns (uint256 TotalReward, uint256 amount){
1415         UserInfo storage user = userInfo[_pid][sender];
1416 
1417         uint256 totalReward = 0;
1418         uint256 firstBlockIndex = 0;
1419         for (uint i = rewards.length - 1; i > 0; i--) {
1420             if (rewards[i].block <= user.lastRewardBlock) {
1421                 firstBlockIndex = (i + 1);
1422                 break;
1423             }
1424         }
1425 
1426         for (uint i = firstBlockIndex; i < rewards.length; i++) {
1427             Reward memory rewardBlock = rewards[i];
1428             if (rewardBlock.amount > 0 && rewardBlock.totalLp > 0) {
1429                 uint256 UserReward = user.amount.mul(rewardBlock.amount).div(rewardBlock.totalLp);
1430                 totalReward = totalReward.add(UserReward);
1431             }
1432             if (i == user.lastDeposits[0].rewardIndex) {
1433                 user.amount = user.amount.add(user.lastDeposits[0].amount);
1434             }
1435         }
1436 
1437         if(user.amount > user.totalAmount){
1438             user.amount = user.totalAmount;
1439         }
1440 
1441         return (user.reward.add(totalReward), user.amount);
1442     }
1443 
1444 
1445     // Deposit LP tokens to ZyxToken for ZYX allocation.
1446     function deposit(uint256 _pid, uint256 _amount) public {
1447         PoolInfo storage pool = poolInfo[_pid];
1448         UserInfo storage user = userInfo[_pid][msg.sender];
1449         if (user.totalAmount > 0) {
1450             (uint totalReward, uint amount) = calcReward(_pid, msg.sender);
1451             user.reward = totalReward;
1452             user.amount = amount;
1453 
1454 
1455             if (user.lastDeposits[0].rewardIndex == rewards.length) {
1456                 user.lastDeposits[0].amount = user.lastDeposits[0].amount.add(_amount);
1457             } else {
1458                 user.lastDeposits[0].amount = _amount;
1459                 user.lastDeposits[0].rewardIndex = rewards.length;
1460             }
1461         } else {
1462             user.lastDeposits.push(LastDeposits({
1463             amount : _amount,
1464             rewardIndex : rewards.length
1465             }));
1466         }
1467 
1468         if(user.amount > user.totalAmount){
1469             user.amount = user.totalAmount;
1470         }
1471 
1472         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1473         user.lastRewardBlock = block.number;
1474         totalLpTokens = totalLpTokens.add(_amount);
1475         pool.totalSupplyLp = pool.totalSupplyLp.add(_amount);
1476         user.totalAmount = user.totalAmount.add(_amount);
1477         emit Deposit(msg.sender, _pid, _amount);
1478     }
1479 
1480 
1481     // Withdraw LP tokens from ZyxManager.
1482     function withdraw(uint256 _pid, uint256 _amount) public {
1483         PoolInfo storage pool = poolInfo[_pid];
1484         UserInfo storage user = userInfo[_pid][msg.sender];
1485         require(user.totalAmount >= _amount, "withdraw: not good");
1486         require(user.totalAmount > 0, "withdraw: no balance");
1487 
1488 
1489         (uint totalReward, uint amount) = calcReward(_pid, msg.sender);
1490         user.reward = totalReward;
1491         user.amount = amount;
1492 
1493         uint256 Amount = 0;
1494         if(_amount > user.lastDeposits[0].amount){
1495             Amount = _amount.sub(user.lastDeposits[0].amount);
1496             user.lastDeposits[0].amount = 0;
1497             user.amount = user.amount.sub(Amount);
1498         } else {
1499             user.lastDeposits[0].amount = user.lastDeposits[0].amount.sub(_amount);
1500         }
1501 
1502 
1503         user.totalAmount = user.totalAmount.sub(_amount);
1504         if(user.totalAmount == 0){
1505             user.amount = 0;
1506             user.lastDeposits.pop();
1507         }
1508 
1509         if(user.amount > user.totalAmount){
1510             user.amount = user.totalAmount;
1511         }
1512 
1513         safeZyxTransfer(msg.sender, user.reward);
1514         user.reward = 0;
1515 
1516         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1517         pool.totalSupplyLp = pool.totalSupplyLp.sub(_amount);
1518         user.lastRewardBlock = block.number;
1519         totalLpTokens = totalLpTokens.sub(_amount);
1520         emit Withdraw(msg.sender, _pid, _amount);
1521     }
1522 
1523     // EMERGENCY ONLY
1524     function emergencyWithdraw(uint256 _pid) public {
1525         PoolInfo storage pool = poolInfo[_pid];
1526         UserInfo storage user = userInfo[_pid][msg.sender];
1527         pool.lpToken.safeTransfer(address(msg.sender), user.totalAmount);
1528         user.totalAmount = 0;
1529         user.reward = 0;
1530         user.lastDeposits.pop();
1531         user.amount = 0;
1532         user.lastRewardBlock = block.number;
1533         emit EmergencyWithdraw(msg.sender, _pid, user.totalAmount);
1534     }
1535 
1536     function distributeReward(uint256 amount) public onlyOwner {
1537         rewards.push(
1538             Reward({
1539         block : block.number,
1540         amount : amount,
1541         totalLp : totalLpTokens
1542         }));
1543     }
1544 
1545     // View function to see pending ZYX's on frontend.
1546     function pendingZyx(uint256 _pid, address _user) external view returns (uint256) {
1547         UserInfo memory user = userInfo[_pid][_user];
1548 
1549         uint256 totalReward = 0;
1550         uint256 firstBlockIndex = 0;
1551         for (uint i = rewards.length - 1; i > 0; i--) {
1552             if (rewards[i].block <= user.lastRewardBlock) {
1553                 firstBlockIndex = (i + 1);
1554                 break;
1555             }
1556         }
1557 
1558         for (uint i = firstBlockIndex; i < rewards.length; i++) {
1559             Reward memory rewardBlock = rewards[i];
1560             if (rewardBlock.amount > 0 && rewardBlock.totalLp > 0) {
1561                 uint256 UserReward = user.amount.mul(rewardBlock.amount).div(rewardBlock.totalLp);
1562                 totalReward = totalReward.add(UserReward);
1563             }
1564             if (i == user.lastDeposits[0].rewardIndex) {
1565                 user.amount = user.amount.add(user.lastDeposits[0].amount);
1566             }
1567         }
1568         return user.reward.add(totalReward);
1569     }
1570 
1571     function safeZyxTransfer(address _to, uint256 _amount) internal {
1572         uint256 zyxBal = zyx.balanceOf(address(this));
1573         if (_amount > zyxBal) {
1574             zyx.transfer(_to, zyxBal);
1575         } else {
1576             zyx.transfer(_to, _amount);
1577         }
1578     }
1579 
1580 
1581 }