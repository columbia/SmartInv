1 /**
2  
3 Telegram: https://t.me/fatpepecoin
4 Twitter: https://twitter.com/fatpepeerc
5 Website: https://fatpepecoin.com
6 Contract Renounced
7 Liquidity Burned
8 
9 */
10 
11 //  SPDX-License-Identifier: MIT
12 pragma solidity >=0.8.19;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19 }
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     modifier onlyOwner() {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39     function renounceOwnership() public virtual onlyOwner {
40         _transferOwnership(address(0));
41     }
42 
43     function transferOwnership(address newOwner) public virtual onlyOwner {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
45         _transferOwnership(newOwner);
46     }
47 
48     function _transferOwnership(address newOwner) internal virtual {
49         address oldOwner = _owner;
50         _owner = newOwner;
51         emit OwnershipTransferred(oldOwner, newOwner);
52     }
53 }
54 
55 interface IERC20 {
56 
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address account) external view returns (uint256);
60 
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 interface IERC20Metadata is IERC20 {
79 
80     function name() external view returns (string memory);
81 
82     function symbol() external view returns (string memory);
83 
84     function decimals() external view returns (uint8);
85 }
86 
87 contract ERC20 is Context, IERC20, IERC20Metadata {
88     mapping(address => uint256) private _balances;
89 
90     mapping(address => mapping(address => uint256)) private _allowances;
91 
92     uint256 private _totalSupply;
93 
94     string private _name;
95     string private _symbol;
96 
97     constructor(string memory name_, string memory symbol_) {
98         _name = name_;
99         _symbol = symbol_;
100     }
101 
102     function name() public view virtual override returns (string memory) {
103         return _name;
104     }
105 
106     function symbol() public view virtual override returns (string memory) {
107         return _symbol;
108     }
109 
110     function decimals() public view virtual override returns (uint8) {
111         return 18;
112     }
113 
114     function totalSupply() public view virtual override returns (uint256) {
115         return _totalSupply;
116     }
117 
118     function balanceOf(address account) public view virtual override returns (uint256) {
119         return _balances[account];
120     }
121 
122     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
123         _transfer(_msgSender(), recipient, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view virtual override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
132         _approve(_msgSender(), spender, amount);
133         return true;
134     }
135 
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) public virtual override returns (bool) {
141         _transfer(sender, recipient, amount);
142 
143         uint256 currentAllowance = _allowances[sender][_msgSender()];
144         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
145         unchecked {
146             _approve(sender, _msgSender(), currentAllowance - amount);
147         }
148 
149         return true;
150     }
151 
152     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
153         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
154         return true;
155     }
156 
157     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
158         uint256 currentAllowance = _allowances[_msgSender()][spender];
159         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
160         unchecked {
161             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
162         }
163 
164         return true;
165     }
166 
167     function _transfer(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) internal virtual {
172         require(sender != address(0), "ERC20: transfer from the zero address");
173         require(recipient != address(0), "ERC20: transfer to the zero address");
174 
175         _beforeTokenTransfer(sender, recipient, amount);
176 
177         uint256 senderBalance = _balances[sender];
178         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
179         unchecked {
180             _balances[sender] = senderBalance - amount;
181         }
182         _balances[recipient] += amount;
183 
184         emit Transfer(sender, recipient, amount);
185 
186         _afterTokenTransfer(sender, recipient, amount);
187     }
188 
189     function _mint(address account, uint256 amount) internal virtual {
190         require(account != address(0), "ERC20: mint to the zero address");
191 
192         _beforeTokenTransfer(address(0), account, amount);
193 
194         _totalSupply += amount;
195         _balances[account] += amount;
196         emit Transfer(address(0), account, amount);
197 
198         _afterTokenTransfer(address(0), account, amount);
199     }
200 
201     function _approve(
202         address owner,
203         address spender,
204         uint256 amount
205     ) internal virtual {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208 
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _beforeTokenTransfer(
214         address from,
215         address to,
216         uint256 amount
217     ) internal virtual {}
218 
219     function _afterTokenTransfer(
220         address from,
221         address to,
222         uint256 amount
223     ) internal virtual {}
224 }
225 
226 library SafeMath {
227 
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         return a - b;
230     }
231 
232     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
233         return a * b;
234     }
235 
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         return a / b;
238     }
239 } 
240 
241 interface IUniswapV2Factory {
242     event PairCreated(
243         address indexed token0,
244         address indexed token1,
245         address pair,
246         uint256
247     );
248 
249     function feeTo() external view returns (address);
250 
251     function feeToSetter() external view returns (address);
252 
253     function getPair(address tokenA, address tokenB)
254         external
255         view
256         returns (address pair);
257 
258     function allPairs(uint256) external view returns (address pair);
259 
260     function allPairsLength() external view returns (uint256);
261 
262     function createPair(address tokenA, address tokenB)
263         external
264         returns (address pair);
265 
266     function setFeeTo(address) external;
267 
268     function setFeeToSetter(address) external;
269 }
270 
271 interface IUniswapV2Pair {
272     event Approval(
273         address indexed owner,
274         address indexed spender,
275         uint256 value
276     );
277     event Transfer(address indexed from, address indexed to, uint256 value);
278 
279     function name() external pure returns (string memory);
280 
281     function symbol() external pure returns (string memory);
282 
283     function decimals() external pure returns (uint8);
284 
285     function totalSupply() external view returns (uint256);
286 
287     function balanceOf(address owner) external view returns (uint256);
288 
289     function allowance(address owner, address spender)
290         external
291         view
292         returns (uint256);
293 
294     function approve(address spender, uint256 value) external returns (bool);
295 
296     function transfer(address to, uint256 value) external returns (bool);
297 
298     function transferFrom(
299         address from,
300         address to,
301         uint256 value
302     ) external returns (bool);
303 
304     function DOMAIN_SEPARATOR() external view returns (bytes32);
305 
306     function PERMIT_TYPEHASH() external pure returns (bytes32);
307 
308     function nonces(address owner) external view returns (uint256);
309 
310     function permit(
311         address owner,
312         address spender,
313         uint256 value,
314         uint256 deadline,
315         uint8 v,
316         bytes32 r,
317         bytes32 s
318     ) external;
319 
320     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
321     event Burn(
322         address indexed sender,
323         uint256 amount0,
324         uint256 amount1,
325         address indexed to
326     );
327     event Swap(
328         address indexed sender,
329         uint256 amount0In,
330         uint256 amount1In,
331         uint256 amount0Out,
332         uint256 amount1Out,
333         address indexed to
334     );
335     event Sync(uint112 reserve0, uint112 reserve1);
336 
337     function MINIMUM_LIQUIDITY() external pure returns (uint256);
338 
339     function factory() external view returns (address);
340 
341     function token0() external view returns (address);
342 
343     function token1() external view returns (address);
344 
345     function getReserves()
346         external
347         view
348         returns (
349             uint112 reserve0,
350             uint112 reserve1,
351             uint32 blockTimestampLast
352         );
353 
354     function price0CumulativeLast() external view returns (uint256);
355 
356     function price1CumulativeLast() external view returns (uint256);
357 
358     function kLast() external view returns (uint256);
359 
360     function mint(address to) external returns (uint256 liquidity);
361 
362     function burn(address to)
363         external
364         returns (uint256 amount0, uint256 amount1);
365 
366     function swap(
367         uint256 amount0Out,
368         uint256 amount1Out,
369         address to,
370         bytes calldata data
371     ) external;
372 
373     function skim(address to) external;
374 
375     function sync() external;
376 
377     function initialize(address, address) external;
378 }
379 
380 interface IUniswapV2Router02 {
381     function factory() external pure returns (address);
382 
383     function WETH() external pure returns (address);
384 
385     function addLiquidity(
386         address tokenA,
387         address tokenB,
388         uint256 amountADesired,
389         uint256 amountBDesired,
390         uint256 amountAMin,
391         uint256 amountBMin,
392         address to,
393         uint256 deadline
394     )
395         external
396         returns (
397             uint256 amountA,
398             uint256 amountB,
399             uint256 liquidity
400         );
401 
402     function addLiquidityETH(
403         address token,
404         uint256 amountTokenDesired,
405         uint256 amountTokenMin,
406         uint256 amountETHMin,
407         address to,
408         uint256 deadline
409     )
410         external
411         payable
412         returns (
413             uint256 amountToken,
414             uint256 amountETH,
415             uint256 liquidity
416         );
417 
418     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
419         uint256 amountIn,
420         uint256 amountOutMin,
421         address[] calldata path,
422         address to,
423         uint256 deadline
424     ) external;
425 
426     function swapExactETHForTokensSupportingFeeOnTransferTokens(
427         uint256 amountOutMin,
428         address[] calldata path,
429         address to,
430         uint256 deadline
431     ) external payable;
432 
433     function swapExactTokensForETHSupportingFeeOnTransferTokens(
434         uint256 amountIn,
435         uint256 amountOutMin,
436         address[] calldata path,
437         address to,
438         uint256 deadline
439     ) external;
440 }
441 
442 contract FATPEPE is ERC20, Ownable {
443     using SafeMath for uint256;
444 
445     IUniswapV2Router02 public immutable uniswapV2Router;
446     address public immutable uniswapV2Pair;
447     address public constant deadAddress = address(0xdead);
448 
449     bool private swapping;
450 
451     address public marketingWallet;
452     address public devWallet;
453     address public lpWallet;
454 
455     uint256 public maxTransactionAmount;
456     uint256 public swapTokensAtAmount;
457     uint256 public maxWallet;
458 
459     bool public limitsInEffect = true;
460     bool public tradingActive = true;
461     bool public swapEnabled = true;
462 
463     uint256 public buyTotalFees;
464     uint256 public buyMarketingFee;
465     uint256 public buyLiquidityFee;
466     uint256 public buyDevFee;
467 
468     uint256 public sellTotalFees;
469     uint256 public sellMarketingFee;
470     uint256 public sellLiquidityFee;
471     uint256 public sellDevFee;
472 
473     uint256 public tokensForMarketing;
474     uint256 public tokensForLiquidity;
475     uint256 public tokensForDev;
476 
477     /******************/
478 
479     // exlcude from fees and max transaction amount
480     mapping(address => bool) private _isExcludedFromFees;
481     mapping(address => bool) public _isExcludedMaxTransactionAmount;
482 
483     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
484     // could be subject to a maximum transfer amount
485     mapping(address => bool) public automatedMarketMakerPairs;
486 
487     event UpdateUniswapV2Router(
488         address indexed newAddress,
489         address indexed oldAddress
490     );
491 
492     event LimitsRemoved();
493 
494     event ExcludeFromFees(address indexed account, bool isExcluded);
495 
496     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
497 
498     event marketingWalletUpdated(
499         address indexed newWallet,
500         address indexed oldWallet
501     );
502 
503     event devWalletUpdated(
504         address indexed newWallet,
505         address indexed oldWallet
506     );
507 
508     event lpWalletUpdated(
509         address indexed newWallet,
510         address indexed oldWallet
511     );
512 
513     event SwapAndLiquify(
514         uint256 tokensSwapped,
515         uint256 ethReceived,
516         uint256 tokensIntoLiquidity
517     );
518 
519     constructor() ERC20("FAT PEPE", "FAP") {
520         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
521             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
522         );
523 
524         excludeFromMaxTransaction(address(_uniswapV2Router), true);
525         uniswapV2Router = _uniswapV2Router;
526 
527         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
528             .createPair(address(this), _uniswapV2Router.WETH());
529         excludeFromMaxTransaction(address(uniswapV2Pair), true);
530         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
531 
532         uint256 _buyMarketingFee = 20;
533         uint256 _buyLiquidityFee = 0;
534         uint256 _buyDevFee = 0;
535 
536         uint256 _sellMarketingFee = 20;
537         uint256 _sellLiquidityFee = 0;
538         uint256 _sellDevFee = 0;
539 
540         uint256 totalSupply = 69000  * 1e18;
541 
542         maxTransactionAmount = (totalSupply * 2) / 100;
543         maxWallet = (totalSupply * 2) / 100;
544         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
545 
546         buyMarketingFee = _buyMarketingFee;
547         buyLiquidityFee = _buyLiquidityFee;
548         buyDevFee = _buyDevFee;
549         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
550 
551         sellMarketingFee = _sellMarketingFee;
552         sellLiquidityFee = _sellLiquidityFee;
553         sellDevFee = _sellDevFee;
554         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
555 
556         marketingWallet = address(0x97fEB9c36771c40404F2575536956b5B8fa21213); 
557         devWallet = address(0x97fEB9c36771c40404F2575536956b5B8fa21213);
558         lpWallet = msg.sender;
559 
560         // exclude from paying fees or having max transaction amount
561         excludeFromFees(owner(), true);
562         excludeFromFees(address(this), true);
563         excludeFromFees(address(0xdead), true);
564         excludeFromFees(marketingWallet, true);
565 
566         excludeFromMaxTransaction(owner(), true);
567         excludeFromMaxTransaction(address(this), true);
568         excludeFromMaxTransaction(address(0xdead), true);
569         excludeFromMaxTransaction(marketingWallet, true);
570 
571         /*
572             _mint is an internal function in ERC20.sol that is only called here,
573             and CANNOT be called ever again
574         */
575         _mint(msg.sender, totalSupply);
576     }
577 
578     receive() external payable {}
579 
580     // once enabled, can never be turned off
581     function enableTrading() external onlyOwner {
582         tradingActive = true;
583         swapEnabled = true;
584     }
585 
586     // remove limits after token is stable
587     function removeLimits() external onlyOwner returns (bool) {
588         limitsInEffect = false;
589         emit LimitsRemoved();
590         return true;
591     }
592 
593     // change the minimum amount of tokens to sell from fees
594     function updateSwapTokensAtAmount(uint256 newAmount)
595         external
596         onlyOwner
597         returns (bool)
598     {
599         require(
600             newAmount >= (totalSupply() * 1) / 100000,
601             "Swap amount cannot be lower than 0.001% total supply."
602         );
603         require(
604             newAmount <= (totalSupply() * 5) / 1000,
605             "Swap amount cannot be higher than 0.5% total supply."
606         );
607         swapTokensAtAmount = newAmount;
608         return true;
609     }
610 
611     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
612         require(
613             newNum >= ((totalSupply() * 1) / 100) / 1e18,
614             "Cannot set maxTransactionAmount lower than 1%"
615         );
616         maxTransactionAmount = newNum * (10**18);
617     }
618 
619     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
620         require(
621             newNum >= ((totalSupply() * 1) / 100) / 1e18,
622             "Cannot set maxWallet lower than 1%"
623         );
624         maxWallet = newNum * (10**18);
625     }
626 
627     function excludeFromMaxTransaction(address updAds, bool isEx)
628         public
629         onlyOwner
630     {
631         _isExcludedMaxTransactionAmount[updAds] = isEx;
632     }
633 
634     // only use to disable contract sales if absolutely necessary (emergency use only)
635     function updateSwapEnabled(bool enabled) external onlyOwner {
636         swapEnabled = enabled;
637     }
638 
639     function updateBuyFees(
640         uint256 _marketingFee,
641         uint256 _liquidityFee,
642         uint256 _devFee
643     ) external onlyOwner {
644          require((_marketingFee + _liquidityFee + _devFee) <= 20 ,"Buy fee cant be sent more than 20%");
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
656         require((_marketingFee + _liquidityFee + _devFee) <= 20 ,"Sell fee cant be sent more than 20% ");
657         sellMarketingFee = _marketingFee;
658         sellLiquidityFee = _liquidityFee;
659         sellDevFee = _devFee;
660         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
661     }
662 
663     function excludeFromFees(address account, bool excluded) public onlyOwner {
664         _isExcludedFromFees[account] = excluded;
665         emit ExcludeFromFees(account, excluded);
666     }
667 
668     function setAutomatedMarketMakerPair(address pair, bool value)
669         public
670         onlyOwner
671     {
672         require(
673             pair != uniswapV2Pair,
674             "The pair cannot be removed from automatedMarketMakerPairs"
675         );
676 
677         _setAutomatedMarketMakerPair(pair, value);
678     }
679 
680     function _setAutomatedMarketMakerPair(address pair, bool value) private {
681         automatedMarketMakerPairs[pair] = value;
682 
683         emit SetAutomatedMarketMakerPair(pair, value);
684     }
685 
686     function updateMarketingWallet(address newMarketingWallet)
687         external
688         onlyOwner
689     {
690         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
691         marketingWallet = newMarketingWallet;
692     }
693 
694     function updateLPWallet(address newLPWallet)
695         external
696         onlyOwner
697     {
698         emit lpWalletUpdated(newLPWallet, lpWallet);
699         lpWallet = newLPWallet;
700     }
701 
702     function updateDevWallet(address newWallet) external onlyOwner {
703         emit devWalletUpdated(newWallet, devWallet);
704         devWallet = newWallet;
705     }
706 
707     function isExcludedFromFees(address account) public view returns (bool) {
708         return _isExcludedFromFees[account];
709     }
710 
711     event BoughtEarly(address indexed sniper);
712 
713     function _transfer(
714         address from,
715         address to,
716         uint256 amount
717     ) internal override {
718         require(from != address(0), "ERC20: transfer from the zero address");
719         require(to != address(0), "ERC20: transfer to the zero address");
720 
721         if (amount == 0) {
722             super._transfer(from, to, 0);
723             return;
724         }
725 
726         if (limitsInEffect) {
727             if (
728                 from != owner() &&
729                 to != owner() &&
730                 to != address(0) &&
731                 to != address(0xdead) &&
732                 !swapping
733             ) {
734                 if (!tradingActive) {
735                     require(
736                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
737                         "Trading is not active."
738                     );
739                 }
740 
741                 //when buy
742                 if (
743                     automatedMarketMakerPairs[from] &&
744                     !_isExcludedMaxTransactionAmount[to]
745                 ) {
746                     require(
747                         amount <= maxTransactionAmount,
748                         "Buy transfer amount exceeds the maxTransactionAmount."
749                     );
750                     require(
751                         amount + balanceOf(to) <= maxWallet,
752                         "Max wallet exceeded"
753                     );
754                 }
755                 //when sell
756                 else if (
757                     automatedMarketMakerPairs[to] &&
758                     !_isExcludedMaxTransactionAmount[from]
759                 ) {
760                     require(
761                         amount <= maxTransactionAmount,
762                         "Sell transfer amount exceeds the maxTransactionAmount."
763                     );
764                 } else if (!_isExcludedMaxTransactionAmount[to]) {
765                     require(
766                         amount + balanceOf(to) <= maxWallet,
767                         "Max wallet exceeded"
768                     );
769                 }
770             }
771         }
772 
773         uint256 contractTokenBalance = balanceOf(address(this));
774 
775         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
776 
777         if (
778             canSwap &&
779             swapEnabled &&
780             !swapping &&
781             !automatedMarketMakerPairs[from] &&
782             !_isExcludedFromFees[from] &&
783             !_isExcludedFromFees[to]
784         ) {
785             swapping = true;
786 
787             swapBack();
788 
789             swapping = false;
790         }
791 
792         bool takeFee = !swapping;
793 
794         // if any account belongs to _isExcludedFromFee account then remove the fee
795         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
796             takeFee = false;
797         }
798 
799         uint256 fees = 0;
800         // only take fees on buys/sells, do not take on wallet transfers
801         if (takeFee) {
802             // on sell
803             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
804                 fees = amount.mul(sellTotalFees).div(100);
805                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
806                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
807                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
808             }
809             // on buy
810             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
811                 fees = amount.mul(buyTotalFees).div(100);
812                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
813                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
814                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
815             }
816 
817             if (fees > 0) {
818                 super._transfer(from, address(this), fees);
819             }
820 
821             amount -= fees;
822         }
823 
824         super._transfer(from, to, amount);
825     }
826 
827     function swapTokensForEth(uint256 tokenAmount) private {
828         // generate the uniswap pair path of token -> weth
829         address[] memory path = new address[](2);
830         path[0] = address(this);
831         path[1] = uniswapV2Router.WETH();
832 
833         _approve(address(this), address(uniswapV2Router), tokenAmount);
834 
835         // make the swap
836         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
837             tokenAmount,
838             0, // accept any amount of ETH
839             path,
840             address(this),
841             block.timestamp
842         );
843     }
844 
845     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
846         // approve token transfer to cover all possible scenarios
847         _approve(address(this), address(uniswapV2Router), tokenAmount);
848 
849         // add the liquidity
850         uniswapV2Router.addLiquidityETH{value: ethAmount}(
851             address(this),
852             tokenAmount,
853             0, // slippage is unavoidable
854             0, // slippage is unavoidable
855             lpWallet,
856             block.timestamp
857         );
858     }
859 
860     function swapBack() private {
861         uint256 contractBalance = balanceOf(address(this));
862         uint256 totalTokensToSwap = tokensForLiquidity +
863             tokensForMarketing +
864             tokensForDev;
865         bool success;
866 
867         if (contractBalance == 0 || totalTokensToSwap == 0) {
868             return;
869         }
870 
871         // Halve the amount of liquidity tokens
872         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
873             totalTokensToSwap /
874             2;
875         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
876 
877         uint256 initialETHBalance = address(this).balance;
878 
879         swapTokensForEth(amountToSwapForETH);
880 
881         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
882 
883         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
884             totalTokensToSwap
885         );
886         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
887 
888         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
889 
890         tokensForLiquidity = 0;
891         tokensForMarketing = 0;
892         tokensForDev = 0;
893 
894         (success, ) = address(devWallet).call{value: ethForDev}("");
895 
896         if (liquidityTokens > 0 && ethForLiquidity > 0) {
897             addLiquidity(liquidityTokens, ethForLiquidity);
898             emit SwapAndLiquify(
899                 amountToSwapForETH,
900                 ethForLiquidity,
901                 tokensForLiquidity
902             );
903         }
904 
905         (success, ) = address(marketingWallet).call{
906             value: address(this).balance
907         }("");
908     }
909 }