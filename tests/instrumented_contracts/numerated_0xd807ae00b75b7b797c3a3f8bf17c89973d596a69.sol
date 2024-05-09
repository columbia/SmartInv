1 // SDOGE is forked from SUSHI. Thx, SUSHI.
2 
3 // Official website: https://sdoge.org/
4 
5 /*
6 ..........................((........................................./####,........
7 ........................./(##(.....................................######(#/.......
8 ........................//(####(................................/########((#.......
9 ........................//((#####(...........................*(#############.......
10 ......................../(((/+***+////////+*********+/////+//(#######%%%%%%%#......
11 .......................*******************************+/////(####(##%%%%%%%%#......
12 ...................,***********************************+//((####((###%%%%%%%#......
13 .................,********,*****+/////+*****************+/((#########%&&&&%##......
14 .............,**,******,..,***+///(/+**************+////////((((####%&&&&&%##......
15 ...........,********,,,,.,,,*+///+******,*****+///////////////(((((###%%%###/......
16 ..........****+/+///+*,,,,,+////////+*,,,,**+////////////////((((((((#######,......
17 ........,****+//&&/%&@&*,+///+*+///+***,,,,,,*+/////////////(/((((((((((#####,.....
18 .......*,...,,*&#/&@@@@*,***+/++////+****+///++///////(//////((((((((((((((###*....
19 ......,.   ...,*%#&&&&*,****+////((//+//@@(%&@@@(////(((((///((((((((((((((((##,...
20 ......      .,,,,+/+*****+////////((((&@//@&@@@&@@#(((((((//((((((((((((((((((#(...
21 ..... ..     .,,*********+/////////(((%&((&&&@&&&%#((////////(((((((((((((((((((,..
22 .............,,,********+///+///////((((((((//////((((((//////((((((((((((((((((/..
23 ..........*&%#(##%%%#(*+///////////(((/////////(((((((//////(((////////((((((((((..
24 .........,&@&&&&&&&&&&&&///++///////(///+****+/+****+//////////////(///((((((((((..
25 ..,,...,**(@@&@@&@@@@&&(//+**+//////////+***,*******+//////////(((/((((((((((((((..
26 ..*,,,,+/(##&&&@@@@@@##///////////////(////+******+///////////(////((((#(((((((((..
27 .....,*,,/(%%%&@&&%%####((((/(#(//////////////++///////////////((((((((((((((((((..
28 .....,**+/(%%&@@@&&%%%##(#((((((///(//////////////////////(/(((((((((((((((((((((..
29 ...,.,,,,,,&&&@@@@@@@@@&%#(((((((((((((((((((//////////((/(/((//((((((((((((((((...
30 ....,,,,,*+/#%&&&&&&&&&%&&%%%%&&%&&%%%#(((((((((///(///(((((((/(/((((((((((((((*...
31 ....,,,,,+////(##((((((((((((((((((##((((((((((((((((((/((((((((((((((((((((((/....
32 .....,,,,*+//////((((((((((((((((((((((((((((((((((((((((((((((((((((((((#((((.....
33 .......,,**+///+*(((((((((((((((((((####((((((((((((((((((((((((((((((((((((*......
34 ........,**+/////((((((((((############(###(((((((((((((((((((((((((((#((((........
35 ..........,*+//(((((((((((((###########(((##(((((((((((//((/((((((((####(..........
36 ..............//(((((((((((((((#######((((((((((((((((((((((((((#####(.............
37 ..................*(((((((((((((###(###((((((((((((((((((########(*,...............
38 .......................,####((((##########((((((((((#########(.....................
39 ...............................*#############((########(*..........................
40                                                                         Woof! Woof!
41 */
42 
43 pragma solidity 0.6.12;
44 
45 /**
46  * @dev Interface of the ERC20 standard as defined in the EIP.
47  */
48 interface IERC20 {
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60      * @dev Moves `amount` tokens from the caller's account to `recipient`.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Returns the remaining number of tokens that `spender` will be
70      * allowed to spend on behalf of `owner` through {transferFrom}. This is
71      * zero by default.
72      *
73      * This value changes when {approve} or {transferFrom} are called.
74      */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `sender` to `recipient` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 // File: @openzeppelin/contracts/math/SafeMath.sol
120 
121 
122 /**
123  * @dev Wrappers over Solidity's arithmetic operations with added overflow
124  * checks.
125  *
126  * Arithmetic operations in Solidity wrap on overflow. This can easily result
127  * in bugs, because programmers usually assume that an overflow raises an
128  * error, which is the standard behavior in high level programming languages.
129  * `SafeMath` restores this intuition by reverting the transaction when an
130  * operation overflows.
131  *
132  * Using this library instead of the unchecked operations eliminates an entire
133  * class of bugs, so it's recommended to use it always.
134  */
135 library SafeMath {
136     /**
137      * @dev Returns the addition of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `+` operator.
141      *
142      * Requirements:
143      *
144      * - Addition cannot overflow.
145      */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         require(c >= a, "SafeMath: addition overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         return sub(a, b, "SafeMath: subtraction overflow");
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
175      * - Subtraction cannot overflow.
176      */
177     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b <= a, errorMessage);
179         uint256 c = a - b;
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
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
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         return div(a, b, "SafeMath: division by zero");
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b > 0, errorMessage);
238         uint256 c = a / b;
239         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return mod(a, b, "SafeMath: modulo by zero");
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * Reverts with custom message when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b != 0, errorMessage);
274         return a % b;
275     }
276 }
277 
278 // File: @openzeppelin/contracts/utils/Address.sol
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
303         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
304         // for accounts without code, i.e. `keccak256('')`
305         bytes32 codehash;
306         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { codehash := extcodehash(account) }
309         return (codehash != accountHash && codehash != 0x0);
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332         (bool success, ) = recipient.call{ value: amount }("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain`call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355       return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
365         return _functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         return _functionCallWithValue(target, data, value, errorMessage);
392     }
393 
394     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
395         require(isContract(target), "Address: call to non-contract");
396 
397         // solhint-disable-next-line avoid-low-level-calls
398         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 // solhint-disable-next-line no-inline-assembly
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
419 
420 
421 /**
422  * @title SafeERC20
423  * @dev Wrappers around ERC20 operations that throw on failure (when the token
424  * contract returns false). Tokens that return no value (and instead revert or
425  * throw on failure) are also supported, non-reverting calls are assumed to be
426  * successful.
427  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
428  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
429  */
430 library SafeERC20 {
431     using SafeMath for uint256;
432     using Address for address;
433 
434     function safeTransfer(IERC20 token, address to, uint256 value) internal {
435         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
436     }
437 
438     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
439         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
440     }
441 
442     /**
443      * @dev Deprecated. This function has issues similar to the ones found in
444      * {IERC20-approve}, and its usage is discouraged.
445      *
446      * Whenever possible, use {safeIncreaseAllowance} and
447      * {safeDecreaseAllowance} instead.
448      */
449     function safeApprove(IERC20 token, address spender, uint256 value) internal {
450         // safeApprove should only be called when setting an initial allowance,
451         // or when resetting it to zero. To increase and decrease it, use
452         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
453         // solhint-disable-next-line max-line-length
454         require((value == 0) || (token.allowance(address(this), spender) == 0),
455             "SafeERC20: approve from non-zero to non-zero allowance"
456         );
457         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
458     }
459 
460     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).add(value);
462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
467         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     /**
471      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
472      * on the return value: the return value is optional (but if data is returned, it must not be false).
473      * @param token The token targeted by the call.
474      * @param data The call data (encoded using abi.encode or one of its variants).
475      */
476     function _callOptionalReturn(IERC20 token, bytes memory data) private {
477         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
478         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
479         // the target address contains contract code and also asserts for success in the low-level call.
480 
481         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
482         if (returndata.length > 0) { // Return data is optional
483             // solhint-disable-next-line max-line-length
484             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
485         }
486     }
487 }
488 
489 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
490 
491 
492 /**
493  * @dev Library for managing
494  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
495  * types.
496  *
497  * Sets have the following properties:
498  *
499  * - Elements are added, removed, and checked for existence in constant time
500  * (O(1)).
501  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
502  *
503  * ```
504  * contract Example {
505  *     // Add the library methods
506  *     using EnumerableSet for EnumerableSet.AddressSet;
507  *
508  *     // Declare a set state variable
509  *     EnumerableSet.AddressSet private mySet;
510  * }
511  * ```
512  *
513  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
514  * (`UintSet`) are supported.
515  */
516 library EnumerableSet {
517     // To implement this library for multiple types with as little code
518     // repetition as possible, we write it in terms of a generic Set type with
519     // bytes32 values.
520     // The Set implementation uses private functions, and user-facing
521     // implementations (such as AddressSet) are just wrappers around the
522     // underlying Set.
523     // This means that we can only create new EnumerableSets for types that fit
524     // in bytes32.
525 
526     struct Set {
527         // Storage of set values
528         bytes32[] _values;
529 
530         // Position of the value in the `values` array, plus 1 because index 0
531         // means a value is not in the set.
532         mapping (bytes32 => uint256) _indexes;
533     }
534 
535     /**
536      * @dev Add a value to a set. O(1).
537      *
538      * Returns true if the value was added to the set, that is if it was not
539      * already present.
540      */
541     function _add(Set storage set, bytes32 value) private returns (bool) {
542         if (!_contains(set, value)) {
543             set._values.push(value);
544             // The value is stored at length-1, but we add 1 to all indexes
545             // and use 0 as a sentinel value
546             set._indexes[value] = set._values.length;
547             return true;
548         } else {
549             return false;
550         }
551     }
552 
553     /**
554      * @dev Removes a value from a set. O(1).
555      *
556      * Returns true if the value was removed from the set, that is if it was
557      * present.
558      */
559     function _remove(Set storage set, bytes32 value) private returns (bool) {
560         // We read and store the value's index to prevent multiple reads from the same storage slot
561         uint256 valueIndex = set._indexes[value];
562 
563         if (valueIndex != 0) { // Equivalent to contains(set, value)
564             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
565             // the array, and then remove the last element (sometimes called as 'swap and pop').
566             // This modifies the order of the array, as noted in {at}.
567 
568             uint256 toDeleteIndex = valueIndex - 1;
569             uint256 lastIndex = set._values.length - 1;
570 
571             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
572             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
573 
574             bytes32 lastvalue = set._values[lastIndex];
575 
576             // Move the last value to the index where the value to delete is
577             set._values[toDeleteIndex] = lastvalue;
578             // Update the index for the moved value
579             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
580 
581             // Delete the slot where the moved value was stored
582             set._values.pop();
583 
584             // Delete the index for the deleted slot
585             delete set._indexes[value];
586 
587             return true;
588         } else {
589             return false;
590         }
591     }
592 
593     /**
594      * @dev Returns true if the value is in the set. O(1).
595      */
596     function _contains(Set storage set, bytes32 value) private view returns (bool) {
597         return set._indexes[value] != 0;
598     }
599 
600     /**
601      * @dev Returns the number of values on the set. O(1).
602      */
603     function _length(Set storage set) private view returns (uint256) {
604         return set._values.length;
605     }
606 
607    /**
608     * @dev Returns the value stored at position `index` in the set. O(1).
609     *
610     * Note that there are no guarantees on the ordering of values inside the
611     * array, and it may change when more values are added or removed.
612     *
613     * Requirements:
614     *
615     * - `index` must be strictly less than {length}.
616     */
617     function _at(Set storage set, uint256 index) private view returns (bytes32) {
618         require(set._values.length > index, "EnumerableSet: index out of bounds");
619         return set._values[index];
620     }
621 
622     // AddressSet
623 
624     struct AddressSet {
625         Set _inner;
626     }
627 
628     /**
629      * @dev Add a value to a set. O(1).
630      *
631      * Returns true if the value was added to the set, that is if it was not
632      * already present.
633      */
634     function add(AddressSet storage set, address value) internal returns (bool) {
635         return _add(set._inner, bytes32(uint256(value)));
636     }
637 
638     /**
639      * @dev Removes a value from a set. O(1).
640      *
641      * Returns true if the value was removed from the set, that is if it was
642      * present.
643      */
644     function remove(AddressSet storage set, address value) internal returns (bool) {
645         return _remove(set._inner, bytes32(uint256(value)));
646     }
647 
648     /**
649      * @dev Returns true if the value is in the set. O(1).
650      */
651     function contains(AddressSet storage set, address value) internal view returns (bool) {
652         return _contains(set._inner, bytes32(uint256(value)));
653     }
654 
655     /**
656      * @dev Returns the number of values in the set. O(1).
657      */
658     function length(AddressSet storage set) internal view returns (uint256) {
659         return _length(set._inner);
660     }
661 
662    /**
663     * @dev Returns the value stored at position `index` in the set. O(1).
664     *
665     * Note that there are no guarantees on the ordering of values inside the
666     * array, and it may change when more values are added or removed.
667     *
668     * Requirements:
669     *
670     * - `index` must be strictly less than {length}.
671     */
672     function at(AddressSet storage set, uint256 index) internal view returns (address) {
673         return address(uint256(_at(set._inner, index)));
674     }
675 
676 
677     // UintSet
678 
679     struct UintSet {
680         Set _inner;
681     }
682 
683     /**
684      * @dev Add a value to a set. O(1).
685      *
686      * Returns true if the value was added to the set, that is if it was not
687      * already present.
688      */
689     function add(UintSet storage set, uint256 value) internal returns (bool) {
690         return _add(set._inner, bytes32(value));
691     }
692 
693     /**
694      * @dev Removes a value from a set. O(1).
695      *
696      * Returns true if the value was removed from the set, that is if it was
697      * present.
698      */
699     function remove(UintSet storage set, uint256 value) internal returns (bool) {
700         return _remove(set._inner, bytes32(value));
701     }
702 
703     /**
704      * @dev Returns true if the value is in the set. O(1).
705      */
706     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
707         return _contains(set._inner, bytes32(value));
708     }
709 
710     /**
711      * @dev Returns the number of values on the set. O(1).
712      */
713     function length(UintSet storage set) internal view returns (uint256) {
714         return _length(set._inner);
715     }
716 
717    /**
718     * @dev Returns the value stored at position `index` in the set. O(1).
719     *
720     * Note that there are no guarantees on the ordering of values inside the
721     * array, and it may change when more values are added or removed.
722     *
723     * Requirements:
724     *
725     * - `index` must be strictly less than {length}.
726     */
727     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
728         return uint256(_at(set._inner, index));
729     }
730 }
731 
732 // File: @openzeppelin/contracts/GSN/Context.sol
733 
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
759 /**
760  * @dev Contract module which provides a basic access control mechanism, where
761  * there is an account (an owner) that can be granted exclusive access to
762  * specific functions.
763  *
764  * By default, the owner account will be the one that deploys the contract. This
765  * can later be changed with {transferOwnership}.
766  *
767  * This module is used through inheritance. It will make available the modifier
768  * `onlyOwner`, which can be applied to your functions to restrict their use to
769  * the owner.
770  */
771 contract Ownable is Context {
772     address private _owner;
773 
774     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
775 
776     /**
777      * @dev Initializes the contract setting the deployer as the initial owner.
778      */
779     constructor () internal {
780         address msgSender = _msgSender();
781         _owner = msgSender;
782         emit OwnershipTransferred(address(0), msgSender);
783     }
784 
785     /**
786      * @dev Returns the address of the current owner.
787      */
788     function owner() public view returns (address) {
789         return _owner;
790     }
791 
792     /**
793      * @dev Throws if called by any account other than the owner.
794      */
795     modifier onlyOwner() {
796         require(_owner == _msgSender(), "Ownable: caller is not the owner");
797         _;
798     }
799 
800     /**
801      * @dev Leaves the contract without owner. It will not be possible to call
802      * `onlyOwner` functions anymore. Can only be called by the current owner.
803      *
804      * NOTE: Renouncing ownership will leave the contract without an owner,
805      * thereby removing any functionality that is only available to the owner.
806      */
807     function renounceOwnership() public virtual onlyOwner {
808         emit OwnershipTransferred(_owner, address(0));
809         _owner = address(0);
810     }
811 
812     /**
813      * @dev Transfers ownership of the contract to a new account (`newOwner`).
814      * Can only be called by the current owner.
815      */
816     function transferOwnership(address newOwner) public virtual onlyOwner {
817         require(newOwner != address(0), "Ownable: new owner is the zero address");
818         emit OwnershipTransferred(_owner, newOwner);
819         _owner = newOwner;
820     }
821 }
822 
823 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
824 
825 
826 
827 /**
828  * @dev Implementation of the {IERC20} interface.
829  *
830  * This implementation is agnostic to the way tokens are created. This means
831  * that a supply mechanism has to be added in a derived contract using {_mint}.
832  * For a generic mechanism see {ERC20PresetMinterPauser}.
833  *
834  * TIP: For a detailed writeup see our guide
835  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
836  * to implement supply mechanisms].
837  *
838  * We have followed general OpenZeppelin guidelines: functions revert instead
839  * of returning `false` on failure. This behavior is nonetheless conventional
840  * and does not conflict with the expectations of ERC20 applications.
841  *
842  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
843  * This allows applications to reconstruct the allowance for all accounts just
844  * by listening to said events. Other implementations of the EIP may not emit
845  * these events, as it isn't required by the specification.
846  *
847  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
848  * functions have been added to mitigate the well-known issues around setting
849  * allowances. See {IERC20-approve}.
850  */
851 contract ERC20 is Context, IERC20 {
852     using SafeMath for uint256;
853     using Address for address;
854 
855     mapping (address => uint256) private _balances;
856 
857     mapping (address => mapping (address => uint256)) private _allowances;
858 
859     uint256 private _totalSupply;
860 
861     string private _name;
862     string private _symbol;
863     uint8 private _decimals;
864 
865     /**
866      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
867      * a default value of 18.
868      *
869      * To select a different value for {decimals}, use {_setupDecimals}.
870      *
871      * All three of these values are immutable: they can only be set once during
872      * construction.
873      */
874     constructor (string memory name, string memory symbol) public {
875         _name = name;
876         _symbol = symbol;
877         _decimals = 18;
878     }
879 
880     /**
881      * @dev Returns the name of the token.
882      */
883     function name() public view returns (string memory) {
884         return _name;
885     }
886 
887     /**
888      * @dev Returns the symbol of the token, usually a shorter version of the
889      * name.
890      */
891     function symbol() public view returns (string memory) {
892         return _symbol;
893     }
894 
895     /**
896      * @dev Returns the number of decimals used to get its user representation.
897      * For example, if `decimals` equals `2`, a balance of `505` tokens should
898      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
899      *
900      * Tokens usually opt for a value of 18, imitating the relationship between
901      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
902      * called.
903      *
904      * NOTE: This information is only used for _display_ purposes: it in
905      * no way affects any of the arithmetic of the contract, including
906      * {IERC20-balanceOf} and {IERC20-transfer}.
907      */
908     function decimals() public view returns (uint8) {
909         return _decimals;
910     }
911 
912     /**
913      * @dev See {IERC20-totalSupply}.
914      */
915     function totalSupply() public view override returns (uint256) {
916         return _totalSupply;
917     }
918 
919     /**
920      * @dev See {IERC20-balanceOf}.
921      */
922     function balanceOf(address account) public view override returns (uint256) {
923         return _balances[account];
924     }
925 
926     /**
927      * @dev See {IERC20-transfer}.
928      *
929      * Requirements:
930      *
931      * - `recipient` cannot be the zero address.
932      * - the caller must have a balance of at least `amount`.
933      */
934     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
935         _transfer(_msgSender(), recipient, amount);
936         return true;
937     }
938 
939     /**
940      * @dev See {IERC20-allowance}.
941      */
942     function allowance(address owner, address spender) public view virtual override returns (uint256) {
943         return _allowances[owner][spender];
944     }
945 
946     /**
947      * @dev See {IERC20-approve}.
948      *
949      * Requirements:
950      *
951      * - `spender` cannot be the zero address.
952      */
953     function approve(address spender, uint256 amount) public virtual override returns (bool) {
954         _approve(_msgSender(), spender, amount);
955         return true;
956     }
957 
958     /**
959      * @dev See {IERC20-transferFrom}.
960      *
961      * Emits an {Approval} event indicating the updated allowance. This is not
962      * required by the EIP. See the note at the beginning of {ERC20};
963      *
964      * Requirements:
965      * - `sender` and `recipient` cannot be the zero address.
966      * - `sender` must have a balance of at least `amount`.
967      * - the caller must have allowance for ``sender``'s tokens of at least
968      * `amount`.
969      */
970     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
971         _transfer(sender, recipient, amount);
972         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
973         return true;
974     }
975 
976     /**
977      * @dev Atomically increases the allowance granted to `spender` by the caller.
978      *
979      * This is an alternative to {approve} that can be used as a mitigation for
980      * problems described in {IERC20-approve}.
981      *
982      * Emits an {Approval} event indicating the updated allowance.
983      *
984      * Requirements:
985      *
986      * - `spender` cannot be the zero address.
987      */
988     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
989         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
990         return true;
991     }
992 
993     /**
994      * @dev Atomically decreases the allowance granted to `spender` by the caller.
995      *
996      * This is an alternative to {approve} that can be used as a mitigation for
997      * problems described in {IERC20-approve}.
998      *
999      * Emits an {Approval} event indicating the updated allowance.
1000      *
1001      * Requirements:
1002      *
1003      * - `spender` cannot be the zero address.
1004      * - `spender` must have allowance for the caller of at least
1005      * `subtractedValue`.
1006      */
1007     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1008         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1009         return true;
1010     }
1011 
1012     /**
1013      * @dev Moves tokens `amount` from `sender` to `recipient`.
1014      *
1015      * This is internal function is equivalent to {transfer}, and can be used to
1016      * e.g. implement automatic token fees, slashing mechanisms, etc.
1017      *
1018      * Emits a {Transfer} event.
1019      *
1020      * Requirements:
1021      *
1022      * - `sender` cannot be the zero address.
1023      * - `recipient` cannot be the zero address.
1024      * - `sender` must have a balance of at least `amount`.
1025      */
1026     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1027         require(sender != address(0), "ERC20: transfer from the zero address");
1028         require(recipient != address(0), "ERC20: transfer to the zero address");
1029 
1030         _beforeTokenTransfer(sender, recipient, amount);
1031 
1032         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1033         _balances[recipient] = _balances[recipient].add(amount);
1034         emit Transfer(sender, recipient, amount);
1035     }
1036 
1037     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1038      * the total supply.
1039      *
1040      * Emits a {Transfer} event with `from` set to the zero address.
1041      *
1042      * Requirements
1043      *
1044      * - `to` cannot be the zero address.
1045      */
1046     function _mint(address account, uint256 amount) internal virtual {
1047         require(account != address(0), "ERC20: mint to the zero address");
1048 
1049         _beforeTokenTransfer(address(0), account, amount);
1050 
1051         _totalSupply = _totalSupply.add(amount);
1052         _balances[account] = _balances[account].add(amount);
1053         emit Transfer(address(0), account, amount);
1054     }
1055 
1056     /**
1057      * @dev Destroys `amount` tokens from `account`, reducing the
1058      * total supply.
1059      *
1060      * Emits a {Transfer} event with `to` set to the zero address.
1061      *
1062      * Requirements
1063      *
1064      * - `account` cannot be the zero address.
1065      * - `account` must have at least `amount` tokens.
1066      */
1067     function _burn(address account, uint256 amount) internal virtual {
1068         require(account != address(0), "ERC20: burn from the zero address");
1069 
1070         _beforeTokenTransfer(account, address(0), amount);
1071 
1072         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1073         _totalSupply = _totalSupply.sub(amount);
1074         emit Transfer(account, address(0), amount);
1075     }
1076 
1077     /**
1078      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1079      *
1080      * This is internal function is equivalent to `approve`, and can be used to
1081      * e.g. set automatic allowances for certain subsystems, etc.
1082      *
1083      * Emits an {Approval} event.
1084      *
1085      * Requirements:
1086      *
1087      * - `owner` cannot be the zero address.
1088      * - `spender` cannot be the zero address.
1089      */
1090     function _approve(address owner, address spender, uint256 amount) internal virtual {
1091         require(owner != address(0), "ERC20: approve from the zero address");
1092         require(spender != address(0), "ERC20: approve to the zero address");
1093 
1094         _allowances[owner][spender] = amount;
1095         emit Approval(owner, spender, amount);
1096     }
1097 
1098     /**
1099      * @dev Sets {decimals} to a value other than the default one of 18.
1100      *
1101      * WARNING: This function should only be called from the constructor. Most
1102      * applications that interact with token contracts will not expect
1103      * {decimals} to ever change, and may work incorrectly if it does.
1104      */
1105     function _setupDecimals(uint8 decimals_) internal {
1106         _decimals = decimals_;
1107     }
1108 
1109     /**
1110      * @dev Hook that is called before any transfer of tokens. This includes
1111      * minting and burning.
1112      *
1113      * Calling conditions:
1114      *
1115      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1116      * will be to transferred to `to`.
1117      * - when `from` is zero, `amount` tokens will be minted for `to`.
1118      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1119      * - `from` and `to` are never both zero.
1120      *
1121      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1122      */
1123     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1124 }
1125 
1126 // File: contracts/SDogeToken.sol
1127 
1128 
1129 
1130 
1131 
1132 
1133 // SDogeToken with Governance.
1134 contract SDogeToken is ERC20("SDogeToken", "SDOGE"), Ownable {
1135     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (SDogeMaster).
1136     function mint(address _to, uint256 _amount) public onlyOwner {
1137         _mint(_to, _amount);
1138         _moveDelegates(address(0), _delegates[_to], _amount);
1139     }
1140 
1141     // Copied and modified from YAM code:
1142     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1143     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1144     // Which is copied and modified from COMPOUND:
1145     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1146 
1147     /// @notice A record of each accounts delegate
1148     mapping (address => address) internal _delegates;
1149 
1150     /// @notice A checkpoint for marking number of votes from a given block
1151     struct Checkpoint {
1152         uint32 fromBlock;
1153         uint256 votes;
1154     }
1155 
1156     /// @notice A record of votes checkpoints for each account, by index
1157     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1158 
1159     /// @notice The number of checkpoints for each account
1160     mapping (address => uint32) public numCheckpoints;
1161 
1162     /// @notice The EIP-712 typehash for the contract's domain
1163     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1164 
1165     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1166     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1167 
1168     /// @notice A record of states for signing / validating signatures
1169     mapping (address => uint) public nonces;
1170 
1171       /// @notice An event thats emitted when an account changes its delegate
1172     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1173 
1174     /// @notice An event thats emitted when a delegate account's vote balance changes
1175     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1176 
1177     /**
1178      * @notice Delegate votes from `msg.sender` to `delegatee`
1179      * @param delegator The address to get delegatee for
1180      */
1181     function delegates(address delegator)
1182         external
1183         view
1184         returns (address)
1185     {
1186         return _delegates[delegator];
1187     }
1188 
1189    /**
1190     * @notice Delegate votes from `msg.sender` to `delegatee`
1191     * @param delegatee The address to delegate votes to
1192     */
1193     function delegate(address delegatee) external {
1194         return _delegate(msg.sender, delegatee);
1195     }
1196 
1197     /**
1198      * @notice Delegates votes from signatory to `delegatee`
1199      * @param delegatee The address to delegate votes to
1200      * @param nonce The contract state required to match the signature
1201      * @param expiry The time at which to expire the signature
1202      * @param v The recovery byte of the signature
1203      * @param r Half of the ECDSA signature pair
1204      * @param s Half of the ECDSA signature pair
1205      */
1206     function delegateBySig(
1207         address delegatee,
1208         uint nonce,
1209         uint expiry,
1210         uint8 v,
1211         bytes32 r,
1212         bytes32 s
1213     )
1214         external
1215     {
1216         bytes32 domainSeparator = keccak256(
1217             abi.encode(
1218                 DOMAIN_TYPEHASH,
1219                 keccak256(bytes(name())),
1220                 getChainId(),
1221                 address(this)
1222             )
1223         );
1224 
1225         bytes32 structHash = keccak256(
1226             abi.encode(
1227                 DELEGATION_TYPEHASH,
1228                 delegatee,
1229                 nonce,
1230                 expiry
1231             )
1232         );
1233 
1234         bytes32 digest = keccak256(
1235             abi.encodePacked(
1236                 "\x19\x01",
1237                 domainSeparator,
1238                 structHash
1239             )
1240         );
1241 
1242         address signatory = ecrecover(digest, v, r, s);
1243         require(signatory != address(0), "SDoge::delegateBySig: invalid signature");
1244         require(nonce == nonces[signatory]++, "SDoge::delegateBySig: invalid nonce");
1245         require(now <= expiry, "SDoge::delegateBySig: signature expired");
1246         return _delegate(signatory, delegatee);
1247     }
1248 
1249     /**
1250      * @notice Gets the current votes balance for `account`
1251      * @param account The address to get votes balance
1252      * @return The number of current votes for `account`
1253      */
1254     function getCurrentVotes(address account)
1255         external
1256         view
1257         returns (uint256)
1258     {
1259         uint32 nCheckpoints = numCheckpoints[account];
1260         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1261     }
1262 
1263     /**
1264      * @notice Determine the prior number of votes for an account as of a block number
1265      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1266      * @param account The address of the account to check
1267      * @param blockNumber The block number to get the vote balance at
1268      * @return The number of votes the account had as of the given block
1269      */
1270     function getPriorVotes(address account, uint blockNumber)
1271         external
1272         view
1273         returns (uint256)
1274     {
1275         require(blockNumber < block.number, "SDoge::getPriorVotes: not yet determined");
1276 
1277         uint32 nCheckpoints = numCheckpoints[account];
1278         if (nCheckpoints == 0) {
1279             return 0;
1280         }
1281 
1282         // First check most recent balance
1283         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1284             return checkpoints[account][nCheckpoints - 1].votes;
1285         }
1286 
1287         // Next check implicit zero balance
1288         if (checkpoints[account][0].fromBlock > blockNumber) {
1289             return 0;
1290         }
1291 
1292         uint32 lower = 0;
1293         uint32 upper = nCheckpoints - 1;
1294         while (upper > lower) {
1295             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1296             Checkpoint memory cp = checkpoints[account][center];
1297             if (cp.fromBlock == blockNumber) {
1298                 return cp.votes;
1299             } else if (cp.fromBlock < blockNumber) {
1300                 lower = center;
1301             } else {
1302                 upper = center - 1;
1303             }
1304         }
1305         return checkpoints[account][lower].votes;
1306     }
1307 
1308     function _delegate(address delegator, address delegatee)
1309         internal
1310     {
1311         address currentDelegate = _delegates[delegator];
1312         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SDoges (not scaled);
1313         _delegates[delegator] = delegatee;
1314 
1315         emit DelegateChanged(delegator, currentDelegate, delegatee);
1316 
1317         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1318     }
1319 
1320     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1321         if (srcRep != dstRep && amount > 0) {
1322             if (srcRep != address(0)) {
1323                 // decrease old representative
1324                 uint32 srcRepNum = numCheckpoints[srcRep];
1325                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1326                 uint256 srcRepNew = srcRepOld.sub(amount);
1327                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1328             }
1329 
1330             if (dstRep != address(0)) {
1331                 // increase new representative
1332                 uint32 dstRepNum = numCheckpoints[dstRep];
1333                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1334                 uint256 dstRepNew = dstRepOld.add(amount);
1335                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1336             }
1337         }
1338     }
1339 
1340     function _writeCheckpoint(
1341         address delegatee,
1342         uint32 nCheckpoints,
1343         uint256 oldVotes,
1344         uint256 newVotes
1345     )
1346         internal
1347     {
1348         uint32 blockNumber = safe32(block.number, "SDoge::_writeCheckpoint: block number exceeds 32 bits");
1349 
1350         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1351             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1352         } else {
1353             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1354             numCheckpoints[delegatee] = nCheckpoints + 1;
1355         }
1356 
1357         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1358     }
1359 
1360     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1361         require(n < 2**32, errorMessage);
1362         return uint32(n);
1363     }
1364 
1365     function getChainId() internal pure returns (uint) {
1366         uint256 chainId;
1367         assembly { chainId := chainid() }
1368         return chainId;
1369     }
1370 }
1371 
1372 // File: contracts/SDogeMaster.sol
1373 
1374 interface IMigratorStar {
1375     function migrate(IERC20 token) external returns (IERC20);
1376 }
1377 
1378 // SDogeMaster is the master of SDOGE.
1379 contract SDogeMaster is Ownable {
1380     using SafeMath for uint256;
1381     using SafeERC20 for IERC20;
1382 
1383     // Info of each user.
1384     struct UserInfo {
1385         uint256 amount;     // How many LP tokens the user has provided.
1386         uint256 rewardDebt; // Reward debt. See explanation below.
1387         //
1388         // We do some fancy math here. Basically, any point in time, the amount of SDoges
1389         // entitled to a user but is pending to be distributed is:
1390         //
1391         //   pending reward = (user.amount * pool.accSDogePerShare) - user.rewardDebt
1392         //
1393         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1394         //   1. The pool's `accSDogePerShare` (and `lastRewardBlock`) gets updated.
1395         //   2. User receives the pending reward sent to his/her address.
1396         //   3. User's `amount` gets updated.
1397         //   4. User's `rewardDebt` gets updated.
1398     }
1399 
1400     // Info of each pool.
1401     struct PoolInfo {
1402         IERC20 lpToken;           // Address of LP token contract.
1403         uint256 allocPoint;       // How many allocation points assigned to this pool. SDoges to distribute per block.
1404         uint256 lastRewardBlock;  // Last block number that SDoges distribution occurs.
1405         uint256 accSDogePerShare; // Accumulated SDoges per share, times 1e12. See below.
1406     }
1407 
1408     // The SDoge TOKEN!
1409     SDogeToken public sdoge;
1410     // Dev address.
1411     address public devaddr;
1412     // SDoge tokens created per block.
1413     uint256 public sdogePerBlock;
1414     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1415     IMigratorStar public migrator;
1416 
1417     // Info of each pool.
1418     PoolInfo[] public poolInfo;
1419     // Info of each user that stakes LP tokens.
1420     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1421     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1422     uint256 public totalAllocPoint = 0;
1423     // The block number when SDoge mining starts.
1424     uint256 public startBlock;
1425     // Total farming period in blocks
1426     uint256 public farmPeriod;
1427 
1428     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1429     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1430     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1431 
1432     constructor(
1433         SDogeToken _sdoge,
1434         address _devaddr,	
1435         uint256 _sdogePerBlock,
1436         uint256 _startBlock,
1437         uint256 _farmPeriod
1438     ) public {
1439         sdoge = _sdoge;
1440         devaddr = _devaddr;	
1441         sdogePerBlock = _sdogePerBlock;
1442         startBlock = _startBlock;
1443         farmPeriod = _farmPeriod;
1444     }
1445 
1446     function poolLength() external view returns (uint256) {
1447         return poolInfo.length;
1448     }
1449 
1450     // Add a new lp to the pool. Can only be called by the owner.
1451     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1452     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1453         if (_withUpdate) {
1454             massUpdatePools();
1455         }
1456         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1457         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1458         poolInfo.push(PoolInfo({
1459             lpToken: _lpToken,
1460             allocPoint: _allocPoint,
1461             lastRewardBlock: lastRewardBlock,
1462             accSDogePerShare: 0
1463         }));
1464     }
1465 
1466     // Update the given pool's SDoge allocation point. Can only be called by the owner.
1467     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1468         if (_withUpdate) {
1469             massUpdatePools();
1470         }
1471         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1472         poolInfo[_pid].allocPoint = _allocPoint;
1473     }
1474 
1475     // Set the migrator contract. Can only be called by the owner.
1476     function setMigrator(IMigratorStar _migrator) public onlyOwner {
1477         migrator = _migrator;
1478     }
1479 
1480     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1481     function migrate(uint256 _pid) public {
1482         require(address(migrator) != address(0), "migrate: no migrator");
1483         PoolInfo storage pool = poolInfo[_pid];
1484         IERC20 lpToken = pool.lpToken;
1485         uint256 bal = lpToken.balanceOf(address(this));
1486         lpToken.safeApprove(address(migrator), bal);
1487         IERC20 newLpToken = migrator.migrate(lpToken);
1488         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1489         pool.lpToken = newLpToken;
1490     }
1491 
1492     // Several cases
1493     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1494         uint256 _endBlock = startBlock.add(farmPeriod);
1495         // Some exceptions
1496         if (_from > _to) {
1497             return 0;
1498         }
1499         if (_to < startBlock) {
1500             return 0;
1501         }
1502         if (_from > _endBlock) {
1503             return 0;
1504         }
1505 
1506         // No reward after reward period ends or before the period
1507         if (_to > _endBlock) { 
1508             if (_from > startBlock){
1509                 return _endBlock.sub(_from); // Some portion is left
1510             } else {
1511                 return farmPeriod; // full reward compensation
1512             }
1513             
1514         } else {
1515             if (_from > startBlock){
1516                 return _to.sub(_from);
1517             } else {
1518                 return _to.sub(startBlock);
1519             }
1520             
1521         }
1522     }
1523 
1524     // View function to see pending SDoges on frontend.
1525     function pendingSDoge(uint256 _pid, address _user) external view returns (uint256) {
1526         PoolInfo storage pool = poolInfo[_pid];
1527         UserInfo storage user = userInfo[_pid][_user];
1528         uint256 accSDogePerShare = pool.accSDogePerShare;
1529         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1530         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1531             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1532             uint256 sdogeReward = multiplier.mul(sdogePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1533             accSDogePerShare = accSDogePerShare.add(sdogeReward.mul(1e12).div(lpSupply));
1534         }
1535         return user.amount.mul(accSDogePerShare).div(1e12).sub(user.rewardDebt);
1536     }
1537 
1538     // Update reward vairables for all pools. Be careful of gas spending!
1539     function massUpdatePools() public {
1540         uint256 length = poolInfo.length;
1541         for (uint256 pid = 0; pid < length; ++pid) {
1542             updatePool(pid);
1543         }
1544     }
1545 
1546     // Update reward variables of the given pool to be up-to-date.
1547     function updatePool(uint256 _pid) public {
1548         PoolInfo storage pool = poolInfo[_pid];
1549         if (block.number <= pool.lastRewardBlock) {
1550             return;
1551         }
1552         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1553         if (lpSupply == 0) {
1554             pool.lastRewardBlock = block.number;
1555             return;
1556         }
1557         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1558         uint256 sdogeReward = multiplier.mul(sdogePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1559         
1560         sdoge.mint(address(this), sdogeReward); // no dev fee
1561 
1562         // Marketing strategy, send SDOGE to the following contracts. Woof! Wow!
1563         //
1564         // YFI: 0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e
1565         // MasterChef of SUSHI: 0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd
1566         // MasterChef of PICKLE: 0xbD17B1ce622d73bD438b9E658acA5996dc394b0d
1567         // MEME contract: 0xD5525D397898e5502075Ea5E830d8914f6F0affe
1568         // 
1569         sdoge.mint(address(0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e), sdogeReward.div(10000)); // 0.01%
1570         sdoge.mint(address(0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd), sdogeReward.div(10000)); // 0.01%
1571         sdoge.mint(address(0xbD17B1ce622d73bD438b9E658acA5996dc394b0d), sdogeReward.div(10000)); // 0.01%
1572         sdoge.mint(address(0xD5525D397898e5502075Ea5E830d8914f6F0affe), sdogeReward.div(10000)); // 0.01%
1573 
1574         pool.accSDogePerShare = pool.accSDogePerShare.add(sdogeReward.mul(1e12).div(lpSupply));
1575         pool.lastRewardBlock = block.number;
1576     }
1577 
1578     // Deposit LP tokens to SDogeMaster for SDoge allocation.
1579     function deposit(uint256 _pid, uint256 _amount) public {
1580         PoolInfo storage pool = poolInfo[_pid];
1581         UserInfo storage user = userInfo[_pid][msg.sender];
1582         updatePool(_pid);
1583         if (user.amount > 0) {
1584             uint256 pending = user.amount.mul(pool.accSDogePerShare).div(1e12).sub(user.rewardDebt);
1585             safeSDogeTransfer(msg.sender, pending);
1586         }
1587         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1588         user.amount = user.amount.add(_amount);
1589         user.rewardDebt = user.amount.mul(pool.accSDogePerShare).div(1e12);
1590         emit Deposit(msg.sender, _pid, _amount);
1591     }
1592 
1593     // Withdraw LP tokens from SDogeMaster.
1594     function withdraw(uint256 _pid, uint256 _amount) public {
1595         PoolInfo storage pool = poolInfo[_pid];
1596         UserInfo storage user = userInfo[_pid][msg.sender];
1597         require(user.amount >= _amount, "withdraw: not good");
1598         updatePool(_pid);
1599         uint256 pending = user.amount.mul(pool.accSDogePerShare).div(1e12).sub(user.rewardDebt);
1600         safeSDogeTransfer(msg.sender, pending);
1601         user.amount = user.amount.sub(_amount);
1602         user.rewardDebt = user.amount.mul(pool.accSDogePerShare).div(1e12);
1603         uint256 withdrwalFee = _amount.div(400); // 0.25%
1604         uint256 amountExcludingFee = _amount.sub(withdrwalFee); // 99.75%
1605         pool.lpToken.safeTransfer(address(msg.sender), amountExcludingFee);
1606         pool.lpToken.safeTransfer(devaddr, withdrwalFee);
1607         emit Withdraw(msg.sender, _pid, amountExcludingFee);
1608     }
1609 
1610     // Withdraw without caring about rewards. EMERGENCY ONLY.
1611     function emergencyWithdraw(uint256 _pid) public {
1612         PoolInfo storage pool = poolInfo[_pid];
1613         UserInfo storage user = userInfo[_pid][msg.sender];
1614         uint256 withdrwalFee = (user.amount).div(400); // 0.25%
1615         uint256 amountExcludingFee = (user.amount).sub(withdrwalFee); // 99.75%
1616         pool.lpToken.safeTransfer(address(msg.sender), amountExcludingFee);
1617         pool.lpToken.safeTransfer(devaddr, withdrwalFee);
1618         emit EmergencyWithdraw(msg.sender, _pid, amountExcludingFee);
1619         user.amount = 0;
1620         user.rewardDebt = 0;
1621     }
1622 
1623     // Safe sdoge transfer function, just in case if rounding error causes pool to not have enough SDoges.
1624     function safeSDogeTransfer(address _to, uint256 _amount) internal {
1625         uint256 sdogeBal = sdoge.balanceOf(address(this));
1626         if (_amount > sdogeBal) {
1627             sdoge.transfer(_to, sdogeBal);
1628         } else {
1629             sdoge.transfer(_to, _amount);
1630         }
1631     }
1632 
1633     // Check whether there is reward or not
1634     function checkRewardPeriod() public view returns (bool) {
1635         uint256 _endBlock = startBlock.add(farmPeriod);
1636         if( block.number > startBlock && block.number <= _endBlock ) {
1637             return true;
1638         } else {
1639             return false;
1640         }
1641     }
1642 
1643     // Once time-lock is active following functions are time-locked.
1644 
1645     // Just in case, reward program can be re-opened
1646     function resetStartBlockAndFarmingPeriod(uint256 _start, uint256 _period) public onlyOwner {
1647         startBlock = _start;
1648         farmPeriod = _period;
1649     }
1650     
1651     // Can adjust reward per block
1652     function resetRewardPerBlock(uint256 _reward) public onlyOwner {
1653         sdogePerBlock = _reward;
1654     }
1655 
1656 }