1 /**
2 
3 
4 */
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.15;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns (string memory);
101 
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns (string memory);
106 
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns (uint8);
111 }
112 
113 contract ERC20 is Context, IERC20, IERC20Metadata {
114     mapping(address => uint256) private _balances;
115 
116     mapping(address => mapping(address => uint256)) private _allowances;
117 
118     uint256 private _totalSupply;
119 
120     string private _name;
121     string private _symbol;
122 
123     constructor(string memory name_, string memory symbol_) {
124         _name = name_;
125         _symbol = symbol_;
126     }
127 
128     function name() public view virtual override returns (string memory) {
129         return _name;
130     }
131 
132     function symbol() public view virtual override returns (string memory) {
133         return _symbol;
134     }
135 
136     function decimals() public view virtual override returns (uint8) {
137         return 18;
138     }
139 
140     function totalSupply() public view virtual override returns (uint256) {
141         return _totalSupply;
142     }
143 
144     function balanceOf(address account) public view virtual override returns (uint256) {
145         return _balances[account];
146     }
147 
148     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
149         _transfer(_msgSender(), recipient, amount);
150         return true;
151     }
152 
153     function allowance(address owner, address spender) public view virtual override returns (uint256) {
154         return _allowances[owner][spender];
155     }
156 
157     function approve(address spender, uint256 amount) public virtual override returns (bool) {
158         _approve(_msgSender(), spender, amount);
159         return true;
160     }
161 
162     function transferFrom(
163         address sender,
164         address recipient,
165         uint256 amount
166     ) public virtual override returns (bool) {
167         _transfer(sender, recipient, amount);
168 
169         uint256 currentAllowance = _allowances[sender][_msgSender()];
170         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
171         unchecked {
172             _approve(sender, _msgSender(), currentAllowance - amount);
173         }
174 
175         return true;
176     }
177 
178     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
180         return true;
181     }
182 
183     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
184         uint256 currentAllowance = _allowances[_msgSender()][spender];
185         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
186         unchecked {
187             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
188         }
189 
190         return true;
191     }
192 
193     function _transfer(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) internal virtual {
198         require(sender != address(0), "ERC20: transfer from the zero address");
199         require(recipient != address(0), "ERC20: transfer to the zero address");
200 
201         uint256 senderBalance = _balances[sender];
202         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
203         unchecked {
204             _balances[sender] = senderBalance - amount;
205         }
206         _balances[recipient] += amount;
207 
208         emit Transfer(sender, recipient, amount);
209     }
210 
211     function _createInitialSupply(address account, uint256 amount) internal virtual {
212         require(account != address(0), "ERC20: mint to the zero address");
213 
214         _totalSupply += amount;
215         _balances[account] += amount;
216         emit Transfer(address(0), account, amount);
217     }
218 
219     function _burn(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: burn from the zero address");
221         uint256 accountBalance = _balances[account];
222         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
223         unchecked {
224             _balances[account] = accountBalance - amount;
225             // Overflow not possible: amount <= accountBalance <= totalSupply.
226             _totalSupply -= amount;
227         }
228 
229         emit Transfer(account, address(0), amount);
230     }
231 
232     function _approve(
233         address owner,
234         address spender,
235         uint256 amount
236     ) internal virtual {
237         require(owner != address(0), "ERC20: approve from the zero address");
238         require(spender != address(0), "ERC20: approve to the zero address");
239 
240         _allowances[owner][spender] = amount;
241         emit Approval(owner, spender, amount);
242     }
243 }
244 
245 contract Ownable is Context {
246     address private _owner;
247 
248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249 
250     constructor () {
251         address msgSender = _msgSender();
252         _owner = msgSender;
253         emit OwnershipTransferred(address(0), msgSender);
254     }
255 
256     function owner() public view returns (address) {
257         return _owner;
258     }
259 
260     modifier onlyOwner() {
261         require(_owner == _msgSender(), "Ownable: caller is not the owner");
262         _;
263     }
264 
265     function renounceOwnership() external virtual onlyOwner {
266         emit OwnershipTransferred(_owner, address(0));
267         _owner = address(0);
268     }
269 
270     function transferOwnership(address newOwner) public virtual onlyOwner {
271         require(newOwner != address(0), "Ownable: new owner is the zero address");
272         emit OwnershipTransferred(_owner, newOwner);
273         _owner = newOwner;
274     }
275 }
276 
277 interface IDexRouter {
278     function factory() external pure returns (address);
279     function WETH() external pure returns (address);
280 
281     function swapExactTokensForETHSupportingFeeOnTransferTokens(
282         uint amountIn,
283         uint amountOutMin,
284         address[] calldata path,
285         address to,
286         uint deadline
287     ) external;
288 
289     function swapExactETHForTokensSupportingFeeOnTransferTokens(
290         uint amountOutMin,
291         address[] calldata path,
292         address to,
293         uint deadline
294     ) external payable;
295 
296     function addLiquidityETH(
297         address token,
298         uint256 amountTokenDesired,
299         uint256 amountTokenMin,
300         uint256 amountETHMin,
301         address to,
302         uint256 deadline
303     )
304         external
305         payable
306         returns (
307             uint256 amountToken,
308             uint256 amountETH,
309             uint256 liquidity
310         );
311 }
312 
313 interface IDexFactory {
314     function createPair(address tokenA, address tokenB)
315         external
316         returns (address pair);
317 }
318 
319 contract SonOfShiba is ERC20, Ownable {
320 
321     uint256 public maxBuyAmount;
322     uint256 public maxSellAmount;
323     uint256 public maxWalletAmount;
324 
325     IDexRouter public dexRouter;
326     address public lpPair;
327 
328     bool private swapping;
329     uint256 public swapTokensAtAmount;
330 
331     address operationsAddress;
332     address devAddress;
333 
334     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
335     uint256 public blockForPenaltyEnd;
336     mapping (address => bool) public boughtEarly;
337     uint256 public botsCaught;
338 
339     bool public limitsInEffect = true;
340     bool public tradingActive = false;
341     bool public swapEnabled = false;
342 
343      // Anti-bot and anti-whale mappings and variables
344     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
345     bool public transferDelayEnabled = true;
346 
347     uint256 public buyTotalFees;
348     uint256 public buyOperationsFee;
349     uint256 public buyLiquidityFee;
350     uint256 public buyDevFee;
351     uint256 public buyBurnFee;
352 
353     uint256 public sellTotalFees;
354     uint256 public sellOperationsFee;
355     uint256 public sellLiquidityFee;
356     uint256 public sellDevFee;
357     uint256 public sellBurnFee;
358 
359     uint256 public tokensForOperations;
360     uint256 public tokensForLiquidity;
361     uint256 public tokensForDev;
362     uint256 public tokensForBurn;
363 
364     /******************/
365 
366     // exlcude from fees and max transaction amount
367     mapping (address => bool) private _isExcludedFromFees;
368     mapping (address => bool) public _isExcludedMaxTransactionAmount;
369 
370     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
371     // could be subject to a maximum transfer amount
372     mapping (address => bool) public automatedMarketMakerPairs;
373 
374     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
375 
376     event EnabledTrading();
377 
378     event RemovedLimits();
379 
380     event ExcludeFromFees(address indexed account, bool isExcluded);
381 
382     event UpdatedMaxBuyAmount(uint256 newAmount);
383 
384     event UpdatedMaxSellAmount(uint256 newAmount);
385 
386     event UpdatedMaxWalletAmount(uint256 newAmount);
387 
388     event UpdatedOperationsAddress(address indexed newWallet);
389 
390     event MaxTransactionExclusion(address _address, bool excluded);
391 
392     event BuyBackTriggered(uint256 amount);
393 
394     event OwnerForcedSwapBack(uint256 timestamp);
395  
396     event CaughtEarlyBuyer(address sniper);
397 
398     event SwapAndLiquify(
399         uint256 tokensSwapped,
400         uint256 ethReceived,
401         uint256 tokensIntoLiquidity
402     );
403 
404     event TransferForeignToken(address token, uint256 amount);
405 
406     constructor() ERC20("Son Of Shiba", "SOS") {
407 
408         address newOwner = msg.sender; // can leave alone if owner is deployer.
409 
410         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
411         dexRouter = _dexRouter;
412 
413         // create pair
414         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
415         _excludeFromMaxTransaction(address(lpPair), true);
416         _setAutomatedMarketMakerPair(address(lpPair), true);
417 
418         uint256 totalSupply = 1 * 1e9 * 1e18;
419 
420         maxBuyAmount = totalSupply * 3 / 100;
421         maxSellAmount = totalSupply * 3 / 100;
422         maxWalletAmount = totalSupply * 3 / 100;
423         swapTokensAtAmount = totalSupply * 5 / 10000;
424 
425         buyOperationsFee = 20;
426         buyLiquidityFee = 0;
427         buyDevFee = 0;
428         buyBurnFee = 0;
429         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
430 
431         sellOperationsFee = 20;
432         sellLiquidityFee = 0;
433         sellDevFee = 0;
434         sellBurnFee = 0;
435         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
436 
437         _excludeFromMaxTransaction(newOwner, true);
438         _excludeFromMaxTransaction(address(this), true);
439         _excludeFromMaxTransaction(address(0xdead), true);
440 
441         excludeFromFees(newOwner, true);
442         excludeFromFees(address(this), true);
443         excludeFromFees(address(0xdead), true);
444 
445         operationsAddress = address(newOwner);
446         devAddress = address(newOwner);
447 
448         _createInitialSupply(newOwner, totalSupply);
449         transferOwnership(newOwner);
450     }
451 
452     receive() external payable {}
453 
454     // only enable if no plan to airdrop
455 
456     function enableTrading(uint256 deadBlocks) external onlyOwner {
457         require(!tradingActive, "Cannot reenable trading");
458         tradingActive = true;
459         swapEnabled = true;
460         tradingActiveBlock = block.number;
461         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
462         emit EnabledTrading();
463     }
464 
465     // remove limits after token is stable
466     function removeLimits() external onlyOwner {
467         limitsInEffect = false;
468         transferDelayEnabled = false;
469         emit RemovedLimits();
470     }
471 
472     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
473         boughtEarly[wallet] = flag;
474     }
475 
476     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
477         for(uint256 i = 0; i < wallets.length; i++){
478             boughtEarly[wallets[i]] = flag;
479         }
480     }
481 
482     // disable Transfer delay - cannot be reenabled
483     function disableTransferDelay() external onlyOwner {
484         transferDelayEnabled = false;
485     }
486 
487     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
488         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
489         maxBuyAmount = newNum * (10**18);
490         emit UpdatedMaxBuyAmount(maxBuyAmount);
491     }
492 
493     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
494         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
495         maxSellAmount = newNum * (10**18);
496         emit UpdatedMaxSellAmount(maxSellAmount);
497     }
498 
499     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
500         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
501         maxWalletAmount = newNum * (10**18);
502         emit UpdatedMaxWalletAmount(maxWalletAmount);
503     }
504 
505     // change the minimum amount of tokens to sell from fees
506     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
507   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
508   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
509   	    swapTokensAtAmount = newAmount;
510   	}
511 
512     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
513         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
514         emit MaxTransactionExclusion(updAds, isExcluded);
515     }
516 
517     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
518         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
519         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
520         for(uint256 i = 0; i < wallets.length; i++){
521             address wallet = wallets[i];
522             uint256 amount = amountsInTokens[i];
523             super._transfer(msg.sender, wallet, amount);
524         }
525     }
526 
527     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
528         if(!isEx){
529             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
530         }
531         _isExcludedMaxTransactionAmount[updAds] = isEx;
532     }
533 
534     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
535         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
536 
537         _setAutomatedMarketMakerPair(pair, value);
538         emit SetAutomatedMarketMakerPair(pair, value);
539     }
540 
541     function _setAutomatedMarketMakerPair(address pair, bool value) private {
542         automatedMarketMakerPairs[pair] = value;
543 
544         _excludeFromMaxTransaction(pair, value);
545 
546         emit SetAutomatedMarketMakerPair(pair, value);
547     }
548 
549     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
550         buyOperationsFee = _operationsFee;
551         buyLiquidityFee = _liquidityFee;
552         buyDevFee = _devFee;
553         buyBurnFee = _burnFee;
554         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
555         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
556     }
557 
558     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
559         sellOperationsFee = _operationsFee;
560         sellLiquidityFee = _liquidityFee;
561         sellDevFee = _devFee;
562         sellBurnFee = _burnFee;
563         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
564         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
565     }
566 
567     function returnToNormalTax() external onlyOwner {
568         sellOperationsFee = 0;
569         sellLiquidityFee = 0;
570         sellDevFee = 0;
571         sellBurnFee = 0;
572         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
573         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
574 
575         buyOperationsFee = 0;
576         buyLiquidityFee = 0;
577         buyDevFee = 0;
578         buyBurnFee = 0;
579         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
580         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
581     }
582 
583     function excludeFromFees(address account, bool excluded) public onlyOwner {
584         _isExcludedFromFees[account] = excluded;
585         emit ExcludeFromFees(account, excluded);
586     }
587 
588     function _transfer(address from, address to, uint256 amount) internal override {
589 
590         require(from != address(0), "ERC20: transfer from the zero address");
591         require(to != address(0), "ERC20: transfer to the zero address");
592         require(amount > 0, "amount must be greater than 0");
593 
594         if(!tradingActive){
595             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
596         }
597 
598         if(blockForPenaltyEnd > 0){
599             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
600         }
601 
602         if(limitsInEffect){
603             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
604 
605                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
606                 if (transferDelayEnabled){
607                     if (to != address(dexRouter) && to != address(lpPair)){
608                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
609                         _holderLastTransferTimestamp[tx.origin] = block.number;
610                         _holderLastTransferTimestamp[to] = block.number;
611                     }
612                 }
613     
614                 //when buy
615                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
616                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
617                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
618                 }
619                 //when sell
620                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
621                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
622                 }
623                 else if (!_isExcludedMaxTransactionAmount[to]){
624                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
625                 }
626             }
627         }
628 
629         uint256 contractTokenBalance = balanceOf(address(this));
630 
631         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
632 
633         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
634             swapping = true;
635 
636             swapBack();
637 
638             swapping = false;
639         }
640 
641         bool takeFee = true;
642         // if any account belongs to _isExcludedFromFee account then remove the fee
643         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
644             takeFee = false;
645         }
646 
647         uint256 fees = 0;
648         // only take fees on buys/sells, do not take on wallet transfers
649         if(takeFee){
650             // bot/sniper penalty.
651             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
652 
653                 if(!boughtEarly[to]){
654                     boughtEarly[to] = true;
655                     botsCaught += 1;
656                     emit CaughtEarlyBuyer(to);
657                 }
658 
659                 fees = amount * 99 / 100;
660         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
661                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
662                 tokensForDev += fees * buyDevFee / buyTotalFees;
663                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
664             }
665 
666             // on sell
667             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
668                 fees = amount * sellTotalFees / 100;
669                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
670                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
671                 tokensForDev += fees * sellDevFee / sellTotalFees;
672                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
673             }
674 
675             // on buy
676             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
677         	    fees = amount * buyTotalFees / 100;
678         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
679                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
680                 tokensForDev += fees * buyDevFee / buyTotalFees;
681                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
682             }
683 
684             if(fees > 0){
685                 super._transfer(from, address(this), fees);
686             }
687 
688         	amount -= fees;
689         }
690 
691         super._transfer(from, to, amount);
692     }
693 
694     function earlyBuyPenaltyInEffect() public view returns (bool){
695         return block.number < blockForPenaltyEnd;
696     }
697 
698     function swapTokensForEth(uint256 tokenAmount) private {
699 
700         // generate the uniswap pair path of token -> weth
701         address[] memory path = new address[](2);
702         path[0] = address(this);
703         path[1] = dexRouter.WETH();
704 
705         _approve(address(this), address(dexRouter), tokenAmount);
706 
707         // make the swap
708         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
709             tokenAmount,
710             0, // accept any amount of ETH
711             path,
712             address(this),
713             block.timestamp
714         );
715     }
716 
717     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
718         // approve token transfer to cover all possible scenarios
719         _approve(address(this), address(dexRouter), tokenAmount);
720 
721         // add the liquidity
722         dexRouter.addLiquidityETH{value: ethAmount}(
723             address(this),
724             tokenAmount,
725             0, // slippage is unavoidable
726             0, // slippage is unavoidable
727             address(0xdead),
728             block.timestamp
729         );
730     }
731 
732     function swapBack() private {
733 
734         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
735             _burn(address(this), tokensForBurn);
736         }
737         tokensForBurn = 0;
738 
739         uint256 contractBalance = balanceOf(address(this));
740         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
741 
742         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
743 
744         if(contractBalance > swapTokensAtAmount * 60){
745             contractBalance = swapTokensAtAmount * 60;
746         }
747 
748         bool success;
749 
750         // Halve the amount of liquidity tokens
751         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
752 
753         swapTokensForEth(contractBalance - liquidityTokens);
754 
755         uint256 ethBalance = address(this).balance;
756         uint256 ethForLiquidity = ethBalance;
757 
758         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
759         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
760 
761         ethForLiquidity -= ethForOperations + ethForDev;
762 
763         tokensForLiquidity = 0;
764         tokensForOperations = 0;
765         tokensForDev = 0;
766         tokensForBurn = 0;
767 
768         if(liquidityTokens > 0 && ethForLiquidity > 0){
769             addLiquidity(liquidityTokens, ethForLiquidity);
770         }
771 
772         (success,) = address(devAddress).call{value: ethForDev}("");
773 
774         (success,) = address(operationsAddress).call{value: address(this).balance}("");
775     }
776 
777     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
778         require(_token != address(0), "_token address cannot be 0");
779         require(_token != address(this), "Can't withdraw native tokens");
780         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
781         _sent = IERC20(_token).transfer(_to, _contractBalance);
782         emit TransferForeignToken(_token, _contractBalance);
783     }
784 
785     // withdraw ETH if stuck or someone sends to the address
786     function withdrawStuckETH() external onlyOwner {
787         bool success;
788         (success,) = address(msg.sender).call{value: address(this).balance}("");
789     }
790 
791     function setOperationsAddress(address _operationsAddress) external onlyOwner {
792         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
793         operationsAddress = payable(_operationsAddress);
794     }
795 
796     function setDevAddress(address _devAddress) external onlyOwner {
797         require(_devAddress != address(0), "_devAddress address cannot be 0");
798         devAddress = payable(_devAddress);
799     }
800 
801     // force Swap back if slippage issues.
802     function forceSwapBack() external onlyOwner {
803         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
804         swapping = true;
805         swapBack();
806         swapping = false;
807         emit OwnerForcedSwapBack(block.timestamp);
808     }
809 
810     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
811     function buyBackTokens(uint256 amountInWei) external onlyOwner {
812         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
813 
814         address[] memory path = new address[](2);
815         path[0] = dexRouter.WETH();
816         path[1] = address(this);
817 
818         // make the swap
819         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
820             0, // accept any amount of Ethereum
821             path,
822             address(0xdead),
823             block.timestamp
824         );
825         emit BuyBackTriggered(amountInWei);
826     }
827 }