1 /*
2 website: https://karencoin.biz/
3 twitter: https://twitter.com/KarenEthereum
4 telegram: https://t.me/karenethereum
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.17;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; 
18         return msg.data;
19     }
20 }
21 
22 interface IERC20 {
23 
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient,uint256 amount) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 interface IERC20Metadata is IERC20 {
36 
37     function name() external view returns (string memory);
38     function symbol() external view returns (string memory);
39     function decimals() external view returns (uint8);
40 }
41 contract ERC20 is Context, IERC20, IERC20Metadata {
42     mapping(address => uint256) private _balances;
43     mapping(address => mapping(address => uint256)) private _allowances;
44 
45     uint256 private _totalSupply;
46     string private _name;
47     string private _symbol;
48 
49     constructor(string memory name_, string memory symbol_) {_name = name_;_symbol = symbol_;
50     }
51 
52     function name() public view virtual override returns (string memory) {
53         return _name;
54     }
55 
56     function symbol() public view virtual override returns (string memory) {
57         return _symbol;
58     }
59 
60     function decimals() public view virtual override returns (uint8) {
61         return 18;
62     }
63 
64     function totalSupply() public view virtual override returns (uint256) {
65         return _totalSupply;
66     }
67 
68     function balanceOf(address account) public view virtual override returns (uint256) {
69         return _balances[account];
70     }
71 
72     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {_transfer(_msgSender(), recipient, amount);
73         return true;
74     }
75 
76     function allowance(address owner, address spender) public view virtual override returns (uint256) {
77         return _allowances[owner][spender];
78     }
79 
80     function approve(address spender, uint256 amount) public virtual override returns (bool) {_approve(_msgSender(), spender, amount);
81         return true;
82     }
83 
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) public virtual override returns (bool) {
89         _transfer(sender, recipient, amount);
90 
91         uint256 currentAllowance = _allowances[sender][_msgSender()];
92         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
93         unchecked {
94             _approve(sender, _msgSender(), currentAllowance - amount);
95         }
96 
97         return true;
98     }
99 
100     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
101         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
102         return true;
103     }
104 
105     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
106         uint256 currentAllowance = _allowances[_msgSender()][spender];
107         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
108         unchecked {
109             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
110         }
111 
112         return true;
113     }
114 
115     function _transfer(
116         address sender,
117         address recipient,
118         uint256 amount
119     ) internal virtual {
120         require(sender != address(0), "ERC20: transfer from the zero address");
121         require(recipient != address(0), "ERC20: transfer to the zero address");
122 
123         uint256 senderBalance = _balances[sender];
124         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
125         unchecked {
126             _balances[sender] = senderBalance - amount;
127         }
128         _balances[recipient] += amount;
129 
130         emit Transfer(sender, recipient, amount);
131     }
132 
133     function _createInitialSupply(address account, uint256 amount) internal virtual {
134         require(account != address(0), "ERC20: mint to the zero address");
135 
136         _totalSupply += amount;
137         _balances[account] += amount;
138         emit Transfer(address(0), account, amount);
139     }
140 
141     function _burn(address account, uint256 amount) internal virtual {
142         require(account != address(0), "ERC20: burn from the zero address");
143         uint256 accountBalance = _balances[account];
144         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
145         unchecked {
146             _balances[account] = accountBalance - amount;
147             // Overflow not possible: amount <= accountBalance <= totalSupply.
148             _totalSupply -= amount;
149         }
150 
151         emit Transfer(account, address(0), amount);
152     }
153 
154     function _approve(
155         address owner,
156         address spender,
157         uint256 amount
158     ) internal virtual {
159         require(owner != address(0), "ERC20: approve from the zero address");
160         require(spender != address(0), "ERC20: approve to the zero address");
161 
162         _allowances[owner][spender] = amount;
163         emit Approval(owner, spender, amount);
164     }
165 }
166 
167 contract Ownable is Context {
168     address private _owner;
169 
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     constructor () {
173         address msgSender = _msgSender();
174         _owner = msgSender;
175         emit OwnershipTransferred(address(0), msgSender);
176     }
177 
178     function owner() public view returns (address) {
179         return _owner;
180     }
181 
182     modifier onlyOwner() {
183         require(_owner == _msgSender(), "Ownable: caller is not the owner");
184         _;
185     }
186 
187     function renounceOwnership() external virtual onlyOwner {
188         emit OwnershipTransferred(_owner, address(0));
189         _owner = address(0);
190     }
191 
192     function transferOwnership(address newOwner) public virtual onlyOwner {
193         require(newOwner != address(0), "Ownable: new owner is the zero address");
194         emit OwnershipTransferred(_owner, newOwner);
195         _owner = newOwner;
196     }
197 }
198 
199 interface IDexRouter {
200     function factory() external pure returns (address);
201     function WETH() external pure returns (address);
202 
203     function swapExactTokensForETHSupportingFeeOnTransferTokens(
204         uint amountIn,
205         uint amountOutMin,
206         address[] calldata path,
207         address to,
208         uint deadline
209     ) external;
210 
211     function swapExactETHForTokensSupportingFeeOnTransferTokens(
212         uint amountOutMin,
213         address[] calldata path,
214         address to,
215         uint deadline
216     ) external payable;
217 
218     function addLiquidityETH(
219         address token,
220         uint256 amountTokenDesired,
221         uint256 amountTokenMin,
222         uint256 amountETHMin,
223         address to,
224         uint256 deadline
225     )
226         external
227         payable
228         returns (
229             uint256 amountToken,
230             uint256 amountETH,
231             uint256 liquidity
232         );
233 }
234 
235 interface IDexFactory {
236     function createPair(address tokenA, address tokenB)
237         external
238         returns (address pair);
239 }
240 
241 contract Karen is ERC20, Ownable {
242 
243     uint256 public maxBuyAmount;
244     uint256 public maxSellAmount;
245     uint256 public maxWalletAmount;
246 
247     IDexRouter public dexRouter;
248     address public lpPair;
249 
250     bool private swapping;
251     uint256 public swapTokensAtAmount;
252 
253     address operationsAddress;
254     address devAddress;
255 
256     uint256 public tradingActiveBlock = 0;
257     uint256 public blockForPenaltyEnd;
258     mapping (address => bool) public boughtEarly;
259     uint256 public botsCaught;
260 
261     bool public limitsInEffect = true;
262     bool public tradingActive = false;
263     bool public swapEnabled = false;
264 
265      // Anti-bot and anti-whale mappings and variables
266     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
267     bool public transferDelayEnabled = true;
268 
269     uint256 public buyTotalFees;
270     uint256 public buyOperationsFee;
271     uint256 public buyLiquidityFee;
272     uint256 public buyDevFee;
273     uint256 public buyBurnFee;
274 
275     uint256 public sellTotalFees;
276     uint256 public sellOperationsFee;
277     uint256 public sellLiquidityFee;
278     uint256 public sellDevFee;
279     uint256 public sellBurnFee;
280 
281     uint256 public tokensForOperations;
282     uint256 public tokensForLiquidity;
283     uint256 public tokensForDev;
284     uint256 public tokensForBurn;
285 
286     /******************/
287 
288     // exlcude from fees and max transaction amount
289     mapping (address => bool) private _isExcludedFromFees;
290     mapping (address => bool) public _isExcludedMaxTransactionAmount;
291 
292     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
293     // could be subject to a maximum transfer amount
294     mapping (address => bool) public automatedMarketMakerPairs;
295 
296     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
297     event EnabledTrading();
298     event RemovedLimits();
299     event ExcludeFromFees(address indexed account, bool isExcluded);
300     event UpdatedMaxBuyAmount(uint256 newAmount);
301     event UpdatedMaxSellAmount(uint256 newAmount);
302     event UpdatedMaxWalletAmount(uint256 newAmount);
303     event UpdatedOperationsAddress(address indexed newWallet);
304     event MaxTransactionExclusion(address _address, bool excluded);
305     event BuyBackTriggered(uint256 amount);
306     event OwnerForcedSwapBack(uint256 timestamp);
307     event CaughtEarlyBuyer(address sniper);
308     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
309     event TransferForeignToken(address token, uint256 amount);
310 
311     constructor() ERC20("Karen", "KAREN") {
312 
313         address newOwner = msg.sender; 
314 
315         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
316         dexRouter = _dexRouter;
317 
318         // create pair
319         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
320         _excludeFromMaxTransaction(address(lpPair), true);
321         _setAutomatedMarketMakerPair(address(lpPair), true);
322 
323         uint256 totalSupply = 69420000000 * 1e18;
324 
325         maxBuyAmount = totalSupply * 2 / 100;
326         maxSellAmount = totalSupply * 2 / 100;
327         maxWalletAmount = totalSupply * 2 / 100;
328         swapTokensAtAmount = totalSupply * 5 / 10000;
329 
330         buyOperationsFee = 15;
331         buyLiquidityFee = 0;
332         buyDevFee = 0;
333         buyBurnFee = 0;
334         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
335 
336         sellOperationsFee = 15;
337         sellLiquidityFee = 0;
338         sellDevFee = 0;
339         sellBurnFee = 0;
340         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
341 
342         _excludeFromMaxTransaction(newOwner, true);
343         _excludeFromMaxTransaction(address(this), true);
344         _excludeFromMaxTransaction(address(0xdead), true);
345 
346         excludeFromFees(newOwner, true);
347         excludeFromFees(address(this), true);
348         excludeFromFees(address(0xdead), true);
349 
350         operationsAddress = address(newOwner);
351         devAddress = address(newOwner);
352 
353         _createInitialSupply(newOwner, totalSupply);
354         transferOwnership(newOwner);
355     }
356 
357     receive() external payable {}
358 
359     function enableTrading(uint256 deadBlocks) external onlyOwner {
360         require(!tradingActive, "Cannot reenable trading");
361         tradingActive = true;
362         swapEnabled = true;
363         tradingActiveBlock = block.number;
364         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
365         emit EnabledTrading();
366     }
367 
368     // remove limits after token is stable
369     function removeLimits() external onlyOwner {
370         limitsInEffect = false;
371         transferDelayEnabled = false;
372         emit RemovedLimits();
373     }
374 
375     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
376         boughtEarly[wallet] = flag;
377     }
378 
379     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
380         for(uint256 i = 0; i < wallets.length; i++){
381             boughtEarly[wallets[i]] = flag;
382         }
383     }
384 
385     // disable Transfer delay - cannot be reenabled
386     function disableTransferDelay() external onlyOwner {
387         transferDelayEnabled = false;
388     }
389 
390     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
391         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
392         maxBuyAmount = newNum * (10**18);
393         emit UpdatedMaxBuyAmount(maxBuyAmount);
394     }
395 
396     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
397         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
398         maxSellAmount = newNum * (10**18);
399         emit UpdatedMaxSellAmount(maxSellAmount);
400     }
401 
402     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
403         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
404         maxWalletAmount = newNum * (10**18);
405         emit UpdatedMaxWalletAmount(maxWalletAmount);
406     }
407 
408     // change the minimum amount of tokens to sell from fees
409     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
410   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
411   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
412   	    swapTokensAtAmount = newAmount;
413   	}
414 
415     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
416         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
417         emit MaxTransactionExclusion(updAds, isExcluded);
418     }
419 
420     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
421         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
422         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
423         for(uint256 i = 0; i < wallets.length; i++){
424             address wallet = wallets[i];
425             uint256 amount = amountsInTokens[i];
426             super._transfer(msg.sender, wallet, amount);
427         }
428     }
429 
430     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
431         if(!isEx){
432             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
433         }
434         _isExcludedMaxTransactionAmount[updAds] = isEx;
435     }
436 
437     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
438         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
439 
440         _setAutomatedMarketMakerPair(pair, value);
441         emit SetAutomatedMarketMakerPair(pair, value);
442     }
443 
444     function _setAutomatedMarketMakerPair(address pair, bool value) private {
445         automatedMarketMakerPairs[pair] = value;
446 
447         _excludeFromMaxTransaction(pair, value);
448 
449         emit SetAutomatedMarketMakerPair(pair, value);
450     }
451 
452     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
453         buyOperationsFee = _operationsFee;
454         buyLiquidityFee = _liquidityFee;
455         buyDevFee = _devFee;
456         buyBurnFee = _burnFee;
457         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
458         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
459     }
460 
461     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
462         sellOperationsFee = _operationsFee;
463         sellLiquidityFee = _liquidityFee;
464         sellDevFee = _devFee;
465         sellBurnFee = _burnFee;
466         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
467         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
468     }
469 
470     function returnToNormalTax() external onlyOwner {
471         sellOperationsFee = 0;
472         sellLiquidityFee = 0;
473         sellDevFee = 0;
474         sellBurnFee = 0;
475         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
476         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
477 
478         buyOperationsFee = 0;
479         buyLiquidityFee = 0;
480         buyDevFee = 0;
481         buyBurnFee = 0;
482         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
483         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
484     }
485 
486     function excludeFromFees(address account, bool excluded) public onlyOwner {
487         _isExcludedFromFees[account] = excluded;
488         emit ExcludeFromFees(account, excluded);
489     }
490 
491     function _transfer(address from, address to, uint256 amount) internal override {
492 
493         require(from != address(0), "ERC20: transfer from the zero address");
494         require(to != address(0), "ERC20: transfer to the zero address");
495         require(amount > 0, "amount must be greater than 0");
496 
497         if(!tradingActive){
498             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
499         }
500 
501         if(blockForPenaltyEnd > 0){
502             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
503         }
504 
505         if(limitsInEffect){
506             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
507 
508                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
509                 if (transferDelayEnabled){
510                     if (to != address(dexRouter) && to != address(lpPair)){
511                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
512                         _holderLastTransferTimestamp[tx.origin] = block.number;
513                         _holderLastTransferTimestamp[to] = block.number;
514                     }
515                 }
516 
517                 //when buy
518                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
519                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
520                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
521                 }
522                 //when sell
523                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
524                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
525                 }
526                 else if (!_isExcludedMaxTransactionAmount[to]){
527                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
528                 }
529             }
530         }
531 
532         uint256 contractTokenBalance = balanceOf(address(this));
533 
534         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
535 
536         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
537             swapping = true;
538 
539             swapBack();
540 
541             swapping = false;
542         }
543 
544         bool takeFee = true;
545         // if any account belongs to _isExcludedFromFee account then remove the fee
546         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
547             takeFee = false;
548         }
549 
550         uint256 fees = 0;
551         // only take fees on buys/sells, do not take on wallet transfers
552         if(takeFee){
553             // bot/sniper penalty.
554             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
555 
556                 if(!boughtEarly[to]){
557                     boughtEarly[to] = true;
558                     botsCaught += 1;
559                     emit CaughtEarlyBuyer(to);
560                 }
561 
562                 fees = amount * 95 / 100;
563         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
564                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
565                 tokensForDev += fees * buyDevFee / buyTotalFees;
566                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
567             }
568 
569             // on sell
570             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
571                 fees = amount * sellTotalFees / 100;
572                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
573                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
574                 tokensForDev += fees * sellDevFee / sellTotalFees;
575                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
576             }
577 
578             // on buy
579             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
580         	    fees = amount * buyTotalFees / 100;
581         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
582                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
583                 tokensForDev += fees * buyDevFee / buyTotalFees;
584                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
585             }
586 
587             if(fees > 0){
588                 super._transfer(from, address(this), fees);
589             }
590 
591         	amount -= fees;
592         }
593 
594         super._transfer(from, to, amount);
595     }
596 
597     function earlyBuyPenaltyInEffect() public view returns (bool){
598         return block.number < blockForPenaltyEnd;
599     }
600 
601     function swapTokensForEth(uint256 tokenAmount) private {
602 
603         // generate the uniswap pair path of token -> weth
604         address[] memory path = new address[](2);
605         path[0] = address(this);
606         path[1] = dexRouter.WETH();
607 
608         _approve(address(this), address(dexRouter), tokenAmount);
609 
610         // make the swap
611         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
612             tokenAmount,
613             0, // accept any amount of ETH
614             path,
615             address(this),
616             block.timestamp
617         );
618     }
619 
620     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
621         // approve token transfer to cover all possible scenarios
622         _approve(address(this), address(dexRouter), tokenAmount);
623 
624         // add the liquidity
625         dexRouter.addLiquidityETH{value: ethAmount}(
626             address(this),
627             tokenAmount,
628             0, 
629             0, 
630             msg.sender,
631             block.timestamp
632         );
633     }
634 
635     function swapBack() private {
636 
637         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
638             _burn(address(this), tokensForBurn);
639         }
640         tokensForBurn = 0;
641 
642         uint256 contractBalance = balanceOf(address(this));
643         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
644 
645         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
646 
647         if(contractBalance > swapTokensAtAmount * 20){
648             contractBalance = swapTokensAtAmount * 20;
649         }
650 
651         bool success;
652 
653         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
654 
655         swapTokensForEth(contractBalance - liquidityTokens);
656 
657         uint256 ethBalance = address(this).balance;
658         uint256 ethForLiquidity = ethBalance;
659 
660         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
661         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
662 
663         ethForLiquidity -= ethForOperations + ethForDev;
664 
665         tokensForLiquidity = 0;
666         tokensForOperations = 0;
667         tokensForDev = 0;
668         tokensForBurn = 0;
669 
670         if(liquidityTokens > 0 && ethForLiquidity > 0){
671             addLiquidity(liquidityTokens, ethForLiquidity);
672         }
673 
674         (success,) = address(devAddress).call{value: ethForDev}("");
675 
676         (success,) = address(operationsAddress).call{value: address(this).balance}("");
677     }
678 
679     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
680         require(_token != address(0), "_token address cannot be 0");
681         require(_token != address(this), "Can't withdraw native tokens");
682         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
683         _sent = IERC20(_token).transfer(_to, _contractBalance);
684         emit TransferForeignToken(_token, _contractBalance);
685     }
686 
687     // withdraw ETH if stuck
688     function withdrawStuckETH() external onlyOwner {
689         bool success;
690         (success,) = address(msg.sender).call{value: address(this).balance}("");
691     }
692 
693     function setOperationsAddress(address _operationsAddress) external onlyOwner {
694         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
695         operationsAddress = payable(_operationsAddress);
696     }
697 
698     function setDevAddress(address _devAddress) external onlyOwner {
699         require(_devAddress != address(0), "_devAddress address cannot be 0");
700         devAddress = payable(_devAddress);
701     }
702 
703     // force Swap back if needed
704     function forceSwapBack() external onlyOwner {
705         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
706         swapping = true;
707         swapBack();
708         swapping = false;
709         emit OwnerForcedSwapBack(block.timestamp);
710     }
711 
712     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
713     function buyBackTokens(uint256 amountInWei) external onlyOwner {
714         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
715 
716         address[] memory path = new address[](2);
717         path[0] = dexRouter.WETH();
718         path[1] = address(this);
719 
720         // make the swap
721         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
722             0, // accept any amount of Ethereum
723             path,
724             address(0xdead),
725             block.timestamp
726         );
727         emit BuyBackTriggered(amountInWei);
728     }
729 }