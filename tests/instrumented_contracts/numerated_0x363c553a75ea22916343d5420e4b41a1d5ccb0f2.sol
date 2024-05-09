1 pragma solidity ^0.6.12;
2 
3 abstract contract Context {
4     function _msgSender() internal view returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 pragma solidity ^0.6.0;
15 
16 /**
17  * @dev Contract module which provides a basic access control mechanism, where
18  * there is an account (an owner) that can be granted exclusive access to
19  * specific functions.
20  *
21  * By default, the owner account will be the one that deploys the contract. This
22  * can later be changed with {transferOwnership}.
23  *
24  * This module is used through inheritance. It will make available the modifier
25  * `onlyOwner`, which can be applied to your functions to restrict their use to
26  * the owner.
27  */
28 contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34      * @dev Initializes the contract setting the deployer as the initial owner.
35      */
36     constructor () internal {
37         address msgSender = _msgSender();
38         _owner = msgSender;
39         emit OwnershipTransferred(address(0), msgSender);
40     }
41 
42     /**
43      * @dev Returns the address of the current owner.
44      */
45     function owner() public view returns (address) {
46         return _owner;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(_owner == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     /**
58      * @dev Leaves the contract without owner. It will not be possible to call
59      * `onlyOwner` functions anymore. Can only be called by the current owner.
60      *
61      * NOTE: Renouncing ownership will leave the contract without an owner,
62      * thereby removing any functionality that is only available to the owner.
63      */
64     function renounceOwnership() public onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Can only be called by the current owner.
72      */
73     function transferOwnership(address newOwner) public onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 pragma solidity ^0.6.0;
81 
82 /**
83  * @dev Library for managing
84  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
85  * types.
86  *
87  * Sets have the following properties:
88  *
89  * - Elements are added, removed, and checked for existence in constant time
90  * (O(1)).
91  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
92  *
93  * ```
94  * contract Example {
95  *     // Add the library methods
96  *     using EnumerableSet for EnumerableSet.AddressSet;
97  *
98  *     // Declare a set state variable
99  *     EnumerableSet.AddressSet private mySet;
100  * }
101  * ```
102  *
103  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
104  * (`UintSet`) are supported.
105  */
106 library EnumerableSet {
107     // To implement this library for multiple types with as little code
108     // repetition as possible, we write it in terms of a generic Set type with
109     // bytes32 values.
110     // The Set implementation uses private functions, and user-facing
111     // implementations (such as AddressSet) are just wrappers around the
112     // underlying Set.
113     // This means that we can only create new EnumerableSets for types that fit
114     // in bytes32.
115 
116     struct Set {
117         // Storage of set values
118         bytes32[] _values;
119 
120         // Position of the value in the `values` array, plus 1 because index 0
121         // means a value is not in the set.
122         mapping (bytes32 => uint256) _indexes;
123     }
124 
125     /**
126      * @dev Add a value to a set. O(1).
127      *
128      * Returns true if the value was added to the set, that is if it was not
129      * already present.
130      */
131     function _add(Set storage set, bytes32 value) private returns (bool) {
132         if (!_contains(set, value)) {
133             set._values.push(value);
134             // The value is stored at length-1, but we add 1 to all indexes
135             // and use 0 as a sentinel value
136             set._indexes[value] = set._values.length;
137             return true;
138         } else {
139             return false;
140         }
141     }
142 
143     /**
144      * @dev Removes a value from a set. O(1).
145      *
146      * Returns true if the value was removed from the set, that is if it was
147      * present.
148      */
149     function _remove(Set storage set, bytes32 value) private returns (bool) {
150         // We read and store the value's index to prevent multiple reads from the same storage slot
151         uint256 valueIndex = set._indexes[value];
152 
153         if (valueIndex != 0) { // Equivalent to contains(set, value)
154             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
155             // the array, and then remove the last element (sometimes called as 'swap and pop').
156             // This modifies the order of the array, as noted in {at}.
157 
158             uint256 toDeleteIndex = valueIndex - 1;
159             uint256 lastIndex = set._values.length - 1;
160 
161             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
162             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
163 
164             bytes32 lastvalue = set._values[lastIndex];
165 
166             // Move the last value to the index where the value to delete is
167             set._values[toDeleteIndex] = lastvalue;
168             // Update the index for the moved value
169             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
170 
171             // Delete the slot where the moved value was stored
172             set._values.pop();
173 
174             // Delete the index for the deleted slot
175             delete set._indexes[value];
176 
177             return true;
178         } else {
179             return false;
180         }
181     }
182 
183     /**
184      * @dev Returns true if the value is in the set. O(1).
185      */
186     function _contains(Set storage set, bytes32 value) private view returns (bool) {
187         return set._indexes[value] != 0;
188     }
189 
190     /**
191      * @dev Returns the number of values on the set. O(1).
192      */
193     function _length(Set storage set) private view returns (uint256) {
194         return set._values.length;
195     }
196 
197    /**
198     * @dev Returns the value stored at position `index` in the set. O(1).
199     *
200     * Note that there are no guarantees on the ordering of values inside the
201     * array, and it may change when more values are added or removed.
202     *
203     * Requirements:
204     *
205     * - `index` must be strictly less than {length}.
206     */
207     function _at(Set storage set, uint256 index) private view returns (bytes32) {
208         require(set._values.length > index, "EnumerableSet: index out of bounds");
209         return set._values[index];
210     }
211 
212     // AddressSet
213 
214     struct AddressSet {
215         Set _inner;
216     }
217 
218     /**
219      * @dev Add a value to a set. O(1).
220      *
221      * Returns true if the value was added to the set, that is if it was not
222      * already present.
223      */
224     function add(AddressSet storage set, address value) internal returns (bool) {
225         return _add(set._inner, bytes32(uint256(value)));
226     }
227 
228     /**
229      * @dev Removes a value from a set. O(1).
230      *
231      * Returns true if the value was removed from the set, that is if it was
232      * present.
233      */
234     function remove(AddressSet storage set, address value) internal returns (bool) {
235         return _remove(set._inner, bytes32(uint256(value)));
236     }
237 
238     /**
239      * @dev Returns true if the value is in the set. O(1).
240      */
241     function contains(AddressSet storage set, address value) internal view returns (bool) {
242         return _contains(set._inner, bytes32(uint256(value)));
243     }
244 
245     /**
246      * @dev Returns the number of values in the set. O(1).
247      */
248     function length(AddressSet storage set) internal view returns (uint256) {
249         return _length(set._inner);
250     }
251 
252    /**
253     * @dev Returns the value stored at position `index` in the set. O(1).
254     *
255     * Note that there are no guarantees on the ordering of values inside the
256     * array, and it may change when more values are added or removed.
257     *
258     * Requirements:
259     *
260     * - `index` must be strictly less than {length}.
261     */
262     function at(AddressSet storage set, uint256 index) internal view returns (address) {
263         return address(uint256(_at(set._inner, index)));
264     }
265 
266 
267     // UintSet
268 
269     struct UintSet {
270         Set _inner;
271     }
272 
273     /**
274      * @dev Add a value to a set. O(1).
275      *
276      * Returns true if the value was added to the set, that is if it was not
277      * already present.
278      */
279     function add(UintSet storage set, uint256 value) internal returns (bool) {
280         return _add(set._inner, bytes32(value));
281     }
282 
283     /**
284      * @dev Removes a value from a set. O(1).
285      *
286      * Returns true if the value was removed from the set, that is if it was
287      * present.
288      */
289     function remove(UintSet storage set, uint256 value) internal returns (bool) {
290         return _remove(set._inner, bytes32(value));
291     }
292 
293     /**
294      * @dev Returns true if the value is in the set. O(1).
295      */
296     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
297         return _contains(set._inner, bytes32(value));
298     }
299 
300     /**
301      * @dev Returns the number of values on the set. O(1).
302      */
303     function length(UintSet storage set) internal view returns (uint256) {
304         return _length(set._inner);
305     }
306 
307    /**
308     * @dev Returns the value stored at position `index` in the set. O(1).
309     *
310     * Note that there are no guarantees on the ordering of values inside the
311     * array, and it may change when more values are added or removed.
312     *
313     * Requirements:
314     *
315     * - `index` must be strictly less than {length}.
316     */
317     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
318         return uint256(_at(set._inner, index));
319     }
320 }
321 pragma solidity ^0.6.2;
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327     /**
328      * @dev Returns true if `account` is a contract.
329      *
330      * [IMPORTANT]
331      * ====
332      * It is unsafe to assume that an address for which this function returns
333      * false is an externally-owned account (EOA) and not a contract.
334      *
335      * Among others, `isContract` will return false for the following
336      * types of addresses:
337      *
338      *  - an externally-owned account
339      *  - a contract in construction
340      *  - an address where a contract will be created
341      *  - an address where a contract lived, but was destroyed
342      * ====
343      */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies in extcodesize, which returns 0 for contracts in
346         // construction, since the code is only stored at the end of the
347         // constructor execution.
348 
349         uint256 size;
350         // solhint-disable-next-line no-inline-assembly
351         assembly { size := extcodesize(account) }
352         return size > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
375         (bool success, ) = recipient.call{ value: amount }("");
376         require(success, "Address: unable to send value, recipient may have reverted");
377     }
378 
379     /**
380      * @dev Performs a Solidity function call using a low level `call`. A
381      * plain`call` is an unsafe replacement for a function call: use this
382      * function instead.
383      *
384      * If `target` reverts with a revert reason, it is bubbled up by this
385      * function (like regular Solidity function calls).
386      *
387      * Returns the raw returned data. To convert to the expected return value,
388      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389      *
390      * Requirements:
391      *
392      * - `target` must be a contract.
393      * - calling `target` with `data` must not revert.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
398       return functionCall(target, data, "Address: low-level call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
403      * `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
408         return _functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         return _functionCallWithValue(target, data, value, errorMessage);
435     }
436 
437     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
438         require(isContract(target), "Address: call to non-contract");
439 
440         // solhint-disable-next-line avoid-low-level-calls
441         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
442         if (success) {
443             return returndata;
444         } else {
445             // Look for revert reason and bubble it up if present
446             if (returndata.length > 0) {
447                 // The easiest way to bubble the revert reason is using memory via assembly
448 
449                 // solhint-disable-next-line no-inline-assembly
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 pragma solidity ^0.6.0;
461 
462 /**
463  * @dev Wrappers over Solidity's arithmetic operations with added overflow
464  * checks.
465  *
466  * Arithmetic operations in Solidity wrap on overflow. This can easily result
467  * in bugs, because programmers usually assume that an overflow raises an
468  * error, which is the standard behavior in high level programming languages.
469  * `SafeMath` restores this intuition by reverting the transaction when an
470  * operation overflows.
471  *
472  * Using this library instead of the unchecked operations eliminates an entire
473  * class of bugs, so it's recommended to use it always.
474  */
475 library SafeMath {
476     /**
477      * @dev Returns the addition of two unsigned integers, reverting on
478      * overflow.
479      *
480      * Counterpart to Solidity's `+` operator.
481      *
482      * Requirements:
483      * - Addition cannot overflow.
484      */
485     function add(uint256 a, uint256 b) internal pure returns (uint256) {
486         uint256 c = a + b;
487         require(c >= a, "SafeMath: addition overflow");
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the subtraction of two unsigned integers, reverting on
494      * overflow (when the result is negative).
495      *
496      * Counterpart to Solidity's `-` operator.
497      *
498      * Requirements:
499      * - Subtraction cannot overflow.
500      */
501     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
502         return sub(a, b, "SafeMath: subtraction overflow");
503     }
504 
505     /**
506      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
507      * overflow (when the result is negative).
508      *
509      * Counterpart to Solidity's `-` operator.
510      *
511      * Requirements:
512      * - Subtraction cannot overflow.
513      */
514     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
515         require(b <= a, errorMessage);
516         uint256 c = a - b;
517 
518         return c;
519     }
520 
521     /**
522      * @dev Returns the multiplication of two unsigned integers, reverting on
523      * overflow.
524      *
525      * Counterpart to Solidity's `*` operator.
526      *
527      * Requirements:
528      * - Multiplication cannot overflow.
529      */
530     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
531         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
532         // benefit is lost if 'b' is also tested.
533         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
534         if (a == 0) {
535             return 0;
536         }
537 
538         uint256 c = a * b;
539         require(c / a == b, "SafeMath: multiplication overflow");
540 
541         return c;
542     }
543 
544     /**
545      * @dev Returns the integer division of two unsigned integers. Reverts on
546      * division by zero. The result is rounded towards zero.
547      *
548      * Counterpart to Solidity's `/` operator. Note: this function uses a
549      * `revert` opcode (which leaves remaining gas untouched) while Solidity
550      * uses an invalid opcode to revert (consuming all remaining gas).
551      *
552      * Requirements:
553      * - The divisor cannot be zero.
554      */
555     function div(uint256 a, uint256 b) internal pure returns (uint256) {
556         return div(a, b, "SafeMath: division by zero");
557     }
558 
559     /**
560      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator. Note: this function uses a
564      * `revert` opcode (which leaves remaining gas untouched) while Solidity
565      * uses an invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      * - The divisor cannot be zero.
569      */
570     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
571         require(b > 0, errorMessage);
572         uint256 c = a / b;
573         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
574 
575         return c;
576     }
577 
578     /**
579      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
580      * Reverts when dividing by zero.
581      *
582      * Counterpart to Solidity's `%` operator. This function uses a `revert`
583      * opcode (which leaves remaining gas untouched) while Solidity uses an
584      * invalid opcode to revert (consuming all remaining gas).
585      *
586      * Requirements:
587      * - The divisor cannot be zero.
588      */
589     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
590         return mod(a, b, "SafeMath: modulo by zero");
591     }
592 
593     /**
594      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
595      * Reverts with custom message when dividing by zero.
596      *
597      * Counterpart to Solidity's `%` operator. This function uses a `revert`
598      * opcode (which leaves remaining gas untouched) while Solidity uses an
599      * invalid opcode to revert (consuming all remaining gas).
600      *
601      * Requirements:
602      * - The divisor cannot be zero.
603      */
604     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
605         require(b != 0, errorMessage);
606         return a % b;
607     }
608 }
609 
610 pragma solidity ^0.6.0;
611 /**
612  * @dev Interface of the ERC20 standard as defined in the EIP.
613  */
614 interface IERC20 {
615     /**
616      * @dev Returns the amount of tokens in existence.
617      */
618     function totalSupply() external view returns (uint256);
619 
620     /**
621      * @dev Returns the amount of tokens owned by `account`.
622      */
623     function balanceOf(address account) external view returns (uint256);
624 
625     /**
626      * @dev Moves `amount` tokens from the caller's account to `recipient`.
627      *
628      * Returns a boolean value indicating whether the operation succeeded.
629      *
630      * Emits a {Transfer} event.
631      */
632     function transfer(address recipient, uint256 amount) external returns (bool);
633 
634     /**
635      * @dev Returns the remaining number of tokens that `spender` will be
636      * allowed to spend on behalf of `owner` through {transferFrom}. This is
637      * zero by default.
638      *
639      * This value changes when {approve} or {transferFrom} are called.
640      */
641     function allowance(address owner, address spender) external view returns (uint256);
642 
643     /**
644      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
645      *
646      * Returns a boolean value indicating whether the operation succeeded.
647      *
648      * IMPORTANT: Beware that changing an allowance with this method brings the risk
649      * that someone may use both the old and the new allowance by unfortunate
650      * transaction ordering. One possible solution to mitigate this race
651      * condition is to first reduce the spender's allowance to 0 and set the
652      * desired value afterwards:
653      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
654      *
655      * Emits an {Approval} event.
656      */
657     function approve(address spender, uint256 amount) external returns (bool);
658 
659     /**
660      * @dev Moves `amount` tokens from `sender` to `recipient` using the
661      * allowance mechanism. `amount` is then deducted from the caller's
662      * allowance.
663      *
664      * Returns a boolean value indicating whether the operation succeeded.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
669 
670     /**
671      * @dev Emitted when `value` tokens are moved from one account (`from`) to
672      * another (`to`).
673      *
674      * Note that `value` may be zero.
675      */
676     event Transfer(address indexed from, address indexed to, uint256 value);
677 
678     /**
679      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
680      * a call to {approve}. `value` is the new allowance.
681      */
682     event Approval(address indexed owner, address indexed spender, uint256 value);
683 }
684 
685 pragma solidity ^0.6.12;
686 
687 /**
688  * @title SafeERC20
689  * @dev Wrappers around ERC20 operations that throw on failure (when the token
690  * contract returns false). Tokens that return no value (and instead revert or
691  * throw on failure) are also supported, non-reverting calls are assumed to be
692  * successful.
693  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
694  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
695  */
696 library SafeERC20 {
697     using SafeMath for uint256;
698     using Address for address;
699 
700     function safeTransfer(IERC20 token, address to, uint256 value) internal {
701         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
702     }
703 
704     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
705         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
706     }
707 
708     /**
709      * @dev Deprecated. This function has issues similar to the ones found in
710      * {IERC20-approve}, and its usage is discouraged.
711      *
712      * Whenever possible, use {safeIncreaseAllowance} and
713      * {safeDecreaseAllowance} instead.
714      */
715     function safeApprove(IERC20 token, address spender, uint256 value) internal {
716         // safeApprove should only be called when setting an initial allowance,
717         // or when resetting it to zero. To increase and decrease it, use
718         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
719         // solhint-disable-next-line max-line-length
720         require((value == 0) || (token.allowance(address(this), spender) == 0),
721             "SafeERC20: approve from non-zero to non-zero allowance"
722         );
723         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
724     }
725 
726     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
727         uint256 newAllowance = token.allowance(address(this), spender).add(value);
728         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
729     }
730 
731     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
732         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
733         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
734     }
735 
736     /**
737      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
738      * on the return value: the return value is optional (but if data is returned, it must not be false).
739      * @param token The token targeted by the call.
740      * @param data The call data (encoded using abi.encode or one of its variants).
741      */
742     function _callOptionalReturn(IERC20 token, bytes memory data) private {
743         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
744         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
745         // the target address contains contract code and also asserts for success in the low-level call.
746 
747         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
748         if (returndata.length > 0) { // Return data is optional
749             // solhint-disable-next-line max-line-length
750             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
751         }
752     }
753 }
754 
755 pragma solidity ^0.6.0;
756 
757 /**
758  * @dev Implementation of the {IERC20} interface.
759  *
760  * This implementation is agnostic to the way tokens are created. This means
761  * that a supply mechanism has to be added in a derived contract using {_mint}.
762  * For a generic mechanism see {ERC20PresetMinterPauser}.
763  *
764  * TIP: For a detailed writeup see our guide
765  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
766  * to implement supply mechanisms].
767  *
768  * We have followed general OpenZeppelin guidelines: functions revert instead
769  * of returning `false` on failure. This behavior is nonetheless conventional
770  * and does not conflict with the expectations of ERC20 applications.
771  *
772  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
773  * This allows applications to reconstruct the allowance for all accounts just
774  * by listening to said events. Other implementations of the EIP may not emit
775  * these events, as it isn't required by the specification.
776  *
777  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
778  * functions have been added to mitigate the well-known issues around setting
779  * allowances. See {IERC20-approve}.
780  */
781 contract ERC20 is Context, IERC20 {
782     using SafeMath for uint256;
783     using Address for address;
784 
785     mapping (address => uint256) private _balances;
786 
787     mapping (address => mapping (address => uint256)) internal _allowances;
788 
789     uint256 private _totalSupply;
790 
791     string private _name;
792     string private _symbol;
793     uint8 private _decimals;
794 
795     /**
796      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
797      * a default value of 18.
798      *
799      * To select a different value for {decimals}, use {_setupDecimals}.
800      *
801      * All three of these values are immutable: they can only be set once during
802      * construction.
803      */
804     constructor (string memory name, string memory symbol) public {
805         _name = name;
806         _symbol = symbol;
807         _decimals = 18;
808     }
809 
810     /**
811      * @dev Returns the name of the token.
812      */
813     function name() public view returns (string memory) {
814         return _name;
815     }
816 
817     /**
818      * @dev Returns the symbol of the token, usually a shorter version of the
819      * name.
820      */
821     function symbol() public view returns (string memory) {
822         return _symbol;
823     }
824 
825     /**
826      * @dev Returns the number of decimals used to get its user representation.
827      * For example, if `decimals` equals `2`, a balance of `505` tokens should
828      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
829      *
830      * Tokens usually opt for a value of 18, imitating the relationship between
831      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
832      * called.
833      *
834      * NOTE: This information is only used for _display_ purposes: it in
835      * no way affects any of the arithmetic of the contract, including
836      * {IERC20-balanceOf} and {IERC20-transfer}.
837      */
838     function decimals() public view returns (uint8) {
839         return _decimals;
840     }
841 
842     /**
843      * @dev See {IERC20-totalSupply}.
844      */
845     function totalSupply() public view override returns (uint256) {
846         return _totalSupply;
847     }
848 
849     /**
850      * @dev See {IERC20-balanceOf}.
851      */
852     function balanceOf(address account) public view override returns (uint256) {
853         return _balances[account];
854     }
855 
856     /**
857      * @dev See {IERC20-allowance}.
858      */
859     function allowance(address owner, address spender) public view virtual override returns (uint256) {
860         return _allowances[owner][spender];
861     }
862 
863     /**
864      * @dev See {IERC20-approve}.
865      *
866      * Requirements:
867      *
868      * - `spender` cannot be the zero address.
869      */
870     function approve(address spender, uint256 amount) public virtual override returns (bool) {
871         _approve(_msgSender(), spender, amount);
872         return true;
873     }
874     
875     // override the functions and make it virtual to be overridden by child contract
876      function transfer(address recipient, uint256 amount) external override virtual returns (bool) { }
877      function transferFrom(address sender, address recipient, uint256 amount) external override virtual returns (bool) { }
878 
879     /**
880      * @dev Atomically increases the allowance granted to `spender` by the caller.
881      *
882      * This is an alternative to {approve} that can be used as a mitigation for
883      * problems described in {IERC20-approve}.
884      *
885      * Emits an {Approval} event indicating the updated allowance.
886      *
887      * Requirements:
888      *
889      * - `spender` cannot be the zero address.
890      */
891     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
892         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
893         return true;
894     }
895 
896     /**
897      * @dev Atomically decreases the allowance granted to `spender` by the caller.
898      *
899      * This is an alternative to {approve} that can be used as a mitigation for
900      * problems described in {IERC20-approve}.
901      *
902      * Emits an {Approval} event indicating the updated allowance.
903      *
904      * Requirements:
905      *
906      * - `spender` cannot be the zero address.
907      * - `spender` must have allowance for the caller of at least
908      * `subtractedValue`.
909      */
910     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
911         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
912         return true;
913     }
914 
915     /**
916      * @dev Moves tokens `amount` from `sender` to `recipient`.
917      *
918      * This is internal function is equivalent to {transfer}, and can be used to
919      * e.g. implement automatic token fees, slashing mechanisms, etc.
920      *
921      * Emits a {Transfer} event.
922      *
923      * Requirements:
924      *
925      * - `sender` cannot be the zero address.
926      * - `recipient` cannot be the zero address.
927      * - `sender` must have a balance of at least `amount`.
928      */
929     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
930         require(sender != address(0), "ERC20: transfer from the zero address");
931         require(recipient != address(0), "ERC20: transfer to the zero address");
932 
933         _beforeTokenTransfer(sender, recipient, amount);
934         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
935         _balances[recipient] = _balances[recipient].add(amount);
936         emit Transfer(sender, recipient, amount);
937         
938     }
939 
940     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
941      * the total supply.
942      *
943      * Emits a {Transfer} event with `from` set to the zero address.
944      *
945      * Requirements
946      *
947      * - `to` cannot be the zero address.
948      */
949     function _mint(address account, uint256 amount) internal virtual {
950         require(account != address(0), "ERC20: mint to the zero address");
951 
952         _beforeTokenTransfer(address(0), account, amount);
953 
954         _totalSupply = _totalSupply.add(amount);
955         _balances[account] = _balances[account].add(amount);
956         emit Transfer(address(0), account, amount);
957     }
958 
959     /**
960      * @dev Destroys `amount` tokens from `account`, reducing the
961      * total supply.
962      *
963      * Emits a {Transfer} event with `to` set to the zero address.
964      *
965      * Requirements
966      *
967      * - `account` cannot be the zero address.
968      * - `account` must have at least `amount` tokens.
969      */
970     function _burn(address account, uint256 amount) internal virtual {
971         require(account != address(0), "ERC20: burn from the zero address");
972 
973         _beforeTokenTransfer(account, address(0), amount);
974 
975         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
976         _totalSupply = _totalSupply.sub(amount);
977         emit Transfer(account, address(0), amount);
978     }
979 
980     /**
981      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
982      *
983      * This is internal function is equivalent to `approve`, and can be used to
984      * e.g. set automatic allowances for certain subsystems, etc.
985      *
986      * Emits an {Approval} event.
987      *
988      * Requirements:
989      *
990      * - `owner` cannot be the zero address.
991      * - `spender` cannot be the zero address.
992      */
993     function _approve(address owner, address spender, uint256 amount) internal virtual {
994         require(owner != address(0), "ERC20: approve from the zero address");
995         require(spender != address(0), "ERC20: approve to the zero address");
996 
997         _allowances[owner][spender] = amount;
998         emit Approval(owner, spender, amount);
999     }
1000 
1001     /**
1002      * @dev Sets {decimals} to a value other than the default one of 18.
1003      *
1004      * WARNING: This function should only be called from the constructor. Most
1005      * applications that interact with token contracts will not expect
1006      * {decimals} to ever change, and may work incorrectly if it does.
1007      */
1008     function _setupDecimals(uint8 decimals_) internal {
1009         _decimals = decimals_;
1010     }
1011 
1012     /**
1013      * @dev Hook that is called before any transfer of tokens. This includes
1014      * minting and burning.
1015      *
1016      * Calling conditions:
1017      *
1018      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1019      * will be to transferred to `to`.
1020      * - when `from` is zero, `amount` tokens will be minted for `to`.
1021      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1022      * - `from` and `to` are never both zero.
1023      *
1024      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1025      */
1026     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1027 }
1028 
1029 pragma solidity 0.6.12;
1030 
1031 // CURRY with Governance.
1032 contract CURRYSWAP is ERC20("CURRYSWAP", "CURRY"), Ownable {
1033 
1034     // Copied and modified from YAM code:
1035     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1036     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1037     // Which is copied and modified from COMPOUND:
1038     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1039 
1040     /// @notice A record of each accounts delegate
1041     mapping (address => address) internal _delegates;
1042 
1043     /// @notice A checkpoint for marking number of votes from a given block
1044     struct Checkpoint {
1045         uint32 fromBlock;
1046         uint256 votes;
1047     }
1048 
1049     /// @notice A record of votes checkpoints for each account, by index
1050     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1051 
1052     /// @notice The number of checkpoints for each account
1053     mapping (address => uint32) public numCheckpoints;
1054 
1055     /// @notice The EIP-712 typehash for the contract's domain
1056     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1057 
1058     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1059     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1060 
1061     /// @notice A record of states for signing / validating signatures
1062     mapping (address => uint) public nonces;
1063     
1064     mapping(address => bool) public isTeamAddressMapping;
1065 
1066       /// @notice An event thats emitted when an account changes its delegate
1067     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1068 
1069     /// @notice An event thats emitted when a delegate account's vote balance changes
1070     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance); // Audit
1071     
1072     modifier isItTeamAddress(address teamAddress) {
1073         require(isTeamAddressMapping[teamAddress] , "Address is not team address.");// Audit
1074         _;
1075     }
1076     
1077     constructor (uint256 supply) public {
1078         mint(address(this), supply);
1079     }
1080   
1081      /**
1082      * @dev See {IERC20-transfer}.
1083      *
1084      * Requirements:
1085      *
1086      * - `recipient` cannot be the zero address.
1087      * - the caller must have a balance of at least `amount`.
1088      */
1089     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1090         _transfer(_msgSender(), recipient, amount);
1091         _moveDelegates(_delegates[_msgSender()], _delegates[recipient], amount);
1092         return true;
1093     }
1094     
1095      /**
1096      * @dev See {IERC20-transferFrom}.
1097      *
1098      * Emits an {Approval} event indicating the updated allowance. This is not
1099      * required by the EIP. See the note at the beginning of {ERC20};
1100      *
1101      * Requirements:
1102      * - `sender` and `recipient` cannot be the zero address.
1103      * - `sender` must have a balance of at least `amount`.
1104      * - the caller must have allowance for ``sender``'s tokens of at least
1105      * `amount`.
1106      */
1107     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1108         _transfer(sender, recipient, amount);
1109         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1110         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1111         return true;
1112     }
1113 
1114     
1115     /**
1116     * @notice Delegate votes from `msg.sender` to `delegatee`
1117     * @param delegatee The address to delegate votes to
1118     */
1119     function delegate(address delegatee) external {
1120          _delegate(msg.sender, delegatee); // Audit
1121     }
1122     
1123     /**
1124      * @notice Delegate votes from `msg.sender` to `delegatee`
1125      * @param delegator The address to get delegatee for
1126      */
1127     function delegates(address delegator)
1128         external
1129         view
1130         returns (address)
1131     {
1132         return _delegates[delegator];
1133     }
1134 
1135      /**
1136      * @notice Determine the prior number of votes for an account as of a block number
1137      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1138      * @param account The address of the account to check
1139      * @param blockNumber The block number to get the vote balance at
1140      * @return The number of votes the account had as of the given block
1141      */
1142     function getPriorVotes(address account, uint256 blockNumber) // Audit
1143         external
1144         view
1145         returns (uint256)
1146     {
1147         require(blockNumber < block.number, "CURRY::getPriorVotes: not yet determined");
1148 
1149         uint32 nCheckpoints = numCheckpoints[account];
1150         if (nCheckpoints == 0) {
1151             return 0;
1152         }
1153 
1154         // First check most recent balance
1155         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1156             return checkpoints[account][nCheckpoints - 1].votes;
1157         }
1158 
1159         // Next check implicit zero balance
1160         if (checkpoints[account][0].fromBlock > blockNumber) {
1161             return 0;
1162         }
1163 
1164         uint32 lower = 0;
1165         uint32 upper = nCheckpoints - 1;
1166         while (upper > lower) {
1167             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1168             Checkpoint memory cp = checkpoints[account][center];
1169             if (cp.fromBlock == blockNumber) {
1170                 return cp.votes;
1171             } else if (cp.fromBlock < blockNumber) {
1172                 lower = center;
1173             } else {
1174                 upper = center - 1;
1175             }
1176         }
1177         return checkpoints[account][lower].votes;
1178     }
1179 
1180     /**
1181      * @notice Gets the current votes balance for `account`
1182      * @param account The address to get votes balance
1183      * @return The number of current votes for `account`
1184      */
1185     function getCurrentVotes(address account)
1186         external
1187         view
1188         returns (uint256)
1189     {
1190         uint32 nCheckpoints = numCheckpoints[account];
1191         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1192     }
1193     
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
1204     function delegateBySig( // Audit
1205         address delegatee,
1206         uint256 nonce,
1207         uint256 expiry,
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
1218                 _getChainId(), // Audit
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
1241         require(signatory != address(0), "CURRY::delegateBySig: invalid signature");
1242         require(nonce == nonces[signatory]++, "CURRY::delegateBySig: invalid nonce");
1243         require(now <= expiry, "CURRY::delegateBySig: signature expired");
1244         _delegate(signatory, delegatee); // Audit
1245     }
1246 
1247 
1248     
1249     function updateOrAddTeamAddress(address teamAddress, bool isTeamAddress) public onlyOwner {
1250         isTeamAddressMapping[teamAddress] = isTeamAddress;
1251     }
1252     
1253     function claimToken(address teamAddress, uint256 claimAmount) public isItTeamAddress(msg.sender) {
1254         require(claimAmount <= IERC20(address(this)).balanceOf(address(this)), "Not Enough balance");
1255         IERC20(address(this)).transfer(teamAddress, claimAmount);
1256     }
1257     
1258     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner
1259     function mint(address _to, uint256 _amount) public onlyOwner {
1260         _mint(_to, _amount);
1261         _moveDelegates(address(0), _delegates[_to], _amount);
1262     }
1263     
1264     /// @notice Burns `_amount` token from teambalance`. Must only be called by the teamaddress
1265     function burn(uint256 _amount) public isItTeamAddress(msg.sender) {
1266         _burn(msg.sender, _amount);
1267         _moveDelegates(_delegates[msg.sender], address(0), _amount);
1268     }
1269    
1270     function _delegate(address delegator, address delegatee)
1271         internal
1272     {
1273         address currentDelegate = _delegates[delegator];
1274         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CURRYs (not scaled);
1275         _delegates[delegator] = delegatee;
1276 
1277         emit DelegateChanged(delegator, currentDelegate, delegatee);
1278 
1279         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1280     }
1281 
1282     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1283         if (srcRep != dstRep && amount > 0) {
1284             if (srcRep != address(0)) {
1285                 // decrease old representative
1286                 uint32 srcRepNum = numCheckpoints[srcRep];
1287                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1288                 uint256 srcRepNew = srcRepOld.sub(amount);
1289                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1290             }
1291 
1292             if (dstRep != address(0)) {
1293                 // increase new representative
1294                 uint32 dstRepNum = numCheckpoints[dstRep];
1295                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1296                 uint256 dstRepNew = dstRepOld.add(amount);
1297                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1298             }
1299         }
1300     }
1301 
1302     function _writeCheckpoint(
1303         address delegatee,
1304         uint32 nCheckpoints,
1305         uint256 oldVotes,
1306         uint256 newVotes
1307     )
1308         internal
1309     {
1310         uint32 blockNumber = _safe32(block.number, "CURRY::_writeCheckpoint: block number exceeds 32 bits"); // Audit
1311 
1312         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1313             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1314         } else {
1315             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1316             numCheckpoints[delegatee] = nCheckpoints + 1;
1317         }
1318 
1319         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1320     }
1321 
1322     function _safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) { // Audit
1323         require(n < 2**32, errorMessage);
1324         return uint32(n);
1325     }
1326 
1327     function _getChainId() internal pure returns (uint) { // Audit
1328         uint256 chainId;
1329         assembly { chainId := chainid() }
1330         return chainId;
1331     }
1332 }
1333 
1334 // CurryChef is the master of Curry. He can make Curry and he is a fair guy.
1335 //
1336 // Note that it's ownable and the owner wields tremendous power. The ownership
1337 // will be transferred to a governance smart contract once CURRY is sufficiently
1338 // distributed and the community can show to govern itself.
1339 //
1340 // Have fun reading it. Hopefully it's bug-free. God bless.
1341 
1342 // This will be static token smart contract - which will have a function 
1343 contract CurryStatic is Ownable {
1344      function distribute(uint256 amount) external {}
1345 }
1346 
1347 
1348 contract CurryChef is Ownable {
1349     using SafeMath for uint256;
1350     using SafeERC20 for IERC20;
1351 
1352     // Info of each user.
1353     struct UserInfo {
1354         uint256 amount;     // How many LP tokens the user has provided.
1355         uint256 rewardDebt; // Reward debt. See explanation below.
1356         //
1357         // We do some fancy math here. Basically, any point in time, the amount of CURRYs
1358         // entitled to a user but is pending to be distributed is:
1359         //
1360         //   pending reward = (user.amount * pool.accCurryPerShare) - user.rewardDebt
1361         //
1362         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1363         //   1. The pool's `accCurryPerShare` (and `lastRewardBlock`) gets updated.
1364         //   2. User receives the pending reward sent to his/her address.
1365         //   3. User's `amount` gets updated.
1366         //   4. User's `rewardDebt` gets updated.
1367     }
1368     
1369     // check pool existance mapping - audit
1370     mapping (IERC20 => bool) public poolExist;
1371 
1372     // Info of each pool.
1373     struct PoolInfo {
1374         IERC20 lpToken;           // Address of LP token contract.
1375         uint256 allocPoint;       // How many allocation points assigned to this pool. CURRYs to distribute per block.
1376         uint256 lastRewardBlock;  // Last block number that CURRYs distribution occurs.
1377         uint256 accCurryPerShare; // Accumulated CURRYs per share, times 1e12. See below.
1378     }
1379     
1380     uint256 constant MINTED_STAKE_PERCENTAGE_TEAM = 11; // Audit
1381     uint256 constant MINTED_STAKE_PERCENTAGE_STATICSTAKERS = 9; // Audit
1382     uint256 constant TRILLION = 1e12; // Audit
1383     
1384     
1385 
1386     // The CURRY TOKEN!
1387     CURRYSWAP public curry;
1388     // Dev address.
1389     address public devaddr;
1390     // unstake Reward Address 0.5 % will go on withdraw
1391     address public unstakeRewardAddress;
1392     
1393     // Static Staking contract
1394     CurryStatic public staticTokenRewardContract;
1395     
1396     // Block number when bonus CURRY period ends.
1397     uint256 public bonusEndBlock;
1398     // CURRY tokens created per block.
1399     uint256 public curryPerBlock;
1400     // Bonus muliplier for early curry makers.
1401     uint256 public constant BONUS_MULTIPLIER = 2; // 2x BONUS
1402     // Info of each pool.
1403     PoolInfo[] public poolInfo;
1404     // Info of each user that stakes LP tokens.
1405     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1406     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1407     uint256 public totalAllocPoint = 0;
1408     // The block number when CURRY mining starts.
1409     uint256 public startBlock;
1410 
1411     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1412     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1413     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1414 
1415     constructor(
1416         CURRYSWAP _curry,
1417         address _devaddr,
1418         uint256 _curryPerBlock,
1419         uint256 _startBlock,
1420         uint256 _bonusEndBlock
1421     ) public {
1422         curry = _curry;
1423         devaddr = _devaddr;
1424         curryPerBlock = _curryPerBlock;
1425         bonusEndBlock = _bonusEndBlock;
1426         startBlock = _startBlock;
1427     }
1428 
1429     function poolLength() external view returns (uint256) {
1430         return poolInfo.length;
1431     }
1432      // update the static token contract
1433     function updateStaticStakingContract(CurryStatic staticTokenContract) external onlyOwner {
1434         staticTokenRewardContract = staticTokenContract;
1435     }
1436      
1437      // update the unstaklereward address
1438     function updateUnstakeRewardAddress(address _unstakeRewardAddress) external onlyOwner {
1439         unstakeRewardAddress = _unstakeRewardAddress;
1440     }
1441     
1442      // View function to see pending CURRYs on frontend.
1443     function pendingCurry(uint256 _pid, address _user) external view returns (uint256) {
1444         PoolInfo storage pool = poolInfo[_pid];
1445         UserInfo storage user = userInfo[_pid][_user];
1446         uint256 accCurryPerShare = pool.accCurryPerShare;
1447         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1448         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1449             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1450             uint256 curryReward = multiplier.mul(curryPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1451             accCurryPerShare = accCurryPerShare.add(curryReward.mul(TRILLION).div(lpSupply));
1452         }
1453         return user.amount.mul(accCurryPerShare).div(TRILLION).sub(user.rewardDebt);
1454     }
1455 
1456     // Add a new lp to the pool. Can only be called by the owner.
1457     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1458     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1459         // check pool exist or not - audit
1460          require(!poolExist[_lpToken], "Pool already exists");
1461          
1462         if (_withUpdate) {
1463             massUpdatePools();
1464         }
1465         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1466         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1467         poolInfo.push(PoolInfo({
1468             lpToken: _lpToken,
1469             allocPoint: _allocPoint,
1470             lastRewardBlock: lastRewardBlock,
1471             accCurryPerShare: 0
1472         }));
1473         // Audit
1474         poolExist[_lpToken]=true;
1475     }
1476 
1477     // Update the given pool's CURRY allocation point. Can only be called by the owner.
1478     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1479         if (_withUpdate) {
1480             massUpdatePools();
1481         }
1482         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1483         poolInfo[_pid].allocPoint = _allocPoint;
1484     }
1485 
1486     // Return reward multiplier over the given _from to _to block.
1487     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1488         if (_to <= bonusEndBlock) {
1489             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1490         } else if (_from >= bonusEndBlock) {
1491             return _to.sub(_from);
1492         } else {
1493             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1494                 _to.sub(bonusEndBlock)
1495             );
1496         }
1497     }
1498 
1499     // Update reward vairables for all pools. Be careful of gas spending!
1500     function massUpdatePools() public {
1501         uint256 length = poolInfo.length;
1502         for (uint256 pid = 0; pid < length; ++pid) {
1503             updatePool(pid);
1504         }
1505     }
1506 
1507     // Update reward variables of the given pool to be up-to-date.
1508     function updatePool(uint256 _pid) public {
1509         PoolInfo storage pool = poolInfo[_pid];
1510         if (block.number <= pool.lastRewardBlock) {
1511             return;
1512         }
1513         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1514         if (lpSupply == 0) {
1515             pool.lastRewardBlock = block.number;
1516             return;
1517         }
1518   
1519         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1520         uint256 curryReward = multiplier.mul(curryPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1521         uint256 devrew = curryReward.mul(MINTED_STAKE_PERCENTAGE_TEAM).div(100); // 11% to dev/ team address
1522         uint256 staticstakerew = curryReward.mul(MINTED_STAKE_PERCENTAGE_STATICSTAKERS).div(100); // 9% to staic staking address
1523         uint256 liquipoolrew =  curryReward.sub(devrew.add(staticstakerew)); // rest to liquidity pool
1524         
1525         //distribute tokens
1526         curry.mint(devaddr, devrew); 
1527         curry.mint(address(staticTokenRewardContract), staticstakerew);
1528         curry.mint(address(this), liquipoolrew);
1529         
1530         // call function to allocate the tokens to each static reward holders
1531         staticTokenRewardContract.distribute(staticstakerew);
1532         
1533         
1534         pool.accCurryPerShare = pool.accCurryPerShare.add(curryReward.mul(TRILLION).div(lpSupply));
1535         pool.lastRewardBlock = block.number;
1536     }
1537 
1538     // Deposit LP tokens to CurryChef for CURRY allocation. - Audit
1539     function deposit(uint256 _pid, uint256 _amount) public {
1540         PoolInfo storage pool = poolInfo[_pid];
1541         UserInfo storage user = userInfo[_pid][msg.sender];
1542         updatePool(_pid);
1543         if (user.amount > 0) {
1544             uint256 pending = user.amount.mul(pool.accCurryPerShare).div(TRILLION).sub(user.rewardDebt);
1545             if(pending > 0) {
1546                 _safeCurryTransfer(msg.sender, pending);// Audit
1547             }
1548         }
1549         if(_amount > 0) {
1550             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1551             user.amount = user.amount.add(_amount);
1552         }
1553         user.rewardDebt = user.amount.mul(pool.accCurryPerShare).div(TRILLION);
1554         emit Deposit(msg.sender, _pid, _amount);
1555     }
1556     
1557 
1558     // Withdraw LP tokens from CurryChef - Audit
1559     function withdraw(uint256 _pid, uint256 _amount) public {
1560         PoolInfo storage pool = poolInfo[_pid];
1561         UserInfo storage user = userInfo[_pid][msg.sender];
1562         require(user.amount >= _amount, "withdraw: not good");
1563         updatePool(_pid);
1564         uint256 pending = user.amount.mul(pool.accCurryPerShare).div(TRILLION).sub(user.rewardDebt);
1565         uint256 unstakeReward = pending.sub(pending.mul(5).div(1e3)); // 0.5% to unstaked address
1566         
1567          if(pending > 0) {
1568            // send back 0.5% to unstake address and 99.5% to user/ caller
1569             _safeCurryTransfer(msg.sender,unstakeReward); // Audit
1570             _safeCurryTransfer(unstakeRewardAddress, pending.sub(unstakeReward));// Audit
1571          }
1572          if(_amount > 0) {
1573              user.amount = user.amount.sub(_amount);
1574              pool.lpToken.safeTransfer(address(msg.sender), _amount);
1575              
1576          }
1577         user.rewardDebt = user.amount.mul(pool.accCurryPerShare).div(TRILLION);
1578         emit Withdraw(msg.sender, _pid, _amount);
1579     }
1580 
1581     // Withdraw without caring about rewards. EMERGENCY ONLY.
1582     function emergencyWithdraw(uint256 _pid) public {
1583         PoolInfo storage pool = poolInfo[_pid];
1584         UserInfo storage user = userInfo[_pid][msg.sender];
1585         // checks-effects-interactions - Audit
1586         uint256 userAmount = user.amount;
1587         user.amount = 0;
1588         user.rewardDebt = 0;
1589         pool.lpToken.safeTransfer(address(msg.sender), userAmount);
1590         emit EmergencyWithdraw(msg.sender, _pid, userAmount);
1591      
1592     }
1593     
1594     // Update dev address by the previous dev.
1595     function dev(address _devaddr) public {
1596         require(msg.sender == devaddr, "dev: wut?");
1597         devaddr = _devaddr;
1598     }
1599 
1600     // Safe curry transfer function, just in case if rounding error causes pool to not have enough Currys.
1601     function _safeCurryTransfer(address _to, uint256 _amount) internal {
1602         uint256 curryBal = curry.balanceOf(address(this));
1603         if (_amount > curryBal) {
1604             curry.transfer(_to, curryBal);
1605         } else {
1606             curry.transfer(_to, _amount);
1607         }
1608     }
1609 
1610 }