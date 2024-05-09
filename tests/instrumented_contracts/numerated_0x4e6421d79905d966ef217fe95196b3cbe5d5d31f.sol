1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-26
3 */
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File: @openzeppelin/contracts/math/SafeMath.sol
84 
85 
86 
87 pragma solidity ^0.6.0;
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations with added overflow
91  * checks.
92  *
93  * Arithmetic operations in Solidity wrap on overflow. This can easily result
94  * in bugs, because programmers usually assume that an overflow raises an
95  * error, which is the standard behavior in high level programming languages.
96  * `SafeMath` restores this intuition by reverting the transaction when an
97  * operation overflows.
98  *
99  * Using this library instead of the unchecked operations eliminates an entire
100  * class of bugs, so it's recommended to use it always.
101  */
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      *
111      * - Addition cannot overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         require(b <= a, errorMessage);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) {
166             return 0;
167         }
168 
169         uint256 c = a * b;
170         require(c / a == b, "SafeMath: multiplication overflow");
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         return div(a, b, "SafeMath: division by zero");
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b > 0, errorMessage);
205         uint256 c = a / b;
206         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return mod(a, b, "SafeMath: modulo by zero");
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts with custom message when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b != 0, errorMessage);
241         return a % b;
242     }
243 }
244 
245 // File: @openzeppelin/contracts/utils/Address.sol
246 
247 
248 
249 pragma solidity ^0.6.2;
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
274         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
275         // for accounts without code, i.e. `keccak256('')`
276         bytes32 codehash;
277         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
278         // solhint-disable-next-line no-inline-assembly
279         assembly { codehash := extcodehash(account) }
280         return (codehash != accountHash && codehash != 0x0);
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
303         (bool success, ) = recipient.call{ value: amount }("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain`call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
336         return _functionCallWithValue(target, data, 0, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but also transferring `value` wei to `target`.
342      *
343      * Requirements:
344      *
345      * - the calling contract must have an ETH balance of at least `value`.
346      * - the called Solidity function must be `payable`.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         return _functionCallWithValue(target, data, value, errorMessage);
363     }
364 
365     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
366         require(isContract(target), "Address: call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 // solhint-disable-next-line no-inline-assembly
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
390 
391 
392 
393 pragma solidity ^0.6.0;
394 
395 
396 
397 
398 /**
399  * @title SafeERC20
400  * @dev Wrappers around ERC20 operations that throw on failure (when the token
401  * contract returns false). Tokens that return no value (and instead revert or
402  * throw on failure) are also supported, non-reverting calls are assumed to be
403  * successful.
404  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
405  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
406  */
407 library SafeERC20 {
408     using SafeMath for uint256;
409     using Address for address;
410 
411     function safeTransfer(IERC20 token, address to, uint256 value) internal {
412         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
413     }
414 
415     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
417     }
418 
419     /**
420      * @dev Deprecated. This function has issues similar to the ones found in
421      * {IERC20-approve}, and its usage is discouraged.
422      *
423      * Whenever possible, use {safeIncreaseAllowance} and
424      * {safeDecreaseAllowance} instead.
425      */
426     function safeApprove(IERC20 token, address spender, uint256 value) internal {
427         // safeApprove should only be called when setting an initial allowance,
428         // or when resetting it to zero. To increase and decrease it, use
429         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
430         // solhint-disable-next-line max-line-length
431         require((value == 0) || (token.allowance(address(this), spender) == 0),
432             "SafeERC20: approve from non-zero to non-zero allowance"
433         );
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
435     }
436 
437     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
438         uint256 newAllowance = token.allowance(address(this), spender).add(value);
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
440     }
441 
442     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     /**
448      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
449      * on the return value: the return value is optional (but if data is returned, it must not be false).
450      * @param token The token targeted by the call.
451      * @param data The call data (encoded using abi.encode or one of its variants).
452      */
453     function _callOptionalReturn(IERC20 token, bytes memory data) private {
454         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
455         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
456         // the target address contains contract code and also asserts for success in the low-level call.
457 
458         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
459         if (returndata.length > 0) { // Return data is optional
460             // solhint-disable-next-line max-line-length
461             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
462         }
463     }
464 }
465 
466 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
467 
468 
469 
470 pragma solidity ^0.6.0;
471 
472 /**
473  * @dev Library for managing
474  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
475  * types.
476  *
477  * Sets have the following properties:
478  *
479  * - Elements are added, removed, and checked for existence in constant time
480  * (O(1)).
481  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
482  *
483  * ```
484  * contract Example {
485  *     // Add the library methods
486  *     using EnumerableSet for EnumerableSet.AddressSet;
487  *
488  *     // Declare a set state variable
489  *     EnumerableSet.AddressSet private mySet;
490  * }
491  * ```
492  *
493  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
494  * (`UintSet`) are supported.
495  */
496 library EnumerableSet {
497     // To implement this library for multiple types with as little code
498     // repetition as possible, we write it in terms of a generic Set type with
499     // bytes32 values.
500     // The Set implementation uses private functions, and user-facing
501     // implementations (such as AddressSet) are just wrappers around the
502     // underlying Set.
503     // This means that we can only create new EnumerableSets for types that fit
504     // in bytes32.
505 
506     struct Set {
507         // Storage of set values
508         bytes32[] _values;
509 
510         // Position of the value in the `values` array, plus 1 because index 0
511         // means a value is not in the set.
512         mapping (bytes32 => uint256) _indexes;
513     }
514 
515     /**
516      * @dev Add a value to a set. O(1).
517      *
518      * Returns true if the value was added to the set, that is if it was not
519      * already present.
520      */
521     function _add(Set storage set, bytes32 value) private returns (bool) {
522         if (!_contains(set, value)) {
523             set._values.push(value);
524             // The value is stored at length-1, but we add 1 to all indexes
525             // and use 0 as a sentinel value
526             set._indexes[value] = set._values.length;
527             return true;
528         } else {
529             return false;
530         }
531     }
532 
533     /**
534      * @dev Removes a value from a set. O(1).
535      *
536      * Returns true if the value was removed from the set, that is if it was
537      * present.
538      */
539     function _remove(Set storage set, bytes32 value) private returns (bool) {
540         // We read and store the value's index to prevent multiple reads from the same storage slot
541         uint256 valueIndex = set._indexes[value];
542 
543         if (valueIndex != 0) { // Equivalent to contains(set, value)
544             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
545             // the array, and then remove the last element (sometimes called as 'swap and pop').
546             // This modifies the order of the array, as noted in {at}.
547 
548             uint256 toDeleteIndex = valueIndex - 1;
549             uint256 lastIndex = set._values.length - 1;
550 
551             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
552             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
553 
554             bytes32 lastvalue = set._values[lastIndex];
555 
556             // Move the last value to the index where the value to delete is
557             set._values[toDeleteIndex] = lastvalue;
558             // Update the index for the moved value
559             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
560 
561             // Delete the slot where the moved value was stored
562             set._values.pop();
563 
564             // Delete the index for the deleted slot
565             delete set._indexes[value];
566 
567             return true;
568         } else {
569             return false;
570         }
571     }
572 
573     /**
574      * @dev Returns true if the value is in the set. O(1).
575      */
576     function _contains(Set storage set, bytes32 value) private view returns (bool) {
577         return set._indexes[value] != 0;
578     }
579 
580     /**
581      * @dev Returns the number of values on the set. O(1).
582      */
583     function _length(Set storage set) private view returns (uint256) {
584         return set._values.length;
585     }
586 
587     /**
588      * @dev Returns the value stored at position `index` in the set. O(1).
589      *
590      * Note that there are no guarantees on the ordering of values inside the
591      * array, and it may change when more values are added or removed.
592      *
593      * Requirements:
594      *
595      * - `index` must be strictly less than {length}.
596      */
597     function _at(Set storage set, uint256 index) private view returns (bytes32) {
598         require(set._values.length > index, "EnumerableSet: index out of bounds");
599         return set._values[index];
600     }
601 
602     // AddressSet
603 
604     struct AddressSet {
605         Set _inner;
606     }
607 
608     /**
609      * @dev Add a value to a set. O(1).
610      *
611      * Returns true if the value was added to the set, that is if it was not
612      * already present.
613      */
614     function add(AddressSet storage set, address value) internal returns (bool) {
615         return _add(set._inner, bytes32(uint256(value)));
616     }
617 
618     /**
619      * @dev Removes a value from a set. O(1).
620      *
621      * Returns true if the value was removed from the set, that is if it was
622      * present.
623      */
624     function remove(AddressSet storage set, address value) internal returns (bool) {
625         return _remove(set._inner, bytes32(uint256(value)));
626     }
627 
628     /**
629      * @dev Returns true if the value is in the set. O(1).
630      */
631     function contains(AddressSet storage set, address value) internal view returns (bool) {
632         return _contains(set._inner, bytes32(uint256(value)));
633     }
634 
635     /**
636      * @dev Returns the number of values in the set. O(1).
637      */
638     function length(AddressSet storage set) internal view returns (uint256) {
639         return _length(set._inner);
640     }
641 
642     /**
643      * @dev Returns the value stored at position `index` in the set. O(1).
644      *
645      * Note that there are no guarantees on the ordering of values inside the
646      * array, and it may change when more values are added or removed.
647      *
648      * Requirements:
649      *
650      * - `index` must be strictly less than {length}.
651      */
652     function at(AddressSet storage set, uint256 index) internal view returns (address) {
653         return address(uint256(_at(set._inner, index)));
654     }
655 
656 
657     // UintSet
658 
659     struct UintSet {
660         Set _inner;
661     }
662 
663     /**
664      * @dev Add a value to a set. O(1).
665      *
666      * Returns true if the value was added to the set, that is if it was not
667      * already present.
668      */
669     function add(UintSet storage set, uint256 value) internal returns (bool) {
670         return _add(set._inner, bytes32(value));
671     }
672 
673     /**
674      * @dev Removes a value from a set. O(1).
675      *
676      * Returns true if the value was removed from the set, that is if it was
677      * present.
678      */
679     function remove(UintSet storage set, uint256 value) internal returns (bool) {
680         return _remove(set._inner, bytes32(value));
681     }
682 
683     /**
684      * @dev Returns true if the value is in the set. O(1).
685      */
686     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
687         return _contains(set._inner, bytes32(value));
688     }
689 
690     /**
691      * @dev Returns the number of values on the set. O(1).
692      */
693     function length(UintSet storage set) internal view returns (uint256) {
694         return _length(set._inner);
695     }
696 
697     /**
698      * @dev Returns the value stored at position `index` in the set. O(1).
699      *
700      * Note that there are no guarantees on the ordering of values inside the
701      * array, and it may change when more values are added or removed.
702      *
703      * Requirements:
704      *
705      * - `index` must be strictly less than {length}.
706      */
707     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
708         return uint256(_at(set._inner, index));
709     }
710 }
711 
712 // File: @openzeppelin/contracts/GSN/Context.sol
713 
714 
715 
716 pragma solidity ^0.6.0;
717 
718 /*
719  * @dev Provides information about the current execution context, including the
720  * sender of the transaction and its data. While these are generally available
721  * via msg.sender and msg.data, they should not be accessed in such a direct
722  * manner, since when dealing with GSN meta-transactions the account sending and
723  * paying for execution may not be the actual sender (as far as an application
724  * is concerned).
725  *
726  * This contract is only required for intermediate, library-like contracts.
727  */
728 abstract contract Context {
729     function _msgSender() internal view virtual returns (address payable) {
730         return msg.sender;
731     }
732 
733     function _msgData() internal view virtual returns (bytes memory) {
734         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
735         return msg.data;
736     }
737 }
738 
739 // File: @openzeppelin/contracts/access/Ownable.sol
740 
741 
742 
743 pragma solidity ^0.6.0;
744 
745 /**
746  * @dev Contract module which provides a basic access control mechanism, where
747  * there is an account (an owner) that can be granted exclusive access to
748  * specific functions.
749  *
750  * By default, the owner account will be the one that deploys the contract. This
751  * can later be changed with {transferOwnership}.
752  *
753  * This module is used through inheritance. It will make available the modifier
754  * `onlyOwner`, which can be applied to your functions to restrict their use to
755  * the owner.
756  */
757 contract Ownable is Context {
758     address private _owner;
759 
760     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
761 
762     /**
763      * @dev Initializes the contract setting the deployer as the initial owner.
764      */
765     constructor () internal {
766         address msgSender = _msgSender();
767         _owner = msgSender;
768         emit OwnershipTransferred(address(0), msgSender);
769     }
770 
771     /**
772      * @dev Returns the address of the current owner.
773      */
774     function owner() public view returns (address) {
775         return _owner;
776     }
777 
778     /**
779      * @dev Throws if called by any account other than the owner.
780      */
781     modifier onlyOwner() {
782         require(_owner == _msgSender(), "Ownable: caller is not the owner");
783         _;
784     }
785 
786     /**
787      * @dev Leaves the contract without owner. It will not be possible to call
788      * `onlyOwner` functions anymore. Can only be called by the current owner.
789      *
790      * NOTE: Renouncing ownership will leave the contract without an owner,
791      * thereby removing any functionality that is only available to the owner.
792      */
793     function renounceOwnership() public virtual onlyOwner {
794         emit OwnershipTransferred(_owner, address(0));
795         _owner = address(0);
796     }
797 
798     /**
799      * @dev Transfers ownership of the contract to a new account (`newOwner`).
800      * Can only be called by the current owner.
801      */
802     function transferOwnership(address newOwner) public virtual onlyOwner {
803         require(newOwner != address(0), "Ownable: new owner is the zero address");
804         emit OwnershipTransferred(_owner, newOwner);
805         _owner = newOwner;
806     }
807 }
808 
809 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
810 
811 
812 
813 pragma solidity ^0.6.0;
814 
815 
816 
817 
818 
819 /**
820  * @dev Implementation of the {IERC20} interface.
821  *
822  * This implementation is agnostic to the way tokens are created. This means
823  * that a supply mechanism has to be added in a derived contract using {_mint}.
824  * For a generic mechanism see {ERC20PresetMinterPauser}.
825  *
826  * TIP: For a detailed writeup see our guide
827  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
828  * to implement supply mechanisms].
829  *
830  * We have followed general OpenZeppelin guidelines: functions revert instead
831  * of returning `false` on failure. This behavior is nonetheless conventional
832  * and does not conflict with the expectations of ERC20 applications.
833  *
834  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
835  * This allows applications to reconstruct the allowance for all accounts just
836  * by listening to said events. Other implementations of the EIP may not emit
837  * these events, as it isn't required by the specification.
838  *
839  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
840  * functions have been added to mitigate the well-known issues around setting
841  * allowances. See {IERC20-approve}.
842  */
843 contract ERC20 is Context, IERC20 {
844     using SafeMath for uint256;
845     using Address for address;
846 
847     mapping (address => uint256) private _balances;
848 
849     mapping (address => mapping (address => uint256)) private _allowances;
850 
851     uint256 private _totalSupply;
852 
853     string private _name;
854     string private _symbol;
855     uint8 private _decimals;
856 
857     /**
858      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
859      * a default value of 18.
860      *
861      * To select a different value for {decimals}, use {_setupDecimals}.
862      *
863      * All three of these values are immutable: they can only be set once during
864      * construction.
865      */
866     constructor (string memory name, string memory symbol) public {
867         _name = name;
868         _symbol = symbol;
869         _decimals = 18;
870     }
871 
872     /**
873      * @dev Returns the name of the token.
874      */
875     function name() public view returns (string memory) {
876         return _name;
877     }
878 
879     /**
880      * @dev Returns the symbol of the token, usually a shorter version of the
881      * name.
882      */
883     function symbol() public view returns (string memory) {
884         return _symbol;
885     }
886 
887     /**
888      * @dev Returns the number of decimals used to get its user representation.
889      * For example, if `decimals` equals `2`, a balance of `505` tokens should
890      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
891      *
892      * Tokens usually opt for a value of 18, imitating the relationship between
893      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
894      * called.
895      *
896      * NOTE: This information is only used for _display_ purposes: it in
897      * no way affects any of the arithmetic of the contract, including
898      * {IERC20-balanceOf} and {IERC20-transfer}.
899      */
900     function decimals() public view returns (uint8) {
901         return _decimals;
902     }
903 
904     /**
905      * @dev See {IERC20-totalSupply}.
906      */
907     function totalSupply() public view override returns (uint256) {
908         return _totalSupply;
909     }
910 
911     /**
912      * @dev See {IERC20-balanceOf}.
913      */
914     function balanceOf(address account) public view override returns (uint256) {
915         return _balances[account];
916     }
917 
918     /**
919      * @dev See {IERC20-transfer}.
920      *
921      * Requirements:
922      *
923      * - `recipient` cannot be the zero address.
924      * - the caller must have a balance of at least `amount`.
925      */
926     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
927         _transfer(_msgSender(), recipient, amount);
928         return true;
929     }
930 
931     /**
932      * @dev See {IERC20-allowance}.
933      */
934     function allowance(address owner, address spender) public view virtual override returns (uint256) {
935         return _allowances[owner][spender];
936     }
937 
938     /**
939      * @dev See {IERC20-approve}.
940      *
941      * Requirements:
942      *
943      * - `spender` cannot be the zero address.
944      */
945     function approve(address spender, uint256 amount) public virtual override returns (bool) {
946         _approve(_msgSender(), spender, amount);
947         return true;
948     }
949 
950     /**
951      * @dev See {IERC20-transferFrom}.
952      *
953      * Emits an {Approval} event indicating the updated allowance. This is not
954      * required by the EIP. See the note at the beginning of {ERC20};
955      *
956      * Requirements:
957      * - `sender` and `recipient` cannot be the zero address.
958      * - `sender` must have a balance of at least `amount`.
959      * - the caller must have allowance for ``sender``'s tokens of at least
960      * `amount`.
961      */
962     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
963         _transfer(sender, recipient, amount);
964         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
965         return true;
966     }
967 
968     /**
969      * @dev Atomically increases the allowance granted to `spender` by the caller.
970      *
971      * This is an alternative to {approve} that can be used as a mitigation for
972      * problems described in {IERC20-approve}.
973      *
974      * Emits an {Approval} event indicating the updated allowance.
975      *
976      * Requirements:
977      *
978      * - `spender` cannot be the zero address.
979      */
980     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
981         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
982         return true;
983     }
984 
985     /**
986      * @dev Atomically decreases the allowance granted to `spender` by the caller.
987      *
988      * This is an alternative to {approve} that can be used as a mitigation for
989      * problems described in {IERC20-approve}.
990      *
991      * Emits an {Approval} event indicating the updated allowance.
992      *
993      * Requirements:
994      *
995      * - `spender` cannot be the zero address.
996      * - `spender` must have allowance for the caller of at least
997      * `subtractedValue`.
998      */
999     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1000         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1001         return true;
1002     }
1003 
1004     /**
1005      * @dev Moves tokens `amount` from `sender` to `recipient`.
1006      *
1007      * This is internal function is equivalent to {transfer}, and can be used to
1008      * e.g. implement automatic token fees, slashing mechanisms, etc.
1009      *
1010      * Emits a {Transfer} event.
1011      *
1012      * Requirements:
1013      *
1014      * - `sender` cannot be the zero address.
1015      * - `recipient` cannot be the zero address.
1016      * - `sender` must have a balance of at least `amount`.
1017      */
1018     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1019         require(sender != address(0), "ERC20: transfer from the zero address");
1020         require(recipient != address(0), "ERC20: transfer to the zero address");
1021 
1022         _beforeTokenTransfer(sender, recipient, amount);
1023 
1024         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1025         _balances[recipient] = _balances[recipient].add(amount);
1026         emit Transfer(sender, recipient, amount);
1027     }
1028 
1029     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1030      * the total supply.
1031      *
1032      * Emits a {Transfer} event with `from` set to the zero address.
1033      *
1034      * Requirements
1035      *
1036      * - `to` cannot be the zero address.
1037      */
1038     function _mint(address account, uint256 amount) internal virtual {
1039         require(account != address(0), "ERC20: mint to the zero address");
1040 
1041         _beforeTokenTransfer(address(0), account, amount);
1042 
1043         _totalSupply = _totalSupply.add(amount);
1044         _balances[account] = _balances[account].add(amount);
1045         emit Transfer(address(0), account, amount);
1046     }
1047 
1048     /**
1049      * @dev Destroys `amount` tokens from `account`, reducing the
1050      * total supply.
1051      *
1052      * Emits a {Transfer} event with `to` set to the zero address.
1053      *
1054      * Requirements
1055      *
1056      * - `account` cannot be the zero address.
1057      * - `account` must have at least `amount` tokens.
1058      */
1059     function _burn(address account, uint256 amount) internal virtual {
1060         require(account != address(0), "ERC20: burn from the zero address");
1061 
1062         _beforeTokenTransfer(account, address(0), amount);
1063 
1064         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1065         _totalSupply = _totalSupply.sub(amount);
1066         emit Transfer(account, address(0), amount);
1067     }
1068 
1069     /**
1070      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1071      *
1072      * This is internal function is equivalent to `approve`, and can be used to
1073      * e.g. set automatic allowances for certain subsystems, etc.
1074      *
1075      * Emits an {Approval} event.
1076      *
1077      * Requirements:
1078      *
1079      * - `owner` cannot be the zero address.
1080      * - `spender` cannot be the zero address.
1081      */
1082     function _approve(address owner, address spender, uint256 amount) internal virtual {
1083         require(owner != address(0), "ERC20: approve from the zero address");
1084         require(spender != address(0), "ERC20: approve to the zero address");
1085 
1086         _allowances[owner][spender] = amount;
1087         emit Approval(owner, spender, amount);
1088     }
1089 
1090     /**
1091      * @dev Sets {decimals} to a value other than the default one of 18.
1092      *
1093      * WARNING: This function should only be called from the constructor. Most
1094      * applications that interact with token contracts will not expect
1095      * {decimals} to ever change, and may work incorrectly if it does.
1096      */
1097     function _setupDecimals(uint8 decimals_) internal {
1098         _decimals = decimals_;
1099     }
1100 
1101     /**
1102      * @dev Hook that is called before any transfer of tokens. This includes
1103      * minting and burning.
1104      *
1105      * Calling conditions:
1106      *
1107      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1108      * will be to transferred to `to`.
1109      * - when `from` is zero, `amount` tokens will be minted for `to`.
1110      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1111      * - `from` and `to` are never both zero.
1112      *
1113      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1114      */
1115     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1116 }
1117 
1118 // File: contracts/FxswapToken.sol
1119 
1120 pragma solidity 0.6.12;
1121 
1122 
1123 
1124 
1125 // FxswapToken with Governance.
1126 contract FxswapToken is ERC20("FxswapToken", "FXSWAP"), Ownable {
1127     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1128     function mint(address _to, uint256 _amount) public onlyOwner {
1129         _mint(_to, _amount);
1130         _moveDelegates(address(0), _delegates[_to], _amount);
1131     }
1132 
1133     // Copied and modified from YAM code:
1134     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1135     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1136     // Which is copied and modified from COMPOUND:
1137     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1138 
1139     /// @notice A record of each accounts delegate
1140     mapping (address => address) internal _delegates;
1141 
1142     /// @notice A checkpoint for marking number of votes from a given block
1143     struct Checkpoint {
1144         uint32 fromBlock;
1145         uint256 votes;
1146     }
1147 
1148     /// @notice A record of votes checkpoints for each account, by index
1149     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1150 
1151     /// @notice The number of checkpoints for each account
1152     mapping (address => uint32) public numCheckpoints;
1153 
1154     /// @notice The EIP-712 typehash for the contract's domain
1155     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1156 
1157     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1158     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1159 
1160     /// @notice A record of states for signing / validating signatures
1161     mapping (address => uint) public nonces;
1162 
1163     /// @notice An event thats emitted when an account changes its delegate
1164     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1165 
1166     /// @notice An event thats emitted when a delegate account's vote balance changes
1167     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1168 
1169     /**
1170      * @notice Delegate votes from `msg.sender` to `delegatee`
1171      * @param delegator The address to get delegatee for
1172      */
1173     function delegates(address delegator)
1174     external
1175     view
1176     returns (address)
1177     {
1178         return _delegates[delegator];
1179     }
1180 
1181     /**
1182      * @notice Delegate votes from `msg.sender` to `delegatee`
1183      * @param delegatee The address to delegate votes to
1184      */
1185     function delegate(address delegatee) external {
1186         return _delegate(msg.sender, delegatee);
1187     }
1188 
1189     /**
1190      * @notice Delegates votes from signatory to `delegatee`
1191      * @param delegatee The address to delegate votes to
1192      * @param nonce The contract state required to match the signature
1193      * @param expiry The time at which to expire the signature
1194      * @param v The recovery byte of the signature
1195      * @param r Half of the ECDSA signature pair
1196      * @param s Half of the ECDSA signature pair
1197      */
1198     function delegateBySig(
1199         address delegatee,
1200         uint nonce,
1201         uint expiry,
1202         uint8 v,
1203         bytes32 r,
1204         bytes32 s
1205     )
1206     external
1207     {
1208         bytes32 domainSeparator = keccak256(
1209             abi.encode(
1210                 DOMAIN_TYPEHASH,
1211                 keccak256(bytes(name())),
1212                 getChainId(),
1213                 address(this)
1214             )
1215         );
1216 
1217         bytes32 structHash = keccak256(
1218             abi.encode(
1219                 DELEGATION_TYPEHASH,
1220                 delegatee,
1221                 nonce,
1222                 expiry
1223             )
1224         );
1225 
1226         bytes32 digest = keccak256(
1227             abi.encodePacked(
1228                 "\x19\x01",
1229                 domainSeparator,
1230                 structHash
1231             )
1232         );
1233 
1234         address signatory = ecrecover(digest, v, r, s);
1235         require(signatory != address(0), "FXSWAP::delegateBySig: invalid signature");
1236         require(nonce == nonces[signatory]++, "FXSWAP::delegateBySig: invalid nonce");
1237         require(now <= expiry, "FXSWAP::delegateBySig: signature expired");
1238         return _delegate(signatory, delegatee);
1239     }
1240 
1241     /**
1242      * @notice Gets the current votes balance for `account`
1243      * @param account The address to get votes balance
1244      * @return The number of current votes for `account`
1245      */
1246     function getCurrentVotes(address account)
1247     external
1248     view
1249     returns (uint256)
1250     {
1251         uint32 nCheckpoints = numCheckpoints[account];
1252         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1253     }
1254 
1255     /**
1256      * @notice Determine the prior number of votes for an account as of a block number
1257      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1258      * @param account The address of the account to check
1259      * @param blockNumber The block number to get the vote balance at
1260      * @return The number of votes the account had as of the given block
1261      */
1262     function getPriorVotes(address account, uint blockNumber)
1263     external
1264     view
1265     returns (uint256)
1266     {
1267         require(blockNumber < block.number, "FXSWAP::getPriorVotes: not yet determined");
1268 
1269         uint32 nCheckpoints = numCheckpoints[account];
1270         if (nCheckpoints == 0) {
1271             return 0;
1272         }
1273 
1274         // First check most recent balance
1275         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1276             return checkpoints[account][nCheckpoints - 1].votes;
1277         }
1278 
1279         // Next check implicit zero balance
1280         if (checkpoints[account][0].fromBlock > blockNumber) {
1281             return 0;
1282         }
1283 
1284         uint32 lower = 0;
1285         uint32 upper = nCheckpoints - 1;
1286         while (upper > lower) {
1287             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1288             Checkpoint memory cp = checkpoints[account][center];
1289             if (cp.fromBlock == blockNumber) {
1290                 return cp.votes;
1291             } else if (cp.fromBlock < blockNumber) {
1292                 lower = center;
1293             } else {
1294                 upper = center - 1;
1295             }
1296         }
1297         return checkpoints[account][lower].votes;
1298     }
1299 
1300     function _delegate(address delegator, address delegatee)
1301     internal
1302     {
1303         address currentDelegate = _delegates[delegator];
1304         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying FXSWAPs (not scaled);
1305         _delegates[delegator] = delegatee;
1306 
1307         emit DelegateChanged(delegator, currentDelegate, delegatee);
1308 
1309         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1310     }
1311 
1312     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1313         if (srcRep != dstRep && amount > 0) {
1314             if (srcRep != address(0)) {
1315                 // decrease old representative
1316                 uint32 srcRepNum = numCheckpoints[srcRep];
1317                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1318                 uint256 srcRepNew = srcRepOld.sub(amount);
1319                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1320             }
1321 
1322             if (dstRep != address(0)) {
1323                 // increase new representative
1324                 uint32 dstRepNum = numCheckpoints[dstRep];
1325                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1326                 uint256 dstRepNew = dstRepOld.add(amount);
1327                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1328             }
1329         }
1330     }
1331 
1332     function _writeCheckpoint(
1333         address delegatee,
1334         uint32 nCheckpoints,
1335         uint256 oldVotes,
1336         uint256 newVotes
1337     )
1338     internal
1339     {
1340         uint32 blockNumber = safe32(block.number, "FXSWAP::_writeCheckpoint: block number exceeds 32 bits");
1341 
1342         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1343             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1344         } else {
1345             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1346             numCheckpoints[delegatee] = nCheckpoints + 1;
1347         }
1348 
1349         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1350     }
1351 
1352     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1353         require(n < 2**32, errorMessage);
1354         return uint32(n);
1355     }
1356 
1357     function getChainId() internal pure returns (uint) {
1358         uint256 chainId;
1359         assembly { chainId := chainid() }
1360         return chainId;
1361     }
1362 }
1363 
1364 // File: contracts/MasterChef.sol
1365 
1366 pragma solidity 0.6.12;
1367 
1368 
1369 
1370 
1371 
1372 
1373 
1374 
1375 interface IMigratorChef {
1376     // Perform LP token migration from legacy UniswapV2 to FxswapSwap.
1377     // Take the current LP token address and return the new LP token address.
1378     // Migrator should have full access to the caller's LP token.
1379     // Return the new LP token address.
1380     //
1381     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1382     // FxswapSwap must mint EXACTLY the same amount of FxswapSwap LP tokens or
1383     // else something bad will happen. Traditional UniswapV2 does not
1384     // do that so be careful!
1385     function migrate(IERC20 token) external returns (IERC20);
1386 }
1387 
1388 // MasterChef is the master of Fxswap. He can make Fxswap and he is a fair guy.
1389 //
1390 // Note that it's ownable and the owner wields tremendous power. The ownership
1391 // will be transferred to a governance smart contract once FXSWAP is sufficiently
1392 // distributed and the community can show to govern itself.
1393 //
1394 // Have fun reading it. Hopefully it's bug-free. God bless.
1395 contract MasterChef is Ownable {
1396     using SafeMath for uint256;
1397     using SafeERC20 for IERC20;
1398 
1399     // Info of each user.
1400     struct UserInfo {
1401         uint256 amount;     // How many LP tokens the user has provided.
1402         uint256 rewardDebt; // Reward debt. See explanation below.
1403         //
1404         // We do some fancy math here. Basically, any point in time, the amount of FXSWAPs
1405         // entitled to a user but is pending to be distributed is:
1406         //
1407         //   pending reward = (user.amount * pool.accFxswapPerShare) - user.rewardDebt
1408         //
1409         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1410         //   1. The pool's `accFxswapPerShare` (and `lastRewardBlock`) gets updated.
1411         //   2. User receives the pending reward sent to his/her address.
1412         //   3. User's `amount` gets updated.
1413         //   4. User's `rewardDebt` gets updated.
1414     }
1415 
1416     // Info of each pool.
1417     struct PoolInfo {
1418         IERC20 lpToken;           // Address of LP token contract.
1419         uint256 allocPoint;       // How many allocation points assigned to this pool. FXSWAPs to distribute per block.
1420         uint256 lastRewardBlock;  // Last block number that FXSWAPs distribution occurs.
1421         uint256 accFxswapPerShare; // Accumulated FXSWAPs per share, times 1e12. See below.
1422     }
1423 
1424     // The FXSWAP TOKEN!
1425     FxswapToken public fxswap;
1426     // Dev address.
1427     address public devaddr;
1428     // Block number when bonus FXSWAP period ends.
1429     uint256 public bonusEndBlock;
1430     // FXSWAP tokens created per block.
1431     uint256 public fxswapPerBlock;
1432     // Bonus muliplier for early fxswap makers.
1433     uint256 public constant BONUS_MULTIPLIER = 1;
1434     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1435     IMigratorChef public migrator;
1436 
1437     // Info of each pool.
1438     PoolInfo[] public poolInfo;
1439     // Info of each user that stakes LP tokens.
1440     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1441     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1442     uint256 public totalAllocPoint = 0;
1443     // The block number when FXSWAP mining starts.
1444     uint256 public startBlock;
1445 
1446     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1447     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1448     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1449 
1450     constructor(
1451         FxswapToken _fxswap,
1452         address _devaddr,
1453         uint256 _fxswapPerBlock,
1454         uint256 _startBlock,
1455         uint256 _bonusEndBlock
1456     ) public {
1457         fxswap = _fxswap;
1458         devaddr = _devaddr;
1459         fxswapPerBlock = _fxswapPerBlock;
1460         bonusEndBlock = _bonusEndBlock;
1461         startBlock = _startBlock;
1462     }
1463 
1464     function poolLength() external view returns (uint256) {
1465         return poolInfo.length;
1466     }
1467 
1468     // Add a new lp to the pool. Can only be called by the owner.
1469     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1470     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1471         if (_withUpdate) {
1472             massUpdatePools();
1473         }
1474         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1475         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1476         poolInfo.push(PoolInfo({
1477         lpToken: _lpToken,
1478         allocPoint: _allocPoint,
1479         lastRewardBlock: lastRewardBlock,
1480         accFxswapPerShare: 0
1481         }));
1482     }
1483 
1484     // Update the given pool's FXSWAP allocation point. Can only be called by the owner.
1485     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1486         if (_withUpdate) {
1487             massUpdatePools();
1488         }
1489         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1490         poolInfo[_pid].allocPoint = _allocPoint;
1491     }
1492 
1493     // Set the migrator contract. Can only be called by the owner.
1494     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1495         migrator = _migrator;
1496     }
1497 
1498     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1499     function migrate(uint256 _pid) public {
1500         require(address(migrator) != address(0), "migrate: no migrator");
1501         PoolInfo storage pool = poolInfo[_pid];
1502         IERC20 lpToken = pool.lpToken;
1503         uint256 bal = lpToken.balanceOf(address(this));
1504         lpToken.safeApprove(address(migrator), bal);
1505         IERC20 newLpToken = migrator.migrate(lpToken);
1506         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1507         pool.lpToken = newLpToken;
1508     }
1509 
1510     // Return reward multiplier over the given _from to _to block.
1511     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1512         if (_to <= bonusEndBlock) {
1513             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1514         } else if (_from >= bonusEndBlock) {
1515             return _to.sub(_from);
1516         } else {
1517             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1518                 _to.sub(bonusEndBlock)
1519             );
1520         }
1521     }
1522 
1523     // View function to see pending FXSWAPs on frontend.
1524     function pendingFxswap(uint256 _pid, address _user) external view returns (uint256) {
1525         PoolInfo storage pool = poolInfo[_pid];
1526         UserInfo storage user = userInfo[_pid][_user];
1527         uint256 accFxswapPerShare = pool.accFxswapPerShare;
1528         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1529         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1530             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1531             uint256 fxswapReward = multiplier.mul(fxswapPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1532             accFxswapPerShare = accFxswapPerShare.add(fxswapReward.mul(1e12).div(lpSupply));
1533         }
1534         return user.amount.mul(accFxswapPerShare).div(1e12).sub(user.rewardDebt);
1535     }
1536 
1537     // Update reward vairables for all pools. Be careful of gas spending!
1538     function massUpdatePools() public {
1539         uint256 length = poolInfo.length;
1540         for (uint256 pid = 0; pid < length; ++pid) {
1541             updatePool(pid);
1542         }
1543     }
1544 
1545     // Update reward variables of the given pool to be up-to-date.
1546     function updatePool(uint256 _pid) public {
1547         PoolInfo storage pool = poolInfo[_pid];
1548         if (block.number <= pool.lastRewardBlock) {
1549             return;
1550         }
1551         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1552         if (lpSupply == 0) {
1553             pool.lastRewardBlock = block.number;
1554             return;
1555         }
1556         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1557         uint256 fxswapReward = multiplier.mul(fxswapPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1558         fxswap.mint(devaddr, fxswapReward.div(10));
1559         fxswap.mint(address(this), fxswapReward);
1560         pool.accFxswapPerShare = pool.accFxswapPerShare.add(fxswapReward.mul(1e12).div(lpSupply));
1561         pool.lastRewardBlock = block.number;
1562     }
1563 
1564     // Deposit LP tokens to MasterChef for FXSWAP allocation.
1565     function deposit(uint256 _pid, uint256 _amount) public {
1566         PoolInfo storage pool = poolInfo[_pid];
1567         UserInfo storage user = userInfo[_pid][msg.sender];
1568         updatePool(_pid);
1569         if (user.amount > 0) {
1570             uint256 pending = user.amount.mul(pool.accFxswapPerShare).div(1e12).sub(user.rewardDebt);
1571             safeFxswapTransfer(msg.sender, pending);
1572         }
1573         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1574         user.amount = user.amount.add(_amount);
1575         user.rewardDebt = user.amount.mul(pool.accFxswapPerShare).div(1e12);
1576         emit Deposit(msg.sender, _pid, _amount);
1577     }
1578 
1579     // Withdraw LP tokens from MasterChef.
1580     function withdraw(uint256 _pid, uint256 _amount) public {
1581         PoolInfo storage pool = poolInfo[_pid];
1582         UserInfo storage user = userInfo[_pid][msg.sender];
1583         require(user.amount >= _amount, "withdraw: not good");
1584         updatePool(_pid);
1585         uint256 pending = user.amount.mul(pool.accFxswapPerShare).div(1e12).sub(user.rewardDebt);
1586         safeFxswapTransfer(msg.sender, pending);
1587         user.amount = user.amount.sub(_amount);
1588         user.rewardDebt = user.amount.mul(pool.accFxswapPerShare).div(1e12);
1589         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1590         emit Withdraw(msg.sender, _pid, _amount);
1591     }
1592 
1593     // Withdraw without caring about rewards. EMERGENCY ONLY.
1594     function emergencyWithdraw(uint256 _pid) public {
1595         PoolInfo storage pool = poolInfo[_pid];
1596         UserInfo storage user = userInfo[_pid][msg.sender];
1597         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1598         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1599         user.amount = 0;
1600         user.rewardDebt = 0;
1601     }
1602 
1603     // Safe fxswap transfer function, just in case if rounding error causes pool to not have enough FXSWAPs.
1604     function safeFxswapTransfer(address _to, uint256 _amount) internal {
1605         uint256 fxswapBal = fxswap.balanceOf(address(this));
1606         if (_amount > fxswapBal) {
1607             fxswap.transfer(_to, fxswapBal);
1608         } else {
1609             fxswap.transfer(_to, _amount);
1610         }
1611     }
1612 
1613     // Update dev address by the previous dev.
1614     function dev(address _devaddr) public {
1615         require(msg.sender == devaddr, "dev: wut?");
1616         devaddr = _devaddr;
1617     }
1618 }