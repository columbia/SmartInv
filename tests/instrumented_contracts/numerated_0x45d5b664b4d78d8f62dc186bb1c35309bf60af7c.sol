1 ///
2 //
3 /*  
4 
5 In a scenario where everyone aims to make money out off animal cruelty, we intend to be go the opposite direction.
6 
7 Raised taxes will be sent to People for the Ethical Treatment oif Animals (PETA). 
8 
9 Welcome to the anti-meta play
10 
11 Socials 
12 
13 https://t.me/OFFICIALPETAPORTAL
14 
15 http://petapeta.quest
16 
17 https://twitter.com/petaerc20
18 
19 */
20 
21 // SPDX-License-Identifier: AGPL-3.0-only
22 pragma solidity 0.8.15;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 interface IERC20 {
36 
37     function totalSupply() external view returns (uint256);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(
43         address sender,
44         address recipient,
45         uint256 amount
46     ) external returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49    
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 interface IERC20Metadata is IERC20 {
54     
55     function name() external view returns (string memory);
56     function symbol() external view returns (string memory);
57     function decimals() external view returns (uint8);
58 }
59 
60 contract ERC20 is Context, IERC20, IERC20Metadata {
61     mapping(address => uint256) private _balances;
62     mapping(address => mapping(address => uint256)) private _allowances;
63 
64     uint256 private _totalSupply;
65     string private _name;
66     string private _symbol;
67 
68     constructor(string memory name_, string memory symbol_) {
69         _name = name_;
70         _symbol = symbol_;
71     }
72 
73     function name() public view virtual override returns (string memory) {
74         return _name;
75     }
76 
77     function symbol() public view virtual override returns (string memory) {
78         return _symbol;
79     }
80 
81     function decimals() public view virtual override returns (uint8) {
82         return 18;
83     }
84 
85     function totalSupply() public view virtual override returns (uint256) {
86         return _totalSupply;
87     }
88 
89     function balanceOf(address account) public view virtual override returns (uint256) {
90         return _balances[account];
91     }
92 
93     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
94         _transfer(_msgSender(), recipient, amount);
95         return true;
96     }
97 
98     function allowance(address owner, address spender) public view virtual override returns (uint256) {
99         return _allowances[owner][spender];
100     }
101 
102     function approve(address spender, uint256 amount) public virtual override returns (bool) {
103         _approve(_msgSender(), spender, amount);
104         return true;
105     }
106 
107     function transferFrom(
108         address sender,
109         address recipient,
110         uint256 amount
111     ) public virtual override returns (bool) {
112         _transfer(sender, recipient, amount);
113 
114         uint256 currentAllowance = _allowances[sender][_msgSender()];
115         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
116         unchecked {
117             _approve(sender, _msgSender(), currentAllowance - amount);
118         }
119 
120         return true;
121     }
122 
123     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
124         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
125         return true;
126     }
127 
128     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
129         uint256 currentAllowance = _allowances[_msgSender()][spender];
130         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
131         unchecked {
132             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
133         }
134 
135         return true;
136     }
137 
138     function _transfer(
139         address sender,
140         address recipient,
141         uint256 amount
142     ) internal virtual {
143         require(sender != address(0), "ERC20: transfer from the zero address");
144         require(recipient != address(0), "ERC20: transfer to the zero address");
145 
146         uint256 senderBalance = _balances[sender];
147         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
148         unchecked {
149             _balances[sender] = senderBalance - amount;
150         }
151         _balances[recipient] += amount;
152 
153         emit Transfer(sender, recipient, amount);
154     }
155 
156     function _createInitialSupply(address account, uint256 amount) internal virtual {
157         require(account != address(0), "ERC20: mint to the zero address");
158 
159         _totalSupply += amount;
160         _balances[account] += amount;
161         emit Transfer(address(0), account, amount);
162     }
163 
164     function _burn(address account, uint256 amount) internal virtual {
165         require(account != address(0), "ERC20: burn from the zero address");
166         uint256 accountBalance = _balances[account];
167         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
168         unchecked {
169             _balances[account] = accountBalance - amount;
170             // Overflow not possible: amount <= accountBalance <= totalSupply.
171             _totalSupply -= amount;
172         }
173 
174         emit Transfer(account, address(0), amount);
175     }
176 
177     function _approve(
178         address owner,
179         address spender,
180         uint256 amount
181     ) internal virtual {
182         require(owner != address(0), "ERC20: approve from the zero address");
183         require(spender != address(0), "ERC20: approve to the zero address");
184 
185         _allowances[owner][spender] = amount;
186         emit Approval(owner, spender, amount);
187     }
188 }
189 
190 contract Ownable is Context {
191     address private _owner;
192 
193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194 
195     constructor () {
196         address msgSender = _msgSender();
197         _owner = msgSender;
198         emit OwnershipTransferred(address(0), msgSender);
199     }
200 
201     function owner() public view returns (address) {
202         return _owner;
203     }
204 
205     modifier onlyOwner() {
206         require(_owner == _msgSender(), "Ownable: caller is not the owner");
207         _;
208     }
209 
210     function renounceOwnership() external virtual onlyOwner {
211         emit OwnershipTransferred(_owner, address(0));
212         _owner = address(0);
213     }
214 
215     function transferOwnership(address newOwner) public virtual onlyOwner {
216         require(newOwner != address(0), "Ownable: new owner is the zero address");
217         emit OwnershipTransferred(_owner, newOwner);
218         _owner = newOwner;
219     }
220 }
221 
222 interface IDexRouter {
223     function factory() external pure returns (address);
224     function WETH() external pure returns (address);
225 
226     function swapExactTokensForETHSupportingFeeOnTransferTokens(
227         uint amountIn,
228         uint amountOutMin,
229         address[] calldata path,
230         address to,
231         uint deadline
232     ) external;
233 
234     function swapExactETHForTokensSupportingFeeOnTransferTokens(
235         uint amountOutMin,
236         address[] calldata path,
237         address to,
238         uint deadline
239     ) external payable;
240 
241     function addLiquidityETH(
242         address token,
243         uint256 amountTokenDesired,
244         uint256 amountTokenMin,
245         uint256 amountETHMin,
246         address to,
247         uint256 deadline
248     )
249         external
250         payable
251         returns (
252             uint256 amountToken,
253             uint256 amountETH,
254             uint256 liquidity
255         );
256 }
257 
258 interface IDexFactory {
259     function createPair(address tokenA, address tokenB)
260         external
261         returns (address pair);
262 }
263 
264 contract PETA is ERC20, Ownable {
265 
266     uint256 public maxBuyAmount;
267     uint256 public maxSellAmount;
268     uint256 public maxWalletAmount;
269 
270     IDexRouter public dexRouter;
271     address public lpPair;
272 
273     bool private swapping;
274     uint256 public swapTokensAtAmount;
275 
276     address marketingAddress;
277     address devAddress;
278 
279     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
280     uint256 public blockForPenaltyEnd = 0;
281     mapping (address => bool) public boughtEarly;
282     uint256 public botsCaught;
283 
284     bool public limitsInEffect = true;
285     bool public tradingActive = false;
286     bool public swapEnabled = false;
287 
288      // Anti-bot and anti-whale mappings and variables
289     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
290     bool public transferDelayEnabled = true;
291 
292     uint256 public buyTotalFees;
293     uint256 public buyMarketingFee;
294     uint256 public buyLiquidityFee;
295     uint256 public buyDevFee;
296     uint256 public buyBurnFee;
297 
298     uint256 public sellTotalFees;
299     uint256 public sellMarketingFee;
300     uint256 public sellLiquidityFee;
301     uint256 public sellDevFee;
302     uint256 public sellBurnFee;
303 
304     uint256 public tokensForMarketing;
305     uint256 public tokensForLiquidity;
306     uint256 public tokensForDev;
307     uint256 public tokensForBurn;
308 
309     /******************/
310 
311     // exlcude from fees and max transaction amount
312     mapping (address => bool) private _isExcludedFromFees;
313     mapping (address => bool) public _isExcludedMaxTransactionAmount;
314 
315     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
316     // could be subject to a maximum transfer amount
317     mapping (address => bool) public automatedMarketMakerPairs;
318 
319     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
320 
321     event EnabledTrading();
322 
323     event RemovedLimits();
324 
325     event ExcludeFromFees(address indexed account, bool isExcluded);
326 
327     event UpdatedMaxBuyAmount(uint256 newAmount);
328 
329     event UpdatedMaxSellAmount(uint256 newAmount);
330 
331     event UpdatedMaxWalletAmount(uint256 newAmount);
332 
333     event UpdatedMarketingAddress(address indexed newWallet);
334 
335     event MaxTransactionExclusion(address _address, bool excluded);
336 
337     event BuyBackTriggered(uint256 amount);
338 
339     event OwnerForcedSwapBack(uint256 timestamp);
340 
341     event CaughtEarlyBuyer(address sniper);
342 
343     event SwapAndLiquify(
344         uint256 tokensSwapped,
345         uint256 ethReceived,
346         uint256 tokensIntoLiquidity
347     );
348 
349     event TransferForeignToken(address token, uint256 amount);
350 
351     constructor() ERC20("PETA", "PETA") {
352 
353         address newOwner = msg.sender; // can leave alone if owner is deployer.
354 
355         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
356         dexRouter = _dexRouter;
357 
358         // create pair
359         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
360         _excludeFromMaxTransaction(address(lpPair), true);
361         _setAutomatedMarketMakerPair(address(lpPair), true);
362 
363         uint256 totalSupply = 1 * 1e8 * 1e18;
364 
365         maxBuyAmount = totalSupply * 2 / 100;
366         maxSellAmount = totalSupply * 2 / 100;
367         maxWalletAmount = totalSupply * 2 / 100;
368         swapTokensAtAmount = totalSupply * 5 / 10000;
369 
370         buyMarketingFee = 15;
371         buyLiquidityFee = 0;
372         buyDevFee = 15;
373         buyBurnFee = 0;
374         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
375 
376         sellMarketingFee = 13;
377         sellLiquidityFee = 0;
378         sellDevFee = 12;
379         sellBurnFee = 0;
380         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
381 
382         _excludeFromMaxTransaction(newOwner, true);
383         _excludeFromMaxTransaction(address(this), true);
384         _excludeFromMaxTransaction(address(0xdead), true);
385 
386         excludeFromFees(newOwner, true);
387         excludeFromFees(address(this), true);
388         excludeFromFees(address(0xdead), true);
389 
390         marketingAddress = address(newOwner);
391         devAddress = address(newOwner);
392 
393         _createInitialSupply(newOwner, totalSupply);
394         transferOwnership(newOwner);
395     }
396 
397     receive() external payable {}
398 
399     // only enable if no plan to airdrop
400 
401     function EnableTrading() external onlyOwner {
402         require(!tradingActive, "Cannot reenable trading");
403         tradingActive = true;
404         swapEnabled = true;
405         tradingActiveBlock = block.number;
406         emit EnabledTrading();
407     }
408 
409     // remove limits after token is stable
410     function removeLimits() external onlyOwner {
411         limitsInEffect = false;
412         transferDelayEnabled = false;
413         emit RemovedLimits();
414     }
415 
416     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
417         boughtEarly[wallet] = flag;
418     }
419 
420     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
421         for(uint256 i = 0; i < wallets.length; i++){
422             boughtEarly[wallets[i]] = flag;
423         }
424     }
425 
426     // disable Transfer delay - cannot be reenabled
427     function disableTransferDelay() external onlyOwner {
428         transferDelayEnabled = false;
429     }
430 
431     function updateMaxBuyPercent(uint256 newNum) external onlyOwner {
432         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
433         maxBuyAmount = newNum * (10**18);
434         emit UpdatedMaxBuyAmount(maxBuyAmount);
435     }
436 
437     function updateMaxSellPercent(uint256 newNum) external onlyOwner {
438         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
439         maxSellAmount = newNum * (10**18);
440         emit UpdatedMaxSellAmount(maxSellAmount);
441     }
442 
443     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
444         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
445         maxWalletAmount = newNum * (10**18);
446         emit UpdatedMaxWalletAmount(maxWalletAmount);
447     }
448 
449     // change the minimum amount of tokens to sell from fees
450     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
451   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
452   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
453   	    swapTokensAtAmount = newAmount;
454   	}
455 
456     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
457         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
458         emit MaxTransactionExclusion(updAds, isExcluded);
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
483     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
484         buyMarketingFee = _marketingFee;
485         buyLiquidityFee = _liquidityFee;
486         buyDevFee = _DevFee;
487         buyBurnFee = _burnFee;
488         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
489         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
490     }
491 
492     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
493         sellMarketingFee = _marketingFee;
494         sellLiquidityFee = _liquidityFee;
495         sellDevFee = _DevFee;
496         sellBurnFee = _burnFee;
497         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
498         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
499     }
500 
501     function NothingToSeeHere() external onlyOwner {
502         sellMarketingFee = 2;
503         sellLiquidityFee = 0;
504         sellDevFee = 2;
505         sellBurnFee = 0;
506         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
507         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
508 
509         buyMarketingFee = 2;
510         buyLiquidityFee = 0;
511         buyDevFee = 2;
512         buyBurnFee = 0;
513         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
514         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
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
595                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
596                 tokensForDev += fees * buyDevFee / buyTotalFees;
597                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
598             }
599 
600             // on sell
601             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
602                 fees = amount * sellTotalFees / 100;
603                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
604                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
605                 tokensForDev += fees * sellDevFee / sellTotalFees;
606                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
607             }
608 
609             // on buy
610             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
611         	    fees = amount * buyTotalFees / 100;
612         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
613                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
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
674         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
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
692         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
693         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
694 
695         ethForLiquidity -= ethForMarketing + ethForDev;
696 
697         tokensForLiquidity = 0;
698         tokensForMarketing = 0;
699         tokensForDev = 0;
700         tokensForBurn = 0;
701 
702         if(liquidityTokens > 0 && ethForLiquidity > 0){
703             addLiquidity(liquidityTokens, ethForLiquidity);
704         }
705 
706         (success,) = address(devAddress).call{value: ethForDev}("");
707 
708         (success,) = address(marketingAddress).call{value: address(this).balance}("");
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
725     function SetMarketingWallet(address _marketingAddress) external onlyOwner {
726         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
727         marketingAddress = payable(_marketingAddress);
728     }
729 
730     function SetDevWallet(address _devAddress) external onlyOwner {
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