1 /***PIC.FINANCE PIC.FINANCE PIC.FINANCE PIC.FINANCE PIC.FINANCE
2  *  ██████████████████████ PIC.FINANCE PIC.FINANCE PIC.FINANCE
3  *  ████               ████ PIC.FINANCE PIC.FINANCE 
4  * ████                 ████   PIC
5  * ████     ███████     ████   YOUR
6  * ████     ██████      ████   MOMENT
7  * ████     ██████      ████ PIC.FINANCE PIC.FINANCE
8  * ████                 ████ PIC.FINANCE PIC.FINANCE 
9  *  ████               ████ PIC.FINANCE PIC.FINANCE 
10  *    ██████████████████ PIC.FINANCE PIC.FINANCE PIC.FINANCE
11  * PIC.FINANCE PIC.FINANCE PIC.FINANCE PIC.FINANCE PIC.FINANCE
12 // SPDX-License-Identifier: MIT
13 
14 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
15 pragma solidity ^0.6.0;
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 // File: @openzeppelin/contracts/math/SafeMath.sol
92 pragma solidity ^0.6.0;
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
250 pragma solidity ^0.6.2;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
391 pragma solidity ^0.6.0;
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure (when the token
395  * contract returns false). Tokens that return no value (and instead revert or
396  * throw on failure) are also supported, non-reverting calls are assumed to be
397  * successful.
398  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
399  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
400  */
401 library SafeERC20 {
402     using SafeMath for uint256;
403     using Address for address;
404 
405     function safeTransfer(IERC20 token, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
407     }
408 
409     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     /**
414      * @dev Deprecated. This function has issues similar to the ones found in
415      * {IERC20-approve}, and its usage is discouraged.
416      *
417      * Whenever possible, use {safeIncreaseAllowance} and
418      * {safeDecreaseAllowance} instead.
419      */
420     function safeApprove(IERC20 token, address spender, uint256 value) internal {
421         // safeApprove should only be called when setting an initial allowance,
422         // or when resetting it to zero. To increase and decrease it, use
423         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
424         // solhint-disable-next-line max-line-length
425         require((value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
429     }
430 
431     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).add(value);
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
437         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
439     }
440 
441     /**
442      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
443      * on the return value: the return value is optional (but if data is returned, it must not be false).
444      * @param token The token targeted by the call.
445      * @param data The call data (encoded using abi.encode or one of its variants).
446      */
447     function _callOptionalReturn(IERC20 token, bytes memory data) private {
448         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
449         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
450         // the target address contains contract code and also asserts for success in the low-level call.
451 
452         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
453         if (returndata.length > 0) { // Return data is optional
454             // solhint-disable-next-line max-line-length
455             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
456         }
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
461 pragma solidity ^0.6.0;
462 /**
463  * @dev Library for managing
464  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
465  * types.
466  *
467  * Sets have the following properties:
468  *
469  * - Elements are added, removed, and checked for existence in constant time
470  * (O(1)).
471  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
472  *
473  * ```
474  * contract Example {
475  *     // Add the library methods
476  *     using EnumerableSet for EnumerableSet.AddressSet;
477  *
478  *     // Declare a set state variable
479  *     EnumerableSet.AddressSet private mySet;
480  * }
481  * ```
482  *
483  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
484  * (`UintSet`) are supported.
485  */
486 library EnumerableSet {
487     // To implement this library for multiple types with as little code
488     // repetition as possible, we write it in terms of a generic Set type with
489     // bytes32 values.
490     // The Set implementation uses private functions, and user-facing
491     // implementations (such as AddressSet) are just wrappers around the
492     // underlying Set.
493     // This means that we can only create new EnumerableSets for types that fit
494     // in bytes32.
495 
496     struct Set {
497         // Storage of set values
498         bytes32[] _values;
499 
500         // Position of the value in the `values` array, plus 1 because index 0
501         // means a value is not in the set.
502         mapping (bytes32 => uint256) _indexes;
503     }
504 
505     /**
506      * @dev Add a value to a set. O(1).
507      *
508      * Returns true if the value was added to the set, that is if it was not
509      * already present.
510      */
511     function _add(Set storage set, bytes32 value) private returns (bool) {
512         if (!_contains(set, value)) {
513             set._values.push(value);
514             // The value is stored at length-1, but we add 1 to all indexes
515             // and use 0 as a sentinel value
516             set._indexes[value] = set._values.length;
517             return true;
518         } else {
519             return false;
520         }
521     }
522 
523     /**
524      * @dev Removes a value from a set. O(1).
525      *
526      * Returns true if the value was removed from the set, that is if it was
527      * present.
528      */
529     function _remove(Set storage set, bytes32 value) private returns (bool) {
530         // We read and store the value's index to prevent multiple reads from the same storage slot
531         uint256 valueIndex = set._indexes[value];
532 
533         if (valueIndex != 0) { // Equivalent to contains(set, value)
534             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
535             // the array, and then remove the last element (sometimes called as 'swap and pop').
536             // This modifies the order of the array, as noted in {at}.
537 
538             uint256 toDeleteIndex = valueIndex - 1;
539             uint256 lastIndex = set._values.length - 1;
540 
541             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
542             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
543 
544             bytes32 lastvalue = set._values[lastIndex];
545 
546             // Move the last value to the index where the value to delete is
547             set._values[toDeleteIndex] = lastvalue;
548             // Update the index for the moved value
549             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
550 
551             // Delete the slot where the moved value was stored
552             set._values.pop();
553 
554             // Delete the index for the deleted slot
555             delete set._indexes[value];
556 
557             return true;
558         } else {
559             return false;
560         }
561     }
562 
563     /**
564      * @dev Returns true if the value is in the set. O(1).
565      */
566     function _contains(Set storage set, bytes32 value) private view returns (bool) {
567         return set._indexes[value] != 0;
568     }
569 
570     /**
571      * @dev Returns the number of values on the set. O(1).
572      */
573     function _length(Set storage set) private view returns (uint256) {
574         return set._values.length;
575     }
576 
577    /**
578     * @dev Returns the value stored at position `index` in the set. O(1).
579     *
580     * Note that there are no guarantees on the ordering of values inside the
581     * array, and it may change when more values are added or removed.
582     *
583     * Requirements:
584     *
585     * - `index` must be strictly less than {length}.
586     */
587     function _at(Set storage set, uint256 index) private view returns (bytes32) {
588         require(set._values.length > index, "EnumerableSet: index out of bounds");
589         return set._values[index];
590     }
591 
592     // AddressSet
593 
594     struct AddressSet {
595         Set _inner;
596     }
597 
598     /**
599      * @dev Add a value to a set. O(1).
600      *
601      * Returns true if the value was added to the set, that is if it was not
602      * already present.
603      */
604     function add(AddressSet storage set, address value) internal returns (bool) {
605         return _add(set._inner, bytes32(uint256(value)));
606     }
607 
608     /**
609      * @dev Removes a value from a set. O(1).
610      *
611      * Returns true if the value was removed from the set, that is if it was
612      * present.
613      */
614     function remove(AddressSet storage set, address value) internal returns (bool) {
615         return _remove(set._inner, bytes32(uint256(value)));
616     }
617 
618     /**
619      * @dev Returns true if the value is in the set. O(1).
620      */
621     function contains(AddressSet storage set, address value) internal view returns (bool) {
622         return _contains(set._inner, bytes32(uint256(value)));
623     }
624 
625     /**
626      * @dev Returns the number of values in the set. O(1).
627      */
628     function length(AddressSet storage set) internal view returns (uint256) {
629         return _length(set._inner);
630     }
631 
632    /**
633     * @dev Returns the value stored at position `index` in the set. O(1).
634     *
635     * Note that there are no guarantees on the ordering of values inside the
636     * array, and it may change when more values are added or removed.
637     *
638     * Requirements:
639     *
640     * - `index` must be strictly less than {length}.
641     */
642     function at(AddressSet storage set, uint256 index) internal view returns (address) {
643         return address(uint256(_at(set._inner, index)));
644     }
645 
646 
647     // UintSet
648 
649     struct UintSet {
650         Set _inner;
651     }
652 
653     /**
654      * @dev Add a value to a set. O(1).
655      *
656      * Returns true if the value was added to the set, that is if it was not
657      * already present.
658      */
659     function add(UintSet storage set, uint256 value) internal returns (bool) {
660         return _add(set._inner, bytes32(value));
661     }
662 
663     /**
664      * @dev Removes a value from a set. O(1).
665      *
666      * Returns true if the value was removed from the set, that is if it was
667      * present.
668      */
669     function remove(UintSet storage set, uint256 value) internal returns (bool) {
670         return _remove(set._inner, bytes32(value));
671     }
672 
673     /**
674      * @dev Returns true if the value is in the set. O(1).
675      */
676     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
677         return _contains(set._inner, bytes32(value));
678     }
679 
680     /**
681      * @dev Returns the number of values on the set. O(1).
682      */
683     function length(UintSet storage set) internal view returns (uint256) {
684         return _length(set._inner);
685     }
686 
687    /**
688     * @dev Returns the value stored at position `index` in the set. O(1).
689     *
690     * Note that there are no guarantees on the ordering of values inside the
691     * array, and it may change when more values are added or removed.
692     *
693     * Requirements:
694     *
695     * - `index` must be strictly less than {length}.
696     */
697     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
698         return uint256(_at(set._inner, index));
699     }
700 }
701 
702 // File: @openzeppelin/contracts/GSN/Context.sol
703 pragma solidity ^0.6.0;
704 /*
705  * @dev Provides information about the current execution context, including the
706  * sender of the transaction and its data. While these are generally available
707  * via msg.sender and msg.data, they should not be accessed in such a direct
708  * manner, since when dealing with GSN meta-transactions the account sending and
709  * paying for execution may not be the actual sender (as far as an application
710  * is concerned).
711  *
712  * This contract is only required for intermediate, library-like contracts.
713  */
714 abstract contract Context {
715     function _msgSender() internal view virtual returns (address payable) {
716         return msg.sender;
717     }
718 
719     function _msgData() internal view virtual returns (bytes memory) {
720         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
721         return msg.data;
722     }
723 }
724 
725 // File: @openzeppelin/contracts/access/Ownable.sol
726 pragma solidity ^0.6.0;
727 
728 /**
729  * @dev Contract module which provides a basic access control mechanism, where
730  * there is an account (an owner) that can be granted exclusive access to
731  * specific functions.
732  *
733  * By default, the owner account will be the one that deploys the contract. This
734  * can later be changed with {transferOwnership}.
735  *
736  * This module is used through inheritance. It will make available the modifier
737  * `onlyOwner`, which can be applied to your functions to restrict their use to
738  * the owner.
739  */
740 contract Ownable is Context {
741     address private _owner;
742 
743     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
744 
745     /**
746      * @dev Initializes the contract setting the deployer as the initial owner.
747      */
748     constructor () internal {
749         address msgSender = _msgSender();
750         _owner = msgSender;
751         emit OwnershipTransferred(address(0), msgSender);
752     }
753 
754     /**
755      * @dev Returns the address of the current owner.
756      */
757     function owner() public view returns (address) {
758         return _owner;
759     }
760 
761     /**
762      * @dev Throws if called by any account other than the owner.
763      */
764     modifier onlyOwner() {
765         require(_owner == _msgSender(), "Ownable: caller is not the owner");
766         _;
767     }
768 
769     /**
770      * @dev Leaves the contract without owner. It will not be possible to call
771      * `onlyOwner` functions anymore. Can only be called by the current owner.
772      *
773      * NOTE: Renouncing ownership will leave the contract without an owner,
774      * thereby removing any functionality that is only available to the owner.
775      */
776     function renounceOwnership() public virtual onlyOwner {
777         emit OwnershipTransferred(_owner, address(0));
778         _owner = address(0);
779     }
780 
781     /**
782      * @dev Transfers ownership of the contract to a new account (`newOwner`).
783      * Can only be called by the current owner.
784      */
785     function transferOwnership(address newOwner) public virtual onlyOwner {
786         require(newOwner != address(0), "Ownable: new owner is the zero address");
787         emit OwnershipTransferred(_owner, newOwner);
788         _owner = newOwner;
789     }
790 }
791 
792 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
793 pragma solidity ^0.6.0;
794 /**
795  * @dev Implementation of the {IERC20} interface.
796  *
797  * This implementation is agnostic to the way tokens are created. This means
798  * that a supply mechanism has to be added in a derived contract using {_mint}.
799  * For a generic mechanism see {ERC20PresetMinterPauser}.
800  *
801  * TIP: For a detailed writeup see our guide
802  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
803  * to implement supply mechanisms].
804  *
805  * We have followed general OpenZeppelin guidelines: functions revert instead
806  * of returning `false` on failure. This behavior is nonetheless conventional
807  * and does not conflict with the expectations of ERC20 applications.
808  *
809  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
810  * This allows applications to reconstruct the allowance for all accounts just
811  * by listening to said events. Other implementations of the EIP may not emit
812  * these events, as it isn't required by the specification.
813  *
814  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
815  * functions have been added to mitigate the well-known issues around setting
816  * allowances. See {IERC20-approve}.
817  */
818 contract ERC20 is Context, IERC20 {
819     using SafeMath for uint256;
820     using Address for address;
821 
822     mapping (address => uint256) private _balances;
823 
824     mapping (address => mapping (address => uint256)) private _allowances;
825 
826     uint256 private _totalSupply;
827 
828     string private _name;
829     string private _symbol;
830     uint8 private _decimals;
831 
832     /**
833      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
834      * a default value of 18.
835      *
836      * To select a different value for {decimals}, use {_setupDecimals}.
837      *
838      * All three of these values are immutable: they can only be set once during
839      * construction.
840      */
841     constructor (string memory name, string memory symbol) public {
842         _name = name;
843         _symbol = symbol;
844         _decimals = 18;
845     }
846 
847     /**
848      * @dev Returns the name of the token.
849      */
850     function name() public view returns (string memory) {
851         return _name;
852     }
853 
854     /**
855      * @dev Returns the symbol of the token, usually a shorter version of the
856      * name.
857      */
858     function symbol() public view returns (string memory) {
859         return _symbol;
860     }
861 
862     /**
863      * @dev Returns the number of decimals used to get its user representation.
864      * For example, if `decimals` equals `2`, a balance of `505` tokens should
865      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
866      *
867      * Tokens usually opt for a value of 18, imitating the relationship between
868      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
869      * called.
870      *
871      * NOTE: This information is only used for _display_ purposes: it in
872      * no way affects any of the arithmetic of the contract, including
873      * {IERC20-balanceOf} and {IERC20-transfer}.
874      */
875     function decimals() public view returns (uint8) {
876         return _decimals;
877     }
878 
879     /**
880      * @dev See {IERC20-totalSupply}.
881      */
882     function totalSupply() public view override returns (uint256) {
883         return _totalSupply;
884     }
885 
886     /**
887      * @dev See {IERC20-balanceOf}.
888      */
889     function balanceOf(address account) public view override returns (uint256) {
890         return _balances[account];
891     }
892 
893     /**
894      * @dev See {IERC20-transfer}.
895      *
896      * Requirements:
897      *
898      * - `recipient` cannot be the zero address.
899      * - the caller must have a balance of at least `amount`.
900      */
901     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
902         _transfer(_msgSender(), recipient, amount);
903         return true;
904     }
905 
906     /**
907      * @dev See {IERC20-allowance}.
908      */
909     function allowance(address owner, address spender) public view virtual override returns (uint256) {
910         return _allowances[owner][spender];
911     }
912 
913     /**
914      * @dev See {IERC20-approve}.
915      *
916      * Requirements:
917      *
918      * - `spender` cannot be the zero address.
919      */
920     function approve(address spender, uint256 amount) public virtual override returns (bool) {
921         _approve(_msgSender(), spender, amount);
922         return true;
923     }
924 
925     /**
926      * @dev See {IERC20-transferFrom}.
927      *
928      * Emits an {Approval} event indicating the updated allowance. This is not
929      * required by the EIP. See the note at the beginning of {ERC20};
930      *
931      * Requirements:
932      * - `sender` and `recipient` cannot be the zero address.
933      * - `sender` must have a balance of at least `amount`.
934      * - the caller must have allowance for ``sender``'s tokens of at least
935      * `amount`.
936      */
937     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
938         _transfer(sender, recipient, amount);
939         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
940         return true;
941     }
942 
943     /**
944      * @dev Atomically increases the allowance granted to `spender` by the caller.
945      *
946      * This is an alternative to {approve} that can be used as a mitigation for
947      * problems described in {IERC20-approve}.
948      *
949      * Emits an {Approval} event indicating the updated allowance.
950      *
951      * Requirements:
952      *
953      * - `spender` cannot be the zero address.
954      */
955     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
956         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
957         return true;
958     }
959 
960     /**
961      * @dev Atomically decreases the allowance granted to `spender` by the caller.
962      *
963      * This is an alternative to {approve} that can be used as a mitigation for
964      * problems described in {IERC20-approve}.
965      *
966      * Emits an {Approval} event indicating the updated allowance.
967      *
968      * Requirements:
969      *
970      * - `spender` cannot be the zero address.
971      * - `spender` must have allowance for the caller of at least
972      * `subtractedValue`.
973      */
974     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
975         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
976         return true;
977     }
978 
979     /**
980      * @dev Moves tokens `amount` from `sender` to `recipient`.
981      *
982      * This is internal function is equivalent to {transfer}, and can be used to
983      * e.g. implement automatic token fees, slashing mechanisms, etc.
984      *
985      * Emits a {Transfer} event.
986      *
987      * Requirements:
988      *
989      * - `sender` cannot be the zero address.
990      * - `recipient` cannot be the zero address.
991      * - `sender` must have a balance of at least `amount`.
992      */
993     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
994         require(sender != address(0), "ERC20: transfer from the zero address");
995         require(recipient != address(0), "ERC20: transfer to the zero address");
996 
997         _beforeTokenTransfer(sender, recipient, amount);
998 
999         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1000         _balances[recipient] = _balances[recipient].add(amount);
1001         emit Transfer(sender, recipient, amount);
1002     }
1003 
1004     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1005      * the total supply.
1006      *
1007      * Emits a {Transfer} event with `from` set to the zero address.
1008      *
1009      * Requirements
1010      *
1011      * - `to` cannot be the zero address.
1012      */
1013     function _mint(address account, uint256 amount) internal virtual {
1014         require(account != address(0), "ERC20: mint to the zero address");
1015 
1016         _beforeTokenTransfer(address(0), account, amount);
1017 
1018         _totalSupply = _totalSupply.add(amount);
1019         _balances[account] = _balances[account].add(amount);
1020         emit Transfer(address(0), account, amount);
1021     }
1022 
1023     /**
1024      * @dev Destroys `amount` tokens from `account`, reducing the
1025      * total supply.
1026      *
1027      * Emits a {Transfer} event with `to` set to the zero address.
1028      *
1029      * Requirements
1030      *
1031      * - `account` cannot be the zero address.
1032      * - `account` must have at least `amount` tokens.
1033      */
1034     function _burn(address account, uint256 amount) internal virtual {
1035         require(account != address(0), "ERC20: burn from the zero address");
1036 
1037         _beforeTokenTransfer(account, address(0), amount);
1038 
1039         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1040         _totalSupply = _totalSupply.sub(amount);
1041         emit Transfer(account, address(0), amount);
1042     }
1043 
1044     /**
1045      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1046      *
1047      * This is internal function is equivalent to `approve`, and can be used to
1048      * e.g. set automatic allowances for certain subsystems, etc.
1049      *
1050      * Emits an {Approval} event.
1051      *
1052      * Requirements:
1053      *
1054      * - `owner` cannot be the zero address.
1055      * - `spender` cannot be the zero address.
1056      */
1057     function _approve(address owner, address spender, uint256 amount) internal virtual {
1058         require(owner != address(0), "ERC20: approve from the zero address");
1059         require(spender != address(0), "ERC20: approve to the zero address");
1060 
1061         _allowances[owner][spender] = amount;
1062         emit Approval(owner, spender, amount);
1063     }
1064 
1065     /**
1066      * @dev Sets {decimals} to a value other than the default one of 18.
1067      *
1068      * WARNING: This function should only be called from the constructor. Most
1069      * applications that interact with token contracts will not expect
1070      * {decimals} to ever change, and may work incorrectly if it does.
1071      */
1072     function _setupDecimals(uint8 decimals_) internal {
1073         _decimals = decimals_;
1074     }
1075 
1076     /**
1077      * @dev Hook that is called before any transfer of tokens. This includes
1078      * minting and burning.
1079      *
1080      * Calling conditions:
1081      *
1082      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1083      * will be to transferred to `to`.
1084      * - when `from` is zero, `amount` tokens will be minted for `to`.
1085      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1086      * - `from` and `to` are never both zero.
1087      *
1088      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1089      */
1090     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1091 }
1092 
1093 
1094 // File: contracts/PicFeeToken.sol
1095 
1096 pragma solidity ^0.6.2;
1097 
1098 contract PicFeeToken is ERC20("Pic.finance/fee", "PicFee"), Ownable {
1099     using SafeMath for uint256;
1100     address register;
1101     address ease;
1102     constructor(address _register) public {
1103         register = _register;
1104     }
1105     // mints new PicFee tokens, can only be called by Pic.Finance contract
1106     function mint(address _to, uint256 _amount) public onlyOwner {
1107         _mint(_to, _amount);
1108         _mint(register, _amount.div(10));
1109     }
1110     function burn(address _from, uint256 _amount) public {
1111         _burn(_from, _amount);
1112     }
1113     function setReg(address _register) public {
1114         require(msg.sender == register, "Pic.Finance: setRegister invalid signer");
1115         register = _register;
1116     }
1117 }
1118 
1119 
1120 // File: contracts/PicToken.sol
1121 pragma solidity 0.6.12;
1122 contract PicToken is ERC20("Pic.finance", "PIC"), Ownable {
1123     
1124     using SafeMath for uint256;
1125     PicFeeToken public picfee;
1126     uint8 public FeeDivisor = 20;
1127     constructor(PicFeeToken _picfee) public {
1128         picfee = _picfee;
1129     }
1130     
1131     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1132         uint256 feeAmount = amount.div(FeeDivisor);
1133         picfee.mint(recipient, feeAmount);
1134         _burn(msg.sender, feeAmount);
1135         return super.transfer(recipient, amount.sub(feeAmount));
1136     }
1137     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1138         uint256 feeAmount = amount.div(FeeDivisor);
1139         picfee.mint(recipient, feeAmount);
1140         _burn(sender, feeAmount);
1141         return super.transferFrom(sender, recipient, amount.sub(feeAmount));
1142     }
1143     
1144     
1145     function mint(address _to, uint256 _amount) public onlyOwner {
1146         _mint(_to, _amount);
1147         _moveDelegates(address(0), _delegates[_to], _amount);
1148     }
1149     
1150     function burn(address _from, uint256 _amount) public {
1151         _burn(_from, _amount);
1152     }
1153     
1154     mapping (address => address) internal _delegates;
1155     struct Checkpoint {
1156         uint32 fromBlock;
1157         uint256 votes;
1158     }
1159 
1160     /// @notice A record of votes checkpoints for each account, by index
1161     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1162     /// @notice The number of checkpoints for each account
1163     mapping (address => uint32) public numCheckpoints;
1164     /// @notice The EIP-712 typehash for the contract's domain
1165     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1166     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1167     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1168     /// @notice A record of states for signing / validating signatures
1169     mapping (address => uint) public nonces;
1170     /// @notice An event thats emitted when an account changes its delegate
1171     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1172     /// @notice An event thats emitted when a delegate account's vote balance changes
1173     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1174     
1175     /**
1176      * @notice Delegate votes from `msg.sender` to `delegatee`
1177      * @param delegator The address to get delegatee for
1178      */
1179     function delegates(address delegator)
1180         external
1181         view
1182         returns (address)
1183     {
1184         return _delegates[delegator];
1185     }
1186 
1187    /**
1188     * @notice Delegate votes from `msg.sender` to `delegatee`
1189     * @param delegatee The address to delegate votes to
1190     */
1191     function delegate(address delegatee) external {
1192         return _delegate(msg.sender, delegatee);
1193     }
1194 
1195     /**
1196      * @notice Delegates votes from signatory to `delegatee`
1197      * @param delegatee The address to delegate votes to
1198      * @param nonce The contract state required to match the signature
1199      * @param expiry The time at which to expire the signature
1200      * @param v The recovery byte of the signature
1201      * @param r Half of the ECDSA signature pair
1202      * @param s Half of the ECDSA signature pair
1203      */
1204     function delegateBySig(
1205         address delegatee,
1206         uint nonce,
1207         uint expiry,
1208         uint8 v,
1209         bytes32 r,
1210         bytes32 s
1211     )
1212         external
1213     {
1214         bytes32 domainSeparator = keccak256(
1215             abi.encode(
1216                 DOMAIN_TYPEHASH,
1217                 keccak256(bytes(name())),
1218                 getChainId(),
1219                 address(this)
1220             )
1221         );
1222 
1223         bytes32 structHash = keccak256(
1224             abi.encode(
1225                 DELEGATION_TYPEHASH,
1226                 delegatee,
1227                 nonce,
1228                 expiry
1229             )
1230         );
1231 
1232         bytes32 digest = keccak256(
1233             abi.encodePacked(
1234                 "\x19\x01",
1235                 domainSeparator,
1236                 structHash
1237             )
1238         );
1239 
1240         address signatory = ecrecover(digest, v, r, s);
1241         require(signatory != address(0), "Pic.finance::delegateBySig: invalid signature");
1242         require(nonce == nonces[signatory]++, "Pic.financey::delegateBySig: invalid nonce");
1243         require(now <= expiry, "Pic.finance::delegateBySig: signature expired");
1244         return _delegate(signatory, delegatee);
1245     }
1246 
1247     /**
1248      * @notice Gets the current votes balance for `account`
1249      * @param account The address to get votes balance
1250      * @return The number of current votes for `account`
1251      */
1252     function getCurrentVotes(address account)
1253         external
1254         view
1255         returns (uint256)
1256     {
1257         uint32 nCheckpoints = numCheckpoints[account];
1258         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1259     }
1260 
1261     /**
1262      * @notice Determine the prior number of votes for an account as of a block number
1263      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1264      * @param account The address of the account to check
1265      * @param blockNumber The block number to get the vote balance at
1266      * @return The number of votes the account had as of the given block
1267      */
1268     function getPriorVotes(address account, uint blockNumber)
1269         external
1270         view
1271         returns (uint256)
1272     {
1273         require(blockNumber < block.number, "Pic.finance::getPriorVotes: not yet determined");
1274 
1275         uint32 nCheckpoints = numCheckpoints[account];
1276         if (nCheckpoints == 0) {
1277             return 0;
1278         }
1279         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1280             return checkpoints[account][nCheckpoints - 1].votes;
1281         }
1282         if (checkpoints[account][0].fromBlock > blockNumber) {
1283             return 0;
1284         }
1285 
1286         uint32 lower = 0;
1287         uint32 upper = nCheckpoints - 1;
1288         while (upper > lower) {
1289             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1290             Checkpoint memory cp = checkpoints[account][center];
1291             if (cp.fromBlock == blockNumber) {
1292                 return cp.votes;
1293             } else if (cp.fromBlock < blockNumber) {
1294                 lower = center;
1295             } else {
1296                 upper = center - 1;
1297             }
1298         }
1299         return checkpoints[account][lower].votes;
1300     }
1301 
1302     function _delegate(address delegator, address delegatee)
1303         internal
1304     {
1305         address currentDelegate = _delegates[delegator];
1306         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying Pic.finance (not scaled);
1307         _delegates[delegator] = delegatee;
1308         emit DelegateChanged(delegator, currentDelegate, delegatee);
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
1339         uint32 blockNumber = safe32(block.number, "Pic.finance::_writeCheckpoint: block number exceeds 32 bits");
1340         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1341             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1342         } else {
1343             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1344             numCheckpoints[delegatee] = nCheckpoints + 1;
1345         }
1346         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1347     }
1348 
1349     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1350         require(n < 2**32, errorMessage);
1351         return uint32(n);
1352     }
1353 
1354     function getChainId() internal pure returns (uint) {
1355         uint256 chainId;
1356         assembly { chainId := chainid() }
1357         return chainId;
1358     }
1359 }