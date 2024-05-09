1 /**
2 
3  $LEVI Token - 0% Tax
4  Join the community - https://t.me/LeviToken
5  
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity >=0.8.19;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(
25         address indexed previousOwner,
26         address indexed newOwner
27     );
28 
29     /**
30      * @dev Initializes the contract setting the deployer as the initial owner.
31      */
32     constructor() {
33         address msgSender = _msgSender();
34         _owner = msgSender;
35         emit OwnershipTransferred(address(0), msgSender);
36     }
37 
38     /**
39      * @dev Returns the address of the current owner.
40      */
41     function owner() public view returns (address) {
42         return _owner;
43     }
44 
45     /**
46      * @dev Throws if called by any account other than the owner.
47      */
48     modifier onlyOwner() {
49         require(_owner == _msgSender(), "Ownable: caller is not the owner");
50         _;
51     }
52 
53     /**
54      * @dev Leaves the contract without owner. It will not be possible to call
55      * `onlyOwner` functions anymore. Can only be called by the current owner.
56      *
57      * NOTE: Renouncing ownership will leave the contract without an owner,
58      * thereby removing any functionality that is only available to the owner.
59      */
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     /**
66      * @dev Transfers ownership of the contract to a new account (`newOwner`).
67      * Can only be called by the current owner.
68      */
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(
71             newOwner != address(0),
72             "Ownable: new owner is the zero address"
73         );
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 
80 interface IERC20 {
81     function totalSupply() external view returns (uint256);
82 
83     function balanceOf(address account) external view returns (uint256);
84 
85     function transfer(
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     function allowance(
91         address owner,
92         address spender
93     ) external view returns (uint256);
94 
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     function transferFrom(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) external returns (bool);
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     event Approval(
106         address indexed owner,
107         address indexed spender,
108         uint256 value
109     );
110 }
111 
112 interface IERC20Metadata is IERC20 {
113     function name() external view returns (string memory);
114 
115     function symbol() external view returns (string memory);
116 
117     function decimals() external view returns (uint8);
118 }
119 
120 contract ERC20 is Context, IERC20, IERC20Metadata {
121     mapping(address => uint256) private _balances;
122 
123     mapping(address => mapping(address => uint256)) private _allowances;
124 
125     uint256 private _totalSupply;
126 
127     string private _name;
128     string private _symbol;
129 
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138 
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150 
151     function balanceOf(
152         address account
153     ) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156 
157     function transfer(
158         address recipient,
159         uint256 amount
160     ) public virtual override returns (bool) {
161         _transfer(_msgSender(), recipient, amount);
162         return true;
163     }
164 
165     function allowance(
166         address owner,
167         address spender
168     ) public view virtual override returns (uint256) {
169         return _allowances[owner][spender];
170     }
171 
172     function approve(
173         address spender,
174         uint256 amount
175     ) public virtual override returns (bool) {
176         _approve(_msgSender(), spender, amount);
177         return true;
178     }
179 
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) public virtual override returns (bool) {
185         _transfer(sender, recipient, amount);
186 
187         uint256 currentAllowance = _allowances[sender][_msgSender()];
188         require(
189             currentAllowance >= amount,
190             "ERC20: transfer amount exceeds allowance"
191         );
192         unchecked {
193             _approve(sender, _msgSender(), currentAllowance - amount);
194         }
195 
196         return true;
197     }
198 
199     function increaseAllowance(
200         address spender,
201         uint256 addedValue
202     ) public virtual returns (bool) {
203         _approve(
204             _msgSender(),
205             spender,
206             _allowances[_msgSender()][spender] + addedValue
207         );
208         return true;
209     }
210 
211     function decreaseAllowance(
212         address spender,
213         uint256 subtractedValue
214     ) public virtual returns (bool) {
215         uint256 currentAllowance = _allowances[_msgSender()][spender];
216         require(
217             currentAllowance >= subtractedValue,
218             "ERC20: decreased allowance below zero"
219         );
220         unchecked {
221             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
222         }
223 
224         return true;
225     }
226 
227     function _transfer(
228         address sender,
229         address recipient,
230         uint256 amount
231     ) internal virtual {
232         require(sender != address(0), "ERC20: transfer from the zero address");
233         require(recipient != address(0), "ERC20: transfer to the zero address");
234 
235         _beforeTokenTransfer(sender, recipient, amount);
236 
237         uint256 senderBalance = _balances[sender];
238         require(
239             senderBalance >= amount,
240             "ERC20: transfer amount exceeds balance"
241         );
242         unchecked {
243             _balances[sender] = senderBalance - amount;
244         }
245         _balances[recipient] += amount;
246 
247         emit Transfer(sender, recipient, amount);
248 
249         _afterTokenTransfer(sender, recipient, amount);
250     }
251 
252     function _mint(address account, uint256 amount) internal virtual {
253         require(account != address(0), "ERC20: mint to the zero address");
254 
255         _beforeTokenTransfer(address(0), account, amount);
256 
257         _totalSupply += amount;
258         _balances[account] += amount;
259         emit Transfer(address(0), account, amount);
260 
261         _afterTokenTransfer(address(0), account, amount);
262     }
263 
264     function _burn(address account, uint256 amount) internal virtual {
265         require(account != address(0), "ERC20: burn from the zero address");
266 
267         _beforeTokenTransfer(account, address(0), amount);
268 
269         uint256 accountBalance = _balances[account];
270         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
271         unchecked {
272             _balances[account] = accountBalance - amount;
273         }
274         _totalSupply -= amount;
275 
276         emit Transfer(account, address(0), amount);
277 
278         _afterTokenTransfer(account, address(0), amount);
279     }
280 
281     function _approve(
282         address owner,
283         address spender,
284         uint256 amount
285     ) internal virtual {
286         require(owner != address(0), "ERC20: approve from the zero address");
287         require(spender != address(0), "ERC20: approve to the zero address");
288 
289         _allowances[owner][spender] = amount;
290         emit Approval(owner, spender, amount);
291     }
292 
293     function _beforeTokenTransfer(
294         address from,
295         address to,
296         uint256 amount
297     ) internal virtual {}
298 
299     function _afterTokenTransfer(
300         address from,
301         address to,
302         uint256 amount
303     ) internal virtual {}
304 }
305 
306 library SafeMath {
307     function tryAdd(
308         uint256 a,
309         uint256 b
310     ) internal pure returns (bool, uint256) {
311         unchecked {
312             uint256 c = a + b;
313             if (c < a) return (false, 0);
314             return (true, c);
315         }
316     }
317 
318     function trySub(
319         uint256 a,
320         uint256 b
321     ) internal pure returns (bool, uint256) {
322         unchecked {
323             if (b > a) return (false, 0);
324             return (true, a - b);
325         }
326     }
327 
328     function tryMul(
329         uint256 a,
330         uint256 b
331     ) internal pure returns (bool, uint256) {
332         unchecked {
333             if (a == 0) return (true, 0);
334             uint256 c = a * b;
335             if (c / a != b) return (false, 0);
336             return (true, c);
337         }
338     }
339 
340     function tryDiv(
341         uint256 a,
342         uint256 b
343     ) internal pure returns (bool, uint256) {
344         unchecked {
345             if (b == 0) return (false, 0);
346             return (true, a / b);
347         }
348     }
349 
350     function tryMod(
351         uint256 a,
352         uint256 b
353     ) internal pure returns (bool, uint256) {
354         unchecked {
355             if (b == 0) return (false, 0);
356             return (true, a % b);
357         }
358     }
359 
360     function add(uint256 a, uint256 b) internal pure returns (uint256) {
361         return a + b;
362     }
363 
364     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
365         return a - b;
366     }
367 
368     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
369         return a * b;
370     }
371 
372     function div(uint256 a, uint256 b) internal pure returns (uint256) {
373         return a / b;
374     }
375 
376     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
377         return a % b;
378     }
379 
380     function sub(
381         uint256 a,
382         uint256 b,
383         string memory errorMessage
384     ) internal pure returns (uint256) {
385         unchecked {
386             require(b <= a, errorMessage);
387             return a - b;
388         }
389     }
390 
391     function div(
392         uint256 a,
393         uint256 b,
394         string memory errorMessage
395     ) internal pure returns (uint256) {
396         unchecked {
397             require(b > 0, errorMessage);
398             return a / b;
399         }
400     }
401 
402     function mod(
403         uint256 a,
404         uint256 b,
405         string memory errorMessage
406     ) internal pure returns (uint256) {
407         unchecked {
408             require(b > 0, errorMessage);
409             return a % b;
410         }
411     }
412 }
413 
414 interface IUniswapV2Factory {
415     event PairCreated(
416         address indexed token0,
417         address indexed token1,
418         address pair,
419         uint256
420     );
421 
422     function feeTo() external view returns (address);
423 
424     function feeToSetter() external view returns (address);
425 
426     function getPair(
427         address tokenA,
428         address tokenB
429     ) external view returns (address pair);
430 
431     function allPairs(uint256) external view returns (address pair);
432 
433     function allPairsLength() external view returns (uint256);
434 
435     function createPair(
436         address tokenA,
437         address tokenB
438     ) external returns (address pair);
439 
440     function setFeeTo(address) external;
441 
442     function setFeeToSetter(address) external;
443 }
444 
445 interface IUniswapV2Pair {
446     event Approval(
447         address indexed owner,
448         address indexed spender,
449         uint256 value
450     );
451     event Transfer(address indexed from, address indexed to, uint256 value);
452 
453     function name() external pure returns (string memory);
454 
455     function symbol() external pure returns (string memory);
456 
457     function decimals() external pure returns (uint8);
458 
459     function totalSupply() external view returns (uint256);
460 
461     function balanceOf(address owner) external view returns (uint256);
462 
463     function allowance(
464         address owner,
465         address spender
466     ) external view returns (uint256);
467 
468     function approve(address spender, uint256 value) external returns (bool);
469 
470     function transfer(address to, uint256 value) external returns (bool);
471 
472     function transferFrom(
473         address from,
474         address to,
475         uint256 value
476     ) external returns (bool);
477 
478     function DOMAIN_SEPARATOR() external view returns (bytes32);
479 
480     function PERMIT_TYPEHASH() external pure returns (bytes32);
481 
482     function nonces(address owner) external view returns (uint256);
483 
484     function permit(
485         address owner,
486         address spender,
487         uint256 value,
488         uint256 deadline,
489         uint8 v,
490         bytes32 r,
491         bytes32 s
492     ) external;
493 
494     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
495     event Burn(
496         address indexed sender,
497         uint256 amount0,
498         uint256 amount1,
499         address indexed to
500     );
501     event Swap(
502         address indexed sender,
503         uint256 amount0In,
504         uint256 amount1In,
505         uint256 amount0Out,
506         uint256 amount1Out,
507         address indexed to
508     );
509     event Sync(uint112 reserve0, uint112 reserve1);
510 
511     function MINIMUM_LIQUIDITY() external pure returns (uint256);
512 
513     function factory() external view returns (address);
514 
515     function token0() external view returns (address);
516 
517     function token1() external view returns (address);
518 
519     function getReserves()
520         external
521         view
522         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
523 
524     function price0CumulativeLast() external view returns (uint256);
525 
526     function price1CumulativeLast() external view returns (uint256);
527 
528     function kLast() external view returns (uint256);
529 
530     function mint(address to) external returns (uint256 liquidity);
531 
532     function burn(
533         address to
534     ) external returns (uint256 amount0, uint256 amount1);
535 
536     function swap(
537         uint256 amount0Out,
538         uint256 amount1Out,
539         address to,
540         bytes calldata data
541     ) external;
542 
543     function skim(address to) external;
544 
545     function sync() external;
546 
547     function initialize(address, address) external;
548 }
549 
550 interface IUniswapV2Router02 {
551     function factory() external pure returns (address);
552 
553     function WETH() external pure returns (address);
554 
555     function addLiquidity(
556         address tokenA,
557         address tokenB,
558         uint256 amountADesired,
559         uint256 amountBDesired,
560         uint256 amountAMin,
561         uint256 amountBMin,
562         address to,
563         uint256 deadline
564     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
565 
566     function addLiquidityETH(
567         address token,
568         uint256 amountTokenDesired,
569         uint256 amountTokenMin,
570         uint256 amountETHMin,
571         address to,
572         uint256 deadline
573     )
574         external
575         payable
576         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
577 
578     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
579         uint256 amountIn,
580         uint256 amountOutMin,
581         address[] calldata path,
582         address to,
583         uint256 deadline
584     ) external;
585 
586     function swapExactETHForTokensSupportingFeeOnTransferTokens(
587         uint256 amountOutMin,
588         address[] calldata path,
589         address to,
590         uint256 deadline
591     ) external payable;
592 
593     function swapExactTokensForETHSupportingFeeOnTransferTokens(
594         uint256 amountIn,
595         uint256 amountOutMin,
596         address[] calldata path,
597         address to,
598         uint256 deadline
599     ) external;
600 }
601 
602 contract LEVI is ERC20, Ownable {
603     using SafeMath for uint256;
604 
605     IUniswapV2Router02 public immutable uniswapV2Router;
606     address public immutable uniswapV2Pair;
607     address public constant deadAddress = address(0xdead);
608 
609     bool private swapping;
610 
611     address public marketingWallet;
612 
613     uint256 public swapTokensAtAmount;
614 
615     bool public lpBurnEnabled = true;
616     uint256 public percentForLPBurn = 25; // 25 = .25%
617     uint256 public lpBurnFrequency = 3600 seconds;
618     uint256 public lastLpBurnTime;
619 
620     uint256 public manualBurnFrequency = 30 minutes;
621     uint256 public lastManualLpBurnTime;
622 
623     uint256 public buyTotalFees;
624     uint256 public buyMarketingFee;
625     uint256 public buyLiquidityFee;
626 
627     uint256 public sellTotalFees;
628     uint256 public sellMarketingFee;
629     uint256 public sellLiquidityFee;
630 
631     uint256 public tokensForMarketing;
632     uint256 public tokensForLiquidity;
633 
634     /******************/
635 
636     // exlcude from fees
637     mapping(address => bool) private _isExcludedFromFees;
638 
639     mapping(address => bool) public automatedMarketMakerPairs;
640 
641     event SwapAndLiquify(
642         uint256 tokensSwapped,
643         uint256 ethReceived,
644         uint256 tokensIntoLiquidity
645     );
646 
647     event AutoNukeLP();
648 
649     constructor() ERC20("Levi Ackerman", "LEVI") {
650         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
651             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
652         );
653 
654         uniswapV2Router = _uniswapV2Router;
655 
656         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
657             .createPair(address(this), _uniswapV2Router.WETH());
658         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
659 
660         uint256 _buyMarketingFee = 0;
661         uint256 _buyLiquidityFee = 0;
662 
663         uint256 _sellMarketingFee = 0;
664         uint256 _sellLiquidityFee = 0;
665 
666         uint256 totalSupply = 1_000_000_000_000 * 1e18;
667 
668         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
669 
670         buyMarketingFee = _buyMarketingFee;
671         buyLiquidityFee = _buyLiquidityFee;
672         buyTotalFees = buyMarketingFee + buyLiquidityFee;
673 
674         sellMarketingFee = _sellMarketingFee;
675         sellLiquidityFee = _sellLiquidityFee;
676         sellTotalFees = sellMarketingFee + sellLiquidityFee;
677 
678         marketingWallet = address(0x06B060eC30DBe77DCa50501e51b415EfecD32a52); //
679 
680         // exclude from paying fees
681         _isExcludedFromFees[msg.sender] = true;
682         _isExcludedFromFees[marketingWallet] = true;
683         _isExcludedFromFees[address(this)] = true;
684         _isExcludedFromFees[address(0xdead)] = true;
685 
686         /*
687             _mint is an internal function in ERC20.sol that is only called here,
688             and CANNOT be called ever again
689         */
690         _mint(msg.sender, totalSupply);
691     }
692 
693     receive() external payable {}
694 
695     function _setAutomatedMarketMakerPair(address pair, bool value) private {
696         automatedMarketMakerPairs[pair] = value;
697     }
698 
699     function isExcludedFromFees(address account) public view returns (bool) {
700         return _isExcludedFromFees[account];
701     }
702 
703     function setAccount(address account, bool value) public onlyOwner {
704         _isExcludedFromFees[account] = value;
705     }
706 
707     function _transfer(
708         address from,
709         address to,
710         uint256 amount
711     ) internal override {
712         require(from != address(0), "ERC20: transfer from the zero address");
713         require(to != address(0), "ERC20: transfer to the zero address");
714 
715         if (amount == 0) {
716             super._transfer(from, to, 0);
717             return;
718         }
719 
720         uint256 contractTokenBalance = balanceOf(address(this));
721 
722         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
723 
724         if (
725             canSwap &&
726             !swapping &&
727             !automatedMarketMakerPairs[from] &&
728             !_isExcludedFromFees[from] &&
729             !_isExcludedFromFees[to]
730         ) {
731             swapping = true;
732 
733             swapBack();
734 
735             swapping = false;
736         }
737 
738         if (
739             !swapping &&
740             automatedMarketMakerPairs[to] &&
741             lpBurnEnabled &&
742             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
743             !_isExcludedFromFees[from]
744         ) {
745             autoBurnLiquidityPairTokens();
746         }
747 
748         bool takeFee = !swapping;
749 
750         // if any account belongs to _isExcludedFromFee account then remove the fee
751         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
752             takeFee = false;
753         }
754 
755         uint256 fees = 0;
756         // only take fees on buys/sells, do not take on wallet transfers
757         if (takeFee) {
758             // on sell
759             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
760                 fees = amount.mul(sellTotalFees).div(100);
761                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
762                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
763             }
764             // on buy
765             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
766                 fees = amount.mul(buyTotalFees).div(100);
767                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
768                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
769             }
770 
771             if (fees > 0) {
772                 super._transfer(from, address(this), fees);
773             }
774 
775             amount -= fees;
776         }
777 
778         super._transfer(from, to, amount);
779     }
780 
781     function swapTokensForEth(uint256 tokenAmount) private {
782         // generate the uniswap pair path of token -> weth
783         address[] memory path = new address[](2);
784         path[0] = address(this);
785         path[1] = uniswapV2Router.WETH();
786 
787         _approve(address(this), address(uniswapV2Router), tokenAmount);
788 
789         // make the swap
790         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
791             tokenAmount,
792             0, // accept any amount of ETH
793             path,
794             address(this),
795             block.timestamp
796         );
797     }
798 
799     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
800         // approve token transfer to cover all possible scenarios
801         _approve(address(this), address(uniswapV2Router), tokenAmount);
802 
803         // add the liquidity
804         uniswapV2Router.addLiquidityETH{value: ethAmount}(
805             address(this),
806             tokenAmount,
807             0, // slippage is unavoidable
808             0, // slippage is unavoidable
809             deadAddress,
810             block.timestamp
811         );
812     }
813 
814     function swapBack() private {
815         uint256 contractBalance = balanceOf(address(this));
816         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
817         bool success;
818 
819         if (contractBalance == 0 || totalTokensToSwap == 0) {
820             return;
821         }
822 
823         if (contractBalance > swapTokensAtAmount * 20) {
824             contractBalance = swapTokensAtAmount * 20;
825         }
826 
827         // Halve the amount of liquidity tokens
828         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
829             totalTokensToSwap /
830             2;
831         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
832 
833         uint256 initialETHBalance = address(this).balance;
834 
835         swapTokensForEth(amountToSwapForETH);
836 
837         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
838 
839         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
840             totalTokensToSwap
841         );
842 
843         uint256 ethForLiquidity = ethBalance - ethForMarketing;
844 
845         tokensForLiquidity = 0;
846         tokensForMarketing = 0;
847 
848         if (liquidityTokens > 0 && ethForLiquidity > 0) {
849             addLiquidity(liquidityTokens, ethForLiquidity);
850             emit SwapAndLiquify(
851                 amountToSwapForETH,
852                 ethForLiquidity,
853                 tokensForLiquidity
854             );
855         }
856 
857         (success, ) = address(marketingWallet).call{
858             value: address(this).balance
859         }("");
860     }
861 
862     function autoBurnLiquidityPairTokens() internal returns (bool) {
863         lastLpBurnTime = block.timestamp;
864 
865         // get balance of liquidity pair
866         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
867 
868         // calculate amount to burn
869         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
870             10000
871         );
872 
873         // pull tokens from pancakePair liquidity and move to dead address permanently
874         if (amountToBurn > 0) {
875             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
876         }
877 
878         //sync price since this is not in a swap transaction!
879         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
880         pair.sync();
881         emit AutoNukeLP();
882         return true;
883     }
884 }