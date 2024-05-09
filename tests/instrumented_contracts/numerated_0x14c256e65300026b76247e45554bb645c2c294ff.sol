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
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30    
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 interface IERC20Metadata is IERC20 {
35     
36     function name() external view returns (string memory);
37     function symbol() external view returns (string memory);
38     function decimals() external view returns (uint8);
39 }
40 
41 contract ERC20 is Context, IERC20, IERC20Metadata {
42     mapping(address => uint256) private _balances;
43     mapping(address => mapping(address => uint256)) private _allowances;
44 
45     uint256 private _totalSupply;
46     string private _name;
47     string private _symbol;
48 
49     constructor(string memory name_, string memory symbol_) {
50         _name = name_;
51         _symbol = symbol_;
52     }
53 
54     function name() public view virtual override returns (string memory) {
55         return _name;
56     }
57 
58     function symbol() public view virtual override returns (string memory) {
59         return _symbol;
60     }
61 
62     function decimals() public view virtual override returns (uint8) {
63         return 18;
64     }
65 
66     function totalSupply() public view virtual override returns (uint256) {
67         return _totalSupply;
68     }
69 
70     function balanceOf(address account) public view virtual override returns (uint256) {
71         return _balances[account];
72     }
73 
74     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
75         _transfer(_msgSender(), recipient, amount);
76         return true;
77     }
78 
79     function allowance(address owner, address spender) public view virtual override returns (uint256) {
80         return _allowances[owner][spender];
81     }
82 
83     function approve(address spender, uint256 amount) public virtual override returns (bool) {
84         _approve(_msgSender(), spender, amount);
85         return true;
86     }
87 
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) public virtual override returns (bool) {
93         _transfer(sender, recipient, amount);
94 
95         uint256 currentAllowance = _allowances[sender][_msgSender()];
96         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
97         unchecked {
98             _approve(sender, _msgSender(), currentAllowance - amount);
99         }
100 
101         return true;
102     }
103 
104     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
105         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
106         return true;
107     }
108 
109     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
110         uint256 currentAllowance = _allowances[_msgSender()][spender];
111         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
112         unchecked {
113             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
114         }
115 
116         return true;
117     }
118 
119     function _transfer(
120         address sender,
121         address recipient,
122         uint256 amount
123     ) internal virtual {
124         require(sender != address(0), "ERC20: transfer from the zero address");
125         require(recipient != address(0), "ERC20: transfer to the zero address");
126 
127         uint256 senderBalance = _balances[sender];
128         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
129         unchecked {
130             _balances[sender] = senderBalance - amount;
131         }
132         _balances[recipient] += amount;
133 
134         emit Transfer(sender, recipient, amount);
135     }
136 
137     function _createInitialSupply(address account, uint256 amount) internal virtual {
138         require(account != address(0), "ERC20: mint to the zero address");
139 
140         _totalSupply += amount;
141         _balances[account] += amount;
142         emit Transfer(address(0), account, amount);
143     }
144 
145     function _burn(address account, uint256 amount) internal virtual {
146         require(account != address(0), "ERC20: burn from the zero address");
147         uint256 accountBalance = _balances[account];
148         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
149         unchecked {
150             _balances[account] = accountBalance - amount;
151             // Overflow not possible: amount <= accountBalance <= totalSupply.
152             _totalSupply -= amount;
153         }
154 
155         emit Transfer(account, address(0), amount);
156     }
157 
158     function _approve(
159         address owner,
160         address spender,
161         uint256 amount
162     ) internal virtual {
163         require(owner != address(0), "ERC20: approve from the zero address");
164         require(spender != address(0), "ERC20: approve to the zero address");
165 
166         _allowances[owner][spender] = amount;
167         emit Approval(owner, spender, amount);
168     }
169 }
170 
171 contract Ownable is Context {
172     address private _owner;
173 
174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
175 
176     constructor () {
177         address msgSender = _msgSender();
178         _owner = msgSender;
179         emit OwnershipTransferred(address(0), msgSender);
180     }
181 
182     function owner() public view returns (address) {
183         return _owner;
184     }
185 
186     modifier onlyOwner() {
187         require(_owner == _msgSender(), "Ownable: caller is not the owner");
188         _;
189     }
190 
191     function renounceOwnership() external virtual onlyOwner {
192         emit OwnershipTransferred(_owner, address(0));
193         _owner = address(0);
194     }
195 
196     function transferOwnership(address newOwner) public virtual onlyOwner {
197         require(newOwner != address(0), "Ownable: new owner is the zero address");
198         emit OwnershipTransferred(_owner, newOwner);
199         _owner = newOwner;
200     }
201 }
202 
203 interface IDexRouter {
204     function factory() external pure returns (address);
205     function WETH() external pure returns (address);
206 
207     function swapExactTokensForETHSupportingFeeOnTransferTokens(
208         uint amountIn,
209         uint amountOutMin,
210         address[] calldata path,
211         address to,
212         uint deadline
213     ) external;
214 
215     function swapExactETHForTokensSupportingFeeOnTransferTokens(
216         uint amountOutMin,
217         address[] calldata path,
218         address to,
219         uint deadline
220     ) external payable;
221 
222     function addLiquidityETH(
223         address token,
224         uint256 amountTokenDesired,
225         uint256 amountTokenMin,
226         uint256 amountETHMin,
227         address to,
228         uint256 deadline
229     )
230         external
231         payable
232         returns (
233             uint256 amountToken,
234             uint256 amountETH,
235             uint256 liquidity
236         );
237 }
238 
239 interface IDexFactory {
240     function createPair(address tokenA, address tokenB)
241         external
242         returns (address pair);
243 }
244 
245 contract Shibet is ERC20, Ownable {
246 
247     uint256 public maxBuyAmount;
248     uint256 public maxSellAmount;
249     uint256 public maxWalletAmount;
250 
251     IDexRouter public dexRouter;
252     address public lpPair;
253 
254     bool private swapping;
255     uint256 public swapTokensAtAmount;
256 
257     address operationsAddress;
258     address devAddress;
259 
260     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
261     uint256 public blockForPenaltyEnd;
262     mapping (address => bool) public boughtEarly;
263     uint256 public botsCaught;
264 
265     bool public limitsInEffect = true;
266     bool public tradingActive = false;
267     bool public swapEnabled = false;
268 
269      // Anti-bot and anti-whale mappings and variables
270     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
271     bool public transferDelayEnabled = true;
272 
273     uint256 public buyTotalFees;
274     uint256 public buyOperationsFee;
275     uint256 public buyLiquidityFee;
276     uint256 public buyDevFee;
277     uint256 public buyBurnFee;
278 
279     uint256 public sellTotalFees;
280     uint256 public sellOperationsFee;
281     uint256 public sellLiquidityFee;
282     uint256 public sellDevFee;
283     uint256 public sellBurnFee;
284 
285     uint256 public tokensForOperations;
286     uint256 public tokensForLiquidity;
287     uint256 public tokensForDev;
288     uint256 public tokensForBurn;
289 
290     /******************/
291 
292     // exlcude from fees and max transaction amount
293     mapping (address => bool) private _isExcludedFromFees;
294     mapping (address => bool) public _isExcludedMaxTransactionAmount;
295 
296     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
297     // could be subject to a maximum transfer amount
298     mapping (address => bool) public automatedMarketMakerPairs;
299 
300     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
301 
302     event EnabledTrading();
303 
304     event RemovedLimits();
305 
306     event ExcludeFromFees(address indexed account, bool isExcluded);
307 
308     event UpdatedMaxBuyAmount(uint256 newAmount);
309 
310     event UpdatedMaxSellAmount(uint256 newAmount);
311 
312     event UpdatedMaxWalletAmount(uint256 newAmount);
313 
314     event UpdatedOperationsAddress(address indexed newWallet);
315 
316     event MaxTransactionExclusion(address _address, bool excluded);
317 
318     event BuyBackTriggered(uint256 amount);
319 
320     event OwnerForcedSwapBack(uint256 timestamp);
321 
322     event CaughtEarlyBuyer(address sniper);
323 
324     event SwapAndLiquify(
325         uint256 tokensSwapped,
326         uint256 ethReceived,
327         uint256 tokensIntoLiquidity
328     );
329 
330     event TransferForeignToken(address token, uint256 amount);
331 
332     constructor() ERC20("ShiBet", "SBET") {
333 
334         address newOwner = msg.sender; // can leave alone if owner is deployer.
335 
336         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
337         dexRouter = _dexRouter;
338 
339         // create pair
340         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
341         _excludeFromMaxTransaction(address(lpPair), true);
342         _setAutomatedMarketMakerPair(address(lpPair), true);
343 
344         uint256 totalSupply = 1 * 1e9 * 1e18;
345 
346         maxBuyAmount = totalSupply * 3 / 1000;
347         maxSellAmount = totalSupply * 3 / 1000;
348         maxWalletAmount = totalSupply * 1 / 100;
349         swapTokensAtAmount = totalSupply * 5 / 10000;
350 
351         buyOperationsFee = 4;
352         buyLiquidityFee = 0;
353         buyDevFee = 4;
354         buyBurnFee = 0;
355         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
356 
357         sellOperationsFee = 4;
358         sellLiquidityFee = 0;
359         sellDevFee = 4;
360         sellBurnFee = 0;
361         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
362 
363         _excludeFromMaxTransaction(newOwner, true);
364         _excludeFromMaxTransaction(address(this), true);
365         _excludeFromMaxTransaction(address(0xdead), true);
366 
367         excludeFromFees(newOwner, true);
368         excludeFromFees(address(this), true);
369         excludeFromFees(address(0xdead), true);
370 
371         operationsAddress = address(newOwner);
372         devAddress = address(newOwner);
373 
374         _createInitialSupply(newOwner, totalSupply);
375         transferOwnership(newOwner);
376     }
377 
378     receive() external payable {}
379 
380     // only enable if no plan to airdrop
381 
382     function enableTrading(uint256 deadBlocks) external onlyOwner {
383         require(!tradingActive, "Cannot reenable trading");
384         tradingActive = true;
385         swapEnabled = true;
386         tradingActiveBlock = block.number;
387         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
388         emit EnabledTrading();
389     }
390 
391     // remove limits after token is stable
392     function removeLimits() external onlyOwner {
393         limitsInEffect = false;
394         transferDelayEnabled = false;
395         emit RemovedLimits();
396     }
397 
398     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
399         boughtEarly[wallet] = flag;
400     }
401 
402     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
403         for(uint256 i = 0; i < wallets.length; i++){
404             boughtEarly[wallets[i]] = flag;
405         }
406     }
407 
408     // disable Transfer delay - cannot be reenabled
409     function disableTransferDelay() external onlyOwner {
410         transferDelayEnabled = false;
411     }
412 
413     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
414         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
415         maxBuyAmount = newNum * (10**18);
416         emit UpdatedMaxBuyAmount(maxBuyAmount);
417     }
418 
419     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
420         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
421         maxSellAmount = newNum * (10**18);
422         emit UpdatedMaxSellAmount(maxSellAmount);
423     }
424 
425     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
426         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
427         maxWalletAmount = newNum * (10**18);
428         emit UpdatedMaxWalletAmount(maxWalletAmount);
429     }
430 
431     // change the minimum amount of tokens to sell from fees
432     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
433   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
434   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
435   	    swapTokensAtAmount = newAmount;
436   	}
437 
438     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
439         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
440         emit MaxTransactionExclusion(updAds, isExcluded);
441     }
442 
443     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
444         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
445         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
446         for(uint256 i = 0; i < wallets.length; i++){
447             address wallet = wallets[i];
448             uint256 amount = amountsInTokens[i];
449             super._transfer(msg.sender, wallet, amount);
450         }
451     }
452 
453     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
454         if(!isEx){
455             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
456         }
457         _isExcludedMaxTransactionAmount[updAds] = isEx;
458     }
459 
460     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
461         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
462 
463         _setAutomatedMarketMakerPair(pair, value);
464         emit SetAutomatedMarketMakerPair(pair, value);
465     }
466 
467     function _setAutomatedMarketMakerPair(address pair, bool value) private {
468         automatedMarketMakerPairs[pair] = value;
469 
470         _excludeFromMaxTransaction(pair, value);
471 
472         emit SetAutomatedMarketMakerPair(pair, value);
473     }
474 
475     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
476         buyOperationsFee = _operationsFee;
477         buyLiquidityFee = _liquidityFee;
478         buyDevFee = _DevFee;
479         buyBurnFee = _burnFee;
480         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
481         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
482     }
483 
484     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
485         sellOperationsFee = _operationsFee;
486         sellLiquidityFee = _liquidityFee;
487         sellDevFee = _DevFee;
488         sellBurnFee = _burnFee;
489         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
490         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
491     }
492 
493     function returnToNormalTax() external onlyOwner {
494         sellOperationsFee = 4;
495         sellLiquidityFee = 0;
496         sellDevFee = 4;
497         sellBurnFee = 0;
498         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
499         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
500 
501         buyOperationsFee = 4;
502         buyLiquidityFee = 0;
503         buyDevFee = 4;
504         buyBurnFee = 0;
505         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
506         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
507     }
508 
509     function excludeFromFees(address account, bool excluded) public onlyOwner {
510         _isExcludedFromFees[account] = excluded;
511         emit ExcludeFromFees(account, excluded);
512     }
513 
514     function _transfer(address from, address to, uint256 amount) internal override {
515 
516         require(from != address(0), "ERC20: transfer from the zero address");
517         require(to != address(0), "ERC20: transfer to the zero address");
518         require(amount > 0, "amount must be greater than 0");
519 
520         if(!tradingActive){
521             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
522         }
523 
524         if(blockForPenaltyEnd > 0){
525             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
526         }
527 
528         if(limitsInEffect){
529             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
530 
531                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
532                 if (transferDelayEnabled){
533                     if (to != address(dexRouter) && to != address(lpPair)){
534                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
535                         _holderLastTransferTimestamp[tx.origin] = block.number;
536                         _holderLastTransferTimestamp[to] = block.number;
537                     }
538                 }
539 
540                 //when buy
541                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
542                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
543                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
544                 }
545                 //when sell
546                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
547                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
548                 }
549                 else if (!_isExcludedMaxTransactionAmount[to]){
550                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
551                 }
552             }
553         }
554 
555         uint256 contractTokenBalance = balanceOf(address(this));
556 
557         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
558 
559         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
560             swapping = true;
561 
562             swapBack();
563 
564             swapping = false;
565         }
566 
567         bool takeFee = true;
568         // if any account belongs to _isExcludedFromFee account then remove the fee
569         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
570             takeFee = false;
571         }
572 
573         uint256 fees = 0;
574         // only take fees on buys/sells, do not take on wallet transfers
575         if(takeFee){
576             // bot/sniper penalty.
577             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
578 
579                 if(!boughtEarly[to]){
580                     boughtEarly[to] = true;
581                     botsCaught += 1;
582                     emit CaughtEarlyBuyer(to);
583                 }
584 
585                 fees = amount * 99 / 100;
586         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
587                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
588                 tokensForDev += fees * buyDevFee / buyTotalFees;
589                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
590             }
591 
592             // on sell
593             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
594                 fees = amount * sellTotalFees / 100;
595                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
596                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
597                 tokensForDev += fees * sellDevFee / sellTotalFees;
598                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
599             }
600 
601             // on buy
602             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
603         	    fees = amount * buyTotalFees / 100;
604         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
605                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
606                 tokensForDev += fees * buyDevFee / buyTotalFees;
607                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
608             }
609 
610             if(fees > 0){
611                 super._transfer(from, address(this), fees);
612             }
613 
614         	amount -= fees;
615         }
616 
617         super._transfer(from, to, amount);
618     }
619 
620     function earlyBuyPenaltyInEffect() public view returns (bool){
621         return block.number < blockForPenaltyEnd;
622     }
623 
624     function swapTokensForEth(uint256 tokenAmount) private {
625 
626         // generate the uniswap pair path of token -> weth
627         address[] memory path = new address[](2);
628         path[0] = address(this);
629         path[1] = dexRouter.WETH();
630 
631         _approve(address(this), address(dexRouter), tokenAmount);
632 
633         // make the swap
634         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
635             tokenAmount,
636             0, // accept any amount of ETH
637             path,
638             address(this),
639             block.timestamp
640         );
641     }
642 
643     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
644         // approve token transfer to cover all possible scenarios
645         _approve(address(this), address(dexRouter), tokenAmount);
646 
647         // add the liquidity
648         dexRouter.addLiquidityETH{value: ethAmount}(
649             address(this),
650             tokenAmount,
651             0, // slippage is unavoidable
652             0, // slippage is unavoidable
653             address(0xdead),
654             block.timestamp
655         );
656     }
657 
658     function swapBack() private {
659 
660         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
661             _burn(address(this), tokensForBurn);
662         }
663         tokensForBurn = 0;
664 
665         uint256 contractBalance = balanceOf(address(this));
666         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
667 
668         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
669 
670         if(contractBalance > swapTokensAtAmount * 20){
671             contractBalance = swapTokensAtAmount * 20;
672         }
673 
674         bool success;
675 
676         // Halve the amount of liquidity tokens
677         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
678 
679         swapTokensForEth(contractBalance - liquidityTokens);
680 
681         uint256 ethBalance = address(this).balance;
682         uint256 ethForLiquidity = ethBalance;
683 
684         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
685         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
686 
687         ethForLiquidity -= ethForOperations + ethForDev;
688 
689         tokensForLiquidity = 0;
690         tokensForOperations = 0;
691         tokensForDev = 0;
692         tokensForBurn = 0;
693 
694         if(liquidityTokens > 0 && ethForLiquidity > 0){
695             addLiquidity(liquidityTokens, ethForLiquidity);
696         }
697 
698         (success,) = address(devAddress).call{value: ethForDev}("");
699 
700         (success,) = address(operationsAddress).call{value: address(this).balance}("");
701     }
702 
703     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
704         require(_token != address(0), "_token address cannot be 0");
705         require(_token != address(this), "Can't withdraw native tokens");
706         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
707         _sent = IERC20(_token).transfer(_to, _contractBalance);
708         emit TransferForeignToken(_token, _contractBalance);
709     }
710 
711     // withdraw ETH if stuck or someone sends to the address
712     function withdrawStuckETH() external onlyOwner {
713         bool success;
714         (success,) = address(msg.sender).call{value: address(this).balance}("");
715     }
716 
717     function setOperationsAddress(address _operationsAddress) external onlyOwner {
718         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
719         operationsAddress = payable(_operationsAddress);
720     }
721 
722     function setDevAddress(address _devAddress) external onlyOwner {
723         require(_devAddress != address(0), "_devAddress address cannot be 0");
724         devAddress = payable(_devAddress);
725     }
726 
727     // force Swap back if slippage issues.
728     function forceSwapBack() external onlyOwner {
729         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
730         swapping = true;
731         swapBack();
732         swapping = false;
733         emit OwnerForcedSwapBack(block.timestamp);
734     }
735 
736     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
737     function buyBackTokens(uint256 amountInWei) external onlyOwner {
738         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
739 
740         address[] memory path = new address[](2);
741         path[0] = dexRouter.WETH();
742         path[1] = address(this);
743 
744         // make the swap
745         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
746             0, // accept any amount of Ethereum
747             path,
748             address(0xdead),
749             block.timestamp
750         );
751         emit BuyBackTriggered(amountInWei);
752     }
753 }