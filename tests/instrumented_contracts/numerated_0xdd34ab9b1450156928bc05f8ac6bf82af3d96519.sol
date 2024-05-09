1 // SPDX-License-Identifier: MIT                                                                               
2 
3 
4 pragma solidity 0.8.15;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 interface IERC20Metadata is IERC20 {
93     /**
94      * @dev Returns the name of the token.
95      */
96     function name() external view returns (string memory);
97 
98     /**
99      * @dev Returns the symbol of the token.
100      */
101     function symbol() external view returns (string memory);
102 
103     /**
104      * @dev Returns the decimals places of the token.
105      */
106     function decimals() external view returns (uint8);
107 }
108 
109 contract ERC20 is Context, IERC20, IERC20Metadata {
110     mapping(address => uint256) private _balances;
111 
112     mapping(address => mapping(address => uint256)) private _allowances;
113 
114     uint256 private _totalSupply;
115 
116     string private _name;
117     string private _symbol;
118 
119     constructor(string memory name_, string memory symbol_) {
120         _name = name_;
121         _symbol = symbol_;
122     }
123 
124     function name() public view virtual override returns (string memory) {
125         return _name;
126     }
127 
128     function symbol() public view virtual override returns (string memory) {
129         return _symbol;
130     }
131 
132     function decimals() public view virtual override returns (uint8) {
133         return 18;
134     }
135 
136     function totalSupply() public view virtual override returns (uint256) {
137         return _totalSupply;
138     }
139 
140     function balanceOf(address account) public view virtual override returns (uint256) {
141         return _balances[account];
142     }
143 
144     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
145         _transfer(_msgSender(), recipient, amount);
146         return true;
147     }
148 
149     function allowance(address owner, address spender) public view virtual override returns (uint256) {
150         return _allowances[owner][spender];
151     }
152 
153     function approve(address spender, uint256 amount) public virtual override returns (bool) {
154         _approve(_msgSender(), spender, amount);
155         return true;
156     }
157 
158     function transferFrom(
159         address sender,
160         address recipient,
161         uint256 amount
162     ) public virtual override returns (bool) {
163         _transfer(sender, recipient, amount);
164 
165         uint256 currentAllowance = _allowances[sender][_msgSender()];
166         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
167         unchecked {
168             _approve(sender, _msgSender(), currentAllowance - amount);
169         }
170 
171         return true;
172     }
173 
174     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
175         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
176         return true;
177     }
178 
179     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
180         uint256 currentAllowance = _allowances[_msgSender()][spender];
181         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
182         unchecked {
183             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
184         }
185 
186         return true;
187     }
188 
189     function _transfer(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) internal virtual {
194         require(sender != address(0), "ERC20: transfer from the zero address");
195         require(recipient != address(0), "ERC20: transfer to the zero address");
196 
197         uint256 senderBalance = _balances[sender];
198         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
199         unchecked {
200             _balances[sender] = senderBalance - amount;
201         }
202         _balances[recipient] += amount;
203 
204         emit Transfer(sender, recipient, amount);
205     }
206 
207     function _createInitialSupply(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: mint to the zero address");
209 
210         _totalSupply += amount;
211         _balances[account] += amount;
212         emit Transfer(address(0), account, amount);
213     }
214 
215     function _approve(
216         address owner,
217         address spender,
218         uint256 amount
219     ) internal virtual {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222 
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 }
227 
228 contract Ownable is Context {
229     address private _owner;
230 
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232     
233     constructor () {
234         address msgSender = _msgSender();
235         _owner = msgSender;
236         emit OwnershipTransferred(address(0), msgSender);
237     }
238 
239     function owner() public view returns (address) {
240         return _owner;
241     }
242 
243     modifier onlyOwner() {
244         require(_owner == _msgSender(), "Ownable: caller is not the owner");
245         _;
246     }
247 
248     function renounceOwnership() external virtual onlyOwner {
249         emit OwnershipTransferred(_owner, address(0));
250         _owner = address(0);
251     }
252 
253     function transferOwnership(address newOwner) public virtual onlyOwner {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 }
259 
260 interface IDexRouter {
261     function factory() external pure returns (address);
262     function WETH() external pure returns (address);
263     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
264     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
265     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
266     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
267     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
268 }
269 
270 interface IDexFactory {
271     function createPair(address tokenA, address tokenB) external returns (address pair);
272 }
273 
274 contract SHANGHAI is ERC20, Ownable {
275 
276     uint256 public maxBuyAmount;
277     uint256 public maxSellAmount;
278     uint256 public maxWallet;
279 
280     IDexRouter public dexRouter;
281     address public lpPair;
282 
283     bool private swapping;
284     uint256 public swapTokensAtAmount;
285 
286     address public treasuryAddress;
287 
288     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
289     uint256 public blockForPenaltyEnd;
290     mapping (address => bool) public boughtEarly;
291     address[] public earlyBuyers;
292     uint256 public botsCaught;
293 
294     bool public limitsInEffect = true;
295     bool public tradingActive = false;
296     bool public swapEnabled = false;
297 
298     mapping (address => bool) public privateSaleWallets;
299     mapping (address => uint256) public nextPrivateWalletSellDate;
300     uint256 public maxPrivSaleSell = 1 ether;
301     
302      // Anti-bot and anti-whale mappings and variables
303     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
304     bool public transferDelayEnabled = true;
305 
306     uint256 public buyTotalFees;
307     uint256 public buyTreasuryFee;
308     uint256 public buyLiquidityFee;
309     uint256 public buyBurnFee;
310 
311     uint256 public sellTotalFees;
312     uint256 public sellTreasuryFee;
313     uint256 public sellLiquidityFee;
314     uint256 public sellBurnFee;
315 
316     uint256 public constant FEE_DIVISOR = 10000;
317 
318     uint256 public tokensForTreasury;
319     uint256 public tokensForLiquidity;
320 
321     uint256 public lpWithdrawRequestTimestamp;
322     uint256 public lpWithdrawRequestDuration = 1 seconds;
323     bool public lpWithdrawRequestPending;
324     uint256 public lpPercToWithDraw;
325 
326     uint256 public percentForLPBurn = 5; // 5 = .05%
327     bool public lpBurnEnabled = false;
328     uint256 public lpBurnFrequency = 1800 seconds;
329     uint256 public lastLpBurnTime;
330     
331     uint256 public manualBurnFrequency = 30 seconds;
332     uint256 public lastManualLpBurnTime;
333     
334     /******************/
335 
336     // exlcude from fees and max transaction amount
337     mapping (address => bool) private _isExcludedFromFees;
338     mapping (address => bool) public _isExcludedMaxTransactionAmount;
339 
340     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
341     // could be subject to a maximum transfer amount
342     mapping (address => bool) public automatedMarketMakerPairs;
343 
344     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
345 
346     event EnabledTrading();
347 
348     event RemovedLimits();
349 
350     event ExcludeFromFees(address indexed account, bool isExcluded);
351 
352     event UpdatedMaxBuyAmount(uint256 newAmount);
353 
354     event UpdatedMaxSellAmount(uint256 newAmount);
355 
356     event UpdatedMaxWalletAmount(uint256 newAmount);
357 
358     event UpdatedTreasuryAddress(address indexed newWallet);
359 
360     event UpdatedDevAddress(address indexed newWallet);
361 
362     event MaxTransactionExclusion(address _address, bool excluded);
363 
364     event OwnerForcedSwapBack(uint256 timestamp);
365 
366     event CaughtEarlyBuyer(address sniper);
367 
368     event SwapAndLiquify(
369         uint256 tokensSwapped,
370         uint256 ethReceived,
371         uint256 tokensIntoLiquidity
372     );
373 
374     event AutoBurnLP(uint256 indexed tokensBurned);
375 
376     event ManualBurnLP(uint256 indexed tokensBurned);
377 
378     event TransferForeignToken(address token, uint256 amount);
379 
380     event UpdatedPrivateMaxSell(uint256 amount);
381 
382     event RequestedLPWithdraw();
383     
384     event WithdrewLPForMigration();
385 
386     event CanceledLpWithdrawRequest();
387 
388     constructor() ERC20("SHANGHAI", "HAI") payable {
389         
390         address newOwner = msg.sender; // can leave alone if owner is deployer.
391         address _dexRouter;
392 
393         if(block.chainid == 1){
394             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
395         } else if(block.chainid == 5){
396             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
397         } else if(block.chainid == 56){
398             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
399         } else if(block.chainid == 97){
400             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
401         } else if(block.chainid == 42161){
402             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
403         } else {
404             revert("Chain not configured");
405         }
406 
407         // initialize router
408         dexRouter = IDexRouter(_dexRouter);
409 
410         uint256 totalSupply = 1 * 1e8 * (10 ** decimals());
411         
412         maxBuyAmount = totalSupply * 1 / 100;
413         maxSellAmount = totalSupply * 1 / 100;
414         maxWallet = totalSupply * 1 / 100;
415         swapTokensAtAmount = totalSupply * 25 / 100000;
416 
417         buyTreasuryFee = 400;
418         buyLiquidityFee = 100;
419         buyBurnFee = 0;
420         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyBurnFee;
421 
422         sellTreasuryFee = 1900;
423         sellLiquidityFee = 600;
424         sellBurnFee = 0;
425         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellBurnFee;
426 
427         treasuryAddress = address(msg.sender);
428 
429         _excludeFromMaxTransaction(newOwner, true);
430         _excludeFromMaxTransaction(address(this), true);
431         _excludeFromMaxTransaction(address(0xdead), true);
432         _excludeFromMaxTransaction(address(treasuryAddress), true);
433         _excludeFromMaxTransaction(address(dexRouter), true);
434 
435         excludeFromFees(newOwner, true);
436         excludeFromFees(address(this), true);
437         excludeFromFees(address(0xdead), true);
438         excludeFromFees(address(treasuryAddress), true);
439         excludeFromFees(address(dexRouter), true);
440 
441         
442         _createInitialSupply(address(this), totalSupply * 99 / 100);  // update with % for LP
443         _createInitialSupply(newOwner, totalSupply - balanceOf(address(this)));
444         transferOwnership(newOwner);
445     }
446 
447     receive() external payable {}
448     
449     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
450         require(!tradingActive, "Cannot reenable trading");
451         require(blocksForPenalty <= 50, "Cannot make penalty blocks more than 50");
452         tradingActive = true;
453         swapEnabled = true;
454         tradingActiveBlock = block.number;
455         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
456         emit EnabledTrading();
457     }
458     
459     // remove limits after token is stable
460     function removeLimits() external onlyOwner {
461         limitsInEffect = false;
462         transferDelayEnabled = false;
463         maxBuyAmount = totalSupply();
464         maxSellAmount = totalSupply();
465         emit RemovedLimits();
466     }
467 
468     function getEarlyBuyers() external view returns (address[] memory){
469         return earlyBuyers;
470     }
471 
472     function massRemoveBoughtEarly(address[] calldata accounts) external onlyOwner {
473         for(uint256 i = 0; i < accounts.length; i++){
474             boughtEarly[accounts[i]] = false;
475         }
476     }
477 
478     function removeBoughtEarly(address wallet) external onlyOwner {
479         require(boughtEarly[wallet], "Wallet is already not flagged.");
480         boughtEarly[wallet] = false;
481     }
482 
483     function emergencyUpdateRouter(address router) external onlyOwner {
484         require(!tradingActive, "Cannot update after trading is functional");
485         dexRouter = IDexRouter(router);
486     }
487     
488     // disable Transfer delay - cannot be reenabled
489     function disableTransferDelay() external onlyOwner {
490         transferDelayEnabled = false;
491     }
492     
493     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
494         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max buy amount lower than 0.1%");
495         maxBuyAmount = newNum * (10 ** decimals());
496         emit UpdatedMaxBuyAmount(maxBuyAmount);
497     }
498     
499     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
500         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max sell amount lower than 0.1%");
501         maxSellAmount = newNum * (10 ** decimals());
502         emit UpdatedMaxSellAmount(maxSellAmount);
503     }
504 
505     function updateMaxWallet(uint256 newNum) external onlyOwner {
506         require(newNum >= (totalSupply() * 1 / 100) / (10 ** decimals()), "Cannot set max wallet amount lower than %");
507         maxWallet = newNum * (10 ** decimals());
508         emit UpdatedMaxWalletAmount(maxWallet);
509     }
510 
511     // change the minimum amount of tokens to sell from fees
512     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
513   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
514   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
515   	    swapTokensAtAmount = newAmount;
516   	}
517     
518     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
519         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
520         emit MaxTransactionExclusion(updAds, isExcluded);
521     }
522      
523     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
524         if(!isEx){
525             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
526         }
527         _isExcludedMaxTransactionAmount[updAds] = isEx;
528     }
529 
530     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
531         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
532         _setAutomatedMarketMakerPair(pair, value);
533         emit SetAutomatedMarketMakerPair(pair, value);
534     }
535 
536     function _setAutomatedMarketMakerPair(address pair, bool value) private {
537         automatedMarketMakerPairs[pair] = value;
538         _excludeFromMaxTransaction(pair, value);
539         emit SetAutomatedMarketMakerPair(pair, value);
540     }
541 
542     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
543         buyTreasuryFee = _treasuryFee;
544         buyLiquidityFee = _liquidityFee;
545         buyBurnFee = _burnFee;
546         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyBurnFee;
547         require(buyTotalFees <= 30 * FEE_DIVISOR / 100, "Must keep fees at 10% or less");
548     }
549 
550     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee,uint256 _burnFee) external onlyOwner {
551         sellTreasuryFee = _treasuryFee;
552         sellLiquidityFee = _liquidityFee;
553         sellBurnFee = _burnFee;
554         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellBurnFee;
555         require(sellTotalFees <= 30 * FEE_DIVISOR / 100, "Must keep fees at 20% or less");
556     }
557 
558     function massExcludeFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
559         for(uint256 i = 0; i < accounts.length; i++){
560             _isExcludedFromFees[accounts[i]] = excluded;
561             emit ExcludeFromFees(accounts[i], excluded);
562         }
563     }
564 
565     function excludeFromFees(address account, bool excluded) public onlyOwner {
566         _isExcludedFromFees[account] = excluded;
567         emit ExcludeFromFees(account, excluded);
568     }
569 
570     function _transfer(address from, address to, uint256 amount) internal override {
571 
572         require(from != address(0), "ERC20: transfer from the zero address");
573         require(to != address(0), "ERC20: transfer to the zero address");
574         require(amount > 0, "amount must be greater than 0");
575         
576         if(!tradingActive){
577             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
578         }
579 
580         if(!earlyBuyPenaltyInEffect() && tradingActive){
581             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
582         }
583 
584         if(privateSaleWallets[from]){
585             if(automatedMarketMakerPairs[to]){
586                 //enforce max sell restrictions.
587                 require(nextPrivateWalletSellDate[from] <= block.timestamp, "Cannot sell yet");
588                 require(amount <= getPrivateSaleMaxSell(), "Attempting to sell over max sell amount.  Check max.");
589                 nextPrivateWalletSellDate[from] = block.timestamp + 24 hours;
590             } else if(!_isExcludedFromFees[to]){
591                 revert("Private sale cannot transfer and must sell only or transfer to a whitelisted address.");
592             }
593         }
594         
595         if(limitsInEffect){
596             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
597                 
598                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
599                 if (transferDelayEnabled){
600                     if (to != address(dexRouter) && to != address(lpPair)){
601                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
602                         _holderLastTransferTimestamp[tx.origin] = block.number;
603                         _holderLastTransferTimestamp[to] = block.number;
604                     }
605                 }
606                  
607                 //when buy
608                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
609                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
610                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
611                 } 
612                 //when sell
613                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
614                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
615                 }
616                 else if (!_isExcludedMaxTransactionAmount[to]) {
617                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
618                 }
619             }
620         }
621 
622         uint256 contractTokenBalance = balanceOf(address(this));
623         
624         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
625 
626         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
627             swapping = true;
628             swapBack();
629             swapping = false;
630         }
631 
632         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
633             autoBurnLiquidityPairTokens();
634         }
635 
636         bool takeFee = true;
637         // if any account belongs to _isExcludedFromFee account then remove the fee
638         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
639             takeFee = false;
640         }
641         
642         uint256 fees = 0;
643         uint256 tokensToBurn = 0;
644 
645         // only take fees on buys/sells, do not take on wallet transfers
646         if(takeFee){
647             // bot/sniper penalty.
648             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && !_isExcludedFromFees[to] && buyTotalFees > 0){
649                 
650                 if(!earlyBuyPenaltyInEffect()){
651                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
652                     maxBuyAmount -= 1;
653                 }
654 
655                 if(!boughtEarly[to]){
656                     boughtEarly[to] = true;
657                     botsCaught += 1;
658                     earlyBuyers.push(to);
659                     emit CaughtEarlyBuyer(to);
660                 }
661 
662                 fees = amount * buyTotalFees / FEE_DIVISOR;
663         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
664                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
665                 tokensToBurn = fees * buyBurnFee / buyTotalFees;
666             }
667 
668             // on sell
669             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
670                 fees = amount * sellTotalFees / FEE_DIVISOR;
671                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
672                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
673                 tokensToBurn = fees * sellBurnFee / buyTotalFees;
674             }
675 
676             // on buy
677             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
678         	    fees = amount * buyTotalFees / FEE_DIVISOR;
679         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
680                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
681                 tokensToBurn = fees * buyBurnFee / buyTotalFees;
682             }
683             
684             if(fees > 0){    
685                 super._transfer(from, address(this), fees);
686                 if(tokensToBurn > 0){
687                     super._transfer(address(this), address(0xdead), tokensToBurn);
688                 }
689             }
690         	
691         	amount -= fees;
692         }
693 
694         super._transfer(from, to, amount);
695     }
696 
697     function earlyBuyPenaltyInEffect() public view returns (bool){
698         return block.number < blockForPenaltyEnd;
699     }
700 
701     function swapTokensForEth(uint256 tokenAmount) private {
702 
703         // generate the uniswap pair path of token -> weth
704         address[] memory path = new address[](2);
705         path[0] = address(this);
706         path[1] = dexRouter.WETH();
707 
708         _approve(address(this), address(dexRouter), tokenAmount);
709 
710         // make the swap
711         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
712             tokenAmount,
713             0, // accept any amount of ETH
714             path,
715             address(this),
716             block.timestamp
717         );
718     }
719     
720     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
721         // approve token transfer to cover all possible scenarios
722         _approve(address(this), address(dexRouter), tokenAmount);
723 
724         // add the liquidity
725         dexRouter.addLiquidityETH{value: ethAmount}(
726             address(this),
727             tokenAmount,
728             0, // slippage is unavoidable
729             0, // slippage is unavoidable
730             address(this),
731             block.timestamp
732         );
733     }
734 
735     function swapBack() private {
736 
737         uint256 contractBalance = balanceOf(address(this));
738         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
739         
740         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
741 
742         if(contractBalance > swapTokensAtAmount * 10){
743             contractBalance = swapTokensAtAmount * 10;
744         }
745 
746         bool success;
747         
748         // Halve the amount of liquidity tokens
749         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
750         
751         swapTokensForEth(contractBalance - liquidityTokens); 
752         
753         uint256 ethBalance = address(this).balance;
754         uint256 ethForLiquidity = ethBalance;
755 
756         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
757 
758         ethForLiquidity -= ethForTreasury;
759             
760         tokensForLiquidity = 0;
761         tokensForTreasury = 0;
762         
763         if(liquidityTokens > 0 && ethForLiquidity > 0){
764             addLiquidity(liquidityTokens, ethForLiquidity);
765         }
766 
767         (success,) = address(treasuryAddress).call{value: address(this).balance}("");
768     }
769 
770     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
771         require(_token != address(0), "_token address cannot be 0");
772         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
773         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
774         _sent = IERC20(_token).transfer(_to, _contractBalance);
775         emit TransferForeignToken(_token, _contractBalance);
776     }
777 
778     // withdraw ETH if stuck or someone sends to the address
779     function withdrawStuckETH() external onlyOwner {
780         bool success;
781         (success,) = address(msg.sender).call{value: address(this).balance}("");
782     }
783 
784     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
785         require(_treasuryAddress != address(0), "_treasuryAddress address cannot be 0");
786         treasuryAddress = payable(_treasuryAddress);
787         emit UpdatedTreasuryAddress(_treasuryAddress);
788     }
789 
790     // force Swap back if slippage issues.
791     function forceSwapBack() external onlyOwner {
792         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
793         swapping = true;
794         swapBack();
795         swapping = false;
796         emit OwnerForcedSwapBack(block.timestamp);
797     }
798 
799     function getPrivateSaleMaxSell() public view returns (uint256){
800         address[] memory path = new address[](2);
801         path[0] = dexRouter.WETH();
802         path[1] = address(this);
803         
804         uint256[] memory amounts = new uint256[](2);
805         amounts = dexRouter.getAmountsOut(maxPrivSaleSell, path);
806         return amounts[1] + (amounts[1] * (sellLiquidityFee + sellTreasuryFee))/100;
807     }
808 
809     function setPrivateSaleMaxSell(uint256 amount) external onlyOwner{
810         require(amount >= 10 && amount <= 50000, "Must set between 0.1 and 500 BNB");
811         maxPrivSaleSell = amount * 1e16;
812         emit UpdatedPrivateMaxSell(amount);
813     }
814 
815     function launch(address[] memory wallets, uint256[] memory amountsInTokens, uint256 blocksForPenalty) external onlyOwner {
816         require(!tradingActive, "Trading is already active, cannot relaunch.");
817         require(blocksForPenalty < 50, "Cannot make penalty blocks more than 50");
818 
819         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
820         require(wallets.length < 300, "Can only airdrop 300 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
821         for(uint256 i = 0; i < wallets.length; i++){
822             address wallet = wallets[i];
823             privateSaleWallets[wallet] = true;
824             nextPrivateWalletSellDate[wallet] = block.timestamp + 24 hours;
825             uint256 amount = amountsInTokens[i] * (10 ** decimals());
826             super._transfer(msg.sender, wallet, amount);
827         }
828 
829         //standard enable trading
830         tradingActive = true;
831         swapEnabled = true;
832         tradingActiveBlock = block.number;
833         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
834         emit EnabledTrading();
835 
836         // create pair
837         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
838         _excludeFromMaxTransaction(address(lpPair), true);
839         _setAutomatedMarketMakerPair(address(lpPair), true);
840    
841         // add the liquidity
842 
843         require(address(this).balance > 0, "Must have ETH on contract to launch");
844 
845         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
846 
847         _approve(address(this), address(dexRouter), balanceOf(address(this)));
848         dexRouter.addLiquidityETH{value: address(this).balance}(
849             address(this),
850             balanceOf(address(this)),
851             0, // slippage is unavoidable
852             0, // slippage is unavoidable
853             address(this),
854             block.timestamp
855         );
856     }
857 
858     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
859         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
860         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
861         lpBurnFrequency = _frequencyInSeconds;
862         percentForLPBurn = _percent;
863         lpBurnEnabled = _Enabled;
864     }
865     
866     function autoBurnLiquidityPairTokens() internal {
867         
868         lastLpBurnTime = block.timestamp;
869         
870         lastManualLpBurnTime = block.timestamp;
871         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
872         uint256 tokenBalance = balanceOf(address(this));
873         uint256 lpAmount = lpBalance * percentForLPBurn / 10000;
874         uint256 initialEthBalance = address(this).balance;
875 
876         // approve token transfer to cover all possible scenarios
877         IERC20(lpPair).approve(address(dexRouter), lpAmount);
878 
879         // remove the liquidity
880         dexRouter.removeLiquidityETH(
881             address(this),
882             lpAmount,
883             1, // slippage is unavoidable
884             1, // slippage is unavoidable
885             address(this),
886             block.timestamp
887         );
888 
889         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
890         if(deltaTokenBalance > 0){
891             super._transfer(address(this), address(0xdead), deltaTokenBalance);
892         }
893 
894         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
895 
896         if(deltaEthBalance > 0){
897             buyBackTokens(deltaEthBalance);
898         }
899 
900         emit AutoBurnLP(lpAmount);
901     }
902 
903     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
904         require(percent <=2000, "May not burn more than 20% of contract's LP at a time");
905         require(lastManualLpBurnTime <= block.timestamp - manualBurnFrequency, "Burn too soon");
906         lastManualLpBurnTime = block.timestamp;
907         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
908         uint256 tokenBalance = balanceOf(address(this));
909         uint256 lpAmount = lpBalance * percent / 10000;
910         uint256 initialEthBalance = address(this).balance;
911 
912         // approve token transfer to cover all possible scenarios
913         IERC20(lpPair).approve(address(dexRouter), lpAmount);
914 
915         // remove the liquidity
916         dexRouter.removeLiquidityETH(
917             address(this),
918             lpAmount,
919             1, // slippage is unavoidable
920             1, // slippage is unavoidable
921             address(this),
922             block.timestamp
923         );
924 
925         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
926         if(deltaTokenBalance > 0){
927             super._transfer(address(this), address(0xdead), deltaTokenBalance);
928         }
929 
930         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
931 
932         if(deltaEthBalance > 0){
933             buyBackTokens(deltaEthBalance);
934         }
935 
936         emit ManualBurnLP(lpAmount);
937     }
938 
939     function buyBackTokens(uint256 amountInWei) internal {
940         address[] memory path = new address[](2);
941         path[0] = dexRouter.WETH();
942         path[1] = address(this);
943 
944         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
945             0,
946             path,
947             address(0xdead),
948             block.timestamp
949         );
950     }
951 
952     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
953         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
954         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
955         lpWithdrawRequestTimestamp = block.timestamp;
956         lpWithdrawRequestPending = true;
957         lpPercToWithDraw = percToWithdraw;
958         emit RequestedLPWithdraw();
959     }
960 
961     function nextAvailableLpWithdrawDate() public view returns (uint256){
962         if(lpWithdrawRequestPending){
963             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
964         }
965         else {
966             return 0;  // 0 means no open requests
967         }
968     }
969 
970     function withdrawRequestedLP() external onlyOwner {
971         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
972         lpWithdrawRequestTimestamp = 0;
973         lpWithdrawRequestPending = false;
974 
975         uint256 amtToWithdraw = IERC20(address(lpPair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
976         
977         lpPercToWithDraw = 0;
978 
979         IERC20(lpPair).transfer(msg.sender, amtToWithdraw);
980     }
981 
982     function cancelLPWithdrawRequest() external onlyOwner {
983         lpWithdrawRequestPending = false;
984         lpPercToWithDraw = 0;
985         lpWithdrawRequestTimestamp = 0;
986         emit CanceledLpWithdrawRequest();
987     }
988 }