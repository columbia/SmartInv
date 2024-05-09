1 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
2 
3 
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Library for managing
9  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
10  * types.
11  *
12  * Sets have the following properties:
13  *
14  * - Elements are added, removed, and checked for existence in constant time
15  * (O(1)).
16  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
17  *
18  * ```
19  * contract Example {
20  *     // Add the library methods
21  *     using EnumerableSet for EnumerableSet.AddressSet;
22  *
23  *     // Declare a set state variable
24  *     EnumerableSet.AddressSet private mySet;
25  * }
26  * ```
27  *
28  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
29  * (`UintSet`) are supported.
30  */
31 library EnumerableSet {
32     // To implement this library for multiple types with as little code
33     // repetition as possible, we write it in terms of a generic Set type with
34     // bytes32 values.
35     // The Set implementation uses private functions, and user-facing
36     // implementations (such as AddressSet) are just wrappers around the
37     // underlying Set.
38     // This means that we can only create new EnumerableSets for types that fit
39     // in bytes32.
40 
41     struct Set {
42         // Storage of set values
43         bytes32[] _values;
44 
45         // Position of the value in the `values` array, plus 1 because index 0
46         // means a value is not in the set.
47         mapping (bytes32 => uint256) _indexes;
48     }
49 
50     /**
51      * @dev Add a value to a set. O(1).
52      *
53      * Returns true if the value was added to the set, that is if it was not
54      * already present.
55      */
56     function _add(Set storage set, bytes32 value) private returns (bool) {
57         if (!_contains(set, value)) {
58             set._values.push(value);
59             // The value is stored at length-1, but we add 1 to all indexes
60             // and use 0 as a sentinel value
61             set._indexes[value] = set._values.length;
62             return true;
63         } else {
64             return false;
65         }
66     }
67 
68     /**
69      * @dev Removes a value from a set. O(1).
70      *
71      * Returns true if the value was removed from the set, that is if it was
72      * present.
73      */
74     function _remove(Set storage set, bytes32 value) private returns (bool) {
75         // We read and store the value's index to prevent multiple reads from the same storage slot
76         uint256 valueIndex = set._indexes[value];
77 
78         if (valueIndex != 0) { // Equivalent to contains(set, value)
79             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
80             // the array, and then remove the last element (sometimes called as 'swap and pop').
81             // This modifies the order of the array, as noted in {at}.
82 
83             uint256 toDeleteIndex = valueIndex - 1;
84             uint256 lastIndex = set._values.length - 1;
85 
86             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
87             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
88 
89             bytes32 lastvalue = set._values[lastIndex];
90 
91             // Move the last value to the index where the value to delete is
92             set._values[toDeleteIndex] = lastvalue;
93             // Update the index for the moved value
94             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
95 
96             // Delete the slot where the moved value was stored
97             set._values.pop();
98 
99             // Delete the index for the deleted slot
100             delete set._indexes[value];
101 
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Returns true if the value is in the set. O(1).
110      */
111     function _contains(Set storage set, bytes32 value) private view returns (bool) {
112         return set._indexes[value] != 0;
113     }
114 
115     /**
116      * @dev Returns the number of values on the set. O(1).
117      */
118     function _length(Set storage set) private view returns (uint256) {
119         return set._values.length;
120     }
121 
122    /**
123     * @dev Returns the value stored at position `index` in the set. O(1).
124     *
125     * Note that there are no guarantees on the ordering of values inside the
126     * array, and it may change when more values are added or removed.
127     *
128     * Requirements:
129     *
130     * - `index` must be strictly less than {length}.
131     */
132     function _at(Set storage set, uint256 index) private view returns (bytes32) {
133         require(set._values.length > index, "EnumerableSet: index out of bounds");
134         return set._values[index];
135     }
136 
137     // AddressSet
138 
139     struct AddressSet {
140         Set _inner;
141     }
142 
143     /**
144      * @dev Add a value to a set. O(1).
145      *
146      * Returns true if the value was added to the set, that is if it was not
147      * already present.
148      */
149     function add(AddressSet storage set, address value) internal returns (bool) {
150         return _add(set._inner, bytes32(uint256(value)));
151     }
152 
153     /**
154      * @dev Removes a value from a set. O(1).
155      *
156      * Returns true if the value was removed from the set, that is if it was
157      * present.
158      */
159     function remove(AddressSet storage set, address value) internal returns (bool) {
160         return _remove(set._inner, bytes32(uint256(value)));
161     }
162 
163     /**
164      * @dev Returns true if the value is in the set. O(1).
165      */
166     function contains(AddressSet storage set, address value) internal view returns (bool) {
167         return _contains(set._inner, bytes32(uint256(value)));
168     }
169 
170     /**
171      * @dev Returns the number of values in the set. O(1).
172      */
173     function length(AddressSet storage set) internal view returns (uint256) {
174         return _length(set._inner);
175     }
176 
177    /**
178     * @dev Returns the value stored at position `index` in the set. O(1).
179     *
180     * Note that there are no guarantees on the ordering of values inside the
181     * array, and it may change when more values are added or removed.
182     *
183     * Requirements:
184     *
185     * - `index` must be strictly less than {length}.
186     */
187     function at(AddressSet storage set, uint256 index) internal view returns (address) {
188         return address(uint256(_at(set._inner, index)));
189     }
190 
191 
192     // UintSet
193 
194     struct UintSet {
195         Set _inner;
196     }
197 
198     /**
199      * @dev Add a value to a set. O(1).
200      *
201      * Returns true if the value was added to the set, that is if it was not
202      * already present.
203      */
204     function add(UintSet storage set, uint256 value) internal returns (bool) {
205         return _add(set._inner, bytes32(value));
206     }
207 
208     /**
209      * @dev Removes a value from a set. O(1).
210      *
211      * Returns true if the value was removed from the set, that is if it was
212      * present.
213      */
214     function remove(UintSet storage set, uint256 value) internal returns (bool) {
215         return _remove(set._inner, bytes32(value));
216     }
217 
218     /**
219      * @dev Returns true if the value is in the set. O(1).
220      */
221     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
222         return _contains(set._inner, bytes32(value));
223     }
224 
225     /**
226      * @dev Returns the number of values on the set. O(1).
227      */
228     function length(UintSet storage set) internal view returns (uint256) {
229         return _length(set._inner);
230     }
231 
232    /**
233     * @dev Returns the value stored at position `index` in the set. O(1).
234     *
235     * Note that there are no guarantees on the ordering of values inside the
236     * array, and it may change when more values are added or removed.
237     *
238     * Requirements:
239     *
240     * - `index` must be strictly less than {length}.
241     */
242     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
243         return uint256(_at(set._inner, index));
244     }
245 }
246 
247 // File: @openzeppelin/contracts/GSN/Context.sol
248 
249 
250 
251 pragma solidity ^0.6.0;
252 
253 /*
254  * @dev Provides information about the current execution context, including the
255  * sender of the transaction and its data. While these are generally available
256  * via msg.sender and msg.data, they should not be accessed in such a direct
257  * manner, since when dealing with GSN meta-transactions the account sending and
258  * paying for execution may not be the actual sender (as far as an application
259  * is concerned).
260  *
261  * This contract is only required for intermediate, library-like contracts.
262  */
263 abstract contract Context {
264     function _msgSender() internal view virtual returns (address payable) {
265         return msg.sender;
266     }
267 
268     function _msgData() internal view virtual returns (bytes memory) {
269         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
270         return msg.data;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/access/Ownable.sol
275 
276 
277 
278 pragma solidity ^0.6.0;
279 
280 /**
281  * @dev Contract module which provides a basic access control mechanism, where
282  * there is an account (an owner) that can be granted exclusive access to
283  * specific functions.
284  *
285  * By default, the owner account will be the one that deploys the contract. This
286  * can later be changed with {transferOwnership}.
287  *
288  * This module is used through inheritance. It will make available the modifier
289  * `onlyOwner`, which can be applied to your functions to restrict their use to
290  * the owner.
291  */
292 contract Ownable is Context {
293     address private _owner;
294 
295     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
296 
297     /**
298      * @dev Initializes the contract setting the deployer as the initial owner.
299      */
300     constructor () internal {
301         address msgSender = _msgSender();
302         _owner = msgSender;
303         emit OwnershipTransferred(address(0), msgSender);
304     }
305 
306     /**
307      * @dev Returns the address of the current owner.
308      */
309     function owner() public view returns (address) {
310         return _owner;
311     }
312 
313     /**
314      * @dev Throws if called by any account other than the owner.
315      */
316     modifier onlyOwner() {
317         require(_owner == _msgSender(), "Ownable: caller is not the owner");
318         _;
319     }
320 
321     /**
322      * @dev Leaves the contract without owner. It will not be possible to call
323      * `onlyOwner` functions anymore. Can only be called by the current owner.
324      *
325      * NOTE: Renouncing ownership will leave the contract without an owner,
326      * thereby removing any functionality that is only available to the owner.
327      */
328     function renounceOwnership() public virtual onlyOwner {
329         emit OwnershipTransferred(_owner, address(0));
330         _owner = address(0);
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      * Can only be called by the current owner.
336      */
337     function transferOwnership(address newOwner) public virtual onlyOwner {
338         require(newOwner != address(0), "Ownable: new owner is the zero address");
339         emit OwnershipTransferred(_owner, newOwner);
340         _owner = newOwner;
341     }
342 }
343 
344 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
345 
346 
347 
348 pragma solidity ^0.6.0;
349 
350 /**
351  * @dev Interface of the ERC20 standard as defined in the EIP.
352  */
353 interface IERC20 {
354     /**
355      * @dev Returns the amount of tokens in existence.
356      */
357     function totalSupply() external view returns (uint256);
358 
359     /**
360      * @dev Returns the amount of tokens owned by `account`.
361      */
362     function balanceOf(address account) external view returns (uint256);
363 
364     /**
365      * @dev Moves `amount` tokens from the caller's account to `recipient`.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transfer(address recipient, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Returns the remaining number of tokens that `spender` will be
375      * allowed to spend on behalf of `owner` through {transferFrom}. This is
376      * zero by default.
377      *
378      * This value changes when {approve} or {transferFrom} are called.
379      */
380     function allowance(address owner, address spender) external view returns (uint256);
381 
382     /**
383      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * IMPORTANT: Beware that changing an allowance with this method brings the risk
388      * that someone may use both the old and the new allowance by unfortunate
389      * transaction ordering. One possible solution to mitigate this race
390      * condition is to first reduce the spender's allowance to 0 and set the
391      * desired value afterwards:
392      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
393      *
394      * Emits an {Approval} event.
395      */
396     function approve(address spender, uint256 amount) external returns (bool);
397 
398     /**
399      * @dev Moves `amount` tokens from `sender` to `recipient` using the
400      * allowance mechanism. `amount` is then deducted from the caller's
401      * allowance.
402      *
403      * Returns a boolean value indicating whether the operation succeeded.
404      *
405      * Emits a {Transfer} event.
406      */
407     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
408 
409     /**
410      * @dev Emitted when `value` tokens are moved from one account (`from`) to
411      * another (`to`).
412      *
413      * Note that `value` may be zero.
414      */
415     event Transfer(address indexed from, address indexed to, uint256 value);
416 
417     /**
418      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
419      * a call to {approve}. `value` is the new allowance.
420      */
421     event Approval(address indexed owner, address indexed spender, uint256 value);
422 }
423 
424 // File: @openzeppelin/contracts/math/SafeMath.sol
425 
426 
427 
428 pragma solidity ^0.6.0;
429 
430 /**
431  * @dev Wrappers over Solidity's arithmetic operations with added overflow
432  * checks.
433  *
434  * Arithmetic operations in Solidity wrap on overflow. This can easily result
435  * in bugs, because programmers usually assume that an overflow raises an
436  * error, which is the standard behavior in high level programming languages.
437  * `SafeMath` restores this intuition by reverting the transaction when an
438  * operation overflows.
439  *
440  * Using this library instead of the unchecked operations eliminates an entire
441  * class of bugs, so it's recommended to use it always.
442  */
443 library SafeMath {
444     /**
445      * @dev Returns the addition of two unsigned integers, reverting on
446      * overflow.
447      *
448      * Counterpart to Solidity's `+` operator.
449      *
450      * Requirements:
451      *
452      * - Addition cannot overflow.
453      */
454     function add(uint256 a, uint256 b) internal pure returns (uint256) {
455         uint256 c = a + b;
456         require(c >= a, "SafeMath: addition overflow");
457 
458         return c;
459     }
460 
461     /**
462      * @dev Returns the subtraction of two unsigned integers, reverting on
463      * overflow (when the result is negative).
464      *
465      * Counterpart to Solidity's `-` operator.
466      *
467      * Requirements:
468      *
469      * - Subtraction cannot overflow.
470      */
471     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
472         return sub(a, b, "SafeMath: subtraction overflow");
473     }
474 
475     /**
476      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
477      * overflow (when the result is negative).
478      *
479      * Counterpart to Solidity's `-` operator.
480      *
481      * Requirements:
482      *
483      * - Subtraction cannot overflow.
484      */
485     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
486         require(b <= a, errorMessage);
487         uint256 c = a - b;
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the multiplication of two unsigned integers, reverting on
494      * overflow.
495      *
496      * Counterpart to Solidity's `*` operator.
497      *
498      * Requirements:
499      *
500      * - Multiplication cannot overflow.
501      */
502     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
503         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
504         // benefit is lost if 'b' is also tested.
505         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
506         if (a == 0) {
507             return 0;
508         }
509 
510         uint256 c = a * b;
511         require(c / a == b, "SafeMath: multiplication overflow");
512 
513         return c;
514     }
515 
516     /**
517      * @dev Returns the integer division of two unsigned integers. Reverts on
518      * division by zero. The result is rounded towards zero.
519      *
520      * Counterpart to Solidity's `/` operator. Note: this function uses a
521      * `revert` opcode (which leaves remaining gas untouched) while Solidity
522      * uses an invalid opcode to revert (consuming all remaining gas).
523      *
524      * Requirements:
525      *
526      * - The divisor cannot be zero.
527      */
528     function div(uint256 a, uint256 b) internal pure returns (uint256) {
529         return div(a, b, "SafeMath: division by zero");
530     }
531 
532     /**
533      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
534      * division by zero. The result is rounded towards zero.
535      *
536      * Counterpart to Solidity's `/` operator. Note: this function uses a
537      * `revert` opcode (which leaves remaining gas untouched) while Solidity
538      * uses an invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
545         require(b > 0, errorMessage);
546         uint256 c = a / b;
547         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
548 
549         return c;
550     }
551 
552     /**
553      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
554      * Reverts when dividing by zero.
555      *
556      * Counterpart to Solidity's `%` operator. This function uses a `revert`
557      * opcode (which leaves remaining gas untouched) while Solidity uses an
558      * invalid opcode to revert (consuming all remaining gas).
559      *
560      * Requirements:
561      *
562      * - The divisor cannot be zero.
563      */
564     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
565         return mod(a, b, "SafeMath: modulo by zero");
566     }
567 
568     /**
569      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
570      * Reverts with custom message when dividing by zero.
571      *
572      * Counterpart to Solidity's `%` operator. This function uses a `revert`
573      * opcode (which leaves remaining gas untouched) while Solidity uses an
574      * invalid opcode to revert (consuming all remaining gas).
575      *
576      * Requirements:
577      *
578      * - The divisor cannot be zero.
579      */
580     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
581         require(b != 0, errorMessage);
582         return a % b;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/utils/Address.sol
587 
588 
589 
590 pragma solidity ^0.6.2;
591 
592 /**
593  * @dev Collection of functions related to the address type
594  */
595 library Address {
596     /**
597      * @dev Returns true if `account` is a contract.
598      *
599      * [IMPORTANT]
600      * ====
601      * It is unsafe to assume that an address for which this function returns
602      * false is an externally-owned account (EOA) and not a contract.
603      *
604      * Among others, `isContract` will return false for the following
605      * types of addresses:
606      *
607      *  - an externally-owned account
608      *  - a contract in construction
609      *  - an address where a contract will be created
610      *  - an address where a contract lived, but was destroyed
611      * ====
612      */
613     function isContract(address account) internal view returns (bool) {
614         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
615         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
616         // for accounts without code, i.e. `keccak256('')`
617         bytes32 codehash;
618         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
619         // solhint-disable-next-line no-inline-assembly
620         assembly { codehash := extcodehash(account) }
621         return (codehash != accountHash && codehash != 0x0);
622     }
623 
624     /**
625      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
626      * `recipient`, forwarding all available gas and reverting on errors.
627      *
628      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
629      * of certain opcodes, possibly making contracts go over the 2300 gas limit
630      * imposed by `transfer`, making them unable to receive funds via
631      * `transfer`. {sendValue} removes this limitation.
632      *
633      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
634      *
635      * IMPORTANT: because control is transferred to `recipient`, care must be
636      * taken to not create reentrancy vulnerabilities. Consider using
637      * {ReentrancyGuard} or the
638      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
639      */
640     function sendValue(address payable recipient, uint256 amount) internal {
641         require(address(this).balance >= amount, "Address: insufficient balance");
642 
643         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
644         (bool success, ) = recipient.call{ value: amount }("");
645         require(success, "Address: unable to send value, recipient may have reverted");
646     }
647 
648     /**
649      * @dev Performs a Solidity function call using a low level `call`. A
650      * plain`call` is an unsafe replacement for a function call: use this
651      * function instead.
652      *
653      * If `target` reverts with a revert reason, it is bubbled up by this
654      * function (like regular Solidity function calls).
655      *
656      * Returns the raw returned data. To convert to the expected return value,
657      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
658      *
659      * Requirements:
660      *
661      * - `target` must be a contract.
662      * - calling `target` with `data` must not revert.
663      *
664      * _Available since v3.1._
665      */
666     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
667       return functionCall(target, data, "Address: low-level call failed");
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
672      * `errorMessage` as a fallback revert reason when `target` reverts.
673      *
674      * _Available since v3.1._
675      */
676     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
677         return _functionCallWithValue(target, data, 0, errorMessage);
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
682      * but also transferring `value` wei to `target`.
683      *
684      * Requirements:
685      *
686      * - the calling contract must have an ETH balance of at least `value`.
687      * - the called Solidity function must be `payable`.
688      *
689      * _Available since v3.1._
690      */
691     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
692         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
697      * with `errorMessage` as a fallback revert reason when `target` reverts.
698      *
699      * _Available since v3.1._
700      */
701     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
702         require(address(this).balance >= value, "Address: insufficient balance for call");
703         return _functionCallWithValue(target, data, value, errorMessage);
704     }
705 
706     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
707         require(isContract(target), "Address: call to non-contract");
708 
709         // solhint-disable-next-line avoid-low-level-calls
710         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
711         if (success) {
712             return returndata;
713         } else {
714             // Look for revert reason and bubble it up if present
715             if (returndata.length > 0) {
716                 // The easiest way to bubble the revert reason is using memory via assembly
717 
718                 // solhint-disable-next-line no-inline-assembly
719                 assembly {
720                     let returndata_size := mload(returndata)
721                     revert(add(32, returndata), returndata_size)
722                 }
723             } else {
724                 revert(errorMessage);
725             }
726         }
727     }
728 }
729 
730 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
731 
732 
733 
734 pragma solidity ^0.6.0;
735 
736 
737 
738 
739 
740 /**
741  * @dev Implementation of the {IERC20} interface.
742  *
743  * This implementation is agnostic to the way tokens are created. This means
744  * that a supply mechanism has to be added in a derived contract using {_mint}.
745  * For a generic mechanism see {ERC20PresetMinterPauser}.
746  *
747  * TIP: For a detailed writeup see our guide
748  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
749  * to implement supply mechanisms].
750  *
751  * We have followed general OpenZeppelin guidelines: functions revert instead
752  * of returning `false` on failure. This behavior is nonetheless conventional
753  * and does not conflict with the expectations of ERC20 applications.
754  *
755  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
756  * This allows applications to reconstruct the allowance for all accounts just
757  * by listening to said events. Other implementations of the EIP may not emit
758  * these events, as it isn't required by the specification.
759  *
760  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
761  * functions have been added to mitigate the well-known issues around setting
762  * allowances. See {IERC20-approve}.
763  */
764 contract ERC20 is Context, IERC20 {
765     using SafeMath for uint256;
766     using Address for address;
767 
768     mapping (address => uint256) private _balances;
769 
770     mapping (address => mapping (address => uint256)) private _allowances;
771 
772     uint256 private _totalSupply;
773 
774     string private _name;
775     string private _symbol;
776     uint8 private _decimals;
777 
778     /**
779      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
780      * a default value of 18.
781      *
782      * To select a different value for {decimals}, use {_setupDecimals}.
783      *
784      * All three of these values are immutable: they can only be set once during
785      * construction.
786      */
787     constructor (string memory name, string memory symbol) public {
788         _name = name;
789         _symbol = symbol;
790         _decimals = 18;
791     }
792 
793     /**
794      * @dev Returns the name of the token.
795      */
796     function name() public view returns (string memory) {
797         return _name;
798     }
799 
800     /**
801      * @dev Returns the symbol of the token, usually a shorter version of the
802      * name.
803      */
804     function symbol() public view returns (string memory) {
805         return _symbol;
806     }
807 
808     /**
809      * @dev Returns the number of decimals used to get its user representation.
810      * For example, if `decimals` equals `2`, a balance of `505` tokens should
811      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
812      *
813      * Tokens usually opt for a value of 18, imitating the relationship between
814      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
815      * called.
816      *
817      * NOTE: This information is only used for _display_ purposes: it in
818      * no way affects any of the arithmetic of the contract, including
819      * {IERC20-balanceOf} and {IERC20-transfer}.
820      */
821     function decimals() public view returns (uint8) {
822         return _decimals;
823     }
824 
825     /**
826      * @dev See {IERC20-totalSupply}.
827      */
828     function totalSupply() public view override returns (uint256) {
829         return _totalSupply;
830     }
831 
832     /**
833      * @dev See {IERC20-balanceOf}.
834      */
835     function balanceOf(address account) public view override returns (uint256) {
836         return _balances[account];
837     }
838 
839     /**
840      * @dev See {IERC20-transfer}.
841      *
842      * Requirements:
843      *
844      * - `recipient` cannot be the zero address.
845      * - the caller must have a balance of at least `amount`.
846      */
847     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
848         _transfer(_msgSender(), recipient, amount);
849         return true;
850     }
851 
852     /**
853      * @dev See {IERC20-allowance}.
854      */
855     function allowance(address owner, address spender) public view virtual override returns (uint256) {
856         return _allowances[owner][spender];
857     }
858 
859     /**
860      * @dev See {IERC20-approve}.
861      *
862      * Requirements:
863      *
864      * - `spender` cannot be the zero address.
865      */
866     function approve(address spender, uint256 amount) public virtual override returns (bool) {
867         _approve(_msgSender(), spender, amount);
868         return true;
869     }
870 
871     /**
872      * @dev See {IERC20-transferFrom}.
873      *
874      * Emits an {Approval} event indicating the updated allowance. This is not
875      * required by the EIP. See the note at the beginning of {ERC20};
876      *
877      * Requirements:
878      * - `sender` and `recipient` cannot be the zero address.
879      * - `sender` must have a balance of at least `amount`.
880      * - the caller must have allowance for ``sender``'s tokens of at least
881      * `amount`.
882      */
883     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
884         _transfer(sender, recipient, amount);
885         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
886         return true;
887     }
888 
889     /**
890      * @dev Atomically increases the allowance granted to `spender` by the caller.
891      *
892      * This is an alternative to {approve} that can be used as a mitigation for
893      * problems described in {IERC20-approve}.
894      *
895      * Emits an {Approval} event indicating the updated allowance.
896      *
897      * Requirements:
898      *
899      * - `spender` cannot be the zero address.
900      */
901     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
902         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
903         return true;
904     }
905 
906     /**
907      * @dev Atomically decreases the allowance granted to `spender` by the caller.
908      *
909      * This is an alternative to {approve} that can be used as a mitigation for
910      * problems described in {IERC20-approve}.
911      *
912      * Emits an {Approval} event indicating the updated allowance.
913      *
914      * Requirements:
915      *
916      * - `spender` cannot be the zero address.
917      * - `spender` must have allowance for the caller of at least
918      * `subtractedValue`.
919      */
920     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
921         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
922         return true;
923     }
924 
925     /**
926      * @dev Moves tokens `amount` from `sender` to `recipient`.
927      *
928      * This is internal function is equivalent to {transfer}, and can be used to
929      * e.g. implement automatic token fees, slashing mechanisms, etc.
930      *
931      * Emits a {Transfer} event.
932      *
933      * Requirements:
934      *
935      * - `sender` cannot be the zero address.
936      * - `recipient` cannot be the zero address.
937      * - `sender` must have a balance of at least `amount`.
938      */
939     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
940         require(sender != address(0), "ERC20: transfer from the zero address");
941         require(recipient != address(0), "ERC20: transfer to the zero address");
942 
943         _beforeTokenTransfer(sender, recipient, amount);
944 
945         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
946         _balances[recipient] = _balances[recipient].add(amount);
947         emit Transfer(sender, recipient, amount);
948     }
949 
950     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
951      * the total supply.
952      *
953      * Emits a {Transfer} event with `from` set to the zero address.
954      *
955      * Requirements
956      *
957      * - `to` cannot be the zero address.
958      */
959     function _mint(address account, uint256 amount) internal virtual {
960         require(account != address(0), "ERC20: mint to the zero address");
961 
962         _beforeTokenTransfer(address(0), account, amount);
963 
964         _totalSupply = _totalSupply.add(amount);
965         _balances[account] = _balances[account].add(amount);
966         emit Transfer(address(0), account, amount);
967     }
968 
969     /**
970      * @dev Destroys `amount` tokens from `account`, reducing the
971      * total supply.
972      *
973      * Emits a {Transfer} event with `to` set to the zero address.
974      *
975      * Requirements
976      *
977      * - `account` cannot be the zero address.
978      * - `account` must have at least `amount` tokens.
979      */
980     function _burn(address account, uint256 amount) internal virtual {
981         require(account != address(0), "ERC20: burn from the zero address");
982 
983         _beforeTokenTransfer(account, address(0), amount);
984 
985         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
986         _totalSupply = _totalSupply.sub(amount);
987         emit Transfer(account, address(0), amount);
988     }
989 
990     /**
991      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
992      *
993      * This is internal function is equivalent to `approve`, and can be used to
994      * e.g. set automatic allowances for certain subsystems, etc.
995      *
996      * Emits an {Approval} event.
997      *
998      * Requirements:
999      *
1000      * - `owner` cannot be the zero address.
1001      * - `spender` cannot be the zero address.
1002      */
1003     function _approve(address owner, address spender, uint256 amount) internal virtual {
1004         require(owner != address(0), "ERC20: approve from the zero address");
1005         require(spender != address(0), "ERC20: approve to the zero address");
1006 
1007         _allowances[owner][spender] = amount;
1008         emit Approval(owner, spender, amount);
1009     }
1010 
1011     /**
1012      * @dev Sets {decimals} to a value other than the default one of 18.
1013      *
1014      * WARNING: This function should only be called from the constructor. Most
1015      * applications that interact with token contracts will not expect
1016      * {decimals} to ever change, and may work incorrectly if it does.
1017      */
1018     function _setupDecimals(uint8 decimals_) internal {
1019         _decimals = decimals_;
1020     }
1021 
1022     /**
1023      * @dev Hook that is called before any transfer of tokens. This includes
1024      * minting and burning.
1025      *
1026      * Calling conditions:
1027      *
1028      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1029      * will be to transferred to `to`.
1030      * - when `from` is zero, `amount` tokens will be minted for `to`.
1031      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1032      * - `from` and `to` are never both zero.
1033      *
1034      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1035      */
1036     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1037 }
1038 
1039 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1040 
1041 
1042 
1043 pragma solidity ^0.6.0;
1044 
1045 
1046 
1047 /**
1048  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1049  * tokens and those that they have an allowance for, in a way that can be
1050  * recognized off-chain (via event analysis).
1051  */
1052 abstract contract ERC20Burnable is Context, ERC20 {
1053     /**
1054      * @dev Destroys `amount` tokens from the caller.
1055      *
1056      * See {ERC20-_burn}.
1057      */
1058     function burn(uint256 amount) public virtual {
1059         _burn(_msgSender(), amount);
1060     }
1061 
1062     /**
1063      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1064      * allowance.
1065      *
1066      * See {ERC20-_burn} and {ERC20-allowance}.
1067      *
1068      * Requirements:
1069      *
1070      * - the caller must have allowance for ``accounts``'s tokens of at least
1071      * `amount`.
1072      */
1073     function burnFrom(address account, uint256 amount) public virtual {
1074         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1075 
1076         _approve(account, _msgSender(), decreasedAllowance);
1077         _burn(account, amount);
1078     }
1079 }
1080 
1081 // File: contracts/governance.sol
1082 
1083 pragma solidity ^0.6.0;
1084 pragma experimental ABIEncoderV2;
1085 
1086 
1087 
1088 abstract contract DeligateERC20 is ERC20Burnable {
1089     /// @notice A record of each accounts delegate
1090     mapping (address => address) internal _delegates;
1091 
1092     /// @notice A checkpoint for marking number of votes from a given block
1093     struct Checkpoint {
1094         uint32 fromBlock;
1095         uint256 votes;
1096     }
1097 
1098     /// @notice A record of votes checkpoints for each account, by index
1099     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1100 
1101     /// @notice The number of checkpoints for each account
1102     mapping (address => uint32) public numCheckpoints;
1103 
1104     /// @notice The EIP-712 typehash for the contract's domain
1105     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1106 
1107     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1108     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1109 
1110     /// @notice A record of states for signing / validating signatures
1111     mapping (address => uint) public nonces;
1112 
1113 
1114     // support delegates mint
1115     function _mint(address account, uint256 amount) internal override virtual {
1116         super._mint(account, amount);
1117 
1118         // add delegates to the minter
1119         _moveDelegates(address(0), _delegates[account], amount);
1120     }
1121 
1122 
1123     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
1124         super._transfer(sender, recipient, amount);
1125         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1126     }
1127 
1128     
1129     // support delegates burn
1130     function burn(uint256 amount) public override virtual {
1131         super.burn(amount);
1132 
1133         // del delegates to backhole
1134         _moveDelegates(_delegates[_msgSender()], address(0), amount);
1135     }
1136 
1137     function burnFrom(address account, uint256 amount) public override virtual {
1138         super.burnFrom(account, amount);
1139 
1140         // del delegates to the backhole
1141         _moveDelegates(_delegates[account], address(0), amount);
1142     }
1143     
1144     /**
1145     * @notice Delegate votes from `msg.sender` to `delegatee`
1146     * @param delegatee The address to delegate votes to
1147     */
1148     function delegate(address delegatee) external {
1149         return _delegate(msg.sender, delegatee);
1150     }
1151 
1152     /**
1153      * @notice Delegates votes from signatory to `delegatee`
1154      * @param delegatee The address to delegate votes to
1155      * @param nonce The contract state required to match the signature
1156      * @param expiry The time at which to expire the signature
1157      * @param v The recovery byte of the signature
1158      * @param r Half of the ECDSA signature pair
1159      * @param s Half of the ECDSA signature pair
1160      */
1161     function delegateBySig(
1162         address delegatee,
1163         uint nonce,
1164         uint expiry,
1165         uint8 v,
1166         bytes32 r,
1167         bytes32 s
1168     )
1169         external
1170     {
1171         bytes32 domainSeparator = keccak256(
1172             abi.encode(
1173                 DOMAIN_TYPEHASH,
1174                 keccak256(bytes(name())),
1175                 getChainId(),
1176                 address(this)
1177             )
1178         );
1179 
1180         bytes32 structHash = keccak256(
1181             abi.encode(
1182                 DELEGATION_TYPEHASH,
1183                 delegatee,
1184                 nonce,
1185                 expiry
1186             )
1187         );
1188 
1189         bytes32 digest = keccak256(
1190             abi.encodePacked(
1191                 "\x19\x01",
1192                 domainSeparator,
1193                 structHash
1194             )
1195         );
1196 
1197         address signatory = ecrecover(digest, v, r, s);
1198         require(signatory != address(0), "Governance::delegateBySig: invalid signature");
1199         require(nonce == nonces[signatory]++, "Governance::delegateBySig: invalid nonce");
1200         require(now <= expiry, "Governance::delegateBySig: signature expired");
1201         return _delegate(signatory, delegatee);
1202     }
1203 
1204     /**
1205      * @notice Gets the current votes balance for `account`
1206      * @param account The address to get votes balance
1207      * @return The number of current votes for `account`
1208      */
1209     function getCurrentVotes(address account)
1210         external
1211         view
1212         returns (uint256)
1213     {
1214         uint32 nCheckpoints = numCheckpoints[account];
1215         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1216     }
1217 
1218     /**
1219      * @notice Determine the prior number of votes for an account as of a block number
1220      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1221      * @param account The address of the account to check
1222      * @param blockNumber The block number to get the vote balance at
1223      * @return The number of votes the account had as of the given block
1224      */
1225     function getPriorVotes(address account, uint blockNumber)
1226         external
1227         view
1228         returns (uint256)
1229     {
1230         require(blockNumber < block.number, "Governance::getPriorVotes: not yet determined");
1231 
1232         uint32 nCheckpoints = numCheckpoints[account];
1233         if (nCheckpoints == 0) {
1234             return 0;
1235         }
1236 
1237         // First check most recent balance
1238         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1239             return checkpoints[account][nCheckpoints - 1].votes;
1240         }
1241 
1242         // Next check implicit zero balance
1243         if (checkpoints[account][0].fromBlock > blockNumber) {
1244             return 0;
1245         }
1246 
1247         uint32 lower = 0;
1248         uint32 upper = nCheckpoints - 1;
1249         while (upper > lower) {
1250             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1251             Checkpoint memory cp = checkpoints[account][center];
1252             if (cp.fromBlock == blockNumber) {
1253                 return cp.votes;
1254             } else if (cp.fromBlock < blockNumber) {
1255                 lower = center;
1256             } else {
1257                 upper = center - 1;
1258             }
1259         }
1260         return checkpoints[account][lower].votes;
1261     }
1262 
1263     function _delegate(address delegator, address delegatee)
1264         internal
1265     {
1266         address currentDelegate = _delegates[delegator];
1267         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying balances (not scaled);
1268         _delegates[delegator] = delegatee;
1269 
1270         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1271 
1272         emit DelegateChanged(delegator, currentDelegate, delegatee);
1273     }
1274 
1275     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1276         if (srcRep != dstRep && amount > 0) {
1277             if (srcRep != address(0)) {
1278                 // decrease old representative
1279                 uint32 srcRepNum = numCheckpoints[srcRep];
1280                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1281                 uint256 srcRepNew = srcRepOld.sub(amount);
1282                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1283             }
1284 
1285             if (dstRep != address(0)) {
1286                 // increase new representative
1287                 uint32 dstRepNum = numCheckpoints[dstRep];
1288                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1289                 uint256 dstRepNew = dstRepOld.add(amount);
1290                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1291             }
1292         }
1293     }
1294 
1295     function _writeCheckpoint(
1296         address delegatee,
1297         uint32 nCheckpoints,
1298         uint256 oldVotes,
1299         uint256 newVotes
1300     )
1301         internal
1302     {
1303         uint32 blockNumber = safe32(block.number, "Governance::_writeCheckpoint: block number exceeds 32 bits");
1304 
1305         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1306             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1307         } else {
1308             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1309             numCheckpoints[delegatee] = nCheckpoints + 1;
1310         }
1311 
1312         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1313     }
1314 
1315     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1316         require(n < 2**32, errorMessage);
1317         return uint32(n);
1318     }
1319 
1320     function getChainId() internal pure returns (uint) {
1321         uint256 chainId;
1322         assembly { chainId := chainid() }
1323 
1324         return chainId;
1325     }
1326 
1327     
1328 
1329     /// @notice An event thats emitted when an account changes its delegate
1330     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1331 
1332     /// @notice An event thats emitted when a delegate account's vote balance changes
1333     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1334 
1335 }
1336 
1337 // File: contracts/nsure.sol
1338 
1339 // SPDX-License-Identifier: nsure.network
1340 
1341 /**
1342  * @author  Nsure.Team
1343  *
1344  * @dev     Contract for Nsure token with burn support
1345  */
1346 
1347 pragma solidity ^0.6.0;
1348 
1349 
1350 
1351 
1352 // Nsure erc20 Token Contract.
1353 contract Nsure is DeligateERC20, Ownable {
1354     uint256 private constant preMineSupply  = 45 * 1e6 * 1e18;      // pre-mine
1355     uint256 private constant maxSupply      = 100 * 1e6 * 1e18;     // the total supply
1356     address private constant nsureAdmin     = 0x5Ba189D1A3E74cf3d1D38ad81F3d75cbFdbdb5bf;
1357 
1358     // for minters
1359     using EnumerableSet for EnumerableSet.AddressSet;
1360     EnumerableSet.AddressSet private _minters;
1361 
1362 
1363     constructor() public ERC20("Nsure Network Token", "Nsure") {
1364         _mint(nsureAdmin, preMineSupply);
1365     }
1366 
1367 
1368     // mint with max supply
1369     function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
1370         if(_amount.add(totalSupply()) > maxSupply) {
1371             return false;
1372         }
1373 
1374         _mint(_to, _amount);
1375         return true;
1376     }
1377 
1378 
1379     function addMinter(address _addMinter) public onlyOwner returns (bool) {
1380         require(_addMinter != address(0), "Nsure: _addMinter is the zero address");
1381         
1382         return EnumerableSet.add(_minters, _addMinter);
1383     }
1384 
1385     function delMinter(address _delMinter) public onlyOwner returns (bool) {
1386         require(_delMinter != address(0), "Nsure: _delMinter is the zero address");
1387         
1388         return EnumerableSet.remove(_minters, _delMinter);
1389     }
1390 
1391     function getMinterLength() public view returns (uint256) {
1392         return EnumerableSet.length(_minters);
1393     }
1394 
1395     function isMinter(address account) public view returns (bool) {
1396         return EnumerableSet.contains(_minters, account);
1397     }
1398 
1399     // modifier for mint function
1400     modifier onlyMinter() {
1401         require(isMinter(msg.sender), "Nsure: caller is not the minter");
1402         _;
1403     }
1404 }