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
262     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
263     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
264     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
265     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
266     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
267 }
268 
269 interface IDexFactory {
270     function createPair(address tokenA, address tokenB) external returns (address pair);
271 }
272 
273 interface IPriceFeed {
274     function latestAnswer() external returns (int256);
275 }
276 
277 contract Oof is ERC20, Ownable {
278 
279     uint256 public maxBuyAmount;
280     uint256 public maxSellAmount;
281     uint256 public maxWallet;
282 
283     IDexRouter public dexRouter;
284     address public lpPair;
285 
286     IPriceFeed internal immutable priceFeed;
287 
288     bool private swapping;
289     uint256 public swapTokensAtAmount;
290 
291     address public operationsAddress;
292     address public devAddress;
293     address public futureOwner;
294 
295     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
296     uint256 public blockForPenaltyEnd;
297     mapping (address => bool) public boughtEarly;
298     address[] public earlyBuyers;
299     uint256 public botsCaught;
300 
301     bool public limitsInEffect = true;
302     bool public tradingActive = false;
303     bool public swapEnabled = false;
304     
305      // Anti-bot and anti-whale mappings and variables
306     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
307     bool public transferDelayEnabled = true;
308 
309     uint256 public buyTotalFees;
310     uint256 public buyOperationsFee;
311     uint256 public buyLiquidityFee;
312     uint256 public buyDevFee;
313 
314     uint256 public sellTotalFees;
315     uint256 public sellOperationsFee;
316     uint256 public sellLiquidityFee;
317     uint256 public sellDevFee;
318 
319     uint256 public constant FEE_DIVISOR = 10000;
320 
321     uint256 public tokensForOperations;
322     uint256 public tokensForLiquidity;
323     uint256 public tokensForDev;
324 
325     uint256 public percentForLPBurn = 25; // 25 = .25%
326     bool public lpBurnEnabled = false;
327     uint256 public lpBurnFrequency = 3600 seconds;
328     uint256 public lastLpBurnTime;
329     
330     uint256 public manualBurnFrequency = 30 minutes;
331     uint256 public lastManualLpBurnTime;
332 
333     // floating liquidity settings
334     bool public customLiquidityActive = true;
335     uint256 public latestEthPrice = 0;
336     uint256 public minimumBuyLiqPerc = 50;
337     uint256 public minimumSellLiqPerc = 33;
338     uint256 public maximumBuyLiqPerc = 80;
339     uint256 public maximumSellLiqPerc = 50;
340     uint256 public mcapComparisonValue = 10 * 1e6;
341 
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
369     event UpdatedDevAddress(address indexed newWallet);
370 
371     event MaxTransactionExclusion(address _address, bool excluded);
372 
373     event OwnerForcedSwapBack(uint256 timestamp);
374 
375     event CaughtEarlyBuyer(address sniper);
376 
377     event SwapAndLiquify(
378         uint256 tokensSwapped,
379         uint256 ethReceived,
380         uint256 tokensIntoLiquidity
381     );
382 
383     event AutoBurnLP(uint256 indexed tokensBurned);
384 
385     event ManualBurnLP(uint256 indexed tokensBurned);
386 
387     event TransferForeignToken(address token, uint256 amount);
388 
389     constructor() ERC20("OOF", "OOF") payable {
390         
391         address newOwner = msg.sender; // can leave alone if owner is deployer.
392         address _dexRouter;
393         address _priceFeed;
394 
395         if(block.chainid == 1){
396             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
397             _priceFeed = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
398         } else if(block.chainid == 4){
399             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Rinkeby ETH: Uniswap V2
400             _priceFeed = 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;
401         } else if(block.chainid == 56){
402             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
403             _priceFeed = 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE;
404         } else if(block.chainid == 97){
405             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain Testnet: PCS V2
406             _priceFeed = 0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526;
407         } else if(block.chainid == 42161){
408             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
409             _priceFeed = 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612;
410         } else {
411             revert("Chain not configured");
412         }
413 
414         priceFeed = IPriceFeed(_priceFeed);
415         require(priceFeed.latestAnswer() > 0, "wrong price feed");
416 
417         // initialize router
418         dexRouter = IDexRouter(_dexRouter);
419 
420         uint256 totalSupply = 100 * 1e6 * (10 ** decimals());
421         
422         maxBuyAmount = totalSupply * 5 / 10000;
423         maxSellAmount = totalSupply * 5 / 10000;
424         maxWallet = totalSupply * 1 / 1000;
425         swapTokensAtAmount = totalSupply * 25 / 100000;
426 
427         buyOperationsFee = 0;
428         buyLiquidityFee = 100;
429         buyDevFee = 200;
430         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee;
431 
432         sellOperationsFee = 3333;
433         sellLiquidityFee = 3333;
434         sellDevFee = 3333;
435         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee;
436 
437         if(block.chainid == 1){
438             operationsAddress = address(0x1DE548Cf3b40c8D29d141ce63be49982E733B41A);
439             devAddress = address(0x1DE548Cf3b40c8D29d141ce63be49982E733B41A);
440             futureOwner = address(0x1DE548Cf3b40c8D29d141ce63be49982E733B41A);
441         } else {
442             operationsAddress = address(msg.sender);
443             devAddress = address(msg.sender);
444             futureOwner = address(msg.sender);
445         }
446 
447         _excludeFromMaxTransaction(newOwner, true);
448         _excludeFromMaxTransaction(address(this), true);
449         _excludeFromMaxTransaction(address(0xdead), true);
450         _excludeFromMaxTransaction(address(operationsAddress), true);
451         _excludeFromMaxTransaction(address(dexRouter), true);
452         _excludeFromMaxTransaction(address(futureOwner), true);
453 
454         excludeFromFees(newOwner, true);
455         excludeFromFees(address(this), true);
456         excludeFromFees(address(0xdead), true);
457         excludeFromFees(address(operationsAddress), true);
458         excludeFromFees(address(dexRouter), true);
459         excludeFromFees(address(futureOwner), true);
460 
461         
462         _createInitialSupply(address(this), totalSupply * 66 / 100);  // update with % for LP
463         _createInitialSupply(futureOwner, totalSupply - balanceOf(address(this)));
464         transferOwnership(newOwner);
465     }
466 
467     receive() external payable {}
468 
469     function setCustomLiquidityActive(bool active) external onlyOwner {
470         customLiquidityActive = active;
471     }
472     
473     function enableTrading(uint256 blocksForPenalty, address _lpPair) external onlyOwner {
474         require(!tradingActive, "Cannot reenable trading");
475         require(blocksForPenalty <= 10, "Cannot make penalty blocks more than 10");
476         tradingActive = true;
477         swapEnabled = true;
478         tradingActiveBlock = block.number;
479         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
480         
481         // set pair
482         lpPair = _lpPair;
483         _excludeFromMaxTransaction(address(lpPair), true);
484         _setAutomatedMarketMakerPair(address(lpPair), true);
485 
486         emit EnabledTrading();
487     }
488     
489     // remove limits after token is stable
490     function removeLimits() external onlyOwner {
491 
492         limitsInEffect = false;
493         transferDelayEnabled = false;
494         maxBuyAmount = totalSupply();
495         maxSellAmount = totalSupply();
496 
497         emit RemovedLimits();
498     }
499 
500     function getEarlyBuyers() external view returns (address[] memory){
501         return earlyBuyers;
502     }
503 
504     function massManageRestrictedWallets(address[] calldata accounts, bool restricted) external onlyOwner {
505         for(uint256 i = 0; i < accounts.length; i++){
506             boughtEarly[accounts[i]] = restricted;
507         }
508     }
509 
510     // disable Transfer delay - cannot be reenabled
511     function disableTransferDelay() external onlyOwner {
512         transferDelayEnabled = false;
513     }
514     
515     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
516         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max buy amount lower than 0.1%");
517         maxBuyAmount = newNum * (10 ** decimals());
518         emit UpdatedMaxBuyAmount(maxBuyAmount);
519     }
520     
521     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
522         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max sell amount lower than 0.1%");
523         maxSellAmount = newNum * (10 ** decimals());
524         emit UpdatedMaxSellAmount(maxSellAmount);
525     }
526 
527     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
528         require(newNum >= (totalSupply() * 1 / 100) / (10 ** decimals()), "Cannot set max sell amount lower than 1%");
529         maxWallet = newNum * (10 ** decimals());
530         emit UpdatedMaxWalletAmount(maxWallet);
531     }
532 
533     // change the minimum amount of tokens to sell from fees
534     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
535   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
536   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
537   	    swapTokensAtAmount = newAmount;
538   	}
539     
540     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
541         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
542         emit MaxTransactionExclusion(updAds, isExcluded);
543     }
544 
545     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
546         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
547         require(wallets.length < 300, "Can only airdrop 300 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
548         for(uint256 i = 0; i < wallets.length; i++){
549             address wallet = wallets[i];
550             uint256 amount = amountsInTokens[i];
551             super._transfer(msg.sender, wallet, amount);
552         }
553     }
554     
555     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
556         if(!isEx){
557             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
558         }
559         _isExcludedMaxTransactionAmount[updAds] = isEx;
560     }
561 
562     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
563         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
564         _setAutomatedMarketMakerPair(pair, value);
565         emit SetAutomatedMarketMakerPair(pair, value);
566     }
567 
568     function _setAutomatedMarketMakerPair(address pair, bool value) private {
569         automatedMarketMakerPairs[pair] = value;
570         _excludeFromMaxTransaction(pair, value);
571         emit SetAutomatedMarketMakerPair(pair, value);
572     }
573 
574     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
575         buyOperationsFee = _operationsFee;
576         buyLiquidityFee = _liquidityFee;
577         buyDevFee = _devFee;
578         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee;
579         require(buyTotalFees <= 15 * FEE_DIVISOR / 100, "Must keep fees at 15% or less");
580     }
581 
582     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
583         sellOperationsFee = _operationsFee;
584         sellLiquidityFee = _liquidityFee;
585         sellDevFee = _devFee;
586         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee;
587         require(sellTotalFees <= 20 * FEE_DIVISOR / 100, "Must keep fees at 20% or less");
588     }
589 
590     function massExcludeFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
591         for(uint256 i = 0; i < accounts.length; i++){
592             _isExcludedFromFees[accounts[i]] = excluded;
593             emit ExcludeFromFees(accounts[i], excluded);
594         }
595     }
596 
597     function excludeFromFees(address account, bool excluded) public onlyOwner {
598         _isExcludedFromFees[account] = excluded;
599         emit ExcludeFromFees(account, excluded);
600     }
601 
602     function _transfer(address from, address to, uint256 amount) internal override {
603 
604         require(from != address(0), "ERC20: transfer from the zero address");
605         require(to != address(0), "ERC20: transfer to the zero address");
606         require(amount > 0, "amount must be greater than 0");
607         
608         if(!tradingActive){
609             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
610         }
611 
612         if(tradingActive){
613             require((!boughtEarly[from] && !boughtEarly[to]) || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
614         }
615         
616         if(limitsInEffect){
617             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
618                 
619                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
620                 if (transferDelayEnabled){
621                     if (to != address(dexRouter) && to != address(lpPair)){
622                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
623                         _holderLastTransferTimestamp[tx.origin] = block.number;
624                         _holderLastTransferTimestamp[to] = block.number;
625                     }
626                 }
627                  
628                 //when buy
629                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
630                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
631                     require(amount + balanceOf(to) <= maxWallet, "Max Wallet Exceeded");
632                 } 
633                 //when sell
634                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
635                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
636                 } else if (!_isExcludedMaxTransactionAmount[to]){
637                     require(amount + balanceOf(to) <= maxWallet, "Max Wallet Exceeded");
638                 }
639             }
640         }
641 
642         uint256 contractTokenBalance = balanceOf(address(this));
643         
644         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
645 
646         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
647             swapping = true;
648             swapBack();
649             swapping = false;
650         }
651 
652         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
653             autoBurnLiquidityPairTokens();
654         }
655 
656         bool takeFee = true;
657         // if any account belongs to _isExcludedFromFee account then remove the fee
658         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
659             takeFee = false;
660         }
661         
662         uint256 fees = 0;
663 
664         if(customLiquidityActive && tradingActive && !swapping){
665             latestEthPrice = uint256(priceFeed.latestAnswer());
666             setCustomFees();
667         }
668 
669         // only take fees on buys/sells, do not take on wallet transfers
670         if(takeFee){
671             // bot/sniper penalty.
672             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && !_isExcludedFromFees[to] && buyTotalFees > 0){
673                 
674                 if(!earlyBuyPenaltyInEffect()){
675                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
676                     maxBuyAmount -= 1;
677                 }
678 
679                 if(!boughtEarly[to]){
680                     boughtEarly[to] = true;
681                     botsCaught += 1;
682                     earlyBuyers.push(to);
683                     emit CaughtEarlyBuyer(to);
684                 }
685 
686                 fees = amount * buyTotalFees / FEE_DIVISOR;
687         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
688                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
689                 tokensForDev += fees * buyDevFee / buyTotalFees;
690             }
691 
692             // on sell
693             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
694                 fees = amount * sellTotalFees / FEE_DIVISOR;
695                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
696                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
697                 tokensForDev += fees * sellDevFee / sellTotalFees;
698             }
699 
700             // on buy
701             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
702         	    fees = amount * buyTotalFees / FEE_DIVISOR;
703         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
704                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
705                 tokensForDev += fees * buyDevFee / buyTotalFees;
706             }
707             
708             if(fees > 0){    
709                 super._transfer(from, address(this), fees);
710             }
711         	
712         	amount -= fees;
713         }
714 
715         super._transfer(from, to, amount);
716     }
717 
718     function earlyBuyPenaltyInEffect() public view returns (bool){
719         return block.number < blockForPenaltyEnd;
720     }
721 
722     function swapTokensForEth(uint256 tokenAmount) private {
723 
724         // generate the uniswap pair path of token -> weth
725         address[] memory path = new address[](2);
726         path[0] = address(this);
727         path[1] = dexRouter.WETH();
728 
729         _approve(address(this), address(dexRouter), tokenAmount);
730 
731         // make the swap
732         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
733             tokenAmount,
734             0, // accept any amount of ETH
735             path,
736             address(this),
737             block.timestamp
738         );
739     }
740     
741     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
742         // approve token transfer to cover all possible scenarios
743         _approve(address(this), address(dexRouter), tokenAmount);
744 
745         // add the liquidity
746         dexRouter.addLiquidityETH{value: ethAmount}(
747             address(this),
748             tokenAmount,
749             0, // slippage is unavoidable
750             0, // slippage is unavoidable
751             address(this),
752             block.timestamp
753         );
754     }
755 
756     function swapBack() private {
757 
758         uint256 contractBalance = balanceOf(address(this));
759         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
760         
761         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
762 
763         if(contractBalance > swapTokensAtAmount * 20){
764             contractBalance = swapTokensAtAmount * 20;
765         }
766 
767         bool success;
768         
769         // Halve the amount of liquidity tokens
770         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
771         
772         swapTokensForEth(contractBalance - liquidityTokens); 
773         
774         uint256 ethBalance = address(this).balance;
775         uint256 ethForLiquidity = ethBalance;
776 
777         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
778         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
779 
780         ethForLiquidity -= ethForOperations + ethForDev;
781             
782         tokensForLiquidity = 0;
783         tokensForOperations = 0;
784         tokensForDev = 0;
785         
786         if(liquidityTokens > 0 && ethForLiquidity > 0){
787             addLiquidity(liquidityTokens, ethForLiquidity);
788         }
789 
790         (success,) = address(devAddress).call{value: ethForDev}("");
791 
792         (success,) = address(operationsAddress).call{value: address(this).balance}("");
793     }
794 
795     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
796         require(_token != address(0), "_token address cannot be 0");
797         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
798         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
799         _sent = IERC20(_token).transfer(_to, _contractBalance);
800         emit TransferForeignToken(_token, _contractBalance);
801     }
802 
803     // withdraw ETH if stuck or someone sends to the address
804     function withdrawStuckETH() external onlyOwner {
805         bool success;
806         (success,) = address(msg.sender).call{value: address(this).balance}("");
807     }
808 
809     function setOperationsAddress(address _operationsAddress) external onlyOwner {
810         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
811         operationsAddress = payable(_operationsAddress);
812         emit UpdatedOperationsAddress(_operationsAddress);
813     }
814     
815     function setDevAddress(address _devAddress) external onlyOwner {
816         require(_devAddress != address(0), "_operationsAddress address cannot be 0");
817         devAddress = payable(_devAddress);
818         emit UpdatedDevAddress(_devAddress);
819     }
820 
821     // force Swap back if slippage issues.
822     function forceSwapBack() external onlyOwner {
823         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
824         swapping = true;
825         swapBack();
826         swapping = false;
827         emit OwnerForcedSwapBack(block.timestamp);
828     }
829 
830     function launch(uint256 blocksForPenalty) external onlyOwner {
831         require(!tradingActive, "Trading is already active, cannot relaunch.");
832 
833         // create pair
834         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
835         _excludeFromMaxTransaction(address(lpPair), true);
836         _setAutomatedMarketMakerPair(address(lpPair), true);
837    
838         // add the liquidity
839 
840         require(address(this).balance > 0, "Must have ETH on contract to launch");
841 
842         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
843 
844         _approve(address(this), address(dexRouter), balanceOf(address(this)));
845         dexRouter.addLiquidityETH{value: address(this).balance}(
846             address(this),
847             balanceOf(address(this)),
848             0, // slippage is unavoidable
849             0, // slippage is unavoidable
850             address(futureOwner),
851             block.timestamp
852         );
853 
854         latestEthPrice = uint256(priceFeed.latestAnswer());
855 
856         //standard enable trading
857         tradingActive = true;
858         swapEnabled = true;
859         tradingActiveBlock = block.number;
860         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
861         emit EnabledTrading();
862     }
863 
864     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
865         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
866         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
867         lpBurnFrequency = _frequencyInSeconds;
868         percentForLPBurn = _percent;
869         lpBurnEnabled = _Enabled;
870     }
871     
872     function autoBurnLiquidityPairTokens() internal {
873         
874         lastLpBurnTime = block.timestamp;
875         
876         lastManualLpBurnTime = block.timestamp;
877         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
878         uint256 tokenBalance = balanceOf(address(this));
879         uint256 lpAmount = lpBalance * percentForLPBurn / 10000;
880         uint256 initialEthBalance = address(this).balance;
881 
882         // approve token transfer to cover all possible scenarios
883         IERC20(lpPair).approve(address(dexRouter), lpAmount);
884 
885         // remove the liquidity
886         dexRouter.removeLiquidityETH(
887             address(this),
888             lpAmount,
889             1, // slippage is unavoidable
890             1, // slippage is unavoidable
891             address(this),
892             block.timestamp
893         );
894 
895         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
896         if(deltaTokenBalance > 0){
897             super._transfer(address(this), address(0xdead), deltaTokenBalance);
898         }
899 
900         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
901 
902         if(deltaEthBalance > 0){
903             buyBackTokens(deltaEthBalance);
904         }
905 
906         emit AutoBurnLP(lpAmount);
907     }
908 
909     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
910         require(percent <= 5000, "May not burn more than 50% of contract's LP at a time");
911         require(lastManualLpBurnTime <= block.timestamp - manualBurnFrequency, "Burn too soon");
912         lastManualLpBurnTime = block.timestamp;
913         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
914         uint256 tokenBalance = balanceOf(address(this));
915         uint256 lpAmount = lpBalance * percent / 10000;
916         uint256 initialEthBalance = address(this).balance;
917 
918         // approve token transfer to cover all possible scenarios
919         IERC20(lpPair).approve(address(dexRouter), lpAmount);
920 
921         // remove the liquidity
922         dexRouter.removeLiquidityETH(
923             address(this),
924             lpAmount,
925             1, // slippage is unavoidable
926             1, // slippage is unavoidable
927             address(this),
928             block.timestamp
929         );
930 
931         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
932         if(deltaTokenBalance > 0){
933             super._transfer(address(this), address(0xdead), deltaTokenBalance);
934         }
935 
936         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
937 
938         if(deltaEthBalance > 0){
939             buyBackTokens(deltaEthBalance);
940         }
941 
942         emit ManualBurnLP(lpAmount);
943     }
944 
945     function buyBackTokens(uint256 amountInWei) internal {
946         address[] memory path = new address[](2);
947         path[0] = dexRouter.WETH();
948         path[1] = address(this);
949 
950         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
951             0,
952             path,
953             address(0xdead),
954             block.timestamp
955         );
956     }
957 
958     function getMcap() public view returns (uint256){
959         return (IERC20(dexRouter.WETH()).balanceOf(address(lpPair)) * 1e18 * latestEthPrice / balanceOf(address(lpPair)) * (totalSupply()-balanceOf(address(0xdead))) / 1e18 / 1e8); 
960     }
961 
962     function customLiquiditySettings(bool _customLiquidityActive, uint256 _minimumBuyLiqPerc, uint256 _maximumBuyLiqPerc, uint256 _minimumSellLiqPerc, uint256 _maximumSellLiqPerc, uint256 _mcapComparisonValue) external onlyOwner {
963         require(_minimumBuyLiqPerc <= 100 && _maximumBuyLiqPerc <= 100 && _minimumBuyLiqPerc <= _maximumBuyLiqPerc, "Buy settings incorrect");
964         require(_minimumSellLiqPerc <= 100 && _maximumSellLiqPerc <= 100 && _minimumSellLiqPerc <= _maximumSellLiqPerc, "Sell settings incorrect");
965         customLiquidityActive = _customLiquidityActive;
966         minimumBuyLiqPerc = _minimumBuyLiqPerc;
967         maximumBuyLiqPerc = _maximumBuyLiqPerc;
968         minimumSellLiqPerc = _minimumSellLiqPerc;
969         maximumSellLiqPerc = _maximumSellLiqPerc;
970         mcapComparisonValue = _mcapComparisonValue;
971     }
972 
973     function setCustomFees() internal {
974         uint256 mcap = getMcap();
975         uint256 newLiquidityPercBuy = (mcap / mcapComparisonValue) * maximumBuyLiqPerc / 1e18 + minimumBuyLiqPerc;
976         uint256 newLiquidityPercSell = (mcap / mcapComparisonValue) * maximumSellLiqPerc / 1e18 + minimumSellLiqPerc;
977         if(newLiquidityPercBuy > maximumBuyLiqPerc){
978             newLiquidityPercBuy = maximumBuyLiqPerc;
979         }
980         if(newLiquidityPercSell > maximumSellLiqPerc){
981             newLiquidityPercSell = maximumSellLiqPerc;
982         }
983         buyLiquidityFee = buyTotalFees * newLiquidityPercBuy / 100;
984         buyOperationsFee = (buyTotalFees - buyLiquidityFee) * 33 / 100;
985         buyDevFee = buyTotalFees - buyOperationsFee - buyLiquidityFee;
986             
987         sellLiquidityFee = sellTotalFees * newLiquidityPercSell / 100;
988         sellOperationsFee = (sellTotalFees - sellLiquidityFee) * 50 / 100;
989         sellDevFee = sellTotalFees - sellOperationsFee - sellLiquidityFee;
990     }
991 }