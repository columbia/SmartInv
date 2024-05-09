1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.17;
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
162         uint256 currentAllowance = _allowances[sender][_msgSender()];
163         if(currentAllowance != type(uint256).max){
164             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
165             unchecked {
166                 _approve(sender, _msgSender(), currentAllowance - amount);
167             }
168         }
169 
170         _transfer(sender, recipient, amount);
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
216     function _burn(address account, uint256 amount) internal virtual {
217         require(account != address(0), "LERC20: mint to the zero address");
218         _totalSupply -= amount;
219         _balances[account] -= amount;
220         emit Transfer(account, address(0), amount);
221     }
222 
223     function _approve(
224         address owner,
225         address spender,
226         uint256 amount
227     ) internal virtual {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230 
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 }
235 
236 contract Ownable is Context {
237     address private _owner;
238 
239     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
240     
241     constructor () {
242         address msgSender = _msgSender();
243         _owner = msgSender;
244         emit OwnershipTransferred(address(0), msgSender);
245     }
246 
247     function owner() public view returns (address) {
248         return _owner;
249     }
250 
251     modifier onlyOwner() {
252         require(_owner == _msgSender(), "Ownable: caller is not the owner");
253         _;
254     }
255 
256     function renounceOwnership() external virtual onlyOwner {
257         emit OwnershipTransferred(_owner, address(0));
258         _owner = address(0);
259     }
260 
261     function transferOwnership(address newOwner) public virtual onlyOwner {
262         require(newOwner != address(0), "Ownable: new owner is the zero address");
263         emit OwnershipTransferred(_owner, newOwner);
264         _owner = newOwner;
265     }
266 }
267 
268 contract TokenHandler is Ownable {
269     function sendTokenToOwner(address token) external onlyOwner {
270         if(IERC20(token).balanceOf(address(this)) > 0){
271             IERC20(token).transfer(owner(), IERC20(token).balanceOf(address(this)));
272         }
273     }
274 }
275 
276 interface ILpPair {
277     function sync() external;
278 }
279 
280 interface IDexRouter {
281     function factory() external pure returns (address);
282     function WETH() external pure returns (address);
283     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
284     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
285     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
286     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
287     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
288     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
289 }
290 
291 interface IDexFactory {
292     function createPair(address tokenA, address tokenB) external returns (address pair);
293 }
294 
295 contract KokanKano is ERC20, Ownable {
296 
297     uint256 public maxBuyAmount;
298     uint256 public maxSellAmount;
299     uint256 public maxWallet;
300 
301     IDexRouter public immutable dexRouter;
302     address public immutable lpPair;   
303 
304     bool private swapping;
305     uint256 public swapTokensAtAmount;
306 
307     address public treasuryAddress;
308 
309     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
310     uint256 public blockForPenaltyEnd;
311 
312     bool public limitsInEffect = true;
313     bool public tradingActive = false;
314     bool public swapEnabled = false;
315 
316      // Anti-bot and anti-whale mappings and variables
317     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
318     bool public transferDelayEnabled = true;
319 
320     uint256 public buyTotalFees;
321     uint256 public buyTreasuryFee;
322     uint256 public buyLiquidityFee;
323 
324     uint256 public sellTotalFees;
325     uint256 public sellTreasuryFee;
326     uint256 public sellLiquidityFee;
327 
328     uint256 public constant FEE_DIVISOR = 10000;
329 
330     uint256 public tokensForTreasury;
331     uint256 public tokensForLiquidity;
332 
333     // exlcude from fees and max transaction amount
334     mapping (address => bool) private _isExcludedFromFees;
335     mapping (address => bool) public _isExcludedMaxTransactionAmount;
336 
337     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
338     // could be subject to a maximum transfer amount
339     mapping (address => bool) public automatedMarketMakerPairs;
340 
341     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
342 
343     event EnabledTrading();
344 
345     event RemovedLimits();
346 
347     event ExcludeFromFees(address indexed account, bool isExcluded);
348 
349     event UpdatedMaxBuyAmount(uint256 newAmount);
350 
351     event UpdatedMaxSellAmount(uint256 newAmount);
352 
353     event UpdatedMaxWalletAmount(uint256 newAmount);
354 
355     event UpdatedTreasuryAddress(address indexed newWallet);
356 
357     event MaxTransactionExclusion(address _address, bool excluded);
358 
359     event OwnerForcedSwapBack(uint256 timestamp);
360 
361     event SwapAndLiquify(
362         uint256 tokensSwapped,
363         uint256 ethReceived,
364         uint256 tokensIntoLiquidity
365     );
366 
367     event TransferForeignToken(address token, uint256 amount);
368 
369     constructor(string memory name_, string memory symbol_) ERC20( name_, symbol_) {
370         
371         address newOwner = msg.sender; // can leave alone if owner is deployer.
372         address _dexRouter;
373 
374         // automatically detect router
375         if(block.chainid == 1){
376             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
377         } else if(block.chainid == 5){
378             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
379         } else if(block.chainid == 56){
380             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
381         } else if(block.chainid == 97){
382             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
383         } else if(block.chainid == 137){
384             _dexRouter = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; // Polygon: Quickswap 
385         } else if(block.chainid == 80001){
386             _dexRouter = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; // Mumbai Polygon: Quickswap 
387         } else {
388             revert("Chain not configured");
389         }
390 
391         // initialize router
392         dexRouter = IDexRouter(_dexRouter);
393 
394         // create pair
395         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
396         _excludeFromMaxTransaction(address(lpPair), true);
397         _setAutomatedMarketMakerPair(address(lpPair), true);
398 
399         uint256 totalSupply = 1 * 1e9 * 1e18;
400         
401         maxBuyAmount = totalSupply * 5 / 1000;
402         maxSellAmount = totalSupply * 5 / 1000;
403         maxWallet = totalSupply * 1 / 100;
404         swapTokensAtAmount = totalSupply * 1 / 10000;
405 
406         buyTreasuryFee = 50;
407         buyLiquidityFee = 50;
408         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
409 
410         sellTreasuryFee = 50;
411         sellLiquidityFee = 50;
412         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
413 
414         treasuryAddress = address(0x5AbD2189C0e1FeE86F77c967E783F987B3F26e2A);
415 
416         _excludeFromMaxTransaction(newOwner, true);
417         _excludeFromMaxTransaction(address(this), true);
418         _excludeFromMaxTransaction(address(0xdead), true);
419         _excludeFromMaxTransaction(address(treasuryAddress), true);
420 
421         excludeFromFees(newOwner, true);
422         excludeFromFees(address(this), true);
423         excludeFromFees(address(0xdead), true);
424         excludeFromFees(address(treasuryAddress), true);
425 
426         _approve(address(this), address(dexRouter), type(uint256).max);
427         _approve(address(msg.sender), address(dexRouter), totalSupply);
428 
429         _createInitialSupply(msg.sender, totalSupply);
430         transferOwnership(newOwner);
431     }
432 
433     receive() external payable {}
434 
435     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
436         require(!tradingActive, "Trading is already started");
437         //standard enable trading
438         tradingActive = true;
439         swapEnabled = true;
440         tradingActiveBlock = block.number;
441         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
442         emit EnabledTrading();
443     }
444     
445     // remove limits after token is stable
446     function removeLimits() external onlyOwner {
447         limitsInEffect = false;
448         transferDelayEnabled = false;
449         maxBuyAmount = totalSupply();
450         maxSellAmount = totalSupply();
451         emit RemovedLimits();
452     }
453 
454     // disable Transfer delay - cannot be reenabled
455     function disableTransferDelay() external onlyOwner {
456         transferDelayEnabled = false;
457     }
458 
459     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
460         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
461         maxBuyAmount = newNum * (10**18);
462         emit UpdatedMaxBuyAmount(maxBuyAmount);
463     }
464     
465     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
466         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
467         maxSellAmount = newNum * (10**18);
468         emit UpdatedMaxSellAmount(maxSellAmount);
469     }
470 
471      function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
472         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set max wallet lower than 1%");
473         maxWallet = newNum * (10**18);
474     }
475 
476     // change the minimum amount of tokens to sell from fees
477     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
478   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
479   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
480   	    swapTokensAtAmount = newAmount;
481   	}
482     
483     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
484         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
485         emit MaxTransactionExclusion(updAds, isExcluded);
486     }
487 
488     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
489         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
490         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
491         for(uint256 i = 0; i < wallets.length; i++){
492             super._transfer(msg.sender, wallets[i], amountsInTokens[i]);
493         }
494     }
495     
496     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
497         if(!isEx){
498             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
499         }
500         _isExcludedMaxTransactionAmount[updAds] = isEx;
501     }
502 
503     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
504         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
505         _setAutomatedMarketMakerPair(pair, value);
506         emit SetAutomatedMarketMakerPair(pair, value);
507     }
508 
509     function _setAutomatedMarketMakerPair(address pair, bool value) private {
510         automatedMarketMakerPairs[pair] = value;
511         _excludeFromMaxTransaction(pair, value);
512         emit SetAutomatedMarketMakerPair(pair, value);
513     }
514 
515     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
516         buyTreasuryFee = _treasuryFee;
517         buyLiquidityFee = _liquidityFee;
518         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
519         require(buyTotalFees <= 200, "Must keep buy fees at 2% or less");
520     }
521 
522     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
523         sellTreasuryFee = _treasuryFee;
524         sellLiquidityFee = _liquidityFee;
525         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
526         require(sellTotalFees <= 200, "Must keep fees at 2% or less");
527     }
528 
529     function excludeFromFees(address account, bool excluded) public onlyOwner {
530         _isExcludedFromFees[account] = excluded;
531         emit ExcludeFromFees(account, excluded);
532     }
533 
534     function _transfer(address from, address to, uint256 amount) internal override {
535 
536         require(from != address(0), "ERC20: transfer from the zero address");
537         require(to != address(0), "ERC20: transfer to the zero address");
538         require(amount > 0, "amount must be greater than 0");
539         
540         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping){
541             super._transfer(from, to, amount);
542             return;
543         }
544 
545         require(tradingActive, "Trading is not active.");
546 
547         if(limitsInEffect){                
548             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
549             if (transferDelayEnabled){
550                 if (to != address(dexRouter) && to != address(lpPair)){
551                     require(_holderLastTransferBlock[tx.origin] < block.number && _holderLastTransferBlock[to] < block.number, "_transfer:: Transfer Delay enabled.  Try again later.");
552                     _holderLastTransferBlock[tx.origin] = block.number;
553                     _holderLastTransferBlock[to] = block.number;
554                 }
555             }
556                 
557             //when buy
558             if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
559                 require(amount <= maxBuyAmount, "Buy transfer amt exceeds the max buy.");
560                 require(amount + balanceOf(to) <= maxWallet, "Cannot Exceed max wallet");
561             } 
562             //when sell
563             else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
564                 require(amount <= maxBuyAmount, "Sell transfer amt exceeds the max sell.");
565             } 
566             else if (!_isExcludedMaxTransactionAmount[to]){
567                 require(amount + balanceOf(to) <= maxWallet, "Cannot Exceed max wallet");
568             }
569         }
570 
571         uint256 contractTokenBalance = balanceOf(address(this));
572         
573         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
574 
575         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from]) {
576             swapping = true;
577             swapBack();
578             swapping = false;
579         }
580 
581         uint256 fees = 0;
582         
583         // bot/sniper penalty.
584         if(earlyBuyPenInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
585             fees = amount * 6000 / FEE_DIVISOR;
586             tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
587             tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
588         } else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){ // on sell
589             fees = amount * sellTotalFees / FEE_DIVISOR;
590             tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
591             tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
592         } else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) { // on buy
593             fees = amount * buyTotalFees / FEE_DIVISOR;
594             tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
595             tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
596         }
597         
598         if(fees > 0){    
599             super._transfer(from, address(this), fees);
600         }
601         
602         amount -= fees;
603         
604         super._transfer(from, to, amount);
605     }
606 
607     function earlyBuyPenInEffect() public view returns (bool){
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
618         // make the swap
619         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
620             tokenAmount,
621             0, // accept any amount of ETH
622             path,
623             address(this),
624             block.timestamp
625         );
626     }
627 
628     function getCurrentBlock() external view returns (uint256) {
629         return block.number;
630     }
631 
632     function getCurrentTimestamp() external view returns (uint256) {
633         return block.timestamp;
634     }
635     
636     function swapBack() private {
637 
638         uint256 contractBalance = balanceOf(address(this));
639         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
640         
641         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
642 
643         if(contractBalance > swapTokensAtAmount * 60){
644             contractBalance = swapTokensAtAmount * 60;
645         }
646         
647         // Halve the amount of liquidity tokens
648         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
649 
650         if(liquidityTokens > 0){
651             super._transfer(address(this), lpPair, liquidityTokens);
652             try ILpPair(lpPair).sync(){} catch {}
653             contractBalance -= liquidityTokens;
654             totalTokensToSwap -= tokensForLiquidity;
655             tokensForLiquidity = 0;
656         }
657 
658         if(contractBalance > 0){
659             swapTokensForEth(contractBalance);
660 
661             uint256 ethBalance = address(this).balance;
662             
663             tokensForTreasury = 0;
664 
665             bool success = false;
666 
667             if(ethBalance > 0){
668                 (success,) = treasuryAddress.call{value: ethBalance}("");   
669             }
670         }
671     }
672 
673     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
674         require(_token != address(0), "_token address cannot be 0");
675         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
676         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
677         _sent = IERC20(_token).transfer(_to, _contractBalance);
678         emit TransferForeignToken(_token, _contractBalance);
679     }
680 
681     // withdraw ETH if stuck or someone sends to the address
682     function withdrawStuckETH() external onlyOwner {
683         bool success;
684         (success,) = address(msg.sender).call{value: address(this).balance}("");
685     }
686 
687     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
688         require(_treasuryAddress != address(0), "address cannot be 0");
689         treasuryAddress = payable(_treasuryAddress);
690         emit UpdatedTreasuryAddress(_treasuryAddress);
691     }
692 
693     // force Swap back if slippage issues.
694     function forceSwapBack() external onlyOwner {
695         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
696         swapping = true;
697         swapBack();
698         swapping = false;
699         emit OwnerForcedSwapBack(block.timestamp);
700     }
701 }