1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @title SafeERC20
6  * @dev Wrappers around ERC20 operations that throw on failure (when the token
7  * contract returns false). Tokens that return no value (and instead revert or
8  * throw on failure) are also supported, non-reverting calls are assumed to be
9  * successful.
10  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
11  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
12  */
13 library SafeERC20 {
14     using SafeMath for uint256;
15     using Address for address;
16 
17     function safeTransfer(IERC20 token, address to, uint256 value) internal {
18         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
19     }
20 
21     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
22         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
23     }
24 
25     /**
26      * @dev Deprecated. This function has issues similar to the ones found in
27      * {IERC20-approve}, and its usage is discouraged.
28      *
29      * Whenever possible, use {safeIncreaseAllowance} and
30      * {safeDecreaseAllowance} instead.
31      */
32     function safeApprove(IERC20 token, address spender, uint256 value) internal {
33         // safeApprove should only be called when setting an initial allowance,
34         // or when resetting it to zero. To increase and decrease it, use
35         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
36         // solhint-disable-next-line max-line-length
37         require((value == 0) || (token.allowance(address(this), spender) == 0),
38             "SafeERC20: approve from non-zero to non-zero allowance"
39         );
40         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
41     }
42 
43     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
44         uint256 newAllowance = token.allowance(address(this), spender).add(value);
45         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
46     }
47 
48     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
49         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
50         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
51     }
52 
53     /**
54      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
55      * on the return value: the return value is optional (but if data is returned, it must not be false).
56      * @param token The token targeted by the call.
57      * @param data The call data (encoded using abi.encode or one of its variants).
58      */
59     function _callOptionalReturn(IERC20 token, bytes memory data) private {
60         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
61         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
62         // the target address contains contract code and also asserts for success in the low-level call.
63 
64         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
65         if (returndata.length > 0) { // Return data is optional
66             // solhint-disable-next-line max-line-length
67             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
68         }
69     }
70 }
71 
72 
73 pragma solidity ^0.6.0;
74 
75 /**
76  * @dev Library for managing
77  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
78  * types.
79  *
80  * Sets have the following properties:
81  *
82  * - Elements are added, removed, and checked for existence in constant time
83  * (O(1)).
84  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
85  *
86  * ```
87  * contract Example {
88  *     // Add the library methods
89  *     using EnumerableSet for EnumerableSet.AddressSet;
90  *
91  *     // Declare a set state variable
92  *     EnumerableSet.AddressSet private mySet;
93  * }
94  * ```
95  *
96  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
97  * (`UintSet`) are supported.
98  */
99 library EnumerableSet {
100     // To implement this library for multiple types with as little code
101     // repetition as possible, we write it in terms of a generic Set type with
102     // bytes32 values.
103     // The Set implementation uses private functions, and user-facing
104     // implementations (such as AddressSet) are just wrappers around the
105     // underlying Set.
106     // This means that we can only create new EnumerableSets for types that fit
107     // in bytes32.
108 
109     struct Set {
110         // Storage of set values
111         bytes32[] _values;
112 
113         // Position of the value in the `values` array, plus 1 because index 0
114         // means a value is not in the set.
115         mapping (bytes32 => uint256) _indexes;
116     }
117 
118     /**
119      * @dev Add a value to a set. O(1).
120      *
121      * Returns true if the value was added to the set, that is if it was not
122      * already present.
123      */
124     function _add(Set storage set, bytes32 value) private returns (bool) {
125         if (!_contains(set, value)) {
126             set._values.push(value);
127             // The value is stored at length-1, but we add 1 to all indexes
128             // and use 0 as a sentinel value
129             set._indexes[value] = set._values.length;
130             return true;
131         } else {
132             return false;
133         }
134     }
135 
136     /**
137      * @dev Removes a value from a set. O(1).
138      *
139      * Returns true if the value was removed from the set, that is if it was
140      * present.
141      */
142     function _remove(Set storage set, bytes32 value) private returns (bool) {
143         // We read and store the value's index to prevent multiple reads from the same storage slot
144         uint256 valueIndex = set._indexes[value];
145 
146         if (valueIndex != 0) { // Equivalent to contains(set, value)
147             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
148             // the array, and then remove the last element (sometimes called as 'swap and pop').
149             // This modifies the order of the array, as noted in {at}.
150 
151             uint256 toDeleteIndex = valueIndex - 1;
152             uint256 lastIndex = set._values.length - 1;
153 
154             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
155             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
156 
157             bytes32 lastvalue = set._values[lastIndex];
158 
159             // Move the last value to the index where the value to delete is
160             set._values[toDeleteIndex] = lastvalue;
161             // Update the index for the moved value
162             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
163 
164             // Delete the slot where the moved value was stored
165             set._values.pop();
166 
167             // Delete the index for the deleted slot
168             delete set._indexes[value];
169 
170             return true;
171         } else {
172             return false;
173         }
174     }
175 
176     /**
177      * @dev Returns true if the value is in the set. O(1).
178      */
179     function _contains(Set storage set, bytes32 value) private view returns (bool) {
180         return set._indexes[value] != 0;
181     }
182 
183     /**
184      * @dev Returns the number of values on the set. O(1).
185      */
186     function _length(Set storage set) private view returns (uint256) {
187         return set._values.length;
188     }
189 
190    /**
191     * @dev Returns the value stored at position `index` in the set. O(1).
192     *
193     * Note that there are no guarantees on the ordering of values inside the
194     * array, and it may change when more values are added or removed.
195     *
196     * Requirements:
197     *
198     * - `index` must be strictly less than {length}.
199     */
200     function _at(Set storage set, uint256 index) private view returns (bytes32) {
201         require(set._values.length > index, "EnumerableSet: index out of bounds");
202         return set._values[index];
203     }
204 
205     // AddressSet
206 
207     struct AddressSet {
208         Set _inner;
209     }
210 
211     /**
212      * @dev Add a value to a set. O(1).
213      *
214      * Returns true if the value was added to the set, that is if it was not
215      * already present.
216      */
217     function add(AddressSet storage set, address value) internal returns (bool) {
218         return _add(set._inner, bytes32(uint256(value)));
219     }
220 
221     /**
222      * @dev Removes a value from a set. O(1).
223      *
224      * Returns true if the value was removed from the set, that is if it was
225      * present.
226      */
227     function remove(AddressSet storage set, address value) internal returns (bool) {
228         return _remove(set._inner, bytes32(uint256(value)));
229     }
230 
231     /**
232      * @dev Returns true if the value is in the set. O(1).
233      */
234     function contains(AddressSet storage set, address value) internal view returns (bool) {
235         return _contains(set._inner, bytes32(uint256(value)));
236     }
237 
238     /**
239      * @dev Returns the number of values in the set. O(1).
240      */
241     function length(AddressSet storage set) internal view returns (uint256) {
242         return _length(set._inner);
243     }
244 
245    /**
246     * @dev Returns the value stored at position `index` in the set. O(1).
247     *
248     * Note that there are no guarantees on the ordering of values inside the
249     * array, and it may change when more values are added or removed.
250     *
251     * Requirements:
252     *
253     * - `index` must be strictly less than {length}.
254     */
255     function at(AddressSet storage set, uint256 index) internal view returns (address) {
256         return address(uint256(_at(set._inner, index)));
257     }
258 
259 
260     // UintSet
261 
262     struct UintSet {
263         Set _inner;
264     }
265 
266     /**
267      * @dev Add a value to a set. O(1).
268      *
269      * Returns true if the value was added to the set, that is if it was not
270      * already present.
271      */
272     function add(UintSet storage set, uint256 value) internal returns (bool) {
273         return _add(set._inner, bytes32(value));
274     }
275 
276     /**
277      * @dev Removes a value from a set. O(1).
278      *
279      * Returns true if the value was removed from the set, that is if it was
280      * present.
281      */
282     function remove(UintSet storage set, uint256 value) internal returns (bool) {
283         return _remove(set._inner, bytes32(value));
284     }
285 
286     /**
287      * @dev Returns true if the value is in the set. O(1).
288      */
289     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
290         return _contains(set._inner, bytes32(value));
291     }
292 
293     /**
294      * @dev Returns the number of values on the set. O(1).
295      */
296     function length(UintSet storage set) internal view returns (uint256) {
297         return _length(set._inner);
298     }
299 
300    /**
301     * @dev Returns the value stored at position `index` in the set. O(1).
302     *
303     * Note that there are no guarantees on the ordering of values inside the
304     * array, and it may change when more values are added or removed.
305     *
306     * Requirements:
307     *
308     * - `index` must be strictly less than {length}.
309     */
310     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
311         return uint256(_at(set._inner, index));
312     }
313 }
314 
315 
316 pragma solidity ^0.6.12;
317 
318 
319 interface IMigratorChef {
320     function migrate(IERC20 token) external returns (IERC20);
321 }
322 
323 
324 // ***************************************************************
325 
326 /**
327  *Submitted for verification at Etherscan.io on 2020-08-26
328 */
329 
330 // File: @openzeppelin/contracts/GSN/Context.sol
331 
332 
333 pragma solidity ^0.6.0;
334 
335 /*
336  * @dev Provides information about the current execution context, including the
337  * sender of the transaction and its data. While these are generally available
338  * via msg.sender and msg.data, they should not be accessed in such a direct
339  * manner, since when dealing with GSN meta-transactions the account sending and
340  * paying for execution may not be the actual sender (as far as an application
341  * is concerned).
342  *
343  * This contract is only required for intermediate, library-like contracts.
344  */
345 abstract contract Context {
346     function _msgSender() internal view virtual returns (address payable) {
347         return msg.sender;
348     }
349 
350     function _msgData() internal view virtual returns (bytes memory) {
351         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
352         return msg.data;
353     }
354 }
355 
356 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
357 
358 
359 
360 pragma solidity ^0.6.0;
361 
362 /**
363  * @dev Interface of the ERC20 standard as defined in the EIP.
364  */
365 interface IERC20 {
366     /**
367      * @dev Returns the amount of tokens in existence.
368      */
369     function totalSupply() external view returns (uint256);
370 
371     /**
372      * @dev Returns the amount of tokens owned by `account`.
373      */
374     function balanceOf(address account) external view returns (uint256);
375 
376     /**
377      * @dev Moves `amount` tokens from the caller's account to `recipient`.
378      *
379      * Returns a boolean value indicating whether the operation succeeded.
380      *
381      * Emits a {Transfer} event.
382      */
383     function transfer(address recipient, uint256 amount) external returns (bool);
384 
385     /**
386      * @dev Returns the remaining number of tokens that `spender` will be
387      * allowed to spend on behalf of `owner` through {transferFrom}. This is
388      * zero by default.
389      *
390      * This value changes when {approve} or {transferFrom} are called.
391      */
392     function allowance(address owner, address spender) external view returns (uint256);
393 
394     /**
395      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
396      *
397      * Returns a boolean value indicating whether the operation succeeded.
398      *
399      * IMPORTANT: Beware that changing an allowance with this method brings the risk
400      * that someone may use both the old and the new allowance by unfortunate
401      * transaction ordering. One possible solution to mitigate this race
402      * condition is to first reduce the spender's allowance to 0 and set the
403      * desired value afterwards:
404      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
405      *
406      * Emits an {Approval} event.
407      */
408     function approve(address spender, uint256 amount) external returns (bool);
409 
410     /**
411      * @dev Moves `amount` tokens from `sender` to `recipient` using the
412      * allowance mechanism. `amount` is then deducted from the caller's
413      * allowance.
414      *
415      * Returns a boolean value indicating whether the operation succeeded.
416      *
417      * Emits a {Transfer} event.
418      */
419     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
420 
421     /**
422      * @dev Emitted when `value` tokens are moved from one account (`from`) to
423      * another (`to`).
424      *
425      * Note that `value` may be zero.
426      */
427     event Transfer(address indexed from, address indexed to, uint256 value);
428 
429     /**
430      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
431      * a call to {approve}. `value` is the new allowance.
432      */
433     event Approval(address indexed owner, address indexed spender, uint256 value);
434 }
435 
436 // File: @openzeppelin/contracts/math/SafeMath.sol
437 
438 
439 
440 pragma solidity ^0.6.0;
441 
442 /**
443  * @dev Wrappers over Solidity's arithmetic operations with added overflow
444  * checks.
445  *
446  * Arithmetic operations in Solidity wrap on overflow. This can easily result
447  * in bugs, because programmers usually assume that an overflow raises an
448  * error, which is the standard behavior in high level programming languages.
449  * `SafeMath` restores this intuition by reverting the transaction when an
450  * operation overflows.
451  *
452  * Using this library instead of the unchecked operations eliminates an entire
453  * class of bugs, so it's recommended to use it always.
454  */
455 library SafeMath {
456     /**
457      * @dev Returns the addition of two unsigned integers, reverting on
458      * overflow.
459      *
460      * Counterpart to Solidity's `+` operator.
461      *
462      * Requirements:
463      *
464      * - Addition cannot overflow.
465      */
466     function add(uint256 a, uint256 b) internal pure returns (uint256) {
467         uint256 c = a + b;
468         require(c >= a, "SafeMath: addition overflow");
469 
470         return c;
471     }
472 
473     /**
474      * @dev Returns the subtraction of two unsigned integers, reverting on
475      * overflow (when the result is negative).
476      *
477      * Counterpart to Solidity's `-` operator.
478      *
479      * Requirements:
480      *
481      * - Subtraction cannot overflow.
482      */
483     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
484         return sub(a, b, "SafeMath: subtraction overflow");
485     }
486 
487     /**
488      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
489      * overflow (when the result is negative).
490      *
491      * Counterpart to Solidity's `-` operator.
492      *
493      * Requirements:
494      *
495      * - Subtraction cannot overflow.
496      */
497     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
498         require(b <= a, errorMessage);
499         uint256 c = a - b;
500 
501         return c;
502     }
503 
504     /**
505      * @dev Returns the multiplication of two unsigned integers, reverting on
506      * overflow.
507      *
508      * Counterpart to Solidity's `*` operator.
509      *
510      * Requirements:
511      *
512      * - Multiplication cannot overflow.
513      */
514     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
515         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
516         // benefit is lost if 'b' is also tested.
517         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
518         if (a == 0) {
519             return 0;
520         }
521 
522         uint256 c = a * b;
523         require(c / a == b, "SafeMath: multiplication overflow");
524 
525         return c;
526     }
527 
528     /**
529      * @dev Returns the integer division of two unsigned integers. Reverts on
530      * division by zero. The result is rounded towards zero.
531      *
532      * Counterpart to Solidity's `/` operator. Note: this function uses a
533      * `revert` opcode (which leaves remaining gas untouched) while Solidity
534      * uses an invalid opcode to revert (consuming all remaining gas).
535      *
536      * Requirements:
537      *
538      * - The divisor cannot be zero.
539      */
540     function div(uint256 a, uint256 b) internal pure returns (uint256) {
541         return div(a, b, "SafeMath: division by zero");
542     }
543 
544     /**
545      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
546      * division by zero. The result is rounded towards zero.
547      *
548      * Counterpart to Solidity's `/` operator. Note: this function uses a
549      * `revert` opcode (which leaves remaining gas untouched) while Solidity
550      * uses an invalid opcode to revert (consuming all remaining gas).
551      *
552      * Requirements:
553      *
554      * - The divisor cannot be zero.
555      */
556     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
557         require(b > 0, errorMessage);
558         uint256 c = a / b;
559         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
560 
561         return c;
562     }
563 
564     /**
565      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
566      * Reverts when dividing by zero.
567      *
568      * Counterpart to Solidity's `%` operator. This function uses a `revert`
569      * opcode (which leaves remaining gas untouched) while Solidity uses an
570      * invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      *
574      * - The divisor cannot be zero.
575      */
576     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
577         return mod(a, b, "SafeMath: modulo by zero");
578     }
579 
580     /**
581      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
582      * Reverts with custom message when dividing by zero.
583      *
584      * Counterpart to Solidity's `%` operator. This function uses a `revert`
585      * opcode (which leaves remaining gas untouched) while Solidity uses an
586      * invalid opcode to revert (consuming all remaining gas).
587      *
588      * Requirements:
589      *
590      * - The divisor cannot be zero.
591      */
592     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
593         require(b != 0, errorMessage);
594         return a % b;
595     }
596 }
597 
598 // File: @openzeppelin/contracts/utils/Address.sol
599 
600 
601 
602 pragma solidity ^0.6.2;
603 
604 /**
605  * @dev Collection of functions related to the address type
606  */
607 library Address {
608     /**
609      * @dev Returns true if `account` is a contract.
610      *
611      * [IMPORTANT]
612      * ====
613      * It is unsafe to assume that an address for which this function returns
614      * false is an externally-owned account (EOA) and not a contract.
615      *
616      * Among others, `isContract` will return false for the following
617      * types of addresses:
618      *
619      *  - an externally-owned account
620      *  - a contract in construction
621      *  - an address where a contract will be created
622      *  - an address where a contract lived, but was destroyed
623      * ====
624      */
625     function isContract(address account) internal view returns (bool) {
626         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
627         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
628         // for accounts without code, i.e. `keccak256('')`
629         bytes32 codehash;
630         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
631         // solhint-disable-next-line no-inline-assembly
632         assembly { codehash := extcodehash(account) }
633         return (codehash != accountHash && codehash != 0x0);
634     }
635 
636     /**
637      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
638      * `recipient`, forwarding all available gas and reverting on errors.
639      *
640      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
641      * of certain opcodes, possibly making contracts go over the 2300 gas limit
642      * imposed by `transfer`, making them unable to receive funds via
643      * `transfer`. {sendValue} removes this limitation.
644      *
645      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
646      *
647      * IMPORTANT: because control is transferred to `recipient`, care must be
648      * taken to not create reentrancy vulnerabilities. Consider using
649      * {ReentrancyGuard} or the
650      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
651      */
652     function sendValue(address payable recipient, uint256 amount) internal {
653         require(address(this).balance >= amount, "Address: insufficient balance");
654 
655         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
656         (bool success, ) = recipient.call{ value: amount }("");
657         require(success, "Address: unable to send value, recipient may have reverted");
658     }
659 
660     /**
661      * @dev Performs a Solidity function call using a low level `call`. A
662      * plain`call` is an unsafe replacement for a function call: use this
663      * function instead.
664      *
665      * If `target` reverts with a revert reason, it is bubbled up by this
666      * function (like regular Solidity function calls).
667      *
668      * Returns the raw returned data. To convert to the expected return value,
669      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
670      *
671      * Requirements:
672      *
673      * - `target` must be a contract.
674      * - calling `target` with `data` must not revert.
675      *
676      * _Available since v3.1._
677      */
678     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
679       return functionCall(target, data, "Address: low-level call failed");
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
684      * `errorMessage` as a fallback revert reason when `target` reverts.
685      *
686      * _Available since v3.1._
687      */
688     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
689         return _functionCallWithValue(target, data, 0, errorMessage);
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
694      * but also transferring `value` wei to `target`.
695      *
696      * Requirements:
697      *
698      * - the calling contract must have an ETH balance of at least `value`.
699      * - the called Solidity function must be `payable`.
700      *
701      * _Available since v3.1._
702      */
703     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
704         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
709      * with `errorMessage` as a fallback revert reason when `target` reverts.
710      *
711      * _Available since v3.1._
712      */
713     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
714         require(address(this).balance >= value, "Address: insufficient balance for call");
715         return _functionCallWithValue(target, data, value, errorMessage);
716     }
717 
718     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
719         require(isContract(target), "Address: call to non-contract");
720 
721         // solhint-disable-next-line avoid-low-level-calls
722         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
723         if (success) {
724             return returndata;
725         } else {
726             // Look for revert reason and bubble it up if present
727             if (returndata.length > 0) {
728                 // The easiest way to bubble the revert reason is using memory via assembly
729 
730                 // solhint-disable-next-line no-inline-assembly
731                 assembly {
732                     let returndata_size := mload(returndata)
733                     revert(add(32, returndata), returndata_size)
734                 }
735             } else {
736                 revert(errorMessage);
737             }
738         }
739     }
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
743 
744 
745 
746 pragma solidity ^0.6.0;
747 
748 
749 
750 
751 
752 /**
753  * @dev Implementation of the {IERC20} interface.
754  *
755  * This implementation is agnostic to the way tokens are created. This means
756  * that a supply mechanism has to be added in a derived contract using {_mint}.
757  * For a generic mechanism see {ERC20PresetMinterPauser}.
758  *
759  * TIP: For a detailed writeup see our guide
760  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
761  * to implement supply mechanisms].
762  *
763  * We have followed general OpenZeppelin guidelines: functions revert instead
764  * of returning `false` on failure. This behavior is nonetheless conventional
765  * and does not conflict with the expectations of ERC20 applications.
766  *
767  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
768  * This allows applications to reconstruct the allowance for all accounts just
769  * by listening to said events. Other implementations of the EIP may not emit
770  * these events, as it isn't required by the specification.
771  *
772  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
773  * functions have been added to mitigate the well-known issues around setting
774  * allowances. See {IERC20-approve}.
775  */
776 contract ERC20 is Context, IERC20 {
777     using SafeMath for uint256;
778     using Address for address;
779 
780     mapping (address => uint256) private _balances;
781 
782     mapping (address => mapping (address => uint256)) private _allowances;
783 
784     uint256 private _totalSupply;
785 
786     string private _name;
787     string private _symbol;
788     uint8 private _decimals;
789 
790     /**
791      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
792      * a default value of 18.
793      *
794      * To select a different value for {decimals}, use {_setupDecimals}.
795      *
796      * All three of these values are immutable: they can only be set once during
797      * construction.
798      */
799     constructor (string memory name, string memory symbol) public {
800         _name = name;
801         _symbol = symbol;
802         _decimals = 18;
803     }
804 
805     /**
806      * @dev Returns the name of the token.
807      */
808     function name() public view returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev Returns the symbol of the token, usually a shorter version of the
814      * name.
815      */
816     function symbol() public view returns (string memory) {
817         return _symbol;
818     }
819 
820     /**
821      * @dev Returns the number of decimals used to get its user representation.
822      * For example, if `decimals` equals `2`, a balance of `505` tokens should
823      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
824      *
825      * Tokens usually opt for a value of 18, imitating the relationship between
826      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
827      * called.
828      *
829      * NOTE: This information is only used for _display_ purposes: it in
830      * no way affects any of the arithmetic of the contract, including
831      * {IERC20-balanceOf} and {IERC20-transfer}.
832      */
833     function decimals() public view returns (uint8) {
834         return _decimals;
835     }
836 
837     /**
838      * @dev See {IERC20-totalSupply}.
839      */
840     function totalSupply() public view override returns (uint256) {
841         return _totalSupply;
842     }
843 
844     /**
845      * @dev See {IERC20-balanceOf}.
846      */
847     function balanceOf(address account) public view override returns (uint256) {
848         return _balances[account];
849     }
850 
851     /**
852      * @dev See {IERC20-transfer}.
853      *
854      * Requirements:
855      *
856      * - `recipient` cannot be the zero address.
857      * - the caller must have a balance of at least `amount`.
858      */
859     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
860         _transfer(_msgSender(), recipient, amount);
861         return true;
862     }
863 
864     /**
865      * @dev See {IERC20-allowance}.
866      */
867     function allowance(address owner, address spender) public view virtual override returns (uint256) {
868         return _allowances[owner][spender];
869     }
870 
871     /**
872      * @dev See {IERC20-approve}.
873      *
874      * Requirements:
875      *
876      * - `spender` cannot be the zero address.
877      */
878     function approve(address spender, uint256 amount) public virtual override returns (bool) {
879         _approve(_msgSender(), spender, amount);
880         return true;
881     }
882 
883     /**
884      * @dev See {IERC20-transferFrom}.
885      *
886      * Emits an {Approval} event indicating the updated allowance. This is not
887      * required by the EIP. See the note at the beginning of {ERC20};
888      *
889      * Requirements:
890      * - `sender` and `recipient` cannot be the zero address.
891      * - `sender` must have a balance of at least `amount`.
892      * - the caller must have allowance for ``sender``'s tokens of at least
893      * `amount`.
894      */
895     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
896         _transfer(sender, recipient, amount);
897         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
898         return true;
899     }
900 
901     /**
902      * @dev Atomically increases the allowance granted to `spender` by the caller.
903      *
904      * This is an alternative to {approve} that can be used as a mitigation for
905      * problems described in {IERC20-approve}.
906      *
907      * Emits an {Approval} event indicating the updated allowance.
908      *
909      * Requirements:
910      *
911      * - `spender` cannot be the zero address.
912      */
913     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
914         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
915         return true;
916     }
917 
918     /**
919      * @dev Atomically decreases the allowance granted to `spender` by the caller.
920      *
921      * This is an alternative to {approve} that can be used as a mitigation for
922      * problems described in {IERC20-approve}.
923      *
924      * Emits an {Approval} event indicating the updated allowance.
925      *
926      * Requirements:
927      *
928      * - `spender` cannot be the zero address.
929      * - `spender` must have allowance for the caller of at least
930      * `subtractedValue`.
931      */
932     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
933         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
934         return true;
935     }
936 
937     /**
938      * @dev Moves tokens `amount` from `sender` to `recipient`.
939      *
940      * This is internal function is equivalent to {transfer}, and can be used to
941      * e.g. implement automatic token fees, slashing mechanisms, etc.
942      *
943      * Emits a {Transfer} event.
944      *
945      * Requirements:
946      *
947      * - `sender` cannot be the zero address.
948      * - `recipient` cannot be the zero address.
949      * - `sender` must have a balance of at least `amount`.
950      */
951     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
952         require(sender != address(0), "ERC20: transfer from the zero address");
953         require(recipient != address(0), "ERC20: transfer to the zero address");
954 
955         _beforeTokenTransfer(sender, recipient, amount);
956 
957         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
958         _balances[recipient] = _balances[recipient].add(amount);
959         emit Transfer(sender, recipient, amount);
960     }
961 
962     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
963      * the total supply.
964      *
965      * Emits a {Transfer} event with `from` set to the zero address.
966      *
967      * Requirements
968      *
969      * - `to` cannot be the zero address.
970      */
971     function _mint(address account, uint256 amount) internal virtual {
972         require(account != address(0), "ERC20: mint to the zero address");
973 
974         _beforeTokenTransfer(address(0), account, amount);
975 
976         _totalSupply = _totalSupply.add(amount);
977         _balances[account] = _balances[account].add(amount);
978         emit Transfer(address(0), account, amount);
979     }
980 
981     /**
982      * @dev Destroys `amount` tokens from `account`, reducing the
983      * total supply.
984      *
985      * Emits a {Transfer} event with `to` set to the zero address.
986      *
987      * Requirements
988      *
989      * - `account` cannot be the zero address.
990      * - `account` must have at least `amount` tokens.
991      */
992     function _burn(address account, uint256 amount) internal virtual {
993         require(account != address(0), "ERC20: burn from the zero address");
994 
995         _beforeTokenTransfer(account, address(0), amount);
996 
997         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
998         _totalSupply = _totalSupply.sub(amount);
999         emit Transfer(account, address(0), amount);
1000     }
1001 
1002     /**
1003      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1004      *
1005      * This is internal function is equivalent to `approve`, and can be used to
1006      * e.g. set automatic allowances for certain subsystems, etc.
1007      *
1008      * Emits an {Approval} event.
1009      *
1010      * Requirements:
1011      *
1012      * - `owner` cannot be the zero address.
1013      * - `spender` cannot be the zero address.
1014      */
1015     function _approve(address owner, address spender, uint256 amount) internal virtual {
1016         require(owner != address(0), "ERC20: approve from the zero address");
1017         require(spender != address(0), "ERC20: approve to the zero address");
1018 
1019         _allowances[owner][spender] = amount;
1020         emit Approval(owner, spender, amount);
1021     }
1022 
1023     /**
1024      * @dev Sets {decimals} to a value other than the default one of 18.
1025      *
1026      * WARNING: This function should only be called from the constructor. Most
1027      * applications that interact with token contracts will not expect
1028      * {decimals} to ever change, and may work incorrectly if it does.
1029      */
1030     function _setupDecimals(uint8 decimals_) internal {
1031         _decimals = decimals_;
1032     }
1033 
1034     /**
1035      * @dev Hook that is called before any transfer of tokens. This includes
1036      * minting and burning.
1037      *
1038      * Calling conditions:
1039      *
1040      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1041      * will be to transferred to `to`.
1042      * - when `from` is zero, `amount` tokens will be minted for `to`.
1043      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1044      * - `from` and `to` are never both zero.
1045      *
1046      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1047      */
1048     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1049 }
1050 
1051 // File: @openzeppelin/contracts/access/Ownable.sol
1052 
1053 
1054 
1055 pragma solidity ^0.6.0;
1056 
1057 /**
1058  * @dev Contract module which provides a basic access control mechanism, where
1059  * there is an account (an owner) that can be granted exclusive access to
1060  * specific functions.
1061  *
1062  * By default, the owner account will be the one that deploys the contract. This
1063  * can later be changed with {transferOwnership}.
1064  *
1065  * This module is used through inheritance. It will make available the modifier
1066  * `onlyOwner`, which can be applied to your functions to restrict their use to
1067  * the owner.
1068  */
1069 contract Ownable is Context {
1070     address private _owner;
1071 
1072     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1073 
1074     /**
1075      * @dev Initializes the contract setting the deployer as the initial owner.
1076      */
1077     constructor () internal {
1078         address msgSender = _msgSender();
1079         _owner = msgSender;
1080         emit OwnershipTransferred(address(0), msgSender);
1081     }
1082 
1083     /**
1084      * @dev Returns the address of the current owner.
1085      */
1086     function owner() public view returns (address) {
1087         return _owner;
1088     }
1089 
1090     /**
1091      * @dev Throws if called by any account other than the owner.
1092      */
1093     modifier onlyOwner() {
1094         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1095         _;
1096     }
1097 
1098     /**
1099      * @dev Leaves the contract without owner. It will not be possible to call
1100      * `onlyOwner` functions anymore. Can only be called by the current owner.
1101      *
1102      * NOTE: Renouncing ownership will leave the contract without an owner,
1103      * thereby removing any functionality that is only available to the owner.
1104      */
1105     function renounceOwnership() public virtual onlyOwner {
1106         emit OwnershipTransferred(_owner, address(0));
1107         _owner = address(0);
1108     }
1109 
1110     /**
1111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1112      * Can only be called by the current owner.
1113      */
1114     function transferOwnership(address newOwner) public virtual onlyOwner {
1115         require(newOwner != address(0), "Ownable: new owner is the zero address");
1116         emit OwnershipTransferred(_owner, newOwner);
1117         _owner = newOwner;
1118     }
1119 }
1120 
1121 pragma solidity ^0.6.12;
1122 
1123 
1124 // YMIToken with Governance.
1125 contract YMIToken is ERC20("YMIToken", "YMI"), Ownable {
1126     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1127     function mint(address _to, uint256 _amount) public onlyOwner {
1128         _mint(_to, _amount);
1129         _moveDelegates(address(0), _delegates[_to], _amount);
1130     }
1131 
1132     // Copied and modified from YAM code:
1133     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1134     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1135     // Which is copied and modified from COMPOUND:
1136     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
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
1234         require(signatory != address(0), "YMI::delegateBySig: invalid signature");
1235         require(nonce == nonces[signatory]++, "YMI::delegateBySig: invalid nonce");
1236         require(now <= expiry, "YMI::delegateBySig: signature expired");
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
1266         require(blockNumber < block.number, "YMI::getPriorVotes: not yet determined");
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
1303         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying YMIS (not scaled);
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
1339         uint32 blockNumber = safe32(block.number, "YMI::_writeCheckpoint: block number exceeds 32 bits");
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
1362 // ***************************************************************
1363 
1364 
1365 
1366 
1367 // MasterChef is the master of Ymi. He can make Ymi and he is a fair guy.
1368 //
1369 // Note that it's ownable and the owner wields tremendous power. The ownership
1370 // will be transferred to a governance smart contract once YMI is sufficiently
1371 // distributed and the community can show to govern itself.
1372 //
1373 // Have fun reading it. Hopefully it's bug-free. God bless.
1374 contract MasterChef is Ownable {
1375     using SafeMath for uint256;
1376     using SafeERC20 for IERC20;
1377 
1378     // Info of each user.
1379     struct UserInfo {
1380         uint256 amount;     // How many LP tokens the user has provided.
1381         uint256 rewardDebt; // Reward debt. See explanation below.
1382         //
1383         // We do some fancy math here. Basically, any point in time, the amount of YMIs
1384         // entitled to a user but is pending to be distributed is:
1385         //
1386         //   pending reward = (user.amount * pool.accYmiPerShare) - user.rewardDebt
1387         //
1388         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1389         //   1. The pool's `accYmiPerShare` (and `lastRewardBlock`) gets updated.
1390         //   2. User receives the pending reward sent to his/her address.
1391         //   3. User's `amount` gets updated.
1392         //   4. User's `rewardDebt` gets updated.
1393     }
1394 
1395     // Info of each pool.
1396     struct PoolInfo {
1397         IERC20 lpToken;           // Address of LP token contract.
1398         uint256 allocPoint;       // How many allocation points assigned to this pool. YMIs to distribute per block.
1399         uint256 lastRewardBlock;  // Last block number that YMIs distribution occurs.
1400         uint256 accYmiPerShare; // Accumulated YMIs per share, times 1e12. See below.
1401     }
1402 
1403     // The YMI TOKEN!
1404     YMIToken public ymi;
1405     // Block number when bonus YMI period ends.
1406     uint256 public bonusEndBlock;
1407     // YMI tokens created per block.
1408     uint256 public ymiPerBlock;
1409     // Bonus muliplier for early ymi makers.
1410     uint256 public constant BONUS_MULTIPLIER = 1;
1411     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1412     IMigratorChef public migrator;
1413 
1414     // Info of each pool.
1415     PoolInfo[] public poolInfo;
1416     // Info of each user that stakes LP tokens.
1417     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1418     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1419     uint256 public totalAllocPoint = 0;
1420     // The block number when YMI mining starts.
1421     uint256 public startBlock;
1422 
1423     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1424     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1425     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1426 
1427     constructor(
1428         YMIToken _ymi,
1429         uint256 _ymiPerBlock,
1430         uint256 _startBlock,
1431         uint256 _bonusEndBlock
1432     ) public {
1433         ymi = _ymi;
1434         ymiPerBlock = _ymiPerBlock;
1435         bonusEndBlock = _bonusEndBlock;
1436         startBlock = _startBlock;
1437     }
1438 
1439     function poolLength() external view returns (uint256) {
1440         return poolInfo.length;
1441     }
1442 
1443     // Add a new lp to the pool. Can only be called by the owner.
1444     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1445     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1446         if (_withUpdate) {
1447             massUpdatePools();
1448         }
1449         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1450         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1451         poolInfo.push(PoolInfo({
1452             lpToken: _lpToken,
1453             allocPoint: _allocPoint,
1454             lastRewardBlock: lastRewardBlock,
1455             accYmiPerShare: 0
1456         }));
1457     }
1458 
1459     // Update the given pool's YMI allocation point. Can only be called by the owner.
1460     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1461         if (_withUpdate) {
1462             massUpdatePools();
1463         }
1464         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1465         poolInfo[_pid].allocPoint = _allocPoint;
1466     }
1467 
1468     // Set the migrator contract. Can only be called by the owner.
1469     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1470         migrator = _migrator;
1471     }
1472 
1473     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1474     function migrate(uint256 _pid) public {
1475         require(address(migrator) != address(0), "migrate: no migrator");
1476         PoolInfo storage pool = poolInfo[_pid];
1477         IERC20 lpToken = pool.lpToken;
1478         uint256 bal = lpToken.balanceOf(address(this));
1479         lpToken.safeApprove(address(migrator), bal);
1480         IERC20 newLpToken = migrator.migrate(lpToken);
1481         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1482         pool.lpToken = newLpToken;
1483     }
1484 
1485     // Return reward multiplier over the given _from to _to block.
1486     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1487         if (_to <= bonusEndBlock) {
1488             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1489         } else if (_from <= bonusEndBlock) {
1490             return bonusEndBlock.sub(_from);
1491         } else {
1492             return 0;
1493         }
1494     }
1495 
1496     // View function to see pending YMIs on frontend.
1497     function pendingYmi(uint256 _pid, address _user) external view returns (uint256) {
1498         PoolInfo storage pool = poolInfo[_pid];
1499         UserInfo storage user = userInfo[_pid][_user];
1500         uint256 accYmiPerShare = pool.accYmiPerShare;
1501         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1502         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1503             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1504             uint256 ymiReward = multiplier.mul(ymiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1505             accYmiPerShare = accYmiPerShare.add(ymiReward.mul(1e12).div(lpSupply));
1506         }
1507         return user.amount.mul(accYmiPerShare).div(1e12).sub(user.rewardDebt);
1508     }
1509 
1510     // Update reward vairables for all pools. Be careful of gas spending!
1511     function massUpdatePools() public {
1512         uint256 length = poolInfo.length;
1513         for (uint256 pid = 0; pid < length; ++pid) {
1514             updatePool(pid);
1515         }
1516     }
1517 
1518     // Update reward variables of the given pool to be up-to-date.
1519     function updatePool(uint256 _pid) public {
1520         PoolInfo storage pool = poolInfo[_pid];
1521         if (block.number <= pool.lastRewardBlock) {
1522             return;
1523         }
1524         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1525         if (lpSupply == 0) {
1526             pool.lastRewardBlock = block.number;
1527             return;
1528         }
1529         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1530         uint256 ymiReward = multiplier.mul(ymiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1531         ymi.mint(address(this), ymiReward);
1532         pool.accYmiPerShare = pool.accYmiPerShare.add(ymiReward.mul(1e12).div(lpSupply));
1533         pool.lastRewardBlock = block.number;
1534     }
1535 
1536     // Deposit LP tokens to MasterChef for YMI allocation.
1537     function deposit(uint256 _pid, uint256 _amount) public {
1538         PoolInfo storage pool = poolInfo[_pid];
1539         UserInfo storage user = userInfo[_pid][msg.sender];
1540         updatePool(_pid);
1541         if (user.amount > 0) {
1542             uint256 pending = user.amount.mul(pool.accYmiPerShare).div(1e12).sub(user.rewardDebt);
1543             safeYmiTransfer(msg.sender, pending);
1544         }
1545         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1546         user.amount = user.amount.add(_amount);
1547         user.rewardDebt = user.amount.mul(pool.accYmiPerShare).div(1e12);
1548         emit Deposit(msg.sender, _pid, _amount);
1549     }
1550 
1551     // Withdraw LP tokens from MasterChef.
1552     function withdraw(uint256 _pid, uint256 _amount) public {
1553         PoolInfo storage pool = poolInfo[_pid];
1554         UserInfo storage user = userInfo[_pid][msg.sender];
1555         require(user.amount >= _amount, "withdraw: not good");
1556         updatePool(_pid);
1557         uint256 pending = user.amount.mul(pool.accYmiPerShare).div(1e12).sub(user.rewardDebt);
1558         safeYmiTransfer(msg.sender, pending);
1559         user.amount = user.amount.sub(_amount);
1560         user.rewardDebt = user.amount.mul(pool.accYmiPerShare).div(1e12);
1561         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1562         emit Withdraw(msg.sender, _pid, _amount);
1563     }
1564 
1565     // Withdraw without caring about rewards. EMERGENCY ONLY.
1566     function emergencyWithdraw(uint256 _pid) public {
1567         PoolInfo storage pool = poolInfo[_pid];
1568         UserInfo storage user = userInfo[_pid][msg.sender];
1569         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1570         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1571         user.amount = 0;
1572         user.rewardDebt = 0;
1573     }
1574 
1575     // Safe ymi transfer function, just in case if rounding error causes pool to not have enough YMIs.
1576     function safeYmiTransfer(address _to, uint256 _amount) internal {
1577         uint256 ymiBal = ymi.balanceOf(address(this));
1578         if (_amount > ymiBal) {
1579             ymi.transfer(_to, ymiBal);
1580         } else {
1581             ymi.transfer(_to, _amount);
1582         }
1583     }
1584 
1585 }