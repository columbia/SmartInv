1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.15;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17 
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36    
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 interface IERC20Metadata is IERC20 {
41     
42     function name() external view returns (string memory);
43 
44     function symbol() external view returns (string memory);
45 
46     function decimals() external view returns (uint8);
47 }
48 
49 contract ERC20 is Context, IERC20, IERC20Metadata {
50     mapping(address => uint256) private _balances;
51 
52     mapping(address => mapping(address => uint256)) private _allowances;
53 
54     uint256 private _totalSupply;
55 
56     string private _name;
57     string private _symbol;
58 
59     constructor(string memory name_, string memory symbol_) {
60         _name = name_;
61         _symbol = symbol_;
62     }
63 
64     function name() public view virtual override returns (string memory) {
65         return _name;
66     }
67 
68     function symbol() public view virtual override returns (string memory) {
69         return _symbol;
70     }
71 
72     function decimals() public view virtual override returns (uint8) {
73         return 18;
74     }
75 
76     function totalSupply() public view virtual override returns (uint256) {
77         return _totalSupply;
78     }
79 
80     function balanceOf(address account) public view virtual override returns (uint256) {
81         return _balances[account];
82     }
83 
84     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
85         _transfer(_msgSender(), recipient, amount);
86         return true;
87     }
88 
89     function allowance(address owner, address spender) public view virtual override returns (uint256) {
90         return _allowances[owner][spender];
91     }
92 
93     function approve(address spender, uint256 amount) public virtual override returns (bool) {
94         _approve(_msgSender(), spender, amount);
95         return true;
96     }
97 
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) public virtual override returns (bool) {
103         _transfer(sender, recipient, amount);
104 
105         uint256 currentAllowance = _allowances[sender][_msgSender()];
106         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
107         unchecked {
108             _approve(sender, _msgSender(), currentAllowance - amount);
109         }
110 
111         return true;
112     }
113 
114     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
115         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
116         return true;
117     }
118 
119     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
120         uint256 currentAllowance = _allowances[_msgSender()][spender];
121         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
122         unchecked {
123             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
124         }
125 
126         return true;
127     }
128 
129     function _transfer(
130         address sender,
131         address recipient,
132         uint256 amount
133     ) internal virtual {
134         require(sender != address(0), "ERC20: transfer from the zero address");
135         require(recipient != address(0), "ERC20: transfer to the zero address");
136 
137         uint256 senderBalance = _balances[sender];
138         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
139         unchecked {
140             _balances[sender] = senderBalance - amount;
141         }
142         _balances[recipient] += amount;
143 
144         emit Transfer(sender, recipient, amount);
145     }
146 
147     function _createInitialSupply(address account, uint256 amount) internal virtual {
148         require(account != address(0), "ERC20: mint to the zero address");
149 
150         _totalSupply += amount;
151         _balances[account] += amount;
152         emit Transfer(address(0), account, amount);
153     }
154 
155     function _burn(address account, uint256 amount) internal virtual {
156         require(account != address(0), "ERC20: burn from the zero address");
157         uint256 accountBalance = _balances[account];
158         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
159         unchecked {
160             _balances[account] = accountBalance - amount;
161             // Overflow not possible: amount <= accountBalance <= totalSupply.
162             _totalSupply -= amount;
163         }
164 
165         emit Transfer(account, address(0), amount);
166     }
167 
168     function _approve(
169         address owner,
170         address spender,
171         uint256 amount
172     ) internal virtual {
173         require(owner != address(0), "ERC20: approve from the zero address");
174         require(spender != address(0), "ERC20: approve to the zero address");
175 
176         _allowances[owner][spender] = amount;
177         emit Approval(owner, spender, amount);
178     }
179 }
180 
181 contract Ownable is Context {
182     address private _owner;
183 
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186     constructor () {
187         address msgSender = _msgSender();
188         _owner = msgSender;
189         emit OwnershipTransferred(address(0), msgSender);
190     }
191 
192     function owner() public view returns (address) {
193         return _owner;
194     }
195 
196     modifier onlyOwner() {
197         require(_owner == _msgSender(), "Ownable: caller is not the owner");
198         _;
199     }
200 
201     function renounceOwnership() external virtual onlyOwner {
202         emit OwnershipTransferred(_owner, address(0));
203         _owner = address(0);
204     }
205 
206     function transferOwnership(address newOwner) public virtual onlyOwner {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         emit OwnershipTransferred(_owner, newOwner);
209         _owner = newOwner;
210     }
211 }
212 
213 interface IDexRouter {
214     function factory() external pure returns (address);
215     function WETH() external pure returns (address);
216 
217     function swapExactTokensForETHSupportingFeeOnTransferTokens(
218         uint amountIn,
219         uint amountOutMin,
220         address[] calldata path,
221         address to,
222         uint deadline
223     ) external;
224 
225     function swapExactETHForTokensSupportingFeeOnTransferTokens(
226         uint amountOutMin,
227         address[] calldata path,
228         address to,
229         uint deadline
230     ) external payable;
231 
232     function addLiquidityETH(
233         address token,
234         uint256 amountTokenDesired,
235         uint256 amountTokenMin,
236         uint256 amountETHMin,
237         address to,
238         uint256 deadline
239     )
240         external
241         payable
242         returns (
243             uint256 amountToken,
244             uint256 amountETH,
245             uint256 liquidity
246         );
247 }
248 
249 interface IDexFactory {
250     function createPair(address tokenA, address tokenB)
251         external
252         returns (address pair);
253 }
254 
255 contract Raven is ERC20, Ownable {
256 
257     uint256 public maxBuyAmount;
258     uint256 public maxSellAmount;
259     uint256 public maxWalletAmount;
260 
261     IDexRouter public dexRouter;
262     address public lpPair;
263 
264     bool private swapping;
265     uint256 public swapTokensAtAmount;
266 
267     address operationsAddress;
268     address devAddress;
269 
270     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
271     uint256 public blockForPenaltyEnd;
272     mapping (address => bool) public boughtEarly;
273     uint256 public botsCaught;
274 
275     bool public limitsInEffect = true;
276     bool public tradingActive = false;
277     bool public swapEnabled = false;
278 
279      // Anti-bot and anti-whale mappings and variables
280     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
281     bool public transferDelayEnabled = true;
282 
283     uint256 public buyTotalFees;
284     uint256 public buyOperationsFee;
285     uint256 public buyLiquidityFee;
286     uint256 public buyDevFee;
287     uint256 public buyBurnFee;
288 
289     uint256 public sellTotalFees;
290     uint256 public sellOperationsFee;
291     uint256 public sellLiquidityFee;
292     uint256 public sellDevFee;
293     uint256 public sellBurnFee;
294 
295     uint256 public tokensForOperations;
296     uint256 public tokensForLiquidity;
297     uint256 public tokensForDev;
298     uint256 public tokensForBurn;
299 
300     /******************/
301 
302     // exlcude from fees and max transaction amount
303     mapping (address => bool) private _isExcludedFromFees;
304     mapping (address => bool) public _isExcludedMaxTransactionAmount;
305 
306     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
307     // could be subject to a maximum transfer amount
308     mapping (address => bool) public automatedMarketMakerPairs;
309 
310     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
311 
312     event EnabledTrading();
313 
314     event RemovedLimits();
315 
316     event ExcludeFromFees(address indexed account, bool isExcluded);
317 
318     event UpdatedMaxBuyAmount(uint256 newAmount);
319 
320     event UpdatedMaxSellAmount(uint256 newAmount);
321 
322     event UpdatedMaxWalletAmount(uint256 newAmount);
323 
324     event UpdatedOperationsAddress(address indexed newWallet);
325 
326     event MaxTransactionExclusion(address _address, bool excluded);
327 
328     event BuyBackTriggered(uint256 amount);
329 
330     event OwnerForcedSwapBack(uint256 timestamp);
331 
332     event CaughtEarlyBuyer(address sniper);
333 
334     event SwapAndLiquify(
335         uint256 tokensSwapped,
336         uint256 ethReceived,
337         uint256 tokensIntoLiquidity
338     );
339 
340     event TransferForeignToken(address token, uint256 amount);
341 
342     constructor() ERC20("RAVEN", "RAVEN") {
343 
344         address newOwner = msg.sender; // can leave alone if owner is deployer.
345 
346         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
347         dexRouter = _dexRouter;
348 
349         // create pair
350         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
351         _excludeFromMaxTransaction(address(lpPair), true);
352         _setAutomatedMarketMakerPair(address(lpPair), true);
353 
354         uint256 totalSupply = 1 * 1e12 * 1e18;
355 
356         maxBuyAmount = totalSupply * 2 / 100;
357         maxSellAmount = totalSupply * 2 / 100;
358         maxWalletAmount = totalSupply * 2 / 100;
359         swapTokensAtAmount = totalSupply * 5 / 10000;
360 
361         buyOperationsFee = 0;
362         buyLiquidityFee = 0;
363         buyDevFee = 0;
364         buyBurnFee = 0;
365         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
366 
367         sellOperationsFee = 0;
368         sellLiquidityFee = 0;
369         sellDevFee = 0;
370         sellBurnFee = 0;
371         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
372 
373         _excludeFromMaxTransaction(newOwner, true);
374         _excludeFromMaxTransaction(address(this), true);
375         _excludeFromMaxTransaction(address(0xdead), true);
376 
377         excludeFromFees(newOwner, true);
378         excludeFromFees(address(this), true);
379         excludeFromFees(address(0xdead), true);
380 
381         operationsAddress = address(newOwner);
382         devAddress = address(newOwner);
383 
384         _createInitialSupply(newOwner, totalSupply);
385         transferOwnership(newOwner);
386     }
387 
388     receive() external payable {}
389 
390     // only enable if no plan to airdrop
391 
392     function enableTrading(uint256 deadBlocks) external onlyOwner {
393         require(!tradingActive, "Cannot reenable trading");
394         tradingActive = true;
395         swapEnabled = true;
396         tradingActiveBlock = block.number;
397         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
398         emit EnabledTrading();
399     }
400 
401     // remove limits after token is stable
402     function removeLimits() external onlyOwner {
403         limitsInEffect = false;
404         transferDelayEnabled = false;
405         emit RemovedLimits();
406     }
407 
408     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
409         boughtEarly[wallet] = flag;
410     }
411 
412     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
413         for(uint256 i = 0; i < wallets.length; i++){
414             boughtEarly[wallets[i]] = flag;
415         }
416     }
417 
418     // disable Transfer delay - cannot be reenabled
419     function disableTransferDelay() external onlyOwner {
420         transferDelayEnabled = false;
421     }
422 
423     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
424         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
425         maxBuyAmount = newNum * (10**18);
426         emit UpdatedMaxBuyAmount(maxBuyAmount);
427     }
428 
429     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
430         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
431         maxSellAmount = newNum * (10**18);
432         emit UpdatedMaxSellAmount(maxSellAmount);
433     }
434 
435     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
436         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
437         maxWalletAmount = newNum * (10**18);
438         emit UpdatedMaxWalletAmount(maxWalletAmount);
439     }
440 
441     // change the minimum amount of tokens to sell from fees
442     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
443   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
444   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
445   	    swapTokensAtAmount = newAmount;
446   	}
447 
448     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
449         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
450         emit MaxTransactionExclusion(updAds, isExcluded);
451     }
452 
453     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
454         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
455         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
456         for(uint256 i = 0; i < wallets.length; i++){
457             address wallet = wallets[i];
458             uint256 amount = amountsInTokens[i];
459             super._transfer(msg.sender, wallet, amount);
460         }
461     }
462 
463     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
464         if(!isEx){
465             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
466         }
467         _isExcludedMaxTransactionAmount[updAds] = isEx;
468     }
469 
470     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
471         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
472 
473         _setAutomatedMarketMakerPair(pair, value);
474         emit SetAutomatedMarketMakerPair(pair, value);
475     }
476 
477     function _setAutomatedMarketMakerPair(address pair, bool value) private {
478         automatedMarketMakerPairs[pair] = value;
479 
480         _excludeFromMaxTransaction(pair, value);
481 
482         emit SetAutomatedMarketMakerPair(pair, value);
483     }
484 
485     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
486         buyOperationsFee = _operationsFee;
487         buyLiquidityFee = _liquidityFee;
488         buyDevFee = _devFee;
489         buyBurnFee = _burnFee;
490         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
491         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
492     }
493 
494     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
495         sellOperationsFee = _operationsFee;
496         sellLiquidityFee = _liquidityFee;
497         sellDevFee = _devFee;
498         sellBurnFee = _burnFee;
499         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
500         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
501     }
502 
503     function returnToNormalTax() external onlyOwner {
504         sellOperationsFee = 20;
505         sellLiquidityFee = 0;
506         sellDevFee = 0;
507         sellBurnFee = 0;
508         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
509         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
510 
511         buyOperationsFee = 20;
512         buyLiquidityFee = 0;
513         buyDevFee = 0;
514         buyBurnFee = 0;
515         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
516         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
517     }
518 
519     function excludeFromFees(address account, bool excluded) public onlyOwner {
520         _isExcludedFromFees[account] = excluded;
521         emit ExcludeFromFees(account, excluded);
522     }
523 
524     function _transfer(address from, address to, uint256 amount) internal override {
525 
526         require(from != address(0), "ERC20: transfer from the zero address");
527         require(to != address(0), "ERC20: transfer to the zero address");
528         require(amount > 0, "amount must be greater than 0");
529 
530         if(!tradingActive){
531             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
532         }
533 
534         if(blockForPenaltyEnd > 0){
535             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
536         }
537 
538         if(limitsInEffect){
539             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
540 
541                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
542                 if (transferDelayEnabled){
543                     if (to != address(dexRouter) && to != address(lpPair)){
544                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
545                         _holderLastTransferTimestamp[tx.origin] = block.number;
546                         _holderLastTransferTimestamp[to] = block.number;
547                     }
548                 }
549 
550                 //when buy
551                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
552                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
553                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
554                 }
555                 //when sell
556                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
557                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
558                 }
559                 else if (!_isExcludedMaxTransactionAmount[to]){
560                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
561                 }
562             }
563         }
564 
565         uint256 contractTokenBalance = balanceOf(address(this));
566 
567         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
568 
569         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
570             swapping = true;
571 
572             swapBack();
573 
574             swapping = false;
575         }
576 
577         bool takeFee = true;
578         // if any account belongs to _isExcludedFromFee account then remove the fee
579         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
580             takeFee = false;
581         }
582 
583         uint256 fees = 0;
584         // only take fees on buys/sells, do not take on wallet transfers
585         if(takeFee){
586             // bot/sniper penalty.
587             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
588 
589                 if(!boughtEarly[to]){
590                     boughtEarly[to] = true;
591                     botsCaught += 1;
592                     emit CaughtEarlyBuyer(to);
593                 }
594 
595                 fees = amount * 99 / 100;
596         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
597                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
598                 tokensForDev += fees * buyDevFee / buyTotalFees;
599                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
600             }
601 
602             // on sell
603             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
604                 fees = amount * sellTotalFees / 100;
605                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
606                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
607                 tokensForDev += fees * sellDevFee / sellTotalFees;
608                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
609             }
610 
611             // on buy
612             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
613         	    fees = amount * buyTotalFees / 100;
614         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
615                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
616                 tokensForDev += fees * buyDevFee / buyTotalFees;
617                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
618             }
619 
620             if(fees > 0){
621                 super._transfer(from, address(this), fees);
622             }
623 
624         	amount -= fees;
625         }
626 
627         super._transfer(from, to, amount);
628     }
629 
630     function earlyBuyPenaltyInEffect() public view returns (bool){
631         return block.number < blockForPenaltyEnd;
632     }
633 
634     function swapTokensForEth(uint256 tokenAmount) private {
635 
636         // generate the uniswap pair path of token -> weth
637         address[] memory path = new address[](2);
638         path[0] = address(this);
639         path[1] = dexRouter.WETH();
640 
641         _approve(address(this), address(dexRouter), tokenAmount);
642 
643         // make the swap
644         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
645             tokenAmount,
646             0, // accept any amount of ETH
647             path,
648             address(this),
649             block.timestamp
650         );
651     }
652 
653     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
654         // approve token transfer to cover all possible scenarios
655         _approve(address(this), address(dexRouter), tokenAmount);
656 
657         // add the liquidity
658         dexRouter.addLiquidityETH{value: ethAmount}(
659             address(this),
660             tokenAmount,
661             0, // slippage is unavoidable
662             0, // slippage is unavoidable
663             address(0xdead),
664             block.timestamp
665         );
666     }
667 
668     function swapBack() private {
669 
670         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
671             _burn(address(this), tokensForBurn);
672         }
673         tokensForBurn = 0;
674 
675         uint256 contractBalance = balanceOf(address(this));
676         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
677 
678         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
679 
680         if(contractBalance > swapTokensAtAmount * 20){
681             contractBalance = swapTokensAtAmount * 20;
682         }
683 
684         bool success;
685 
686         // Halve the amount of liquidity tokens
687         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
688 
689         swapTokensForEth(contractBalance - liquidityTokens);
690 
691         uint256 ethBalance = address(this).balance;
692         uint256 ethForLiquidity = ethBalance;
693 
694         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
695         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
696 
697         ethForLiquidity -= ethForOperations + ethForDev;
698 
699         tokensForLiquidity = 0;
700         tokensForOperations = 0;
701         tokensForDev = 0;
702         tokensForBurn = 0;
703 
704         if(liquidityTokens > 0 && ethForLiquidity > 0){
705             addLiquidity(liquidityTokens, ethForLiquidity);
706         }
707 
708         (success,) = address(devAddress).call{value: ethForDev}("");
709 
710         (success,) = address(operationsAddress).call{value: address(this).balance}("");
711     }
712 
713     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
714         require(_token != address(0), "_token address cannot be 0");
715         require(_token != address(this), "Can't withdraw native tokens");
716         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
717         _sent = IERC20(_token).transfer(_to, _contractBalance);
718         emit TransferForeignToken(_token, _contractBalance);
719     }
720 
721     // withdraw ETH if stuck or someone sends to the address
722     function withdrawStuckETH() external onlyOwner {
723         bool success;
724         (success,) = address(msg.sender).call{value: address(this).balance}("");
725     }
726 
727     function setOperationsAddress(address _operationsAddress) external onlyOwner {
728         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
729         operationsAddress = payable(_operationsAddress);
730     }
731 
732     function setDevAddress(address _devAddress) external onlyOwner {
733         require(_devAddress != address(0), "_devAddress address cannot be 0");
734         devAddress = payable(_devAddress);
735     }
736 
737     // force Swap back if slippage issues.
738     function forceSwapBack() external onlyOwner {
739         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
740         swapping = true;
741         swapBack();
742         swapping = false;
743         emit OwnerForcedSwapBack(block.timestamp);
744     }
745 
746     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
747     function buyBackTokens(uint256 amountInWei) external onlyOwner {
748         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
749 
750         address[] memory path = new address[](2);
751         path[0] = dexRouter.WETH();
752         path[1] = address(this);
753 
754         // make the swap
755         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
756             0, // accept any amount of Ethereum
757             path,
758             address(0xdead),
759             block.timestamp
760         );
761         emit BuyBackTriggered(amountInWei);
762     }
763 }