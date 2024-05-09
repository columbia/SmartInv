1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 ordinex.io
6 
7 */
8 
9 pragma solidity 0.8.15;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 contract ERC20 is Context, IERC20, IERC20Metadata {
115     mapping(address => uint256) private _balances;
116 
117     mapping(address => mapping(address => uint256)) private _allowances;
118 
119     uint256 private _totalSupply;
120 
121     string private _name;
122     string private _symbol;
123 
124     constructor(string memory name_, string memory symbol_) {
125         _name = name_;
126         _symbol = symbol_;
127     }
128 
129     function name() public view virtual override returns (string memory) {
130         return _name;
131     }
132 
133     function symbol() public view virtual override returns (string memory) {
134         return _symbol;
135     }
136 
137     function decimals() public view virtual override returns (uint8) {
138         return 18;
139     }
140 
141     function totalSupply() public view virtual override returns (uint256) {
142         return _totalSupply;
143     }
144 
145     function balanceOf(address account) public view virtual override returns (uint256) {
146         return _balances[account];
147     }
148 
149     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
150         _transfer(_msgSender(), recipient, amount);
151         return true;
152     }
153 
154     function allowance(address owner, address spender) public view virtual override returns (uint256) {
155         return _allowances[owner][spender];
156     }
157 
158     function approve(address spender, uint256 amount) public virtual override returns (bool) {
159         _approve(_msgSender(), spender, amount);
160         return true;
161     }
162 
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) public virtual override returns (bool) {
168         _transfer(sender, recipient, amount);
169 
170         uint256 currentAllowance = _allowances[sender][_msgSender()];
171         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
172         unchecked {
173             _approve(sender, _msgSender(), currentAllowance - amount);
174         }
175 
176         return true;
177     }
178 
179     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
180         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
181         return true;
182     }
183 
184     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
185         uint256 currentAllowance = _allowances[_msgSender()][spender];
186         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
187         unchecked {
188             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
189         }
190 
191         return true;
192     }
193 
194     function _transfer(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) internal virtual {
199         require(sender != address(0), "ERC20: transfer from the zero address");
200         require(recipient != address(0), "ERC20: transfer to the zero address");
201 
202         uint256 senderBalance = _balances[sender];
203         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
204         unchecked {
205             _balances[sender] = senderBalance - amount;
206         }
207         _balances[recipient] += amount;
208 
209         emit Transfer(sender, recipient, amount);
210     }
211 
212     function _createInitialSupply(address account, uint256 amount) internal virtual {
213         require(account != address(0), "ERC20: mint to the zero address");
214 
215         _totalSupply += amount;
216         _balances[account] += amount;
217         emit Transfer(address(0), account, amount);
218     }
219 
220     function _burn(address account, uint256 amount) internal virtual {
221         require(account != address(0), "ERC20: burn from the zero address");
222         uint256 accountBalance = _balances[account];
223         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
224         unchecked {
225             _balances[account] = accountBalance - amount;
226             // Overflow not possible: amount <= accountBalance <= totalSupply.
227             _totalSupply -= amount;
228         }
229 
230         emit Transfer(account, address(0), amount);
231     }
232 
233     function _approve(
234         address owner,
235         address spender,
236         uint256 amount
237     ) internal virtual {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240 
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244 }
245 
246 contract Ownable is Context {
247     address private _owner;
248 
249     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251     constructor () {
252         address msgSender = _msgSender();
253         _owner = msgSender;
254         emit OwnershipTransferred(address(0), msgSender);
255     }
256 
257     function owner() public view returns (address) {
258         return _owner;
259     }
260 
261     modifier onlyOwner() {
262         require(_owner == _msgSender(), "Ownable: caller is not the owner");
263         _;
264     }
265 
266     function renounceOwnership() external virtual onlyOwner {
267         emit OwnershipTransferred(_owner, address(0));
268         _owner = address(0);
269     }
270 
271     function transferOwnership(address newOwner) public virtual onlyOwner {
272         require(newOwner != address(0), "Ownable: new owner is the zero address");
273         emit OwnershipTransferred(_owner, newOwner);
274         _owner = newOwner;
275     }
276 }
277 
278 interface IDexRouter {
279     function factory() external pure returns (address);
280     function WETH() external pure returns (address);
281 
282     function swapExactTokensForETHSupportingFeeOnTransferTokens(
283         uint amountIn,
284         uint amountOutMin,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external;
289 
290     function swapExactETHForTokensSupportingFeeOnTransferTokens(
291         uint amountOutMin,
292         address[] calldata path,
293         address to,
294         uint deadline
295     ) external payable;
296 
297     function addLiquidityETH(
298         address token,
299         uint256 amountTokenDesired,
300         uint256 amountTokenMin,
301         uint256 amountETHMin,
302         address to,
303         uint256 deadline
304     )
305         external
306         payable
307         returns (
308             uint256 amountToken,
309             uint256 amountETH,
310             uint256 liquidity
311         );
312 }
313 
314 interface IDexFactory {
315     function createPair(address tokenA, address tokenB)
316         external
317         returns (address pair);
318 }
319 
320 contract ordinex is ERC20, Ownable {
321 
322     uint256 public maxBuyAmount;
323     uint256 public maxSellAmount;
324     uint256 public maxWalletAmount;
325 
326     IDexRouter public dexRouter;
327     address public lpPair;
328 
329     bool private swapping;
330     uint256 public swapTokensAtAmount;
331 
332     address operationsAddress;
333     address devAddress;
334 
335     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
336     uint256 public blockForPenaltyEnd;
337     mapping (address => bool) public boughtEarly;
338     uint256 public botsCaught;
339 
340     bool public limitsInEffect = true;
341     bool public tradingActive = false;
342     bool public swapEnabled = false;
343 
344      // Anti-bot and anti-whale mappings and variables
345     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
346     bool public transferDelayEnabled = true;
347 
348     uint256 public buyTotalFees;
349     uint256 public buyOperationsFee;
350     uint256 public buyLiquidityFee;
351     uint256 public buyDevFee;
352     uint256 public buyBurnFee;
353 
354     uint256 public sellTotalFees;
355     uint256 public sellOperationsFee;
356     uint256 public sellLiquidityFee;
357     uint256 public sellDevFee;
358     uint256 public sellBurnFee;
359 
360     uint256 public tokensForOperations;
361     uint256 public tokensForLiquidity;
362     uint256 public tokensForDev;
363     uint256 public tokensForBurn;
364 
365     /******************/
366 
367     // exlcude from fees and max transaction amount
368     mapping (address => bool) private _isExcludedFromFees;
369     mapping (address => bool) public _isExcludedMaxTransactionAmount;
370 
371     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
372     // could be subject to a maximum transfer amount
373     mapping (address => bool) public automatedMarketMakerPairs;
374 
375     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
376 
377     event EnabledTrading();
378 
379     event RemovedLimits();
380 
381     event ExcludeFromFees(address indexed account, bool isExcluded);
382 
383     event UpdatedMaxBuyAmount(uint256 newAmount);
384 
385     event UpdatedMaxSellAmount(uint256 newAmount);
386 
387     event UpdatedMaxWalletAmount(uint256 newAmount);
388 
389     event UpdatedOperationsAddress(address indexed newWallet);
390 
391     event MaxTransactionExclusion(address _address, bool excluded);
392 
393     event BuyBackTriggered(uint256 amount);
394 
395     event OwnerForcedSwapBack(uint256 timestamp);
396 
397     event CaughtEarlyBuyer(address sniper);
398 
399     event SwapAndLiquify(
400         uint256 tokensSwapped,
401         uint256 ethReceived,
402         uint256 tokensIntoLiquidity
403     );
404 
405     event TransferForeignToken(address token, uint256 amount);
406 
407     constructor() ERC20("ordinex", "ORD") {
408 
409         address newOwner = msg.sender; // can leave alone if owner is deployer.
410 
411         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
412         dexRouter = _dexRouter;
413 
414         // create pair
415         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
416         _excludeFromMaxTransaction(address(lpPair), true);
417         _setAutomatedMarketMakerPair(address(lpPair), true);
418 
419         uint256 totalSupply = 1 * 1e12 * 1e18;
420 
421         maxBuyAmount = totalSupply * 1 / 100;
422         maxSellAmount = totalSupply * 1 / 100;
423         maxWalletAmount = totalSupply * 1 / 100;
424         swapTokensAtAmount = totalSupply * 1 / 1000;
425 
426         buyOperationsFee = 10;
427         buyLiquidityFee = 0;
428         buyDevFee = 0;
429         buyBurnFee = 0;
430         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
431 
432         sellOperationsFee = 20;
433         sellLiquidityFee = 0;
434         sellDevFee = 0;
435         sellBurnFee = 0;
436         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
437 
438         _excludeFromMaxTransaction(newOwner, true);
439         _excludeFromMaxTransaction(address(this), true);
440         _excludeFromMaxTransaction(address(0xdead), true);
441 
442         excludeFromFees(newOwner, true);
443         excludeFromFees(address(this), true);
444         excludeFromFees(address(0xdead), true);
445 
446         operationsAddress = address(newOwner);
447         devAddress = address(newOwner);
448 
449         _createInitialSupply(newOwner, totalSupply);
450         transferOwnership(newOwner);
451     }
452 
453     receive() external payable {}
454 
455     // only enable if no plan to airdrop
456 
457     function enableTrading(uint256 deadBlocks) external onlyOwner {
458         require(!tradingActive, "Cannot reenable trading");
459         tradingActive = true;
460         swapEnabled = true;
461         tradingActiveBlock = block.number;
462         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
463         emit EnabledTrading();
464     }
465 
466     // remove limits after token is stable
467     function removeLimits() external onlyOwner {
468         limitsInEffect = false;
469         transferDelayEnabled = false;
470         emit RemovedLimits();
471     }
472 
473     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
474         boughtEarly[wallet] = flag;
475     }
476 
477     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
478         for(uint256 i = 0; i < wallets.length; i++){
479             boughtEarly[wallets[i]] = flag;
480         }
481     }
482 
483     // disable Transfer delay - cannot be reenabled
484     function disableTransferDelay() external onlyOwner {
485         transferDelayEnabled = false;
486     }
487 
488     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
489         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
490         maxBuyAmount = newNum * (10**18);
491         emit UpdatedMaxBuyAmount(maxBuyAmount);
492     }
493 
494     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
495         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
496         maxSellAmount = newNum * (10**18);
497         emit UpdatedMaxSellAmount(maxSellAmount);
498     }
499 
500     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
501         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
502         maxWalletAmount = newNum * (10**18);
503         emit UpdatedMaxWalletAmount(maxWalletAmount);
504     }
505 
506     // change the minimum amount of tokens to sell from fees
507     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
508   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
509   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
510   	    swapTokensAtAmount = newAmount;
511   	}
512 
513     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
514         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
515         emit MaxTransactionExclusion(updAds, isExcluded);
516     }
517 
518     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
519         if(!isEx){
520             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
521         }
522         _isExcludedMaxTransactionAmount[updAds] = isEx;
523     }
524 
525     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
526         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
527 
528         _setAutomatedMarketMakerPair(pair, value);
529         emit SetAutomatedMarketMakerPair(pair, value);
530     }
531 
532     function _setAutomatedMarketMakerPair(address pair, bool value) private {
533         automatedMarketMakerPairs[pair] = value;
534 
535         _excludeFromMaxTransaction(pair, value);
536 
537         emit SetAutomatedMarketMakerPair(pair, value);
538     }
539 
540     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
541         buyOperationsFee = _operationsFee;
542         buyLiquidityFee = _liquidityFee;
543         buyDevFee = _devFee;
544         buyBurnFee = _burnFee;
545         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
546         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
547     }
548 
549     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
550         sellOperationsFee = _operationsFee;
551         sellLiquidityFee = _liquidityFee;
552         sellDevFee = _devFee;
553         sellBurnFee = _burnFee;
554         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
555         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
556     }
557 
558     function returnToNormalTax() external onlyOwner {
559         sellOperationsFee = 3;
560         sellLiquidityFee = 0;
561         sellDevFee = 0;
562         sellBurnFee = 0;
563         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
564         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
565 
566         buyOperationsFee = 3;
567         buyLiquidityFee = 0;
568         buyDevFee = 0;
569         buyBurnFee = 0;
570         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
571         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
572     }
573 
574     function excludeFromFees(address account, bool excluded) public onlyOwner {
575         _isExcludedFromFees[account] = excluded;
576         emit ExcludeFromFees(account, excluded);
577     }
578 
579     function _transfer(address from, address to, uint256 amount) internal override {
580 
581         require(from != address(0), "ERC20: transfer from the zero address");
582         require(to != address(0), "ERC20: transfer to the zero address");
583         require(amount > 0, "amount must be greater than 0");
584 
585         if(!tradingActive){
586             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
587         }
588 
589         if(blockForPenaltyEnd > 0){
590             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
591         }
592 
593         if(limitsInEffect){
594             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
595 
596                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
597                 if (transferDelayEnabled){
598                     if (to != address(dexRouter) && to != address(lpPair)){
599                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
600                         _holderLastTransferTimestamp[tx.origin] = block.number;
601                         _holderLastTransferTimestamp[to] = block.number;
602                     }
603                 }
604 
605                 //when buy
606                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
607                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
608                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
609                 }
610                 //when sell
611                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
612                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
613                 }
614                 else if (!_isExcludedMaxTransactionAmount[to]){
615                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
616                 }
617             }
618         }
619 
620         uint256 contractTokenBalance = balanceOf(address(this));
621 
622         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
623 
624         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
625             swapping = true;
626 
627             swapBack();
628 
629             swapping = false;
630         }
631 
632         bool takeFee = true;
633         // if any account belongs to _isExcludedFromFee account then remove the fee
634         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
635             takeFee = false;
636         }
637 
638         uint256 fees = 0;
639         // only take fees on buys/sells, do not take on wallet transfers
640         if(takeFee){
641             // bot/sniper penalty.
642             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
643 
644                 if(!boughtEarly[to]){
645                     boughtEarly[to] = true;
646                     botsCaught += 1;
647                     emit CaughtEarlyBuyer(to);
648                 }
649 
650                 fees = amount * 99 / 100;
651         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
652                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
653                 tokensForDev += fees * buyDevFee / buyTotalFees;
654                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
655             }
656 
657             // on sell
658             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
659                 fees = amount * sellTotalFees / 100;
660                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
661                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
662                 tokensForDev += fees * sellDevFee / sellTotalFees;
663                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
664             }
665 
666             // on buy
667             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
668         	    fees = amount * buyTotalFees / 100;
669         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
670                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
671                 tokensForDev += fees * buyDevFee / buyTotalFees;
672                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
673             }
674 
675             if(fees > 0){
676                 super._transfer(from, address(this), fees);
677             }
678 
679         	amount -= fees;
680         }
681 
682         super._transfer(from, to, amount);
683     }
684 
685     function earlyBuyPenaltyInEffect() public view returns (bool){
686         return block.number < blockForPenaltyEnd;
687     }
688 
689     function swapTokensForEth(uint256 tokenAmount) private {
690 
691         // generate the uniswap pair path of token -> weth
692         address[] memory path = new address[](2);
693         path[0] = address(this);
694         path[1] = dexRouter.WETH();
695 
696         _approve(address(this), address(dexRouter), tokenAmount);
697 
698         // make the swap
699         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
700             tokenAmount,
701             0, // accept any amount of ETH
702             path,
703             address(this),
704             block.timestamp
705         );
706     }
707 
708     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
709         // approve token transfer to cover all possible scenarios
710         _approve(address(this), address(dexRouter), tokenAmount);
711 
712         // add the liquidity
713         dexRouter.addLiquidityETH{value: ethAmount}(
714             address(this),
715             tokenAmount,
716             0, // slippage is unavoidable
717             0, // slippage is unavoidable
718             address(0xdead),
719             block.timestamp
720         );
721     }
722 
723     function swapBack() private {
724 
725         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
726             _burn(address(this), tokensForBurn);
727         }
728         tokensForBurn = 0;
729 
730         uint256 contractBalance = balanceOf(address(this));
731         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
732 
733         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
734 
735         if(contractBalance > swapTokensAtAmount * 20){
736             contractBalance = swapTokensAtAmount * 20;
737         }
738 
739         bool success;
740 
741         // Halve the amount of liquidity tokens
742         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
743 
744         swapTokensForEth(contractBalance - liquidityTokens);
745 
746         uint256 ethBalance = address(this).balance;
747         uint256 ethForLiquidity = ethBalance;
748 
749         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
750         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
751 
752         ethForLiquidity -= ethForOperations + ethForDev;
753 
754         tokensForLiquidity = 0;
755         tokensForOperations = 0;
756         tokensForDev = 0;
757         tokensForBurn = 0;
758 
759         if(liquidityTokens > 0 && ethForLiquidity > 0){
760             addLiquidity(liquidityTokens, ethForLiquidity);
761         }
762 
763         (success,) = address(devAddress).call{value: ethForDev}("");
764 
765         (success,) = address(operationsAddress).call{value: address(this).balance}("");
766     }
767 
768     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
769         require(_token != address(0), "_token address cannot be 0");
770         require(_token != address(this), "Can't withdraw native tokens");
771         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
772         _sent = IERC20(_token).transfer(_to, _contractBalance);
773         emit TransferForeignToken(_token, _contractBalance);
774     }
775 
776     // withdraw ETH from contract address
777     function withdrawStuckETH() external onlyOwner {
778         bool success;
779         (success,) = address(msg.sender).call{value: address(this).balance}("");
780     }
781 
782     function setOperationsAddress(address _operationsAddress) external onlyOwner {
783         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
784         operationsAddress = payable(_operationsAddress);
785     }
786 
787     function setDevAddress(address _devAddress) external onlyOwner {
788         require(_devAddress != address(0), "_devAddress address cannot be 0");
789         devAddress = payable(_devAddress);
790     }
791 
792     // force Swap back if slippage issues.
793     function forceSwapBack() external onlyOwner {
794         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
795         swapping = true;
796         swapBack();
797         swapping = false;
798         emit OwnerForcedSwapBack(block.timestamp);
799     }
800 
801     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
802     function buyBackTokens(uint256 amountInWei) external onlyOwner {
803         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
804 
805         address[] memory path = new address[](2);
806         path[0] = dexRouter.WETH();
807         path[1] = address(this);
808 
809         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
810             0, // accept any amount of Ethereum
811             path,
812             address(0xdead),
813             block.timestamp
814         );
815         emit BuyBackTriggered(amountInWei);
816     }
817 }