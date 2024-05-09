1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-26
3 */
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 
8 
9 pragma solidity ^0.6.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: @openzeppelin/contracts/math/SafeMath.sol
86 
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      *
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Address.sol
245 
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
386 
387 
388 /**
389  * @title SafeERC20
390  * @dev Wrappers around ERC20 operations that throw on failure (when the token
391  * contract returns false). Tokens that return no value (and instead revert or
392  * throw on failure) are also supported, non-reverting calls are assumed to be
393  * successful.
394  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
395  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
396  */
397 library SafeERC20 {
398     using SafeMath for uint256;
399     using Address for address;
400 
401     function safeTransfer(IERC20 token, address to, uint256 value) internal {
402         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
403     }
404 
405     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
407     }
408 
409     /**
410      * @dev Deprecated. This function has issues similar to the ones found in
411      * {IERC20-approve}, and its usage is discouraged.
412      *
413      * Whenever possible, use {safeIncreaseAllowance} and
414      * {safeDecreaseAllowance} instead.
415      */
416     function safeApprove(IERC20 token, address spender, uint256 value) internal {
417         // safeApprove should only be called when setting an initial allowance,
418         // or when resetting it to zero. To increase and decrease it, use
419         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
420         // solhint-disable-next-line max-line-length
421         require((value == 0) || (token.allowance(address(this), spender) == 0),
422             "SafeERC20: approve from non-zero to non-zero allowance"
423         );
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
425     }
426 
427     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
428         uint256 newAllowance = token.allowance(address(this), spender).add(value);
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
430     }
431 
432     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
433         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     /**
438      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
439      * on the return value: the return value is optional (but if data is returned, it must not be false).
440      * @param token The token targeted by the call.
441      * @param data The call data (encoded using abi.encode or one of its variants).
442      */
443     function _callOptionalReturn(IERC20 token, bytes memory data) private {
444         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
445         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
446         // the target address contains contract code and also asserts for success in the low-level call.
447 
448         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
449         if (returndata.length > 0) { // Return data is optional
450             // solhint-disable-next-line max-line-length
451             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
452         }
453     }
454 }
455 
456 /**
457  * @dev Library for managing
458  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
459  * types.
460  *
461  * Sets have the following properties:
462  *
463  * - Elements are added, removed, and checked for existence in constant time
464  * (O(1)).
465  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
466  *
467  * ```
468  * contract Example {
469  *     // Add the library methods
470  *     using EnumerableSet for EnumerableSet.AddressSet;
471  *
472  *     // Declare a set state variable
473  *     EnumerableSet.AddressSet private mySet;
474  * }
475  * ```
476  *
477  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
478  * (`UintSet`) are supported.
479  */
480 library EnumerableSet {
481     // To implement this library for multiple types with as little code
482     // repetition as possible, we write it in terms of a generic Set type with
483     // bytes32 values.
484     // The Set implementation uses private functions, and user-facing
485     // implementations (such as AddressSet) are just wrappers around the
486     // underlying Set.
487     // This means that we can only create new EnumerableSets for types that fit
488     // in bytes32.
489 
490     struct Set {
491         // Storage of set values
492         bytes32[] _values;
493 
494         // Position of the value in the `values` array, plus 1 because index 0
495         // means a value is not in the set.
496         mapping (bytes32 => uint256) _indexes;
497     }
498 
499     /**
500      * @dev Add a value to a set. O(1).
501      *
502      * Returns true if the value was added to the set, that is if it was not
503      * already present.
504      */
505     function _add(Set storage set, bytes32 value) private returns (bool) {
506         if (!_contains(set, value)) {
507             set._values.push(value);
508             // The value is stored at length-1, but we add 1 to all indexes
509             // and use 0 as a sentinel value
510             set._indexes[value] = set._values.length;
511             return true;
512         } else {
513             return false;
514         }
515     }
516 
517     /**
518      * @dev Removes a value from a set. O(1).
519      *
520      * Returns true if the value was removed from the set, that is if it was
521      * present.
522      */
523     function _remove(Set storage set, bytes32 value) private returns (bool) {
524         // We read and store the value's index to prevent multiple reads from the same storage slot
525         uint256 valueIndex = set._indexes[value];
526 
527         if (valueIndex != 0) { // Equivalent to contains(set, value)
528             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
529             // the array, and then remove the last element (sometimes called as 'swap and pop').
530             // This modifies the order of the array, as noted in {at}.
531 
532             uint256 toDeleteIndex = valueIndex - 1;
533             uint256 lastIndex = set._values.length - 1;
534 
535             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
536             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
537 
538             bytes32 lastvalue = set._values[lastIndex];
539 
540             // Move the last value to the index where the value to delete is
541             set._values[toDeleteIndex] = lastvalue;
542             // Update the index for the moved value
543             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
544 
545             // Delete the slot where the moved value was stored
546             set._values.pop();
547 
548             // Delete the index for the deleted slot
549             delete set._indexes[value];
550 
551             return true;
552         } else {
553             return false;
554         }
555     }
556 
557     /**
558      * @dev Returns true if the value is in the set. O(1).
559      */
560     function _contains(Set storage set, bytes32 value) private view returns (bool) {
561         return set._indexes[value] != 0;
562     }
563 
564     /**
565      * @dev Returns the number of values on the set. O(1).
566      */
567     function _length(Set storage set) private view returns (uint256) {
568         return set._values.length;
569     }
570 
571    /**
572     * @dev Returns the value stored at position `index` in the set. O(1).
573     *
574     * Note that there are no guarantees on the ordering of values inside the
575     * array, and it may change when more values are added or removed.
576     *
577     * Requirements:
578     *
579     * - `index` must be strictly less than {length}.
580     */
581     function _at(Set storage set, uint256 index) private view returns (bytes32) {
582         require(set._values.length > index, "EnumerableSet: index out of bounds");
583         return set._values[index];
584     }
585 
586     // AddressSet
587 
588     struct AddressSet {
589         Set _inner;
590     }
591 
592     /**
593      * @dev Add a value to a set. O(1).
594      *
595      * Returns true if the value was added to the set, that is if it was not
596      * already present.
597      */
598     function add(AddressSet storage set, address value) internal returns (bool) {
599         return _add(set._inner, bytes32(uint256(value)));
600     }
601 
602     /**
603      * @dev Removes a value from a set. O(1).
604      *
605      * Returns true if the value was removed from the set, that is if it was
606      * present.
607      */
608     function remove(AddressSet storage set, address value) internal returns (bool) {
609         return _remove(set._inner, bytes32(uint256(value)));
610     }
611 
612     /**
613      * @dev Returns true if the value is in the set. O(1).
614      */
615     function contains(AddressSet storage set, address value) internal view returns (bool) {
616         return _contains(set._inner, bytes32(uint256(value)));
617     }
618 
619     /**
620      * @dev Returns the number of values in the set. O(1).
621      */
622     function length(AddressSet storage set) internal view returns (uint256) {
623         return _length(set._inner);
624     }
625 
626    /**
627     * @dev Returns the value stored at position `index` in the set. O(1).
628     *
629     * Note that there are no guarantees on the ordering of values inside the
630     * array, and it may change when more values are added or removed.
631     *
632     * Requirements:
633     *
634     * - `index` must be strictly less than {length}.
635     */
636     function at(AddressSet storage set, uint256 index) internal view returns (address) {
637         return address(uint256(_at(set._inner, index)));
638     }
639 
640 
641     // UintSet
642 
643     struct UintSet {
644         Set _inner;
645     }
646 
647     /**
648      * @dev Add a value to a set. O(1).
649      *
650      * Returns true if the value was added to the set, that is if it was not
651      * already present.
652      */
653     function add(UintSet storage set, uint256 value) internal returns (bool) {
654         return _add(set._inner, bytes32(value));
655     }
656 
657     /**
658      * @dev Removes a value from a set. O(1).
659      *
660      * Returns true if the value was removed from the set, that is if it was
661      * present.
662      */
663     function remove(UintSet storage set, uint256 value) internal returns (bool) {
664         return _remove(set._inner, bytes32(value));
665     }
666 
667     /**
668      * @dev Returns true if the value is in the set. O(1).
669      */
670     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
671         return _contains(set._inner, bytes32(value));
672     }
673 
674     /**
675      * @dev Returns the number of values on the set. O(1).
676      */
677     function length(UintSet storage set) internal view returns (uint256) {
678         return _length(set._inner);
679     }
680 
681    /**
682     * @dev Returns the value stored at position `index` in the set. O(1).
683     *
684     * Note that there are no guarantees on the ordering of values inside the
685     * array, and it may change when more values are added or removed.
686     *
687     * Requirements:
688     *
689     * - `index` must be strictly less than {length}.
690     */
691     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
692         return uint256(_at(set._inner, index));
693     }
694 }
695 
696 // File: @openzeppelin/contracts/GSN/Context.sol
697 
698 /*
699  * @dev Provides information about the current execution context, including the
700  * sender of the transaction and its data. While these are generally available
701  * via msg.sender and msg.data, they should not be accessed in such a direct
702  * manner, since when dealing with GSN meta-transactions the account sending and
703  * paying for execution may not be the actual sender (as far as an application
704  * is concerned).
705  *
706  * This contract is only required for intermediate, library-like contracts.
707  */
708 abstract contract Context {
709     function _msgSender() internal view virtual returns (address payable) {
710         return msg.sender;
711     }
712 
713     function _msgData() internal view virtual returns (bytes memory) {
714         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
715         return msg.data;
716     }
717 }
718 
719 // File: @openzeppelin/contracts/access/Ownable.sol
720 
721 /**
722  * @dev Contract module which provides a basic access control mechanism, where
723  * there is an account (an owner) that can be granted exclusive access to
724  * specific functions.
725  *
726  * By default, the owner account will be the one that deploys the contract. This
727  * can later be changed with {transferOwnership}.
728  *
729  * This module is used through inheritance. It will make available the modifier
730  * `onlyOwner`, which can be applied to your functions to restrict their use to
731  * the owner.
732  */
733 contract Ownable is Context {
734     address private _owner;
735 
736     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
737 
738     /**
739      * @dev Initializes the contract setting the deployer as the initial owner.
740      */
741     constructor () internal {
742         address msgSender = _msgSender();
743         _owner = msgSender;
744         emit OwnershipTransferred(address(0), msgSender);
745     }
746 
747     /**
748      * @dev Returns the address of the current owner.
749      */
750     function owner() public view returns (address) {
751         return _owner;
752     }
753 
754     /**
755      * @dev Throws if called by any account other than the owner.
756      */
757     modifier onlyOwner() {
758         require(_owner == _msgSender(), "Ownable: caller is not the owner");
759         _;
760     }
761 
762     /**
763      * @dev Leaves the contract without owner. It will not be possible to call
764      * `onlyOwner` functions anymore. Can only be called by the current owner.
765      *
766      * NOTE: Renouncing ownership will leave the contract without an owner,
767      * thereby removing any functionality that is only available to the owner.
768      */
769     function renounceOwnership() public virtual onlyOwner {
770         emit OwnershipTransferred(_owner, address(0));
771         _owner = address(0);
772     }
773 
774     /**
775      * @dev Transfers ownership of the contract to a new account (`newOwner`).
776      * Can only be called by the current owner.
777      */
778     function transferOwnership(address newOwner) public virtual onlyOwner {
779         require(newOwner != address(0), "Ownable: new owner is the zero address");
780         emit OwnershipTransferred(_owner, newOwner);
781         _owner = newOwner;
782     }
783 }
784 
785 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
786 
787 
788 contract wksaToken is Context, IERC20, Ownable {
789     using SafeMath for uint256;
790     using Address for address;
791 
792     mapping (address => uint256) private _balances;
793     mapping (address => mapping (address => uint256)) private _allowances;
794     mapping (address => bool) public minters;
795     mapping (address => bool) public blackAccounts;
796 
797     uint256 private _totalSupply;
798     string private _name;
799     string private _symbol;
800     uint8 private _decimals;
801 
802     /**
803      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
804      * a default value of 18.
805      *
806      * To select a different value for {decimals}, use {_setupDecimals}.
807      *
808      * All three of these values are immutable: they can only be set once during
809      * construction.
810      */
811     constructor (string memory name, string memory symbol) public {
812         _name = name;
813         _symbol = symbol;
814         _decimals = 18;
815     }
816 
817     /**
818      * @dev Returns the name of the token.
819      */
820     function name() public view returns (string memory) {
821         return _name;
822     }
823 
824     /**
825      * @dev Returns the symbol of the token, usually a shorter version of the
826      * name.
827      */
828     function symbol() public view returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev Returns the number of decimals used to get its user representation.
834      * For example, if `decimals` equals `2`, a balance of `505` tokens should
835      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
836      *
837      * Tokens usually opt for a value of 18, imitating the relationship between
838      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
839      * called.
840      *
841      * NOTE: This information is only used for _display_ purposes: it in
842      * no way affects any of the arithmetic of the contract, including
843      * {IERC20-balanceOf} and {IERC20-transfer}.
844      */
845     function decimals() public view returns (uint8) {
846         return _decimals;
847     }
848 
849     /**
850      * @dev See {IERC20-totalSupply}.
851      */
852     function totalSupply() public view override returns (uint256) {
853         return _totalSupply;
854     }
855 
856     /**
857      * @dev See {IERC20-balanceOf}.
858      */
859     function balanceOf(address account) public view override returns (uint256) {
860         return _balances[account];
861     }
862 
863     /**
864      * @dev See {IERC20-transfer}.
865      *
866      * Requirements:
867      *
868      * - `recipient` cannot be the zero address.
869      * - the caller must have a balance of at least `amount`.
870      */
871     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
872         require(!blackAccounts[recipient]);
873         _transfer(_msgSender(), recipient, amount);
874         return true;
875     }
876 
877     /**
878      * @dev See {IERC20-allowance}.
879      */
880     function allowance(address owner, address spender) public view virtual override returns (uint256) {
881         return _allowances[owner][spender];
882     }
883 
884     /**
885      * @dev See {IERC20-approve}.
886      *
887      * Requirements:
888      *
889      * - `spender` cannot be the zero address.
890      */
891     function approve(address spender, uint256 amount) public virtual override returns (bool) {
892         _approve(_msgSender(), spender, amount);
893         return true;
894     }
895 
896     /**
897      * @dev See {IERC20-transferFrom}.
898      *
899      * Emits an {Approval} event indicating the updated allowance. This is not
900      * required by the EIP. See the note at the beginning of {ERC20};
901      *
902      * Requirements:
903      * - `sender` and `recipient` cannot be the zero address.
904      * - `sender` must have a balance of at least `amount`.
905      * - the caller must have allowance for ``sender``'s tokens of at least
906      * `amount`.
907      */
908     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
909         require(!blackAccounts[recipient]);
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
969         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
970         _balances[recipient] = _balances[recipient].add(amount);
971         emit Transfer(sender, recipient, amount);
972     }
973 
974     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
975      * the total supply.
976      *
977      * Emits a {Transfer} event with `from` set to the zero address.
978      *
979      * Requirements
980      *
981      * - `to` cannot be the zero address.
982      */
983     function _mint(address account, uint256 amount) internal virtual {
984         require(account != address(0), "ERC20: mint to the zero address");
985 
986         _totalSupply = _totalSupply.add(amount);
987         _balances[account] = _balances[account].add(amount);
988         emit Transfer(address(0), account, amount);
989     }
990 
991     /**
992      * @dev Destroys `amount` tokens from `account`, reducing the
993      * total supply.
994      *
995      * Emits a {Transfer} event with `to` set to the zero address.
996      *
997      * Requirements
998      *
999      * - `account` cannot be the zero address.
1000      * - `account` must have at least `amount` tokens.
1001      */
1002     function _burn(address account, uint256 amount) internal virtual {
1003         require(account != address(0), "ERC20: burn from the zero address");
1004 
1005         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1006         _totalSupply = _totalSupply.sub(amount);
1007         emit Transfer(account, address(0), amount);
1008     }
1009 
1010     /**
1011      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1012      *
1013      * This is internal function is equivalent to `approve`, and can be used to
1014      * e.g. set automatic allowances for certain subsystems, etc.
1015      *
1016      * Emits an {Approval} event.
1017      *
1018      * Requirements:
1019      *
1020      * - `owner` cannot be the zero address.
1021      * - `spender` cannot be the zero address.
1022      */
1023     function _approve(address owner, address spender, uint256 amount) internal virtual {
1024         require(owner != address(0), "ERC20: approve from the zero address");
1025         require(spender != address(0), "ERC20: approve to the zero address");
1026 
1027         _allowances[owner][spender] = amount;
1028         emit Approval(owner, spender, amount);
1029     }
1030 
1031     /**
1032      * @dev Sets {decimals} to a value other than the default one of 18.
1033      *
1034      * WARNING: This function should only be called from the constructor. Most
1035      * applications that interact with token contracts will not expect
1036      * {decimals} to ever change, and may work incorrectly if it does.
1037      */
1038     function _setupDecimals(uint8 decimals_) internal {
1039         _decimals = decimals_;
1040     }
1041 
1042     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
1043     function mint(address _to, uint256 _amount) public{
1044         require(minters[msg.sender], "!minter");
1045         require (totalSupply() + _amount <= 20000*1e18, 'totalSupply exceeds 20000');
1046         _mint(_to, _amount);
1047     }
1048     
1049     function addMinter(address _minter) public onlyOwner{
1050       minters[_minter] = true;
1051     } 
1052   
1053     function removeMinter(address _minter) public onlyOwner{
1054       minters[_minter] = false;
1055     }
1056     
1057     function addBlackAccount(address _account) public onlyOwner{
1058       blackAccounts[_account] = true;
1059     } 
1060   
1061     function removeBlockAccount(address _account) public onlyOwner{
1062       blackAccounts[_account] = false;
1063     }
1064 }
1065 
1066 // File: contracts/caesar.sol
1067 
1068 pragma solidity 0.6.12;
1069 
1070 interface IMigrator {
1071     // Perform LP token migration from legacy UniswapV2 to kkSwap.
1072     // Take the current LP token address and return the new LP token address.
1073     // Migrator should have full access to the caller's LP token.
1074     // Return the new LP token address.
1075     //
1076     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1077     // kkSwap must mint EXACTLY the same amount of kkSwap LP tokens or
1078     // else something bad will happen. Traditional UniswapV2 does not
1079     // do that so be careful!
1080     function migrate(IERC20 token) external returns (IERC20);
1081 }
1082 
1083 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1084 /**
1085  * @dev Required interface of an ERC721 compliant contract.
1086  */
1087 interface IERC721{
1088     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1089     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1090     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1091 
1092     /**
1093      * @dev Returns the number of NFTs in `owner`'s account.
1094      */
1095     function balanceOf(address owner) external view returns (uint256 balance);
1096 
1097     /**
1098      * @dev Returns the owner of the NFT specified by `tokenId`.
1099      */
1100     function ownerOf(uint256 tokenId) external view returns (address owner);
1101 
1102     /**
1103      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1104      * another (`to`).
1105      *
1106      *
1107      *
1108      * Requirements:
1109      * - `from`, `to` cannot be zero.
1110      * - `tokenId` must be owned by `from`.
1111      * - If the caller is not `from`, it must be have been allowed to move this
1112      * NFT by either {approve} or {setApprovalForAll}.
1113      */
1114     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1115     /**
1116      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1117      * another (`to`).
1118      *
1119      * Requirements:
1120      * - If the caller is not `from`, it must be approved to move this NFT by
1121      * either {approve} or {setApprovalForAll}.
1122      */
1123     function transferFrom(address from, address to, uint256 tokenId) external;
1124     function approve(address to, uint256 tokenId) external;
1125     function getApproved(uint256 tokenId) external view returns (address operator);
1126 
1127     function setApprovalForAll(address operator, bool _approved) external;
1128     function isApprovedForAll(address owner, address operator) external view returns (bool);
1129 
1130     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) external;
1131 }
1132 
1133 
1134 
1135 // Caesar is the master of wKSA. He can make wKSA and he is a fair guy.
1136 //
1137 // Note that it's ownable and the owner wields tremendous power. The ownership
1138 // will be transferred to a governance smart contract once wksa is sufficiently
1139 // distributed and the community can show to govern itself.
1140 //
1141 // Have fun reading it. Hopefully it's bug-free. God bless.
1142 contract Caesar is Ownable {
1143     using SafeMath for uint256;
1144     using SafeERC20 for IERC20;
1145 
1146     // Info of each user.
1147     struct UserInfo {
1148         uint256 amount;     // How many LP tokens the user has provided.
1149         uint256 rewardDebt; // Reward debt. See explanation below.
1150         uint256 weight;
1151         uint256 nksnLength;
1152         uint256 nkcnLength;
1153         uint256 nkcmLength;
1154         uint256 inviteNumber;
1155         //
1156         // We do some fancy math here. Basically, any point in time, the amount of wksa
1157         // entitled to a user but is pending to be distributed is:
1158         //
1159         //   pending reward = (user.amount * pool.accWKSAPerShare) - user.rewardDebt
1160         //
1161         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1162         //   1. The pool's `accWKSAPerShare` (and `lastRewardBlock`) gets updated.
1163         //   2. User receives the pending reward sent to his/her address.
1164         //   3. User's `amount` gets updated.
1165         //   4. User's `rewardDebt` gets updated.
1166     }
1167 
1168     // Info of each pool.
1169     struct PoolInfo {
1170         IERC20 lpToken;           // Address of LP token contract.
1171         uint256 allocPoint;       // How many allocation points assigned to this pool. wKSA to distribute per block.
1172         uint256 lastRewardBlock;  // Last block number that wKSA distribution occurs.
1173         uint256 weightedSupply;
1174         uint256 accWKSAPerShare; // Accumulated wKSA per share, times 1e12. See below.
1175     }
1176 
1177     // The wKSA TOKEN!
1178     wksaToken public wksa;
1179     // Block number when bonus wKSA period ends.
1180     uint256 public bonusEndBlock;
1181     // wKSA tokens created per block.
1182     uint256 public wksaPerBlock;
1183     // Bonus muliplier for early wksa makers.
1184     uint256 public constant BONUS_MULTIPLIER = 5;
1185     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1186     IMigrator public migrator;
1187 
1188     // Info of each pool.
1189     PoolInfo[] public poolInfo;
1190     // Info of each user that stakes LP tokens.
1191     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1192     mapping (uint256 => mapping (address => uint256[])) public nksnList;
1193     mapping (uint256 => mapping (address => uint256[])) public nkcnList;
1194     mapping (uint256 => mapping (address => uint256[])) public nkcmList;
1195     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1196     uint256 public totalAllocPoint = 0;
1197     // The block number when wKSA mining starts.
1198     uint256 public startBlock;
1199     // Last user id
1200     uint256 public lastUser;
1201     // Find user's address by id
1202     mapping (uint256 => address) public idToAddr;
1203     // Find user's id by address
1204     mapping (address => uint256) public addrToId;
1205     // Set user's inviter
1206     mapping (address => address) public inviter;
1207     // Amount of userd invited
1208     mapping (address => address[]) public inviterList;
1209     // NFT bonus
1210     mapping (uint256 => uint256) public levelBonus;
1211     // NFT addresses
1212     IERC721 public nksnToken = IERC721(0xEB34C0D43893d72601106AbED8BD413fdba6D0ab);
1213     IERC721 public nkcnToken = IERC721(0xBb23dfb032477e251B260D19AEc4C3641693c688);
1214     IERC721 public nkcmToken = IERC721(0xc22395d3F39715Ca966BebD5489D5303b29b93df);
1215 
1216     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1217     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1218     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1219     event NFTReceived(address operator, address from, uint256 tokenId, bytes data);
1220 
1221     constructor(
1222         wksaToken _wksa,
1223         uint256 _wksaPerBlock,
1224         uint256 _startBlock,
1225         uint256 _bonusEndBlock
1226     ) public {
1227         levelBonus[1] = 1e10;
1228         for (uint256 i = 2; i <= 5; i++) {
1229             levelBonus[i] = levelBonus[i-1] + levelBonus[1].div(2**(i-1));
1230         }
1231         lastUser = 1;
1232 
1233         wksa = _wksa;
1234         wksaPerBlock = _wksaPerBlock;
1235         bonusEndBlock = _bonusEndBlock;
1236         startBlock = _startBlock;
1237     }
1238 
1239     function poolLength() external view returns (uint256) {
1240         return poolInfo.length;
1241     }
1242 
1243     // Add a new lp to the pool. Can only be called by the owner.
1244     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1245     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1246         if (_withUpdate) {
1247             massUpdatePools();
1248         }
1249         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1250         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1251         poolInfo.push(PoolInfo({
1252             lpToken: _lpToken,
1253             allocPoint: _allocPoint,
1254             lastRewardBlock: lastRewardBlock,
1255             weightedSupply: 0,
1256             accWKSAPerShare: 0
1257         }));
1258     }
1259 
1260     // Update the given pool's wKSA allocation point. Can only be called by the owner.
1261     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1262         if (_withUpdate) {
1263             massUpdatePools();
1264         }
1265         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1266         poolInfo[_pid].allocPoint = _allocPoint;
1267     }
1268 
1269     // Set the migrator contract. Can only be called by the owner.
1270     function setMigrator(IMigrator _migrator) public onlyOwner {
1271         migrator = _migrator;
1272     }
1273 
1274     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1275     function migrate(uint256 _pid) public {
1276         require(address(migrator) != address(0), "migrate: no migrator");
1277         PoolInfo storage pool = poolInfo[_pid];
1278         IERC20 lpToken = pool.lpToken;
1279         uint256 bal = lpToken.balanceOf(address(this));
1280         lpToken.safeApprove(address(migrator), bal);
1281         IERC20 newLpToken = migrator.migrate(lpToken);
1282         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1283         pool.lpToken = newLpToken;
1284     }
1285 
1286     // Return reward multiplier over the given _from to _to block.
1287     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1288         if (_to <= bonusEndBlock) {
1289             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1290         } else if (_from >= bonusEndBlock) {
1291             return _to.sub(_from);
1292         } else {
1293             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1294                 _to.sub(bonusEndBlock)
1295             );
1296         }
1297     }
1298 
1299     // Return reward weight on NFTs staked and users invited
1300     function getWeight(uint256 _nksn, uint256 _nkcn, uint256 _nkcm, uint256 _inviteAmount) public view returns (uint256) {
1301         uint256 weight = _inviteAmount.mul(1e10).add(1e12);
1302         if(weight > 120e10){
1303             weight = 120e10;
1304         }
1305         if(_nksn >= 5){
1306             weight = weight.add(levelBonus[5].mul(15));
1307         }
1308         else{
1309             weight = weight.add(levelBonus[_nksn].mul(15));
1310         }
1311         if(_nkcn >= 5){
1312             weight = weight.add(levelBonus[5].mul(10));
1313         }
1314         else{
1315             weight = weight.add(levelBonus[_nkcn].mul(10));
1316         }
1317         if(_nkcm >= 5){
1318             weight = weight.add(levelBonus[5].mul(5));
1319         }
1320         else{
1321             weight = weight.add(levelBonus[_nkcm].mul(5));
1322         }
1323         return weight;
1324     }
1325 
1326     // View function to see pending wKSA on frontend.
1327     function pendingWKSA(uint256 _pid, address _user) external view returns (uint256) {
1328         PoolInfo storage pool = poolInfo[_pid];
1329         UserInfo storage user = userInfo[_pid][_user];
1330         uint256 accWKSAPerShare = pool.accWKSAPerShare;
1331         uint256 lpSupply = pool.weightedSupply;
1332         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1333             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1334             uint256 wksaReward = multiplier.mul(wksaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1335             accWKSAPerShare = accWKSAPerShare.add(wksaReward.mul(1e12).div(lpSupply));
1336         }
1337         return user.amount.mul(user.weight).div(1e12).mul(accWKSAPerShare).div(1e12).sub(user.rewardDebt);
1338     }
1339 
1340     // Update reward vairables for all pools. Be careful of gas spending!
1341     function massUpdatePools() public {
1342         uint256 length = poolInfo.length;
1343         for (uint256 pid = 0; pid < length; ++pid) {
1344             updatePool(pid);
1345         }
1346     }
1347 
1348     // Update reward variables of the given pool to be up-to-date.
1349     function updatePool(uint256 _pid) public {
1350         PoolInfo storage pool = poolInfo[_pid];
1351         if (block.number <= pool.lastRewardBlock) {
1352             return;
1353         }
1354         
1355         uint256 lpSupply = pool.weightedSupply;
1356         if (lpSupply == 0) {
1357             pool.lastRewardBlock = block.number;
1358             return;
1359         }
1360         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1361         uint256 wksaReward = multiplier.mul(wksaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1362         wksa.mint(address(this), wksaReward);
1363         pool.accWKSAPerShare = pool.accWKSAPerShare.add(wksaReward.mul(1e12).div(lpSupply));
1364         pool.lastRewardBlock = block.number;
1365     }
1366     
1367     // Update reward weight of the given pool
1368     function updatePoolWeight(uint256 _pid, address _user) public {
1369         PoolInfo storage pool = poolInfo[_pid];
1370         UserInfo storage user = userInfo[_pid][_user];
1371         
1372         uint newWeight = getWeight(user.nksnLength, user.nkcnLength, user.nkcmLength, user.inviteNumber);
1373         if(newWeight != user.weight){
1374             pool.weightedSupply = pool.weightedSupply.add(user.amount.mul(newWeight).div(1e12)).sub(user.amount.mul(user.weight).div(1e12));
1375         }
1376         
1377     }
1378     
1379     // Update reward weight of the given user
1380     function updateUserWeight(uint256 _pid, address _user) public {
1381         UserInfo storage user = userInfo[_pid][_user];
1382 
1383         uint newWeight = getWeight(user.nksnLength, user.nkcnLength, user.nkcmLength, user.inviteNumber);
1384         if(newWeight != user.weight){
1385             user.weight = newWeight;
1386         }
1387     }
1388 
1389     // Deposit LP tokens to Caesar for wksa allocation.
1390     function deposit(uint256 _pid, uint256 _amount, uint256 _inviter) public {
1391         PoolInfo storage pool = poolInfo[_pid];
1392         UserInfo storage user = userInfo[_pid][msg.sender];
1393         updatePool(_pid);
1394 
1395         if(user.weight == 0){
1396             user.weight = getWeight(user.nksnLength, user.nkcnLength, user.nkcmLength, user.inviteNumber);
1397         }
1398 
1399         if (user.amount > 0) {
1400             uint256 pending = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12).sub(user.rewardDebt);
1401             safeWKSATransfer(msg.sender, pending);
1402         }
1403         
1404         if(_amount > 0 && addrToId[msg.sender] == 0){
1405             addrToId[msg.sender] = lastUser;
1406             idToAddr[lastUser] = msg.sender;
1407             lastUser ++;
1408             
1409             if(_inviter > 0 && _inviter < addrToId[msg.sender] && 
1410             idToAddr[_inviter] != address(0) && inviter[msg.sender] == address(0)){
1411                 inviterList[idToAddr[_inviter]].push(msg.sender);
1412                 UserInfo storage upline = userInfo[_pid][idToAddr[_inviter]];
1413                 upline.inviteNumber ++;
1414                 inviter[msg.sender] = idToAddr[_inviter];
1415 
1416                 if(upline.amount > 0){
1417                     uint256 pending = upline.amount.mul(upline.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12).sub(upline.rewardDebt);
1418                     safeWKSATransfer(idToAddr[_inviter], pending);
1419                 }
1420                 updatePoolWeight(_pid, idToAddr[_inviter]);
1421                 updateUserWeight(_pid, idToAddr[_inviter]);
1422                 upline.rewardDebt = upline.amount.mul(upline.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12);
1423             }
1424         }
1425         
1426         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1427         user.amount = user.amount.add(_amount);
1428         pool.weightedSupply = pool.weightedSupply.add(_amount.mul(user.weight).div(1e12));
1429         user.rewardDebt = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12);
1430         emit Deposit(msg.sender, _pid, _amount);
1431     }
1432 
1433     // Withdraw LP tokens from Caesar.
1434     function withdraw(uint256 _pid, uint256 _amount) public {
1435         PoolInfo storage pool = poolInfo[_pid];
1436         UserInfo storage user = userInfo[_pid][msg.sender];
1437         require(user.amount >= _amount, "withdraw: not good");
1438         updatePool(_pid);
1439         uint256 pending = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12).sub(user.rewardDebt);
1440         safeWKSATransfer(msg.sender, pending);
1441         pool.weightedSupply = pool.weightedSupply.sub(_amount.mul(user.weight).div(1e12));
1442         user.amount = user.amount.sub(_amount);
1443         user.rewardDebt = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12);
1444         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1445         emit Withdraw(msg.sender, _pid, _amount);
1446     }
1447 
1448     // Withdraw without caring about rewards. EMERGENCY ONLY.
1449     function emergencyWithdraw(uint256 _pid) public {
1450         PoolInfo storage pool = poolInfo[_pid];
1451         UserInfo storage user = userInfo[_pid][msg.sender];
1452         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1453         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1454         user.amount = 0;
1455         user.rewardDebt = 0;
1456     }
1457 
1458     // Safe wksa transfer function, just in case if rounding error causes pool to not have enough wksa.
1459     function safeWKSATransfer(address _to, uint256 _amount) internal {
1460         uint256 wksaBal = wksa.balanceOf(address(this));
1461         if (_amount > wksaBal) {
1462             wksa.transfer(_to, wksaBal);
1463         } else {
1464             wksa.transfer(_to, _amount);
1465         }
1466     }
1467     
1468     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
1469         emit NFTReceived(operator, from, tokenId, data);
1470         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
1471     }
1472     
1473     function stakeNKSN(uint256 nksnId, uint256 _pid) public {
1474         PoolInfo storage pool = poolInfo[_pid];
1475         UserInfo storage user = userInfo[_pid][msg.sender];
1476         nksnList[_pid][msg.sender].push(nksnId);
1477         user.nksnLength ++;
1478         nksnToken.safeTransferFrom(msg.sender, address(this), nksnId);
1479         updatePool(_pid);
1480         
1481         if (user.amount > 0) {
1482             uint256 pending = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12).sub(user.rewardDebt);
1483             safeWKSATransfer(msg.sender, pending);
1484         }
1485         updatePoolWeight(_pid, msg.sender);
1486         updateUserWeight(_pid, msg.sender);
1487         user.rewardDebt = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12);
1488     }
1489     
1490     function withdrawNKSN(uint256 nksnId, uint256 _pid) public {
1491         require(nksnId > 0, "the nksnId error");
1492         PoolInfo storage pool = poolInfo[_pid];
1493         UserInfo storage user = userInfo[_pid][msg.sender];
1494         for(uint256 i = 0; i < nksnList[_pid][msg.sender].length; i ++){
1495             if(nksnList[_pid][msg.sender][i] == nksnId){
1496                 nksnList[_pid][msg.sender][i] = nksnList[_pid][msg.sender][nksnList[_pid][msg.sender].length-1];
1497                 nksnList[_pid][msg.sender].pop();
1498                 user.nksnLength --;
1499                 nksnToken.safeTransferFrom(address(this), msg.sender, nksnId);
1500                 break;
1501             }
1502         }
1503         updatePool(_pid);
1504         uint256 pending = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12).sub(user.rewardDebt);
1505         safeWKSATransfer(msg.sender, pending);
1506         updatePoolWeight(_pid, msg.sender);
1507         updateUserWeight(_pid, msg.sender);
1508         user.rewardDebt = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12);
1509     }
1510     
1511     function stakeNKCN(uint256 nkcnId, uint256 _pid) public {
1512         PoolInfo storage pool = poolInfo[_pid];
1513         UserInfo storage user = userInfo[_pid][msg.sender];
1514         nkcnList[_pid][msg.sender].push(nkcnId);
1515         user.nkcnLength ++;
1516         nkcnToken.safeTransferFrom(msg.sender, address(this), nkcnId);
1517         updatePool(_pid);
1518         
1519         if (user.amount > 0) {
1520             uint256 pending = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12).sub(user.rewardDebt);
1521             safeWKSATransfer(msg.sender, pending);
1522         }
1523         updatePoolWeight(_pid, msg.sender);
1524         updateUserWeight(_pid, msg.sender);
1525         user.rewardDebt = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12);
1526     }
1527     
1528     function withdrawNKCN(uint256 nkcnId, uint256 _pid) public {
1529         require(nkcnId > 0, "the nkcnId error");
1530         PoolInfo storage pool = poolInfo[_pid];
1531         UserInfo storage user = userInfo[_pid][msg.sender];
1532         for(uint256 i = 0; i < nkcnList[_pid][msg.sender].length; i ++){
1533             if(nkcnList[_pid][msg.sender][i] == nkcnId){
1534                 nkcnList[_pid][msg.sender][i] = nkcnList[_pid][msg.sender][nkcnList[_pid][msg.sender].length-1];
1535                 nkcnList[_pid][msg.sender].pop();
1536                 user.nkcnLength --;
1537                 nkcnToken.safeTransferFrom(address(this), msg.sender, nkcnId);
1538                 break;
1539             }
1540         }
1541         updatePool(_pid);
1542         uint256 pending = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12).sub(user.rewardDebt);
1543         safeWKSATransfer(msg.sender, pending);
1544         updatePoolWeight(_pid, msg.sender);
1545         updateUserWeight(_pid, msg.sender);
1546         user.rewardDebt = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12);
1547     }
1548     
1549     function stakeNKCM(uint256 nkcmId, uint256 _pid) public {
1550         PoolInfo storage pool = poolInfo[_pid];
1551         UserInfo storage user = userInfo[_pid][msg.sender];
1552         nkcmList[_pid][msg.sender].push(nkcmId);
1553         user.nkcmLength ++ ;
1554         nkcmToken.safeTransferFrom(msg.sender, address(this), nkcmId);
1555         updatePool(_pid);
1556         if (user.amount > 0) {
1557             uint256 pending = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12).sub(user.rewardDebt);
1558             safeWKSATransfer(msg.sender, pending);
1559         }
1560         updatePoolWeight(_pid, msg.sender);
1561         updateUserWeight(_pid, msg.sender);
1562         user.rewardDebt = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12);
1563     }
1564     
1565     function withdrawNKCM(uint256 nkcmId, uint256 _pid) public {
1566         require(nkcmId > 0, "the nksmId error");
1567         PoolInfo storage pool = poolInfo[_pid];
1568         UserInfo storage user = userInfo[_pid][msg.sender];
1569         for(uint256 i = 0; i < nkcmList[_pid][msg.sender].length; i ++){
1570             if(nkcmList[_pid][msg.sender][i] == nkcmId){
1571                 nkcmList[_pid][msg.sender][i] = nkcmList[_pid][msg.sender][nkcmList[_pid][msg.sender].length-1];
1572                 nkcmList[_pid][msg.sender].pop();
1573                 user.nkcmLength --;
1574                 nkcmToken.safeTransferFrom(address(this), msg.sender, nkcmId);
1575                 break;
1576             }
1577         }
1578         updatePool(_pid);
1579         uint256 pending = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12).sub(user.rewardDebt);
1580         safeWKSATransfer(msg.sender, pending);
1581         updatePoolWeight(_pid, msg.sender);
1582         updateUserWeight(_pid, msg.sender);
1583         user.rewardDebt = user.amount.mul(user.weight).div(1e12).mul(pool.accWKSAPerShare).div(1e12);
1584     }
1585 }