1 /*
2  *visit: https://beerhouse.farm
3  *Telegram: https://t.me/BeerHousefarm
4  *Start : Block 10965437
5  *Bonus END: Block 11023037
6  *Bonus Multiplier: 3x
7  *Deployer: Omega Protocol Ltd.
8  */
9  
10 pragma solidity ^0.6.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/math/SafeMath.sol
87 
88 
89 
90 pragma solidity ^0.6.0;
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return div(a, b, "SafeMath: division by zero");
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 
251 
252 pragma solidity ^0.6.2;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
277         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
278         // for accounts without code, i.e. `keccak256('')`
279         bytes32 codehash;
280         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { codehash := extcodehash(account) }
283         return (codehash != accountHash && codehash != 0x0);
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
306         (bool success, ) = recipient.call{ value: amount }("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain`call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329       return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
339         return _functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         return _functionCallWithValue(target, data, value, errorMessage);
366     }
367 
368     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
369         require(isContract(target), "Address: call to non-contract");
370 
371         // solhint-disable-next-line avoid-low-level-calls
372         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 // solhint-disable-next-line no-inline-assembly
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
393 
394 
395 
396 pragma solidity ^0.6.0;
397 
398 
399 
400 
401 /**
402  * @title SafeERC20
403  * @dev Wrappers around ERC20 operations that throw on failure (when the token
404  * contract returns false). Tokens that return no value (and instead revert or
405  * throw on failure) are also supported, non-reverting calls are assumed to be
406  * successful.
407  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
408  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
409  */
410 library SafeERC20 {
411     using SafeMath for uint256;
412     using Address for address;
413 
414     function safeTransfer(IERC20 token, address to, uint256 value) internal {
415         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
416     }
417 
418     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
419         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
420     }
421 
422     /**
423      * @dev Deprecated. This function has issues similar to the ones found in
424      * {IERC20-approve}, and its usage is discouraged.
425      *
426      * Whenever possible, use {safeIncreaseAllowance} and
427      * {safeDecreaseAllowance} instead.
428      */
429     function safeApprove(IERC20 token, address spender, uint256 value) internal {
430         // safeApprove should only be called when setting an initial allowance,
431         // or when resetting it to zero. To increase and decrease it, use
432         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
433         // solhint-disable-next-line max-line-length
434         require((value == 0) || (token.allowance(address(this), spender) == 0),
435             "SafeERC20: approve from non-zero to non-zero allowance"
436         );
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
438     }
439 
440     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).add(value);
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
446         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
447         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
448     }
449 
450     /**
451      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
452      * on the return value: the return value is optional (but if data is returned, it must not be false).
453      * @param token The token targeted by the call.
454      * @param data The call data (encoded using abi.encode or one of its variants).
455      */
456     function _callOptionalReturn(IERC20 token, bytes memory data) private {
457         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
458         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
459         // the target address contains contract code and also asserts for success in the low-level call.
460 
461         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
462         if (returndata.length > 0) { // Return data is optional
463             // solhint-disable-next-line max-line-length
464             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
465         }
466     }
467 }
468 
469 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
470 
471 
472 
473 pragma solidity ^0.6.0;
474 
475 /**
476  * @dev Library for managing
477  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
478  * types.
479  *
480  * Sets have the following properties:
481  *
482  * - Elements are added, removed, and checked for existence in constant time
483  * (O(1)).
484  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
485  *
486  * ```
487  * contract Example {
488  *     // Add the library methods
489  *     using EnumerableSet for EnumerableSet.AddressSet;
490  *
491  *     // Declare a set state variable
492  *     EnumerableSet.AddressSet private mySet;
493  * }
494  * ```
495  *
496  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
497  * (`UintSet`) are supported.
498  */
499 library EnumerableSet {
500     // To implement this library for multiple types with as little code
501     // repetition as possible, we write it in terms of a generic Set type with
502     // bytes32 values.
503     // The Set implementation uses private functions, and user-facing
504     // implementations (such as AddressSet) are just wrappers around the
505     // underlying Set.
506     // This means that we can only create new EnumerableSets for types that fit
507     // in bytes32.
508 
509     struct Set {
510         // Storage of set values
511         bytes32[] _values;
512 
513         // Position of the value in the `values` array, plus 1 because index 0
514         // means a value is not in the set.
515         mapping (bytes32 => uint256) _indexes;
516     }
517 
518     /**
519      * @dev Add a value to a set. O(1).
520      *
521      * Returns true if the value was added to the set, that is if it was not
522      * already present.
523      */
524     function _add(Set storage set, bytes32 value) private returns (bool) {
525         if (!_contains(set, value)) {
526             set._values.push(value);
527             // The value is stored at length-1, but we add 1 to all indexes
528             // and use 0 as a sentinel value
529             set._indexes[value] = set._values.length;
530             return true;
531         } else {
532             return false;
533         }
534     }
535 
536     /**
537      * @dev Removes a value from a set. O(1).
538      *
539      * Returns true if the value was removed from the set, that is if it was
540      * present.
541      */
542     function _remove(Set storage set, bytes32 value) private returns (bool) {
543         // We read and store the value's index to prevent multiple reads from the same storage slot
544         uint256 valueIndex = set._indexes[value];
545 
546         if (valueIndex != 0) { // Equivalent to contains(set, value)
547             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
548             // the array, and then remove the last element (sometimes called as 'swap and pop').
549             // This modifies the order of the array, as noted in {at}.
550 
551             uint256 toDeleteIndex = valueIndex - 1;
552             uint256 lastIndex = set._values.length - 1;
553 
554             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
555             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
556 
557             bytes32 lastvalue = set._values[lastIndex];
558 
559             // Move the last value to the index where the value to delete is
560             set._values[toDeleteIndex] = lastvalue;
561             // Update the index for the moved value
562             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
563 
564             // Delete the slot where the moved value was stored
565             set._values.pop();
566 
567             // Delete the index for the deleted slot
568             delete set._indexes[value];
569 
570             return true;
571         } else {
572             return false;
573         }
574     }
575 
576     /**
577      * @dev Returns true if the value is in the set. O(1).
578      */
579     function _contains(Set storage set, bytes32 value) private view returns (bool) {
580         return set._indexes[value] != 0;
581     }
582 
583     /**
584      * @dev Returns the number of values on the set. O(1).
585      */
586     function _length(Set storage set) private view returns (uint256) {
587         return set._values.length;
588     }
589 
590    /**
591     * @dev Returns the value stored at position `index` in the set. O(1).
592     *
593     * Note that there are no guarantees on the ordering of values inside the
594     * array, and it may change when more values are added or removed.
595     *
596     * Requirements:
597     *
598     * - `index` must be strictly less than {length}.
599     */
600     function _at(Set storage set, uint256 index) private view returns (bytes32) {
601         require(set._values.length > index, "EnumerableSet: index out of bounds");
602         return set._values[index];
603     }
604 
605     // AddressSet
606 
607     struct AddressSet {
608         Set _inner;
609     }
610 
611     /**
612      * @dev Add a value to a set. O(1).
613      *
614      * Returns true if the value was added to the set, that is if it was not
615      * already present.
616      */
617     function add(AddressSet storage set, address value) internal returns (bool) {
618         return _add(set._inner, bytes32(uint256(value)));
619     }
620 
621     /**
622      * @dev Removes a value from a set. O(1).
623      *
624      * Returns true if the value was removed from the set, that is if it was
625      * present.
626      */
627     function remove(AddressSet storage set, address value) internal returns (bool) {
628         return _remove(set._inner, bytes32(uint256(value)));
629     }
630 
631     /**
632      * @dev Returns true if the value is in the set. O(1).
633      */
634     function contains(AddressSet storage set, address value) internal view returns (bool) {
635         return _contains(set._inner, bytes32(uint256(value)));
636     }
637 
638     /**
639      * @dev Returns the number of values in the set. O(1).
640      */
641     function length(AddressSet storage set) internal view returns (uint256) {
642         return _length(set._inner);
643     }
644 
645    /**
646     * @dev Returns the value stored at position `index` in the set. O(1).
647     *
648     * Note that there are no guarantees on the ordering of values inside the
649     * array, and it may change when more values are added or removed.
650     *
651     * Requirements:
652     *
653     * - `index` must be strictly less than {length}.
654     */
655     function at(AddressSet storage set, uint256 index) internal view returns (address) {
656         return address(uint256(_at(set._inner, index)));
657     }
658 
659 
660     // UintSet
661 
662     struct UintSet {
663         Set _inner;
664     }
665 
666     /**
667      * @dev Add a value to a set. O(1).
668      *
669      * Returns true if the value was added to the set, that is if it was not
670      * already present.
671      */
672     function add(UintSet storage set, uint256 value) internal returns (bool) {
673         return _add(set._inner, bytes32(value));
674     }
675 
676     /**
677      * @dev Removes a value from a set. O(1).
678      *
679      * Returns true if the value was removed from the set, that is if it was
680      * present.
681      */
682     function remove(UintSet storage set, uint256 value) internal returns (bool) {
683         return _remove(set._inner, bytes32(value));
684     }
685 
686     /**
687      * @dev Returns true if the value is in the set. O(1).
688      */
689     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
690         return _contains(set._inner, bytes32(value));
691     }
692 
693     /**
694      * @dev Returns the number of values on the set. O(1).
695      */
696     function length(UintSet storage set) internal view returns (uint256) {
697         return _length(set._inner);
698     }
699 
700    /**
701     * @dev Returns the value stored at position `index` in the set. O(1).
702     *
703     * Note that there are no guarantees on the ordering of values inside the
704     * array, and it may change when more values are added or removed.
705     *
706     * Requirements:
707     *
708     * - `index` must be strictly less than {length}.
709     */
710     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
711         return uint256(_at(set._inner, index));
712     }
713 }
714 
715 // File: @openzeppelin/contracts/GSN/Context.sol
716 
717 
718 
719 pragma solidity ^0.6.0;
720 
721 /*
722  * @dev Provides information about the current execution context, including the
723  * sender of the transaction and its data. While these are generally available
724  * via msg.sender and msg.data, they should not be accessed in such a direct
725  * manner, since when dealing with GSN meta-transactions the account sending and
726  * paying for execution may not be the actual sender (as far as an application
727  * is concerned).
728  *
729  * This contract is only required for intermediate, library-like contracts.
730  */
731 abstract contract Context {
732     function _msgSender() internal view virtual returns (address payable) {
733         return msg.sender;
734     }
735 
736     function _msgData() internal view virtual returns (bytes memory) {
737         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
738         return msg.data;
739     }
740 }
741 
742 // File: @openzeppelin/contracts/access/Ownable.sol
743 
744 
745 
746 pragma solidity ^0.6.0;
747 
748 /**
749  * @dev Contract module which provides a basic access control mechanism, where
750  * there is an account (an owner) that can be granted exclusive access to
751  * specific functions.
752  *
753  * By default, the owner account will be the one that deploys the contract. This
754  * can later be changed with {transferOwnership}.
755  *
756  * This module is used through inheritance. It will make available the modifier
757  * `onlyOwner`, which can be applied to your functions to restrict their use to
758  * the owner.
759  */
760 contract Ownable is Context {
761     address private _owner;
762 
763     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
764 
765     /**
766      * @dev Initializes the contract setting the deployer as the initial owner.
767      */
768     constructor () internal {
769         address msgSender = _msgSender();
770         _owner = msgSender;
771         emit OwnershipTransferred(address(0), msgSender);
772     }
773 
774     /**
775      * @dev Returns the address of the current owner.
776      */
777     function owner() public view returns (address) {
778         return _owner;
779     }
780 
781     /**
782      * @dev Throws if called by any account other than the owner.
783      */
784     modifier onlyOwner() {
785         require(_owner == _msgSender(), "Ownable: caller is not the owner");
786         _;
787     }
788 
789     /**
790      * @dev Leaves the contract without owner. It will not be possible to call
791      * `onlyOwner` functions anymore. Can only be called by the current owner.
792      *
793      * NOTE: Renouncing ownership will leave the contract without an owner,
794      * thereby removing any functionality that is only available to the owner.
795      */
796     function renounceOwnership() public virtual onlyOwner {
797         emit OwnershipTransferred(_owner, address(0));
798         _owner = address(0);
799     }
800 
801     /**
802      * @dev Transfers ownership of the contract to a new account (`newOwner`).
803      * Can only be called by the current owner.
804      */
805     function transferOwnership(address newOwner) public virtual onlyOwner {
806         require(newOwner != address(0), "Ownable: new owner is the zero address");
807         emit OwnershipTransferred(_owner, newOwner);
808         _owner = newOwner;
809     }
810 }
811 
812 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
813 
814 
815 
816 pragma solidity ^0.6.0;
817 
818 
819 
820 
821 
822 /**
823  * @dev Implementation of the {IERC20} interface.
824  *
825  * This implementation is agnostic to the way tokens are created. This means
826  * that a supply mechanism has to be added in a derived contract using {_mint}.
827  * For a generic mechanism see {ERC20PresetMinterPauser}.
828  *
829  * TIP: For a detailed writeup see our guide
830  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
831  * to implement supply mechanisms].
832  *
833  * We have followed general OpenZeppelin guidelines: functions revert instead
834  * of returning `false` on failure. This behavior is nonetheless conventional
835  * and does not conflict with the expectations of ERC20 applications.
836  *
837  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
838  * This allows applications to reconstruct the allowance for all accounts just
839  * by listening to said events. Other implementations of the EIP may not emit
840  * these events, as it isn't required by the specification.
841  *
842  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
843  * functions have been added to mitigate the well-known issues around setting
844  * allowances. See {IERC20-approve}.
845  */
846 contract ERC20 is Context, IERC20 {
847     using SafeMath for uint256;
848     using Address for address;
849 
850     mapping (address => uint256) private _balances;
851 
852     mapping (address => mapping (address => uint256)) private _allowances;
853 
854     uint256 private _totalSupply;
855 
856     string private _name;
857     string private _symbol;
858     uint8 private _decimals;
859 
860     /**
861      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
862      * a default value of 18.
863      *
864      * To select a different value for {decimals}, use {_setupDecimals}.
865      *
866      * All three of these values are immutable: they can only be set once during
867      * construction.
868      */
869     constructor (string memory name, string memory symbol) public {
870         _name = name;
871         _symbol = symbol;
872         _decimals = 18;
873     }
874 
875     /**
876      * @dev Returns the name of the token.
877      */
878     function name() public view returns (string memory) {
879         return _name;
880     }
881 
882     /**
883      * @dev Returns the symbol of the token, usually a shorter version of the
884      * name.
885      */
886     function symbol() public view returns (string memory) {
887         return _symbol;
888     }
889 
890     /**
891      * @dev Returns the number of decimals used to get its user representation.
892      * For example, if `decimals` equals `2`, a balance of `505` tokens should
893      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
894      *
895      * Tokens usually opt for a value of 18, imitating the relationship between
896      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
897      * called.
898      *
899      * NOTE: This information is only used for _display_ purposes: it in
900      * no way affects any of the arithmetic of the contract, including
901      * {IERC20-balanceOf} and {IERC20-transfer}.
902      */
903     function decimals() public view returns (uint8) {
904         return _decimals;
905     }
906 
907     /**
908      * @dev See {IERC20-totalSupply}.
909      */
910     function totalSupply() public view override returns (uint256) {
911         return _totalSupply;
912     }
913 
914     /**
915      * @dev See {IERC20-balanceOf}.
916      */
917     function balanceOf(address account) public view override returns (uint256) {
918         return _balances[account];
919     }
920 
921     /**
922      * @dev See {IERC20-transfer}.
923      *
924      * Requirements:
925      *
926      * - `recipient` cannot be the zero address.
927      * - the caller must have a balance of at least `amount`.
928      */
929     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
930         _transfer(_msgSender(), recipient, amount);
931         return true;
932     }
933 
934     /**
935      * @dev See {IERC20-allowance}.
936      */
937     function allowance(address owner, address spender) public view virtual override returns (uint256) {
938         return _allowances[owner][spender];
939     }
940 
941     /**
942      * @dev See {IERC20-approve}.
943      *
944      * Requirements:
945      *
946      * - `spender` cannot be the zero address.
947      */
948     function approve(address spender, uint256 amount) public virtual override returns (bool) {
949         _approve(_msgSender(), spender, amount);
950         return true;
951     }
952 
953     /**
954      * @dev See {IERC20-transferFrom}.
955      *
956      * Emits an {Approval} event indicating the updated allowance. This is not
957      * required by the EIP. See the note at the beginning of {ERC20};
958      *
959      * Requirements:
960      * - `sender` and `recipient` cannot be the zero address.
961      * - `sender` must have a balance of at least `amount`.
962      * - the caller must have allowance for ``sender``'s tokens of at least
963      * `amount`.
964      */
965     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
966         _transfer(sender, recipient, amount);
967         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
968         return true;
969     }
970 
971     /**
972      * @dev Atomically increases the allowance granted to `spender` by the caller.
973      *
974      * This is an alternative to {approve} that can be used as a mitigation for
975      * problems described in {IERC20-approve}.
976      *
977      * Emits an {Approval} event indicating the updated allowance.
978      *
979      * Requirements:
980      *
981      * - `spender` cannot be the zero address.
982      */
983     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
984         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
985         return true;
986     }
987 
988     /**
989      * @dev Atomically decreases the allowance granted to `spender` by the caller.
990      *
991      * This is an alternative to {approve} that can be used as a mitigation for
992      * problems described in {IERC20-approve}.
993      *
994      * Emits an {Approval} event indicating the updated allowance.
995      *
996      * Requirements:
997      *
998      * - `spender` cannot be the zero address.
999      * - `spender` must have allowance for the caller of at least
1000      * `subtractedValue`.
1001      */
1002     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1003         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1004         return true;
1005     }
1006 
1007     /**
1008      * @dev Moves tokens `amount` from `sender` to `recipient`.
1009      *
1010      * This is internal function is equivalent to {transfer}, and can be used to
1011      * e.g. implement automatic token fees, slashing mechanisms, etc.
1012      *
1013      * Emits a {Transfer} event.
1014      *
1015      * Requirements:
1016      *
1017      * - `sender` cannot be the zero address.
1018      * - `recipient` cannot be the zero address.
1019      * - `sender` must have a balance of at least `amount`.
1020      */
1021     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1022         require(sender != address(0), "ERC20: transfer from the zero address");
1023         require(recipient != address(0), "ERC20: transfer to the zero address");
1024 
1025         _beforeTokenTransfer(sender, recipient, amount);
1026 
1027         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1028         _balances[recipient] = _balances[recipient].add(amount);
1029         emit Transfer(sender, recipient, amount);
1030     }
1031 
1032     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1033      * the total supply.
1034      *
1035      * Emits a {Transfer} event with `from` set to the zero address.
1036      *
1037      * Requirements
1038      *
1039      * - `to` cannot be the zero address.
1040      */
1041     function _mint(address account, uint256 amount) internal virtual {
1042         require(account != address(0), "ERC20: mint to the zero address");
1043 
1044         _beforeTokenTransfer(address(0), account, amount);
1045 
1046         _totalSupply = _totalSupply.add(amount);
1047         _balances[account] = _balances[account].add(amount);
1048         emit Transfer(address(0), account, amount);
1049     }
1050 
1051     /**
1052      * @dev Destroys `amount` tokens from `account`, reducing the
1053      * total supply.
1054      *
1055      * Emits a {Transfer} event with `to` set to the zero address.
1056      *
1057      * Requirements
1058      *
1059      * - `account` cannot be the zero address.
1060      * - `account` must have at least `amount` tokens.
1061      */
1062     function _burn(address account, uint256 amount) internal virtual {
1063         require(account != address(0), "ERC20: burn from the zero address");
1064 
1065         _beforeTokenTransfer(account, address(0), amount);
1066 
1067         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1068         _totalSupply = _totalSupply.sub(amount);
1069         emit Transfer(account, address(0), amount);
1070     }
1071 
1072     /**
1073      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1074      *
1075      * This is internal function is equivalent to `approve`, and can be used to
1076      * e.g. set automatic allowances for certain subsystems, etc.
1077      *
1078      * Emits an {Approval} event.
1079      *
1080      * Requirements:
1081      *
1082      * - `owner` cannot be the zero address.
1083      * - `spender` cannot be the zero address.
1084      */
1085     function _approve(address owner, address spender, uint256 amount) internal virtual {
1086         require(owner != address(0), "ERC20: approve from the zero address");
1087         require(spender != address(0), "ERC20: approve to the zero address");
1088 
1089         _allowances[owner][spender] = amount;
1090         emit Approval(owner, spender, amount);
1091     }
1092 
1093     /**
1094      * @dev Sets {decimals} to a value other than the default one of 18.
1095      *
1096      * WARNING: This function should only be called from the constructor. Most
1097      * applications that interact with token contracts will not expect
1098      * {decimals} to ever change, and may work incorrectly if it does.
1099      */
1100     function _setupDecimals(uint8 decimals_) internal {
1101         _decimals = decimals_;
1102     }
1103 
1104     /**
1105      * @dev Hook that is called before any transfer of tokens. This includes
1106      * minting and burning.
1107      *
1108      * Calling conditions:
1109      *
1110      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1111      * will be to transferred to `to`.
1112      * - when `from` is zero, `amount` tokens will be minted for `to`.
1113      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1114      * - `from` and `to` are never both zero.
1115      *
1116      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1117      */
1118     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1119 }
1120 
1121 // File: contracts/BeerToken.sol
1122 
1123 pragma solidity 0.6.12;
1124 
1125 
1126 
1127 
1128 // BeerToken with Governance.
1129 contract BeerToken is ERC20("Beer Token", "BEER"), Ownable {
1130     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (BrewMaster).
1131     function mint(address _to, uint256 _amount) public onlyOwner {
1132         _mint(_to, _amount);
1133         _moveDelegates(address(0), _delegates[_to], _amount);
1134     }
1135 
1136   
1137 
1138     /// @notice A record of each accounts delegate
1139     mapping (address => address) internal _delegates;
1140 
1141     /// @notice A checkpoint for marking number of votes from a given block
1142     struct Checkpoint {
1143         uint32 fromBlock;
1144         uint256 votes;
1145     }
1146 
1147     /// @notice A record of votes checkpoints for each account, by index
1148     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1149 
1150     /// @notice The number of checkpoints for each account
1151     mapping (address => uint32) public numCheckpoints;
1152 
1153     /// @notice The EIP-712 typehash for the contract's domain
1154     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1155 
1156     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1157     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1158 
1159     /// @notice A record of states for signing / validating signatures
1160     mapping (address => uint) public nonces;
1161 
1162       /// @notice An event thats emitted when an account changes its delegate
1163     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1164 
1165     /// @notice An event thats emitted when a delegate account's vote balance changes
1166     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1167 
1168     /**
1169      * @notice Delegate votes from `msg.sender` to `delegatee`
1170      * @param delegator The address to get delegatee for
1171      */
1172     function delegates(address delegator)
1173         external
1174         view
1175         returns (address)
1176     {
1177         return _delegates[delegator];
1178     }
1179 
1180    /**
1181     * @notice Delegate votes from `msg.sender` to `delegatee`
1182     * @param delegatee The address to delegate votes to
1183     */
1184     function delegate(address delegatee) external {
1185         return _delegate(msg.sender, delegatee);
1186     }
1187 
1188     /**
1189      * @notice Delegates votes from signatory to `delegatee`
1190      * @param delegatee The address to delegate votes to
1191      * @param nonce The contract state required to match the signature
1192      * @param expiry The time at which to expire the signature
1193      * @param v The recovery byte of the signature
1194      * @param r Half of the ECDSA signature pair
1195      * @param s Half of the ECDSA signature pair
1196      */
1197     function delegateBySig(
1198         address delegatee,
1199         uint nonce,
1200         uint expiry,
1201         uint8 v,
1202         bytes32 r,
1203         bytes32 s
1204     )
1205         external
1206     {
1207         bytes32 domainSeparator = keccak256(
1208             abi.encode(
1209                 DOMAIN_TYPEHASH,
1210                 keccak256(bytes(name())),
1211                 getChainId(),
1212                 address(this)
1213             )
1214         );
1215 
1216         bytes32 structHash = keccak256(
1217             abi.encode(
1218                 DELEGATION_TYPEHASH,
1219                 delegatee,
1220                 nonce,
1221                 expiry
1222             )
1223         );
1224 
1225         bytes32 digest = keccak256(
1226             abi.encodePacked(
1227                 "\x19\x01",
1228                 domainSeparator,
1229                 structHash
1230             )
1231         );
1232 
1233         address signatory = ecrecover(digest, v, r, s);
1234         require(signatory != address(0), "BEER::delegateBySig: invalid signature");
1235         require(nonce == nonces[signatory]++, "BEER::delegateBySig: invalid nonce");
1236         require(now <= expiry, "BEER::delegateBySig: signature expired");
1237         return _delegate(signatory, delegatee);
1238     }
1239 
1240     /**
1241      * @notice Gets the current votes balance for `account`
1242      * @param account The address to get votes balance
1243      * @return The number of current votes for `account`
1244      */
1245     function getCurrentVotes(address account)
1246         external
1247         view
1248         returns (uint256)
1249     {
1250         uint32 nCheckpoints = numCheckpoints[account];
1251         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1252     }
1253 
1254     /**
1255      * @notice Determine the prior number of votes for an account as of a block number
1256      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1257      * @param account The address of the account to check
1258      * @param blockNumber The block number to get the vote balance at
1259      * @return The number of votes the account had as of the given block
1260      */
1261     function getPriorVotes(address account, uint blockNumber)
1262         external
1263         view
1264         returns (uint256)
1265     {
1266         require(blockNumber < block.number, "BEER::getPriorVotes: not yet determined");
1267 
1268         uint32 nCheckpoints = numCheckpoints[account];
1269         if (nCheckpoints == 0) {
1270             return 0;
1271         }
1272 
1273         // First check most recent balance
1274         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1275             return checkpoints[account][nCheckpoints - 1].votes;
1276         }
1277 
1278         // Next check implicit zero balance
1279         if (checkpoints[account][0].fromBlock > blockNumber) {
1280             return 0;
1281         }
1282 
1283         uint32 lower = 0;
1284         uint32 upper = nCheckpoints - 1;
1285         while (upper > lower) {
1286             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1287             Checkpoint memory cp = checkpoints[account][center];
1288             if (cp.fromBlock == blockNumber) {
1289                 return cp.votes;
1290             } else if (cp.fromBlock < blockNumber) {
1291                 lower = center;
1292             } else {
1293                 upper = center - 1;
1294             }
1295         }
1296         return checkpoints[account][lower].votes;
1297     }
1298 
1299     function _delegate(address delegator, address delegatee)
1300         internal
1301     {
1302         address currentDelegate = _delegates[delegator];
1303         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BEERs (not scaled);
1304         _delegates[delegator] = delegatee;
1305 
1306         emit DelegateChanged(delegator, currentDelegate, delegatee);
1307 
1308         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1309     }
1310 
1311     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1312         if (srcRep != dstRep && amount > 0) {
1313             if (srcRep != address(0)) {
1314                 // decrease old representative
1315                 uint32 srcRepNum = numCheckpoints[srcRep];
1316                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1317                 uint256 srcRepNew = srcRepOld.sub(amount);
1318                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1319             }
1320 
1321             if (dstRep != address(0)) {
1322                 // increase new representative
1323                 uint32 dstRepNum = numCheckpoints[dstRep];
1324                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1325                 uint256 dstRepNew = dstRepOld.add(amount);
1326                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1327             }
1328         }
1329     }
1330 
1331     function _writeCheckpoint(
1332         address delegatee,
1333         uint32 nCheckpoints,
1334         uint256 oldVotes,
1335         uint256 newVotes
1336     )
1337         internal
1338     {
1339         uint32 blockNumber = safe32(block.number, "BEER::_writeCheckpoint: block number exceeds 32 bits");
1340 
1341         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1342             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1343         } else {
1344             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1345             numCheckpoints[delegatee] = nCheckpoints + 1;
1346         }
1347 
1348         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1349     }
1350 
1351     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1352         require(n < 2**32, errorMessage);
1353         return uint32(n);
1354     }
1355 
1356     function getChainId() internal pure returns (uint) {
1357         uint256 chainId;
1358         assembly { chainId := chainid() }
1359         return chainId;
1360     }
1361 }
1362 
1363 // File: contracts/BrewMaster.sol
1364 
1365 pragma solidity 0.6.12;
1366 
1367 
1368 
1369 
1370 
1371 
1372 
1373 
1374 interface IMigratorChef {
1375    
1376     function migrate(IERC20 token) external returns (IERC20);
1377 }
1378 
1379 
1380 contract BrewMaster is Ownable {
1381     using SafeMath for uint256;
1382     using SafeERC20 for IERC20;
1383 
1384     // Info of each user.
1385     struct UserInfo {
1386         uint256 amount;     // How many LP tokens the user has provided.
1387         uint256 rewardDebt; // Reward debt. See explanation below.
1388         //
1389         // We do some fancy math here. Basically, any point in time, the amount of BEERs
1390         // entitled to a user but is pending to be distributed is:
1391         //
1392         //   pending reward = (user.amount * pool.accEggPerShare) - user.rewardDebt
1393         //
1394         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1395         //   1. The pool's `accEggPerShare` (and `lastRewardBlock`) gets updated.
1396         //   2. User receives the pending reward sent to his/her address.
1397         //   3. User's `amount` gets updated.
1398         //   4. User's `rewardDebt` gets updated.
1399     }
1400 
1401     // Info of each pool.
1402     struct PoolInfo {
1403         IERC20 lpToken;           // Address of LP token contract.
1404         uint256 allocPoint;       // How many allocation points assigned to this pool. BEERs to distribute per block.
1405         uint256 lastRewardBlock;  // Last block number that BEERs distribution occurs.
1406         uint256 accEggPerShare; // Accumulated BEERs per share, times 1e12. See below.
1407     }
1408 
1409     // The BEER TOKEN!
1410     BeerToken public beer;
1411     // Dev address.
1412     address public devaddr;
1413     // Block number when bonus BEER period ends.
1414     uint256 public bonusEndBlock;
1415     // BEER tokens created per block.
1416     uint256 public beerPerBlock;
1417     // Bonus muliplier for early beer makers.
1418     uint256 public constant BONUS_MULTIPLIER = 3;
1419     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1420     IMigratorChef public migrator;
1421 
1422     // Info of each pool.
1423     PoolInfo[] public poolInfo;
1424     // Info of each user that stakes LP tokens.
1425     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1426     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1427     uint256 public totalAllocPoint = 0;
1428     // The block number when BEER mining starts.
1429     uint256 public startBlock;
1430 
1431     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1432     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1433     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1434 
1435     constructor(
1436         BeerToken _beer,
1437         address _devaddr,
1438         uint256 _beerPerBlock,
1439         uint256 _startBlock,
1440         uint256 _bonusEndBlock
1441     ) public {
1442         beer = _beer;
1443         devaddr = _devaddr;
1444         beerPerBlock = _beerPerBlock;
1445         bonusEndBlock = _bonusEndBlock;
1446         startBlock = _startBlock;
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
1462             lpToken: _lpToken,
1463             allocPoint: _allocPoint,
1464             lastRewardBlock: lastRewardBlock,
1465             accEggPerShare: 0
1466         }));
1467     }
1468 
1469     // Update the given pool's BEER allocation point. Can only be called by the owner.
1470     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1471         if (_withUpdate) {
1472             massUpdatePools();
1473         }
1474         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1475         poolInfo[_pid].allocPoint = _allocPoint;
1476     }
1477 
1478     // Set the migrator contract. Can only be called by the owner.
1479     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1480         migrator = _migrator;
1481     }
1482 
1483     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1484     function migrate(uint256 _pid) public {
1485         require(address(migrator) != address(0), "migrate: no migrator");
1486         PoolInfo storage pool = poolInfo[_pid];
1487         IERC20 lpToken = pool.lpToken;
1488         uint256 bal = lpToken.balanceOf(address(this));
1489         lpToken.safeApprove(address(migrator), bal);
1490         IERC20 newLpToken = migrator.migrate(lpToken);
1491         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1492         pool.lpToken = newLpToken;
1493     }
1494 
1495     // Return reward multiplier over the given _from to _to block.
1496     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1497         if (_to <= bonusEndBlock) {
1498             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1499         } else if (_from >= bonusEndBlock) {
1500             return _to.sub(_from);
1501         } else {
1502             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1503                 _to.sub(bonusEndBlock)
1504             );
1505         }
1506     }
1507 
1508     // View function to see pending BEERs on frontend.
1509     function pendingEgg(uint256 _pid, address _user) external view returns (uint256) {
1510         PoolInfo storage pool = poolInfo[_pid];
1511         UserInfo storage user = userInfo[_pid][_user];
1512         uint256 accEggPerShare = pool.accEggPerShare;
1513         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1514         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1515             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1516             uint256 beerReward = multiplier.mul(beerPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1517             accEggPerShare = accEggPerShare.add(beerReward.mul(1e12).div(lpSupply));
1518         }
1519         return user.amount.mul(accEggPerShare).div(1e12).sub(user.rewardDebt);
1520     }
1521 
1522     // Update reward vairables for all pools. Be careful of gas spending!
1523     function massUpdatePools() public {
1524         uint256 length = poolInfo.length;
1525         for (uint256 pid = 0; pid < length; ++pid) {
1526             updatePool(pid);
1527         }
1528     }
1529 
1530     // Update reward variables of the given pool to be up-to-date.
1531     function updatePool(uint256 _pid) public {
1532         PoolInfo storage pool = poolInfo[_pid];
1533         if (block.number <= pool.lastRewardBlock) {
1534             return;
1535         }
1536         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1537         if (lpSupply == 0) {
1538             pool.lastRewardBlock = block.number;
1539             return;
1540         }
1541         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1542         uint256 beerReward = multiplier.mul(beerPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1543         beer.mint(devaddr, beerReward.div(10));
1544         beer.mint(address(this), beerReward);
1545         pool.accEggPerShare = pool.accEggPerShare.add(beerReward.mul(1e12).div(lpSupply));
1546         pool.lastRewardBlock = block.number;
1547     }
1548 
1549     // Deposit LP tokens to BrewMaster for BEER allocation.
1550     function deposit(uint256 _pid, uint256 _amount) public {
1551         PoolInfo storage pool = poolInfo[_pid];
1552         UserInfo storage user = userInfo[_pid][msg.sender];
1553         updatePool(_pid);
1554         if (user.amount > 0) {
1555             uint256 pending = user.amount.mul(pool.accEggPerShare).div(1e12).sub(user.rewardDebt);
1556             safeEggTransfer(msg.sender, pending);
1557         }
1558         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1559         user.amount = user.amount.add(_amount);
1560         user.rewardDebt = user.amount.mul(pool.accEggPerShare).div(1e12);
1561         emit Deposit(msg.sender, _pid, _amount);
1562     }
1563 
1564     // Withdraw LP tokens from BrewMaster.
1565     function withdraw(uint256 _pid, uint256 _amount) public {
1566         PoolInfo storage pool = poolInfo[_pid];
1567         UserInfo storage user = userInfo[_pid][msg.sender];
1568         require(user.amount >= _amount, "withdraw: not good");
1569         updatePool(_pid);
1570         uint256 pending = user.amount.mul(pool.accEggPerShare).div(1e12).sub(user.rewardDebt);
1571         safeEggTransfer(msg.sender, pending);
1572         user.amount = user.amount.sub(_amount);
1573         user.rewardDebt = user.amount.mul(pool.accEggPerShare).div(1e12);
1574         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1575         emit Withdraw(msg.sender, _pid, _amount);
1576     }
1577 
1578     // Withdraw without caring about rewards. EMERGENCY ONLY.
1579     function emergencyWithdraw(uint256 _pid) public {
1580         PoolInfo storage pool = poolInfo[_pid];
1581         UserInfo storage user = userInfo[_pid][msg.sender];
1582         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1583         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1584         user.amount = 0;
1585         user.rewardDebt = 0;
1586     }
1587 
1588     // Safe beer transfer function, just in case if rounding error causes pool to not have enough BEERs.
1589     function safeEggTransfer(address _to, uint256 _amount) internal {
1590         uint256 beerBal = beer.balanceOf(address(this));
1591         if (_amount > beerBal) {
1592             beer.transfer(_to, beerBal);
1593         } else {
1594             beer.transfer(_to, _amount);
1595         }
1596     }
1597 
1598     // Update dev address by the previous dev.
1599     function dev(address _devaddr) public {
1600         require(msg.sender == devaddr, "dev: addy?");
1601         devaddr = _devaddr;
1602     }
1603 }