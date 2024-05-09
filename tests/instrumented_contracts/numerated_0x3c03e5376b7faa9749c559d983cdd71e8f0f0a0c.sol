1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 
6 two possibilities exist
7 
8 either we are alone in the Universe
9 
10 or we are not
11 
12 both are equally terrifying
13 
14 
15 */
16 
17 pragma solidity 0.8.15;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 interface IERC20 {
31 
32     function totalSupply() external view returns (uint256);
33 
34     function balanceOf(address account) external view returns (uint256);
35 
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     function approve(address spender, uint256 amount) external returns (bool);
41 
42     function transferFrom(
43         address sender,
44         address recipient,
45         uint256 amount
46     ) external returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50    
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 interface IERC20Metadata is IERC20 {
55     
56     function name() external view returns (string memory);
57 
58     function symbol() external view returns (string memory);
59 
60     function decimals() external view returns (uint8);
61 }
62 
63 contract ERC20 is Context, IERC20, IERC20Metadata {
64     mapping(address => uint256) private _balances;
65 
66     mapping(address => mapping(address => uint256)) private _allowances;
67 
68     uint256 private _totalSupply;
69 
70     string private _name;
71     string private _symbol;
72 
73     constructor(string memory name_, string memory symbol_) {
74         _name = name_;
75         _symbol = symbol_;
76     }
77 
78     function name() public view virtual override returns (string memory) {
79         return _name;
80     }
81 
82     function symbol() public view virtual override returns (string memory) {
83         return _symbol;
84     }
85 
86     function decimals() public view virtual override returns (uint8) {
87         return 18;
88     }
89 
90     function totalSupply() public view virtual override returns (uint256) {
91         return _totalSupply;
92     }
93 
94     function balanceOf(address account) public view virtual override returns (uint256) {
95         return _balances[account];
96     }
97 
98     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
99         _transfer(_msgSender(), recipient, amount);
100         return true;
101     }
102 
103     function allowance(address owner, address spender) public view virtual override returns (uint256) {
104         return _allowances[owner][spender];
105     }
106 
107     function approve(address spender, uint256 amount) public virtual override returns (bool) {
108         _approve(_msgSender(), spender, amount);
109         return true;
110     }
111 
112     function transferFrom(
113         address sender,
114         address recipient,
115         uint256 amount
116     ) public virtual override returns (bool) {
117         _transfer(sender, recipient, amount);
118 
119         uint256 currentAllowance = _allowances[sender][_msgSender()];
120         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
121         unchecked {
122             _approve(sender, _msgSender(), currentAllowance - amount);
123         }
124 
125         return true;
126     }
127 
128     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
129         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
130         return true;
131     }
132 
133     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
134         uint256 currentAllowance = _allowances[_msgSender()][spender];
135         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
136         unchecked {
137             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
138         }
139 
140         return true;
141     }
142 
143     function _transfer(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) internal virtual {
148         require(sender != address(0), "ERC20: transfer from the zero address");
149         require(recipient != address(0), "ERC20: transfer to the zero address");
150 
151         uint256 senderBalance = _balances[sender];
152         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
153         unchecked {
154             _balances[sender] = senderBalance - amount;
155         }
156         _balances[recipient] += amount;
157 
158         emit Transfer(sender, recipient, amount);
159     }
160 
161     function _createInitialSupply(address account, uint256 amount) internal virtual {
162         require(account != address(0), "ERC20: mint to the zero address");
163 
164         _totalSupply += amount;
165         _balances[account] += amount;
166         emit Transfer(address(0), account, amount);
167     }
168 
169     function _burn(address account, uint256 amount) internal virtual {
170         require(account != address(0), "ERC20: burn from the zero address");
171         uint256 accountBalance = _balances[account];
172         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
173         unchecked {
174             _balances[account] = accountBalance - amount;
175             // Overflow not possible: amount <= accountBalance <= totalSupply.
176             _totalSupply -= amount;
177         }
178 
179         emit Transfer(account, address(0), amount);
180     }
181 
182     function _approve(
183         address owner,
184         address spender,
185         uint256 amount
186     ) internal virtual {
187         require(owner != address(0), "ERC20: approve from the zero address");
188         require(spender != address(0), "ERC20: approve to the zero address");
189 
190         _allowances[owner][spender] = amount;
191         emit Approval(owner, spender, amount);
192     }
193 }
194 
195 contract Ownable is Context {
196     address private _owner;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200     constructor () {
201         address msgSender = _msgSender();
202         _owner = msgSender;
203         emit OwnershipTransferred(address(0), msgSender);
204     }
205 
206     function owner() public view returns (address) {
207         return _owner;
208     }
209 
210     modifier onlyOwner() {
211         require(_owner == _msgSender(), "Ownable: caller is not the owner");
212         _;
213     }
214 
215     function renounceOwnership() external virtual onlyOwner {
216         emit OwnershipTransferred(_owner, address(0));
217         _owner = address(0);
218     }
219 
220     function transferOwnership(address newOwner) public virtual onlyOwner {
221         require(newOwner != address(0), "Ownable: new owner is the zero address");
222         emit OwnershipTransferred(_owner, newOwner);
223         _owner = newOwner;
224     }
225 }
226 
227 interface IDexRouter {
228     function factory() external pure returns (address);
229     function WETH() external pure returns (address);
230 
231     function swapExactTokensForETHSupportingFeeOnTransferTokens(
232         uint amountIn,
233         uint amountOutMin,
234         address[] calldata path,
235         address to,
236         uint deadline
237     ) external;
238 
239     function swapExactETHForTokensSupportingFeeOnTransferTokens(
240         uint amountOutMin,
241         address[] calldata path,
242         address to,
243         uint deadline
244     ) external payable;
245 
246     function addLiquidityETH(
247         address token,
248         uint256 amountTokenDesired,
249         uint256 amountTokenMin,
250         uint256 amountETHMin,
251         address to,
252         uint256 deadline
253     )
254         external
255         payable
256         returns (
257             uint256 amountToken,
258             uint256 amountETH,
259             uint256 liquidity
260         );
261 }
262 
263 interface IDexFactory {
264     function createPair(address tokenA, address tokenB)
265         external
266         returns (address pair);
267 }
268 
269 contract thecosmickin is ERC20, Ownable {
270 
271     uint256 public maxBuyAmount;
272     uint256 public maxSellAmount;
273     uint256 public maxWalletAmount;
274 
275     IDexRouter public dexRouter;
276     address public lpPair;
277 
278     bool private swapping;
279     uint256 public swapTokensAtAmount;
280 
281     address operationsAddress;
282     address devAddress;
283 
284     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
285     uint256 public blockForPenaltyEnd;
286     mapping (address => bool) public boughtEarly;
287     uint256 public botsCaught;
288 
289     bool public limitsInEffect = true;
290     bool public tradingActive = false;
291     bool public swapEnabled = false;
292 
293      // Anti-bot and anti-whale mappings and variables
294     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
295     bool public transferDelayEnabled = true;
296 
297     uint256 public buyTotalFees;
298     uint256 public buyOperationsFee;
299     uint256 public buyLiquidityFee;
300     uint256 public buyDevFee;
301     uint256 public buyBurnFee;
302 
303     uint256 public sellTotalFees;
304     uint256 public sellOperationsFee;
305     uint256 public sellLiquidityFee;
306     uint256 public sellDevFee;
307     uint256 public sellBurnFee;
308 
309     uint256 public tokensForOperations;
310     uint256 public tokensForLiquidity;
311     uint256 public tokensForDev;
312     uint256 public tokensForBurn;
313 
314     /******************/
315 
316     // exlcude from fees and max transaction amount
317     mapping (address => bool) private _isExcludedFromFees;
318     mapping (address => bool) public _isExcludedMaxTransactionAmount;
319 
320     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
321     // could be subject to a maximum transfer amount
322     mapping (address => bool) public automatedMarketMakerPairs;
323 
324     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
325 
326     event EnabledTrading();
327 
328     event RemovedLimits();
329 
330     event ExcludeFromFees(address indexed account, bool isExcluded);
331 
332     event UpdatedMaxBuyAmount(uint256 newAmount);
333 
334     event UpdatedMaxSellAmount(uint256 newAmount);
335 
336     event UpdatedMaxWalletAmount(uint256 newAmount);
337 
338     event UpdatedOperationsAddress(address indexed newWallet);
339 
340     event MaxTransactionExclusion(address _address, bool excluded);
341 
342     event BuyBackTriggered(uint256 amount);
343 
344     event OwnerForcedSwapBack(uint256 timestamp);
345 
346     event CaughtEarlyBuyer(address sniper);
347 
348     event SwapAndLiquify(
349         uint256 tokensSwapped,
350         uint256 ethReceived,
351         uint256 tokensIntoLiquidity
352     );
353 
354     event TransferForeignToken(address token, uint256 amount);
355 
356     constructor() ERC20("THE COSMIC KIN", "EXO") {
357 
358         address newOwner = msg.sender; // can leave alone if owner is deployer.
359 
360         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
361         dexRouter = _dexRouter;
362 
363         // create pair
364         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
365         _excludeFromMaxTransaction(address(lpPair), true);
366         _setAutomatedMarketMakerPair(address(lpPair), true);
367 
368         uint256 totalSupply = 1 * 1e12 * 1e18;
369 
370         maxBuyAmount = totalSupply * 2 / 100;
371         maxSellAmount = totalSupply * 2 / 100;
372         maxWalletAmount = totalSupply * 2 / 100;
373         swapTokensAtAmount = totalSupply * 5 / 10000;
374 
375         buyOperationsFee = 3;
376         buyLiquidityFee = 0;
377         buyDevFee = 0;
378         buyBurnFee = 0;
379         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
380 
381         sellOperationsFee = 3;
382         sellLiquidityFee = 0;
383         sellDevFee = 0;
384         sellBurnFee = 0;
385         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
386 
387         _excludeFromMaxTransaction(newOwner, true);
388         _excludeFromMaxTransaction(address(this), true);
389         _excludeFromMaxTransaction(address(0xdead), true);
390 
391         excludeFromFees(newOwner, true);
392         excludeFromFees(address(this), true);
393         excludeFromFees(address(0xdead), true);
394 
395         operationsAddress = address(newOwner);
396         devAddress = address(newOwner);
397 
398         _createInitialSupply(newOwner, totalSupply);
399         transferOwnership(newOwner);
400     }
401 
402     receive() external payable {}
403 
404     // only enable if no plan to airdrop
405 
406     function enableTrading(uint256 deadBlocks) external onlyOwner {
407         require(!tradingActive, "Cannot reenable trading");
408         tradingActive = true;
409         swapEnabled = true;
410         tradingActiveBlock = block.number;
411         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
412         emit EnabledTrading();
413     }
414 
415     // remove limits after token is stable
416     function removeLimits() external onlyOwner {
417         limitsInEffect = false;
418         transferDelayEnabled = false;
419         emit RemovedLimits();
420     }
421 
422     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
423         boughtEarly[wallet] = flag;
424     }
425 
426     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
427         for(uint256 i = 0; i < wallets.length; i++){
428             boughtEarly[wallets[i]] = flag;
429         }
430     }
431 
432     // disable Transfer delay - cannot be reenabled
433     function disableTransferDelay() external onlyOwner {
434         transferDelayEnabled = false;
435     }
436 
437     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
438         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
439         maxBuyAmount = newNum * (10**18);
440         emit UpdatedMaxBuyAmount(maxBuyAmount);
441     }
442 
443     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
444         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
445         maxSellAmount = newNum * (10**18);
446         emit UpdatedMaxSellAmount(maxSellAmount);
447     }
448 
449     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
450         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
451         maxWalletAmount = newNum * (10**18);
452         emit UpdatedMaxWalletAmount(maxWalletAmount);
453     }
454 
455     // change the minimum amount of tokens to sell from fees
456     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
457   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
458   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
459   	    swapTokensAtAmount = newAmount;
460   	}
461 
462     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
463         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
464         emit MaxTransactionExclusion(updAds, isExcluded);
465     }
466 
467     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
468         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
469         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
470         for(uint256 i = 0; i < wallets.length; i++){
471             address wallet = wallets[i];
472             uint256 amount = amountsInTokens[i];
473             super._transfer(msg.sender, wallet, amount);
474         }
475     }
476 
477     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
478         if(!isEx){
479             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
480         }
481         _isExcludedMaxTransactionAmount[updAds] = isEx;
482     }
483 
484     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
485         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
486 
487         _setAutomatedMarketMakerPair(pair, value);
488         emit SetAutomatedMarketMakerPair(pair, value);
489     }
490 
491     function _setAutomatedMarketMakerPair(address pair, bool value) private {
492         automatedMarketMakerPairs[pair] = value;
493 
494         _excludeFromMaxTransaction(pair, value);
495 
496         emit SetAutomatedMarketMakerPair(pair, value);
497     }
498 
499     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
500         buyOperationsFee = _operationsFee;
501         buyLiquidityFee = _liquidityFee;
502         buyDevFee = _devFee;
503         buyBurnFee = _burnFee;
504         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
505         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
506     }
507 
508     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
509         sellOperationsFee = _operationsFee;
510         sellLiquidityFee = _liquidityFee;
511         sellDevFee = _devFee;
512         sellBurnFee = _burnFee;
513         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
514         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
515     }
516 
517     function returnToNormalTax() external onlyOwner {
518         sellOperationsFee = 20;
519         sellLiquidityFee = 0;
520         sellDevFee = 0;
521         sellBurnFee = 0;
522         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
523         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
524 
525         buyOperationsFee = 20;
526         buyLiquidityFee = 0;
527         buyDevFee = 0;
528         buyBurnFee = 0;
529         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
530         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
531     }
532 
533     function excludeFromFees(address account, bool excluded) public onlyOwner {
534         _isExcludedFromFees[account] = excluded;
535         emit ExcludeFromFees(account, excluded);
536     }
537 
538     function _transfer(address from, address to, uint256 amount) internal override {
539 
540         require(from != address(0), "ERC20: transfer from the zero address");
541         require(to != address(0), "ERC20: transfer to the zero address");
542         require(amount > 0, "amount must be greater than 0");
543 
544         if(!tradingActive){
545             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
546         }
547 
548         if(blockForPenaltyEnd > 0){
549             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
550         }
551 
552         if(limitsInEffect){
553             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
554 
555                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
556                 if (transferDelayEnabled){
557                     if (to != address(dexRouter) && to != address(lpPair)){
558                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
559                         _holderLastTransferTimestamp[tx.origin] = block.number;
560                         _holderLastTransferTimestamp[to] = block.number;
561                     }
562                 }
563 
564                 //when buy
565                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
566                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
567                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
568                 }
569                 //when sell
570                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
571                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
572                 }
573                 else if (!_isExcludedMaxTransactionAmount[to]){
574                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
575                 }
576             }
577         }
578 
579         uint256 contractTokenBalance = balanceOf(address(this));
580 
581         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
582 
583         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
584             swapping = true;
585 
586             swapBack();
587 
588             swapping = false;
589         }
590 
591         bool takeFee = true;
592         // if any account belongs to _isExcludedFromFee account then remove the fee
593         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
594             takeFee = false;
595         }
596 
597         uint256 fees = 0;
598         // only take fees on buys/sells, do not take on wallet transfers
599         if(takeFee){
600             // bot/sniper penalty.
601             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
602 
603                 if(!boughtEarly[to]){
604                     boughtEarly[to] = true;
605                     botsCaught += 1;
606                     emit CaughtEarlyBuyer(to);
607                 }
608 
609                 fees = amount * 99 / 100;
610         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
611                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
612                 tokensForDev += fees * buyDevFee / buyTotalFees;
613                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
614             }
615 
616             // on sell
617             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
618                 fees = amount * sellTotalFees / 100;
619                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
620                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
621                 tokensForDev += fees * sellDevFee / sellTotalFees;
622                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
623             }
624 
625             // on buy
626             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
627         	    fees = amount * buyTotalFees / 100;
628         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
629                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
630                 tokensForDev += fees * buyDevFee / buyTotalFees;
631                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
632             }
633 
634             if(fees > 0){
635                 super._transfer(from, address(this), fees);
636             }
637 
638         	amount -= fees;
639         }
640 
641         super._transfer(from, to, amount);
642     }
643 
644     function earlyBuyPenaltyInEffect() public view returns (bool){
645         return block.number < blockForPenaltyEnd;
646     }
647 
648     function swapTokensForEth(uint256 tokenAmount) private {
649 
650         // generate the uniswap pair path of token -> weth
651         address[] memory path = new address[](2);
652         path[0] = address(this);
653         path[1] = dexRouter.WETH();
654 
655         _approve(address(this), address(dexRouter), tokenAmount);
656 
657         // make the swap
658         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
659             tokenAmount,
660             0, // accept any amount of ETH
661             path,
662             address(this),
663             block.timestamp
664         );
665     }
666 
667     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
668         // approve token transfer to cover all possible scenarios
669         _approve(address(this), address(dexRouter), tokenAmount);
670 
671         // add the liquidity
672         dexRouter.addLiquidityETH{value: ethAmount}(
673             address(this),
674             tokenAmount,
675             0, // slippage is unavoidable
676             0, // slippage is unavoidable
677             address(0xdead),
678             block.timestamp
679         );
680     }
681 
682     function swapBack() private {
683 
684         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
685             _burn(address(this), tokensForBurn);
686         }
687         tokensForBurn = 0;
688 
689         uint256 contractBalance = balanceOf(address(this));
690         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
691 
692         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
693 
694         if(contractBalance > swapTokensAtAmount * 20){
695             contractBalance = swapTokensAtAmount * 20;
696         }
697 
698         bool success;
699 
700         // Halve the amount of liquidity tokens
701         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
702 
703         swapTokensForEth(contractBalance - liquidityTokens);
704 
705         uint256 ethBalance = address(this).balance;
706         uint256 ethForLiquidity = ethBalance;
707 
708         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
709         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
710 
711         ethForLiquidity -= ethForOperations + ethForDev;
712 
713         tokensForLiquidity = 0;
714         tokensForOperations = 0;
715         tokensForDev = 0;
716         tokensForBurn = 0;
717 
718         if(liquidityTokens > 0 && ethForLiquidity > 0){
719             addLiquidity(liquidityTokens, ethForLiquidity);
720         }
721 
722         (success,) = address(devAddress).call{value: ethForDev}("");
723 
724         (success,) = address(operationsAddress).call{value: address(this).balance}("");
725     }
726 
727     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
728         require(_token != address(0), "_token address cannot be 0");
729         require(_token != address(this), "Can't withdraw native tokens");
730         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
731         _sent = IERC20(_token).transfer(_to, _contractBalance);
732         emit TransferForeignToken(_token, _contractBalance);
733     }
734 
735     // withdraw ETH if stuck or someone sends to the address
736     function withdrawStuckETH() external onlyOwner {
737         bool success;
738         (success,) = address(msg.sender).call{value: address(this).balance}("");
739     }
740 
741     function setOperationsAddress(address _operationsAddress) external onlyOwner {
742         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
743         operationsAddress = payable(_operationsAddress);
744     }
745 
746     function setDevAddress(address _devAddress) external onlyOwner {
747         require(_devAddress != address(0), "_devAddress address cannot be 0");
748         devAddress = payable(_devAddress);
749     }
750 
751     // force Swap back if slippage issues.
752     function forceSwapBack() external onlyOwner {
753         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
754         swapping = true;
755         swapBack();
756         swapping = false;
757         emit OwnerForcedSwapBack(block.timestamp);
758     }
759 
760     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
761     function buyBackTokens(uint256 amountInWei) external onlyOwner {
762         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
763 
764         address[] memory path = new address[](2);
765         path[0] = dexRouter.WETH();
766         path[1] = address(this);
767 
768         // make the swap
769         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
770             0, // accept any amount of Ethereum
771             path,
772             address(0xdead),
773             block.timestamp
774         );
775         emit BuyBackTriggered(amountInWei);
776     }
777 }