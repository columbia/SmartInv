1 /**
2 **********************************************  
3 *           GOLDMINING.FARM                  *
4 **********************************************
5 * NAME: GOLDMINING TOKEN                     *
6 * VERSION: 0.1.1                             *
7 * TICKER: GMT                                *
8 * SUPPLY: 5000 GMT                           *
9 * MINING START: ETHEREUM BLOCK # 10978939    *
10 * BONUS BLOCK: 0 BLOCKS ONLY                 *
11 * BONUS REWARD: 1X [ NO BONUS ]              *
12 * BLOCK REWARD: 0.25 GMT / BLOCK             *
13 * TEAM ALLOCATION: 5%                        *
14 **********************************************
15 *           MORE DETAILS                     *
16 **********************************************
17 * App: https://goldmining.farm               *
18 * Telegram: https://t.me/goldminingfarm      *
19 * Twitter: https://twitter.com/goldminingfarm*
20 **********************************************
21  */
22 
23  
24 pragma solidity ^0.6.0;
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 // File: @openzeppelin/contracts/math/SafeMath.sol
101 
102 
103 
104 pragma solidity ^0.6.0;
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 // File: @openzeppelin/contracts/utils/Address.sol
263 
264 
265 
266 pragma solidity ^0.6.2;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly { codehash := extcodehash(account) }
297         return (codehash != accountHash && codehash != 0x0);
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
320         (bool success, ) = recipient.call{ value: amount }("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 
324     /**
325      * @dev Performs a Solidity function call using a low level `call`. A
326      * plain`call` is an unsafe replacement for a function call: use this
327      * function instead.
328      *
329      * If `target` reverts with a revert reason, it is bubbled up by this
330      * function (like regular Solidity function calls).
331      *
332      * Returns the raw returned data. To convert to the expected return value,
333      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
334      *
335      * Requirements:
336      *
337      * - `target` must be a contract.
338      * - calling `target` with `data` must not revert.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
343       return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
353         return _functionCallWithValue(target, data, 0, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but also transferring `value` wei to `target`.
359      *
360      * Requirements:
361      *
362      * - the calling contract must have an ETH balance of at least `value`.
363      * - the called Solidity function must be `payable`.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         return _functionCallWithValue(target, data, value, errorMessage);
380     }
381 
382     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
383         require(isContract(target), "Address: call to non-contract");
384 
385         // solhint-disable-next-line avoid-low-level-calls
386         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 // solhint-disable-next-line no-inline-assembly
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
407 
408 
409 
410 pragma solidity ^0.6.0;
411 
412 
413 
414 
415 /**
416  * @title SafeERC20
417  * @dev Wrappers around ERC20 operations that throw on failure (when the token
418  * contract returns false). Tokens that return no value (and instead revert or
419  * throw on failure) are also supported, non-reverting calls are assumed to be
420  * successful.
421  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
422  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
423  */
424 library SafeERC20 {
425     using SafeMath for uint256;
426     using Address for address;
427 
428     function safeTransfer(IERC20 token, address to, uint256 value) internal {
429         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
430     }
431 
432     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
433         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
434     }
435 
436     /**
437      * @dev Deprecated. This function has issues similar to the ones found in
438      * {IERC20-approve}, and its usage is discouraged.
439      *
440      * Whenever possible, use {safeIncreaseAllowance} and
441      * {safeDecreaseAllowance} instead.
442      */
443     function safeApprove(IERC20 token, address spender, uint256 value) internal {
444         // safeApprove should only be called when setting an initial allowance,
445         // or when resetting it to zero. To increase and decrease it, use
446         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
447         // solhint-disable-next-line max-line-length
448         require((value == 0) || (token.allowance(address(this), spender) == 0),
449             "SafeERC20: approve from non-zero to non-zero allowance"
450         );
451         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
452     }
453 
454     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
455         uint256 newAllowance = token.allowance(address(this), spender).add(value);
456         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
457     }
458 
459     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
460         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
461         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
462     }
463 
464     /**
465      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
466      * on the return value: the return value is optional (but if data is returned, it must not be false).
467      * @param token The token targeted by the call.
468      * @param data The call data (encoded using abi.encode or one of its variants).
469      */
470     function _callOptionalReturn(IERC20 token, bytes memory data) private {
471         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
472         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
473         // the target address contains contract code and also asserts for success in the low-level call.
474 
475         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
476         if (returndata.length > 0) { // Return data is optional
477             // solhint-disable-next-line max-line-length
478             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
479         }
480     }
481 }
482 
483 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
484 
485 
486 
487 pragma solidity ^0.6.0;
488 
489 /**
490  * @dev Library for managing
491  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
492  * types.
493  *
494  * Sets have the following properties:
495  *
496  * - Elements are added, removed, and checked for existence in constant time
497  * (O(1)).
498  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
499  *
500  * ```
501  * contract Example {
502  *     // Add the library methods
503  *     using EnumerableSet for EnumerableSet.AddressSet;
504  *
505  *     // Declare a set state variable
506  *     EnumerableSet.AddressSet private mySet;
507  * }
508  * ```
509  *
510  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
511  * (`UintSet`) are supported.
512  */
513 library EnumerableSet {
514     // To implement this library for multiple types with as little code
515     // repetition as possible, we write it in terms of a generic Set type with
516     // bytes32 values.
517     // The Set implementation uses private functions, and user-facing
518     // implementations (such as AddressSet) are just wrappers around the
519     // underlying Set.
520     // This means that we can only create new EnumerableSets for types that fit
521     // in bytes32.
522 
523     struct Set {
524         // Storage of set values
525         bytes32[] _values;
526 
527         // Position of the value in the `values` array, plus 1 because index 0
528         // means a value is not in the set.
529         mapping (bytes32 => uint256) _indexes;
530     }
531 
532     /**
533      * @dev Add a value to a set. O(1).
534      *
535      * Returns true if the value was added to the set, that is if it was not
536      * already present.
537      */
538     function _add(Set storage set, bytes32 value) private returns (bool) {
539         if (!_contains(set, value)) {
540             set._values.push(value);
541             // The value is stored at length-1, but we add 1 to all indexes
542             // and use 0 as a sentinel value
543             set._indexes[value] = set._values.length;
544             return true;
545         } else {
546             return false;
547         }
548     }
549 
550     /**
551      * @dev Removes a value from a set. O(1).
552      *
553      * Returns true if the value was removed from the set, that is if it was
554      * present.
555      */
556     function _remove(Set storage set, bytes32 value) private returns (bool) {
557         // We read and store the value's index to prevent multiple reads from the same storage slot
558         uint256 valueIndex = set._indexes[value];
559 
560         if (valueIndex != 0) { // Equivalent to contains(set, value)
561             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
562             // the array, and then remove the last element (sometimes called as 'swap and pop').
563             // This modifies the order of the array, as noted in {at}.
564 
565             uint256 toDeleteIndex = valueIndex - 1;
566             uint256 lastIndex = set._values.length - 1;
567 
568             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
569             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
570 
571             bytes32 lastvalue = set._values[lastIndex];
572 
573             // Move the last value to the index where the value to delete is
574             set._values[toDeleteIndex] = lastvalue;
575             // Update the index for the moved value
576             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
577 
578             // Delete the slot where the moved value was stored
579             set._values.pop();
580 
581             // Delete the index for the deleted slot
582             delete set._indexes[value];
583 
584             return true;
585         } else {
586             return false;
587         }
588     }
589 
590     /**
591      * @dev Returns true if the value is in the set. O(1).
592      */
593     function _contains(Set storage set, bytes32 value) private view returns (bool) {
594         return set._indexes[value] != 0;
595     }
596 
597     /**
598      * @dev Returns the number of values on the set. O(1).
599      */
600     function _length(Set storage set) private view returns (uint256) {
601         return set._values.length;
602     }
603 
604    /**
605     * @dev Returns the value stored at position `index` in the set. O(1).
606     *
607     * Note that there are no guarantees on the ordering of values inside the
608     * array, and it may change when more values are added or removed.
609     *
610     * Requirements:
611     *
612     * - `index` must be strictly less than {length}.
613     */
614     function _at(Set storage set, uint256 index) private view returns (bytes32) {
615         require(set._values.length > index, "EnumerableSet: index out of bounds");
616         return set._values[index];
617     }
618 
619     // AddressSet
620 
621     struct AddressSet {
622         Set _inner;
623     }
624 
625     /**
626      * @dev Add a value to a set. O(1).
627      *
628      * Returns true if the value was added to the set, that is if it was not
629      * already present.
630      */
631     function add(AddressSet storage set, address value) internal returns (bool) {
632         return _add(set._inner, bytes32(uint256(value)));
633     }
634 
635     /**
636      * @dev Removes a value from a set. O(1).
637      *
638      * Returns true if the value was removed from the set, that is if it was
639      * present.
640      */
641     function remove(AddressSet storage set, address value) internal returns (bool) {
642         return _remove(set._inner, bytes32(uint256(value)));
643     }
644 
645     /**
646      * @dev Returns true if the value is in the set. O(1).
647      */
648     function contains(AddressSet storage set, address value) internal view returns (bool) {
649         return _contains(set._inner, bytes32(uint256(value)));
650     }
651 
652     /**
653      * @dev Returns the number of values in the set. O(1).
654      */
655     function length(AddressSet storage set) internal view returns (uint256) {
656         return _length(set._inner);
657     }
658 
659    /**
660     * @dev Returns the value stored at position `index` in the set. O(1).
661     *
662     * Note that there are no guarantees on the ordering of values inside the
663     * array, and it may change when more values are added or removed.
664     *
665     * Requirements:
666     *
667     * - `index` must be strictly less than {length}.
668     */
669     function at(AddressSet storage set, uint256 index) internal view returns (address) {
670         return address(uint256(_at(set._inner, index)));
671     }
672 
673 
674     // UintSet
675 
676     struct UintSet {
677         Set _inner;
678     }
679 
680     /**
681      * @dev Add a value to a set. O(1).
682      *
683      * Returns true if the value was added to the set, that is if it was not
684      * already present.
685      */
686     function add(UintSet storage set, uint256 value) internal returns (bool) {
687         return _add(set._inner, bytes32(value));
688     }
689 
690     /**
691      * @dev Removes a value from a set. O(1).
692      *
693      * Returns true if the value was removed from the set, that is if it was
694      * present.
695      */
696     function remove(UintSet storage set, uint256 value) internal returns (bool) {
697         return _remove(set._inner, bytes32(value));
698     }
699 
700     /**
701      * @dev Returns true if the value is in the set. O(1).
702      */
703     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
704         return _contains(set._inner, bytes32(value));
705     }
706 
707     /**
708      * @dev Returns the number of values on the set. O(1).
709      */
710     function length(UintSet storage set) internal view returns (uint256) {
711         return _length(set._inner);
712     }
713 
714    /**
715     * @dev Returns the value stored at position `index` in the set. O(1).
716     *
717     * Note that there are no guarantees on the ordering of values inside the
718     * array, and it may change when more values are added or removed.
719     *
720     * Requirements:
721     *
722     * - `index` must be strictly less than {length}.
723     */
724     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
725         return uint256(_at(set._inner, index));
726     }
727 }
728 
729 // File: @openzeppelin/contracts/GSN/Context.sol
730 
731 
732 
733 pragma solidity ^0.6.0;
734 
735 /*
736  * @dev Provides information about the current execution context, including the
737  * sender of the transaction and its data. While these are generally available
738  * via msg.sender and msg.data, they should not be accessed in such a direct
739  * manner, since when dealing with GSN meta-transactions the account sending and
740  * paying for execution may not be the actual sender (as far as an application
741  * is concerned).
742  *
743  * This contract is only required for intermediate, library-like contracts.
744  */
745 abstract contract Context {
746     function _msgSender() internal view virtual returns (address payable) {
747         return msg.sender;
748     }
749 
750     function _msgData() internal view virtual returns (bytes memory) {
751         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
752         return msg.data;
753     }
754 }
755 
756 // File: @openzeppelin/contracts/access/Ownable.sol
757 
758 
759 
760 pragma solidity ^0.6.0;
761 
762 /**
763  * @dev Contract module which provides a basic access control mechanism, where
764  * there is an account (an owner) that can be granted exclusive access to
765  * specific functions.
766  *
767  * By default, the owner account will be the one that deploys the contract. This
768  * can later be changed with {transferOwnership}.
769  *
770  * This module is used through inheritance. It will make available the modifier
771  * `onlyOwner`, which can be applied to your functions to restrict their use to
772  * the owner.
773  */
774 contract Ownable is Context {
775     address private _owner;
776 
777     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
778 
779     /**
780      * @dev Initializes the contract setting the deployer as the initial owner.
781      */
782     constructor () internal {
783         address msgSender = _msgSender();
784         _owner = msgSender;
785         emit OwnershipTransferred(address(0), msgSender);
786     }
787 
788     /**
789      * @dev Returns the address of the current owner.
790      */
791     function owner() public view returns (address) {
792         return _owner;
793     }
794 
795     /**
796      * @dev Throws if called by any account other than the owner.
797      */
798     modifier onlyOwner() {
799         require(_owner == _msgSender(), "Ownable: caller is not the owner");
800         _;
801     }
802 
803     /**
804      * @dev Leaves the contract without owner. It will not be possible to call
805      * `onlyOwner` functions anymore. Can only be called by the current owner.
806      *
807      * NOTE: Renouncing ownership will leave the contract without an owner,
808      * thereby removing any functionality that is only available to the owner.
809      */
810     function renounceOwnership() public virtual onlyOwner {
811         emit OwnershipTransferred(_owner, address(0));
812         _owner = address(0);
813     }
814 
815     /**
816      * @dev Transfers ownership of the contract to a new account (`newOwner`).
817      * Can only be called by the current owner.
818      */
819     function transferOwnership(address newOwner) public virtual onlyOwner {
820         require(newOwner != address(0), "Ownable: new owner is the zero address");
821         emit OwnershipTransferred(_owner, newOwner);
822         _owner = newOwner;
823     }
824 }
825 
826 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
827 
828 
829 
830 pragma solidity ^0.6.0;
831 
832 
833 
834 
835 
836 /**
837  * @dev Implementation of the {IERC20} interface.
838  *
839  * This implementation is agnostic to the way tokens are created. This means
840  * that a supply mechanism has to be added in a derived contract using {_mint}.
841  * For a generic mechanism see {ERC20PresetMinterPauser}.
842  *
843  * TIP: For a detailed writeup see our guide
844  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
845  * to implement supply mechanisms].
846  *
847  * We have followed general OpenZeppelin guidelines: functions revert instead
848  * of returning `false` on failure. This behavior is nonetheless conventional
849  * and does not conflict with the expectations of ERC20 applications.
850  *
851  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
852  * This allows applications to reconstruct the allowance for all accounts just
853  * by listening to said events. Other implementations of the EIP may not emit
854  * these events, as it isn't required by the specification.
855  *
856  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
857  * functions have been added to mitigate the well-known issues around setting
858  * allowances. See {IERC20-approve}.
859  */
860 contract ERC20 is Context, IERC20 {
861     using SafeMath for uint256;
862     using Address for address;
863 
864     mapping (address => uint256) private _balances;
865 
866     mapping (address => mapping (address => uint256)) private _allowances;
867 
868     uint256 private _totalSupply;
869 
870     string private _name;
871     string private _symbol;
872     uint8 private _decimals;
873 
874     /**
875      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
876      * a default value of 18.
877      *
878      * To select a different value for {decimals}, use {_setupDecimals}.
879      *
880      * All three of these values are immutable: they can only be set once during
881      * construction.
882      */
883     constructor (string memory name, string memory symbol) public {
884         _name = name;
885         _symbol = symbol;
886         _decimals = 18;
887     }
888 
889     /**
890      * @dev Returns the name of the token.
891      */
892     function name() public view returns (string memory) {
893         return _name;
894     }
895 
896     /**
897      * @dev Returns the symbol of the token, usually a shorter version of the
898      * name.
899      */
900     function symbol() public view returns (string memory) {
901         return _symbol;
902     }
903 
904     /**
905      * @dev Returns the number of decimals used to get its user representation.
906      * For example, if `decimals` equals `2`, a balance of `505` tokens should
907      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
908      *
909      * Tokens usually opt for a value of 18, imitating the relationship between
910      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
911      * called.
912      *
913      * NOTE: This information is only used for _display_ purposes: it in
914      * no way affects any of the arithmetic of the contract, including
915      * {IERC20-balanceOf} and {IERC20-transfer}.
916      */
917     function decimals() public view returns (uint8) {
918         return _decimals;
919     }
920 
921     /**
922      * @dev See {IERC20-totalSupply}.
923      */
924     function totalSupply() public view override returns (uint256) {
925         return _totalSupply;
926     }
927 
928     /**
929      * @dev See {IERC20-balanceOf}.
930      */
931     function balanceOf(address account) public view override returns (uint256) {
932         return _balances[account];
933     }
934 
935     /**
936      * @dev See {IERC20-transfer}.
937      *
938      * Requirements:
939      *
940      * - `recipient` cannot be the zero address.
941      * - the caller must have a balance of at least `amount`.
942      */
943     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
944         _transfer(_msgSender(), recipient, amount);
945         return true;
946     }
947 
948     /**
949      * @dev See {IERC20-allowance}.
950      */
951     function allowance(address owner, address spender) public view virtual override returns (uint256) {
952         return _allowances[owner][spender];
953     }
954 
955     /**
956      * @dev See {IERC20-approve}.
957      *
958      * Requirements:
959      *
960      * - `spender` cannot be the zero address.
961      */
962     function approve(address spender, uint256 amount) public virtual override returns (bool) {
963         _approve(_msgSender(), spender, amount);
964         return true;
965     }
966 
967     /**
968      * @dev See {IERC20-transferFrom}.
969      *
970      * Emits an {Approval} event indicating the updated allowance. This is not
971      * required by the EIP. See the note at the beginning of {ERC20};
972      *
973      * Requirements:
974      * - `sender` and `recipient` cannot be the zero address.
975      * - `sender` must have a balance of at least `amount`.
976      * - the caller must have allowance for ``sender``'s tokens of at least
977      * `amount`.
978      */
979     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
980         _transfer(sender, recipient, amount);
981         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
982         return true;
983     }
984 
985     /**
986      * @dev Atomically increases the allowance granted to `spender` by the caller.
987      *
988      * This is an alternative to {approve} that can be used as a mitigation for
989      * problems described in {IERC20-approve}.
990      *
991      * Emits an {Approval} event indicating the updated allowance.
992      *
993      * Requirements:
994      *
995      * - `spender` cannot be the zero address.
996      */
997     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
998         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
999         return true;
1000     }
1001 
1002     /**
1003      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1004      *
1005      * This is an alternative to {approve} that can be used as a mitigation for
1006      * problems described in {IERC20-approve}.
1007      *
1008      * Emits an {Approval} event indicating the updated allowance.
1009      *
1010      * Requirements:
1011      *
1012      * - `spender` cannot be the zero address.
1013      * - `spender` must have allowance for the caller of at least
1014      * `subtractedValue`.
1015      */
1016     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1017         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1018         return true;
1019     }
1020 
1021     /**
1022      * @dev Moves tokens `amount` from `sender` to `recipient`.
1023      *
1024      * This is internal function is equivalent to {transfer}, and can be used to
1025      * e.g. implement automatic token fees, slashing mechanisms, etc.
1026      *
1027      * Emits a {Transfer} event.
1028      *
1029      * Requirements:
1030      *
1031      * - `sender` cannot be the zero address.
1032      * - `recipient` cannot be the zero address.
1033      * - `sender` must have a balance of at least `amount`.
1034      */
1035     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1036         require(sender != address(0), "ERC20: transfer from the zero address");
1037         require(recipient != address(0), "ERC20: transfer to the zero address");
1038 
1039         _beforeTokenTransfer(sender, recipient, amount);
1040 
1041         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1042         _balances[recipient] = _balances[recipient].add(amount);
1043         emit Transfer(sender, recipient, amount);
1044     }
1045 
1046     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1047      * the total supply.
1048      *
1049      * Emits a {Transfer} event with `from` set to the zero address.
1050      *
1051      * Requirements
1052      *
1053      * - `to` cannot be the zero address.
1054      */
1055     function _mint(address account, uint256 amount) internal virtual {
1056         require(account != address(0), "ERC20: mint to the zero address");
1057 
1058         _beforeTokenTransfer(address(0), account, amount);
1059 
1060         _totalSupply = _totalSupply.add(amount);
1061         _balances[account] = _balances[account].add(amount);
1062         emit Transfer(address(0), account, amount);
1063     }
1064 
1065     /**
1066      * @dev Destroys `amount` tokens from `account`, reducing the
1067      * total supply.
1068      *
1069      * Emits a {Transfer} event with `to` set to the zero address.
1070      *
1071      * Requirements
1072      *
1073      * - `account` cannot be the zero address.
1074      * - `account` must have at least `amount` tokens.
1075      */
1076     function _burn(address account, uint256 amount) internal virtual {
1077         require(account != address(0), "ERC20: burn from the zero address");
1078 
1079         _beforeTokenTransfer(account, address(0), amount);
1080 
1081         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1082         _totalSupply = _totalSupply.sub(amount);
1083         emit Transfer(account, address(0), amount);
1084     }
1085 
1086     /**
1087      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1088      *
1089      * This is internal function is equivalent to `approve`, and can be used to
1090      * e.g. set automatic allowances for certain subsystems, etc.
1091      *
1092      * Emits an {Approval} event.
1093      *
1094      * Requirements:
1095      *
1096      * - `owner` cannot be the zero address.
1097      * - `spender` cannot be the zero address.
1098      */
1099     function _approve(address owner, address spender, uint256 amount) internal virtual {
1100         require(owner != address(0), "ERC20: approve from the zero address");
1101         require(spender != address(0), "ERC20: approve to the zero address");
1102 
1103         _allowances[owner][spender] = amount;
1104         emit Approval(owner, spender, amount);
1105     }
1106 
1107     /**
1108      * @dev Sets {decimals} to a value other than the default one of 18.
1109      *
1110      * WARNING: This function should only be called from the constructor. Most
1111      * applications that interact with token contracts will not expect
1112      * {decimals} to ever change, and may work incorrectly if it does.
1113      */
1114     function _setupDecimals(uint8 decimals_) internal {
1115         _decimals = decimals_;
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before any transfer of tokens. This includes
1120      * minting and burning.
1121      *
1122      * Calling conditions:
1123      *
1124      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1125      * will be to transferred to `to`.
1126      * - when `from` is zero, `amount` tokens will be minted for `to`.
1127      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1128      * - `from` and `to` are never both zero.
1129      *
1130      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1131      */
1132     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1133 }
1134 
1135 // File: contracts/GoldMining.sol
1136 
1137 pragma solidity 0.6.12;
1138 
1139 
1140 
1141 
1142 // GoldMining with Governance.
1143 contract GoldMining is ERC20("GoldMining Token", "GMT"), Ownable {
1144     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MiningRig).
1145     function mint(address _to, uint256 _amount) public onlyOwner {
1146         _mint(_to, _amount);
1147         _moveDelegates(address(0), _delegates[_to], _amount);
1148     }
1149 
1150     // Copied and modified from YAM code:
1151     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1152     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1153     // Which is copied and modified from COMPOUND:
1154     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1155 
1156     /// @notice A record of each accounts delegate
1157     mapping (address => address) internal _delegates;
1158 
1159     /// @notice A checkpoint for marking number of votes from a given block
1160     struct Checkpoint {
1161         uint32 fromBlock;
1162         uint256 votes;
1163     }
1164 
1165     /// @notice A record of votes checkpoints for each account, by index
1166     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1167 
1168     /// @notice The number of checkpoints for each account
1169     mapping (address => uint32) public numCheckpoints;
1170 
1171     /// @notice The EIP-712 typehash for the contract's domain
1172     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1173 
1174     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1175     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1176 
1177     /// @notice A record of states for signing / validating signatures
1178     mapping (address => uint) public nonces;
1179 
1180       /// @notice An event thats emitted when an account changes its delegate
1181     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1182 
1183     /// @notice An event thats emitted when a delegate account's vote balance changes
1184     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1185 
1186     /**
1187      * @notice Delegate votes from `msg.sender` to `delegatee`
1188      * @param delegator The address to get delegatee for
1189      */
1190     function delegates(address delegator)
1191         external
1192         view
1193         returns (address)
1194     {
1195         return _delegates[delegator];
1196     }
1197 
1198    /**
1199     * @notice Delegate votes from `msg.sender` to `delegatee`
1200     * @param delegatee The address to delegate votes to
1201     */
1202     function delegate(address delegatee) external {
1203         return _delegate(msg.sender, delegatee);
1204     }
1205 
1206     /**
1207      * @notice Delegates votes from signatory to `delegatee`
1208      * @param delegatee The address to delegate votes to
1209      * @param nonce The contract state required to match the signature
1210      * @param expiry The time at which to expire the signature
1211      * @param v The recovery byte of the signature
1212      * @param r Half of the ECDSA signature pair
1213      * @param s Half of the ECDSA signature pair
1214      */
1215     function delegateBySig(
1216         address delegatee,
1217         uint nonce,
1218         uint expiry,
1219         uint8 v,
1220         bytes32 r,
1221         bytes32 s
1222     )
1223         external
1224     {
1225         bytes32 domainSeparator = keccak256(
1226             abi.encode(
1227                 DOMAIN_TYPEHASH,
1228                 keccak256(bytes(name())),
1229                 getChainId(),
1230                 address(this)
1231             )
1232         );
1233 
1234         bytes32 structHash = keccak256(
1235             abi.encode(
1236                 DELEGATION_TYPEHASH,
1237                 delegatee,
1238                 nonce,
1239                 expiry
1240             )
1241         );
1242 
1243         bytes32 digest = keccak256(
1244             abi.encodePacked(
1245                 "\x19\x01",
1246                 domainSeparator,
1247                 structHash
1248             )
1249         );
1250 
1251         address signatory = ecrecover(digest, v, r, s);
1252         require(signatory != address(0), "GMT::delegateBySig: invalid signature");
1253         require(nonce == nonces[signatory]++, "GMT::delegateBySig: invalid nonce");
1254         require(now <= expiry, "GMT::delegateBySig: signature expired");
1255         return _delegate(signatory, delegatee);
1256     }
1257 
1258     /**
1259      * @notice Gets the current votes balance for `account`
1260      * @param account The address to get votes balance
1261      * @return The number of current votes for `account`
1262      */
1263     function getCurrentVotes(address account)
1264         external
1265         view
1266         returns (uint256)
1267     {
1268         uint32 nCheckpoints = numCheckpoints[account];
1269         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1270     }
1271 
1272     /**
1273      * @notice Determine the prior number of votes for an account as of a block number
1274      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1275      * @param account The address of the account to check
1276      * @param blockNumber The block number to get the vote balance at
1277      * @return The number of votes the account had as of the given block
1278      */
1279     function getPriorVotes(address account, uint blockNumber)
1280         external
1281         view
1282         returns (uint256)
1283     {
1284         require(blockNumber < block.number, "GMT::getPriorVotes: not yet determined");
1285 
1286         uint32 nCheckpoints = numCheckpoints[account];
1287         if (nCheckpoints == 0) {
1288             return 0;
1289         }
1290 
1291         // First check most recent balance
1292         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1293             return checkpoints[account][nCheckpoints - 1].votes;
1294         }
1295 
1296         // Next check implicit zero balance
1297         if (checkpoints[account][0].fromBlock > blockNumber) {
1298             return 0;
1299         }
1300 
1301         uint32 lower = 0;
1302         uint32 upper = nCheckpoints - 1;
1303         while (upper > lower) {
1304             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1305             Checkpoint memory cp = checkpoints[account][center];
1306             if (cp.fromBlock == blockNumber) {
1307                 return cp.votes;
1308             } else if (cp.fromBlock < blockNumber) {
1309                 lower = center;
1310             } else {
1311                 upper = center - 1;
1312             }
1313         }
1314         return checkpoints[account][lower].votes;
1315     }
1316 
1317     function _delegate(address delegator, address delegatee)
1318         internal
1319     {
1320         address currentDelegate = _delegates[delegator];
1321         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying GMTs (not scaled);
1322         _delegates[delegator] = delegatee;
1323 
1324         emit DelegateChanged(delegator, currentDelegate, delegatee);
1325 
1326         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1327     }
1328 
1329     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1330         if (srcRep != dstRep && amount > 0) {
1331             if (srcRep != address(0)) {
1332                 // decrease old representative
1333                 uint32 srcRepNum = numCheckpoints[srcRep];
1334                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1335                 uint256 srcRepNew = srcRepOld.sub(amount);
1336                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1337             }
1338 
1339             if (dstRep != address(0)) {
1340                 // increase new representative
1341                 uint32 dstRepNum = numCheckpoints[dstRep];
1342                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1343                 uint256 dstRepNew = dstRepOld.add(amount);
1344                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1345             }
1346         }
1347     }
1348 
1349     function _writeCheckpoint(
1350         address delegatee,
1351         uint32 nCheckpoints,
1352         uint256 oldVotes,
1353         uint256 newVotes
1354     )
1355         internal
1356     {
1357         uint32 blockNumber = safe32(block.number, "GMT::_writeCheckpoint: block number exceeds 32 bits");
1358 
1359         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1360             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1361         } else {
1362             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1363             numCheckpoints[delegatee] = nCheckpoints + 1;
1364         }
1365 
1366         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1367     }
1368 
1369     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1370         require(n < 2**32, errorMessage);
1371         return uint32(n);
1372     }
1373 
1374     function getChainId() internal pure returns (uint) {
1375         uint256 chainId;
1376         assembly { chainId := chainid() }
1377         return chainId;
1378     }
1379 }
1380 
1381 // File: contracts/MiningRig.sol
1382 
1383 pragma solidity 0.6.12;
1384 
1385 
1386 
1387 
1388 
1389 
1390 
1391 
1392 interface IMigratorChef {
1393    
1394     function migrate(IERC20 token) external returns (IERC20);
1395 }
1396 
1397 
1398 contract MiningRig is Ownable {
1399     using SafeMath for uint256;
1400     using SafeERC20 for IERC20;
1401 
1402     // Info of each user.
1403     struct UserInfo {
1404         uint256 amount;     // How many LP tokens the user has provided.
1405         uint256 rewardDebt; // Reward debt. See explanation below.
1406         //
1407         // We do some fancy math here. Basically, any point in time, the amount of GMTs
1408         // entitled to a user but is pending to be distributed is:
1409         //
1410         //   pending reward = (user.amount * pool.accGmtPerShare) - user.rewardDebt
1411         //
1412         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1413         //   1. The pool's `accGmtPerShare` (and `lastRewardBlock`) gets updated.
1414         //   2. User receives the pending reward sent to his/her address.
1415         //   3. User's `amount` gets updated.
1416         //   4. User's `rewardDebt` gets updated.
1417     }
1418 
1419     // Info of each pool.
1420     struct PoolInfo {
1421         IERC20 lpToken;           // Address of LP token contract.
1422         uint256 allocPoint;       // How many allocation points assigned to this pool. GMTs to distribute per block.
1423         uint256 lastRewardBlock;  // Last block number that GMTs distribution occurs.
1424         uint256 accGmtPerShare; // Accumulated GMTs per share, times 1e12. See below.
1425     }
1426 
1427     // The GMT TOKEN!
1428     GoldMining public gmt;
1429     // Dev address.
1430     address public devaddr;
1431     // Block number when bonus GMT period ends.
1432     uint256 public bonusEndBlock;
1433     // GMT tokens created per block.
1434     uint256 public gmtPerBlock;
1435     // Bonus muliplier for early gmt makers.
1436     uint256 public constant BONUS_MULTIPLIER = 1;
1437     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1438     IMigratorChef public migrator;
1439 
1440     // Info of each pool.
1441     PoolInfo[] public poolInfo;
1442     // Info of each user that stakes LP tokens.
1443     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1444     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1445     uint256 public totalAllocPoint = 0;
1446     // The block number when GMT mining starts.
1447     uint256 public startBlock;
1448 
1449     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1450     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1451     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1452 
1453     constructor(
1454         GoldMining _gmt,
1455         address _devaddr,
1456         uint256 _gmtPerBlock,
1457         uint256 _startBlock,
1458         uint256 _bonusEndBlock
1459     ) public {
1460         gmt = _gmt;
1461         devaddr = _devaddr;
1462         gmtPerBlock = _gmtPerBlock;
1463         bonusEndBlock = _bonusEndBlock;
1464         startBlock = _startBlock;
1465     }
1466 
1467     function poolLength() external view returns (uint256) {
1468         return poolInfo.length;
1469     }
1470 
1471     // Add a new lp to the pool. Can only be called by the owner.
1472     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1473     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1474         if (_withUpdate) {
1475             massUpdatePools();
1476         }
1477         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1478         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1479         poolInfo.push(PoolInfo({
1480             lpToken: _lpToken,
1481             allocPoint: _allocPoint,
1482             lastRewardBlock: lastRewardBlock,
1483             accGmtPerShare: 0
1484         }));
1485     }
1486 
1487     // Update the given pool's GMT allocation point. Can only be called by the owner.
1488     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1489         if (_withUpdate) {
1490             massUpdatePools();
1491         }
1492         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1493         poolInfo[_pid].allocPoint = _allocPoint;
1494     }
1495 
1496     // Set the migrator contract. Can only be called by the owner.
1497     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1498         migrator = _migrator;
1499     }
1500 
1501     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1502     function migrate(uint256 _pid) public {
1503         require(address(migrator) != address(0), "migrate: no migrator");
1504         PoolInfo storage pool = poolInfo[_pid];
1505         IERC20 lpToken = pool.lpToken;
1506         uint256 bal = lpToken.balanceOf(address(this));
1507         lpToken.safeApprove(address(migrator), bal);
1508         IERC20 newLpToken = migrator.migrate(lpToken);
1509         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1510         pool.lpToken = newLpToken;
1511     }
1512 
1513     // Return reward multiplier over the given _from to _to block.
1514     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1515         if (_to <= bonusEndBlock) {
1516             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1517         } else if (_from >= bonusEndBlock) {
1518             return _to.sub(_from);
1519         } else {
1520             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1521                 _to.sub(bonusEndBlock)
1522             );
1523         }
1524     }
1525 
1526     // View function to see pending GMTs on frontend.
1527     function pendingGmt(uint256 _pid, address _user) external view returns (uint256) {
1528         PoolInfo storage pool = poolInfo[_pid];
1529         UserInfo storage user = userInfo[_pid][_user];
1530         uint256 accGmtPerShare = pool.accGmtPerShare;
1531         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1532         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1533             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1534             uint256 gmtReward = multiplier.mul(gmtPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1535             accGmtPerShare = accGmtPerShare.add(gmtReward.mul(1e12).div(lpSupply));
1536         }
1537         return user.amount.mul(accGmtPerShare).div(1e12).sub(user.rewardDebt);
1538     }
1539 
1540     // Update reward vairables for all pools. Be careful of gas spending!
1541     function massUpdatePools() public {
1542         uint256 length = poolInfo.length;
1543         for (uint256 pid = 0; pid < length; ++pid) {
1544             updatePool(pid);
1545         }
1546     }
1547 
1548     // Update reward variables of the given pool to be up-to-date.
1549     function updatePool(uint256 _pid) public {
1550         PoolInfo storage pool = poolInfo[_pid];
1551         if (block.number <= pool.lastRewardBlock) {
1552             return;
1553         }
1554         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1555         if (lpSupply == 0) {
1556             pool.lastRewardBlock = block.number;
1557             return;
1558         }
1559         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1560         uint256 gmtReward = multiplier.mul(gmtPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1561         gmt.mint(devaddr, gmtReward.div(10));
1562         gmt.mint(address(this), gmtReward);
1563         pool.accGmtPerShare = pool.accGmtPerShare.add(gmtReward.mul(1e12).div(lpSupply));
1564         pool.lastRewardBlock = block.number;
1565     }
1566 
1567     // Deposit LP tokens to MiningRig for GMT allocation.
1568     function deposit(uint256 _pid, uint256 _amount) public {
1569         PoolInfo storage pool = poolInfo[_pid];
1570         UserInfo storage user = userInfo[_pid][msg.sender];
1571         updatePool(_pid);
1572         if (user.amount > 0) {
1573             uint256 pending = user.amount.mul(pool.accGmtPerShare).div(1e12).sub(user.rewardDebt);
1574             safeGmtTransfer(msg.sender, pending);
1575         }
1576         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1577         user.amount = user.amount.add(_amount);
1578         user.rewardDebt = user.amount.mul(pool.accGmtPerShare).div(1e12);
1579         emit Deposit(msg.sender, _pid, _amount);
1580     }
1581 
1582     // Withdraw LP tokens from MiningRig.
1583     function withdraw(uint256 _pid, uint256 _amount) public {
1584         PoolInfo storage pool = poolInfo[_pid];
1585         UserInfo storage user = userInfo[_pid][msg.sender];
1586         require(user.amount >= _amount, "withdraw: not good");
1587         updatePool(_pid);
1588         uint256 pending = user.amount.mul(pool.accGmtPerShare).div(1e12).sub(user.rewardDebt);
1589         safeGmtTransfer(msg.sender, pending);
1590         user.amount = user.amount.sub(_amount);
1591         user.rewardDebt = user.amount.mul(pool.accGmtPerShare).div(1e12);
1592         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1593         emit Withdraw(msg.sender, _pid, _amount);
1594     }
1595 
1596     // Withdraw without caring about rewards. EMERGENCY ONLY.
1597     function emergencyWithdraw(uint256 _pid) public {
1598         PoolInfo storage pool = poolInfo[_pid];
1599         UserInfo storage user = userInfo[_pid][msg.sender];
1600         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1601         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1602         user.amount = 0;
1603         user.rewardDebt = 0;
1604     }
1605 
1606     // Safe gmt transfer function, just in case if rounding error causes pool to not have enough GMTs.
1607     function safeGmtTransfer(address _to, uint256 _amount) internal {
1608         uint256 gmtBal = gmt.balanceOf(address(this));
1609         if (_amount > gmtBal) {
1610             gmt.transfer(_to, gmtBal);
1611         } else {
1612             gmt.transfer(_to, _amount);
1613         }
1614     }
1615 
1616     // Update dev address by the previous dev.
1617     function dev(address _devaddr) public {
1618         require(msg.sender == devaddr, "dev: wut?");
1619         devaddr = _devaddr;
1620     }
1621 }