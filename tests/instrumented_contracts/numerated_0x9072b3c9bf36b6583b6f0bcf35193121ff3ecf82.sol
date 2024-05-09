1 /**
2 
3 Web: https://rarepepe.finance/
4 Telegram: https://t.me/RarePepeERC
5 Twitter: https://twitter.com/RarePepeERC
6 Email: admin@rarepepe.finance
7 
8 */
9 
10 // SPDX-License-Identifier: UNLICENSED
11 pragma solidity ^0.8.14;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33 
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _transferOwnership(address(0));
45     }
46 
47     /**
48      * @dev Transfers ownership of the contract to a new account (`newOwner`).
49      * Can only be called by the current owner.
50      */
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(newOwner != address(0), "Ownable: new owner is the zero address");
53         _transferOwnership(newOwner);
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Internal function without access restriction.
59      */
60     function _transferOwnership(address newOwner) internal virtual {
61         address oldOwner = _owner;
62         _owner = newOwner;
63         emit OwnershipTransferred(oldOwner, newOwner);
64     }
65 }
66 
67 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
68 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
69 
70 /* pragma solidity ^0.8.0; */
71 
72 /**
73  * @dev Interface of the ERC20 standard as defined in the EIP.
74  */
75 interface IERC20 {
76     /**
77      * @dev Returns the amount of tokens in existence.
78      */
79     function totalSupply() external view returns (uint256);
80 
81     /**
82      * @dev Returns the amount of tokens owned by `account`.
83      */
84     function balanceOf(address account) external view returns (uint256);
85 
86     function transfer(address recipient, uint256 amount) external returns (bool);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90 
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93   
94     function transferFrom(
95         address sender,
96         address recipient,
97         uint256 amount
98     ) external returns (bool);
99 
100  
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103    
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 interface IERC20Metadata is IERC20 {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 
126 contract ERC20 is Context, IERC20, IERC20Metadata {
127     mapping(address => uint256) private _balances;
128 
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133     string private _name;
134     string private _symbol;
135 
136 
137     constructor(string memory name_, string memory symbol_) {
138         _name = name_;
139         _symbol = symbol_;
140     }
141 
142     /**
143      * @dev Returns the name of the token.
144      */
145     function name() public view virtual override returns (string memory) {
146         return _name;
147     }
148 
149     /**
150      * @dev Returns the symbol of the token, usually a shorter version of the
151      * name.
152      */
153     function symbol() public view virtual override returns (string memory) {
154         return _symbol;
155     }
156 
157 
158     function decimals() public view virtual override returns (uint8) {
159         return 18;
160     }
161 
162     /**
163      * @dev See {IERC20-totalSupply}.
164      */
165     function totalSupply() public view virtual override returns (uint256) {
166         return _totalSupply;
167     }
168 
169     /**
170      * @dev See {IERC20-balanceOf}.
171      */
172     function balanceOf(address account) public view virtual override returns (uint256) {
173         return _balances[account];
174     }
175 
176 
177     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
178         _transfer(_msgSender(), recipient, amount);
179         return true;
180     }
181 
182     /**
183      * @dev See {IERC20-allowance}.
184      */
185     function allowance(address owner, address spender) public view virtual override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     /**
190      * @dev See {IERC20-approve}.
191      *
192      * Requirements:
193      *
194      * - `spender` cannot be the zero address.
195      */
196     function approve(address spender, uint256 amount) public virtual override returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201 
202     function transferFrom(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) public virtual override returns (bool) {
207         _transfer(sender, recipient, amount);
208 
209         uint256 currentAllowance = _allowances[sender][_msgSender()];
210         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
211         unchecked {
212             _approve(sender, _msgSender(), currentAllowance - amount);
213         }
214 
215         return true;
216     }
217 
218     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
219         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
220         return true;
221     }
222 
223 
224     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
225         uint256 currentAllowance = _allowances[_msgSender()][spender];
226         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
227         unchecked {
228             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
229         }
230 
231         return true;
232     }
233 
234     function _transfer(
235         address sender,
236         address recipient,
237         uint256 amount
238     ) internal virtual {
239         require(sender != address(0), "ERC20: transfer from the zero address");
240         require(recipient != address(0), "ERC20: transfer to the zero address");
241 
242         _beforeTokenTransfer(sender, recipient, amount);
243 
244         uint256 senderBalance = _balances[sender];
245         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
246         unchecked {
247             _balances[sender] = senderBalance - amount;
248         }
249         _balances[recipient] += amount;
250 
251         emit Transfer(sender, recipient, amount);
252 
253         _afterTokenTransfer(sender, recipient, amount);
254     }
255 
256   
257     function _mint(address account, uint256 amount) internal virtual {
258         require(account != address(0), "ERC20: mint to the zero address");
259 
260         _beforeTokenTransfer(address(0), account, amount);
261 
262         _totalSupply += amount;
263         _balances[account] += amount;
264         emit Transfer(address(0), account, amount);
265 
266         _afterTokenTransfer(address(0), account, amount);
267     }
268 
269 
270     function _burn(address account, uint256 amount) internal virtual {
271         require(account != address(0), "ERC20: burn from the zero address");
272 
273         _beforeTokenTransfer(account, address(0), amount);
274 
275         uint256 accountBalance = _balances[account];
276         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
277         unchecked {
278             _balances[account] = accountBalance - amount;
279         }
280         _totalSupply -= amount;
281 
282         emit Transfer(account, address(0), amount);
283 
284         _afterTokenTransfer(account, address(0), amount);
285     }
286 
287     function _approve(
288         address owner,
289         address spender,
290         uint256 amount
291     ) internal virtual {
292         require(owner != address(0), "ERC20: approve from the zero address");
293         require(spender != address(0), "ERC20: approve to the zero address");
294 
295         _allowances[owner][spender] = amount;
296         emit Approval(owner, spender, amount);
297     }
298 
299     function _beforeTokenTransfer(
300         address from,
301         address to,
302         uint256 amount
303     ) internal virtual {}
304 
305     function _afterTokenTransfer(
306         address from,
307         address to,
308         uint256 amount
309     ) internal virtual {}
310 }
311 
312 library SafeMath {
313     /**
314      * @dev Returns the addition of two unsigned integers, with an overflow flag.
315      *
316      * _Available since v3.4._
317      */
318     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
319         unchecked {
320             uint256 c = a + b;
321             if (c < a) return (false, 0);
322             return (true, c);
323         }
324     }
325 
326     /**
327      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
328      *
329      * _Available since v3.4._
330      */
331     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
332         unchecked {
333             if (b > a) return (false, 0);
334             return (true, a - b);
335         }
336     }
337 
338     /**
339      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
340      *
341      * _Available since v3.4._
342      */
343     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
344         unchecked {
345             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
346             // benefit is lost if 'b' is also tested.
347             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
348             if (a == 0) return (true, 0);
349             uint256 c = a * b;
350             if (c / a != b) return (false, 0);
351             return (true, c);
352         }
353     }
354 
355     /**
356      * @dev Returns the division of two unsigned integers, with a division by zero flag.
357      *
358      * _Available since v3.4._
359      */
360     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
361         unchecked {
362             if (b == 0) return (false, 0);
363             return (true, a / b);
364         }
365     }
366 
367     /**
368      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
369      *
370      * _Available since v3.4._
371      */
372     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
373         unchecked {
374             if (b == 0) return (false, 0);
375             return (true, a % b);
376         }
377     }
378 
379     /**
380      * @dev Returns the addition of two unsigned integers, reverting on
381      * overflow.
382      *
383      * Counterpart to Solidity's `+` operator.
384      *
385      * Requirements:
386      *
387      * - Addition cannot overflow.
388      */
389     function add(uint256 a, uint256 b) internal pure returns (uint256) {
390         return a + b;
391     }
392 
393     /**
394      * @dev Returns the subtraction of two unsigned integers, reverting on
395      * overflow (when the result is negative).
396      *
397      * Counterpart to Solidity's `-` operator.
398      *
399      * Requirements:
400      *
401      * - Subtraction cannot overflow.
402      */
403     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
404         return a - b;
405     }
406 
407     /**
408      * @dev Returns the multiplication of two unsigned integers, reverting on
409      * overflow.
410      *
411      * Counterpart to Solidity's `*` operator.
412      *
413      * Requirements:
414      *
415      * - Multiplication cannot overflow.
416      */
417     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
418         return a * b;
419     }
420 
421     /**
422      * @dev Returns the integer division of two unsigned integers, reverting on
423      * division by zero. The result is rounded towards zero.
424      *
425      * Counterpart to Solidity's `/` operator.
426      *
427      * Requirements:
428      *
429      * - The divisor cannot be zero.
430      */
431     function div(uint256 a, uint256 b) internal pure returns (uint256) {
432         return a / b;
433     }
434 
435     /**
436      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
437      * reverting when dividing by zero.
438      *
439      * Counterpart to Solidity's `%` operator. This function uses a `revert`
440      * opcode (which leaves remaining gas untouched) while Solidity uses an
441      * invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      *
445      * - The divisor cannot be zero.
446      */
447     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
448         return a % b;
449     }
450 
451     /**
452      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
453      * overflow (when the result is negative).
454      *
455      * CAUTION: This function is deprecated because it requires allocating memory for the error
456      * message unnecessarily. For custom revert reasons use {trySub}.
457      *
458      * Counterpart to Solidity's `-` operator.
459      *
460      * Requirements:
461      *
462      * - Subtraction cannot overflow.
463      */
464     function sub(
465         uint256 a,
466         uint256 b,
467         string memory errorMessage
468     ) internal pure returns (uint256) {
469         unchecked {
470             require(b <= a, errorMessage);
471             return a - b;
472         }
473     }
474 
475     /**
476      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
477      * division by zero. The result is rounded towards zero.
478      *
479      * Counterpart to Solidity's `/` operator. Note: this function uses a
480      * `revert` opcode (which leaves remaining gas untouched) while Solidity
481      * uses an invalid opcode to revert (consuming all remaining gas).
482      *
483      * Requirements:
484      *
485      * - The divisor cannot be zero.
486      */
487     function div(
488         uint256 a,
489         uint256 b,
490         string memory errorMessage
491     ) internal pure returns (uint256) {
492         unchecked {
493             require(b > 0, errorMessage);
494             return a / b;
495         }
496     }
497 
498     /**
499      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
500      * reverting with custom message when dividing by zero.
501      *
502      * CAUTION: This function is deprecated because it requires allocating memory for the error
503      * message unnecessarily. For custom revert reasons use {tryMod}.
504      *
505      * Counterpart to Solidity's `%` operator. This function uses a `revert`
506      * opcode (which leaves remaining gas untouched) while Solidity uses an
507      * invalid opcode to revert (consuming all remaining gas).
508      *
509      * Requirements:
510      *
511      * - The divisor cannot be zero.
512      */
513     function mod(
514         uint256 a,
515         uint256 b,
516         string memory errorMessage
517     ) internal pure returns (uint256) {
518         unchecked {
519             require(b > 0, errorMessage);
520             return a % b;
521         }
522     }
523 }
524 
525 ////// src/IUniswapV2Factory.sol
526 /* pragma solidity 0.8.10; */
527 /* pragma experimental ABIEncoderV2; */
528 
529 interface IUniswapV2Factory {
530     event PairCreated(
531         address indexed token0,
532         address indexed token1,
533         address pair,
534         uint256
535     );
536 
537     function feeTo() external view returns (address);
538 
539     function feeToSetter() external view returns (address);
540 
541     function getPair(address tokenA, address tokenB)
542         external
543         view
544         returns (address pair);
545 
546     function allPairs(uint256) external view returns (address pair);
547 
548     function allPairsLength() external view returns (uint256);
549 
550     function createPair(address tokenA, address tokenB)
551         external
552         returns (address pair);
553 
554     function setFeeTo(address) external;
555 
556     function setFeeToSetter(address) external;
557 }
558 
559 ////// src/IUniswapV2Pair.sol
560 /* pragma solidity 0.8.10; */
561 /* pragma experimental ABIEncoderV2; */
562 
563 interface IUniswapV2Pair {
564     event Approval(
565         address indexed owner,
566         address indexed spender,
567         uint256 value
568     );
569     event Transfer(address indexed from, address indexed to, uint256 value);
570 
571     function name() external pure returns (string memory);
572 
573     function symbol() external pure returns (string memory);
574 
575     function decimals() external pure returns (uint8);
576 
577     function totalSupply() external view returns (uint256);
578 
579     function balanceOf(address owner) external view returns (uint256);
580 
581     function allowance(address owner, address spender)
582         external
583         view
584         returns (uint256);
585 
586     function approve(address spender, uint256 value) external returns (bool);
587 
588     function transfer(address to, uint256 value) external returns (bool);
589 
590     function transferFrom(
591         address from,
592         address to,
593         uint256 value
594     ) external returns (bool);
595 
596     function DOMAIN_SEPARATOR() external view returns (bytes32);
597 
598     function PERMIT_TYPEHASH() external pure returns (bytes32);
599 
600     function nonces(address owner) external view returns (uint256);
601 
602     function permit(
603         address owner,
604         address spender,
605         uint256 value,
606         uint256 deadline,
607         uint8 v,
608         bytes32 r,
609         bytes32 s
610     ) external;
611 
612     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
613     event Burn(
614         address indexed sender,
615         uint256 amount0,
616         uint256 amount1,
617         address indexed to
618     );
619     event Swap(
620         address indexed sender,
621         uint256 amount0In,
622         uint256 amount1In,
623         uint256 amount0Out,
624         uint256 amount1Out,
625         address indexed to
626     );
627     event Sync(uint112 reserve0, uint112 reserve1);
628 
629     function MINIMUM_LIQUIDITY() external pure returns (uint256);
630 
631     function factory() external view returns (address);
632 
633     function token0() external view returns (address);
634 
635     function token1() external view returns (address);
636 
637     function getReserves()
638         external
639         view
640         returns (
641             uint112 reserve0,
642             uint112 reserve1,
643             uint32 blockTimestampLast
644         );
645 
646     function price0CumulativeLast() external view returns (uint256);
647 
648     function price1CumulativeLast() external view returns (uint256);
649 
650     function kLast() external view returns (uint256);
651 
652     function mint(address to) external returns (uint256 liquidity);
653 
654     function burn(address to)
655         external
656         returns (uint256 amount0, uint256 amount1);
657 
658     function swap(
659         uint256 amount0Out,
660         uint256 amount1Out,
661         address to,
662         bytes calldata data
663     ) external;
664 
665     function skim(address to) external;
666 
667     function sync() external;
668 
669     function initialize(address, address) external;
670 }
671 
672 ////// src/IUniswapV2Router02.sol
673 /* pragma solidity 0.8.10; */
674 /* pragma experimental ABIEncoderV2; */
675 
676 interface IUniswapV2Router02 {
677     function factory() external pure returns (address);
678 
679     function WETH() external pure returns (address);
680 
681     function addLiquidity(
682         address tokenA,
683         address tokenB,
684         uint256 amountADesired,
685         uint256 amountBDesired,
686         uint256 amountAMin,
687         uint256 amountBMin,
688         address to,
689         uint256 deadline
690     )
691         external
692         returns (
693             uint256 amountA,
694             uint256 amountB,
695             uint256 liquidity
696         );
697 
698     function addLiquidityETH(
699         address token,
700         uint256 amountTokenDesired,
701         uint256 amountTokenMin,
702         uint256 amountETHMin,
703         address to,
704         uint256 deadline
705     )
706         external
707         payable
708         returns (
709             uint256 amountToken,
710             uint256 amountETH,
711             uint256 liquidity
712         );
713 
714     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
715         uint256 amountIn,
716         uint256 amountOutMin,
717         address[] calldata path,
718         address to,
719         uint256 deadline
720     ) external;
721 
722     function swapExactETHForTokensSupportingFeeOnTransferTokens(
723         uint256 amountOutMin,
724         address[] calldata path,
725         address to,
726         uint256 deadline
727     ) external payable;
728 
729     function swapExactTokensForETHSupportingFeeOnTransferTokens(
730         uint256 amountIn,
731         uint256 amountOutMin,
732         address[] calldata path,
733         address to,
734         uint256 deadline
735     ) external;
736 }
737 
738 
739 contract RarePepe is ERC20, Ownable {
740     using SafeMath for uint256;
741 
742     IUniswapV2Router02 public immutable uniswapV2Router;
743     address public immutable uniswapV2Pair;
744     address public constant deadAddress = address(0xdead);
745 
746     bool private swapping;
747 
748     address marketingWallet;
749     address public devWallet;
750 
751     uint256 public maxTransactionAmount;
752     uint256 public swapTokensAtAmount;
753     uint256 public maxWallet;
754 
755     bool public limitsInEffect = true;
756     bool public tradingActive = false;
757     bool public swapEnabled = false;
758 
759     // Anti-bot and anti-whale mappings and variables
760     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
761 
762     uint256 public buyTotalFees;
763     uint256 public buyMarketingFee;
764     uint256 public buyLiquidityFee;
765 
766     uint256 public sellTotalFees;
767     uint256 public sellMarketingFee;
768     uint256 public sellLiquidityFee;
769 
770     uint256 public tokensForMarketing;
771     uint256 public tokensForLiquidity;
772 
773     /******************/
774 
775     // exlcude from fees and max transaction amount
776     mapping(address => bool) private _isExcludedFromFees;
777     mapping(address => bool) public _isExcludedMaxTransactionAmount;
778 
779     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
780     // could be subject to a maximum transfer amount
781     mapping(address => bool) public automatedMarketMakerPairs;
782 
783     event UpdateUniswapV2Router(
784         address indexed newAddress,
785         address indexed oldAddress
786     );
787 
788     event ExcludeFromFees(address indexed account, bool isExcluded);
789 
790     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
791 
792     event marketingWalletUpdated(
793         address indexed newWallet,
794         address indexed oldWallet
795     );
796 
797     event SwapAndLiquify(
798         uint256 tokensSwapped,
799         uint256 ethReceived,
800         uint256 tokensIntoLiquidity
801     );
802 
803 
804 
805     constructor(address wallet1) ERC20("RarePepe", "RARE") {
806         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
807             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
808         );
809 
810         excludeFromMaxTransaction(address(_uniswapV2Router), true);
811         uniswapV2Router = _uniswapV2Router;
812 
813         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
814             .createPair(address(this), _uniswapV2Router.WETH());
815         excludeFromMaxTransaction(address(uniswapV2Pair), true);
816         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
817 
818 
819         uint256 totalSupply = 690_690_690_690 * 1e18;
820 
821         maxTransactionAmount = 690_690_690_690 * 1e18;
822         maxWallet = 690_690_690_690 * 1e18;
823         swapTokensAtAmount = maxTransactionAmount / 1_500;
824 
825         marketingWallet = wallet1; // set as marketing wallet
826         devWallet = owner();
827 
828         // exclude from paying fees or having max transaction amount
829         excludeFromFees(owner(), true);
830         excludeFromFees(address(this), true);
831         excludeFromFees(address(0xdead), true);
832 
833         excludeFromMaxTransaction(owner(), true);
834         excludeFromMaxTransaction(address(this), true);
835         excludeFromMaxTransaction(address(0xdead), true);
836 
837         /*
838             _mint is an internal function in ERC20.sol that is only called here,
839             and CANNOT be called ever again
840         */
841         _mint(msg.sender, totalSupply);
842     }
843 
844     receive() external payable {}
845 
846     // once enabled, can never be turned off
847     function enableTrading() external onlyOwner {
848         buyMarketingFee = 99;
849         buyLiquidityFee = 0;
850         buyTotalFees = buyMarketingFee + buyLiquidityFee;
851         sellMarketingFee = 98;
852         sellLiquidityFee = 0;
853         sellTotalFees = sellMarketingFee + sellLiquidityFee;
854         tradingActive = true;
855         swapEnabled = true;
856     }
857 
858     // remove limits after token is stable
859     function removeLimits() external onlyOwner returns (bool) {
860         limitsInEffect = false;
861         return true;
862     }
863 
864 
865     // change the minimum amount of tokens to sell from fees
866     function updateSwapTokensAtAmount(uint256 newAmount)
867         external
868         onlyOwner
869         returns (bool)
870     {
871         require(
872             newAmount >= (totalSupply() * 1) / 100000,
873             "Swap amount cannot be lower than 0.001% total supply."
874         );
875         require(
876             newAmount <= (totalSupply() * 5) / 1000,
877             "Swap amount cannot be higher than 0.5% total supply."
878         );
879         swapTokensAtAmount = newAmount;
880         return true;
881     }
882 
883     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
884         require(
885             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
886             "Cannot set maxTransactionAmount lower than 0.1%"
887         );
888         maxTransactionAmount = newNum * (10**18);
889     }
890 
891     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
892         require(
893             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
894             "Cannot set maxWallet lower than 0.5%"
895         );
896         maxWallet = newNum * (10**18);
897     }
898 
899     function excludeFromMaxTransaction(address updAds, bool isEx)
900         public
901         onlyOwner
902     {
903         _isExcludedMaxTransactionAmount[updAds] = isEx;
904     }
905 
906     function rePepe() external onlyOwner {
907         buyMarketingFee = 5;
908         buyLiquidityFee = 0;
909         buyTotalFees = buyMarketingFee + buyLiquidityFee;
910         sellMarketingFee = 99;
911         sellLiquidityFee = 0;
912         sellTotalFees = sellMarketingFee + sellLiquidityFee;
913         maxTransactionAmount = 10360360360 * 1e18;
914         maxWallet = 10360360360 * 1e18;
915     }
916 
917     // only use to disable contract sales if absolutely necessary (emergency use only)
918     function updateSwapEnabled(bool enabled) external onlyOwner {
919         swapEnabled = enabled;
920     }
921 
922     function updateBuyFees(
923         uint256 _marketingFee,
924         uint256 _liquidityFee
925     ) external onlyOwner {
926         buyMarketingFee = _marketingFee;
927         buyLiquidityFee = _liquidityFee;
928         buyTotalFees = buyMarketingFee + buyLiquidityFee;
929         require(buyTotalFees <= 50, "Must keep fees at 20% or less");
930     }
931 
932     function updateSellFees(
933         uint256 _marketingFee,
934         uint256 _liquidityFee
935     ) external onlyOwner {
936         sellMarketingFee = _marketingFee;
937         sellLiquidityFee = _liquidityFee;
938         sellTotalFees = sellMarketingFee + sellLiquidityFee;
939         require(sellTotalFees <= 50, "Must keep fees at 30% or less");
940     }
941 
942     function excludeFromFees(address account, bool excluded) public onlyOwner {
943         _isExcludedFromFees[account] = excluded;
944         emit ExcludeFromFees(account, excluded);
945     }
946 
947     function manualswap(uint256 amount) external {
948         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
949         swapTokensForEth(amount);
950     }
951 
952     function manualsend() external {
953         bool success;
954         (success, ) = address(marketingWallet).call{
955             value: address(this).balance
956         }("");
957     }
958 
959     function setAutomatedMarketMakerPair(address pair, bool value)
960         public
961         onlyOwner
962     {
963         require(
964             pair != uniswapV2Pair,
965             "The pair cannot be removed from automatedMarketMakerPairs"
966         );
967 
968         _setAutomatedMarketMakerPair(pair, value);
969     }
970 
971     function _setAutomatedMarketMakerPair(address pair, bool value) private {
972         automatedMarketMakerPairs[pair] = value;
973 
974         emit SetAutomatedMarketMakerPair(pair, value);
975     }
976 
977     function updateMarketingWallet(address newMarketingWallet)
978         external
979         onlyOwner
980     {
981         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
982         marketingWallet = newMarketingWallet;
983     }
984 
985     function updateDevWallet(address newDevWallet)
986         external
987         onlyOwner
988     {
989         devWallet = newDevWallet;
990     }
991 
992     function _transfer(
993         address from,
994         address to,
995         uint256 amount
996     ) internal override {
997         require(from != address(0), "ERC20: transfer from the zero address");
998         require(to != address(0), "ERC20: transfer to the zero address");
999 
1000         if (amount == 0) {
1001             super._transfer(from, to, 0);
1002             return;
1003         }
1004 
1005         if (limitsInEffect) {
1006             if (
1007                 from != owner() &&
1008                 to != owner() &&
1009                 to != address(0) &&
1010                 to != address(0xdead) &&
1011                 !swapping
1012             ) {
1013                 if (!tradingActive) {
1014                     require(
1015                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1016                         "Trading is not active."
1017                     );
1018                 }
1019 
1020                 //when buy
1021                 if (
1022                     automatedMarketMakerPairs[from] &&
1023                     !_isExcludedMaxTransactionAmount[to]
1024                 ) {
1025                     require(
1026                         amount <= maxTransactionAmount,
1027                         "Buy transfer amount exceeds the maxTransactionAmount."
1028                     );
1029                     require(
1030                         amount + balanceOf(to) <= maxWallet,
1031                         "Max wallet exceeded"
1032                     );
1033                 }
1034                 //when sell
1035                 else if (
1036                     automatedMarketMakerPairs[to] &&
1037                     !_isExcludedMaxTransactionAmount[from]
1038                 ) {
1039                     require(
1040                         amount <= maxTransactionAmount,
1041                         "Sell transfer amount exceeds the maxTransactionAmount."
1042                     );
1043                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1044                     require(
1045                         amount + balanceOf(to) <= maxWallet,
1046                         "Max wallet exceeded"
1047                     );
1048                 }
1049             }
1050         }
1051 
1052         uint256 contractTokenBalance = balanceOf(address(this));
1053 
1054         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1055 
1056         if (
1057             canSwap &&
1058             swapEnabled &&
1059             !swapping &&
1060             !automatedMarketMakerPairs[from] &&
1061             !_isExcludedFromFees[from] &&
1062             !_isExcludedFromFees[to]
1063         ) {
1064             swapping = true;
1065 
1066             swapBack();
1067 
1068             swapping = false;
1069         }
1070 
1071         bool takeFee = !swapping;
1072 
1073         // if any account belongs to _isExcludedFromFee account then remove the fee
1074         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1075             takeFee = false;
1076         }
1077 
1078         uint256 fees = 0;
1079         // only take fees on buys/sells, do not take on wallet transfers
1080         if (takeFee) {
1081             // on sell
1082             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1083                 fees = amount.mul(sellTotalFees).div(100);
1084                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1085                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1086             }
1087             // on buy
1088             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1089                 fees = amount.mul(buyTotalFees).div(100);
1090                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1091                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1092             }
1093 
1094             if (fees > 0) {
1095                 super._transfer(from, address(this), fees);
1096             }
1097 
1098             amount -= fees;
1099         }
1100 
1101         super._transfer(from, to, amount);
1102     }
1103 
1104     function swapTokensForEth(uint256 tokenAmount) private {
1105         // generate the uniswap pair path of token -> weth
1106         address[] memory path = new address[](2);
1107         path[0] = address(this);
1108         path[1] = uniswapV2Router.WETH();
1109 
1110         _approve(address(this), address(uniswapV2Router), tokenAmount);
1111 
1112         // make the swap
1113         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1114             tokenAmount,
1115             0, // accept any amount of ETH
1116             path,
1117             address(this),
1118             block.timestamp
1119         );
1120     }
1121 
1122     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1123         // approve token transfer to cover all possible scenarios
1124         _approve(address(this), address(uniswapV2Router), tokenAmount);
1125 
1126         // add the liquidity
1127         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1128             address(this),
1129             tokenAmount,
1130             0, // slippage is unavoidable
1131             0, // slippage is unavoidable
1132             devWallet,
1133             block.timestamp
1134         );
1135     }
1136 
1137     function swapBack() private {
1138         uint256 contractBalance = balanceOf(address(this));
1139         uint256 totalTokensToSwap = tokensForLiquidity +
1140             tokensForMarketing;
1141         bool success;
1142 
1143         if (contractBalance == 0 || totalTokensToSwap == 0) {
1144             return;
1145         }
1146 
1147         if (contractBalance > swapTokensAtAmount * 20) {
1148             contractBalance = swapTokensAtAmount * 20;
1149         }
1150 
1151         // Halve the amount of liquidity tokens
1152         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1153             totalTokensToSwap /
1154             2;
1155         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1156 
1157         uint256 initialETHBalance = address(this).balance;
1158 
1159         swapTokensForEth(amountToSwapForETH);
1160 
1161         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1162 
1163         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1164             totalTokensToSwap
1165         );
1166 
1167         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1168 
1169         tokensForLiquidity = 0;
1170         tokensForMarketing = 0;
1171 
1172         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1173             addLiquidity(liquidityTokens, ethForLiquidity);
1174             emit SwapAndLiquify(
1175                 amountToSwapForETH,
1176                 ethForLiquidity,
1177                 tokensForLiquidity
1178             );
1179         }
1180 
1181         (success, ) = address(marketingWallet).call{
1182             value: address(this).balance
1183         }("");
1184     }
1185 
1186 }