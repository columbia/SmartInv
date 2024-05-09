1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.12;
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
259 interface ILpPair {
260     function sync() external;
261 }
262 
263 interface IDexRouter {
264     function factory() external pure returns (address);
265     function WETH() external pure returns (address);
266     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
267     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
268     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
269     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
270 }
271 
272 interface IDexFactory {
273     function createPair(address tokenA, address tokenB) external returns (address pair);
274 }
275 
276 contract ThorPaulInu is ERC20, Ownable {
277 
278     uint256 public maxBuyAmount;
279     uint256 public maxSellAmount;
280 
281     IDexRouter public dexRouter;
282     address public lpPair;
283 
284     bool private swapping;
285     uint256 public swapTokensAtAmount;
286 
287     address public operationsAddress;
288     address public devAddress;
289 
290     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
291     uint256 public blockForPenaltyEnd;
292     mapping (address => bool) public boughtEarly;
293     address[] public earlyBuyers;
294     uint256 public botsCaught;
295 
296     bool public limitsInEffect = true;
297     bool public tradingActive = false;
298     bool public swapEnabled = false;
299 
300     mapping (address => bool) public privateSaleWallets;
301     mapping (address => uint256) public nextPrivateWalletSellDate;
302     uint256 public maxPrivSaleSell = .75 ether;
303     
304      // Anti-bot and anti-whale mappings and variables
305     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
306     bool public transferDelayEnabled = true;
307 
308     bool private gasLimitActive = true;
309     uint256 private gasPriceMax = 250 * 1 gwei;
310 
311     uint256 public buyTotalFees;
312     uint256 public buyOperationsFee;
313     uint256 public buyLiquidityFee;
314     uint256 public buyDevFee;
315 
316     uint256 public sellTotalFees;
317     uint256 public sellOperationsFee;
318     uint256 public sellLiquidityFee;
319     uint256 public sellDevFee;
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
333     /******************/
334 
335     // exlcude from fees and max transaction amount
336     mapping (address => bool) private _isExcludedFromFees;
337     mapping (address => bool) public _isExcludedMaxTransactionAmount;
338 
339     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
340     // could be subject to a maximum transfer amount
341     mapping (address => bool) public automatedMarketMakerPairs;
342 
343     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
344 
345     event EnabledTrading();
346 
347     event RemovedLimits();
348 
349     event ExcludeFromFees(address indexed account, bool isExcluded);
350 
351     event UpdatedMaxBuyAmount(uint256 newAmount);
352 
353     event UpdatedMaxSellAmount(uint256 newAmount);
354 
355     event UpdatedMaxWalletAmount(uint256 newAmount);
356 
357     event UpdatedOperationsAddress(address indexed newWallet);
358 
359     event UpdatedDevAddress(address indexed newWallet);
360 
361     event MaxTransactionExclusion(address _address, bool excluded);
362 
363     event OwnerForcedSwapBack(uint256 timestamp);
364 
365     event CaughtEarlyBuyer(address sniper);
366 
367     event SwapAndLiquify(
368         uint256 tokensSwapped,
369         uint256 ethReceived,
370         uint256 tokensIntoLiquidity
371     );
372 
373     event AutoNukeLP(uint256 indexed tokensBurned);
374 
375     event ManualNukeLP(uint256 indexed tokensBurned);
376 
377     event TransferForeignToken(address token, uint256 amount);
378 
379     event UpdatedPrivateMaxSell(uint256 amount);
380 
381     constructor() ERC20("Thor Paul Inu", "TPI") payable {
382         
383         address newOwner = msg.sender; // can leave alone if owner is deployer.
384 
385         // initialize router
386         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
387         dexRouter = _dexRouter;
388 
389         uint256 totalSupply = 1 * 1e9 * 1e18;
390         
391         maxBuyAmount = totalSupply * 2 / 1000;
392         maxSellAmount = totalSupply * 2 / 1000;
393         swapTokensAtAmount = totalSupply * 5 / 10000;
394 
395         buyOperationsFee = 6;
396         buyLiquidityFee = 5;
397         buyDevFee = 2;
398         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee;
399 
400         sellOperationsFee = 9;
401         sellLiquidityFee = 3;
402         sellDevFee = 3;
403         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee;
404 
405         operationsAddress = address(0x36bF10cF108D01bF2Ce1c6bE009B8Eec79800053);
406         devAddress = address(0xcF77c3d6E07D7924C7434C347C9C797C688B69c7);
407 
408         _excludeFromMaxTransaction(newOwner, true);
409         _excludeFromMaxTransaction(address(this), true);
410         _excludeFromMaxTransaction(address(0xdead), true);
411         _excludeFromMaxTransaction(address(operationsAddress), true);
412 
413         excludeFromFees(newOwner, true);
414         excludeFromFees(address(this), true);
415         excludeFromFees(address(0xdead), true);
416         excludeFromFees(address(operationsAddress), true);
417 
418         _createInitialSupply(newOwner, totalSupply * 638 / 1000);
419         _createInitialSupply(address(this), totalSupply * 36 / 100);
420         _createInitialSupply(0x85bde96D098c338b4b3DCa8Cae84c4B3bb900B01, totalSupply * 2/1000);
421         transferOwnership(newOwner);
422     }
423 
424     receive() external payable {}
425 
426     function setGasPriceMax(uint256 gas) external onlyOwner {
427         require(gas >= 200);
428         gasPriceMax = gas * 1 gwei;
429     }
430     
431     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
432         require(!tradingActive, "Cannot reenable trading");
433         require(blocksForPenalty <= 10, "Cannot make penalty blocks more than 10");
434         tradingActive = true;
435         swapEnabled = true;
436         tradingActiveBlock = block.number;
437         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
438         emit EnabledTrading();
439     }
440     
441     // remove limits after token is stable
442     function removeLimits() external onlyOwner {
443         limitsInEffect = false;
444         gasLimitActive = false;
445         transferDelayEnabled = false;
446         maxBuyAmount = totalSupply();
447         maxSellAmount = totalSupply();
448         emit RemovedLimits();
449     }
450 
451     function getEarlyBuyers() external view returns (address[] memory){
452         return earlyBuyers;
453     }
454 
455     function removeBoughtEarly(address wallet) external onlyOwner {
456         require(boughtEarly[wallet], "Wallet is already not flagged.");
457         boughtEarly[wallet] = false;
458     }
459 
460     function emergencyUpdateRouter(address router) external onlyOwner {
461         require(!tradingActive, "Cannot update after trading is functional");
462         dexRouter = IDexRouter(router);
463     }
464     
465     // disable Transfer delay - cannot be reenabled
466     function disableTransferDelay() external onlyOwner {
467         transferDelayEnabled = false;
468     }
469     
470     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
471         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
472         maxBuyAmount = newNum * (10**18);
473         emit UpdatedMaxBuyAmount(maxBuyAmount);
474     }
475     
476     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
477         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
478         maxSellAmount = newNum * (10**18);
479         emit UpdatedMaxSellAmount(maxSellAmount);
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
523     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
524         buyOperationsFee = _operationsFee;
525         buyLiquidityFee = _liquidityFee;
526         buyDevFee = _devFee;
527         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee;
528         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
529     }
530 
531     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
532         sellOperationsFee = _operationsFee;
533         sellLiquidityFee = _liquidityFee;
534         sellDevFee = _devFee;
535         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee;
536         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
537     }
538 
539     function excludeFromFees(address account, bool excluded) public onlyOwner {
540         _isExcludedFromFees[account] = excluded;
541         emit ExcludeFromFees(account, excluded);
542     }
543 
544     function _transfer(address from, address to, uint256 amount) internal override {
545 
546         require(from != address(0), "ERC20: transfer from the zero address");
547         require(to != address(0), "ERC20: transfer to the zero address");
548         require(amount > 0, "amount must be greater than 0");
549         
550         if(!tradingActive){
551             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
552         }
553 
554         if(!earlyBuyPenaltyInEffect() && tradingActive){
555             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
556         }
557 
558         if(privateSaleWallets[from]){
559             if(automatedMarketMakerPairs[to]){
560                 //enforce max sell restrictions.
561                 require(nextPrivateWalletSellDate[from] <= block.timestamp, "Cannot sell yet");
562                 require(amount <= getPrivateSaleMaxSell(), "Attempting to sell over max sell amount.  Check max.");
563                 nextPrivateWalletSellDate[from] = block.timestamp + 24 hours;
564             } else if(!_isExcludedFromFees[to]){
565                 revert("Private sale cannot transfer and must sell only or transfer to a whitelisted address.");
566             }
567         }
568         
569         if(limitsInEffect){
570             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
571                 
572                 // only use to prevent sniper buys in the first blocks.
573                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
574                     require(tx.gasprice <= gasPriceMax, "Gas price exceeds limit.");
575                 }
576 
577                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
578                 if (transferDelayEnabled){
579                     if (to != address(dexRouter) && to != address(lpPair)){
580                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
581                         _holderLastTransferTimestamp[tx.origin] = block.number;
582                         _holderLastTransferTimestamp[to] = block.number;
583                     }
584                 }
585                  
586                 //when buy
587                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
588                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
589                 } 
590                 //when sell
591                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
592                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
593                 }
594             }
595         }
596 
597         uint256 contractTokenBalance = balanceOf(address(this));
598         
599         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
600 
601         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
602             swapping = true;
603             swapBack();
604             swapping = false;
605         }
606 
607         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
608             autoBurnLiquidityPairTokens();
609         }
610 
611         bool takeFee = true;
612         // if any account belongs to _isExcludedFromFee account then remove the fee
613         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
614             takeFee = false;
615         }
616         
617         uint256 fees = 0;
618         // only take fees on buys/sells, do not take on wallet transfers
619         if(takeFee){
620             // bot/sniper penalty.
621             if((earlyBuyPenaltyInEffect() || (amount >= maxBuyAmount - .9 ether && blockForPenaltyEnd + 8 >= block.number)) && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && !_isExcludedFromFees[to] && buyTotalFees > 0){
622                 
623                 if(!earlyBuyPenaltyInEffect()){
624                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
625                     maxBuyAmount -= 1;
626                 }
627 
628                 if(!boughtEarly[to]){
629                     boughtEarly[to] = true;
630                     botsCaught += 1;
631                     earlyBuyers.push(to);
632                     emit CaughtEarlyBuyer(to);
633                 }
634 
635                 fees = amount * buyTotalFees / 100;
636         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
637                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
638                 tokensForDev += fees *  buyDevFee / buyTotalFees;
639             }
640 
641             // on sell
642             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
643                 fees = amount * sellTotalFees / 100;
644                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
645                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
646                 tokensForDev += fees *  sellDevFee / buyTotalFees;
647             }
648 
649             // on buy
650             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
651         	    fees = amount * buyTotalFees / 100;
652         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
653                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
654                 tokensForDev += fees *  buyDevFee / buyTotalFees;
655             }
656             
657             if(fees > 0){    
658                 super._transfer(from, address(this), fees);
659             }
660         	
661         	amount -= fees;
662         }
663 
664         super._transfer(from, to, amount);
665     }
666 
667     function earlyBuyPenaltyInEffect() public view returns (bool){
668         return block.number < blockForPenaltyEnd;
669     }
670 
671     function swapTokensForEth(uint256 tokenAmount) private {
672 
673         // generate the uniswap pair path of token -> weth
674         address[] memory path = new address[](2);
675         path[0] = address(this);
676         path[1] = dexRouter.WETH();
677 
678         _approve(address(this), address(dexRouter), tokenAmount);
679 
680         // make the swap
681         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
682             tokenAmount,
683             0, // accept any amount of ETH
684             path,
685             address(this),
686             block.timestamp
687         );
688     }
689     
690     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
691         // approve token transfer to cover all possible scenarios
692         _approve(address(this), address(dexRouter), tokenAmount);
693 
694         // add the liquidity
695         dexRouter.addLiquidityETH{value: ethAmount}(
696             address(this),
697             tokenAmount,
698             0, // slippage is unavoidable
699             0, // slippage is unavoidable
700             address(0xdead),
701             block.timestamp
702         );
703     }
704 
705     function swapBack() private {
706 
707         uint256 contractBalance = balanceOf(address(this));
708         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
709         
710         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
711 
712         if(contractBalance > swapTokensAtAmount * 10){
713             contractBalance = swapTokensAtAmount * 10;
714         }
715 
716         bool success;
717         
718         // Halve the amount of liquidity tokens
719         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
720         
721         swapTokensForEth(contractBalance - liquidityTokens); 
722         
723         uint256 ethBalance = address(this).balance;
724         uint256 ethForLiquidity = ethBalance;
725 
726         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
727         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
728 
729         ethForLiquidity -= ethForOperations + ethForDev;
730             
731         tokensForLiquidity = 0;
732         tokensForOperations = 0;
733         tokensForDev = 0;
734         
735         if(liquidityTokens > 0 && ethForLiquidity > 0){
736             addLiquidity(liquidityTokens, ethForLiquidity);
737         }
738 
739         (success,) = address(devAddress).call{value: ethForDev}("");
740 
741         (success,) = address(operationsAddress).call{value: address(this).balance}("");
742     }
743 
744     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
745         require(_token != address(0), "_token address cannot be 0");
746         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
747         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
748         _sent = IERC20(_token).transfer(_to, _contractBalance);
749         emit TransferForeignToken(_token, _contractBalance);
750     }
751 
752     // withdraw ETH if stuck or someone sends to the address
753     function withdrawStuckETH() external onlyOwner {
754         bool success;
755         (success,) = address(msg.sender).call{value: address(this).balance}("");
756     }
757 
758     function setOperationsAddress(address _operationsAddress) external onlyOwner {
759         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
760         operationsAddress = payable(_operationsAddress);
761         emit UpdatedOperationsAddress(_operationsAddress);
762     }
763     
764     function setDevAddress(address _devAddress) external onlyOwner {
765         require(_devAddress != address(0), "_operationsAddress address cannot be 0");
766         devAddress = payable(_devAddress);
767         emit UpdatedDevAddress(_devAddress);
768     }
769 
770     // force Swap back if slippage issues.
771     function forceSwapBack() external onlyOwner {
772         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
773         swapping = true;
774         swapBack();
775         swapping = false;
776         emit OwnerForcedSwapBack(block.timestamp);
777     }
778 
779     function getPrivateSaleMaxSell() public view returns (uint256){
780         address[] memory path = new address[](2);
781         path[0] = dexRouter.WETH();
782         path[1] = address(this);
783         
784         uint256[] memory amounts = new uint256[](2);
785         amounts = dexRouter.getAmountsOut(maxPrivSaleSell, path);
786         return amounts[1] + (amounts[1] * (sellLiquidityFee + sellOperationsFee + sellDevFee))/100;
787     }
788 
789     function setPrivateSaleMaxSell(uint256 amount) external onlyOwner{
790         require(amount >= 25 && amount <= 5000, "Must set between 0.25 and 50 ETH");
791         maxPrivSaleSell = amount * 1e16;
792         emit UpdatedPrivateMaxSell(amount);
793     }
794 
795     function launch(address[] memory wallets, uint256[] memory amountsInTokens, uint256 blocksForPenalty) external onlyOwner {
796         require(!tradingActive, "Trading is already active, cannot relaunch.");
797         require(blocksForPenalty < 10, "Cannot make penalty blocks more than 10");
798 
799         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
800         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
801         for(uint256 i = 0; i < wallets.length; i++){
802             address wallet = wallets[i];
803             privateSaleWallets[wallet] = true;
804             nextPrivateWalletSellDate[wallet] = block.timestamp + 24 hours;
805             uint256 amount = amountsInTokens[i];
806             super._transfer(msg.sender, wallet, amount);
807         }
808 
809         maxBuyAmount = totalSupply() * 1 / 1000;
810         maxSellAmount = totalSupply() * 1 / 1000;
811 
812         //standard enable trading
813         tradingActive = true;
814         swapEnabled = true;
815         tradingActiveBlock = block.number;
816         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
817         emit EnabledTrading();
818 
819         // create pair
820         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
821         _excludeFromMaxTransaction(address(lpPair), true);
822         _setAutomatedMarketMakerPair(address(lpPair), true);
823    
824         // add the liquidity
825 
826         require(address(this).balance > 0, "Must have ETH on contract to launch");
827 
828         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
829 
830         _approve(address(this), address(dexRouter), balanceOf(address(this)));
831         dexRouter.addLiquidityETH{value: address(this).balance}(
832             address(this),
833             balanceOf(address(this)),
834             0, // slippage is unavoidable
835             0, // slippage is unavoidable
836             operationsAddress,
837             block.timestamp
838         );
839 
840         super._transfer(msg.sender, operationsAddress, balanceOf(msg.sender));
841     }
842 
843     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
844         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
845         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
846         lpBurnFrequency = _frequencyInSeconds;
847         percentForLPBurn = _percent;
848         lpBurnEnabled = _Enabled;
849     }
850     
851     function autoBurnLiquidityPairTokens() internal returns (bool){
852         
853         lastLpBurnTime = block.timestamp;
854         
855         // get balance of liquidity pair
856         uint256 liquidityPairBalance = this.balanceOf(lpPair);
857         
858         // calculate amount to burn
859         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;
860         
861         // pull tokens from pancakePair liquidity and move to dead address permanently
862         if (amountToBurn > 0){
863             super._transfer(lpPair, address(0xdead), amountToBurn);
864         }
865         
866         //sync price since this is not in a swap transaction!
867         ILpPair pair = ILpPair(lpPair);
868         pair.sync();
869         emit AutoNukeLP(amountToBurn);
870         return true;
871     }
872 
873     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
874         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
875         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
876         lastManualLpBurnTime = block.timestamp;
877         
878         // get balance of liquidity pair
879         uint256 liquidityPairBalance = this.balanceOf(lpPair);
880         
881         // calculate amount to burn
882         uint256 amountToBurn = liquidityPairBalance * percent / 10000;
883         
884         // pull tokens from pancakePair liquidity and move to dead address permanently
885         if (amountToBurn > 0){
886             super._transfer(lpPair, address(0xdead), amountToBurn);
887         }
888         
889         //sync price since this is not in a swap transaction!
890         ILpPair pair = ILpPair(lpPair);
891         pair.sync();
892         emit ManualNukeLP(amountToBurn);
893         return true;
894     }
895 }