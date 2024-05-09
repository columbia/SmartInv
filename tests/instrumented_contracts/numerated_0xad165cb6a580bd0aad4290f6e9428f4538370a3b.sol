1 // SPDX-License-Identifier: SimPL-2.0
2 // http://swapx.org
3 pragma solidity 0.6.12;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 /**
92  * @dev Library for managing
93  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
94  * types.
95  *
96  * Sets have the following properties:
97  *
98  * - Elements are added, removed, and checked for existence in constant time
99  * (O(1)).
100  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
101  *
102  * ```
103  * contract Example {
104  *     // Add the library methods
105  *     using EnumerableSet for EnumerableSet.AddressSet;
106  *
107  *     // Declare a set state variable
108  *     EnumerableSet.AddressSet private mySet;
109  * }
110  * ```
111  *
112  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
113  * (`UintSet`) are supported.
114  */
115 library EnumerableSet {
116     // To implement this library for multiple types with as little code
117     // repetition as possible, we write it in terms of a generic Set type with
118     // bytes32 values.
119     // The Set implementation uses private functions, and user-facing
120     // implementations (such as AddressSet) are just wrappers around the
121     // underlying Set.
122     // This means that we can only create new EnumerableSets for types that fit
123     // in bytes32.
124 
125     struct Set {
126         // Storage of set values
127         bytes32[] _values;
128 
129         // Position of the value in the `values` array, plus 1 because index 0
130         // means a value is not in the set.
131         mapping (bytes32 => uint256) _indexes;
132     }
133 
134     /**
135      * @dev Add a value to a set. O(1).
136      *
137      * Returns true if the value was added to the set, that is if it was not
138      * already present.
139      */
140     function _add(Set storage set, bytes32 value) private returns (bool) {
141         if (!_contains(set, value)) {
142             set._values.push(value);
143             // The value is stored at length-1, but we add 1 to all indexes
144             // and use 0 as a sentinel value
145             set._indexes[value] = set._values.length;
146             return true;
147         } else {
148             return false;
149         }
150     }
151 
152     /**
153      * @dev Removes a value from a set. O(1).
154      *
155      * Returns true if the value was removed from the set, that is if it was
156      * present.
157      */
158     function _remove(Set storage set, bytes32 value) private returns (bool) {
159         // We read and store the value's index to prevent multiple reads from the same storage slot
160         uint256 valueIndex = set._indexes[value];
161 
162         if (valueIndex != 0) { // Equivalent to contains(set, value)
163             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
164             // the array, and then remove the last element (sometimes called as 'swap and pop').
165             // This modifies the order of the array, as noted in {at}.
166 
167             uint256 toDeleteIndex = valueIndex - 1;
168             uint256 lastIndex = set._values.length - 1;
169 
170             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
171             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
172 
173             bytes32 lastvalue = set._values[lastIndex];
174 
175             // Move the last value to the index where the value to delete is
176             set._values[toDeleteIndex] = lastvalue;
177             // Update the index for the moved value
178             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
179 
180             // Delete the slot where the moved value was stored
181             set._values.pop();
182 
183             // Delete the index for the deleted slot
184             delete set._indexes[value];
185 
186             return true;
187         } else {
188             return false;
189         }
190     }
191 
192     /**
193      * @dev Returns true if the value is in the set. O(1).
194      */
195     function _contains(Set storage set, bytes32 value) private view returns (bool) {
196         return set._indexes[value] != 0;
197     }
198 
199     /**
200      * @dev Returns the number of values on the set. O(1).
201      */
202     function _length(Set storage set) private view returns (uint256) {
203         return set._values.length;
204     }
205 
206    /**
207     * @dev Returns the value stored at position `index` in the set. O(1).
208     *
209     * Note that there are no guarantees on the ordering of values inside the
210     * array, and it may change when more values are added or removed.
211     *
212     * Requirements:
213     *
214     * - `index` must be strictly less than {length}.
215     */
216     function _at(Set storage set, uint256 index) private view returns (bytes32) {
217         require(set._values.length > index, "EnumerableSet: index out of bounds");
218         return set._values[index];
219     }
220 
221     // AddressSet
222 
223     struct AddressSet {
224         Set _inner;
225     }
226 
227     /**
228      * @dev Add a value to a set. O(1).
229      *
230      * Returns true if the value was added to the set, that is if it was not
231      * already present.
232      */
233     function add(AddressSet storage set, address value) internal returns (bool) {
234         return _add(set._inner, bytes32(uint256(value)));
235     }
236 
237     /**
238      * @dev Removes a value from a set. O(1).
239      *
240      * Returns true if the value was removed from the set, that is if it was
241      * present.
242      */
243     function remove(AddressSet storage set, address value) internal returns (bool) {
244         return _remove(set._inner, bytes32(uint256(value)));
245     }
246 
247     /**
248      * @dev Returns true if the value is in the set. O(1).
249      */
250     function contains(AddressSet storage set, address value) internal view returns (bool) {
251         return _contains(set._inner, bytes32(uint256(value)));
252     }
253 
254     /**
255      * @dev Returns the number of values in the set. O(1).
256      */
257     function length(AddressSet storage set) internal view returns (uint256) {
258         return _length(set._inner);
259     }
260 
261    /**
262     * @dev Returns the value stored at position `index` in the set. O(1).
263     *
264     * Note that there are no guarantees on the ordering of values inside the
265     * array, and it may change when more values are added or removed.
266     *
267     * Requirements:
268     *
269     * - `index` must be strictly less than {length}.
270     */
271     function at(AddressSet storage set, uint256 index) internal view returns (address) {
272         return address(uint256(_at(set._inner, index)));
273     }
274 
275 
276     // UintSet
277 
278     struct UintSet {
279         Set _inner;
280     }
281 
282     /**
283      * @dev Add a value to a set. O(1).
284      *
285      * Returns true if the value was added to the set, that is if it was not
286      * already present.
287      */
288     function add(UintSet storage set, uint256 value) internal returns (bool) {
289         return _add(set._inner, bytes32(value));
290     }
291 
292     /**
293      * @dev Removes a value from a set. O(1).
294      *
295      * Returns true if the value was removed from the set, that is if it was
296      * present.
297      */
298     function remove(UintSet storage set, uint256 value) internal returns (bool) {
299         return _remove(set._inner, bytes32(value));
300     }
301 
302     /**
303      * @dev Returns true if the value is in the set. O(1).
304      */
305     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
306         return _contains(set._inner, bytes32(value));
307     }
308 
309     /**
310      * @dev Returns the number of values on the set. O(1).
311      */
312     function length(UintSet storage set) internal view returns (uint256) {
313         return _length(set._inner);
314     }
315 
316    /**
317     * @dev Returns the value stored at position `index` in the set. O(1).
318     *
319     * Note that there are no guarantees on the ordering of values inside the
320     * array, and it may change when more values are added or removed.
321     *
322     * Requirements:
323     *
324     * - `index` must be strictly less than {length}.
325     */
326     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
327         return uint256(_at(set._inner, index));
328     }
329 }
330 
331 /**
332  * @dev Interface of the ERC20 standard as defined in the EIP.
333  */
334 interface IERC20 {
335     /**
336      * @dev Returns the amount of tokens in existence.
337      */
338     function totalSupply() external view returns (uint256);
339 
340     /**
341      * @dev Returns the amount of tokens owned by `account`.
342      */
343     function balanceOf(address account) external view returns (uint256);
344 
345     /**
346      * @dev Moves `amount` tokens from the caller's account to `recipient`.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transfer(address recipient, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Returns the remaining number of tokens that `spender` will be
356      * allowed to spend on behalf of `owner` through {transferFrom}. This is
357      * zero by default.
358      *
359      * This value changes when {approve} or {transferFrom} are called.
360      */
361     function allowance(address owner, address spender) external view returns (uint256);
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * IMPORTANT: Beware that changing an allowance with this method brings the risk
369      * that someone may use both the old and the new allowance by unfortunate
370      * transaction ordering. One possible solution to mitigate this race
371      * condition is to first reduce the spender's allowance to 0 and set the
372      * desired value afterwards:
373      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374      *
375      * Emits an {Approval} event.
376      */
377     function approve(address spender, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Moves `amount` tokens from `sender` to `recipient` using the
381      * allowance mechanism. `amount` is then deducted from the caller's
382      * allowance.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
389 
390     /**
391      * @dev Emitted when `value` tokens are moved from one account (`from`) to
392      * another (`to`).
393      *
394      * Note that `value` may be zero.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 value);
397 
398     /**
399      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
400      * a call to {approve}. `value` is the new allowance.
401      */
402     event Approval(address indexed owner, address indexed spender, uint256 value);
403 }
404 
405 /**
406  * @dev Collection of functions related to the address type
407  */
408 library Address {
409     /**
410      * @dev Returns true if `account` is a contract.
411      *
412      * [IMPORTANT]
413      * ====
414      * It is unsafe to assume that an address for which this function returns
415      * false is an externally-owned account (EOA) and not a contract.
416      *
417      * Among others, `isContract` will return false for the following
418      * types of addresses:
419      *
420      *  - an externally-owned account
421      *  - a contract in construction
422      *  - an address where a contract will be created
423      *  - an address where a contract lived, but was destroyed
424      * ====
425      */
426     function isContract(address account) internal view returns (bool) {
427         // This method relies in extcodesize, which returns 0 for contracts in
428         // construction, since the code is only stored at the end of the
429         // constructor execution.
430 
431         uint256 size;
432         // solhint-disable-next-line no-inline-assembly
433         assembly { size := extcodesize(account) }
434         return size > 0;
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
457         (bool success, ) = recipient.call{ value: amount }("");
458         require(success, "Address: unable to send value, recipient may have reverted");
459     }
460 
461     /**
462      * @dev Performs a Solidity function call using a low level `call`. A
463      * plain`call` is an unsafe replacement for a function call: use this
464      * function instead.
465      *
466      * If `target` reverts with a revert reason, it is bubbled up by this
467      * function (like regular Solidity function calls).
468      *
469      * Returns the raw returned data. To convert to the expected return value,
470      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
471      *
472      * Requirements:
473      *
474      * - `target` must be a contract.
475      * - calling `target` with `data` must not revert.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
480       return functionCall(target, data, "Address: low-level call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
485      * `errorMessage` as a fallback revert reason when `target` reverts.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
490         return _functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
515         require(address(this).balance >= value, "Address: insufficient balance for call");
516         return _functionCallWithValue(target, data, value, errorMessage);
517     }
518 
519     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
520         require(isContract(target), "Address: call to non-contract");
521 
522         // solhint-disable-next-line avoid-low-level-calls
523         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
524         if (success) {
525             return returndata;
526         } else {
527             // Look for revert reason and bubble it up if present
528             if (returndata.length > 0) {
529                 // The easiest way to bubble the revert reason is using memory via assembly
530 
531                 // solhint-disable-next-line no-inline-assembly
532                 assembly {
533                     let returndata_size := mload(returndata)
534                     revert(add(32, returndata), returndata_size)
535                 }
536             } else {
537                 revert(errorMessage);
538             }
539         }
540     }
541 }
542 
543 
544 /**
545  * @dev Wrappers over Solidity's arithmetic operations with added overflow
546  * checks.
547  *
548  * Arithmetic operations in Solidity wrap on overflow. This can easily result
549  * in bugs, because programmers usually assume that an overflow raises an
550  * error, which is the standard behavior in high level programming languages.
551  * `SafeMath` restores this intuition by reverting the transaction when an
552  * operation overflows.
553  *
554  * Using this library instead of the unchecked operations eliminates an entire
555  * class of bugs, so it's recommended to use it always.
556  */
557 library SafeMath {
558     /**
559      * @dev Returns the addition of two unsigned integers, reverting on
560      * overflow.
561      *
562      * Counterpart to Solidity's `+` operator.
563      *
564      * Requirements:
565      *
566      * - Addition cannot overflow.
567      */
568     function add(uint256 a, uint256 b) internal pure returns (uint256) {
569         uint256 c = a + b;
570         require(c >= a, "SafeMath: addition overflow");
571 
572         return c;
573     }
574 
575     /**
576      * @dev Returns the subtraction of two unsigned integers, reverting on
577      * overflow (when the result is negative).
578      *
579      * Counterpart to Solidity's `-` operator.
580      *
581      * Requirements:
582      *
583      * - Subtraction cannot overflow.
584      */
585     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
586         return sub(a, b, "SafeMath: subtraction overflow");
587     }
588 
589     /**
590      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
591      * overflow (when the result is negative).
592      *
593      * Counterpart to Solidity's `-` operator.
594      *
595      * Requirements:
596      *
597      * - Subtraction cannot overflow.
598      */
599     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
600         require(b <= a, errorMessage);
601         uint256 c = a - b;
602 
603         return c;
604     }
605 
606     /**
607      * @dev Returns the multiplication of two unsigned integers, reverting on
608      * overflow.
609      *
610      * Counterpart to Solidity's `*` operator.
611      *
612      * Requirements:
613      *
614      * - Multiplication cannot overflow.
615      */
616     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
617         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
618         // benefit is lost if 'b' is also tested.
619         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
620         if (a == 0) {
621             return 0;
622         }
623 
624         uint256 c = a * b;
625         require(c / a == b, "SafeMath: multiplication overflow");
626 
627         return c;
628     }
629 
630     /**
631      * @dev Returns the integer division of two unsigned integers. Reverts on
632      * division by zero. The result is rounded towards zero.
633      *
634      * Counterpart to Solidity's `/` operator. Note: this function uses a
635      * `revert` opcode (which leaves remaining gas untouched) while Solidity
636      * uses an invalid opcode to revert (consuming all remaining gas).
637      *
638      * Requirements:
639      *
640      * - The divisor cannot be zero.
641      */
642     function div(uint256 a, uint256 b) internal pure returns (uint256) {
643         return div(a, b, "SafeMath: division by zero");
644     }
645 
646     /**
647      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
648      * division by zero. The result is rounded towards zero.
649      *
650      * Counterpart to Solidity's `/` operator. Note: this function uses a
651      * `revert` opcode (which leaves remaining gas untouched) while Solidity
652      * uses an invalid opcode to revert (consuming all remaining gas).
653      *
654      * Requirements:
655      *
656      * - The divisor cannot be zero.
657      */
658     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
659         require(b > 0, errorMessage);
660         uint256 c = a / b;
661         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
662 
663         return c;
664     }
665 
666     /**
667      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
668      * Reverts when dividing by zero.
669      *
670      * Counterpart to Solidity's `%` operator. This function uses a `revert`
671      * opcode (which leaves remaining gas untouched) while Solidity uses an
672      * invalid opcode to revert (consuming all remaining gas).
673      *
674      * Requirements:
675      *
676      * - The divisor cannot be zero.
677      */
678     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
679         return mod(a, b, "SafeMath: modulo by zero");
680     }
681 
682     /**
683      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
684      * Reverts with custom message when dividing by zero.
685      *
686      * Counterpart to Solidity's `%` operator. This function uses a `revert`
687      * opcode (which leaves remaining gas untouched) while Solidity uses an
688      * invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
695         require(b != 0, errorMessage);
696         return a % b;
697     }
698 }
699 
700 
701 /**
702  * @title SafeERC20
703  * @dev Wrappers around ERC20 operations that throw on failure (when the token
704  * contract returns false). Tokens that return no value (and instead revert or
705  * throw on failure) are also supported, non-reverting calls are assumed to be
706  * successful.
707  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
708  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
709  */
710 library SafeERC20 {
711     using SafeMath for uint256;
712     using Address for address;
713 
714     function safeTransfer(IERC20 token, address to, uint256 value) internal {
715         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
716     }
717 
718     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
719         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
720     }
721 
722     /**
723      * @dev Deprecated. This function has issues similar to the ones found in
724      * {IERC20-approve}, and its usage is discouraged.
725      *
726      * Whenever possible, use {safeIncreaseAllowance} and
727      * {safeDecreaseAllowance} instead.
728      */
729     function safeApprove(IERC20 token, address spender, uint256 value) internal {
730         // safeApprove should only be called when setting an initial allowance,
731         // or when resetting it to zero. To increase and decrease it, use
732         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
733         // solhint-disable-next-line max-line-length
734         require((value == 0) || (token.allowance(address(this), spender) == 0),
735             "SafeERC20: approve from non-zero to non-zero allowance"
736         );
737         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
738     }
739 
740     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
741         uint256 newAllowance = token.allowance(address(this), spender).add(value);
742         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
743     }
744 
745     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
746         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
747         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
748     }
749 
750     /**
751      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
752      * on the return value: the return value is optional (but if data is returned, it must not be false).
753      * @param token The token targeted by the call.
754      * @param data The call data (encoded using abi.encode or one of its variants).
755      */
756     function _callOptionalReturn(IERC20 token, bytes memory data) private {
757         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
758         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
759         // the target address contains contract code and also asserts for success in the low-level call.
760 
761         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
762         if (returndata.length > 0) { // Return data is optional
763             // solhint-disable-next-line max-line-length
764             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
765         }
766     }
767 }
768 
769 interface ISwapXToken is IERC20 {
770     function issue(address account, uint256 amount) external returns (bool);
771 }
772 
773 interface IMigrator {
774     function migrate(IERC20 token) external returns (IERC20);
775 }
776 
777 contract SwapXLPStaking is Ownable {
778     using SafeMath for uint256;
779     using SafeERC20 for IERC20;
780     using SafeERC20 for ISwapXToken;
781     // Info of each user.
782     struct UserInfo {
783         uint256 amount;     // How many LP tokens the user has provided.
784         uint256 rewardDebt; // Reward debt. See explanation below.
785         // Basically, any point in time, the amount of SWP
786         // entitled to a user but is pending to be distributed is:
787         //
788         //   pending reward = (user.amount * pool.accSwpPerShare) - user.rewardDebt
789         //
790         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
791         //   1. The pool's `accSwpPerShare` (and `lastRewardBlock`) gets updated.
792         //   2. User receives the pending reward sent to his/her address.
793         //   3. User's `amount` gets updated.
794         //   4. User's `rewardDebt` gets updated.
795     }
796 
797     // Info of each pool.
798     struct PoolInfo {
799         IERC20 lpToken;           // Address of LP token contract.
800         uint256 allocPoint;       // How many allocation points assigned to this pool. SWP to distribute per block.
801         uint256 lastRewardBlock;  // Last block number that SWP distribution occurs.
802         uint256 accSwpPerShare; // Accumulated SWP per share, times 1e12. See below.
803     }
804 
805     // The SWP TOKEN!
806     ISwapXToken public swp;
807     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
808     IMigrator public migrator;
809     // The block number when SWP mining starts.
810     uint256 immutable public startBlock;
811     // The block number when SWP mining ends.
812     uint256 immutable public endBlock;
813     // SWP tokens created per block.
814     uint256 immutable public swpPerBlock;
815 
816     // Info of each pool.
817     PoolInfo[] public poolInfo;
818     mapping (address => bool) public  addedPool;
819     // Info of each user that stakes LP tokens.
820     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
821     // Total allocation poitns. Must be the sum of all allocation points in all pools.
822     uint256 public totalAllocPoint = 0;
823 
824     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
825     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
826     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
827     event SafeSwpTransfer(address to, uint256 amount);
828     event SetMigrator(address indexed newMigrator);
829     event Migrate(uint256 pid, address indexed lpToken, address indexed newToken);
830     event Initialization(address swp, uint256 swpPerBlock, uint256 startBlock, uint256 endBlock);
831     event Add(uint256 allocPoint, IERC20 lpToken, bool withUpdate);
832     event Set(uint256 pid, uint256 allocPoint, bool withUpdate);
833     event BatchUpdatePools();
834     event UpdatePool(uint256 pid);
835 
836     constructor(
837         ISwapXToken _swp,
838         uint256 _swpPerBlock,
839         uint256 _startBlock,
840         uint256 _endBlock
841     ) public {
842         swp = _swp;
843         swpPerBlock = _swpPerBlock;
844         startBlock = _startBlock;
845         endBlock = _endBlock;
846         emit Initialization(address(_swp), _swpPerBlock, _startBlock, _endBlock);
847     }
848 
849     function poolLength() external view returns (uint256) {
850         return poolInfo.length;
851     }
852 
853     // Add a new lp to the pool. Can only be called by the owner.
854     // DO NOT add the same LP token more than once. Rewards will be messed up if you do.
855     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
856         require(!addedPool[address(_lpToken)], "SwapX Staking: duplicate lpToken");
857         if (_withUpdate) {
858             batchUpdatePools();
859         }
860         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
861         totalAllocPoint = totalAllocPoint.add(_allocPoint);
862         poolInfo.push(PoolInfo({
863             lpToken: _lpToken,
864             allocPoint: _allocPoint,
865             lastRewardBlock: lastRewardBlock,
866             accSwpPerShare: 0
867         }));
868         addedPool[address(_lpToken)] = true;
869         emit Add(_allocPoint, _lpToken, _withUpdate);
870     }
871 
872     // Update the given pool's SWP allocation point. Can only be called by the owner.
873     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
874         require(_pid<poolInfo.length, "SwapX Staking: bad pid");
875         if (_withUpdate) {
876             batchUpdatePools();
877         }
878         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
879         poolInfo[_pid].allocPoint = _allocPoint;
880         emit Set(_pid, _allocPoint, _withUpdate);
881     }
882 
883     // Set the migrator contract. Can only be called by the owner.
884     function setMigrator(IMigrator _migrator) public onlyOwner {
885         migrator = _migrator;
886         emit SetMigrator(address(_migrator));
887     }
888 
889     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
890     function migrate(uint256 _pid) public {
891         require(_pid<poolInfo.length, "SwapX Staking: bad pid");
892         require(address(migrator) != address(0), "migrate: no migrator");
893         PoolInfo storage pool = poolInfo[_pid];
894         IERC20 lpToken = pool.lpToken;
895         uint256 bal = lpToken.balanceOf(address(this));
896         lpToken.safeApprove(address(migrator), bal);
897         IERC20 newLpToken = migrator.migrate(lpToken);
898         require(address(newLpToken) != address(0) && (bal == newLpToken.balanceOf(address(this))), "migrate: bad");
899         pool.lpToken = newLpToken;
900         emit Migrate(_pid, address(lpToken), address(newLpToken));
901     }
902 
903     // Return reward multiplier over the given _from to _to block.
904     function getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
905         if (_to <= endBlock) {
906             return _to.sub(_from);
907         } else if (_from >= endBlock) {
908             return 0;
909         } else {
910             return endBlock.sub(_from);
911         }
912     }
913 
914     // View function to see pending SWP on frontend.
915     function pendingSWP(uint256 _pid, address _user) external view returns (uint256) {
916         PoolInfo storage pool = poolInfo[_pid];
917         UserInfo storage user = userInfo[_pid][_user];
918         uint256 accSwpPerShare = pool.accSwpPerShare;
919         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
920         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
921             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
922             uint256 swpReward = multiplier.mul(swpPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
923             accSwpPerShare = accSwpPerShare.add(swpReward.mul(1e12).div(lpSupply));
924         }
925         return user.amount.mul(accSwpPerShare).div(1e12).sub(user.rewardDebt);
926     }
927 
928     // Update reward vairables for all pools. Be careful of gas spending!
929     function batchUpdatePools() public {
930         uint256 length = poolInfo.length;
931         for (uint256 pid = 0; pid < length; ++pid) {
932             updatePool(pid);
933         }
934         emit BatchUpdatePools();
935     }
936 
937     // Update reward variables of the given pool to be up-to-date.
938     function updatePool(uint256 _pid) internal {
939         require(_pid<poolInfo.length, "SwapX Staking: bad pid");
940         PoolInfo storage pool = poolInfo[_pid];
941         if (block.number <= pool.lastRewardBlock) {
942             return;
943         }
944         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
945         if (lpSupply == 0) {
946             pool.lastRewardBlock = block.number;
947             return;
948         }
949         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
950         uint256 swpReward = multiplier.mul(swpPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
951         require(swp.issue(address(this), swpReward), "SwapX Staking: distribute rewards err");
952         pool.accSwpPerShare = pool.accSwpPerShare.add(swpReward.mul(1e12).div(lpSupply));
953         pool.lastRewardBlock = block.number;
954         emit UpdatePool(_pid);
955     }
956 
957     // Deposit LP tokens to Staking for SWP allocation.
958     function deposit(uint256 _pid, uint256 _amount) public {
959         require(_pid<poolInfo.length, "SwapX Staking: bad pid");
960         PoolInfo storage pool = poolInfo[_pid];
961         UserInfo storage user = userInfo[_pid][msg.sender];
962         updatePool(_pid);
963         if (user.amount > 0) {
964             uint256 pending = user.amount.mul(pool.accSwpPerShare).div(1e12).sub(user.rewardDebt);
965             safeSwpTransfer(msg.sender, pending);
966         }
967         if(_amount>0){
968             pool.lpToken.safeTransferFrom(msg.sender, address(this), _amount);
969         }
970         user.amount = user.amount.add(_amount);
971         user.rewardDebt = user.amount.mul(pool.accSwpPerShare).div(1e12);
972         emit Deposit(msg.sender, _pid, _amount);
973     }
974 
975     // Withdraw LP tokens from SwapXLPStaking.
976     function withdraw(uint256 _pid, uint256 _amount) public {
977         require(_pid<poolInfo.length, "SwapX Staking: bad pid");
978         PoolInfo storage pool = poolInfo[_pid];
979         UserInfo storage user = userInfo[_pid][msg.sender];
980         require(user.amount >= _amount, "withdraw: not good");
981         updatePool(_pid);
982         uint256 pending = user.amount.mul(pool.accSwpPerShare).div(1e12).sub(user.rewardDebt);
983         safeSwpTransfer(msg.sender, pending);
984         user.amount = user.amount.sub(_amount);
985         user.rewardDebt = user.amount.mul(pool.accSwpPerShare).div(1e12);
986         if(_amount>0){
987             pool.lpToken.safeTransfer(msg.sender, _amount);
988         }
989         emit Withdraw(msg.sender, _pid, _amount);
990     }
991 
992     // Withdraw without caring about rewards. EMERGENCY ONLY.
993     function emergencyWithdraw(uint256 _pid) public {
994         require(_pid<poolInfo.length, "SwapX Staking: bad pid");
995         PoolInfo storage pool = poolInfo[_pid];
996         UserInfo storage user = userInfo[_pid][msg.sender];
997         uint256 amount = user.amount;
998         user.amount = 0;
999         pool.lpToken.safeTransfer(msg.sender, amount);
1000         emit EmergencyWithdraw(msg.sender, _pid, amount);
1001         user.rewardDebt = 0;
1002     }
1003 
1004     // Safe SWP transfer function, just in case if rounding error causes pool to not have enough SWP.
1005     function safeSwpTransfer(address _to, uint256 _amount) internal{
1006         uint256 swpBal = swp.balanceOf(address(this));
1007         uint256 amount;
1008         if (_amount > swpBal) {
1009             amount = swpBal;
1010         } else {
1011             amount = _amount;
1012         }
1013         swp.safeTransfer(_to, amount);
1014         emit SafeSwpTransfer(_to, amount);
1015     }
1016 }