1 //.      P̶u̶r̶e̶ m̶a̶d̶n̶e̶s̶s̶ a̶l̶i̶v̶e̶ , a̶g̶a̶i̶n̶.̶
2 
3 //.      https://ktu-lu.com/
4 
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.15;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22 
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35    
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 interface IERC20Metadata is IERC20 {
40     
41     function name() external view returns (string memory);
42     function symbol() external view returns (string memory);
43     function decimals() external view returns (uint8);
44 }
45 
46 contract ERC20 is Context, IERC20, IERC20Metadata {
47     mapping(address => uint256) private _balances;
48     mapping(address => mapping(address => uint256)) private _allowances;
49 
50     uint256 private _totalSupply;
51     string private _name;
52     string private _symbol;
53 
54     constructor(string memory name_, string memory symbol_) {
55         _name = name_;
56         _symbol = symbol_;
57     }
58 
59     function name() public view virtual override returns (string memory) {
60         return _name;
61     }
62 
63     function symbol() public view virtual override returns (string memory) {
64         return _symbol;
65     }
66 
67     function decimals() public view virtual override returns (uint8) {
68         return 18;
69     }
70 
71     function totalSupply() public view virtual override returns (uint256) {
72         return _totalSupply;
73     }
74 
75     function balanceOf(address account) public view virtual override returns (uint256) {
76         return _balances[account];
77     }
78 
79     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
80         _transfer(_msgSender(), recipient, amount);
81         return true;
82     }
83 
84     function allowance(address owner, address spender) public view virtual override returns (uint256) {
85         return _allowances[owner][spender];
86     }
87 
88     function approve(address spender, uint256 amount) public virtual override returns (bool) {
89         _approve(_msgSender(), spender, amount);
90         return true;
91     }
92 
93     function transferFrom(
94         address sender,
95         address recipient,
96         uint256 amount
97     ) public virtual override returns (bool) {
98         _transfer(sender, recipient, amount);
99 
100         uint256 currentAllowance = _allowances[sender][_msgSender()];
101         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
102         unchecked {
103             _approve(sender, _msgSender(), currentAllowance - amount);
104         }
105 
106         return true;
107     }
108 
109     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
110         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
111         return true;
112     }
113 
114     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
115         uint256 currentAllowance = _allowances[_msgSender()][spender];
116         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
117         unchecked {
118             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
119         }
120 
121         return true;
122     }
123 
124     function _transfer(
125         address sender,
126         address recipient,
127         uint256 amount
128     ) internal virtual {
129         require(sender != address(0), "ERC20: transfer from the zero address");
130         require(recipient != address(0), "ERC20: transfer to the zero address");
131 
132         uint256 senderBalance = _balances[sender];
133         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
134         unchecked {
135             _balances[sender] = senderBalance - amount;
136         }
137         _balances[recipient] += amount;
138 
139         emit Transfer(sender, recipient, amount);
140     }
141 
142     function _createInitialSupply(address account, uint256 amount) internal virtual {
143         require(account != address(0), "ERC20: mint to the zero address");
144 
145         _totalSupply += amount;
146         _balances[account] += amount;
147         emit Transfer(address(0), account, amount);
148     }
149 
150     function _burn(address account, uint256 amount) internal virtual {
151         require(account != address(0), "ERC20: burn from the zero address");
152         uint256 accountBalance = _balances[account];
153         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
154         unchecked {
155             _balances[account] = accountBalance - amount;
156             // Overflow not possible: amount <= accountBalance <= totalSupply.
157             _totalSupply -= amount;
158         }
159 
160         emit Transfer(account, address(0), amount);
161     }
162 
163     function _approve(
164         address owner,
165         address spender,
166         uint256 amount
167     ) internal virtual {
168         require(owner != address(0), "ERC20: approve from the zero address");
169         require(spender != address(0), "ERC20: approve to the zero address");
170 
171         _allowances[owner][spender] = amount;
172         emit Approval(owner, spender, amount);
173     }
174 }
175 
176 contract Ownable is Context {
177     address private _owner;
178 
179     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
180 
181     constructor () {
182         address msgSender = _msgSender();
183         _owner = msgSender;
184         emit OwnershipTransferred(address(0), msgSender);
185     }
186 
187     function owner() public view returns (address) {
188         return _owner;
189     }
190 
191     modifier onlyOwner() {
192         require(_owner == _msgSender(), "Ownable: caller is not the owner");
193         _;
194     }
195 
196     function renounceOwnership() external virtual onlyOwner {
197         emit OwnershipTransferred(_owner, address(0));
198         _owner = address(0);
199     }
200 
201     function transferOwnership(address newOwner) public virtual onlyOwner {
202         require(newOwner != address(0), "Ownable: new owner is the zero address");
203         emit OwnershipTransferred(_owner, newOwner);
204         _owner = newOwner;
205     }
206 }
207 
208 interface IDexRouter {
209     function factory() external pure returns (address);
210     function WETH() external pure returns (address);
211 
212     function swapExactTokensForETHSupportingFeeOnTransferTokens(
213         uint amountIn,
214         uint amountOutMin,
215         address[] calldata path,
216         address to,
217         uint deadline
218     ) external;
219 
220     function swapExactETHForTokensSupportingFeeOnTransferTokens(
221         uint amountOutMin,
222         address[] calldata path,
223         address to,
224         uint deadline
225     ) external payable;
226 
227     function addLiquidityETH(
228         address token,
229         uint256 amountTokenDesired,
230         uint256 amountTokenMin,
231         uint256 amountETHMin,
232         address to,
233         uint256 deadline
234     )
235         external
236         payable
237         returns (
238             uint256 amountToken,
239             uint256 amountETH,
240             uint256 liquidity
241         );
242 }
243 
244 interface IDexFactory {
245     function createPair(address tokenA, address tokenB)
246         external
247         returns (address pair);
248 }
249 
250 contract ktulu is ERC20, Ownable {
251 
252     uint256 public maxBuyAmount;
253     uint256 public maxSellAmount;
254     uint256 public maxWalletAmount;
255 
256     IDexRouter public dexRouter;
257     address public lpPair;
258 
259     bool private swapping;
260     uint256 public swapTokensAtAmount;
261 
262     address operationsAddress;
263     address devAddress;
264 
265     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
266     uint256 public blockForPenaltyEnd;
267     mapping (address => bool) public boughtEarly;
268     uint256 public botsCaught;
269 
270     bool public limitsInEffect = true;
271     bool public tradingActive = false;
272     bool public swapEnabled = false;
273 
274      // Anti-bot and anti-whale mappings and variables
275     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
276     bool public transferDelayEnabled = true;
277 
278     uint256 public buyTotalFees;
279     uint256 public buyOperationsFee;
280     uint256 public buyLiquidityFee;
281     uint256 public buyDevFee;
282     uint256 public buyBurnFee;
283 
284     uint256 public sellTotalFees;
285     uint256 public sellOperationsFee;
286     uint256 public sellLiquidityFee;
287     uint256 public sellDevFee;
288     uint256 public sellBurnFee;
289 
290     uint256 public tokensForOperations;
291     uint256 public tokensForLiquidity;
292     uint256 public tokensForDev;
293     uint256 public tokensForBurn;
294 
295     /******************/
296 
297     // exlcude from fees and max transaction amount
298     mapping (address => bool) private _isExcludedFromFees;
299     mapping (address => bool) public _isExcludedMaxTransactionAmount;
300 
301     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
302     // could be subject to a maximum transfer amount
303     mapping (address => bool) public automatedMarketMakerPairs;
304 
305     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
306     event EnabledTrading();
307     event RemovedLimits();
308     event ExcludeFromFees(address indexed account, bool isExcluded);
309     event UpdatedMaxBuyAmount(uint256 newAmount);
310     event UpdatedMaxSellAmount(uint256 newAmount);
311     event UpdatedMaxWalletAmount(uint256 newAmount);
312     event UpdatedOperationsAddress(address indexed newWallet);
313     event MaxTransactionExclusion(address _address, bool excluded);
314     event BuyBackTriggered(uint256 amount);
315     event OwnerForcedSwapBack(uint256 timestamp);
316     event CaughtEarlyBuyer(address sniper);
317     event SwapAndLiquify(
318         uint256 tokensSwapped,
319         uint256 ethReceived,
320         uint256 tokensIntoLiquidity
321     );
322 
323     event TransferForeignToken(address token, uint256 amount);
324 
325     constructor() ERC20("KTULU", "$KTL") {
326 
327         address newOwner = msg.sender; // can leave alone if owner is deployer.
328 
329         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
330         dexRouter = _dexRouter;
331 
332         // create pair
333         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
334         _excludeFromMaxTransaction(address(lpPair), true);
335         _setAutomatedMarketMakerPair(address(lpPair), true);
336 
337         uint256 totalSupply = 1 * 1e12 * 1e18;
338 
339         maxBuyAmount = totalSupply * 1 / 100;
340         maxSellAmount = totalSupply * 1 / 100;
341         maxWalletAmount = totalSupply * 1 / 100;
342         swapTokensAtAmount = totalSupply * 5 / 10000;
343 
344         buyOperationsFee = 2;
345         buyLiquidityFee = 0;
346         buyDevFee = 0;
347         buyBurnFee = 0;
348         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
349 
350         sellOperationsFee = 2;
351         sellLiquidityFee = 0;
352         sellDevFee = 0;
353         sellBurnFee = 0;
354         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
355 
356         _excludeFromMaxTransaction(newOwner, true);
357         _excludeFromMaxTransaction(address(this), true);
358         _excludeFromMaxTransaction(address(0xdead), true);
359 
360         excludeFromFees(newOwner, true);
361         excludeFromFees(address(this), true);
362         excludeFromFees(address(0xdead), true);
363 
364         operationsAddress = address(newOwner);
365         devAddress = address(newOwner);
366 
367         _createInitialSupply(newOwner, totalSupply);
368         transferOwnership(newOwner);
369     }
370 
371     receive() external payable {}
372 
373 
374     function enableTrading(uint256 deadBlocks) external onlyOwner {
375         require(!tradingActive, "Cannot reenable trading");
376         tradingActive = true;
377         swapEnabled = true;
378         tradingActiveBlock = block.number;
379         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
380         emit EnabledTrading();
381     }
382 
383 
384     function removeLimits() external onlyOwner {
385         limitsInEffect = false;
386         transferDelayEnabled = false;
387         emit RemovedLimits();
388     }
389 
390     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
391         boughtEarly[wallet] = flag;
392     }
393 
394     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
395         for(uint256 i = 0; i < wallets.length; i++){
396             boughtEarly[wallets[i]] = flag;
397         }
398     }
399 
400     // disable Transfer delay - cannot be reenabled
401     function disableTransferDelay() external onlyOwner {
402         transferDelayEnabled = false;
403     }
404 
405     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
406         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
407         maxBuyAmount = newNum * (10**18);
408         emit UpdatedMaxBuyAmount(maxBuyAmount);
409     }
410 
411     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
412         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
413         maxSellAmount = newNum * (10**18);
414         emit UpdatedMaxSellAmount(maxSellAmount);
415     }
416 
417     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
418         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
419         maxWalletAmount = newNum * (10**18);
420         emit UpdatedMaxWalletAmount(maxWalletAmount);
421     }
422 
423     // change the minimum amount of tokens to sell from fees
424     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
425   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
426   	    require(newAmount <= totalSupply() * 1 / 5000, "Swap amount cannot be higher than 0.5% total supply.");
427   	    swapTokensAtAmount = newAmount;
428   	}
429 
430     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
431         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
432         emit MaxTransactionExclusion(updAds, isExcluded);
433     }
434 
435     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
436         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
437         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
438         for(uint256 i = 0; i < wallets.length; i++){
439             address wallet = wallets[i];
440             uint256 amount = amountsInTokens[i];
441             super._transfer(msg.sender, wallet, amount);
442         }
443     }
444 
445     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
446         if(!isEx){
447             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
448         }
449         _isExcludedMaxTransactionAmount[updAds] = isEx;
450     }
451 
452     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
453         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
454 
455         _setAutomatedMarketMakerPair(pair, value);
456         emit SetAutomatedMarketMakerPair(pair, value);
457     }
458 
459     function _setAutomatedMarketMakerPair(address pair, bool value) private {
460         automatedMarketMakerPairs[pair] = value;
461 
462         _excludeFromMaxTransaction(pair, value);
463 
464         emit SetAutomatedMarketMakerPair(pair, value);
465     }
466 
467     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
468         buyOperationsFee = _operationsFee;
469         buyLiquidityFee = _liquidityFee;
470         buyDevFee = _DevFee;
471         buyBurnFee = _burnFee;
472         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
473         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
474     }
475 
476     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
477         sellOperationsFee = _operationsFee;
478         sellLiquidityFee = _liquidityFee;
479         sellDevFee = _DevFee;
480         sellBurnFee = _burnFee;
481         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
482         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
483     }
484 
485     function returnToNormalTax() external onlyOwner {
486         sellOperationsFee = 25;
487         sellLiquidityFee = 0;
488         sellDevFee = 0;
489         sellBurnFee = 0;
490         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
491         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
492 
493         buyOperationsFee = 25;
494         buyLiquidityFee = 0;
495         buyDevFee = 0;
496         buyBurnFee = 0;
497         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
498         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
499     }
500 
501     function excludeFromFees(address account, bool excluded) public onlyOwner {
502         _isExcludedFromFees[account] = excluded;
503         emit ExcludeFromFees(account, excluded);
504     }
505 
506     function _transfer(address from, address to, uint256 amount) internal override {
507 
508         require(from != address(0), "ERC20: transfer from the zero address");
509         require(to != address(0), "ERC20: transfer to the zero address");
510         require(amount > 0, "amount must be greater than 0");
511 
512         if(!tradingActive){
513             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
514         }
515 
516         if(blockForPenaltyEnd > 0){
517             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
518         }
519 
520         if(limitsInEffect){
521             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
522 
523                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
524                 if (transferDelayEnabled){
525                     if (to != address(dexRouter) && to != address(lpPair)){
526                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
527                         _holderLastTransferTimestamp[tx.origin] = block.number;
528                         _holderLastTransferTimestamp[to] = block.number;
529                     }
530                 }
531 
532                 //when buy
533                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
534                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
535                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
536                 }
537                 //when sell
538                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
539                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
540                 }
541                 else if (!_isExcludedMaxTransactionAmount[to]){
542                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
543                 }
544             }
545         }
546 
547         uint256 contractTokenBalance = balanceOf(address(this));
548 
549         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
550 
551         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
552             swapping = true;
553 
554             swapBack();
555 
556             swapping = false;
557         }
558 
559         bool takeFee = true;
560         // if any account belongs to _isExcludedFromFee account then remove the fee
561         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
562             takeFee = false;
563         }
564 
565         uint256 fees = 0;
566         // only take fees on buys/sells, do not take on wallet transfers
567         if(takeFee){
568             // bot/sniper penalty.
569             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
570 
571                 if(!boughtEarly[to]){
572                     boughtEarly[to] = true;
573                     botsCaught += 1;
574                     emit CaughtEarlyBuyer(to);
575                 }
576 
577                 fees = amount * 99 / 100;
578         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
579                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
580                 tokensForDev += fees * buyDevFee / buyTotalFees;
581                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
582             }
583 
584             // on sell
585             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
586                 fees = amount * sellTotalFees / 100;
587                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
588                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
589                 tokensForDev += fees * sellDevFee / sellTotalFees;
590                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
591             }
592 
593             // on buy
594             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
595         	    fees = amount * buyTotalFees / 100;
596         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
597                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
598                 tokensForDev += fees * buyDevFee / buyTotalFees;
599                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
600             }
601 
602             if(fees > 0){
603                 super._transfer(from, address(this), fees);
604             }
605 
606         	amount -= fees;
607         }
608 
609         super._transfer(from, to, amount);
610     }
611 
612     function earlyBuyPenaltyInEffect() public view returns (bool){
613         return block.number < blockForPenaltyEnd;
614     }
615 
616     function swapTokensForEth(uint256 tokenAmount) private {
617 
618         // generate the uniswap pair path of token -> weth
619         address[] memory path = new address[](2);
620         path[0] = address(this);
621         path[1] = dexRouter.WETH();
622 
623         _approve(address(this), address(dexRouter), tokenAmount);
624 
625         // make the swap
626         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
627             tokenAmount,
628             0, // accept any amount of ETH
629             path,
630             address(this),
631             block.timestamp
632         );
633     }
634 
635     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
636         // approve token transfer to cover all possible scenarios
637         _approve(address(this), address(dexRouter), tokenAmount);
638 
639         // add the liquidity
640         dexRouter.addLiquidityETH{value: ethAmount}(
641             address(this),
642             tokenAmount,
643             0, // slippage is unavoidable
644             0, // slippage is unavoidable
645             address(0xdead),
646             block.timestamp
647         );
648     }
649 
650     function swapBack() private {
651 
652         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
653             _burn(address(this), tokensForBurn);
654         }
655         tokensForBurn = 0;
656 
657         uint256 contractBalance = balanceOf(address(this));
658         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
659 
660         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
661 
662         if(contractBalance > swapTokensAtAmount * 20){
663             contractBalance = swapTokensAtAmount * 20;
664         }
665 
666         bool success;
667 
668         // Halve the amount of liquidity tokens
669         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
670 
671         swapTokensForEth(contractBalance - liquidityTokens);
672 
673         uint256 ethBalance = address(this).balance;
674         uint256 ethForLiquidity = ethBalance;
675 
676         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
677         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
678 
679         ethForLiquidity -= ethForOperations + ethForDev;
680 
681         tokensForLiquidity = 0;
682         tokensForOperations = 0;
683         tokensForDev = 0;
684         tokensForBurn = 0;
685 
686         if(liquidityTokens > 0 && ethForLiquidity > 0){
687             addLiquidity(liquidityTokens, ethForLiquidity);
688         }
689 
690         (success,) = address(devAddress).call{value: ethForDev}("");
691 
692         (success,) = address(operationsAddress).call{value: address(this).balance}("");
693     }
694 
695     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
696         require(_token != address(0), "_token address cannot be 0");
697         require(_token != address(this), "Can't withdraw native tokens");
698         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
699         _sent = IERC20(_token).transfer(_to, _contractBalance);
700         emit TransferForeignToken(_token, _contractBalance);
701     }
702 
703     // withdraw ETH if stuck or someone sends to the address
704     function withdrawStuckETH() external onlyOwner {
705         bool success;
706         (success,) = address(msg.sender).call{value: address(this).balance}("");
707     }
708 
709     function setOperationsAddress(address _operationsAddress) external onlyOwner {
710         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
711         operationsAddress = payable(_operationsAddress);
712     }
713 
714     function setDevAddress(address _devAddress) external onlyOwner {
715         require(_devAddress != address(0), "_devAddress address cannot be 0");
716         devAddress = payable(_devAddress);
717     }
718 
719     // force Swap back if slippage issues.
720     function forceSwapBack() external onlyOwner {
721         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
722         swapping = true;
723         swapBack();
724         swapping = false;
725         emit OwnerForcedSwapBack(block.timestamp);
726     }
727 
728     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
729     function buyBackTokens(uint256 amountInWei) external onlyOwner {
730         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
731 
732         address[] memory path = new address[](2);
733         path[0] = dexRouter.WETH();
734         path[1] = address(this);
735 
736         // make the swap
737         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
738             0, // accept any amount of Ethereum
739             path,
740             address(0xdead),
741             block.timestamp
742         );
743         emit BuyBackTriggered(amountInWei);
744     }
745 }