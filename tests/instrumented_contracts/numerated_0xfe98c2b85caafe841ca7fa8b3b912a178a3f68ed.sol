1 //https://twitter.com/RedRabbitERC
2 
3 // SPDX-License-Identifier: MIT                                                                               
4                                                     
5 pragma solidity 0.8.17;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 contract ERC20 is Context, IERC20, IERC20Metadata {
111     mapping(address => uint256) private _balances;
112 
113     mapping(address => mapping(address => uint256)) private _allowances;
114 
115     uint256 private _totalSupply;
116 
117     string private _name;
118     string private _symbol;
119 
120     constructor(string memory name_, string memory symbol_) {
121         _name = name_;
122         _symbol = symbol_;
123     }
124 
125     function name() public view virtual override returns (string memory) {
126         return _name;
127     }
128 
129     function symbol() public view virtual override returns (string memory) {
130         return _symbol;
131     }
132 
133     function decimals() public view virtual override returns (uint8) {
134         return 18;
135     }
136 
137     function totalSupply() public view virtual override returns (uint256) {
138         return _totalSupply;
139     }
140 
141     function balanceOf(address account) public view virtual override returns (uint256) {
142         return _balances[account];
143     }
144 
145     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
146         _transfer(_msgSender(), recipient, amount);
147         return true;
148     }
149 
150     function allowance(address owner, address spender) public view virtual override returns (uint256) {
151         return _allowances[owner][spender];
152     }
153 
154     function approve(address spender, uint256 amount) public virtual override returns (bool) {
155         _approve(_msgSender(), spender, amount);
156         return true;
157     }
158 
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) public virtual override returns (bool) {
164         _transfer(sender, recipient, amount);
165 
166         uint256 currentAllowance = _allowances[sender][_msgSender()];
167         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
168         unchecked {
169             _approve(sender, _msgSender(), currentAllowance - amount);
170         }
171 
172         return true;
173     }
174 
175     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
176         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
177         return true;
178     }
179 
180     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
181         uint256 currentAllowance = _allowances[_msgSender()][spender];
182         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
183         unchecked {
184             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
185         }
186 
187         return true;
188     }
189 
190     function _transfer(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) internal virtual {
195         require(sender != address(0), "ERC20: transfer from the zero address");
196         require(recipient != address(0), "ERC20: transfer to the zero address");
197 
198         uint256 senderBalance = _balances[sender];
199         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
200         unchecked {
201             _balances[sender] = senderBalance - amount;
202         }
203         _balances[recipient] += amount;
204 
205         emit Transfer(sender, recipient, amount);
206     }
207 
208     function _createInitialSupply(address account, uint256 amount) internal virtual {
209         require(account != address(0), "ERC20: mint to the zero address");
210 
211         _totalSupply += amount;
212         _balances[account] += amount;
213         emit Transfer(address(0), account, amount);
214     }
215 
216     function _approve(
217         address owner,
218         address spender,
219         uint256 amount
220     ) internal virtual {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223 
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 }
228 
229 contract Ownable is Context {
230     address private _owner;
231 
232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233     
234     constructor () {
235         address msgSender = _msgSender();
236         _owner = msgSender;
237         emit OwnershipTransferred(address(0), msgSender);
238     }
239 
240     function owner() public view returns (address) {
241         return _owner;
242     }
243 
244     modifier onlyOwner() {
245         require(_owner == _msgSender(), "Ownable: caller is not the owner");
246         _;
247     }
248 
249     function renounceOwnership() external virtual onlyOwner {
250         emit OwnershipTransferred(_owner, address(0));
251         _owner = address(0);
252     }
253 
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         emit OwnershipTransferred(_owner, newOwner);
257         _owner = newOwner;
258     }
259 }
260 
261 interface IDexRouter {
262     function factory() external pure returns (address);
263     function WETH() external pure returns (address);
264     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
265     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
266     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
267     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
268     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
269 }
270 
271 interface IDexFactory {
272     function createPair(address tokenA, address tokenB) external returns (address pair);
273 }
274 
275 contract RR is ERC20, Ownable {
276 
277     uint256 public maxBuyAmount;
278     uint256 public maxSellAmount;
279     uint256 public maxWallet;
280 
281     IDexRouter public dexRouter;
282     address public lpPair;
283 
284     bool private swapping;
285     uint256 public swapTokensAtAmount;
286 
287     address public operationsAddress;
288     address public futureOwner;
289 
290     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
291 
292     bool public limitsInEffect = true;
293     bool public tradingActive = false;
294     bool public swapEnabled = false;
295     
296      // Anti-bot and anti-whale mappings and variables
297     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
298     bool public transferDelayEnabled = true;
299 
300     uint256 public buyTotalFees;
301     uint256 public buyOperationsFee;
302     uint256 public buyLiquidityFee;
303 
304     uint256 public sellTotalFees;
305     uint256 public sellOperationsFee;
306     uint256 public sellLiquidityFee;
307 
308     uint256 public constant FEE_DIVISOR = 10000;
309 
310     uint256 public tokensForOperations;
311     uint256 public tokensForLiquidity;
312     uint256 public percentForLPBurn = 25; // 25 = .25%
313     bool public lpBurnEnabled = false;
314     uint256 public lpBurnFrequency = 3600 seconds;
315     uint256 public lastLpBurnTime;
316     
317     uint256 public manualBurnFrequency = 30 minutes;
318     uint256 public lastManualLpBurnTime;
319 
320     
321     /******************/
322 
323     // exlcude from fees and max transaction amount
324     mapping (address => bool) private _isExcludedFromFees;
325     mapping (address => bool) public _isExcludedMaxTransactionAmount;
326 
327     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
328     // could be subject to a maximum transfer amount
329     mapping (address => bool) public automatedMarketMakerPairs;
330 
331     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
332 
333     event EnabledTrading();
334 
335     event RemovedLimits();
336 
337     event ExcludeFromFees(address indexed account, bool isExcluded);
338 
339     event UpdatedMaxBuyAmount(uint256 newAmount);
340 
341     event UpdatedMaxSellAmount(uint256 newAmount);
342 
343     event UpdatedMaxWalletAmount(uint256 newAmount);
344 
345     event UpdatedOperationsAddress(address indexed newWallet);
346 
347     event MaxTransactionExclusion(address _address, bool excluded);
348 
349     event OwnerForcedSwapBack(uint256 timestamp);
350 
351     event CaughtEarlyBuyer(address sniper);
352 
353     event SwapAndLiquify(
354         uint256 tokensSwapped,
355         uint256 ethReceived,
356         uint256 tokensIntoLiquidity
357     );
358 
359     event AutoBurnLP(uint256 indexed tokensBurned);
360 
361     event ManualBurnLP(uint256 indexed tokensBurned);
362 
363     event TransferForeignToken(address token, uint256 amount);
364 
365     constructor() ERC20("Red Rabbit", "RR") payable {
366         
367         address newOwner = msg.sender; // can leave alone if owner is deployer.
368         address _dexRouter;
369 
370         if(block.chainid == 1){
371             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
372         } else if(block.chainid == 5){
373             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Goerli ETH: Uniswap V2
374         } else if(block.chainid == 56){
375             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
376         } else if(block.chainid == 97){
377             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain Testnet: PCS V2
378         } else if(block.chainid == 42161){
379             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
380         } else {
381             revert("Chain not configured");
382         }
383 
384         // initialize router
385         dexRouter = IDexRouter(_dexRouter);
386 
387         uint256 totalSupply = 2_320_232_023 * (10 ** decimals());
388         
389         maxBuyAmount = totalSupply * 25 / 10000;
390         maxSellAmount = totalSupply * 50 / 10000;
391         maxWallet = totalSupply * 50 / 10000;
392         swapTokensAtAmount = totalSupply * 5 / 10000;
393 
394         buyOperationsFee = 50;
395         buyLiquidityFee = 150;
396         buyTotalFees = buyOperationsFee + buyLiquidityFee;
397 
398         sellOperationsFee = 7000;
399         sellLiquidityFee = 500;
400         sellTotalFees = sellOperationsFee + sellLiquidityFee;
401 
402         if(block.chainid == 1){
403             operationsAddress = address(msg.sender); // update
404             futureOwner = address(msg.sender); // update if necessary
405         } else {
406             operationsAddress = address(msg.sender);
407             futureOwner = address(msg.sender);
408         }
409 
410         _excludeFromMaxTransaction(newOwner, true);
411         _excludeFromMaxTransaction(address(this), true);
412         _excludeFromMaxTransaction(address(0xdead), true);
413         _excludeFromMaxTransaction(address(operationsAddress), true);
414         _excludeFromMaxTransaction(address(dexRouter), true);
415         _excludeFromMaxTransaction(address(futureOwner), true);
416 
417         excludeFromFees(newOwner, true);
418         excludeFromFees(address(this), true);
419         excludeFromFees(address(0xdead), true);
420         excludeFromFees(address(operationsAddress), true);
421         excludeFromFees(address(dexRouter), true);
422         excludeFromFees(address(futureOwner), true);
423 
424         
425         // _createInitialSupply(address(this), totalSupply * 66 / 100);  // update with % for LP and use this if using launch function
426         _createInitialSupply(futureOwner, totalSupply - balanceOf(address(this)));
427         transferOwnership(newOwner);
428     }
429 
430     receive() external payable {}
431     
432     function enableTrading(address _lpPair) external onlyOwner {
433         require(!tradingActive, "Cannot reenable trading");
434         tradingActive = true;
435         swapEnabled = true;
436         tradingActiveBlock = block.number;
437         
438         // set pair
439         require(_lpPair != address(0) && balanceOf(_lpPair)  > 0, "Lp pair not valid for launch");
440         lpPair = _lpPair;
441         _excludeFromMaxTransaction(address(lpPair), true);
442         _setAutomatedMarketMakerPair(address(lpPair), true);
443 
444         emit EnabledTrading();
445     }
446     
447     // remove limits after token is stable
448     function removeLimits() external onlyOwner {
449 
450         limitsInEffect = false;
451         transferDelayEnabled = false;
452         maxBuyAmount = totalSupply();
453         maxSellAmount = totalSupply();
454         maxWallet = totalSupply();
455 
456         emit RemovedLimits();
457     }
458 
459     // disable Transfer delay - cannot be reenabled
460     function disableTransferDelay() external onlyOwner {
461         transferDelayEnabled = false;
462     }
463     
464     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
465         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max buy amount lower than 0.1%");
466         maxBuyAmount = newNum * (10 ** decimals());
467         emit UpdatedMaxBuyAmount(maxBuyAmount);
468     }
469     
470     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
471         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max sell amount lower than 0.1%");
472         maxSellAmount = newNum * (10 ** decimals());
473         emit UpdatedMaxSellAmount(maxSellAmount);
474     }
475 
476     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
477         require(newNum >= (totalSupply() * 1 / 100) / (10 ** decimals()), "Cannot set max sell amount lower than 1%");
478         maxWallet = newNum * (10 ** decimals());
479         emit UpdatedMaxWalletAmount(maxWallet);
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
496         require(wallets.length < 300, "Can only airdrop 300 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
497         for(uint256 i = 0; i < wallets.length; i++){
498             address wallet = wallets[i];
499             uint256 amount = amountsInTokens[i];
500             super._transfer(msg.sender, wallet, amount);
501         }
502     }
503     
504     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
505         if(!isEx){
506             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
507         }
508         _isExcludedMaxTransactionAmount[updAds] = isEx;
509     }
510 
511     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
512         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
513         _setAutomatedMarketMakerPair(pair, value);
514         emit SetAutomatedMarketMakerPair(pair, value);
515     }
516 
517     function _setAutomatedMarketMakerPair(address pair, bool value) private {
518         automatedMarketMakerPairs[pair] = value;
519         _excludeFromMaxTransaction(pair, value);
520         emit SetAutomatedMarketMakerPair(pair, value);
521     }
522 
523     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
524         buyOperationsFee = _operationsFee;
525         buyLiquidityFee = _liquidityFee;
526         buyTotalFees = buyOperationsFee + buyLiquidityFee;
527         require(buyTotalFees <= 5 * FEE_DIVISOR / 100, "Must keep fees at 5% or less");
528     }
529 
530     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
531         sellOperationsFee = _operationsFee;
532         sellLiquidityFee = _liquidityFee;
533         sellTotalFees = sellOperationsFee + sellLiquidityFee;
534         require(sellTotalFees <= 80 * FEE_DIVISOR / 100, "Must keep fees at 5% or less");
535     }
536 
537     function massExcludeFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
538         for(uint256 i = 0; i < accounts.length; i++){
539             _isExcludedFromFees[accounts[i]] = excluded;
540             emit ExcludeFromFees(accounts[i], excluded);
541         }
542     }
543 
544     function excludeFromFees(address account, bool excluded) public onlyOwner {
545         _isExcludedFromFees[account] = excluded;
546         emit ExcludeFromFees(account, excluded);
547     }
548 
549     function _transfer(address from, address to, uint256 amount) internal override {
550 
551         require(from != address(0), "ERC20: transfer from the zero address");
552         require(to != address(0), "ERC20: transfer to the zero address");
553         require(amount > 0, "amount must be greater than 0");
554         
555         if(!tradingActive){
556             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
557         }
558         if(limitsInEffect){
559             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
560                 
561                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
562                 if (transferDelayEnabled){
563                     if (to != address(dexRouter) && !automatedMarketMakerPairs[to]){
564                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
565                         _holderLastTransferTimestamp[tx.origin] = block.number;
566                         _holderLastTransferTimestamp[to] = block.number;
567                     }
568                 }
569                  
570                 //when buy
571                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
572                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
573                     require(amount + balanceOf(to) <= maxWallet, "Max Wallet Exceeded");
574                 } 
575                 //when sell
576                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
577                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
578                 } else if (!_isExcludedMaxTransactionAmount[to]){
579                     require(amount + balanceOf(to) <= maxWallet, "Max Wallet Exceeded");
580                 }
581             }
582         }
583 
584         uint256 contractTokenBalance = balanceOf(address(this));
585         
586         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
587 
588         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
589             swapping = true;
590             swapBack();
591             swapping = false;
592         }
593 
594         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
595             autoBurnLiquidityPairTokens();
596         }
597 
598         bool takeFee = true;
599         // if any account belongs to _isExcludedFromFee account then remove the fee
600         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
601             takeFee = false;
602         }
603         
604         uint256 fees = 0;
605 
606         // only take fees on buys/sells, do not take on wallet transfers
607         if(takeFee){
608             // on sell
609             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
610                 fees = amount * sellTotalFees / FEE_DIVISOR;
611                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
612                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
613             }
614 
615             // on buy
616             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
617         	    fees = amount * buyTotalFees / FEE_DIVISOR;
618         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
619                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
620             }
621             
622             if(fees > 0){    
623                 super._transfer(from, address(this), fees);
624             }
625         	
626         	amount -= fees;
627         }
628 
629         super._transfer(from, to, amount);
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
661             address(this),
662             block.timestamp
663         );
664     }
665 
666     function swapBack() private {
667 
668         uint256 contractBalance = balanceOf(address(this));
669         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
670         
671         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
672 
673         if(contractBalance > swapTokensAtAmount * 40){
674             contractBalance = swapTokensAtAmount * 40;
675         }
676 
677         bool success;
678         
679         // Halve the amount of liquidity tokens
680         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
681         
682         swapTokensForEth(contractBalance - liquidityTokens); 
683         
684         uint256 ethBalance = address(this).balance;
685         uint256 ethForLiquidity = ethBalance;
686 
687         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
688 
689         ethForLiquidity -= ethForOperations;
690             
691         tokensForLiquidity = 0;
692         tokensForOperations = 0;
693         
694         if(liquidityTokens > 0 && ethForLiquidity > 0){
695             addLiquidity(liquidityTokens, ethForLiquidity);
696         }
697 
698         (success,) = address(operationsAddress).call{value: address(this).balance}("");
699     }
700 
701     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
702         require(_token != address(0), "_token address cannot be 0");
703         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
704         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
705         _sent = IERC20(_token).transfer(_to, _contractBalance);
706         emit TransferForeignToken(_token, _contractBalance);
707     }
708 
709     // withdraw ETH if stuck or someone sends to the address
710     function withdrawStuckETH() external onlyOwner {
711         bool success;
712         (success,) = address(msg.sender).call{value: address(this).balance}("");
713     }
714 
715     function setOperationsAddress(address _operationsAddress) external onlyOwner {
716         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
717         operationsAddress = payable(_operationsAddress);
718         emit UpdatedOperationsAddress(_operationsAddress);
719     }
720     // force Swap back if slippage issues.
721     function forceSwapBack() external onlyOwner {
722         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
723         swapping = true;
724         swapBack();
725         swapping = false;
726         emit OwnerForcedSwapBack(block.timestamp);
727     }
728 
729     function launch() external onlyOwner {
730         require(!tradingActive, "Trading is already active, cannot relaunch.");
731 
732         // create pair
733         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
734         _excludeFromMaxTransaction(address(lpPair), true);
735         _setAutomatedMarketMakerPair(address(lpPair), true);
736    
737         // add the liquidity
738 
739         require(address(this).balance > 0, "Must have ETH on contract to launch");
740 
741         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
742 
743         _approve(address(this), address(dexRouter), balanceOf(address(this)));
744         dexRouter.addLiquidityETH{value: address(this).balance}(
745             address(this),
746             balanceOf(address(this)),
747             0, // slippage is unavoidable
748             0, // slippage is unavoidable
749             address(futureOwner),
750             block.timestamp
751         );
752 
753         //standard enable trading
754         tradingActive = true;
755         swapEnabled = true;
756         tradingActiveBlock = block.number;
757         emit EnabledTrading();
758     }
759 
760     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
761         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
762         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
763         lpBurnFrequency = _frequencyInSeconds;
764         percentForLPBurn = _percent;
765         lpBurnEnabled = _Enabled;
766     }
767     
768     function autoBurnLiquidityPairTokens() internal {
769         
770         lastLpBurnTime = block.timestamp;
771         
772         lastManualLpBurnTime = block.timestamp;
773         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
774         uint256 tokenBalance = balanceOf(address(this));
775         uint256 lpAmount = lpBalance * percentForLPBurn / 10000;
776         uint256 initialEthBalance = address(this).balance;
777 
778         // approve token transfer to cover all possible scenarios
779         IERC20(lpPair).approve(address(dexRouter), lpAmount);
780 
781         // remove the liquidity
782         dexRouter.removeLiquidityETH(
783             address(this),
784             lpAmount,
785             1, // slippage is unavoidable
786             1, // slippage is unavoidable
787             address(this),
788             block.timestamp
789         );
790 
791         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
792         if(deltaTokenBalance > 0){
793             super._transfer(address(this), address(0xdead), deltaTokenBalance);
794         }
795 
796         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
797 
798         if(deltaEthBalance > 0){
799             buyBackTokens(deltaEthBalance);
800         }
801 
802         emit AutoBurnLP(lpAmount);
803     }
804 
805     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
806         require(percent <= 5000, "May not burn more than 50% of contract's LP at a time");
807         require(lastManualLpBurnTime <= block.timestamp - manualBurnFrequency, "Burn too soon");
808         lastManualLpBurnTime = block.timestamp;
809         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
810         uint256 tokenBalance = balanceOf(address(this));
811         uint256 lpAmount = lpBalance * percent / 10000;
812         uint256 initialEthBalance = address(this).balance;
813 
814         // approve token transfer to cover all possible scenarios
815         IERC20(lpPair).approve(address(dexRouter), lpAmount);
816 
817         // remove the liquidity
818         dexRouter.removeLiquidityETH(
819             address(this),
820             lpAmount,
821             1, // slippage is unavoidable
822             1, // slippage is unavoidable
823             address(this),
824             block.timestamp
825         );
826 
827         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
828         if(deltaTokenBalance > 0){
829             super._transfer(address(this), address(0xdead), deltaTokenBalance);
830         }
831 
832         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
833 
834         if(deltaEthBalance > 0){
835             buyBackTokens(deltaEthBalance);
836         }
837 
838         emit ManualBurnLP(lpAmount);
839     }
840 
841     function buyBackTokens(uint256 amountInWei) internal {
842         address[] memory path = new address[](2);
843         path[0] = dexRouter.WETH();
844         path[1] = address(this);
845 
846         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
847             0,
848             path,
849             address(0xdead),
850             block.timestamp
851         );
852     }
853 }