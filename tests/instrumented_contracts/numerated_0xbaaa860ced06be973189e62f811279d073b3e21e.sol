1 pragma solidity ^0.6.12;
2 
3 /*
4 
5 https://soju.farm
6 
7  $$$$$$\   $$$$$$\     $$$$$\ $$\   $$\
8 $$  __$$\ $$  __$$\    \__$$ |$$ |  $$ |
9 $$ /  \__|$$ /  $$ |      $$ |$$ |  $$ |
10 \$$$$$$\  $$ |  $$ |      $$ |$$ |  $$ |
11  \____$$\ $$ |  $$ |$$\   $$ |$$ |  $$ |
12 $$\   $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |
13 \$$$$$$  | $$$$$$  |\$$$$$$  |\$$$$$$  |
14  \______/  \______/  \______/  \______/
15 
16 */
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with GSN meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 
117 library SafeERC20 {
118     using SafeMath for uint256;
119     using Address for address;
120 
121     function safeTransfer(IERC20 token, address to, uint256 value) internal {
122         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
123     }
124 
125     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
126         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
127     }
128 
129     /**
130      * @dev Deprecated. This function has issues similar to the ones found in
131      * {IERC20-approve}, and its usage is discouraged.
132      *
133      * Whenever possible, use {safeIncreaseAllowance} and
134      * {safeDecreaseAllowance} instead.
135      */
136     function safeApprove(IERC20 token, address spender, uint256 value) internal {
137         // safeApprove should only be called when setting an initial allowance,
138         // or when resetting it to zero. To increase and decrease it, use
139         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
140         // solhint-disable-next-line max-line-length
141         require((value == 0) || (token.allowance(address(this), spender) == 0),
142             "SafeERC20: approve from non-zero to non-zero allowance"
143         );
144         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
145     }
146 
147     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
148         uint256 newAllowance = token.allowance(address(this), spender).add(value);
149         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
150     }
151 
152     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
153         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
154         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
155     }
156 
157     /**
158      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
159      * on the return value: the return value is optional (but if data is returned, it must not be false).
160      * @param token The token targeted by the call.
161      * @param data The call data (encoded using abi.encode or one of its variants).
162      */
163     function _callOptionalReturn(IERC20 token, bytes memory data) private {
164         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
165         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
166         // the target address contains contract code and also asserts for success in the low-level call.
167 
168         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
169         if (returndata.length > 0) { // Return data is optional
170             // solhint-disable-next-line max-line-length
171             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
172         }
173     }
174 }
175 
176 // File: @openzeppelin/contracts/math/SafeMath.sol
177 
178 /**
179  * @dev Library for managing
180  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
181  * types.
182  *
183  * Sets have the following properties:
184  *
185  * - Elements are added, removed, and checked for existence in constant time
186  * (O(1)).
187  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
188  *
189  * ```
190  * contract Example {
191  *     // Add the library methods
192  *     using EnumerableSet for EnumerableSet.AddressSet;
193  *
194  *     // Declare a set state variable
195  *     EnumerableSet.AddressSet private mySet;
196  * }
197  * ```
198  *
199  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
200  * (`UintSet`) are supported.
201  */
202  
203 library EnumerableSet {
204     // To implement this library for multiple types with as little code
205     // repetition as possible, we write it in terms of a generic Set type with
206     // bytes32 values.
207     // The Set implementation uses private functions, and user-facing
208     // implementations (such as AddressSet) are just wrappers around the
209     // underlying Set.
210     // This means that we can only create new EnumerableSets for types that fit
211     // in bytes32.
212 
213     struct Set {
214         // Storage of set values
215         bytes32[] _values;
216 
217         // Position of the value in the `values` array, plus 1 because index 0
218         // means a value is not in the set.
219         mapping (bytes32 => uint256) _indexes;
220     }
221 
222     /**
223      * @dev Add a value to a set. O(1).
224      *
225      * Returns true if the value was added to the set, that is if it was not
226      * already present.
227      */
228     function _add(Set storage set, bytes32 value) private returns (bool) {
229         if (!_contains(set, value)) {
230             set._values.push(value);
231             // The value is stored at length-1, but we add 1 to all indexes
232             // and use 0 as a sentinel value
233             set._indexes[value] = set._values.length;
234             return true;
235         } else {
236             return false;
237         }
238     }
239 
240     /**
241      * @dev Removes a value from a set. O(1).
242      *
243      * Returns true if the value was removed from the set, that is if it was
244      * present.
245      */
246     function _remove(Set storage set, bytes32 value) private returns (bool) {
247         // We read and store the value's index to prevent multiple reads from the same storage slot
248         uint256 valueIndex = set._indexes[value];
249 
250         if (valueIndex != 0) { // Equivalent to contains(set, value)
251             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
252             // the array, and then remove the last element (sometimes called as 'swap and pop').
253             // This modifies the order of the array, as noted in {at}.
254 
255             uint256 toDeleteIndex = valueIndex - 1;
256             uint256 lastIndex = set._values.length - 1;
257 
258             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
259             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
260 
261             bytes32 lastvalue = set._values[lastIndex];
262 
263             // Move the last value to the index where the value to delete is
264             set._values[toDeleteIndex] = lastvalue;
265             // Update the index for the moved value
266             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
267 
268             // Delete the slot where the moved value was stored
269             set._values.pop();
270 
271             // Delete the index for the deleted slot
272             delete set._indexes[value];
273 
274             return true;
275         } else {
276             return false;
277         }
278     }
279 
280     /**
281      * @dev Returns true if the value is in the set. O(1).
282      */
283     function _contains(Set storage set, bytes32 value) private view returns (bool) {
284         return set._indexes[value] != 0;
285     }
286 
287     /**
288      * @dev Returns the number of values on the set. O(1).
289      */
290     function _length(Set storage set) private view returns (uint256) {
291         return set._values.length;
292     }
293 
294    /**
295     * @dev Returns the value stored at position `index` in the set. O(1).
296     *
297     * Note that there are no guarantees on the ordering of values inside the
298     * array, and it may change when more values are added or removed.
299     *
300     * Requirements:
301     *
302     * - `index` must be strictly less than {length}.
303     */
304     function _at(Set storage set, uint256 index) private view returns (bytes32) {
305         require(set._values.length > index, "EnumerableSet: index out of bounds");
306         return set._values[index];
307     }
308 
309     // AddressSet
310 
311     struct AddressSet {
312         Set _inner;
313     }
314 
315     /**
316      * @dev Add a value to a set. O(1).
317      *
318      * Returns true if the value was added to the set, that is if it was not
319      * already present.
320      */
321     function add(AddressSet storage set, address value) internal returns (bool) {
322         return _add(set._inner, bytes32(uint256(value)));
323     }
324 
325     /**
326      * @dev Removes a value from a set. O(1).
327      *
328      * Returns true if the value was removed from the set, that is if it was
329      * present.
330      */
331     function remove(AddressSet storage set, address value) internal returns (bool) {
332         return _remove(set._inner, bytes32(uint256(value)));
333     }
334 
335     /**
336      * @dev Returns true if the value is in the set. O(1).
337      */
338     function contains(AddressSet storage set, address value) internal view returns (bool) {
339         return _contains(set._inner, bytes32(uint256(value)));
340     }
341 
342     /**
343      * @dev Returns the number of values in the set. O(1).
344      */
345     function length(AddressSet storage set) internal view returns (uint256) {
346         return _length(set._inner);
347     }
348 
349    /**
350     * @dev Returns the value stored at position `index` in the set. O(1).
351     *
352     * Note that there are no guarantees on the ordering of values inside the
353     * array, and it may change when more values are added or removed.
354     *
355     * Requirements:
356     *
357     * - `index` must be strictly less than {length}.
358     */
359     function at(AddressSet storage set, uint256 index) internal view returns (address) {
360         return address(uint256(_at(set._inner, index)));
361     }
362 
363 
364     // UintSet
365 
366     struct UintSet {
367         Set _inner;
368     }
369 
370     /**
371      * @dev Add a value to a set. O(1).
372      *
373      * Returns true if the value was added to the set, that is if it was not
374      * already present.
375      */
376     function add(UintSet storage set, uint256 value) internal returns (bool) {
377         return _add(set._inner, bytes32(value));
378     }
379 
380     /**
381      * @dev Removes a value from a set. O(1).
382      *
383      * Returns true if the value was removed from the set, that is if it was
384      * present.
385      */
386     function remove(UintSet storage set, uint256 value) internal returns (bool) {
387         return _remove(set._inner, bytes32(value));
388     }
389 
390     /**
391      * @dev Returns true if the value is in the set. O(1).
392      */
393     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
394         return _contains(set._inner, bytes32(value));
395     }
396 
397     /**
398      * @dev Returns the number of values on the set. O(1).
399      */
400     function length(UintSet storage set) internal view returns (uint256) {
401         return _length(set._inner);
402     }
403 
404    /**
405     * @dev Returns the value stored at position `index` in the set. O(1).
406     *
407     * Note that there are no guarantees on the ordering of values inside the
408     * array, and it may change when more values are added or removed.
409     *
410     * Requirements:
411     *
412     * - `index` must be strictly less than {length}.
413     */
414     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
415         return uint256(_at(set._inner, index));
416     }
417 }
418 
419 /**
420  * @dev Wrappers over Solidity's arithmetic operations with added overflow
421  * checks.
422  *
423  * Arithmetic operations in Solidity wrap on overflow. This can easily result
424  * in bugs, because programmers usually assume that an overflow raises an
425  * error, which is the standard behavior in high level programming languages.
426  * `SafeMath` restores this intuition by reverting the transaction when an
427  * operation overflows.
428  *
429  * Using this library instead of the unchecked operations eliminates an entire
430  * class of bugs, so it's recommended to use it always.
431  */
432  
433 library SafeMath {
434     /**
435      * @dev Returns the addition of two unsigned integers, reverting on
436      * overflow.
437      *
438      * Counterpart to Solidity's `+` operator.
439      *
440      * Requirements:
441      *
442      * - Addition cannot overflow.
443      */
444     function add(uint256 a, uint256 b) internal pure returns (uint256) {
445         uint256 c = a + b;
446         require(c >= a, "SafeMath: addition overflow");
447 
448         return c;
449     }
450 
451     /**
452      * @dev Returns the subtraction of two unsigned integers, reverting on
453      * overflow (when the result is negative).
454      *
455      * Counterpart to Solidity's `-` operator.
456      *
457      * Requirements:
458      *
459      * - Subtraction cannot overflow.
460      */
461     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
462         return sub(a, b, "SafeMath: subtraction overflow");
463     }
464 
465     /**
466      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
467      * overflow (when the result is negative).
468      *
469      * Counterpart to Solidity's `-` operator.
470      *
471      * Requirements:
472      *
473      * - Subtraction cannot overflow.
474      */
475     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
476         require(b <= a, errorMessage);
477         uint256 c = a - b;
478 
479         return c;
480     }
481 
482     /**
483      * @dev Returns the multiplication of two unsigned integers, reverting on
484      * overflow.
485      *
486      * Counterpart to Solidity's `*` operator.
487      *
488      * Requirements:
489      *
490      * - Multiplication cannot overflow.
491      */
492     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
493         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
494         // benefit is lost if 'b' is also tested.
495         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
496         if (a == 0) {
497             return 0;
498         }
499 
500         uint256 c = a * b;
501         require(c / a == b, "SafeMath: multiplication overflow");
502 
503         return c;
504     }
505 
506     /**
507      * @dev Returns the integer division of two unsigned integers. Reverts on
508      * division by zero. The result is rounded towards zero.
509      *
510      * Counterpart to Solidity's `/` operator. Note: this function uses a
511      * `revert` opcode (which leaves remaining gas untouched) while Solidity
512      * uses an invalid opcode to revert (consuming all remaining gas).
513      *
514      * Requirements:
515      *
516      * - The divisor cannot be zero.
517      */
518     function div(uint256 a, uint256 b) internal pure returns (uint256) {
519         return div(a, b, "SafeMath: division by zero");
520     }
521 
522     /**
523      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
524      * division by zero. The result is rounded towards zero.
525      *
526      * Counterpart to Solidity's `/` operator. Note: this function uses a
527      * `revert` opcode (which leaves remaining gas untouched) while Solidity
528      * uses an invalid opcode to revert (consuming all remaining gas).
529      *
530      * Requirements:
531      *
532      * - The divisor cannot be zero.
533      */
534     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
535         require(b > 0, errorMessage);
536         uint256 c = a / b;
537         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
538 
539         return c;
540     }
541 
542     /**
543      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
544      * Reverts when dividing by zero.
545      *
546      * Counterpart to Solidity's `%` operator. This function uses a `revert`
547      * opcode (which leaves remaining gas untouched) while Solidity uses an
548      * invalid opcode to revert (consuming all remaining gas).
549      *
550      * Requirements:
551      *
552      * - The divisor cannot be zero.
553      */
554     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
555         return mod(a, b, "SafeMath: modulo by zero");
556     }
557 
558     /**
559      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
560      * Reverts with custom message when dividing by zero.
561      *
562      * Counterpart to Solidity's `%` operator. This function uses a `revert`
563      * opcode (which leaves remaining gas untouched) while Solidity uses an
564      * invalid opcode to revert (consuming all remaining gas).
565      *
566      * Requirements:
567      *
568      * - The divisor cannot be zero.
569      */
570     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
571         require(b != 0, errorMessage);
572         return a % b;
573     }
574 }
575 
576 // File: @openzeppelin/contracts/utils/Address.sol
577 
578 
579 /**
580  * @dev Collection of functions related to the address type
581  */
582  
583 library Address {
584     /**
585      * @dev Returns true if `account` is a contract.
586      *
587      * [IMPORTANT]
588      * ====
589      * It is unsafe to assume that an address for which this function returns
590      * false is an externally-owned account (EOA) and not a contract.
591      *
592      * Among others, `isContract` will return false for the following
593      * types of addresses:
594      *
595      *  - an externally-owned account
596      *  - a contract in construction
597      *  - an address where a contract will be created
598      *  - an address where a contract lived, but was destroyed
599      * ====
600      */
601     function isContract(address account) internal view returns (bool) {
602         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
603         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
604         // for accounts without code, i.e. `keccak256('')`
605         bytes32 codehash;
606         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
607         // solhint-disable-next-line no-inline-assembly
608         assembly { codehash := extcodehash(account) }
609         return (codehash != accountHash && codehash != 0x0);
610     }
611 
612     /**
613      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
614      * `recipient`, forwarding all available gas and reverting on errors.
615      *
616      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
617      * of certain opcodes, possibly making contracts go over the 2300 gas limit
618      * imposed by `transfer`, making them unable to receive funds via
619      * `transfer`. {sendValue} removes this limitation.
620      *
621      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
622      *
623      * IMPORTANT: because control is transferred to `recipient`, care must be
624      * taken to not create reentrancy vulnerabilities. Consider using
625      * {ReentrancyGuard} or the
626      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
627      */
628     function sendValue(address payable recipient, uint256 amount) internal {
629         require(address(this).balance >= amount, "Address: insufficient balance");
630 
631         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
632         (bool success, ) = recipient.call{ value: amount }("");
633         require(success, "Address: unable to send value, recipient may have reverted");
634     }
635 
636     /**
637      * @dev Performs a Solidity function call using a low level `call`. A
638      * plain`call` is an unsafe replacement for a function call: use this
639      * function instead.
640      *
641      * If `target` reverts with a revert reason, it is bubbled up by this
642      * function (like regular Solidity function calls).
643      *
644      * Returns the raw returned data. To convert to the expected return value,
645      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
646      *
647      * Requirements:
648      *
649      * - `target` must be a contract.
650      * - calling `target` with `data` must not revert.
651      *
652      * _Available since v3.1._
653      */
654     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
655       return functionCall(target, data, "Address: low-level call failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
660      * `errorMessage` as a fallback revert reason when `target` reverts.
661      *
662      * _Available since v3.1._
663      */
664     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
665         return _functionCallWithValue(target, data, 0, errorMessage);
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
670      * but also transferring `value` wei to `target`.
671      *
672      * Requirements:
673      *
674      * - the calling contract must have an ETH balance of at least `value`.
675      * - the called Solidity function must be `payable`.
676      *
677      * _Available since v3.1._
678      */
679     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
680         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
685      * with `errorMessage` as a fallback revert reason when `target` reverts.
686      *
687      * _Available since v3.1._
688      */
689     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
690         require(address(this).balance >= value, "Address: insufficient balance for call");
691         return _functionCallWithValue(target, data, value, errorMessage);
692     }
693 
694     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
695         require(isContract(target), "Address: call to non-contract");
696 
697         // solhint-disable-next-line avoid-low-level-calls
698         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
699         if (success) {
700             return returndata;
701         } else {
702             // Look for revert reason and bubble it up if present
703             if (returndata.length > 0) {
704                 // The easiest way to bubble the revert reason is using memory via assembly
705 
706                 // solhint-disable-next-line no-inline-assembly
707                 assembly {
708                     let returndata_size := mload(returndata)
709                     revert(add(32, returndata), returndata_size)
710                 }
711             } else {
712                 revert(errorMessage);
713             }
714         }
715     }
716 }
717 
718 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
719 
720 /**
721  * @dev Implementation of the {IERC20} interface.
722  *
723  * This implementation is agnostic to the way tokens are created. This means
724  * that a supply mechanism has to be added in a derived contract using {_mint}.
725  * For a generic mechanism see {ERC20PresetMinterPauser}.
726  *
727  * TIP: For a detailed writeup see our guide
728  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
729  * to implement supply mechanisms].
730  *
731  * We have followed general OpenZeppelin guidelines: functions revert instead
732  * of returning `false` on failure. This behavior is nonetheless conventional
733  * and does not conflict with the expectations of ERC20 applications.
734  *
735  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
736  * This allows applications to reconstruct the allowance for all accounts just
737  * by listening to said events. Other implementations of the EIP may not emit
738  * these events, as it isn't required by the specification.
739  *
740  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
741  * functions have been added to mitigate the well-known issues around setting
742  * allowances. See {IERC20-approve}.
743  */
744  
745 contract ERC20 is Context, IERC20 {
746     using SafeMath for uint256;
747     using Address for address;
748 
749     mapping (address => uint256) private _balances;
750 
751     mapping (address => mapping (address => uint256)) private _allowances;
752 
753     uint256 private _totalSupply;
754 
755     string private _name;
756     string private _symbol;
757     uint8 private _decimals;
758 
759     /**
760      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
761      * a default value of 18.
762      *
763      * To select a different value for {decimals}, use {_setupDecimals}.
764      *
765      * All three of these values are immutable: they can only be set once during
766      * construction.
767      */
768     constructor (string memory name, string memory symbol) public {
769         _name = name;
770         _symbol = symbol;
771         _decimals = 18;
772     }
773 
774     /**
775      * @dev Returns the name of the token.
776      */
777     function name() public view returns (string memory) {
778         return _name;
779     }
780 
781     /**
782      * @dev Returns the symbol of the token, usually a shorter version of the
783      * name.
784      */
785     function symbol() public view returns (string memory) {
786         return _symbol;
787     }
788 
789     /**
790      * @dev Returns the number of decimals used to get its user representation.
791      * For example, if `decimals` equals `2`, a balance of `505` tokens should
792      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
793      *
794      * Tokens usually opt for a value of 18, imitating the relationship between
795      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
796      * called.
797      *
798      * NOTE: This information is only used for _display_ purposes: it in
799      * no way affects any of the arithmetic of the contract, including
800      * {IERC20-balanceOf} and {IERC20-transfer}.
801      */
802     function decimals() public view returns (uint8) {
803         return _decimals;
804     }
805 
806     /**
807      * @dev See {IERC20-totalSupply}.
808      */
809     function totalSupply() public view override returns (uint256) {
810         return _totalSupply;
811     }
812 
813     /**
814      * @dev See {IERC20-balanceOf}.
815      */
816     function balanceOf(address account) public view override returns (uint256) {
817         return _balances[account];
818     }
819 
820     /**
821      * @dev See {IERC20-transfer}.
822      *
823      * Requirements:
824      *
825      * - `recipient` cannot be the zero address.
826      * - the caller must have a balance of at least `amount`.
827      */
828     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
829         _transfer(_msgSender(), recipient, amount);
830         return true;
831     }
832 
833     /**
834      * @dev See {IERC20-allowance}.
835      */
836     function allowance(address owner, address spender) public view virtual override returns (uint256) {
837         return _allowances[owner][spender];
838     }
839 
840     /**
841      * @dev See {IERC20-approve}.
842      *
843      * Requirements:
844      *
845      * - `spender` cannot be the zero address.
846      */
847     function approve(address spender, uint256 amount) public virtual override returns (bool) {
848         _approve(_msgSender(), spender, amount);
849         return true;
850     }
851 
852     /**
853      * @dev See {IERC20-transferFrom}.
854      *
855      * Emits an {Approval} event indicating the updated allowance. This is not
856      * required by the EIP. See the note at the beginning of {ERC20};
857      *
858      * Requirements:
859      * - `sender` and `recipient` cannot be the zero address.
860      * - `sender` must have a balance of at least `amount`.
861      * - the caller must have allowance for ``sender``'s tokens of at least
862      * `amount`.
863      */
864     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
865         _transfer(sender, recipient, amount);
866         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
867         return true;
868     }
869 
870     /**
871      * @dev Atomically increases the allowance granted to `spender` by the caller.
872      *
873      * This is an alternative to {approve} that can be used as a mitigation for
874      * problems described in {IERC20-approve}.
875      *
876      * Emits an {Approval} event indicating the updated allowance.
877      *
878      * Requirements:
879      *
880      * - `spender` cannot be the zero address.
881      */
882     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
883         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
884         return true;
885     }
886 
887     /**
888      * @dev Atomically decreases the allowance granted to `spender` by the caller.
889      *
890      * This is an alternative to {approve} that can be used as a mitigation for
891      * problems described in {IERC20-approve}.
892      *
893      * Emits an {Approval} event indicating the updated allowance.
894      *
895      * Requirements:
896      *
897      * - `spender` cannot be the zero address.
898      * - `spender` must have allowance for the caller of at least
899      * `subtractedValue`.
900      */
901     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
902         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
903         return true;
904     }
905 
906     /**
907      * @dev Moves tokens `amount` from `sender` to `recipient`.
908      *
909      * This is internal function is equivalent to {transfer}, and can be used to
910      * e.g. implement automatic token fees, slashing mechanisms, etc.
911      *
912      * Emits a {Transfer} event.
913      *
914      * Requirements:
915      *
916      * - `sender` cannot be the zero address.
917      * - `recipient` cannot be the zero address.
918      * - `sender` must have a balance of at least `amount`.
919      */
920     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
921         require(sender != address(0), "ERC20: transfer from the zero address");
922         require(recipient != address(0), "ERC20: transfer to the zero address");
923 
924         _beforeTokenTransfer(sender, recipient, amount);
925 
926         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
927         _balances[recipient] = _balances[recipient].add(amount);
928         emit Transfer(sender, recipient, amount);
929     }
930 
931     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
932      * the total supply.
933      *
934      * Emits a {Transfer} event with `from` set to the zero address.
935      *
936      * Requirements
937      *
938      * - `to` cannot be the zero address.
939      */
940     function _mint(address account, uint256 amount) internal virtual {
941         require(account != address(0), "ERC20: mint to the zero address");
942 
943         _beforeTokenTransfer(address(0), account, amount);
944 
945         _totalSupply = _totalSupply.add(amount);
946         _balances[account] = _balances[account].add(amount);
947         emit Transfer(address(0), account, amount);
948     }
949 
950     /**
951      * @dev Destroys `amount` tokens from `account`, reducing the
952      * total supply.
953      *
954      * Emits a {Transfer} event with `to` set to the zero address.
955      *
956      * Requirements
957      *
958      * - `account` cannot be the zero address.
959      * - `account` must have at least `amount` tokens.
960      */
961     function _burn(address account, uint256 amount) internal virtual {
962         require(account != address(0), "ERC20: burn from the zero address");
963 
964         _beforeTokenTransfer(account, address(0), amount);
965 
966         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
967         _totalSupply = _totalSupply.sub(amount);
968         emit Transfer(account, address(0), amount);
969     }
970 
971     /**
972      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
973      *
974      * This is internal function is equivalent to `approve`, and can be used to
975      * e.g. set automatic allowances for certain subsystems, etc.
976      *
977      * Emits an {Approval} event.
978      *
979      * Requirements:
980      *
981      * - `owner` cannot be the zero address.
982      * - `spender` cannot be the zero address.
983      */
984     function _approve(address owner, address spender, uint256 amount) internal virtual {
985         require(owner != address(0), "ERC20: approve from the zero address");
986         require(spender != address(0), "ERC20: approve to the zero address");
987 
988         _allowances[owner][spender] = amount;
989         emit Approval(owner, spender, amount);
990     }
991 
992     /**
993      * @dev Sets {decimals} to a value other than the default one of 18.
994      *
995      * WARNING: This function should only be called from the constructor. Most
996      * applications that interact with token contracts will not expect
997      * {decimals} to ever change, and may work incorrectly if it does.
998      */
999     function _setupDecimals(uint8 decimals_) internal {
1000         _decimals = decimals_;
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before any transfer of tokens. This includes
1005      * minting and burning.
1006      *
1007      * Calling conditions:
1008      *
1009      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1010      * will be to transferred to `to`.
1011      * - when `from` is zero, `amount` tokens will be minted for `to`.
1012      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1013      * - `from` and `to` are never both zero.
1014      *
1015      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1016      */
1017     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1018 }
1019 
1020 // File: @openzeppelin/contracts/access/Ownable.sol
1021 
1022 /**
1023  * @dev Contract module which provides a basic access control mechanism, where
1024  * there is an account (an owner) that can be granted exclusive access to
1025  * specific functions.
1026  *
1027  * By default, the owner account will be the one that deploys the contract. This
1028  * can later be changed with {transferOwnership}.
1029  *
1030  * This module is used through inheritance. It will make available the modifier
1031  * `onlyOwner`, which can be applied to your functions to restrict their use to
1032  * the owner.
1033  */
1034 contract Ownable is Context {
1035     address private _owner;
1036 
1037     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1038 
1039     /**
1040      * @dev Initializes the contract setting the deployer as the initial owner.
1041      */
1042     constructor () internal {
1043         address msgSender = _msgSender();
1044         _owner = msgSender;
1045         emit OwnershipTransferred(address(0), msgSender);
1046     }
1047 
1048     /**
1049      * @dev Returns the address of the current owner.
1050      */
1051     function owner() public view returns (address) {
1052         return _owner;
1053     }
1054 
1055     /**
1056      * @dev Throws if called by any account other than the owner.
1057      */
1058     modifier onlyOwner() {
1059         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1060         _;
1061     }
1062 
1063     /**
1064      * @dev Leaves the contract without owner. It will not be possible to call
1065      * `onlyOwner` functions anymore. Can only be called by the current owner.
1066      *
1067      * NOTE: Renouncing ownership will leave the contract without an owner,
1068      * thereby removing any functionality that is only available to the owner.
1069      */
1070     function renounceOwnership() public virtual onlyOwner {
1071         emit OwnershipTransferred(_owner, address(0));
1072         _owner = address(0);
1073     }
1074 
1075     /**
1076      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1077      * Can only be called by the current owner.
1078      */
1079     function transferOwnership(address newOwner) public virtual onlyOwner {
1080         require(newOwner != address(0), "Ownable: new owner is the zero address");
1081         emit OwnershipTransferred(_owner, newOwner);
1082         _owner = newOwner;
1083     }
1084 }
1085 
1086 // File: contracts/SojuToken.sol
1087 
1088 // SojuToken with Governance.
1089 contract SojuToken is ERC20("SojuToken", "Soju"), Ownable {
1090     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1091     function mint(address _to, uint256 _amount) public onlyOwner {
1092         _mint(_to, _amount);
1093         _moveDelegates(address(0), _delegates[_to], _amount);
1094     }
1095 
1096     // Copied and modified from YAM code:
1097     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1098     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1099     // Which is copied and modified from COMPOUND:
1100     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1101 
1102     mapping (address => address) internal _delegates;
1103 
1104     /// @notice A checkpoint for marking number of votes from a given block
1105     struct Checkpoint {
1106         uint32 fromBlock;
1107         uint256 votes;
1108     }
1109 
1110     /// @notice A record of votes checkpoints for each account, by index
1111     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1112 
1113     /// @notice The number of checkpoints for each account
1114     mapping (address => uint32) public numCheckpoints;
1115 
1116     /// @notice The EIP-712 typehash for the contract's domain
1117     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1118 
1119     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1120     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1121 
1122     /// @notice A record of states for signing / validating signatures
1123     mapping (address => uint) public nonces;
1124 
1125       /// @notice An event thats emitted when an account changes its delegate
1126     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1127 
1128     /// @notice An event thats emitted when a delegate account's vote balance changes
1129     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1130 
1131     /**
1132      * @notice Delegate votes from `msg.sender` to `delegatee`
1133      * @param delegator The address to get delegatee for
1134      */
1135     function delegates(address delegator)
1136         external
1137         view
1138         returns (address)
1139     {
1140         return _delegates[delegator];
1141     }
1142 
1143    /**
1144     * @notice Delegate votes from `msg.sender` to `delegatee`
1145     * @param delegatee The address to delegate votes to
1146     */
1147     function delegate(address delegatee) external {
1148         return _delegate(msg.sender, delegatee);
1149     }
1150 
1151     /**
1152      * @notice Delegates votes from signatory to `delegatee`
1153      * @param delegatee The address to delegate votes to
1154      * @param nonce The contract state required to match the signature
1155      * @param expiry The time at which to expire the signature
1156      * @param v The recovery byte of the signature
1157      * @param r Half of the ECDSA signature pair
1158      * @param s Half of the ECDSA signature pair
1159      */
1160     function delegateBySig(
1161         address delegatee,
1162         uint nonce,
1163         uint expiry,
1164         uint8 v,
1165         bytes32 r,
1166         bytes32 s
1167     )
1168         external
1169     {
1170         bytes32 domainSeparator = keccak256(
1171             abi.encode(
1172                 DOMAIN_TYPEHASH,
1173                 keccak256(bytes(name())),
1174                 getChainId(),
1175                 address(this)
1176             )
1177         );
1178 
1179         bytes32 structHash = keccak256(
1180             abi.encode(
1181                 DELEGATION_TYPEHASH,
1182                 delegatee,
1183                 nonce,
1184                 expiry
1185             )
1186         );
1187 
1188         bytes32 digest = keccak256(
1189             abi.encodePacked(
1190                 "\x19\x01",
1191                 domainSeparator,
1192                 structHash
1193             )
1194         );
1195 
1196         address signatory = ecrecover(digest, v, r, s);
1197         require(signatory != address(0), "Soju::delegateBySig: invalid signature");
1198         require(nonce == nonces[signatory]++, "Soju::delegateBySig: invalid nonce");
1199         require(now <= expiry, "Soju::delegateBySig: signature expired");
1200         return _delegate(signatory, delegatee);
1201     }
1202 
1203     /**
1204      * @notice Gets the current votes balance for `account`
1205      * @param account The address to get votes balance
1206      * @return The number of current votes for `account`
1207      */
1208     function getCurrentVotes(address account)
1209         external
1210         view
1211         returns (uint256)
1212     {
1213         uint32 nCheckpoints = numCheckpoints[account];
1214         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1215     }
1216 
1217     /**
1218      * @notice Determine the prior number of votes for an account as of a block number
1219      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1220      * @param account The address of the account to check
1221      * @param blockNumber The block number to get the vote balance at
1222      * @return The number of votes the account had as of the given block
1223      */
1224     function getPriorVotes(address account, uint blockNumber)
1225         external
1226         view
1227         returns (uint256)
1228     {
1229         require(blockNumber < block.number, "Soju::getPriorVotes: not yet determined");
1230 
1231         uint32 nCheckpoints = numCheckpoints[account];
1232         if (nCheckpoints == 0) {
1233             return 0;
1234         }
1235 
1236         // First check most recent balance
1237         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1238             return checkpoints[account][nCheckpoints - 1].votes;
1239         }
1240 
1241         // Next check implicit zero balance
1242         if (checkpoints[account][0].fromBlock > blockNumber) {
1243             return 0;
1244         }
1245 
1246         uint32 lower = 0;
1247         uint32 upper = nCheckpoints - 1;
1248         while (upper > lower) {
1249             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1250             Checkpoint memory cp = checkpoints[account][center];
1251             if (cp.fromBlock == blockNumber) {
1252                 return cp.votes;
1253             } else if (cp.fromBlock < blockNumber) {
1254                 lower = center;
1255             } else {
1256                 upper = center - 1;
1257             }
1258         }
1259         return checkpoints[account][lower].votes;
1260     }
1261 
1262     function _delegate(address delegator, address delegatee)
1263         internal
1264     {
1265         address currentDelegate = _delegates[delegator];
1266         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying Sojus (not scaled);
1267         _delegates[delegator] = delegatee;
1268 
1269         emit DelegateChanged(delegator, currentDelegate, delegatee);
1270 
1271         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1272     }
1273 
1274     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1275         if (srcRep != dstRep && amount > 0) {
1276             if (srcRep != address(0)) {
1277                 // decrease old representative
1278                 uint32 srcRepNum = numCheckpoints[srcRep];
1279                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1280                 uint256 srcRepNew = srcRepOld.sub(amount);
1281                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1282             }
1283 
1284             if (dstRep != address(0)) {
1285                 // increase new representative
1286                 uint32 dstRepNum = numCheckpoints[dstRep];
1287                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1288                 uint256 dstRepNew = dstRepOld.add(amount);
1289                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1290             }
1291         }
1292     }
1293 
1294     function _writeCheckpoint(
1295         address delegatee,
1296         uint32 nCheckpoints,
1297         uint256 oldVotes,
1298         uint256 newVotes
1299     )
1300         internal
1301     {
1302         uint32 blockNumber = safe32(block.number, "Soju::_writeCheckpoint: block number exceeds 32 bits");
1303 
1304         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1305             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1306         } else {
1307             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1308             numCheckpoints[delegatee] = nCheckpoints + 1;
1309         }
1310 
1311         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1312     }
1313 
1314     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1315         require(n < 2**32, errorMessage);
1316         return uint32(n);
1317     }
1318 
1319     function getChainId() internal pure returns (uint) {
1320         uint256 chainId;
1321         assembly { chainId := chainid() }
1322         return chainId;
1323     }
1324 }
1325 
1326 
1327 interface IMigratorChef {
1328     function migrate(IERC20 token) external returns (IERC20);
1329 }
1330 
1331 contract Bartender is Ownable {
1332     using SafeMath for uint256;
1333     using SafeERC20 for IERC20;
1334 
1335     struct Alcoholic {
1336         uint256 amount;
1337         uint256 rewardDebt;
1338     }
1339 
1340     struct PoolInfo {
1341         IERC20 lpToken;
1342         uint256 allocPoint;
1343         uint lastRewardBlock;
1344         uint256 accSojuPerShare;
1345     }
1346 
1347     SojuToken public soju;
1348     address public devaddr;
1349     uint256 public sojuPerBlock = 1719 * 1000000000000000000;
1350     uint256 public sojuMax = 3614025000 * 1000000000000000000;
1351     IMigratorChef public migrator;
1352 
1353     PoolInfo[] public poolInfo;
1354     mapping(uint256 => mapping(address => Alcoholic)) public alcoholics;
1355     uint256 public totalAllocPoint = 0;
1356 
1357     event Deposit(address indexed alcoholic, uint256 indexed pid, uint256 amount);
1358     event Withdraw(address indexed alcoholic, uint256 indexed pid, uint256 amount);
1359     event EmergencyWithdraw(
1360         address indexed alcoholic,
1361         uint256 indexed pid,
1362         uint256 amount
1363     );
1364 
1365     constructor(
1366         SojuToken _soju,
1367         address _devaddr
1368     ) public {
1369         soju = _soju;
1370         devaddr = _devaddr;
1371     }
1372 
1373     function poolLength() external view returns (uint256) {
1374         return poolInfo.length;
1375     }
1376 
1377     function add(
1378         uint256 _allocPoint,
1379         IERC20 _lpToken,
1380         bool _withUpdate
1381     ) public onlyOwner {
1382         if (_withUpdate) {
1383             massUpdatePools();
1384         }
1385         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1386         poolInfo.push(
1387             PoolInfo({
1388                 lpToken: _lpToken,
1389                 allocPoint: _allocPoint,
1390                 lastRewardBlock: block.number,
1391                 accSojuPerShare: 0
1392             })
1393         );
1394     }
1395 
1396     function set(
1397         uint256 _pid,
1398         uint256 _allocPoint,
1399         bool _withUpdate
1400     ) public onlyOwner {
1401         if (_withUpdate) {
1402             massUpdatePools();
1403         }
1404         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1405             _allocPoint
1406         );
1407         poolInfo[_pid].allocPoint = _allocPoint;
1408     }
1409 
1410     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1411         migrator = _migrator;
1412     }
1413 
1414     function migrate(uint256 _pid) public {
1415         require(address(migrator) != address(0), "migrate: no migrator");
1416         PoolInfo storage pool = poolInfo[_pid];
1417         IERC20 lpToken = pool.lpToken;
1418         uint256 bal = lpToken.balanceOf(address(this));
1419         lpToken.safeApprove(address(migrator), bal);
1420         IERC20 newLpToken = migrator.migrate(lpToken);
1421         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1422         pool.lpToken = newLpToken;
1423     }
1424 
1425     function pendingSoju(uint256 _pid, address _alcoholic)
1426         external
1427         view
1428         returns (uint256)
1429     {
1430         PoolInfo storage pool = poolInfo[_pid];
1431         Alcoholic storage alcoholic = alcoholics[_pid][_alcoholic];
1432         uint256 accSojuPerShare = pool.accSojuPerShare;
1433         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1434         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1435             uint256 sojuReward = block.number
1436                 .sub(pool.lastRewardBlock)
1437                 .mul(sojuPerBlock)
1438                 .mul(pool.allocPoint)
1439                 .div(totalAllocPoint);
1440             accSojuPerShare = accSojuPerShare.add(
1441                 sojuReward.mul(1e12).div(lpSupply)
1442             );
1443         }
1444         return alcoholic.amount.mul(accSojuPerShare).div(1e12).sub(alcoholic.rewardDebt);
1445     }
1446 
1447     function massUpdatePools() public {
1448         uint256 length = poolInfo.length;
1449         for (uint256 pid = 0; pid < length; ++pid) {
1450             updatePool(pid);
1451         }
1452     }
1453 
1454     function updatePool(uint256 _pid) public {
1455         PoolInfo storage pool = poolInfo[_pid];
1456         if (block.number <= pool.lastRewardBlock) {
1457             return;
1458         }
1459         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1460         if (lpSupply == 0) {
1461             pool.lastRewardBlock = block.number;
1462             return;
1463         }
1464 
1465         uint256 sojuReward = block.number.sub(pool.lastRewardBlock)
1466             .mul(sojuPerBlock)
1467             .mul(pool.allocPoint)
1468             .div(totalAllocPoint);
1469 
1470         if(soju.totalSupply() >= sojuMax){ return; }
1471 
1472         soju.mint(devaddr, sojuReward.div(14));
1473         soju.mint(address(this), sojuReward);
1474 
1475         pool.accSojuPerShare = pool.accSojuPerShare.add(
1476             sojuReward.mul(1e12).div(lpSupply)
1477         );
1478         pool.lastRewardBlock = block.number;
1479     }
1480 
1481     function deposit(uint256 _pid, uint256 _amount) public {
1482         PoolInfo storage pool = poolInfo[_pid];
1483         Alcoholic storage alcoholic = alcoholics[_pid][msg.sender];
1484         updatePool(_pid);
1485         if (alcoholic.amount > 0) {
1486             uint256 pending = alcoholic
1487                 .amount
1488                 .mul(pool.accSojuPerShare)
1489                 .div(1e12)
1490                 .sub(alcoholic.rewardDebt);
1491             safeSojuTransfer(msg.sender, pending);
1492         }
1493         pool.lpToken.safeTransferFrom(
1494             address(msg.sender),
1495             address(this),
1496             _amount
1497         );
1498         alcoholic.amount = alcoholic.amount.add(_amount);
1499         alcoholic.rewardDebt = alcoholic.amount.mul(pool.accSojuPerShare).div(1e12);
1500         emit Deposit(msg.sender, _pid, _amount);
1501     }
1502 
1503     function withdraw(uint256 _pid, uint256 _amount) public {
1504         PoolInfo storage pool = poolInfo[_pid];
1505         Alcoholic storage alcoholic = alcoholics[_pid][msg.sender];
1506         require(alcoholic.amount >= _amount, "withdraw: not good");
1507         updatePool(_pid);
1508         uint256 pending = alcoholic.amount.mul(pool.accSojuPerShare).div(1e12).sub(
1509             alcoholic.rewardDebt
1510         );
1511         safeSojuTransfer(msg.sender, pending);
1512         alcoholic.amount = alcoholic.amount.sub(_amount);
1513         alcoholic.rewardDebt = alcoholic.amount.mul(pool.accSojuPerShare).div(1e12);
1514         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1515         emit Withdraw(msg.sender, _pid, _amount);
1516     }
1517 
1518     function emergencyWithdraw(uint256 _pid) public {
1519         PoolInfo storage pool = poolInfo[_pid];
1520         Alcoholic storage alcoholic = alcoholics[_pid][msg.sender];
1521         pool.lpToken.safeTransfer(address(msg.sender), alcoholic.amount);
1522         emit EmergencyWithdraw(msg.sender, _pid, alcoholic.amount);
1523         alcoholic.amount = 0;
1524         alcoholic.rewardDebt = 0;
1525     }
1526 
1527     function safeSojuTransfer(address _to, uint256 _amount) internal {
1528         uint256 sojuBal = soju.balanceOf(address(this));
1529         if (_amount > sojuBal) {
1530             soju.transfer(_to, sojuBal);
1531         } else {
1532             soju.transfer(_to, _amount);
1533         }
1534     }
1535 
1536     function dev(address _devaddr) public {
1537         require(msg.sender == devaddr, "dev: wut?");
1538         devaddr = _devaddr;
1539     }
1540 }