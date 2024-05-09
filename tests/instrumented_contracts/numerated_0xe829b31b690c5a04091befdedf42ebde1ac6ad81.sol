1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-24
3 */
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 
8 pragma solidity ^0.6.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // File: @openzeppelin/contracts/math/SafeMath.sol
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
248 pragma solidity ^0.6.2;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies in extcodesize, which returns 0 for contracts in
273         // construction, since the code is only stored at the end of the
274         // constructor execution.
275 
276         uint256 size;
277         // solhint-disable-next-line no-inline-assembly
278         assembly { size := extcodesize(account) }
279         return size > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
302         (bool success, ) = recipient.call{ value: amount }("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain`call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325       return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
335         return _functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         return _functionCallWithValue(target, data, value, errorMessage);
362     }
363 
364     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
365         require(isContract(target), "Address: call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 // solhint-disable-next-line no-inline-assembly
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
389 
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
465 
466 
467 pragma solidity ^0.6.0;
468 
469 /**
470  * @dev Library for managing
471  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
472  * types.
473  *
474  * Sets have the following properties:
475  *
476  * - Elements are added, removed, and checked for existence in constant time
477  * (O(1)).
478  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
479  *
480  * ```
481  * contract Example {
482  *     // Add the library methods
483  *     using EnumerableSet for EnumerableSet.AddressSet;
484  *
485  *     // Declare a set state variable
486  *     EnumerableSet.AddressSet private mySet;
487  * }
488  * ```
489  *
490  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
491  * (`UintSet`) are supported.
492  */
493 library EnumerableSet {
494     // To implement this library for multiple types with as little code
495     // repetition as possible, we write it in terms of a generic Set type with
496     // bytes32 values.
497     // The Set implementation uses private functions, and user-facing
498     // implementations (such as AddressSet) are just wrappers around the
499     // underlying Set.
500     // This means that we can only create new EnumerableSets for types that fit
501     // in bytes32.
502 
503     struct Set {
504         // Storage of set values
505         bytes32[] _values;
506 
507         // Position of the value in the `values` array, plus 1 because index 0
508         // means a value is not in the set.
509         mapping (bytes32 => uint256) _indexes;
510     }
511 
512     /**
513      * @dev Add a value to a set. O(1).
514      *
515      * Returns true if the value was added to the set, that is if it was not
516      * already present.
517      */
518     function _add(Set storage set, bytes32 value) private returns (bool) {
519         if (!_contains(set, value)) {
520             set._values.push(value);
521             // The value is stored at length-1, but we add 1 to all indexes
522             // and use 0 as a sentinel value
523             set._indexes[value] = set._values.length;
524             return true;
525         } else {
526             return false;
527         }
528     }
529 
530     /**
531      * @dev Removes a value from a set. O(1).
532      *
533      * Returns true if the value was removed from the set, that is if it was
534      * present.
535      */
536     function _remove(Set storage set, bytes32 value) private returns (bool) {
537         // We read and store the value's index to prevent multiple reads from the same storage slot
538         uint256 valueIndex = set._indexes[value];
539 
540         if (valueIndex != 0) { // Equivalent to contains(set, value)
541             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
542             // the array, and then remove the last element (sometimes called as 'swap and pop').
543             // This modifies the order of the array, as noted in {at}.
544 
545             uint256 toDeleteIndex = valueIndex - 1;
546             uint256 lastIndex = set._values.length - 1;
547 
548             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
549             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
550 
551             bytes32 lastvalue = set._values[lastIndex];
552 
553             // Move the last value to the index where the value to delete is
554             set._values[toDeleteIndex] = lastvalue;
555             // Update the index for the moved value
556             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
557 
558             // Delete the slot where the moved value was stored
559             set._values.pop();
560 
561             // Delete the index for the deleted slot
562             delete set._indexes[value];
563 
564             return true;
565         } else {
566             return false;
567         }
568     }
569 
570     /**
571      * @dev Returns true if the value is in the set. O(1).
572      */
573     function _contains(Set storage set, bytes32 value) private view returns (bool) {
574         return set._indexes[value] != 0;
575     }
576 
577     /**
578      * @dev Returns the number of values on the set. O(1).
579      */
580     function _length(Set storage set) private view returns (uint256) {
581         return set._values.length;
582     }
583 
584    /**
585     * @dev Returns the value stored at position `index` in the set. O(1).
586     *
587     * Note that there are no guarantees on the ordering of values inside the
588     * array, and it may change when more values are added or removed.
589     *
590     * Requirements:
591     *
592     * - `index` must be strictly less than {length}.
593     */
594     function _at(Set storage set, uint256 index) private view returns (bytes32) {
595         require(set._values.length > index, "EnumerableSet: index out of bounds");
596         return set._values[index];
597     }
598 
599     // AddressSet
600 
601     struct AddressSet {
602         Set _inner;
603     }
604 
605     /**
606      * @dev Add a value to a set. O(1).
607      *
608      * Returns true if the value was added to the set, that is if it was not
609      * already present.
610      */
611     function add(AddressSet storage set, address value) internal returns (bool) {
612         return _add(set._inner, bytes32(uint256(value)));
613     }
614 
615     /**
616      * @dev Removes a value from a set. O(1).
617      *
618      * Returns true if the value was removed from the set, that is if it was
619      * present.
620      */
621     function remove(AddressSet storage set, address value) internal returns (bool) {
622         return _remove(set._inner, bytes32(uint256(value)));
623     }
624 
625     /**
626      * @dev Returns true if the value is in the set. O(1).
627      */
628     function contains(AddressSet storage set, address value) internal view returns (bool) {
629         return _contains(set._inner, bytes32(uint256(value)));
630     }
631 
632     /**
633      * @dev Returns the number of values in the set. O(1).
634      */
635     function length(AddressSet storage set) internal view returns (uint256) {
636         return _length(set._inner);
637     }
638 
639    /**
640     * @dev Returns the value stored at position `index` in the set. O(1).
641     *
642     * Note that there are no guarantees on the ordering of values inside the
643     * array, and it may change when more values are added or removed.
644     *
645     * Requirements:
646     *
647     * - `index` must be strictly less than {length}.
648     */
649     function at(AddressSet storage set, uint256 index) internal view returns (address) {
650         return address(uint256(_at(set._inner, index)));
651     }
652 
653 
654     // UintSet
655 
656     struct UintSet {
657         Set _inner;
658     }
659 
660     /**
661      * @dev Add a value to a set. O(1).
662      *
663      * Returns true if the value was added to the set, that is if it was not
664      * already present.
665      */
666     function add(UintSet storage set, uint256 value) internal returns (bool) {
667         return _add(set._inner, bytes32(value));
668     }
669 
670     /**
671      * @dev Removes a value from a set. O(1).
672      *
673      * Returns true if the value was removed from the set, that is if it was
674      * present.
675      */
676     function remove(UintSet storage set, uint256 value) internal returns (bool) {
677         return _remove(set._inner, bytes32(value));
678     }
679 
680     /**
681      * @dev Returns true if the value is in the set. O(1).
682      */
683     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
684         return _contains(set._inner, bytes32(value));
685     }
686 
687     /**
688      * @dev Returns the number of values on the set. O(1).
689      */
690     function length(UintSet storage set) internal view returns (uint256) {
691         return _length(set._inner);
692     }
693 
694    /**
695     * @dev Returns the value stored at position `index` in the set. O(1).
696     *
697     * Note that there are no guarantees on the ordering of values inside the
698     * array, and it may change when more values are added or removed.
699     *
700     * Requirements:
701     *
702     * - `index` must be strictly less than {length}.
703     */
704     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
705         return uint256(_at(set._inner, index));
706     }
707 }
708 
709 // File: @openzeppelin/contracts/GSN/Context.sol
710 
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
737 
738 pragma solidity ^0.6.0;
739 
740 /**
741  * @dev Contract module which provides a basic access control mechanism, where
742  * there is an account (an owner) that can be granted exclusive access to
743  * specific functions.
744  *
745  * By default, the owner account will be the one that deploys the contract. This
746  * can later be changed with {transferOwnership}.
747  *
748  * This module is used through inheritance. It will make available the modifier
749  * `onlyOwner`, which can be applied to your functions to restrict their use to
750  * the owner.
751  */
752 contract Ownable is Context {
753     address private _owner;
754 
755     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
756 
757     /**
758      * @dev Initializes the contract setting the deployer as the initial owner.
759      */
760     constructor () internal {
761         address msgSender = _msgSender();
762         _owner = msgSender;
763         emit OwnershipTransferred(address(0), msgSender);
764     }
765 
766     /**
767      * @dev Returns the address of the current owner.
768      */
769     function owner() public view returns (address) {
770         return _owner;
771     }
772 
773     /**
774      * @dev Throws if called by any account other than the owner.
775      */
776     modifier onlyOwner() {
777         require(_owner == _msgSender(), "Ownable: caller is not the owner");
778         _;
779     }
780 
781     /**
782      * @dev Leaves the contract without owner. It will not be possible to call
783      * `onlyOwner` functions anymore. Can only be called by the current owner.
784      *
785      * NOTE: Renouncing ownership will leave the contract without an owner,
786      * thereby removing any functionality that is only available to the owner.
787      */
788     function renounceOwnership() public virtual onlyOwner {
789         emit OwnershipTransferred(_owner, address(0));
790         _owner = address(0);
791     }
792 
793     /**
794      * @dev Transfers ownership of the contract to a new account (`newOwner`).
795      * Can only be called by the current owner.
796      */
797     function transferOwnership(address newOwner) public virtual onlyOwner {
798         require(newOwner != address(0), "Ownable: new owner is the zero address");
799         emit OwnershipTransferred(_owner, newOwner);
800         _owner = newOwner;
801     }
802 }
803 
804 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
805 
806 
807 pragma solidity ^0.6.0;
808 
809 
810 
811 
812 
813 /**
814  * @dev Implementation of the {IERC20} interface.
815  *
816  * This implementation is agnostic to the way tokens are created. This means
817  * that a supply mechanism has to be added in a derived contract using {_mint}.
818  * For a generic mechanism see {ERC20PresetMinterPauser}.
819  *
820  * TIP: For a detailed writeup see our guide
821  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
822  * to implement supply mechanisms].
823  *
824  * We have followed general OpenZeppelin guidelines: functions revert instead
825  * of returning `false` on failure. This behavior is nonetheless conventional
826  * and does not conflict with the expectations of ERC20 applications.
827  *
828  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
829  * This allows applications to reconstruct the allowance for all accounts just
830  * by listening to said events. Other implementations of the EIP may not emit
831  * these events, as it isn't required by the specification.
832  *
833  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
834  * functions have been added to mitigate the well-known issues around setting
835  * allowances. See {IERC20-approve}.
836  */
837 contract ERC20 is Context, IERC20 {
838     using SafeMath for uint256;
839     using Address for address;
840 
841     mapping (address => uint256) private _balances;
842 
843     mapping (address => mapping (address => uint256)) private _allowances;
844 
845     uint256 private _totalSupply;
846 
847     string private _name;
848     string private _symbol;
849     uint8 private _decimals;
850 
851     /**
852      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
853      * a default value of 18.
854      *
855      * To select a different value for {decimals}, use {_setupDecimals}.
856      *
857      * All three of these values are immutable: they can only be set once during
858      * construction.
859      */
860     constructor (string memory name, string memory symbol) public {
861         _name = name;
862         _symbol = symbol;
863         _decimals = 18;
864     }
865 
866     /**
867      * @dev Returns the name of the token.
868      */
869     function name() public view returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev Returns the symbol of the token, usually a shorter version of the
875      * name.
876      */
877     function symbol() public view returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev Returns the number of decimals used to get its user representation.
883      * For example, if `decimals` equals `2`, a balance of `505` tokens should
884      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
885      *
886      * Tokens usually opt for a value of 18, imitating the relationship between
887      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
888      * called.
889      *
890      * NOTE: This information is only used for _display_ purposes: it in
891      * no way affects any of the arithmetic of the contract, including
892      * {IERC20-balanceOf} and {IERC20-transfer}.
893      */
894     function decimals() public view returns (uint8) {
895         return _decimals;
896     }
897 
898     /**
899      * @dev See {IERC20-totalSupply}.
900      */
901     function totalSupply() public view override returns (uint256) {
902         return _totalSupply;
903     }
904 
905     /**
906      * @dev See {IERC20-balanceOf}.
907      */
908     function balanceOf(address account) public view override returns (uint256) {
909         return _balances[account];
910     }
911 
912     /**
913      * @dev See {IERC20-transfer}.
914      *
915      * Requirements:
916      *
917      * - `recipient` cannot be the zero address.
918      * - the caller must have a balance of at least `amount`.
919      */
920     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
921         _transfer(_msgSender(), recipient, amount);
922         return true;
923     }
924 
925     /**
926      * @dev See {IERC20-allowance}.
927      */
928     function allowance(address owner, address spender) public view virtual override returns (uint256) {
929         return _allowances[owner][spender];
930     }
931 
932     /**
933      * @dev See {IERC20-approve}.
934      *
935      * Requirements:
936      *
937      * - `spender` cannot be the zero address.
938      */
939     function approve(address spender, uint256 amount) public virtual override returns (bool) {
940         _approve(_msgSender(), spender, amount);
941         return true;
942     }
943 
944     /**
945      * @dev See {IERC20-transferFrom}.
946      *
947      * Emits an {Approval} event indicating the updated allowance. This is not
948      * required by the EIP. See the note at the beginning of {ERC20};
949      *
950      * Requirements:
951      * - `sender` and `recipient` cannot be the zero address.
952      * - `sender` must have a balance of at least `amount`.
953      * - the caller must have allowance for ``sender``'s tokens of at least
954      * `amount`.
955      */
956     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
957         _transfer(sender, recipient, amount);
958         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
959         return true;
960     }
961 
962     /**
963      * @dev Atomically increases the allowance granted to `spender` by the caller.
964      *
965      * This is an alternative to {approve} that can be used as a mitigation for
966      * problems described in {IERC20-approve}.
967      *
968      * Emits an {Approval} event indicating the updated allowance.
969      *
970      * Requirements:
971      *
972      * - `spender` cannot be the zero address.
973      */
974     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
975         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
976         return true;
977     }
978 
979     /**
980      * @dev Atomically decreases the allowance granted to `spender` by the caller.
981      *
982      * This is an alternative to {approve} that can be used as a mitigation for
983      * problems described in {IERC20-approve}.
984      *
985      * Emits an {Approval} event indicating the updated allowance.
986      *
987      * Requirements:
988      *
989      * - `spender` cannot be the zero address.
990      * - `spender` must have allowance for the caller of at least
991      * `subtractedValue`.
992      */
993     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
994         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
995         return true;
996     }
997 
998     /**
999      * @dev Moves tokens `amount` from `sender` to `recipient`.
1000      *
1001      * This is internal function is equivalent to {transfer}, and can be used to
1002      * e.g. implement automatic token fees, slashing mechanisms, etc.
1003      *
1004      * Emits a {Transfer} event.
1005      *
1006      * Requirements:
1007      *
1008      * - `sender` cannot be the zero address.
1009      * - `recipient` cannot be the zero address.
1010      * - `sender` must have a balance of at least `amount`.
1011      */
1012     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1013         require(sender != address(0), "ERC20: transfer from the zero address");
1014         require(recipient != address(0), "ERC20: transfer to the zero address");
1015 
1016         _beforeTokenTransfer(sender, recipient, amount);
1017 
1018         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1019         _balances[recipient] = _balances[recipient].add(amount);
1020         emit Transfer(sender, recipient, amount);
1021     }
1022 
1023     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1024      * the total supply.
1025      *
1026      * Emits a {Transfer} event with `from` set to the zero address.
1027      *
1028      * Requirements
1029      *
1030      * - `to` cannot be the zero address.
1031      */
1032     function _mint(address account, uint256 amount) internal virtual {
1033         require(account != address(0), "ERC20: mint to the zero address");
1034 
1035         _beforeTokenTransfer(address(0), account, amount);
1036 
1037         _totalSupply = _totalSupply.add(amount);
1038         _balances[account] = _balances[account].add(amount);
1039         emit Transfer(address(0), account, amount);
1040     }
1041 
1042     /**
1043      * @dev Destroys `amount` tokens from `account`, reducing the
1044      * total supply.
1045      *
1046      * Emits a {Transfer} event with `to` set to the zero address.
1047      *
1048      * Requirements
1049      *
1050      * - `account` cannot be the zero address.
1051      * - `account` must have at least `amount` tokens.
1052      */
1053     function _burn(address account, uint256 amount) internal virtual {
1054         require(account != address(0), "ERC20: burn from the zero address");
1055 
1056         _beforeTokenTransfer(account, address(0), amount);
1057 
1058         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1059         _totalSupply = _totalSupply.sub(amount);
1060         emit Transfer(account, address(0), amount);
1061     }
1062 
1063     /**
1064      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1065      *
1066      * This internal function is equivalent to `approve`, and can be used to
1067      * e.g. set automatic allowances for certain subsystems, etc.
1068      *
1069      * Emits an {Approval} event.
1070      *
1071      * Requirements:
1072      *
1073      * - `owner` cannot be the zero address.
1074      * - `spender` cannot be the zero address.
1075      */
1076     function _approve(address owner, address spender, uint256 amount) internal virtual {
1077         require(owner != address(0), "ERC20: approve from the zero address");
1078         require(spender != address(0), "ERC20: approve to the zero address");
1079 
1080         _allowances[owner][spender] = amount;
1081         emit Approval(owner, spender, amount);
1082     }
1083 
1084     /**
1085      * @dev Sets {decimals} to a value other than the default one of 18.
1086      *
1087      * WARNING: This function should only be called from the constructor. Most
1088      * applications that interact with token contracts will not expect
1089      * {decimals} to ever change, and may work incorrectly if it does.
1090      */
1091     function _setupDecimals(uint8 decimals_) internal {
1092         _decimals = decimals_;
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any transfer of tokens. This includes
1097      * minting and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1102      * will be to transferred to `to`.
1103      * - when `from` is zero, `amount` tokens will be minted for `to`.
1104      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1110 }
1111 
1112 // File: contracts/FruitToken.sol
1113 
1114 pragma solidity 0.6.12;
1115 
1116 
1117 
1118 
1119 // FruitToken with Governance.
1120 contract FruitToken is ERC20("Fruit V4", "FRUIT"), Ownable {
1121 
1122     // Copied and modified from YAM code:
1123     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1124     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1125     // Which is copied and modified from COMPOUND:
1126     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1127 
1128     /// @notice A record of each accounts delegate
1129     mapping (address => address) internal _delegates;
1130 
1131     /// @notice A checkpoint for marking number of votes from a given block
1132     struct Checkpoint {
1133         uint32 fromBlock;
1134         uint256 votes;
1135     }
1136 
1137     /// @notice A record of votes checkpoints for each account, by index
1138     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1139 
1140     /// @notice The number of checkpoints for each account
1141     mapping (address => uint32) public numCheckpoints;
1142 
1143     /// @notice The EIP-712 typehash for the contract's domain
1144     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1145 
1146     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1147     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1148 
1149     /// @notice A record of states for signing / validating signatures
1150     mapping (address => uint) public nonces;
1151 
1152       /// @notice An event thats emitted when an account changes its delegate
1153     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1154 
1155     /// @notice An event thats emitted when a delegate account's vote balance changes
1156     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1157 
1158     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1159     function mint(address _to, uint256 _amount) public onlyOwner {
1160         _mint(_to, _amount);
1161         _moveDelegates(address(0), _delegates[_to], _amount);
1162     }
1163 
1164     /**
1165      * @dev Destroys `amount` tokens from the caller.
1166      *
1167      * See {ERC20-_burn}.
1168      */
1169     function burn(uint256 amount) public virtual {
1170         _burn(_msgSender(), amount);
1171         _moveDelegates(_delegates[_msgSender()], address(0), amount);
1172     }
1173 
1174     /**
1175      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1176      * allowance.
1177      *
1178      * See {ERC20-_burn} and {ERC20-allowance}.
1179      *
1180      * Requirements:
1181      *
1182      * - the caller must have allowance for ``accounts``'s tokens of at least
1183      * `amount`.
1184      */
1185     function burnFrom(address account, uint256 amount) public virtual {
1186         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1187 
1188         _approve(account, _msgSender(), decreasedAllowance);
1189         _burn(account, amount);
1190         _moveDelegates(account, address(0), amount);
1191     }
1192 
1193     /**
1194      * @notice Delegate votes from `msg.sender` to `delegatee`
1195      * @param delegator The address to get delegatee for
1196      */
1197     function delegates(address delegator)
1198         external
1199         view
1200         returns (address)
1201     {
1202         return _delegates[delegator];
1203     }
1204 
1205    /**
1206     * @notice Delegate votes from `msg.sender` to `delegatee`
1207     * @param delegatee The address to delegate votes to
1208     */
1209     function delegate(address delegatee) external {
1210         return _delegate(msg.sender, delegatee);
1211     }
1212 
1213     /**
1214      * @notice Delegates votes from signatory to `delegatee`
1215      * @param delegatee The address to delegate votes to
1216      * @param nonce The contract state required to match the signature
1217      * @param expiry The time at which to expire the signature
1218      * @param v The recovery byte of the signature
1219      * @param r Half of the ECDSA signature pair
1220      * @param s Half of the ECDSA signature pair
1221      */
1222     function delegateBySig(
1223         address delegatee,
1224         uint nonce,
1225         uint expiry,
1226         uint8 v,
1227         bytes32 r,
1228         bytes32 s
1229     )
1230         external
1231     {
1232         bytes32 domainSeparator = keccak256(
1233             abi.encode(
1234                 DOMAIN_TYPEHASH,
1235                 keccak256(bytes(name())),
1236                 getChainId(),
1237                 address(this)
1238             )
1239         );
1240 
1241         bytes32 structHash = keccak256(
1242             abi.encode(
1243                 DELEGATION_TYPEHASH,
1244                 delegatee,
1245                 nonce,
1246                 expiry
1247             )
1248         );
1249 
1250         bytes32 digest = keccak256(
1251             abi.encodePacked(
1252                 "\x19\x01",
1253                 domainSeparator,
1254                 structHash
1255             )
1256         );
1257 
1258         address signatory = ecrecover(digest, v, r, s);
1259         require(signatory != address(0), "JELLY::delegateBySig: invalid signature");
1260         require(nonce == nonces[signatory]++, "JELLY::delegateBySig: invalid nonce");
1261         require(now <= expiry, "JELLY::delegateBySig: signature expired");
1262         return _delegate(signatory, delegatee);
1263     }
1264 
1265     /**
1266      * @notice Gets the current votes balance for `account`
1267      * @param account The address to get votes balance
1268      * @return The number of current votes for `account`
1269      */
1270     function getCurrentVotes(address account)
1271         external
1272         view
1273         returns (uint256)
1274     {
1275         uint32 nCheckpoints = numCheckpoints[account];
1276         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1277     }
1278 
1279     /**
1280      * @notice Determine the prior number of votes for an account as of a block number
1281      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1282      * @param account The address of the account to check
1283      * @param blockNumber The block number to get the vote balance at
1284      * @return The number of votes the account had as of the given block
1285      */
1286     function getPriorVotes(address account, uint blockNumber)
1287         external
1288         view
1289         returns (uint256)
1290     {
1291         require(blockNumber < block.number, "JELLY::getPriorVotes: not yet determined");
1292 
1293         uint32 nCheckpoints = numCheckpoints[account];
1294         if (nCheckpoints == 0) {
1295             return 0;
1296         }
1297 
1298         // First check most recent balance
1299         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1300             return checkpoints[account][nCheckpoints - 1].votes;
1301         }
1302 
1303         // Next check implicit zero balance
1304         if (checkpoints[account][0].fromBlock > blockNumber) {
1305             return 0;
1306         }
1307 
1308         uint32 lower = 0;
1309         uint32 upper = nCheckpoints - 1;
1310         while (upper > lower) {
1311             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1312             Checkpoint memory cp = checkpoints[account][center];
1313             if (cp.fromBlock == blockNumber) {
1314                 return cp.votes;
1315             } else if (cp.fromBlock < blockNumber) {
1316                 lower = center;
1317             } else {
1318                 upper = center - 1;
1319             }
1320         }
1321         return checkpoints[account][lower].votes;
1322     }
1323 
1324     function _delegate(address delegator, address delegatee)
1325         internal
1326     {
1327         address currentDelegate = _delegates[delegator];
1328         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying JELLYs (not scaled);
1329         _delegates[delegator] = delegatee;
1330 
1331         emit DelegateChanged(delegator, currentDelegate, delegatee);
1332 
1333         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1334     }
1335 
1336     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1337         if (srcRep != dstRep && amount > 0) {
1338             if (srcRep != address(0)) {
1339                 // decrease old representative
1340                 uint32 srcRepNum = numCheckpoints[srcRep];
1341                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1342                 uint256 srcRepNew = srcRepOld.sub(amount);
1343                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1344             }
1345 
1346             if (dstRep != address(0)) {
1347                 // increase new representative
1348                 uint32 dstRepNum = numCheckpoints[dstRep];
1349                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1350                 uint256 dstRepNew = dstRepOld.add(amount);
1351                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1352             }
1353         }
1354     }
1355 
1356     function _writeCheckpoint(
1357         address delegatee,
1358         uint32 nCheckpoints,
1359         uint256 oldVotes,
1360         uint256 newVotes
1361     )
1362         internal
1363     {
1364         uint32 blockNumber = safe32(block.number, "JELLY::_writeCheckpoint: block number exceeds 32 bits");
1365 
1366         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1367             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1368         } else {
1369             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1370             numCheckpoints[delegatee] = nCheckpoints + 1;
1371         }
1372 
1373         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1374     }
1375 
1376     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1377         require(n < 2**32, errorMessage);
1378         return uint32(n);
1379     }
1380 
1381     function getChainId() internal pure returns (uint) {
1382         uint256 chainId;
1383         assembly { chainId := chainid() }
1384         return chainId;
1385     }
1386 }