1 // https://devil.finance/
2 //
3 // Honest farmer, welcome to hell.
4 //
5 // The rules are a little different around here...
6 //
7 // Instead of lame veggies you will be harvesting souls and releasing them upon
8 // humanity as demons.
9 //
10 // There are 7 primary pools where you can harvest these poor innocent souls, each
11 // corresponding to the 7 deadly sins.
12 //
13 // Additionally, there are 3 bonus pools for the braver farmers to venture into. 
14 // These bonus pools are unlike the first 7 pools. They may be banished anytime 
15 // after 6 days, any token staked in these pools will be sent to the abyss, never 
16 // to be reclaimed. When will the banishment happen? You will never see it come.
17 //
18 // Also, don't we all hate the greedy farmers who pulls the rug early and destroys 
19 // the fun for everyone? Here, the souls are tethered to hell in the first two weeks 
20 // of harvesting. Only a fraction of the harvested souls will be available for claim 
21 // during both deposit and withdrawal. The ratio of souls you can claim will increase 
22 // steeply nearing the end of the two weeks - just like the temperature down here.
23 // 
24 // Your first 6 days here will feel exactly like you are in heaven. Souls are harvested
25 // at 5x the normal rate and the bonus pools are open to braver farmers to harvest souls
26 // at much higher rates without fear of banishment.
27 // 
28 // Things might be a little different after 6 days... 
29 // Temperature will slowly rise as the fraction of souls that can be claimed 
30 // increases and bonus pools are at risk of permanent closures...
31 //
32 // Who will be the first to freak out and leave hell with no yield?
33 // Who will risk banishment in the bonus pools after 6 days?
34 // Who will stay long enough to claim all the souls harvested at the end?
35 //
36 // Let's find out.
37 //
38 // Ps. The devil does not play by your rules. If playing in hell is too dangerous for you, leave. You have been warned!
39 
40 pragma solidity ^0.5.0;
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46   /**
47      * @dev Returns the amount of tokens in existence.
48      */
49   function totalSupply() external view returns (uint256);
50 
51   /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54   function balanceOf(address account) external view returns (uint256);
55 
56   /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63   function transfer(address recipient, uint256 amount) external returns (bool);
64 
65   /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72   function allowance(address owner, address spender) external view returns (uint256);
73 
74   /**
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
88   function approve(address spender, uint256 amount) external returns (bool);
89 
90   /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101   /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107   event Transfer(address indexed from, address indexed to, uint256 value);
108 
109   /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 pragma solidity ^0.5.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132   /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     require(c >= a, "SafeMath: addition overflow");
145 
146     return c;
147   }
148 
149   /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160     return sub(a, b, "SafeMath: subtraction overflow");
161   }
162 
163   /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174     require(b <= a, errorMessage);
175     uint256 c = a - b;
176 
177     return c;
178   }
179 
180   /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192     // benefit is lost if 'b' is also tested.
193     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194     if (a == 0) {
195       return 0;
196     }
197 
198     uint256 c = a * b;
199     require(c / a == b, "SafeMath: multiplication overflow");
200 
201     return c;
202   }
203 
204   /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216   function div(uint256 a, uint256 b) internal pure returns (uint256) {
217     return div(a, b, "SafeMath: division by zero");
218   }
219 
220   /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233     require(b > 0, errorMessage);
234     uint256 c = a / b;
235     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237     return c;
238   }
239 
240   /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253     return mod(a, b, "SafeMath: modulo by zero");
254   }
255 
256   /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269     require(b != 0, errorMessage);
270     return a % b;
271   }
272 }
273 
274 pragma solidity ^0.5.2;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280   /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297   function isContract(address account) internal view returns (bool) {
298     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
299     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
300     // for accounts without code, i.e. `keccak256('')`
301     bytes32 codehash;
302     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
303     // solhint-disable-next-line no-inline-assembly
304     assembly {
305       codehash := extcodehash(account)
306     }
307     return (codehash != accountHash && codehash != 0x0);
308   }
309 
310   /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326   function sendValue(address payable recipient, uint256 amount) internal {
327     require(address(this).balance >= amount, "Address: insufficient balance");
328 
329     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330     (bool success, ) = recipient.call.value(amount)("");
331     require(success, "Address: unable to send value, recipient may have reverted");
332   }
333 
334   /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353     return functionCall(target, data, "Address: low-level call failed");
354   }
355 
356   /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362   function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363     return _functionCallWithValue(target, data, 0, errorMessage);
364   }
365 
366   /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377   function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
378     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379   }
380 
381   /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387   function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage)
388     internal
389     returns (bytes memory)
390   {
391     require(address(this).balance >= value, "Address: insufficient balance for call");
392     return _functionCallWithValue(target, data, value, errorMessage);
393   }
394 
395   function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage)
396     private
397     returns (bytes memory)
398   {
399     require(isContract(target), "Address: call to non-contract");
400 
401     // solhint-disable-next-line avoid-low-level-calls
402     (bool success, bytes memory returndata) = target.call.value(weiValue)(data);
403     if (success) {
404       return returndata;
405     } else {
406       // Look for revert reason and bubble it up if present
407       if (returndata.length > 0) {
408         // The easiest way to bubble the revert reason is using memory via assembly
409 
410         // solhint-disable-next-line no-inline-assembly
411         assembly {
412           let returndata_size := mload(returndata)
413           revert(add(32, returndata), returndata_size)
414         }
415       } else {
416         revert(errorMessage);
417       }
418     }
419   }
420 }
421 
422 pragma solidity ^0.5.0;
423 
424 /**
425  * @title SafeERC20
426  * @dev Wrappers around ERC20 operations that throw on failure (when the token
427  * contract returns false). Tokens that return no value (and instead revert or
428  * throw on failure) are also supported, non-reverting calls are assumed to be
429  * successful.
430  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
431  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
432  */
433 library SafeERC20 {
434   using SafeMath for uint256;
435   using Address for address;
436 
437   function safeTransfer(IERC20 token, address to, uint256 value) internal {
438     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
439   }
440 
441   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
442     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
443   }
444 
445   /**
446      * @dev Deprecated. This function has issues similar to the ones found in
447      * {IERC20-approve}, and its usage is discouraged.
448      *
449      * Whenever possible, use {safeIncreaseAllowance} and
450      * {safeDecreaseAllowance} instead.
451      */
452   function safeApprove(IERC20 token, address spender, uint256 value) internal {
453     // safeApprove should only be called when setting an initial allowance,
454     // or when resetting it to zero. To increase and decrease it, use
455     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
456     // solhint-disable-next-line max-line-length
457     require(
458       (value == 0) || (token.allowance(address(this), spender) == 0),
459       "SafeERC20: approve from non-zero to non-zero allowance"
460     );
461     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
462   }
463 
464   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
465     uint256 newAllowance = token.allowance(address(this), spender).add(value);
466     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
467   }
468 
469   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
470     uint256 newAllowance = token.allowance(address(this), spender).sub(
471       value,
472       "SafeERC20: decreased allowance below zero"
473     );
474     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
475   }
476 
477   /**
478      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
479      * on the return value: the return value is optional (but if data is returned, it must not be false).
480      * @param token The token targeted by the call.
481      * @param data The call data (encoded using abi.encode or one of its variants).
482      */
483   function _callOptionalReturn(IERC20 token, bytes memory data) private {
484     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
485     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
486     // the target address contains contract code and also asserts for success in the low-level call.
487 
488     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
489     if (returndata.length > 0) {
490       // Return data is optional
491       // solhint-disable-next-line max-line-length
492       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
493     }
494   }
495 }
496 
497 pragma solidity ^0.5.0;
498 
499 /**
500  * @dev Library for managing
501  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
502  * types.
503  *
504  * Sets have the following properties:
505  *
506  * - Elements are added, removed, and checked for existence in constant time
507  * (O(1)).
508  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
509  *
510  * ```
511  * contract Example {
512  *     // Add the library methods
513  *     using EnumerableSet for EnumerableSet.AddressSet;
514  *
515  *     // Declare a set state variable
516  *     EnumerableSet.AddressSet private mySet;
517  * }
518  * ```
519  *
520  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
521  * (`UintSet`) are supported.
522  */
523 library EnumerableSet {
524   // To implement this library for multiple types with as little code
525   // repetition as possible, we write it in terms of a generic Set type with
526   // bytes32 values.
527   // The Set implementation uses private functions, and user-facing
528   // implementations (such as AddressSet) are just wrappers around the
529   // underlying Set.
530   // This means that we can only create new EnumerableSets for types that fit
531   // in bytes32.
532 
533   struct Set {
534     // Storage of set values
535     bytes32[] _values;
536     // Position of the value in the `values` array, plus 1 because index 0
537     // means a value is not in the set.
538     mapping(bytes32 => uint256) _indexes;
539   }
540 
541   /**
542      * @dev Add a value to a set. O(1).
543      *
544      * Returns true if the value was added to the set, that is if it was not
545      * already present.
546      */
547   function _add(Set storage set, bytes32 value) private returns (bool) {
548     if (!_contains(set, value)) {
549       set._values.push(value);
550       // The value is stored at length-1, but we add 1 to all indexes
551       // and use 0 as a sentinel value
552       set._indexes[value] = set._values.length;
553       return true;
554     } else {
555       return false;
556     }
557   }
558 
559   /**
560      * @dev Removes a value from a set. O(1).
561      *
562      * Returns true if the value was removed from the set, that is if it was
563      * present.
564      */
565   function _remove(Set storage set, bytes32 value) private returns (bool) {
566     // We read and store the value's index to prevent multiple reads from the same storage slot
567     uint256 valueIndex = set._indexes[value];
568 
569     if (valueIndex != 0) {
570       // Equivalent to contains(set, value)
571       // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
572       // the array, and then remove the last element (sometimes called as 'swap and pop').
573       // This modifies the order of the array, as noted in {at}.
574 
575       uint256 toDeleteIndex = valueIndex - 1;
576       uint256 lastIndex = set._values.length - 1;
577 
578       // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
579       // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
580 
581       bytes32 lastvalue = set._values[lastIndex];
582 
583       // Move the last value to the index where the value to delete is
584       set._values[toDeleteIndex] = lastvalue;
585       // Update the index for the moved value
586       set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
587 
588       // Delete the slot where the moved value was stored
589       set._values.pop();
590 
591       // Delete the index for the deleted slot
592       delete set._indexes[value];
593 
594       return true;
595     } else {
596       return false;
597     }
598   }
599 
600   /**
601      * @dev Returns true if the value is in the set. O(1).
602      */
603   function _contains(Set storage set, bytes32 value) private view returns (bool) {
604     return set._indexes[value] != 0;
605   }
606 
607   /**
608      * @dev Returns the number of values on the set. O(1).
609      */
610   function _length(Set storage set) private view returns (uint256) {
611     return set._values.length;
612   }
613 
614   /**
615     * @dev Returns the value stored at position `index` in the set. O(1).
616     *
617     * Note that there are no guarantees on the ordering of values inside the
618     * array, and it may change when more values are added or removed.
619     *
620     * Requirements:
621     *
622     * - `index` must be strictly less than {length}.
623     */
624   function _at(Set storage set, uint256 index) private view returns (bytes32) {
625     require(set._values.length > index, "EnumerableSet: index out of bounds");
626     return set._values[index];
627   }
628 
629   // AddressSet
630 
631   struct AddressSet {
632     Set _inner;
633   }
634 
635   /**
636      * @dev Add a value to a set. O(1).
637      *
638      * Returns true if the value was added to the set, that is if it was not
639      * already present.
640      */
641   function add(AddressSet storage set, address value) internal returns (bool) {
642     return _add(set._inner, bytes32(uint256(value)));
643   }
644 
645   /**
646      * @dev Removes a value from a set. O(1).
647      *
648      * Returns true if the value was removed from the set, that is if it was
649      * present.
650      */
651   function remove(AddressSet storage set, address value) internal returns (bool) {
652     return _remove(set._inner, bytes32(uint256(value)));
653   }
654 
655   /**
656      * @dev Returns true if the value is in the set. O(1).
657      */
658   function contains(AddressSet storage set, address value) internal view returns (bool) {
659     return _contains(set._inner, bytes32(uint256(value)));
660   }
661 
662   /**
663      * @dev Returns the number of values in the set. O(1).
664      */
665   function length(AddressSet storage set) internal view returns (uint256) {
666     return _length(set._inner);
667   }
668 
669   /**
670     * @dev Returns the value stored at position `index` in the set. O(1).
671     *
672     * Note that there are no guarantees on the ordering of values inside the
673     * array, and it may change when more values are added or removed.
674     *
675     * Requirements:
676     *
677     * - `index` must be strictly less than {length}.
678     */
679   function at(AddressSet storage set, uint256 index) internal view returns (address) {
680     return address(uint256(_at(set._inner, index)));
681   }
682 
683   // UintSet
684 
685   struct UintSet {
686     Set _inner;
687   }
688 
689   /**
690      * @dev Add a value to a set. O(1).
691      *
692      * Returns true if the value was added to the set, that is if it was not
693      * already present.
694      */
695   function add(UintSet storage set, uint256 value) internal returns (bool) {
696     return _add(set._inner, bytes32(value));
697   }
698 
699   /**
700      * @dev Removes a value from a set. O(1).
701      *
702      * Returns true if the value was removed from the set, that is if it was
703      * present.
704      */
705   function remove(UintSet storage set, uint256 value) internal returns (bool) {
706     return _remove(set._inner, bytes32(value));
707   }
708 
709   /**
710      * @dev Returns true if the value is in the set. O(1).
711      */
712   function contains(UintSet storage set, uint256 value) internal view returns (bool) {
713     return _contains(set._inner, bytes32(value));
714   }
715 
716   /**
717      * @dev Returns the number of values on the set. O(1).
718      */
719   function length(UintSet storage set) internal view returns (uint256) {
720     return _length(set._inner);
721   }
722 
723   /**
724     * @dev Returns the value stored at position `index` in the set. O(1).
725     *
726     * Note that there are no guarantees on the ordering of values inside the
727     * array, and it may change when more values are added or removed.
728     *
729     * Requirements:
730     *
731     * - `index` must be strictly less than {length}.
732     */
733   function at(UintSet storage set, uint256 index) internal view returns (uint256) {
734     return uint256(_at(set._inner, index));
735   }
736 }
737 
738 pragma solidity ^0.5.0;
739 
740 /*
741  * @dev Provides information about the current execution context, including the
742  * sender of the transaction and its data. While these are generally available
743  * via msg.sender and msg.data, they should not be accessed in such a direct
744  * manner, since when dealing with GSN meta-transactions the account sending and
745  * paying for execution may not be the actual sender (as far as an application
746  * is concerned).
747  *
748  * This contract is only required for intermediate, library-like contracts.
749  */
750 contract Context {
751   function _msgSender() internal view returns (address payable) {
752     return msg.sender;
753   }
754 
755   function _msgData() internal view returns (bytes memory) {
756     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
757     return msg.data;
758   }
759 }
760 
761 pragma solidity ^0.5.0;
762 
763 /**
764  * @dev Contract module which provides a basic access control mechanism, where
765  * there is an account (an owner) that can be granted exclusive access to
766  * specific functions.
767  *
768  * By default, the owner account will be the one that deploys the contract. This
769  * can later be changed with {transferOwnership}.
770  *
771  * This module is used through inheritance. It will make available the modifier
772  * `onlyOwner`, which can be applied to your functions to restrict their use to
773  * the owner.
774  */
775 contract Ownable is Context {
776   address private _owner;
777 
778   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
779 
780   /**
781      * @dev Initializes the contract setting the deployer as the initial owner.
782      */
783   constructor() internal {
784     address msgSender = _msgSender();
785     _owner = msgSender;
786     emit OwnershipTransferred(address(0), msgSender);
787   }
788 
789   /**
790      * @dev Returns the address of the current owner.
791      */
792   function owner() public view returns (address) {
793     return _owner;
794   }
795 
796   /**
797      * @dev Throws if called by any account other than the owner.
798      */
799   modifier onlyOwner() {
800     require(_owner == _msgSender(), "Ownable: caller is not the owner");
801     _;
802   }
803 
804   /**
805      * @dev Leaves the contract without owner. It will not be possible to call
806      * `onlyOwner` functions anymore. Can only be called by the current owner.
807      *
808      * NOTE: Renouncing ownership will leave the contract without an owner,
809      * thereby removing any functionality that is only available to the owner.
810      */
811   function renounceOwnership() public onlyOwner {
812     emit OwnershipTransferred(_owner, address(0));
813     _owner = address(0);
814   }
815 
816   /**
817      * @dev Transfers ownership of the contract to a new account (`newOwner`).
818      * Can only be called by the current owner.
819      */
820   function transferOwnership(address newOwner) public onlyOwner {
821     require(newOwner != address(0), "Ownable: new owner is the zero address");
822     emit OwnershipTransferred(_owner, newOwner);
823     _owner = newOwner;
824   }
825 }
826 
827 pragma solidity ^0.5.0;
828 
829 /**
830  * @dev Implementation of the {IERC20} interface.
831  *
832  * This implementation is agnostic to the way tokens are created. This means
833  * that a supply mechanism has to be added in a derived contract using {_mint}.
834  * For a generic mechanism see {ERC20PresetMinterPauser}.
835  *
836  * TIP: For a detailed writeup see our guide
837  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
838  * to implement supply mechanisms].
839  *
840  * We have followed general OpenZeppelin guidelines: functions revert instead
841  * of returning `false` on failure. This behavior is nonetheless conventional
842  * and does not conflict with the expectations of ERC20 applications.
843  *
844  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
845  * This allows applications to reconstruct the allowance for all accounts just
846  * by listening to said events. Other implementations of the EIP may not emit
847  * these events, as it isn't required by the specification.
848  *
849  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
850  * functions have been added to mitigate the well-known issues around setting
851  * allowances. See {IERC20-approve}.
852  */
853 contract ERC20 is Context, IERC20 {
854   using SafeMath for uint256;
855   using Address for address;
856 
857   mapping(address => uint256) private _balances;
858 
859   mapping(address => mapping(address => uint256)) private _allowances;
860 
861   uint256 private _totalSupply;
862 
863   string private _name;
864   string private _symbol;
865   uint8 private _decimals;
866 
867   /**
868      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
869      * a default value of 18.
870      *
871      * To select a different value for {decimals}, use {_setupDecimals}.
872      *
873      * All three of these values are immutable: they can only be set once during
874      * construction.
875      */
876   constructor(string memory name, string memory symbol) public {
877     _name = name;
878     _symbol = symbol;
879     _decimals = 18;
880   }
881 
882   /**
883      * @dev Returns the name of the token.
884      */
885   function name() public view returns (string memory) {
886     return _name;
887   }
888 
889   /**
890      * @dev Returns the symbol of the token, usually a shorter version of the
891      * name.
892      */
893   function symbol() public view returns (string memory) {
894     return _symbol;
895   }
896 
897   /**
898      * @dev Returns the number of decimals used to get its user representation.
899      * For example, if `decimals` equals `2`, a balance of `505` tokens should
900      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
901      *
902      * Tokens usually opt for a value of 18, imitating the relationship between
903      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
904      * called.
905      *
906      * NOTE: This information is only used for _display_ purposes: it in
907      * no way affects any of the arithmetic of the contract, including
908      * {IERC20-balanceOf} and {IERC20-transfer}.
909      */
910   function decimals() public view returns (uint8) {
911     return _decimals;
912   }
913 
914   /**
915      * @dev See {IERC20-totalSupply}.
916      */
917   function totalSupply() public view returns (uint256) {
918     return _totalSupply;
919   }
920 
921   /**
922      * @dev See {IERC20-balanceOf}.
923      */
924   function balanceOf(address account) public view returns (uint256) {
925     return _balances[account];
926   }
927 
928   /**
929      * @dev See {IERC20-transfer}.
930      *
931      * Requirements:
932      *
933      * - `recipient` cannot be the zero address.
934      * - the caller must have a balance of at least `amount`.
935      */
936   function transfer(address recipient, uint256 amount) public returns (bool) {
937     _transfer(_msgSender(), recipient, amount);
938     return true;
939   }
940 
941   /**
942      * @dev See {IERC20-allowance}.
943      */
944   function allowance(address owner, address spender) public view returns (uint256) {
945     return _allowances[owner][spender];
946   }
947 
948   /**
949      * @dev See {IERC20-approve}.
950      *
951      * Requirements:
952      *
953      * - `spender` cannot be the zero address.
954      */
955   function approve(address spender, uint256 amount) public returns (bool) {
956     _approve(_msgSender(), spender, amount);
957     return true;
958   }
959 
960   /**
961      * @dev See {IERC20-transferFrom}.
962      *
963      * Emits an {Approval} event indicating the updated allowance. This is not
964      * required by the EIP. See the note at the beginning of {ERC20};
965      *
966      * Requirements:
967      * - `sender` and `recipient` cannot be the zero address.
968      * - `sender` must have a balance of at least `amount`.
969      * - the caller must have allowance for ``sender``'s tokens of at least
970      * `amount`.
971      */
972   function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
973     _transfer(sender, recipient, amount);
974     _approve(
975       sender,
976       _msgSender(),
977       _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
978     );
979     return true;
980   }
981 
982   /**
983      * @dev Atomically increases the allowance granted to `spender` by the caller.
984      *
985      * This is an alternative to {approve} that can be used as a mitigation for
986      * problems described in {IERC20-approve}.
987      *
988      * Emits an {Approval} event indicating the updated allowance.
989      *
990      * Requirements:
991      *
992      * - `spender` cannot be the zero address.
993      */
994   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
995     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
996     return true;
997   }
998 
999   /**
1000      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1001      *
1002      * This is an alternative to {approve} that can be used as a mitigation for
1003      * problems described in {IERC20-approve}.
1004      *
1005      * Emits an {Approval} event indicating the updated allowance.
1006      *
1007      * Requirements:
1008      *
1009      * - `spender` cannot be the zero address.
1010      * - `spender` must have allowance for the caller of at least
1011      * `subtractedValue`.
1012      */
1013   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1014     _approve(
1015       _msgSender(),
1016       spender,
1017       _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
1018     );
1019     return true;
1020   }
1021 
1022   /**
1023      * @dev Moves tokens `amount` from `sender` to `recipient`.
1024      *
1025      * This is internal function is equivalent to {transfer}, and can be used to
1026      * e.g. implement automatic token fees, slashing mechanisms, etc.
1027      *
1028      * Emits a {Transfer} event.
1029      *
1030      * Requirements:
1031      *
1032      * - `sender` cannot be the zero address.
1033      * - `recipient` cannot be the zero address.
1034      * - `sender` must have a balance of at least `amount`.
1035      */
1036   function _transfer(address sender, address recipient, uint256 amount) internal {
1037     require(sender != address(0), "ERC20: transfer from the zero address");
1038     require(recipient != address(0), "ERC20: transfer to the zero address");
1039 
1040     _beforeTokenTransfer(sender, recipient, amount);
1041 
1042     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1043     _balances[recipient] = _balances[recipient].add(amount);
1044     emit Transfer(sender, recipient, amount);
1045   }
1046 
1047   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1048      * the total supply.
1049      *
1050      * Emits a {Transfer} event with `from` set to the zero address.
1051      *
1052      * Requirements
1053      *
1054      * - `to` cannot be the zero address.
1055      */
1056   function _mint(address account, uint256 amount) internal {
1057     require(account != address(0), "ERC20: mint to the zero address");
1058 
1059     _beforeTokenTransfer(address(0), account, amount);
1060 
1061     _totalSupply = _totalSupply.add(amount);
1062     _balances[account] = _balances[account].add(amount);
1063     emit Transfer(address(0), account, amount);
1064   }
1065 
1066   /**
1067      * @dev Destroys `amount` tokens from `account`, reducing the
1068      * total supply.
1069      *
1070      * Emits a {Transfer} event with `to` set to the zero address.
1071      *
1072      * Requirements
1073      *
1074      * - `account` cannot be the zero address.
1075      * - `account` must have at least `amount` tokens.
1076      */
1077   function _burn(address account, uint256 amount) internal {
1078     require(account != address(0), "ERC20: burn from the zero address");
1079 
1080     _beforeTokenTransfer(account, address(0), amount);
1081 
1082     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1083     _totalSupply = _totalSupply.sub(amount);
1084     emit Transfer(account, address(0), amount);
1085   }
1086 
1087   /**
1088      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1089      *
1090      * This is internal function is equivalent to `approve`, and can be used to
1091      * e.g. set automatic allowances for certain subsystems, etc.
1092      *
1093      * Emits an {Approval} event.
1094      *
1095      * Requirements:
1096      *
1097      * - `owner` cannot be the zero address.
1098      * - `spender` cannot be the zero address.
1099      */
1100   function _approve(address owner, address spender, uint256 amount) internal {
1101     require(owner != address(0), "ERC20: approve from the zero address");
1102     require(spender != address(0), "ERC20: approve to the zero address");
1103 
1104     _allowances[owner][spender] = amount;
1105     emit Approval(owner, spender, amount);
1106   }
1107 
1108   /**
1109      * @dev Sets {decimals} to a value other than the default one of 18.
1110      *
1111      * WARNING: This function should only be called from the constructor. Most
1112      * applications that interact with token contracts will not expect
1113      * {decimals} to ever change, and may work incorrectly if it does.
1114      */
1115   function _setupDecimals(uint8 decimals_) internal {
1116     _decimals = decimals_;
1117   }
1118 
1119   /**
1120      * @dev Hook that is called before any transfer of tokens. This includes
1121      * minting and burning.
1122      *
1123      * Calling conditions:
1124      *
1125      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1126      * will be to transferred to `to`.
1127      * - when `from` is zero, `amount` tokens will be minted for `to`.
1128      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1129      * - `from` and `to` are never both zero.
1130      *
1131      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1132      */
1133   function _beforeTokenTransfer(address from, address to, uint256 amount) internal {}
1134 }
1135 
1136 pragma solidity ^0.5.0;
1137 
1138 // SoulToken with Governance.
1139 contract SoulToken is ERC20("https://devil.finance/", "$SOUL"), Ownable {
1140   /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (DevilContract).
1141   function mint(address _to, uint256 _amount) public onlyOwner {
1142     _mint(_to, _amount);
1143     _moveDelegates(address(0), _delegates[_to], _amount);
1144   }
1145 
1146   /// @notice Burns token from message sender. Callable by anyone.
1147   function burn(uint256 _amount) public {
1148     _burn(msg.sender, _amount);
1149   }
1150 
1151   // Copied and modified from YAM code:
1152   // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1153   // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1154   // Which is copied and modified from COMPOUND:
1155   // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1156 
1157   /// @notice A record of each accounts delegate
1158   mapping(address => address) internal _delegates;
1159 
1160   /// @notice A checkpoint for marking number of votes from a given block
1161   struct Checkpoint {
1162     uint32 fromBlock;
1163     uint256 votes;
1164   }
1165 
1166   /// @notice A record of votes checkpoints for each account, by index
1167   mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1168 
1169   /// @notice The number of checkpoints for each account
1170   mapping(address => uint32) public numCheckpoints;
1171 
1172   /// @notice The EIP-712 typehash for the contract's domain
1173   bytes32 public constant DOMAIN_TYPEHASH = keccak256(
1174     "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
1175   );
1176 
1177   /// @notice The EIP-712 typehash for the delegation struct used by the contract
1178   bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1179 
1180   /// @notice A record of states for signing / validating signatures
1181   mapping(address => uint256) public nonces;
1182 
1183   /// @notice An event thats emitted when an account changes its delegate
1184   event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1185 
1186   /// @notice An event thats emitted when a delegate account's vote balance changes
1187   event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1188 
1189   /**
1190      * @notice Delegate votes from `msg.sender` to `delegatee`
1191      * @param delegator The address to get delegatee for
1192      */
1193   function delegates(address delegator) external view returns (address) {
1194     return _delegates[delegator];
1195   }
1196 
1197   /**
1198     * @notice Delegate votes from `msg.sender` to `delegatee`
1199     * @param delegatee The address to delegate votes to
1200     */
1201   function delegate(address delegatee) external {
1202     return _delegate(msg.sender, delegatee);
1203   }
1204 
1205   /**
1206      * @notice Delegates votes from signatory to `delegatee`
1207      * @param delegatee The address to delegate votes to
1208      * @param nonce The contract state required to match the signature
1209      * @param expiry The time at which to expire the signature
1210      * @param v The recovery byte of the signature
1211      * @param r Half of the ECDSA signature pair
1212      * @param s Half of the ECDSA signature pair
1213      */
1214   function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) external {
1215     bytes32 domainSeparator = keccak256(
1216       abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), getChainId(), address(this))
1217     );
1218 
1219     bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
1220 
1221     bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1222 
1223     address signatory = ecrecover(digest, v, r, s);
1224     require(signatory != address(0), "SOUL::delegateBySig: invalid signature");
1225     require(nonce == nonces[signatory]++, "SOUL::delegateBySig: invalid nonce");
1226     require(now <= expiry, "SOUL::delegateBySig: signature expired");
1227     return _delegate(signatory, delegatee);
1228   }
1229 
1230   /**
1231      * @notice Gets the current votes balance for `account`
1232      * @param account The address to get votes balance
1233      * @return The number of current votes for `account`
1234      */
1235   function getCurrentVotes(address account) external view returns (uint256) {
1236     uint32 nCheckpoints = numCheckpoints[account];
1237     return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1238   }
1239 
1240   /**
1241      * @notice Determine the prior number of votes for an account as of a block number
1242      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1243      * @param account The address of the account to check
1244      * @param blockNumber The block number to get the vote balance at
1245      * @return The number of votes the account had as of the given block
1246      */
1247   function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {
1248     require(blockNumber < block.number, "SOUL::getPriorVotes: not yet determined");
1249 
1250     uint32 nCheckpoints = numCheckpoints[account];
1251     if (nCheckpoints == 0) {
1252       return 0;
1253     }
1254 
1255     // First check most recent balance
1256     if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1257       return checkpoints[account][nCheckpoints - 1].votes;
1258     }
1259 
1260     // Next check implicit zero balance
1261     if (checkpoints[account][0].fromBlock > blockNumber) {
1262       return 0;
1263     }
1264 
1265     uint32 lower = 0;
1266     uint32 upper = nCheckpoints - 1;
1267     while (upper > lower) {
1268       uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1269       Checkpoint memory cp = checkpoints[account][center];
1270       if (cp.fromBlock == blockNumber) {
1271         return cp.votes;
1272       } else if (cp.fromBlock < blockNumber) {
1273         lower = center;
1274       } else {
1275         upper = center - 1;
1276       }
1277     }
1278     return checkpoints[account][lower].votes;
1279   }
1280 
1281   function _delegate(address delegator, address delegatee) internal {
1282     address currentDelegate = _delegates[delegator];
1283     uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SOULs (not scaled);
1284     _delegates[delegator] = delegatee;
1285 
1286     emit DelegateChanged(delegator, currentDelegate, delegatee);
1287 
1288     _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1289   }
1290 
1291   function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1292     if (srcRep != dstRep && amount > 0) {
1293       if (srcRep != address(0)) {
1294         // decrease old representative
1295         uint32 srcRepNum = numCheckpoints[srcRep];
1296         uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1297         uint256 srcRepNew = srcRepOld.sub(amount);
1298         _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1299       }
1300 
1301       if (dstRep != address(0)) {
1302         // increase new representative
1303         uint32 dstRepNum = numCheckpoints[dstRep];
1304         uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1305         uint256 dstRepNew = dstRepOld.add(amount);
1306         _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1307       }
1308     }
1309   }
1310 
1311   function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {
1312     uint32 blockNumber = safe32(block.number, "SOUL::_writeCheckpoint: block number exceeds 32 bits");
1313 
1314     if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1315       checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1316     } else {
1317       checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1318       numCheckpoints[delegatee] = nCheckpoints + 1;
1319     }
1320 
1321     emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1322   }
1323 
1324   function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
1325     require(n < 2**32, errorMessage);
1326     return uint32(n);
1327   }
1328 
1329   function getChainId() internal pure returns (uint256) {
1330     uint256 chainId;
1331     assembly {
1332       chainId := chainid
1333     }
1334     return chainId;
1335   }
1336 }
1337 
1338 pragma solidity ^0.5.0;
1339 
1340 contract DevilContract is Ownable {
1341   using SafeMath for uint256;
1342   using SafeERC20 for IERC20;
1343 
1344   // Info of each user.
1345   struct UserInfo {
1346     uint256 amount; // How many LP tokens the user has provided.
1347     uint256 rewardDebt; // Reward debt. See explanation below.
1348     //
1349     // We do some fancy math here. Basically, any point in time, the amount of SOULs
1350     // entitled to a user but is pending to be distributed is:
1351     //
1352     //   pending reward = (user.amount * pool.accSoulPerShare) - user.rewardDebt
1353     //
1354     // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1355     //   1. The pool's `accSoulPerShare` (and `lastRewardBlock`) gets updated.
1356     //   2. User receives the pending reward sent to his/her address.
1357     //   3. User's `amount` gets updated.
1358     //   4. User's `rewardDebt` gets updated.
1359   }
1360 
1361   // Info of each pool.
1362   struct PoolInfo {
1363     IERC20 lpToken; // Address of LP token contract.
1364     uint256 allocPoint; // How many allocation points assigned to this pool. SOULs to distribute per block.
1365     uint256 lastRewardBlock; // Last block number that SOULs distribution occurs.
1366     uint256 accSoulPerShare; // Accumulated SOULs per share, times 1e12. See below.
1367   }
1368 
1369   // The SOUL TOKEN!
1370   SoulToken public soul;
1371   // Block number when bonus SOUL period ends.
1372   uint256 public bonusEndBlock;
1373   // SOUL tokens created per block.
1374   uint256 public soulPerBlock;
1375   // Bonus muliplier for early soul makers.
1376   uint256 public constant BONUS_MULTIPLIER = 10;
1377   // Block number when user can withdraw full amount of SOUL
1378   uint256 public bondingEndBlock;
1379 
1380   // Info of each pool.
1381   PoolInfo[] public poolInfo;
1382   // Info of each user that stakes LP tokens.
1383   mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1384   // Total allocation poitns. Must be the sum of all allocation points in all pools.
1385   uint256 public totalAllocPoint = 0;
1386   // The block number when SOUL mining starts.
1387   uint256 public startBlock;
1388 
1389   event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1390   event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1391   event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1392 
1393   constructor(
1394     SoulToken _soul,
1395     uint256 _soulPerBlock,
1396     uint256 _startBlock,
1397     uint256 _bonusEndBlock,
1398     uint256 _bondingEndBlock
1399   ) public {
1400     soul = _soul;
1401     soulPerBlock = _soulPerBlock;
1402     bonusEndBlock = _bonusEndBlock;
1403     startBlock = _startBlock;
1404     bondingEndBlock = _bondingEndBlock;
1405   }
1406 
1407   function poolLength() external view returns (uint256) {
1408     return poolInfo.length;
1409   }
1410 
1411   // Add a new lp to the pool. Can only be called by the owner.
1412   // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1413   function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1414     require(_allocPoint > 0, "Allocation points cannot be negative");
1415     if (_withUpdate) {
1416       massUpdatePools();
1417     }
1418     uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1419     totalAllocPoint = totalAllocPoint.add(_allocPoint);
1420     poolInfo.push(
1421       PoolInfo({lpToken: _lpToken, allocPoint: _allocPoint, lastRewardBlock: lastRewardBlock, accSoulPerShare: 0})
1422     );
1423   }
1424 
1425   // Update the given pool's SOUL allocation point. Can only be called by the owner.
1426   function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1427     require(_allocPoint > 0, "Allocation points cannot be negative");
1428     if (_withUpdate) {
1429       massUpdatePools();
1430     }
1431     totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1432     poolInfo[_pid].allocPoint = _allocPoint;
1433   }
1434 
1435   // Return reward multiplier over the given _from to _to block.
1436   function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1437     if (_to <= bonusEndBlock) {
1438       return _to.sub(_from).mul(BONUS_MULTIPLIER);
1439     } else if (_from >= bonusEndBlock) {
1440       return _to.sub(_from);
1441     } else {
1442       return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(_to.sub(bonusEndBlock));
1443     }
1444   }
1445 
1446   // View function to see pending SOULs on frontend.
1447   function pendingSoul(uint256 _pid, address _user) external view returns (uint256) {
1448     PoolInfo storage pool = poolInfo[_pid];
1449     UserInfo storage user = userInfo[_pid][_user];
1450     uint256 accSoulPerShare = pool.accSoulPerShare;
1451     uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1452     if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1453       uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1454       uint256 soulReward = multiplier.mul(soulPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1455       accSoulPerShare = accSoulPerShare.add(soulReward.mul(1e12).div(lpSupply));
1456     }
1457     return user.amount.mul(accSoulPerShare).div(1e12).sub(user.rewardDebt);
1458   }
1459 
1460   // Update reward variables for all pools. Be careful of gas spending!
1461   function massUpdatePools() public {
1462     uint256 length = poolInfo.length;
1463     for (uint256 pid = 0; pid < length; ++pid) {
1464       updatePool(pid);
1465     }
1466   }
1467 
1468   // Restrict access to pools, but may not alter the first 7 pools
1469   function poolAccess(uint256 _pid) public onlyOwner {
1470     require(_pid >= 6, "First 7 pools are reserved");
1471     require(block.number >= bonusEndBlock, "Cannot reduce pool before bonusEndBlock");
1472     poolInfo.length = _pid;
1473   }
1474 
1475   // Recalculate all pool allocation points to sync alloc point for visible pools, callable by anyone
1476   function sync() public {
1477     totalAllocPoint = 0;
1478     for (uint256 pid = 0; pid < poolInfo.length; ++pid) {
1479       PoolInfo storage pool = poolInfo[pid];
1480       totalAllocPoint += pool.allocPoint;
1481     }
1482   }
1483 
1484   // Get amount of SOUL withdrawable based on tethered factor
1485   // ie when progress = 10% & _amount = 10000
1486   // ratio = 0.1 * 1e4 = 1000
1487   // tethered factor =  10000 * 1000 * 1000 * 1000 / 1e12 = 10
1488   // one can withdraw 10 out of 10000 $SOUL token
1489   function tetheredFactor(uint256 _amount) public view returns (uint256) {
1490     if (block.number >= bondingEndBlock) {
1491       return _amount;
1492     } else if (block.number < startBlock) {
1493       return 0;
1494     } else {
1495       uint256 progress = block.number - startBlock;
1496       uint256 total = bondingEndBlock - startBlock;
1497       uint256 ratio = progress.mul(1e4).div(total);
1498       return _amount.mul(ratio).mul(ratio).mul(ratio).div(1e12);
1499     }
1500   }
1501 
1502   // Update reward variables of the given pool to be up-to-date.
1503   function updatePool(uint256 _pid) public {
1504     PoolInfo storage pool = poolInfo[_pid];
1505     if (block.number <= pool.lastRewardBlock) {
1506       return;
1507     }
1508     uint256 lpSupply = pool.lpToken.balanceOf(address(this)); // 1e18
1509     if (lpSupply == 0) {
1510       pool.lastRewardBlock = block.number;
1511       return;
1512     }
1513     uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number); // 10
1514     uint256 soulReward = multiplier.mul(soulPerBlock).mul(pool.allocPoint).div(totalAllocPoint); // soulperblock = 1e18
1515     soul.mint(address(this), soulReward);
1516     pool.accSoulPerShare = pool.accSoulPerShare.add(soulReward.mul(1e12).div(lpSupply)); // 1e18 * 1e12 / 1e18
1517     pool.lastRewardBlock = block.number;
1518   }
1519 
1520   // Deposit LP tokens to DevilContract for SOUL allocation.
1521   function deposit(uint256 _pid, uint256 _amount) public {
1522     PoolInfo storage pool = poolInfo[_pid];
1523     UserInfo storage user = userInfo[_pid][msg.sender];
1524     updatePool(_pid);
1525     if (user.amount > 0) {
1526       uint256 pending = user.amount.mul(pool.accSoulPerShare).div(1e12).sub(user.rewardDebt);
1527       uint256 withdrawable = tetheredFactor(pending);
1528       uint256 burnt = pending - withdrawable;
1529       safeSoulTransfer(msg.sender, withdrawable);
1530       safeSoulBurn(burnt);
1531     }
1532     pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1533     user.amount = user.amount.add(_amount);
1534     user.rewardDebt = user.amount.mul(pool.accSoulPerShare).div(1e12);
1535     emit Deposit(msg.sender, _pid, _amount);
1536   }
1537 
1538   // Withdraw LP tokens from DevilContract.
1539   function withdraw(uint256 _pid, uint256 _amount) public {
1540     PoolInfo storage pool = poolInfo[_pid];
1541     UserInfo storage user = userInfo[_pid][msg.sender];
1542     require(user.amount >= _amount, "withdraw: not good");
1543     updatePool(_pid);
1544     uint256 pending = user.amount.mul(pool.accSoulPerShare).div(1e12).sub(user.rewardDebt);
1545     uint256 withdrawable = tetheredFactor(pending);
1546     uint256 burnt = pending - withdrawable;
1547     safeSoulTransfer(msg.sender, withdrawable);
1548     safeSoulBurn(burnt);
1549     user.amount = user.amount.sub(_amount);
1550     user.rewardDebt = user.amount.mul(pool.accSoulPerShare).div(1e12);
1551     pool.lpToken.safeTransfer(address(msg.sender), _amount);
1552     emit Withdraw(msg.sender, _pid, _amount);
1553   }
1554 
1555   // Withdraw without caring about rewards. EMERGENCY ONLY.
1556   function emergencyWithdraw(uint256 _pid) public {
1557     PoolInfo storage pool = poolInfo[_pid];
1558     UserInfo storage user = userInfo[_pid][msg.sender];
1559     pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1560     emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1561     user.amount = 0;
1562     user.rewardDebt = 0;
1563   }
1564 
1565   // Safe soul burn function, just in case if rounding error causes pool to not have enough SOULs.
1566   function safeSoulBurn(uint256 _amount) internal {
1567     uint256 soulBal = soul.balanceOf(address(this));
1568     if (_amount > soulBal) {
1569       soul.burn(soulBal);
1570     } else {
1571       soul.burn(_amount);
1572     }
1573   }
1574 
1575   // Safe soul transfer function, just in case if rounding error causes pool to not have enough SOULs.
1576   function safeSoulTransfer(address _to, uint256 _amount) internal {
1577     uint256 soulBal = soul.balanceOf(address(this));
1578     if (_amount > soulBal) {
1579       soul.transfer(_to, soulBal);
1580     } else {
1581       soul.transfer(_to, _amount);
1582     }
1583   }
1584 }