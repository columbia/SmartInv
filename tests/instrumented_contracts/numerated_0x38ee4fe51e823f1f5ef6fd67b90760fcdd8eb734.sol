1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.6.12;
4 
5 
6 // 
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
28 // 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 }
92 
93 // 
94 /**
95  * @dev Interface of the ERC20 standard as defined in the EIP.
96  */
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107 
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125 
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 // 
169 /**
170  * @dev Wrappers over Solidity's arithmetic operations with added overflow
171  * checks.
172  *
173  * Arithmetic operations in Solidity wrap on overflow. This can easily result
174  * in bugs, because programmers usually assume that an overflow raises an
175  * error, which is the standard behavior in high level programming languages.
176  * `SafeMath` restores this intuition by reverting the transaction when an
177  * operation overflows.
178  *
179  * Using this library instead of the unchecked operations eliminates an entire
180  * class of bugs, so it's recommended to use it always.
181  */
182 library SafeMath {
183     /**
184      * @dev Returns the addition of two unsigned integers, with an overflow flag.
185      *
186      * _Available since v3.4._
187      */
188     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
189         uint256 c = a + b;
190         if (c < a) return (false, 0);
191         return (true, c);
192     }
193 
194     /**
195      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
196      *
197      * _Available since v3.4._
198      */
199     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
200         if (b > a) return (false, 0);
201         return (true, a - b);
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
211         // benefit is lost if 'b' is also tested.
212         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
213         if (a == 0) return (true, 0);
214         uint256 c = a * b;
215         if (c / a != b) return (false, 0);
216         return (true, c);
217     }
218 
219     /**
220      * @dev Returns the division of two unsigned integers, with a division by zero flag.
221      *
222      * _Available since v3.4._
223      */
224     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         if (b == 0) return (false, 0);
226         return (true, a / b);
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
231      *
232      * _Available since v3.4._
233      */
234     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
235         if (b == 0) return (false, 0);
236         return (true, a % b);
237     }
238 
239     /**
240      * @dev Returns the addition of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `+` operator.
244      *
245      * Requirements:
246      *
247      * - Addition cannot overflow.
248      */
249     function add(uint256 a, uint256 b) internal pure returns (uint256) {
250         uint256 c = a + b;
251         require(c >= a, "SafeMath: addition overflow");
252         return c;
253     }
254 
255     /**
256      * @dev Returns the subtraction of two unsigned integers, reverting on
257      * overflow (when the result is negative).
258      *
259      * Counterpart to Solidity's `-` operator.
260      *
261      * Requirements:
262      *
263      * - Subtraction cannot overflow.
264      */
265     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b <= a, "SafeMath: subtraction overflow");
267         return a - b;
268     }
269 
270     /**
271      * @dev Returns the multiplication of two unsigned integers, reverting on
272      * overflow.
273      *
274      * Counterpart to Solidity's `*` operator.
275      *
276      * Requirements:
277      *
278      * - Multiplication cannot overflow.
279      */
280     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
281         if (a == 0) return 0;
282         uint256 c = a * b;
283         require(c / a == b, "SafeMath: multiplication overflow");
284         return c;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b) internal pure returns (uint256) {
300         require(b > 0, "SafeMath: division by zero");
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting when dividing by zero.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b > 0, "SafeMath: modulo by zero");
318         return a % b;
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
323      * overflow (when the result is negative).
324      *
325      * CAUTION: This function is deprecated because it requires allocating memory for the error
326      * message unnecessarily. For custom revert reasons use {trySub}.
327      *
328      * Counterpart to Solidity's `-` operator.
329      *
330      * Requirements:
331      *
332      * - Subtraction cannot overflow.
333      */
334     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b <= a, errorMessage);
336         return a - b;
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
341      * division by zero. The result is rounded towards zero.
342      *
343      * CAUTION: This function is deprecated because it requires allocating memory for the error
344      * message unnecessarily. For custom revert reasons use {tryDiv}.
345      *
346      * Counterpart to Solidity's `/` operator. Note: this function uses a
347      * `revert` opcode (which leaves remaining gas untouched) while Solidity
348      * uses an invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      *
352      * - The divisor cannot be zero.
353      */
354     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
355         require(b > 0, errorMessage);
356         return a / b;
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
361      * reverting with custom message when dividing by zero.
362      *
363      * CAUTION: This function is deprecated because it requires allocating memory for the error
364      * message unnecessarily. For custom revert reasons use {tryMod}.
365      *
366      * Counterpart to Solidity's `%` operator. This function uses a `revert`
367      * opcode (which leaves remaining gas untouched) while Solidity uses an
368      * invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
375         require(b > 0, errorMessage);
376         return a % b;
377     }
378 }
379 
380 // 
381 interface IUniswapV2Factory {
382     function createPair(address tokenA, address tokenB) external returns (address pair);
383 }
384 
385 interface IUniswapV2Router02 {
386     function swapExactTokensForETHSupportingFeeOnTransferTokens(
387         uint amountIn,
388         uint amountOutMin,
389         address[] calldata path,
390         address to,
391         uint deadline
392     ) external;
393     function factory() external pure returns (address);
394     function WETH() external pure returns (address);
395     function addLiquidityETH(
396         address token,
397         uint amountTokenDesired,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline
402     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
403     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
404 }
405 
406 // 
407 library Address {
408     /**
409     * @dev Returns true if `account` is a contract.
410     *
411     * [IMPORTANT]
412     * ====
413     * It is unsafe to assume that an address for which this function returns
414     * false is an externally-owned account (EOA) and not a contract.
415     *
416     * Among others, `isContract` will return false for the following
417     * types of addresses:
418     *
419     *  - an externally-owned account
420     *  - a contract in construction
421     *  - an address where a contract will be created
422     *  - an address where a contract lived, but was destroyed
423     * ====
424     */
425     function isContract(address account) internal view returns (bool) {
426         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
427         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
428         // for accounts without code, i.e. `keccak256('')`
429         bytes32 codehash;
430         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
431         // solhint-disable-next-line no-inline-assembly
432         assembly { codehash := extcodehash(account) }
433         return (codehash != accountHash && codehash != 0x0);
434     }
435 
436     /**
437     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
438     * `recipient`, forwarding all available gas and reverting on errors.
439     *
440     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
441     * of certain opcodes, possibly making contracts go over the 2300 gas limit
442     * imposed by `transfer`, making them unable to receive funds via
443     * `transfer`. {sendValue} removes this limitation.
444     *
445     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
446     *
447     * IMPORTANT: because control is transferred to `recipient`, care must be
448     * taken to not create reentrancy vulnerabilities. Consider using
449     * {ReentrancyGuard} or the
450     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
451     */
452     function sendValue(address payable recipient, uint256 amount) internal {
453         require(address(this).balance >= amount, "Address: insufficient balance");
454 
455         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
456         (bool success, ) = recipient.call{ value: amount }("");
457         require(success, "Address: unable to send value, recipient may have reverted");
458     }
459 
460     /**
461     * @dev Performs a Solidity function call using a low level `call`. A
462     * plain`call` is an unsafe replacement for a function call: use this
463     * function instead.
464     *
465     * If `target` reverts with a revert reason, it is bubbled up by this
466     * function (like regular Solidity function calls).
467     *
468     * Returns the raw returned data. To convert to the expected return value,
469     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
470     *
471     * Requirements:
472     *
473     * - `target` must be a contract.
474     * - calling `target` with `data` must not revert.
475     *
476     * _Available since v3.1._
477     */
478     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionCall(target, data, "Address: low-level call failed");
480     }
481 
482     /**
483     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484     * `errorMessage` as a fallback revert reason when `target` reverts.
485     *
486     * _Available since v3.1._
487     */
488     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
489         return _functionCallWithValue(target, data, 0, errorMessage);
490     }
491 
492     /**
493     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494     * but also transferring `value` wei to `target`.
495     *
496     * Requirements:
497     *
498     * - the calling contract must have an ETH balance of at least `value`.
499     * - the called Solidity function must be `payable`.
500     *
501     * _Available since v3.1._
502     */
503     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
505     }
506 
507     /**
508     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
509     * with `errorMessage` as a fallback revert reason when `target` reverts.
510     *
511     * _Available since v3.1._
512     */
513     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
514         require(address(this).balance >= value, "Address: insufficient balance for call");
515         return _functionCallWithValue(target, data, value, errorMessage);
516     }
517 
518     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
519         require(isContract(target), "Address: call to non-contract");
520 
521         // solhint-disable-next-line avoid-low-level-calls
522         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
523         if (success) {
524             return returndata;
525         } else {
526             // Look for revert reason and bubble it up if present
527             if (returndata.length > 0) {
528                 // The easiest way to bubble the revert reason is using memory via assembly
529 
530                 // solhint-disable-next-line no-inline-assembly
531                 assembly {
532                     let returndata_size := mload(returndata)
533                     revert(add(32, returndata), returndata_size)
534                 }
535             } else {
536                 revert(errorMessage);
537             }
538         }
539     }
540 }
541 
542 // 
543 /**
544  * @dev Library for managing
545  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
546  * types.
547  *
548  * Sets have the following properties:
549  *
550  * - Elements are added, removed, and checked for existence in constant time
551  * (O(1)).
552  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
553  *
554  * ```
555  * contract Example {
556  *     // Add the library methods
557  *     using EnumerableSet for EnumerableSet.AddressSet;
558  *
559  *     // Declare a set state variable
560  *     EnumerableSet.AddressSet private mySet;
561  * }
562  * ```
563  *
564  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
565  * and `uint256` (`UintSet`) are supported.
566  */
567 library EnumerableSet {
568     // To implement this library for multiple types with as little code
569     // repetition as possible, we write it in terms of a generic Set type with
570     // bytes32 values.
571     // The Set implementation uses private functions, and user-facing
572     // implementations (such as AddressSet) are just wrappers around the
573     // underlying Set.
574     // This means that we can only create new EnumerableSets for types that fit
575     // in bytes32.
576 
577     struct Set {
578         // Storage of set values
579         bytes32[] _values;
580         // Position of the value in the `values` array, plus 1 because index 0
581         // means a value is not in the set.
582         mapping(bytes32 => uint256) _indexes;
583     }
584 
585     /**
586      * @dev Add a value to a set. O(1).
587      *
588      * Returns true if the value was added to the set, that is if it was not
589      * already present.
590      */
591     function _add(Set storage set, bytes32 value) private returns (bool) {
592         if (!_contains(set, value)) {
593             set._values.push(value);
594             // The value is stored at length-1, but we add 1 to all indexes
595             // and use 0 as a sentinel value
596             set._indexes[value] = set._values.length;
597             return true;
598         } else {
599             return false;
600         }
601     }
602 
603     /**
604      * @dev Removes a value from a set. O(1).
605      *
606      * Returns true if the value was removed from the set, that is if it was
607      * present.
608      */
609     function _remove(Set storage set, bytes32 value) private returns (bool) {
610         // We read and store the value's index to prevent multiple reads from the same storage slot
611         uint256 valueIndex = set._indexes[value];
612 
613         if (valueIndex != 0) {
614             // Equivalent to contains(set, value)
615             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
616             // the array, and then remove the last element (sometimes called as 'swap and pop').
617             // This modifies the order of the array, as noted in {at}.
618 
619             uint256 toDeleteIndex = valueIndex - 1;
620             uint256 lastIndex = set._values.length - 1;
621 
622             if (lastIndex != toDeleteIndex) {
623                 bytes32 lastvalue = set._values[lastIndex];
624 
625                 // Move the last value to the index where the value to delete is
626                 set._values[toDeleteIndex] = lastvalue;
627                 // Update the index for the moved value
628                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
629             }
630 
631             // Delete the slot where the moved value was stored
632             set._values.pop();
633 
634             // Delete the index for the deleted slot
635             delete set._indexes[value];
636 
637             return true;
638         } else {
639             return false;
640         }
641     }
642 
643     /**
644      * @dev Returns true if the value is in the set. O(1).
645      */
646     function _contains(Set storage set, bytes32 value) private view returns (bool) {
647         return set._indexes[value] != 0;
648     }
649 
650     /**
651      * @dev Returns the number of values on the set. O(1).
652      */
653     function _length(Set storage set) private view returns (uint256) {
654         return set._values.length;
655     }
656 
657     /**
658      * @dev Returns the value stored at position `index` in the set. O(1).
659      *
660      * Note that there are no guarantees on the ordering of values inside the
661      * array, and it may change when more values are added or removed.
662      *
663      * Requirements:
664      *
665      * - `index` must be strictly less than {length}.
666      */
667     function _at(Set storage set, uint256 index) private view returns (bytes32) {
668         return set._values[index];
669     }
670 
671     /**
672      * @dev Return the entire set in an array
673      *
674      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
675      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
676      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
677      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
678      */
679     function _values(Set storage set) private view returns (bytes32[] memory) {
680         return set._values;
681     }
682 
683     // Bytes32Set
684 
685     struct Bytes32Set {
686         Set _inner;
687     }
688 
689     /**
690      * @dev Add a value to a set. O(1).
691      *
692      * Returns true if the value was added to the set, that is if it was not
693      * already present.
694      */
695     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
696         return _add(set._inner, value);
697     }
698 
699     /**
700      * @dev Removes a value from a set. O(1).
701      *
702      * Returns true if the value was removed from the set, that is if it was
703      * present.
704      */
705     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
706         return _remove(set._inner, value);
707     }
708 
709     /**
710      * @dev Returns true if the value is in the set. O(1).
711      */
712     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
713         return _contains(set._inner, value);
714     }
715 
716     /**
717      * @dev Returns the number of values in the set. O(1).
718      */
719     function length(Bytes32Set storage set) internal view returns (uint256) {
720         return _length(set._inner);
721     }
722 
723     /**
724      * @dev Returns the value stored at position `index` in the set. O(1).
725      *
726      * Note that there are no guarantees on the ordering of values inside the
727      * array, and it may change when more values are added or removed.
728      *
729      * Requirements:
730      *
731      * - `index` must be strictly less than {length}.
732      */
733     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
734         return _at(set._inner, index);
735     }
736 
737     /**
738      * @dev Return the entire set in an array
739      *
740      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
741      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
742      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
743      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
744      */
745     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
746         return _values(set._inner);
747     }
748 
749     // AddressSet
750 
751     struct AddressSet {
752         Set _inner;
753     }
754 
755     /**
756      * @dev Add a value to a set. O(1).
757      *
758      * Returns true if the value was added to the set, that is if it was not
759      * already present.
760      */
761     function add(AddressSet storage set, address value) internal returns (bool) {
762         return _add(set._inner, bytes32(uint256(uint160(value))));
763     }
764 
765     /**
766      * @dev Removes a value from a set. O(1).
767      *
768      * Returns true if the value was removed from the set, that is if it was
769      * present.
770      */
771     function remove(AddressSet storage set, address value) internal returns (bool) {
772         return _remove(set._inner, bytes32(uint256(uint160(value))));
773     }
774 
775     /**
776      * @dev Returns true if the value is in the set. O(1).
777      */
778     function contains(AddressSet storage set, address value) internal view returns (bool) {
779         return _contains(set._inner, bytes32(uint256(uint160(value))));
780     }
781 
782     /**
783      * @dev Returns the number of values in the set. O(1).
784      */
785     function length(AddressSet storage set) internal view returns (uint256) {
786         return _length(set._inner);
787     }
788 
789     /**
790      * @dev Returns the value stored at position `index` in the set. O(1).
791      *
792      * Note that there are no guarantees on the ordering of values inside the
793      * array, and it may change when more values are added or removed.
794      *
795      * Requirements:
796      *
797      * - `index` must be strictly less than {length}.
798      */
799     function at(AddressSet storage set, uint256 index) internal view returns (address) {
800         return address(uint160(uint256(_at(set._inner, index))));
801     }
802 
803     /**
804      * @dev Return the entire set in an array
805      *
806      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
807      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
808      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
809      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
810      */
811     function values(AddressSet storage set) internal view returns (address[] memory) {
812         bytes32[] memory store = _values(set._inner);
813         address[] memory result;
814 
815         assembly {
816             result := store
817         }
818 
819         return result;
820     }
821 
822     // UintSet
823 
824     struct UintSet {
825         Set _inner;
826     }
827 
828     /**
829      * @dev Add a value to a set. O(1).
830      *
831      * Returns true if the value was added to the set, that is if it was not
832      * already present.
833      */
834     function add(UintSet storage set, uint256 value) internal returns (bool) {
835         return _add(set._inner, bytes32(value));
836     }
837 
838     /**
839      * @dev Removes a value from a set. O(1).
840      *
841      * Returns true if the value was removed from the set, that is if it was
842      * present.
843      */
844     function remove(UintSet storage set, uint256 value) internal returns (bool) {
845         return _remove(set._inner, bytes32(value));
846     }
847 
848     /**
849      * @dev Returns true if the value is in the set. O(1).
850      */
851     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
852         return _contains(set._inner, bytes32(value));
853     }
854 
855     /**
856      * @dev Returns the number of values on the set. O(1).
857      */
858     function length(UintSet storage set) internal view returns (uint256) {
859         return _length(set._inner);
860     }
861 
862     /**
863      * @dev Returns the value stored at position `index` in the set. O(1).
864      *
865      * Note that there are no guarantees on the ordering of values inside the
866      * array, and it may change when more values are added or removed.
867      *
868      * Requirements:
869      *
870      * - `index` must be strictly less than {length}.
871      */
872     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
873         return uint256(_at(set._inner, index));
874     }
875 
876     /**
877      * @dev Return the entire set in an array
878      *
879      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
880      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
881      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
882      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
883      */
884     function values(UintSet storage set) internal view returns (uint256[] memory) {
885         bytes32[] memory store = _values(set._inner);
886         uint256[] memory result;
887 
888         assembly {
889             result := store
890         }
891 
892         return result;
893     }
894 }
895 
896 // 
897 abstract contract fuzangRNG is Ownable {
898     /**
899     * Tiers
900     * 0 - Pearl
901     * 1 - Gold
902     * 2 - Silver
903     * 3 - Bronze
904      */
905     using SafeMath for uint256;
906     using EnumerableSet for EnumerableSet.AddressSet;
907 
908     address payable public pearlWinner;
909     address payable public goldWinner;
910     address payable public silverWinner;
911     address payable public bronzeWinner;
912     
913     EnumerableSet.AddressSet pearlSet;
914     EnumerableSet.AddressSet goldSet;
915     EnumerableSet.AddressSet silverSet;
916     EnumerableSet.AddressSet bronzeSet;
917 
918     EnumerableSet.AddressSet[] potWallets;
919 
920     uint256 public pearlMinWeight = 2 * 10 ** 5;
921     uint256 public goldMinWeight = 10 ** 5;
922     uint256 public silverMinWeight = 5 * 10 ** 4;
923 
924     mapping(address => uint256) public potWeights;
925     mapping(address => uint256) public ethAmounts;
926     mapping(address => bool) public excludedFromPot;
927     mapping(address => bool) public isEthAmountNegative;
928 
929     IUniswapV2Router02 public uniswapV2Router;
930 
931     uint256 public feeMin = 0.1 * 10 ** 18;
932     uint256 public feeMax = 0.3 * 10 ** 18;
933     uint256 internal lastTotalFee;
934 
935     uint256 public ethWeight = 10 ** 10;
936 
937     mapping(address => bool) isGoverner;
938     address[] governers;
939 
940     event newWinnersSelected(uint256 timestamp, address pearlWinner, address goldWinner, address silverWinner, address bronzeWinner, 
941         uint256 pearlEthAmount, uint256 goldEthAmount, uint256 silverEthAmount, uint256 bronzeEthAmount,
942         uint256 pearlfuzangAmount, uint256 goldfuzangAmount, uint256 silverfuzangAmount, uint256 bronzefuzangAmount,
943         uint256 lastTotalFee);
944 
945     modifier onlyGoverner() {
946         require(isGoverner[_msgSender()], "Not governer");
947         _;
948     }
949 
950     constructor(address payable _initialWinner) public
951     {
952         pearlWinner = _initialWinner;
953         goldWinner = _initialWinner;
954         silverWinner = _initialWinner;
955         bronzeWinner = _initialWinner;
956         
957         pearlSet.add(_initialWinner);
958         goldSet.add(_initialWinner);
959         silverSet.add(_initialWinner);
960         bronzeSet.add(_initialWinner);
961 
962         potWallets.push(pearlSet);
963         potWallets.push(goldSet);
964         potWallets.push(silverSet);
965         potWallets.push(bronzeSet);
966 
967         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
968 
969         isGoverner[owner()] = true;
970         governers.push(owner());
971     }
972 
973     function checkTierFromWeight(uint256 weight)
974         public
975         view
976         returns(uint256)
977     {
978         if (weight > pearlMinWeight) {
979             return 0;
980         }
981         if (weight > goldMinWeight) {
982             return 1;
983         }
984         if (weight > silverMinWeight) {
985             return 2;
986         }
987         return 3;
988     }
989 
990     function calcWeight(uint256 ethAmount, uint256 fuzangAmount) public view returns(uint256) {
991         return ethAmount.div(10 ** 13) + fuzangAmount.div(10 ** 13).div(ethWeight);
992     }
993 
994     function addNewWallet(address _account, uint256 tier) internal {
995         potWallets[tier].add(_account);
996     }
997 
998     function removeWallet(address _account, uint256 tier) internal {
999         potWallets[tier].remove(_account);
1000     }
1001 
1002     function addWalletToPotList(address _account, uint256 _amount) internal {
1003         if (!excludedFromPot[_account]) {
1004             address[] memory path = new address[](2);
1005             path[0] = uniswapV2Router.WETH();
1006             path[1] = address(this);
1007             
1008             uint256 ethAmount = uniswapV2Router.getAmountsIn(_amount, path)[0];
1009             
1010             uint256 oldWeight = potWeights[_account];
1011 
1012             if (isEthAmountNegative[_account]) {
1013                 if (ethAmount > ethAmounts[_account]) {
1014                     ethAmounts[_account] = ethAmount - ethAmounts[_account];
1015                     isEthAmountNegative[_account] = false;
1016 
1017                     potWeights[_account] = calcWeight(ethAmounts[_account], IERC20(address(this)).balanceOf(_account) + _amount);
1018                 } else {
1019                     ethAmounts[_account] = ethAmounts[_account] - ethAmount;
1020                     potWeights[_account] = 0;
1021                 }
1022             } else {
1023                 ethAmounts[_account] += ethAmount;
1024 
1025                 potWeights[_account] = calcWeight(ethAmounts[_account], IERC20(address(this)).balanceOf(_account) + _amount);
1026             }
1027 
1028             if (!isEthAmountNegative[_account]) {
1029                 uint256 oldTier = checkTierFromWeight(oldWeight);
1030                 uint256 newTier = checkTierFromWeight(potWeights[_account]);
1031 
1032                 if (oldTier != newTier) {
1033                     removeWallet(_account, oldTier);
1034                 }
1035 
1036                 addNewWallet(_account, newTier);
1037             }
1038         }
1039     }
1040 
1041     function removeWalletFromPotList(address _account, uint256 _amount) internal {
1042         if (!excludedFromPot[_account]) {
1043             address[] memory path = new address[](2);
1044             path[0] = uniswapV2Router.WETH();
1045             path[1] = address(this);
1046             
1047             uint256 ethAmount = uniswapV2Router.getAmountsIn(_amount, path)[0];
1048 
1049             uint256 oldWeight = potWeights[_account];
1050 
1051             if (isEthAmountNegative[_account]) {
1052                 ethAmounts[_account] += ethAmount;
1053                 potWeights[_account] = 0;
1054             } else if (ethAmounts[_account] >= ethAmount) {
1055                 ethAmounts[_account] -= ethAmount;
1056                 potWeights[_account] = calcWeight(ethAmounts[_account], IERC20(address(this)).balanceOf(_account));
1057             } else {
1058                 ethAmounts[_account] = ethAmount - ethAmounts[_account];
1059                 isEthAmountNegative[_account] = true;
1060                 potWeights[_account] = 0;
1061             }
1062 
1063             uint256 oldTier = checkTierFromWeight(oldWeight);
1064             removeWallet(_account, oldTier);
1065         }
1066     }
1067 
1068     function rand(uint256 max)
1069         private
1070         view
1071         returns(uint256)
1072     {
1073         if (max == 1) {
1074             return 0;
1075         }
1076 
1077         uint256 seed = uint256(keccak256(abi.encodePacked(
1078             block.timestamp + block.difficulty +
1079             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +
1080             block.gaslimit +
1081             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)) +
1082             block.number
1083         )));
1084 
1085         return (seed - ((seed / (max - 1)) * (max - 1))) + 1;
1086     }
1087 
1088     function checkAndChangePotWinner() internal {
1089         uint256 randFee = rand(feeMax - feeMin) + feeMin;
1090 
1091         if (lastTotalFee >= randFee) {
1092             uint256 pearlWinnerIndex = rand(potWallets[0].length());
1093             uint256 goldWinnerIndex = rand(potWallets[1].length());
1094             uint256 silverWinnerIndex = rand(potWallets[2].length());
1095             uint256 bronzeWinnerIndex = rand(potWallets[3].length());
1096 
1097             pearlWinner = payable(potWallets[0].at(pearlWinnerIndex));
1098             goldWinner = payable(potWallets[1].at(goldWinnerIndex));
1099             silverWinner = payable(potWallets[2].at(silverWinnerIndex));
1100             bronzeWinner = payable(potWallets[3].at(bronzeWinnerIndex));
1101 
1102             emit newWinnersSelected(
1103                 block.timestamp, pearlWinner, goldWinner, silverWinner, bronzeWinner, 
1104                 ethAmounts[pearlWinner], ethAmounts[goldWinner], ethAmounts[silverWinner], ethAmounts[bronzeWinner],
1105                 IERC20(address(this)).balanceOf(pearlWinner), IERC20(address(this)).balanceOf(goldWinner), IERC20(address(this)).balanceOf(silverWinner), IERC20(address(this)).balanceOf(bronzeWinner),
1106                 lastTotalFee
1107             );
1108         }
1109     }
1110 
1111     /**
1112     * Mutations
1113      */
1114 
1115     function setEthWeight(uint256 _ethWeight) external onlyGoverner {
1116         ethWeight = _ethWeight;
1117     }
1118 
1119     function setTierWeights(uint256 _pearlMin, uint256 _goldMin, uint256 _silverMin) external onlyGoverner {
1120         require(_pearlMin > _goldMin && _goldMin > _silverMin, "Weights should be descending order");
1121 
1122         pearlMinWeight = _pearlMin;
1123         goldMinWeight = _goldMin;
1124         silverMinWeight = _silverMin;
1125     }
1126 
1127     function setFeeMinMax(uint256 _feeMin, uint256 _feeMax) external onlyGoverner {
1128         require(_feeMin < _feeMax, "feeMin should be smaller than feeMax");
1129 
1130         feeMin = _feeMin;
1131         feeMax = _feeMax;
1132     }
1133 
1134     function addGoverner(address _governer) public onlyGoverner {
1135         if (!isGoverner[_governer]) {
1136             isGoverner[_governer] = true;
1137             governers.push(_governer);
1138         }
1139     }
1140 
1141     function removeGoverner(address _governer) external onlyGoverner {
1142         if (isGoverner[_governer]) {
1143             isGoverner[_governer] = false;
1144 
1145             for (uint i = 0; i < governers.length; i ++) {
1146                 if (governers[i] == _governer) {
1147                     governers[i] = governers[governers.length - 1];
1148                     governers.pop();
1149                     break;
1150                 }
1151             }
1152         }
1153     }
1154 }
1155 
1156 /*
1157 More info:
1158 
1159     * Instead of giving equal weights to all users, we give weights based on their purchase token amount and contributed ETH amount
1160     * If you sell or transfer tokens to other wallets, you lose your ticket, but as soon as you buy again you regain your ticket
1161     * There's no min eligible amount. Even if you buy 1 token, you have the very little chance to get rewarded.
1162 */
1163 // 
1164 // Contract implementation
1165 contract TreasureHoard is IERC20, Ownable, fuzangRNG {
1166     using SafeMath for uint256;
1167     using Address for address;
1168 
1169     mapping (address => uint256) private _tOwned;
1170     mapping (address => mapping (address => uint256)) private _allowances;
1171     mapping (address => uint256) public timestamp;
1172 
1173     uint256 private eligibleRNG = block.timestamp;
1174 
1175     mapping (address => bool) private _isExcludedFromFee;
1176 
1177     mapping (address => bool) private _isBlackListedBot;
1178 
1179     uint256 private _tTotal = 1000000000000 * 10 ** 18;  //1,000,000,000,000
1180 
1181     uint256 public _coolDown = 30 seconds;
1182 
1183     string private _name = 'Treasure Hoard';
1184     string private _symbol = 'FUZANG';
1185     uint8 private _decimals = 18;
1186     
1187     uint256 public _devFee = 8;
1188     uint256 private _previousdevFee = _devFee;
1189 
1190     address payable private _treasurehoardAddress;
1191     
1192     address public uniswapV2Pair;
1193 
1194     bool inSwap = false;
1195     bool public swapEnabled = true;
1196     bool public feeEnabled = true;
1197     
1198     bool public tradingEnabled = false;
1199     bool public cooldownEnabled = true;
1200 
1201     uint256 public _maxTxAmount = _tTotal * 5 / 1000;
1202     uint256 private _numOfTokensToExchangeFordev = 5000000000000000;
1203 
1204     address public migrator;
1205 
1206     event SwapEnabledUpdated(bool enabled);
1207 
1208     modifier lockTheSwap {
1209         inSwap = true;
1210         _;
1211         inSwap = false;
1212     }
1213 
1214     constructor (address payable treasurehoardAddress)
1215         fuzangRNG(treasurehoardAddress)
1216         public
1217     {
1218         _treasurehoardAddress = treasurehoardAddress;
1219         _tOwned[_msgSender()] = _tTotal;
1220 
1221         // Create a uniswap pair for this new token
1222         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1223             .createPair(address(this), uniswapV2Router.WETH());
1224 
1225         // Exclude owner and this contract from fee
1226         _isExcludedFromFee[owner()] = true;
1227         _isExcludedFromFee[address(this)] = true;
1228 
1229         // Excluded fuzang, pair, owner from pot list
1230         excludedFromPot[address(this)] = true;
1231         excludedFromPot[uniswapV2Pair] = true;
1232         excludedFromPot[owner()] = true;
1233 
1234         emit Transfer(address(0), _msgSender(), _tTotal);
1235     }
1236 
1237     function name() public view returns (string memory) {
1238         return _name;
1239     }
1240 
1241     function symbol() public view returns (string memory) {
1242         return _symbol;
1243     }
1244 
1245     function decimals() public view returns (uint8) {
1246         return _decimals;
1247     }
1248 
1249     function totalSupply() public view override returns (uint256) {
1250         return _tTotal;
1251     }
1252 
1253     function balanceOf(address account) public view override returns (uint256) {
1254         return _tOwned[account];
1255     }
1256 
1257     function transfer(address recipient, uint256 amount) public override returns (bool) {
1258         _transfer(_msgSender(), recipient, amount);
1259         return true;
1260     }
1261 
1262     function allowance(address owner, address spender) public view override returns (uint256) {
1263         return _allowances[owner][spender];
1264     }
1265 
1266     function approve(address spender, uint256 amount) public override returns (bool) {
1267         _approve(_msgSender(), spender, amount);
1268         return true;
1269     }
1270 
1271     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1272         _transfer(sender, recipient, amount);
1273         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1274         return true;
1275     }
1276 
1277     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1278         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1279         return true;
1280     }
1281 
1282     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1283         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1284         return true;
1285     }
1286     
1287     function isBlackListed(address account) public view returns (bool) {
1288         return _isBlackListedBot[account];
1289     }
1290 
1291     function setExcludeFromFee(address account, bool excluded) external onlyGoverner {
1292         _isExcludedFromFee[account] = excluded;
1293     }
1294 
1295     function addBotToBlackList(address account) external onlyOwner() {
1296         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
1297         require(!_isBlackListedBot[account], "Account is already blacklisted");
1298         _isBlackListedBot[account] = true;
1299     }
1300     
1301     function addBotsToBlackList(address[] memory bots) external onlyOwner() {
1302         for (uint i = 0; i < bots.length; i++) {
1303             _isBlackListedBot[bots[i]] = true;
1304         }
1305     }
1306 
1307     function removeBotFromBlackList(address account) external onlyOwner() {
1308         require(_isBlackListedBot[account], "Account is not blacklisted");
1309         _isBlackListedBot[account] = false;
1310     }
1311 
1312     function removeAllFee() private {
1313         if(_devFee == 0) return;
1314         _previousdevFee = _devFee;
1315         _devFee = 0;
1316     }
1317 
1318     function restoreAllFee() private {
1319         _devFee = _previousdevFee;
1320     }
1321 
1322     function isExcludedFromFee(address account) public view returns(bool) {
1323         return _isExcludedFromFee[account];
1324     }
1325     
1326     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1327         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1328             10**2
1329         );
1330     }
1331     
1332     function setMaxTxAmount(uint256 maxTx) external onlyOwner() {
1333         _maxTxAmount = maxTx;
1334     }
1335 
1336     function _approve(address owner, address spender, uint256 amount) private {
1337         require(owner != address(0), "ERC20: approve from the zero address");
1338         require(spender != address(0), "ERC20: approve to the zero address");
1339 
1340         _allowances[owner][spender] = amount;
1341         emit Approval(owner, spender, amount);
1342     }
1343 
1344     function _transfer(address sender, address recipient, uint256 amount) private {
1345         require(sender != address(0), "ERC20: transfer from the zero address");
1346         require(recipient != address(0), "ERC20: transfer to the zero address");
1347         require(amount > 0, "Transfer amount must be greater than zero");
1348         require(!_isBlackListedBot[recipient], "Go away");
1349         require(!_isBlackListedBot[sender], "Go away");
1350 
1351         if(sender != owner() && recipient != owner() && sender != migrator && recipient != migrator) {
1352             require(amount <= _maxTxAmount, "Transfer amount exceeds the max amount.");
1353 
1354             // You can't trade this yet until trading enabled, be patient 
1355             if (sender == uniswapV2Pair || recipient == uniswapV2Pair) {
1356                 require(tradingEnabled, "Trading is not enabled");
1357             }
1358         }
1359 
1360         // Cooldown
1361         if(cooldownEnabled) {
1362             if (sender == uniswapV2Pair ) {
1363                 // They just bought so add cooldown
1364                 timestamp[recipient] = block.timestamp.add(_coolDown);
1365             }
1366 
1367             // exclude owner and uniswap
1368             if(sender != owner() && sender != uniswapV2Pair) {
1369                 require(block.timestamp >= timestamp[sender], "Cooldown");
1370             }
1371         }
1372 
1373         if (sender == uniswapV2Pair) {
1374             if (recipient != owner() && feeEnabled) {
1375                 addWalletToPotList(recipient, amount);
1376             }
1377         }
1378 
1379         // rest of the standard shit below
1380 
1381         uint256 contractTokenBalance = balanceOf(address(this));
1382 
1383         if (contractTokenBalance >= _maxTxAmount) {
1384             contractTokenBalance = _maxTxAmount;
1385         }
1386 
1387         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeFordev;
1388         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1389             // We need to swap the current tokens to ETH and send to the dev wallet
1390             swapTokensForEth(contractTokenBalance);
1391 
1392             uint256 contractETHBalance = address(this).balance;
1393             if(contractETHBalance > 0) {
1394                 sendETHTodev(address(this).balance);
1395             }
1396         }
1397         
1398         //indicates if fee should be deducted from transfer
1399         bool takeFee = true;
1400 
1401         //if any account belongs to _isExcludedFromFee account then remove the fee
1402         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1403             takeFee = false;
1404         }
1405 
1406         // transfer amount, it will take tax and dev fee
1407         _tokenTransfer(sender, recipient, amount, takeFee);
1408     }
1409 
1410     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1411         // generate the uniswap pair path of token -> weth
1412         address[] memory path = new address[](2);
1413         path[0] = address(this);
1414         path[1] = uniswapV2Router.WETH();
1415 
1416         _approve(address(this), address(uniswapV2Router), tokenAmount);
1417 
1418         // make the swap
1419         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1420             tokenAmount,
1421             0, // accept any amount of ETH
1422             path,
1423             address(this),
1424             block.timestamp
1425         );
1426     }
1427     
1428     function sendETHTodev(uint256 amount) private {
1429         if (block.timestamp >= eligibleRNG) {
1430             checkAndChangePotWinner();
1431         }
1432 
1433         uint256 winnerReward = amount.div(33);
1434 
1435         lastTotalFee += winnerReward;
1436 
1437         pearlWinner.transfer(winnerReward.mul(4));
1438         goldWinner.transfer(winnerReward.mul(3));
1439         silverWinner.transfer(winnerReward.mul(2));
1440         bronzeWinner.transfer(winnerReward.mul(1));
1441 
1442         _treasurehoardAddress.transfer(amount.mul(2).div(3));
1443     }
1444     
1445     // We are exposing these functions to be able to manual swap and send
1446     // in case the token is highly valued and 5M becomes too much
1447     function manualSwap() external onlyGoverner {
1448         uint256 contractBalance = balanceOf(address(this));
1449         swapTokensForEth(contractBalance);
1450     }
1451     
1452     function manualSend() external onlyGoverner {
1453         uint256 contractETHBalance = address(this).balance;
1454         sendETHTodev(contractETHBalance);
1455     }
1456 
1457     function setSwapEnabled(bool enabled) external onlyOwner(){
1458         swapEnabled = enabled;
1459         emit SwapEnabledUpdated(enabled);
1460     }    
1461     
1462     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1463         if(!takeFee)
1464             removeAllFee();
1465 
1466         _transferStandard(sender, recipient, amount);
1467 
1468         if(!takeFee)
1469             restoreAllFee();
1470     }
1471 
1472     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1473         uint256 tdev = tAmount.mul(_devFee).div(100);
1474         uint256 transferAmount = tAmount.sub(tdev);
1475 
1476         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1477         _tOwned[recipient] = _tOwned[recipient].add(transferAmount);
1478         
1479         // Stop wallets from trying to stay in pot by transferring to other wallets
1480         removeWalletFromPotList(sender, tAmount);
1481         
1482         _takedev(tdev); 
1483         emit Transfer(sender, recipient, transferAmount);
1484     }
1485 
1486     function _takedev(uint256 tdev) private {
1487         _tOwned[address(this)] = _tOwned[address(this)].add(tdev);
1488     }
1489 
1490         //to recieve ETH from uniswapV2Router when swaping
1491     receive() external payable {}
1492 
1493     function _getMaxTxAmount() private view returns(uint256) {
1494         return _maxTxAmount;
1495     }
1496 
1497     function _getETHBalance() public view returns(uint256 balance) {
1498         return address(this).balance;
1499     }
1500     
1501     function allowDex(bool _tradingEnabled) external onlyOwner() {
1502         tradingEnabled = _tradingEnabled;
1503         eligibleRNG = block.timestamp + 25 minutes;
1504     }
1505     
1506     function toggleCoolDown(bool _cooldownEnabled) external onlyOwner() {
1507         cooldownEnabled = _cooldownEnabled;
1508     }
1509     
1510     function toggleFeeEnabled(bool _feeEnabled) external onlyOwner() {
1511         // this is a failsafe if something breaks with mappings we can turn off so no-one gets rekt and can still trade
1512         feeEnabled = _feeEnabled;
1513     }
1514 
1515     function setMigrationContract(address _migrator) external onlyGoverner {
1516         excludedFromPot[_migrator] = true;
1517         _isExcludedFromFee[_migrator] = true;
1518         addGoverner(_migrator);
1519         migrator = _migrator;
1520     }
1521 }