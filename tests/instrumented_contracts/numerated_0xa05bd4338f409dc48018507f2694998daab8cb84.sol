1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.15;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 contract ERC20 is Context, IERC20, IERC20Metadata {
113     mapping(address => uint256) private _balances;
114 
115     mapping(address => mapping(address => uint256)) private _allowances;
116 
117     uint256 private _totalSupply;
118 
119     string private _name;
120     string private _symbol;
121 
122     constructor(string memory name_, string memory symbol_) {
123         _name = name_;
124         _symbol = symbol_;
125     }
126 
127     function name() public view virtual override returns (string memory) {
128         return _name;
129     }
130 
131     function symbol() public view virtual override returns (string memory) {
132         return _symbol;
133     }
134 
135     function decimals() public view virtual override returns (uint8) {
136         return 18;
137     }
138 
139     function totalSupply() public view virtual override returns (uint256) {
140         return _totalSupply;
141     }
142 
143     function balanceOf(address account) public view virtual override returns (uint256) {
144         return _balances[account];
145     }
146 
147     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
148         _transfer(_msgSender(), recipient, amount);
149         return true;
150     }
151 
152     function allowance(address owner, address spender) public view virtual override returns (uint256) {
153         return _allowances[owner][spender];
154     }
155 
156     function approve(address spender, uint256 amount) public virtual override returns (bool) {
157         _approve(_msgSender(), spender, amount);
158         return true;
159     }
160 
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) public virtual override returns (bool) {
166         _transfer(sender, recipient, amount);
167 
168         uint256 currentAllowance = _allowances[sender][_msgSender()];
169         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
170         unchecked {
171             _approve(sender, _msgSender(), currentAllowance - amount);
172         }
173 
174         return true;
175     }
176 
177     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
178         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
179         return true;
180     }
181 
182     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
183         uint256 currentAllowance = _allowances[_msgSender()][spender];
184         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
185         unchecked {
186             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
187         }
188 
189         return true;
190     }
191 
192     function _transfer(
193         address sender,
194         address recipient,
195         uint256 amount
196     ) internal virtual {
197         require(sender != address(0), "ERC20: transfer from the zero address");
198         require(recipient != address(0), "ERC20: transfer to the zero address");
199 
200         uint256 senderBalance = _balances[sender];
201         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
202         unchecked {
203             _balances[sender] = senderBalance - amount;
204         }
205         _balances[recipient] += amount;
206 
207         emit Transfer(sender, recipient, amount);
208     }
209 
210     function _createInitialSupply(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: mint to the zero address");
212 
213         _totalSupply += amount;
214         _balances[account] += amount;
215         emit Transfer(address(0), account, amount);
216     }
217 
218     function _burn(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: burn from the zero address");
220         uint256 accountBalance = _balances[account];
221         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
222         unchecked {
223             _balances[account] = accountBalance - amount;
224             // Overflow not possible: amount <= accountBalance <= totalSupply.
225             _totalSupply -= amount;
226         }
227 
228         emit Transfer(account, address(0), amount);
229     }
230 
231     function _approve(
232         address owner,
233         address spender,
234         uint256 amount
235     ) internal virtual {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238 
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 }
243 
244 contract Ownable is Context {
245     address private _owner;
246 
247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249     constructor () {
250         address msgSender = _msgSender();
251         _owner = msgSender;
252         emit OwnershipTransferred(address(0), msgSender);
253     }
254 
255     function owner() public view returns (address) {
256         return _owner;
257     }
258 
259     modifier onlyOwner() {
260         require(_owner == _msgSender(), "Ownable: caller is not the owner");
261         _;
262     }
263 
264     function renounceOwnership() external virtual onlyOwner {
265         emit OwnershipTransferred(_owner, address(0));
266         _owner = address(0);
267     }
268 
269     function transferOwnership(address newOwner) public virtual onlyOwner {
270         require(newOwner != address(0), "Ownable: new owner is the zero address");
271         emit OwnershipTransferred(_owner, newOwner);
272         _owner = newOwner;
273     }
274 }
275 
276 interface IDexRouter {
277     function factory() external pure returns (address);
278     function WETH() external pure returns (address);
279 
280     function swapExactTokensForETHSupportingFeeOnTransferTokens(
281         uint amountIn,
282         uint amountOutMin,
283         address[] calldata path,
284         address to,
285         uint deadline
286     ) external;
287 
288     function swapExactETHForTokensSupportingFeeOnTransferTokens(
289         uint amountOutMin,
290         address[] calldata path,
291         address to,
292         uint deadline
293     ) external payable;
294 
295     function addLiquidityETH(
296         address token,
297         uint256 amountTokenDesired,
298         uint256 amountTokenMin,
299         uint256 amountETHMin,
300         address to,
301         uint256 deadline
302     )
303         external
304         payable
305         returns (
306             uint256 amountToken,
307             uint256 amountETH,
308             uint256 liquidity
309         );
310 }
311 
312 interface IDexFactory {
313     function createPair(address tokenA, address tokenB)
314         external
315         returns (address pair);
316 }
317 
318 contract WrappedDoge is ERC20, Ownable {
319 
320     uint256 public maxBuyAmount;
321     uint256 public maxSellAmount;
322     uint256 public maxWalletAmount;
323 
324     IDexRouter public dexRouter;
325     address public lpPair;
326 
327     bool private swapping;
328     uint256 public swapTokensAtAmount;
329 
330     address operationsAddress;
331     address devAddress;
332 
333     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
334     uint256 public blockForPenaltyEnd;
335     mapping (address => bool) public boughtEarly;
336     uint256 public botsCaught;
337 
338     bool public limitsInEffect = true;
339     bool public tradingActive = false;
340     bool public swapEnabled = false;
341 
342      // Anti-bot and anti-whale mappings and variables
343     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
344     bool public transferDelayEnabled = true;
345 
346     uint256 public buyTotalFees;
347     uint256 public buyOperationsFee;
348     uint256 public buyLiquidityFee;
349     uint256 public buyDevFee;
350     uint256 public buyBurnFee;
351 
352     uint256 public sellTotalFees;
353     uint256 public sellOperationsFee;
354     uint256 public sellLiquidityFee;
355     uint256 public sellDevFee;
356     uint256 public sellBurnFee;
357 
358     uint256 public tokensForOperations;
359     uint256 public tokensForLiquidity;
360     uint256 public tokensForDev;
361     uint256 public tokensForBurn;
362 
363     /******************/
364 
365     // exlcude from fees and max transaction amount
366     mapping (address => bool) private _isExcludedFromFees;
367     mapping (address => bool) public _isExcludedMaxTransactionAmount;
368 
369     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
370     // could be subject to a maximum transfer amount
371     mapping (address => bool) public automatedMarketMakerPairs;
372 
373     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
374 
375     event EnabledTrading();
376 
377     event RemovedLimits();
378 
379     event ExcludeFromFees(address indexed account, bool isExcluded);
380 
381     event UpdatedMaxBuyAmount(uint256 newAmount);
382 
383     event UpdatedMaxSellAmount(uint256 newAmount);
384 
385     event UpdatedMaxWalletAmount(uint256 newAmount);
386 
387     event UpdatedOperationsAddress(address indexed newWallet);
388 
389     event MaxTransactionExclusion(address _address, bool excluded);
390 
391     event BuyBackTriggered(uint256 amount);
392 
393     event OwnerForcedSwapBack(uint256 timestamp);
394  
395     event CaughtEarlyBuyer(address sniper);
396 
397     event SwapAndLiquify(
398         uint256 tokensSwapped,
399         uint256 ethReceived,
400         uint256 tokensIntoLiquidity
401     );
402 
403     event TransferForeignToken(address token, uint256 amount);
404 
405     constructor() ERC20("Wrapped Doge", "WDOGE") {
406 
407         address newOwner = msg.sender; // can leave alone if owner is deployer.
408 
409         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
410         dexRouter = _dexRouter;
411 
412         // create pair
413         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
414         _excludeFromMaxTransaction(address(lpPair), true);
415         _setAutomatedMarketMakerPair(address(lpPair), true);
416 
417         uint256 totalSupply = 1 * 1e9 * 1e18;
418 
419         maxBuyAmount = totalSupply * 3 / 100;
420         maxSellAmount = totalSupply * 3 / 100;
421         maxWalletAmount = totalSupply * 3 / 100;
422         swapTokensAtAmount = totalSupply * 5 / 10000;
423 
424         buyOperationsFee = 20;
425         buyLiquidityFee = 0;
426         buyDevFee = 0;
427         buyBurnFee = 0;
428         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
429 
430         sellOperationsFee = 20;
431         sellLiquidityFee = 0;
432         sellDevFee = 0;
433         sellBurnFee = 0;
434         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
435 
436         _excludeFromMaxTransaction(newOwner, true);
437         _excludeFromMaxTransaction(address(this), true);
438         _excludeFromMaxTransaction(address(0xdead), true);
439 
440         excludeFromFees(newOwner, true);
441         excludeFromFees(address(this), true);
442         excludeFromFees(address(0xdead), true);
443 
444         operationsAddress = address(newOwner);
445         devAddress = address(newOwner);
446 
447         _createInitialSupply(newOwner, totalSupply);
448         transferOwnership(newOwner);
449     }
450 
451     receive() external payable {}
452 
453     // only enable if no plan to airdrop
454 
455     function enableTrading(uint256 deadBlocks) external onlyOwner {
456         require(!tradingActive, "Cannot reenable trading");
457         tradingActive = true;
458         swapEnabled = true;
459         tradingActiveBlock = block.number;
460         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
461         emit EnabledTrading();
462     }
463 
464     // remove limits after token is stable
465     function removeLimits() external onlyOwner {
466         limitsInEffect = false;
467         transferDelayEnabled = false;
468         emit RemovedLimits();
469     }
470 
471     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
472         boughtEarly[wallet] = flag;
473     }
474 
475     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
476         for(uint256 i = 0; i < wallets.length; i++){
477             boughtEarly[wallets[i]] = flag;
478         }
479     }
480 
481     // disable Transfer delay - cannot be reenabled
482     function disableTransferDelay() external onlyOwner {
483         transferDelayEnabled = false;
484     }
485 
486     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
487         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
488         maxBuyAmount = newNum * (10**18);
489         emit UpdatedMaxBuyAmount(maxBuyAmount);
490     }
491 
492     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
493         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
494         maxSellAmount = newNum * (10**18);
495         emit UpdatedMaxSellAmount(maxSellAmount);
496     }
497 
498     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
499         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
500         maxWalletAmount = newNum * (10**18);
501         emit UpdatedMaxWalletAmount(maxWalletAmount);
502     }
503 
504     // change the minimum amount of tokens to sell from fees
505     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
506   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
507   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
508   	    swapTokensAtAmount = newAmount;
509   	}
510 
511     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
512         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
513         emit MaxTransactionExclusion(updAds, isExcluded);
514     }
515 
516     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
517         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
518         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
519         for(uint256 i = 0; i < wallets.length; i++){
520             address wallet = wallets[i];
521             uint256 amount = amountsInTokens[i];
522             super._transfer(msg.sender, wallet, amount);
523         }
524     }
525 
526     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
527         if(!isEx){
528             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
529         }
530         _isExcludedMaxTransactionAmount[updAds] = isEx;
531     }
532 
533     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
534         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
535 
536         _setAutomatedMarketMakerPair(pair, value);
537         emit SetAutomatedMarketMakerPair(pair, value);
538     }
539 
540     function _setAutomatedMarketMakerPair(address pair, bool value) private {
541         automatedMarketMakerPairs[pair] = value;
542 
543         _excludeFromMaxTransaction(pair, value);
544 
545         emit SetAutomatedMarketMakerPair(pair, value);
546     }
547 
548     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
549         buyOperationsFee = _operationsFee;
550         buyLiquidityFee = _liquidityFee;
551         buyDevFee = _devFee;
552         buyBurnFee = _burnFee;
553         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
554         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
555     }
556 
557     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
558         sellOperationsFee = _operationsFee;
559         sellLiquidityFee = _liquidityFee;
560         sellDevFee = _devFee;
561         sellBurnFee = _burnFee;
562         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
563         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
564     }
565 
566     function returnToNormalTax() external onlyOwner {
567         sellOperationsFee = 0;
568         sellLiquidityFee = 0;
569         sellDevFee = 0;
570         sellBurnFee = 0;
571         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
572         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
573 
574         buyOperationsFee = 0;
575         buyLiquidityFee = 0;
576         buyDevFee = 0;
577         buyBurnFee = 0;
578         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
579         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
580     }
581 
582     function excludeFromFees(address account, bool excluded) public onlyOwner {
583         _isExcludedFromFees[account] = excluded;
584         emit ExcludeFromFees(account, excluded);
585     }
586 
587     function _transfer(address from, address to, uint256 amount) internal override {
588 
589         require(from != address(0), "ERC20: transfer from the zero address");
590         require(to != address(0), "ERC20: transfer to the zero address");
591         require(amount > 0, "amount must be greater than 0");
592 
593         if(!tradingActive){
594             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
595         }
596 
597         if(blockForPenaltyEnd > 0){
598             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
599         }
600 
601         if(limitsInEffect){
602             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
603 
604                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
605                 if (transferDelayEnabled){
606                     if (to != address(dexRouter) && to != address(lpPair)){
607                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
608                         _holderLastTransferTimestamp[tx.origin] = block.number;
609                         _holderLastTransferTimestamp[to] = block.number;
610                     }
611                 }
612     
613                 //when buy
614                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
615                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
616                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
617                 }
618                 //when sell
619                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
620                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
621                 }
622                 else if (!_isExcludedMaxTransactionAmount[to]){
623                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
624                 }
625             }
626         }
627 
628         uint256 contractTokenBalance = balanceOf(address(this));
629 
630         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
631 
632         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
633             swapping = true;
634 
635             swapBack();
636 
637             swapping = false;
638         }
639 
640         bool takeFee = true;
641         // if any account belongs to _isExcludedFromFee account then remove the fee
642         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
643             takeFee = false;
644         }
645 
646         uint256 fees = 0;
647         // only take fees on buys/sells, do not take on wallet transfers
648         if(takeFee){
649             // bot/sniper penalty.
650             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
651 
652                 if(!boughtEarly[to]){
653                     boughtEarly[to] = true;
654                     botsCaught += 1;
655                     emit CaughtEarlyBuyer(to);
656                 }
657 
658                 fees = amount * 99 / 100;
659         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
660                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
661                 tokensForDev += fees * buyDevFee / buyTotalFees;
662                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
663             }
664 
665             // on sell
666             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
667                 fees = amount * sellTotalFees / 100;
668                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
669                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
670                 tokensForDev += fees * sellDevFee / sellTotalFees;
671                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
672             }
673 
674             // on buy
675             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
676         	    fees = amount * buyTotalFees / 100;
677         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
678                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
679                 tokensForDev += fees * buyDevFee / buyTotalFees;
680                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
681             }
682 
683             if(fees > 0){
684                 super._transfer(from, address(this), fees);
685             }
686 
687         	amount -= fees;
688         }
689 
690         super._transfer(from, to, amount);
691     }
692 
693     function earlyBuyPenaltyInEffect() public view returns (bool){
694         return block.number < blockForPenaltyEnd;
695     }
696 
697     function swapTokensForEth(uint256 tokenAmount) private {
698 
699         // generate the uniswap pair path of token -> weth
700         address[] memory path = new address[](2);
701         path[0] = address(this);
702         path[1] = dexRouter.WETH();
703 
704         _approve(address(this), address(dexRouter), tokenAmount);
705 
706         // make the swap
707         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
708             tokenAmount,
709             0, // accept any amount of ETH
710             path,
711             address(this),
712             block.timestamp
713         );
714     }
715 
716     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
717         // approve token transfer to cover all possible scenarios
718         _approve(address(this), address(dexRouter), tokenAmount);
719 
720         // add the liquidity
721         dexRouter.addLiquidityETH{value: ethAmount}(
722             address(this),
723             tokenAmount,
724             0, // slippage is unavoidable
725             0, // slippage is unavoidable
726             address(0xdead),
727             block.timestamp
728         );
729     }
730 
731     function swapBack() private {
732 
733         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
734             _burn(address(this), tokensForBurn);
735         }
736         tokensForBurn = 0;
737 
738         uint256 contractBalance = balanceOf(address(this));
739         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
740 
741         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
742 
743         if(contractBalance > swapTokensAtAmount * 60){
744             contractBalance = swapTokensAtAmount * 60;
745         }
746 
747         bool success;
748 
749         // Halve the amount of liquidity tokens
750         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
751 
752         swapTokensForEth(contractBalance - liquidityTokens);
753 
754         uint256 ethBalance = address(this).balance;
755         uint256 ethForLiquidity = ethBalance;
756 
757         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
758         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
759 
760         ethForLiquidity -= ethForOperations + ethForDev;
761 
762         tokensForLiquidity = 0;
763         tokensForOperations = 0;
764         tokensForDev = 0;
765         tokensForBurn = 0;
766 
767         if(liquidityTokens > 0 && ethForLiquidity > 0){
768             addLiquidity(liquidityTokens, ethForLiquidity);
769         }
770 
771         (success,) = address(devAddress).call{value: ethForDev}("");
772 
773         (success,) = address(operationsAddress).call{value: address(this).balance}("");
774     }
775 
776     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
777         require(_token != address(0), "_token address cannot be 0");
778         require(_token != address(this), "Can't withdraw native tokens");
779         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
780         _sent = IERC20(_token).transfer(_to, _contractBalance);
781         emit TransferForeignToken(_token, _contractBalance);
782     }
783 
784     // withdraw ETH if stuck or someone sends to the address
785     function withdrawStuckETH() external onlyOwner {
786         bool success;
787         (success,) = address(msg.sender).call{value: address(this).balance}("");
788     }
789 
790     function setOperationsAddress(address _operationsAddress) external onlyOwner {
791         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
792         operationsAddress = payable(_operationsAddress);
793     }
794 
795     function setDevAddress(address _devAddress) external onlyOwner {
796         require(_devAddress != address(0), "_devAddress address cannot be 0");
797         devAddress = payable(_devAddress);
798     }
799 
800     // force Swap back if slippage issues.
801     function forceSwapBack() external onlyOwner {
802         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
803         swapping = true;
804         swapBack();
805         swapping = false;
806         emit OwnerForcedSwapBack(block.timestamp);
807     }
808 
809     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
810     function buyBackTokens(uint256 amountInWei) external onlyOwner {
811         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
812 
813         address[] memory path = new address[](2);
814         path[0] = dexRouter.WETH();
815         path[1] = address(this);
816 
817         // make the swap
818         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
819             0, // accept any amount of Ethereum
820             path,
821             address(0xdead),
822             block.timestamp
823         );
824         emit BuyBackTriggered(amountInWei);
825     }
826 }