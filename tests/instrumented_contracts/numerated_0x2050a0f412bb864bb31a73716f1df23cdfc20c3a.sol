1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /**
8 
9 */
10 
11 pragma solidity 0.8.16;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 contract ERC20 is Context, IERC20, IERC20Metadata {
117     mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     string private _name;
124     string private _symbol;
125 
126     constructor(string memory name_, string memory symbol_) {
127         _name = name_;
128         _symbol = symbol_;
129     }
130 
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public view virtual override returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view virtual override returns (uint8) {
140         return 18;
141     }
142 
143     function totalSupply() public view virtual override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     function balanceOf(address account) public view virtual override returns (uint256) {
148         return _balances[account];
149     }
150 
151     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     function allowance(address owner, address spender) public view virtual override returns (uint256) {
157         return _allowances[owner][spender];
158     }
159 
160     function approve(address spender, uint256 amount) public virtual override returns (bool) {
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164 
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) public virtual override returns (bool) {
170         _transfer(sender, recipient, amount);
171 
172         uint256 currentAllowance = _allowances[sender][_msgSender()];
173         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
174         unchecked {
175             _approve(sender, _msgSender(), currentAllowance - amount);
176         }
177 
178         return true;
179     }
180 
181     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
182         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
183         return true;
184     }
185 
186     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
187         uint256 currentAllowance = _allowances[_msgSender()][spender];
188         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
189         unchecked {
190             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
191         }
192 
193         return true;
194     }
195 
196     function _transfer(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) internal virtual {
201         require(sender != address(0), "ERC20: transfer from the zero address");
202         require(recipient != address(0), "ERC20: transfer to the zero address");
203 
204         uint256 senderBalance = _balances[sender];
205         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
206         unchecked {
207             _balances[sender] = senderBalance - amount;
208         }
209         _balances[recipient] += amount;
210 
211         emit Transfer(sender, recipient, amount);
212     }
213 
214     function _createInitialSupply(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: mint to the zero address");
216 
217         _totalSupply += amount;
218         _balances[account] += amount;
219         emit Transfer(address(0), account, amount);
220     }
221 
222     function _burn(address account, uint256 amount) internal virtual {
223         require(account != address(0), "ERC20: burn from the zero address");
224         uint256 accountBalance = _balances[account];
225         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
226         unchecked {
227             _balances[account] = accountBalance - amount;
228             // Overflow not possible: amount <= accountBalance <= totalSupply.
229             _totalSupply -= amount;
230         }
231 
232         emit Transfer(account, address(0), amount);
233     }
234 
235     function _approve(
236         address owner,
237         address spender,
238         uint256 amount
239     ) internal virtual {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242 
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 }
247 
248 contract Ownable is Context {
249     address private _owner;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     constructor () {
254         address msgSender = _msgSender();
255         _owner = msgSender;
256         emit OwnershipTransferred(address(0), msgSender);
257     }
258 
259     function owner() public view returns (address) {
260         return _owner;
261     }
262 
263     modifier onlyOwner() {
264         require(_owner == _msgSender(), "Ownable: caller is not the owner");
265         _;
266     }
267 
268     function renounceOwnership() external virtual onlyOwner {
269         emit OwnershipTransferred(_owner, address(0));
270         _owner = address(0);
271     }
272 
273     function transferOwnership(address newOwner) public virtual onlyOwner {
274         require(newOwner != address(0), "Ownable: new owner is the zero address");
275         emit OwnershipTransferred(_owner, newOwner);
276         _owner = newOwner;
277     }
278 }
279 
280 interface IDexRouter {
281     function factory() external pure returns (address);
282     function WETH() external pure returns (address);
283 
284     function swapExactTokensForETHSupportingFeeOnTransferTokens(
285         uint amountIn,
286         uint amountOutMin,
287         address[] calldata path,
288         address to,
289         uint deadline
290     ) external;
291 
292     function swapExactETHForTokensSupportingFeeOnTransferTokens(
293         uint amountOutMin,
294         address[] calldata path,
295         address to,
296         uint deadline
297     ) external payable;
298 
299     function addLiquidityETH(
300         address token,
301         uint256 amountTokenDesired,
302         uint256 amountTokenMin,
303         uint256 amountETHMin,
304         address to,
305         uint256 deadline
306     )
307         external
308         payable
309         returns (
310             uint256 amountToken,
311             uint256 amountETH,
312             uint256 liquidity
313         );
314 }
315 
316 interface IDexFactory {
317     function createPair(address tokenA, address tokenB)
318         external
319         returns (address pair);
320 }
321 
322 contract SIUUKA is ERC20, Ownable {
323 
324     uint256 public maxBuyAmount;
325     uint256 public maxSellAmount;
326     uint256 public maxWalletAmount;
327 
328     IDexRouter public dexRouter;
329     address public lpPair;
330 
331     bool private swapping;
332     uint256 public swapTokensAtAmount;
333 
334     address operationsAddress;
335     address devAddress;
336 
337     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
338     uint256 public blockForPenaltyEnd;
339     mapping (address => bool) public boughtEarly;
340     uint256 public botsCaught;
341 
342     bool public limitsInEffect = true;
343     bool public tradingActive = false;
344     bool public swapEnabled = false;
345 
346      // Anti-bot and anti-whale mappings and variables
347     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
348     bool public transferDelayEnabled = true;
349 
350     uint256 public buyTotalFees;
351     uint256 public buyOperationsFee;
352     uint256 public buyLiquidityFee;
353     uint256 public buyDevFee;
354     uint256 public buyBurnFee;
355 
356     uint256 public sellTotalFees;
357     uint256 public sellOperationsFee;
358     uint256 public sellLiquidityFee;
359     uint256 public sellDevFee;
360     uint256 public sellBurnFee;
361 
362     uint256 public tokensForOperations;
363     uint256 public tokensForLiquidity;
364     uint256 public tokensForDev;
365     uint256 public tokensForBurn;
366 
367     /******************/
368 
369     // exlcude from fees and max transaction amount
370     mapping (address => bool) private _isExcludedFromFees;
371     mapping (address => bool) public _isExcludedMaxTransactionAmount;
372 
373     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
374     // could be subject to a maximum transfer amount
375     mapping (address => bool) public automatedMarketMakerPairs;
376 
377     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
378 
379     event EnabledTrading();
380 
381     event RemovedLimits();
382 
383     event ExcludeFromFees(address indexed account, bool isExcluded);
384 
385     event UpdatedMaxBuyAmount(uint256 newAmount);
386 
387     event UpdatedMaxSellAmount(uint256 newAmount);
388 
389     event UpdatedMaxWalletAmount(uint256 newAmount);
390 
391     event UpdatedOperationsAddress(address indexed newWallet);
392 
393     event MaxTransactionExclusion(address _address, bool excluded);
394 
395     event BuyBackTriggered(uint256 amount);
396 
397     event OwnerForcedSwapBack(uint256 timestamp);
398 
399     event CaughtEarlyBuyer(address sniper);
400 
401     event SwapAndLiquify(
402         uint256 tokensSwapped,
403         uint256 ethReceived,
404         uint256 tokensIntoLiquidity
405     );
406 
407     event TransferForeignToken(address token, uint256 amount);
408 
409     constructor() ERC20("TSUKA WORLD CUP", "SIUUKA") {
410 
411         address newOwner = msg.sender; // can leave alone if owner is deployer.
412 
413         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
414         dexRouter = _dexRouter;
415 
416         // create pair
417         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
418         _excludeFromMaxTransaction(address(lpPair), true);
419         _setAutomatedMarketMakerPair(address(lpPair), true);
420 
421         uint256 totalSupply = 1 * 1e7 * 1e18;
422 
423         maxBuyAmount = totalSupply * 1 / 100;
424         maxSellAmount = totalSupply * 1 / 100;
425         maxWalletAmount = totalSupply * 1 / 100;
426         swapTokensAtAmount = totalSupply * 5 / 10000;
427 
428         buyOperationsFee = 3;
429         buyLiquidityFee = 2;
430         buyDevFee = 2;
431         buyBurnFee = 0;
432         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
433 
434         sellOperationsFee = 3;
435         sellLiquidityFee = 2;
436         sellDevFee = 2;
437         sellBurnFee = 0;
438         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
439 
440         _excludeFromMaxTransaction(newOwner, true);
441         _excludeFromMaxTransaction(address(this), true);
442         _excludeFromMaxTransaction(address(0xdead), true);
443 
444         excludeFromFees(newOwner, true);
445         excludeFromFees(address(this), true);
446         excludeFromFees(address(0xdead), true);
447 
448         operationsAddress = address(newOwner);
449         devAddress = address(newOwner);
450 
451         _createInitialSupply(newOwner, totalSupply);
452         transferOwnership(newOwner);
453     }
454 
455     receive() external payable {}
456 
457     // only enable if no plan to airdrop
458 
459     function enableTrading(uint256 deadBlocks) external onlyOwner {
460         require(!tradingActive, "Cannot reenable trading");
461         tradingActive = true;
462         swapEnabled = true;
463         tradingActiveBlock = block.number;
464         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
465         emit EnabledTrading();
466     }
467 
468     // remove limits after token is stable
469     function removeLimits() external onlyOwner {
470         limitsInEffect = false;
471         transferDelayEnabled = false;
472         emit RemovedLimits();
473     }
474 
475     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
476         boughtEarly[wallet] = flag;
477     }
478 
479     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
480         for(uint256 i = 0; i < wallets.length; i++){
481             boughtEarly[wallets[i]] = flag;
482         }
483     }
484 
485     // disable Transfer delay - cannot be reenabled
486     function disableTransferDelay() external onlyOwner {
487         transferDelayEnabled = false;
488     }
489 
490     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
491         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
492         maxBuyAmount = newNum * (10**18);
493         emit UpdatedMaxBuyAmount(maxBuyAmount);
494     }
495 
496     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
497         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
498         maxSellAmount = newNum * (10**18);
499         emit UpdatedMaxSellAmount(maxSellAmount);
500     }
501 
502     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
503         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
504         maxWalletAmount = newNum * (10**18);
505         emit UpdatedMaxWalletAmount(maxWalletAmount);
506     }
507 
508     // change the minimum amount of tokens to sell from fees
509     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
510   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
511   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
512   	    swapTokensAtAmount = newAmount;
513   	}
514 
515     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
516         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
517         emit MaxTransactionExclusion(updAds, isExcluded);
518     }
519 
520     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
521         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
522         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
523         for(uint256 i = 0; i < wallets.length; i++){
524             address wallet = wallets[i];
525             uint256 amount = amountsInTokens[i];
526             super._transfer(msg.sender, wallet, amount);
527         }
528     }
529 
530     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
531         if(!isEx){
532             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
533         }
534         _isExcludedMaxTransactionAmount[updAds] = isEx;
535     }
536 
537     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
538         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
539 
540         _setAutomatedMarketMakerPair(pair, value);
541         emit SetAutomatedMarketMakerPair(pair, value);
542     }
543 
544     function _setAutomatedMarketMakerPair(address pair, bool value) private {
545         automatedMarketMakerPairs[pair] = value;
546 
547         _excludeFromMaxTransaction(pair, value);
548 
549         emit SetAutomatedMarketMakerPair(pair, value);
550     }
551 
552     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
553         buyOperationsFee = _operationsFee;
554         buyLiquidityFee = _liquidityFee;
555         buyDevFee = _devFee;
556         buyBurnFee = _burnFee;
557         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
558         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
559     }
560 
561     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
562         sellOperationsFee = _operationsFee;
563         sellLiquidityFee = _liquidityFee;
564         sellDevFee = _devFee;
565         sellBurnFee = _burnFee;
566         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
567         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
568     }
569 
570     function returnToNormalTax() external onlyOwner {
571         sellOperationsFee = 20;
572         sellLiquidityFee = 0;
573         sellDevFee = 0;
574         sellBurnFee = 0;
575         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
576         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
577 
578         buyOperationsFee = 20;
579         buyLiquidityFee = 0;
580         buyDevFee = 0;
581         buyBurnFee = 0;
582         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
583         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
584     }
585 
586     function excludeFromFees(address account, bool excluded) public onlyOwner {
587         _isExcludedFromFees[account] = excluded;
588         emit ExcludeFromFees(account, excluded);
589     }
590 
591     function _transfer(address from, address to, uint256 amount) internal override {
592 
593         require(from != address(0), "ERC20: transfer from the zero address");
594         require(to != address(0), "ERC20: transfer to the zero address");
595         require(amount > 0, "amount must be greater than 0");
596 
597         if(!tradingActive){
598             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
599         }
600 
601         if(blockForPenaltyEnd > 0){
602             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
603         }
604 
605         if(limitsInEffect){
606             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
607 
608                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
609                 if (transferDelayEnabled){
610                     if (to != address(dexRouter) && to != address(lpPair)){
611                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
612                         _holderLastTransferTimestamp[tx.origin] = block.number;
613                         _holderLastTransferTimestamp[to] = block.number;
614                     }
615                 }
616 
617                 //when buy
618                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
619                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
620                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
621                 }
622                 //when sell
623                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
624                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
625                 }
626                 else if (!_isExcludedMaxTransactionAmount[to]){
627                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
628                 }
629             }
630         }
631 
632         uint256 contractTokenBalance = balanceOf(address(this));
633 
634         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
635 
636         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
637             swapping = true;
638 
639             swapBack();
640 
641             swapping = false;
642         }
643 
644         bool takeFee = true;
645         // if any account belongs to _isExcludedFromFee account then remove the fee
646         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
647             takeFee = false;
648         }
649 
650         uint256 fees = 0;
651         // only take fees on buys/sells, do not take on wallet transfers
652         if(takeFee){
653             // bot/sniper penalty.
654             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
655 
656                 if(!boughtEarly[to]){
657                     boughtEarly[to] = true;
658                     botsCaught += 1;
659                     emit CaughtEarlyBuyer(to);
660                 }
661 
662                 fees = amount * 99 / 100;
663         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
664                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
665                 tokensForDev += fees * buyDevFee / buyTotalFees;
666                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
667             }
668 
669             // on sell
670             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
671                 fees = amount * sellTotalFees / 100;
672                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
673                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
674                 tokensForDev += fees * sellDevFee / sellTotalFees;
675                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
676             }
677 
678             // on buy
679             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
680         	    fees = amount * buyTotalFees / 100;
681         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
682                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
683                 tokensForDev += fees * buyDevFee / buyTotalFees;
684                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
685             }
686 
687             if(fees > 0){
688                 super._transfer(from, address(this), fees);
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
730             address(0xdead),
731             block.timestamp
732         );
733     }
734 
735     function swapBack() private {
736 
737         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
738             _burn(address(this), tokensForBurn);
739         }
740         tokensForBurn = 0;
741 
742         uint256 contractBalance = balanceOf(address(this));
743         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
744 
745         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
746 
747         if(contractBalance > swapTokensAtAmount * 20){
748             contractBalance = swapTokensAtAmount * 20;
749         }
750 
751         bool success;
752 
753         // Halve the amount of liquidity tokens
754         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
755 
756         swapTokensForEth(contractBalance - liquidityTokens);
757 
758         uint256 ethBalance = address(this).balance;
759         uint256 ethForLiquidity = ethBalance;
760 
761         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
762         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
763 
764         ethForLiquidity -= ethForOperations + ethForDev;
765 
766         tokensForLiquidity = 0;
767         tokensForOperations = 0;
768         tokensForDev = 0;
769         tokensForBurn = 0;
770 
771         if(liquidityTokens > 0 && ethForLiquidity > 0){
772             addLiquidity(liquidityTokens, ethForLiquidity);
773         }
774 
775         (success,) = address(devAddress).call{value: ethForDev}("");
776 
777         (success,) = address(operationsAddress).call{value: address(this).balance}("");
778     }
779 
780     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
781         require(_token != address(0), "_token address cannot be 0");
782         require(_token != address(this), "Can't withdraw native tokens");
783         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
784         _sent = IERC20(_token).transfer(_to, _contractBalance);
785         emit TransferForeignToken(_token, _contractBalance);
786     }
787 
788     // withdraw ETH if stuck or someone sends to the address
789     function withdrawStuckETH() external onlyOwner {
790         bool success;
791         (success,) = address(msg.sender).call{value: address(this).balance}("");
792     }
793 
794     function setOperationsAddress(address _operationsAddress) external onlyOwner {
795         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
796         operationsAddress = payable(_operationsAddress);
797     }
798 
799     function setDevAddress(address _devAddress) external onlyOwner {
800         require(_devAddress != address(0), "_devAddress address cannot be 0");
801         devAddress = payable(_devAddress);
802     }
803 
804     // force Swap back if slippage issues.
805     function forceSwapBack() external onlyOwner {
806         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
807         swapping = true;
808         swapBack();
809         swapping = false;
810         emit OwnerForcedSwapBack(block.timestamp);
811     }
812 
813     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
814     function buyBackTokens(uint256 amountInWei) external onlyOwner {
815         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
816 
817         address[] memory path = new address[](2);
818         path[0] = dexRouter.WETH();
819         path[1] = address(this);
820 
821         // make the swap
822         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
823             0, // accept any amount of Ethereum
824             path,
825             address(0xdead),
826             block.timestamp
827         );
828         emit BuyBackTriggered(amountInWei);
829     }
830 }