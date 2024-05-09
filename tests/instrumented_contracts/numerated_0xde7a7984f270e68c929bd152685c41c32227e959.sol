1 /*
2  *visit: https://eggy.finance
3  *Discord: https://discord.gg/4nHaXgB
4  *Telegram: https://t.me/eggyfi
5  *Start : Block 10929350
6  *Bonus END: 10930300
7  *Bonus Multiplyer: 4x
8  *Deployer: Omega Protocol Ltd.
9  */
10  
11 pragma solidity ^0.6.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: @openzeppelin/contracts/math/SafeMath.sol
88 
89 
90 
91 pragma solidity ^0.6.0;
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations with added overflow
95  * checks.
96  *
97  * Arithmetic operations in Solidity wrap on overflow. This can easily result
98  * in bugs, because programmers usually assume that an overflow raises an
99  * error, which is the standard behavior in high level programming languages.
100  * `SafeMath` restores this intuition by reverting the transaction when an
101  * operation overflows.
102  *
103  * Using this library instead of the unchecked operations eliminates an entire
104  * class of bugs, so it's recommended to use it always.
105  */
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      *
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      *
163      * - Multiplication cannot overflow.
164      */
165     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167         // benefit is lost if 'b' is also tested.
168         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
169         if (a == 0) {
170             return 0;
171         }
172 
173         uint256 c = a * b;
174         require(c / a == b, "SafeMath: multiplication overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b > 0, errorMessage);
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228         return mod(a, b, "SafeMath: modulo by zero");
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts with custom message when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b != 0, errorMessage);
245         return a % b;
246     }
247 }
248 
249 // File: @openzeppelin/contracts/utils/Address.sol
250 
251 
252 
253 pragma solidity ^0.6.2;
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
278         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
279         // for accounts without code, i.e. `keccak256('')`
280         bytes32 codehash;
281         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
282         // solhint-disable-next-line no-inline-assembly
283         assembly { codehash := extcodehash(account) }
284         return (codehash != accountHash && codehash != 0x0);
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
307         (bool success, ) = recipient.call{ value: amount }("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 
311     /**
312      * @dev Performs a Solidity function call using a low level `call`. A
313      * plain`call` is an unsafe replacement for a function call: use this
314      * function instead.
315      *
316      * If `target` reverts with a revert reason, it is bubbled up by this
317      * function (like regular Solidity function calls).
318      *
319      * Returns the raw returned data. To convert to the expected return value,
320      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
321      *
322      * Requirements:
323      *
324      * - `target` must be a contract.
325      * - calling `target` with `data` must not revert.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
330       return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335      * `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
340         return _functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but also transferring `value` wei to `target`.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least `value`.
350      * - the called Solidity function must be `payable`.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
360      * with `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
365         require(address(this).balance >= value, "Address: insufficient balance for call");
366         return _functionCallWithValue(target, data, value, errorMessage);
367     }
368 
369     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
370         require(isContract(target), "Address: call to non-contract");
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 // solhint-disable-next-line no-inline-assembly
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
394 
395 
396 
397 pragma solidity ^0.6.0;
398 
399 
400 
401 
402 /**
403  * @title SafeERC20
404  * @dev Wrappers around ERC20 operations that throw on failure (when the token
405  * contract returns false). Tokens that return no value (and instead revert or
406  * throw on failure) are also supported, non-reverting calls are assumed to be
407  * successful.
408  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
409  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
410  */
411 library SafeERC20 {
412     using SafeMath for uint256;
413     using Address for address;
414 
415     function safeTransfer(IERC20 token, address to, uint256 value) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
417     }
418 
419     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
420         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
421     }
422 
423     /**
424      * @dev Deprecated. This function has issues similar to the ones found in
425      * {IERC20-approve}, and its usage is discouraged.
426      *
427      * Whenever possible, use {safeIncreaseAllowance} and
428      * {safeDecreaseAllowance} instead.
429      */
430     function safeApprove(IERC20 token, address spender, uint256 value) internal {
431         // safeApprove should only be called when setting an initial allowance,
432         // or when resetting it to zero. To increase and decrease it, use
433         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
434         // solhint-disable-next-line max-line-length
435         require((value == 0) || (token.allowance(address(this), spender) == 0),
436             "SafeERC20: approve from non-zero to non-zero allowance"
437         );
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
439     }
440 
441     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
442         uint256 newAllowance = token.allowance(address(this), spender).add(value);
443         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
444     }
445 
446     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
447         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
449     }
450 
451     /**
452      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
453      * on the return value: the return value is optional (but if data is returned, it must not be false).
454      * @param token The token targeted by the call.
455      * @param data The call data (encoded using abi.encode or one of its variants).
456      */
457     function _callOptionalReturn(IERC20 token, bytes memory data) private {
458         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
459         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
460         // the target address contains contract code and also asserts for success in the low-level call.
461 
462         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
463         if (returndata.length > 0) { // Return data is optional
464             // solhint-disable-next-line max-line-length
465             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
466         }
467     }
468 }
469 
470 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
471 
472 
473 
474 pragma solidity ^0.6.0;
475 
476 /**
477  * @dev Library for managing
478  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
479  * types.
480  *
481  * Sets have the following properties:
482  *
483  * - Elements are added, removed, and checked for existence in constant time
484  * (O(1)).
485  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
486  *
487  * ```
488  * contract Example {
489  *     // Add the library methods
490  *     using EnumerableSet for EnumerableSet.AddressSet;
491  *
492  *     // Declare a set state variable
493  *     EnumerableSet.AddressSet private mySet;
494  * }
495  * ```
496  *
497  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
498  * (`UintSet`) are supported.
499  */
500 library EnumerableSet {
501     // To implement this library for multiple types with as little code
502     // repetition as possible, we write it in terms of a generic Set type with
503     // bytes32 values.
504     // The Set implementation uses private functions, and user-facing
505     // implementations (such as AddressSet) are just wrappers around the
506     // underlying Set.
507     // This means that we can only create new EnumerableSets for types that fit
508     // in bytes32.
509 
510     struct Set {
511         // Storage of set values
512         bytes32[] _values;
513 
514         // Position of the value in the `values` array, plus 1 because index 0
515         // means a value is not in the set.
516         mapping (bytes32 => uint256) _indexes;
517     }
518 
519     /**
520      * @dev Add a value to a set. O(1).
521      *
522      * Returns true if the value was added to the set, that is if it was not
523      * already present.
524      */
525     function _add(Set storage set, bytes32 value) private returns (bool) {
526         if (!_contains(set, value)) {
527             set._values.push(value);
528             // The value is stored at length-1, but we add 1 to all indexes
529             // and use 0 as a sentinel value
530             set._indexes[value] = set._values.length;
531             return true;
532         } else {
533             return false;
534         }
535     }
536 
537     /**
538      * @dev Removes a value from a set. O(1).
539      *
540      * Returns true if the value was removed from the set, that is if it was
541      * present.
542      */
543     function _remove(Set storage set, bytes32 value) private returns (bool) {
544         // We read and store the value's index to prevent multiple reads from the same storage slot
545         uint256 valueIndex = set._indexes[value];
546 
547         if (valueIndex != 0) { // Equivalent to contains(set, value)
548             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
549             // the array, and then remove the last element (sometimes called as 'swap and pop').
550             // This modifies the order of the array, as noted in {at}.
551 
552             uint256 toDeleteIndex = valueIndex - 1;
553             uint256 lastIndex = set._values.length - 1;
554 
555             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
556             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
557 
558             bytes32 lastvalue = set._values[lastIndex];
559 
560             // Move the last value to the index where the value to delete is
561             set._values[toDeleteIndex] = lastvalue;
562             // Update the index for the moved value
563             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
564 
565             // Delete the slot where the moved value was stored
566             set._values.pop();
567 
568             // Delete the index for the deleted slot
569             delete set._indexes[value];
570 
571             return true;
572         } else {
573             return false;
574         }
575     }
576 
577     /**
578      * @dev Returns true if the value is in the set. O(1).
579      */
580     function _contains(Set storage set, bytes32 value) private view returns (bool) {
581         return set._indexes[value] != 0;
582     }
583 
584     /**
585      * @dev Returns the number of values on the set. O(1).
586      */
587     function _length(Set storage set) private view returns (uint256) {
588         return set._values.length;
589     }
590 
591    /**
592     * @dev Returns the value stored at position `index` in the set. O(1).
593     *
594     * Note that there are no guarantees on the ordering of values inside the
595     * array, and it may change when more values are added or removed.
596     *
597     * Requirements:
598     *
599     * - `index` must be strictly less than {length}.
600     */
601     function _at(Set storage set, uint256 index) private view returns (bytes32) {
602         require(set._values.length > index, "EnumerableSet: index out of bounds");
603         return set._values[index];
604     }
605 
606     // AddressSet
607 
608     struct AddressSet {
609         Set _inner;
610     }
611 
612     /**
613      * @dev Add a value to a set. O(1).
614      *
615      * Returns true if the value was added to the set, that is if it was not
616      * already present.
617      */
618     function add(AddressSet storage set, address value) internal returns (bool) {
619         return _add(set._inner, bytes32(uint256(value)));
620     }
621 
622     /**
623      * @dev Removes a value from a set. O(1).
624      *
625      * Returns true if the value was removed from the set, that is if it was
626      * present.
627      */
628     function remove(AddressSet storage set, address value) internal returns (bool) {
629         return _remove(set._inner, bytes32(uint256(value)));
630     }
631 
632     /**
633      * @dev Returns true if the value is in the set. O(1).
634      */
635     function contains(AddressSet storage set, address value) internal view returns (bool) {
636         return _contains(set._inner, bytes32(uint256(value)));
637     }
638 
639     /**
640      * @dev Returns the number of values in the set. O(1).
641      */
642     function length(AddressSet storage set) internal view returns (uint256) {
643         return _length(set._inner);
644     }
645 
646    /**
647     * @dev Returns the value stored at position `index` in the set. O(1).
648     *
649     * Note that there are no guarantees on the ordering of values inside the
650     * array, and it may change when more values are added or removed.
651     *
652     * Requirements:
653     *
654     * - `index` must be strictly less than {length}.
655     */
656     function at(AddressSet storage set, uint256 index) internal view returns (address) {
657         return address(uint256(_at(set._inner, index)));
658     }
659 
660 
661     // UintSet
662 
663     struct UintSet {
664         Set _inner;
665     }
666 
667     /**
668      * @dev Add a value to a set. O(1).
669      *
670      * Returns true if the value was added to the set, that is if it was not
671      * already present.
672      */
673     function add(UintSet storage set, uint256 value) internal returns (bool) {
674         return _add(set._inner, bytes32(value));
675     }
676 
677     /**
678      * @dev Removes a value from a set. O(1).
679      *
680      * Returns true if the value was removed from the set, that is if it was
681      * present.
682      */
683     function remove(UintSet storage set, uint256 value) internal returns (bool) {
684         return _remove(set._inner, bytes32(value));
685     }
686 
687     /**
688      * @dev Returns true if the value is in the set. O(1).
689      */
690     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
691         return _contains(set._inner, bytes32(value));
692     }
693 
694     /**
695      * @dev Returns the number of values on the set. O(1).
696      */
697     function length(UintSet storage set) internal view returns (uint256) {
698         return _length(set._inner);
699     }
700 
701    /**
702     * @dev Returns the value stored at position `index` in the set. O(1).
703     *
704     * Note that there are no guarantees on the ordering of values inside the
705     * array, and it may change when more values are added or removed.
706     *
707     * Requirements:
708     *
709     * - `index` must be strictly less than {length}.
710     */
711     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
712         return uint256(_at(set._inner, index));
713     }
714 }
715 
716 // File: @openzeppelin/contracts/GSN/Context.sol
717 
718 
719 
720 pragma solidity ^0.6.0;
721 
722 /*
723  * @dev Provides information about the current execution context, including the
724  * sender of the transaction and its data. While these are generally available
725  * via msg.sender and msg.data, they should not be accessed in such a direct
726  * manner, since when dealing with GSN meta-transactions the account sending and
727  * paying for execution may not be the actual sender (as far as an application
728  * is concerned).
729  *
730  * This contract is only required for intermediate, library-like contracts.
731  */
732 abstract contract Context {
733     function _msgSender() internal view virtual returns (address payable) {
734         return msg.sender;
735     }
736 
737     function _msgData() internal view virtual returns (bytes memory) {
738         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
739         return msg.data;
740     }
741 }
742 
743 // File: @openzeppelin/contracts/access/Ownable.sol
744 
745 
746 
747 pragma solidity ^0.6.0;
748 
749 /**
750  * @dev Contract module which provides a basic access control mechanism, where
751  * there is an account (an owner) that can be granted exclusive access to
752  * specific functions.
753  *
754  * By default, the owner account will be the one that deploys the contract. This
755  * can later be changed with {transferOwnership}.
756  *
757  * This module is used through inheritance. It will make available the modifier
758  * `onlyOwner`, which can be applied to your functions to restrict their use to
759  * the owner.
760  */
761 contract Ownable is Context {
762     address private _owner;
763 
764     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
765 
766     /**
767      * @dev Initializes the contract setting the deployer as the initial owner.
768      */
769     constructor () internal {
770         address msgSender = _msgSender();
771         _owner = msgSender;
772         emit OwnershipTransferred(address(0), msgSender);
773     }
774 
775     /**
776      * @dev Returns the address of the current owner.
777      */
778     function owner() public view returns (address) {
779         return _owner;
780     }
781 
782     /**
783      * @dev Throws if called by any account other than the owner.
784      */
785     modifier onlyOwner() {
786         require(_owner == _msgSender(), "Ownable: caller is not the owner");
787         _;
788     }
789 
790     /**
791      * @dev Leaves the contract without owner. It will not be possible to call
792      * `onlyOwner` functions anymore. Can only be called by the current owner.
793      *
794      * NOTE: Renouncing ownership will leave the contract without an owner,
795      * thereby removing any functionality that is only available to the owner.
796      */
797     function renounceOwnership() public virtual onlyOwner {
798         emit OwnershipTransferred(_owner, address(0));
799         _owner = address(0);
800     }
801 
802     /**
803      * @dev Transfers ownership of the contract to a new account (`newOwner`).
804      * Can only be called by the current owner.
805      */
806     function transferOwnership(address newOwner) public virtual onlyOwner {
807         require(newOwner != address(0), "Ownable: new owner is the zero address");
808         emit OwnershipTransferred(_owner, newOwner);
809         _owner = newOwner;
810     }
811 }
812 
813 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
814 
815 
816 
817 pragma solidity ^0.6.0;
818 
819 
820 
821 
822 
823 /**
824  * @dev Implementation of the {IERC20} interface.
825  *
826  * This implementation is agnostic to the way tokens are created. This means
827  * that a supply mechanism has to be added in a derived contract using {_mint}.
828  * For a generic mechanism see {ERC20PresetMinterPauser}.
829  *
830  * TIP: For a detailed writeup see our guide
831  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
832  * to implement supply mechanisms].
833  *
834  * We have followed general OpenZeppelin guidelines: functions revert instead
835  * of returning `false` on failure. This behavior is nonetheless conventional
836  * and does not conflict with the expectations of ERC20 applications.
837  *
838  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
839  * This allows applications to reconstruct the allowance for all accounts just
840  * by listening to said events. Other implementations of the EIP may not emit
841  * these events, as it isn't required by the specification.
842  *
843  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
844  * functions have been added to mitigate the well-known issues around setting
845  * allowances. See {IERC20-approve}.
846  */
847 contract ERC20 is Context, IERC20 {
848     using SafeMath for uint256;
849     using Address for address;
850 
851     mapping (address => uint256) private _balances;
852 
853     mapping (address => mapping (address => uint256)) private _allowances;
854 
855     uint256 private _totalSupply;
856 
857     string private _name;
858     string private _symbol;
859     uint8 private _decimals;
860 
861     /**
862      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
863      * a default value of 18.
864      *
865      * To select a different value for {decimals}, use {_setupDecimals}.
866      *
867      * All three of these values are immutable: they can only be set once during
868      * construction.
869      */
870     constructor (string memory name, string memory symbol) public {
871         _name = name;
872         _symbol = symbol;
873         _decimals = 18;
874     }
875 
876     /**
877      * @dev Returns the name of the token.
878      */
879     function name() public view returns (string memory) {
880         return _name;
881     }
882 
883     /**
884      * @dev Returns the symbol of the token, usually a shorter version of the
885      * name.
886      */
887     function symbol() public view returns (string memory) {
888         return _symbol;
889     }
890 
891     /**
892      * @dev Returns the number of decimals used to get its user representation.
893      * For example, if `decimals` equals `2`, a balance of `505` tokens should
894      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
895      *
896      * Tokens usually opt for a value of 18, imitating the relationship between
897      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
898      * called.
899      *
900      * NOTE: This information is only used for _display_ purposes: it in
901      * no way affects any of the arithmetic of the contract, including
902      * {IERC20-balanceOf} and {IERC20-transfer}.
903      */
904     function decimals() public view returns (uint8) {
905         return _decimals;
906     }
907 
908     /**
909      * @dev See {IERC20-totalSupply}.
910      */
911     function totalSupply() public view override returns (uint256) {
912         return _totalSupply;
913     }
914 
915     /**
916      * @dev See {IERC20-balanceOf}.
917      */
918     function balanceOf(address account) public view override returns (uint256) {
919         return _balances[account];
920     }
921 
922     /**
923      * @dev See {IERC20-transfer}.
924      *
925      * Requirements:
926      *
927      * - `recipient` cannot be the zero address.
928      * - the caller must have a balance of at least `amount`.
929      */
930     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
931         _transfer(_msgSender(), recipient, amount);
932         return true;
933     }
934 
935     /**
936      * @dev See {IERC20-allowance}.
937      */
938     function allowance(address owner, address spender) public view virtual override returns (uint256) {
939         return _allowances[owner][spender];
940     }
941 
942     /**
943      * @dev See {IERC20-approve}.
944      *
945      * Requirements:
946      *
947      * - `spender` cannot be the zero address.
948      */
949     function approve(address spender, uint256 amount) public virtual override returns (bool) {
950         _approve(_msgSender(), spender, amount);
951         return true;
952     }
953 
954     /**
955      * @dev See {IERC20-transferFrom}.
956      *
957      * Emits an {Approval} event indicating the updated allowance. This is not
958      * required by the EIP. See the note at the beginning of {ERC20};
959      *
960      * Requirements:
961      * - `sender` and `recipient` cannot be the zero address.
962      * - `sender` must have a balance of at least `amount`.
963      * - the caller must have allowance for ``sender``'s tokens of at least
964      * `amount`.
965      */
966     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
967         _transfer(sender, recipient, amount);
968         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
969         return true;
970     }
971 
972     /**
973      * @dev Atomically increases the allowance granted to `spender` by the caller.
974      *
975      * This is an alternative to {approve} that can be used as a mitigation for
976      * problems described in {IERC20-approve}.
977      *
978      * Emits an {Approval} event indicating the updated allowance.
979      *
980      * Requirements:
981      *
982      * - `spender` cannot be the zero address.
983      */
984     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
985         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
986         return true;
987     }
988 
989     /**
990      * @dev Atomically decreases the allowance granted to `spender` by the caller.
991      *
992      * This is an alternative to {approve} that can be used as a mitigation for
993      * problems described in {IERC20-approve}.
994      *
995      * Emits an {Approval} event indicating the updated allowance.
996      *
997      * Requirements:
998      *
999      * - `spender` cannot be the zero address.
1000      * - `spender` must have allowance for the caller of at least
1001      * `subtractedValue`.
1002      */
1003     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1004         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1005         return true;
1006     }
1007 
1008     /**
1009      * @dev Moves tokens `amount` from `sender` to `recipient`.
1010      *
1011      * This is internal function is equivalent to {transfer}, and can be used to
1012      * e.g. implement automatic token fees, slashing mechanisms, etc.
1013      *
1014      * Emits a {Transfer} event.
1015      *
1016      * Requirements:
1017      *
1018      * - `sender` cannot be the zero address.
1019      * - `recipient` cannot be the zero address.
1020      * - `sender` must have a balance of at least `amount`.
1021      */
1022     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1023         require(sender != address(0), "ERC20: transfer from the zero address");
1024         require(recipient != address(0), "ERC20: transfer to the zero address");
1025 
1026         _beforeTokenTransfer(sender, recipient, amount);
1027 
1028         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1029         _balances[recipient] = _balances[recipient].add(amount);
1030         emit Transfer(sender, recipient, amount);
1031     }
1032 
1033     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1034      * the total supply.
1035      *
1036      * Emits a {Transfer} event with `from` set to the zero address.
1037      *
1038      * Requirements
1039      *
1040      * - `to` cannot be the zero address.
1041      */
1042     function _mint(address account, uint256 amount) internal virtual {
1043         require(account != address(0), "ERC20: mint to the zero address");
1044 
1045         _beforeTokenTransfer(address(0), account, amount);
1046 
1047         _totalSupply = _totalSupply.add(amount);
1048         _balances[account] = _balances[account].add(amount);
1049         emit Transfer(address(0), account, amount);
1050     }
1051 
1052     /**
1053      * @dev Destroys `amount` tokens from `account`, reducing the
1054      * total supply.
1055      *
1056      * Emits a {Transfer} event with `to` set to the zero address.
1057      *
1058      * Requirements
1059      *
1060      * - `account` cannot be the zero address.
1061      * - `account` must have at least `amount` tokens.
1062      */
1063     function _burn(address account, uint256 amount) internal virtual {
1064         require(account != address(0), "ERC20: burn from the zero address");
1065 
1066         _beforeTokenTransfer(account, address(0), amount);
1067 
1068         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1069         _totalSupply = _totalSupply.sub(amount);
1070         emit Transfer(account, address(0), amount);
1071     }
1072 
1073     /**
1074      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1075      *
1076      * This is internal function is equivalent to `approve`, and can be used to
1077      * e.g. set automatic allowances for certain subsystems, etc.
1078      *
1079      * Emits an {Approval} event.
1080      *
1081      * Requirements:
1082      *
1083      * - `owner` cannot be the zero address.
1084      * - `spender` cannot be the zero address.
1085      */
1086     function _approve(address owner, address spender, uint256 amount) internal virtual {
1087         require(owner != address(0), "ERC20: approve from the zero address");
1088         require(spender != address(0), "ERC20: approve to the zero address");
1089 
1090         _allowances[owner][spender] = amount;
1091         emit Approval(owner, spender, amount);
1092     }
1093 
1094     /**
1095      * @dev Sets {decimals} to a value other than the default one of 18.
1096      *
1097      * WARNING: This function should only be called from the constructor. Most
1098      * applications that interact with token contracts will not expect
1099      * {decimals} to ever change, and may work incorrectly if it does.
1100      */
1101     function _setupDecimals(uint8 decimals_) internal {
1102         _decimals = decimals_;
1103     }
1104 
1105     /**
1106      * @dev Hook that is called before any transfer of tokens. This includes
1107      * minting and burning.
1108      *
1109      * Calling conditions:
1110      *
1111      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1112      * will be to transferred to `to`.
1113      * - when `from` is zero, `amount` tokens will be minted for `to`.
1114      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1115      * - `from` and `to` are never both zero.
1116      *
1117      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1118      */
1119     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1120 }
1121 
1122 // File: contracts/EggToken.sol
1123 
1124 pragma solidity 0.6.12;
1125 
1126 
1127 
1128 
1129 // EggToken with Governance.
1130 contract EggToken is ERC20("Eggy.Finance", "EGG"), Ownable {
1131     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1132     function mint(address _to, uint256 _amount) public onlyOwner {
1133         _mint(_to, _amount);
1134         _moveDelegates(address(0), _delegates[_to], _amount);
1135     }
1136 
1137     // Copied and modified from YAM code:
1138     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1139     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1140     // Which is copied and modified from COMPOUND:
1141     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1142 
1143     /// @notice A record of each accounts delegate
1144     mapping (address => address) internal _delegates;
1145 
1146     /// @notice A checkpoint for marking number of votes from a given block
1147     struct Checkpoint {
1148         uint32 fromBlock;
1149         uint256 votes;
1150     }
1151 
1152     /// @notice A record of votes checkpoints for each account, by index
1153     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1154 
1155     /// @notice The number of checkpoints for each account
1156     mapping (address => uint32) public numCheckpoints;
1157 
1158     /// @notice The EIP-712 typehash for the contract's domain
1159     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1160 
1161     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1162     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1163 
1164     /// @notice A record of states for signing / validating signatures
1165     mapping (address => uint) public nonces;
1166 
1167       /// @notice An event thats emitted when an account changes its delegate
1168     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1169 
1170     /// @notice An event thats emitted when a delegate account's vote balance changes
1171     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1172 
1173     /**
1174      * @notice Delegate votes from `msg.sender` to `delegatee`
1175      * @param delegator The address to get delegatee for
1176      */
1177     function delegates(address delegator)
1178         external
1179         view
1180         returns (address)
1181     {
1182         return _delegates[delegator];
1183     }
1184 
1185    /**
1186     * @notice Delegate votes from `msg.sender` to `delegatee`
1187     * @param delegatee The address to delegate votes to
1188     */
1189     function delegate(address delegatee) external {
1190         return _delegate(msg.sender, delegatee);
1191     }
1192 
1193     /**
1194      * @notice Delegates votes from signatory to `delegatee`
1195      * @param delegatee The address to delegate votes to
1196      * @param nonce The contract state required to match the signature
1197      * @param expiry The time at which to expire the signature
1198      * @param v The recovery byte of the signature
1199      * @param r Half of the ECDSA signature pair
1200      * @param s Half of the ECDSA signature pair
1201      */
1202     function delegateBySig(
1203         address delegatee,
1204         uint nonce,
1205         uint expiry,
1206         uint8 v,
1207         bytes32 r,
1208         bytes32 s
1209     )
1210         external
1211     {
1212         bytes32 domainSeparator = keccak256(
1213             abi.encode(
1214                 DOMAIN_TYPEHASH,
1215                 keccak256(bytes(name())),
1216                 getChainId(),
1217                 address(this)
1218             )
1219         );
1220 
1221         bytes32 structHash = keccak256(
1222             abi.encode(
1223                 DELEGATION_TYPEHASH,
1224                 delegatee,
1225                 nonce,
1226                 expiry
1227             )
1228         );
1229 
1230         bytes32 digest = keccak256(
1231             abi.encodePacked(
1232                 "\x19\x01",
1233                 domainSeparator,
1234                 structHash
1235             )
1236         );
1237 
1238         address signatory = ecrecover(digest, v, r, s);
1239         require(signatory != address(0), "EGG::delegateBySig: invalid signature");
1240         require(nonce == nonces[signatory]++, "EGG::delegateBySig: invalid nonce");
1241         require(now <= expiry, "EGG::delegateBySig: signature expired");
1242         return _delegate(signatory, delegatee);
1243     }
1244 
1245     /**
1246      * @notice Gets the current votes balance for `account`
1247      * @param account The address to get votes balance
1248      * @return The number of current votes for `account`
1249      */
1250     function getCurrentVotes(address account)
1251         external
1252         view
1253         returns (uint256)
1254     {
1255         uint32 nCheckpoints = numCheckpoints[account];
1256         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1257     }
1258 
1259     /**
1260      * @notice Determine the prior number of votes for an account as of a block number
1261      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1262      * @param account The address of the account to check
1263      * @param blockNumber The block number to get the vote balance at
1264      * @return The number of votes the account had as of the given block
1265      */
1266     function getPriorVotes(address account, uint blockNumber)
1267         external
1268         view
1269         returns (uint256)
1270     {
1271         require(blockNumber < block.number, "EGG::getPriorVotes: not yet determined");
1272 
1273         uint32 nCheckpoints = numCheckpoints[account];
1274         if (nCheckpoints == 0) {
1275             return 0;
1276         }
1277 
1278         // First check most recent balance
1279         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1280             return checkpoints[account][nCheckpoints - 1].votes;
1281         }
1282 
1283         // Next check implicit zero balance
1284         if (checkpoints[account][0].fromBlock > blockNumber) {
1285             return 0;
1286         }
1287 
1288         uint32 lower = 0;
1289         uint32 upper = nCheckpoints - 1;
1290         while (upper > lower) {
1291             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1292             Checkpoint memory cp = checkpoints[account][center];
1293             if (cp.fromBlock == blockNumber) {
1294                 return cp.votes;
1295             } else if (cp.fromBlock < blockNumber) {
1296                 lower = center;
1297             } else {
1298                 upper = center - 1;
1299             }
1300         }
1301         return checkpoints[account][lower].votes;
1302     }
1303 
1304     function _delegate(address delegator, address delegatee)
1305         internal
1306     {
1307         address currentDelegate = _delegates[delegator];
1308         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying EGGs (not scaled);
1309         _delegates[delegator] = delegatee;
1310 
1311         emit DelegateChanged(delegator, currentDelegate, delegatee);
1312 
1313         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1314     }
1315 
1316     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1317         if (srcRep != dstRep && amount > 0) {
1318             if (srcRep != address(0)) {
1319                 // decrease old representative
1320                 uint32 srcRepNum = numCheckpoints[srcRep];
1321                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1322                 uint256 srcRepNew = srcRepOld.sub(amount);
1323                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1324             }
1325 
1326             if (dstRep != address(0)) {
1327                 // increase new representative
1328                 uint32 dstRepNum = numCheckpoints[dstRep];
1329                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1330                 uint256 dstRepNew = dstRepOld.add(amount);
1331                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1332             }
1333         }
1334     }
1335 
1336     function _writeCheckpoint(
1337         address delegatee,
1338         uint32 nCheckpoints,
1339         uint256 oldVotes,
1340         uint256 newVotes
1341     )
1342         internal
1343     {
1344         uint32 blockNumber = safe32(block.number, "EGG::_writeCheckpoint: block number exceeds 32 bits");
1345 
1346         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1347             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1348         } else {
1349             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1350             numCheckpoints[delegatee] = nCheckpoints + 1;
1351         }
1352 
1353         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1354     }
1355 
1356     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1357         require(n < 2**32, errorMessage);
1358         return uint32(n);
1359     }
1360 
1361     function getChainId() internal pure returns (uint) {
1362         uint256 chainId;
1363         assembly { chainId := chainid() }
1364         return chainId;
1365     }
1366 }
1367 
1368 // File: contracts/MasterChef.sol
1369 
1370 pragma solidity 0.6.12;
1371 
1372 
1373 
1374 
1375 
1376 
1377 
1378 
1379 interface IMigratorChef {
1380    
1381     function migrate(IERC20 token) external returns (IERC20);
1382 }
1383 
1384 
1385 contract MasterChef is Ownable {
1386     using SafeMath for uint256;
1387     using SafeERC20 for IERC20;
1388 
1389     // Info of each user.
1390     struct UserInfo {
1391         uint256 amount;     // How many LP tokens the user has provided.
1392         uint256 rewardDebt; // Reward debt. See explanation below.
1393         //
1394         // We do some fancy math here. Basically, any point in time, the amount of EGGs
1395         // entitled to a user but is pending to be distributed is:
1396         //
1397         //   pending reward = (user.amount * pool.accEggPerShare) - user.rewardDebt
1398         //
1399         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1400         //   1. The pool's `accEggPerShare` (and `lastRewardBlock`) gets updated.
1401         //   2. User receives the pending reward sent to his/her address.
1402         //   3. User's `amount` gets updated.
1403         //   4. User's `rewardDebt` gets updated.
1404     }
1405 
1406     // Info of each pool.
1407     struct PoolInfo {
1408         IERC20 lpToken;           // Address of LP token contract.
1409         uint256 allocPoint;       // How many allocation points assigned to this pool. EGGs to distribute per block.
1410         uint256 lastRewardBlock;  // Last block number that EGGs distribution occurs.
1411         uint256 accEggPerShare; // Accumulated EGGs per share, times 1e12. See below.
1412     }
1413 
1414     // The EGG TOKEN!
1415     EggToken public egg;
1416     // Dev address.
1417     address public devaddr;
1418     // Block number when bonus EGG period ends.
1419     uint256 public bonusEndBlock;
1420     // EGG tokens created per block.
1421     uint256 public eggPerBlock;
1422     // Bonus muliplier for early egg makers.
1423     uint256 public constant BONUS_MULTIPLIER = 4;
1424     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1425     IMigratorChef public migrator;
1426 
1427     // Info of each pool.
1428     PoolInfo[] public poolInfo;
1429     // Info of each user that stakes LP tokens.
1430     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1431     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1432     uint256 public totalAllocPoint = 0;
1433     // The block number when EGG mining starts.
1434     uint256 public startBlock;
1435 
1436     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1437     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1438     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1439 
1440     constructor(
1441         EggToken _egg,
1442         address _devaddr,
1443         uint256 _eggPerBlock,
1444         uint256 _startBlock,
1445         uint256 _bonusEndBlock
1446     ) public {
1447         egg = _egg;
1448         devaddr = _devaddr;
1449         eggPerBlock = _eggPerBlock;
1450         bonusEndBlock = _bonusEndBlock;
1451         startBlock = _startBlock;
1452     }
1453 
1454     function poolLength() external view returns (uint256) {
1455         return poolInfo.length;
1456     }
1457 
1458     // Add a new lp to the pool. Can only be called by the owner.
1459     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1460     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1461         if (_withUpdate) {
1462             massUpdatePools();
1463         }
1464         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1465         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1466         poolInfo.push(PoolInfo({
1467             lpToken: _lpToken,
1468             allocPoint: _allocPoint,
1469             lastRewardBlock: lastRewardBlock,
1470             accEggPerShare: 0
1471         }));
1472     }
1473 
1474     // Update the given pool's EGG allocation point. Can only be called by the owner.
1475     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1476         if (_withUpdate) {
1477             massUpdatePools();
1478         }
1479         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1480         poolInfo[_pid].allocPoint = _allocPoint;
1481     }
1482 
1483     // Set the migrator contract. Can only be called by the owner.
1484     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1485         migrator = _migrator;
1486     }
1487 
1488     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1489     function migrate(uint256 _pid) public {
1490         require(address(migrator) != address(0), "migrate: no migrator");
1491         PoolInfo storage pool = poolInfo[_pid];
1492         IERC20 lpToken = pool.lpToken;
1493         uint256 bal = lpToken.balanceOf(address(this));
1494         lpToken.safeApprove(address(migrator), bal);
1495         IERC20 newLpToken = migrator.migrate(lpToken);
1496         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1497         pool.lpToken = newLpToken;
1498     }
1499 
1500     // Return reward multiplier over the given _from to _to block.
1501     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1502         if (_to <= bonusEndBlock) {
1503             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1504         } else if (_from >= bonusEndBlock) {
1505             return _to.sub(_from);
1506         } else {
1507             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1508                 _to.sub(bonusEndBlock)
1509             );
1510         }
1511     }
1512 
1513     // View function to see pending EGGs on frontend.
1514     function pendingEgg(uint256 _pid, address _user) external view returns (uint256) {
1515         PoolInfo storage pool = poolInfo[_pid];
1516         UserInfo storage user = userInfo[_pid][_user];
1517         uint256 accEggPerShare = pool.accEggPerShare;
1518         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1519         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1520             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1521             uint256 eggReward = multiplier.mul(eggPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1522             accEggPerShare = accEggPerShare.add(eggReward.mul(1e12).div(lpSupply));
1523         }
1524         return user.amount.mul(accEggPerShare).div(1e12).sub(user.rewardDebt);
1525     }
1526 
1527     // Update reward vairables for all pools. Be careful of gas spending!
1528     function massUpdatePools() public {
1529         uint256 length = poolInfo.length;
1530         for (uint256 pid = 0; pid < length; ++pid) {
1531             updatePool(pid);
1532         }
1533     }
1534 
1535     // Update reward variables of the given pool to be up-to-date.
1536     function updatePool(uint256 _pid) public {
1537         PoolInfo storage pool = poolInfo[_pid];
1538         if (block.number <= pool.lastRewardBlock) {
1539             return;
1540         }
1541         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1542         if (lpSupply == 0) {
1543             pool.lastRewardBlock = block.number;
1544             return;
1545         }
1546         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1547         uint256 eggReward = multiplier.mul(eggPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1548         egg.mint(devaddr, eggReward.div(10));
1549         egg.mint(address(this), eggReward);
1550         pool.accEggPerShare = pool.accEggPerShare.add(eggReward.mul(1e12).div(lpSupply));
1551         pool.lastRewardBlock = block.number;
1552     }
1553 
1554     // Deposit LP tokens to MasterChef for EGG allocation.
1555     function deposit(uint256 _pid, uint256 _amount) public {
1556         PoolInfo storage pool = poolInfo[_pid];
1557         UserInfo storage user = userInfo[_pid][msg.sender];
1558         updatePool(_pid);
1559         if (user.amount > 0) {
1560             uint256 pending = user.amount.mul(pool.accEggPerShare).div(1e12).sub(user.rewardDebt);
1561             safeEggTransfer(msg.sender, pending);
1562         }
1563         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1564         user.amount = user.amount.add(_amount);
1565         user.rewardDebt = user.amount.mul(pool.accEggPerShare).div(1e12);
1566         emit Deposit(msg.sender, _pid, _amount);
1567     }
1568 
1569     // Withdraw LP tokens from MasterChef.
1570     function withdraw(uint256 _pid, uint256 _amount) public {
1571         PoolInfo storage pool = poolInfo[_pid];
1572         UserInfo storage user = userInfo[_pid][msg.sender];
1573         require(user.amount >= _amount, "withdraw: not good");
1574         updatePool(_pid);
1575         uint256 pending = user.amount.mul(pool.accEggPerShare).div(1e12).sub(user.rewardDebt);
1576         safeEggTransfer(msg.sender, pending);
1577         user.amount = user.amount.sub(_amount);
1578         user.rewardDebt = user.amount.mul(pool.accEggPerShare).div(1e12);
1579         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1580         emit Withdraw(msg.sender, _pid, _amount);
1581     }
1582 
1583     // Withdraw without caring about rewards. EMERGENCY ONLY.
1584     function emergencyWithdraw(uint256 _pid) public {
1585         PoolInfo storage pool = poolInfo[_pid];
1586         UserInfo storage user = userInfo[_pid][msg.sender];
1587         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1588         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1589         user.amount = 0;
1590         user.rewardDebt = 0;
1591     }
1592 
1593     // Safe egg transfer function, just in case if rounding error causes pool to not have enough EGGs.
1594     function safeEggTransfer(address _to, uint256 _amount) internal {
1595         uint256 eggBal = egg.balanceOf(address(this));
1596         if (_amount > eggBal) {
1597             egg.transfer(_to, eggBal);
1598         } else {
1599             egg.transfer(_to, _amount);
1600         }
1601     }
1602 
1603     // Update dev address by the previous dev.
1604     function dev(address _devaddr) public {
1605         require(msg.sender == devaddr, "dev: wut?");
1606         devaddr = _devaddr;
1607     }
1608 }