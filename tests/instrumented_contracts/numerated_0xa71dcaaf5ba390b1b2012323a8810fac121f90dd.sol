1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-15
3 */
4 
5 /**
6  
7  Website: https://safegrowtoken.com
8 Telegram: https://t.me/SafeGrowProject
9 Twitter: https://www.twitter.com/SafeGrowToken
10 */
11 
12 //  SPDX-License-Identifier: MIT
13 pragma solidity >=0.8.19;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20 }
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor() {
28         _transferOwnership(_msgSender());
29     }
30 
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     modifier onlyOwner() {
36         require(owner() == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     function renounceOwnership() public virtual onlyOwner {
41         _transferOwnership(address(0));
42     }
43 
44     function transferOwnership(address newOwner) public virtual onlyOwner {
45         require(newOwner != address(0), "Ownable: new owner is the zero address");
46         _transferOwnership(newOwner);
47     }
48 
49     function _transferOwnership(address newOwner) internal virtual {
50         address oldOwner = _owner;
51         _owner = newOwner;
52         emit OwnershipTransferred(oldOwner, newOwner);
53     }
54 }
55 
56 interface IERC20 {
57 
58     function totalSupply() external view returns (uint256);
59 
60     function balanceOf(address account) external view returns (uint256);
61 
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 interface IERC20Metadata is IERC20 {
80 
81     function name() external view returns (string memory);
82 
83     function symbol() external view returns (string memory);
84 
85     function decimals() external view returns (uint8);
86 }
87 
88 contract ERC20 is Context, IERC20, IERC20Metadata {
89     mapping(address => uint256) private _balances;
90 
91     mapping(address => mapping(address => uint256)) private _allowances;
92 
93     uint256 private _totalSupply;
94 
95     string private _name;
96     string private _symbol;
97 
98     constructor(string memory name_, string memory symbol_) {
99         _name = name_;
100         _symbol = symbol_;
101     }
102 
103     function name() public view virtual override returns (string memory) {
104         return _name;
105     }
106 
107     function symbol() public view virtual override returns (string memory) {
108         return _symbol;
109     }
110 
111     function decimals() public view virtual override returns (uint8) {
112         return 18;
113     }
114 
115     function totalSupply() public view virtual override returns (uint256) {
116         return _totalSupply;
117     }
118 
119     function balanceOf(address account) public view virtual override returns (uint256) {
120         return _balances[account];
121     }
122 
123     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
124         _transfer(_msgSender(), recipient, amount);
125         return true;
126     }
127 
128     function allowance(address owner, address spender) public view virtual override returns (uint256) {
129         return _allowances[owner][spender];
130     }
131 
132     function approve(address spender, uint256 amount) public virtual override returns (bool) {
133         _approve(_msgSender(), spender, amount);
134         return true;
135     }
136 
137     function transferFrom(
138         address sender,
139         address recipient,
140         uint256 amount
141     ) public virtual override returns (bool) {
142         _transfer(sender, recipient, amount);
143 
144         uint256 currentAllowance = _allowances[sender][_msgSender()];
145         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
146         unchecked {
147             _approve(sender, _msgSender(), currentAllowance - amount);
148         }
149 
150         return true;
151     }
152 
153     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
154         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
155         return true;
156     }
157 
158     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
159         uint256 currentAllowance = _allowances[_msgSender()][spender];
160         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
161         unchecked {
162             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
163         }
164 
165         return true;
166     }
167 
168     function _transfer(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) internal virtual {
173         require(sender != address(0), "ERC20: transfer from the zero address");
174         require(recipient != address(0), "ERC20: transfer to the zero address");
175 
176         _beforeTokenTransfer(sender, recipient, amount);
177 
178         uint256 senderBalance = _balances[sender];
179         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
180         unchecked {
181             _balances[sender] = senderBalance - amount;
182         }
183         _balances[recipient] += amount;
184 
185         emit Transfer(sender, recipient, amount);
186 
187         _afterTokenTransfer(sender, recipient, amount);
188     }
189 
190     function _mint(address account, uint256 amount) internal virtual {
191         require(account != address(0), "ERC20: mint to the zero address");
192 
193         _beforeTokenTransfer(address(0), account, amount);
194 
195         _totalSupply += amount;
196         _balances[account] += amount;
197         emit Transfer(address(0), account, amount);
198 
199         _afterTokenTransfer(address(0), account, amount);
200     }
201 
202     function _approve(
203         address owner,
204         address spender,
205         uint256 amount
206     ) internal virtual {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209 
210         _allowances[owner][spender] = amount;
211         emit Approval(owner, spender, amount);
212     }
213 
214     function _beforeTokenTransfer(
215         address from,
216         address to,
217         uint256 amount
218     ) internal virtual {}
219 
220     function _afterTokenTransfer(
221         address from,
222         address to,
223         uint256 amount
224     ) internal virtual {}
225 }
226 
227 library SafeMath {
228 
229     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a - b;
231     }
232 
233     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
234         return a * b;
235     }
236 
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         return a / b;
239     }
240 } 
241 
242 interface IUniswapV2Factory {
243     event PairCreated(
244         address indexed token0,
245         address indexed token1,
246         address pair,
247         uint256
248     );
249 
250     function feeTo() external view returns (address);
251 
252     function feeToSetter() external view returns (address);
253 
254     function getPair(address tokenA, address tokenB)
255         external
256         view
257         returns (address pair);
258 
259     function allPairs(uint256) external view returns (address pair);
260 
261     function allPairsLength() external view returns (uint256);
262 
263     function createPair(address tokenA, address tokenB)
264         external
265         returns (address pair);
266 
267     function setFeeTo(address) external;
268 
269     function setFeeToSetter(address) external;
270 }
271 
272 interface IUniswapV2Pair {
273     event Approval(
274         address indexed owner,
275         address indexed spender,
276         uint256 value
277     );
278     event Transfer(address indexed from, address indexed to, uint256 value);
279 
280     function name() external pure returns (string memory);
281 
282     function symbol() external pure returns (string memory);
283 
284     function decimals() external pure returns (uint8);
285 
286     function totalSupply() external view returns (uint256);
287 
288     function balanceOf(address owner) external view returns (uint256);
289 
290     function allowance(address owner, address spender)
291         external
292         view
293         returns (uint256);
294 
295     function approve(address spender, uint256 value) external returns (bool);
296 
297     function transfer(address to, uint256 value) external returns (bool);
298 
299     function transferFrom(
300         address from,
301         address to,
302         uint256 value
303     ) external returns (bool);
304 
305     function DOMAIN_SEPARATOR() external view returns (bytes32);
306 
307     function PERMIT_TYPEHASH() external pure returns (bytes32);
308 
309     function nonces(address owner) external view returns (uint256);
310 
311     function permit(
312         address owner,
313         address spender,
314         uint256 value,
315         uint256 deadline,
316         uint8 v,
317         bytes32 r,
318         bytes32 s
319     ) external;
320 
321     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
322     event Burn(
323         address indexed sender,
324         uint256 amount0,
325         uint256 amount1,
326         address indexed to
327     );
328     event Swap(
329         address indexed sender,
330         uint256 amount0In,
331         uint256 amount1In,
332         uint256 amount0Out,
333         uint256 amount1Out,
334         address indexed to
335     );
336     event Sync(uint112 reserve0, uint112 reserve1);
337 
338     function MINIMUM_LIQUIDITY() external pure returns (uint256);
339 
340     function factory() external view returns (address);
341 
342     function token0() external view returns (address);
343 
344     function token1() external view returns (address);
345 
346     function getReserves()
347         external
348         view
349         returns (
350             uint112 reserve0,
351             uint112 reserve1,
352             uint32 blockTimestampLast
353         );
354 
355     function price0CumulativeLast() external view returns (uint256);
356 
357     function price1CumulativeLast() external view returns (uint256);
358 
359     function kLast() external view returns (uint256);
360 
361     function mint(address to) external returns (uint256 liquidity);
362 
363     function burn(address to)
364         external
365         returns (uint256 amount0, uint256 amount1);
366 
367     function swap(
368         uint256 amount0Out,
369         uint256 amount1Out,
370         address to,
371         bytes calldata data
372     ) external;
373 
374     function skim(address to) external;
375 
376     function sync() external;
377 
378     function initialize(address, address) external;
379 }
380 
381 interface IUniswapV2Router02 {
382     function factory() external pure returns (address);
383 
384     function WETH() external pure returns (address);
385 
386     function addLiquidity(
387         address tokenA,
388         address tokenB,
389         uint256 amountADesired,
390         uint256 amountBDesired,
391         uint256 amountAMin,
392         uint256 amountBMin,
393         address to,
394         uint256 deadline
395     )
396         external
397         returns (
398             uint256 amountA,
399             uint256 amountB,
400             uint256 liquidity
401         );
402 
403     function addLiquidityETH(
404         address token,
405         uint256 amountTokenDesired,
406         uint256 amountTokenMin,
407         uint256 amountETHMin,
408         address to,
409         uint256 deadline
410     )
411         external
412         payable
413         returns (
414             uint256 amountToken,
415             uint256 amountETH,
416             uint256 liquidity
417         );
418 
419     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
420         uint256 amountIn,
421         uint256 amountOutMin,
422         address[] calldata path,
423         address to,
424         uint256 deadline
425     ) external;
426 
427     function swapExactETHForTokensSupportingFeeOnTransferTokens(
428         uint256 amountOutMin,
429         address[] calldata path,
430         address to,
431         uint256 deadline
432     ) external payable;
433 
434     function swapExactTokensForETHSupportingFeeOnTransferTokens(
435         uint256 amountIn,
436         uint256 amountOutMin,
437         address[] calldata path,
438         address to,
439         uint256 deadline
440     ) external;
441 }
442 
443 contract SAFEGROW is ERC20, Ownable {
444     using SafeMath for uint256;
445 
446     IUniswapV2Router02 public immutable uniswapV2Router;
447     address public immutable uniswapV2Pair;
448     address public constant deadAddress = address(0xdead);
449 
450     bool private swapping;
451 
452     address public marketingWallet;
453     address public devWallet;
454     address public lpWallet;
455 
456     uint256 public maxTransactionAmount;
457     uint256 public swapTokensAtAmount;
458     uint256 public maxWallet;
459 
460     bool public limitsInEffect = true;
461     bool public tradingActive = true;
462     bool public swapEnabled = true;
463 
464     uint256 public buyTotalFees;
465     uint256 public buyMarketingFee;
466     uint256 public buyLiquidityFee;
467     uint256 public buyDevFee;
468 
469     uint256 public sellTotalFees;
470     uint256 public sellMarketingFee;
471     uint256 public sellLiquidityFee;
472     uint256 public sellDevFee;
473 
474     uint256 public tokensForMarketing;
475     uint256 public tokensForLiquidity;
476     uint256 public tokensForDev;
477 
478     /******************/
479 
480     // exlcude from fees and max transaction amount
481     mapping(address => bool) private _isExcludedFromFees;
482     mapping(address => bool) public _isExcludedMaxTransactionAmount;
483 
484     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
485     // could be subject to a maximum transfer amount
486     mapping(address => bool) public automatedMarketMakerPairs;
487 
488     event UpdateUniswapV2Router(
489         address indexed newAddress,
490         address indexed oldAddress
491     );
492 
493     event LimitsRemoved();
494 
495     event ExcludeFromFees(address indexed account, bool isExcluded);
496 
497     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
498 
499     event marketingWalletUpdated(
500         address indexed newWallet,
501         address indexed oldWallet
502     );
503 
504     event devWalletUpdated(
505         address indexed newWallet,
506         address indexed oldWallet
507     );
508 
509     event lpWalletUpdated(
510         address indexed newWallet,
511         address indexed oldWallet
512     );
513 
514     event SwapAndLiquify(
515         uint256 tokensSwapped,
516         uint256 ethReceived,
517         uint256 tokensIntoLiquidity
518     );
519 
520     constructor() ERC20("SafeGrow", "SFG") {
521         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
522             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
523         );
524 
525         excludeFromMaxTransaction(address(_uniswapV2Router), true);
526         uniswapV2Router = _uniswapV2Router;
527 
528         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
529             .createPair(address(this), _uniswapV2Router.WETH());
530         excludeFromMaxTransaction(address(uniswapV2Pair), true);
531         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
532 
533         uint256 _buyMarketingFee = 3;
534         uint256 _buyLiquidityFee = 2;
535         uint256 _buyDevFee = 0;
536 
537         uint256 _sellMarketingFee = 3;
538         uint256 _sellLiquidityFee = 2;
539         uint256 _sellDevFee = 0;
540 
541         uint256 totalSupply = 1000000000 * 1e18;
542 
543         maxTransactionAmount = (totalSupply * 2) / 100;
544         maxWallet = (totalSupply * 2) / 100;
545         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
546 
547         buyMarketingFee = _buyMarketingFee;
548         buyLiquidityFee = _buyLiquidityFee;
549         buyDevFee = _buyDevFee;
550         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
551 
552         sellMarketingFee = _sellMarketingFee;
553         sellLiquidityFee = _sellLiquidityFee;
554         sellDevFee = _sellDevFee;
555         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
556 
557         marketingWallet = address(0x1445802Aa5Bbcfeb84baF7B78f0830D537D5fdbE); 
558         devWallet = address(0xbF2D9704F47aeBdA7D5585aD4ae465eb3A546605);
559         lpWallet = msg.sender;
560 
561         // exclude from paying fees or having max transaction amount
562         excludeFromFees(owner(), true);
563         excludeFromFees(address(this), true);
564         excludeFromFees(address(0xdead), true);
565         excludeFromFees(marketingWallet, true);
566 
567         excludeFromMaxTransaction(owner(), true);
568         excludeFromMaxTransaction(address(this), true);
569         excludeFromMaxTransaction(address(0xdead), true);
570         excludeFromMaxTransaction(marketingWallet, true);
571 
572         /*
573             _mint is an internal function in ERC20.sol that is only called here,
574             and CANNOT be called ever again
575         */
576         _mint(msg.sender, totalSupply);
577     }
578 
579     receive() external payable {}
580 
581     // once enabled, can never be turned off
582     function enableTrading() external onlyOwner {
583         tradingActive = true;
584         swapEnabled = true;
585     }
586 
587     // remove limits after token is stable
588     function removeLimits() external onlyOwner returns (bool) {
589         limitsInEffect = false;
590         emit LimitsRemoved();
591         return true;
592     }
593 
594     // change the minimum amount of tokens to sell from fees
595     function updateSwapTokensAtAmount(uint256 newAmount)
596         external
597         onlyOwner
598         returns (bool)
599     {
600         require(
601             newAmount >= (totalSupply() * 1) / 100000,
602             "Swap amount cannot be lower than 0.001% total supply."
603         );
604         require(
605             newAmount <= (totalSupply() * 5) / 1000,
606             "Swap amount cannot be higher than 0.5% total supply."
607         );
608         swapTokensAtAmount = newAmount;
609         return true;
610     }
611 
612     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
613         require(
614             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
615             "Cannot set maxTransactionAmount lower than 0.1%"
616         );
617         maxTransactionAmount = newNum * (10**18);
618     }
619 
620     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
621         require(
622             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
623             "Cannot set maxWallet lower than 0.5%"
624         );
625         maxWallet = newNum * (10**18);
626     }
627 
628     function excludeFromMaxTransaction(address updAds, bool isEx)
629         public
630         onlyOwner
631     {
632         _isExcludedMaxTransactionAmount[updAds] = isEx;
633     }
634 
635     // only use to disable contract sales if absolutely necessary (emergency use only)
636     function updateSwapEnabled(bool enabled) external onlyOwner {
637         swapEnabled = enabled;
638     }
639 
640     function updateBuyFees(
641         uint256 _marketingFee,
642         uint256 _liquidityFee,
643         uint256 _devFee
644     ) external onlyOwner {
645         buyMarketingFee = _marketingFee;
646         buyLiquidityFee = _liquidityFee;
647         buyDevFee = _devFee;
648         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
649     }
650 
651     function updateSellFees(
652         uint256 _marketingFee,
653         uint256 _liquidityFee,
654         uint256 _devFee
655     ) external onlyOwner {
656         sellMarketingFee = _marketingFee;
657         sellLiquidityFee = _liquidityFee;
658         sellDevFee = _devFee;
659         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
660     }
661 
662     function excludeFromFees(address account, bool excluded) public onlyOwner {
663         _isExcludedFromFees[account] = excluded;
664         emit ExcludeFromFees(account, excluded);
665     }
666 
667     function setAutomatedMarketMakerPair(address pair, bool value)
668         public
669         onlyOwner
670     {
671         require(
672             pair != uniswapV2Pair,
673             "The pair cannot be removed from automatedMarketMakerPairs"
674         );
675 
676         _setAutomatedMarketMakerPair(pair, value);
677     }
678 
679     function _setAutomatedMarketMakerPair(address pair, bool value) private {
680         automatedMarketMakerPairs[pair] = value;
681 
682         emit SetAutomatedMarketMakerPair(pair, value);
683     }
684 
685     function updateMarketingWallet(address newMarketingWallet)
686         external
687         onlyOwner
688     {
689         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
690         marketingWallet = newMarketingWallet;
691     }
692 
693     function updateLPWallet(address newLPWallet)
694         external
695         onlyOwner
696     {
697         emit lpWalletUpdated(newLPWallet, lpWallet);
698         lpWallet = newLPWallet;
699     }
700 
701     function updateDevWallet(address newWallet) external onlyOwner {
702         emit devWalletUpdated(newWallet, devWallet);
703         devWallet = newWallet;
704     }
705 
706     function isExcludedFromFees(address account) public view returns (bool) {
707         return _isExcludedFromFees[account];
708     }
709 
710     event BoughtEarly(address indexed sniper);
711 
712     function _transfer(
713         address from,
714         address to,
715         uint256 amount
716     ) internal override {
717         require(from != address(0), "ERC20: transfer from the zero address");
718         require(to != address(0), "ERC20: transfer to the zero address");
719 
720         if (amount == 0) {
721             super._transfer(from, to, 0);
722             return;
723         }
724 
725         if (limitsInEffect) {
726             if (
727                 from != owner() &&
728                 to != owner() &&
729                 to != address(0) &&
730                 to != address(0xdead) &&
731                 !swapping
732             ) {
733                 if (!tradingActive) {
734                     require(
735                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
736                         "Trading is not active."
737                     );
738                 }
739 
740                 //when buy
741                 if (
742                     automatedMarketMakerPairs[from] &&
743                     !_isExcludedMaxTransactionAmount[to]
744                 ) {
745                     require(
746                         amount <= maxTransactionAmount,
747                         "Buy transfer amount exceeds the maxTransactionAmount."
748                     );
749                     require(
750                         amount + balanceOf(to) <= maxWallet,
751                         "Max wallet exceeded"
752                     );
753                 }
754                 //when sell
755                 else if (
756                     automatedMarketMakerPairs[to] &&
757                     !_isExcludedMaxTransactionAmount[from]
758                 ) {
759                     require(
760                         amount <= maxTransactionAmount,
761                         "Sell transfer amount exceeds the maxTransactionAmount."
762                     );
763                 } else if (!_isExcludedMaxTransactionAmount[to]) {
764                     require(
765                         amount + balanceOf(to) <= maxWallet,
766                         "Max wallet exceeded"
767                     );
768                 }
769             }
770         }
771 
772         uint256 contractTokenBalance = balanceOf(address(this));
773 
774         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
775 
776         if (
777             canSwap &&
778             swapEnabled &&
779             !swapping &&
780             !automatedMarketMakerPairs[from] &&
781             !_isExcludedFromFees[from] &&
782             !_isExcludedFromFees[to]
783         ) {
784             swapping = true;
785 
786             swapBack();
787 
788             swapping = false;
789         }
790 
791         bool takeFee = !swapping;
792 
793         // if any account belongs to _isExcludedFromFee account then remove the fee
794         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
795             takeFee = false;
796         }
797 
798         uint256 fees = 0;
799         // only take fees on buys/sells, do not take on wallet transfers
800         if (takeFee) {
801             // on sell
802             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
803                 fees = amount.mul(sellTotalFees).div(100);
804                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
805                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
806                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
807             }
808             // on buy
809             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
810                 fees = amount.mul(buyTotalFees).div(100);
811                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
812                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
813                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
814             }
815 
816             if (fees > 0) {
817                 super._transfer(from, address(this), fees);
818             }
819 
820             amount -= fees;
821         }
822 
823         super._transfer(from, to, amount);
824     }
825 
826     function swapTokensForEth(uint256 tokenAmount) private {
827         // generate the uniswap pair path of token -> weth
828         address[] memory path = new address[](2);
829         path[0] = address(this);
830         path[1] = uniswapV2Router.WETH();
831 
832         _approve(address(this), address(uniswapV2Router), tokenAmount);
833 
834         // make the swap
835         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
836             tokenAmount,
837             0, // accept any amount of ETH
838             path,
839             address(this),
840             block.timestamp
841         );
842     }
843 
844     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
845         // approve token transfer to cover all possible scenarios
846         _approve(address(this), address(uniswapV2Router), tokenAmount);
847 
848         // add the liquidity
849         uniswapV2Router.addLiquidityETH{value: ethAmount}(
850             address(this),
851             tokenAmount,
852             0, // slippage is unavoidable
853             0, // slippage is unavoidable
854             lpWallet,
855             block.timestamp
856         );
857     }
858 
859     function swapBack() private {
860         uint256 contractBalance = balanceOf(address(this));
861         uint256 totalTokensToSwap = tokensForLiquidity +
862             tokensForMarketing +
863             tokensForDev;
864         bool success;
865 
866         if (contractBalance == 0 || totalTokensToSwap == 0) {
867             return;
868         }
869 
870         // Halve the amount of liquidity tokens
871         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
872             totalTokensToSwap /
873             2;
874         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
875 
876         uint256 initialETHBalance = address(this).balance;
877 
878         swapTokensForEth(amountToSwapForETH);
879 
880         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
881 
882         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
883             totalTokensToSwap
884         );
885         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
886 
887         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
888 
889         tokensForLiquidity = 0;
890         tokensForMarketing = 0;
891         tokensForDev = 0;
892 
893         (success, ) = address(devWallet).call{value: ethForDev}("");
894 
895         if (liquidityTokens > 0 && ethForLiquidity > 0) {
896             addLiquidity(liquidityTokens, ethForLiquidity);
897             emit SwapAndLiquify(
898                 amountToSwapForETH,
899                 ethForLiquidity,
900                 tokensForLiquidity
901             );
902         }
903 
904         (success, ) = address(marketingWallet).call{
905             value: address(this).balance
906         }("");
907     }
908 }