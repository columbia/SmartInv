1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-03
3 */
4 
5 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
6 
7 
8 
9 pragma solidity ^0.6.0;
10 
11 /**
12  * @dev Library for managing
13  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
14  * types.
15  *
16  * Sets have the following properties:
17  *
18  * - Elements are added, removed, and checked for existence in constant time
19  * (O(1)).
20  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
21  *
22  * ```
23  * contract Example {
24  *     // Add the library methods
25  *     using EnumerableSet for EnumerableSet.AddressSet;
26  *
27  *     // Declare a set state variable
28  *     EnumerableSet.AddressSet private mySet;
29  * }
30  * ```
31  *
32  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
33  * (`UintSet`) are supported.
34  */
35 library EnumerableSet {
36     // To implement this library for multiple types with as little code
37     // repetition as possible, we write it in terms of a generic Set type with
38     // bytes32 values.
39     // The Set implementation uses private functions, and user-facing
40     // implementations (such as AddressSet) are just wrappers around the
41     // underlying Set.
42     // This means that we can only create new EnumerableSets for types that fit
43     // in bytes32.
44 
45     struct Set {
46         // Storage of set values
47         bytes32[] _values;
48 
49         // Position of the value in the `values` array, plus 1 because index 0
50         // means a value is not in the set.
51         mapping (bytes32 => uint256) _indexes;
52     }
53 
54     /**
55      * @dev Add a value to a set. O(1).
56      *
57      * Returns true if the value was added to the set, that is if it was not
58      * already present.
59      */
60     function _add(Set storage set, bytes32 value) private returns (bool) {
61         if (!_contains(set, value)) {
62             set._values.push(value);
63             // The value is stored at length-1, but we add 1 to all indexes
64             // and use 0 as a sentinel value
65             set._indexes[value] = set._values.length;
66             return true;
67         } else {
68             return false;
69         }
70     }
71 
72     /**
73      * @dev Removes a value from a set. O(1).
74      *
75      * Returns true if the value was removed from the set, that is if it was
76      * present.
77      */
78     function _remove(Set storage set, bytes32 value) private returns (bool) {
79         // We read and store the value's index to prevent multiple reads from the same storage slot
80         uint256 valueIndex = set._indexes[value];
81 
82         if (valueIndex != 0) { // Equivalent to contains(set, value)
83             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
84             // the array, and then remove the last element (sometimes called as 'swap and pop').
85             // This modifies the order of the array, as noted in {at}.
86 
87             uint256 toDeleteIndex = valueIndex - 1;
88             uint256 lastIndex = set._values.length - 1;
89 
90             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
91             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
92 
93             bytes32 lastvalue = set._values[lastIndex];
94 
95             // Move the last value to the index where the value to delete is
96             set._values[toDeleteIndex] = lastvalue;
97             // Update the index for the moved value
98             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
99 
100             // Delete the slot where the moved value was stored
101             set._values.pop();
102 
103             // Delete the index for the deleted slot
104             delete set._indexes[value];
105 
106             return true;
107         } else {
108             return false;
109         }
110     }
111 
112     /**
113      * @dev Returns true if the value is in the set. O(1).
114      */
115     function _contains(Set storage set, bytes32 value) private view returns (bool) {
116         return set._indexes[value] != 0;
117     }
118 
119     /**
120      * @dev Returns the number of values on the set. O(1).
121      */
122     function _length(Set storage set) private view returns (uint256) {
123         return set._values.length;
124     }
125 
126    /**
127     * @dev Returns the value stored at position `index` in the set. O(1).
128     *
129     * Note that there are no guarantees on the ordering of values inside the
130     * array, and it may change when more values are added or removed.
131     *
132     * Requirements:
133     *
134     * - `index` must be strictly less than {length}.
135     */
136     function _at(Set storage set, uint256 index) private view returns (bytes32) {
137         require(set._values.length > index, "EnumerableSet: index out of bounds");
138         return set._values[index];
139     }
140 
141     // AddressSet
142 
143     struct AddressSet {
144         Set _inner;
145     }
146 
147     /**
148      * @dev Add a value to a set. O(1).
149      *
150      * Returns true if the value was added to the set, that is if it was not
151      * already present.
152      */
153     function add(AddressSet storage set, address value) internal returns (bool) {
154         return _add(set._inner, bytes32(uint256(value)));
155     }
156 
157     /**
158      * @dev Removes a value from a set. O(1).
159      *
160      * Returns true if the value was removed from the set, that is if it was
161      * present.
162      */
163     function remove(AddressSet storage set, address value) internal returns (bool) {
164         return _remove(set._inner, bytes32(uint256(value)));
165     }
166 
167     /**
168      * @dev Returns true if the value is in the set. O(1).
169      */
170     function contains(AddressSet storage set, address value) internal view returns (bool) {
171         return _contains(set._inner, bytes32(uint256(value)));
172     }
173 
174     /**
175      * @dev Returns the number of values in the set. O(1).
176      */
177     function length(AddressSet storage set) internal view returns (uint256) {
178         return _length(set._inner);
179     }
180 
181    /**
182     * @dev Returns the value stored at position `index` in the set. O(1).
183     *
184     * Note that there are no guarantees on the ordering of values inside the
185     * array, and it may change when more values are added or removed.
186     *
187     * Requirements:
188     *
189     * - `index` must be strictly less than {length}.
190     */
191     function at(AddressSet storage set, uint256 index) internal view returns (address) {
192         return address(uint256(_at(set._inner, index)));
193     }
194 
195 
196     // UintSet
197 
198     struct UintSet {
199         Set _inner;
200     }
201 
202     /**
203      * @dev Add a value to a set. O(1).
204      *
205      * Returns true if the value was added to the set, that is if it was not
206      * already present.
207      */
208     function add(UintSet storage set, uint256 value) internal returns (bool) {
209         return _add(set._inner, bytes32(value));
210     }
211 
212     /**
213      * @dev Removes a value from a set. O(1).
214      *
215      * Returns true if the value was removed from the set, that is if it was
216      * present.
217      */
218     function remove(UintSet storage set, uint256 value) internal returns (bool) {
219         return _remove(set._inner, bytes32(value));
220     }
221 
222     /**
223      * @dev Returns true if the value is in the set. O(1).
224      */
225     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
226         return _contains(set._inner, bytes32(value));
227     }
228 
229     /**
230      * @dev Returns the number of values on the set. O(1).
231      */
232     function length(UintSet storage set) internal view returns (uint256) {
233         return _length(set._inner);
234     }
235 
236    /**
237     * @dev Returns the value stored at position `index` in the set. O(1).
238     *
239     * Note that there are no guarantees on the ordering of values inside the
240     * array, and it may change when more values are added or removed.
241     *
242     * Requirements:
243     *
244     * - `index` must be strictly less than {length}.
245     */
246     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
247         return uint256(_at(set._inner, index));
248     }
249 }
250 
251 // File: @openzeppelin/contracts/GSN/Context.sol
252 
253 
254 
255 pragma solidity ^0.6.0;
256 
257 /*
258  * @dev Provides information about the current execution context, including the
259  * sender of the transaction and its data. While these are generally available
260  * via msg.sender and msg.data, they should not be accessed in such a direct
261  * manner, since when dealing with GSN meta-transactions the account sending and
262  * paying for execution may not be the actual sender (as far as an application
263  * is concerned).
264  *
265  * This contract is only required for intermediate, library-like contracts.
266  */
267 abstract contract Context {
268     function _msgSender() internal view virtual returns (address payable) {
269         return msg.sender;
270     }
271 
272     function _msgData() internal view virtual returns (bytes memory) {
273         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
274         return msg.data;
275     }
276 }
277 
278 // File: @openzeppelin/contracts/access/Ownable.sol
279 
280 
281 
282 pragma solidity ^0.6.0;
283 
284 /**
285  * @dev Contract module which provides a basic access control mechanism, where
286  * there is an account (an owner) that can be granted exclusive access to
287  * specific functions.
288  *
289  * By default, the owner account will be the one that deploys the contract. This
290  * can later be changed with {transferOwnership}.
291  *
292  * This module is used through inheritance. It will make available the modifier
293  * `onlyOwner`, which can be applied to your functions to restrict their use to
294  * the owner.
295  */
296 contract Ownable is Context {
297     address private _owner;
298 
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301     /**
302      * @dev Initializes the contract setting the deployer as the initial owner.
303      */
304     constructor () internal {
305         address msgSender = _msgSender();
306         _owner = msgSender;
307         emit OwnershipTransferred(address(0), msgSender);
308     }
309 
310     /**
311      * @dev Returns the address of the current owner.
312      */
313     function owner() public view returns (address) {
314         return _owner;
315     }
316 
317     /**
318      * @dev Throws if called by any account other than the owner.
319      */
320     modifier onlyOwner() {
321         require(_owner == _msgSender(), "Ownable: caller is not the owner");
322         _;
323     }
324 
325     /**
326      * @dev Leaves the contract without owner. It will not be possible to call
327      * `onlyOwner` functions anymore. Can only be called by the current owner.
328      *
329      * NOTE: Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public virtual onlyOwner {
333         emit OwnershipTransferred(_owner, address(0));
334         _owner = address(0);
335     }
336 
337     /**
338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
339      * Can only be called by the current owner.
340      */
341     function transferOwnership(address newOwner) public virtual onlyOwner {
342         require(newOwner != address(0), "Ownable: new owner is the zero address");
343         emit OwnershipTransferred(_owner, newOwner);
344         _owner = newOwner;
345     }
346 }
347 
348 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
349 
350 
351 
352 pragma solidity ^0.6.0;
353 
354 /**
355  * @dev Interface of the ERC20 standard as defined in the EIP.
356  */
357 interface IERC20 {
358     /**
359      * @dev Returns the amount of tokens in existence.
360      */
361     function totalSupply() external view returns (uint256);
362 
363     /**
364      * @dev Returns the amount of tokens owned by `account`.
365      */
366     function balanceOf(address account) external view returns (uint256);
367 
368     /**
369      * @dev Moves `amount` tokens from the caller's account to `recipient`.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * Emits a {Transfer} event.
374      */
375     function transfer(address recipient, uint256 amount) external returns (bool);
376 
377     /**
378      * @dev Returns the remaining number of tokens that `spender` will be
379      * allowed to spend on behalf of `owner` through {transferFrom}. This is
380      * zero by default.
381      *
382      * This value changes when {approve} or {transferFrom} are called.
383      */
384     function allowance(address owner, address spender) external view returns (uint256);
385 
386     /**
387      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * IMPORTANT: Beware that changing an allowance with this method brings the risk
392      * that someone may use both the old and the new allowance by unfortunate
393      * transaction ordering. One possible solution to mitigate this race
394      * condition is to first reduce the spender's allowance to 0 and set the
395      * desired value afterwards:
396      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397      *
398      * Emits an {Approval} event.
399      */
400     function approve(address spender, uint256 amount) external returns (bool);
401 
402     /**
403      * @dev Moves `amount` tokens from `sender` to `recipient` using the
404      * allowance mechanism. `amount` is then deducted from the caller's
405      * allowance.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
412 
413     /**
414      * @dev Emitted when `value` tokens are moved from one account (`from`) to
415      * another (`to`).
416      *
417      * Note that `value` may be zero.
418      */
419     event Transfer(address indexed from, address indexed to, uint256 value);
420 
421     /**
422      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
423      * a call to {approve}. `value` is the new allowance.
424      */
425     event Approval(address indexed owner, address indexed spender, uint256 value);
426 }
427 
428 // File: @openzeppelin/contracts/math/SafeMath.sol
429 
430 
431 
432 pragma solidity ^0.6.0;
433 
434 /**
435  * @dev Wrappers over Solidity's arithmetic operations with added overflow
436  * checks.
437  *
438  * Arithmetic operations in Solidity wrap on overflow. This can easily result
439  * in bugs, because programmers usually assume that an overflow raises an
440  * error, which is the standard behavior in high level programming languages.
441  * `SafeMath` restores this intuition by reverting the transaction when an
442  * operation overflows.
443  *
444  * Using this library instead of the unchecked operations eliminates an entire
445  * class of bugs, so it's recommended to use it always.
446  */
447 library SafeMath {
448     /**
449      * @dev Returns the addition of two unsigned integers, reverting on
450      * overflow.
451      *
452      * Counterpart to Solidity's `+` operator.
453      *
454      * Requirements:
455      *
456      * - Addition cannot overflow.
457      */
458     function add(uint256 a, uint256 b) internal pure returns (uint256) {
459         uint256 c = a + b;
460         require(c >= a, "SafeMath: addition overflow");
461 
462         return c;
463     }
464 
465     /**
466      * @dev Returns the subtraction of two unsigned integers, reverting on
467      * overflow (when the result is negative).
468      *
469      * Counterpart to Solidity's `-` operator.
470      *
471      * Requirements:
472      *
473      * - Subtraction cannot overflow.
474      */
475     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
476         return sub(a, b, "SafeMath: subtraction overflow");
477     }
478 
479     /**
480      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
481      * overflow (when the result is negative).
482      *
483      * Counterpart to Solidity's `-` operator.
484      *
485      * Requirements:
486      *
487      * - Subtraction cannot overflow.
488      */
489     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
490         require(b <= a, errorMessage);
491         uint256 c = a - b;
492 
493         return c;
494     }
495 
496     /**
497      * @dev Returns the multiplication of two unsigned integers, reverting on
498      * overflow.
499      *
500      * Counterpart to Solidity's `*` operator.
501      *
502      * Requirements:
503      *
504      * - Multiplication cannot overflow.
505      */
506     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
507         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
508         // benefit is lost if 'b' is also tested.
509         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
510         if (a == 0) {
511             return 0;
512         }
513 
514         uint256 c = a * b;
515         require(c / a == b, "SafeMath: multiplication overflow");
516 
517         return c;
518     }
519 
520     /**
521      * @dev Returns the integer division of two unsigned integers. Reverts on
522      * division by zero. The result is rounded towards zero.
523      *
524      * Counterpart to Solidity's `/` operator. Note: this function uses a
525      * `revert` opcode (which leaves remaining gas untouched) while Solidity
526      * uses an invalid opcode to revert (consuming all remaining gas).
527      *
528      * Requirements:
529      *
530      * - The divisor cannot be zero.
531      */
532     function div(uint256 a, uint256 b) internal pure returns (uint256) {
533         return div(a, b, "SafeMath: division by zero");
534     }
535 
536     /**
537      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
538      * division by zero. The result is rounded towards zero.
539      *
540      * Counterpart to Solidity's `/` operator. Note: this function uses a
541      * `revert` opcode (which leaves remaining gas untouched) while Solidity
542      * uses an invalid opcode to revert (consuming all remaining gas).
543      *
544      * Requirements:
545      *
546      * - The divisor cannot be zero.
547      */
548     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
549         require(b > 0, errorMessage);
550         uint256 c = a / b;
551         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
552 
553         return c;
554     }
555 
556     /**
557      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
558      * Reverts when dividing by zero.
559      *
560      * Counterpart to Solidity's `%` operator. This function uses a `revert`
561      * opcode (which leaves remaining gas untouched) while Solidity uses an
562      * invalid opcode to revert (consuming all remaining gas).
563      *
564      * Requirements:
565      *
566      * - The divisor cannot be zero.
567      */
568     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
569         return mod(a, b, "SafeMath: modulo by zero");
570     }
571 
572     /**
573      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
574      * Reverts with custom message when dividing by zero.
575      *
576      * Counterpart to Solidity's `%` operator. This function uses a `revert`
577      * opcode (which leaves remaining gas untouched) while Solidity uses an
578      * invalid opcode to revert (consuming all remaining gas).
579      *
580      * Requirements:
581      *
582      * - The divisor cannot be zero.
583      */
584     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
585         require(b != 0, errorMessage);
586         return a % b;
587     }
588 }
589 
590 // File: @openzeppelin/contracts/utils/Address.sol
591 
592 
593 
594 pragma solidity ^0.6.2;
595 
596 /**
597  * @dev Collection of functions related to the address type
598  */
599 library Address {
600     /**
601      * @dev Returns true if `account` is a contract.
602      *
603      * [IMPORTANT]
604      * ====
605      * It is unsafe to assume that an address for which this function returns
606      * false is an externally-owned account (EOA) and not a contract.
607      *
608      * Among others, `isContract` will return false for the following
609      * types of addresses:
610      *
611      *  - an externally-owned account
612      *  - a contract in construction
613      *  - an address where a contract will be created
614      *  - an address where a contract lived, but was destroyed
615      * ====
616      */
617     function isContract(address account) internal view returns (bool) {
618         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
619         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
620         // for accounts without code, i.e. `keccak256('')`
621         bytes32 codehash;
622         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
623         // solhint-disable-next-line no-inline-assembly
624         assembly { codehash := extcodehash(account) }
625         return (codehash != accountHash && codehash != 0x0);
626     }
627 
628     /**
629      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
630      * `recipient`, forwarding all available gas and reverting on errors.
631      *
632      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
633      * of certain opcodes, possibly making contracts go over the 2300 gas limit
634      * imposed by `transfer`, making them unable to receive funds via
635      * `transfer`. {sendValue} removes this limitation.
636      *
637      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
638      *
639      * IMPORTANT: because control is transferred to `recipient`, care must be
640      * taken to not create reentrancy vulnerabilities. Consider using
641      * {ReentrancyGuard} or the
642      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
643      */
644     function sendValue(address payable recipient, uint256 amount) internal {
645         require(address(this).balance >= amount, "Address: insufficient balance");
646 
647         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
648         (bool success, ) = recipient.call{ value: amount }("");
649         require(success, "Address: unable to send value, recipient may have reverted");
650     }
651 
652     /**
653      * @dev Performs a Solidity function call using a low level `call`. A
654      * plain`call` is an unsafe replacement for a function call: use this
655      * function instead.
656      *
657      * If `target` reverts with a revert reason, it is bubbled up by this
658      * function (like regular Solidity function calls).
659      *
660      * Returns the raw returned data. To convert to the expected return value,
661      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
662      *
663      * Requirements:
664      *
665      * - `target` must be a contract.
666      * - calling `target` with `data` must not revert.
667      *
668      * _Available since v3.1._
669      */
670     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
671       return functionCall(target, data, "Address: low-level call failed");
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
676      * `errorMessage` as a fallback revert reason when `target` reverts.
677      *
678      * _Available since v3.1._
679      */
680     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
681         return _functionCallWithValue(target, data, 0, errorMessage);
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
686      * but also transferring `value` wei to `target`.
687      *
688      * Requirements:
689      *
690      * - the calling contract must have an ETH balance of at least `value`.
691      * - the called Solidity function must be `payable`.
692      *
693      * _Available since v3.1._
694      */
695     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
696         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
701      * with `errorMessage` as a fallback revert reason when `target` reverts.
702      *
703      * _Available since v3.1._
704      */
705     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
706         require(address(this).balance >= value, "Address: insufficient balance for call");
707         return _functionCallWithValue(target, data, value, errorMessage);
708     }
709 
710     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
711         require(isContract(target), "Address: call to non-contract");
712 
713         // solhint-disable-next-line avoid-low-level-calls
714         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
715         if (success) {
716             return returndata;
717         } else {
718             // Look for revert reason and bubble it up if present
719             if (returndata.length > 0) {
720                 // The easiest way to bubble the revert reason is using memory via assembly
721 
722                 // solhint-disable-next-line no-inline-assembly
723                 assembly {
724                     let returndata_size := mload(returndata)
725                     revert(add(32, returndata), returndata_size)
726                 }
727             } else {
728                 revert(errorMessage);
729             }
730         }
731     }
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
735 
736 
737 
738 pragma solidity ^0.6.0;
739 
740 
741 
742 
743 
744 /**
745  * @dev Implementation of the {IERC20} interface.
746  *
747  * This implementation is agnostic to the way tokens are created. This means
748  * that a supply mechanism has to be added in a derived contract using {_mint}.
749  * For a generic mechanism see {ERC20PresetMinterPauser}.
750  *
751  * TIP: For a detailed writeup see our guide
752  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
753  * to implement supply mechanisms].
754  *
755  * We have followed general OpenZeppelin guidelines: functions revert instead
756  * of returning `false` on failure. This behavior is nonetheless conventional
757  * and does not conflict with the expectations of ERC20 applications.
758  *
759  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
760  * This allows applications to reconstruct the allowance for all accounts just
761  * by listening to said events. Other implementations of the EIP may not emit
762  * these events, as it isn't required by the specification.
763  *
764  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
765  * functions have been added to mitigate the well-known issues around setting
766  * allowances. See {IERC20-approve}.
767  */
768 contract ERC20 is Context, IERC20 {
769     using SafeMath for uint256;
770     using Address for address;
771 
772     mapping (address => uint256) private _balances;
773 
774     mapping (address => mapping (address => uint256)) private _allowances;
775 
776     uint256 private _totalSupply;
777 
778     string private _name;
779     string private _symbol;
780     uint8 private _decimals;
781 
782     /**
783      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
784      * a default value of 18.
785      *
786      * To select a different value for {decimals}, use {_setupDecimals}.
787      *
788      * All three of these values are immutable: they can only be set once during
789      * construction.
790      */
791     constructor (string memory name, string memory symbol) public {
792         _name = name;
793         _symbol = symbol;
794         _decimals = 18;
795     }
796 
797     /**
798      * @dev Returns the name of the token.
799      */
800     function name() public view returns (string memory) {
801         return _name;
802     }
803 
804     /**
805      * @dev Returns the symbol of the token, usually a shorter version of the
806      * name.
807      */
808     function symbol() public view returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev Returns the number of decimals used to get its user representation.
814      * For example, if `decimals` equals `2`, a balance of `505` tokens should
815      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
816      *
817      * Tokens usually opt for a value of 18, imitating the relationship between
818      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
819      * called.
820      *
821      * NOTE: This information is only used for _display_ purposes: it in
822      * no way affects any of the arithmetic of the contract, including
823      * {IERC20-balanceOf} and {IERC20-transfer}.
824      */
825     function decimals() public view returns (uint8) {
826         return _decimals;
827     }
828 
829     /**
830      * @dev See {IERC20-totalSupply}.
831      */
832     function totalSupply() public view override returns (uint256) {
833         return _totalSupply;
834     }
835 
836     /**
837      * @dev See {IERC20-balanceOf}.
838      */
839     function balanceOf(address account) public view override returns (uint256) {
840         return _balances[account];
841     }
842 
843     /**
844      * @dev See {IERC20-transfer}.
845      *
846      * Requirements:
847      *
848      * - `recipient` cannot be the zero address.
849      * - the caller must have a balance of at least `amount`.
850      */
851     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
852         _transfer(_msgSender(), recipient, amount);
853         return true;
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
875     /**
876      * @dev See {IERC20-transferFrom}.
877      *
878      * Emits an {Approval} event indicating the updated allowance. This is not
879      * required by the EIP. See the note at the beginning of {ERC20};
880      *
881      * Requirements:
882      * - `sender` and `recipient` cannot be the zero address.
883      * - `sender` must have a balance of at least `amount`.
884      * - the caller must have allowance for ``sender``'s tokens of at least
885      * `amount`.
886      */
887     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
888         _transfer(sender, recipient, amount);
889         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
890         return true;
891     }
892 
893     /**
894      * @dev Atomically increases the allowance granted to `spender` by the caller.
895      *
896      * This is an alternative to {approve} that can be used as a mitigation for
897      * problems described in {IERC20-approve}.
898      *
899      * Emits an {Approval} event indicating the updated allowance.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
906         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
907         return true;
908     }
909 
910     /**
911      * @dev Atomically decreases the allowance granted to `spender` by the caller.
912      *
913      * This is an alternative to {approve} that can be used as a mitigation for
914      * problems described in {IERC20-approve}.
915      *
916      * Emits an {Approval} event indicating the updated allowance.
917      *
918      * Requirements:
919      *
920      * - `spender` cannot be the zero address.
921      * - `spender` must have allowance for the caller of at least
922      * `subtractedValue`.
923      */
924     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
925         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
926         return true;
927     }
928 
929     /**
930      * @dev Moves tokens `amount` from `sender` to `recipient`.
931      *
932      * This is internal function is equivalent to {transfer}, and can be used to
933      * e.g. implement automatic token fees, slashing mechanisms, etc.
934      *
935      * Emits a {Transfer} event.
936      *
937      * Requirements:
938      *
939      * - `sender` cannot be the zero address.
940      * - `recipient` cannot be the zero address.
941      * - `sender` must have a balance of at least `amount`.
942      */
943     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
944         require(sender != address(0), "ERC20: transfer from the zero address");
945         require(recipient != address(0), "ERC20: transfer to the zero address");
946 
947         _beforeTokenTransfer(sender, recipient, amount);
948 
949         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
950         _balances[recipient] = _balances[recipient].add(amount);
951         emit Transfer(sender, recipient, amount);
952     }
953 
954     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
955      * the total supply.
956      *
957      * Emits a {Transfer} event with `from` set to the zero address.
958      *
959      * Requirements
960      *
961      * - `to` cannot be the zero address.
962      */
963     function _mint(address account, uint256 amount) internal virtual {
964         require(account != address(0), "ERC20: mint to the zero address");
965 
966         _beforeTokenTransfer(address(0), account, amount);
967 
968         _totalSupply = _totalSupply.add(amount);
969         _balances[account] = _balances[account].add(amount);
970         emit Transfer(address(0), account, amount);
971     }
972 
973     /**
974      * @dev Destroys `amount` tokens from `account`, reducing the
975      * total supply.
976      *
977      * Emits a {Transfer} event with `to` set to the zero address.
978      *
979      * Requirements
980      *
981      * - `account` cannot be the zero address.
982      * - `account` must have at least `amount` tokens.
983      */
984     function _burn(address account, uint256 amount) internal virtual {
985         require(account != address(0), "ERC20: burn from the zero address");
986 
987         _beforeTokenTransfer(account, address(0), amount);
988 
989         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
990         _totalSupply = _totalSupply.sub(amount);
991         emit Transfer(account, address(0), amount);
992     }
993 
994     /**
995      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
996      *
997      * This is internal function is equivalent to `approve`, and can be used to
998      * e.g. set automatic allowances for certain subsystems, etc.
999      *
1000      * Emits an {Approval} event.
1001      *
1002      * Requirements:
1003      *
1004      * - `owner` cannot be the zero address.
1005      * - `spender` cannot be the zero address.
1006      */
1007     function _approve(address owner, address spender, uint256 amount) internal virtual {
1008         require(owner != address(0), "ERC20: approve from the zero address");
1009         require(spender != address(0), "ERC20: approve to the zero address");
1010 
1011         _allowances[owner][spender] = amount;
1012         emit Approval(owner, spender, amount);
1013     }
1014 
1015     /**
1016      * @dev Sets {decimals} to a value other than the default one of 18.
1017      *
1018      * WARNING: This function should only be called from the constructor. Most
1019      * applications that interact with token contracts will not expect
1020      * {decimals} to ever change, and may work incorrectly if it does.
1021      */
1022     function _setupDecimals(uint8 decimals_) internal {
1023         _decimals = decimals_;
1024     }
1025 
1026     /**
1027      * @dev Hook that is called before any transfer of tokens. This includes
1028      * minting and burning.
1029      *
1030      * Calling conditions:
1031      *
1032      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1033      * will be to transferred to `to`.
1034      * - when `from` is zero, `amount` tokens will be minted for `to`.
1035      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1036      * - `from` and `to` are never both zero.
1037      *
1038      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1039      */
1040     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1041 }
1042 
1043 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1044 
1045 
1046 
1047 pragma solidity ^0.6.0;
1048 
1049 
1050 
1051 /**
1052  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1053  * tokens and those that they have an allowance for, in a way that can be
1054  * recognized off-chain (via event analysis).
1055  */
1056 abstract contract ERC20Burnable is Context, ERC20 {
1057     /**
1058      * @dev Destroys `amount` tokens from the caller.
1059      *
1060      * See {ERC20-_burn}.
1061      */
1062     function burn(uint256 amount) public virtual {
1063         _burn(_msgSender(), amount);
1064     }
1065 
1066     /**
1067      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1068      * allowance.
1069      *
1070      * See {ERC20-_burn} and {ERC20-allowance}.
1071      *
1072      * Requirements:
1073      *
1074      * - the caller must have allowance for ``accounts``'s tokens of at least
1075      * `amount`.
1076      */
1077     function burnFrom(address account, uint256 amount) public virtual {
1078         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1079 
1080         _approve(account, _msgSender(), decreasedAllowance);
1081         _burn(account, amount);
1082     }
1083 }
1084 
1085 // File: contracts/governance.sol
1086 
1087 pragma solidity ^0.6.0;
1088 pragma experimental ABIEncoderV2;
1089 
1090 
1091 
1092 abstract contract DeligateERC20 is ERC20Burnable {
1093     /// @notice A record of each accounts delegate
1094     mapping (address => address) internal _delegates;
1095 
1096     /// @notice A checkpoint for marking number of votes from a given block
1097     struct Checkpoint {
1098         uint32 fromBlock;
1099         uint256 votes;
1100     }
1101 
1102     /// @notice A record of votes checkpoints for each account, by index
1103     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1104 
1105     /// @notice The number of checkpoints for each account
1106     mapping (address => uint32) public numCheckpoints;
1107 
1108     /// @notice The EIP-712 typehash for the contract's domain
1109     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1110 
1111     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1112     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1113 
1114     /// @notice A record of states for signing / validating signatures
1115     mapping (address => uint) public nonces;
1116 
1117 
1118     // support delegates mint
1119     function _mint(address account, uint256 amount) internal override virtual {
1120         super._mint(account, amount);
1121 
1122         // add delegates to the minter
1123         _moveDelegates(address(0), _delegates[account], amount);
1124     }
1125 
1126 
1127     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
1128         super._transfer(sender, recipient, amount);
1129         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1130     }
1131 
1132     
1133     // support delegates burn
1134     function burn(uint256 amount) public override virtual {
1135         super.burn(amount);
1136 
1137         // del delegates to backhole
1138         _moveDelegates(_delegates[_msgSender()], address(0), amount);
1139     }
1140 
1141     function burnFrom(address account, uint256 amount) public override virtual {
1142         super.burnFrom(account, amount);
1143 
1144         // del delegates to the backhole
1145         _moveDelegates(_delegates[account], address(0), amount);
1146     }
1147     
1148     /**
1149     * @notice Delegate votes from `msg.sender` to `delegatee`
1150     * @param delegatee The address to delegate votes to
1151     */
1152     function delegate(address delegatee) external {
1153         return _delegate(msg.sender, delegatee);
1154     }
1155 
1156     /**
1157      * @notice Delegates votes from signatory to `delegatee`
1158      * @param delegatee The address to delegate votes to
1159      * @param nonce The contract state required to match the signature
1160      * @param expiry The time at which to expire the signature
1161      * @param v The recovery byte of the signature
1162      * @param r Half of the ECDSA signature pair
1163      * @param s Half of the ECDSA signature pair
1164      */
1165     function delegateBySig(
1166         address delegatee,
1167         uint nonce,
1168         uint expiry,
1169         uint8 v,
1170         bytes32 r,
1171         bytes32 s
1172     )
1173         external
1174     {
1175         bytes32 domainSeparator = keccak256(
1176             abi.encode(
1177                 DOMAIN_TYPEHASH,
1178                 keccak256(bytes(name())),
1179                 getChainId(),
1180                 address(this)
1181             )
1182         );
1183 
1184         bytes32 structHash = keccak256(
1185             abi.encode(
1186                 DELEGATION_TYPEHASH,
1187                 delegatee,
1188                 nonce,
1189                 expiry
1190             )
1191         );
1192 
1193         bytes32 digest = keccak256(
1194             abi.encodePacked(
1195                 "\x19\x01",
1196                 domainSeparator,
1197                 structHash
1198             )
1199         );
1200 
1201         address signatory = ecrecover(digest, v, r, s);
1202         require(signatory != address(0), "Governance::delegateBySig: invalid signature");
1203         require(nonce == nonces[signatory]++, "Governance::delegateBySig: invalid nonce");
1204         require(now <= expiry, "Governance::delegateBySig: signature expired");
1205         return _delegate(signatory, delegatee);
1206     }
1207 
1208     /**
1209      * @notice Gets the current votes balance for `account`
1210      * @param account The address to get votes balance
1211      * @return The number of current votes for `account`
1212      */
1213     function getCurrentVotes(address account)
1214         external
1215         view
1216         returns (uint256)
1217     {
1218         uint32 nCheckpoints = numCheckpoints[account];
1219         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1220     }
1221 
1222     /**
1223      * @notice Determine the prior number of votes for an account as of a block number
1224      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1225      * @param account The address of the account to check
1226      * @param blockNumber The block number to get the vote balance at
1227      * @return The number of votes the account had as of the given block
1228      */
1229     function getPriorVotes(address account, uint blockNumber)
1230         external
1231         view
1232         returns (uint256)
1233     {
1234         require(blockNumber < block.number, "Governance::getPriorVotes: not yet determined");
1235 
1236         uint32 nCheckpoints = numCheckpoints[account];
1237         if (nCheckpoints == 0) {
1238             return 0;
1239         }
1240 
1241         // First check most recent balance
1242         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1243             return checkpoints[account][nCheckpoints - 1].votes;
1244         }
1245 
1246         // Next check implicit zero balance
1247         if (checkpoints[account][0].fromBlock > blockNumber) {
1248             return 0;
1249         }
1250 
1251         uint32 lower = 0;
1252         uint32 upper = nCheckpoints - 1;
1253         while (upper > lower) {
1254             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1255             Checkpoint memory cp = checkpoints[account][center];
1256             if (cp.fromBlock == blockNumber) {
1257                 return cp.votes;
1258             } else if (cp.fromBlock < blockNumber) {
1259                 lower = center;
1260             } else {
1261                 upper = center - 1;
1262             }
1263         }
1264         return checkpoints[account][lower].votes;
1265     }
1266 
1267     function _delegate(address delegator, address delegatee)
1268         internal
1269     {
1270         address currentDelegate = _delegates[delegator];
1271         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying balances (not scaled);
1272         _delegates[delegator] = delegatee;
1273 
1274         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1275 
1276         emit DelegateChanged(delegator, currentDelegate, delegatee);
1277     }
1278 
1279     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1280         if (srcRep != dstRep && amount > 0) {
1281             if (srcRep != address(0)) {
1282                 // decrease old representative
1283                 uint32 srcRepNum = numCheckpoints[srcRep];
1284                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1285                 uint256 srcRepNew = srcRepOld.sub(amount);
1286                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1287             }
1288 
1289             if (dstRep != address(0)) {
1290                 // increase new representative
1291                 uint32 dstRepNum = numCheckpoints[dstRep];
1292                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1293                 uint256 dstRepNew = dstRepOld.add(amount);
1294                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1295             }
1296         }
1297     }
1298 
1299     function _writeCheckpoint(
1300         address delegatee,
1301         uint32 nCheckpoints,
1302         uint256 oldVotes,
1303         uint256 newVotes
1304     )
1305         internal
1306     {
1307         uint32 blockNumber = safe32(block.number, "Governance::_writeCheckpoint: block number exceeds 32 bits");
1308 
1309         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1310             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1311         } else {
1312             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1313             numCheckpoints[delegatee] = nCheckpoints + 1;
1314         }
1315 
1316         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1317     }
1318 
1319     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1320         require(n < 2**32, errorMessage);
1321         return uint32(n);
1322     }
1323 
1324     function getChainId() internal pure returns (uint) {
1325         uint256 chainId;
1326         assembly { chainId := chainid() }
1327 
1328         return chainId;
1329     }
1330 
1331     
1332 
1333     /// @notice An event thats emitted when an account changes its delegate
1334     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1335 
1336     /// @notice An event thats emitted when a delegate account's vote balance changes
1337     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1338 
1339 }
1340 
1341 
1342 /**
1343  * @author  Sunder.Team
1344  *
1345  * @dev     Contract for Sunder token with burn support
1346  */
1347 
1348 pragma solidity ^0.6.0;
1349 
1350 
1351 
1352 
1353 // Sunder erc20 Token Contract.
1354 contract Sunder is DeligateERC20, Ownable {
1355     uint256 private constant maxSupply      = 200 * 1e6 * 1e18;     // the total supply
1356 
1357     uint256 private idoSupply       = 5 * 1e6 * 1e18;       // pre-mine for ido
1358     address private idoAdmin        = msg.sender;
1359     
1360     uint256 private preMineSupply   = 85 * 1e6 * 1e18;      // pre-mine for locking
1361     address private preMineAdmin    = 0xf8e835232daE0295Ac12FD326EA75b22a6F732E7;
1362 
1363     // for minters
1364     using EnumerableSet for EnumerableSet.AddressSet;
1365     EnumerableSet.AddressSet private _minters;
1366 
1367 
1368     constructor() public ERC20("Sunder Goverance Token", "Sunder") {
1369         _mint(idoAdmin, idoSupply);
1370         _mint(preMineAdmin, preMineSupply);
1371     }
1372 
1373 
1374     // mint with max supply
1375     function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
1376         if(_amount.add(totalSupply()) > maxSupply) {
1377             return false;
1378         }
1379 
1380         _mint(_to, _amount);
1381         return true;
1382     }
1383 
1384 
1385     function addMinter(address _addMinter) public onlyOwner returns (bool) {
1386         require(_addMinter != address(0), "Alert: _addMinter is the zero address");
1387         
1388         return EnumerableSet.add(_minters, _addMinter);
1389     }
1390 
1391     function delMinter(address _delMinter) public onlyOwner returns (bool) {
1392         require(_delMinter != address(0), "Alert: _delMinter is the zero address");
1393         
1394         return EnumerableSet.remove(_minters, _delMinter);
1395     }
1396 
1397     function getMinterLength() public view returns (uint256) {
1398         return EnumerableSet.length(_minters);
1399     }
1400 
1401     function isMinter(address account) public view returns (bool) {
1402         return EnumerableSet.contains(_minters, account);
1403     }
1404 
1405     modifier onlyMinter() {
1406         require(isMinter(msg.sender), "Alert: caller is not the minter");
1407         _;
1408     }
1409 }