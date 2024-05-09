1 /**
2  
3  https://t.me/SafeGrowErc20
4 
5 */
6 
7 //  SPDX-License-Identifier: MIT
8 pragma solidity >=0.8.19;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15 }
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     constructor() {
23         _transferOwnership(_msgSender());
24     }
25 
26     function owner() public view virtual returns (address) {
27         return _owner;
28     }
29 
30     modifier onlyOwner() {
31         require(owner() == _msgSender(), "Ownable: caller is not the owner");
32         _;
33     }
34 
35     function renounceOwnership() public virtual onlyOwner {
36         _transferOwnership(address(0));
37     }
38 
39     function transferOwnership(address newOwner) public virtual onlyOwner {
40         require(newOwner != address(0), "Ownable: new owner is the zero address");
41         _transferOwnership(newOwner);
42     }
43 
44     function _transferOwnership(address newOwner) internal virtual {
45         address oldOwner = _owner;
46         _owner = newOwner;
47         emit OwnershipTransferred(oldOwner, newOwner);
48     }
49 }
50 
51 interface IERC20 {
52 
53     function totalSupply() external view returns (uint256);
54 
55     function balanceOf(address account) external view returns (uint256);
56 
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 interface IERC20Metadata is IERC20 {
75 
76     function name() external view returns (string memory);
77 
78     function symbol() external view returns (string memory);
79 
80     function decimals() external view returns (uint8);
81 }
82 
83 contract ERC20 is Context, IERC20, IERC20Metadata {
84     mapping(address => uint256) private _balances;
85 
86     mapping(address => mapping(address => uint256)) private _allowances;
87 
88     uint256 private _totalSupply;
89 
90     string private _name;
91     string private _symbol;
92 
93     constructor(string memory name_, string memory symbol_) {
94         _name = name_;
95         _symbol = symbol_;
96     }
97 
98     function name() public view virtual override returns (string memory) {
99         return _name;
100     }
101 
102     function symbol() public view virtual override returns (string memory) {
103         return _symbol;
104     }
105 
106     function decimals() public view virtual override returns (uint8) {
107         return 18;
108     }
109 
110     function totalSupply() public view virtual override returns (uint256) {
111         return _totalSupply;
112     }
113 
114     function balanceOf(address account) public view virtual override returns (uint256) {
115         return _balances[account];
116     }
117 
118     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
119         _transfer(_msgSender(), recipient, amount);
120         return true;
121     }
122 
123     function allowance(address owner, address spender) public view virtual override returns (uint256) {
124         return _allowances[owner][spender];
125     }
126 
127     function approve(address spender, uint256 amount) public virtual override returns (bool) {
128         _approve(_msgSender(), spender, amount);
129         return true;
130     }
131 
132     function transferFrom(
133         address sender,
134         address recipient,
135         uint256 amount
136     ) public virtual override returns (bool) {
137         _transfer(sender, recipient, amount);
138 
139         uint256 currentAllowance = _allowances[sender][_msgSender()];
140         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
141         unchecked {
142             _approve(sender, _msgSender(), currentAllowance - amount);
143         }
144 
145         return true;
146     }
147 
148     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
149         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
150         return true;
151     }
152 
153     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
154         uint256 currentAllowance = _allowances[_msgSender()][spender];
155         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
156         unchecked {
157             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
158         }
159 
160         return true;
161     }
162 
163     function _transfer(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) internal virtual {
168         require(sender != address(0), "ERC20: transfer from the zero address");
169         require(recipient != address(0), "ERC20: transfer to the zero address");
170 
171         _beforeTokenTransfer(sender, recipient, amount);
172 
173         uint256 senderBalance = _balances[sender];
174         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
175         unchecked {
176             _balances[sender] = senderBalance - amount;
177         }
178         _balances[recipient] += amount;
179 
180         emit Transfer(sender, recipient, amount);
181 
182         _afterTokenTransfer(sender, recipient, amount);
183     }
184 
185     function _mint(address account, uint256 amount) internal virtual {
186         require(account != address(0), "ERC20: mint to the zero address");
187 
188         _beforeTokenTransfer(address(0), account, amount);
189 
190         _totalSupply += amount;
191         _balances[account] += amount;
192         emit Transfer(address(0), account, amount);
193 
194         _afterTokenTransfer(address(0), account, amount);
195     }
196 
197     function _approve(
198         address owner,
199         address spender,
200         uint256 amount
201     ) internal virtual {
202         require(owner != address(0), "ERC20: approve from the zero address");
203         require(spender != address(0), "ERC20: approve to the zero address");
204 
205         _allowances[owner][spender] = amount;
206         emit Approval(owner, spender, amount);
207     }
208 
209     function _beforeTokenTransfer(
210         address from,
211         address to,
212         uint256 amount
213     ) internal virtual {}
214 
215     function _afterTokenTransfer(
216         address from,
217         address to,
218         uint256 amount
219     ) internal virtual {}
220 }
221 
222 library SafeMath {
223 
224     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225         return a - b;
226     }
227 
228     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
229         return a * b;
230     }
231 
232     function div(uint256 a, uint256 b) internal pure returns (uint256) {
233         return a / b;
234     }
235 } 
236 
237 interface IUniswapV2Factory {
238     event PairCreated(
239         address indexed token0,
240         address indexed token1,
241         address pair,
242         uint256
243     );
244 
245     function feeTo() external view returns (address);
246 
247     function feeToSetter() external view returns (address);
248 
249     function getPair(address tokenA, address tokenB)
250         external
251         view
252         returns (address pair);
253 
254     function allPairs(uint256) external view returns (address pair);
255 
256     function allPairsLength() external view returns (uint256);
257 
258     function createPair(address tokenA, address tokenB)
259         external
260         returns (address pair);
261 
262     function setFeeTo(address) external;
263 
264     function setFeeToSetter(address) external;
265 }
266 
267 interface IUniswapV2Pair {
268     event Approval(
269         address indexed owner,
270         address indexed spender,
271         uint256 value
272     );
273     event Transfer(address indexed from, address indexed to, uint256 value);
274 
275     function name() external pure returns (string memory);
276 
277     function symbol() external pure returns (string memory);
278 
279     function decimals() external pure returns (uint8);
280 
281     function totalSupply() external view returns (uint256);
282 
283     function balanceOf(address owner) external view returns (uint256);
284 
285     function allowance(address owner, address spender)
286         external
287         view
288         returns (uint256);
289 
290     function approve(address spender, uint256 value) external returns (bool);
291 
292     function transfer(address to, uint256 value) external returns (bool);
293 
294     function transferFrom(
295         address from,
296         address to,
297         uint256 value
298     ) external returns (bool);
299 
300     function DOMAIN_SEPARATOR() external view returns (bytes32);
301 
302     function PERMIT_TYPEHASH() external pure returns (bytes32);
303 
304     function nonces(address owner) external view returns (uint256);
305 
306     function permit(
307         address owner,
308         address spender,
309         uint256 value,
310         uint256 deadline,
311         uint8 v,
312         bytes32 r,
313         bytes32 s
314     ) external;
315 
316     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
317     event Burn(
318         address indexed sender,
319         uint256 amount0,
320         uint256 amount1,
321         address indexed to
322     );
323     event Swap(
324         address indexed sender,
325         uint256 amount0In,
326         uint256 amount1In,
327         uint256 amount0Out,
328         uint256 amount1Out,
329         address indexed to
330     );
331     event Sync(uint112 reserve0, uint112 reserve1);
332 
333     function MINIMUM_LIQUIDITY() external pure returns (uint256);
334 
335     function factory() external view returns (address);
336 
337     function token0() external view returns (address);
338 
339     function token1() external view returns (address);
340 
341     function getReserves()
342         external
343         view
344         returns (
345             uint112 reserve0,
346             uint112 reserve1,
347             uint32 blockTimestampLast
348         );
349 
350     function price0CumulativeLast() external view returns (uint256);
351 
352     function price1CumulativeLast() external view returns (uint256);
353 
354     function kLast() external view returns (uint256);
355 
356     function mint(address to) external returns (uint256 liquidity);
357 
358     function burn(address to)
359         external
360         returns (uint256 amount0, uint256 amount1);
361 
362     function swap(
363         uint256 amount0Out,
364         uint256 amount1Out,
365         address to,
366         bytes calldata data
367     ) external;
368 
369     function skim(address to) external;
370 
371     function sync() external;
372 
373     function initialize(address, address) external;
374 }
375 
376 interface IUniswapV2Router02 {
377     function factory() external pure returns (address);
378 
379     function WETH() external pure returns (address);
380 
381     function addLiquidity(
382         address tokenA,
383         address tokenB,
384         uint256 amountADesired,
385         uint256 amountBDesired,
386         uint256 amountAMin,
387         uint256 amountBMin,
388         address to,
389         uint256 deadline
390     )
391         external
392         returns (
393             uint256 amountA,
394             uint256 amountB,
395             uint256 liquidity
396         );
397 
398     function addLiquidityETH(
399         address token,
400         uint256 amountTokenDesired,
401         uint256 amountTokenMin,
402         uint256 amountETHMin,
403         address to,
404         uint256 deadline
405     )
406         external
407         payable
408         returns (
409             uint256 amountToken,
410             uint256 amountETH,
411             uint256 liquidity
412         );
413 
414     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
415         uint256 amountIn,
416         uint256 amountOutMin,
417         address[] calldata path,
418         address to,
419         uint256 deadline
420     ) external;
421 
422     function swapExactETHForTokensSupportingFeeOnTransferTokens(
423         uint256 amountOutMin,
424         address[] calldata path,
425         address to,
426         uint256 deadline
427     ) external payable;
428 
429     function swapExactTokensForETHSupportingFeeOnTransferTokens(
430         uint256 amountIn,
431         uint256 amountOutMin,
432         address[] calldata path,
433         address to,
434         uint256 deadline
435     ) external;
436 }
437 
438 contract SafeGrow is ERC20, Ownable {
439     using SafeMath for uint256;
440 
441     IUniswapV2Router02 public immutable uniswapV2Router;
442     address public immutable uniswapV2Pair;
443     address public constant deadAddress = address(0xdead);
444 
445     bool private swapping;
446 
447     address public marketingWallet;
448     address public devWallet;
449     address public lpWallet;
450 
451     uint256 public maxTransactionAmount;
452     uint256 public swapTokensAtAmount;
453     uint256 public maxWallet;
454 
455     bool public limitsInEffect = true;
456     bool public tradingActive = true;
457     bool public swapEnabled = true;
458 
459     uint256 public buyTotalFees;
460     uint256 public buyMarketingFee;
461     uint256 public buyLiquidityFee;
462     uint256 public buyDevFee;
463 
464     uint256 public sellTotalFees;
465     uint256 public sellMarketingFee;
466     uint256 public sellLiquidityFee;
467     uint256 public sellDevFee;
468 
469     uint256 public tokensForMarketing;
470     uint256 public tokensForLiquidity;
471     uint256 public tokensForDev;
472 
473     /******************/
474 
475     // exlcude from fees and max transaction amount
476     mapping(address => bool) private _isExcludedFromFees;
477     mapping(address => bool) public _isExcludedMaxTransactionAmount;
478 
479     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
480     // could be subject to a maximum transfer amount
481     mapping(address => bool) public automatedMarketMakerPairs;
482 
483     event UpdateUniswapV2Router(
484         address indexed newAddress,
485         address indexed oldAddress
486     );
487 
488     event LimitsRemoved();
489 
490     event ExcludeFromFees(address indexed account, bool isExcluded);
491 
492     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
493 
494     event marketingWalletUpdated(
495         address indexed newWallet,
496         address indexed oldWallet
497     );
498 
499     event devWalletUpdated(
500         address indexed newWallet,
501         address indexed oldWallet
502     );
503 
504     event lpWalletUpdated(
505         address indexed newWallet,
506         address indexed oldWallet
507     );
508 
509     event SwapAndLiquify(
510         uint256 tokensSwapped,
511         uint256 ethReceived,
512         uint256 tokensIntoLiquidity
513     );
514 
515     constructor() ERC20("SafeGrow", "SAFEGROW") {
516         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
517             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
518         );
519 
520         excludeFromMaxTransaction(address(_uniswapV2Router), true);
521         uniswapV2Router = _uniswapV2Router;
522 
523         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
524             .createPair(address(this), _uniswapV2Router.WETH());
525         excludeFromMaxTransaction(address(uniswapV2Pair), true);
526         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
527 
528         uint256 _buyMarketingFee = 15;
529         uint256 _buyLiquidityFee = 0;
530         uint256 _buyDevFee = 0;
531 
532         uint256 _sellMarketingFee = 25;
533         uint256 _sellLiquidityFee = 0;
534         uint256 _sellDevFee = 0;
535 
536         uint256 totalSupply = 1000000000000 * 1e18;
537 
538         maxTransactionAmount = (totalSupply * 2) / 100;
539         maxWallet = (totalSupply * 2) / 100;
540         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
541 
542         buyMarketingFee = _buyMarketingFee;
543         buyLiquidityFee = _buyLiquidityFee;
544         buyDevFee = _buyDevFee;
545         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
546 
547         sellMarketingFee = _sellMarketingFee;
548         sellLiquidityFee = _sellLiquidityFee;
549         sellDevFee = _sellDevFee;
550         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
551 
552         marketingWallet = address(0x9A255f4977fEA15F2F7D16f1F668e8429f37730C); 
553         devWallet = address(0x9A255f4977fEA15F2F7D16f1F668e8429f37730C);
554         lpWallet = msg.sender;
555 
556         // exclude from paying fees or having max transaction amount
557         excludeFromFees(owner(), true);
558         excludeFromFees(address(this), true);
559         excludeFromFees(address(0xdead), true);
560         excludeFromFees(marketingWallet, true);
561 
562         excludeFromMaxTransaction(owner(), true);
563         excludeFromMaxTransaction(address(this), true);
564         excludeFromMaxTransaction(address(0xdead), true);
565         excludeFromMaxTransaction(marketingWallet, true);
566 
567         /*
568             _mint is an internal function in ERC20.sol that is only called here,
569             and CANNOT be called ever again
570         */
571         _mint(msg.sender, totalSupply);
572     }
573 
574     receive() external payable {}
575 
576     // once enabled, can never be turned off
577     function enableTrading() external onlyOwner {
578         tradingActive = true;
579         swapEnabled = true;
580     }
581 
582     // remove limits after token is stable
583     function removeLimits() external onlyOwner returns (bool) {
584         limitsInEffect = false;
585         emit LimitsRemoved();
586         return true;
587     }
588 
589     // change the minimum amount of tokens to sell from fees
590     function updateSwapTokensAtAmount(uint256 newAmount)
591         external
592         onlyOwner
593         returns (bool)
594     {
595         require(
596             newAmount >= (totalSupply() * 1) / 100000,
597             "Swap amount cannot be lower than 0.001% total supply."
598         );
599         require(
600             newAmount <= (totalSupply() * 5) / 1000,
601             "Swap amount cannot be higher than 0.5% total supply."
602         );
603         swapTokensAtAmount = newAmount;
604         return true;
605     }
606 
607     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
608         require(
609             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
610             "Cannot set maxTransactionAmount lower than 0.1%"
611         );
612         maxTransactionAmount = newNum * (10**18);
613     }
614 
615     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
616         require(
617             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
618             "Cannot set maxWallet lower than 0.5%"
619         );
620         maxWallet = newNum * (10**18);
621     }
622 
623     function excludeFromMaxTransaction(address updAds, bool isEx)
624         public
625         onlyOwner
626     {
627         _isExcludedMaxTransactionAmount[updAds] = isEx;
628     }
629 
630     // only use to disable contract sales if absolutely necessary (emergency use only)
631     function updateSwapEnabled(bool enabled) external onlyOwner {
632         swapEnabled = enabled;
633     }
634 
635     function updateBuyFees(
636         uint256 _marketingFee,
637         uint256 _liquidityFee,
638         uint256 _devFee
639     ) external onlyOwner {
640         buyMarketingFee = _marketingFee;
641         buyLiquidityFee = _liquidityFee;
642         buyDevFee = _devFee;
643         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
644     }
645 
646     function updateSellFees(
647         uint256 _marketingFee,
648         uint256 _liquidityFee,
649         uint256 _devFee
650     ) external onlyOwner {
651         sellMarketingFee = _marketingFee;
652         sellLiquidityFee = _liquidityFee;
653         sellDevFee = _devFee;
654         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
655     }
656 
657     function excludeFromFees(address account, bool excluded) public onlyOwner {
658         _isExcludedFromFees[account] = excluded;
659         emit ExcludeFromFees(account, excluded);
660     }
661 
662     function setAutomatedMarketMakerPair(address pair, bool value)
663         public
664         onlyOwner
665     {
666         require(
667             pair != uniswapV2Pair,
668             "The pair cannot be removed from automatedMarketMakerPairs"
669         );
670 
671         _setAutomatedMarketMakerPair(pair, value);
672     }
673 
674     function _setAutomatedMarketMakerPair(address pair, bool value) private {
675         automatedMarketMakerPairs[pair] = value;
676 
677         emit SetAutomatedMarketMakerPair(pair, value);
678     }
679 
680     function updateMarketingWallet(address newMarketingWallet)
681         external
682         onlyOwner
683     {
684         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
685         marketingWallet = newMarketingWallet;
686     }
687 
688     function updateLPWallet(address newLPWallet)
689         external
690         onlyOwner
691     {
692         emit lpWalletUpdated(newLPWallet, lpWallet);
693         lpWallet = newLPWallet;
694     }
695 
696     function updateDevWallet(address newWallet) external onlyOwner {
697         emit devWalletUpdated(newWallet, devWallet);
698         devWallet = newWallet;
699     }
700 
701     function isExcludedFromFees(address account) public view returns (bool) {
702         return _isExcludedFromFees[account];
703     }
704 
705     event BoughtEarly(address indexed sniper);
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
720         if (limitsInEffect) {
721             if (
722                 from != owner() &&
723                 to != owner() &&
724                 to != address(0) &&
725                 to != address(0xdead) &&
726                 !swapping
727             ) {
728                 if (!tradingActive) {
729                     require(
730                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
731                         "Trading is not active."
732                     );
733                 }
734 
735                 //when buy
736                 if (
737                     automatedMarketMakerPairs[from] &&
738                     !_isExcludedMaxTransactionAmount[to]
739                 ) {
740                     require(
741                         amount <= maxTransactionAmount,
742                         "Buy transfer amount exceeds the maxTransactionAmount."
743                     );
744                     require(
745                         amount + balanceOf(to) <= maxWallet,
746                         "Max wallet exceeded"
747                     );
748                 }
749                 //when sell
750                 else if (
751                     automatedMarketMakerPairs[to] &&
752                     !_isExcludedMaxTransactionAmount[from]
753                 ) {
754                     require(
755                         amount <= maxTransactionAmount,
756                         "Sell transfer amount exceeds the maxTransactionAmount."
757                     );
758                 } else if (!_isExcludedMaxTransactionAmount[to]) {
759                     require(
760                         amount + balanceOf(to) <= maxWallet,
761                         "Max wallet exceeded"
762                     );
763                 }
764             }
765         }
766 
767         uint256 contractTokenBalance = balanceOf(address(this));
768 
769         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
770 
771         if (
772             canSwap &&
773             swapEnabled &&
774             !swapping &&
775             !automatedMarketMakerPairs[from] &&
776             !_isExcludedFromFees[from] &&
777             !_isExcludedFromFees[to]
778         ) {
779             swapping = true;
780 
781             swapBack();
782 
783             swapping = false;
784         }
785 
786         bool takeFee = !swapping;
787 
788         // if any account belongs to _isExcludedFromFee account then remove the fee
789         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
790             takeFee = false;
791         }
792 
793         uint256 fees = 0;
794         // only take fees on buys/sells, do not take on wallet transfers
795         if (takeFee) {
796             // on sell
797             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
798                 fees = amount.mul(sellTotalFees).div(100);
799                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
800                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
801                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
802             }
803             // on buy
804             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
805                 fees = amount.mul(buyTotalFees).div(100);
806                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
807                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
808                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
809             }
810 
811             if (fees > 0) {
812                 super._transfer(from, address(this), fees);
813             }
814 
815             amount -= fees;
816         }
817 
818         super._transfer(from, to, amount);
819     }
820 
821     function swapTokensForEth(uint256 tokenAmount) private {
822         // generate the uniswap pair path of token -> weth
823         address[] memory path = new address[](2);
824         path[0] = address(this);
825         path[1] = uniswapV2Router.WETH();
826 
827         _approve(address(this), address(uniswapV2Router), tokenAmount);
828 
829         // make the swap
830         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
831             tokenAmount,
832             0, // accept any amount of ETH
833             path,
834             address(this),
835             block.timestamp
836         );
837     }
838 
839     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
840         // approve token transfer to cover all possible scenarios
841         _approve(address(this), address(uniswapV2Router), tokenAmount);
842 
843         // add the liquidity
844         uniswapV2Router.addLiquidityETH{value: ethAmount}(
845             address(this),
846             tokenAmount,
847             0, // slippage is unavoidable
848             0, // slippage is unavoidable
849             lpWallet,
850             block.timestamp
851         );
852     }
853 
854     function swapBack() private {
855         uint256 contractBalance = balanceOf(address(this));
856         uint256 totalTokensToSwap = tokensForLiquidity +
857             tokensForMarketing +
858             tokensForDev;
859         bool success;
860 
861         if (contractBalance == 0 || totalTokensToSwap == 0) {
862             return;
863         }
864 
865         // Halve the amount of liquidity tokens
866         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
867             totalTokensToSwap /
868             2;
869         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
870 
871         uint256 initialETHBalance = address(this).balance;
872 
873         swapTokensForEth(amountToSwapForETH);
874 
875         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
876 
877         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
878             totalTokensToSwap
879         );
880         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
881 
882         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
883 
884         tokensForLiquidity = 0;
885         tokensForMarketing = 0;
886         tokensForDev = 0;
887 
888         (success, ) = address(devWallet).call{value: ethForDev}("");
889 
890         if (liquidityTokens > 0 && ethForLiquidity > 0) {
891             addLiquidity(liquidityTokens, ethForLiquidity);
892             emit SwapAndLiquify(
893                 amountToSwapForETH,
894                 ethForLiquidity,
895                 tokensForLiquidity
896             );
897         }
898 
899         (success, ) = address(marketingWallet).call{
900             value: address(this).balance
901         }("");
902     }
903 }