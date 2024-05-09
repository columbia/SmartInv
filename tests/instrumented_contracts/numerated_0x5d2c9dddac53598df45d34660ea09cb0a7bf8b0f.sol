1 /*
2 
3    ___  _________________  ____  ____
4   / _ )/  _/ __/_  __/ _ \/ __ \/ __ \
5  / _  |/ /_\ \  / / / , _/ /_/ / /_/ /
6 /____/___/___/ /_/ /_/|_|\____/\____/
7 
8 Bistroo Farm/Liquidity Contract
9 Powered by TERRY.COM
10 
11 */
12 
13 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
14 
15 pragma solidity ^0.6.0;
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 // File: @openzeppelin/contracts/math/SafeMath.sol
92 
93 pragma solidity ^0.6.0;
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b, "SafeMath: multiplication overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts on
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
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         return div(a, b, "SafeMath: division by zero");
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return mod(a, b, "SafeMath: modulo by zero");
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts with custom message when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b != 0, errorMessage);
247         return a % b;
248     }
249 }
250 
251 // File: @openzeppelin/contracts/utils/Address.sol
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
395 pragma solidity ^0.6.0;
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
468 pragma solidity ^0.6.0;
469 
470 /**
471  * @dev Library for managing
472  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
473  * types.
474  *
475  * Sets have the following properties:
476  *
477  * - Elements are added, removed, and checked for existence in constant time
478  * (O(1)).
479  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
480  *
481  * ```
482  * contract Example {
483  *     // Add the library methods
484  *     using EnumerableSet for EnumerableSet.AddressSet;
485  *
486  *     // Declare a set state variable
487  *     EnumerableSet.AddressSet private mySet;
488  * }
489  * ```
490  *
491  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
492  * (`UintSet`) are supported.
493  */
494 library EnumerableSet {
495     // To implement this library for multiple types with as little code
496     // repetition as possible, we write it in terms of a generic Set type with
497     // bytes32 values.
498     // The Set implementation uses private functions, and user-facing
499     // implementations (such as AddressSet) are just wrappers around the
500     // underlying Set.
501     // This means that we can only create new EnumerableSets for types that fit
502     // in bytes32.
503 
504     struct Set {
505         // Storage of set values
506         bytes32[] _values;
507 
508         // Position of the value in the `values` array, plus 1 because index 0
509         // means a value is not in the set.
510         mapping (bytes32 => uint256) _indexes;
511     }
512 
513     /**
514      * @dev Add a value to a set. O(1).
515      *
516      * Returns true if the value was added to the set, that is if it was not
517      * already present.
518      */
519     function _add(Set storage set, bytes32 value) private returns (bool) {
520         if (!_contains(set, value)) {
521             set._values.push(value);
522             // The value is stored at length-1, but we add 1 to all indexes
523             // and use 0 as a sentinel value
524             set._indexes[value] = set._values.length;
525             return true;
526         } else {
527             return false;
528         }
529     }
530 
531     /**
532      * @dev Removes a value from a set. O(1).
533      *
534      * Returns true if the value was removed from the set, that is if it was
535      * present.
536      */
537     function _remove(Set storage set, bytes32 value) private returns (bool) {
538         // We read and store the value's index to prevent multiple reads from the same storage slot
539         uint256 valueIndex = set._indexes[value];
540 
541         if (valueIndex != 0) { // Equivalent to contains(set, value)
542             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
543             // the array, and then remove the last element (sometimes called as 'swap and pop').
544             // This modifies the order of the array, as noted in {at}.
545 
546             uint256 toDeleteIndex = valueIndex - 1;
547             uint256 lastIndex = set._values.length - 1;
548 
549             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
550             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
551 
552             bytes32 lastvalue = set._values[lastIndex];
553 
554             // Move the last value to the index where the value to delete is
555             set._values[toDeleteIndex] = lastvalue;
556             // Update the index for the moved value
557             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
558 
559             // Delete the slot where the moved value was stored
560             set._values.pop();
561 
562             // Delete the index for the deleted slot
563             delete set._indexes[value];
564 
565             return true;
566         } else {
567             return false;
568         }
569     }
570 
571     /**
572      * @dev Returns true if the value is in the set. O(1).
573      */
574     function _contains(Set storage set, bytes32 value) private view returns (bool) {
575         return set._indexes[value] != 0;
576     }
577 
578     /**
579      * @dev Returns the number of values on the set. O(1).
580      */
581     function _length(Set storage set) private view returns (uint256) {
582         return set._values.length;
583     }
584 
585    /**
586     * @dev Returns the value stored at position `index` in the set. O(1).
587     *
588     * Note that there are no guarantees on the ordering of values inside the
589     * array, and it may change when more values are added or removed.
590     *
591     * Requirements:
592     *
593     * - `index` must be strictly less than {length}.
594     */
595     function _at(Set storage set, uint256 index) private view returns (bytes32) {
596         require(set._values.length > index, "EnumerableSet: index out of bounds");
597         return set._values[index];
598     }
599 
600     // AddressSet
601 
602     struct AddressSet {
603         Set _inner;
604     }
605 
606     /**
607      * @dev Add a value to a set. O(1).
608      *
609      * Returns true if the value was added to the set, that is if it was not
610      * already present.
611      */
612     function add(AddressSet storage set, address value) internal returns (bool) {
613         return _add(set._inner, bytes32(uint256(value)));
614     }
615 
616     /**
617      * @dev Removes a value from a set. O(1).
618      *
619      * Returns true if the value was removed from the set, that is if it was
620      * present.
621      */
622     function remove(AddressSet storage set, address value) internal returns (bool) {
623         return _remove(set._inner, bytes32(uint256(value)));
624     }
625 
626     /**
627      * @dev Returns true if the value is in the set. O(1).
628      */
629     function contains(AddressSet storage set, address value) internal view returns (bool) {
630         return _contains(set._inner, bytes32(uint256(value)));
631     }
632 
633     /**
634      * @dev Returns the number of values in the set. O(1).
635      */
636     function length(AddressSet storage set) internal view returns (uint256) {
637         return _length(set._inner);
638     }
639 
640    /**
641     * @dev Returns the value stored at position `index` in the set. O(1).
642     *
643     * Note that there are no guarantees on the ordering of values inside the
644     * array, and it may change when more values are added or removed.
645     *
646     * Requirements:
647     *
648     * - `index` must be strictly less than {length}.
649     */
650     function at(AddressSet storage set, uint256 index) internal view returns (address) {
651         return address(uint256(_at(set._inner, index)));
652     }
653 
654 
655     // UintSet
656 
657     struct UintSet {
658         Set _inner;
659     }
660 
661     /**
662      * @dev Add a value to a set. O(1).
663      *
664      * Returns true if the value was added to the set, that is if it was not
665      * already present.
666      */
667     function add(UintSet storage set, uint256 value) internal returns (bool) {
668         return _add(set._inner, bytes32(value));
669     }
670 
671     /**
672      * @dev Removes a value from a set. O(1).
673      *
674      * Returns true if the value was removed from the set, that is if it was
675      * present.
676      */
677     function remove(UintSet storage set, uint256 value) internal returns (bool) {
678         return _remove(set._inner, bytes32(value));
679     }
680 
681     /**
682      * @dev Returns true if the value is in the set. O(1).
683      */
684     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
685         return _contains(set._inner, bytes32(value));
686     }
687 
688     /**
689      * @dev Returns the number of values on the set. O(1).
690      */
691     function length(UintSet storage set) internal view returns (uint256) {
692         return _length(set._inner);
693     }
694 
695    /**
696     * @dev Returns the value stored at position `index` in the set. O(1).
697     *
698     * Note that there are no guarantees on the ordering of values inside the
699     * array, and it may change when more values are added or removed.
700     *
701     * Requirements:
702     *
703     * - `index` must be strictly less than {length}.
704     */
705     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
706         return uint256(_at(set._inner, index));
707     }
708 }
709 
710 // File: @openzeppelin/contracts/GSN/Context.sol
711 
712 pragma solidity ^0.6.0;
713 
714 /*
715  * @dev Provides information about the current execution context, including the
716  * sender of the transaction and its data. While these are generally available
717  * via msg.sender and msg.data, they should not be accessed in such a direct
718  * manner, since when dealing with GSN meta-transactions the account sending and
719  * paying for execution may not be the actual sender (as far as an application
720  * is concerned).
721  *
722  * This contract is only required for intermediate, library-like contracts.
723  */
724 abstract contract Context {
725     function _msgSender() internal view virtual returns (address payable) {
726         return msg.sender;
727     }
728 
729     function _msgData() internal view virtual returns (bytes memory) {
730         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
731         return msg.data;
732     }
733 }
734 
735 // File: @openzeppelin/contracts/access/Ownable.sol
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
805 pragma solidity ^0.6.0;
806 
807 /**
808  * @dev Implementation of the {IERC20} interface.
809  *
810  * This implementation is agnostic to the way tokens are created. This means
811  * that a supply mechanism has to be added in a derived contract using {_mint}.
812  * For a generic mechanism see {ERC20PresetMinterPauser}.
813  *
814  * TIP: For a detailed writeup see our guide
815  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
816  * to implement supply mechanisms].
817  *
818  * We have followed general OpenZeppelin guidelines: functions revert instead
819  * of returning `false` on failure. This behavior is nonetheless conventional
820  * and does not conflict with the expectations of ERC20 applications.
821  *
822  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
823  * This allows applications to reconstruct the allowance for all accounts just
824  * by listening to said events. Other implementations of the EIP may not emit
825  * these events, as it isn't required by the specification.
826  *
827  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
828  * functions have been added to mitigate the well-known issues around setting
829  * allowances. See {IERC20-approve}.
830  */
831 contract ERC20 is Context, IERC20 {
832     using SafeMath for uint256;
833     using Address for address;
834 
835     mapping (address => uint256) private _balances;
836 
837     mapping (address => mapping (address => uint256)) private _allowances;
838 
839     uint256 private _totalSupply;
840 
841     string private _name;
842     string private _symbol;
843     uint8 private _decimals;
844 
845     /**
846      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
847      * a default value of 18.
848      *
849      * To select a different value for {decimals}, use {_setupDecimals}.
850      *
851      * All three of these values are immutable: they can only be set once during
852      * construction.
853      */
854     constructor (string memory name, string memory symbol) public {
855         _name = name;
856         _symbol = symbol;
857         _decimals = 18;
858     }
859 
860     /**
861      * @dev Returns the name of the token.
862      */
863     function name() public view returns (string memory) {
864         return _name;
865     }
866 
867     /**
868      * @dev Returns the symbol of the token, usually a shorter version of the
869      * name.
870      */
871     function symbol() public view returns (string memory) {
872         return _symbol;
873     }
874 
875     /**
876      * @dev Returns the number of decimals used to get its user representation.
877      * For example, if `decimals` equals `2`, a balance of `505` tokens should
878      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
879      *
880      * Tokens usually opt for a value of 18, imitating the relationship between
881      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
882      * called.
883      *
884      * NOTE: This information is only used for _display_ purposes: it in
885      * no way affects any of the arithmetic of the contract, including
886      * {IERC20-balanceOf} and {IERC20-transfer}.
887      */
888     function decimals() public view returns (uint8) {
889         return _decimals;
890     }
891 
892     /**
893      * @dev See {IERC20-totalSupply}.
894      */
895     function totalSupply() public view override returns (uint256) {
896         return _totalSupply;
897     }
898 
899     /**
900      * @dev See {IERC20-balanceOf}.
901      */
902     function balanceOf(address account) public view override returns (uint256) {
903         return _balances[account];
904     }
905 
906     /**
907      * @dev See {IERC20-transfer}.
908      *
909      * Requirements:
910      *
911      * - `recipient` cannot be the zero address.
912      * - the caller must have a balance of at least `amount`.
913      */
914     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
915         _transfer(_msgSender(), recipient, amount);
916         return true;
917     }
918 
919     /**
920      * @dev See {IERC20-allowance}.
921      */
922     function allowance(address owner, address spender) public view virtual override returns (uint256) {
923         return _allowances[owner][spender];
924     }
925 
926     /**
927      * @dev See {IERC20-approve}.
928      *
929      * Requirements:
930      *
931      * - `spender` cannot be the zero address.
932      */
933     function approve(address spender, uint256 amount) public virtual override returns (bool) {
934         _approve(_msgSender(), spender, amount);
935         return true;
936     }
937 
938     /**
939      * @dev See {IERC20-transferFrom}.
940      *
941      * Emits an {Approval} event indicating the updated allowance. This is not
942      * required by the EIP. See the note at the beginning of {ERC20};
943      *
944      * Requirements:
945      * - `sender` and `recipient` cannot be the zero address.
946      * - `sender` must have a balance of at least `amount`.
947      * - the caller must have allowance for ``sender``'s tokens of at least
948      * `amount`.
949      */
950     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
951         _transfer(sender, recipient, amount);
952         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
953         return true;
954     }
955 
956     /**
957      * @dev Atomically increases the allowance granted to `spender` by the caller.
958      *
959      * This is an alternative to {approve} that can be used as a mitigation for
960      * problems described in {IERC20-approve}.
961      *
962      * Emits an {Approval} event indicating the updated allowance.
963      *
964      * Requirements:
965      *
966      * - `spender` cannot be the zero address.
967      */
968     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
969         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
970         return true;
971     }
972 
973     /**
974      * @dev Atomically decreases the allowance granted to `spender` by the caller.
975      *
976      * This is an alternative to {approve} that can be used as a mitigation for
977      * problems described in {IERC20-approve}.
978      *
979      * Emits an {Approval} event indicating the updated allowance.
980      *
981      * Requirements:
982      *
983      * - `spender` cannot be the zero address.
984      * - `spender` must have allowance for the caller of at least
985      * `subtractedValue`.
986      */
987     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
988         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
989         return true;
990     }
991 
992     /**
993      * @dev Moves tokens `amount` from `sender` to `recipient`.
994      *
995      * This is internal function is equivalent to {transfer}, and can be used to
996      * e.g. implement automatic token fees, slashing mechanisms, etc.
997      *
998      * Emits a {Transfer} event.
999      *
1000      * Requirements:
1001      *
1002      * - `sender` cannot be the zero address.
1003      * - `recipient` cannot be the zero address.
1004      * - `sender` must have a balance of at least `amount`.
1005      */
1006     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1007         require(sender != address(0), "ERC20: transfer from the zero address");
1008         require(recipient != address(0), "ERC20: transfer to the zero address");
1009 
1010         _beforeTokenTransfer(sender, recipient, amount);
1011 
1012         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1013         _balances[recipient] = _balances[recipient].add(amount);
1014         emit Transfer(sender, recipient, amount);
1015     }
1016 
1017     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1018      * the total supply.
1019      *
1020      * Emits a {Transfer} event with `from` set to the zero address.
1021      *
1022      * Requirements
1023      *
1024      * - `to` cannot be the zero address.
1025      */
1026     function _mint(address account, uint256 amount) internal virtual {
1027         require(account != address(0), "ERC20: mint to the zero address");
1028 
1029         _beforeTokenTransfer(address(0), account, amount);
1030 
1031         _totalSupply = _totalSupply.add(amount);
1032         _balances[account] = _balances[account].add(amount);
1033         emit Transfer(address(0), account, amount);
1034     }
1035 
1036     /**
1037      * @dev Destroys `amount` tokens from `account`, reducing the
1038      * total supply.
1039      *
1040      * Emits a {Transfer} event with `to` set to the zero address.
1041      *
1042      * Requirements
1043      *
1044      * - `account` cannot be the zero address.
1045      * - `account` must have at least `amount` tokens.
1046      */
1047     function _burn(address account, uint256 amount) internal virtual {
1048         require(account != address(0), "ERC20: burn from the zero address");
1049 
1050         _beforeTokenTransfer(account, address(0), amount);
1051 
1052         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1053         _totalSupply = _totalSupply.sub(amount);
1054         emit Transfer(account, address(0), amount);
1055     }
1056 
1057     /**
1058      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1059      *
1060      * This is internal function is equivalent to `approve`, and can be used to
1061      * e.g. set automatic allowances for certain subsystems, etc.
1062      *
1063      * Emits an {Approval} event.
1064      *
1065      * Requirements:
1066      *
1067      * - `owner` cannot be the zero address.
1068      * - `spender` cannot be the zero address.
1069      */
1070     function _approve(address owner, address spender, uint256 amount) internal virtual {
1071         require(owner != address(0), "ERC20: approve from the zero address");
1072         require(spender != address(0), "ERC20: approve to the zero address");
1073 
1074         _allowances[owner][spender] = amount;
1075         emit Approval(owner, spender, amount);
1076     }
1077 
1078     /**
1079      * @dev Sets {decimals} to a value other than the default one of 18.
1080      *
1081      * WARNING: This function should only be called from the constructor. Most
1082      * applications that interact with token contracts will not expect
1083      * {decimals} to ever change, and may work incorrectly if it does.
1084      */
1085     function _setupDecimals(uint8 decimals_) internal {
1086         _decimals = decimals_;
1087     }
1088 
1089     /**
1090      * @dev Hook that is called before any transfer of tokens. This includes
1091      * minting and burning.
1092      *
1093      * Calling conditions:
1094      *
1095      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1096      * will be to transferred to `to`.
1097      * - when `from` is zero, `amount` tokens will be minted for `to`.
1098      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1099      * - `from` and `to` are never both zero.
1100      *
1101      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1102      */
1103     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1104 }
1105 
1106 // File: contracts/BistrooFarm.sol
1107 
1108 pragma solidity 0.6.12;
1109 
1110 interface IMigratorChef {
1111     // Perform LP token migration from legacy UniswapV2 to SushiSwap.
1112     // Take the current LP token address and return the new LP token address.
1113     // Migrator should have full access to the caller's LP token.
1114     // Return the new LP token address.
1115     function migrate(IERC20 token) external returns (IERC20);
1116 }
1117 
1118 contract BistrooFarm is Ownable {
1119     using SafeMath for uint256;
1120     using SafeERC20 for IERC20;
1121 
1122     // Info of each user.
1123     struct UserInfo {
1124         uint256 amount; // How many LP tokens the user has provided.
1125         uint256 rewardDebt; // Reward debt.
1126     }
1127 
1128     // Info of each pool.
1129     struct PoolInfo {
1130         IERC20 lpToken; // Address of LP token contract.
1131         uint256 allocPoint; // How many allocation points assigned to this pool. BISTs to distribute per block.
1132         uint256 lastRewardBlock; // Last block number that BISTs distribution occurs.
1133         uint256 accBistPerShare; // Accumulated BISTs per share, times 1e12. See below.
1134     }
1135 
1136     // The BIST TOKEN
1137     ERC20 public bist;
1138 
1139     // Dev address.
1140     address public devaddr;
1141 
1142     // Rewards address.
1143     address public rewardsaddr;
1144 
1145     // BIST tokens created per block.
1146     uint256 public bistPerBlock;
1147 
1148     // Bonus muliplier for early BIST makers.
1149     uint256 public constant BONUS_MULTIPLIER = 10;
1150 
1151     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1152     IMigratorChef public migrator;
1153 
1154     // Info of each pool.
1155     PoolInfo[] public poolInfo;
1156 
1157     // Info of each user that stakes LP tokens.
1158     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1159 
1160     // Total allocation points. Must be the sum of all allocation points in all pools.
1161     uint256 public totalAllocPoint = 0;
1162 
1163     // The block number when BIST mining starts.
1164     uint256 public startBlock;
1165 
1166     // Block number when BIST mining ends.
1167     uint256 public stopBlock;
1168 
1169     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1170     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1171     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1172 
1173     constructor(ERC20 _bist, address _devaddr, address _rewardsaddr, uint256 _bistPerBlock, uint256 _startBlock, uint256 _stopBlock) public {
1174         bist = _bist;
1175         devaddr = _devaddr;
1176         rewardsaddr = _rewardsaddr;
1177         bistPerBlock = _bistPerBlock;
1178         startBlock = _startBlock;
1179         stopBlock = _stopBlock;
1180     }
1181 
1182     function poolLength() external view returns (uint256) {
1183         return poolInfo.length;
1184     }
1185 
1186     // Add a new lp to the pool. Can only be called by the owner.
1187     // DO NOT add the same LP token more than once.
1188     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1189         if (_withUpdate) {
1190             massUpdatePools();
1191         }
1192 
1193         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1194         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1195         poolInfo.push(
1196             PoolInfo({
1197                 lpToken: _lpToken,
1198                 allocPoint: _allocPoint,
1199                 lastRewardBlock: lastRewardBlock,
1200                 accBistPerShare: 0
1201             })
1202         );
1203     }
1204 
1205     // Update the given pool's BIST allocation point. Can only be called by the owner.
1206     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1207         if (_withUpdate) {
1208             massUpdatePools();
1209         }
1210 
1211         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1212         poolInfo[_pid].allocPoint = _allocPoint;
1213     }
1214 
1215     // Set the migrator contract. Can only be called by the owner.
1216     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1217         migrator = _migrator;
1218     }
1219 
1220     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1221     function migrate(uint256 _pid) public {
1222         require(address(migrator) != address(0), "migrate: no migrator");
1223         PoolInfo storage pool = poolInfo[_pid];
1224         IERC20 lpToken = pool.lpToken;
1225         uint256 bal = lpToken.balanceOf(address(this));
1226         lpToken.safeApprove(address(migrator), bal);
1227         IERC20 newLpToken = migrator.migrate(lpToken);
1228         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1229         pool.lpToken = newLpToken;
1230     }
1231 
1232     // Return reward multiplier over the given _from to _to block.
1233     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1234         if (_from > stopBlock) {
1235             return 0;
1236         }
1237 
1238         if (_to >= stopBlock) {
1239             return stopBlock.sub(_from);
1240         }
1241 
1242         return _to.sub(_from);
1243     }
1244 
1245     // View function to see pending BISTs on frontend.
1246     function pendingBist(uint256 _pid, address _user) external view returns (uint256) {
1247         PoolInfo storage pool = poolInfo[_pid];
1248         UserInfo storage user = userInfo[_pid][_user];
1249         uint256 accBistPerShare = pool.accBistPerShare;
1250         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1251         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1252             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1253             uint256 bistReward = multiplier.mul(bistPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1254             accBistPerShare = accBistPerShare.add(bistReward.mul(1e12).div(lpSupply));
1255         }
1256 
1257         return user.amount.mul(accBistPerShare).div(1e12).sub(user.rewardDebt);
1258     }
1259 
1260     // Update reward variables for all pools. Be careful of gas spending!
1261     function massUpdatePools() public {
1262         uint256 length = poolInfo.length;
1263         for (uint256 pid = 0; pid < length; ++pid) {
1264             updatePool(pid);
1265         }
1266     }
1267 
1268     // Update reward variables of the given pool to be up-to-date.
1269     function updatePool(uint256 _pid) public {
1270         PoolInfo storage pool = poolInfo[_pid];
1271         if (block.number <= pool.lastRewardBlock) {
1272             return;
1273         }
1274 
1275         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1276         if (lpSupply == 0) {
1277             pool.lastRewardBlock = block.number;
1278             return;
1279         }
1280 
1281         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1282         uint256 bistReward = multiplier.mul(bistPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1283 
1284         pool.accBistPerShare = pool.accBistPerShare.add(bistReward.mul(1e12).div(lpSupply));
1285         pool.lastRewardBlock = block.number;
1286     }
1287 
1288     // Deposit LP tokens to BistrooFarm for BIST allocation.
1289     function deposit(uint256 _pid, uint256 _amount) public {
1290         require(block.number < stopBlock, "deposit: reward period has ended");
1291         PoolInfo storage pool = poolInfo[_pid];
1292         UserInfo storage user = userInfo[_pid][msg.sender];
1293         updatePool(_pid);
1294 
1295         if (user.amount > 0) {
1296             uint256 pending = user.amount.mul(pool.accBistPerShare).div(1e12).sub(user.rewardDebt);
1297             safeBistTransfer(msg.sender, pending);
1298         }
1299 
1300         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1301         user.amount = user.amount.add(_amount);
1302         user.rewardDebt = user.amount.mul(pool.accBistPerShare).div(1e12);
1303         emit Deposit(msg.sender, _pid, _amount);
1304     }
1305 
1306     // Withdraw LP tokens from BistrooFarm.
1307     function withdraw(uint256 _pid, uint256 _amount) public {
1308         PoolInfo storage pool = poolInfo[_pid];
1309         UserInfo storage user = userInfo[_pid][msg.sender];
1310         require(user.amount >= _amount, "withdraw: not good");
1311         updatePool(_pid);
1312         uint256 pending = user.amount.mul(pool.accBistPerShare).div(1e12).sub(user.rewardDebt);
1313         safeBistTransfer(msg.sender, pending);
1314         user.amount = user.amount.sub(_amount);
1315         user.rewardDebt = user.amount.mul(pool.accBistPerShare).div(1e12);
1316         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1317         emit Withdraw(msg.sender, _pid, _amount);
1318     }
1319 
1320     // Withdraw without caring about rewards. EMERGENCY ONLY.
1321     function emergencyWithdraw(uint256 _pid) public {
1322         PoolInfo storage pool = poolInfo[_pid];
1323         UserInfo storage user = userInfo[_pid][msg.sender];
1324         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1325         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1326         user.amount = 0;
1327         user.rewardDebt = 0;
1328     }
1329 
1330     // Safe BIST transfer function, just in case if rounding error causes rewardsaddr to not have enough BISTs.
1331     function safeBistTransfer(address _to, uint256 _amount) internal {
1332         uint256 bistBal = bist.balanceOf(rewardsaddr);
1333         if (_amount > bistBal) {
1334             bist.transferFrom(rewardsaddr, _to, bistBal);
1335         } else {
1336             bist.transferFrom(rewardsaddr, _to, _amount);
1337         }
1338     }
1339 
1340     // Update dev address by the previous dev.
1341     function dev(address _devaddr) public {
1342         require(msg.sender == devaddr, "dev: wut?");
1343         devaddr = _devaddr;
1344     }
1345 }