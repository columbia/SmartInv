1 /**
2 
3 8888888b.  8888888888 8888888888 8888888b.  888       888  .d8888b.  888888b.   
4 888  "Y88b 888        888        888   Y88b 888   o   888 d88P  Y88b 888  "88b  
5 888    888 888        888        888    888 888  d8b  888      .d88P 888  .88P  
6 888    888 8888888    8888888    888   d88P 888 d888b 888     8888"  8888888K.  
7 888    888 888        888        8888888P"  888d88888b888      "Y8b. 888  "Y88b 
8 888    888 888        888        888        88888P Y88888 888    888 888    888 
9 888  .d88P 888        888        888        8888P   Y8888 Y88b  d88P 888   d88P 
10 8888888P"  8888888888 8888888888 888        888P     Y888  "Y8888P"  8888888P"  
11                                                                                 
12 --------------------------------------------------------
13  CONTRACT AUDITED: https://deepw3b.com/api/static/deepw3b_contract_audit.pdf
14 --------------------------------------------------------
15 
16  WEB: deepw3b.com
17  TELEGRAM: https://t.me/Deepw3b_com  
18  TWITTER: https://twitter.com/deepw3b_
19  YOUTUBE: https://www.youtube.com/@deepw3b_/
20  IG: https://www.instagram.com/deepw3b_com/
21  TIKTOK: https://www.tiktok.com/@deepw3b_com
22 */
23 
24 // SPDX-License-Identifier: Unlicensed
25 pragma solidity >=0.6.0 <0.9.0;
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29 
30     function decimals() external view returns (uint8);
31 
32     function symbol() external view returns (string memory);
33 
34     function name() external view returns (string memory);
35 
36     function getOwner() external view returns (address);
37 
38     function balanceOf(address account) external view returns (uint256);
39 
40     function transfer(address recipient, uint256 amount)
41         external
42         returns (bool);
43 
44     function allowance(address _owner, address spender)
45         external
46         view
47         returns (uint256);
48 
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     function transferFrom(
52         address sender,
53         address recipient,
54         uint256 amount
55     ) external returns (bool);
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(
59         address indexed owner,
60         address indexed spender,
61         uint256 value
62     );
63 }
64 
65 interface IFactoryV2 {
66     event PairCreated(
67         address indexed token0,
68         address indexed token1,
69         address lpPair,
70         uint256
71     );
72 
73     function getPair(address tokenA, address tokenB)
74         external
75         view
76         returns (address lpPair);
77 
78     function createPair(address tokenA, address tokenB)
79         external
80         returns (address lpPair);
81 }
82 
83 interface IV2Pair {
84     function factory() external view returns (address);
85 
86     function getReserves()
87         external
88         view
89         returns (
90             uint112 reserve0,
91             uint112 reserve1,
92             uint32 blockTimestampLast
93         );
94 
95     function sync() external;
96 }
97 
98 interface IRouter01 {
99     function factory() external pure returns (address);
100 
101     function WETH() external pure returns (address);
102 
103     function addLiquidityETH(
104         address token,
105         uint256 amountTokenDesired,
106         uint256 amountTokenMin,
107         uint256 amountETHMin,
108         address to,
109         uint256 deadline
110     )
111         external
112         payable
113         returns (
114             uint256 amountToken,
115             uint256 amountETH,
116             uint256 liquidity
117         );
118 
119     function addLiquidity(
120         address tokenA,
121         address tokenB,
122         uint256 amountADesired,
123         uint256 amountBDesired,
124         uint256 amountAMin,
125         uint256 amountBMin,
126         address to,
127         uint256 deadline
128     )
129         external
130         returns (
131             uint256 amountA,
132             uint256 amountB,
133             uint256 liquidity
134         );
135 
136     function swapExactETHForTokens(
137         uint256 amountOutMin,
138         address[] calldata path,
139         address to,
140         uint256 deadline
141     ) external payable returns (uint256[] memory amounts);
142 
143     function getAmountsOut(uint256 amountIn, address[] calldata path)
144         external
145         view
146         returns (uint256[] memory amounts);
147 
148     function getAmountsIn(uint256 amountOut, address[] calldata path)
149         external
150         view
151         returns (uint256[] memory amounts);
152 }
153 
154 interface IRouter02 is IRouter01 {
155     function swapExactTokensForETHSupportingFeeOnTransferTokens(
156         uint256 amountIn,
157         uint256 amountOutMin,
158         address[] calldata path,
159         address to,
160         uint256 deadline
161     ) external;
162 
163     function swapExactETHForTokensSupportingFeeOnTransferTokens(
164         uint256 amountOutMin,
165         address[] calldata path,
166         address to,
167         uint256 deadline
168     ) external payable;
169 
170     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
171         uint256 amountIn,
172         uint256 amountOutMin,
173         address[] calldata path,
174         address to,
175         uint256 deadline
176     ) external;
177 
178     function swapExactTokensForTokens(
179         uint256 amountIn,
180         uint256 amountOutMin,
181         address[] calldata path,
182         address to,
183         uint256 deadline
184     ) external returns (uint256[] memory amounts);
185 }
186 
187 contract DEEPW3B is IERC20 {
188     mapping(address => uint256) private _tOwned;
189     mapping(address => bool) lpPairs;
190     uint256 private timeSinceLastPair = 0;
191     mapping(address => mapping(address => uint256)) private _allowances;
192     mapping(address => bool) private _liquidityHolders;
193     mapping(address => bool) private _isExcludedFromFees;
194     mapping(address => bool) private _isExcludedFromLimits;
195 
196     uint256 private constant startingSupply = 100_000_000;
197     string private constant _name = "Deepw3b";
198     string private constant _symbol = "DW3B";
199     uint8 private constant _decimals = 18;
200     uint256 private _tTotal = startingSupply * 10**_decimals;
201 
202     struct Fees {
203         uint16 buyFee;
204         uint16 sellFee;
205         uint16 transferFee;
206     }
207 
208     struct Ratios {
209         uint16 liquidity;
210         uint16 operations;
211         uint16 burn;
212         uint16 totalSwap;
213     }
214 
215     Fees public _taxRates = Fees({buyFee: 600, sellFee: 600, transferFee: 600});
216 
217     Ratios public _ratios =
218         Ratios({liquidity: 100, operations: 500, burn: 0, totalSwap: 600});
219 
220     uint256 public constant maxTransferTaxes = 600;
221     uint256 public constant maxBuyTaxes = 600;
222     uint256 public constant maxSellTaxes = 600;
223     uint256 constant masterTaxDivisor = 10000;
224 
225     bool public taxesAreLocked;
226     bool public maxDisabled;    
227     IRouter02 public dexRouter;
228     address public lpPair;
229     address public liquidityAddress;
230     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
231 
232     struct TaxWallets {
233         address payable operations;
234     }
235 
236     TaxWallets public _taxWallets =
237         TaxWallets({
238             operations: payable(0x50800A8799aE012f18a609eb2bB485981F82D9c0)
239         });
240     bool inSwap;
241     bool public contractSwapEnabled = false;
242     uint256 public swapThreshold;
243     uint256 public swapAmount;
244     bool public piContractSwapsEnabled;
245     uint256 public piSwapPercent = 10;
246 
247     uint256 private _maxTxAmount = (_tTotal * 205) / 10000;
248     uint256 private _maxWalletSize = (_tTotal * 205) / 10000;
249 
250     bool public tradingEnabled = false;
251     bool public _hasLiqBeenAdded = false;
252 
253     event ContractSwapEnabledUpdated(bool enabled);
254     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
255 
256     modifier inSwapFlag() {
257         inSwap = true;
258         _;
259         inSwap = false;
260     }
261 
262     constructor() payable {
263         _owner = msg.sender;
264         originalDeployer = msg.sender;
265         _tOwned[_owner] = _tTotal;
266         emit Transfer(address(0), _owner, _tTotal);
267         dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
268         lpPair = IFactoryV2(dexRouter.factory()).createPair(
269             dexRouter.WETH(),
270             address(this)
271         );
272         lpPairs[lpPair] = true;
273         _approve(_owner, address(dexRouter), type(uint256).max);
274         _approve(address(this), address(dexRouter), type(uint256).max);
275         _isExcludedFromFees[_owner] = true;
276         _isExcludedFromFees[0x50800A8799aE012f18a609eb2bB485981F82D9c0] = true;
277         _isExcludedFromFees[address(this)] = true;
278         _isExcludedFromFees[DEAD] = true;
279         _liquidityHolders[_owner] = true;
280         liquidityAddress = _owner;
281     }
282 
283     receive() external payable {}
284 
285     address private _owner;
286     modifier onlyOwner() {
287         require(_owner == msg.sender, "Caller =/= owner.");
288         _;
289     }
290     event OwnershipTransferred(
291         address indexed previousOwner,
292         address indexed newOwner
293     );
294 
295     function transferOwner(address newOwner) external onlyOwner {
296         require(
297             newOwner != address(0),
298             "Call renounceOwnership to transfer owner to the zero address."
299         );
300         require(
301             newOwner != DEAD,
302             "Call renounceOwnership to transfer owner to the zero address."
303         );
304         setExcludedFromFees(_owner, false);
305         setExcludedFromFees(newOwner, true);
306 
307         if (balanceOf(_owner) > 0) {
308             finalizeTransfer(
309                 _owner,
310                 newOwner,
311                 balanceOf(_owner),
312                 false,
313                 false,
314                 true
315             );
316         }
317 
318         address oldOwner = _owner;
319         _owner = newOwner;
320         emit OwnershipTransferred(oldOwner, newOwner);
321     }
322 
323     function renounceOwnership() external onlyOwner {
324         setExcludedFromFees(_owner, false);
325         address oldOwner = _owner;
326         _owner = address(0);
327         emit OwnershipTransferred(oldOwner, address(0));
328     }
329 
330     address public originalDeployer;
331     address public operator;
332 
333     function setOperator(address newOperator) public {
334         require(
335             msg.sender == originalDeployer,
336             "Can only be called by original deployer."
337         );
338         address oldOperator = operator;
339         if (oldOperator != address(0)) {
340             _liquidityHolders[oldOperator] = false;
341             setExcludedFromFees(oldOperator, false);
342         }
343         operator = newOperator;
344         _liquidityHolders[newOperator] = true;
345         setExcludedFromFees(newOperator, true);
346     }
347 
348     function renounceOriginalDeployer() external {
349         require(
350             msg.sender == originalDeployer,
351             "Can only be called by original deployer."
352         );
353         setOperator(address(0));
354         originalDeployer = address(0);
355     }
356 
357     function totalSupply() external view override returns (uint256) {
358         if (_tTotal == 0) {
359             revert();
360         }
361         return _tTotal;
362     }
363 
364     function decimals() external view override returns (uint8) {
365         if (_tTotal == 0) {
366             revert();
367         }
368         return _decimals;
369     }
370 
371     function symbol() external pure override returns (string memory) {
372         return _symbol;
373     }
374 
375     function name() external pure override returns (string memory) {
376         return _name;
377     }
378 
379     function getOwner() external view override returns (address) {
380         return _owner;
381     }
382 
383     function allowance(address holder, address spender)
384         external
385         view
386         override
387         returns (uint256)
388     {
389         return _allowances[holder][spender];
390     }
391 
392     function balanceOf(address account) public view override returns (uint256) {
393         return _tOwned[account];
394     }
395 
396     function transfer(address recipient, uint256 amount)
397         public
398         override
399         returns (bool)
400     {
401         _transfer(msg.sender, recipient, amount);
402         return true;
403     }
404 
405     function approve(address spender, uint256 amount)
406         external
407         override
408         returns (bool)
409     {
410         _approve(msg.sender, spender, amount);
411         return true;
412     }
413 
414     function _approve(
415         address sender,
416         address spender,
417         uint256 amount
418     ) internal {
419         require(sender != address(0), "ERC20: Zero Address");
420         require(spender != address(0), "ERC20: Zero Address");
421         _allowances[sender][spender] = amount;
422         emit Approval(sender, spender, amount);
423     }
424 
425     function approveContractContingency() external onlyOwner returns (bool) {
426         _approve(address(this), address(dexRouter), type(uint256).max);
427         return true;
428     }
429 
430     function transferFrom(
431         address sender,
432         address recipient,
433         uint256 amount
434     ) external override returns (bool) {
435         if (_allowances[sender][msg.sender] != type(uint256).max) {
436             _allowances[sender][msg.sender] -= amount;
437         }
438         return _transfer(sender, recipient, amount);
439     }
440 
441     function setNewRouter(address newRouter) external onlyOwner {
442         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
443         IRouter02 _newRouter = IRouter02(newRouter);
444         address get_pair = IFactoryV2(_newRouter.factory()).getPair(
445             address(this),
446             _newRouter.WETH()
447         );
448         lpPairs[lpPair] = false;
449         if (get_pair == address(0)) {
450             lpPair = IFactoryV2(_newRouter.factory()).createPair(
451                 address(this),
452                 _newRouter.WETH()
453             );
454         } else {
455             lpPair = get_pair;
456         }
457         dexRouter = _newRouter;
458         lpPairs[lpPair] = true;
459         _approve(address(this), address(dexRouter), type(uint256).max);
460     }
461 
462     function setLpPair(address pair, bool enabled) external onlyOwner {
463         if (!enabled) {
464             lpPairs[pair] = false;
465         } else {
466             if (timeSinceLastPair != 0) {
467                 require(
468                     block.timestamp - timeSinceLastPair > 3 days,
469                     "3 Day cooldown."
470                 );
471             }
472             require(!lpPairs[pair], "Pair already added to list.");
473             lpPairs[pair] = true;
474             timeSinceLastPair = block.timestamp;
475         }
476     }
477 
478     function isExcludedFromLimits(address account)
479         external
480         view
481         returns (bool)
482     {
483         return _isExcludedFromLimits[account];
484     }
485 
486     function setExcludedFromLimits(address account, bool enabled)
487         external
488         onlyOwner
489     {
490         _isExcludedFromLimits[account] = enabled;
491     }
492 
493     function isExcludedFromFees(address account) external view returns (bool) {
494         return _isExcludedFromFees[account];
495     }
496 
497     function setExcludedFromFees(address account, bool enabled)
498         public
499         onlyOwner
500     {
501         _isExcludedFromFees[account] = enabled;
502     }
503 
504     function lockTaxes() external onlyOwner {
505         taxesAreLocked = true;
506     }   
507 
508     function disableMax() external onlyOwner {
509         maxDisabled = true;
510     }
511 
512     function setTaxes(
513         uint16 buyFee,
514         uint16 sellFee,
515         uint16 transferFee
516     ) external onlyOwner {
517         require(!taxesAreLocked, "Taxes are locked.");
518         require(
519             buyFee <= maxBuyTaxes &&
520                 sellFee <= maxSellTaxes &&
521                 transferFee <= maxTransferTaxes,
522             "Cannot exceed maximums."
523         );
524         _taxRates.buyFee = buyFee;
525         _taxRates.sellFee = sellFee;
526         _taxRates.transferFee = transferFee;
527     }
528 
529     function setRatios(
530         uint16 liquidity,
531         uint16 operations,
532         uint16 burn
533     ) external onlyOwner {
534         _ratios.liquidity = liquidity;
535         _ratios.operations = operations;
536         _ratios.burn = burn;
537         _ratios.totalSwap = liquidity + operations;
538         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
539         require(
540             _ratios.totalSwap + _ratios.burn <= total,
541             "Cannot exceed sum of buy and sell fees."
542         );
543     }
544 
545     function setWallets(address payable operations) external onlyOwner {
546         require(operations != address(0), "Cannot be zero address.");
547         _taxWallets.operations = payable(operations);
548     }
549 
550     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
551         require(_liquidityAddress != address(0), "Cannot be zero address.");
552         liquidityAddress = _liquidityAddress;
553     }
554 
555     function setMaxTxAmount(uint256 percent, uint256 divisor)
556         external
557         onlyOwner
558     {        
559         require(!maxDisabled, "Max amount is disabled.");
560         require(
561             (_tTotal * percent) / divisor >= ((_tTotal * 5) / 1000),
562             "Max Transaction amt must be above 0.5% of total supply."
563         );
564         _maxTxAmount = (_tTotal * percent) / divisor;
565     }
566 
567     function setMaxWalletSize(uint256 percent, uint256 divisor)
568         external
569         onlyOwner
570     {
571         require(!maxDisabled, "Max wallet is disabled.");
572         require(
573             (_tTotal * percent) / divisor >= (_tTotal / 100),
574             "Max Wallet amt must be above 1% of total supply."
575         );
576         _maxWalletSize = (_tTotal * percent) / divisor;
577     }
578 
579     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds)
580         external
581         view
582         returns (uint256)
583     {
584         return ((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
585     }
586 
587     function setSwapSettings(
588         uint256 thresholdPercent,
589         uint256 thresholdDivisor,
590         uint256 amountPercent,
591         uint256 amountDivisor
592     ) external onlyOwner {
593         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
594         swapAmount = (_tTotal * amountPercent) / amountDivisor;
595         require(
596             swapThreshold <= swapAmount,
597             "Threshold cannot be above amount."
598         );
599         require(
600             swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor,
601             "Cannot be above 1.5% of current PI."
602         );
603         require(
604             swapAmount >= _tTotal / 1_000_000,
605             "Cannot be lower than 0.00001% of total supply."
606         );
607         require(
608             swapThreshold >= _tTotal / 1_000_000,
609             "Cannot be lower than 0.00001% of total supply."
610         );
611     }
612 
613     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent)
614         external
615         onlyOwner
616     {
617         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
618         piSwapPercent = priceImpactSwapPercent;
619     }
620 
621     function setContractSwapEnabled(
622         bool swapEnabled,
623         bool priceImpactSwapEnabled
624     ) external onlyOwner {
625         contractSwapEnabled = swapEnabled;
626         piContractSwapsEnabled = priceImpactSwapEnabled;
627         emit ContractSwapEnabledUpdated(swapEnabled);
628     }
629 
630     function _hasLimits(address from, address to) internal view returns (bool) {
631         return
632             from != _owner &&
633             to != _owner &&
634             tx.origin != _owner &&
635             !_liquidityHolders[to] &&
636             !_liquidityHolders[from] &&
637             to != DEAD &&
638             to != address(0) &&
639             from != address(this);
640     }
641 
642     function _transfer(
643         address from,
644         address to,
645         uint256 amount
646     ) internal returns (bool) {
647         require(from != address(0), "ERC20: transfer from the zero address");
648         require(to != address(0), "ERC20: transfer to the zero address");
649         require(amount > 0, "Transfer amount must be greater than zero");
650         bool buy = false;
651         bool sell = false;
652         bool other = false;
653         if (lpPairs[from]) {
654             buy = true;
655         } else if (lpPairs[to]) {
656             sell = true;
657         } else {
658             other = true;
659         }
660         if (_hasLimits(from, to)) {
661             if (!tradingEnabled) {
662                 revert("Trading not yet enabled!");
663             }
664             if (buy || sell) {
665                 if (
666                     !_isExcludedFromLimits[from] && !_isExcludedFromLimits[to] && !maxDisabled
667                 ) {
668                     require(
669                         amount <= _maxTxAmount,
670                         "Transfer amount exceeds the maxTxAmount."
671                     );
672                 }
673             }
674             if (to != address(dexRouter) && !sell) {
675                 if (!_isExcludedFromLimits[to] && !maxDisabled) {
676                     require(
677                         balanceOf(to) + amount <= _maxWalletSize,
678                         "Transfer amount exceeds the maxWalletSize."
679                     );
680                 }
681             }
682         }
683         
684         if (sell) {
685             if (!inSwap) {
686                 if (contractSwapEnabled) {
687                     uint256 contractTokenBalance = balanceOf(address(this));
688                     if (contractTokenBalance >= swapThreshold) {
689                         uint256 swapAmt = swapAmount;
690                         if (piContractSwapsEnabled) {
691                             swapAmt =
692                                 (balanceOf(lpPair) * piSwapPercent) /
693                                 masterTaxDivisor;
694                         }
695                         if (contractTokenBalance >= swapAmt) {
696                             contractTokenBalance = swapAmt;
697                         }
698                         contractSwap(contractTokenBalance);
699                     }
700                 }
701             }
702         }
703 
704         return finalizeTransfer(from, to, amount, buy, sell, other);
705     }
706 
707     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
708         Ratios memory ratios = _ratios;
709         if (ratios.totalSwap == 0) {
710             return;
711         }
712 
713         if (
714             _allowances[address(this)][address(dexRouter)] != type(uint256).max
715         ) {
716             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
717         }
718 
719         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) /
720             ratios.totalSwap) / 2;
721         uint256 swapAmt = contractTokenBalance - toLiquify;
722 
723         address[] memory path = new address[](2);
724         path[0] = address(this);
725         path[1] = dexRouter.WETH();
726 
727         try
728             dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
729                 swapAmt,
730                 0,
731                 path,
732                 address(this),
733                 block.timestamp
734             )
735         {} catch {
736             return;
737         }
738 
739         uint256 amtBalance = address(this).balance;
740         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
741 
742         if (toLiquify > 0) {
743             try
744                 dexRouter.addLiquidityETH{value: liquidityBalance}(
745                     address(this),
746                     toLiquify,
747                     0,
748                     0,
749                     liquidityAddress,
750                     block.timestamp
751                 )
752             {
753                 emit AutoLiquify(liquidityBalance, toLiquify);
754             } catch {
755                 return;
756             }
757         }
758 
759         amtBalance -= liquidityBalance;
760         ratios.totalSwap -= ratios.liquidity;
761         bool success;
762         uint256 operationsBalance = (amtBalance * ratios.operations) /
763             ratios.totalSwap;
764         if (ratios.operations > 0) {
765             (success, ) = _taxWallets.operations.call{
766                 value: operationsBalance,
767                 gas: 55000
768             }("");
769         }
770     }
771 
772     function _checkLiquidityAdd(address from, address to) internal {
773         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
774         if (!_hasLimits(from, to) && to == lpPair) {
775             _liquidityHolders[from] = true;
776             _isExcludedFromFees[from] = true;
777             _hasLiqBeenAdded = true;
778             contractSwapEnabled = true;
779             emit ContractSwapEnabledUpdated(true);
780         }
781     }
782 
783     function enableTrading() public onlyOwner {
784         require(!tradingEnabled, "Trading already enabled!");
785         require(_hasLiqBeenAdded, "Liquidity must be added.");
786         tradingEnabled = true;
787         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
788         swapAmount = (balanceOf(lpPair) * 30) / 10000;
789     }
790 
791     function sweepContingency() external onlyOwner {
792         payable(_owner).transfer(address(this).balance);
793     }
794 
795     function sweepExternalTokens(address token) external onlyOwner {
796         IERC20 TOKEN = IERC20(token);
797         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
798     }
799 
800     function multiSendTokens(
801         address[] memory accounts,
802         uint256[] memory amounts
803     ) external onlyOwner {
804         require(accounts.length == amounts.length, "Lengths do not match.");
805         for (uint16 i = 0; i < accounts.length; i++) {
806             require(
807                 balanceOf(msg.sender) >= amounts[i] * 10**_decimals,
808                 "Not enough tokens."
809             );
810             finalizeTransfer(
811                 msg.sender,
812                 accounts[i],
813                 amounts[i] * 10**_decimals,
814                 false,
815                 false,
816                 true
817             );
818         }
819     }
820 
821     function finalizeTransfer(
822         address from,
823         address to,
824         uint256 amount,
825         bool buy,
826         bool sell,
827         bool other
828     ) internal returns (bool) {
829         bool takeFee = true;
830         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
831             takeFee = false;
832         }
833         _tOwned[from] -= amount;
834         uint256 amountReceived = (takeFee)
835             ? takeTaxes(from, buy, sell, amount)
836             : amount;
837         _tOwned[to] += amountReceived;
838         emit Transfer(from, to, amountReceived);
839         if (!_hasLiqBeenAdded) {
840             _checkLiquidityAdd(from, to);
841             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !other) {
842                 revert("Pre-liquidity transfer protection.");
843             }
844         }
845         return true;
846     }
847 
848     function takeTaxes(
849         address from,
850         bool buy,
851         bool sell,
852         uint256 amount
853     ) internal returns (uint256) {
854         Ratios memory ratios = _ratios;
855         uint256 total = ratios.burn + ratios.totalSwap;
856         uint256 currentFee;
857         if (buy) {
858             currentFee = _taxRates.buyFee;
859         } else if (sell) {
860             currentFee = _taxRates.sellFee;
861         } else {
862             currentFee = _taxRates.transferFee;
863         }
864         if (currentFee == 0 || total == 0) {
865             return amount;
866         }
867         uint256 feeAmount = (amount * currentFee) / masterTaxDivisor;
868         uint256 burnAmt = (feeAmount * ratios.burn) / total;
869         uint256 swapAmt = feeAmount - burnAmt;
870         if (swapAmt > 0) {
871             _tOwned[address(this)] += swapAmt;
872             emit Transfer(from, address(this), swapAmt);
873         }
874         if (burnAmt > 0) {
875             _tTotal -= burnAmt;
876             emit Transfer(from, address(0), burnAmt);
877         }
878 
879         return amount - feeAmount;
880     }
881 }