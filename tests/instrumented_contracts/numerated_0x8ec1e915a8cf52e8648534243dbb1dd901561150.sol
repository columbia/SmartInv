1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-08
3 */
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
81 
82 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
83 
84 
85 
86 pragma solidity ^0.6.2;
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies in extcodesize, which returns 0 for contracts in
111         // construction, since the code is only stored at the end of the
112         // constructor execution.
113 
114         uint256 size;
115         // solhint-disable-next-line no-inline-assembly
116         assembly { size := extcodesize(account) }
117         return size > 0;
118     }
119 
120     /**
121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
122      * `recipient`, forwarding all available gas and reverting on errors.
123      *
124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
126      * imposed by `transfer`, making them unable to receive funds via
127      * `transfer`. {sendValue} removes this limitation.
128      *
129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
130      *
131      * IMPORTANT: because control is transferred to `recipient`, care must be
132      * taken to not create reentrancy vulnerabilities. Consider using
133      * {ReentrancyGuard} or the
134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
135      */
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
140         (bool success, ) = recipient.call{ value: amount }("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144     /**
145      * @dev Performs a Solidity function call using a low level `call`. A
146      * plain`call` is an unsafe replacement for a function call: use this
147      * function instead.
148      *
149      * If `target` reverts with a revert reason, it is bubbled up by this
150      * function (like regular Solidity function calls).
151      *
152      * Returns the raw returned data. To convert to the expected return value,
153      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
154      *
155      * Requirements:
156      *
157      * - `target` must be a contract.
158      * - calling `target` with `data` must not revert.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163       return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
168      * `errorMessage` as a fallback revert reason when `target` reverts.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
173         return _functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
198         require(address(this).balance >= value, "Address: insufficient balance for call");
199         return _functionCallWithValue(target, data, value, errorMessage);
200     }
201 
202     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
203         require(isContract(target), "Address: call to non-contract");
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
207         if (success) {
208             return returndata;
209         } else {
210             // Look for revert reason and bubble it up if present
211             if (returndata.length > 0) {
212                 // The easiest way to bubble the revert reason is using memory via assembly
213 
214                 // solhint-disable-next-line no-inline-assembly
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
227 
228 
229 
230 pragma solidity ^0.6.0;
231 
232 
233 
234 
235 /**
236  * @title SafeERC20
237  * @dev Wrappers around ERC20 operations that throw on failure (when the token
238  * contract returns false). Tokens that return no value (and instead revert or
239  * throw on failure) are also supported, non-reverting calls are assumed to be
240  * successful.
241  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
242  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
243  */
244 library SafeERC20 {
245     using SafeMath for uint256;
246     using Address for address;
247 
248     function safeTransfer(IERC20 token, address to, uint256 value) internal {
249         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
250     }
251 
252     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
253         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
254     }
255 
256     /**
257      * @dev Deprecated. This function has issues similar to the ones found in
258      * {IERC20-approve}, and its usage is discouraged.
259      *
260      * Whenever possible, use {safeIncreaseAllowance} and
261      * {safeDecreaseAllowance} instead.
262      */
263     function safeApprove(IERC20 token, address spender, uint256 value) internal {
264         // safeApprove should only be called when setting an initial allowance,
265         // or when resetting it to zero. To increase and decrease it, use
266         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
267         // solhint-disable-next-line max-line-length
268         require((value == 0) || (token.allowance(address(this), spender) == 0),
269             "SafeERC20: approve from non-zero to non-zero allowance"
270         );
271         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
272     }
273 
274     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
275         uint256 newAllowance = token.allowance(address(this), spender).add(value);
276         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
277     }
278 
279     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
280         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
281         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
282     }
283 
284     /**
285      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
286      * on the return value: the return value is optional (but if data is returned, it must not be false).
287      * @param token The token targeted by the call.
288      * @param data The call data (encoded using abi.encode or one of its variants).
289      */
290     function _callOptionalReturn(IERC20 token, bytes memory data) private {
291         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
292         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
293         // the target address contains contract code and also asserts for success in the low-level call.
294 
295         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
296         if (returndata.length > 0) { // Return data is optional
297             // solhint-disable-next-line max-line-length
298             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
299         }
300     }
301 }
302 
303 // File: @openzeppelin\contracts\utils\EnumerableSet.sol
304 
305 
306 
307 pragma solidity ^0.6.0;
308 
309 /**
310  * @dev Library for managing
311  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
312  * types.
313  *
314  * Sets have the following properties:
315  *
316  * - Elements are added, removed, and checked for existence in constant time
317  * (O(1)).
318  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
319  *
320  * ```
321  * contract Example {
322  *     // Add the library methods
323  *     using EnumerableSet for EnumerableSet.AddressSet;
324  *
325  *     // Declare a set state variable
326  *     EnumerableSet.AddressSet private mySet;
327  * }
328  * ```
329  *
330  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
331  * (`UintSet`) are supported.
332  */
333 library EnumerableSet {
334     // To implement this library for multiple types with as little code
335     // repetition as possible, we write it in terms of a generic Set type with
336     // bytes32 values.
337     // The Set implementation uses private functions, and user-facing
338     // implementations (such as AddressSet) are just wrappers around the
339     // underlying Set.
340     // This means that we can only create new EnumerableSets for types that fit
341     // in bytes32.
342 
343     struct Set {
344         // Storage of set values
345         bytes32[] _values;
346 
347         // Position of the value in the `values` array, plus 1 because index 0
348         // means a value is not in the set.
349         mapping (bytes32 => uint256) _indexes;
350     }
351 
352     /**
353      * @dev Add a value to a set. O(1).
354      *
355      * Returns true if the value was added to the set, that is if it was not
356      * already present.
357      */
358     function _add(Set storage set, bytes32 value) private returns (bool) {
359         if (!_contains(set, value)) {
360             set._values.push(value);
361             // The value is stored at length-1, but we add 1 to all indexes
362             // and use 0 as a sentinel value
363             set._indexes[value] = set._values.length;
364             return true;
365         } else {
366             return false;
367         }
368     }
369 
370     /**
371      * @dev Removes a value from a set. O(1).
372      *
373      * Returns true if the value was removed from the set, that is if it was
374      * present.
375      */
376     function _remove(Set storage set, bytes32 value) private returns (bool) {
377         // We read and store the value's index to prevent multiple reads from the same storage slot
378         uint256 valueIndex = set._indexes[value];
379 
380         if (valueIndex != 0) { // Equivalent to contains(set, value)
381             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
382             // the array, and then remove the last element (sometimes called as 'swap and pop').
383             // This modifies the order of the array, as noted in {at}.
384 
385             uint256 toDeleteIndex = valueIndex - 1;
386             uint256 lastIndex = set._values.length - 1;
387 
388             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
389             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
390 
391             bytes32 lastvalue = set._values[lastIndex];
392 
393             // Move the last value to the index where the value to delete is
394             set._values[toDeleteIndex] = lastvalue;
395             // Update the index for the moved value
396             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
397 
398             // Delete the slot where the moved value was stored
399             set._values.pop();
400 
401             // Delete the index for the deleted slot
402             delete set._indexes[value];
403 
404             return true;
405         } else {
406             return false;
407         }
408     }
409 
410     /**
411      * @dev Returns true if the value is in the set. O(1).
412      */
413     function _contains(Set storage set, bytes32 value) private view returns (bool) {
414         return set._indexes[value] != 0;
415     }
416 
417     /**
418      * @dev Returns the number of values on the set. O(1).
419      */
420     function _length(Set storage set) private view returns (uint256) {
421         return set._values.length;
422     }
423 
424    /**
425     * @dev Returns the value stored at position `index` in the set. O(1).
426     *
427     * Note that there are no guarantees on the ordering of values inside the
428     * array, and it may change when more values are added or removed.
429     *
430     * Requirements:
431     *
432     * - `index` must be strictly less than {length}.
433     */
434     function _at(Set storage set, uint256 index) private view returns (bytes32) {
435         require(set._values.length > index, "EnumerableSet: index out of bounds");
436         return set._values[index];
437     }
438 
439     // AddressSet
440 
441     struct AddressSet {
442         Set _inner;
443     }
444 
445     /**
446      * @dev Add a value to a set. O(1).
447      *
448      * Returns true if the value was added to the set, that is if it was not
449      * already present.
450      */
451     function add(AddressSet storage set, address value) internal returns (bool) {
452         return _add(set._inner, bytes32(uint256(value)));
453     }
454 
455     /**
456      * @dev Removes a value from a set. O(1).
457      *
458      * Returns true if the value was removed from the set, that is if it was
459      * present.
460      */
461     function remove(AddressSet storage set, address value) internal returns (bool) {
462         return _remove(set._inner, bytes32(uint256(value)));
463     }
464 
465     /**
466      * @dev Returns true if the value is in the set. O(1).
467      */
468     function contains(AddressSet storage set, address value) internal view returns (bool) {
469         return _contains(set._inner, bytes32(uint256(value)));
470     }
471 
472     /**
473      * @dev Returns the number of values in the set. O(1).
474      */
475     function length(AddressSet storage set) internal view returns (uint256) {
476         return _length(set._inner);
477     }
478 
479    /**
480     * @dev Returns the value stored at position `index` in the set. O(1).
481     *
482     * Note that there are no guarantees on the ordering of values inside the
483     * array, and it may change when more values are added or removed.
484     *
485     * Requirements:
486     *
487     * - `index` must be strictly less than {length}.
488     */
489     function at(AddressSet storage set, uint256 index) internal view returns (address) {
490         return address(uint256(_at(set._inner, index)));
491     }
492 
493 
494     // UintSet
495 
496     struct UintSet {
497         Set _inner;
498     }
499 
500     /**
501      * @dev Add a value to a set. O(1).
502      *
503      * Returns true if the value was added to the set, that is if it was not
504      * already present.
505      */
506     function add(UintSet storage set, uint256 value) internal returns (bool) {
507         return _add(set._inner, bytes32(value));
508     }
509 
510     /**
511      * @dev Removes a value from a set. O(1).
512      *
513      * Returns true if the value was removed from the set, that is if it was
514      * present.
515      */
516     function remove(UintSet storage set, uint256 value) internal returns (bool) {
517         return _remove(set._inner, bytes32(value));
518     }
519 
520     /**
521      * @dev Returns true if the value is in the set. O(1).
522      */
523     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
524         return _contains(set._inner, bytes32(value));
525     }
526 
527     /**
528      * @dev Returns the number of values on the set. O(1).
529      */
530     function length(UintSet storage set) internal view returns (uint256) {
531         return _length(set._inner);
532     }
533 
534    /**
535     * @dev Returns the value stored at position `index` in the set. O(1).
536     *
537     * Note that there are no guarantees on the ordering of values inside the
538     * array, and it may change when more values are added or removed.
539     *
540     * Requirements:
541     *
542     * - `index` must be strictly less than {length}.
543     */
544     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
545         return uint256(_at(set._inner, index));
546     }
547 }
548 
549 // File: @openzeppelin\contracts\math\SafeMath.sol
550 
551 
552 
553 pragma solidity ^0.6.0;
554 
555 /**
556  * @dev Wrappers over Solidity's arithmetic operations with added overflow
557  * checks.
558  *
559  * Arithmetic operations in Solidity wrap on overflow. This can easily result
560  * in bugs, because programmers usually assume that an overflow raises an
561  * error, which is the standard behavior in high level programming languages.
562  * `SafeMath` restores this intuition by reverting the transaction when an
563  * operation overflows.
564  *
565  * Using this library instead of the unchecked operations eliminates an entire
566  * class of bugs, so it's recommended to use it always.
567  */
568 library SafeMath {
569     /**
570      * @dev Returns the addition of two unsigned integers, reverting on
571      * overflow.
572      *
573      * Counterpart to Solidity's `+` operator.
574      *
575      * Requirements:
576      *
577      * - Addition cannot overflow.
578      */
579     function add(uint256 a, uint256 b) internal pure returns (uint256) {
580         uint256 c = a + b;
581         require(c >= a, "SafeMath: addition overflow");
582 
583         return c;
584     }
585 
586     /**
587      * @dev Returns the subtraction of two unsigned integers, reverting on
588      * overflow (when the result is negative).
589      *
590      * Counterpart to Solidity's `-` operator.
591      *
592      * Requirements:
593      *
594      * - Subtraction cannot overflow.
595      */
596     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
597         return sub(a, b, "SafeMath: subtraction overflow");
598     }
599 
600     /**
601      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
602      * overflow (when the result is negative).
603      *
604      * Counterpart to Solidity's `-` operator.
605      *
606      * Requirements:
607      *
608      * - Subtraction cannot overflow.
609      */
610     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
611         require(b <= a, errorMessage);
612         uint256 c = a - b;
613 
614         return c;
615     }
616 
617     /**
618      * @dev Returns the multiplication of two unsigned integers, reverting on
619      * overflow.
620      *
621      * Counterpart to Solidity's `*` operator.
622      *
623      * Requirements:
624      *
625      * - Multiplication cannot overflow.
626      */
627     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
628         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
629         // benefit is lost if 'b' is also tested.
630         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
631         if (a == 0) {
632             return 0;
633         }
634 
635         uint256 c = a * b;
636         require(c / a == b, "SafeMath: multiplication overflow");
637 
638         return c;
639     }
640 
641     /**
642      * @dev Returns the integer division of two unsigned integers. Reverts on
643      * division by zero. The result is rounded towards zero.
644      *
645      * Counterpart to Solidity's `/` operator. Note: this function uses a
646      * `revert` opcode (which leaves remaining gas untouched) while Solidity
647      * uses an invalid opcode to revert (consuming all remaining gas).
648      *
649      * Requirements:
650      *
651      * - The divisor cannot be zero.
652      */
653     function div(uint256 a, uint256 b) internal pure returns (uint256) {
654         return div(a, b, "SafeMath: division by zero");
655     }
656 
657     /**
658      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
659      * division by zero. The result is rounded towards zero.
660      *
661      * Counterpart to Solidity's `/` operator. Note: this function uses a
662      * `revert` opcode (which leaves remaining gas untouched) while Solidity
663      * uses an invalid opcode to revert (consuming all remaining gas).
664      *
665      * Requirements:
666      *
667      * - The divisor cannot be zero.
668      */
669     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
670         require(b > 0, errorMessage);
671         uint256 c = a / b;
672         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
673 
674         return c;
675     }
676 
677     /**
678      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
679      * Reverts when dividing by zero.
680      *
681      * Counterpart to Solidity's `%` operator. This function uses a `revert`
682      * opcode (which leaves remaining gas untouched) while Solidity uses an
683      * invalid opcode to revert (consuming all remaining gas).
684      *
685      * Requirements:
686      *
687      * - The divisor cannot be zero.
688      */
689     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
690         return mod(a, b, "SafeMath: modulo by zero");
691     }
692 
693     /**
694      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
695      * Reverts with custom message when dividing by zero.
696      *
697      * Counterpart to Solidity's `%` operator. This function uses a `revert`
698      * opcode (which leaves remaining gas untouched) while Solidity uses an
699      * invalid opcode to revert (consuming all remaining gas).
700      *
701      * Requirements:
702      *
703      * - The divisor cannot be zero.
704      */
705     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
706         require(b != 0, errorMessage);
707         return a % b;
708     }
709 }
710 
711 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
712 
713 
714 
715 pragma solidity ^0.6.0;
716 
717 /*
718  * @dev Provides information about the current execution context, including the
719  * sender of the transaction and its data. While these are generally available
720  * via msg.sender and msg.data, they should not be accessed in such a direct
721  * manner, since when dealing with GSN meta-transactions the account sending and
722  * paying for execution may not be the actual sender (as far as an application
723  * is concerned).
724  *
725  * This contract is only required for intermediate, library-like contracts.
726  */
727 abstract contract Context {
728     function _msgSender() internal view virtual returns (address payable) {
729         return msg.sender;
730     }
731 
732     function _msgData() internal view virtual returns (bytes memory) {
733         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
734         return msg.data;
735     }
736 }
737 
738 // File: @openzeppelin\contracts\access\Ownable.sol
739 
740 
741 
742 pragma solidity ^0.6.0;
743 
744 /**
745  * @dev Contract module which provides a basic access control mechanism, where
746  * there is an account (an owner) that can be granted exclusive access to
747  * specific functions.
748  *
749  * By default, the owner account will be the one that deploys the contract. This
750  * can later be changed with {transferOwnership}.
751  *
752  * This module is used through inheritance. It will make available the modifier
753  * `onlyOwner`, which can be applied to your functions to restrict their use to
754  * the owner.
755  */
756 contract Ownable is Context {
757     address private _owner;
758 
759     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
760 
761     /**
762      * @dev Initializes the contract setting the deployer as the initial owner.
763      */
764     constructor () internal {
765         address msgSender = _msgSender();
766         _owner = msgSender;
767         emit OwnershipTransferred(address(0), msgSender);
768     }
769 
770     /**
771      * @dev Returns the address of the current owner.
772      */
773     function owner() public view returns (address) {
774         return _owner;
775     }
776 
777     /**
778      * @dev Throws if called by any account other than the owner.
779      */
780     modifier onlyOwner() {
781         require(_owner == _msgSender(), "Ownable: caller is not the owner");
782         _;
783     }
784 
785     /**
786      * @dev Leaves the contract without owner. It will not be possible to call
787      * `onlyOwner` functions anymore. Can only be called by the current owner.
788      *
789      * NOTE: Renouncing ownership will leave the contract without an owner,
790      * thereby removing any functionality that is only available to the owner.
791      */
792     function renounceOwnership() public virtual onlyOwner {
793         emit OwnershipTransferred(_owner, address(0));
794         _owner = address(0);
795     }
796 
797     /**
798      * @dev Transfers ownership of the contract to a new account (`newOwner`).
799      * Can only be called by the current owner.
800      */
801     function transferOwnership(address newOwner) public virtual onlyOwner {
802         require(newOwner != address(0), "Ownable: new owner is the zero address");
803         emit OwnershipTransferred(_owner, newOwner);
804         _owner = newOwner;
805     }
806 }
807 
808 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
809 
810 
811 
812 pragma solidity ^0.6.0;
813 
814 
815 
816 
817 
818 /**
819  * @dev Implementation of the {IERC20} interface.
820  *
821  * This implementation is agnostic to the way tokens are created. This means
822  * that a supply mechanism has to be added in a derived contract using {_mint}.
823  * For a generic mechanism see {ERC20PresetMinterPauser}.
824  *
825  * TIP: For a detailed writeup see our guide
826  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
827  * to implement supply mechanisms].
828  *
829  * We have followed general OpenZeppelin guidelines: functions revert instead
830  * of returning `false` on failure. This behavior is nonetheless conventional
831  * and does not conflict with the expectations of ERC20 applications.
832  *
833  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
834  * This allows applications to reconstruct the allowance for all accounts just
835  * by listening to said events. Other implementations of the EIP may not emit
836  * these events, as it isn't required by the specification.
837  *
838  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
839  * functions have been added to mitigate the well-known issues around setting
840  * allowances. See {IERC20-approve}.
841  */
842 contract ERC20 is Context, IERC20 {
843     using SafeMath for uint256;
844     using Address for address;
845 
846     mapping (address => uint256) private _balances;
847 
848     mapping (address => mapping (address => uint256)) private _allowances;
849 
850     uint256 private _totalSupply;
851 
852     string private _name;
853     string private _symbol;
854     uint8 private _decimals;
855 
856     /**
857      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
858      * a default value of 18.
859      *
860      * To select a different value for {decimals}, use {_setupDecimals}.
861      *
862      * All three of these values are immutable: they can only be set once during
863      * construction.
864      */
865     constructor (string memory name, string memory symbol) public {
866         _name = name;
867         _symbol = symbol;
868         _decimals = 18;
869     }
870 
871     /**
872      * @dev Returns the name of the token.
873      */
874     function name() public view returns (string memory) {
875         return _name;
876     }
877 
878     /**
879      * @dev Returns the symbol of the token, usually a shorter version of the
880      * name.
881      */
882     function symbol() public view returns (string memory) {
883         return _symbol;
884     }
885 
886     /**
887      * @dev Returns the number of decimals used to get its user representation.
888      * For example, if `decimals` equals `2`, a balance of `505` tokens should
889      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
890      *
891      * Tokens usually opt for a value of 18, imitating the relationship between
892      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
893      * called.
894      *
895      * NOTE: This information is only used for _display_ purposes: it in
896      * no way affects any of the arithmetic of the contract, including
897      * {IERC20-balanceOf} and {IERC20-transfer}.
898      */
899     function decimals() public view returns (uint8) {
900         return _decimals;
901     }
902 
903     /**
904      * @dev See {IERC20-totalSupply}.
905      */
906     function totalSupply() public view override returns (uint256) {
907         return _totalSupply;
908     }
909 
910     /**
911      * @dev See {IERC20-balanceOf}.
912      */
913     function balanceOf(address account) public view override returns (uint256) {
914         return _balances[account];
915     }
916 
917     /**
918      * @dev See {IERC20-transfer}.
919      *
920      * Requirements:
921      *
922      * - `recipient` cannot be the zero address.
923      * - the caller must have a balance of at least `amount`.
924      */
925     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
926         _transfer(_msgSender(), recipient, amount);
927         return true;
928     }
929 
930     /**
931      * @dev See {IERC20-allowance}.
932      */
933     function allowance(address owner, address spender) public view virtual override returns (uint256) {
934         return _allowances[owner][spender];
935     }
936 
937     /**
938      * @dev See {IERC20-approve}.
939      *
940      * Requirements:
941      *
942      * - `spender` cannot be the zero address.
943      */
944     function approve(address spender, uint256 amount) public virtual override returns (bool) {
945         _approve(_msgSender(), spender, amount);
946         return true;
947     }
948 
949     /**
950      * @dev See {IERC20-transferFrom}.
951      *
952      * Emits an {Approval} event indicating the updated allowance. This is not
953      * required by the EIP. See the note at the beginning of {ERC20};
954      *
955      * Requirements:
956      * - `sender` and `recipient` cannot be the zero address.
957      * - `sender` must have a balance of at least `amount`.
958      * - the caller must have allowance for ``sender``'s tokens of at least
959      * `amount`.
960      */
961     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
962         _transfer(sender, recipient, amount);
963         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
964         return true;
965     }
966 
967     /**
968      * @dev Atomically increases the allowance granted to `spender` by the caller.
969      *
970      * This is an alternative to {approve} that can be used as a mitigation for
971      * problems described in {IERC20-approve}.
972      *
973      * Emits an {Approval} event indicating the updated allowance.
974      *
975      * Requirements:
976      *
977      * - `spender` cannot be the zero address.
978      */
979     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
980         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
981         return true;
982     }
983 
984     /**
985      * @dev Atomically decreases the allowance granted to `spender` by the caller.
986      *
987      * This is an alternative to {approve} that can be used as a mitigation for
988      * problems described in {IERC20-approve}.
989      *
990      * Emits an {Approval} event indicating the updated allowance.
991      *
992      * Requirements:
993      *
994      * - `spender` cannot be the zero address.
995      * - `spender` must have allowance for the caller of at least
996      * `subtractedValue`.
997      */
998     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
999         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1000         return true;
1001     }
1002 
1003     /**
1004      * @dev Moves tokens `amount` from `sender` to `recipient`.
1005      *
1006      * This is internal function is equivalent to {transfer}, and can be used to
1007      * e.g. implement automatic token fees, slashing mechanisms, etc.
1008      *
1009      * Emits a {Transfer} event.
1010      *
1011      * Requirements:
1012      *
1013      * - `sender` cannot be the zero address.
1014      * - `recipient` cannot be the zero address.
1015      * - `sender` must have a balance of at least `amount`.
1016      */
1017     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1018         require(sender != address(0), "ERC20: transfer from the zero address");
1019         require(recipient != address(0), "ERC20: transfer to the zero address");
1020 
1021         _beforeTokenTransfer(sender, recipient, amount);
1022 
1023         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1024         _balances[recipient] = _balances[recipient].add(amount);
1025         emit Transfer(sender, recipient, amount);
1026     }
1027 
1028     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1029      * the total supply.
1030      *
1031      * Emits a {Transfer} event with `from` set to the zero address.
1032      *
1033      * Requirements
1034      *
1035      * - `to` cannot be the zero address.
1036      */
1037     function _mint(address account, uint256 amount) internal virtual {
1038         require(account != address(0), "ERC20: mint to the zero address");
1039 
1040         _beforeTokenTransfer(address(0), account, amount);
1041 
1042         _totalSupply = _totalSupply.add(amount);
1043         _balances[account] = _balances[account].add(amount);
1044         emit Transfer(address(0), account, amount);
1045     }
1046 
1047     /**
1048      * @dev Destroys `amount` tokens from `account`, reducing the
1049      * total supply.
1050      *
1051      * Emits a {Transfer} event with `to` set to the zero address.
1052      *
1053      * Requirements
1054      *
1055      * - `account` cannot be the zero address.
1056      * - `account` must have at least `amount` tokens.
1057      */
1058     function _burn(address account, uint256 amount) internal virtual {
1059         require(account != address(0), "ERC20: burn from the zero address");
1060 
1061         _beforeTokenTransfer(account, address(0), amount);
1062 
1063         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1064         _totalSupply = _totalSupply.sub(amount);
1065         emit Transfer(account, address(0), amount);
1066     }
1067 
1068     /**
1069      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1070      *
1071      * This internal function is equivalent to `approve`, and can be used to
1072      * e.g. set automatic allowances for certain subsystems, etc.
1073      *
1074      * Emits an {Approval} event.
1075      *
1076      * Requirements:
1077      *
1078      * - `owner` cannot be the zero address.
1079      * - `spender` cannot be the zero address.
1080      */
1081     function _approve(address owner, address spender, uint256 amount) internal virtual {
1082         require(owner != address(0), "ERC20: approve from the zero address");
1083         require(spender != address(0), "ERC20: approve to the zero address");
1084 
1085         _allowances[owner][spender] = amount;
1086         emit Approval(owner, spender, amount);
1087     }
1088 
1089     /**
1090      * @dev Sets {decimals} to a value other than the default one of 18.
1091      *
1092      * WARNING: This function should only be called from the constructor. Most
1093      * applications that interact with token contracts will not expect
1094      * {decimals} to ever change, and may work incorrectly if it does.
1095      */
1096     function _setupDecimals(uint8 decimals_) internal {
1097         _decimals = decimals_;
1098     }
1099 
1100     /**
1101      * @dev Hook that is called before any transfer of tokens. This includes
1102      * minting and burning.
1103      *
1104      * Calling conditions:
1105      *
1106      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1107      * will be to transferred to `to`.
1108      * - when `from` is zero, `amount` tokens will be minted for `to`.
1109      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1110      * - `from` and `to` are never both zero.
1111      *
1112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1113      */
1114     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1115 }
1116 
1117 // File: contracts\BCDC.sol
1118 
1119 pragma solidity 0.6.12;
1120 
1121 
1122 
1123 
1124 // BCDC with Governance.
1125 contract BCDC is ERC20("BCDC", "BCDC"), Ownable {
1126     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (0x).
1127     function mint(address _to, uint256 _amount) public onlyOwner {
1128         _mint(_to, _amount);
1129         _moveDelegates(address(0), _delegates[_to], _amount);
1130     }
1131 
1132     /// @notice A record of each accounts delegate
1133     mapping (address => address) internal _delegates;
1134 
1135     /// @notice A checkpoint for marking number of votes from a given block
1136     struct Checkpoint {
1137         uint32 fromBlock;
1138         uint256 votes;
1139     }
1140 
1141     /// @notice A record of votes checkpoints for each account, by index
1142     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1143 
1144     /// @notice The number of checkpoints for each account
1145     mapping (address => uint32) public numCheckpoints;
1146 
1147     /// @notice The EIP-712 typehash for the contract's domain
1148     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1149 
1150     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1151     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1152 
1153     /// @notice A record of states for signing / validating signatures
1154     mapping (address => uint) public nonces;
1155 
1156       /// @notice An event thats emitted when an account changes its delegate
1157     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1158 
1159     /// @notice An event thats emitted when a delegate account's vote balance changes
1160     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1161 
1162     /**
1163      * @notice Delegate votes from `msg.sender` to `delegatee`
1164      * @param delegator The address to get delegatee for
1165      */
1166     function delegates(address delegator)
1167         external
1168         view
1169         returns (address)
1170     {
1171         return _delegates[delegator];
1172     }
1173 
1174    /**
1175     * @notice Delegate votes from `msg.sender` to `delegatee`
1176     * @param delegatee The address to delegate votes to
1177     */
1178     function delegate(address delegatee) external {
1179         return _delegate(msg.sender, delegatee);
1180     }
1181 
1182     /**
1183      * @notice Delegates votes from signatory to `delegatee`
1184      * @param delegatee The address to delegate votes to
1185      * @param nonce The contract state required to match the signature
1186      * @param expiry The time at which to expire the signature
1187      * @param v The recovery byte of the signature
1188      * @param r Half of the ECDSA signature pair
1189      * @param s Half of the ECDSA signature pair
1190      */
1191     function delegateBySig(
1192         address delegatee,
1193         uint nonce,
1194         uint expiry,
1195         uint8 v,
1196         bytes32 r,
1197         bytes32 s
1198     )
1199         external
1200     {
1201         bytes32 domainSeparator = keccak256(
1202             abi.encode(
1203                 DOMAIN_TYPEHASH,
1204                 keccak256(bytes(name())),
1205                 getChainId(),
1206                 address(this)
1207             )
1208         );
1209 
1210         bytes32 structHash = keccak256(
1211             abi.encode(
1212                 DELEGATION_TYPEHASH,
1213                 delegatee,
1214                 nonce,
1215                 expiry
1216             )
1217         );
1218 
1219         bytes32 digest = keccak256(
1220             abi.encodePacked(
1221                 "\x19\x01",
1222                 domainSeparator,
1223                 structHash
1224             )
1225         );
1226 
1227         address signatory = ecrecover(digest, v, r, s);
1228         require(signatory != address(0), "BCDC::delegateBySig: invalid signature");
1229         require(nonce == nonces[signatory]++, "BCDC::delegateBySig: invalid nonce");
1230         require(now <= expiry, "BCDC::delegateBySig: signature expired");
1231         return _delegate(signatory, delegatee);
1232     }
1233 
1234     /**
1235      * @notice Gets the current votes balance for `account`
1236      * @param account The address to get votes balance
1237      * @return The number of current votes for `account`
1238      */
1239     function getCurrentVotes(address account)
1240         external
1241         view
1242         returns (uint256)
1243     {
1244         uint32 nCheckpoints = numCheckpoints[account];
1245         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1246     }
1247 
1248     /**
1249      * @notice Determine the prior number of votes for an account as of a block number
1250      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1251      * @param account The address of the account to check
1252      * @param blockNumber The block number to get the vote balance at
1253      * @return The number of votes the account had as of the given block
1254      */
1255     function getPriorVotes(address account, uint blockNumber)
1256         external
1257         view
1258         returns (uint256)
1259     {
1260         require(blockNumber < block.number, "BCDC::getPriorVotes: not yet determined");
1261 
1262         uint32 nCheckpoints = numCheckpoints[account];
1263         if (nCheckpoints == 0) {
1264             return 0;
1265         }
1266 
1267         // First check most recent balance
1268         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1269             return checkpoints[account][nCheckpoints - 1].votes;
1270         }
1271 
1272         // Next check implicit zero balance
1273         if (checkpoints[account][0].fromBlock > blockNumber) {
1274             return 0;
1275         }
1276 
1277         uint32 lower = 0;
1278         uint32 upper = nCheckpoints - 1;
1279         while (upper > lower) {
1280             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1281             Checkpoint memory cp = checkpoints[account][center];
1282             if (cp.fromBlock == blockNumber) {
1283                 return cp.votes;
1284             } else if (cp.fromBlock < blockNumber) {
1285                 lower = center;
1286             } else {
1287                 upper = center - 1;
1288             }
1289         }
1290         return checkpoints[account][lower].votes;
1291     }
1292 
1293     function _delegate(address delegator, address delegatee)
1294         internal
1295     {
1296         address currentDelegate = _delegates[delegator];
1297         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BCDCs (not scaled);
1298         _delegates[delegator] = delegatee;
1299 
1300         emit DelegateChanged(delegator, currentDelegate, delegatee);
1301 
1302         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1303     }
1304 
1305     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1306         if (srcRep != dstRep && amount > 0) {
1307             if (srcRep != address(0)) {
1308                 // decrease old representative
1309                 uint32 srcRepNum = numCheckpoints[srcRep];
1310                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1311                 uint256 srcRepNew = srcRepOld.sub(amount);
1312                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1313             }
1314 
1315             if (dstRep != address(0)) {
1316                 // increase new representative
1317                 uint32 dstRepNum = numCheckpoints[dstRep];
1318                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1319                 uint256 dstRepNew = dstRepOld.add(amount);
1320                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1321             }
1322         }
1323     }
1324 
1325     function _writeCheckpoint(
1326         address delegatee,
1327         uint32 nCheckpoints,
1328         uint256 oldVotes,
1329         uint256 newVotes
1330     )
1331         internal
1332     {
1333         uint32 blockNumber = safe32(block.number, "BCDC::_writeCheckpoint: block number exceeds 32 bits");
1334 
1335         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1336             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1337         } else {
1338             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1339             numCheckpoints[delegatee] = nCheckpoints + 1;
1340         }
1341 
1342         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1343     }
1344 
1345     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1346         require(n < 2**32, errorMessage);
1347         return uint32(n);
1348     }
1349 
1350     function getChainId() internal pure returns (uint) {
1351         uint256 chainId;
1352         assembly { chainId := chainid() }
1353         return chainId;
1354     }
1355 }
1356 
1357 // File: contracts\BCDCPool.sol
1358 
1359 pragma solidity 0.6.12;
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 
1368 interface IMigratorBCDCPool {
1369     // Perform LP token migration from legacy UniswapV2 to BCDC.
1370     // Take the current LP token address and return the new LP token address.
1371     // Migrator should have full access to the caller's LP token.
1372     // Return the new LP token address.
1373     //
1374     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1375     // BCDC must mint EXACTLY the same amount of BCDC LP tokens or
1376     // else something bad will happen. Traditional UniswapV2 does not
1377     // do that so be careful!
1378     function migrate(IERC20 token) external returns (IERC20);
1379 }
1380 
1381 // BCDCPool is the Bcdc. He can make Bcdc and he is a fair guy.
1382 //
1383 // Note that it's ownable and the owner wields tremendous power. The ownership
1384 // will be transferred to a governance smart contract once BCDC is sufficiently
1385 // distributed and the community can show to govern itself.
1386 //
1387 // Have fun reading it. Hopefully it's bug-free. God bless.
1388 contract BCDCPool is Ownable {
1389     using SafeMath for uint256;
1390     using SafeERC20 for IERC20;
1391 
1392     // Info of each user.
1393     struct UserInfo {
1394         uint256 amount;     // How many LP tokens the user has provided.
1395         uint256 rewardDebt; // Reward debt. See explanation below.
1396         //
1397         // We do some fancy math here. Basically, any point in time, the amount of BCDCs
1398         // entitled to a user but is pending to be distributed is:
1399         //
1400         //   pending reward = (user.amount * pool.accBcdcPerShare) - user.rewardDebt
1401         //
1402         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1403         //   1. The pool's `accBcdcPerShare` (and `lastRewardBlock`) gets updated.
1404         //   2. User receives the pending reward sent to his/her address.
1405         //   3. User's `amount` gets updated.
1406         //   4. User's `rewardDebt` gets updated.
1407     }
1408 
1409     // Info of each pool.
1410     struct PoolInfo {
1411         IERC20 lpToken;           // Address of LP token contract.
1412         uint256 allocPoint;       // How many allocation points assigned to this pool. BCDCs to distribute per block.
1413         uint256 lastRewardBlock;  // Last block number that BCDCs distribution occurs.
1414         uint256 accBcdcPerShare; // Accumulated BCDCs per share, times 1e12. See below.
1415     }
1416 
1417     // The BCDC TOKEN!
1418     BCDC public bcdc;
1419     // Dev address.
1420     address public teamAddr;
1421     // Block number when bonus BCDC period ends.
1422     uint256 public bonusEndBlock;
1423     // BCDC tokens created per block.
1424     uint256 public bcdcPerBlock;
1425     // Bonus muliplier for early bcdc makers.
1426     uint256 public constant BONUS_MULTIPLIER = 2;
1427     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1428     IMigratorBCDCPool public migrator;
1429 
1430     // Info of each pool.
1431     PoolInfo[] public poolInfo;
1432     // Info of each user that stakes LP tokens.
1433     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1434     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1435     uint256 public totalAllocPoint = 0;
1436     // The block number when BCDC mining starts.
1437     uint256 public startBlock;
1438 
1439     uint256 public endBlock;
1440 
1441     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1442     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1443     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1444 
1445     constructor(
1446         BCDC _bcdc,
1447         address _teamAddr,
1448         uint256 _bcdcPerBlock,
1449         uint256 _startBlock,
1450         uint256 _endBlock,
1451         uint256 _bonusEndBlock
1452     ) public {
1453         bcdc = _bcdc;
1454         teamAddr = _teamAddr;
1455         bcdcPerBlock = _bcdcPerBlock;
1456         startBlock = _startBlock;
1457         endBlock = _endBlock;
1458         bonusEndBlock = _bonusEndBlock;
1459     }
1460 
1461     function poolLength() external view returns (uint256) {
1462         return poolInfo.length;
1463     }
1464 
1465     // Add a new lp to the pool. Can only be called by the owner.
1466     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1467     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1468         if (_withUpdate) {
1469             massUpdatePools();
1470         }
1471         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1472         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1473         poolInfo.push(PoolInfo({
1474             lpToken: _lpToken,
1475             allocPoint: _allocPoint,
1476             lastRewardBlock: lastRewardBlock,
1477             accBcdcPerShare: 0
1478         }));
1479     }
1480 
1481     // Update the given pool's BCDC allocation point. Can only be called by the owner.
1482     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1483         if (_withUpdate) {
1484             massUpdatePools();
1485         }
1486         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1487         poolInfo[_pid].allocPoint = _allocPoint;
1488     }
1489 
1490     // Set the migrator contract. Can only be called by the owner.
1491     function setMigrator(IMigratorBCDCPool _migrator) public onlyOwner {
1492         migrator = _migrator;
1493     }
1494 
1495     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1496     function migrate(uint256 _pid) public {
1497         require(address(migrator) != address(0), "migrate: no migrator");
1498         PoolInfo storage pool = poolInfo[_pid];
1499         IERC20 lpToken = pool.lpToken;
1500         uint256 bal = lpToken.balanceOf(address(this));
1501         lpToken.safeApprove(address(migrator), bal);
1502         IERC20 newLpToken = migrator.migrate(lpToken);
1503         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1504         pool.lpToken = newLpToken;
1505     }
1506 
1507     // Return reward multiplier over the given _from to _to block.
1508     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1509         if (_to <= bonusEndBlock) {
1510             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1511         } else if (_from >= bonusEndBlock) {
1512             return _to.sub(_from);
1513         } else {
1514             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1515                 _to.sub(bonusEndBlock)
1516             );
1517         }
1518     }
1519 
1520     // View function to see pending BCDCs on frontend.
1521     function pendingBcdc(uint256 _pid, address _user) external view returns (uint256) {
1522         PoolInfo storage pool = poolInfo[_pid];
1523         UserInfo storage user = userInfo[_pid][_user];
1524         uint256 accBcdcPerShare = pool.accBcdcPerShare;
1525         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1526 
1527         uint256 blockNumber = 0;
1528         if(block.number > endBlock)
1529             blockNumber = endBlock;
1530         else
1531             blockNumber = block.number;
1532 
1533         if (blockNumber > pool.lastRewardBlock && lpSupply != 0) {
1534             uint256 multiplier = getMultiplier(pool.lastRewardBlock, blockNumber);
1535             uint256 bcdcReward = multiplier.mul(bcdcPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1536             accBcdcPerShare = accBcdcPerShare.add(bcdcReward.mul(1e12).div(lpSupply));
1537         }
1538         return user.amount.mul(accBcdcPerShare).div(1e12).sub(user.rewardDebt);
1539     }
1540 
1541     // Update reward vairables for all pools. Be careful of gas spending!
1542     function massUpdatePools() public {
1543         uint256 length = poolInfo.length;
1544         for (uint256 pid = 0; pid < length; ++pid) {
1545             updatePool(pid);
1546         }
1547     }
1548 
1549     // Update reward variables of the given pool to be up-to-date.
1550     function updatePool(uint256 _pid) public {
1551         PoolInfo storage pool = poolInfo[_pid];
1552         if (block.number <= pool.lastRewardBlock) {
1553             return;
1554         }
1555         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1556         if (lpSupply == 0) {
1557             if (block.number > endBlock)
1558                 pool.lastRewardBlock = endBlock;
1559             else
1560                 pool.lastRewardBlock = block.number;
1561             return;
1562         }
1563         if (pool.lastRewardBlock == endBlock){
1564             return;
1565         }
1566 
1567         if (block.number > endBlock){
1568             uint256 multiplier = getMultiplier(pool.lastRewardBlock, endBlock);
1569             uint256 bcdcReward = multiplier.mul(bcdcPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1570             //bcdc.mint(teamAddr, bcdcReward.div(10));
1571             //bcdc.mint(address(this), bcdcReward);
1572             pool.accBcdcPerShare = pool.accBcdcPerShare.add(bcdcReward.mul(1e12).div(lpSupply));
1573             pool.lastRewardBlock = endBlock;
1574             return;
1575         }
1576 
1577         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1578         uint256 bcdcReward = multiplier.mul(bcdcPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1579         //bcdc.mint(teamAddr, bcdcReward.div(10));
1580         //bcdc.mint(address(this), bcdcReward);
1581         pool.accBcdcPerShare = pool.accBcdcPerShare.add(bcdcReward.mul(1e12).div(lpSupply));
1582         pool.lastRewardBlock = block.number;
1583 
1584     }
1585 
1586     // Deposit LP tokens to BCDCPool for BCDC allocation.
1587     function deposit(uint256 _pid, uint256 _amount) public {
1588         PoolInfo storage pool = poolInfo[_pid];
1589         UserInfo storage user = userInfo[_pid][msg.sender];
1590         updatePool(_pid);
1591         if (user.amount > 0) {
1592             uint256 pending = user.amount.mul(pool.accBcdcPerShare).div(1e12).sub(user.rewardDebt);
1593             safeBcdcTransfer(msg.sender, pending);
1594         }
1595         if(_amount > 0) { //kevin
1596             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1597             user.amount = user.amount.add(_amount);
1598         }
1599         user.rewardDebt = user.amount.mul(pool.accBcdcPerShare).div(1e12);
1600         emit Deposit(msg.sender, _pid, _amount);
1601     }
1602 
1603     // DepositFor LP tokens to BCDCPool for BCDC allocation.
1604     function depositFor(address _beneficiary, uint256 _pid, uint256 _amount) public {
1605         PoolInfo storage pool = poolInfo[_pid];
1606         UserInfo storage user = userInfo[_pid][_beneficiary];
1607         updatePool(_pid);
1608         if (user.amount > 0) {
1609             uint256 pending = user.amount.mul(pool.accBcdcPerShare).div(1e12).sub(user.rewardDebt);
1610             safeBcdcTransfer(_beneficiary, pending);
1611         }
1612         if(_amount > 0) { //kevin
1613             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1614             user.amount = user.amount.add(_amount);
1615         }
1616         user.rewardDebt = user.amount.mul(pool.accBcdcPerShare).div(1e12);
1617         emit Deposit(_beneficiary, _pid, _amount);
1618     }
1619 
1620     // Withdraw LP tokens from BCDCPool.
1621     function withdraw(uint256 _pid, uint256 _amount) public {
1622         PoolInfo storage pool = poolInfo[_pid];
1623         UserInfo storage user = userInfo[_pid][msg.sender];
1624         require(user.amount >= _amount, "withdraw: not good");
1625         updatePool(_pid);
1626         uint256 pending = user.amount.mul(pool.accBcdcPerShare).div(1e12).sub(user.rewardDebt);
1627         safeBcdcTransfer(msg.sender, pending);
1628         user.amount = user.amount.sub(_amount);
1629         user.rewardDebt = user.amount.mul(pool.accBcdcPerShare).div(1e12);
1630         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1631         emit Withdraw(msg.sender, _pid, _amount);
1632     }
1633 
1634     // Withdraw without caring about rewards. EMERGENCY ONLY.
1635     function emergencyWithdraw(uint256 _pid) public {
1636         PoolInfo storage pool = poolInfo[_pid];
1637         UserInfo storage user = userInfo[_pid][msg.sender];
1638         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1639         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1640         user.amount = 0;
1641         user.rewardDebt = 0;
1642     }
1643 
1644     // Safe bcdc transfer function, just in case if rounding error causes pool to not have enough BCDCs.
1645     function safeBcdcTransfer(address _to, uint256 _amount) internal {
1646         uint256 bcdcBal = bcdc.balanceOf(address(this));
1647         if (_amount > bcdcBal) {
1648             bcdc.transfer(_to, bcdcBal);
1649         } else {
1650             bcdc.transfer(_to, _amount);
1651         }
1652     }
1653 
1654     // Update dev address by the previous dev.
1655     function dev(address _teamAddr) public {
1656         require(msg.sender == teamAddr, "dev: wut?");
1657         teamAddr = _teamAddr;
1658     }
1659 
1660     // Update dev address by the previous dev.
1661     function setEndBlock(uint256 blockNumber) public onlyOwner {
1662         endBlock = blockNumber;
1663     }
1664 
1665 }