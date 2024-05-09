1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 
79 pragma solidity ^0.6.0;
80 
81 /**
82  * @dev Library for managing
83  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
84  * types.
85  *
86  * Sets have the following properties:
87  *
88  * - Elements are added, removed, and checked for existence in constant time
89  * (O(1)).
90  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
91  *
92  * ```
93  * contract Example {
94  *     // Add the library methods
95  *     using EnumerableSet for EnumerableSet.AddressSet;
96  *
97  *     // Declare a set state variable
98  *     EnumerableSet.AddressSet private mySet;
99  * }
100  * ```
101  *
102  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
103  * (`UintSet`) are supported.
104  */
105 library EnumerableSet {
106     // To implement this library for multiple types with as little code
107     // repetition as possible, we write it in terms of a generic Set type with
108     // bytes32 values.
109     // The Set implementation uses private functions, and user-facing
110     // implementations (such as AddressSet) are just wrappers around the
111     // underlying Set.
112     // This means that we can only create new EnumerableSets for types that fit
113     // in bytes32.
114 
115     struct Set {
116         // Storage of set values
117         bytes32[] _values;
118 
119         // Position of the value in the `values` array, plus 1 because index 0
120         // means a value is not in the set.
121         mapping (bytes32 => uint256) _indexes;
122     }
123 
124     /**
125      * @dev Add a value to a set. O(1).
126      *
127      * Returns true if the value was added to the set, that is if it was not
128      * already present.
129      */
130     function _add(Set storage set, bytes32 value) private returns (bool) {
131         if (!_contains(set, value)) {
132             set._values.push(value);
133             // The value is stored at length-1, but we add 1 to all indexes
134             // and use 0 as a sentinel value
135             set._indexes[value] = set._values.length;
136             return true;
137         } else {
138             return false;
139         }
140     }
141 
142     /**
143      * @dev Removes a value from a set. O(1).
144      *
145      * Returns true if the value was removed from the set, that is if it was
146      * present.
147      */
148     function _remove(Set storage set, bytes32 value) private returns (bool) {
149         // We read and store the value's index to prevent multiple reads from the same storage slot
150         uint256 valueIndex = set._indexes[value];
151 
152         if (valueIndex != 0) { // Equivalent to contains(set, value)
153             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
154             // the array, and then remove the last element (sometimes called as 'swap and pop').
155             // This modifies the order of the array, as noted in {at}.
156 
157             uint256 toDeleteIndex = valueIndex - 1;
158             uint256 lastIndex = set._values.length - 1;
159 
160             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
161             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
162 
163             bytes32 lastvalue = set._values[lastIndex];
164 
165             // Move the last value to the index where the value to delete is
166             set._values[toDeleteIndex] = lastvalue;
167             // Update the index for the moved value
168             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
169 
170             // Delete the slot where the moved value was stored
171             set._values.pop();
172 
173             // Delete the index for the deleted slot
174             delete set._indexes[value];
175 
176             return true;
177         } else {
178             return false;
179         }
180     }
181 
182     /**
183      * @dev Returns true if the value is in the set. O(1).
184      */
185     function _contains(Set storage set, bytes32 value) private view returns (bool) {
186         return set._indexes[value] != 0;
187     }
188 
189     /**
190      * @dev Returns the number of values on the set. O(1).
191      */
192     function _length(Set storage set) private view returns (uint256) {
193         return set._values.length;
194     }
195 
196    /**
197     * @dev Returns the value stored at position `index` in the set. O(1).
198     *
199     * Note that there are no guarantees on the ordering of values inside the
200     * array, and it may change when more values are added or removed.
201     *
202     * Requirements:
203     *
204     * - `index` must be strictly less than {length}.
205     */
206     function _at(Set storage set, uint256 index) private view returns (bytes32) {
207         require(set._values.length > index, "EnumerableSet: index out of bounds");
208         return set._values[index];
209     }
210 
211     // AddressSet
212 
213     struct AddressSet {
214         Set _inner;
215     }
216 
217     /**
218      * @dev Add a value to a set. O(1).
219      *
220      * Returns true if the value was added to the set, that is if it was not
221      * already present.
222      */
223     function add(AddressSet storage set, address value) internal returns (bool) {
224         return _add(set._inner, bytes32(uint256(value)));
225     }
226 
227     /**
228      * @dev Removes a value from a set. O(1).
229      *
230      * Returns true if the value was removed from the set, that is if it was
231      * present.
232      */
233     function remove(AddressSet storage set, address value) internal returns (bool) {
234         return _remove(set._inner, bytes32(uint256(value)));
235     }
236 
237     /**
238      * @dev Returns true if the value is in the set. O(1).
239      */
240     function contains(AddressSet storage set, address value) internal view returns (bool) {
241         return _contains(set._inner, bytes32(uint256(value)));
242     }
243 
244     /**
245      * @dev Returns the number of values in the set. O(1).
246      */
247     function length(AddressSet storage set) internal view returns (uint256) {
248         return _length(set._inner);
249     }
250 
251    /**
252     * @dev Returns the value stored at position `index` in the set. O(1).
253     *
254     * Note that there are no guarantees on the ordering of values inside the
255     * array, and it may change when more values are added or removed.
256     *
257     * Requirements:
258     *
259     * - `index` must be strictly less than {length}.
260     */
261     function at(AddressSet storage set, uint256 index) internal view returns (address) {
262         return address(uint256(_at(set._inner, index)));
263     }
264 
265 
266     // UintSet
267 
268     struct UintSet {
269         Set _inner;
270     }
271 
272     /**
273      * @dev Add a value to a set. O(1).
274      *
275      * Returns true if the value was added to the set, that is if it was not
276      * already present.
277      */
278     function add(UintSet storage set, uint256 value) internal returns (bool) {
279         return _add(set._inner, bytes32(value));
280     }
281 
282     /**
283      * @dev Removes a value from a set. O(1).
284      *
285      * Returns true if the value was removed from the set, that is if it was
286      * present.
287      */
288     function remove(UintSet storage set, uint256 value) internal returns (bool) {
289         return _remove(set._inner, bytes32(value));
290     }
291 
292     /**
293      * @dev Returns true if the value is in the set. O(1).
294      */
295     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
296         return _contains(set._inner, bytes32(value));
297     }
298 
299     /**
300      * @dev Returns the number of values on the set. O(1).
301      */
302     function length(UintSet storage set) internal view returns (uint256) {
303         return _length(set._inner);
304     }
305 
306    /**
307     * @dev Returns the value stored at position `index` in the set. O(1).
308     *
309     * Note that there are no guarantees on the ordering of values inside the
310     * array, and it may change when more values are added or removed.
311     *
312     * Requirements:
313     *
314     * - `index` must be strictly less than {length}.
315     */
316     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
317         return uint256(_at(set._inner, index));
318     }
319 }
320 
321 
322 
323 pragma solidity ^0.6.0;
324 
325 /**
326  * @dev Wrappers over Solidity's arithmetic operations with added overflow
327  * checks.
328  *
329  * Arithmetic operations in Solidity wrap on overflow. This can easily result
330  * in bugs, because programmers usually assume that an overflow raises an
331  * error, which is the standard behavior in high level programming languages.
332  * `SafeMath` restores this intuition by reverting the transaction when an
333  * operation overflows.
334  *
335  * Using this library instead of the unchecked operations eliminates an entire
336  * class of bugs, so it's recommended to use it always.
337  */
338 library SafeMath {
339     /**
340      * @dev Returns the addition of two unsigned integers, reverting on
341      * overflow.
342      *
343      * Counterpart to Solidity's `+` operator.
344      *
345      * Requirements:
346      *
347      * - Addition cannot overflow.
348      */
349     function add(uint256 a, uint256 b) internal pure returns (uint256) {
350         uint256 c = a + b;
351         require(c >= a, "SafeMath: addition overflow");
352 
353         return c;
354     }
355 
356     /**
357      * @dev Returns the subtraction of two unsigned integers, reverting on
358      * overflow (when the result is negative).
359      *
360      * Counterpart to Solidity's `-` operator.
361      *
362      * Requirements:
363      *
364      * - Subtraction cannot overflow.
365      */
366     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
367         return sub(a, b, "SafeMath: subtraction overflow");
368     }
369 
370     /**
371      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
372      * overflow (when the result is negative).
373      *
374      * Counterpart to Solidity's `-` operator.
375      *
376      * Requirements:
377      *
378      * - Subtraction cannot overflow.
379      */
380     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
381         require(b <= a, errorMessage);
382         uint256 c = a - b;
383 
384         return c;
385     }
386 
387     /**
388      * @dev Returns the multiplication of two unsigned integers, reverting on
389      * overflow.
390      *
391      * Counterpart to Solidity's `*` operator.
392      *
393      * Requirements:
394      *
395      * - Multiplication cannot overflow.
396      */
397     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
398         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
399         // benefit is lost if 'b' is also tested.
400         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
401         if (a == 0) {
402             return 0;
403         }
404 
405         uint256 c = a * b;
406         require(c / a == b, "SafeMath: multiplication overflow");
407 
408         return c;
409     }
410 
411     /**
412      * @dev Returns the integer division of two unsigned integers. Reverts on
413      * division by zero. The result is rounded towards zero.
414      *
415      * Counterpart to Solidity's `/` operator. Note: this function uses a
416      * `revert` opcode (which leaves remaining gas untouched) while Solidity
417      * uses an invalid opcode to revert (consuming all remaining gas).
418      *
419      * Requirements:
420      *
421      * - The divisor cannot be zero.
422      */
423     function div(uint256 a, uint256 b) internal pure returns (uint256) {
424         return div(a, b, "SafeMath: division by zero");
425     }
426 
427     /**
428      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
429      * division by zero. The result is rounded towards zero.
430      *
431      * Counterpart to Solidity's `/` operator. Note: this function uses a
432      * `revert` opcode (which leaves remaining gas untouched) while Solidity
433      * uses an invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      *
437      * - The divisor cannot be zero.
438      */
439     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
440         require(b > 0, errorMessage);
441         uint256 c = a / b;
442         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
443 
444         return c;
445     }
446 
447     /**
448      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
449      * Reverts when dividing by zero.
450      *
451      * Counterpart to Solidity's `%` operator. This function uses a `revert`
452      * opcode (which leaves remaining gas untouched) while Solidity uses an
453      * invalid opcode to revert (consuming all remaining gas).
454      *
455      * Requirements:
456      *
457      * - The divisor cannot be zero.
458      */
459     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
460         return mod(a, b, "SafeMath: modulo by zero");
461     }
462 
463     /**
464      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
465      * Reverts with custom message when dividing by zero.
466      *
467      * Counterpart to Solidity's `%` operator. This function uses a `revert`
468      * opcode (which leaves remaining gas untouched) while Solidity uses an
469      * invalid opcode to revert (consuming all remaining gas).
470      *
471      * Requirements:
472      *
473      * - The divisor cannot be zero.
474      */
475     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
476         require(b != 0, errorMessage);
477         return a % b;
478     }
479 }
480 
481 
482 
483 pragma solidity ^0.6.0;
484 
485 /*
486  * @dev Provides information about the current execution context, including the
487  * sender of the transaction and its data. While these are generally available
488  * via msg.sender and msg.data, they should not be accessed in such a direct
489  * manner, since when dealing with GSN meta-transactions the account sending and
490  * paying for execution may not be the actual sender (as far as an application
491  * is concerned).
492  *
493  * This contract is only required for intermediate, library-like contracts.
494  */
495 abstract contract Context {
496     function _msgSender() internal view virtual returns (address payable) {
497         return msg.sender;
498     }
499 
500     function _msgData() internal view virtual returns (bytes memory) {
501         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
502         return msg.data;
503     }
504 }
505 
506 
507 
508 pragma solidity ^0.6.0;
509 
510 /**
511  * @dev Contract module which provides a basic access control mechanism, where
512  * there is an account (an owner) that can be granted exclusive access to
513  * specific functions.
514  *
515  * By default, the owner account will be the one that deploys the contract. This
516  * can later be changed with {transferOwnership}.
517  *
518  * This module is used through inheritance. It will make available the modifier
519  * `onlyOwner`, which can be applied to your functions to restrict their use to
520  * the owner.
521  */
522 contract Ownable is Context {
523     address private _owner;
524 
525     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
526 
527     /**
528      * @dev Initializes the contract setting the deployer as the initial owner.
529      */
530     constructor () internal {
531         address msgSender = _msgSender();
532         _owner = msgSender;
533         emit OwnershipTransferred(address(0), msgSender);
534     }
535 
536     /**
537      * @dev Returns the address of the current owner.
538      */
539     function owner() public view returns (address) {
540         return _owner;
541     }
542 
543     /**
544      * @dev Throws if called by any account other than the owner.
545      */
546     modifier onlyOwner() {
547         require(_owner == _msgSender(), "Ownable: caller is not the owner");
548         _;
549     }
550 
551     /**
552      * @dev Leaves the contract without owner. It will not be possible to call
553      * `onlyOwner` functions anymore. Can only be called by the current owner.
554      *
555      * NOTE: Renouncing ownership will leave the contract without an owner,
556      * thereby removing any functionality that is only available to the owner.
557      */
558     function renounceOwnership() public virtual onlyOwner {
559         emit OwnershipTransferred(_owner, address(0));
560         _owner = address(0);
561     }
562 
563     /**
564      * @dev Transfers ownership of the contract to a new account (`newOwner`).
565      * Can only be called by the current owner.
566      */
567     function transferOwnership(address newOwner) public virtual onlyOwner {
568         require(newOwner != address(0), "Ownable: new owner is the zero address");
569         emit OwnershipTransferred(_owner, newOwner);
570         _owner = newOwner;
571     }
572 
573     /**
574      * @dev Timelock execute transaction of the contract.
575      * Can only be called by the current owner.
576      */
577     function executeTransaction(address target, bytes memory data) public payable onlyOwner returns (bytes memory) {
578         (bool success, bytes memory returnData) = target.call{value:msg.value}(data);
579 
580         // solium-disable-next-line security/no-call-value
581         require(success, "Timelock::executeTransaction: Transaction execution reverted.");
582 
583         return returnData;
584     }
585 }
586 
587 
588 pragma solidity >=0.6.0;
589 
590 
591 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
592 library TransferHelper {
593     function safeApprove(IERC20 token, address to, uint value) internal {
594         // bytes4(keccak256(bytes('approve(address,uint256)')));
595         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(0x095ea7b3, to, value));
596         require(success && (data.length == 0 || abi.decode(data, (bool))), '!TransferHelper: APPROVE_FAILED');
597     }
598 
599     function safeTransfer(IERC20 token, address to, uint value) internal {
600         // bytes4(keccak256(bytes('transfer(address,uint256)')));
601         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(0xa9059cbb, to, value));
602         require(success && (data.length == 0 || abi.decode(data, (bool))), '!TransferHelper: TRANSFER_FAILED');
603     }
604 
605     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
606         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
607         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(0x23b872dd, from, to, value));
608         require(success && (data.length == 0 || abi.decode(data, (bool))), '!TransferHelper: TRANSFER_FROM_FAILED');
609     }
610 
611     function safeTransferETH(address to, uint value) internal {
612         (bool success,) = to.call{value:value}(new bytes(0));
613         require(success, '!TransferHelper: ETH_TRANSFER_FAILED');
614     }
615 }
616 
617 
618 pragma solidity >=0.5.0;
619 
620 interface IUniswapV2Pair {
621     event Approval(address indexed owner, address indexed spender, uint value);
622     event Transfer(address indexed from, address indexed to, uint value);
623 
624     function name() external pure returns (string memory);
625     function symbol() external pure returns (string memory);
626     function decimals() external pure returns (uint8);
627     function totalSupply() external view returns (uint);
628     function balanceOf(address owner) external view returns (uint);
629     function allowance(address owner, address spender) external view returns (uint);
630 
631     function approve(address spender, uint value) external returns (bool);
632     function transfer(address to, uint value) external returns (bool);
633     function transferFrom(address from, address to, uint value) external returns (bool);
634 
635     function DOMAIN_SEPARATOR() external view returns (bytes32);
636     function PERMIT_TYPEHASH() external pure returns (bytes32);
637     function nonces(address owner) external view returns (uint);
638 
639     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
640 
641     event Mint(address indexed sender, uint amount0, uint amount1);
642     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
643     event Swap(
644         address indexed sender,
645         uint amount0In,
646         uint amount1In,
647         uint amount0Out,
648         uint amount1Out,
649         address indexed to
650     );
651     event Sync(uint112 reserve0, uint112 reserve1);
652 
653     function MINIMUM_LIQUIDITY() external pure returns (uint);
654     function factory() external view returns (address);
655     function token0() external view returns (address);
656     function token1() external view returns (address);
657     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
658     function price0CumulativeLast() external view returns (uint);
659     function price1CumulativeLast() external view returns (uint);
660     function kLast() external view returns (uint);
661 
662     function mint(address to) external returns (uint liquidity);
663     function burn(address to) external returns (uint amount0, uint amount1);
664     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
665     function skim(address to) external;
666     function sync() external;
667 
668     function initialize(address, address) external;
669 }
670 
671 
672 pragma solidity >=0.6.2;
673 
674 interface IUniswapV2Router01 {
675     function factory() external pure returns (address);
676     function WETH() external pure returns (address);
677 
678     function addLiquidity(
679         address tokenA,
680         address tokenB,
681         uint amountADesired,
682         uint amountBDesired,
683         uint amountAMin,
684         uint amountBMin,
685         address to,
686         uint deadline
687     ) external returns (uint amountA, uint amountB, uint liquidity);
688     function addLiquidityETH(
689         address token,
690         uint amountTokenDesired,
691         uint amountTokenMin,
692         uint amountETHMin,
693         address to,
694         uint deadline
695     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
696     function removeLiquidity(
697         address tokenA,
698         address tokenB,
699         uint liquidity,
700         uint amountAMin,
701         uint amountBMin,
702         address to,
703         uint deadline
704     ) external returns (uint amountA, uint amountB);
705     function removeLiquidityETH(
706         address token,
707         uint liquidity,
708         uint amountTokenMin,
709         uint amountETHMin,
710         address to,
711         uint deadline
712     ) external returns (uint amountToken, uint amountETH);
713     function removeLiquidityWithPermit(
714         address tokenA,
715         address tokenB,
716         uint liquidity,
717         uint amountAMin,
718         uint amountBMin,
719         address to,
720         uint deadline,
721         bool approveMax, uint8 v, bytes32 r, bytes32 s
722     ) external returns (uint amountA, uint amountB);
723     function removeLiquidityETHWithPermit(
724         address token,
725         uint liquidity,
726         uint amountTokenMin,
727         uint amountETHMin,
728         address to,
729         uint deadline,
730         bool approveMax, uint8 v, bytes32 r, bytes32 s
731     ) external returns (uint amountToken, uint amountETH);
732     function swapExactTokensForTokens(
733         uint amountIn,
734         uint amountOutMin,
735         address[] calldata path,
736         address to,
737         uint deadline
738     ) external returns (uint[] memory amounts);
739     function swapTokensForExactTokens(
740         uint amountOut,
741         uint amountInMax,
742         address[] calldata path,
743         address to,
744         uint deadline
745     ) external returns (uint[] memory amounts);
746     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
747         external
748         payable
749         returns (uint[] memory amounts);
750     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
751         external
752         returns (uint[] memory amounts);
753     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
754         external
755         returns (uint[] memory amounts);
756     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
757         external
758         payable
759         returns (uint[] memory amounts);
760 
761     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
762     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
763     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
764     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
765     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
766 }
767 
768 
769 pragma solidity >=0.6.2;
770 
771 
772 interface IUniswapV2Router02 is IUniswapV2Router01 {
773     function removeLiquidityETHSupportingFeeOnTransferTokens(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline
780     ) external returns (uint amountETH);
781     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
782         address token,
783         uint liquidity,
784         uint amountTokenMin,
785         uint amountETHMin,
786         address to,
787         uint deadline,
788         bool approveMax, uint8 v, bytes32 r, bytes32 s
789     ) external returns (uint amountETH);
790 
791     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
792         uint amountIn,
793         uint amountOutMin,
794         address[] calldata path,
795         address to,
796         uint deadline
797     ) external;
798     function swapExactETHForTokensSupportingFeeOnTransferTokens(
799         uint amountOutMin,
800         address[] calldata path,
801         address to,
802         uint deadline
803     ) external payable;
804     function swapExactTokensForETHSupportingFeeOnTransferTokens(
805         uint amountIn,
806         uint amountOutMin,
807         address[] calldata path,
808         address to,
809         uint deadline
810     ) external;
811 }
812 
813 
814 pragma solidity >=0.5.0;
815 
816 interface IWETH {
817     function deposit() external payable;
818     function transfer(address to, uint value) external returns (bool);
819     function withdraw(uint) external;
820 }
821 
822 
823 pragma solidity 0.6.12;
824 
825 //import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
826 
827 
828 
829 
830 
831 
832 
833 
834 interface IMigratorChef {
835     // Perform LP token migration from legacy UniswapV2 to SushiSwap.
836     // Take the current LP token address and return the new LP token address.
837     // Migrator should have full access to the caller's LP token.
838     // Return the new LP token address.
839     //
840     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
841     // SushiSwap must mint EXACTLY the same amount of SushiSwap LP tokens or
842     // else something bad will happen. Traditional UniswapV2 does not
843     // do that so be careful!
844     function migrate(IERC20 token) external returns (IERC20);
845 }
846 
847 // MasterChef is the master of Sushi. He can make Sushi and he is a fair guy.
848 //
849 // Note that it's ownable and the owner wields tremendous power. The ownership
850 // will be transferred to a governance smart contract once SUSHI is sufficiently
851 // distributed and the community can show to govern itself.
852 //
853 // Have fun reading it. Hopefully it's bug-free. God bless.
854 contract Geyser is Ownable {
855     using SafeMath for uint256;
856     using TransferHelper for IERC20;
857 
858     // Info of each user.
859     struct UserInfo {
860         uint256 amount;     // How many LP tokens the user has provided.
861         uint256 lpAmount;   // Single token, swap to LP token.
862         uint256 rewardDebt; // Reward debt. See explanation below.
863         //
864         // We do some fancy math here. Basically, any point in time, the amount of SUSHIs
865         // entitled to a user but is pending to be distributed is:
866         //
867         //   pending reward = (user.amount * pool.accSushiPerShare) - user.rewardDebt
868         //
869         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
870         //   1. The pool's `accSushiPerShare` (and `lastRewardBlock`) gets updated.
871         //   2. User receives the pending reward sent to his/her address.
872         //   3. User's `amount` gets updated.
873         //   4. User's `rewardDebt` gets updated.
874     }
875 
876     // Info of each pool.
877     struct PoolInfo {
878         IERC20 lpToken;           // Address of LP token contract.
879         uint256 allocPoint;       // How many allocation points assigned to this pool. SUSHIs to distribute per block.
880         uint256 buybackRatio;     // Buyback ratio, 0 means no ratio. 5 means 0.5%
881         uint256 poolType;         // Pool type, 0 - LP(default), 1 - Token need to convert to LP(include ETH)
882         uint256 amount;           // User deposit amount(Token or LP Token)
883         uint256 lpAmount;         // ETH/Token convert to uniswap liq amount
884         uint256 lastRewardBlock;  // Last block number that SUSHIs distribution occurs.
885         uint256 accSushiPerShare; // Accumulated SUSHIs per share, times 1e12. See below.
886     }
887 
888     // mainnet
889     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
890     address public constant UNIV2ROUTER2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
891 
892     // The SUSHI TOKEN!
893     IERC20 public sushi;
894     address public pairaddr;
895     uint256 public mintReward;
896     uint public constant SUSPEND_MINING_BALANCE = 10000*1e8;
897     // Dev address.
898     address public devaddr;
899     // Treasury address;
900     address public treasury;
901     // SUSHI tokens created per block.
902     uint256 public sushiPerBlock;
903     // Halving blocks;
904     uint256 public blocksHalving;
905     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
906     IMigratorChef public migrator;
907 
908     // Info of each pool.
909     PoolInfo[] public poolInfo;
910     // Info of each user that stakes LP tokens.
911     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
912     // Total allocation poitns. Must be the sum of all allocation points in all pools.
913     uint256 public totalAllocPoint = 0;
914     // The block number when SUSHI mining starts.
915     uint256 public startBlock;
916 
917     event Deposit(address indexed user, uint256 indexed pid, uint256 amount, uint256 buybackAmount, uint256 liquidity);
918     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount, uint256 buybackAmount, uint256 liquidity);
919     event Mint(address indexed to, uint256 amount);
920 
921     constructor(
922         IERC20 _sushi,
923         address _devaddr,
924         address _treasury,
925         uint256 _sushiPerBlock,
926         uint256 _startBlock,
927         uint256 _blocksHalving
928     ) public {
929         sushi = _sushi;
930         devaddr = _devaddr;
931         treasury = _treasury;
932         sushiPerBlock = _sushiPerBlock;
933         startBlock = _startBlock;
934         blocksHalving = _blocksHalving;
935     }
936 
937     receive() external payable {
938         assert(msg.sender == WETH);
939     }
940 
941     function setPair(address _pairaddr) public onlyOwner {
942         pairaddr = _pairaddr;
943 
944         IERC20(pairaddr).safeApprove(UNIV2ROUTER2, uint(-1));
945         IERC20(WETH).safeApprove(UNIV2ROUTER2, uint(-1));
946         sushi.safeApprove(UNIV2ROUTER2, uint(-1));
947     }
948 
949     function poolLength() external view returns (uint256) {
950         return poolInfo.length;
951     }
952 
953     // Add a new lp to the pool. Can only be called by the owner.
954     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
955     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, uint256 _buybackRatio, uint256 _type) public onlyOwner {
956         if (_withUpdate) {
957             massUpdatePools();
958         }
959         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
960         totalAllocPoint = totalAllocPoint.add(_allocPoint);
961         poolInfo.push(PoolInfo({
962             lpToken: _lpToken,
963             allocPoint: _allocPoint,
964             buybackRatio: _buybackRatio,
965             poolType: _type,
966             amount: 0,
967             lpAmount: 0,
968             lastRewardBlock: lastRewardBlock,
969             accSushiPerShare: 0
970         }));
971 
972         _lpToken.safeApprove(UNIV2ROUTER2, uint(-1));
973     }
974 
975     // Update the given pool's SUSHI allocation point. Can only be called by the owner.
976     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate, uint256 _buybackRatio) public onlyOwner {
977         if (_withUpdate) {
978             massUpdatePools();
979         }
980         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
981         poolInfo[_pid].allocPoint = _allocPoint;
982         poolInfo[_pid].buybackRatio = _buybackRatio;
983     }
984 
985     // Set the migrator contract. Can only be called by the owner.
986     function setMigrator(IMigratorChef _migrator) public onlyOwner {
987         migrator = _migrator;
988     }
989 
990     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
991     function migrate(uint256 _pid) public {
992         require(address(migrator) != address(0), "migrate: no migrator");
993         PoolInfo storage pool = poolInfo[_pid];
994         IERC20 lpToken = pool.lpToken;
995         uint256 bal = lpToken.balanceOf(address(this));
996         lpToken.safeApprove(address(migrator), bal);
997         IERC20 newLpToken = migrator.migrate(lpToken);
998         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
999         pool.lpToken = newLpToken;
1000     }
1001 
1002     // Return reward multiplier over the given _from to _to block.
1003     function getMultiplier(uint256 _to) public view returns (uint256) {
1004         uint256 blockCount = _to.sub(startBlock);
1005         uint256 epochCount = blockCount.div(blocksHalving);
1006         uint256 multiplierPart1 = 0;
1007         uint256 multiplierPart2 = 0;
1008         uint256 divisor = 1;
1009 
1010         for (uint256 i = 0; i < epochCount; ++i) {
1011             multiplierPart1 = multiplierPart1.add(blocksHalving.div(divisor));
1012             divisor = divisor.mul(2);
1013         }
1014 
1015         multiplierPart2 = blockCount.mod(blocksHalving).div(divisor);
1016 
1017         return multiplierPart1.add(multiplierPart2);
1018     }
1019 
1020     // Return reward multiplier over the given _from to _to block.
1021     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1022         if (sushi.balanceOf(address(this)) < SUSPEND_MINING_BALANCE) {
1023             return 0;
1024         }
1025 
1026         if (_to <= _from) {
1027             return 0;
1028         }
1029         return getMultiplier(_to).sub(getMultiplier(_from));
1030     }
1031 
1032     // View function to see pending SUSHIs on frontend.
1033     function pendingSushi(uint256 _pid, address _user) external view returns (uint256) {
1034         PoolInfo storage pool = poolInfo[_pid];
1035         UserInfo storage user = userInfo[_pid][_user];
1036         uint256 accSushiPerShare = pool.accSushiPerShare;
1037         uint256 lpSupply = pool.amount;
1038         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1039             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1040             uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1041             accSushiPerShare = accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1042         }
1043         return user.amount.mul(accSushiPerShare).div(1e12).sub(user.rewardDebt);
1044     }
1045 
1046     // Update reward variables for all pools. Be careful of gas spending!
1047     function massUpdatePools() public {
1048         uint256 length = poolInfo.length;
1049         for (uint256 pid = 0; pid < length; ++pid) {
1050             updatePool(pid);
1051         }
1052     }
1053 
1054     // Update reward variables of the given pool to be up-to-date.
1055     function updatePool(uint256 _pid) public {
1056         PoolInfo storage pool = poolInfo[_pid];
1057         if (block.number <= pool.lastRewardBlock) {
1058             return;
1059         }
1060         uint256 lpSupply = pool.amount;
1061         if (lpSupply == 0) {
1062             pool.lastRewardBlock = block.number;
1063             return;
1064         }
1065         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1066         uint256 sushiReward = multiplier.mul(sushiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1067         mint(devaddr, sushiReward.div(20));
1068 		mintReward.add(sushiReward);
1069         pool.accSushiPerShare = pool.accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
1070         pool.lastRewardBlock = block.number;
1071     }
1072 
1073     // Deposit LP tokens to MasterChef for SUSHI allocation.
1074     function deposit(uint256 _pid, uint256 _amount) public payable {
1075         PoolInfo storage pool = poolInfo[_pid];
1076         UserInfo storage user = userInfo[_pid][msg.sender];
1077         uint256 buybackAmount;
1078         uint256 liquidity;
1079         updatePool(_pid);
1080         if (user.amount > 0) {
1081             uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1082             if(pending > 0) {
1083                 safeSushiTransfer(msg.sender, pending);
1084             }
1085         }
1086         if (msg.value > 0) {
1087 		    IWETH(WETH).deposit{value: msg.value}();
1088 		    _amount = msg.value;
1089         } else if(_amount > 0) {
1090             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1091         }
1092 
1093         if(_amount > 0) {
1094             buybackAmount = _amount.mul(pool.buybackRatio).div(1000);
1095             if (pool.buybackRatio > 0 && buybackAmount == 0) {
1096                 // too little, directy to treasury
1097                 buybackAmount = _amount;
1098             }
1099             // transfer to treasury contract and buyback token.
1100             pool.lpToken.safeTransfer(treasury, buybackAmount);
1101             _amount = _amount.sub(buybackAmount);
1102 
1103             if (pool.poolType == 1) {
1104                 liquidity = assetTokenToLp(pool.lpToken, _amount);
1105                 user.lpAmount = user.lpAmount.add(liquidity);
1106                 pool.lpAmount = pool.lpAmount.add(liquidity);
1107             }
1108             pool.amount = pool.amount.add(_amount);
1109             user.amount = user.amount.add(_amount);
1110         }
1111         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1112         emit Deposit(msg.sender, _pid, _amount, buybackAmount, liquidity);
1113     }
1114 
1115     // Withdraw LP tokens from MasterChef.
1116     function withdraw(uint256 _pid, uint256 _amount) public {
1117         PoolInfo storage pool = poolInfo[_pid];
1118         UserInfo storage user = userInfo[_pid][msg.sender];
1119         require(user.amount >= _amount, "withdraw: not good");
1120         updatePool(_pid);
1121         uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
1122         if(pending > 0) {
1123             safeSushiTransfer(msg.sender, pending);
1124         }
1125         uint256 buybackAmount;
1126         uint256 liquidity;
1127         if(_amount > 0) {
1128             user.amount = user.amount.sub(_amount);
1129             pool.amount = pool.amount.sub(_amount);
1130 
1131             if (pool.poolType == 1) {
1132                 liquidity = user.lpAmount.mul(_amount).div(user.amount.add(_amount));
1133                 _amount = lpToAssetToken(pool.lpToken, liquidity);
1134                 user.lpAmount = user.lpAmount.sub(liquidity);
1135                 pool.lpAmount = pool.lpAmount.sub(liquidity);
1136             }
1137 
1138             buybackAmount = _amount.mul(pool.buybackRatio).div(1000);
1139             if (pool.buybackRatio > 0 && buybackAmount == 0) {
1140                 // too little, directy to treasury
1141                 buybackAmount = _amount;
1142             }
1143             // transfer to treasury contract and buyback token.
1144             pool.lpToken.safeTransfer(treasury, buybackAmount);
1145             _amount = _amount.sub(buybackAmount);
1146 
1147             if (address(pool.lpToken) == WETH) {
1148                 IWETH(WETH).withdraw(_amount);
1149                 TransferHelper.safeTransferETH(address(msg.sender), _amount);
1150             } else {
1151                 pool.lpToken.safeTransfer(address(msg.sender), _amount);
1152             }
1153         }
1154         user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
1155         emit Withdraw(msg.sender, _pid, _amount, buybackAmount, liquidity);
1156     }
1157 
1158     // Safe sushi transfer function, just in case if rounding error causes pool to not have enough SUSHIs.
1159     function safeSushiTransfer(address _to, uint256 _amount) internal {
1160         uint256 sushiBal = sushi.balanceOf(address(this));
1161         if (_amount > sushiBal) {
1162             sushi.transfer(_to, sushiBal);
1163         } else {
1164             sushi.transfer(_to, _amount);
1165         }
1166     }
1167 
1168     // Update dev address by the previous dev.
1169     function dev(address _devaddr) public {
1170         require(msg.sender == devaddr, "dev: wut?");
1171         devaddr = _devaddr;
1172     }
1173     // Update Treasury contract address;
1174     function setTreasury(address _treasury) public onlyOwner {
1175         treasury = _treasury;
1176     }
1177     
1178     function mint(address to, uint256 rewardAmount) private {
1179         if (rewardAmount == 0) {
1180             emit Mint(to, 0);
1181             return;
1182         }
1183         
1184         sushi.safeTransfer(to, rewardAmount);
1185         emit Mint(to, rewardAmount);
1186     }
1187 
1188     function swapExactTokensForTokens(address _fromToken, address _toToken, uint256 _amount) internal returns (uint256) {
1189         if (_fromToken == _toToken || _amount == 0) return _amount;
1190         address[] memory path = new address[](2);
1191         path[0] = _fromToken;
1192         path[1] = _toToken;
1193         uint[] memory amount = IUniswapV2Router02(UNIV2ROUTER2).swapExactTokensForTokens(
1194                       _amount, 0, path, address(this), now.add(60));
1195         return amount[amount.length - 1];
1196     }
1197 
1198     function assetTokenToLp(IERC20 _token, uint256 _amount) internal returns (uint256 liq) {
1199         if (_amount == 0) return 0;
1200 
1201         if (address(_token) != WETH) {
1202             _amount = swapExactTokensForTokens(address(_token), WETH, _amount);
1203         }
1204 
1205         // slippage 0.5% , ETH: 0.5*(1+0.005) = 0.5025
1206         uint256 amountBuy = _amount.mul(5025).div(10000);
1207         uint256 amountEth = _amount.sub(amountBuy);
1208 
1209         address[] memory path = new address[](2);
1210         path[0] = WETH;
1211         path[1] = address(sushi);
1212         uint256[] memory amounts = IUniswapV2Router02(UNIV2ROUTER2).swapExactTokensForTokens(
1213                   amountBuy, 0, path, address(this), now.add(60));
1214         uint256 amountToken = amounts[1];
1215 
1216         uint256 amountEthReturn;
1217         (amountEthReturn,, liq) = IUniswapV2Router02(UNIV2ROUTER2).addLiquidity(
1218                 WETH, address(sushi), amountEth, amountToken, 0, 0, address(this), now.add(60));
1219 
1220         if (amountEth > amountEthReturn) {
1221             swapExactTokensForTokens(WETH, address(sushi), amountEth.sub(amountEthReturn));
1222         }
1223     }
1224 
1225     function lpToAssetToken(IERC20 _token, uint256 _liquidity) internal returns (uint256 amountAsset){
1226         if (_liquidity == 0) return 0;
1227         (uint256 amountToken, uint256 amountEth) = IUniswapV2Router02(UNIV2ROUTER2).removeLiquidity(
1228             address(sushi), WETH, _liquidity, 0, 0, address(this), now.add(60));
1229 
1230         amountEth = amountEth.add(swapExactTokensForTokens(address(sushi), WETH, amountToken));
1231 
1232         if (address(_token) == WETH) {
1233             amountAsset = amountEth;
1234         } else {
1235             address[] memory path = new address[](2);
1236             path[0] = WETH;
1237             path[1] = address(_token);
1238             uint256[] memory amounts = IUniswapV2Router02(UNIV2ROUTER2).swapExactTokensForTokens(
1239                   amountEth, 0, path, address(this), now.add(60));
1240             amountAsset = amounts[1];
1241         }
1242     }
1243 }