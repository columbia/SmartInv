1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 WHEN AI MEETS THE FUTURE.
6 
7 https://evolvetoken.io
8 
9 https://twitter.com/EvolveERC20
10 
11 https://t.me/evolveproject
12 
13 https://medium.com/@evolvetoken
14 
15 */
16 
17 pragma solidity 0.8.15;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 contract ERC20 is Context, IERC20, IERC20Metadata {
123     mapping(address => uint256) private _balances;
124 
125     mapping(address => mapping(address => uint256)) private _allowances;
126 
127     uint256 private _totalSupply;
128 
129     string private _name;
130     string private _symbol;
131 
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     function name() public view virtual override returns (string memory) {
138         return _name;
139     }
140 
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144 
145     function decimals() public view virtual override returns (uint8) {
146         return 18;
147     }
148 
149     function totalSupply() public view virtual override returns (uint256) {
150         return _totalSupply;
151     }
152 
153     function balanceOf(address account) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156 
157     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
158         _transfer(_msgSender(), recipient, amount);
159         return true;
160     }
161 
162     function allowance(address owner, address spender) public view virtual override returns (uint256) {
163         return _allowances[owner][spender];
164     }
165 
166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170 
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) public virtual override returns (bool) {
176         _transfer(sender, recipient, amount);
177 
178         uint256 currentAllowance = _allowances[sender][_msgSender()];
179         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
180         unchecked {
181             _approve(sender, _msgSender(), currentAllowance - amount);
182         }
183 
184         return true;
185     }
186 
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
189         return true;
190     }
191 
192     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
193         uint256 currentAllowance = _allowances[_msgSender()][spender];
194         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
195         unchecked {
196             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
197         }
198 
199         return true;
200     }
201 
202     function _transfer(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) internal virtual {
207         require(sender != address(0), "ERC20: transfer from the zero address");
208         require(recipient != address(0), "ERC20: transfer to the zero address");
209 
210         uint256 senderBalance = _balances[sender];
211         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
212         unchecked {
213             _balances[sender] = senderBalance - amount;
214         }
215         _balances[recipient] += amount;
216 
217         emit Transfer(sender, recipient, amount);
218     }
219 
220     function _createInitialSupply(address account, uint256 amount) internal virtual {
221         require(account != address(0), "ERC20: mint to the zero address");
222 
223         _totalSupply += amount;
224         _balances[account] += amount;
225         emit Transfer(address(0), account, amount);
226     }
227 
228     function _burn(address account, uint256 amount) internal virtual {
229         require(account != address(0), "ERC20: burn from the zero address");
230         uint256 accountBalance = _balances[account];
231         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
232         unchecked {
233             _balances[account] = accountBalance - amount;
234             // Overflow not possible: amount <= accountBalance <= totalSupply.
235             _totalSupply -= amount;
236         }
237 
238         emit Transfer(account, address(0), amount);
239     }
240 
241     function _approve(
242         address owner,
243         address spender,
244         uint256 amount
245     ) internal virtual {
246         require(owner != address(0), "ERC20: approve from the zero address");
247         require(spender != address(0), "ERC20: approve to the zero address");
248 
249         _allowances[owner][spender] = amount;
250         emit Approval(owner, spender, amount);
251     }
252 }
253 
254 contract Ownable is Context {
255     address private _owner;
256 
257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
258 
259     constructor () {
260         address msgSender = _msgSender();
261         _owner = msgSender;
262         emit OwnershipTransferred(address(0), msgSender);
263     }
264 
265     function owner() public view returns (address) {
266         return _owner;
267     }
268 
269     modifier onlyOwner() {
270         require(_owner == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     function renounceOwnership() external virtual onlyOwner {
275         emit OwnershipTransferred(_owner, address(0));
276         _owner = address(0);
277     }
278 
279     function transferOwnership(address newOwner) public virtual onlyOwner {
280         require(newOwner != address(0), "Ownable: new owner is the zero address");
281         emit OwnershipTransferred(_owner, newOwner);
282         _owner = newOwner;
283     }
284 }
285 
286 interface IDexRouter {
287     function factory() external pure returns (address);
288     function WETH() external pure returns (address);
289 
290     function swapExactTokensForETHSupportingFeeOnTransferTokens(
291         uint amountIn,
292         uint amountOutMin,
293         address[] calldata path,
294         address to,
295         uint deadline
296     ) external;
297 
298     function swapExactETHForTokensSupportingFeeOnTransferTokens(
299         uint amountOutMin,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external payable;
304 
305     function addLiquidityETH(
306         address token,
307         uint256 amountTokenDesired,
308         uint256 amountTokenMin,
309         uint256 amountETHMin,
310         address to,
311         uint256 deadline
312     )
313         external
314         payable
315         returns (
316             uint256 amountToken,
317             uint256 amountETH,
318             uint256 liquidity
319         );
320 }
321 
322 interface IDexFactory {
323     function createPair(address tokenA, address tokenB)
324         external
325         returns (address pair);
326 }
327 
328 contract Evolve is ERC20, Ownable {
329 
330     uint256 public maxBuyAmount;
331     uint256 public maxSellAmount;
332     uint256 public maxWalletAmount;
333 
334     IDexRouter public dexRouter;
335     address public lpPair;
336 
337     bool private swapping;
338     uint256 public swapTokensAtAmount;
339 
340     address operationsAddress;
341     address devAddress;
342 
343     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
344     uint256 public blockForPenaltyEnd;
345     mapping (address => bool) public boughtEarly;
346     uint256 public botsCaught;
347 
348     bool public limitsInEffect = true;
349     bool public tradingActive = false;
350     bool public swapEnabled = false;
351 
352      // Anti-bot and anti-whale mappings and variables
353     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
354     bool public transferDelayEnabled = true;
355 
356     uint256 public buyTotalFees;
357     uint256 public buyOperationsFee;
358     uint256 public buyLiquidityFee;
359     uint256 public buyDevFee;
360     uint256 public buyBurnFee;
361 
362     uint256 public sellTotalFees;
363     uint256 public sellOperationsFee;
364     uint256 public sellLiquidityFee;
365     uint256 public sellDevFee;
366     uint256 public sellBurnFee;
367 
368     uint256 public tokensForOperations;
369     uint256 public tokensForLiquidity;
370     uint256 public tokensForDev;
371     uint256 public tokensForBurn;
372 
373     /******************/
374 
375     // exlcude from fees and max transaction amount
376     mapping (address => bool) private _isExcludedFromFees;
377     mapping (address => bool) public _isExcludedMaxTransactionAmount;
378 
379     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
380     // could be subject to a maximum transfer amount
381     mapping (address => bool) public automatedMarketMakerPairs;
382 
383     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
384 
385     event EnabledTrading();
386 
387     event RemovedLimits();
388 
389     event ExcludeFromFees(address indexed account, bool isExcluded);
390 
391     event UpdatedMaxBuyAmount(uint256 newAmount);
392 
393     event UpdatedMaxSellAmount(uint256 newAmount);
394 
395     event UpdatedMaxWalletAmount(uint256 newAmount);
396 
397     event UpdatedOperationsAddress(address indexed newWallet);
398 
399     event MaxTransactionExclusion(address _address, bool excluded);
400 
401     event BuyBackTriggered(uint256 amount);
402 
403     event OwnerForcedSwapBack(uint256 timestamp);
404 
405     event CaughtEarlyBuyer(address sniper);
406 
407     event SwapAndLiquify(
408         uint256 tokensSwapped,
409         uint256 ethReceived,
410         uint256 tokensIntoLiquidity
411     );
412 
413     event TransferForeignToken(address token, uint256 amount);
414 
415     constructor() ERC20("Evolve", "EVLV") {
416 
417         address newOwner = msg.sender; // can leave alone if owner is deployer.
418 
419         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
420         dexRouter = _dexRouter;
421 
422         // create pair
423         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
424         _excludeFromMaxTransaction(address(lpPair), true);
425         _setAutomatedMarketMakerPair(address(lpPair), true);
426 
427         uint256 totalSupply = 5 * 1e12 * 1e18;
428 
429         maxBuyAmount = totalSupply * 1 / 100;
430         maxSellAmount = totalSupply * 1 / 100;
431         maxWalletAmount = totalSupply * 1 / 100;
432         swapTokensAtAmount = totalSupply * 5 / 10000;
433 
434         buyOperationsFee = 15;
435         buyLiquidityFee = 0;
436         buyDevFee = 0;
437         buyBurnFee = 0;
438         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
439 
440         sellOperationsFee = 30;
441         sellLiquidityFee = 0;
442         sellDevFee = 0;
443         sellBurnFee = 0;
444         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
445 
446         _excludeFromMaxTransaction(newOwner, true);
447         _excludeFromMaxTransaction(address(this), true);
448         _excludeFromMaxTransaction(address(0xdead), true);
449 
450         excludeFromFees(newOwner, true);
451         excludeFromFees(address(this), true);
452         excludeFromFees(address(0xdead), true);
453 
454         operationsAddress = address(newOwner);
455         devAddress = address(newOwner);
456 
457         _createInitialSupply(newOwner, totalSupply);
458         transferOwnership(newOwner);
459     }
460 
461     receive() external payable {}
462 
463     // only enable if no plan to airdrop
464 
465     function enableTrading(uint256 deadBlocks) external onlyOwner {
466         require(!tradingActive, "Cannot reenable trading");
467         tradingActive = true;
468         swapEnabled = true;
469         tradingActiveBlock = block.number;
470         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
471         emit EnabledTrading();
472     }
473 
474     // remove limits after token is stable
475     function removeLimits() external onlyOwner {
476         limitsInEffect = false;
477         transferDelayEnabled = false;
478         emit RemovedLimits();
479     }
480 
481     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
482         boughtEarly[wallet] = flag;
483     }
484 
485     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
486         for(uint256 i = 0; i < wallets.length; i++){
487             boughtEarly[wallets[i]] = flag;
488         }
489     }
490 
491     // disable Transfer delay - cannot be reenabled
492     function disableTransferDelay() external onlyOwner {
493         transferDelayEnabled = false;
494     }
495 
496     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
497         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
498         maxBuyAmount = newNum * (10**18);
499         emit UpdatedMaxBuyAmount(maxBuyAmount);
500     }
501 
502     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
503         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
504         maxSellAmount = newNum * (10**18);
505         emit UpdatedMaxSellAmount(maxSellAmount);
506     }
507 
508     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
509         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
510         maxWalletAmount = newNum * (10**18);
511         emit UpdatedMaxWalletAmount(maxWalletAmount);
512     }
513 
514     // change the minimum amount of tokens to sell from fees
515     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
516   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
517   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
518   	    swapTokensAtAmount = newAmount;
519   	}
520 
521     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
522         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
523         emit MaxTransactionExclusion(updAds, isExcluded);
524     }
525 
526     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
527         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
528         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
529         for(uint256 i = 0; i < wallets.length; i++){
530             address wallet = wallets[i];
531             uint256 amount = amountsInTokens[i];
532             super._transfer(msg.sender, wallet, amount);
533         }
534     }
535 
536     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
537         if(!isEx){
538             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
539         }
540         _isExcludedMaxTransactionAmount[updAds] = isEx;
541     }
542 
543     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
544         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
545 
546         _setAutomatedMarketMakerPair(pair, value);
547         emit SetAutomatedMarketMakerPair(pair, value);
548     }
549 
550     function _setAutomatedMarketMakerPair(address pair, bool value) private {
551         automatedMarketMakerPairs[pair] = value;
552 
553         _excludeFromMaxTransaction(pair, value);
554 
555         emit SetAutomatedMarketMakerPair(pair, value);
556     }
557 
558     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
559         buyOperationsFee = _operationsFee;
560         buyLiquidityFee = _liquidityFee;
561         buyDevFee = _devFee;
562         buyBurnFee = _burnFee;
563         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
564         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
565     }
566 
567     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
568         sellOperationsFee = _operationsFee;
569         sellLiquidityFee = _liquidityFee;
570         sellDevFee = _devFee;
571         sellBurnFee = _burnFee;
572         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
573         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
574     }
575 
576     function returnToNormalTax() external onlyOwner {
577         sellOperationsFee = 30;
578         sellLiquidityFee = 0;
579         sellDevFee = 0;
580         sellBurnFee = 0;
581         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
582         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
583 
584         buyOperationsFee = 15;
585         buyLiquidityFee = 0;
586         buyDevFee = 0;
587         buyBurnFee = 0;
588         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
589         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
590     }
591 
592     function excludeFromFees(address account, bool excluded) public onlyOwner {
593         _isExcludedFromFees[account] = excluded;
594         emit ExcludeFromFees(account, excluded);
595     }
596 
597     function _transfer(address from, address to, uint256 amount) internal override {
598 
599         require(from != address(0), "ERC20: transfer from the zero address");
600         require(to != address(0), "ERC20: transfer to the zero address");
601         require(amount > 0, "amount must be greater than 0");
602 
603         if(!tradingActive){
604             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
605         }
606 
607         if(blockForPenaltyEnd > 0){
608             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
609         }
610 
611         if(limitsInEffect){
612             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
613 
614                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
615                 if (transferDelayEnabled){
616                     if (to != address(dexRouter) && to != address(lpPair)){
617                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
618                         _holderLastTransferTimestamp[tx.origin] = block.number;
619                         _holderLastTransferTimestamp[to] = block.number;
620                     }
621                 }
622 
623                 //when buy
624                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
625                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
626                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
627                 }
628                 //when sell
629                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
630                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
631                 }
632                 else if (!_isExcludedMaxTransactionAmount[to]){
633                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
634                 }
635             }
636         }
637 
638         uint256 contractTokenBalance = balanceOf(address(this));
639 
640         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
641 
642         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
643             swapping = true;
644 
645             swapBack();
646 
647             swapping = false;
648         }
649 
650         bool takeFee = true;
651         // if any account belongs to _isExcludedFromFee account then remove the fee
652         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
653             takeFee = false;
654         }
655 
656         uint256 fees = 0;
657         // only take fees on buys/sells, do not take on wallet transfers
658         if(takeFee){
659             // bot/sniper penalty.
660             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
661 
662                 if(!boughtEarly[to]){
663                     boughtEarly[to] = true;
664                     botsCaught += 1;
665                     emit CaughtEarlyBuyer(to);
666                 }
667 
668                 fees = amount * 99 / 100;
669         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
670                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
671                 tokensForDev += fees * buyDevFee / buyTotalFees;
672                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
673             }
674 
675             // on sell
676             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
677                 fees = amount * sellTotalFees / 100;
678                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
679                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
680                 tokensForDev += fees * sellDevFee / sellTotalFees;
681                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
682             }
683 
684             // on buy
685             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
686         	    fees = amount * buyTotalFees / 100;
687         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
688                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
689                 tokensForDev += fees * buyDevFee / buyTotalFees;
690                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
691             }
692 
693             if(fees > 0){
694                 super._transfer(from, address(this), fees);
695             }
696 
697         	amount -= fees;
698         }
699 
700         super._transfer(from, to, amount);
701     }
702 
703     function earlyBuyPenaltyInEffect() public view returns (bool){
704         return block.number < blockForPenaltyEnd;
705     }
706 
707     function swapTokensForEth(uint256 tokenAmount) private {
708 
709         // generate the uniswap pair path of token -> weth
710         address[] memory path = new address[](2);
711         path[0] = address(this);
712         path[1] = dexRouter.WETH();
713 
714         _approve(address(this), address(dexRouter), tokenAmount);
715 
716         // make the swap
717         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
718             tokenAmount,
719             0, // accept any amount of ETH
720             path,
721             address(this),
722             block.timestamp
723         );
724     }
725 
726     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
727         // approve token transfer to cover all possible scenarios
728         _approve(address(this), address(dexRouter), tokenAmount);
729 
730         // add the liquidity
731         dexRouter.addLiquidityETH{value: ethAmount}(
732             address(this),
733             tokenAmount,
734             0, // slippage is unavoidable
735             0, // slippage is unavoidable
736             address(0xdead),
737             block.timestamp
738         );
739     }
740 
741     function swapBack() private {
742 
743         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
744             _burn(address(this), tokensForBurn);
745         }
746         tokensForBurn = 0;
747 
748         uint256 contractBalance = balanceOf(address(this));
749         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
750 
751         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
752 
753         if(contractBalance > swapTokensAtAmount * 20){
754             contractBalance = swapTokensAtAmount * 20;
755         }
756 
757         bool success;
758 
759         // Halve the amount of liquidity tokens
760         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
761 
762         swapTokensForEth(contractBalance - liquidityTokens);
763 
764         uint256 ethBalance = address(this).balance;
765         uint256 ethForLiquidity = ethBalance;
766 
767         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
768         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
769 
770         ethForLiquidity -= ethForOperations + ethForDev;
771 
772         tokensForLiquidity = 0;
773         tokensForOperations = 0;
774         tokensForDev = 0;
775         tokensForBurn = 0;
776 
777         if(liquidityTokens > 0 && ethForLiquidity > 0){
778             addLiquidity(liquidityTokens, ethForLiquidity);
779         }
780 
781         (success,) = address(devAddress).call{value: ethForDev}("");
782 
783         (success,) = address(operationsAddress).call{value: address(this).balance}("");
784     }
785 
786     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
787         require(_token != address(0), "_token address cannot be 0");
788         require(_token != address(this), "Can't withdraw native tokens");
789         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
790         _sent = IERC20(_token).transfer(_to, _contractBalance);
791         emit TransferForeignToken(_token, _contractBalance);
792     }
793 
794     // withdraw ETH if stuck or someone sends to the address
795     function withdrawStuckETH() external onlyOwner {
796         bool success;
797         (success,) = address(msg.sender).call{value: address(this).balance}("");
798     }
799 
800     function setOperationsAddress(address _operationsAddress) external onlyOwner {
801         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
802         operationsAddress = payable(_operationsAddress);
803     }
804 
805     function setDevAddress(address _devAddress) external onlyOwner {
806         require(_devAddress != address(0), "_devAddress address cannot be 0");
807         devAddress = payable(_devAddress);
808     }
809 
810     // force Swap back if slippage issues.
811     function forceSwapBack() external onlyOwner {
812         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
813         swapping = true;
814         swapBack();
815         swapping = false;
816         emit OwnerForcedSwapBack(block.timestamp);
817     }
818 
819     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
820     function buyBackTokens(uint256 amountInWei) external onlyOwner {
821         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
822 
823         address[] memory path = new address[](2);
824         path[0] = dexRouter.WETH();
825         path[1] = address(this);
826 
827         // make the swap
828         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
829             0, // accept any amount of Ethereum
830             path,
831             address(0xdead),
832             block.timestamp
833         );
834         emit BuyBackTriggered(amountInWei);
835     }
836 }