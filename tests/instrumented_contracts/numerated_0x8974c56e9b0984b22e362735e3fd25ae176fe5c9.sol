1 /**
2 Pepe in Binary. 
3 
4 twitter.com/BinaryPepeERC
5 t.me/BinaryPepe
6 
7 
8 */
9 
10 
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity 0.8.15;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 private _totalSupply;
125 
126     string private _name;
127     string private _symbol;
128 
129     constructor(string memory name_, string memory symbol_) {
130         _name = name_;
131         _symbol = symbol_;
132     }
133 
134     function name() public view virtual override returns (string memory) {
135         return _name;
136     }
137 
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141 
142     function decimals() public view virtual override returns (uint8) {
143         return 18;
144     }
145 
146     function totalSupply() public view virtual override returns (uint256) {
147         return _totalSupply;
148     }
149 
150     function balanceOf(address account) public view virtual override returns (uint256) {
151         return _balances[account];
152     }
153 
154     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
155         _transfer(_msgSender(), recipient, amount);
156         return true;
157     }
158 
159     function allowance(address owner, address spender) public view virtual override returns (uint256) {
160         return _allowances[owner][spender];
161     }
162 
163     function approve(address spender, uint256 amount) public virtual override returns (bool) {
164         _approve(_msgSender(), spender, amount);
165         return true;
166     }
167 
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) public virtual override returns (bool) {
173         _transfer(sender, recipient, amount);
174 
175         uint256 currentAllowance = _allowances[sender][_msgSender()];
176         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
177         unchecked {
178             _approve(sender, _msgSender(), currentAllowance - amount);
179         }
180 
181         return true;
182     }
183 
184     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
185         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
186         return true;
187     }
188 
189     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
190         uint256 currentAllowance = _allowances[_msgSender()][spender];
191         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
192         unchecked {
193             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
194         }
195 
196         return true;
197     }
198 
199     function _transfer(
200         address sender,
201         address recipient,
202         uint256 amount
203     ) internal virtual {
204         require(sender != address(0), "ERC20: transfer from the zero address");
205         require(recipient != address(0), "ERC20: transfer to the zero address");
206 
207         uint256 senderBalance = _balances[sender];
208         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
209         unchecked {
210             _balances[sender] = senderBalance - amount;
211         }
212         _balances[recipient] += amount;
213 
214         emit Transfer(sender, recipient, amount);
215     }
216 
217     function _createInitialSupply(address account, uint256 amount) internal virtual {
218         require(account != address(0), "ERC20: mint to the zero address");
219 
220         _totalSupply += amount;
221         _balances[account] += amount;
222         emit Transfer(address(0), account, amount);
223     }
224 
225     function _burn(address account, uint256 amount) internal virtual {
226         require(account != address(0), "ERC20: burn from the zero address");
227         uint256 accountBalance = _balances[account];
228         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
229         unchecked {
230             _balances[account] = accountBalance - amount;
231             // Overflow not possible: amount <= accountBalance <= totalSupply.
232             _totalSupply -= amount;
233         }
234 
235         emit Transfer(account, address(0), amount);
236     }
237 
238     function _approve(
239         address owner,
240         address spender,
241         uint256 amount
242     ) internal virtual {
243         require(owner != address(0), "ERC20: approve from the zero address");
244         require(spender != address(0), "ERC20: approve to the zero address");
245 
246         _allowances[owner][spender] = amount;
247         emit Approval(owner, spender, amount);
248     }
249 }
250 
251 contract Ownable is Context {
252     address private _owner;
253 
254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256     constructor () {
257         address msgSender = _msgSender();
258         _owner = msgSender;
259         emit OwnershipTransferred(address(0), msgSender);
260     }
261 
262     function owner() public view returns (address) {
263         return _owner;
264     }
265 
266     modifier onlyOwner() {
267         require(_owner == _msgSender(), "Ownable: caller is not the owner");
268         _;
269     }
270 
271     function renounceOwnership() external virtual onlyOwner {
272         emit OwnershipTransferred(_owner, address(0));
273         _owner = address(0);
274     }
275 
276     function transferOwnership(address newOwner) public virtual onlyOwner {
277         require(newOwner != address(0), "Ownable: new owner is the zero address");
278         emit OwnershipTransferred(_owner, newOwner);
279         _owner = newOwner;
280     }
281 }
282 
283 interface IDexRouter {
284     function factory() external pure returns (address);
285     function WETH() external pure returns (address);
286 
287     function swapExactTokensForETHSupportingFeeOnTransferTokens(
288         uint amountIn,
289         uint amountOutMin,
290         address[] calldata path,
291         address to,
292         uint deadline
293     ) external;
294 
295     function swapExactETHForTokensSupportingFeeOnTransferTokens(
296         uint amountOutMin,
297         address[] calldata path,
298         address to,
299         uint deadline
300     ) external payable;
301 
302     function addLiquidityETH(
303         address token,
304         uint256 amountTokenDesired,
305         uint256 amountTokenMin,
306         uint256 amountETHMin,
307         address to,
308         uint256 deadline
309     )
310         external
311         payable
312         returns (
313             uint256 amountToken,
314             uint256 amountETH,
315             uint256 liquidity
316         );
317 }
318 
319 interface IDexFactory {
320     function createPair(address tokenA, address tokenB)
321         external
322         returns (address pair);
323 }
324 
325 contract BinaryPepe is ERC20, Ownable {
326 
327     uint256 public maxBuyAmount;
328     uint256 public maxSellAmount;
329     uint256 public maxWalletAmount;
330 
331     IDexRouter public dexRouter;
332     address public lpPair;
333 
334     bool private swapping;
335     uint256 public swapTokensAtAmount;
336 
337     address operationsAddress;
338     address devAddress;
339 
340     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
341     uint256 public blockForPenaltyEnd;
342     mapping (address => bool) public boughtEarly;
343     uint256 public botsCaught;
344 
345     bool public limitsInEffect = true;
346     bool public tradingActive = false;
347     bool public swapEnabled = false;
348 
349      // Anti-bot and anti-whale mappings and variables
350     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
351     bool public transferDelayEnabled = true;
352 
353     uint256 public buyTotalFees;
354     uint256 public buyOperationsFee;
355     uint256 public buyLiquidityFee;
356     uint256 public buyDevFee;
357     uint256 public buyBurnFee;
358 
359     uint256 public sellTotalFees;
360     uint256 public sellOperationsFee;
361     uint256 public sellLiquidityFee;
362     uint256 public sellDevFee;
363     uint256 public sellBurnFee;
364 
365     uint256 public tokensForOperations;
366     uint256 public tokensForLiquidity;
367     uint256 public tokensForDev;
368     uint256 public tokensForBurn;
369 
370     /******************/
371 
372     // exlcude from fees and max transaction amount
373     mapping (address => bool) private _isExcludedFromFees;
374     mapping (address => bool) public _isExcludedMaxTransactionAmount;
375 
376     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
377     // could be subject to a maximum transfer amount
378     mapping (address => bool) public automatedMarketMakerPairs;
379 
380     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
381 
382     event EnabledTrading();
383 
384     event RemovedLimits();
385 
386     event ExcludeFromFees(address indexed account, bool isExcluded);
387 
388     event UpdatedMaxBuyAmount(uint256 newAmount);
389 
390     event UpdatedMaxSellAmount(uint256 newAmount);
391 
392     event UpdatedMaxWalletAmount(uint256 newAmount);
393 
394     event UpdatedOperationsAddress(address indexed newWallet);
395 
396     event MaxTransactionExclusion(address _address, bool excluded);
397 
398     event BuyBackTriggered(uint256 amount);
399 
400     event OwnerForcedSwapBack(uint256 timestamp);
401 
402     event CaughtEarlyBuyer(address sniper);
403 
404     event SwapAndLiquify(
405         uint256 tokensSwapped,
406         uint256 ethReceived,
407         uint256 tokensIntoLiquidity
408     );
409 
410     event TransferForeignToken(address token, uint256 amount);
411 
412     constructor() ERC20("01010000 01100101 01110000 01100101", "01010000 01100101 01110000 01100101") {
413 
414         address newOwner = msg.sender; // can leave alone if owner is deployer.
415 
416         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
417         dexRouter = _dexRouter;
418 
419         // create pair
420         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
421         _excludeFromMaxTransaction(address(lpPair), true);
422         _setAutomatedMarketMakerPair(address(lpPair), true);
423 
424         uint256 totalSupply = 1 * 1e12 * 1e18;
425 
426         maxBuyAmount = totalSupply * 125 / 10000;
427         maxSellAmount = totalSupply * 125 / 10000;
428         maxWalletAmount = totalSupply * 125 / 10000;
429         swapTokensAtAmount = totalSupply * 1 / 300;
430 
431         buyOperationsFee = 20;
432         buyLiquidityFee = 0;
433         buyDevFee = 0;
434         buyBurnFee = 0;
435         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
436 
437         sellOperationsFee = 20;
438         sellLiquidityFee = 0;
439         sellDevFee = 0;
440         sellBurnFee = 0;
441         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
442 
443         _excludeFromMaxTransaction(newOwner, true);
444         _excludeFromMaxTransaction(address(this), true);
445         _excludeFromMaxTransaction(address(0xdead), true);
446 
447         excludeFromFees(newOwner, true);
448         excludeFromFees(address(this), true);
449         excludeFromFees(address(0xdead), true);
450 
451         operationsAddress = address(newOwner);
452         devAddress = address(newOwner);
453 
454         _createInitialSupply(newOwner, totalSupply);
455         transferOwnership(newOwner);
456     }
457 
458     receive() external payable {}
459 
460     // only enable if no plan to airdrop
461 
462     function enableTrading(uint256 deadBlocks) external onlyOwner {
463         require(!tradingActive, "Cannot reenable trading");
464         tradingActive = true;
465         swapEnabled = true;
466         tradingActiveBlock = block.number;
467         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
468         emit EnabledTrading();
469     }
470 
471     // remove limits after token is stable
472     function removeLimits() external onlyOwner {
473         limitsInEffect = false;
474         transferDelayEnabled = false;
475         emit RemovedLimits();
476     }
477 
478     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
479         boughtEarly[wallet] = flag;
480     }
481 
482     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
483         for(uint256 i = 0; i < wallets.length; i++){
484             boughtEarly[wallets[i]] = flag;
485         }
486     }
487 
488     // disable Transfer delay - cannot be reenabled
489     function disableTransferDelay() external onlyOwner {
490         transferDelayEnabled = false;
491     }
492 
493     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
494         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
495         maxBuyAmount = newNum * (10**18);
496         emit UpdatedMaxBuyAmount(maxBuyAmount);
497     }
498 
499     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
500         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
501         maxSellAmount = newNum * (10**18);
502         emit UpdatedMaxSellAmount(maxSellAmount);
503     }
504 
505     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
506         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
507         maxWalletAmount = newNum * (10**18);
508         emit UpdatedMaxWalletAmount(maxWalletAmount);
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
523     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
524         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
525         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
526         for(uint256 i = 0; i < wallets.length; i++){
527             address wallet = wallets[i];
528             uint256 amount = amountsInTokens[i];
529             super._transfer(msg.sender, wallet, amount);
530         }
531     }
532 
533     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
534         if(!isEx){
535             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
536         }
537         _isExcludedMaxTransactionAmount[updAds] = isEx;
538     }
539 
540     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
541         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
542 
543         _setAutomatedMarketMakerPair(pair, value);
544         emit SetAutomatedMarketMakerPair(pair, value);
545     }
546 
547     function _setAutomatedMarketMakerPair(address pair, bool value) private {
548         automatedMarketMakerPairs[pair] = value;
549 
550         _excludeFromMaxTransaction(pair, value);
551 
552         emit SetAutomatedMarketMakerPair(pair, value);
553     }
554 
555     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
556         buyOperationsFee = _operationsFee;
557         buyLiquidityFee = _liquidityFee;
558         buyDevFee = _devFee;
559         buyBurnFee = _burnFee;
560         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
561         require(buyTotalFees <= 20, "Must keep fees at 10% or less");
562     }
563 
564     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
565         sellOperationsFee = _operationsFee;
566         sellLiquidityFee = _liquidityFee;
567         sellDevFee = _devFee;
568         sellBurnFee = _burnFee;
569         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
570         require(sellTotalFees <= 20, "Must keep fees at 10% or less");
571     }
572 
573     function returnToNormalTax() external onlyOwner {
574         sellOperationsFee = 0;
575         sellLiquidityFee = 0;
576         sellDevFee = 0;
577         sellBurnFee = 0;
578         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
579         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
580 
581         buyOperationsFee = 0;
582         buyLiquidityFee = 0;
583         buyDevFee = 0;
584         buyBurnFee = 0;
585         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
586         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
587     }
588 
589     function excludeFromFees(address account, bool excluded) public onlyOwner {
590         _isExcludedFromFees[account] = excluded;
591         emit ExcludeFromFees(account, excluded);
592     }
593 
594     function _transfer(address from, address to, uint256 amount) internal override {
595 
596         require(from != address(0), "ERC20: transfer from the zero address");
597         require(to != address(0), "ERC20: transfer to the zero address");
598         require(amount > 0, "amount must be greater than 0");
599 
600         if(!tradingActive){
601             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
602         }
603 
604         if(blockForPenaltyEnd > 0){
605             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
606         }
607 
608         if(limitsInEffect){
609             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
610 
611                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
612                 if (transferDelayEnabled){
613                     if (to != address(dexRouter) && to != address(lpPair)){
614                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
615                         _holderLastTransferTimestamp[tx.origin] = block.number;
616                         _holderLastTransferTimestamp[to] = block.number;
617                     }
618                 }
619     
620                 //when buy
621                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
622                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
623                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
624                 }
625                 //when sell
626                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
627                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
628                 }
629                 else if (!_isExcludedMaxTransactionAmount[to]){
630                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
631                 }
632             }
633         }
634 
635         uint256 contractTokenBalance = balanceOf(address(this));
636 
637         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
638 
639         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
640             swapping = true;
641 
642             swapBack();
643 
644             swapping = false;
645         }
646 
647         bool takeFee = true;
648         // if any account belongs to _isExcludedFromFee account then remove the fee
649         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
650             takeFee = false;
651         }
652 
653         uint256 fees = 0;
654         // only take fees on buys/sells, do not take on wallet transfers
655         if(takeFee){
656             // bot/sniper penalty.
657             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
658 
659                 if(!boughtEarly[to]){
660                     boughtEarly[to] = true;
661                     botsCaught += 1;
662                     emit CaughtEarlyBuyer(to);
663                 }
664 
665                 fees = amount * 99 / 100;
666         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
667                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
668                 tokensForDev += fees * buyDevFee / buyTotalFees;
669                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
670             }
671 
672             // on sell
673             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
674                 fees = amount * sellTotalFees / 100;
675                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
676                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
677                 tokensForDev += fees * sellDevFee / sellTotalFees;
678                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
679             }
680 
681             // on buy
682             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
683         	    fees = amount * buyTotalFees / 100;
684         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
685                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
686                 tokensForDev += fees * buyDevFee / buyTotalFees;
687                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
688             }
689 
690             if(fees > 0){
691                 super._transfer(from, address(this), fees);
692             }
693 
694         	amount -= fees;
695         }
696 
697         super._transfer(from, to, amount);
698     }
699 
700     function earlyBuyPenaltyInEffect() public view returns (bool){
701         return block.number < blockForPenaltyEnd;
702     }
703 
704     function swapTokensForEth(uint256 tokenAmount) private {
705 
706         // generate the uniswap pair path of token -> weth
707         address[] memory path = new address[](2);
708         path[0] = address(this);
709         path[1] = dexRouter.WETH();
710 
711         _approve(address(this), address(dexRouter), tokenAmount);
712 
713         // make the swap
714         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
715             tokenAmount,
716             0, // accept any amount of ETH
717             path,
718             address(this),
719             block.timestamp
720         );
721     }
722 
723     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
724         // approve token transfer to cover all possible scenarios
725         _approve(address(this), address(dexRouter), tokenAmount);
726 
727         // add the liquidity
728         dexRouter.addLiquidityETH{value: ethAmount}(
729             address(this),
730             tokenAmount,
731             0, // slippage is unavoidable
732             0, // slippage is unavoidable
733             address(0xdead),
734             block.timestamp
735         );
736     }
737 
738     function swapBack() private {
739 
740         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
741             _burn(address(this), tokensForBurn);
742         }
743         tokensForBurn = 0;
744 
745         uint256 contractBalance = balanceOf(address(this));
746         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
747 
748         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
749 
750         if(contractBalance > swapTokensAtAmount * 60){
751             contractBalance = swapTokensAtAmount * 60;
752         }
753 
754         bool success;
755 
756         // Halve the amount of liquidity tokens
757         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
758 
759         swapTokensForEth(contractBalance - liquidityTokens);
760 
761         uint256 ethBalance = address(this).balance;
762         uint256 ethForLiquidity = ethBalance;
763 
764         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
765         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
766 
767         ethForLiquidity -= ethForOperations + ethForDev;
768 
769         tokensForLiquidity = 0;
770         tokensForOperations = 0;
771         tokensForDev = 0;
772         tokensForBurn = 0;
773 
774         if(liquidityTokens > 0 && ethForLiquidity > 0){
775             addLiquidity(liquidityTokens, ethForLiquidity);
776         }
777 
778         (success,) = address(devAddress).call{value: ethForDev}("");
779 
780         (success,) = address(operationsAddress).call{value: address(this).balance}("");
781     }
782 
783     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
784         require(_token != address(0), "_token address cannot be 0");
785         require(_token != address(this), "Can't withdraw native tokens");
786         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
787         _sent = IERC20(_token).transfer(_to, _contractBalance);
788         emit TransferForeignToken(_token, _contractBalance);
789     }
790 
791     // withdraw ETH if stuck or someone sends to the address
792     function withdrawStuckETH() external onlyOwner {
793         bool success;
794         (success,) = address(msg.sender).call{value: address(this).balance}("");
795     }
796 
797     function setOperationsAddress(address _operationsAddress) external onlyOwner {
798         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
799         operationsAddress = payable(_operationsAddress);
800     }
801 
802     function setDevAddress(address _devAddress) external onlyOwner {
803         require(_devAddress != address(0), "_devAddress address cannot be 0");
804         devAddress = payable(_devAddress);
805     }
806 
807     // force Swap back if slippage issues.
808     function forceSwapBack() external onlyOwner {
809         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
810         swapping = true;
811         swapBack();
812         swapping = false;
813         emit OwnerForcedSwapBack(block.timestamp);
814     }
815 
816     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
817     function buyBackTokens(uint256 amountInWei) external onlyOwner {
818         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
819 
820         address[] memory path = new address[](2);
821         path[0] = dexRouter.WETH();
822         path[1] = address(this);
823 
824         // make the swap
825         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
826             0, // accept any amount of Ethereum
827             path,
828             address(0xdead),
829             block.timestamp
830         );
831         emit BuyBackTriggered(amountInWei);
832     }
833 }