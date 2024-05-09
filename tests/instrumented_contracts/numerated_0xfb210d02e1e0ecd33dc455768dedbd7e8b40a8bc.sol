1 //SPDX-License-Identifier: MIT
2 /* Website: http://OneMillionHolders.com
3 Twitter: https://twitter.com/1millionholder
4 Telegram: http://t.me/onemillionholders
5 */
6 
7 pragma solidity >=0.6.2;
8 
9 interface IUniswapV2Router01 {
10     function factory() external pure returns (address);
11     function WETH() external pure returns (address);
12 
13     function addLiquidity(
14         address tokenA,
15         address tokenB,
16         uint amountADesired,
17         uint amountBDesired,
18         uint amountAMin,
19         uint amountBMin,
20         address to,
21         uint deadline
22     ) external returns (uint amountA, uint amountB, uint liquidity);
23     function addLiquidityETH(
24         address token,
25         uint amountTokenDesired,
26         uint amountTokenMin,
27         uint amountETHMin,
28         address to,
29         uint deadline
30     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
31     function removeLiquidity(
32         address tokenA,
33         address tokenB,
34         uint liquidity,
35         uint amountAMin,
36         uint amountBMin,
37         address to,
38         uint deadline
39     ) external returns (uint amountA, uint amountB);
40     function removeLiquidityETH(
41         address token,
42         uint liquidity,
43         uint amountTokenMin,
44         uint amountETHMin,
45         address to,
46         uint deadline
47     ) external returns (uint amountToken, uint amountETH);
48     function removeLiquidityWithPermit(
49         address tokenA,
50         address tokenB,
51         uint liquidity,
52         uint amountAMin,
53         uint amountBMin,
54         address to,
55         uint deadline,
56         bool approveMax, uint8 v, bytes32 r, bytes32 s
57     ) external returns (uint amountA, uint amountB);
58     function removeLiquidityETHWithPermit(
59         address token,
60         uint liquidity,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline,
65         bool approveMax, uint8 v, bytes32 r, bytes32 s
66     ) external returns (uint amountToken, uint amountETH);
67     function swapExactTokensForTokens(
68         uint amountIn,
69         uint amountOutMin,
70         address[] calldata path,
71         address to,
72         uint deadline
73     ) external returns (uint[] memory amounts);
74     function swapTokensForExactTokens(
75         uint amountOut,
76         uint amountInMax,
77         address[] calldata path,
78         address to,
79         uint deadline
80     ) external returns (uint[] memory amounts);
81     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
82         external
83         payable
84         returns (uint[] memory amounts);
85     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
86         external
87         returns (uint[] memory amounts);
88     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
89         external
90         returns (uint[] memory amounts);
91     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
92         external
93         payable
94         returns (uint[] memory amounts);
95 
96     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
97     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
98     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
99     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
100     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
101 }
102 
103 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
104 
105 pragma solidity >=0.6.2;
106 
107 
108 interface IUniswapV2Router02 is IUniswapV2Router01 {
109     function removeLiquidityETHSupportingFeeOnTransferTokens(
110         address token,
111         uint liquidity,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external returns (uint amountETH);
117     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
118         address token,
119         uint liquidity,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline,
124         bool approveMax, uint8 v, bytes32 r, bytes32 s
125     ) external returns (uint amountETH);
126 
127     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134     function swapExactETHForTokensSupportingFeeOnTransferTokens(
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external payable;
140     function swapExactTokensForETHSupportingFeeOnTransferTokens(
141         uint amountIn,
142         uint amountOutMin,
143         address[] calldata path,
144         address to,
145         uint deadline
146     ) external;
147 }
148 
149 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
150 
151 pragma solidity >=0.5.0;
152 
153 interface IUniswapV2Pair {
154     event Approval(address indexed owner, address indexed spender, uint value);
155     event Transfer(address indexed from, address indexed to, uint value);
156 
157     function name() external pure returns (string memory);
158     function symbol() external pure returns (string memory);
159     function decimals() external pure returns (uint8);
160     function totalSupply() external view returns (uint);
161     function balanceOf(address owner) external view returns (uint);
162     function allowance(address owner, address spender) external view returns (uint);
163 
164     function approve(address spender, uint value) external returns (bool);
165     function transfer(address to, uint value) external returns (bool);
166     function transferFrom(address from, address to, uint value) external returns (bool);
167 
168     function DOMAIN_SEPARATOR() external view returns (bytes32);
169     function PERMIT_TYPEHASH() external pure returns (bytes32);
170     function nonces(address owner) external view returns (uint);
171 
172     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
173 
174     event Mint(address indexed sender, uint amount0, uint amount1);
175     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
176     event Swap(
177         address indexed sender,
178         uint amount0In,
179         uint amount1In,
180         uint amount0Out,
181         uint amount1Out,
182         address indexed to
183     );
184     event Sync(uint112 reserve0, uint112 reserve1);
185 
186     function MINIMUM_LIQUIDITY() external pure returns (uint);
187     function factory() external view returns (address);
188     function token0() external view returns (address);
189     function token1() external view returns (address);
190     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
191     function price0CumulativeLast() external view returns (uint);
192     function price1CumulativeLast() external view returns (uint);
193     function kLast() external view returns (uint);
194 
195     function mint(address to) external returns (uint liquidity);
196     function burn(address to) external returns (uint amount0, uint amount1);
197     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
198     function skim(address to) external;
199     function sync() external;
200 
201     function initialize(address, address) external;
202 }
203 
204 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
205 
206 pragma solidity >=0.5.0;
207 
208 interface IUniswapV2Factory {
209     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
210 
211     function feeTo() external view returns (address);
212     function feeToSetter() external view returns (address);
213 
214     function getPair(address tokenA, address tokenB) external view returns (address pair);
215     function allPairs(uint) external view returns (address pair);
216     function allPairsLength() external view returns (uint);
217 
218     function createPair(address tokenA, address tokenB) external returns (address pair);
219 
220     function setFeeTo(address) external;
221     function setFeeToSetter(address) external;
222 }
223 
224 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
225 
226 
227 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 // CAUTION
232 // This version of SafeMath should only be used with Solidity 0.8 or later,
233 // because it relies on the compiler's built in overflow checks.
234 
235 /**
236  * @dev Wrappers over Solidity's arithmetic operations.
237  *
238  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
239  * now has built in overflow checking.
240  */
241 library SafeMath {
242     /**
243      * @dev Returns the addition of two unsigned integers, with an overflow flag.
244      *
245      * _Available since v3.4._
246      */
247     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
248         unchecked {
249             uint256 c = a + b;
250             if (c < a) return (false, 0);
251             return (true, c);
252         }
253     }
254 
255     /**
256      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
257      *
258      * _Available since v3.4._
259      */
260     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (b > a) return (false, 0);
263             return (true, a - b);
264         }
265     }
266 
267     /**
268      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
269      *
270      * _Available since v3.4._
271      */
272     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
275             // benefit is lost if 'b' is also tested.
276             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
277             if (a == 0) return (true, 0);
278             uint256 c = a * b;
279             if (c / a != b) return (false, 0);
280             return (true, c);
281         }
282     }
283 
284     /**
285      * @dev Returns the division of two unsigned integers, with a division by zero flag.
286      *
287      * _Available since v3.4._
288      */
289     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
290         unchecked {
291             if (b == 0) return (false, 0);
292             return (true, a / b);
293         }
294     }
295 
296     /**
297      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
298      *
299      * _Available since v3.4._
300      */
301     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
302         unchecked {
303             if (b == 0) return (false, 0);
304             return (true, a % b);
305         }
306     }
307 
308     /**
309      * @dev Returns the addition of two unsigned integers, reverting on
310      * overflow.
311      *
312      * Counterpart to Solidity's `+` operator.
313      *
314      * Requirements:
315      *
316      * - Addition cannot overflow.
317      */
318     function add(uint256 a, uint256 b) internal pure returns (uint256) {
319         return a + b;
320     }
321 
322     /**
323      * @dev Returns the subtraction of two unsigned integers, reverting on
324      * overflow (when the result is negative).
325      *
326      * Counterpart to Solidity's `-` operator.
327      *
328      * Requirements:
329      *
330      * - Subtraction cannot overflow.
331      */
332     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
333         return a - b;
334     }
335 
336     /**
337      * @dev Returns the multiplication of two unsigned integers, reverting on
338      * overflow.
339      *
340      * Counterpart to Solidity's `*` operator.
341      *
342      * Requirements:
343      *
344      * - Multiplication cannot overflow.
345      */
346     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
347         return a * b;
348     }
349 
350     /**
351      * @dev Returns the integer division of two unsigned integers, reverting on
352      * division by zero. The result is rounded towards zero.
353      *
354      * Counterpart to Solidity's `/` operator.
355      *
356      * Requirements:
357      *
358      * - The divisor cannot be zero.
359      */
360     function div(uint256 a, uint256 b) internal pure returns (uint256) {
361         return a / b;
362     }
363 
364     /**
365      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
366      * reverting when dividing by zero.
367      *
368      * Counterpart to Solidity's `%` operator. This function uses a `revert`
369      * opcode (which leaves remaining gas untouched) while Solidity uses an
370      * invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      *
374      * - The divisor cannot be zero.
375      */
376     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
377         return a % b;
378     }
379 
380     /**
381      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
382      * overflow (when the result is negative).
383      *
384      * CAUTION: This function is deprecated because it requires allocating memory for the error
385      * message unnecessarily. For custom revert reasons use {trySub}.
386      *
387      * Counterpart to Solidity's `-` operator.
388      *
389      * Requirements:
390      *
391      * - Subtraction cannot overflow.
392      */
393     function sub(
394         uint256 a,
395         uint256 b,
396         string memory errorMessage
397     ) internal pure returns (uint256) {
398         unchecked {
399             require(b <= a, errorMessage);
400             return a - b;
401         }
402     }
403 
404     /**
405      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
406      * division by zero. The result is rounded towards zero.
407      *
408      * Counterpart to Solidity's `/` operator. Note: this function uses a
409      * `revert` opcode (which leaves remaining gas untouched) while Solidity
410      * uses an invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      *
414      * - The divisor cannot be zero.
415      */
416     function div(
417         uint256 a,
418         uint256 b,
419         string memory errorMessage
420     ) internal pure returns (uint256) {
421         unchecked {
422             require(b > 0, errorMessage);
423             return a / b;
424         }
425     }
426 
427     /**
428      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
429      * reverting with custom message when dividing by zero.
430      *
431      * CAUTION: This function is deprecated because it requires allocating memory for the error
432      * message unnecessarily. For custom revert reasons use {tryMod}.
433      *
434      * Counterpart to Solidity's `%` operator. This function uses a `revert`
435      * opcode (which leaves remaining gas untouched) while Solidity uses an
436      * invalid opcode to revert (consuming all remaining gas).
437      *
438      * Requirements:
439      *
440      * - The divisor cannot be zero.
441      */
442     function mod(
443         uint256 a,
444         uint256 b,
445         string memory errorMessage
446     ) internal pure returns (uint256) {
447         unchecked {
448             require(b > 0, errorMessage);
449             return a % b;
450         }
451     }
452 }
453 
454 // File: @openzeppelin/contracts/utils/Context.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @dev Provides information about the current execution context, including the
463  * sender of the transaction and its data. While these are generally available
464  * via msg.sender and msg.data, they should not be accessed in such a direct
465  * manner, since when dealing with meta-transactions the account sending and
466  * paying for execution may not be the actual sender (as far as an application
467  * is concerned).
468  *
469  * This contract is only required for intermediate, library-like contracts.
470  */
471 abstract contract Context {
472     function _msgSender() internal view virtual returns (address) {
473         return msg.sender;
474     }
475 
476     function _msgData() internal view virtual returns (bytes calldata) {
477         return msg.data;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/access/Ownable.sol
482 
483 
484 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 
489 /**
490  * @dev Contract module which provides a basic access control mechanism, where
491  * there is an account (an owner) that can be granted exclusive access to
492  * specific functions.
493  *
494  * By default, the owner account will be the one that deploys the contract. This
495  * can later be changed with {transferOwnership}.
496  *
497  * This module is used through inheritance. It will make available the modifier
498  * `onlyOwner`, which can be applied to your functions to restrict their use to
499  * the owner.
500  */
501 abstract contract Ownable is Context {
502     address private _owner;
503 
504     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
505 
506     /**
507      * @dev Initializes the contract setting the deployer as the initial owner.
508      */
509     constructor() {
510         _transferOwnership(_msgSender());
511     }
512 
513     /**
514      * @dev Throws if called by any account other than the owner.
515      */
516     modifier onlyOwner() {
517         _checkOwner();
518         _;
519     }
520 
521     /**
522      * @dev Returns the address of the current owner.
523      */
524     function owner() public view virtual returns (address) {
525         return _owner;
526     }
527 
528     /**
529      * @dev Throws if the sender is not the owner.
530      */
531     function _checkOwner() internal view virtual {
532         require(owner() == _msgSender(), "Ownable: caller is not the owner");
533     }
534 
535     /**
536      * @dev Leaves the contract without owner. It will not be possible to call
537      * `onlyOwner` functions anymore. Can only be called by the current owner.
538      *
539      * NOTE: Renouncing ownership will leave the contract without an owner,
540      * thereby removing any functionality that is only available to the owner.
541      */
542     function renounceOwnership() public virtual onlyOwner {
543         _transferOwnership(address(0));
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      * Can only be called by the current owner.
549      */
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(newOwner != address(0), "Ownable: new owner is the zero address");
552         _transferOwnership(newOwner);
553     }
554 
555     /**
556      * @dev Transfers ownership of the contract to a new account (`newOwner`).
557      * Internal function without access restriction.
558      */
559     function _transferOwnership(address newOwner) internal virtual {
560         address oldOwner = _owner;
561         _owner = newOwner;
562         emit OwnershipTransferred(oldOwner, newOwner);
563     }
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
567 
568 
569 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @dev Interface of the ERC20 standard as defined in the EIP.
575  */
576 interface IERC20 {
577     /**
578      * @dev Emitted when `value` tokens are moved from one account (`from`) to
579      * another (`to`).
580      *
581      * Note that `value` may be zero.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 value);
584 
585     /**
586      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
587      * a call to {approve}. `value` is the new allowance.
588      */
589     event Approval(address indexed owner, address indexed spender, uint256 value);
590 
591     /**
592      * @dev Returns the amount of tokens in existence.
593      */
594     function totalSupply() external view returns (uint256);
595 
596     /**
597      * @dev Returns the amount of tokens owned by `account`.
598      */
599     function balanceOf(address account) external view returns (uint256);
600 
601     /**
602      * @dev Moves `amount` tokens from the caller's account to `to`.
603      *
604      * Returns a boolean value indicating whether the operation succeeded.
605      *
606      * Emits a {Transfer} event.
607      */
608     function transfer(address to, uint256 amount) external returns (bool);
609 
610     /**
611      * @dev Returns the remaining number of tokens that `spender` will be
612      * allowed to spend on behalf of `owner` through {transferFrom}. This is
613      * zero by default.
614      *
615      * This value changes when {approve} or {transferFrom} are called.
616      */
617     function allowance(address owner, address spender) external view returns (uint256);
618 
619     /**
620      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
621      *
622      * Returns a boolean value indicating whether the operation succeeded.
623      *
624      * IMPORTANT: Beware that changing an allowance with this method brings the risk
625      * that someone may use both the old and the new allowance by unfortunate
626      * transaction ordering. One possible solution to mitigate this race
627      * condition is to first reduce the spender's allowance to 0 and set the
628      * desired value afterwards:
629      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
630      *
631      * Emits an {Approval} event.
632      */
633     function approve(address spender, uint256 amount) external returns (bool);
634 
635     /**
636      * @dev Moves `amount` tokens from `from` to `to` using the
637      * allowance mechanism. `amount` is then deducted from the caller's
638      * allowance.
639      *
640      * Returns a boolean value indicating whether the operation succeeded.
641      *
642      * Emits a {Transfer} event.
643      */
644     function transferFrom(
645         address from,
646         address to,
647         uint256 amount
648     ) external returns (bool);
649 }
650 
651 // File: contracts/OMH.sol
652 
653 
654 pragma solidity ^0.8.17;
655 
656 
657 
658 
659 
660 
661 
662 contract OMHERC20 is Context, IERC20, Ownable {
663     using SafeMath for uint256;
664 
665     string private constant _name = "ONE MILLION HOLDERS";
666     string private constant _symbol = "OMH";
667     uint8 private constant _decimals = 9;
668 
669     mapping(address => uint256) private _rOwned;
670     mapping(address => mapping(address => uint256)) private _allowances;
671     mapping(address => bool) private _isExcludedFromFee;
672     uint256 private constant MAX = ~uint256(0);
673     uint256 private constant _tTotal = 100_000_000 * 10 ** _decimals;
674     uint256 private _rTotal = (MAX - (MAX % _tTotal));
675     uint256 private _tFeeTotal;
676     uint256 private _redisFeeOnBuy = 0;
677     uint256 private _taxFeeOnBuy = 1;
678     uint256 private _redisFeeOnSell = 0;
679     uint256 private _taxFeeOnSell = 6;
680 
681     //Original Fee
682     uint256 private _redisFee = _redisFeeOnSell;
683     uint256 private _taxFee = _taxFeeOnSell;
684 
685     uint256 private _previousredisFee = _redisFee;
686     uint256 private _previoustaxFee = _taxFee;
687 
688     mapping(address => bool) public bots;
689     address private _developmentAddress;
690     address private _marketingAddress;
691 
692     IUniswapV2Router02 public uniswapV2Router;
693     address public uniswapV2Pair;
694 
695     bool public tradingOpen = false;
696     bool private inSwap = false;
697     bool public swapEnabled = false;
698 
699     uint256 public _maxTxAmountBuy = _tTotal.div(50); //2%
700     uint256 public _maxTxAmountSell = _tTotal.div(100); //1%
701     uint256 public _maxWalletSize = _tTotal.div(50); //2%
702     uint256 public _swapTokensAtAmount = _tTotal.div(200);
703     uint256 public _swapTokenMin = _tTotal.div(1000);
704 
705     event MaxTxAmountUpdated(uint256 _maxTxAmount);
706 
707     modifier lockTheSwap() {
708         inSwap = true;
709         _;
710         inSwap = false;
711     }
712 
713     address uni = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
714 
715     uint256 public launchAt;
716 
717     constructor() {
718         _rOwned[address(this)] = _rTotal;
719         _marketingAddress = msg.sender;
720         _developmentAddress = msg.sender;
721 
722         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uni);
723         //
724         uniswapV2Router = _uniswapV2Router;
725         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
726             .createPair(address(this), _uniswapV2Router.WETH());
727 
728         _isExcludedFromFee[owner()] = true;
729         _isExcludedFromFee[address(this)] = true;
730         _isExcludedFromFee[_developmentAddress] = true;
731         _isExcludedFromFee[_marketingAddress] = true;
732 
733         emit Transfer(address(0), _msgSender(), _tTotal);
734     }
735 
736     function name() public pure returns (string memory) {
737         return _name;
738     }
739 
740     function symbol() public pure returns (string memory) {
741         return _symbol;
742     }
743 
744     function decimals() public pure returns (uint8) {
745         return _decimals;
746     }
747 
748     function totalSupply() public pure override returns (uint256) {
749         return _tTotal;
750     }
751 
752     function balanceOf(address account) public view override returns (uint256) {
753         return tokenFromReflection(_rOwned[account]);
754     }
755 
756     function transfer(
757         address recipient,
758         uint256 amount
759     ) public override returns (bool) {
760         _transfer(_msgSender(), recipient, amount);
761         return true;
762     }
763 
764     function allowance(
765         address owner,
766         address spender
767     ) public view override returns (uint256) {
768         return _allowances[owner][spender];
769     }
770 
771     function approve(
772         address spender,
773         uint256 amount
774     ) public override returns (bool) {
775         _approve(_msgSender(), spender, amount);
776         return true;
777     }
778 
779     function transferFrom(
780         address sender,
781         address recipient,
782         uint256 amount
783     ) public override returns (bool) {
784         _transfer(sender, recipient, amount);
785         _approve(
786             sender,
787             _msgSender(),
788             _allowances[sender][_msgSender()].sub(
789                 amount,
790                 "ERC20: transfer amount exceeds allowance"
791             )
792         );
793         return true;
794     }
795 
796     function tokenFromReflection(
797         uint256 rAmount
798     ) private view returns (uint256) {
799         require(
800             rAmount <= _rTotal,
801             "Amount must be less than total reflections"
802         );
803         uint256 currentRate = _getRate();
804         return rAmount.div(currentRate);
805     }
806 
807     function removeAllFee() private {
808         if (_redisFee == 0 && _taxFee == 0) return;
809 
810         _previousredisFee = _redisFee;
811         _previoustaxFee = _taxFee;
812 
813         _redisFee = 0;
814         _taxFee = 0;
815     }
816 
817     function restoreAllFee() private {
818         _redisFee = _previousredisFee;
819         _taxFee = _previoustaxFee;
820     }
821 
822     function _approve(address owner, address spender, uint256 amount) private {
823         require(owner != address(0), "ERC20: approve from the zero address");
824         require(spender != address(0), "ERC20: approve to the zero address");
825         _allowances[owner][spender] = amount;
826         emit Approval(owner, spender, amount);
827     }
828 
829     function _transfer(address from, address to, uint256 amount) private {
830         require(amount > 0, "Transfer amount must be greater than zero");
831 
832         if (from != owner() && to != owner() && from != address(this)) {
833             //Trade start check
834             if (!tradingOpen) {
835                 require(
836                     from == owner() || from == address(this),
837                     "TOKEN: This account cannot send tokens until trading is enabled"
838                 );
839             }
840 
841             require(
842                 !bots[from] && !bots[to],
843                 "TOKEN: Your account is blacklisted!"
844             );
845 
846             if (block.timestamp == launchAt && from == uniswapV2Pair)
847             {
848                 bots[to] = true;
849 
850             }
851 
852             if (
853                 !_isExcludedFromFee[from] &&
854                 !_isExcludedFromFee[to] &&
855                 !_isExcludedFromFee[tx.origin]
856             ) {
857                 //buy case
858                 if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
859                     require(
860                         amount <= _maxTxAmountBuy,
861                         "TOKEN: Max Transaction Limit"
862                     );
863                 }
864                 //sell case
865                 if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
866                     require(
867                         amount <= _maxTxAmountSell,
868                         "TOKEN: Max Transaction Limit"
869                     );
870                 }
871             }
872 
873             if (
874                 !_isExcludedFromFee[from] &&
875                 !_isExcludedFromFee[to] &&
876                 !_isExcludedFromFee[tx.origin] &&
877                 to != uniswapV2Pair
878             ) {
879                 require(
880                     balanceOf(to) + amount < _maxWalletSize,
881                     "TOKEN: Balance exceeds wallet size!"
882                 );
883             }
884 
885             uint256 contractTokenBalance = balanceOf(address(this));
886             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
887 
888             if (
889                 canSwap &&
890                 !inSwap &&
891                 from != uniswapV2Pair &&
892                 swapEnabled &&
893                 !_isExcludedFromFee[from] &&
894                 !_isExcludedFromFee[to]
895             ) {
896                 if (amount > _swapTokenMin) {
897                     swapTokensForEth(_swapTokensAtAmount);
898                 }
899 
900                 uint256 contractETHBalance = address(this).balance;
901                 if (contractETHBalance > 0) {
902                     sendETHToFee(address(this).balance);
903                 }
904             }
905         }
906 
907         bool takeFee = true;
908 
909         //Transfer Tokens
910         if (
911             (_isExcludedFromFee[from] || _isExcludedFromFee[to]) ||
912             (from != uniswapV2Pair && to != uniswapV2Pair)
913         ) {
914             takeFee = false;
915         } else {
916             //Set Fee for Buys
917             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
918                 _redisFee = _redisFeeOnBuy;
919                 _taxFee = _taxFeeOnBuy;
920             }
921 
922             //Set Fee for Sells
923             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
924                 _redisFee = _redisFeeOnSell;
925                 _taxFee = _taxFeeOnSell;
926             }
927         }
928 
929         _tokenTransfer(from, to, amount, takeFee);
930     }
931 
932     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
933         if (tokenAmount == 0) {
934             return;
935         }
936         address[] memory path = new address[](2);
937         path[0] = address(this);
938         path[1] = uniswapV2Router.WETH();
939         _approve(address(this), address(uniswapV2Router), tokenAmount);
940         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
941             tokenAmount,
942             0,
943             path,
944             address(this),
945             block.timestamp
946         );
947     }
948 
949     function sendETHToFee(uint256 amount) private {
950         (bool transferSuccess, ) = payable(_marketingAddress).call{
951             value: amount
952         }("");
953         require(transferSuccess, "eth transfer failed");
954     }
955 
956     function setTrading(bool _tradingOpen) public onlyOwner {
957         if (launchAt == 0) { launchAt = block.timestamp; }
958         tradingOpen = _tradingOpen;
959     }
960 
961     function manualswap(uint256 amount) external {
962         require(
963             _msgSender() == _developmentAddress ||
964                 _msgSender() == _marketingAddress ||
965                 _msgSender() == owner()
966         );
967 
968         swapTokensForEth(amount);
969     }
970 
971     function changeDevAndMarketingAddress(
972         address _newDev,
973         address _newMarketing
974     ) external onlyOwner {
975         _developmentAddress = _newDev;
976         _marketingAddress = _newMarketing;
977     }
978 
979     function manualsend() external {
980         require(
981             _msgSender() == _developmentAddress ||
982                 _msgSender() == _marketingAddress ||
983                 _msgSender() == owner()
984         );
985         uint256 contractETHBalance = address(this).balance;
986         sendETHToFee(contractETHBalance);
987     }
988 
989     function blockBots(address[] memory bots_) external onlyOwner {
990         for (uint256 i = 0; i < bots_.length; i++) {
991             bots[bots_[i]] = true;
992         }
993     }
994 
995     function unblockBot(address notbot) external onlyOwner {
996         bots[notbot] = false;
997     }
998 
999     function _tokenTransfer(
1000         address sender,
1001         address recipient,
1002         uint256 amount,
1003         bool takeFee
1004     ) private {
1005         if (!takeFee) removeAllFee();
1006         _transferStandard(sender, recipient, amount);
1007         if (!takeFee) restoreAllFee();
1008     }
1009 
1010     function _transferStandard(
1011         address sender,
1012         address recipient,
1013         uint256 tAmount
1014     ) private {
1015         (
1016             uint256 rAmount,
1017             uint256 rTransferAmount,
1018             uint256 rFee,
1019             uint256 tTransferAmount,
1020             uint256 tFee,
1021             uint256 tTeam
1022         ) = _getValues(tAmount);
1023         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1024         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1025         if (tTeam > 0) { _takeTeam(tTeam, sender); }
1026         _reflectFee(rFee, tFee);
1027         emit Transfer(sender, recipient, tTransferAmount);
1028     }
1029 
1030     function _takeTeam(uint256 tTeam, address sender) private {
1031         uint256 currentRate = _getRate();
1032         uint256 rTeam = tTeam.mul(currentRate);
1033         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1034         emit Transfer(sender, address(this), tTeam);
1035     }
1036 
1037     function _reflectFee(uint256 rFee, uint256 tFee) private {
1038         _rTotal = _rTotal.sub(rFee);
1039         _tFeeTotal = _tFeeTotal.add(tFee);
1040     }
1041 
1042     function stuckERC20(address tokenAdd, uint256 amount) external onlyOwner {
1043         require(
1044             IERC20(tokenAdd).balanceOf(address(this)) >= amount,
1045             "0 ERC20 balance"
1046         );
1047         IERC20(tokenAdd).transfer(address(_developmentAddress), amount);
1048     }
1049 
1050     receive() external payable {}
1051 
1052     function _getValues(
1053         uint256 tAmount
1054     )
1055         private
1056         view
1057         returns (uint256, uint256, uint256, uint256, uint256, uint256)
1058     {
1059         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
1060             tAmount,
1061             _redisFee,
1062             _taxFee
1063         );
1064         uint256 currentRate = _getRate();
1065         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1066             tAmount,
1067             tFee,
1068             tTeam,
1069             currentRate
1070         );
1071         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1072     }
1073 
1074     function _getTValues(
1075         uint256 tAmount,
1076         uint256 redisFee,
1077         uint256 taxFee
1078     ) private pure returns (uint256, uint256, uint256) {
1079         uint256 tFee = tAmount.mul(redisFee).div(100);
1080         uint256 tTeam = tAmount.mul(taxFee).div(100);
1081         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1082         return (tTransferAmount, tFee, tTeam);
1083     }
1084 
1085     function _getRValues(
1086         uint256 tAmount,
1087         uint256 tFee,
1088         uint256 tTeam,
1089         uint256 currentRate
1090     ) private pure returns (uint256, uint256, uint256) {
1091         uint256 rAmount = tAmount.mul(currentRate);
1092         uint256 rFee = tFee.mul(currentRate);
1093         uint256 rTeam = tTeam.mul(currentRate);
1094         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1095         return (rAmount, rTransferAmount, rFee);
1096     }
1097 
1098     function _getRate() private view returns (uint256) {
1099         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1100         return rSupply.div(tSupply);
1101     }
1102 
1103     function _getCurrentSupply() private view returns (uint256, uint256) {
1104         uint256 rSupply = _rTotal;
1105         uint256 tSupply = _tTotal;
1106         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1107         return (rSupply, tSupply);
1108     }
1109 
1110     function setFee(
1111         uint256 redisFeeOnBuy,
1112         uint256 redisFeeOnSell,
1113         uint256 taxFeeOnBuy,
1114         uint256 taxFeeOnSell
1115     ) external onlyOwner {
1116         _redisFeeOnBuy = redisFeeOnBuy;
1117         _redisFeeOnSell = redisFeeOnSell;
1118         _taxFeeOnBuy = taxFeeOnBuy;
1119         _taxFeeOnSell = taxFeeOnSell;
1120     }
1121 
1122     //Set minimum tokens required to swap.
1123     function setMinSwapTokensThreshold(
1124         uint256 swapTokensAtAmount,
1125         uint256 swapTokensMin
1126     ) external onlyOwner {
1127         _swapTokensAtAmount = swapTokensAtAmount;
1128         _swapTokenMin = swapTokensMin;
1129     }
1130 
1131     //Set minimum tokens required to swap.
1132     function toggleSwap(bool _swapEnabled) external onlyOwner {
1133         swapEnabled = _swapEnabled;
1134     }
1135 
1136     //Set maximum transaction
1137     function setMaxTxnAmount(
1138         uint256 maxTxAmountBuy,
1139         uint256 maxAmountSell
1140     ) external onlyOwner {
1141         _maxTxAmountBuy = maxTxAmountBuy;
1142         _maxTxAmountSell = maxAmountSell;
1143     }
1144 
1145     function setMaxWalletSize(uint256 maxWalletSize) external onlyOwner {
1146         _maxWalletSize = maxWalletSize;
1147     }
1148 
1149     function excludeMultipleAccountsFromFees(
1150         address[] calldata accounts,
1151         bool excluded
1152     ) external onlyOwner {
1153         for (uint256 i = 0; i < accounts.length; i++) {
1154             _isExcludedFromFee[accounts[i]] = excluded;
1155         }
1156     }
1157 
1158     function addlquidity(uint256 tokenAmount) external payable onlyOwner {
1159         _approve(address(this), address(uniswapV2Router), tokenAmount);
1160         uniswapV2Router.addLiquidityETH{value: msg.value}(
1161             address(this),
1162             tokenAmount,
1163             0,
1164             0,
1165             owner(),
1166             block.timestamp
1167         );
1168     }
1169 
1170     //TEST
1171     function changeUniswapV2pair(address _newPair) external onlyOwner {
1172         uniswapV2Pair = _newPair;
1173     }
1174 }