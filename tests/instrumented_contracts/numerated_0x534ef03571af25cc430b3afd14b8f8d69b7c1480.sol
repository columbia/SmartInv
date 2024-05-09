1 /**
2  *
3 */
4 
5 /**
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.15;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25 
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38    
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 interface IERC20Metadata is IERC20 {
43     
44     function name() external view returns (string memory);
45     function symbol() external view returns (string memory);
46     function decimals() external view returns (uint8);
47 }
48 
49 contract ERC20 is Context, IERC20, IERC20Metadata {
50     mapping(address => uint256) private _balances;
51     mapping(address => mapping(address => uint256)) private _allowances;
52 
53     uint256 private _totalSupply;
54     string private _name;
55     string private _symbol;
56 
57     constructor(string memory name_, string memory symbol_) {
58         _name = name_;
59         _symbol = symbol_;
60     }
61 
62     function name() public view virtual override returns (string memory) {
63         return _name;
64     }
65 
66     function symbol() public view virtual override returns (string memory) {
67         return _symbol;
68     }
69 
70     function decimals() public view virtual override returns (uint8) {
71         return 18;
72     }
73 
74     function totalSupply() public view virtual override returns (uint256) {
75         return _totalSupply;
76     }
77 
78     function balanceOf(address account) public view virtual override returns (uint256) {
79         return _balances[account];
80     }
81 
82     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
83         _transfer(_msgSender(), recipient, amount);
84         return true;
85     }
86 
87     function allowance(address owner, address spender) public view virtual override returns (uint256) {
88         return _allowances[owner][spender];
89     }
90 
91     function approve(address spender, uint256 amount) public virtual override returns (bool) {
92         _approve(_msgSender(), spender, amount);
93         return true;
94     }
95 
96     function transferFrom(
97         address sender,
98         address recipient,
99         uint256 amount
100     ) public virtual override returns (bool) {
101         _transfer(sender, recipient, amount);
102 
103         uint256 currentAllowance = _allowances[sender][_msgSender()];
104         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
105         unchecked {
106             _approve(sender, _msgSender(), currentAllowance - amount);
107         }
108 
109         return true;
110     }
111 
112     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
113         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
114         return true;
115     }
116 
117     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
118         uint256 currentAllowance = _allowances[_msgSender()][spender];
119         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
120         unchecked {
121             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
122         }
123 
124         return true;
125     }
126 
127     function _transfer(
128         address sender,
129         address recipient,
130         uint256 amount
131     ) internal virtual {
132         require(sender != address(0), "ERC20: transfer from the zero address");
133         require(recipient != address(0), "ERC20: transfer to the zero address");
134 
135         uint256 senderBalance = _balances[sender];
136         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
137         unchecked {
138             _balances[sender] = senderBalance - amount;
139         }
140         _balances[recipient] += amount;
141 
142         emit Transfer(sender, recipient, amount);
143     }
144 
145     function _createInitialSupply(address account, uint256 amount) internal virtual {
146         require(account != address(0), "ERC20: mint to the zero address");
147 
148         _totalSupply += amount;
149         _balances[account] += amount;
150         emit Transfer(address(0), account, amount);
151     }
152 
153     function _burn(address account, uint256 amount) internal virtual {
154         require(account != address(0), "ERC20: burn from the zero address");
155         uint256 accountBalance = _balances[account];
156         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
157         unchecked {
158             _balances[account] = accountBalance - amount;
159             // Overflow not possible: amount <= accountBalance <= totalSupply.
160             _totalSupply -= amount;
161         }
162 
163         emit Transfer(account, address(0), amount);
164     }
165 
166     function _approve(
167         address owner,
168         address spender,
169         uint256 amount
170     ) internal virtual {
171         require(owner != address(0), "ERC20: approve from the zero address");
172         require(spender != address(0), "ERC20: approve to the zero address");
173 
174         _allowances[owner][spender] = amount;
175         emit Approval(owner, spender, amount);
176     }
177 }
178 
179 contract Ownable is Context {
180     address private _owner;
181 
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184     constructor () {
185         address msgSender = _msgSender();
186         _owner = msgSender;
187         emit OwnershipTransferred(address(0), msgSender);
188     }
189 
190     function owner() public view returns (address) {
191         return _owner;
192     }
193 
194     modifier onlyOwner() {
195         require(_owner == _msgSender(), "Ownable: caller is not the owner");
196         _;
197     }
198 
199     function renounceOwnership() external virtual onlyOwner {
200         emit OwnershipTransferred(_owner, address(0));
201         _owner = address(0);
202     }
203 
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         emit OwnershipTransferred(_owner, newOwner);
207         _owner = newOwner;
208     }
209 }
210 
211 interface IDexRouter {
212     function factory() external pure returns (address);
213     function WETH() external pure returns (address);
214 
215     function swapExactTokensForETHSupportingFeeOnTransferTokens(
216         uint amountIn,
217         uint amountOutMin,
218         address[] calldata path,
219         address to,
220         uint deadline
221     ) external;
222 
223     function swapExactETHForTokensSupportingFeeOnTransferTokens(
224         uint amountOutMin,
225         address[] calldata path,
226         address to,
227         uint deadline
228     ) external payable;
229 
230     function addLiquidityETH(
231         address token,
232         uint256 amountTokenDesired,
233         uint256 amountTokenMin,
234         uint256 amountETHMin,
235         address to,
236         uint256 deadline
237     )
238         external
239         payable
240         returns (
241             uint256 amountToken,
242             uint256 amountETH,
243             uint256 liquidity
244         );
245 }
246 
247 interface IDexFactory {
248     function createPair(address tokenA, address tokenB)
249         external
250         returns (address pair);
251 }
252 
253 contract NyanCat is ERC20, Ownable {
254 
255     uint256 public maxBuyAmount;
256     uint256 public maxSellAmount;
257     uint256 public maxWalletAmount;
258 
259     IDexRouter public dexRouter;
260     address public lpPair;
261 
262     bool private swapping;
263     uint256 public swapTokensAtAmount;
264 
265     address operationsAddress;
266     address devAddress;
267 
268     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
269     uint256 public blockForPenaltyEnd;
270     mapping (address => bool) public boughtEarly;
271     uint256 public botsCaught;
272 
273     bool public limitsInEffect = true;
274     bool public tradingActive = false;
275     bool public swapEnabled = false;
276 
277      // Anti-bot and anti-whale mappings and variables
278     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
279     bool public transferDelayEnabled = true;
280 
281     uint256 public buyTotalFees;
282     uint256 public buyOperationsFee;
283     uint256 public buyLiquidityFee;
284     uint256 public buyDevFee;
285     uint256 public buyBurnFee;
286 
287     uint256 public sellTotalFees;
288     uint256 public sellOperationsFee;
289     uint256 public sellLiquidityFee;
290     uint256 public sellDevFee;
291     uint256 public sellBurnFee;
292 
293     uint256 public tokensForOperations;
294     uint256 public tokensForLiquidity;
295     uint256 public tokensForDev;
296     uint256 public tokensForBurn;
297 
298     /******************/
299 
300     // exlcude from fees and max transaction amount
301     mapping (address => bool) private _isExcludedFromFees;
302     mapping (address => bool) public _isExcludedMaxTransactionAmount;
303 
304     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
305     // could be subject to a maximum transfer amount
306     mapping (address => bool) public automatedMarketMakerPairs;
307 
308     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
309 
310     event EnabledTrading();
311 
312     event RemovedLimits();
313 
314     event ExcludeFromFees(address indexed account, bool isExcluded);
315 
316     event UpdatedMaxBuyAmount(uint256 newAmount);
317 
318     event UpdatedMaxSellAmount(uint256 newAmount);
319 
320     event UpdatedMaxWalletAmount(uint256 newAmount);
321 
322     event UpdatedOperationsAddress(address indexed newWallet);
323 
324     event MaxTransactionExclusion(address _address, bool excluded);
325 
326     event BuyBackTriggered(uint256 amount);
327 
328     event OwnerForcedSwapBack(uint256 timestamp);
329 
330     event CaughtEarlyBuyer(address sniper);
331 
332     event SwapAndLiquify(
333         uint256 tokensSwapped,
334         uint256 ethReceived,
335         uint256 tokensIntoLiquidity
336     );
337 
338     event TransferForeignToken(address token, uint256 amount);
339 
340     constructor() ERC20("Nyan Cat", "Nyan") {
341 
342         address newOwner = msg.sender; // can leave alone if owner is deployer.
343 
344         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
345         dexRouter = _dexRouter;
346 
347         // create pair
348         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
349         _excludeFromMaxTransaction(address(lpPair), true);
350         _setAutomatedMarketMakerPair(address(lpPair), true);
351 
352         uint256 totalSupply = 1 * 1e9 * 1e18;
353 
354         maxBuyAmount = totalSupply * 1 / 100;
355         maxSellAmount = totalSupply * 1 / 100;
356         maxWalletAmount = totalSupply * 2 / 100;
357         swapTokensAtAmount = totalSupply * 5 / 10000;
358 
359         buyOperationsFee = 10;
360         buyLiquidityFee = 2;
361         buyDevFee = 10;
362         buyBurnFee = 0;
363         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
364 
365         sellOperationsFee = 10;
366         sellLiquidityFee = 2;
367         sellDevFee = 20;
368         sellBurnFee = 0;
369         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
370 
371         _excludeFromMaxTransaction(newOwner, true);
372         _excludeFromMaxTransaction(address(this), true);
373         _excludeFromMaxTransaction(address(0xdead), true);
374 
375         excludeFromFees(newOwner, true);
376         excludeFromFees(address(this), true);
377         excludeFromFees(address(0xdead), true);
378 
379         operationsAddress = address(newOwner);
380         devAddress = address(newOwner);
381 
382         _createInitialSupply(newOwner, totalSupply);
383         transferOwnership(newOwner);
384     }
385 
386     receive() external payable {}
387 
388     // only enable if no plan to airdrop
389 
390     function enableTrading(uint256 deadBlocks) external onlyOwner {
391         require(!tradingActive, "Cannot reenable trading");
392         tradingActive = true;
393         swapEnabled = true;
394         tradingActiveBlock = block.number;
395         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
396         emit EnabledTrading();
397     }
398 
399     // remove limits after token is stable
400     function removeLimits() external onlyOwner {
401         limitsInEffect = false;
402         transferDelayEnabled = false;
403         emit RemovedLimits();
404     }
405 
406     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
407         boughtEarly[wallet] = flag;
408     }
409 
410     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
411         for(uint256 i = 0; i < wallets.length; i++){
412             boughtEarly[wallets[i]] = flag;
413         }
414     }
415 
416     // disable Transfer delay - cannot be reenabled
417     function disableTransferDelay() external onlyOwner {
418         transferDelayEnabled = false;
419     }
420 
421     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
422         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
423         maxBuyAmount = newNum * (10**18);
424         emit UpdatedMaxBuyAmount(maxBuyAmount);
425     }
426 
427     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
428         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
429         maxSellAmount = newNum * (10**18);
430         emit UpdatedMaxSellAmount(maxSellAmount);
431     }
432 
433     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
434         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
435         maxWalletAmount = newNum * (10**18);
436         emit UpdatedMaxWalletAmount(maxWalletAmount);
437     }
438 
439     // change the minimum amount of tokens to sell from fees
440     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
441   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
442   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
443   	    swapTokensAtAmount = newAmount;
444   	}
445 
446     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
447         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
448         emit MaxTransactionExclusion(updAds, isExcluded);
449     }
450 
451     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
452         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
453         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
454         for(uint256 i = 0; i < wallets.length; i++){
455             address wallet = wallets[i];
456             uint256 amount = amountsInTokens[i];
457             super._transfer(msg.sender, wallet, amount);
458         }
459     }
460 
461     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
462         if(!isEx){
463             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
464         }
465         _isExcludedMaxTransactionAmount[updAds] = isEx;
466     }
467 
468     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
469         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
470 
471         _setAutomatedMarketMakerPair(pair, value);
472         emit SetAutomatedMarketMakerPair(pair, value);
473     }
474 
475     function _setAutomatedMarketMakerPair(address pair, bool value) private {
476         automatedMarketMakerPairs[pair] = value;
477 
478         _excludeFromMaxTransaction(pair, value);
479 
480         emit SetAutomatedMarketMakerPair(pair, value);
481     }
482 
483     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
484         buyOperationsFee = _operationsFee;
485         buyLiquidityFee = _liquidityFee;
486         buyDevFee = _DevFee;
487         buyBurnFee = _burnFee;
488         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
489         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
490     }
491 
492     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
493         sellOperationsFee = _operationsFee;
494         sellLiquidityFee = _liquidityFee;
495         sellDevFee = _DevFee;
496         sellBurnFee = _burnFee;
497         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
498         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
499     }
500 
501     function returnToNormalTax() external onlyOwner {
502         sellOperationsFee = 10;
503         sellLiquidityFee = 2;
504         sellDevFee = 5;
505         sellBurnFee = 0;
506         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
507         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
508 
509         buyOperationsFee = 10;
510         buyLiquidityFee = 2;
511         buyDevFee = 5;
512         buyBurnFee = 0;
513         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
514         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
515     }
516 
517     function excludeFromFees(address account, bool excluded) public onlyOwner {
518         _isExcludedFromFees[account] = excluded;
519         emit ExcludeFromFees(account, excluded);
520     }
521 
522     function _transfer(address from, address to, uint256 amount) internal override {
523 
524         require(from != address(0), "ERC20: transfer from the zero address");
525         require(to != address(0), "ERC20: transfer to the zero address");
526         require(amount > 0, "amount must be greater than 0");
527 
528         if(!tradingActive){
529             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
530         }
531 
532         if(blockForPenaltyEnd > 0){
533             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
534         }
535 
536         if(limitsInEffect){
537             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
538 
539                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
540                 if (transferDelayEnabled){
541                     if (to != address(dexRouter) && to != address(lpPair)){
542                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
543                         _holderLastTransferTimestamp[tx.origin] = block.number;
544                         _holderLastTransferTimestamp[to] = block.number;
545                     }
546                 }
547 
548                 //when buy
549                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
550                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
551                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
552                 }
553                 //when sell
554                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
555                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
556                 }
557                 else if (!_isExcludedMaxTransactionAmount[to]){
558                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
559                 }
560             }
561         }
562 
563         uint256 contractTokenBalance = balanceOf(address(this));
564 
565         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
566 
567         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
568             swapping = true;
569 
570             swapBack();
571 
572             swapping = false;
573         }
574 
575         bool takeFee = true;
576         // if any account belongs to _isExcludedFromFee account then remove the fee
577         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
578             takeFee = false;
579         }
580 
581         uint256 fees = 0;
582         // only take fees on buys/sells, do not take on wallet transfers
583         if(takeFee){
584             // bot/sniper penalty.
585             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
586 
587                 if(!boughtEarly[to]){
588                     boughtEarly[to] = true;
589                     botsCaught += 1;
590                     emit CaughtEarlyBuyer(to);
591                 }
592 
593                 fees = amount * 99 / 100;
594         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
595                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
596                 tokensForDev += fees * buyDevFee / buyTotalFees;
597                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
598             }
599 
600             // on sell
601             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
602                 fees = amount * sellTotalFees / 100;
603                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
604                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
605                 tokensForDev += fees * sellDevFee / sellTotalFees;
606                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
607             }
608 
609             // on buy
610             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
611         	    fees = amount * buyTotalFees / 100;
612         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
613                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
614                 tokensForDev += fees * buyDevFee / buyTotalFees;
615                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
616             }
617 
618             if(fees > 0){
619                 super._transfer(from, address(this), fees);
620             }
621 
622         	amount -= fees;
623         }
624 
625         super._transfer(from, to, amount);
626     }
627 
628     function earlyBuyPenaltyInEffect() public view returns (bool){
629         return block.number < blockForPenaltyEnd;
630     }
631 
632     function swapTokensForEth(uint256 tokenAmount) private {
633 
634         // generate the uniswap pair path of token -> weth
635         address[] memory path = new address[](2);
636         path[0] = address(this);
637         path[1] = dexRouter.WETH();
638 
639         _approve(address(this), address(dexRouter), tokenAmount);
640 
641         // make the swap
642         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
643             tokenAmount,
644             0, // accept any amount of ETH
645             path,
646             address(this),
647             block.timestamp
648         );
649     }
650 
651     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
652         // approve token transfer to cover all possible scenarios
653         _approve(address(this), address(dexRouter), tokenAmount);
654 
655         // add the liquidity
656         dexRouter.addLiquidityETH{value: ethAmount}(
657             address(this),
658             tokenAmount,
659             0, // slippage is unavoidable
660             0, // slippage is unavoidable
661             address(0xdead),
662             block.timestamp
663         );
664     }
665 
666     function swapBack() private {
667 
668         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
669             _burn(address(this), tokensForBurn);
670         }
671         tokensForBurn = 0;
672 
673         uint256 contractBalance = balanceOf(address(this));
674         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
675 
676         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
677 
678         if(contractBalance > swapTokensAtAmount * 20){
679             contractBalance = swapTokensAtAmount * 20;
680         }
681 
682         bool success;
683 
684         // Halve the amount of liquidity tokens
685         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
686 
687         swapTokensForEth(contractBalance - liquidityTokens);
688 
689         uint256 ethBalance = address(this).balance;
690         uint256 ethForLiquidity = ethBalance;
691 
692         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
693         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
694 
695         ethForLiquidity -= ethForOperations + ethForDev;
696 
697         tokensForLiquidity = 0;
698         tokensForOperations = 0;
699         tokensForDev = 0;
700         tokensForBurn = 0;
701 
702         if(liquidityTokens > 0 && ethForLiquidity > 0){
703             addLiquidity(liquidityTokens, ethForLiquidity);
704         }
705 
706         (success,) = address(devAddress).call{value: ethForDev}("");
707 
708         (success,) = address(operationsAddress).call{value: address(this).balance}("");
709     }
710 
711     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
712         require(_token != address(0), "_token address cannot be 0");
713         require(_token != address(this), "Can't withdraw native tokens");
714         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
715         _sent = IERC20(_token).transfer(_to, _contractBalance);
716         emit TransferForeignToken(_token, _contractBalance);
717     }
718 
719     // withdraw ETH if stuck or someone sends to the address
720     function withdrawStuckETH() external onlyOwner {
721         bool success;
722         (success,) = address(msg.sender).call{value: address(this).balance}("");
723     }
724 
725     function setOperationsAddress(address _operationsAddress) external onlyOwner {
726         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
727         operationsAddress = payable(_operationsAddress);
728     }
729 
730     function setDevAddress(address _devAddress) external onlyOwner {
731         require(_devAddress != address(0), "_devAddress address cannot be 0");
732         devAddress = payable(_devAddress);
733     }
734 
735     // force Swap back if slippage issues.
736     function forceSwapBack() external onlyOwner {
737         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
738         swapping = true;
739         swapBack();
740         swapping = false;
741         emit OwnerForcedSwapBack(block.timestamp);
742     }
743 
744     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
745     function buyBackTokens(uint256 amountInWei) external onlyOwner {
746         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
747 
748         address[] memory path = new address[](2);
749         path[0] = dexRouter.WETH();
750         path[1] = address(this);
751 
752         // make the swap
753         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
754             0, // accept any amount of Ethereum
755             path,
756             address(0xdead),
757             block.timestamp
758         );
759         emit BuyBackTriggered(amountInWei);
760     }
761 }