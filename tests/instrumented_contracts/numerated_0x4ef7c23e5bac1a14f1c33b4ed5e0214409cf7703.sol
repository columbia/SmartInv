1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-21
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
51         mapping(bytes32 => uint256) _indexes;
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
82         if (valueIndex != 0) {// Equivalent to contains(set, value)
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
98             set._indexes[lastvalue] = toDeleteIndex + 1;
99             // All indexes are 1-based
100 
101             // Delete the slot where the moved value was stored
102             set._values.pop();
103 
104             // Delete the index for the deleted slot
105             delete set._indexes[value];
106 
107             return true;
108         } else {
109             return false;
110         }
111     }
112 
113     /**
114      * @dev Returns true if the value is in the set. O(1).
115      */
116     function _contains(Set storage set, bytes32 value) private view returns (bool) {
117         return set._indexes[value] != 0;
118     }
119 
120     /**
121      * @dev Returns the number of values on the set. O(1).
122      */
123     function _length(Set storage set) private view returns (uint256) {
124         return set._values.length;
125     }
126 
127     /**
128      * @dev Returns the value stored at position `index` in the set. O(1).
129      *
130      * Note that there are no guarantees on the ordering of values inside the
131      * array, and it may change when more values are added or removed.
132      *
133      * Requirements:
134      *
135      * - `index` must be strictly less than {length}.
136      */
137     function _at(Set storage set, uint256 index) private view returns (bytes32) {
138         require(set._values.length > index, "EnumerableSet: index out of bounds");
139         return set._values[index];
140     }
141 
142     // AddressSet
143 
144     struct AddressSet {
145         Set _inner;
146     }
147 
148     /**
149      * @dev Add a value to a set. O(1).
150      *
151      * Returns true if the value was added to the set, that is if it was not
152      * already present.
153      */
154     function add(AddressSet storage set, address value) internal returns (bool) {
155         return _add(set._inner, bytes32(uint256(value)));
156     }
157 
158     /**
159      * @dev Removes a value from a set. O(1).
160      *
161      * Returns true if the value was removed from the set, that is if it was
162      * present.
163      */
164     function remove(AddressSet storage set, address value) internal returns (bool) {
165         return _remove(set._inner, bytes32(uint256(value)));
166     }
167 
168     /**
169      * @dev Returns true if the value is in the set. O(1).
170      */
171     function contains(AddressSet storage set, address value) internal view returns (bool) {
172         return _contains(set._inner, bytes32(uint256(value)));
173     }
174 
175     /**
176      * @dev Returns the number of values in the set. O(1).
177      */
178     function length(AddressSet storage set) internal view returns (uint256) {
179         return _length(set._inner);
180     }
181 
182     /**
183      * @dev Returns the value stored at position `index` in the set. O(1).
184      *
185      * Note that there are no guarantees on the ordering of values inside the
186      * array, and it may change when more values are added or removed.
187      *
188      * Requirements:
189      *
190      * - `index` must be strictly less than {length}.
191      */
192     function at(AddressSet storage set, uint256 index) internal view returns (address) {
193         return address(uint256(_at(set._inner, index)));
194     }
195 
196 
197     // UintSet
198 
199     struct UintSet {
200         Set _inner;
201     }
202 
203     /**
204      * @dev Add a value to a set. O(1).
205      *
206      * Returns true if the value was added to the set, that is if it was not
207      * already present.
208      */
209     function add(UintSet storage set, uint256 value) internal returns (bool) {
210         return _add(set._inner, bytes32(value));
211     }
212 
213     /**
214      * @dev Removes a value from a set. O(1).
215      *
216      * Returns true if the value was removed from the set, that is if it was
217      * present.
218      */
219     function remove(UintSet storage set, uint256 value) internal returns (bool) {
220         return _remove(set._inner, bytes32(value));
221     }
222 
223     /**
224      * @dev Returns true if the value is in the set. O(1).
225      */
226     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
227         return _contains(set._inner, bytes32(value));
228     }
229 
230     /**
231      * @dev Returns the number of values on the set. O(1).
232      */
233     function length(UintSet storage set) internal view returns (uint256) {
234         return _length(set._inner);
235     }
236 
237     /**
238      * @dev Returns the value stored at position `index` in the set. O(1).
239      *
240      * Note that there are no guarantees on the ordering of values inside the
241      * array, and it may change when more values are added or removed.
242      *
243      * Requirements:
244      *
245      * - `index` must be strictly less than {length}.
246      */
247     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
248         return uint256(_at(set._inner, index));
249     }
250 }
251 
252 // File: @openzeppelin/contracts/GSN/Context.sol
253 
254 
255 
256 pragma solidity ^0.6.0;
257 
258 /*
259  * @dev Provides information about the current execution context, including the
260  * sender of the transaction and its data. While these are generally available
261  * via msg.sender and msg.data, they should not be accessed in such a direct
262  * manner, since when dealing with GSN meta-transactions the account sending and
263  * paying for execution may not be the actual sender (as far as an application
264  * is concerned).
265  *
266  * This contract is only required for intermediate, library-like contracts.
267  */
268 abstract contract Context {
269     function _msgSender() internal view virtual returns (address payable) {
270         return msg.sender;
271     }
272 
273     function _msgData() internal view virtual returns (bytes memory) {
274         this;
275         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
276         return msg.data;
277     }
278 }
279 
280 // File: @openzeppelin/contracts/access/Ownable.sol
281 
282 
283 
284 pragma solidity ^0.6.0;
285 
286 /**
287  * @dev Contract module which provides a basic access control mechanism, where
288  * there is an account (an owner) that can be granted exclusive access to
289  * specific functions.
290  *
291  * By default, the owner account will be the one that deploys the contract. This
292  * can later be changed with {transferOwnership}.
293  *
294  * This module is used through inheritance. It will make available the modifier
295  * `onlyOwner`, which can be applied to your functions to restrict their use to
296  * the owner.
297  */
298 contract Ownable is Context {
299     address private _owner;
300 
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303     /**
304      * @dev Initializes the contract setting the deployer as the initial owner.
305      */
306     constructor () internal {
307         address msgSender = _msgSender();
308         _owner = msgSender;
309         emit OwnershipTransferred(address(0), msgSender);
310     }
311 
312     /**
313      * @dev Returns the address of the current owner.
314      */
315     function owner() public view returns (address) {
316         return _owner;
317     }
318 
319     /**
320      * @dev Throws if called by any account other than the owner.
321      */
322     modifier onlyOwner() {
323         require(_owner == _msgSender(), "Ownable: caller is not the owner");
324         _;
325     }
326 
327     /**
328      * @dev Leaves the contract without owner. It will not be possible to call
329      * `onlyOwner` functions anymore. Can only be called by the current owner.
330      *
331      * NOTE: Renouncing ownership will leave the contract without an owner,
332      * thereby removing any functionality that is only available to the owner.
333      */
334     function renounceOwnership() public virtual onlyOwner {
335         emit OwnershipTransferred(_owner, address(0));
336         _owner = address(0);
337     }
338 
339     /**
340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
341      * Can only be called by the current owner.
342      */
343     function transferOwnership(address newOwner) public virtual onlyOwner {
344         require(newOwner != address(0), "Ownable: new owner is the zero address");
345         emit OwnershipTransferred(_owner, newOwner);
346         _owner = newOwner;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
351 
352 
353 
354 pragma solidity ^0.6.0;
355 
356 /**
357  * @dev Interface of the ERC20 standard as defined in the EIP.
358  */
359 interface IERC20 {
360     /**
361      * @dev Returns the amount of tokens in existence.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     /**
366      * @dev Returns the amount of tokens owned by `account`.
367      */
368     function balanceOf(address account) external view returns (uint256);
369 
370     /**
371      * @dev Moves `amount` tokens from the caller's account to `recipient`.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transfer(address recipient, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Returns the remaining number of tokens that `spender` will be
381      * allowed to spend on behalf of `owner` through {transferFrom}. This is
382      * zero by default.
383      *
384      * This value changes when {approve} or {transferFrom} are called.
385      */
386     function allowance(address owner, address spender) external view returns (uint256);
387 
388     /**
389      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * IMPORTANT: Beware that changing an allowance with this method brings the risk
394      * that someone may use both the old and the new allowance by unfortunate
395      * transaction ordering. One possible solution to mitigate this race
396      * condition is to first reduce the spender's allowance to 0 and set the
397      * desired value afterwards:
398      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
399      *
400      * Emits an {Approval} event.
401      */
402     function approve(address spender, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Moves `amount` tokens from `sender` to `recipient` using the
406      * allowance mechanism. `amount` is then deducted from the caller's
407      * allowance.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
414 
415     /**
416      * @dev Emitted when `value` tokens are moved from one account (`from`) to
417      * another (`to`).
418      *
419      * Note that `value` may be zero.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 value);
422 
423     /**
424      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
425      * a call to {approve}. `value` is the new allowance.
426      */
427     event Approval(address indexed owner, address indexed spender, uint256 value);
428 }
429 
430 // File: @openzeppelin/contracts/math/SafeMath.sol
431 
432 
433 
434 pragma solidity ^0.6.0;
435 
436 /**
437  * @dev Wrappers over Solidity's arithmetic operations with added overflow
438  * checks.
439  *
440  * Arithmetic operations in Solidity wrap on overflow. This can easily result
441  * in bugs, because programmers usually assume that an overflow raises an
442  * error, which is the standard behavior in high level programming languages.
443  * `SafeMath` restores this intuition by reverting the transaction when an
444  * operation overflows.
445  *
446  * Using this library instead of the unchecked operations eliminates an entire
447  * class of bugs, so it's recommended to use it always.
448  */
449 library SafeMath {
450     /**
451      * @dev Returns the addition of two unsigned integers, reverting on
452      * overflow.
453      *
454      * Counterpart to Solidity's `+` operator.
455      *
456      * Requirements:
457      *
458      * - Addition cannot overflow.
459      */
460     function add(uint256 a, uint256 b) internal pure returns (uint256) {
461         uint256 c = a + b;
462         require(c >= a, "SafeMath: addition overflow");
463 
464         return c;
465     }
466 
467     /**
468      * @dev Returns the subtraction of two unsigned integers, reverting on
469      * overflow (when the result is negative).
470      *
471      * Counterpart to Solidity's `-` operator.
472      *
473      * Requirements:
474      *
475      * - Subtraction cannot overflow.
476      */
477     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
478         return sub(a, b, "SafeMath: subtraction overflow");
479     }
480 
481     /**
482      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
483      * overflow (when the result is negative).
484      *
485      * Counterpart to Solidity's `-` operator.
486      *
487      * Requirements:
488      *
489      * - Subtraction cannot overflow.
490      */
491     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
492         require(b <= a, errorMessage);
493         uint256 c = a - b;
494 
495         return c;
496     }
497 
498     /**
499      * @dev Returns the multiplication of two unsigned integers, reverting on
500      * overflow.
501      *
502      * Counterpart to Solidity's `*` operator.
503      *
504      * Requirements:
505      *
506      * - Multiplication cannot overflow.
507      */
508     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
509         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
510         // benefit is lost if 'b' is also tested.
511         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
512         if (a == 0) {
513             return 0;
514         }
515 
516         uint256 c = a * b;
517         require(c / a == b, "SafeMath: multiplication overflow");
518 
519         return c;
520     }
521 
522     /**
523      * @dev Returns the integer division of two unsigned integers. Reverts on
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
534     function div(uint256 a, uint256 b) internal pure returns (uint256) {
535         return div(a, b, "SafeMath: division by zero");
536     }
537 
538     /**
539      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
540      * division by zero. The result is rounded towards zero.
541      *
542      * Counterpart to Solidity's `/` operator. Note: this function uses a
543      * `revert` opcode (which leaves remaining gas untouched) while Solidity
544      * uses an invalid opcode to revert (consuming all remaining gas).
545      *
546      * Requirements:
547      *
548      * - The divisor cannot be zero.
549      */
550     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
551         require(b > 0, errorMessage);
552         uint256 c = a / b;
553         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
554 
555         return c;
556     }
557 
558     /**
559      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
560      * Reverts when dividing by zero.
561      *
562      * Counterpart to Solidity's `%` operator. This function uses a `revert`
563      * opcode (which leaves remaining gas untouched) while Solidity uses an
564      * invalid opcode to revert (consuming all remaining gas).
565      *
566      * Requirements:
567      *
568      * - The divisor cannot be zero.
569      */
570     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
571         return mod(a, b, "SafeMath: modulo by zero");
572     }
573 
574     /**
575      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
576      * Reverts with custom message when dividing by zero.
577      *
578      * Counterpart to Solidity's `%` operator. This function uses a `revert`
579      * opcode (which leaves remaining gas untouched) while Solidity uses an
580      * invalid opcode to revert (consuming all remaining gas).
581      *
582      * Requirements:
583      *
584      * - The divisor cannot be zero.
585      */
586     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
587         require(b != 0, errorMessage);
588         return a % b;
589     }
590 }
591 
592 // File: @openzeppelin/contracts/utils/Address.sol
593 
594 
595 
596 pragma solidity ^0.6.2;
597 
598 /**
599  * @dev Collection of functions related to the address type
600  */
601 library Address {
602     /**
603      * @dev Returns true if `account` is a contract.
604      *
605      * [IMPORTANT]
606      * ====
607      * It is unsafe to assume that an address for which this function returns
608      * false is an externally-owned account (EOA) and not a contract.
609      *
610      * Among others, `isContract` will return false for the following
611      * types of addresses:
612      *
613      *  - an externally-owned account
614      *  - a contract in construction
615      *  - an address where a contract will be created
616      *  - an address where a contract lived, but was destroyed
617      * ====
618      */
619     function isContract(address account) internal view returns (bool) {
620         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
621         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
622         // for accounts without code, i.e. `keccak256('')`
623         bytes32 codehash;
624         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
625         // solhint-disable-next-line no-inline-assembly
626         assembly {codehash := extcodehash(account)}
627         return (codehash != accountHash && codehash != 0x0);
628     }
629 
630     /**
631      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
632      * `recipient`, forwarding all available gas and reverting on errors.
633      *
634      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
635      * of certain opcodes, possibly making contracts go over the 2300 gas limit
636      * imposed by `transfer`, making them unable to receive funds via
637      * `transfer`. {sendValue} removes this limitation.
638      *
639      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
640      *
641      * IMPORTANT: because control is transferred to `recipient`, care must be
642      * taken to not create reentrancy vulnerabilities. Consider using
643      * {ReentrancyGuard} or the
644      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
645      */
646     function sendValue(address payable recipient, uint256 amount) internal {
647         require(address(this).balance >= amount, "Address: insufficient balance");
648 
649         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
650         (bool success,) = recipient.call{value : amount}("");
651         require(success, "Address: unable to send value, recipient may have reverted");
652     }
653 
654     /**
655      * @dev Performs a Solidity function call using a low level `call`. A
656      * plain`call` is an unsafe replacement for a function call: use this
657      * function instead.
658      *
659      * If `target` reverts with a revert reason, it is bubbled up by this
660      * function (like regular Solidity function calls).
661      *
662      * Returns the raw returned data. To convert to the expected return value,
663      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
664      *
665      * Requirements:
666      *
667      * - `target` must be a contract.
668      * - calling `target` with `data` must not revert.
669      *
670      * _Available since v3.1._
671      */
672     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
673         return functionCall(target, data, "Address: low-level call failed");
674     }
675 
676     /**
677      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
678      * `errorMessage` as a fallback revert reason when `target` reverts.
679      *
680      * _Available since v3.1._
681      */
682     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
683         return _functionCallWithValue(target, data, 0, errorMessage);
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
688      * but also transferring `value` wei to `target`.
689      *
690      * Requirements:
691      *
692      * - the calling contract must have an ETH balance of at least `value`.
693      * - the called Solidity function must be `payable`.
694      *
695      * _Available since v3.1._
696      */
697     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
698         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
703      * with `errorMessage` as a fallback revert reason when `target` reverts.
704      *
705      * _Available since v3.1._
706      */
707     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
708         require(address(this).balance >= value, "Address: insufficient balance for call");
709         return _functionCallWithValue(target, data, value, errorMessage);
710     }
711 
712     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
713         require(isContract(target), "Address: call to non-contract");
714 
715         // solhint-disable-next-line avoid-low-level-calls
716         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
717         if (success) {
718             return returndata;
719         } else {
720             // Look for revert reason and bubble it up if present
721             if (returndata.length > 0) {
722                 // The easiest way to bubble the revert reason is using memory via assembly
723 
724                 // solhint-disable-next-line no-inline-assembly
725                 assembly {
726                     let returndata_size := mload(returndata)
727                     revert(add(32, returndata), returndata_size)
728                 }
729             } else {
730                 revert(errorMessage);
731             }
732         }
733     }
734 }
735 
736 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
737 
738 
739 
740 pragma solidity ^0.6.0;
741 
742 
743 
744 
745 
746 /**
747  * @dev Implementation of the {IERC20} interface.
748  *
749  * This implementation is agnostic to the way tokens are created. This means
750  * that a supply mechanism has to be added in a derived contract using {_mint}.
751  * For a generic mechanism see {ERC20PresetMinterPauser}.
752  *
753  * TIP: For a detailed writeup see our guide
754  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
755  * to implement supply mechanisms].
756  *
757  * We have followed general OpenZeppelin guidelines: functions revert instead
758  * of returning `false` on failure. This behavior is nonetheless conventional
759  * and does not conflict with the expectations of ERC20 applications.
760  *
761  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
762  * This allows applications to reconstruct the allowance for all accounts just
763  * by listening to said events. Other implementations of the EIP may not emit
764  * these events, as it isn't required by the specification.
765  *
766  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
767  * functions have been added to mitigate the well-known issues around setting
768  * allowances. See {IERC20-approve}.
769  */
770 contract ERC20 is Context, IERC20 {
771     using SafeMath for uint256;
772     using Address for address;
773 
774     mapping(address => uint256) private _balances;
775 
776     mapping(address => mapping(address => uint256)) private _allowances;
777 
778     uint256 private _totalSupply;
779 
780     string private _name;
781     string private _symbol;
782     uint8 private _decimals;
783 
784     /**
785      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
786      * a default value of 18.
787      *
788      * To select a different value for {decimals}, use {_setupDecimals}.
789      *
790      * All three of these values are immutable: they can only be set once during
791      * construction.
792      */
793     constructor (string memory name, string memory symbol) public {
794         _name = name;
795         _symbol = symbol;
796         _decimals = 18;
797     }
798 
799     /**
800      * @dev Returns the name of the token.
801      */
802     function name() public view returns (string memory) {
803         return _name;
804     }
805 
806     /**
807      * @dev Returns the symbol of the token, usually a shorter version of the
808      * name.
809      */
810     function symbol() public view returns (string memory) {
811         return _symbol;
812     }
813 
814     /**
815      * @dev Returns the number of decimals used to get its user representation.
816      * For example, if `decimals` equals `2`, a balance of `505` tokens should
817      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
818      *
819      * Tokens usually opt for a value of 18, imitating the relationship between
820      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
821      * called.
822      *
823      * NOTE: This information is only used for _display_ purposes: it in
824      * no way affects any of the arithmetic of the contract, including
825      * {IERC20-balanceOf} and {IERC20-transfer}.
826      */
827     function decimals() public view returns (uint8) {
828         return _decimals;
829     }
830 
831     /**
832      * @dev See {IERC20-totalSupply}.
833      */
834     function totalSupply() public view override returns (uint256) {
835         return _totalSupply;
836     }
837 
838     /**
839      * @dev See {IERC20-balanceOf}.
840      */
841     function balanceOf(address account) public view override returns (uint256) {
842         return _balances[account];
843     }
844 
845     /**
846      * @dev See {IERC20-transfer}.
847      *
848      * Requirements:
849      *
850      * - `recipient` cannot be the zero address.
851      * - the caller must have a balance of at least `amount`.
852      */
853     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
854         _transfer(_msgSender(), recipient, amount);
855         return true;
856     }
857 
858     /**
859      * @dev See {IERC20-allowance}.
860      */
861     function allowance(address owner, address spender) public view virtual override returns (uint256) {
862         return _allowances[owner][spender];
863     }
864 
865     /**
866      * @dev See {IERC20-approve}.
867      *
868      * Requirements:
869      *
870      * - `spender` cannot be the zero address.
871      */
872     function approve(address spender, uint256 amount) public virtual override returns (bool) {
873         _approve(_msgSender(), spender, amount);
874         return true;
875     }
876 
877     /**
878      * @dev See {IERC20-transferFrom}.
879      *
880      * Emits an {Approval} event indicating the updated allowance. This is not
881      * required by the EIP. See the note at the beginning of {ERC20};
882      *
883      * Requirements:
884      * - `sender` and `recipient` cannot be the zero address.
885      * - `sender` must have a balance of at least `amount`.
886      * - the caller must have allowance for ``sender``'s tokens of at least
887      * `amount`.
888      */
889     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
890         _transfer(sender, recipient, amount);
891         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
892         return true;
893     }
894 
895     /**
896      * @dev Atomically increases the allowance granted to `spender` by the caller.
897      *
898      * This is an alternative to {approve} that can be used as a mitigation for
899      * problems described in {IERC20-approve}.
900      *
901      * Emits an {Approval} event indicating the updated allowance.
902      *
903      * Requirements:
904      *
905      * - `spender` cannot be the zero address.
906      */
907     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
908         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
909         return true;
910     }
911 
912     /**
913      * @dev Atomically decreases the allowance granted to `spender` by the caller.
914      *
915      * This is an alternative to {approve} that can be used as a mitigation for
916      * problems described in {IERC20-approve}.
917      *
918      * Emits an {Approval} event indicating the updated allowance.
919      *
920      * Requirements:
921      *
922      * - `spender` cannot be the zero address.
923      * - `spender` must have allowance for the caller of at least
924      * `subtractedValue`.
925      */
926     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
927         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
928         return true;
929     }
930 
931     /**
932      * @dev Moves tokens `amount` from `sender` to `recipient`.
933      *
934      * This is internal function is equivalent to {transfer}, and can be used to
935      * e.g. implement automatic token fees, slashing mechanisms, etc.
936      *
937      * Emits a {Transfer} event.
938      *
939      * Requirements:
940      *
941      * - `sender` cannot be the zero address.
942      * - `recipient` cannot be the zero address.
943      * - `sender` must have a balance of at least `amount`.
944      */
945     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
946         require(sender != address(0), "ERC20: transfer from the zero address");
947         require(recipient != address(0), "ERC20: transfer to the zero address");
948 
949         _beforeTokenTransfer(sender, recipient, amount);
950 
951         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
952         _balances[recipient] = _balances[recipient].add(amount);
953         emit Transfer(sender, recipient, amount);
954     }
955 
956     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
957      * the total supply.
958      *
959      * Emits a {Transfer} event with `from` set to the zero address.
960      *
961      * Requirements
962      *
963      * - `to` cannot be the zero address.
964      */
965     function _mint(address account, uint256 amount) internal virtual {
966         require(account != address(0), "ERC20: mint to the zero address");
967 
968         _beforeTokenTransfer(address(0), account, amount);
969 
970         _totalSupply = _totalSupply.add(amount);
971         _balances[account] = _balances[account].add(amount);
972         emit Transfer(address(0), account, amount);
973     }
974 
975     /**
976      * @dev Destroys `amount` tokens from `account`, reducing the
977      * total supply.
978      *
979      * Emits a {Transfer} event with `to` set to the zero address.
980      *
981      * Requirements
982      *
983      * - `account` cannot be the zero address.
984      * - `account` must have at least `amount` tokens.
985      */
986     function _burn(address account, uint256 amount) internal virtual {
987         require(account != address(0), "ERC20: burn from the zero address");
988 
989         _beforeTokenTransfer(account, address(0), amount);
990 
991         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
992         _totalSupply = _totalSupply.sub(amount);
993         emit Transfer(account, address(0), amount);
994     }
995 
996     /**
997      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
998      *
999      * This is internal function is equivalent to `approve`, and can be used to
1000      * e.g. set automatic allowances for certain subsystems, etc.
1001      *
1002      * Emits an {Approval} event.
1003      *
1004      * Requirements:
1005      *
1006      * - `owner` cannot be the zero address.
1007      * - `spender` cannot be the zero address.
1008      */
1009     function _approve(address owner, address spender, uint256 amount) internal virtual {
1010         require(owner != address(0), "ERC20: approve from the zero address");
1011         require(spender != address(0), "ERC20: approve to the zero address");
1012 
1013         _allowances[owner][spender] = amount;
1014         emit Approval(owner, spender, amount);
1015     }
1016 
1017     /**
1018      * @dev Sets {decimals} to a value other than the default one of 18.
1019      *
1020      * WARNING: This function should only be called from the constructor. Most
1021      * applications that interact with token contracts will not expect
1022      * {decimals} to ever change, and may work incorrectly if it does.
1023      */
1024     function _setupDecimals(uint8 decimals_) internal {
1025         _decimals = decimals_;
1026     }
1027 
1028     /**
1029      * @dev Hook that is called before any transfer of tokens. This includes
1030      * minting and burning.
1031      *
1032      * Calling conditions:
1033      *
1034      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1035      * will be to transferred to `to`.
1036      * - when `from` is zero, `amount` tokens will be minted for `to`.
1037      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1038      * - `from` and `to` are never both zero.
1039      *
1040      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1041      */
1042     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1043 }
1044 
1045 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1046 
1047 
1048 
1049 pragma solidity ^0.6.0;
1050 
1051 
1052 
1053 /**
1054  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1055  * tokens and those that they have an allowance for, in a way that can be
1056  * recognized off-chain (via event analysis).
1057  */
1058 abstract contract ERC20Burnable is Context, ERC20 {
1059     /**
1060      * @dev Destroys `amount` tokens from the caller.
1061      *
1062      * See {ERC20-_burn}.
1063      */
1064     function burn(uint256 amount) public virtual {
1065         _burn(_msgSender(), amount);
1066     }
1067 
1068     /**
1069      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1070      * allowance.
1071      *
1072      * See {ERC20-_burn} and {ERC20-allowance}.
1073      *
1074      * Requirements:
1075      *
1076      * - the caller must have allowance for ``accounts``'s tokens of at least
1077      * `amount`.
1078      */
1079     function burnFrom(address account, uint256 amount) public virtual {
1080         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1081 
1082         _approve(account, _msgSender(), decreasedAllowance);
1083         _burn(account, amount);
1084     }
1085 }
1086 
1087 // File: contracts/governance.sol
1088 
1089 pragma solidity ^0.6.0;
1090 pragma experimental ABIEncoderV2;
1091 
1092 
1093 abstract contract DeligateERC20 is ERC20Burnable {
1094     /// @notice A record of each accounts delegate
1095     mapping(address => address) internal _delegates;
1096 
1097     /// @notice A checkpoint for marking number of votes from a given block
1098     struct Checkpoint {
1099         uint32 fromBlock;
1100         uint256 votes;
1101     }
1102 
1103     /// @notice A record of votes checkpoints for each account, by index
1104     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1105 
1106     /// @notice The number of checkpoints for each account
1107     mapping(address => uint32) public numCheckpoints;
1108 
1109     /// @notice The EIP-712 typehash for the contract's domain
1110     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1111 
1112     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1113     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1114 
1115     /// @notice A record of states for signing / validating signatures
1116     mapping(address => uint) public nonces;
1117 
1118 
1119     // support delegates mint
1120     function _mint(address account, uint256 amount) internal override virtual {
1121         super._mint(account, amount);
1122 
1123         // add delegates to the minter
1124         _moveDelegates(address(0), _delegates[account], amount);
1125     }
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
1173     external
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
1214     external
1215     view
1216     returns (uint256)
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
1230     external
1231     view
1232     returns (uint256)
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
1254             uint32 center = upper - (upper - lower) / 2;
1255             // ceil, avoiding overflow
1256             Checkpoint memory cp = checkpoints[account][center];
1257             if (cp.fromBlock == blockNumber) {
1258                 return cp.votes;
1259             } else if (cp.fromBlock < blockNumber) {
1260                 lower = center;
1261             } else {
1262                 upper = center - 1;
1263             }
1264         }
1265         return checkpoints[account][lower].votes;
1266     }
1267 
1268     function _delegate(address delegator, address delegatee)
1269     internal
1270     {
1271         address currentDelegate = _delegates[delegator];
1272         uint256 delegatorBalance = balanceOf(delegator);
1273         // balance of underlying balances (not scaled);
1274         _delegates[delegator] = delegatee;
1275 
1276         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1277 
1278         emit DelegateChanged(delegator, currentDelegate, delegatee);
1279     }
1280 
1281     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1282         if (srcRep != dstRep && amount > 0) {
1283             if (srcRep != address(0)) {
1284                 // decrease old representative
1285                 uint32 srcRepNum = numCheckpoints[srcRep];
1286                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1287                 uint256 srcRepNew = srcRepOld.sub(amount);
1288                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1289             }
1290 
1291             if (dstRep != address(0)) {
1292                 // increase new representative
1293                 uint32 dstRepNum = numCheckpoints[dstRep];
1294                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1295                 uint256 dstRepNew = dstRepOld.add(amount);
1296                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1297             }
1298         }
1299     }
1300 
1301     function _writeCheckpoint(
1302         address delegatee,
1303         uint32 nCheckpoints,
1304         uint256 oldVotes,
1305         uint256 newVotes
1306     )
1307     internal
1308     {
1309         uint32 blockNumber = safe32(block.number, "Governance::_writeCheckpoint: block number exceeds 32 bits");
1310 
1311         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1312             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1313         } else {
1314             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1315             numCheckpoints[delegatee] = nCheckpoints + 1;
1316         }
1317 
1318         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1319     }
1320 
1321     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1322         require(n < 2 ** 32, errorMessage);
1323         return uint32(n);
1324     }
1325 
1326     function getChainId() internal pure returns (uint) {
1327         uint256 chainId;
1328         assembly {chainId := chainid()}
1329 
1330         return chainId;
1331     }
1332 
1333 
1334 
1335     /// @notice An event thats emitted when an account changes its delegate
1336     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1337 
1338     /// @notice An event thats emitted when a delegate account's vote balance changes
1339     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1340 
1341 }
1342 
1343 
1344 // SPDX-License-Identifier: AntNetwork
1345 
1346 /**
1347  * @author  AntNetwork
1348  *
1349  * @dev     Contract for AntNetwork token with burn support
1350  */
1351 
1352 pragma solidity ^0.6.0;
1353 
1354 
1355 
1356 
1357 // AntNetwork erc20 Token Contract.
1358 contract AntNetworkToken is DeligateERC20, Ownable {
1359     uint256 private constant maxSupply = 21000 * 1e18;     // the total supply
1360 
1361     // for minters
1362     using EnumerableSet for EnumerableSet.AddressSet;
1363     EnumerableSet.AddressSet private _minters;
1364 
1365 
1366     constructor() public ERC20("AntNetwork", "ANT") {}
1367 
1368 
1369     // mint with max supply
1370     function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
1371         if (_amount.add(totalSupply()) > maxSupply) {
1372             return false;
1373         }
1374 
1375         _mint(_to, _amount);
1376         return true;
1377     }
1378 
1379 
1380     function addMinter(address _addMinter) public onlyOwner returns (bool) {
1381         require(_addMinter != address(0), "AntNetwork: _addMinter is the zero address");
1382 
1383         return EnumerableSet.add(_minters, _addMinter);
1384     }
1385 
1386     function delMinter(address _delMinter) public onlyOwner returns (bool) {
1387         require(_delMinter != address(0), "AntNetwork: _delMinter is the zero address");
1388 
1389         return EnumerableSet.remove(_minters, _delMinter);
1390     }
1391 
1392     function getMinterLength() public view returns (uint256) {
1393         return EnumerableSet.length(_minters);
1394     }
1395 
1396     function isMinter(address account) public view returns (bool) {
1397         return EnumerableSet.contains(_minters, account);
1398     }
1399 
1400     // modifier for mint function
1401     modifier onlyMinter() {
1402         require(isMinter(msg.sender), "AntNetwork: caller is not the minter");
1403         _;
1404     }
1405 }