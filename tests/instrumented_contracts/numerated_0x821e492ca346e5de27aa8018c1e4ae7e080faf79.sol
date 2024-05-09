1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.15;
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
132         return 9;
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
162         _transfer(sender, recipient, amount);
163 
164         uint256 currentAllowance = _allowances[sender][_msgSender()];
165         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
166         unchecked {
167             _approve(sender, _msgSender(), currentAllowance - amount);
168         }
169 
170         return true;
171     }
172 
173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
175         return true;
176     }
177 
178     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
179         uint256 currentAllowance = _allowances[_msgSender()][spender];
180         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
181         unchecked {
182             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
183         }
184 
185         return true;
186     }
187 
188     function _transfer(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) internal virtual {
193         require(sender != address(0), "ERC20: transfer from the zero address");
194         require(recipient != address(0), "ERC20: transfer to the zero address");
195 
196         uint256 senderBalance = _balances[sender];
197         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
198         unchecked {
199             _balances[sender] = senderBalance - amount;
200         }
201         _balances[recipient] += amount;
202 
203         emit Transfer(sender, recipient, amount);
204     }
205 
206     function _createInitialSupply(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _totalSupply += amount;
210         _balances[account] += amount;
211         emit Transfer(address(0), account, amount);
212     }
213 
214     function _burn(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: burn from the zero address");
216         uint256 accountBalance = _balances[account];
217         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
218         unchecked {
219             _balances[account] = accountBalance - amount;
220             // Overflow not possible: amount <= accountBalance <= totalSupply.
221             _totalSupply -= amount;
222         }
223 
224         emit Transfer(account, address(0), amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234 
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 }
239 
240 contract Ownable is Context {
241     address private _owner;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245     constructor () {
246         address msgSender = _msgSender();
247         _owner = msgSender;
248         emit OwnershipTransferred(address(0), msgSender);
249     }
250 
251     function owner() public view returns (address) {
252         return _owner;
253     }
254 
255     modifier onlyOwner() {
256         require(_owner == _msgSender(), "Ownable: caller is not the owner");
257         _;
258     }
259 
260     function renounceOwnership() external virtual onlyOwner {
261         emit OwnershipTransferred(_owner, address(0));
262         _owner = address(0);
263     }
264 
265     function transferOwnership(address newOwner) public virtual onlyOwner {
266         require(newOwner != address(0), "Ownable: new owner is the zero address");
267         emit OwnershipTransferred(_owner, newOwner);
268         _owner = newOwner;
269     }
270 }
271 
272 interface IDexRouter {
273     function factory() external pure returns (address);
274     function WETH() external pure returns (address);
275 
276     function swapExactTokensForETHSupportingFeeOnTransferTokens(
277         uint amountIn,
278         uint amountOutMin,
279         address[] calldata path,
280         address to,
281         uint deadline
282     ) external;
283 
284     function swapExactETHForTokensSupportingFeeOnTransferTokens(
285         uint amountOutMin,
286         address[] calldata path,
287         address to,
288         uint deadline
289     ) external payable;
290 
291     function addLiquidityETH(
292         address token,
293         uint256 amountTokenDesired,
294         uint256 amountTokenMin,
295         uint256 amountETHMin,
296         address to,
297         uint256 deadline
298     )
299         external
300         payable
301         returns (
302             uint256 amountToken,
303             uint256 amountETH,
304             uint256 liquidity
305         );
306 }
307 
308 interface IDexFactory {
309     function createPair(address tokenA, address tokenB)
310         external
311         returns (address pair);
312 }
313 
314 contract PsyopInu is ERC20, Ownable {
315 
316     uint256 public maxBuyAmount;
317     uint256 public maxSellAmount;
318     uint256 public maxWalletAmount;
319 
320     IDexRouter public dexRouter;
321     address public lpPair;
322 
323     bool private swapping;
324     uint256 public swapTokensAtAmount;
325 
326     address operationsAddress;
327     address devAddress;
328 
329     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
330     uint256 public blockForPenaltyEnd;
331     mapping (address => bool) public boughtEarly;
332     uint256 public botsCaught;
333 
334     bool public limitsInEffect = true;
335     bool public tradingActive = false;
336     bool public swapEnabled = false;
337 
338      // Anti-bot and anti-whale mappings and variables
339     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
340     bool public transferDelayEnabled = true;
341 
342     uint256 public buyTotalFees;
343     uint256 public buyOperationsFee;
344     uint256 public buyLiquidityFee;
345     uint256 public buyDevFee;
346     uint256 public buyBurnFee;
347 
348     uint256 public sellTotalFees;
349     uint256 public sellOperationsFee;
350     uint256 public sellLiquidityFee;
351     uint256 public sellDevFee;
352     uint256 public sellBurnFee;
353 
354     uint256 public tokensForOperations;
355     uint256 public tokensForLiquidity;
356     uint256 public tokensForDev;
357     uint256 public tokensForBurn;
358 
359     /******************/
360 
361     // exlcude from fees and max transaction amount
362     mapping (address => bool) private _isExcludedFromFees;
363     mapping (address => bool) public _isExcludedMaxTransactionAmount;
364 
365     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
366     // could be subject to a maximum transfer amount
367     mapping (address => bool) public automatedMarketMakerPairs;
368 
369     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
370 
371     event EnabledTrading();
372 
373     event RemovedLimits();
374 
375     event ExcludeFromFees(address indexed account, bool isExcluded);
376 
377     event UpdatedMaxBuyAmount(uint256 newAmount);
378 
379     event UpdatedMaxSellAmount(uint256 newAmount);
380 
381     event UpdatedMaxWalletAmount(uint256 newAmount);
382 
383     event UpdatedOperationsAddress(address indexed newWallet);
384 
385     event MaxTransactionExclusion(address _address, bool excluded);
386 
387     event BuyBackTriggered(uint256 amount);
388 
389     event OwnerForcedSwapBack(uint256 timestamp);
390 
391     event CaughtEarlyBuyer(address sniper);
392 
393     event SwapAndLiquify(
394         uint256 tokensSwapped,
395         uint256 ethReceived,
396         uint256 tokensIntoLiquidity
397     );
398 
399     event TransferForeignToken(address token, uint256 amount);
400 
401     constructor() ERC20("PsyopInu", "PSYINU") {
402 
403         address newOwner = msg.sender; // can leave alone if owner is deployer.
404 
405         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
406         dexRouter = _dexRouter;
407 
408         // create pair
409         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
410         _excludeFromMaxTransaction(address(lpPair), true);
411         _setAutomatedMarketMakerPair(address(lpPair), true);
412 
413         uint256 totalSupply = 210689999999999 * 1e9;
414 
415         maxBuyAmount = totalSupply * 5 / 1000;
416         maxSellAmount = totalSupply * 5 / 1000;
417         maxWalletAmount = totalSupply * 5 / 1000;
418         swapTokensAtAmount = totalSupply * 3 / 1000;
419 
420         buyOperationsFee = 3;
421         buyLiquidityFee = 0;
422         buyDevFee = 0;
423         buyBurnFee = 0;
424         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
425 
426         sellOperationsFee = 3;
427         sellLiquidityFee = 0;
428         sellDevFee = 0;
429         sellBurnFee = 0;
430         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
431 
432         _excludeFromMaxTransaction(newOwner, true);
433         _excludeFromMaxTransaction(address(this), true);
434         _excludeFromMaxTransaction(address(0xdead), true);
435 
436         excludeFromFees(newOwner, true);
437         excludeFromFees(address(this), true);
438         excludeFromFees(address(0xdead), true);
439 
440         operationsAddress = address(newOwner);
441         devAddress = address(newOwner);
442 
443         _createInitialSupply(newOwner, totalSupply);
444         transferOwnership(newOwner);
445     }
446 
447     receive() external payable {}
448 
449     // only enable if no plan to airdrop
450 
451     function enableTrading(uint256 deadBlocks) external onlyOwner {
452         require(!tradingActive, "Cannot reenable trading");
453         tradingActive = true;
454         swapEnabled = true;
455         tradingActiveBlock = block.number;
456         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
457         emit EnabledTrading();
458     }
459 
460     // remove limits after token is stable
461     function removeLimits() external onlyOwner {
462         limitsInEffect = false;
463         transferDelayEnabled = false;
464         emit RemovedLimits();
465     }
466 
467     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
468         boughtEarly[wallet] = flag;
469     }
470 
471     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
472         for(uint256 i = 0; i < wallets.length; i++){
473             boughtEarly[wallets[i]] = flag;
474         }
475     }
476 
477     // disable Transfer delay - cannot be reenabled
478     function disableTransferDelay() external onlyOwner {
479         transferDelayEnabled = false;
480     }
481 
482     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
483         require(newNum >= (totalSupply() * 2 / 1000)/1e9, "Cannot set max buy amount lower than 0.2%");
484         maxBuyAmount = newNum * (10**9);
485         emit UpdatedMaxBuyAmount(maxBuyAmount);
486     }
487 
488     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
489         require(newNum >= (totalSupply() * 2 / 1000)/1e9, "Cannot set max sell amount lower than 0.2%");
490         maxSellAmount = newNum * (10**9);
491         emit UpdatedMaxSellAmount(maxSellAmount);
492     }
493 
494     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
495         require(newNum >= (totalSupply() * 3 / 1000)/1e9, "Cannot set max wallet amount lower than 0.3%");
496         maxWalletAmount = newNum * (10**9);
497         emit UpdatedMaxWalletAmount(maxWalletAmount);
498     }
499 
500     // change the minimum amount of tokens to sell from fees
501     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
502   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
503   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
504   	    swapTokensAtAmount = newAmount;
505   	}
506 
507     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
508         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
509         emit MaxTransactionExclusion(updAds, isExcluded);
510     }
511 
512     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
513         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
514         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
515         for(uint256 i = 0; i < wallets.length; i++){
516             address wallet = wallets[i];
517             uint256 amount = amountsInTokens[i];
518             super._transfer(msg.sender, wallet, amount);
519         }
520     }
521 
522     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
523         if(!isEx){
524             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
525         }
526         _isExcludedMaxTransactionAmount[updAds] = isEx;
527     }
528 
529     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
530         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
531 
532         _setAutomatedMarketMakerPair(pair, value);
533         emit SetAutomatedMarketMakerPair(pair, value);
534     }
535 
536     function _setAutomatedMarketMakerPair(address pair, bool value) private {
537         automatedMarketMakerPairs[pair] = value;
538 
539         _excludeFromMaxTransaction(pair, value);
540 
541         emit SetAutomatedMarketMakerPair(pair, value);
542     }
543 
544     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
545         buyOperationsFee = _operationsFee;
546         buyLiquidityFee = _liquidityFee;
547         buyDevFee = _devFee;
548         buyBurnFee = _burnFee;
549         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
550         require(buyTotalFees <= 20, "Must keep fees at 10% or less");
551     }
552 
553     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
554         sellOperationsFee = _operationsFee;
555         sellLiquidityFee = _liquidityFee;
556         sellDevFee = _devFee;
557         sellBurnFee = _burnFee;
558         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
559         require(sellTotalFees <= 20, "Must keep fees at 10% or less");
560     }
561 
562     function returnToNormalTax() external onlyOwner {
563         sellOperationsFee = 0;
564         sellLiquidityFee = 0;
565         sellDevFee = 0;
566         sellBurnFee = 0;
567         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
568         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
569 
570         buyOperationsFee = 0;
571         buyLiquidityFee = 0;
572         buyDevFee = 0;
573         buyBurnFee = 0;
574         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
575         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
576     }
577 
578     function excludeFromFees(address account, bool excluded) public onlyOwner {
579         _isExcludedFromFees[account] = excluded;
580         emit ExcludeFromFees(account, excluded);
581     }
582 
583     function _transfer(address from, address to, uint256 amount) internal override {
584 
585         require(from != address(0), "ERC20: transfer from the zero address");
586         require(to != address(0), "ERC20: transfer to the zero address");
587         require(amount > 0, "amount must be greater than 0");
588 
589         if(!tradingActive){
590             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
591         }
592 
593         if(blockForPenaltyEnd > 0){
594             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
595         }
596 
597         if(limitsInEffect){
598             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
599 
600                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
601                 if (transferDelayEnabled){
602                     if (to != address(dexRouter) && to != address(lpPair)){
603                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
604                         _holderLastTransferTimestamp[tx.origin] = block.number;
605                         _holderLastTransferTimestamp[to] = block.number;
606                     }
607                 }
608     
609                 //when buy
610                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
611                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
612                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
613                 }
614                 //when sell
615                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
616                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
617                 }
618                 else if (!_isExcludedMaxTransactionAmount[to]){
619                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
620                 }
621             }
622         }
623 
624         uint256 contractTokenBalance = balanceOf(address(this));
625 
626         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
627 
628         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
629             swapping = true;
630 
631             swapBack();
632 
633             swapping = false;
634         }
635 
636         bool takeFee = true;
637         // if any account belongs to _isExcludedFromFee account then remove the fee
638         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
639             takeFee = false;
640         }
641 
642         uint256 fees = 0;
643         // only take fees on buys/sells, do not take on wallet transfers
644         if(takeFee){
645             // bot/sniper penalty.
646             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
647 
648                 if(!boughtEarly[to]){
649                     boughtEarly[to] = true;
650                     botsCaught += 1;
651                     emit CaughtEarlyBuyer(to);
652                 }
653 
654                 fees = amount * 99 / 100;
655         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
656                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
657                 tokensForDev += fees * buyDevFee / buyTotalFees;
658                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
659             }
660 
661             // on sell
662             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
663                 fees = amount * sellTotalFees / 100;
664                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
665                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
666                 tokensForDev += fees * sellDevFee / sellTotalFees;
667                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
668             }
669 
670             // on buy
671             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
672         	    fees = amount * buyTotalFees / 100;
673         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
674                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
675                 tokensForDev += fees * buyDevFee / buyTotalFees;
676                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
677             }
678 
679             if(fees > 0){
680                 super._transfer(from, address(this), fees);
681             }
682 
683         	amount -= fees;
684         }
685 
686         super._transfer(from, to, amount);
687     }
688 
689     function earlyBuyPenaltyInEffect() public view returns (bool){
690         return block.number < blockForPenaltyEnd;
691     }
692 
693     function swapTokensForEth(uint256 tokenAmount) private {
694 
695         // generate the uniswap pair path of token -> weth
696         address[] memory path = new address[](2);
697         path[0] = address(this);
698         path[1] = dexRouter.WETH();
699 
700         _approve(address(this), address(dexRouter), tokenAmount);
701 
702         // make the swap
703         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
704             tokenAmount,
705             0, // accept any amount of ETH
706             path,
707             address(this),
708             block.timestamp
709         );
710     }
711 
712     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
713         // approve token transfer to cover all possible scenarios
714         _approve(address(this), address(dexRouter), tokenAmount);
715 
716         // add the liquidity
717         dexRouter.addLiquidityETH{value: ethAmount}(
718             address(this),
719             tokenAmount,
720             0, // slippage is unavoidable
721             0, // slippage is unavoidable
722             address(0xdead),
723             block.timestamp
724         );
725     }
726 
727     function swapBack() private {
728 
729         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
730             _burn(address(this), tokensForBurn);
731         }
732         tokensForBurn = 0;
733 
734         uint256 contractBalance = balanceOf(address(this));
735         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
736 
737         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
738 
739         if(contractBalance > swapTokensAtAmount * 60){
740             contractBalance = swapTokensAtAmount * 60;
741         }
742 
743         bool success;
744 
745         // Halve the amount of liquidity tokens
746         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
747 
748         swapTokensForEth(contractBalance - liquidityTokens);
749 
750         uint256 ethBalance = address(this).balance;
751         uint256 ethForLiquidity = ethBalance;
752 
753         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
754         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
755 
756         ethForLiquidity -= ethForOperations + ethForDev;
757 
758         tokensForLiquidity = 0;
759         tokensForOperations = 0;
760         tokensForDev = 0;
761         tokensForBurn = 0;
762 
763         if(liquidityTokens > 0 && ethForLiquidity > 0){
764             addLiquidity(liquidityTokens, ethForLiquidity);
765         }
766 
767         (success,) = address(devAddress).call{value: ethForDev}("");
768 
769         (success,) = address(operationsAddress).call{value: address(this).balance}("");
770     }
771 
772     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
773         require(_token != address(0), "_token address cannot be 0");
774         require(_token != address(this), "Can't withdraw native tokens");
775         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
776         _sent = IERC20(_token).transfer(_to, _contractBalance);
777         emit TransferForeignToken(_token, _contractBalance);
778     }
779 
780     // withdraw ETH if stuck or someone sends to the address
781     function withdrawStuckETH() external onlyOwner {
782         bool success;
783         (success,) = address(msg.sender).call{value: address(this).balance}("");
784     }
785 
786     function setOperationsAddress(address _operationsAddress) external onlyOwner {
787         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
788         operationsAddress = payable(_operationsAddress);
789     }
790 
791     function setDevAddress(address _devAddress) external onlyOwner {
792         require(_devAddress != address(0), "_devAddress address cannot be 0");
793         devAddress = payable(_devAddress);
794     }
795 
796     // force Swap back if slippage issues.
797     function forceSwapBack() external onlyOwner {
798         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
799         swapping = true;
800         swapBack();
801         swapping = false;
802         emit OwnerForcedSwapBack(block.timestamp);
803     }
804 
805     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
806     function buyBackTokens(uint256 amountInWei) external onlyOwner {
807         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
808 
809         address[] memory path = new address[](2);
810         path[0] = dexRouter.WETH();
811         path[1] = address(this);
812 
813         // make the swap
814         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
815             0, // accept any amount of Ethereum
816             path,
817             address(0xdead),
818             block.timestamp
819         );
820         emit BuyBackTriggered(amountInWei);
821     }
822 }