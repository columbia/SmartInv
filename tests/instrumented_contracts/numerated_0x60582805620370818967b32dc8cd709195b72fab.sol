1 /*
2  * Fire Inu (FINU)
3  *
4  * Anon fork with adjusted tokenomics.
5  *
6  * Locking Liquidity.
7  *
8  * Total Supply: 100,000,000,000,000
9  * Max Buy: 690,000,000,000 (0.69% of Total Supply)
10  * Max Hold: 2,100,000,000,000 (2.1% of Total Supply)
11  *
12  * READ THIS CAREFULLY:
13  * The starting taxes will be as follows and may change based on the community vote
14  * Sell within 1 day   : 32% tax  (0% burn, 32% Liquidity, 0% Holders)
15  * Sell within 3 days  : 30% tax  (4% burn, 20% Liquidity, 6% Holders)
16  * Sell within 3 weeks : 20% tax  (6% burn, 10% Liquidity, 4% Holders)
17  * Standard            : 8% tax  (6% burn,  0% Liquidity, 2% Holders)
18  *
19  * https://fireinu.com
20  * https://t.me/FireInuToken
21  *
22  */
23 
24 pragma solidity ^0.6.12;
25 
26 // SPDX-License-Identifier: The MIT License
27 
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the token decimals. (extra from BEP20)
36      */
37     function decimals() external view returns (uint8);
38 
39     /**
40      * @dev Returns the token symbol.
41      */
42     function symbol() external view returns (string memory);
43 
44     /**
45      * @dev Returns the token name. (extra from BEP20)
46      */
47     function name() external view returns (string memory);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount)
62         external
63         returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address _owner, address spender)
73         external
74         view
75         returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `sender` to `recipient` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address sender,
104         address recipient,
105         uint256 amount
106     ) external returns (bool);
107 
108     /**
109      * @dev Emitted when `value` tokens are moved from one account (`from`) to
110      * another (`to`).
111      *
112      * Note that `value` may be zero.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116     /**
117      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
118      * a call to {approve}. `value` is the new allowance.
119      */
120     event Approval(
121         address indexed owner,
122         address indexed spender,
123         uint256 value
124     );
125 }
126 
127 /*
128  * @dev Provides information about the current execution context, including the
129  * sender of the transaction and its data. While these are generally available
130  * via msg.sender and msg.data, they should not be accessed in such a direct
131  * manner, since when dealing with GSN meta-transactions the account sending and
132  * paying for execution may not be the actual sender (as far as an application
133  * is concerned).
134  *
135  * This contract is only required for intermediate, library-like contracts.
136  */
137 contract Context {
138     // Empty internal constructor, to prevent people from mistakenly deploying
139     // an instance of this contract, which should be used via inheritance.
140     constructor() internal {}
141 
142     function _msgSender() internal view returns (address payable) {
143         return msg.sender;
144     }
145 
146     function _msgData() internal view returns (bytes memory) {
147         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
148         return msg.data;
149     }
150 }
151 
152 /**
153  * @dev Wrappers over Solidity's arithmetic operations with added overflow
154  * checks.
155  *
156  * Arithmetic operations in Solidity wrap on overflow. This can easily result
157  * in bugs, because programmers usually assume that an overflow raises an
158  * error, which is the standard behavior in high level programming languages.
159  * `SafeMath` restores this intuition by reverting the transaction when an
160  * operation overflows.
161  *
162  * Using this library instead of the unchecked operations eliminates an entire
163  * class of bugs, so it's recommended to use it always.
164  */
165 library SafeMath {
166     /**
167      * @dev Returns the addition of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `+` operator.
171      *
172      * Requirements:
173      * - Addition cannot overflow.
174      */
175     function add(uint256 a, uint256 b) internal pure returns (uint256) {
176         uint256 c = a + b;
177         require(c >= a, "SafeMath: addition overflow");
178         return c;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting on
183      * overflow (when the result is negative).
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         return sub(a, b, "SafeMath: subtraction overflow");
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      * - Subtraction cannot overflow.
202      */
203     function sub(
204         uint256 a,
205         uint256 b,
206         string memory errorMessage
207     ) internal pure returns (uint256) {
208         require(b <= a, errorMessage);
209         uint256 c = a - b;
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the multiplication of two unsigned integers, reverting on
216      * overflow.
217      *
218      * Counterpart to Solidity's `*` operator.
219      *
220      * Requirements:
221      * - Multiplication cannot overflow.
222      */
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
225         // benefit is lost if 'b' is also tested.
226         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
227         if (a == 0) {
228             return 0;
229         }
230 
231         uint256 c = a * b;
232         require(c / a == b, "SafeMath: multiplication overflow");
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers. Reverts on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         return div(a, b, "SafeMath: division by zero");
250     }
251 
252     /**
253      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
254      * division by zero. The result is rounded towards zero.
255      *
256      * Counterpart to Solidity's `/` operator. Note: this function uses a
257      * `revert` opcode (which leaves remaining gas untouched) while Solidity
258      * uses an invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      * - The divisor cannot be zero.
262      */
263     function div(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         // Solidity only automatically asserts when dividing by 0
269         require(b > 0, errorMessage);
270         uint256 c = a / b;
271         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * Reverts when dividing by zero.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
288         return mod(a, b, "SafeMath: modulo by zero");
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts with custom message when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function mod(
303         uint256 a,
304         uint256 b,
305         string memory errorMessage
306     ) internal pure returns (uint256) {
307         require(b != 0, errorMessage);
308         return a % b;
309     }
310 }
311 
312 /**
313  * @dev Contract module which provides a basic access control mechanism, where
314  * there is an account (an owner) that can be granted exclusive access to
315  * specific functions.
316  *
317  * By default, the owner account will be the one that deploys the contract. This
318  * can later be changed with {transferOwnership}.
319  *
320  * Owner Validation:
321  * VsLbhPbclGuvfYvarBsS!E3!AHLbherNFuvgQriJubQbrfagPurpxBirePbqr
322  *
323  * This module is used through inheritance. It will make available the modifier
324  * `onlyOwner`, which can be applied to your functions to restrict their use to
325  * the owner.
326  */
327 contract Ownable is Context {
328     address private _owner;
329 
330     event OwnershipTransferred(
331         address indexed previousOwner,
332         address indexed newOwner
333     );
334 
335     /**
336      * @dev Initializes the contract setting the deployer as the initial owner.
337      */
338     constructor() internal {
339         address msgSender = _msgSender();
340         _owner = msgSender;
341         emit OwnershipTransferred(address(0), msgSender);
342     }
343 
344     /**
345      * @dev Returns the address of the current owner.
346      */
347     function owner() public view returns (address) {
348         return _owner;
349     }
350 
351     /**
352      * @dev Throws if called by any account other than the owner.
353      */
354     modifier onlyOwner() {
355         require(_owner == _msgSender(), "Ownable: caller is not the owner");
356         _;
357     }
358 
359     /**
360      * @dev Leaves the contract without owner. It will not be possible to call
361      * `onlyOwner` functions anymore. Can only be called by the current owner.
362      *
363      * NOTE: Renouncing ownership will leave the contract without an owner,
364      * thereby removing any functionality that is only available to the owner.
365      */
366     function renounceOwnership() public onlyOwner {
367         emit OwnershipTransferred(_owner, address(0));
368         _owner = address(0);
369     }
370 
371     /**
372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
373      * Can only be called by the current owner.
374      */
375     function transferOwnership(address newOwner) public onlyOwner {
376         _transferOwnership(newOwner);
377     }
378 
379     /**
380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
381      */
382     function _transferOwnership(address newOwner) internal {
383         require(
384             newOwner != address(0),
385             "Ownable: new owner is the zero address"
386         );
387         emit OwnershipTransferred(_owner, newOwner);
388         _owner = newOwner;
389     }
390 }
391 
392 pragma solidity >=0.6.2;
393 
394 interface IUniswapV2Router01 {
395     function factory() external pure returns (address);
396 
397     function WETH() external pure returns (address);
398 
399     function addLiquidity(
400         address tokenA,
401         address tokenB,
402         uint256 amountADesired,
403         uint256 amountBDesired,
404         uint256 amountAMin,
405         uint256 amountBMin,
406         address to,
407         uint256 deadline
408     )
409         external
410         returns (
411             uint256 amountA,
412             uint256 amountB,
413             uint256 liquidity
414         );
415 
416     function addLiquidityETH(
417         address token,
418         uint256 amountTokenDesired,
419         uint256 amountTokenMin,
420         uint256 amountETHMin,
421         address to,
422         uint256 deadline
423     )
424         external
425         payable
426         returns (
427             uint256 amountToken,
428             uint256 amountETH,
429             uint256 liquidity
430         );
431 
432     function removeLiquidity(
433         address tokenA,
434         address tokenB,
435         uint256 liquidity,
436         uint256 amountAMin,
437         uint256 amountBMin,
438         address to,
439         uint256 deadline
440     ) external returns (uint256 amountA, uint256 amountB);
441 
442     function removeLiquidityETH(
443         address token,
444         uint256 liquidity,
445         uint256 amountTokenMin,
446         uint256 amountETHMin,
447         address to,
448         uint256 deadline
449     ) external returns (uint256 amountToken, uint256 amountETH);
450 
451     function removeLiquidityWithPermit(
452         address tokenA,
453         address tokenB,
454         uint256 liquidity,
455         uint256 amountAMin,
456         uint256 amountBMin,
457         address to,
458         uint256 deadline,
459         bool approveMax,
460         uint8 v,
461         bytes32 r,
462         bytes32 s
463     ) external returns (uint256 amountA, uint256 amountB);
464 
465     function removeLiquidityETHWithPermit(
466         address token,
467         uint256 liquidity,
468         uint256 amountTokenMin,
469         uint256 amountETHMin,
470         address to,
471         uint256 deadline,
472         bool approveMax,
473         uint8 v,
474         bytes32 r,
475         bytes32 s
476     ) external returns (uint256 amountToken, uint256 amountETH);
477 
478     function swapExactTokensForTokens(
479         uint256 amountIn,
480         uint256 amountOutMin,
481         address[] calldata path,
482         address to,
483         uint256 deadline
484     ) external returns (uint256[] memory amounts);
485 
486     function swapTokensForExactTokens(
487         uint256 amountOut,
488         uint256 amountInMax,
489         address[] calldata path,
490         address to,
491         uint256 deadline
492     ) external returns (uint256[] memory amounts);
493 
494     function swapExactETHForTokens(
495         uint256 amountOutMin,
496         address[] calldata path,
497         address to,
498         uint256 deadline
499     ) external payable returns (uint256[] memory amounts);
500 
501     function swapTokensForExactETH(
502         uint256 amountOut,
503         uint256 amountInMax,
504         address[] calldata path,
505         address to,
506         uint256 deadline
507     ) external returns (uint256[] memory amounts);
508 
509     function swapExactTokensForETH(
510         uint256 amountIn,
511         uint256 amountOutMin,
512         address[] calldata path,
513         address to,
514         uint256 deadline
515     ) external returns (uint256[] memory amounts);
516 
517     function swapETHForExactTokens(
518         uint256 amountOut,
519         address[] calldata path,
520         address to,
521         uint256 deadline
522     ) external payable returns (uint256[] memory amounts);
523 
524     function quote(
525         uint256 amountA,
526         uint256 reserveA,
527         uint256 reserveB
528     ) external pure returns (uint256 amountB);
529 
530     function getAmountOut(
531         uint256 amountIn,
532         uint256 reserveIn,
533         uint256 reserveOut
534     ) external pure returns (uint256 amountOut);
535 
536     function getAmountIn(
537         uint256 amountOut,
538         uint256 reserveIn,
539         uint256 reserveOut
540     ) external pure returns (uint256 amountIn);
541 
542     function getAmountsOut(uint256 amountIn, address[] calldata path)
543         external
544         view
545         returns (uint256[] memory amounts);
546 
547     function getAmountsIn(uint256 amountOut, address[] calldata path)
548         external
549         view
550         returns (uint256[] memory amounts);
551 }
552 
553 // File: contracts\interfaces\IUniswapV2Router02.sol
554 
555 pragma solidity >=0.6.2;
556 
557 interface IUniswapV2Router02 is IUniswapV2Router01 {
558     function removeLiquidityETHSupportingFeeOnTransferTokens(
559         address token,
560         uint256 liquidity,
561         uint256 amountTokenMin,
562         uint256 amountETHMin,
563         address to,
564         uint256 deadline
565     ) external returns (uint256 amountETH);
566 
567     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
568         address token,
569         uint256 liquidity,
570         uint256 amountTokenMin,
571         uint256 amountETHMin,
572         address to,
573         uint256 deadline,
574         bool approveMax,
575         uint8 v,
576         bytes32 r,
577         bytes32 s
578     ) external returns (uint256 amountETH);
579 
580     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
581         uint256 amountIn,
582         uint256 amountOutMin,
583         address[] calldata path,
584         address to,
585         uint256 deadline
586     ) external;
587 
588     function swapExactETHForTokensSupportingFeeOnTransferTokens(
589         uint256 amountOutMin,
590         address[] calldata path,
591         address to,
592         uint256 deadline
593     ) external payable;
594 
595     function swapExactTokensForETHSupportingFeeOnTransferTokens(
596         uint256 amountIn,
597         uint256 amountOutMin,
598         address[] calldata path,
599         address to,
600         uint256 deadline
601     ) external;
602 }
603 
604 pragma solidity >=0.5.0;
605 
606 interface IUniswapV2Factory {
607     event PairCreated(
608         address indexed token0,
609         address indexed token1,
610         address pair,
611         uint256
612     );
613 
614     function feeTo() external view returns (address);
615 
616     function feeToSetter() external view returns (address);
617 
618     function getPair(address tokenA, address tokenB)
619         external
620         view
621         returns (address pair);
622 
623     function allPairs(uint256) external view returns (address pair);
624 
625     function allPairsLength() external view returns (uint256);
626 
627     function createPair(address tokenA, address tokenB)
628         external
629         returns (address pair);
630 
631     function setFeeTo(address) external;
632 
633     function setFeeToSetter(address) external;
634 
635     function INIT_CODE_PAIR_HASH() external view returns (bytes32);
636 }
637 
638 pragma solidity >=0.5.0;
639 
640 interface IUniswapPair {
641     event Approval(
642         address indexed owner,
643         address indexed spender,
644         uint256 value
645     );
646     event Transfer(address indexed from, address indexed to, uint256 value);
647 
648     function name() external pure returns (string memory);
649 
650     function symbol() external pure returns (string memory);
651 
652     function decimals() external pure returns (uint8);
653 
654     function totalSupply() external view returns (uint256);
655 
656     function balanceOf(address owner) external view returns (uint256);
657 
658     function allowance(address owner, address spender)
659         external
660         view
661         returns (uint256);
662 
663     function approve(address spender, uint256 value) external returns (bool);
664 
665     function transfer(address to, uint256 value) external returns (bool);
666 
667     function transferFrom(
668         address from,
669         address to,
670         uint256 value
671     ) external returns (bool);
672 
673     function DOMAIN_SEPARATOR() external view returns (bytes32);
674 
675     function PERMIT_TYPEHASH() external pure returns (bytes32);
676 
677     function nonces(address owner) external view returns (uint256);
678 
679     function permit(
680         address owner,
681         address spender,
682         uint256 value,
683         uint256 deadline,
684         uint8 v,
685         bytes32 r,
686         bytes32 s
687     ) external;
688 
689     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
690     event Burn(
691         address indexed sender,
692         uint256 amount0,
693         uint256 amount1,
694         address indexed to
695     );
696     event Swap(
697         address indexed sender,
698         uint256 amount0In,
699         uint256 amount1In,
700         uint256 amount0Out,
701         uint256 amount1Out,
702         address indexed to
703     );
704     event Sync(uint112 reserve0, uint112 reserve1);
705 
706     function MINIMUM_LIQUIDITY() external pure returns (uint256);
707 
708     function factory() external view returns (address);
709 
710     function token0() external view returns (address);
711 
712     function token1() external view returns (address);
713 
714     function getReserves()
715         external
716         view
717         returns (
718             uint112 reserve0,
719             uint112 reserve1,
720             uint32 blockTimestampLast
721         );
722 
723     function price0CumulativeLast() external view returns (uint256);
724 
725     function price1CumulativeLast() external view returns (uint256);
726 
727     function kLast() external view returns (uint256);
728 
729     function mint(address to) external returns (uint256 liquidity);
730 
731     function burn(address to)
732         external
733         returns (uint256 amount0, uint256 amount1);
734 
735     function swap(
736         uint256 amount0Out,
737         uint256 amount1Out,
738         address to,
739         bytes calldata data
740     ) external;
741 
742     function skim(address to) external;
743 
744     function sync() external;
745 
746     function initialize(address, address) external;
747 }
748 
749 contract FireInu is Context, IERC20, Ownable {
750     // Interfaces are from sister chain ^^. Kept it the same for simplicity
751     using SafeMath for uint256;
752 
753     mapping(address => uint256) private _rOwned;
754     mapping(address => uint256) private _tOwned;
755     mapping(address => mapping(address => uint256)) private _allowances;
756 
757     mapping(address => bool) private _isExcludedFromFee;
758 
759     uint256 private constant HOUR = 60 * 60;
760     uint256 private constant MAX = ~uint256(0);
761     bool inSwapAndLiquify;
762 
763     uint256 private _tTotal = 100 * 10**12 * 10**18; // 100 Trillion
764     uint256 private _rTotal = (MAX - (MAX % _tTotal));
765     uint256 private _tFeeTotal;
766     uint256 public _maxTxAmount = 690 * 10**9 * 10**18; // Max Transaction: 690 Billion (0.69%)
767     uint256 public _numTokensSellToAddToLiquidity = 300 * 10**9 * 10**18; // 300 Billion
768     uint256 public _maxWalletToken = 2.1 * 10**12 * 10**18; // Max Wallet: 2.1 Trillion (2.1%)
769 
770     // Fees
771     uint256 public _burnFee = 2 * 10**2; // 200 = 2.00%
772     uint256 public _liquidityFee = 2 * 10**2; // 200 = 2.00%
773     uint256 public _holderFee = 2 * 10**2; // 200 = 2.00%
774     uint256 public _previousBurnFee = _burnFee;
775     uint256 public _previousLiquidityFee = _liquidityFee;
776     uint256 public _previousHolderFee = _holderFee;
777     uint256[] public _taxTiers = [24, 72, 504]; // 24 = 1 day, 72 = 3 days, 504 = 3 weeks
778 
779     IUniswapV2Router02 public immutable uniswapV2Router;
780     address public immutable uniswapV2Pair;
781 
782     string private _name = "FireInu";
783     string private _symbol = "FINU";
784     uint8 private _decimals = 18;
785     uint256 private _start_timestamp = block.timestamp;
786 
787     event SwapAndLiquify(
788         uint256 tokensSwapped,
789         uint256 ethReceived,
790         uint256 tokensIntoLiqudity,
791         uint256 contractTokenBalance
792     );
793 
794     constructor() public {
795         _rOwned[_msgSender()] = _rTotal;
796         _isExcludedFromFee[owner()] = true;
797         _isExcludedFromFee[address(this)] = true;
798 
799         IUniswapV2Router02 _uniswapswapV2Router =
800             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
801         // Create a uniswap pair for this new token
802         uniswapV2Pair = IUniswapV2Factory(_uniswapswapV2Router.factory())
803             .createPair(address(this), _uniswapswapV2Router.WETH());
804         uniswapV2Router = _uniswapswapV2Router;
805 
806         emit Transfer(address(0), _msgSender(), _tTotal);
807     }
808 
809     modifier lockTheSwap {
810         inSwapAndLiquify = true;
811         _;
812         inSwapAndLiquify = false;
813     }
814 
815     // This section allows for adjust tokenomics
816 
817     /*
818      * newStartTimestamp: in seconds
819      */
820     function resetStartTimestamp(uint256 newStartTimestamp) public onlyOwner {
821         _start_timestamp = newStartTimestamp;
822     }
823 
824     /*
825      * newBurnFee: 200 = 2.00%
826      */
827     function setBurnFee(uint256 newBurnFee) public onlyOwner {
828         require(newBurnFee <= _burnFee);
829         _burnFee = newBurnFee;
830     }
831 
832     /*
833      * newLiquidityFee: 200 = 2.00%
834      */
835     function setLiquidityFee(uint256 newLiquidityFee) public onlyOwner {
836         require(newLiquidityFee <= _liquidityFee);
837         _liquidityFee = newLiquidityFee;
838     }
839 
840     /*
841      * newHolderFee: 200 = 2.00%
842      */
843     function setHolderFee(uint256 newHolderFee) public onlyOwner {
844         require(newHolderFee <= _holderFee);
845         _holderFee = newHolderFee;
846     }
847 
848     /*
849      * newHours: in hours
850      */
851     function setTier(uint256 count, uint256 newHours) public onlyOwner {
852         require(count < _taxTiers.length);
853         _taxTiers[count] = newHours;
854     }
855 
856     /*
857      * newNum: 300 * 10**9 * 10**18 = 300 Billion
858      */
859     function setNumTokensSellToAddToLiquidity(uint256 newNum) public onlyOwner {
860         require(newNum <= _numTokensSellToAddToLiquidity);
861         _numTokensSellToAddToLiquidity = newNum;
862     }
863 
864     function toggleExcludedFromFee(address account) public onlyOwner {
865         _isExcludedFromFee[account] = !_isExcludedFromFee[account];
866     }
867 
868     // Getters
869 
870     function name() public view override returns (string memory) {
871         return _name;
872     }
873 
874     function symbol() public view override returns (string memory) {
875         return _symbol;
876     }
877 
878     function decimals() public view override returns (uint8) {
879         return _decimals;
880     }
881 
882     function totalSupply() public view override returns (uint256) {
883         return _tTotal;
884     }
885 
886     function startTimestampForTax() public view returns (uint256) {
887         return _start_timestamp;
888     }
889 
890     function burnPercent() public view returns (uint256) {
891         return _getCurrentBurnFee();
892     }
893 
894     function liquidityPercent() public view returns (uint256) {
895         return _getCurrentLiqFee();
896     }
897 
898     function holderPercent() public view returns (uint256) {
899         return _getCurrentHolderFee();
900     }
901 
902     function isExcludedFromFee(address account) public view returns (bool) {
903         return _isExcludedFromFee[account];
904     }
905 
906     /*
907      * Wen tier end in seconds from epoc
908      */
909     function wenTierEnd(uint256 count) public view returns (uint256) {
910         require(count < _taxTiers.length);
911         return _start_timestamp + (_taxTiers[count] * HOUR);
912     }
913 
914     function numTokensSellToAddToLiquidity() public view returns (uint256) {
915         return _numTokensSellToAddToLiquidity;
916     }
917 
918     function balanceOf(address account) public view override returns (uint256) {
919         return tokenFromReflection(_rOwned[account]);
920     }
921 
922     function pSolHoldAME() public pure returns (string memory) {
923         return "LbherNFuvgQriJubQbrfagPurpxBirePbqrVsAbgS!ER!Ah";
924     }
925 
926     // Getters
927 
928     function transfer(address recipient, uint256 amount)
929         public
930         override
931         returns (bool)
932     {
933         _transfer(_msgSender(), recipient, amount);
934         return true;
935     }
936 
937     function allowance(address owner, address spender)
938         public
939         view
940         override
941         returns (uint256)
942     {
943         return _allowances[owner][spender];
944     }
945 
946     function approve(address spender, uint256 amount)
947         public
948         override
949         returns (bool)
950     {
951         _approve(_msgSender(), spender, amount);
952         return true;
953     }
954 
955     function transferFrom(
956         address sender,
957         address recipient,
958         uint256 amount
959     ) public override returns (bool) {
960         _transfer(sender, recipient, amount);
961         _approve(
962             sender,
963             _msgSender(),
964             _allowances[sender][_msgSender()].sub(
965                 amount,
966                 "ERC20: transfer amount exceeds allowance"
967             )
968         );
969         return true;
970     }
971 
972     function increaseAllowance(address spender, uint256 addedValue)
973         public
974         virtual
975         returns (bool)
976     {
977         _approve(
978             _msgSender(),
979             spender,
980             _allowances[_msgSender()][spender].add(addedValue)
981         );
982         return true;
983     }
984 
985     function decreaseAllowance(address spender, uint256 subtractedValue)
986         public
987         virtual
988         returns (bool)
989     {
990         _approve(
991             _msgSender(),
992             spender,
993             _allowances[_msgSender()][spender].sub(
994                 subtractedValue,
995                 "ERC20: decreased allowance below zero"
996             )
997         );
998         return true;
999     }
1000 
1001     function totalFees() public view returns (uint256) {
1002         return _tFeeTotal;
1003     }
1004 
1005     function reflect(uint256 tAmount) public {
1006         address sender = _msgSender();
1007         (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1008         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1009         _rTotal = _rTotal.sub(rAmount);
1010         _tFeeTotal = _tFeeTotal.add(tAmount);
1011     }
1012 
1013     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1014         public
1015         view
1016         returns (uint256)
1017     {
1018         require(tAmount <= _tTotal, "Amount must be less than supply");
1019         if (!deductTransferFee) {
1020             (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1021             return rAmount;
1022         } else {
1023             (, uint256 rTransferAmount, , , , , ) = _getValues(tAmount);
1024             return rTransferAmount;
1025         }
1026     }
1027 
1028     function tokenFromReflection(uint256 rAmount)
1029         public
1030         view
1031         returns (uint256)
1032     {
1033         require(
1034             rAmount <= _rTotal,
1035             "Amount must be less than total reflections"
1036         );
1037         uint256 currentRate = _getRate();
1038         return rAmount.div(currentRate);
1039     }
1040 
1041     function _approve(
1042         address owner,
1043         address spender,
1044         uint256 amount
1045     ) private {
1046         require(owner != address(0), "ERC20: approve from the zero address");
1047         require(spender != address(0), "ERC20: approve to the zero address");
1048 
1049         _allowances[owner][spender] = amount;
1050         emit Approval(owner, spender, amount);
1051     }
1052 
1053     function removeAllFee() private {
1054         if (_burnFee == 0 && _holderFee == 0 && _liquidityFee == 0) return;
1055 
1056         _previousBurnFee = _burnFee;
1057         _previousHolderFee = _holderFee;
1058         _previousLiquidityFee = _liquidityFee;
1059 
1060         _burnFee = 0;
1061         _holderFee = 0;
1062         _liquidityFee = 0;
1063     }
1064 
1065     function restoreAllFee() private {
1066         _burnFee = _previousBurnFee;
1067         _holderFee = _previousHolderFee;
1068         _liquidityFee = _previousLiquidityFee;
1069     }
1070 
1071     function _transfer(
1072         address sender,
1073         address recipient,
1074         uint256 amount
1075     ) private {
1076         require(sender != address(0), "ERC20: transfer from the zero address");
1077         require(recipient != address(0), "ERC20: transfer to the zero address");
1078         require(amount > 0, "Transfer amount must be greater than zero");
1079         if (
1080             sender != owner() &&
1081             recipient != owner() &&
1082             recipient != address(1) &&
1083             recipient != address(0xdead) &&
1084             recipient != uniswapV2Pair
1085         ) {
1086             require(
1087                 amount <= _maxTxAmount,
1088                 "Transfer amount exceeds the maxTxAmount."
1089             );
1090             uint256 contractBalanceRecepient = balanceOf(recipient);
1091             require(
1092                 contractBalanceRecepient + amount <= _maxWalletToken,
1093                 "Exceeds maximum wallet token amount."
1094             );
1095         }
1096 
1097         // is the token balance of this contract address over the min number of
1098         // tokens that we need to initiate a swap + liquidity lock?
1099         // also, don't get caught in a circular liquidity event.
1100         // also, don't swap & liquify if sender is uniswap pair.
1101         uint256 contractTokenBalance = balanceOf(address(this));
1102 
1103         if (contractTokenBalance >= _maxTxAmount) {
1104             contractTokenBalance = _maxTxAmount;
1105         }
1106 
1107         bool overMinTokenBalance =
1108             contractTokenBalance >= _numTokensSellToAddToLiquidity;
1109         if (
1110             overMinTokenBalance && !inSwapAndLiquify && sender != uniswapV2Pair
1111         ) {
1112             contractTokenBalance = _numTokensSellToAddToLiquidity;
1113             swapAndLiquify(contractTokenBalance);
1114         }
1115 
1116         bool takeFee = true;
1117 
1118         //if any account belongs to _isExcludedFromFee account then remove the fee
1119         if (
1120             _isExcludedFromFee[sender] ||
1121             _isExcludedFromFee[recipient] ||
1122             sender == uniswapV2Pair
1123         ) {
1124             takeFee = false;
1125         }
1126 
1127         if (!takeFee) removeAllFee();
1128 
1129         _transferStandard(sender, recipient, amount);
1130 
1131         if (!takeFee) restoreAllFee();
1132     }
1133 
1134     function _transferStandard(
1135         address sender,
1136         address recipient,
1137         uint256 tAmount
1138     ) private {
1139         (
1140             uint256 rAmount,
1141             uint256 rTransferAmount,
1142             uint256 rFee,
1143             uint256 tTransferAmount,
1144             uint256 tFee,
1145             uint256 tLiquidity,
1146             uint256 tBurn
1147         ) = _getValues(tAmount);
1148         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1149         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1150         _takeLiquidity(tLiquidity);
1151         _reflectFee(rFee, tFee);
1152 
1153         if (tBurn > 0) _reflectBurn(sender, tBurn);
1154         emit Transfer(sender, recipient, tTransferAmount);
1155     }
1156 
1157     function _reflectBurn(address sender, uint256 tBurn) private {
1158         _rOwned[address(0xdead)] = _rOwned[address(0xdead)].add(tBurn);
1159         _tTotal = _tTotal.sub(tBurn);
1160         _rTotal = _rTotal.sub(tBurn);
1161         emit Transfer(sender, address(0xdead), tBurn);
1162     }
1163 
1164     function _reflectFee(uint256 rFee, uint256 tFee) private {
1165         _rTotal = _rTotal.sub(rFee);
1166         _tFeeTotal = _tFeeTotal.add(tFee);
1167     }
1168 
1169     function _getValues(uint256 tAmount)
1170         private
1171         view
1172         returns (
1173             uint256,
1174             uint256,
1175             uint256,
1176             uint256,
1177             uint256,
1178             uint256,
1179             uint256
1180         )
1181     {
1182         (
1183             uint256 tTransferAmount,
1184             uint256 tFee,
1185             uint256 tLiquidity,
1186             uint256 tBurn
1187         ) = _getTValues(tAmount);
1188         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
1189             _getRValues(tAmount, tFee, tLiquidity, tBurn, _getRate());
1190         return (
1191             rAmount,
1192             rTransferAmount,
1193             rFee,
1194             tTransferAmount,
1195             tFee,
1196             tLiquidity,
1197             tBurn
1198         );
1199     }
1200 
1201     function _getCurrentBurnFee() private view returns (uint256) {
1202         uint256 time_since_start = block.timestamp - _start_timestamp;
1203         if (time_since_start < _taxTiers[0] * HOUR) {
1204             return _burnFee.mul(0);
1205         } else if (time_since_start < _taxTiers[1] * HOUR) {
1206             return _burnFee.mul(2);
1207         } else if (time_since_start < _taxTiers[2] * HOUR) {
1208             return _burnFee.mul(3);
1209         } else {
1210             return _burnFee.mul(3);
1211         }
1212     }
1213 
1214     function _getCurrentLiqFee() private view returns (uint256) {
1215         uint256 time_since_start = block.timestamp - _start_timestamp;
1216         if (time_since_start < _taxTiers[0] * HOUR) {
1217             return _liquidityFee.mul(16);
1218         } else if (time_since_start < _taxTiers[1] * HOUR) {
1219             return _liquidityFee.mul(10);
1220         } else if (time_since_start < _taxTiers[2] * HOUR) {
1221             return _burnFee.mul(5);
1222         } else {
1223             return _liquidityFee.mul(0);
1224         }
1225     }
1226 
1227     function _getCurrentHolderFee() private view returns (uint256) {
1228         uint256 time_since_start = block.timestamp - _start_timestamp;
1229         if (time_since_start < _taxTiers[0] * HOUR) {
1230             return _holderFee.mul(0);
1231         } else if (time_since_start < _taxTiers[1] * HOUR) {
1232             return _holderFee.mul(3);
1233         } else if (time_since_start < _taxTiers[2] * HOUR) {
1234             return _burnFee.mul(2);
1235         } else {
1236             return _holderFee.mul(1);
1237         }
1238     }
1239 
1240     function _getTValues(uint256 tAmount)
1241         private
1242         view
1243         returns (
1244             uint256,
1245             uint256,
1246             uint256,
1247             uint256
1248         )
1249     {
1250         // uint256 currentBurnFee = _getCurrentBurnFee();
1251         // uint256 currentLiqFee = _getCurrentLiqFee();
1252         // uint256 currentHolderFee = _getCurrentHolderFee();
1253 
1254         // 10**2 for percentage.  Another 10**2 to allow fees with decimals in the future
1255         uint256 tBurn = tAmount.div(10**2).mul(_getCurrentBurnFee()).div(10**2);
1256         uint256 tLiquidity =
1257             tAmount.div(10**2).mul(_getCurrentLiqFee()).div(10**2);
1258         uint256 tFee =
1259             tAmount.div(10**2).mul(_getCurrentHolderFee()).div(10**2);
1260         uint256 tTransferAmount = tAmount.sub(tBurn).sub(tLiquidity).sub(tFee);
1261         return (tTransferAmount, tFee, tLiquidity, tBurn);
1262     }
1263 
1264     function _getRValues(
1265         uint256 tAmount,
1266         uint256 tFee,
1267         uint256 tLiquidity,
1268         uint256 tBurn,
1269         uint256 currentRate
1270     )
1271         private
1272         pure
1273         returns (
1274             uint256,
1275             uint256,
1276             uint256
1277         )
1278     {
1279         uint256 rAmount = tAmount.mul(currentRate);
1280         uint256 rFee = tFee.mul(currentRate);
1281         uint256 rLiquidity = tLiquidity.mul(currentRate);
1282         uint256 rBurn = tBurn.mul(currentRate);
1283         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBurn);
1284         return (rAmount, rTransferAmount, rFee);
1285     }
1286 
1287     function _getRate() private view returns (uint256) {
1288         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1289         return rSupply.div(tSupply);
1290     }
1291 
1292     function _getCurrentSupply() private view returns (uint256, uint256) {
1293         uint256 rSupply = _rTotal;
1294         uint256 tSupply = _tTotal;
1295         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1296         return (rSupply, tSupply);
1297     }
1298 
1299     function _takeLiquidity(uint256 tLiquidity) private {
1300         uint256 currentRate = _getRate();
1301         uint256 rLiquidity = tLiquidity.mul(currentRate);
1302         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1303     }
1304 
1305     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1306         // split the contract balance into halves
1307         uint256 half = contractTokenBalance.div(2);
1308         uint256 otherHalf = contractTokenBalance.sub(half);
1309 
1310         // capture the contract's current ETH balance.
1311         // this is so that we can capture exactly the amount of ETH that the
1312         // If you copy this line of F!R3!NU you're a shit dev who doesn't check over code
1313         // swap creates, and not make the liquidity event include any ETH that
1314         // has been manually sent to the contract
1315         uint256 initialBalance = address(this).balance;
1316 
1317         // swap tokens for ETH
1318         swapTokensForBNB(half);
1319 
1320         // how much ETH did we just swap into?
1321         uint256 newBalance = address(this).balance.sub(initialBalance);
1322 
1323         // add liquidity to uniswap
1324         addLiquidity(otherHalf, newBalance);
1325 
1326         emit SwapAndLiquify(half, newBalance, otherHalf, contractTokenBalance);
1327     }
1328 
1329     function swapTokensForBNB(uint256 tokenAmount) private {
1330         // generate the uniswap pair path of token -> weth
1331         address[] memory path = new address[](2);
1332         path[0] = address(this);
1333         path[1] = uniswapV2Router.WETH();
1334 
1335         _approve(address(this), address(uniswapV2Router), tokenAmount);
1336 
1337         // make the swap
1338         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1339             tokenAmount,
1340             0, // accept any amount of ETH
1341             path,
1342             address(this),
1343             block.timestamp
1344         );
1345     }
1346 
1347     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1348         // approve token transfer to cover all possible scenarios
1349         _approve(address(this), address(uniswapV2Router), tokenAmount);
1350 
1351         // add the liquidity
1352         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1353             address(this),
1354             tokenAmount,
1355             0, // slippage is unavoidable
1356             0, // slippage is unavoidable
1357             owner(),
1358             block.timestamp
1359         );
1360     }
1361 
1362     receive() external payable {}
1363 }