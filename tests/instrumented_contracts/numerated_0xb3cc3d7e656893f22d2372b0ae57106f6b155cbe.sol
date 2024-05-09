1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.13;
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
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 contract ERC20 is Context, IERC20, IERC20Metadata {
109     mapping(address => uint256) private _balances;
110 
111     mapping(address => mapping(address => uint256)) private _allowances;
112 
113     uint256 private _totalSupply;
114 
115     string private _name;
116     string private _symbol;
117 
118     constructor(string memory name_, string memory symbol_) {
119         _name = name_;
120         _symbol = symbol_;
121     }
122 
123     function name() public view virtual override returns (string memory) {
124         return _name;
125     }
126 
127     function symbol() public view virtual override returns (string memory) {
128         return _symbol;
129     }
130 
131     function decimals() public view virtual override returns (uint8) {
132         return 18;
133     }
134 
135     function totalSupply() public view virtual override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(address account) public view virtual override returns (uint256) {
140         return _balances[account];
141     }
142 
143     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
144         _transfer(_msgSender(), recipient, amount);
145         return true;
146     }
147 
148     function allowance(address owner, address spender) public view virtual override returns (uint256) {
149         return _allowances[owner][spender];
150     }
151 
152     function approve(address spender, uint256 amount) public virtual override returns (bool) {
153         _approve(_msgSender(), spender, amount);
154         return true;
155     }
156 
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) public virtual override returns (bool) {
162         _transfer(sender, recipient, amount);
163 
164         uint256 currentAllowance = _allowances[sender][_msgSender()];
165         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
166         unchecked {
167             _approve(sender, _msgSender(), currentAllowance - amount);
168         }
169 
170         return true;
171     }
172 
173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
175         return true;
176     }
177 
178     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
179         uint256 currentAllowance = _allowances[_msgSender()][spender];
180         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
181         unchecked {
182             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
183         }
184 
185         return true;
186     }
187 
188     function _transfer(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) internal virtual {
193         require(sender != address(0), "ERC20: transfer from the zero address");
194         require(recipient != address(0), "ERC20: transfer to the zero address");
195 
196         uint256 senderBalance = _balances[sender];
197         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
198         unchecked {
199             _balances[sender] = senderBalance - amount;
200         }
201         _balances[recipient] += amount;
202 
203         emit Transfer(sender, recipient, amount);
204     }
205 
206     function _createInitialSupply(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _totalSupply += amount;
210         _balances[account] += amount;
211         emit Transfer(address(0), account, amount);
212     }
213 
214     function _approve(
215         address owner,
216         address spender,
217         uint256 amount
218     ) internal virtual {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221 
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 }
226 
227 contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231     
232     constructor () {
233         address msgSender = _msgSender();
234         _owner = msgSender;
235         emit OwnershipTransferred(address(0), msgSender);
236     }
237 
238     function owner() public view returns (address) {
239         return _owner;
240     }
241 
242     modifier onlyOwner() {
243         require(_owner == _msgSender(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     function renounceOwnership() external virtual onlyOwner {
248         emit OwnershipTransferred(_owner, address(0));
249         _owner = address(0);
250     }
251 
252     function transferOwnership(address newOwner) public virtual onlyOwner {
253         require(newOwner != address(0), "Ownable: new owner is the zero address");
254         emit OwnershipTransferred(_owner, newOwner);
255         _owner = newOwner;
256     }
257 }
258 
259 interface IDexRouter {
260     function factory() external pure returns (address);
261     function WETH() external pure returns (address);
262     
263     function swapExactTokensForETHSupportingFeeOnTransferTokens(
264         uint amountIn,
265         uint amountOutMin,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external;
270 
271     function swapExactETHForTokensSupportingFeeOnTransferTokens(
272         uint amountOutMin,
273         address[] calldata path,
274         address to,
275         uint deadline
276     ) external payable;
277 
278     function addLiquidityETH(
279         address token,
280         uint256 amountTokenDesired,
281         uint256 amountTokenMin,
282         uint256 amountETHMin,
283         address to,
284         uint256 deadline
285     )
286         external
287         payable
288         returns (
289             uint256 amountToken,
290             uint256 amountETH,
291             uint256 liquidity
292         );
293 }
294 
295 interface IDexFactory {
296     function createPair(address tokenA, address tokenB)
297         external
298         returns (address pair);
299 }
300 
301 contract Dogger is ERC20, Ownable {
302 
303     uint256 public maxBuyAmount;
304     uint256 public maxSellAmount;
305     uint256 public maxWalletAmount;
306 
307     IDexRouter public dexRouter;
308     address public lpPair;
309 
310     bool private swapping;
311     uint256 public swapTokensAtAmount;
312 
313     address operationsAddress;
314     address stakingAddress;
315 
316     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
317     uint256 public blockForPenaltyEnd;
318     mapping (address => bool) public restrictedWallet;
319     uint256 public botsCaught;
320 
321     bool public limitsInEffect = true;
322     bool public tradingActive = false;
323     bool public swapEnabled = false;
324     
325      // Anti-bot and anti-whale mappings and variables
326     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
327     bool public transferDelayEnabled = true;
328 
329     uint256 public buyTotalFees;
330     uint256 public buyOperationsFee;
331     uint256 public buyLiquidityFee;
332     uint256 public buyStakingFee;
333 
334     uint256 public sellTotalFees;
335     uint256 public sellOperationsFee;
336     uint256 public sellLiquidityFee;
337     uint256 public sellStakingFee;
338 
339     uint256 public tokensForOperations;
340     uint256 public tokensForLiquidity;
341     uint256 public tokensForStaking;
342     
343     /******************/
344 
345     // exlcude from fees and max transaction amount
346     mapping (address => bool) private _isExcludedFromFees;
347     mapping (address => bool) public _isExcludedMaxTransactionAmount;
348 
349     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
350     // could be subject to a maximum transfer amount
351     mapping (address => bool) public automatedMarketMakerPairs;
352 
353     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
354 
355     event EnabledTrading();
356 
357     event RemovedLimits();
358 
359     event ExcludeFromFees(address indexed account, bool isExcluded);
360 
361     event UpdatedMaxBuyAmount(uint256 newAmount);
362 
363     event UpdatedMaxSellAmount(uint256 newAmount);
364 
365     event UpdatedMaxWalletAmount(uint256 newAmount);
366 
367     event UpdatedOperationsAddress(address indexed newWallet);
368 
369     event MaxTransactionExclusion(address _address, bool excluded);
370 
371     event BuyBackTriggered(uint256 amount);
372 
373     event OwnerForcedSwapBack(uint256 timestamp);
374 
375     event CaughtBot(address sniper);
376 
377     event TransferForeignToken(address token, uint256 amount);
378 
379     constructor() ERC20("Dogger Token", "DOGGER") {
380         
381         address newOwner = msg.sender; // can leave alone if owner is deployer.
382 
383         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
384         dexRouter = _dexRouter;
385 
386         // create pair
387         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
388         _excludeFromMaxTransaction(address(lpPair), true);
389         _setAutomatedMarketMakerPair(address(lpPair), true);
390 
391         uint256 totalSupply = 1 * 1e9 * 1e18;
392         
393         maxBuyAmount = totalSupply * 30 / 10000;
394         maxSellAmount = totalSupply * 30 / 10000;
395         maxWalletAmount = totalSupply * 15 / 1000;
396         swapTokensAtAmount = totalSupply * 25 / 100000;
397 
398         buyOperationsFee = 9;
399         buyLiquidityFee = 0;
400         buyStakingFee = 3;
401         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyStakingFee;
402 
403         sellOperationsFee = 9;
404         sellLiquidityFee = 0;
405         sellStakingFee = 3;
406         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellStakingFee;
407 
408         _excludeFromMaxTransaction(newOwner, true);
409         _excludeFromMaxTransaction(address(this), true);
410         _excludeFromMaxTransaction(address(0xdead), true);
411 
412         excludeFromFees(newOwner, true);
413         excludeFromFees(address(this), true);
414         excludeFromFees(address(0xdead), true);
415 
416         operationsAddress = address(newOwner);
417         stakingAddress = address(newOwner);
418         
419         _createInitialSupply(newOwner, totalSupply);
420         transferOwnership(newOwner);
421     }
422 
423     receive() external payable {}
424     
425     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
426         require(!tradingActive, "Cannot reenable trading");
427         tradingActive = true;
428         swapEnabled = true;
429         tradingActiveBlock = block.number;
430         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
431         emit EnabledTrading();
432     }
433     
434     // remove limits after token is stable
435     function removeLimits() external onlyOwner {
436         limitsInEffect = false;
437         transferDelayEnabled = false;
438         emit RemovedLimits();
439     }
440 
441     function pauseTrading() external onlyOwner {
442         tradingActive = false;
443     }
444 
445     function unpauseTrading() external onlyOwner {
446         tradingActive = true;
447     }
448 
449     function manageRestrictedWallets(address[] calldata wallets, bool restricted) external onlyOwner {
450         for(uint256 i = 0; i < wallets.length; i++){
451             restrictedWallet[wallets[i]] = restricted;
452         }
453     }
454     
455     // disable Transfer delay
456     function disableTransferDelay() external onlyOwner {
457         transferDelayEnabled = false;
458     }
459 
460     function enableTransferDelay() external onlyOwner {
461         transferDelayEnabled = true;
462     }
463     
464     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
465         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
466         maxBuyAmount = newNum * (10**18);
467         emit UpdatedMaxBuyAmount(maxBuyAmount);
468     }
469     
470     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
471         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
472         maxSellAmount = newNum * (10**18);
473         emit UpdatedMaxSellAmount(maxSellAmount);
474     }
475 
476     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
477         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
478         maxWalletAmount = newNum * (10**18);
479         emit UpdatedMaxWalletAmount(maxWalletAmount);
480     }
481 
482     // change the minimum amount of tokens to sell from fees
483     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
484   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
485   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
486   	    swapTokensAtAmount = newAmount;
487   	}
488     
489     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
490         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
491         emit MaxTransactionExclusion(updAds, isExcluded);
492     }
493 
494     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
495         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
496         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
497         for(uint256 i = 0; i < wallets.length; i++){
498             super._transfer(msg.sender, wallets[i], amountsInTokens[i]);
499         }
500     }
501     
502     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
503         if(!isEx){
504             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
505         }
506         _isExcludedMaxTransactionAmount[updAds] = isEx;
507     }
508 
509     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
510         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
511 
512         _setAutomatedMarketMakerPair(pair, value);
513         emit SetAutomatedMarketMakerPair(pair, value);
514     }
515 
516     function _setAutomatedMarketMakerPair(address pair, bool value) private {
517         automatedMarketMakerPairs[pair] = value;
518         
519         _excludeFromMaxTransaction(pair, value);
520 
521         emit SetAutomatedMarketMakerPair(pair, value);
522     }
523 
524     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _stakingFee) external onlyOwner {
525         buyOperationsFee = _operationsFee;
526         buyLiquidityFee = _liquidityFee;
527         buyStakingFee = _stakingFee;
528         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyStakingFee;
529         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
530     }
531 
532     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _stakingFee) external onlyOwner {
533         sellOperationsFee = _operationsFee;
534         sellLiquidityFee = _liquidityFee;
535         sellStakingFee = _stakingFee;
536         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellStakingFee;
537         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
538     }
539 
540     function returnToNormalTax() external onlyOwner {
541         sellOperationsFee = 9;
542         sellLiquidityFee = 0;
543         sellStakingFee = 3;
544         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellStakingFee;
545         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
546 
547         buyOperationsFee = 9;
548         buyLiquidityFee = 0;
549         buyStakingFee = 3;
550         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyStakingFee;
551         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
552     }
553 
554     function excludeFromFees(address account, bool excluded) public onlyOwner {
555         _isExcludedFromFees[account] = excluded;
556         emit ExcludeFromFees(account, excluded);
557     }
558 
559     function _transfer(address from, address to, uint256 amount) internal override {
560 
561         require(from != address(0), "ERC20: transfer from the zero address");
562         require(to != address(0), "ERC20: transfer to the zero address");
563         require(amount > 0, "amount must be greater than 0");
564         
565         if(!tradingActive){
566             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
567         }
568 
569         if(!earlyBuyPenaltyInEffect() && blockForPenaltyEnd > 0){
570             require(!restrictedWallet[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
571         }
572         
573         if(limitsInEffect){
574             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
575                 
576                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
577                 if (transferDelayEnabled){
578                     if (to != address(dexRouter) && to != address(lpPair)){
579                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
580                         _holderLastTransferTimestamp[tx.origin] = block.number;
581                         _holderLastTransferTimestamp[to] = block.number;
582                     }
583                 }
584                  
585                 //when buy
586                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
587                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
588                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
589                 } 
590                 //when sell
591                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
592                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
593                 } 
594                 else if (!_isExcludedMaxTransactionAmount[to]){
595                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
596                 }
597             }
598         }
599 
600         uint256 contractTokenBalance = balanceOf(address(this));
601         
602         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
603 
604         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
605             swapping = true;
606             swapBack();
607             swapping = false;
608         }
609 
610         bool takeFee = true;
611         // if any account belongs to _isExcludedFromFee account then remove the fee
612         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
613             takeFee = false;
614         }
615         
616         uint256 fees = 0;
617         // only take fees on buys/sells, do not take on wallet transfers
618         if(takeFee){
619             // bot/sniper penalty.
620             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
621                 
622                 if(!restrictedWallet[to]){
623                     restrictedWallet[to] = true;
624                     botsCaught += 1;
625                     emit CaughtBot(to);
626                 }
627 
628                 fees = amount * buyTotalFees / 100;
629         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
630                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
631                 tokensForStaking += fees * buyStakingFee / buyTotalFees;
632             }
633 
634             // on sell
635             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
636                 fees = amount * sellTotalFees / 100;
637                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
638                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
639                 tokensForStaking += fees * sellStakingFee / sellTotalFees;
640             }
641 
642             // on buy
643             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
644         	    fees = amount * buyTotalFees / 100;
645         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
646                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
647                 tokensForStaking += fees * buyStakingFee / buyTotalFees;
648             }
649             
650             if(fees > 0){    
651                 super._transfer(from, address(this), fees);
652             }
653         	
654         	amount -= fees;
655         }
656 
657         super._transfer(from, to, amount);
658     }
659 
660     function earlyBuyPenaltyInEffect() public view returns (bool){
661         return block.number < blockForPenaltyEnd;
662     }
663 
664     function swapTokensForEth(uint256 tokenAmount) private {
665 
666         // generate the uniswap pair path of token -> weth
667         address[] memory path = new address[](2);
668         path[0] = address(this);
669         path[1] = dexRouter.WETH();
670 
671         _approve(address(this), address(dexRouter), tokenAmount);
672 
673         // make the swap
674         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
675             tokenAmount,
676             0, // accept any amount of ETH
677             path,
678             address(this),
679             block.timestamp
680         );
681     }
682     
683     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
684         // approve token transfer to cover all possible scenarios
685         _approve(address(this), address(dexRouter), tokenAmount);
686 
687         // add the liquidity
688         dexRouter.addLiquidityETH{value: ethAmount}(
689             address(this),
690             tokenAmount,
691             0, // slippage is unavoidable
692             0, // slippage is unavoidable
693             address(0xdead),
694             block.timestamp
695         );
696     }
697 
698     function swapBack() private {
699 
700         if(tokensForStaking > 0 && balanceOf(address(this)) >= tokensForStaking) {
701             super._transfer(address(this), address(stakingAddress), tokensForStaking);
702         }
703         tokensForStaking = 0;
704 
705         uint256 contractBalance = balanceOf(address(this));
706         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
707         
708         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
709 
710         if(contractBalance > swapTokensAtAmount * 20){
711             contractBalance = swapTokensAtAmount * 20;
712         }
713 
714         bool success;
715         
716         // Halve the amount of liquidity tokens
717         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
718         
719         swapTokensForEth(contractBalance - liquidityTokens);
720         
721         uint256 ethBalance = address(this).balance;
722         uint256 ethForLiquidity = ethBalance;
723 
724         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
725 
726         ethForLiquidity -= ethForOperations;
727             
728         tokensForLiquidity = 0;
729         tokensForOperations = 0;
730         
731         if(liquidityTokens > 0 && ethForLiquidity > 0){
732             addLiquidity(liquidityTokens, ethForLiquidity);
733         }
734 
735         (success,) = address(operationsAddress).call{value: address(this).balance}("");
736     }
737 
738     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
739         require(_token != address(0), "_token address cannot be 0");
740         require(_token != address(this), "Can't withdraw native tokens");
741         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
742         _sent = IERC20(_token).transfer(_to, _contractBalance);
743         emit TransferForeignToken(_token, _contractBalance);
744     }
745 
746     // withdraw ETH if stuck or someone sends to the address
747     function withdrawStuckETH() external onlyOwner {
748         bool success;
749         (success,) = address(owner()).call{value: address(this).balance}("");
750     }
751 
752     function setOperationsAddress(address _operationsAddress) external onlyOwner {
753         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
754         operationsAddress = payable(_operationsAddress);
755     }
756 
757     function setStakingAddress(address _stakingAddress) external onlyOwner {
758         require(_stakingAddress != address(0), "_stakingAddress address cannot be 0");
759         stakingAddress = payable(_stakingAddress);
760     }
761 
762     // force Swap back if slippage issues.
763     function forceSwapBack() external onlyOwner {
764         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
765         swapping = true;
766         swapBack();
767         swapping = false;
768         emit OwnerForcedSwapBack(block.timestamp);
769     }
770 }