1 /**
2  https://t.me/Kabosuinuofficialportal
3 
4  https://twitter.com/KabosuInuETH
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.15;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36    
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 interface IERC20Metadata is IERC20 {
41     
42     function name() external view returns (string memory);
43     function symbol() external view returns (string memory);
44     function decimals() external view returns (uint8);
45 }
46 
47 contract ERC20 is Context, IERC20, IERC20Metadata {
48     mapping(address => uint256) private _balances;
49     mapping(address => mapping(address => uint256)) private _allowances;
50 
51     uint256 private _totalSupply;
52     string private _name;
53     string private _symbol;
54 
55     constructor(string memory name_, string memory symbol_) {
56         _name = name_;
57         _symbol = symbol_;
58     }
59 
60     function name() public view virtual override returns (string memory) {
61         return _name;
62     }
63 
64     function symbol() public view virtual override returns (string memory) {
65         return _symbol;
66     }
67 
68     function decimals() public view virtual override returns (uint8) {
69         return 18;
70     }
71 
72     function totalSupply() public view virtual override returns (uint256) {
73         return _totalSupply;
74     }
75 
76     function balanceOf(address account) public view virtual override returns (uint256) {
77         return _balances[account];
78     }
79 
80     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
81         _transfer(_msgSender(), recipient, amount);
82         return true;
83     }
84 
85     function allowance(address owner, address spender) public view virtual override returns (uint256) {
86         return _allowances[owner][spender];
87     }
88 
89     function approve(address spender, uint256 amount) public virtual override returns (bool) {
90         _approve(_msgSender(), spender, amount);
91         return true;
92     }
93 
94     function transferFrom(
95         address sender,
96         address recipient,
97         uint256 amount
98     ) public virtual override returns (bool) {
99         _transfer(sender, recipient, amount);
100 
101         uint256 currentAllowance = _allowances[sender][_msgSender()];
102         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
103         unchecked {
104             _approve(sender, _msgSender(), currentAllowance - amount);
105         }
106 
107         return true;
108     }
109 
110     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
111         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
112         return true;
113     }
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
116         uint256 currentAllowance = _allowances[_msgSender()][spender];
117         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
118         unchecked {
119             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
120         }
121 
122         return true;
123     }
124 
125     function _transfer(
126         address sender,
127         address recipient,
128         uint256 amount
129     ) internal virtual {
130         require(sender != address(0), "ERC20: transfer from the zero address");
131         require(recipient != address(0), "ERC20: transfer to the zero address");
132 
133         uint256 senderBalance = _balances[sender];
134         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
135         unchecked {
136             _balances[sender] = senderBalance - amount;
137         }
138         _balances[recipient] += amount;
139 
140         emit Transfer(sender, recipient, amount);
141     }
142 
143     function _createInitialSupply(address account, uint256 amount) internal virtual {
144         require(account != address(0), "ERC20: mint to the zero address");
145 
146         _totalSupply += amount;
147         _balances[account] += amount;
148         emit Transfer(address(0), account, amount);
149     }
150 
151     function _burn(address account, uint256 amount) internal virtual {
152         require(account != address(0), "ERC20: burn from the zero address");
153         uint256 accountBalance = _balances[account];
154         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
155         unchecked {
156             _balances[account] = accountBalance - amount;
157             // Overflow not possible: amount <= accountBalance <= totalSupply.
158             _totalSupply -= amount;
159         }
160 
161         emit Transfer(account, address(0), amount);
162     }
163 
164     function _approve(
165         address owner,
166         address spender,
167         uint256 amount
168     ) internal virtual {
169         require(owner != address(0), "ERC20: approve from the zero address");
170         require(spender != address(0), "ERC20: approve to the zero address");
171 
172         _allowances[owner][spender] = amount;
173         emit Approval(owner, spender, amount);
174     }
175 }
176 
177 contract Ownable is Context {
178     address private _owner;
179 
180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
181 
182     constructor () {
183         address msgSender = _msgSender();
184         _owner = msgSender;
185         emit OwnershipTransferred(address(0), msgSender);
186     }
187 
188     function owner() public view returns (address) {
189         return _owner;
190     }
191 
192     modifier onlyOwner() {
193         require(_owner == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196 
197     function renounceOwnership() external virtual onlyOwner {
198         emit OwnershipTransferred(_owner, address(0));
199         _owner = address(0);
200     }
201 
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         emit OwnershipTransferred(_owner, newOwner);
205         _owner = newOwner;
206     }
207 }
208 
209 interface IDexRouter {
210     function factory() external pure returns (address);
211     function WETH() external pure returns (address);
212 
213     function swapExactTokensForETHSupportingFeeOnTransferTokens(
214         uint amountIn,
215         uint amountOutMin,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external;
220 
221     function swapExactETHForTokensSupportingFeeOnTransferTokens(
222         uint amountOutMin,
223         address[] calldata path,
224         address to,
225         uint deadline
226     ) external payable;
227 
228     function addLiquidityETH(
229         address token,
230         uint256 amountTokenDesired,
231         uint256 amountTokenMin,
232         uint256 amountETHMin,
233         address to,
234         uint256 deadline
235     )
236         external
237         payable
238         returns (
239             uint256 amountToken,
240             uint256 amountETH,
241             uint256 liquidity
242         );
243 }
244 
245 interface IDexFactory {
246     function createPair(address tokenA, address tokenB)
247         external
248         returns (address pair);
249 }
250 
251 contract Kabosu is ERC20, Ownable {
252 
253     uint256 public maxBuyAmount;
254     uint256 public maxSellAmount;
255     uint256 public maxWalletAmount;
256 
257     IDexRouter public dexRouter;
258     address public lpPair;
259 
260     bool private swapping;
261     uint256 public swapTokensAtAmount;
262 
263     address operationsAddress;
264     address devAddress;
265 
266     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
267     uint256 public blockForPenaltyEnd;
268     mapping (address => bool) public boughtEarly;
269     uint256 public botsCaught;
270 
271     bool public limitsInEffect = true;
272     bool public tradingActive = false;
273     bool public swapEnabled = false;
274 
275      // Anti-bot and anti-whale mappings and variables
276     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
277     bool public transferDelayEnabled = true;
278 
279     uint256 public buyTotalFees;
280     uint256 public buyOperationsFee;
281     uint256 public buyLiquidityFee;
282     uint256 public buyDevFee;
283     uint256 public buyBurnFee;
284 
285     uint256 public sellTotalFees;
286     uint256 public sellOperationsFee;
287     uint256 public sellLiquidityFee;
288     uint256 public sellDevFee;
289     uint256 public sellBurnFee;
290 
291     uint256 public tokensForOperations;
292     uint256 public tokensForLiquidity;
293     uint256 public tokensForDev;
294     uint256 public tokensForBurn;
295 
296     /******************/
297 
298     // exlcude from fees and max transaction amount
299     mapping (address => bool) private _isExcludedFromFees;
300     mapping (address => bool) public _isExcludedMaxTransactionAmount;
301 
302     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
303     // could be subject to a maximum transfer amount
304     mapping (address => bool) public automatedMarketMakerPairs;
305 
306     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
307 
308     event EnabledTrading();
309 
310     event RemovedLimits();
311 
312     event ExcludeFromFees(address indexed account, bool isExcluded);
313 
314     event UpdatedMaxBuyAmount(uint256 newAmount);
315 
316     event UpdatedMaxSellAmount(uint256 newAmount);
317 
318     event UpdatedMaxWalletAmount(uint256 newAmount);
319 
320     event UpdatedOperationsAddress(address indexed newWallet);
321 
322     event MaxTransactionExclusion(address _address, bool excluded);
323 
324     event BuyBackTriggered(uint256 amount);
325 
326     event OwnerForcedSwapBack(uint256 timestamp);
327 
328     event CaughtEarlyBuyer(address sniper);
329 
330     event SwapAndLiquify(
331         uint256 tokensSwapped,
332         uint256 ethReceived,
333         uint256 tokensIntoLiquidity
334     );
335 
336     event TransferForeignToken(address token, uint256 amount);
337 
338     constructor() ERC20("Kabosu Inu", "Kabosu Inu") {
339 
340         address newOwner = msg.sender; // can leave alone if owner is deployer.
341 
342         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
343         dexRouter = _dexRouter;
344 
345         // create pair
346         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
347         _excludeFromMaxTransaction(address(lpPair), true);
348         _setAutomatedMarketMakerPair(address(lpPair), true);
349 
350         uint256 totalSupply = 1 * 1e12 * 1e18;
351 
352         maxBuyAmount = totalSupply * 1 / 100;
353         maxSellAmount = totalSupply * 1 / 100;
354         maxWalletAmount = totalSupply * 2 / 100;
355         swapTokensAtAmount = totalSupply * 5 / 10000;
356 
357         buyOperationsFee = 7;
358         buyLiquidityFee = 0;
359         buyDevFee = 3;
360         buyBurnFee = 0;
361         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
362 
363         sellOperationsFee = 10;
364         sellLiquidityFee = 0;
365         sellDevFee = 5;
366         sellBurnFee = 0;
367         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
368 
369         _excludeFromMaxTransaction(newOwner, true);
370         _excludeFromMaxTransaction(address(this), true);
371         _excludeFromMaxTransaction(address(0xdead), true);
372 
373         excludeFromFees(newOwner, true);
374         excludeFromFees(address(this), true);
375         excludeFromFees(address(0xdead), true);
376 
377         operationsAddress = address(newOwner);
378         devAddress = address(newOwner);
379 
380         _createInitialSupply(newOwner, totalSupply);
381         transferOwnership(newOwner);
382     }
383 
384     receive() external payable {}
385 
386     // only enable if no plan to airdrop
387 
388     function enableTrading(uint256 deadBlocks) external onlyOwner {
389         require(!tradingActive, "Cannot reenable trading");
390         tradingActive = true;
391         swapEnabled = true;
392         tradingActiveBlock = block.number;
393         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
394         emit EnabledTrading();
395     }
396 
397     // remove limits after token is stable
398     function removeLimits() external onlyOwner {
399         limitsInEffect = false;
400         transferDelayEnabled = false;
401         emit RemovedLimits();
402     }
403 
404     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
405         boughtEarly[wallet] = flag;
406     }
407 
408     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
409         for(uint256 i = 0; i < wallets.length; i++){
410             boughtEarly[wallets[i]] = flag;
411         }
412     }
413 
414     // disable Transfer delay - cannot be reenabled
415     function disableTransferDelay() external onlyOwner {
416         transferDelayEnabled = false;
417     }
418 
419     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
420         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
421         maxBuyAmount = newNum * (10**18);
422         emit UpdatedMaxBuyAmount(maxBuyAmount);
423     }
424 
425     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
426         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
427         maxSellAmount = newNum * (10**18);
428         emit UpdatedMaxSellAmount(maxSellAmount);
429     }
430 
431     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
432         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
433         maxWalletAmount = newNum * (10**18);
434         emit UpdatedMaxWalletAmount(maxWalletAmount);
435     }
436 
437     // change the minimum amount of tokens to sell from fees
438     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
439   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
440   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
441   	    swapTokensAtAmount = newAmount;
442   	}
443 
444     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
445         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
446         emit MaxTransactionExclusion(updAds, isExcluded);
447     }
448 
449     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
450         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
451         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
452         for(uint256 i = 0; i < wallets.length; i++){
453             address wallet = wallets[i];
454             uint256 amount = amountsInTokens[i];
455             super._transfer(msg.sender, wallet, amount);
456         }
457     }
458 
459     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
460         if(!isEx){
461             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
462         }
463         _isExcludedMaxTransactionAmount[updAds] = isEx;
464     }
465 
466     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
467         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
468 
469         _setAutomatedMarketMakerPair(pair, value);
470         emit SetAutomatedMarketMakerPair(pair, value);
471     }
472 
473     function _setAutomatedMarketMakerPair(address pair, bool value) private {
474         automatedMarketMakerPairs[pair] = value;
475 
476         _excludeFromMaxTransaction(pair, value);
477 
478         emit SetAutomatedMarketMakerPair(pair, value);
479     }
480 
481     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
482         buyOperationsFee = _operationsFee;
483         buyLiquidityFee = _liquidityFee;
484         buyDevFee = _DevFee;
485         buyBurnFee = _burnFee;
486         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
487         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
488     }
489 
490     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
491         sellOperationsFee = _operationsFee;
492         sellLiquidityFee = _liquidityFee;
493         sellDevFee = _DevFee;
494         sellBurnFee = _burnFee;
495         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
496         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
497     }
498 
499     function returnToNormalTax() external onlyOwner {
500         sellOperationsFee = 20;
501         sellLiquidityFee = 0;
502         sellDevFee = 0;
503         sellBurnFee = 0;
504         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
505         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
506 
507         buyOperationsFee = 20;
508         buyLiquidityFee = 0;
509         buyDevFee = 0;
510         buyBurnFee = 0;
511         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
512         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
513     }
514 
515     function excludeFromFees(address account, bool excluded) public onlyOwner {
516         _isExcludedFromFees[account] = excluded;
517         emit ExcludeFromFees(account, excluded);
518     }
519 
520     function _transfer(address from, address to, uint256 amount) internal override {
521 
522         require(from != address(0), "ERC20: transfer from the zero address");
523         require(to != address(0), "ERC20: transfer to the zero address");
524         require(amount > 0, "amount must be greater than 0");
525 
526         if(!tradingActive){
527             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
528         }
529 
530         if(blockForPenaltyEnd > 0){
531             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
532         }
533 
534         if(limitsInEffect){
535             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
536 
537                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
538                 if (transferDelayEnabled){
539                     if (to != address(dexRouter) && to != address(lpPair)){
540                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
541                         _holderLastTransferTimestamp[tx.origin] = block.number;
542                         _holderLastTransferTimestamp[to] = block.number;
543                     }
544                 }
545 
546                 //when buy
547                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
548                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
549                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
550                 }
551                 //when sell
552                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
553                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
554                 }
555                 else if (!_isExcludedMaxTransactionAmount[to]){
556                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
557                 }
558             }
559         }
560 
561         uint256 contractTokenBalance = balanceOf(address(this));
562 
563         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
564 
565         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
566             swapping = true;
567 
568             swapBack();
569 
570             swapping = false;
571         }
572 
573         bool takeFee = true;
574         // if any account belongs to _isExcludedFromFee account then remove the fee
575         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
576             takeFee = false;
577         }
578 
579         uint256 fees = 0;
580         // only take fees on buys/sells, do not take on wallet transfers
581         if(takeFee){
582             // bot/sniper penalty.
583             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
584 
585                 if(!boughtEarly[to]){
586                     boughtEarly[to] = true;
587                     botsCaught += 1;
588                     emit CaughtEarlyBuyer(to);
589                 }
590 
591                 fees = amount * 99 / 100;
592         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
593                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
594                 tokensForDev += fees * buyDevFee / buyTotalFees;
595                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
596             }
597 
598             // on sell
599             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
600                 fees = amount * sellTotalFees / 100;
601                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
602                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
603                 tokensForDev += fees * sellDevFee / sellTotalFees;
604                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
605             }
606 
607             // on buy
608             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
609         	    fees = amount * buyTotalFees / 100;
610         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
611                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
612                 tokensForDev += fees * buyDevFee / buyTotalFees;
613                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
614             }
615 
616             if(fees > 0){
617                 super._transfer(from, address(this), fees);
618             }
619 
620         	amount -= fees;
621         }
622 
623         super._transfer(from, to, amount);
624     }
625 
626     function earlyBuyPenaltyInEffect() public view returns (bool){
627         return block.number < blockForPenaltyEnd;
628     }
629 
630     function swapTokensForEth(uint256 tokenAmount) private {
631 
632         // generate the uniswap pair path of token -> weth
633         address[] memory path = new address[](2);
634         path[0] = address(this);
635         path[1] = dexRouter.WETH();
636 
637         _approve(address(this), address(dexRouter), tokenAmount);
638 
639         // make the swap
640         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
641             tokenAmount,
642             0, // accept any amount of ETH
643             path,
644             address(this),
645             block.timestamp
646         );
647     }
648 
649     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
650         // approve token transfer to cover all possible scenarios
651         _approve(address(this), address(dexRouter), tokenAmount);
652 
653         // add the liquidity
654         dexRouter.addLiquidityETH{value: ethAmount}(
655             address(this),
656             tokenAmount,
657             0, // slippage is unavoidable
658             0, // slippage is unavoidable
659             address(0xdead),
660             block.timestamp
661         );
662     }
663 
664     function swapBack() private {
665 
666         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
667             _burn(address(this), tokensForBurn);
668         }
669         tokensForBurn = 0;
670 
671         uint256 contractBalance = balanceOf(address(this));
672         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
673 
674         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
675 
676         if(contractBalance > swapTokensAtAmount * 20){
677             contractBalance = swapTokensAtAmount * 20;
678         }
679 
680         bool success;
681 
682         // Halve the amount of liquidity tokens
683         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
684 
685         swapTokensForEth(contractBalance - liquidityTokens);
686 
687         uint256 ethBalance = address(this).balance;
688         uint256 ethForLiquidity = ethBalance;
689 
690         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
691         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
692 
693         ethForLiquidity -= ethForOperations + ethForDev;
694 
695         tokensForLiquidity = 0;
696         tokensForOperations = 0;
697         tokensForDev = 0;
698         tokensForBurn = 0;
699 
700         if(liquidityTokens > 0 && ethForLiquidity > 0){
701             addLiquidity(liquidityTokens, ethForLiquidity);
702         }
703 
704         (success,) = address(devAddress).call{value: ethForDev}("");
705 
706         (success,) = address(operationsAddress).call{value: address(this).balance}("");
707     }
708 
709     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
710         require(_token != address(0), "_token address cannot be 0");
711         require(_token != address(this), "Can't withdraw native tokens");
712         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
713         _sent = IERC20(_token).transfer(_to, _contractBalance);
714         emit TransferForeignToken(_token, _contractBalance);
715     }
716 
717     // withdraw ETH if stuck or someone sends to the address
718     function withdrawStuckETH() external onlyOwner {
719         bool success;
720         (success,) = address(msg.sender).call{value: address(this).balance}("");
721     }
722 
723     function setOperationsAddress(address _operationsAddress) external onlyOwner {
724         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
725         operationsAddress = payable(_operationsAddress);
726     }
727 
728     function setDevAddress(address _devAddress) external onlyOwner {
729         require(_devAddress != address(0), "_devAddress address cannot be 0");
730         devAddress = payable(_devAddress);
731     }
732 
733     // force Swap back if slippage issues.
734     function forceSwapBack() external onlyOwner {
735         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
736         swapping = true;
737         swapBack();
738         swapping = false;
739         emit OwnerForcedSwapBack(block.timestamp);
740     }
741 
742     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
743     function buyBackTokens(uint256 amountInWei) external onlyOwner {
744         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
745 
746         address[] memory path = new address[](2);
747         path[0] = dexRouter.WETH();
748         path[1] = address(this);
749 
750         // make the swap
751         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
752             0, // accept any amount of Ethereum
753             path,
754             address(0xdead),
755             block.timestamp
756         );
757         emit BuyBackTriggered(amountInWei);
758     }
759 }