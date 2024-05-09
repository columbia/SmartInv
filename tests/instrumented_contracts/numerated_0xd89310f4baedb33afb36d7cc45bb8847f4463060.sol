1 // SPDX-License-Identifier: AGPL-3.0-only
2 pragma solidity 0.8.15;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16 
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29    
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 interface IERC20Metadata is IERC20 {
34     
35     function name() external view returns (string memory);
36     function symbol() external view returns (string memory);
37     function decimals() external view returns (uint8);
38 }
39 
40 contract ERC20 is Context, IERC20, IERC20Metadata {
41     mapping(address => uint256) private _balances;
42     mapping(address => mapping(address => uint256)) private _allowances;
43 
44     uint256 private _totalSupply;
45     string private _name;
46     string private _symbol;
47 
48     constructor(string memory name_, string memory symbol_) {
49         _name = name_;
50         _symbol = symbol_;
51     }
52 
53     function name() public view virtual override returns (string memory) {
54         return _name;
55     }
56 
57     function symbol() public view virtual override returns (string memory) {
58         return _symbol;
59     }
60 
61     function decimals() public view virtual override returns (uint8) {
62         return 18;
63     }
64 
65     function totalSupply() public view virtual override returns (uint256) {
66         return _totalSupply;
67     }
68 
69     function balanceOf(address account) public view virtual override returns (uint256) {
70         return _balances[account];
71     }
72 
73     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
74         _transfer(_msgSender(), recipient, amount);
75         return true;
76     }
77 
78     function allowance(address owner, address spender) public view virtual override returns (uint256) {
79         return _allowances[owner][spender];
80     }
81 
82     function approve(address spender, uint256 amount) public virtual override returns (bool) {
83         _approve(_msgSender(), spender, amount);
84         return true;
85     }
86 
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) public virtual override returns (bool) {
92         _transfer(sender, recipient, amount);
93 
94         uint256 currentAllowance = _allowances[sender][_msgSender()];
95         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
96         unchecked {
97             _approve(sender, _msgSender(), currentAllowance - amount);
98         }
99 
100         return true;
101     }
102 
103     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
104         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
105         return true;
106     }
107 
108     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
109         uint256 currentAllowance = _allowances[_msgSender()][spender];
110         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
111         unchecked {
112             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
113         }
114 
115         return true;
116     }
117 
118     function _transfer(
119         address sender,
120         address recipient,
121         uint256 amount
122     ) internal virtual {
123         require(sender != address(0), "ERC20: transfer from the zero address");
124         require(recipient != address(0), "ERC20: transfer to the zero address");
125 
126         uint256 senderBalance = _balances[sender];
127         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
128         unchecked {
129             _balances[sender] = senderBalance - amount;
130         }
131         _balances[recipient] += amount;
132 
133         emit Transfer(sender, recipient, amount);
134     }
135 
136     function _createInitialSupply(address account, uint256 amount) internal virtual {
137         require(account != address(0), "ERC20: mint to the zero address");
138 
139         _totalSupply += amount;
140         _balances[account] += amount;
141         emit Transfer(address(0), account, amount);
142     }
143 
144     function _burn(address account, uint256 amount) internal virtual {
145         require(account != address(0), "ERC20: burn from the zero address");
146         uint256 accountBalance = _balances[account];
147         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
148         unchecked {
149             _balances[account] = accountBalance - amount;
150             // Overflow not possible: amount <= accountBalance <= totalSupply.
151             _totalSupply -= amount;
152         }
153 
154         emit Transfer(account, address(0), amount);
155     }
156 
157     function _approve(
158         address owner,
159         address spender,
160         uint256 amount
161     ) internal virtual {
162         require(owner != address(0), "ERC20: approve from the zero address");
163         require(spender != address(0), "ERC20: approve to the zero address");
164 
165         _allowances[owner][spender] = amount;
166         emit Approval(owner, spender, amount);
167     }
168 }
169 
170 contract Ownable is Context {
171     address private _owner;
172 
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     constructor () {
176         address msgSender = _msgSender();
177         _owner = msgSender;
178         emit OwnershipTransferred(address(0), msgSender);
179     }
180 
181     function owner() public view returns (address) {
182         return _owner;
183     }
184 
185     modifier onlyOwner() {
186         require(_owner == _msgSender(), "Ownable: caller is not the owner");
187         _;
188     }
189 
190     function renounceOwnership() external virtual onlyOwner {
191         emit OwnershipTransferred(_owner, address(0));
192         _owner = address(0);
193     }
194 
195     function transferOwnership(address newOwner) public virtual onlyOwner {
196         require(newOwner != address(0), "Ownable: new owner is the zero address");
197         emit OwnershipTransferred(_owner, newOwner);
198         _owner = newOwner;
199     }
200 }
201 
202 interface IDexRouter {
203     function factory() external pure returns (address);
204     function WETH() external pure returns (address);
205 
206     function swapExactTokensForETHSupportingFeeOnTransferTokens(
207         uint amountIn,
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external;
213 
214     function swapExactETHForTokensSupportingFeeOnTransferTokens(
215         uint amountOutMin,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external payable;
220 
221     function addLiquidityETH(
222         address token,
223         uint256 amountTokenDesired,
224         uint256 amountTokenMin,
225         uint256 amountETHMin,
226         address to,
227         uint256 deadline
228     )
229         external
230         payable
231         returns (
232             uint256 amountToken,
233             uint256 amountETH,
234             uint256 liquidity
235         );
236 }
237 
238 interface IDexFactory {
239     function createPair(address tokenA, address tokenB)
240         external
241         returns (address pair);
242 }
243 
244 contract MEMEX is ERC20, Ownable {
245 
246     uint256 public maxBuyAmount;
247     uint256 public maxSellAmount;
248     uint256 public maxWalletAmount;
249 
250     IDexRouter public dexRouter;
251     address public lpPair;
252 
253     bool private swapping;
254     uint256 public swapTokensAtAmount;
255 
256     address marketingAddress;
257     address devAddress;
258 
259     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
260     uint256 public blockForPenaltyEnd = 0;
261     mapping (address => bool) public boughtEarly;
262     uint256 public botsCaught;
263 
264     bool public limitsInEffect = true;
265     bool public tradingActive = false;
266     bool public swapEnabled = false;
267 
268      // Anti-bot and anti-whale mappings and variables
269     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
270     bool public transferDelayEnabled = true;
271 
272     uint256 public buyTotalFees;
273     uint256 public buyMarketingFee;
274     uint256 public buyLiquidityFee;
275     uint256 public buyDevFee;
276     uint256 public buyBurnFee;
277 
278     uint256 public sellTotalFees;
279     uint256 public sellMarketingFee;
280     uint256 public sellLiquidityFee;
281     uint256 public sellDevFee;
282     uint256 public sellBurnFee;
283 
284     uint256 public tokensForMarketing;
285     uint256 public tokensForLiquidity;
286     uint256 public tokensForDev;
287     uint256 public tokensForBurn;
288 
289     /******************/
290 
291     // exlcude from fees and max transaction amount
292     mapping (address => bool) private _isExcludedFromFees;
293     mapping (address => bool) public _isExcludedMaxTransactionAmount;
294 
295     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
296     // could be subject to a maximum transfer amount
297     mapping (address => bool) public automatedMarketMakerPairs;
298 
299     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
300 
301     event EnabledTrading();
302 
303     event RemovedLimits();
304 
305     event ExcludeFromFees(address indexed account, bool isExcluded);
306 
307     event UpdatedMaxBuyAmount(uint256 newAmount);
308 
309     event UpdatedMaxSellAmount(uint256 newAmount);
310 
311     event UpdatedMaxWalletAmount(uint256 newAmount);
312 
313     event UpdatedMarketingAddress(address indexed newWallet);
314 
315     event MaxTransactionExclusion(address _address, bool excluded);
316 
317     event BuyBackTriggered(uint256 amount);
318 
319     event OwnerForcedSwapBack(uint256 timestamp);
320 
321     event CaughtEarlyBuyer(address sniper);
322 
323     event SwapAndLiquify(
324         uint256 tokensSwapped,
325         uint256 ethReceived,
326         uint256 tokensIntoLiquidity
327     );
328 
329     event TransferForeignToken(address token, uint256 amount);
330 
331     constructor() ERC20("MEMEX", "MEMEX") {
332 
333         address newOwner = msg.sender; // can leave alone if owner is deployer.
334 
335         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
336         dexRouter = _dexRouter;
337 
338         // create pair
339         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
340         _excludeFromMaxTransaction(address(lpPair), true);
341         _setAutomatedMarketMakerPair(address(lpPair), true);
342 
343         uint256 totalSupply = 1 * 1e8 * 1e18;
344 
345         maxBuyAmount = totalSupply * 15 / 1000;
346         maxSellAmount = totalSupply * 10 / 1000;
347         maxWalletAmount = totalSupply * 20 / 1000;
348         swapTokensAtAmount = totalSupply * 5 / 10000;
349 
350         buyMarketingFee = 24;
351         buyLiquidityFee = 0;
352         buyDevFee = 6;
353         buyBurnFee = 0;
354         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
355 
356         sellMarketingFee = 20;
357         sellLiquidityFee = 0;
358         sellDevFee = 5;
359         sellBurnFee = 0;
360         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
361 
362         _excludeFromMaxTransaction(newOwner, true);
363         _excludeFromMaxTransaction(address(this), true);
364         _excludeFromMaxTransaction(address(0xdead), true);
365 
366         excludeFromFees(newOwner, true);
367         excludeFromFees(address(this), true);
368         excludeFromFees(address(0xdead), true);
369 
370         marketingAddress = address(newOwner);
371         devAddress = address(newOwner);
372 
373         _createInitialSupply(newOwner, totalSupply);
374         transferOwnership(newOwner);
375     }
376 
377     receive() external payable {}
378 
379     // only enable if no plan to airdrop
380 
381     function EnableTrading() external onlyOwner {
382         require(!tradingActive, "Cannot reenable trading");
383         tradingActive = true;
384         swapEnabled = true;
385         tradingActiveBlock = block.number;
386         emit EnabledTrading();
387     }
388 
389     // remove limits after token is stable
390     function removeLimits() external onlyOwner {
391         limitsInEffect = false;
392         transferDelayEnabled = false;
393         emit RemovedLimits();
394     }
395 
396     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
397         boughtEarly[wallet] = flag;
398     }
399 
400     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
401         for(uint256 i = 0; i < wallets.length; i++){
402             boughtEarly[wallets[i]] = flag;
403         }
404     }
405 
406     // disable Transfer delay - cannot be reenabled
407     function disableTransferDelay() external onlyOwner {
408         transferDelayEnabled = false;
409     }
410 
411     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
412         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
413         maxBuyAmount = newNum * (10**18);
414         emit UpdatedMaxBuyAmount(maxBuyAmount);
415     }
416 
417     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
418         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
419         maxSellAmount = newNum * (10**18);
420         emit UpdatedMaxSellAmount(maxSellAmount);
421     }
422 
423     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
424         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
425         maxWalletAmount = newNum * (10**18);
426         emit UpdatedMaxWalletAmount(maxWalletAmount);
427     }
428 
429     // change the minimum amount of tokens to sell from fees
430     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
431   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
432   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
433   	    swapTokensAtAmount = newAmount;
434   	}
435 
436     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
437         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
438         emit MaxTransactionExclusion(updAds, isExcluded);
439     }
440 
441     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
442         if(!isEx){
443             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
444         }
445         _isExcludedMaxTransactionAmount[updAds] = isEx;
446     }
447 
448     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
449         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
450 
451         _setAutomatedMarketMakerPair(pair, value);
452         emit SetAutomatedMarketMakerPair(pair, value);
453     }
454 
455     function _setAutomatedMarketMakerPair(address pair, bool value) private {
456         automatedMarketMakerPairs[pair] = value;
457 
458         _excludeFromMaxTransaction(pair, value);
459 
460         emit SetAutomatedMarketMakerPair(pair, value);
461     }
462 
463     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
464         buyMarketingFee = _marketingFee;
465         buyLiquidityFee = _liquidityFee;
466         buyDevFee = _DevFee;
467         buyBurnFee = _burnFee;
468         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
469         require(buyTotalFees <= 99, "Must keep fees at 35% or less");
470     }
471 
472     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
473         sellMarketingFee = _marketingFee;
474         sellLiquidityFee = _liquidityFee;
475         sellDevFee = _DevFee;
476         sellBurnFee = _burnFee;
477         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
478         require(sellTotalFees <= 99, "Must keep fees at 35% or less");
479     }
480 
481     function MEMEXTax() external onlyOwner {
482         sellMarketingFee = 4;
483         sellLiquidityFee = 0;
484         sellDevFee = 1;
485         sellBurnFee = 0;
486         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
487         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
488 
489         buyMarketingFee = 4;
490         buyLiquidityFee = 0;
491         buyDevFee = 1;
492         buyBurnFee = 0;
493         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
494         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
495     }
496 
497     function excludeFromFees(address account, bool excluded) public onlyOwner {
498         _isExcludedFromFees[account] = excluded;
499         emit ExcludeFromFees(account, excluded);
500     }
501 
502     function _transfer(address from, address to, uint256 amount) internal override {
503 
504         require(from != address(0), "ERC20: transfer from the zero address");
505         require(to != address(0), "ERC20: transfer to the zero address");
506         require(amount > 0, "amount must be greater than 0");
507 
508         if(!tradingActive){
509             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
510         }
511 
512         if(blockForPenaltyEnd > 0){
513             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
514         }
515 
516         if(limitsInEffect){
517             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
518 
519                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
520                 if (transferDelayEnabled){
521                     if (to != address(dexRouter) && to != address(lpPair)){
522                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
523                         _holderLastTransferTimestamp[tx.origin] = block.number;
524                         _holderLastTransferTimestamp[to] = block.number;
525                     }
526                 }
527 
528                 //when buy
529                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
530                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
531                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
532                 }
533                 //when sell
534                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
535                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
536                 }
537                 else if (!_isExcludedMaxTransactionAmount[to]){
538                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
539                 }
540             }
541         }
542 
543         uint256 contractTokenBalance = balanceOf(address(this));
544 
545         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
546 
547         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
548             swapping = true;
549 
550             swapBack();
551 
552             swapping = false;
553         }
554 
555         bool takeFee = true;
556         // if any account belongs to _isExcludedFromFee account then remove the fee
557         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
558             takeFee = false;
559         }
560 
561         uint256 fees = 0;
562         // only take fees on buys/sells, do not take on wallet transfers
563         if(takeFee){
564             // bot/sniper penalty.
565             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
566 
567                 if(!boughtEarly[to]){
568                     boughtEarly[to] = true;
569                     botsCaught += 1;
570                     emit CaughtEarlyBuyer(to);
571                 }
572 
573                 fees = amount * 99 / 100;
574         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
575                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
576                 tokensForDev += fees * buyDevFee / buyTotalFees;
577                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
578             }
579 
580             // on sell
581             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
582                 fees = amount * sellTotalFees / 100;
583                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
584                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
585                 tokensForDev += fees * sellDevFee / sellTotalFees;
586                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
587             }
588 
589             // on buy
590             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
591         	    fees = amount * buyTotalFees / 100;
592         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
593                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
594                 tokensForDev += fees * buyDevFee / buyTotalFees;
595                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
596             }
597 
598             if(fees > 0){
599                 super._transfer(from, address(this), fees);
600             }
601 
602         	amount -= fees;
603         }
604 
605         super._transfer(from, to, amount);
606     }
607 
608     function earlyBuyPenaltyInEffect() public view returns (bool){
609         return block.number < blockForPenaltyEnd;
610     }
611 
612     function swapTokensForEth(uint256 tokenAmount) private {
613 
614         // generate the uniswap pair path of token -> weth
615         address[] memory path = new address[](2);
616         path[0] = address(this);
617         path[1] = dexRouter.WETH();
618 
619         _approve(address(this), address(dexRouter), tokenAmount);
620 
621         // make the swap
622         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
623             tokenAmount,
624             0, // accept any amount of ETH
625             path,
626             address(this),
627             block.timestamp
628         );
629     }
630 
631     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
632         // approve token transfer to cover all possible scenarios
633         _approve(address(this), address(dexRouter), tokenAmount);
634 
635         // add the liquidity
636         dexRouter.addLiquidityETH{value: ethAmount}(
637             address(this),
638             tokenAmount,
639             0, // slippage is unavoidable
640             0, // slippage is unavoidable
641             address(0xdead),
642             block.timestamp
643         );
644     }
645 
646     function swapBack() private {
647 
648         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
649             _burn(address(this), tokensForBurn);
650         }
651         tokensForBurn = 0;
652 
653         uint256 contractBalance = balanceOf(address(this));
654         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
655 
656         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
657 
658         if(contractBalance > swapTokensAtAmount * 20){
659             contractBalance = swapTokensAtAmount * 20;
660         }
661 
662         bool success;
663 
664         // Halve the amount of liquidity tokens
665         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
666 
667         swapTokensForEth(contractBalance - liquidityTokens);
668 
669         uint256 ethBalance = address(this).balance;
670         uint256 ethForLiquidity = ethBalance;
671 
672         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
673         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
674 
675         ethForLiquidity -= ethForMarketing + ethForDev;
676 
677         tokensForLiquidity = 0;
678         tokensForMarketing = 0;
679         tokensForDev = 0;
680         tokensForBurn = 0;
681 
682         if(liquidityTokens > 0 && ethForLiquidity > 0){
683             addLiquidity(liquidityTokens, ethForLiquidity);
684         }
685 
686         (success,) = address(devAddress).call{value: ethForDev}("");
687 
688         (success,) = address(marketingAddress).call{value: address(this).balance}("");
689     }
690 
691     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
692         require(_token != address(0), "_token address cannot be 0");
693         require(_token != address(this), "Can't withdraw native tokens");
694         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
695         _sent = IERC20(_token).transfer(_to, _contractBalance);
696         emit TransferForeignToken(_token, _contractBalance);
697     }
698 
699     // withdraw ETH if stuck or someone sends to the address
700     function withdrawStuckETH() external onlyOwner {
701         bool success;
702         (success,) = address(msg.sender).call{value: address(this).balance}("");
703     }
704 
705     function SetMarketingWallet(address _marketingAddress) external onlyOwner {
706         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
707         marketingAddress = payable(_marketingAddress);
708     }
709 
710     function SetDevWallet(address _devAddress) external onlyOwner {
711         require(_devAddress != address(0), "_devAddress address cannot be 0");
712         devAddress = payable(_devAddress);
713     }
714 
715     // force Swap back if slippage issues.
716     function forceSwapBack() external onlyOwner {
717         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
718         swapping = true;
719         swapBack();
720         swapping = false;
721         emit OwnerForcedSwapBack(block.timestamp);
722     }
723 
724     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
725     function buyBackTokens(uint256 amountInWei) external onlyOwner {
726         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
727 
728         address[] memory path = new address[](2);
729         path[0] = dexRouter.WETH();
730         path[1] = address(this);
731 
732         // make the swap
733         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
734             0, // accept any amount of Ethereum
735             path,
736             address(0xdead),
737             block.timestamp
738         );
739         emit BuyBackTriggered(amountInWei);
740     }
741 }