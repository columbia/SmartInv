1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.16;
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
273 contract LanceInu is ERC20, Ownable {
274 
275     uint256 public maxBuyAmount;
276     uint256 public maxSellAmount;
277     uint256 public maxWallet;
278 
279     IDexRouter public dexRouter;
280     address public lpPair;
281 
282     bool private swapping;
283     uint256 public swapTokensAtAmount;
284 
285     address public marketingAddress;
286     address public devAddress;
287     address public treasuryAddress;
288 
289     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
290     uint256 public blockForPenaltyEnd;
291     mapping (address => bool) public boughtEarly;
292     address[] public earlyBuyers;
293     uint256 public botsCaught;
294 
295     bool public limitsInEffect = true;
296     bool public tradingActive = false;
297     bool public swapEnabled = false;
298     
299      // Anti-bot and anti-whale mappings and variables
300     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
301     bool public transferDelayEnabled = true;
302 
303     uint256 public buyTotalFees;
304     uint256 public buyMarketingFee;
305     uint256 public buyLiquidityFee;
306     uint256 public buyTreasuryFee;
307     uint256 public buyDevFee;
308 
309     uint256 public sellTotalFees;
310     uint256 public sellMarketingFee;
311     uint256 public sellLiquidityFee;
312     uint256 public sellTreasuryFee;
313     uint256 public sellDevFee;
314 
315     uint256 public constant FEE_DIVISOR = 10000;
316 
317     uint256 public tokensForMarketing;
318     uint256 public tokensForLiquidity;
319     uint256 public tokensForDev;
320     uint256 public tokensForTreasury;
321     
322     /******************/
323 
324     // exlcude from fees and max transaction amount
325     mapping (address => bool) private _isExcludedFromFees;
326     mapping (address => bool) public _isExcludedMaxTransactionAmount;
327 
328     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
329     // could be subject to a maximum transfer amount
330     mapping (address => bool) public automatedMarketMakerPairs;
331 
332     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
333 
334     event EnabledTrading();
335 
336     event RemovedLimits();
337 
338     event ExcludeFromFees(address indexed account, bool isExcluded);
339 
340     event UpdatedMaxBuyAmount(uint256 newAmount);
341 
342     event UpdatedMaxSellAmount(uint256 newAmount);
343 
344     event UpdatedMaxWalletAmount(uint256 newAmount);
345 
346     event UpdatedMarketingAddress(address indexed newWallet);
347 
348     event UpdatedDevAddress(address indexed newWallet);
349 
350     event UpdatedTreasuryAddress(address indexed newWallet);
351 
352     event MaxTransactionExclusion(address _address, bool excluded);
353 
354     event OwnerForcedSwapBack(uint256 timestamp);
355 
356     event CaughtEarlyBuyer(address sniper);
357 
358     event SwapAndLiquify(
359         uint256 tokensSwapped,
360         uint256 ethReceived,
361         uint256 tokensIntoLiquidity
362     );
363     event TransferForeignToken(address token, uint256 amount);
364 
365     constructor() ERC20("Lance Inu", "LINU") payable {
366         
367         address _dexRouter;
368 
369         if(block.chainid == 1){
370             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
371         } else if(block.chainid == 4){
372             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Rinkeby ETH: Uniswap V2
373         } else if(block.chainid == 56){
374             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
375         } else if(block.chainid == 97){
376             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain Testnet: PCS V2
377         } else if(block.chainid == 42161){
378             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
379         } else {
380             revert("Chain not configured");
381         }
382         
383         // initialize router
384         dexRouter = IDexRouter(_dexRouter);
385 
386         // create pair
387         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
388         _excludeFromMaxTransaction(address(lpPair), true);
389         _setAutomatedMarketMakerPair(address(lpPair), true);
390         
391         uint256 totalSupply = 10 * 1e12 * (10 ** decimals());
392         
393         maxBuyAmount = totalSupply * 25 / 10000;
394         maxSellAmount = totalSupply * 25 / 10000;
395         maxWallet = totalSupply * 1 / 100;
396         swapTokensAtAmount = totalSupply * 25 / 100000;
397 
398         buyMarketingFee = 100;
399         buyLiquidityFee = 100;
400         buyDevFee = 400;
401         buyTreasuryFee = 200;
402         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyTreasuryFee;
403 
404         sellMarketingFee = 100;
405         sellLiquidityFee = 100;
406         sellDevFee = 500;
407         sellTreasuryFee = 500;
408         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellTreasuryFee;
409 
410         marketingAddress = address(msg.sender);
411         devAddress = address(msg.sender);
412         treasuryAddress = address(msg.sender);
413 
414         _excludeFromMaxTransaction(msg.sender, true);
415         _excludeFromMaxTransaction(address(this), true);
416         _excludeFromMaxTransaction(address(0xdead), true);
417         _excludeFromMaxTransaction(address(marketingAddress), true);
418         _excludeFromMaxTransaction(address(dexRouter), true);
419 
420         excludeFromFees(msg.sender, true);
421         excludeFromFees(address(this), true);
422         excludeFromFees(address(0xdead), true);
423         excludeFromFees(address(marketingAddress), true);
424         excludeFromFees(address(dexRouter), true);
425 
426         
427         _createInitialSupply(msg.sender, totalSupply);
428     }
429 
430     receive() external payable {}
431 
432     
433     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
434         require(!tradingActive, "Cannot reenable trading");
435         require(blocksForPenalty <= 10, "Cannot make penalty blocks more than 10");
436         tradingActive = true;
437         swapEnabled = true;
438         tradingActiveBlock = block.number;
439         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
440         
441         emit EnabledTrading();
442     }
443     
444     // remove limits after token is stable
445     function removeLimits() external onlyOwner {
446 
447         limitsInEffect = false;
448         transferDelayEnabled = false;
449         maxBuyAmount = totalSupply();
450         maxSellAmount = totalSupply();
451 
452         emit RemovedLimits();
453     }
454 
455     function getEarlyBuyers() external view returns (address[] memory){
456         return earlyBuyers;
457     }
458 
459     function massManageRestrictedWallets(address[] calldata accounts, bool restricted) external onlyOwner {
460         for(uint256 i = 0; i < accounts.length; i++){
461             boughtEarly[accounts[i]] = restricted;
462         }
463     }
464 
465     // disable Transfer delay - cannot be reenabled
466     function disableTransferDelay() external onlyOwner {
467         transferDelayEnabled = false;
468     }
469     
470     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
471         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max buy amount lower than 0.1%");
472         maxBuyAmount = newNum * (10 ** decimals());
473         emit UpdatedMaxBuyAmount(maxBuyAmount);
474     }
475     
476     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
477         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max sell amount lower than 0.1%");
478         maxSellAmount = newNum * (10 ** decimals());
479         emit UpdatedMaxSellAmount(maxSellAmount);
480     }
481 
482     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
483         require(newNum >= (totalSupply() * 1 / 100) / (10 ** decimals()), "Cannot set max sell amount lower than 1%");
484         maxWallet = newNum * (10 ** decimals());
485         emit UpdatedMaxWalletAmount(maxWallet);
486     }
487 
488     // change the minimum amount of tokens to sell from fees
489     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
490   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
491   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
492   	    swapTokensAtAmount = newAmount;
493   	}
494     
495     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
496         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
497         emit MaxTransactionExclusion(updAds, isExcluded);
498     }
499 
500     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
501         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
502         require(wallets.length < 300, "Can only airdrop 300 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
503         for(uint256 i = 0; i < wallets.length; i++){
504             address wallet = wallets[i];
505             uint256 amount = amountsInTokens[i];
506             super._transfer(msg.sender, wallet, amount);
507         }
508     }
509     
510     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
511         if(!isEx){
512             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
513         }
514         _isExcludedMaxTransactionAmount[updAds] = isEx;
515     }
516 
517     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
518         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
519         _setAutomatedMarketMakerPair(pair, value);
520         emit SetAutomatedMarketMakerPair(pair, value);
521     }
522 
523     function _setAutomatedMarketMakerPair(address pair, bool value) private {
524         automatedMarketMakerPairs[pair] = value;
525         _excludeFromMaxTransaction(pair, value);
526         emit SetAutomatedMarketMakerPair(pair, value);
527     }
528 
529     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _treasuryFee) external onlyOwner {
530         buyMarketingFee = _marketingFee;
531         buyLiquidityFee = _liquidityFee;
532         buyDevFee = _devFee;
533         buyTreasuryFee = _treasuryFee;
534         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTreasuryFee + buyDevFee;
535         require(buyTotalFees <= 15 * FEE_DIVISOR / 100, "Must keep fees at 15% or less");
536     }
537 
538     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _treasuryFee) external onlyOwner {
539         sellMarketingFee = _marketingFee;
540         sellLiquidityFee = _liquidityFee;
541         sellDevFee = _devFee;
542         sellTreasuryFee = _treasuryFee;
543         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellTreasuryFee;
544         require(sellTotalFees <= 20 * FEE_DIVISOR / 100, "Must keep fees at 20% or less");
545     }
546 
547     function massExcludeFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
548         for(uint256 i = 0; i < accounts.length; i++){
549             _isExcludedFromFees[accounts[i]] = excluded;
550             emit ExcludeFromFees(accounts[i], excluded);
551         }
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
569         if(tradingActive){
570             require((!boughtEarly[from] && !boughtEarly[to]) || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
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
587                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
588                     require(amount + balanceOf(to) <= maxWallet, "Max Wallet Exceeded");
589                 } 
590                 //when sell
591                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
592                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
593                 } else if (!_isExcludedMaxTransactionAmount[to]){
594                     require(amount + balanceOf(to) <= maxWallet, "Max Wallet Exceeded");
595                 }
596             }
597         }
598 
599         uint256 contractTokenBalance = balanceOf(address(this));
600         
601         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
602 
603         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
604             swapping = true;
605             swapBack();
606             swapping = false;
607         }
608 
609         bool takeFee = true;
610         // if any account belongs to _isExcludedFromFee account then remove the fee
611         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
612             takeFee = false;
613         }
614         
615         uint256 fees = 0;
616 
617         // only take fees on buys/sells, do not take on wallet transfers
618         if(takeFee){
619             // bot/sniper penalty.
620             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && !_isExcludedFromFees[to] && buyTotalFees > 0){
621                 
622                 if(!earlyBuyPenaltyInEffect()){
623                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
624                     maxBuyAmount -= 1;
625                 }
626 
627                 if(!boughtEarly[to]){
628                     boughtEarly[to] = true;
629                     botsCaught += 1;
630                     earlyBuyers.push(to);
631                     emit CaughtEarlyBuyer(to);
632                 }
633 
634                 fees = amount * buyTotalFees / FEE_DIVISOR;
635         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
636                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
637                 tokensForDev += fees * buyDevFee / buyTotalFees;
638                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
639             }
640 
641             // on sell
642             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
643                 fees = amount * sellTotalFees / FEE_DIVISOR;
644                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
645                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
646                 tokensForDev += fees * sellDevFee / sellTotalFees;
647                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
648             }
649 
650             // on buy
651             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
652         	    fees = amount * buyTotalFees / FEE_DIVISOR;
653         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
654                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
655                 tokensForDev += fees * buyDevFee / buyTotalFees;
656                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
657             }
658             
659             if(fees > 0){    
660                 super._transfer(from, address(this), fees);
661             }
662         	
663         	amount -= fees;
664         }
665 
666         super._transfer(from, to, amount);
667     }
668 
669     function earlyBuyPenaltyInEffect() public view returns (bool){
670         return block.number < blockForPenaltyEnd;
671     }
672 
673     function swapTokensForEth(uint256 tokenAmount) private {
674 
675         // generate the uniswap pair path of token -> weth
676         address[] memory path = new address[](2);
677         path[0] = address(this);
678         path[1] = dexRouter.WETH();
679 
680         _approve(address(this), address(dexRouter), tokenAmount);
681 
682         // make the swap
683         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
684             tokenAmount,
685             0, // accept any amount of ETH
686             path,
687             address(this),
688             block.timestamp
689         );
690     }
691     
692     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
693         // approve token transfer to cover all possible scenarios
694         _approve(address(this), address(dexRouter), tokenAmount);
695 
696         // add the liquidity
697         dexRouter.addLiquidityETH{value: ethAmount}(
698             address(this),
699             tokenAmount,
700             0, // slippage is unavoidable
701             0, // slippage is unavoidable
702             address(0xdead),
703             block.timestamp
704         );
705     }
706 
707     function swapBack() private {
708 
709         uint256 contractBalance = balanceOf(address(this));
710         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev + tokensForTreasury;
711         
712         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
713 
714         if(contractBalance > swapTokensAtAmount * 20){
715             contractBalance = swapTokensAtAmount * 20;
716         }
717 
718         bool success;
719         
720         // Halve the amount of liquidity tokens
721         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
722         
723         swapTokensForEth(contractBalance - liquidityTokens); 
724         
725         uint256 ethBalance = address(this).balance;
726         uint256 ethForLiquidity = ethBalance;
727 
728         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
729         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
730         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
731 
732         ethForLiquidity -= ethForMarketing + ethForDev + ethForTreasury;
733             
734         tokensForLiquidity = 0;
735         tokensForMarketing = 0;
736         tokensForDev = 0;
737         tokensForTreasury = 0;
738         
739         if(liquidityTokens > 0 && ethForLiquidity > 0){
740             addLiquidity(liquidityTokens, ethForLiquidity);
741         }
742 
743         (success,) = address(devAddress).call{value: ethForDev}("");
744 
745         (success,) = address(treasuryAddress).call{value: ethForTreasury}("");
746 
747         (success,) = address(marketingAddress).call{value: address(this).balance}("");
748     }
749 
750     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
751         require(_token != address(0), "_token address cannot be 0");
752         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
753         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
754         _sent = IERC20(_token).transfer(_to, _contractBalance);
755         emit TransferForeignToken(_token, _contractBalance);
756     }
757 
758     // withdraw ETH if stuck or someone sends to the address
759     function withdrawStuckETH() external onlyOwner {
760         bool success;
761         (success,) = address(msg.sender).call{value: address(this).balance}("");
762     }
763 
764     function setMarketingAddress(address _marketingAddress) external onlyOwner {
765         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
766         marketingAddress = payable(_marketingAddress);
767         emit UpdatedMarketingAddress(_marketingAddress);
768     }
769     
770     function setDevAddress(address _devAddress) external onlyOwner {
771         require(_devAddress != address(0), "_marketingAddress address cannot be 0");
772         devAddress = payable(_devAddress);
773         emit UpdatedDevAddress(_devAddress);
774     }
775 
776     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
777         require(_treasuryAddress != address(0), "_marketingAddress address cannot be 0");
778         treasuryAddress = payable(_treasuryAddress);
779         emit UpdatedTreasuryAddress(_treasuryAddress);
780     }
781 
782     // force Swap back if slippage issues.
783     function forceSwapBack() external onlyOwner {
784         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
785         swapping = true;
786         swapBack();
787         swapping = false;
788         emit OwnerForcedSwapBack(block.timestamp);
789     }
790 }