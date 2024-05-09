1 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // pragma solidity ^0.6.0;
33 
34 // import "@openzeppelin/contracts/GSN/Context.sol";
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () internal {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 
100 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
101 
102 
103 // pragma solidity ^0.6.0;
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
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
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 
262 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
263 
264 
265 // pragma solidity ^0.6.0;
266 
267 /**
268  * @dev Interface of the ERC20 standard as defined in the EIP.
269  */
270 interface IERC20 {
271     /**
272      * @dev Returns the amount of tokens in existence.
273      */
274     function totalSupply() external view returns (uint256);
275 
276     /**
277      * @dev Returns the amount of tokens owned by `account`.
278      */
279     function balanceOf(address account) external view returns (uint256);
280 
281     /**
282      * @dev Moves `amount` tokens from the caller's account to `recipient`.
283      *
284      * Returns a boolean value indicating whether the operation succeeded.
285      *
286      * Emits a {Transfer} event.
287      */
288     function transfer(address recipient, uint256 amount) external returns (bool);
289 
290     /**
291      * @dev Returns the remaining number of tokens that `spender` will be
292      * allowed to spend on behalf of `owner` through {transferFrom}. This is
293      * zero by default.
294      *
295      * This value changes when {approve} or {transferFrom} are called.
296      */
297     function allowance(address owner, address spender) external view returns (uint256);
298 
299     /**
300      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
301      *
302      * Returns a boolean value indicating whether the operation succeeded.
303      *
304      * // importANT: Beware that changing an allowance with this method brings the risk
305      * that someone may use both the old and the new allowance by unfortunate
306      * transaction ordering. One possible solution to mitigate this race
307      * condition is to first reduce the spender's allowance to 0 and set the
308      * desired value afterwards:
309      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310      *
311      * Emits an {Approval} event.
312      */
313     function approve(address spender, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Moves `amount` tokens from `sender` to `recipient` using the
317      * allowance mechanism. `amount` is then deducted from the caller's
318      * allowance.
319      *
320      * Returns a boolean value indicating whether the operation succeeded.
321      *
322      * Emits a {Transfer} event.
323      */
324     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
325 
326     /**
327      * @dev Emitted when `value` tokens are moved from one account (`from`) to
328      * another (`to`).
329      *
330      * Note that `value` may be zero.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 value);
333 
334     /**
335      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
336      * a call to {approve}. `value` is the new allowance.
337      */
338     event Approval(address indexed owner, address indexed spender, uint256 value);
339 }
340 
341 
342 // Dependency file: @openzeppelin/contracts/utils/Address.sol
343 
344 
345 // pragma solidity ^0.6.2;
346 
347 /**
348  * @dev Collection of functions related to the address type
349  */
350 library Address {
351     /**
352      * @dev Returns true if `account` is a contract.
353      *
354      * [// importANT]
355      * ====
356      * It is unsafe to assume that an address for which this function returns
357      * false is an externally-owned account (EOA) and not a contract.
358      *
359      * Among others, `isContract` will return false for the following
360      * types of addresses:
361      *
362      *  - an externally-owned account
363      *  - a contract in construction
364      *  - an address where a contract will be created
365      *  - an address where a contract lived, but was destroyed
366      * ====
367      */
368     function isContract(address account) internal view returns (bool) {
369         // This method relies in extcodesize, which returns 0 for contracts in
370         // construction, since the code is only stored at the end of the
371         // constructor execution.
372 
373         uint256 size;
374         // solhint-disable-next-line no-inline-assembly
375         assembly { size := extcodesize(account) }
376         return size > 0;
377     }
378 
379     /**
380      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
381      * `recipient`, forwarding all available gas and reverting on errors.
382      *
383      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
384      * of certain opcodes, possibly making contracts go over the 2300 gas limit
385      * imposed by `transfer`, making them unable to receive funds via
386      * `transfer`. {sendValue} removes this limitation.
387      *
388      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
389      *
390      * // importANT: because control is transferred to `recipient`, care must be
391      * taken to not create reentrancy vulnerabilities. Consider using
392      * {ReentrancyGuard} or the
393      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
394      */
395     function sendValue(address payable recipient, uint256 amount) internal {
396         require(address(this).balance >= amount, "Address: insufficient balance");
397 
398         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
399         (bool success, ) = recipient.call{ value: amount }("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 
403     /**
404      * @dev Performs a Solidity function call using a low level `call`. A
405      * plain`call` is an unsafe replacement for a function call: use this
406      * function instead.
407      *
408      * If `target` reverts with a revert reason, it is bubbled up by this
409      * function (like regular Solidity function calls).
410      *
411      * Returns the raw returned data. To convert to the expected return value,
412      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
413      *
414      * Requirements:
415      *
416      * - `target` must be a contract.
417      * - calling `target` with `data` must not revert.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
422       return functionCall(target, data, "Address: low-level call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
427      * `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
432         return _functionCallWithValue(target, data, 0, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but also transferring `value` wei to `target`.
438      *
439      * Requirements:
440      *
441      * - the calling contract must have an ETH balance of at least `value`.
442      * - the called Solidity function must be `payable`.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
457         require(address(this).balance >= value, "Address: insufficient balance for call");
458         return _functionCallWithValue(target, data, value, errorMessage);
459     }
460 
461     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
462         require(isContract(target), "Address: call to non-contract");
463 
464         // solhint-disable-next-line avoid-low-level-calls
465         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 // solhint-disable-next-line no-inline-assembly
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 
486 // Dependency file: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
487 
488 
489 // pragma solidity ^0.6.0;
490 
491 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
492 // import "@openzeppelin/contracts/math/SafeMath.sol";
493 // import "@openzeppelin/contracts/utils/Address.sol";
494 
495 /**
496  * @title SafeERC20
497  * @dev Wrappers around ERC20 operations that throw on failure (when the token
498  * contract returns false). Tokens that return no value (and instead revert or
499  * throw on failure) are also supported, non-reverting calls are assumed to be
500  * successful.
501  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
502  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
503  */
504 library SafeERC20 {
505     using SafeMath for uint256;
506     using Address for address;
507 
508     function safeTransfer(IERC20 token, address to, uint256 value) internal {
509         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
510     }
511 
512     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
514     }
515 
516     /**
517      * @dev Deprecated. This function has issues similar to the ones found in
518      * {IERC20-approve}, and its usage is discouraged.
519      *
520      * Whenever possible, use {safeIncreaseAllowance} and
521      * {safeDecreaseAllowance} instead.
522      */
523     function safeApprove(IERC20 token, address spender, uint256 value) internal {
524         // safeApprove should only be called when setting an initial allowance,
525         // or when resetting it to zero. To increase and decrease it, use
526         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
527         // solhint-disable-next-line max-line-length
528         require((value == 0) || (token.allowance(address(this), spender) == 0),
529             "SafeERC20: approve from non-zero to non-zero allowance"
530         );
531         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
532     }
533 
534     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
535         uint256 newAllowance = token.allowance(address(this), spender).add(value);
536         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
537     }
538 
539     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
540         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
541         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
542     }
543 
544     /**
545      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
546      * on the return value: the return value is optional (but if data is returned, it must not be false).
547      * @param token The token targeted by the call.
548      * @param data The call data (encoded using abi.encode or one of its variants).
549      */
550     function _callOptionalReturn(IERC20 token, bytes memory data) private {
551         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
552         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
553         // the target address contains contract code and also asserts for success in the low-level call.
554 
555         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
556         if (returndata.length > 0) { // Return data is optional
557             // solhint-disable-next-line max-line-length
558             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
559         }
560     }
561 }
562 
563 
564 // Dependency file: @openzeppelin/contracts/utils/EnumerableSet.sol
565 
566 
567 // pragma solidity ^0.6.0;
568 
569 /**
570  * @dev Library for managing
571  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
572  * types.
573  *
574  * Sets have the following properties:
575  *
576  * - Elements are added, removed, and checked for existence in constant time
577  * (O(1)).
578  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
579  *
580  * ```
581  * contract Example {
582  *     // Add the library methods
583  *     using EnumerableSet for EnumerableSet.AddressSet;
584  *
585  *     // Declare a set state variable
586  *     EnumerableSet.AddressSet private mySet;
587  * }
588  * ```
589  *
590  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
591  * (`UintSet`) are supported.
592  */
593 library EnumerableSet {
594     // To implement this library for multiple types with as little code
595     // repetition as possible, we write it in terms of a generic Set type with
596     // bytes32 values.
597     // The Set implementation uses private functions, and user-facing
598     // implementations (such as AddressSet) are just wrappers around the
599     // underlying Set.
600     // This means that we can only create new EnumerableSets for types that fit
601     // in bytes32.
602 
603     struct Set {
604         // Storage of set values
605         bytes32[] _values;
606 
607         // Position of the value in the `values` array, plus 1 because index 0
608         // means a value is not in the set.
609         mapping (bytes32 => uint256) _indexes;
610     }
611 
612     /**
613      * @dev Add a value to a set. O(1).
614      *
615      * Returns true if the value was added to the set, that is if it was not
616      * already present.
617      */
618     function _add(Set storage set, bytes32 value) private returns (bool) {
619         if (!_contains(set, value)) {
620             set._values.push(value);
621             // The value is stored at length-1, but we add 1 to all indexes
622             // and use 0 as a sentinel value
623             set._indexes[value] = set._values.length;
624             return true;
625         } else {
626             return false;
627         }
628     }
629 
630     /**
631      * @dev Removes a value from a set. O(1).
632      *
633      * Returns true if the value was removed from the set, that is if it was
634      * present.
635      */
636     function _remove(Set storage set, bytes32 value) private returns (bool) {
637         // We read and store the value's index to prevent multiple reads from the same storage slot
638         uint256 valueIndex = set._indexes[value];
639 
640         if (valueIndex != 0) { // Equivalent to contains(set, value)
641             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
642             // the array, and then remove the last element (sometimes called as 'swap and pop').
643             // This modifies the order of the array, as noted in {at}.
644 
645             uint256 toDeleteIndex = valueIndex - 1;
646             uint256 lastIndex = set._values.length - 1;
647 
648             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
649             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
650 
651             bytes32 lastvalue = set._values[lastIndex];
652 
653             // Move the last value to the index where the value to delete is
654             set._values[toDeleteIndex] = lastvalue;
655             // Update the index for the moved value
656             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
657 
658             // Delete the slot where the moved value was stored
659             set._values.pop();
660 
661             // Delete the index for the deleted slot
662             delete set._indexes[value];
663 
664             return true;
665         } else {
666             return false;
667         }
668     }
669 
670     /**
671      * @dev Returns true if the value is in the set. O(1).
672      */
673     function _contains(Set storage set, bytes32 value) private view returns (bool) {
674         return set._indexes[value] != 0;
675     }
676 
677     /**
678      * @dev Returns the number of values on the set. O(1).
679      */
680     function _length(Set storage set) private view returns (uint256) {
681         return set._values.length;
682     }
683 
684    /**
685     * @dev Returns the value stored at position `index` in the set. O(1).
686     *
687     * Note that there are no guarantees on the ordering of values inside the
688     * array, and it may change when more values are added or removed.
689     *
690     * Requirements:
691     *
692     * - `index` must be strictly less than {length}.
693     */
694     function _at(Set storage set, uint256 index) private view returns (bytes32) {
695         require(set._values.length > index, "EnumerableSet: index out of bounds");
696         return set._values[index];
697     }
698 
699     // AddressSet
700 
701     struct AddressSet {
702         Set _inner;
703     }
704 
705     /**
706      * @dev Add a value to a set. O(1).
707      *
708      * Returns true if the value was added to the set, that is if it was not
709      * already present.
710      */
711     function add(AddressSet storage set, address value) internal returns (bool) {
712         return _add(set._inner, bytes32(uint256(value)));
713     }
714 
715     /**
716      * @dev Removes a value from a set. O(1).
717      *
718      * Returns true if the value was removed from the set, that is if it was
719      * present.
720      */
721     function remove(AddressSet storage set, address value) internal returns (bool) {
722         return _remove(set._inner, bytes32(uint256(value)));
723     }
724 
725     /**
726      * @dev Returns true if the value is in the set. O(1).
727      */
728     function contains(AddressSet storage set, address value) internal view returns (bool) {
729         return _contains(set._inner, bytes32(uint256(value)));
730     }
731 
732     /**
733      * @dev Returns the number of values in the set. O(1).
734      */
735     function length(AddressSet storage set) internal view returns (uint256) {
736         return _length(set._inner);
737     }
738 
739    /**
740     * @dev Returns the value stored at position `index` in the set. O(1).
741     *
742     * Note that there are no guarantees on the ordering of values inside the
743     * array, and it may change when more values are added or removed.
744     *
745     * Requirements:
746     *
747     * - `index` must be strictly less than {length}.
748     */
749     function at(AddressSet storage set, uint256 index) internal view returns (address) {
750         return address(uint256(_at(set._inner, index)));
751     }
752 
753 
754     // UintSet
755 
756     struct UintSet {
757         Set _inner;
758     }
759 
760     /**
761      * @dev Add a value to a set. O(1).
762      *
763      * Returns true if the value was added to the set, that is if it was not
764      * already present.
765      */
766     function add(UintSet storage set, uint256 value) internal returns (bool) {
767         return _add(set._inner, bytes32(value));
768     }
769 
770     /**
771      * @dev Removes a value from a set. O(1).
772      *
773      * Returns true if the value was removed from the set, that is if it was
774      * present.
775      */
776     function remove(UintSet storage set, uint256 value) internal returns (bool) {
777         return _remove(set._inner, bytes32(value));
778     }
779 
780     /**
781      * @dev Returns true if the value is in the set. O(1).
782      */
783     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
784         return _contains(set._inner, bytes32(value));
785     }
786 
787     /**
788      * @dev Returns the number of values on the set. O(1).
789      */
790     function length(UintSet storage set) internal view returns (uint256) {
791         return _length(set._inner);
792     }
793 
794    /**
795     * @dev Returns the value stored at position `index` in the set. O(1).
796     *
797     * Note that there are no guarantees on the ordering of values inside the
798     * array, and it may change when more values are added or removed.
799     *
800     * Requirements:
801     *
802     * - `index` must be strictly less than {length}.
803     */
804     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
805         return uint256(_at(set._inner, index));
806     }
807 }
808 
809 
810 // Root file: contracts/MasterGame.sol
811 
812 pragma solidity ^0.6.12;
813 
814 // import "@openzeppelin/contracts/access/Ownable.sol";
815 // import "@openzeppelin/contracts/math/SafeMath.sol";
816 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
817 // import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
818 // import "@openzeppelin/contracts/utils/EnumerableSet.sol";
819 
820 /**
821  * @dev Ticket contract interface
822  */
823 interface ITicketsToken is IERC20 {
824     function burnFromUsdt(address account, uint256 usdtAmount) external;
825 
826     function vendingAndBurn(address account, uint256 amount) external;
827 
828     function price() external returns (uint256);
829 
830     function totalVending() external returns (uint256);
831 }
832 
833 /**
834  * @dev Master contract
835  */
836 contract MasterGame is Ownable {
837     using SafeERC20 for IERC20;
838     using SafeMath for uint256;
839     using EnumerableSet for EnumerableSet.AddressSet;
840 
841     IERC20 usdt;
842     uint256 constant usdter = 1e6;
843 
844     // Creation time
845     uint256 public createdAt;
846     // Total revenue
847     uint256 public totalRevenue;
848 
849     // Ticket contract
850     ITicketsToken ticket;
851 
852     // Static income cycle: 1 day
853     uint256 constant STATIC_CYCLE = 1 days;
854     // Daily prize pool cycle: 1 day
855     uint256 constant DAY_POOL_CYCLE = 1 days;
856     // Weekly prize pool cycle: 7 days
857     uint256 constant WEEK_POOL_CYCLE = 7 days;
858     // Upgrade node discount: 100 days
859     uint256 constant NODE_DISCOUNT_TIME = 100 days;
860 
861     // Static rate of return, parts per thousand
862     uint256 staticRate = 5;
863     // Dynamic rate of return, parts per thousand
864     uint256[12] dynamicRates = [
865         100,
866         80,
867         60,
868         50,
869         50,
870         60,
871         70,
872         50,
873         50,
874         50,
875         60,
876         80
877     ];
878     // Technology founding team
879     uint256 public founder;
880     // Market value management fee
881     uint256 public operation;
882     // Insurance pool
883     uint256 public insurance;
884     // Perpetual capital pool
885     uint256 public sustainable;
886     // Dex Market making
887     uint256 public dex;
888     // Account ID
889     uint256 public id;
890     // Number of people activating Pa Point
891     uint8 public nodeBurnNumber;
892     // Account data
893     mapping(address => Account) public accounts;
894     mapping(address => AccountCount) public stats;
895     // Node burn data
896     mapping(address => AccountNodeBurn) public burns;
897     // Team data
898     mapping(address => AccountPerformance) public performances;
899     mapping(address => address[]) public teams;
900     // Node data
901     // 1 Light node; 2 Intermediate node; 3 Super node; 4 Genesis node
902     mapping(uint8 => address[]) public nodes;
903 
904     // Weekly prize pool
905     uint64 public weekPoolId;
906     mapping(uint64 => Pool) public weekPool;
907 
908     // Daily prize pool
909     uint64 public dayPoolId;
910     mapping(uint64 => Pool) public dayPool;
911 
912     // Address with a deposit of 15,000 or more
913     EnumerableSet.AddressSet private richman;
914 
915     // Account
916     struct Account {
917         uint256 id;
918         address referrer; // Direct push
919         bool reinvest; // Whether to reinvest
920         uint8 nodeLevel; // Node level
921         uint256 joinTime; // Join time: This value needs to be updated when joining again
922         uint256 lastTakeTime; // Last time the static income was received
923         uint256 deposit; // Deposited quantity: 0 means "out"
924         uint256 nodeIncome; // Node revenue balance
925         uint256 dayPoolIncome; // Daily bonus pool income balance
926         uint256 weekPoolIncome; // Weekly bonus pool income balance
927         uint256 dynamicIncome; // Dynamic income balance
928         uint256 income; // Total revenue
929         uint256 maxIncome; // Exit condition
930         uint256 reward; // Additional other rewards
931     }
932 
933     // Account statistics
934     struct AccountCount {
935         uint256 income; // Total revenue
936         uint256 investment; // Total investment
937     }
938 
939     // Performance
940     struct AccountPerformance {
941         uint256 performance; // Direct performance
942         uint256 wholeLine; // Performance of all layers below
943     }
944 
945     // Node burn
946     struct AccountNodeBurn {
947         bool active; // Whether to activate Node burn
948         uint256 income; // Node burn income
949     }
950 
951     // Prize pool
952     struct Pool {
953         uint256 amount; // Prize pool amount
954         uint256 date; // Creation time: Use this field to determine the draw time
955         mapping(uint8 => address) ranks; // Ranking: up to 256
956         mapping(address => uint256) values; // Quantity/Performance
957     }
958 
959     /**
960      * @dev Determine whether the address is an already added address
961      */
962     modifier onlyJoined(address addr) {
963         require(accounts[addr].id > 0, "ANR");
964         _;
965     }
966 
967     constructor(IERC20 _usdt) public {
968         usdt = _usdt;
969 
970         createdAt = now;
971 
972         // Genius
973         Account storage user = accounts[msg.sender];
974         user.id = ++id;
975         user.referrer = address(0);
976         user.joinTime = now;
977     }
978 
979     /**
980      * @dev Join or reinvest the game
981      */
982     function join(address referrer, uint256 _amount)
983         public
984         onlyJoined(referrer)
985     {
986         require(referrer != msg.sender, "NS");
987         require(_amount >= usdter.mul(100), "MIN");
988 
989         // Receive USDT
990         usdt.safeTransferFrom(msg.sender, address(this), _amount);
991 
992         // Burn 12%
993         _handleJoinBurn(msg.sender, _amount);
994 
995         Account storage user = accounts[msg.sender];
996         // Create new account
997         if (user.id == 0) {
998             user.id = ++id;
999             user.referrer = referrer;
1000             user.joinTime = now;
1001             // Direct team
1002             teams[referrer].push(msg.sender);
1003         }
1004 
1005         // Reinvest to join
1006         if (user.deposit != 0) {
1007             require(!user.reinvest, "Reinvest");
1008 
1009             // Can reinvest after paying back
1010             uint256 income = calculateStaticIncome(msg.sender)
1011                 .add(user.dynamicIncome)
1012                 .add(user.nodeIncome)
1013                 .add(burns[msg.sender].income)
1014                 .add(user.income);
1015             require(income >= user.deposit, "Not Coast");
1016 
1017             // Half or all reinvestment
1018             require(
1019                 _amount == user.deposit || _amount == user.deposit.div(2),
1020                 "FOH"
1021             );
1022 
1023             if (_amount == user.deposit) {
1024                 // All reinvestment
1025                 user.maxIncome = user.maxIncome.add(
1026                     _calculateFullOutAmount(_amount)
1027                 );
1028             } else {
1029                 // Half return
1030                 user.maxIncome = user.maxIncome.add(
1031                     _calculateOutAmount(_amount)
1032                 );
1033             }
1034             user.reinvest = true;
1035             user.deposit = user.deposit.add(_amount);
1036         } else {
1037             // Join out
1038             user.deposit = _amount;
1039             user.lastTakeTime = now;
1040             user.maxIncome = _calculateOutAmount(_amount);
1041             // Cumulative income cleared
1042             user.nodeIncome = 0;
1043             user.dayPoolIncome = 0;
1044             user.weekPoolIncome = 0;
1045             user.dynamicIncome = 0;
1046             burns[msg.sender].income = 0;
1047         }
1048 
1049         // Processing performance
1050         performances[msg.sender].wholeLine = performances[msg.sender]
1051             .wholeLine
1052             .add(_amount);
1053         _handlePerformance(user.referrer, _amount);
1054         // Processing node rewards
1055         _handleNodeReward(_amount);
1056         // Handling Node burn Reward
1057         _handleNodeBurnReward(msg.sender, _amount);
1058         // Processing node level
1059         _handleNodeLevel(user.referrer);
1060         // Handling prizes and draws
1061         _handlePool(user.referrer, _amount);
1062 
1063         // Technology founding team: 4%
1064         founder = founder.add(_amount.mul(4).div(100));
1065         // Expansion operating expenses: 4%
1066         operation = operation.add(_amount.mul(4).div(100));
1067         // Dex market making capital 2%
1068         dex = dex.add(_amount.mul(2).div(100));
1069 
1070         // Insurance pool: 1.5%
1071         insurance = insurance.add(_amount.mul(15).div(1000));
1072         // Perpetual pool: 3.5%
1073         sustainable = sustainable.add(_amount.mul(35).div(1000));
1074 
1075         // Record the address of deposit 15000
1076         if (user.deposit >= usdter.mul(15000)) {
1077             EnumerableSet.add(richman, msg.sender);
1078         }
1079 
1080         // Statistics total investment
1081         stats[msg.sender].investment = stats[msg.sender].investment.add(
1082             _amount
1083         );
1084         // Total revenue
1085         totalRevenue = totalRevenue.add(_amount);
1086     }
1087 
1088     /**
1089      * @dev Burn tickets when you join
1090      */
1091     function _handleJoinBurn(address addr, uint256 _amount) internal {
1092         uint256 burnUsdt = _amount.mul(12).div(100);
1093         uint256 burnAmount = burnUsdt.mul(ticket.price()).div(usdter);
1094         uint256 bal = ticket.balanceOf(addr);
1095 
1096         if (bal >= burnAmount) {
1097             ticket.burnFromUsdt(addr, burnUsdt);
1098         } else {
1099             // USDT can be used to deduct tickets after the resonance of 4.5 million
1100             require(
1101                 ticket.totalVending() >= uint256(1e18).mul(4500000),
1102                 "4.5M"
1103             );
1104 
1105             // Use USDT to deduct tickets
1106             usdt.safeTransferFrom(addr, address(this), burnUsdt);
1107             ticket.vendingAndBurn(addr, burnAmount);
1108         }
1109     }
1110 
1111     /**
1112      * @dev Receive revenue and calculate outgoing data
1113      */
1114     function take() public onlyJoined(msg.sender) {
1115         Account storage user = accounts[msg.sender];
1116 
1117         require(user.deposit > 0, "OUT");
1118 
1119         uint256 staticIncome = calculateStaticIncome(msg.sender);
1120         if (staticIncome > 0) {
1121             user.lastTakeTime =
1122                 now -
1123                 ((now - user.lastTakeTime) % STATIC_CYCLE);
1124         }
1125 
1126         uint256 paid = staticIncome
1127             .add(user.dynamicIncome)
1128             .add(user.nodeIncome)
1129             .add(burns[msg.sender].income);
1130 
1131         // Cleared
1132         user.nodeIncome = 0;
1133         user.dynamicIncome = 0;
1134         burns[msg.sender].income = 0;
1135 
1136         // Cumulative income
1137         user.income = user.income.add(paid);
1138 
1139         // Meet the exit conditions, or no re-investment and reach 1.3 times
1140         uint256 times13 = user.deposit.mul(13).div(10);
1141         bool special = !user.reinvest && user.income >= times13;
1142         // Out of the game
1143         if (user.income >= user.maxIncome || special) {
1144             // Deduct excess income
1145             if (special) {
1146                 paid = times13.sub(user.income.sub(paid));
1147             } else {
1148                 paid = paid.sub(user.income.sub(user.maxIncome));
1149             }
1150             // Data clear
1151             user.deposit = 0;
1152             user.income = 0;
1153             user.maxIncome = 0;
1154             user.reinvest = false;
1155         }
1156 
1157         // Static income returns to superior dynamic income
1158         // When zooming in half of the quota (including re-investment), dynamic acceleration is not provided to the upper 12 layers
1159         if (staticIncome > 0 && user.income < user.maxIncome.div(2)) {
1160             _handleDynamicIncome(msg.sender, staticIncome);
1161         }
1162 
1163         // Total income statistics
1164         stats[msg.sender].income = stats[msg.sender].income.add(paid);
1165 
1166         // USDT transfer
1167         _safeUsdtTransfer(msg.sender, paid);
1168 
1169         // Trigger
1170         _openWeekPool();
1171         _openDayPool();
1172     }
1173 
1174     /**
1175      * @dev Receive insurance pool rewards
1176      */
1177     function takeReward() public {
1178         uint256 paid = accounts[msg.sender].reward;
1179         accounts[msg.sender].reward = 0;
1180         usdt.safeTransfer(msg.sender, paid);
1181 
1182         // Total income statistics
1183         stats[msg.sender].income = stats[msg.sender].income.add(paid);
1184     }
1185 
1186     /**
1187      * @dev Receive prize pool income
1188      */
1189     function takePoolIncome() public {
1190         Account storage user = accounts[msg.sender];
1191 
1192         uint256 paid = user.dayPoolIncome.add(user.weekPoolIncome);
1193         user.dayPoolIncome = 0;
1194         user.weekPoolIncome = 0;
1195 
1196         // Total income statistics
1197         stats[msg.sender].income = stats[msg.sender].income.add(paid);
1198 
1199         _safeUsdtTransfer(msg.sender, paid);
1200     }
1201 
1202     /**
1203      * @dev To activate Node burn, you need to destroy some tickets worth a specific USDT
1204      */
1205     function activateNodeBurn() public onlyJoined(msg.sender) {
1206         require(!burns[msg.sender].active, "ACT");
1207         require(nodeBurnNumber < 500, "LIMIT");
1208 
1209         uint256 burn = activateNodeBurnAmount();
1210 
1211         ticket.burnFromUsdt(msg.sender, burn);
1212         nodeBurnNumber++;
1213 
1214         burns[msg.sender].active = true;
1215     }
1216 
1217     /**
1218      * @dev Get the amount of USDT that activates the burned ticket for Node burn
1219      */
1220     function activateNodeBurnAmount() public view returns (uint256) {
1221         uint8 num = nodeBurnNumber + 1;
1222 
1223         if (num >= 400) {
1224             return usdter.mul(7000);
1225         } else if (num >= 300) {
1226             return usdter.mul(6000);
1227         } else if (num >= 200) {
1228             return usdter.mul(5000);
1229         } else if (num >= 100) {
1230             return usdter.mul(4000);
1231         } else {
1232             return usdter.mul(3000);
1233         }
1234     }
1235 
1236     /**
1237      * @dev Handling Node burn Reward
1238      */
1239     function _handleNodeBurnReward(address addr, uint256 _amount) internal {
1240         address referrer = accounts[addr].referrer;
1241         bool pioneer = false;
1242 
1243         while (referrer != address(0)) {
1244             AccountNodeBurn storage ap = burns[referrer];
1245             if (ap.active) {
1246                 if (accounts[referrer].nodeLevel > 0) {
1247                     uint256 paid;
1248                     if (pioneer) {
1249                         paid = _amount.mul(4).div(100); // 4%
1250                     } else {
1251                         paid = _amount.mul(7).div(100); // 7%
1252                     }
1253                     ap.income = ap.income.add(paid);
1254                     break;
1255                 } else if (!pioneer) {
1256                     ap.income = ap.income.add(_amount.mul(3).div(100)); // 3%
1257                     pioneer = true;
1258                 }
1259             }
1260             referrer = accounts[referrer].referrer;
1261         }
1262     }
1263 
1264     /**
1265      * @dev Dealing with dynamic revenue
1266      */
1267     function _handleDynamicIncome(address addr, uint256 _amount) internal {
1268         address account = accounts[addr].referrer;
1269         // Up to 12 layers
1270         for (uint8 i = 1; i <= 12; i++) {
1271             if (account == address(0)) {
1272                 break;
1273             }
1274 
1275             Account storage user = accounts[account];
1276             if (
1277                 user.deposit > 0 &&
1278                 _canDynamicIncomeAble(
1279                     performances[account].performance,
1280                     user.deposit,
1281                     i
1282                 )
1283             ) {
1284                 uint256 _income = _amount.mul(dynamicRates[i - 1]).div(1000);
1285                 user.dynamicIncome = user.dynamicIncome.add(_income);
1286             }
1287 
1288             account = user.referrer;
1289         }
1290     }
1291 
1292     /**
1293      * @dev Judge whether you can get dynamic income
1294      */
1295     function _canDynamicIncomeAble(
1296         uint256 performance,
1297         uint256 deposit,
1298         uint8 floor
1299     ) internal pure returns (bool) {
1300         // Deposit more than 1500
1301         if (deposit >= usdter.mul(1500)) {
1302             if (performance >= usdter.mul(10000)) {
1303                 return floor <= 12;
1304             }
1305             if (performance >= usdter.mul(6000)) {
1306                 return floor <= 8;
1307             }
1308             if (performance >= usdter.mul(3000)) {
1309                 return floor <= 5;
1310             }
1311             if (performance >= usdter.mul(1500)) {
1312                 return floor <= 3;
1313             }
1314         } else if (deposit >= usdter.mul(300)) {
1315             if (performance >= usdter.mul(1500)) {
1316                 return floor <= 3;
1317             }
1318         }
1319         return floor <= 1;
1320     }
1321 
1322     /**
1323      * @dev Process prize pool data and draw
1324      */
1325     function _handlePool(address referrer, uint256 _amount) internal {
1326         _openWeekPool();
1327         _openDayPool();
1328 
1329         uint256 prize = _amount.mul(3).div(100); // 3%
1330 
1331         uint256 dayPrize = prize.mul(60).div(100); // 60%
1332         uint256 weekPrize = prize.sub(dayPrize); // 40%
1333 
1334         _handleWeekPool(referrer, _amount, weekPrize);
1335         _handleDayPool(referrer, _amount, dayPrize);
1336     }
1337 
1338     /**
1339      * @dev Manually trigger the draw
1340      */
1341     function triggerOpenPool() public {
1342         _openWeekPool();
1343         _openDayPool();
1344     }
1345 
1346     /**
1347      * @dev Processing weekly prize pool
1348      */
1349     function _handleWeekPool(
1350         address referrer,
1351         uint256 _amount,
1352         uint256 _prize
1353     ) internal {
1354         Pool storage week = weekPool[weekPoolId];
1355 
1356         week.amount = week.amount.add(_prize);
1357         week.values[referrer] = week.values[referrer].add(_amount);
1358         _PoolSort(week, referrer, 3);
1359     }
1360 
1361     /**
1362      * @dev Handling the daily prize pool
1363      */
1364     function _handleDayPool(
1365         address referrer,
1366         uint256 _amount,
1367         uint256 _prize
1368     ) internal {
1369         Pool storage day = dayPool[dayPoolId];
1370 
1371         day.amount = day.amount.add(_prize);
1372         day.values[referrer] = day.values[referrer].add(_amount);
1373         _PoolSort(day, referrer, 7);
1374     }
1375 
1376     /**
1377      * @dev Prize pool sorting
1378      */
1379     function _PoolSort(
1380         Pool storage pool,
1381         address addr,
1382         uint8 number
1383     ) internal {
1384         for (uint8 i = 0; i < number; i++) {
1385             address key = pool.ranks[i];
1386             if (key == addr) {
1387                 break;
1388             }
1389             if (pool.values[addr] > pool.values[key]) {
1390                 for (uint8 j = number; j > i; j--) {
1391                     pool.ranks[j] = pool.ranks[j - 1];
1392                 }
1393                 pool.ranks[i] = addr;
1394 
1395                 for (uint8 k = i + 1; k < number; k++) {
1396                     if (pool.ranks[k] == addr) {
1397                         for (uint8 l = k; l < number; l++) {
1398                             pool.ranks[l] = pool.ranks[l + 1];
1399                         }
1400                         break;
1401                     }
1402                 }
1403                 break;
1404             }
1405         }
1406     }
1407 
1408     /**
1409      * @dev Weekly prize pool draw
1410      */
1411     function _openWeekPool() internal {
1412         Pool storage week = weekPool[weekPoolId];
1413         // Determine whether the weekly prize pool can draw prizes
1414         if (now >= week.date + WEEK_POOL_CYCLE) {
1415             weekPoolId++;
1416             weekPool[weekPoolId].date = now;
1417 
1418             // 15% for the draw
1419             uint256 prize = week.amount.mul(15).div(100);
1420             // 85% naturally rolled into the next round
1421             weekPool[weekPoolId].amount = week.amount.sub(prize);
1422 
1423             if (prize > 0) {
1424                 // No prizes left
1425                 uint256 surplus = prize;
1426 
1427                 // Proportion 70%、20%、10%
1428                 uint256[3] memory rates = [
1429                     uint256(70),
1430                     uint256(20),
1431                     uint256(10)
1432                 ];
1433                 // Top 3
1434                 for (uint8 i = 0; i < 3; i++) {
1435                     address addr = week.ranks[i];
1436                     uint256 reward = prize.mul(rates[i]).div(100);
1437 
1438                     // Reward for rankings, and rollover to the next round without rankings
1439                     if (addr != address(0)) {
1440                         accounts[addr].weekPoolIncome = accounts[addr]
1441                             .weekPoolIncome
1442                             .add(reward);
1443                         surplus = surplus.sub(reward);
1444                     }
1445                 }
1446 
1447                 // Add the rest to the next round
1448                 weekPool[weekPoolId].amount = weekPool[weekPoolId].amount.add(
1449                     surplus
1450                 );
1451             }
1452         }
1453     }
1454 
1455     /**
1456      * @dev Daily prize pool draw
1457      */
1458     function _openDayPool() internal {
1459         Pool storage day = dayPool[dayPoolId];
1460         // Determine whether the daily prize pool can be drawn
1461         if (now >= day.date + DAY_POOL_CYCLE) {
1462             dayPoolId++;
1463             dayPool[dayPoolId].date = now;
1464 
1465             // 15% for the draw
1466             uint256 prize = day.amount.mul(15).div(100);
1467             // 85% naturally rolled into the next round
1468             dayPool[dayPoolId].amount = day.amount.sub(prize);
1469 
1470             if (prize > 0) {
1471                 // No prizes left
1472                 uint256 surplus = prize;
1473 
1474                 // The first and second place ratios are 70%, 20%; 10% is evenly distributed to the remaining 5
1475                 uint256[2] memory rates = [uint256(70), uint256(20)];
1476 
1477                 // Top 2
1478                 for (uint8 i = 0; i < 2; i++) {
1479                     address addr = day.ranks[i];
1480                     uint256 reward = prize.mul(rates[i]).div(100);
1481 
1482                     // Reward for rankings, and rollover to the next round without rankings
1483                     if (addr != address(0)) {
1484                         accounts[addr].dayPoolIncome = accounts[addr]
1485                             .dayPoolIncome
1486                             .add(reward);
1487                         surplus = surplus.sub(reward);
1488                     }
1489                 }
1490 
1491                 // 10% is evenly divided among the remaining 5
1492                 uint256 avg = prize.div(50);
1493                 for (uint8 i = 2; i <= 6; i++) {
1494                     address addr = day.ranks[i];
1495 
1496                     if (addr != address(0)) {
1497                         accounts[addr].dayPoolIncome = accounts[addr]
1498                             .dayPoolIncome
1499                             .add(avg);
1500                         surplus = surplus.sub(avg);
1501                     }
1502                 }
1503 
1504                 // Add the rest to the next round
1505                 dayPool[dayPoolId].amount = dayPool[dayPoolId].amount.add(
1506                     surplus
1507                 );
1508             }
1509         }
1510     }
1511 
1512     /**
1513      * @dev Processing account performance
1514      */
1515     function _handlePerformance(address referrer, uint256 _amount) internal {
1516         // Direct performance
1517         performances[referrer].performance = performances[referrer]
1518             .performance
1519             .add(_amount);
1520         // Full line performance
1521         address addr = referrer;
1522         while (addr != address(0)) {
1523             performances[addr].wholeLine = performances[addr].wholeLine.add(
1524                 _amount
1525             );
1526             addr = accounts[addr].referrer;
1527         }
1528     }
1529 
1530     /**
1531      * @dev Processing node level
1532      */
1533     function _handleNodeLevel(address referrer) internal {
1534         address addr = referrer;
1535 
1536         // Condition
1537         uint256[4] memory c1s = [
1538             usdter.mul(100000),
1539             usdter.mul(300000),
1540             usdter.mul(600000),
1541             usdter.mul(1200000)
1542         ];
1543         uint256[4] memory c2s = [
1544             usdter.mul(250000),
1545             usdter.mul(600000),
1546             usdter.mul(1200000),
1547             usdter.mul(2250000)
1548         ];
1549         uint256[4] memory s1s = [
1550             usdter.mul(20000),
1551             usdter.mul(60000),
1552             usdter.mul(90000),
1553             usdter.mul(160000)
1554         ];
1555         uint256[4] memory s2s = [
1556             usdter.mul(30000),
1557             usdter.mul(90000),
1558             usdter.mul(135000),
1559             usdter.mul(240000)
1560         ];
1561 
1562         while (addr != address(0)) {
1563             uint8 level = accounts[addr].nodeLevel;
1564             if (level < 4) {
1565                 uint256 c1 = c1s[level];
1566                 uint256 c2 = c2s[level];
1567 
1568                 if (now - accounts[addr].joinTime <= NODE_DISCOUNT_TIME) {
1569                     c1 = c1.sub(s1s[level]);
1570                     c2 = c2.sub(s2s[level]);
1571                 }
1572 
1573                 if (_handleNodeLevelUpgrade(addr, c1, c2)) {
1574                     accounts[addr].nodeLevel = level + 1;
1575                     nodes[level + 1].push(addr);
1576                 }
1577             }
1578 
1579             addr = accounts[addr].referrer;
1580         }
1581     }
1582 
1583     /**
1584      * @dev Determine whether the upgrade conditions are met according to the conditions
1585      */
1586     function _handleNodeLevelUpgrade(
1587         address addr,
1588         uint256 c1,
1589         uint256 c2
1590     ) internal view returns (bool) {
1591         uint8 count = 0;
1592         uint256 min = uint256(-1);
1593 
1594         for (uint256 i = 0; i < teams[addr].length; i++) {
1595             uint256 w = performances[teams[addr][i]].wholeLine;
1596 
1597             // Case 1
1598             if (w >= c1) {
1599                 count++;
1600                 if (count >= 3) {
1601                     return true;
1602                 }
1603             }
1604 
1605             // Case 2
1606             if (w >= c2 && w < min) {
1607                 min = w;
1608             }
1609         }
1610         if (min < uint256(-1) && performances[addr].wholeLine.sub(min) >= c2) {
1611             return true;
1612         }
1613 
1614         return false;
1615     }
1616 
1617     /**
1618      * @dev Processing node rewards
1619      */
1620     function _handleNodeReward(uint256 _amount) internal {
1621         uint256 reward = _amount.div(25);
1622         for (uint8 i = 1; i <= 4; i++) {
1623             address[] storage _nodes = nodes[i];
1624             uint256 len = _nodes.length;
1625             if (len > 0) {
1626                 uint256 _reward = reward.div(len);
1627                 for (uint256 j = 0; j < len; j++) {
1628                     Account storage user = accounts[_nodes[j]];
1629                     user.nodeIncome = user.nodeIncome.add(_reward);
1630                 }
1631             }
1632         }
1633     }
1634 
1635     /**
1636      * @dev Calculate static income
1637      */
1638     function calculateStaticIncome(address addr) public view returns (uint256) {
1639         Account storage user = accounts[addr];
1640         if (user.deposit > 0) {
1641             uint256 last = user.lastTakeTime;
1642             uint256 day = (now - last) / STATIC_CYCLE;
1643 
1644             if (day == 0) {
1645                 return 0;
1646             }
1647 
1648             if (day > 30) {
1649                 day = 30;
1650             }
1651 
1652             return user.deposit.mul(staticRate).div(1000).mul(day);
1653         }
1654         return 0;
1655     }
1656 
1657     /**
1658      * @dev Calculate out multiple
1659      */
1660     function _calculateOutAmount(uint256 _amount)
1661         internal
1662         pure
1663         returns (uint256)
1664     {
1665         if (_amount >= usdter.mul(15000)) {
1666             return _amount.mul(35).div(10);
1667         } else if (_amount >= usdter.mul(4000)) {
1668             return _amount.mul(30).div(10);
1669         } else if (_amount >= usdter.mul(1500)) {
1670             return _amount.mul(25).div(10);
1671         } else {
1672             return _amount.mul(20).div(10);
1673         }
1674     }
1675 
1676     /**
1677      * @dev Calculate the out multiple of all reinvestments
1678      */
1679     function _calculateFullOutAmount(uint256 _amount)
1680         internal
1681         pure
1682         returns (uint256)
1683     {
1684         if (_amount >= usdter.mul(15000)) {
1685             return _amount.mul(45).div(10);
1686         } else if (_amount >= usdter.mul(4000)) {
1687             return _amount.mul(40).div(10);
1688         } else if (_amount >= usdter.mul(1500)) {
1689             return _amount.mul(35).div(10);
1690         } else {
1691             return _amount.mul(25).div(10);
1692         }
1693     }
1694 
1695     /**
1696      * @dev Get the number of nodes at a certain level
1697      */
1698     function nodeLength(uint8 level) public view returns (uint256) {
1699         return nodes[level].length;
1700     }
1701 
1702     /**
1703      * @dev Number of teams
1704      */
1705     function teamsLength(address addr) public view returns (uint256) {
1706         return teams[addr].length;
1707     }
1708 
1709     /**
1710      * @dev Daily prize pool ranking
1711      */
1712     function dayPoolRank(uint64 _id, uint8 _rank)
1713         public
1714         view
1715         returns (address)
1716     {
1717         return dayPool[_id].ranks[_rank];
1718     }
1719 
1720     /**
1721      * @dev Daily prize pool performance
1722      */
1723     function dayPoolValue(uint64 _id, address _addr)
1724         public
1725         view
1726         returns (uint256)
1727     {
1728         return dayPool[_id].values[_addr];
1729     }
1730 
1731     /**
1732      * @dev Weekly prize pool ranking
1733      */
1734     function weekPoolRank(uint64 _id, uint8 _rank)
1735         public
1736         view
1737         returns (address)
1738     {
1739         return weekPool[_id].ranks[_rank];
1740     }
1741 
1742     /**
1743      * @dev Weekly prize pool performance
1744      */
1745     function weekPoolValue(uint64 _id, address _addr)
1746         public
1747         view
1748         returns (uint256)
1749     {
1750         return weekPool[_id].values[_addr];
1751     }
1752 
1753     /**
1754      * @dev Team statistics, return the smallest, medium and most performance
1755      */
1756     function teamsStats(address addr) public view returns (uint256, uint256) {
1757         uint256 count = teams[addr].length;
1758         if (count > 0) {
1759             uint256 max = performances[teams[addr][count - 1]].wholeLine;
1760             uint256 min = performances[teams[addr][count - 1]].wholeLine;
1761             for (uint256 i = 0; i < count; i++) {
1762                 if (performances[teams[addr][i]].wholeLine > max) {
1763                     max = performances[teams[addr][i]].wholeLine;
1764                 }
1765                 if (performances[teams[addr][i]].wholeLine < min) {
1766                     min = performances[teams[addr][i]].wholeLine;
1767                 }
1768             }
1769 
1770             return (max, min);
1771         }
1772         return (0, 0);
1773     }
1774 
1775     /**
1776      * @dev Count how many people meet the conditions
1777      */
1778     function teamsCount(address addr, uint256 _amount)
1779         public
1780         view
1781         returns (uint256)
1782     {
1783         uint256 count;
1784 
1785         for (uint256 i = 0; i < teams[addr].length; i++) {
1786             if (_amount <= performances[teams[addr][i]].wholeLine) {
1787                 count++;
1788             }
1789         }
1790 
1791         return count;
1792     }
1793 
1794     /**
1795      * @dev Get the number of large account addresses
1796      */
1797     function richmanLength() public view returns (uint256) {
1798         return EnumerableSet.length(richman);
1799     }
1800 
1801     /**
1802      * @dev Safe USDT transfer, excluding the balance of insurance pool and perpetual pool
1803      */
1804     function _safeUsdtTransfer(address addr, uint256 _amount) internal {
1805         uint256 bal = usdt.balanceOf(address(this));
1806         bal = bal.sub(insurance).sub(sustainable);
1807 
1808         if (bal < _amount) {
1809             usdt.safeTransfer(addr, bal);
1810         } else {
1811             usdt.safeTransfer(addr, _amount);
1812         }
1813     }
1814 
1815     /**
1816      * @dev Activate the insurance pool, only the administrator can call
1817      */
1818     function activeInsurance() public onlyOwner {
1819         uint256 nodePaid = insurance.mul(70).div(100);
1820         uint256 bigPaid = insurance.sub(nodePaid);
1821 
1822         insurance = 0;
1823 
1824         // Issued to richman
1825         uint256 _richmanLen = EnumerableSet.length(richman);
1826         if (_richmanLen > 0) {
1827             uint256 paid = bigPaid.div(_richmanLen);
1828             for (uint256 i = 0; i < _richmanLen; i++) {
1829                 Account storage user = accounts[EnumerableSet.at(richman, i)];
1830                 user.reward = user.reward.add(paid);
1831             }
1832         }
1833 
1834         // Issued to node
1835         uint256[4] memory _rates = [
1836             uint256(10),
1837             uint256(20),
1838             uint256(30),
1839             uint256(40)
1840         ];
1841         for (uint8 i = 1; i <= 4; i++) {
1842             uint256 _nodeLen = nodes[i].length;
1843             if (_nodeLen > 0) {
1844                 uint256 paid = nodePaid.mul(_rates[i - 1]).div(100).div(
1845                     _nodeLen
1846                 );
1847                 for (uint256 j = 0; j < _nodeLen; j++) {
1848                     Account storage user = accounts[nodes[i][j]];
1849                     user.reward = user.reward.add(paid);
1850                 }
1851             }
1852         }
1853     }
1854 
1855     /**
1856      * @dev Transfer to the perpetual pool, only the administrator can call
1857      */
1858     function activeSustainable(address next) public onlyOwner {
1859         require(sustainable > 0);
1860         uint256 paid = sustainable;
1861         uint256 bal = usdt.balanceOf(address(this));
1862         if (bal < paid) {
1863             usdt.safeTransfer(next, bal);
1864         } else {
1865             usdt.safeTransfer(next, paid);
1866         }
1867     }
1868 
1869     /**
1870      * @dev Set static rate of return, only the administrator can call
1871      */
1872     function setStaticRate(uint256 _rate) public onlyOwner {
1873         require(_rate <= 1000);
1874         staticRate = _rate;
1875     }
1876 
1877     /**
1878      * @dev Set dynamic rate of return, only the administrator can call
1879      */
1880     function setDynamicRates(uint8 level, uint256 _rate) public onlyOwner {
1881         require(level < 12);
1882         require(_rate <= 1000);
1883         dynamicRates[level] = _rate;
1884     }
1885 
1886     /**
1887      * @dev Set up the ticket contract, only the administrator can call
1888      */
1889     function setTicket(ITicketsToken _ticket) public onlyOwner {
1890         ticket = _ticket;
1891     }
1892 
1893     /**
1894      * @dev Receive the technical founding team, only the administrator can call
1895      */
1896     function takeFounder() public onlyOwner {
1897         uint256 paid = founder;
1898         founder = 0;
1899         usdt.safeTransfer(msg.sender, paid);
1900     }
1901 
1902     /**
1903      * @dev Receive expansion operation fee, only the administrator can call
1904      */
1905     function takeOperation() public onlyOwner {
1906         uint256 paid = operation.add(dex);
1907         operation = 0;
1908         dex = 0;
1909         usdt.safeTransfer(msg.sender, paid);
1910     }
1911 }