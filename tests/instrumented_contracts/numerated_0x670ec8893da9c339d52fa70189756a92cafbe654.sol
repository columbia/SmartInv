1 /** 
2 
3 dadadadum, dadadadum
4 daaa, dadadadadadadadaaa
5 dadadadum, dadadadum
6 daaa, dadadadadadadadaaa
7 dadadadum, dadadadum
8 daaa, dadadadadadadadaaa
9 
10 https://potterpredator.com/
11 
12 https://t.me/PPV4LD3M0RT
13 
14 https://twitter.com/PotterPredator
15 
16 */
17 
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity 0.8.15;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 interface IERC20Metadata is IERC20 {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 contract ERC20 is Context, IERC20, IERC20Metadata {
126     mapping(address => uint256) private _balances;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131 
132     string private _name;
133     string private _symbol;
134 
135     constructor(string memory name_, string memory symbol_) {
136         _name = name_;
137         _symbol = symbol_;
138     }
139 
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     function symbol() public view virtual override returns (string memory) {
145         return _symbol;
146     }
147 
148     function decimals() public view virtual override returns (uint8) {
149         return 18;
150     }
151 
152     function totalSupply() public view virtual override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(address account) public view virtual override returns (uint256) {
157         return _balances[account];
158     }
159 
160     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
161         _transfer(_msgSender(), recipient, amount);
162         return true;
163     }
164 
165     function allowance(address owner, address spender) public view virtual override returns (uint256) {
166         return _allowances[owner][spender];
167     }
168 
169     function approve(address spender, uint256 amount) public virtual override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173 
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) public virtual override returns (bool) {
179         _transfer(sender, recipient, amount);
180 
181         uint256 currentAllowance = _allowances[sender][_msgSender()];
182         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
183         unchecked {
184             _approve(sender, _msgSender(), currentAllowance - amount);
185         }
186 
187         return true;
188     }
189 
190     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
191         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
192         return true;
193     }
194 
195     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
196         uint256 currentAllowance = _allowances[_msgSender()][spender];
197         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
198         unchecked {
199             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
200         }
201 
202         return true;
203     }
204 
205     function _transfer(
206         address sender,
207         address recipient,
208         uint256 amount
209     ) internal virtual {
210         require(sender != address(0), "ERC20: transfer from the zero address");
211         require(recipient != address(0), "ERC20: transfer to the zero address");
212 
213         uint256 senderBalance = _balances[sender];
214         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
215         unchecked {
216             _balances[sender] = senderBalance - amount;
217         }
218         _balances[recipient] += amount;
219 
220         emit Transfer(sender, recipient, amount);
221     }
222 
223     function _createInitialSupply(address account, uint256 amount) internal virtual {
224         require(account != address(0), "ERC20: mint to the zero address");
225 
226         _totalSupply += amount;
227         _balances[account] += amount;
228         emit Transfer(address(0), account, amount);
229     }
230 
231     function _burn(address account, uint256 amount) internal virtual {
232         require(account != address(0), "ERC20: burn from the zero address");
233         uint256 accountBalance = _balances[account];
234         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
235         unchecked {
236             _balances[account] = accountBalance - amount;
237             // Overflow not possible: amount <= accountBalance <= totalSupply.
238             _totalSupply -= amount;
239         }
240 
241         emit Transfer(account, address(0), amount);
242     }
243 
244     function _approve(
245         address owner,
246         address spender,
247         uint256 amount
248     ) internal virtual {
249         require(owner != address(0), "ERC20: approve from the zero address");
250         require(spender != address(0), "ERC20: approve to the zero address");
251 
252         _allowances[owner][spender] = amount;
253         emit Approval(owner, spender, amount);
254     }
255 }
256 
257 contract Ownable is Context {
258     address private _owner;
259 
260     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
261 
262     constructor () {
263         address msgSender = _msgSender();
264         _owner = msgSender;
265         emit OwnershipTransferred(address(0), msgSender);
266     }
267 
268     function owner() public view returns (address) {
269         return _owner;
270     }
271 
272     modifier onlyOwner() {
273         require(_owner == _msgSender(), "Ownable: caller is not the owner");
274         _;
275     }
276 
277     function renounceOwnership() external virtual onlyOwner {
278         emit OwnershipTransferred(_owner, address(0));
279         _owner = address(0);
280     }
281 
282     function transferOwnership(address newOwner) public virtual onlyOwner {
283         require(newOwner != address(0), "Ownable: new owner is the zero address");
284         emit OwnershipTransferred(_owner, newOwner);
285         _owner = newOwner;
286     }
287 }
288 
289 interface IDexRouter {
290     function factory() external pure returns (address);
291     function WETH() external pure returns (address);
292 
293     function swapExactTokensForETHSupportingFeeOnTransferTokens(
294         uint amountIn,
295         uint amountOutMin,
296         address[] calldata path,
297         address to,
298         uint deadline
299     ) external;
300 
301     function swapExactETHForTokensSupportingFeeOnTransferTokens(
302         uint amountOutMin,
303         address[] calldata path,
304         address to,
305         uint deadline
306     ) external payable;
307 
308     function addLiquidityETH(
309         address token,
310         uint256 amountTokenDesired,
311         uint256 amountTokenMin,
312         uint256 amountETHMin,
313         address to,
314         uint256 deadline
315     )
316         external
317         payable
318         returns (
319             uint256 amountToken,
320             uint256 amountETH,
321             uint256 liquidity
322         );
323 }
324 
325 interface IDexFactory {
326     function createPair(address tokenA, address tokenB)
327         external
328         returns (address pair);
329 }
330 
331 contract Voldemort is ERC20, Ownable {
332 
333     uint256 public maxBuyAmount;
334     uint256 public maxSellAmount;
335     uint256 public maxWalletAmount;
336 
337     IDexRouter public dexRouter;
338     address public lpPair;
339 
340     bool private swapping;
341     uint256 public swapTokensAtAmount;
342 
343     address operationsAddress;
344     address devAddress;
345 
346     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
347     uint256 public blockForPenaltyEnd;
348     mapping (address => bool) public boughtEarly;
349     uint256 public botsCaught;
350 
351     bool public limitsInEffect = true;
352     bool public tradingActive = false;
353     bool public swapEnabled = false;
354 
355      // Anti-bot and anti-whale mappings and variables
356     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
357     bool public transferDelayEnabled = true;
358 
359     uint256 public buyTotalFees;
360     uint256 public buyOperationsFee;
361     uint256 public buyLiquidityFee;
362     uint256 public buyDevFee;
363     uint256 public buyBurnFee;
364 
365     uint256 public sellTotalFees;
366     uint256 public sellOperationsFee;
367     uint256 public sellLiquidityFee;
368     uint256 public sellDevFee;
369     uint256 public sellBurnFee;
370 
371     uint256 public tokensForOperations;
372     uint256 public tokensForLiquidity;
373     uint256 public tokensForDev;
374     uint256 public tokensForBurn;
375 
376     /******************/
377 
378     // exlcude from fees and max transaction amount
379     mapping (address => bool) private _isExcludedFromFees;
380     mapping (address => bool) public _isExcludedMaxTransactionAmount;
381 
382     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
383     // could be subject to a maximum transfer amount
384     mapping (address => bool) public automatedMarketMakerPairs;
385 
386     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
387 
388     event EnabledTrading();
389 
390     event RemovedLimits();
391 
392     event ExcludeFromFees(address indexed account, bool isExcluded);
393 
394     event UpdatedMaxBuyAmount(uint256 newAmount);
395 
396     event UpdatedMaxSellAmount(uint256 newAmount);
397 
398     event UpdatedMaxWalletAmount(uint256 newAmount);
399 
400     event UpdatedOperationsAddress(address indexed newWallet);
401 
402     event MaxTransactionExclusion(address _address, bool excluded);
403 
404     event BuyBackTriggered(uint256 amount);
405 
406     event OwnerForcedSwapBack(uint256 timestamp);
407 
408     event CaughtEarlyBuyer(address sniper);
409 
410     event SwapAndLiquify(
411         uint256 tokensSwapped,
412         uint256 ethReceived,
413         uint256 tokensIntoLiquidity
414     );
415 
416     event TransferForeignToken(address token, uint256 amount);
417 
418     constructor() ERC20("Potter Predator ", "Voldemort") {
419 
420         address newOwner = msg.sender; // can leave alone if owner is deployer.
421 
422         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
423         dexRouter = _dexRouter;
424 
425         // create pair
426         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
427         _excludeFromMaxTransaction(address(lpPair), true);
428         _setAutomatedMarketMakerPair(address(lpPair), true);
429 
430         uint256 totalSupply = 1 * 1e9 * 1e18;
431 
432         maxBuyAmount = totalSupply * 2 / 100;
433         maxSellAmount = totalSupply * 2 / 100;
434         maxWalletAmount = totalSupply * 2 / 100;
435         swapTokensAtAmount = totalSupply * 1 / 1000;
436 
437         buyOperationsFee = 30;
438         buyLiquidityFee = 0;
439         buyDevFee = 0;
440         buyBurnFee = 0;
441         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
442 
443         sellOperationsFee = 30;
444         sellLiquidityFee = 0;
445         sellDevFee = 0;
446         sellBurnFee = 0;
447         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
448 
449         _excludeFromMaxTransaction(newOwner, true);
450         _excludeFromMaxTransaction(address(this), true);
451         _excludeFromMaxTransaction(address(0xdead), true);
452 
453         excludeFromFees(newOwner, true);
454         excludeFromFees(address(this), true);
455         excludeFromFees(address(0xdead), true);
456 
457         operationsAddress = address(newOwner);
458         devAddress = address(newOwner);
459 
460         _createInitialSupply(newOwner, totalSupply);
461         transferOwnership(newOwner);
462     }
463 
464     receive() external payable {}
465 
466     // only enable if no plan to airdrop
467 
468     function enableTrading(uint256 deadBlocks) external onlyOwner {
469         require(!tradingActive, "Cannot reenable trading");
470         tradingActive = true;
471         swapEnabled = true;
472         tradingActiveBlock = block.number;
473         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
474         emit EnabledTrading();
475     }
476 
477     // remove limits after token is stable
478     function removeLimits() external onlyOwner {
479         limitsInEffect = false;
480         transferDelayEnabled = false;
481         emit RemovedLimits();
482     }
483 
484     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
485         boughtEarly[wallet] = flag;
486     }
487 
488     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
489         for(uint256 i = 0; i < wallets.length; i++){
490             boughtEarly[wallets[i]] = flag;
491         }
492     }
493 
494     // disable Transfer delay - cannot be reenabled
495     function disableTransferDelay() external onlyOwner {
496         transferDelayEnabled = false;
497     }
498 
499     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
500         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
501         maxBuyAmount = newNum * (10**18);
502         emit UpdatedMaxBuyAmount(maxBuyAmount);
503     }
504 
505     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
506         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
507         maxSellAmount = newNum * (10**18);
508         emit UpdatedMaxSellAmount(maxSellAmount);
509     }
510 
511     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
512         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
513         maxWalletAmount = newNum * (10**18);
514         emit UpdatedMaxWalletAmount(maxWalletAmount);
515     }
516 
517     // change the minimum amount of tokens to sell from fees
518     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
519   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
520   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
521   	    swapTokensAtAmount = newAmount;
522   	}
523 
524     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
525         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
526         emit MaxTransactionExclusion(updAds, isExcluded);
527     }
528 
529     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
530         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
531         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
532         for(uint256 i = 0; i < wallets.length; i++){
533             address wallet = wallets[i];
534             uint256 amount = amountsInTokens[i];
535             super._transfer(msg.sender, wallet, amount);
536         }
537     }
538 
539     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
540         if(!isEx){
541             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
542         }
543         _isExcludedMaxTransactionAmount[updAds] = isEx;
544     }
545 
546     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
547         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
548 
549         _setAutomatedMarketMakerPair(pair, value);
550         emit SetAutomatedMarketMakerPair(pair, value);
551     }
552 
553     function _setAutomatedMarketMakerPair(address pair, bool value) private {
554         automatedMarketMakerPairs[pair] = value;
555 
556         _excludeFromMaxTransaction(pair, value);
557 
558         emit SetAutomatedMarketMakerPair(pair, value);
559     }
560 
561     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
562         buyOperationsFee = _operationsFee;
563         buyLiquidityFee = _liquidityFee;
564         buyDevFee = _devFee;
565         buyBurnFee = _burnFee;
566         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
567         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
568     }
569 
570     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
571         sellOperationsFee = _operationsFee;
572         sellLiquidityFee = _liquidityFee;
573         sellDevFee = _devFee;
574         sellBurnFee = _burnFee;
575         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
576         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
577     }
578 
579     function returnToNormalTax() external onlyOwner {
580         sellOperationsFee = 0;
581         sellLiquidityFee = 0;
582         sellDevFee = 0;
583         sellBurnFee = 0;
584         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
585         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
586 
587         buyOperationsFee = 0;
588         buyLiquidityFee = 0;
589         buyDevFee = 0;
590         buyBurnFee = 0;
591         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
592         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
593     }
594 
595     function excludeFromFees(address account, bool excluded) public onlyOwner {
596         _isExcludedFromFees[account] = excluded;
597         emit ExcludeFromFees(account, excluded);
598     }
599 
600     function _transfer(address from, address to, uint256 amount) internal override {
601 
602         require(from != address(0), "ERC20: transfer from the zero address");
603         require(to != address(0), "ERC20: transfer to the zero address");
604         require(amount > 0, "amount must be greater than 0");
605 
606         if(!tradingActive){
607             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
608         }
609 
610         if(blockForPenaltyEnd > 0){
611             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
612         }
613 
614         if(limitsInEffect){
615             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
616 
617                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
618                 if (transferDelayEnabled){
619                     if (to != address(dexRouter) && to != address(lpPair)){
620                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
621                         _holderLastTransferTimestamp[tx.origin] = block.number;
622                         _holderLastTransferTimestamp[to] = block.number;
623                     }
624                 }
625     
626                 //when buy
627                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
628                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
629                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
630                 }
631                 //when sell
632                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
633                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
634                 }
635                 else if (!_isExcludedMaxTransactionAmount[to]){
636                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
637                 }
638             }
639         }
640 
641         uint256 contractTokenBalance = balanceOf(address(this));
642 
643         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
644 
645         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
646             swapping = true;
647 
648             swapBack();
649 
650             swapping = false;
651         }
652 
653         bool takeFee = true;
654         // if any account belongs to _isExcludedFromFee account then remove the fee
655         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
656             takeFee = false;
657         }
658 
659         uint256 fees = 0;
660         // only take fees on buys/sells, do not take on wallet transfers
661         if(takeFee){
662             // bot/sniper penalty.
663             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
664 
665                 if(!boughtEarly[to]){
666                     boughtEarly[to] = true;
667                     botsCaught += 1;
668                     emit CaughtEarlyBuyer(to);
669                 }
670 
671                 fees = amount * 99 / 100;
672         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
673                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
674                 tokensForDev += fees * buyDevFee / buyTotalFees;
675                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
676             }
677 
678             // on sell
679             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
680                 fees = amount * sellTotalFees / 100;
681                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
682                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
683                 tokensForDev += fees * sellDevFee / sellTotalFees;
684                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
685             }
686 
687             // on buy
688             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
689         	    fees = amount * buyTotalFees / 100;
690         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
691                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
692                 tokensForDev += fees * buyDevFee / buyTotalFees;
693                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
694             }
695 
696             if(fees > 0){
697                 super._transfer(from, address(this), fees);
698             }
699 
700         	amount -= fees;
701         }
702 
703         super._transfer(from, to, amount);
704     }
705 
706     function earlyBuyPenaltyInEffect() public view returns (bool){
707         return block.number < blockForPenaltyEnd;
708     }
709 
710     function swapTokensForEth(uint256 tokenAmount) private {
711 
712         // generate the uniswap pair path of token -> weth
713         address[] memory path = new address[](2);
714         path[0] = address(this);
715         path[1] = dexRouter.WETH();
716 
717         _approve(address(this), address(dexRouter), tokenAmount);
718 
719         // make the swap
720         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
721             tokenAmount,
722             0, // accept any amount of ETH
723             path,
724             address(this),
725             block.timestamp
726         );
727     }
728 
729     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
730         // approve token transfer to cover all possible scenarios
731         _approve(address(this), address(dexRouter), tokenAmount);
732 
733         // add the liquidity
734         dexRouter.addLiquidityETH{value: ethAmount}(
735             address(this),
736             tokenAmount,
737             0, // slippage is unavoidable
738             0, // slippage is unavoidable
739             address(0xdead),
740             block.timestamp
741         );
742     }
743 
744     function swapBack() private {
745 
746         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
747             _burn(address(this), tokensForBurn);
748         }
749         tokensForBurn = 0;
750 
751         uint256 contractBalance = balanceOf(address(this));
752         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
753 
754         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
755 
756         if(contractBalance > swapTokensAtAmount * 60){
757             contractBalance = swapTokensAtAmount * 60;
758         }
759 
760         bool success;
761 
762         // Halve the amount of liquidity tokens
763         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
764 
765         swapTokensForEth(contractBalance - liquidityTokens);
766 
767         uint256 ethBalance = address(this).balance;
768         uint256 ethForLiquidity = ethBalance;
769 
770         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
771         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
772 
773         ethForLiquidity -= ethForOperations + ethForDev;
774 
775         tokensForLiquidity = 0;
776         tokensForOperations = 0;
777         tokensForDev = 0;
778         tokensForBurn = 0;
779 
780         if(liquidityTokens > 0 && ethForLiquidity > 0){
781             addLiquidity(liquidityTokens, ethForLiquidity);
782         }
783 
784         (success,) = address(devAddress).call{value: ethForDev}("");
785 
786         (success,) = address(operationsAddress).call{value: address(this).balance}("");
787     }
788 
789     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
790         require(_token != address(0), "_token address cannot be 0");
791         require(_token != address(this), "Can't withdraw native tokens");
792         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
793         _sent = IERC20(_token).transfer(_to, _contractBalance);
794         emit TransferForeignToken(_token, _contractBalance);
795     }
796 
797     // withdraw ETH if stuck or someone sends to the address
798     function withdrawStuckETH() external onlyOwner {
799         bool success;
800         (success,) = address(msg.sender).call{value: address(this).balance}("");
801     }
802 
803     function setOperationsAddress(address _operationsAddress) external onlyOwner {
804         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
805         operationsAddress = payable(_operationsAddress);
806     }
807 
808     function setDevAddress(address _devAddress) external onlyOwner {
809         require(_devAddress != address(0), "_devAddress address cannot be 0");
810         devAddress = payable(_devAddress);
811     }
812 
813     // force Swap back if slippage issues.
814     function forceSwapBack() external onlyOwner {
815         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
816         swapping = true;
817         swapBack();
818         swapping = false;
819         emit OwnerForcedSwapBack(block.timestamp);
820     }
821 
822     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
823     function buyBackTokens(uint256 amountInWei) external onlyOwner {
824         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
825 
826         address[] memory path = new address[](2);
827         path[0] = dexRouter.WETH();
828         path[1] = address(this);
829 
830         // make the swap
831         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
832             0, // accept any amount of Ethereum
833             path,
834             address(0xdead),
835             block.timestamp
836         );
837         emit BuyBackTriggered(amountInWei);
838     }
839 }