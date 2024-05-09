1 //**Developed by DevHound**
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.12;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address payable) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108  
109 library SafeMath {
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return sub(a, b, "SafeMath: subtraction overflow");
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b <= a, errorMessage);
153         uint256 c = a - b;
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the multiplication of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `*` operator.
163      *
164      * Requirements:
165      *
166      * - Multiplication cannot overflow.
167      */
168     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170         // benefit is lost if 'b' is also tested.
171         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         return div(a, b, "SafeMath: division by zero");
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         uint256 c = a / b;
213         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         return mod(a, b, "SafeMath: modulo by zero");
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts with custom message when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b != 0, errorMessage);
248         return a % b;
249     }
250 }
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
390 /**
391  * @dev Contract module which provides a basic access control mechanism, where
392  * there is an account (an owner) that can be granted exclusive access to
393  * specific functions.
394  *
395  * By default, the owner account will be the one that deploys the contract. This
396  * can later be changed with {transferOwnership}.
397  *
398  * This module is used through inheritance. It will make available the modifier
399  * `onlyOwner`, which can be applied to your functions to restrict their use to
400  * the owner.
401  */
402 contract Ownable is Context {
403     address private _owner;
404     address private _previousOwner;
405     uint256 private _lockTime;
406 
407     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
408 
409     /**
410      * @dev Initializes the contract setting the deployer as the initial owner.
411      */
412     constructor () internal {
413         address msgSender = _msgSender();
414         _owner = msgSender;
415         emit OwnershipTransferred(address(0), msgSender);
416     }
417 
418     /**
419      * @dev Returns the address of the current owner.
420      */
421     function owner() public view returns (address) {
422         return _owner;
423     }
424 
425     /**
426      * @dev Throws if called by any account other than the owner.
427      */
428     modifier onlyOwner() {
429         require(_owner == _msgSender(), "Ownable: caller is not the owner");
430         _;
431     }
432 
433      /**
434      * @dev Leaves the contract without owner. It will not be possible to call
435      * `onlyOwner` functions anymore. Can only be called by the current owner.
436      *
437      * NOTE: Renouncing ownership will leave the contract without an owner,
438      * thereby removing any functionality that is only available to the owner.
439      */
440     function renounceOwnership() public virtual onlyOwner {
441         emit OwnershipTransferred(_owner, address(0));
442         _owner = address(0);
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(newOwner != address(0), "Ownable: new owner is the zero address");
451         emit OwnershipTransferred(_owner, newOwner);
452         _owner = newOwner;
453     }
454 
455     function geUnlockTime() public view returns (uint256) {
456         return _lockTime;
457     }
458 
459     //Locks the contract for owner for the amount of time provided
460     function lock(uint256 time) public virtual onlyOwner {
461         _previousOwner = _owner;
462         _owner = address(0);
463         _lockTime = now + time;
464         emit OwnershipTransferred(_owner, address(0));
465     }
466     
467     //Unlocks the contract for owner when _lockTime is exceeds
468     function unlock() public virtual {
469         require(_previousOwner == msg.sender, "You don't have permission to unlock");
470         require(now > _lockTime , "Contract is locked until 7 days");
471         emit OwnershipTransferred(_owner, _previousOwner);
472         _owner = _previousOwner;
473     }
474 }
475 
476 // pragma solidity >=0.5.0;
477 
478 interface IUniswapV2Factory {
479     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
480 
481     function feeTo() external view returns (address);
482     function feeToSetter() external view returns (address);
483 
484     function getPair(address tokenA, address tokenB) external view returns (address pair);
485     function allPairs(uint) external view returns (address pair);
486     function allPairsLength() external view returns (uint);
487 
488     function createPair(address tokenA, address tokenB) external returns (address pair);
489 
490     function setFeeTo(address) external;
491     function setFeeToSetter(address) external;
492 }
493 
494 
495 // pragma solidity >=0.5.0;
496 
497 interface IUniswapV2Pair {
498     event Approval(address indexed owner, address indexed spender, uint value);
499     event Transfer(address indexed from, address indexed to, uint value);
500 
501     function name() external pure returns (string memory);
502     function symbol() external pure returns (string memory);
503     function decimals() external pure returns (uint8);
504     function totalSupply() external view returns (uint);
505     function balanceOf(address owner) external view returns (uint);
506     function allowance(address owner, address spender) external view returns (uint);
507 
508     function approve(address spender, uint value) external returns (bool);
509     function transfer(address to, uint value) external returns (bool);
510     function transferFrom(address from, address to, uint value) external returns (bool);
511 
512     function DOMAIN_SEPARATOR() external view returns (bytes32);
513     function PERMIT_TYPEHASH() external pure returns (bytes32);
514     function nonces(address owner) external view returns (uint);
515 
516     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
517 
518     event Mint(address indexed sender, uint amount0, uint amount1);
519     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
520     event Swap(
521         address indexed sender,
522         uint amount0In,
523         uint amount1In,
524         uint amount0Out,
525         uint amount1Out,
526         address indexed to
527     );
528     event Sync(uint112 reserve0, uint112 reserve1);
529 
530     function MINIMUM_LIQUIDITY() external pure returns (uint);
531     function factory() external view returns (address);
532     function token0() external view returns (address);
533     function token1() external view returns (address);
534     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
535     function price0CumulativeLast() external view returns (uint);
536     function price1CumulativeLast() external view returns (uint);
537     function kLast() external view returns (uint);
538 
539     function mint(address to) external returns (uint liquidity);
540     function burn(address to) external returns (uint amount0, uint amount1);
541     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
542     function skim(address to) external;
543     function sync() external;
544 
545     function initialize(address, address) external;
546 }
547 
548 // pragma solidity >=0.6.2;
549 
550 interface IUniswapV2Router01 {
551     function factory() external pure returns (address);
552     function WETH() external pure returns (address);
553 
554     function addLiquidity(
555         address tokenA,
556         address tokenB,
557         uint amountADesired,
558         uint amountBDesired,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline
563     ) external returns (uint amountA, uint amountB, uint liquidity);
564     function addLiquidityETH(
565         address token,
566         uint amountTokenDesired,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline
571     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
572     function removeLiquidity(
573         address tokenA,
574         address tokenB,
575         uint liquidity,
576         uint amountAMin,
577         uint amountBMin,
578         address to,
579         uint deadline
580     ) external returns (uint amountA, uint amountB);
581     function removeLiquidityETH(
582         address token,
583         uint liquidity,
584         uint amountTokenMin,
585         uint amountETHMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountToken, uint amountETH);
589     function removeLiquidityWithPermit(
590         address tokenA,
591         address tokenB,
592         uint liquidity,
593         uint amountAMin,
594         uint amountBMin,
595         address to,
596         uint deadline,
597         bool approveMax, uint8 v, bytes32 r, bytes32 s
598     ) external returns (uint amountA, uint amountB);
599     function removeLiquidityETHWithPermit(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountToken, uint amountETH);
608     function swapExactTokensForTokens(
609         uint amountIn,
610         uint amountOutMin,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external returns (uint[] memory amounts);
615     function swapTokensForExactTokens(
616         uint amountOut,
617         uint amountInMax,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external returns (uint[] memory amounts);
622     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
623         external
624         payable
625         returns (uint[] memory amounts);
626     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
627         external
628         returns (uint[] memory amounts);
629     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
630         external
631         returns (uint[] memory amounts);
632     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
633         external
634         payable
635         returns (uint[] memory amounts);
636 
637     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
638     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
639     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
640     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
641     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
642 }
643 
644 
645 
646 // pragma solidity >=0.6.2;
647 
648 interface IUniswapV2Router02 is IUniswapV2Router01 {
649     function removeLiquidityETHSupportingFeeOnTransferTokens(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline
656     ) external returns (uint amountETH);
657     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
658         address token,
659         uint liquidity,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline,
664         bool approveMax, uint8 v, bytes32 r, bytes32 s
665     ) external returns (uint amountETH);
666 
667     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
668         uint amountIn,
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external;
674     function swapExactETHForTokensSupportingFeeOnTransferTokens(
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external payable;
680     function swapExactTokensForETHSupportingFeeOnTransferTokens(
681         uint amountIn,
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external;
687 }
688 
689 
690 contract ECHO is Context, IERC20, Ownable {
691     using SafeMath for uint256;
692     using Address for address;
693 
694     mapping (address => uint256) private _rOwned;
695     mapping (address => uint256) private _tOwned;
696     mapping (address => mapping (address => uint256)) private _allowances;
697 
698     mapping (address => bool) private _isExcludedFromFee;
699 
700     mapping (address => bool) private _isExcluded;
701     address[] private _excluded;
702    
703     uint256 private constant MAX = ~uint256(0);
704     uint256 private _tTotal = 10000 * 10**18;
705     uint256 private _rTotal = (MAX - (MAX % _tTotal));
706     uint256 private _tFeeTotal;
707 
708     string private _name = "Echo Finance";
709     string private _symbol = "ECHO";
710     uint8 private _decimals = 18;
711     
712     //2%
713     uint256 public _taxFee = 2;
714     uint256 private _previousTaxFee = _taxFee;
715     
716     //2%
717     uint256 public _liquidityFee = 2;
718     uint256 private _previousLiquidityFee = _liquidityFee;
719     
720     //No limit
721     uint256 public _maxTxAmount = _tTotal;
722     
723     IUniswapV2Router02 public immutable uniswapV2Router;
724     address public immutable uniswapV2Pair;
725     
726     bool inSwapAndLiquify;
727     bool public swapAndLiquifyEnabled = true;
728     uint256 private minTokensBeforeSwap = 8;
729     
730     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
731     event SwapAndLiquifyEnabledUpdated(bool enabled);
732     event SwapAndLiquify(
733         uint256 tokensSwapped,
734         uint256 ethReceived,
735         uint256 tokensIntoLiqudity
736     );
737     
738     modifier lockTheSwap {
739         inSwapAndLiquify = true;
740         _;
741         inSwapAndLiquify = false;
742     }
743     
744     constructor () public {
745         _rOwned[_msgSender()] = _rTotal;
746         
747         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
748          // Create a uniswap pair for this new token
749         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
750             .createPair(address(this), _uniswapV2Router.WETH());
751 
752         // set the rest of the contract variables
753         uniswapV2Router = _uniswapV2Router;
754         
755         //exclude owner and this contract from fee
756         _isExcludedFromFee[owner()] = true;
757         _isExcludedFromFee[address(this)] = true;
758         
759         emit Transfer(address(0), _msgSender(), _tTotal);
760     }
761 
762     function name() public view returns (string memory) {
763         return _name;
764     }
765 
766     function symbol() public view returns (string memory) {
767         return _symbol;
768     }
769 
770     function decimals() public view returns (uint8) {
771         return _decimals;
772     }
773 
774     function totalSupply() public view override returns (uint256) {
775         return _tTotal;
776     }
777 
778     function balanceOf(address account) public view override returns (uint256) {
779         if (_isExcluded[account]) return _tOwned[account];
780         return tokenFromReflection(_rOwned[account]);
781     }
782 
783     function transfer(address recipient, uint256 amount) public override returns (bool) {
784         _transfer(_msgSender(), recipient, amount);
785         return true;
786     }
787 
788     function allowance(address owner, address spender) public view override returns (uint256) {
789         return _allowances[owner][spender];
790     }
791 
792     function approve(address spender, uint256 amount) public override returns (bool) {
793         _approve(_msgSender(), spender, amount);
794         return true;
795     }
796 
797     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
798         _transfer(sender, recipient, amount);
799         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
800         return true;
801     }
802 
803     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
804         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
805         return true;
806     }
807 
808     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
809         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
810         return true;
811     }
812 
813     function isExcludedFromReward(address account) public view returns (bool) {
814         return _isExcluded[account];
815     }
816 
817     function totalFees() public view returns (uint256) {
818         return _tFeeTotal;
819     }
820 
821     function deliver(uint256 tAmount) public {
822         address sender = _msgSender();
823         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
824         (uint256 rAmount,,,,,) = _getValues(tAmount);
825         _rOwned[sender] = _rOwned[sender].sub(rAmount);
826         _rTotal = _rTotal.sub(rAmount);
827         _tFeeTotal = _tFeeTotal.add(tAmount);
828     }
829 
830     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
831         require(tAmount <= _tTotal, "Amount must be less than supply");
832         if (!deductTransferFee) {
833             (uint256 rAmount,,,,,) = _getValues(tAmount);
834             return rAmount;
835         } else {
836             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
837             return rTransferAmount;
838         }
839     }
840 
841     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
842         require(rAmount <= _rTotal, "Amount must be less than total reflections");
843         uint256 currentRate =  _getRate();
844         return rAmount.div(currentRate);
845     }
846 
847     function excludeFromReward(address account) public onlyOwner() {
848         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
849         require(!_isExcluded[account], "Account is already excluded");
850         if(_rOwned[account] > 0) {
851             _tOwned[account] = tokenFromReflection(_rOwned[account]);
852         }
853         _isExcluded[account] = true;
854         _excluded.push(account);
855     }
856 
857     function includeInReward(address account) external onlyOwner() {
858         require(_isExcluded[account], "Account is already excluded");
859         for (uint256 i = 0; i < _excluded.length; i++) {
860             if (_excluded[i] == account) {
861                 _excluded[i] = _excluded[_excluded.length - 1];
862                 _tOwned[account] = 0;
863                 _isExcluded[account] = false;
864                 _excluded.pop();
865                 break;
866             }
867         }
868     }
869 
870     function _approve(address owner, address spender, uint256 amount) private {
871         require(owner != address(0), "ERC20: approve from the zero address");
872         require(spender != address(0), "ERC20: approve to the zero address");
873 
874         _allowances[owner][spender] = amount;
875         emit Approval(owner, spender, amount);
876     }
877 
878     function _transfer(
879         address from,
880         address to,
881         uint256 amount
882     ) private {
883         require(from != address(0), "ERC20: transfer from the zero address");
884         require(to != address(0), "ERC20: transfer to the zero address");
885         require(amount > 0, "Transfer amount must be greater than zero");
886         if(from != owner() && to != owner())
887             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
888 
889         // is the token balance of this contract address over the min number of
890         // tokens that we need to initiate a swap + liquidity lock?
891         // also, don't get caught in a circular liquidity event.
892         // also, don't swap & liquify if sender is uniswap pair.
893         uint256 contractTokenBalance = balanceOf(address(this));
894         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
895         if (
896             overMinTokenBalance &&
897             !inSwapAndLiquify &&
898             from != uniswapV2Pair &&
899             swapAndLiquifyEnabled
900         ) {
901             //add liquidity
902             swapAndLiquify(contractTokenBalance);
903         }
904         
905         //indicates if fee should be deducted from transfer
906         bool takeFee = true;
907         
908         //if any account belongs to _isExcludedFromFee account then remove the fee
909         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
910             takeFee = false;
911         }
912         
913         //transfer amount, it will take tax, burn, liquidity fee
914         _tokenTransfer(from,to,amount,takeFee);
915     }
916 
917     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
918         // split the contract balance into halves
919         uint256 half = contractTokenBalance.div(2);
920         uint256 otherHalf = contractTokenBalance.sub(half);
921 
922         // capture the contract's current ETH balance.
923         // this is so that we can capture exactly the amount of ETH that the
924         // swap creates, and not make the liquidity event include any ETH that
925         // has been manually sent to the contract
926         uint256 initialBalance = address(this).balance;
927 
928         // swap tokens for ETH
929         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
930 
931         // how much ETH did we just swap into?
932         uint256 newBalance = address(this).balance.sub(initialBalance);
933 
934         // add liquidity to uniswap
935         addLiquidity(otherHalf, newBalance);
936         
937         emit SwapAndLiquify(half, newBalance, otherHalf);
938     }
939 
940     function swapTokensForEth(uint256 tokenAmount) private {
941         // generate the uniswap pair path of token -> weth
942         address[] memory path = new address[](2);
943         path[0] = address(this);
944         path[1] = uniswapV2Router.WETH();
945 
946         _approve(address(this), address(uniswapV2Router), tokenAmount);
947 
948         // make the swap
949         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
950             tokenAmount,
951             0, // accept any amount of ETH
952             path,
953             address(this),
954             block.timestamp
955         );
956     }
957 
958     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
959         // approve token transfer to cover all possible scenarios
960         _approve(address(this), address(uniswapV2Router), tokenAmount);
961 
962         // add the liquidity
963         uniswapV2Router.addLiquidityETH{value: ethAmount}(
964             address(this),
965             tokenAmount,
966             0, // slippage is unavoidable
967             0, // slippage is unavoidable
968             owner(),
969             block.timestamp
970         );
971     }
972 
973     //this method is responsible for taking all fee, if takeFee is true
974     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
975         if(!takeFee)
976             removeAllFee();
977         
978         if (_isExcluded[sender] && !_isExcluded[recipient]) {
979             _transferFromExcluded(sender, recipient, amount);
980         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
981             _transferToExcluded(sender, recipient, amount);
982         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
983             _transferStandard(sender, recipient, amount);
984         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
985             _transferBothExcluded(sender, recipient, amount);
986         } else {
987             _transferStandard(sender, recipient, amount);
988         }
989         
990         if(!takeFee)
991             restoreAllFee();
992     }
993 
994     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
995         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
996         _rOwned[sender] = _rOwned[sender].sub(rAmount);
997         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
998         _takeLiquidity(tLiquidity);
999         _reflectFee(rFee, tFee);
1000         emit Transfer(sender, recipient, tTransferAmount);
1001     }
1002 
1003     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1004         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1005         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1006         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1007         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1008         _takeLiquidity(tLiquidity);
1009         _reflectFee(rFee, tFee);
1010         emit Transfer(sender, recipient, tTransferAmount);
1011     }
1012 
1013     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1014         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1015         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1016         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1017         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1018         _takeLiquidity(tLiquidity);
1019         _reflectFee(rFee, tFee);
1020         emit Transfer(sender, recipient, tTransferAmount);
1021     }
1022 
1023     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1024         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1025         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1026         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1027         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1028         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1029         _takeLiquidity(tLiquidity);
1030         _reflectFee(rFee, tFee);
1031         emit Transfer(sender, recipient, tTransferAmount);
1032     }
1033 
1034     function _reflectFee(uint256 rFee, uint256 tFee) private {
1035         _rTotal = _rTotal.sub(rFee);
1036         _tFeeTotal = _tFeeTotal.add(tFee);
1037     }
1038 
1039     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1040         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1041         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1042         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1043     }
1044 
1045     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1046         uint256 tFee = calculateTaxFee(tAmount);
1047         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1048         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1049         return (tTransferAmount, tFee, tLiquidity);
1050     }
1051 
1052     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1053         uint256 rAmount = tAmount.mul(currentRate);
1054         uint256 rFee = tFee.mul(currentRate);
1055         uint256 rLiquidity = tLiquidity.mul(currentRate);
1056         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1057         return (rAmount, rTransferAmount, rFee);
1058     }
1059 
1060     function _getRate() private view returns(uint256) {
1061         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1062         return rSupply.div(tSupply);
1063     }
1064 
1065     function _getCurrentSupply() private view returns(uint256, uint256) {
1066         uint256 rSupply = _rTotal;
1067         uint256 tSupply = _tTotal;      
1068         for (uint256 i = 0; i < _excluded.length; i++) {
1069             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1070             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1071             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1072         }
1073         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1074         return (rSupply, tSupply);
1075     }
1076     
1077     function _takeLiquidity(uint256 tLiquidity) private {
1078         uint256 currentRate =  _getRate();
1079         uint256 rLiquidity = tLiquidity.mul(currentRate);
1080         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1081         if(_isExcluded[address(this)])
1082             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1083     }
1084     
1085     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1086         return _amount.mul(_taxFee).div(
1087             10**2
1088         );
1089     }
1090 
1091     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1092         return _amount.mul(_liquidityFee).div(
1093             10**2
1094         );
1095     }
1096     
1097     function removeAllFee() private {
1098         if(_taxFee == 0 && _liquidityFee == 0) return;
1099         
1100         _previousTaxFee = _taxFee;
1101         _previousLiquidityFee = _liquidityFee;
1102         
1103         _taxFee = 0;
1104         _liquidityFee = 0;
1105     }
1106     
1107     function restoreAllFee() private {
1108         _taxFee = _previousTaxFee;
1109         _liquidityFee = _previousLiquidityFee;
1110     }
1111     
1112     function isExcludedFromFee(address account) public view returns(bool) {
1113         return _isExcludedFromFee[account];
1114     }
1115     
1116     function excludeFromFee(address account) public onlyOwner {
1117         _isExcludedFromFee[account] = true;
1118     }
1119     
1120     function includeInFee(address account) public onlyOwner {
1121         _isExcludedFromFee[account] = false;
1122     }
1123     
1124     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1125         _taxFee = taxFee;
1126     }
1127     
1128     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1129         _liquidityFee = liquidityFee;
1130     }
1131    
1132     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1133         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1134             10**2
1135         );
1136     }
1137 
1138     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1139         swapAndLiquifyEnabled = _enabled;
1140         emit SwapAndLiquifyEnabledUpdated(_enabled);
1141     }
1142     
1143      //to recieve ETH from uniswapV2Router when swaping
1144     receive() external payable {}
1145 }