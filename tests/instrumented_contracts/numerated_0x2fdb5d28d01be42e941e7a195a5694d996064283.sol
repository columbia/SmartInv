1 // File: contracts/CRI.sol
2 
3 /**
4  
5 /*
6 hello.
7 
8 Crypto releif Inu is a charity based meme token providing auto donation to https://cryptorelief.in endorsed by Vitalik Buterin and founded by Sandeep Nailwal - Co-Founder - Polygon Technology
9 total taxes 5% 
10 Marketing wallet is set to https://cryptorelief.in/donate- 0x68A99f89E475a078645f4BAC491360aFe255Dff1
11 2% of every Tx is going to crypto relief donation address mention above.
12 2% is going towards LP.
13 1% is going towards development of project.
14 Max Tx: 15000
15 Max wallet: 30000
16 
17 Good luck
18 
19  */
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity 0.8.0;
23 
24 interface IUniswapV2Factory {
25     function createPair(address tokenA, address tokenB)
26         external
27         returns (address pair);
28 }
29 interface IUniswapV2Router01 {
30     function factory() external pure returns (address);
31     function WETH() external pure returns (address);
32     function addLiquidityETH(
33         address token,
34         uint256 amountTokenDesired,
35         uint256 amountTokenMin,
36         uint256 amountETHMin,
37         address to,
38         uint256 deadline
39     )
40         external
41         payable
42         returns (
43             uint256 amountToken,
44             uint256 amountETH,
45             uint256 liquidity
46         );
47 }
48 interface IUniswapV2Router02 is IUniswapV2Router01 {
49     function swapExactTokensForETHSupportingFeeOnTransferTokens(
50         uint256 amountIn,
51         uint256 amountOutMin,
52         address[] calldata path,
53         address to,
54         uint256 deadline
55     ) external;
56 }
57 interface IUniswapV2Pair {
58     function sync() external;
59 }
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64     function _msgData() internal view virtual returns (bytes calldata) {
65         return msg.data;
66     }
67 }
68 abstract contract Ownable is Context {
69     address private _owner;
70     event OwnershipTransferred(
71         address indexed previousOwner,
72         address indexed newOwner
73     );
74     constructor() {
75         _transferOwnership(_msgSender());
76     }
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(
89             newOwner != address(0),
90             "Ownable: new owner is the zero address"
91         );
92         _transferOwnership(newOwner);
93     }
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 interface IERC20 {
101     function totalSupply() external view returns (uint256);
102     function balanceOf(address account) external view returns (uint256);
103     function transfer(address recipient, uint256 amount)
104         external
105         returns (bool);
106     function allowance(address owner, address spender)
107         external
108         view
109         returns (uint256);
110     function approve(address spender, uint256 amount) external returns (bool);
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) external returns (bool);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     event Approval(
118         address indexed owner,
119         address indexed spender,
120         uint256 value
121     );
122 }
123 interface IERC20Metadata is IERC20 {
124     function name() external view returns (string memory);
125     function symbol() external view returns (string memory);
126     function decimals() external view returns (uint8);
127 }
128 contract ERC20 is Context, IERC20, IERC20Metadata {
129     mapping(address => uint256) private _balances;
130     mapping(address => mapping(address => uint256)) private _allowances;
131     uint256 private _totalSupply;
132     string private _name;
133     string private _symbol;
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138     function name() public view virtual override returns (string memory) {
139         return _name;
140     }
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150     function balanceOf(address account)
151         public
152         view
153         virtual
154         override
155         returns (uint256)
156     {
157         return _balances[account];
158     }
159     function transfer(address recipient, uint256 amount)
160         public
161         virtual
162         override
163         returns (bool)
164     {
165         _transfer(_msgSender(), recipient, amount);
166         return true;
167     }
168     function allowance(address owner, address spender)
169         public
170         view
171         virtual
172         override
173         returns (uint256)
174     {
175         return _allowances[owner][spender];
176     }
177     function approve(address spender, uint256 amount)
178         public
179         virtual
180         override
181         returns (bool)
182     {
183         _approve(_msgSender(), spender, amount);
184         return true;
185     }
186     function transferFrom(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) public virtual override returns (bool) {
191         _transfer(sender, recipient, amount);
192         uint256 currentAllowance = _allowances[sender][_msgSender()];
193         require(
194             currentAllowance >= amount,
195             "ERC20: transfer amount exceeds allowance"
196         );
197         unchecked {
198             _approve(sender, _msgSender(), currentAllowance - amount);
199         }
200         return true;
201     }
202     function increaseAllowance(address spender, uint256 addedValue)
203         public
204         virtual
205         returns (bool)
206     {
207         _approve(
208             _msgSender(),
209             spender,
210             _allowances[_msgSender()][spender] + addedValue
211         );
212         return true;
213     }
214     function decreaseAllowance(address spender, uint256 subtractedValue)
215         public
216         virtual
217         returns (bool)
218     {
219         uint256 currentAllowance = _allowances[_msgSender()][spender];
220         require(
221             currentAllowance >= subtractedValue,
222             "ERC20: decreased allowance below zero"
223         );
224         unchecked {
225             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
226         }
227         return true;
228     }
229     function _transfer(
230         address sender,
231         address recipient,
232         uint256 amount
233     ) internal virtual {
234         require(sender != address(0), "ERC20: transfer from the zero address");
235         require(recipient != address(0), "ERC20: transfer to the zero address");
236         _beforeTokenTransfer(sender, recipient, amount);
237         uint256 senderBalance = _balances[sender];
238         require(
239             senderBalance >= amount,
240             "ERC20: transfer amount exceeds balance"
241         );
242         unchecked {
243             _balances[sender] = senderBalance - amount;
244         }
245         _balances[recipient] += amount;
246         emit Transfer(sender, recipient, amount);
247         _afterTokenTransfer(sender, recipient, amount);
248     }
249     function _mint(address account, uint256 amount) internal virtual {
250         require(account != address(0), "ERC20: mint to the zero address");
251         _beforeTokenTransfer(address(0), account, amount);
252         _totalSupply += amount;
253         _balances[account] += amount;
254         emit Transfer(address(0), account, amount);
255         _afterTokenTransfer(address(0), account, amount);
256     }
257     function _burn(address account, uint256 amount) internal virtual {
258         require(account != address(0), "ERC20: burn from the zero address");
259         _beforeTokenTransfer(account, address(0), amount);
260         uint256 accountBalance = _balances[account];
261         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
262         unchecked {
263             _balances[account] = accountBalance - amount;
264         }
265         _totalSupply -= amount;
266         emit Transfer(account, address(0), amount);
267         _afterTokenTransfer(account, address(0), amount);
268     }
269     function _approve(
270         address owner,
271         address spender,
272         uint256 amount
273     ) internal virtual {
274         require(owner != address(0), "ERC20: approve from the zero address");
275         require(spender != address(0), "ERC20: approve to the zero address");
276         _allowances[owner][spender] = amount;
277         emit Approval(owner, spender, amount);
278     }
279     function _beforeTokenTransfer(
280         address from,
281         address to,
282         uint256 amount
283     ) internal virtual {}
284     function _afterTokenTransfer(
285         address from,
286         address to,
287         uint256 amount
288     ) internal virtual {}
289 }
290 library SafeMath {
291     function tryAdd(uint256 a, uint256 b)
292         internal
293         pure
294         returns (bool, uint256)
295     {
296         unchecked {
297             uint256 c = a + b;
298             if (c < a) return (false, 0);
299             return (true, c);
300         }
301     }
302     function trySub(uint256 a, uint256 b)
303         internal
304         pure
305         returns (bool, uint256)
306     {
307         unchecked {
308             if (b > a) return (false, 0);
309             return (true, a - b);
310         }
311     }
312     function tryMul(uint256 a, uint256 b)
313         internal
314         pure
315         returns (bool, uint256)
316     {
317         unchecked {
318             if (a == 0) return (true, 0);
319             uint256 c = a * b;
320             if (c / a != b) return (false, 0);
321             return (true, c);
322         }
323     }
324     function tryDiv(uint256 a, uint256 b)
325         internal
326         pure
327         returns (bool, uint256)
328     {
329         unchecked {
330             if (b == 0) return (false, 0);
331             return (true, a / b);
332         }
333     }
334     function tryMod(uint256 a, uint256 b)
335         internal
336         pure
337         returns (bool, uint256)
338     {
339         unchecked {
340             if (b == 0) return (false, 0);
341             return (true, a % b);
342         }
343     }
344     function add(uint256 a, uint256 b) internal pure returns (uint256) {
345         return a + b;
346     }
347     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
348         return a - b;
349     }
350     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
351         return a * b;
352     }
353     function div(uint256 a, uint256 b) internal pure returns (uint256) {
354         return a / b;
355     }
356     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
357         return a % b;
358     }
359     function sub(
360         uint256 a,
361         uint256 b,
362         string memory errorMessage
363     ) internal pure returns (uint256) {
364         unchecked {
365             require(b <= a, errorMessage);
366             return a - b;
367         }
368     }
369     function div(
370         uint256 a,
371         uint256 b,
372         string memory errorMessage
373     ) internal pure returns (uint256) {
374         unchecked {
375             require(b > 0, errorMessage);
376             return a / b;
377         }
378     }
379     function mod(
380         uint256 a,
381         uint256 b,
382         string memory errorMessage
383     ) internal pure returns (uint256) {
384         unchecked {
385             require(b > 0, errorMessage);
386             return a % b;
387         }
388     }
389 }
390 contract CRI is ERC20, Ownable {
391     using SafeMath for uint256;
392     IUniswapV2Router02 public immutable uniswapV2Router;
393     address public uniswapV2Pair;
394     address public constant deadAddress = address(0xdead);
395     bool private swapping;
396     address public marketingWallet;
397     address public devWallet;
398     uint256 public maxTransactionAmount;
399     uint256 public swapTokensAtAmount;
400     uint256 public maxWallet;
401     uint256 public percentForLPBurn = 0; 
402     bool public lpBurnEnabled = false;
403     uint256 public lpBurnFrequency = 36000000 seconds;
404     uint256 public lastLpBurnTime;
405     uint256 public manualBurnFrequency = 30000 minutes;
406     uint256 public lastManualLpBurnTime;
407     bool public limitsInEffect = true;
408     bool public tradingActive = false;
409     bool public swapEnabled = false;
410     mapping(address => uint256) private _holderLastTransferTimestamp; 
411     bool public transferDelayEnabled = true;
412     uint256 public buyTotalFees;
413     uint256 public constant buyMarketingFee = 2;
414     uint256 public constant buyLiquidityFee = 2;
415     uint256 public constant buyDevFee = 1;
416     uint256 public sellTotalFees;
417     uint256 public constant sellMarketingFee = 2;
418     uint256 public constant sellLiquidityFee = 2;
419     uint256 public constant sellDevFee = 1;
420     uint256 public tokensForMarketing;
421     uint256 public tokensForLiquidity;
422     uint256 public tokensForDev;
423     mapping(address => bool) private _isExcludedFromFees;
424     mapping(address => bool) public _isExcludedMaxTransactionAmount;
425     mapping(address => bool) public automatedMarketMakerPairs;
426     event UpdateUniswapV2Router(
427         address indexed newAddress,
428         address indexed oldAddress
429     );
430     event ExcludeFromFees(address indexed account, bool isExcluded);
431     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
432     event marketingWalletUpdated(
433         address indexed newWallet,
434         address indexed oldWallet
435     );
436     event devWalletUpdated(
437         address indexed newWallet,
438         address indexed oldWallet
439     );
440     event SwapAndLiquify(
441         uint256 tokensSwapped,
442         uint256 ethReceived,
443         uint256 tokensIntoLiquidity
444     );
445     event AutoNukeLP();
446     event ManualNukeLP();
447     event BoughtEarly(address indexed sniper);
448     constructor() ERC20("Crypto relief Inu", "CRI") {
449         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
450             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
451         );
452         excludeFromMaxTransaction(address(_uniswapV2Router), true);
453         uniswapV2Router = _uniswapV2Router;
454         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
455             .createPair(address(this), _uniswapV2Router.WETH());
456         excludeFromMaxTransaction(address(uniswapV2Pair), true);
457         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
458         uint256 totalSupply = 1_000_000 * 1e18; 
459         maxTransactionAmount = 15_000 * 1e18; 
460         maxWallet = 30_000 * 1e18; 
461         swapTokensAtAmount = (totalSupply * 3) / 10000; 
462         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
463         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
464         marketingWallet = address(0x68A99f89E475a078645f4BAC491360aFe255Dff1); 
465         devWallet = address(0x387389E7C4D07dbbb36b4FC5213225c4f43AbB17); 
466         excludeFromFees(owner(), true);
467         excludeFromFees(address(this), true);
468         excludeFromFees(address(0xdead), true);
469         excludeFromMaxTransaction(owner(), true);
470         excludeFromMaxTransaction(address(this), true);
471         excludeFromMaxTransaction(address(0xdead), true);
472         _mint(msg.sender, totalSupply);
473     }
474     receive() external payable {}
475     function startTrading() external onlyOwner {
476         tradingActive = false;
477         swapEnabled = true;
478         lastLpBurnTime = block.timestamp;
479     }
480     function removeLimits() external onlyOwner returns (bool) {
481         limitsInEffect = false;
482         return true;
483     }
484     function disableTransferDelay() external onlyOwner returns (bool) {
485         transferDelayEnabled = false;
486         return true;
487     }
488     function updateSwapTokensAtAmount(uint256 newAmount)
489         external
490         onlyOwner
491         returns (bool)
492     {
493         require(
494             newAmount >= (totalSupply() * 1) / 100000,
495             "Swap amount cannot be lower than 0.001% total supply."
496         );
497         require(
498             newAmount <= (totalSupply() * 5) / 1000,
499             "Swap amount cannot be higher than 0.5% total supply."
500         );
501         swapTokensAtAmount = newAmount;
502         return true;
503     }
504     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
505         require(
506             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
507             "Cannot set maxTransactionAmount lower than 0.1%"
508         );
509         maxTransactionAmount = newNum * (10**18);
510     }
511     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
512         require(
513             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
514             "Cannot set maxWallet lower than 0.5%"
515         );
516         maxWallet = newNum * (10**18);
517     }
518     function excludeFromMaxTransaction(address updAds, bool isEx)
519         public
520         onlyOwner
521     {
522         _isExcludedMaxTransactionAmount[updAds] = isEx;
523     }
524     function updateSwapEnabled(bool enabled) external onlyOwner {
525         swapEnabled = enabled;
526     }
527     function excludeFromFees(address account, bool excluded) public onlyOwner {
528         _isExcludedFromFees[account] = excluded;
529         emit ExcludeFromFees(account, excluded);
530     }
531     function setAutomatedMarketMakerPair(address pair, bool value)
532         public
533         onlyOwner
534     {
535         require(
536             pair != uniswapV2Pair,
537             "The pair cannot be removed from automatedMarketMakerPairs"
538         );
539         _setAutomatedMarketMakerPair(pair, value);
540     }
541     function _setAutomatedMarketMakerPair(address pair, bool value) private {
542         automatedMarketMakerPairs[pair] = value;
543         emit SetAutomatedMarketMakerPair(pair, value);
544     }
545     function updateMarketingWallet(address newMarketingWallet)
546         external
547         onlyOwner
548     {
549         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
550         marketingWallet = newMarketingWallet;
551     }
552     function updateDevWallet(address newWallet) external onlyOwner {
553         emit devWalletUpdated(newWallet, devWallet);
554         devWallet = newWallet;
555     }
556     function isExcludedFromFees(address account) public view returns (bool) {
557         return _isExcludedFromFees[account];
558     }
559     function _transfer(
560         address from,
561         address to,
562         uint256 amount
563     ) internal override {
564         require(from != address(0), "ERC20: transfer from the zero address");
565         require(to != address(0), "ERC20: transfer to the zero address");
566         if (amount == 0) {
567             super._transfer(from, to, 0);
568             return;
569         }
570         if (limitsInEffect) {
571             if (
572                 from != owner() &&
573                 to != owner() &&
574                 to != address(0) &&
575                 to != address(0xdead) &&
576                 !swapping
577             ) {
578                 if (!tradingActive) {
579                     require(
580                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
581                         "Trading is not active."
582                     );
583                 }
584                 if (transferDelayEnabled) {
585                     if (
586                         to != owner() &&
587                         to != address(uniswapV2Router) &&
588                         to != address(uniswapV2Pair)
589                     ) {
590                         require(
591                             _holderLastTransferTimestamp[tx.origin] <
592                                 block.number,
593                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
594                         );
595                         _holderLastTransferTimestamp[tx.origin] = block.number;
596                     }
597                 }
598                 if (
599                     automatedMarketMakerPairs[from] &&
600                     !_isExcludedMaxTransactionAmount[to]
601                 ) {
602                     require(
603                         amount <= maxTransactionAmount,
604                         "Buy transfer amount exceeds the maxTransactionAmount."
605                     );
606                     require(
607                         amount + balanceOf(to) <= maxWallet,
608                         "Max wallet exceeded"
609                     );
610                 }
611                 else if (
612                     automatedMarketMakerPairs[to] &&
613                     !_isExcludedMaxTransactionAmount[from]
614                 ) {
615                     require(
616                         amount <= maxTransactionAmount,
617                         "Sell transfer amount exceeds the maxTransactionAmount."
618                     );
619                 } else if (!_isExcludedMaxTransactionAmount[to]) {
620                     require(
621                         amount + balanceOf(to) <= maxWallet,
622                         "Max wallet exceeded"
623                     );
624                 }
625             }
626         }
627         uint256 contractTokenBalance = balanceOf(address(this));
628         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
629         if (
630             canSwap &&
631             swapEnabled &&
632             !swapping &&
633             !automatedMarketMakerPairs[from] &&
634             !_isExcludedFromFees[from] &&
635             !_isExcludedFromFees[to]
636         ) {
637             swapping = true;
638             swapBack();
639             swapping = false;
640         }
641         if (
642             !swapping &&
643             automatedMarketMakerPairs[to] &&
644             lpBurnEnabled &&
645             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
646             !_isExcludedFromFees[from]
647         ) {
648             autoBurnLiquidityPairTokens();
649         }
650         bool takeFee = !swapping;
651         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
652             takeFee = false;
653         }
654         uint256 fees = 0;
655         if (takeFee) {
656             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
657                 fees = amount.mul(sellTotalFees).div(100);
658                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
659                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
660                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
661             }
662             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
663                 fees = amount.mul(buyTotalFees).div(100);
664                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
665                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
666                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
667             }
668             if (fees > 0) {
669                 super._transfer(from, address(this), fees);
670             }
671             amount -= fees;
672         }
673         super._transfer(from, to, amount);
674     }
675     function swapTokensForEth(uint256 tokenAmount) private {
676         address[] memory path = new address[](2);
677         path[0] = address(this);
678         path[1] = uniswapV2Router.WETH();
679         _approve(address(this), address(uniswapV2Router), tokenAmount);
680         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
681             tokenAmount,
682             0, 
683             path,
684             address(this),
685             block.timestamp
686         );
687     }
688     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
689         _approve(address(this), address(uniswapV2Router), tokenAmount);
690         uniswapV2Router.addLiquidityETH{value: ethAmount}(
691             address(this),
692             tokenAmount,
693             0, 
694             0, 
695             deadAddress,
696             block.timestamp
697         );
698     }
699     function swapBack() private {
700         uint256 contractBalance = balanceOf(address(this));
701         uint256 totalTokensToSwap = tokensForLiquidity +
702             tokensForMarketing +
703             tokensForDev;
704         bool success;
705         if (contractBalance == 0 || totalTokensToSwap == 0) {
706             return;
707         }
708         if (contractBalance > swapTokensAtAmount * 20) {
709             contractBalance = swapTokensAtAmount * 20;
710         }
711         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
712             totalTokensToSwap /
713             2;
714         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
715         uint256 initialETHBalance = address(this).balance;
716         swapTokensForEth(amountToSwapForETH);
717         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
718         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
719             totalTokensToSwap
720         );
721         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
722         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
723         tokensForLiquidity = 0;
724         tokensForMarketing = 0;
725         tokensForDev = 0;
726         (success, ) = address(devWallet).call{value: ethForDev}("");
727         if (liquidityTokens > 0 && ethForLiquidity > 0) {
728             addLiquidity(liquidityTokens, ethForLiquidity);
729             emit SwapAndLiquify(
730                 amountToSwapForETH,
731                 ethForLiquidity,
732                 tokensForLiquidity
733             );
734         }
735         (success, ) = address(marketingWallet).call{
736             value: address(this).balance
737         }("");
738     }
739     function setAutoLPBurnSettings(
740         uint256 _frequencyInSeconds,
741         uint256 _percent,
742         bool _Enabled
743     ) external onlyOwner {
744         require(
745             _frequencyInSeconds >= 600,
746             "cannot set buyback more often than every 10 minutes"
747         );
748         require(
749             _percent <= 1000 && _percent >= 0,
750             "Must set auto LP burn percent between 0% and 10%"
751         );
752         lpBurnFrequency = _frequencyInSeconds;
753         percentForLPBurn = _percent;
754         lpBurnEnabled = _Enabled;
755     }
756     function autoBurnLiquidityPairTokens() internal returns (bool) {
757         lastLpBurnTime = block.timestamp;
758         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
759         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
760             10000
761         );
762         if (amountToBurn > 0) {
763             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
764         }
765         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
766         pair.sync();
767         emit AutoNukeLP();
768         return true;
769     }
770     function manualBurnLiquidityPairTokens(uint256 percent)
771         external
772         onlyOwner
773         returns (bool)
774     {
775         require(
776             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
777             "Must wait for cooldown to finish"
778         );
779         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
780         lastManualLpBurnTime = block.timestamp;
781         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
782         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
783         if (amountToBurn > 0) {
784             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
785         }
786         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
787         pair.sync();
788         emit ManualNukeLP();
789         return true;
790     }
791 }