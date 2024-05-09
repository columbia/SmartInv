1 /**
2 
3 Dracarys ($DRACO) is a new ERC-20 cryptocurrency inspired by dragons. Every transaction made with Dracarys will have 3% of it burned, and 3% will be added to the liquidity pool. This will help to keep the currency stable, as well as help to grow the liquidity pool over time.
4 
5 No dev or mkt taxes!
6 
7 3% BURNED | 3% ADDED TO LIQUIDITY | 5B TOKENS | LIQUIDITY BURNED
8 
9 https://dracarys.wtf
10 
11 https://t.me/dracaryserc
12 
13 https://twitter.com/TokenDracarys
14 
15 */
16 
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
318 contract Dracarys is ERC20, Ownable {
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
405     constructor() ERC20("Dracarys", "DRACO") {
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
417         uint256 totalSupply = 5 * 1e12 * 1e18;
418 
419         maxBuyAmount = totalSupply * 2 / 100;
420         maxSellAmount = totalSupply * 1 / 100;
421         maxWalletAmount = totalSupply * 2 / 100;
422         swapTokensAtAmount = totalSupply * 5 / 10000;
423 
424         buyOperationsFee = 0;
425         buyLiquidityFee = 3;
426         buyDevFee = 0;
427         buyBurnFee = 3;
428         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
429 
430         sellOperationsFee = 0;
431         sellLiquidityFee = 3;
432         sellDevFee = 0;
433         sellBurnFee = 3;
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
455     function enableTrading() external onlyOwner {
456         require(!tradingActive, "Cannot reenable trading");
457         tradingActive = true;
458         swapEnabled = true;
459         tradingActiveBlock = block.number;
460         blockForPenaltyEnd = tradingActiveBlock + 1;
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
471     function removeBoughtEarly(address wallet) external onlyOwner {
472         require(boughtEarly[wallet], "Wallet is already not flagged.");
473         boughtEarly[wallet] = false;
474     }
475 
476     // disable Transfer delay - cannot be reenabled
477     function disableTransferDelay() external onlyOwner {
478         transferDelayEnabled = false;
479     }
480 
481     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
482         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
483         maxBuyAmount = newNum * (10**18);
484         emit UpdatedMaxBuyAmount(maxBuyAmount);
485     }
486 
487     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
488         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
489         maxSellAmount = newNum * (10**18);
490         emit UpdatedMaxSellAmount(maxSellAmount);
491     }
492 
493     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
494         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
495         maxWalletAmount = newNum * (10**18);
496         emit UpdatedMaxWalletAmount(maxWalletAmount);
497     }
498 
499     // change the minimum amount of tokens to sell from fees
500     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
501   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
502   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
503   	    swapTokensAtAmount = newAmount;
504   	}
505 
506     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
507         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
508         emit MaxTransactionExclusion(updAds, isExcluded);
509     }
510 
511     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
512         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
513         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
514         for(uint256 i = 0; i < wallets.length; i++){
515             address wallet = wallets[i];
516             uint256 amount = amountsInTokens[i];
517             super._transfer(msg.sender, wallet, amount);
518         }
519     }
520 
521     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
522         if(!isEx){
523             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
524         }
525         _isExcludedMaxTransactionAmount[updAds] = isEx;
526     }
527 
528     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
529         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
530 
531         _setAutomatedMarketMakerPair(pair, value);
532         emit SetAutomatedMarketMakerPair(pair, value);
533     }
534 
535     function _setAutomatedMarketMakerPair(address pair, bool value) private {
536         automatedMarketMakerPairs[pair] = value;
537 
538         _excludeFromMaxTransaction(pair, value);
539 
540         emit SetAutomatedMarketMakerPair(pair, value);
541     }
542 
543     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
544         buyOperationsFee = _operationsFee;
545         buyLiquidityFee = _liquidityFee;
546         buyDevFee = _devFee;
547         buyBurnFee = _burnFee;
548         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
549         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
550     }
551 
552     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
553         sellOperationsFee = _operationsFee;
554         sellLiquidityFee = _liquidityFee;
555         sellDevFee = _devFee;
556         sellBurnFee = _burnFee;
557         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
558         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
559     }
560 
561     function returnToNormalTax() external onlyOwner {
562         sellOperationsFee = 0;
563         sellLiquidityFee = 3;
564         sellDevFee = 0;
565         sellBurnFee = 3;
566         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
567         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
568 
569         buyOperationsFee = 0;
570         buyLiquidityFee = 3;
571         buyDevFee = 0;
572         buyBurnFee = 3;
573         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
574         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
575     }
576 
577     function excludeFromFees(address account, bool excluded) public onlyOwner {
578         _isExcludedFromFees[account] = excluded;
579         emit ExcludeFromFees(account, excluded);
580     }
581 
582     function _transfer(address from, address to, uint256 amount) internal override {
583 
584         require(from != address(0), "ERC20: transfer from the zero address");
585         require(to != address(0), "ERC20: transfer to the zero address");
586         require(amount > 0, "amount must be greater than 0");
587 
588         if(!tradingActive){
589             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
590         }
591 
592         if(!earlyBuyPenaltyInEffect() && blockForPenaltyEnd > 0){
593             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
594         }
595 
596         if(limitsInEffect){
597             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
598 
599                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
600                 if (transferDelayEnabled){
601                     if (to != address(dexRouter) && to != address(lpPair)){
602                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
603                         _holderLastTransferTimestamp[tx.origin] = block.number;
604                         _holderLastTransferTimestamp[to] = block.number;
605                     }
606                 }
607 
608                 //when buy
609                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
610                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
611                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
612                 }
613                 //when sell
614                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
615                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
616                 }
617                 else if (!_isExcludedMaxTransactionAmount[to]){
618                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
619                 }
620             }
621         }
622 
623         uint256 contractTokenBalance = balanceOf(address(this));
624 
625         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
626 
627         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
628             swapping = true;
629 
630             swapBack();
631 
632             swapping = false;
633         }
634 
635         bool takeFee = true;
636         // if any account belongs to _isExcludedFromFee account then remove the fee
637         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
638             takeFee = false;
639         }
640 
641         uint256 fees = 0;
642         // only take fees on buys/sells, do not take on wallet transfers
643         if(takeFee){
644             // bot/sniper penalty.
645             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
646 
647                 if(!boughtEarly[to]){
648                     boughtEarly[to] = true;
649                     botsCaught += 1;
650                     emit CaughtEarlyBuyer(to);
651                 }
652 
653                 fees = amount * buyTotalFees / 100;
654         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
655                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
656                 tokensForDev += fees * buyDevFee / buyTotalFees;
657                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
658             }
659 
660             // on sell
661             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
662                 fees = amount * sellTotalFees / 100;
663                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
664                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
665                 tokensForDev += fees * sellDevFee / sellTotalFees;
666                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
667             }
668 
669             // on buy
670             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
671         	    fees = amount * buyTotalFees / 100;
672         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
673                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
674                 tokensForDev += fees * buyDevFee / buyTotalFees;
675                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
676             }
677 
678             if(fees > 0){
679                 super._transfer(from, address(this), fees);
680             }
681 
682         	amount -= fees;
683         }
684 
685         super._transfer(from, to, amount);
686     }
687 
688     function earlyBuyPenaltyInEffect() public view returns (bool){
689         return block.number < blockForPenaltyEnd;
690     }
691 
692     function swapTokensForEth(uint256 tokenAmount) private {
693 
694         // generate the uniswap pair path of token -> weth
695         address[] memory path = new address[](2);
696         path[0] = address(this);
697         path[1] = dexRouter.WETH();
698 
699         _approve(address(this), address(dexRouter), tokenAmount);
700 
701         // make the swap
702         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
703             tokenAmount,
704             0, // accept any amount of ETH
705             path,
706             address(this),
707             block.timestamp
708         );
709     }
710 
711     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
712         // approve token transfer to cover all possible scenarios
713         _approve(address(this), address(dexRouter), tokenAmount);
714 
715         // add the liquidity
716         dexRouter.addLiquidityETH{value: ethAmount}(
717             address(this),
718             tokenAmount,
719             0, // slippage is unavoidable
720             0, // slippage is unavoidable
721             address(0xdead),
722             block.timestamp
723         );
724     }
725 
726     function swapBack() private {
727 
728         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
729             super._transfer(address(this), address(0xdead), tokensForBurn);
730         }
731         tokensForBurn = 0;
732 
733         uint256 contractBalance = balanceOf(address(this));
734         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
735 
736         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
737 
738         if(contractBalance > swapTokensAtAmount * 20){
739             contractBalance = swapTokensAtAmount * 20;
740         }
741 
742         bool success;
743 
744         // Halve the amount of liquidity tokens
745         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
746 
747         swapTokensForEth(contractBalance - liquidityTokens);
748 
749         uint256 ethBalance = address(this).balance;
750         uint256 ethForLiquidity = ethBalance;
751 
752         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
753         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
754 
755         ethForLiquidity -= ethForOperations + ethForDev;
756 
757         tokensForLiquidity = 0;
758         tokensForOperations = 0;
759         tokensForDev = 0;
760         tokensForBurn = 0;
761 
762         if(liquidityTokens > 0 && ethForLiquidity > 0){
763             addLiquidity(liquidityTokens, ethForLiquidity);
764         }
765 
766         (success,) = address(devAddress).call{value: ethForDev}("");
767 
768         (success,) = address(operationsAddress).call{value: address(this).balance}("");
769     }
770 
771     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
772         require(_token != address(0), "_token address cannot be 0");
773         require(_token != address(this), "Can't withdraw native tokens");
774         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
775         _sent = IERC20(_token).transfer(_to, _contractBalance);
776         emit TransferForeignToken(_token, _contractBalance);
777     }
778 
779     // withdraw ETH if stuck or someone sends to the address
780     function withdrawStuckETH() external onlyOwner {
781         bool success;
782         (success,) = address(msg.sender).call{value: address(this).balance}("");
783     }
784 
785     function setOperationsAddress(address _operationsAddress) external onlyOwner {
786         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
787         operationsAddress = payable(_operationsAddress);
788     }
789 
790     function setDevAddress(address _devAddress) external onlyOwner {
791         require(_devAddress != address(0), "_devAddress address cannot be 0");
792         devAddress = payable(_devAddress);
793     }
794 
795     // force Swap back if slippage issues.
796     function forceSwapBack() external onlyOwner {
797         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
798         swapping = true;
799         swapBack();
800         swapping = false;
801         emit OwnerForcedSwapBack(block.timestamp);
802     }
803 
804     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
805     function buyBackTokens(uint256 amountInWei) external onlyOwner {
806         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
807 
808         address[] memory path = new address[](2);
809         path[0] = dexRouter.WETH();
810         path[1] = address(this);
811 
812         // make the swap
813         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
814             0, // accept any amount of Ethereum
815             path,
816             address(0xdead),
817             block.timestamp
818         );
819         emit BuyBackTriggered(amountInWei);
820     }
821 }