1 /**
2 
3 Website: https://alienchain.dev/
4 Telegram: https://t.me/AlienChainETH
5 
6 */
7 
8 //  SPDX-License-Identifier: MIT
9 pragma solidity >=0.8.19;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16 }
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     constructor() {
24         _transferOwnership(_msgSender());
25     }
26 
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(owner() == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function renounceOwnership() public virtual onlyOwner {
37         _transferOwnership(address(0));
38     }
39 
40     function transferOwnership(address newOwner) public virtual onlyOwner {
41         require(newOwner != address(0), "Ownable: new owner is the zero address");
42         _transferOwnership(newOwner);
43     }
44 
45     function _transferOwnership(address newOwner) internal virtual {
46         address oldOwner = _owner;
47         _owner = newOwner;
48         emit OwnershipTransferred(oldOwner, newOwner);
49     }
50 }
51 
52 interface IERC20 {
53 
54     function totalSupply() external view returns (uint256);
55 
56     function balanceOf(address account) external view returns (uint256);
57 
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 interface IERC20Metadata is IERC20 {
76 
77     function name() external view returns (string memory);
78 
79     function symbol() external view returns (string memory);
80 
81     function decimals() external view returns (uint8);
82 }
83 
84 contract ERC20 is Context, IERC20, IERC20Metadata {
85     mapping(address => uint256) private _balances;
86 
87     mapping(address => mapping(address => uint256)) private _allowances;
88 
89     uint256 private _totalSupply;
90 
91     string private _name;
92     string private _symbol;
93 
94     constructor(string memory name_, string memory symbol_) {
95         _name = name_;
96         _symbol = symbol_;
97     }
98 
99     function name() public view virtual override returns (string memory) {
100         return _name;
101     }
102 
103     function symbol() public view virtual override returns (string memory) {
104         return _symbol;
105     }
106 
107     function decimals() public view virtual override returns (uint8) {
108         return 18;
109     }
110 
111     function totalSupply() public view virtual override returns (uint256) {
112         return _totalSupply;
113     }
114 
115     function balanceOf(address account) public view virtual override returns (uint256) {
116         return _balances[account];
117     }
118 
119     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
120         _transfer(_msgSender(), recipient, amount);
121         return true;
122     }
123 
124     function allowance(address owner, address spender) public view virtual override returns (uint256) {
125         return _allowances[owner][spender];
126     }
127 
128     function approve(address spender, uint256 amount) public virtual override returns (bool) {
129         _approve(_msgSender(), spender, amount);
130         return true;
131     }
132 
133     function transferFrom(
134         address sender,
135         address recipient,
136         uint256 amount
137     ) public virtual override returns (bool) {
138         _transfer(sender, recipient, amount);
139 
140         uint256 currentAllowance = _allowances[sender][_msgSender()];
141         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
142         unchecked {
143             _approve(sender, _msgSender(), currentAllowance - amount);
144         }
145 
146         return true;
147     }
148 
149     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
150         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
151         return true;
152     }
153 
154     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
155         uint256 currentAllowance = _allowances[_msgSender()][spender];
156         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
157         unchecked {
158             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
159         }
160 
161         return true;
162     }
163 
164     function _transfer(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) internal virtual {
169         require(sender != address(0), "ERC20: transfer from the zero address");
170         require(recipient != address(0), "ERC20: transfer to the zero address");
171 
172         _beforeTokenTransfer(sender, recipient, amount);
173 
174         uint256 senderBalance = _balances[sender];
175         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
176         unchecked {
177             _balances[sender] = senderBalance - amount;
178         }
179         _balances[recipient] += amount;
180 
181         emit Transfer(sender, recipient, amount);
182 
183         _afterTokenTransfer(sender, recipient, amount);
184     }
185 
186     function _mint(address account, uint256 amount) internal virtual {
187         require(account != address(0), "ERC20: mint to the zero address");
188 
189         _beforeTokenTransfer(address(0), account, amount);
190 
191         _totalSupply += amount;
192         _balances[account] += amount;
193         emit Transfer(address(0), account, amount);
194 
195         _afterTokenTransfer(address(0), account, amount);
196     }
197 
198     function _approve(
199         address owner,
200         address spender,
201         uint256 amount
202     ) internal virtual {
203         require(owner != address(0), "ERC20: approve from the zero address");
204         require(spender != address(0), "ERC20: approve to the zero address");
205 
206         _allowances[owner][spender] = amount;
207         emit Approval(owner, spender, amount);
208     }
209 
210     function _beforeTokenTransfer(
211         address from,
212         address to,
213         uint256 amount
214     ) internal virtual {}
215 
216     function _afterTokenTransfer(
217         address from,
218         address to,
219         uint256 amount
220     ) internal virtual {}
221 }
222 
223 library SafeMath {
224 
225     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a - b;
227     }
228 
229     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a * b;
231     }
232 
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         return a / b;
235     }
236 } 
237 
238 interface IUniswapV2Factory {
239     event PairCreated(
240         address indexed token0,
241         address indexed token1,
242         address pair,
243         uint256
244     );
245 
246     function feeTo() external view returns (address);
247 
248     function feeToSetter() external view returns (address);
249 
250     function getPair(address tokenA, address tokenB)
251         external
252         view
253         returns (address pair);
254 
255     function allPairs(uint256) external view returns (address pair);
256 
257     function allPairsLength() external view returns (uint256);
258 
259     function createPair(address tokenA, address tokenB)
260         external
261         returns (address pair);
262 
263     function setFeeTo(address) external;
264 
265     function setFeeToSetter(address) external;
266 }
267 
268 interface IUniswapV2Pair {
269     event Approval(
270         address indexed owner,
271         address indexed spender,
272         uint256 value
273     );
274     event Transfer(address indexed from, address indexed to, uint256 value);
275 
276     function name() external pure returns (string memory);
277 
278     function symbol() external pure returns (string memory);
279 
280     function decimals() external pure returns (uint8);
281 
282     function totalSupply() external view returns (uint256);
283 
284     function balanceOf(address owner) external view returns (uint256);
285 
286     function allowance(address owner, address spender)
287         external
288         view
289         returns (uint256);
290 
291     function approve(address spender, uint256 value) external returns (bool);
292 
293     function transfer(address to, uint256 value) external returns (bool);
294 
295     function transferFrom(
296         address from,
297         address to,
298         uint256 value
299     ) external returns (bool);
300 
301     function DOMAIN_SEPARATOR() external view returns (bytes32);
302 
303     function PERMIT_TYPEHASH() external pure returns (bytes32);
304 
305     function nonces(address owner) external view returns (uint256);
306 
307     function permit(
308         address owner,
309         address spender,
310         uint256 value,
311         uint256 deadline,
312         uint8 v,
313         bytes32 r,
314         bytes32 s
315     ) external;
316 
317     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
318     event Burn(
319         address indexed sender,
320         uint256 amount0,
321         uint256 amount1,
322         address indexed to
323     );
324     event Swap(
325         address indexed sender,
326         uint256 amount0In,
327         uint256 amount1In,
328         uint256 amount0Out,
329         uint256 amount1Out,
330         address indexed to
331     );
332     event Sync(uint112 reserve0, uint112 reserve1);
333 
334     function MINIMUM_LIQUIDITY() external pure returns (uint256);
335 
336     function factory() external view returns (address);
337 
338     function token0() external view returns (address);
339 
340     function token1() external view returns (address);
341 
342     function getReserves()
343         external
344         view
345         returns (
346             uint112 reserve0,
347             uint112 reserve1,
348             uint32 blockTimestampLast
349         );
350 
351     function price0CumulativeLast() external view returns (uint256);
352 
353     function price1CumulativeLast() external view returns (uint256);
354 
355     function kLast() external view returns (uint256);
356 
357     function mint(address to) external returns (uint256 liquidity);
358 
359     function burn(address to)
360         external
361         returns (uint256 amount0, uint256 amount1);
362 
363     function swap(
364         uint256 amount0Out,
365         uint256 amount1Out,
366         address to,
367         bytes calldata data
368     ) external;
369 
370     function skim(address to) external;
371 
372     function sync() external;
373 
374     function initialize(address, address) external;
375 }
376 
377 interface IUniswapV2Router02 {
378     function factory() external pure returns (address);
379 
380     function WETH() external pure returns (address);
381 
382     function addLiquidity(
383         address tokenA,
384         address tokenB,
385         uint256 amountADesired,
386         uint256 amountBDesired,
387         uint256 amountAMin,
388         uint256 amountBMin,
389         address to,
390         uint256 deadline
391     )
392         external
393         returns (
394             uint256 amountA,
395             uint256 amountB,
396             uint256 liquidity
397         );
398 
399     function addLiquidityETH(
400         address token,
401         uint256 amountTokenDesired,
402         uint256 amountTokenMin,
403         uint256 amountETHMin,
404         address to,
405         uint256 deadline
406     )
407         external
408         payable
409         returns (
410             uint256 amountToken,
411             uint256 amountETH,
412             uint256 liquidity
413         );
414 
415     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
416         uint256 amountIn,
417         uint256 amountOutMin,
418         address[] calldata path,
419         address to,
420         uint256 deadline
421     ) external;
422 
423     function swapExactETHForTokensSupportingFeeOnTransferTokens(
424         uint256 amountOutMin,
425         address[] calldata path,
426         address to,
427         uint256 deadline
428     ) external payable;
429 
430     function swapExactTokensForETHSupportingFeeOnTransferTokens(
431         uint256 amountIn,
432         uint256 amountOutMin,
433         address[] calldata path,
434         address to,
435         uint256 deadline
436     ) external;
437 }
438 
439 contract ALIEN is ERC20, Ownable {
440     using SafeMath for uint256;
441 
442     IUniswapV2Router02 public immutable uniswapV2Router;
443     address public immutable uniswapV2Pair;
444     address public constant deadAddress = address(0xdead);
445 
446     bool private swapping;
447 
448     address public marketingWallet;
449     address public devWallet;
450     address public lpWallet;
451 
452     uint256 public maxTransactionAmount;
453     uint256 public swapTokensAtAmount;
454     uint256 public maxWallet;
455 
456     bool public limitsInEffect = true;
457     bool public tradingActive = true;
458     bool public swapEnabled = true;
459 
460     uint256 public buyTotalFees;
461     uint256 public buyMarketingFee;
462     uint256 public buyLiquidityFee;
463     uint256 public buyDevFee;
464 
465     uint256 public sellTotalFees;
466     uint256 public sellMarketingFee;
467     uint256 public sellLiquidityFee;
468     uint256 public sellDevFee;
469 
470     uint256 public tokensForMarketing;
471     uint256 public tokensForLiquidity;
472     uint256 public tokensForDev;
473 
474     /******************/
475 
476     // exlcude from fees and max transaction amount
477     mapping(address => bool) private _isExcludedFromFees;
478     mapping(address => bool) public _isExcludedMaxTransactionAmount;
479 
480     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
481     // could be subject to a maximum transfer amount
482     mapping(address => bool) public automatedMarketMakerPairs;
483 
484     event UpdateUniswapV2Router(
485         address indexed newAddress,
486         address indexed oldAddress
487     );
488 
489     event LimitsRemoved();
490 
491     event ExcludeFromFees(address indexed account, bool isExcluded);
492 
493     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
494 
495     event marketingWalletUpdated(
496         address indexed newWallet,
497         address indexed oldWallet
498     );
499 
500     event devWalletUpdated(
501         address indexed newWallet,
502         address indexed oldWallet
503     );
504 
505     event lpWalletUpdated(
506         address indexed newWallet,
507         address indexed oldWallet
508     );
509 
510     event SwapAndLiquify(
511         uint256 tokensSwapped,
512         uint256 ethReceived,
513         uint256 tokensIntoLiquidity
514     );
515 
516     constructor() ERC20("ALIEN CHAIN", "ALIEN") {
517         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
518             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
519         );
520 
521         excludeFromMaxTransaction(address(_uniswapV2Router), true);
522         uniswapV2Router = _uniswapV2Router;
523 
524         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
525             .createPair(address(this), _uniswapV2Router.WETH());
526         excludeFromMaxTransaction(address(uniswapV2Pair), true);
527         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
528 
529         uint256 _buyMarketingFee = 30;
530         uint256 _buyLiquidityFee = 0;
531         uint256 _buyDevFee = 0;
532 
533         uint256 _sellMarketingFee = 20;
534         uint256 _sellLiquidityFee = 0;
535         uint256 _sellDevFee = 0;
536 
537         uint256 totalSupply = 10000000  * 1e18;
538 
539         maxTransactionAmount = (totalSupply * 2) / 100;
540         maxWallet = (totalSupply * 2) / 100;
541         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
542 
543         buyMarketingFee = _buyMarketingFee;
544         buyLiquidityFee = _buyLiquidityFee;
545         buyDevFee = _buyDevFee;
546         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
547 
548         sellMarketingFee = _sellMarketingFee;
549         sellLiquidityFee = _sellLiquidityFee;
550         sellDevFee = _sellDevFee;
551         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
552 
553         marketingWallet = address(0xFF27b3b352853ccf039E4a33A89EDe072759E675); 
554         devWallet = address(0xFF27b3b352853ccf039E4a33A89EDe072759E675);
555         lpWallet = msg.sender;
556 
557         // exclude from paying fees or having max transaction amount
558         excludeFromFees(owner(), true);
559         excludeFromFees(address(this), true);
560         excludeFromFees(address(0xdead), true);
561         excludeFromFees(marketingWallet, true);
562 
563         excludeFromMaxTransaction(owner(), true);
564         excludeFromMaxTransaction(address(this), true);
565         excludeFromMaxTransaction(address(0xdead), true);
566         excludeFromMaxTransaction(marketingWallet, true);
567 
568         /*
569             _mint is an internal function in ERC20.sol that is only called here,
570             and CANNOT be called ever again
571         */
572         _mint(msg.sender, totalSupply);
573     }
574 
575     receive() external payable {}
576 
577     // once enabled, can never be turned off
578     function enableTrading() external onlyOwner {
579         tradingActive = false;
580         swapEnabled = true;
581     }
582 
583     // remove limits after token is stable
584     function removeLimits() external onlyOwner returns (bool) {
585         limitsInEffect = false;
586         emit LimitsRemoved();
587         return true;
588     }
589 
590     // change the minimum amount of tokens to sell from fees
591     function updateSwapTokensAtAmount(uint256 newAmount)
592         external
593         onlyOwner
594         returns (bool)
595     {
596         require(
597             newAmount >= (totalSupply() * 1) / 100000,
598             "Swap amount cannot be lower than 0.001% total supply."
599         );
600         require(
601             newAmount <= (totalSupply() * 5) / 1000,
602             "Swap amount cannot be higher than 0.5% total supply."
603         );
604         swapTokensAtAmount = newAmount;
605         return true;
606     }
607 
608     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
609         require(
610             newNum >= ((totalSupply() * 1) / 100) / 1e18,
611             "Cannot set maxTransactionAmount lower than 1%"
612         );
613         maxTransactionAmount = newNum * (10**18);
614     }
615 
616     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
617         require(
618             newNum >= ((totalSupply() * 1) / 100) / 1e18,
619             "Cannot set maxWallet lower than 1%"
620         );
621         maxWallet = newNum * (10**18);
622     }
623 
624     function excludeFromMaxTransaction(address updAds, bool isEx)
625         public
626         onlyOwner
627     {
628         _isExcludedMaxTransactionAmount[updAds] = isEx;
629     }
630 
631     // only use to disable contract sales if absolutely necessary (emergency use only)
632     function updateSwapEnabled(bool enabled) external onlyOwner {
633         swapEnabled = enabled;
634     }
635 
636     function updateBuyFees(
637         uint256 _marketingFee,
638         uint256 _liquidityFee,
639         uint256 _devFee
640     ) external onlyOwner {
641          require((_marketingFee + _liquidityFee + _devFee) <= 20 ,"Buy fee cant be sent more than 20%");
642         buyMarketingFee = _marketingFee;
643         buyLiquidityFee = _liquidityFee;
644         buyDevFee = _devFee;
645         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
646     }
647 
648     function updateSellFees(
649         uint256 _marketingFee,
650         uint256 _liquidityFee,
651         uint256 _devFee
652     ) external onlyOwner {
653         require((_marketingFee + _liquidityFee + _devFee) <= 20 ,"Sell fee cant be sent more than 20% ");
654         sellMarketingFee = _marketingFee;
655         sellLiquidityFee = _liquidityFee;
656         sellDevFee = _devFee;
657         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
658     }
659 
660     function excludeFromFees(address account, bool excluded) public onlyOwner {
661         _isExcludedFromFees[account] = excluded;
662         emit ExcludeFromFees(account, excluded);
663     }
664 
665     function setAutomatedMarketMakerPair(address pair, bool value)
666         public
667         onlyOwner
668     {
669         require(
670             pair != uniswapV2Pair,
671             "The pair cannot be removed from automatedMarketMakerPairs"
672         );
673 
674         _setAutomatedMarketMakerPair(pair, value);
675     }
676 
677     function _setAutomatedMarketMakerPair(address pair, bool value) private {
678         automatedMarketMakerPairs[pair] = value;
679 
680         emit SetAutomatedMarketMakerPair(pair, value);
681     }
682 
683     function updateMarketingWallet(address newMarketingWallet)
684         external
685         onlyOwner
686     {
687         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
688         marketingWallet = newMarketingWallet;
689     }
690 
691     function updateLPWallet(address newLPWallet)
692         external
693         onlyOwner
694     {
695         emit lpWalletUpdated(newLPWallet, lpWallet);
696         lpWallet = newLPWallet;
697     }
698 
699     function updateDevWallet(address newWallet) external onlyOwner {
700         emit devWalletUpdated(newWallet, devWallet);
701         devWallet = newWallet;
702     }
703 
704     function isExcludedFromFees(address account) public view returns (bool) {
705         return _isExcludedFromFees[account];
706     }
707 
708     event BoughtEarly(address indexed sniper);
709 
710     function _transfer(
711         address from,
712         address to,
713         uint256 amount
714     ) internal override {
715         require(from != address(0), "ERC20: transfer from the zero address");
716         require(to != address(0), "ERC20: transfer to the zero address");
717 
718         if (amount == 0) {
719             super._transfer(from, to, 0);
720             return;
721         }
722 
723         if (limitsInEffect) {
724             if (
725                 from != owner() &&
726                 to != owner() &&
727                 to != address(0) &&
728                 to != address(0xdead) &&
729                 !swapping
730             ) {
731                 if (!tradingActive) {
732                     require(
733                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
734                         "Trading is not active."
735                     );
736                 }
737 
738                 //when buy
739                 if (
740                     automatedMarketMakerPairs[from] &&
741                     !_isExcludedMaxTransactionAmount[to]
742                 ) {
743                     require(
744                         amount <= maxTransactionAmount,
745                         "Buy transfer amount exceeds the maxTransactionAmount."
746                     );
747                     require(
748                         amount + balanceOf(to) <= maxWallet,
749                         "Max wallet exceeded"
750                     );
751                 }
752                 //when sell
753                 else if (
754                     automatedMarketMakerPairs[to] &&
755                     !_isExcludedMaxTransactionAmount[from]
756                 ) {
757                     require(
758                         amount <= maxTransactionAmount,
759                         "Sell transfer amount exceeds the maxTransactionAmount."
760                     );
761                 } else if (!_isExcludedMaxTransactionAmount[to]) {
762                     require(
763                         amount + balanceOf(to) <= maxWallet,
764                         "Max wallet exceeded"
765                     );
766                 }
767             }
768         }
769 
770         uint256 contractTokenBalance = balanceOf(address(this));
771 
772         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
773 
774         if (
775             canSwap &&
776             swapEnabled &&
777             !swapping &&
778             !automatedMarketMakerPairs[from] &&
779             !_isExcludedFromFees[from] &&
780             !_isExcludedFromFees[to]
781         ) {
782             swapping = true;
783 
784             swapBack();
785 
786             swapping = false;
787         }
788 
789         bool takeFee = !swapping;
790 
791         // if any account belongs to _isExcludedFromFee account then remove the fee
792         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
793             takeFee = false;
794         }
795 
796         uint256 fees = 0;
797         // only take fees on buys/sells, do not take on wallet transfers
798         if (takeFee) {
799             // on sell
800             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
801                 fees = amount.mul(sellTotalFees).div(100);
802                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
803                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
804                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
805             }
806             // on buy
807             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
808                 fees = amount.mul(buyTotalFees).div(100);
809                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
810                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
811                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
812             }
813 
814             if (fees > 0) {
815                 super._transfer(from, address(this), fees);
816             }
817 
818             amount -= fees;
819         }
820 
821         super._transfer(from, to, amount);
822     }
823 
824     function swapTokensForEth(uint256 tokenAmount) private {
825         // generate the uniswap pair path of token -> weth
826         address[] memory path = new address[](2);
827         path[0] = address(this);
828         path[1] = uniswapV2Router.WETH();
829 
830         _approve(address(this), address(uniswapV2Router), tokenAmount);
831 
832         // make the swap
833         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
834             tokenAmount,
835             0, // accept any amount of ETH
836             path,
837             address(this),
838             block.timestamp
839         );
840     }
841 
842     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
843         // approve token transfer to cover all possible scenarios
844         _approve(address(this), address(uniswapV2Router), tokenAmount);
845 
846         // add the liquidity
847         uniswapV2Router.addLiquidityETH{value: ethAmount}(
848             address(this),
849             tokenAmount,
850             0, // slippage is unavoidable
851             0, // slippage is unavoidable
852             lpWallet,
853             block.timestamp
854         );
855     }
856 
857     function swapBack() private {
858         uint256 contractBalance = balanceOf(address(this));
859         uint256 totalTokensToSwap = tokensForLiquidity +
860             tokensForMarketing +
861             tokensForDev;
862         bool success;
863 
864         if (contractBalance == 0 || totalTokensToSwap == 0) {
865             return;
866         }
867 
868         // Halve the amount of liquidity tokens
869         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
870             totalTokensToSwap /
871             2;
872         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
873 
874         uint256 initialETHBalance = address(this).balance;
875 
876         swapTokensForEth(amountToSwapForETH);
877 
878         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
879 
880         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
881             totalTokensToSwap
882         );
883         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
884 
885         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
886 
887         tokensForLiquidity = 0;
888         tokensForMarketing = 0;
889         tokensForDev = 0;
890 
891         (success, ) = address(devWallet).call{value: ethForDev}("");
892 
893         if (liquidityTokens > 0 && ethForLiquidity > 0) {
894             addLiquidity(liquidityTokens, ethForLiquidity);
895             emit SwapAndLiquify(
896                 amountToSwapForETH,
897                 ethForLiquidity,
898                 tokensForLiquidity
899             );
900         }
901 
902         (success, ) = address(marketingWallet).call{
903             value: address(this).balance
904         }("");
905     }
906 }