1 /**
2 
3 🌒😎🌘
4 
5 twitter.com/Matt_Furie/status/1589830492022779904?s=20
6 t.me/moonsunglassesmoon
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.17;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address sender,
81         address recipient,
82         uint256 amount
83     ) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     mapping(address => uint256) private _balances;
119 
120     mapping(address => mapping(address => uint256)) private _allowances;
121 
122     uint256 private _totalSupply;
123 
124     string private _name;
125     string private _symbol;
126 
127     constructor(string memory name_, string memory symbol_) {
128         _name = name_;
129         _symbol = symbol_;
130     }
131 
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135 
136     function symbol() public view virtual override returns (string memory) {
137         return _symbol;
138     }
139 
140     function decimals() public view virtual override returns (uint8) {
141         return 18;
142     }
143 
144     function totalSupply() public view virtual override returns (uint256) {
145         return _totalSupply;
146     }
147 
148     function balanceOf(address account) public view virtual override returns (uint256) {
149         return _balances[account];
150     }
151 
152     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
153         _transfer(_msgSender(), recipient, amount);
154         return true;
155     }
156 
157     function allowance(address owner, address spender) public view virtual override returns (uint256) {
158         return _allowances[owner][spender];
159     }
160 
161     function approve(address spender, uint256 amount) public virtual override returns (bool) {
162         _approve(_msgSender(), spender, amount);
163         return true;
164     }
165 
166     function transferFrom(
167         address sender,
168         address recipient,
169         uint256 amount
170     ) public virtual override returns (bool) {
171         _transfer(sender, recipient, amount);
172 
173         uint256 currentAllowance = _allowances[sender][_msgSender()];
174         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
175         unchecked {
176             _approve(sender, _msgSender(), currentAllowance - amount);
177         }
178 
179         return true;
180     }
181 
182     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
184         return true;
185     }
186 
187     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
188         uint256 currentAllowance = _allowances[_msgSender()][spender];
189         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
190         unchecked {
191             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
192         }
193 
194         return true;
195     }
196 
197     function _transfer(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) internal virtual {
202         require(sender != address(0), "ERC20: transfer from the zero address");
203         require(recipient != address(0), "ERC20: transfer to the zero address");
204 
205         uint256 senderBalance = _balances[sender];
206         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
207         unchecked {
208             _balances[sender] = senderBalance - amount;
209         }
210         _balances[recipient] += amount;
211 
212         emit Transfer(sender, recipient, amount);
213     }
214 
215     function _createInitialSupply(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: mint to the zero address");
217 
218         _totalSupply += amount;
219         _balances[account] += amount;
220         emit Transfer(address(0), account, amount);
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
268 interface IDexRouter {
269     function factory() external pure returns (address);
270     function WETH() external pure returns (address);
271 
272     function swapExactTokensForETHSupportingFeeOnTransferTokens(
273         uint amountIn,
274         uint amountOutMin,
275         address[] calldata path,
276         address to,
277         uint deadline
278     ) external;
279 
280     function swapExactETHForTokensSupportingFeeOnTransferTokens(
281         uint amountOutMin,
282         address[] calldata path,
283         address to,
284         uint deadline
285     ) external payable;
286 
287     function addLiquidityETH(
288         address token,
289         uint256 amountTokenDesired,
290         uint256 amountTokenMin,
291         uint256 amountETHMin,
292         address to,
293         uint256 deadline
294     )
295         external
296         payable
297         returns (
298             uint256 amountToken,
299             uint256 amountETH,
300             uint256 liquidity
301         );
302 }
303 
304 interface IDexFactory {
305     function createPair(address tokenA, address tokenB)
306         external
307         returns (address pair);
308 }
309 
310 contract MOONSUNGLASSESMOON is ERC20, Ownable {
311 
312     uint256 public maxBuyAmount;
313     uint256 public maxSellAmount;
314     uint256 public maxWalletAmount;
315 
316     IDexRouter public dexRouter;
317     address public lpPair;
318 
319     bool private swapping;
320     uint256 public swapTokensAtAmount;
321 
322     address operationsAddress;
323 
324     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
325     mapping (address => bool) public bot;
326     uint256 public botsCaught;
327 
328     bool public limitsInEffect = true;
329     bool public tradingActive = false;
330     bool public swapEnabled = false;
331 
332      // Anti-bot and anti-whale mappings and variables
333     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
334     bool public transferDelayEnabled = true;
335 
336     uint256 public buyTotalFees;
337     uint256 public buyOperationsFee;
338     uint256 public buyLiquidityFee;
339 
340     uint256 public sellTotalFees;
341     uint256 public sellOperationsFee;
342     uint256 public sellLiquidityFee;
343 
344     uint256 public tokensForOperations;
345     uint256 public tokensForLiquidity;
346 
347     /******************/
348 
349     // exlcude from fees and max transaction amount
350     mapping (address => bool) private _isExcludedFromFees;
351     mapping (address => bool) public _isExcludedMaxTransactionAmount;
352 
353     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
354     // could be subject to a maximum transfer amount
355     mapping (address => bool) public automatedMarketMakerPairs;
356 
357     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
358 
359     event EnabledTrading();
360 
361     event RemovedLimits();
362 
363     event ExcludeFromFees(address indexed account, bool isExcluded);
364 
365     event UpdatedMaxBuyAmount(uint256 newAmount);
366 
367     event UpdatedMaxSellAmount(uint256 newAmount);
368 
369     event UpdatedMaxWalletAmount(uint256 newAmount);
370 
371     event UpdatedOperationsAddress(address indexed newWallet);
372 
373     event MaxTransactionExclusion(address _address, bool excluded);
374 
375     event BuyBackTriggered(uint256 amount);
376 
377     event OwnerForcedSwapBack(uint256 timestamp);
378  
379     event CaughtEarlyBuyer(address sniper);
380 
381     event SwapAndLiquify(
382         uint256 tokensSwapped,
383         uint256 ethReceived,
384         uint256 tokensIntoLiquidity
385     );
386 
387     event TransferForeignToken(address token, uint256 amount);
388 
389     constructor() ERC20(unicode"?", unicode"🌒😎🌘") {
390 
391         address newOwner = msg.sender; // can leave alone if owner is deployer.
392 
393         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
394         dexRouter = _dexRouter;
395 
396         // create pair
397         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
398         _excludeFromMaxTransaction(address(lpPair), true);
399         _setAutomatedMarketMakerPair(address(lpPair), true);
400 
401         uint256 totalSupply = 1 * 1e9 * 1e18;
402 
403         maxBuyAmount = totalSupply * 2 / 100;
404         maxSellAmount = totalSupply * 2 / 100;
405         maxWalletAmount = totalSupply * 3 / 100;
406         swapTokensAtAmount = totalSupply * 1 / 1000;
407 
408         buyOperationsFee = 20;
409         buyLiquidityFee = 0;
410         buyTotalFees = buyOperationsFee + buyLiquidityFee;
411 
412         sellOperationsFee = 20;
413         sellLiquidityFee = 0;
414         sellTotalFees = sellOperationsFee + sellLiquidityFee;
415 
416         _excludeFromMaxTransaction(newOwner, true);
417         _excludeFromMaxTransaction(address(this), true);
418         _excludeFromMaxTransaction(address(0xdead), true);
419 
420         excludeFromFees(newOwner, true);
421         excludeFromFees(address(this), true);
422         excludeFromFees(address(0xdead), true);
423 
424         operationsAddress = address(newOwner);
425 
426         _createInitialSupply(newOwner, totalSupply);
427         transferOwnership(newOwner);
428     }
429 
430     receive() external payable {}
431 
432     // only enable if no plan to airdrop
433 
434     function enableTrading() external onlyOwner {
435         require(!tradingActive, "Cannot reenable trading");
436         tradingActive = true;
437         swapEnabled = true;
438         tradingActiveBlock = block.number;
439         emit EnabledTrading();
440     }
441 
442     // remove limits after token is stable
443     function removeLimits() external onlyOwner {
444         limitsInEffect = false;
445         transferDelayEnabled = false;
446         emit RemovedLimits();
447     }
448 
449     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
450         bot[wallet] = flag;
451     }
452 
453     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
454         for(uint256 i = 0; i < wallets.length; i++){
455             bot[wallets[i]] = flag;
456         }
457     }
458 
459     // disable Transfer delay - cannot be reenabled
460     function disableTransferDelay() external onlyOwner {
461         transferDelayEnabled = false;
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
496         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
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
513 
514         _setAutomatedMarketMakerPair(pair, value);
515         emit SetAutomatedMarketMakerPair(pair, value);
516     }
517 
518     function _setAutomatedMarketMakerPair(address pair, bool value) private {
519         automatedMarketMakerPairs[pair] = value;
520 
521         _excludeFromMaxTransaction(pair, value);
522 
523         emit SetAutomatedMarketMakerPair(pair, value);
524     }
525 
526     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
527         buyOperationsFee = _operationsFee;
528         buyLiquidityFee = _liquidityFee;
529         buyTotalFees = buyOperationsFee + buyLiquidityFee;
530         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
531     }
532 
533     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
534         sellOperationsFee = _operationsFee;
535         sellLiquidityFee = _liquidityFee;
536         sellTotalFees = sellOperationsFee + sellLiquidityFee;
537         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
538     }
539 
540     function excludeFromFees(address account, bool excluded) public onlyOwner {
541         _isExcludedFromFees[account] = excluded;
542         emit ExcludeFromFees(account, excluded);
543     }
544 
545     function _transfer(address from, address to, uint256 amount) internal override {
546 
547         require(from != address(0), "ERC20: transfer from the zero address");
548         require(to != address(0), "ERC20: transfer to the zero address");
549         require(amount > 0, "amount must be greater than 0");
550 
551         if(!tradingActive){
552             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
553         }
554 
555         require(!bot[from] && !bot[to], "Bots cannot transfer tokens in or out except to owner or dead address.");
556 
557         if(limitsInEffect){
558             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
559 
560                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
561                 if (transferDelayEnabled){
562                     if (to != address(dexRouter) && to != address(lpPair)){
563                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
564                         _holderLastTransferTimestamp[tx.origin] = block.number;
565                         _holderLastTransferTimestamp[to] = block.number;
566                     }
567                 }
568     
569                 //when buy
570                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
571                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
572                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
573                 }
574                 //when sell
575                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
576                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
577                 }
578                 else if (!_isExcludedMaxTransactionAmount[to]){
579                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
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
590 
591             swapBack();
592 
593             swapping = false;
594         }
595 
596         bool takeFee = true;
597         // if any account belongs to _isExcludedFromFee account then remove the fee
598         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
599             takeFee = false;
600         }
601 
602         uint256 fees = 0;
603         // only take fees on buys/sells, do not take on wallet transfers
604         if(takeFee){
605             // on sell
606             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
607                 fees = amount * sellTotalFees / 100;
608                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
609                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
610             }
611 
612             // on buy
613             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
614         	    fees = amount * buyTotalFees / 100;
615         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
616                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
617             }
618 
619             if(fees > 0){
620                 super._transfer(from, address(this), fees);
621             }
622 
623         	amount -= fees;
624         }
625 
626         super._transfer(from, to, amount);
627     }
628     function swapTokensForEth(uint256 tokenAmount) private {
629 
630         // generate the uniswap pair path of token -> weth
631         address[] memory path = new address[](2);
632         path[0] = address(this);
633         path[1] = dexRouter.WETH();
634 
635         _approve(address(this), address(dexRouter), tokenAmount);
636 
637         // make the swap
638         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
639             tokenAmount,
640             0, // accept any amount of ETH
641             path,
642             address(this),
643             block.timestamp
644         );
645     }
646 
647     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
648         // approve token transfer to cover all possible scenarios
649         _approve(address(this), address(dexRouter), tokenAmount);
650 
651         // add the liquidity
652         dexRouter.addLiquidityETH{value: ethAmount}(
653             address(this),
654             tokenAmount,
655             0, // slippage is unavoidable
656             0, // slippage is unavoidable
657             address(0xdead),
658             block.timestamp
659         );
660     }
661 
662     function swapBack() private {
663         uint256 contractBalance = balanceOf(address(this));
664         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
665 
666         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
667 
668         if(contractBalance > swapTokensAtAmount * 60){
669             contractBalance = swapTokensAtAmount * 60;
670         }
671 
672         bool success;
673 
674         // Halve the amount of liquidity tokens
675         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
676 
677         swapTokensForEth(contractBalance - liquidityTokens);
678 
679         uint256 ethBalance = address(this).balance;
680         uint256 ethForLiquidity = ethBalance;
681 
682         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
683 
684         ethForLiquidity -= ethForOperations;
685 
686         tokensForLiquidity = 0;
687         tokensForOperations = 0;
688 
689         if(liquidityTokens > 0 && ethForLiquidity > 0){
690             addLiquidity(liquidityTokens, ethForLiquidity);
691         }
692 
693         if(address(this).balance > 0){
694             (success,) = address(operationsAddress).call{value: address(this).balance}("");
695         }
696     }
697 
698     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
699         require(_token != address(0), "_token address cannot be 0");
700         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
701         _sent = IERC20(_token).transfer(_to, _contractBalance);
702         emit TransferForeignToken(_token, _contractBalance);
703     }
704 
705     // withdraw ETH if stuck or someone sends to the address
706     function withdrawStuckETH() external onlyOwner {
707         bool success;
708         (success,) = address(msg.sender).call{value: address(this).balance}("");
709     }
710 
711     function setOperationsAddress(address _operationsAddress) external onlyOwner {
712         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
713         operationsAddress = payable(_operationsAddress);
714     }
715 
716     // force Swap back if slippage issues.
717     function forceSwapBack() external onlyOwner {
718         require(balanceOf(address(this)) >= 0, "No tokens to swap");
719         swapping = true;
720         swapBack();
721         swapping = false;
722         emit OwnerForcedSwapBack(block.timestamp);
723     }
724 
725 }