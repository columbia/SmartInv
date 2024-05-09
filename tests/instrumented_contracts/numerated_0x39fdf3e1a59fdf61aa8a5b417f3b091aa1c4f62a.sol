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
245 contract ATLAS is ERC20, Ownable {
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
301     event EnabledTrading();
302     event RemovedLimits();
303     event ExcludeFromFees(address indexed account, bool isExcluded);
304     event UpdatedMaxBuyAmount(uint256 newAmount);
305     event UpdatedMaxSellAmount(uint256 newAmount);
306     event UpdatedMaxWalletAmount(uint256 newAmount);
307     event UpdatedOperationsAddress(address indexed newWallet);
308     event MaxTransactionExclusion(address _address, bool excluded);
309     event BuyBackTriggered(uint256 amount);
310     event OwnerForcedSwapBack(uint256 timestamp);
311     event CaughtEarlyBuyer(address sniper);
312     event SwapAndLiquify(
313         uint256 tokensSwapped,
314         uint256 ethReceived,
315         uint256 tokensIntoLiquidity
316     );
317 
318     event TransferForeignToken(address token, uint256 amount);
319 
320     constructor() ERC20("ATLAS", "ATLAS") {
321 
322         address newOwner = msg.sender; // can leave alone if owner is deployer.
323 
324         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
325         dexRouter = _dexRouter;
326 
327         // create pair
328         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
329         _excludeFromMaxTransaction(address(lpPair), true);
330         _setAutomatedMarketMakerPair(address(lpPair), true);
331 
332         uint256 totalSupply = 1 * 1e12 * 1e18;
333 
334         maxBuyAmount = totalSupply * 1 / 100;
335         maxSellAmount = totalSupply * 1 / 100;
336         maxWalletAmount = totalSupply * 2 / 100;
337         swapTokensAtAmount = totalSupply * 5 / 10000;
338 
339         buyOperationsFee = 4;
340         buyLiquidityFee = 0;
341         buyDevFee = 0;
342         buyBurnFee = 0;
343         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
344 
345         sellOperationsFee = 4;
346         sellLiquidityFee = 0;
347         sellDevFee = 0;
348         sellBurnFee = 0;
349         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
350 
351         _excludeFromMaxTransaction(newOwner, true);
352         _excludeFromMaxTransaction(address(this), true);
353         _excludeFromMaxTransaction(address(0xdead), true);
354 
355         excludeFromFees(newOwner, true);
356         excludeFromFees(address(this), true);
357         excludeFromFees(address(0xdead), true);
358 
359         operationsAddress = address(newOwner);
360         devAddress = address(newOwner);
361 
362         _createInitialSupply(newOwner, totalSupply);
363         transferOwnership(newOwner);
364     }
365 
366     receive() external payable {}
367 
368 
369     function enableTrading(uint256 deadBlocks) external onlyOwner {
370         require(!tradingActive, "Cannot reenable trading");
371         tradingActive = true;
372         swapEnabled = true;
373         tradingActiveBlock = block.number;
374         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
375         emit EnabledTrading();
376     }
377 
378 
379     function removeLimits() external onlyOwner {
380         limitsInEffect = false;
381         transferDelayEnabled = false;
382         emit RemovedLimits();
383     }
384 
385     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
386         boughtEarly[wallet] = flag;
387     }
388 
389     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
390         for(uint256 i = 0; i < wallets.length; i++){
391             boughtEarly[wallets[i]] = flag;
392         }
393     }
394 
395     // disable Transfer delay - cannot be reenabled
396     function disableTransferDelay() external onlyOwner {
397         transferDelayEnabled = false;
398     }
399 
400     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
401         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
402         maxBuyAmount = newNum * (10**18);
403         emit UpdatedMaxBuyAmount(maxBuyAmount);
404     }
405 
406     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
407         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
408         maxSellAmount = newNum * (10**18);
409         emit UpdatedMaxSellAmount(maxSellAmount);
410     }
411 
412     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
413         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
414         maxWalletAmount = newNum * (10**18);
415         emit UpdatedMaxWalletAmount(maxWalletAmount);
416     }
417 
418     // change the minimum amount of tokens to sell from fees
419     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
420   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
421   	    require(newAmount <= totalSupply() * 1 / 5000, "Swap amount cannot be higher than 0.5% total supply.");
422   	    swapTokensAtAmount = newAmount;
423   	}
424 
425     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
426         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
427         emit MaxTransactionExclusion(updAds, isExcluded);
428     }
429 
430     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
431         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
432         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
433         for(uint256 i = 0; i < wallets.length; i++){
434             address wallet = wallets[i];
435             uint256 amount = amountsInTokens[i];
436             super._transfer(msg.sender, wallet, amount);
437         }
438     }
439 
440     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
441         if(!isEx){
442             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
443         }
444         _isExcludedMaxTransactionAmount[updAds] = isEx;
445     }
446 
447     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
448         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
449 
450         _setAutomatedMarketMakerPair(pair, value);
451         emit SetAutomatedMarketMakerPair(pair, value);
452     }
453 
454     function _setAutomatedMarketMakerPair(address pair, bool value) private {
455         automatedMarketMakerPairs[pair] = value;
456 
457         _excludeFromMaxTransaction(pair, value);
458 
459         emit SetAutomatedMarketMakerPair(pair, value);
460     }
461 
462     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
463         buyOperationsFee = _operationsFee;
464         buyLiquidityFee = _liquidityFee;
465         buyDevFee = _DevFee;
466         buyBurnFee = _burnFee;
467         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
468         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
469     }
470 
471     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
472         sellOperationsFee = _operationsFee;
473         sellLiquidityFee = _liquidityFee;
474         sellDevFee = _DevFee;
475         sellBurnFee = _burnFee;
476         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
477         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
478     }
479 
480     function returnToNormalTax() external onlyOwner {
481         sellOperationsFee = 20;
482         sellLiquidityFee = 0;
483         sellDevFee = 0;
484         sellBurnFee = 0;
485         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
486         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
487 
488         buyOperationsFee = 15;
489         buyLiquidityFee = 0;
490         buyDevFee = 0;
491         buyBurnFee = 0;
492         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
493         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
494     }
495 
496     function excludeFromFees(address account, bool excluded) public onlyOwner {
497         _isExcludedFromFees[account] = excluded;
498         emit ExcludeFromFees(account, excluded);
499     }
500 
501     function _transfer(address from, address to, uint256 amount) internal override {
502 
503         require(from != address(0), "ERC20: transfer from the zero address");
504         require(to != address(0), "ERC20: transfer to the zero address");
505         require(amount > 0, "amount must be greater than 0");
506 
507         if(!tradingActive){
508             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
509         }
510 
511         if(blockForPenaltyEnd > 0){
512             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
513         }
514 
515         if(limitsInEffect){
516             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
517 
518                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
519                 if (transferDelayEnabled){
520                     if (to != address(dexRouter) && to != address(lpPair)){
521                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
522                         _holderLastTransferTimestamp[tx.origin] = block.number;
523                         _holderLastTransferTimestamp[to] = block.number;
524                     }
525                 }
526 
527                 //when buy
528                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
529                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
530                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
531                 }
532                 //when sell
533                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
534                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
535                 }
536                 else if (!_isExcludedMaxTransactionAmount[to]){
537                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
538                 }
539             }
540         }
541 
542         uint256 contractTokenBalance = balanceOf(address(this));
543 
544         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
545 
546         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
547             swapping = true;
548 
549             swapBack();
550 
551             swapping = false;
552         }
553 
554         bool takeFee = true;
555         // if any account belongs to _isExcludedFromFee account then remove the fee
556         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
557             takeFee = false;
558         }
559 
560         uint256 fees = 0;
561         // only take fees on buys/sells, do not take on wallet transfers
562         if(takeFee){
563             // bot/sniper penalty.
564             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
565 
566                 if(!boughtEarly[to]){
567                     boughtEarly[to] = true;
568                     botsCaught += 1;
569                     emit CaughtEarlyBuyer(to);
570                 }
571 
572                 fees = amount * 99 / 100;
573         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
574                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
575                 tokensForDev += fees * buyDevFee / buyTotalFees;
576                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
577             }
578 
579             // on sell
580             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
581                 fees = amount * sellTotalFees / 100;
582                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
583                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
584                 tokensForDev += fees * sellDevFee / sellTotalFees;
585                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
586             }
587 
588             // on buy
589             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
590         	    fees = amount * buyTotalFees / 100;
591         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
592                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
593                 tokensForDev += fees * buyDevFee / buyTotalFees;
594                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
595             }
596 
597             if(fees > 0){
598                 super._transfer(from, address(this), fees);
599             }
600 
601         	amount -= fees;
602         }
603 
604         super._transfer(from, to, amount);
605     }
606 
607     function earlyBuyPenaltyInEffect() public view returns (bool){
608         return block.number < blockForPenaltyEnd;
609     }
610 
611     function swapTokensForEth(uint256 tokenAmount) private {
612 
613         // generate the uniswap pair path of token -> weth
614         address[] memory path = new address[](2);
615         path[0] = address(this);
616         path[1] = dexRouter.WETH();
617 
618         _approve(address(this), address(dexRouter), tokenAmount);
619 
620         // make the swap
621         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
622             tokenAmount,
623             0, // accept any amount of ETH
624             path,
625             address(this),
626             block.timestamp
627         );
628     }
629 
630     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
631         // approve token transfer to cover all possible scenarios
632         _approve(address(this), address(dexRouter), tokenAmount);
633 
634         // add the liquidity
635         dexRouter.addLiquidityETH{value: ethAmount}(
636             address(this),
637             tokenAmount,
638             0, // slippage is unavoidable
639             0, // slippage is unavoidable
640             address(0xdead),
641             block.timestamp
642         );
643     }
644 
645     function swapBack() private {
646 
647         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
648             _burn(address(this), tokensForBurn);
649         }
650         tokensForBurn = 0;
651 
652         uint256 contractBalance = balanceOf(address(this));
653         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
654 
655         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
656 
657         if(contractBalance > swapTokensAtAmount * 20){
658             contractBalance = swapTokensAtAmount * 20;
659         }
660 
661         bool success;
662 
663         // Halve the amount of liquidity tokens
664         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
665 
666         swapTokensForEth(contractBalance - liquidityTokens);
667 
668         uint256 ethBalance = address(this).balance;
669         uint256 ethForLiquidity = ethBalance;
670 
671         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
672         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
673 
674         ethForLiquidity -= ethForOperations + ethForDev;
675 
676         tokensForLiquidity = 0;
677         tokensForOperations = 0;
678         tokensForDev = 0;
679         tokensForBurn = 0;
680 
681         if(liquidityTokens > 0 && ethForLiquidity > 0){
682             addLiquidity(liquidityTokens, ethForLiquidity);
683         }
684 
685         (success,) = address(devAddress).call{value: ethForDev}("");
686 
687         (success,) = address(operationsAddress).call{value: address(this).balance}("");
688     }
689 
690     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
691         require(_token != address(0), "_token address cannot be 0");
692         require(_token != address(this), "Can't withdraw native tokens");
693         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
694         _sent = IERC20(_token).transfer(_to, _contractBalance);
695         emit TransferForeignToken(_token, _contractBalance);
696     }
697 
698     // withdraw ETH if stuck or someone sends to the address
699     function withdrawStuckETH() external onlyOwner {
700         bool success;
701         (success,) = address(msg.sender).call{value: address(this).balance}("");
702     }
703 
704     function setOperationsAddress(address _operationsAddress) external onlyOwner {
705         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
706         operationsAddress = payable(_operationsAddress);
707     }
708 
709     function setDevAddress(address _devAddress) external onlyOwner {
710         require(_devAddress != address(0), "_devAddress address cannot be 0");
711         devAddress = payable(_devAddress);
712     }
713 
714     // force Swap back if slippage issues.
715     function forceSwapBack() external onlyOwner {
716         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
717         swapping = true;
718         swapBack();
719         swapping = false;
720         emit OwnerForcedSwapBack(block.timestamp);
721     }
722 
723     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
724     function buyBackTokens(uint256 amountInWei) external onlyOwner {
725         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
726 
727         address[] memory path = new address[](2);
728         path[0] = dexRouter.WETH();
729         path[1] = address(this);
730 
731         // make the swap
732         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
733             0, // accept any amount of Ethereum
734             path,
735             address(0xdead),
736             block.timestamp
737         );
738         emit BuyBackTriggered(amountInWei);
739     }
740 }