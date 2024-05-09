1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 MUCH PUMP!
6 
7 https://hexdoge.xyz
8 
9 https://twitter.com/hexdogetoken
10 
11 https://t.me/hexdogetoken
12 
13 */
14 
15 pragma solidity 0.8.15;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 interface IERC20Metadata is IERC20 {
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() external view returns (string memory);
108 
109     /**
110      * @dev Returns the symbol of the token.
111      */
112     function symbol() external view returns (string memory);
113 
114     /**
115      * @dev Returns the decimals places of the token.
116      */
117     function decimals() external view returns (uint8);
118 }
119 
120 contract ERC20 is Context, IERC20, IERC20Metadata {
121     mapping(address => uint256) private _balances;
122 
123     mapping(address => mapping(address => uint256)) private _allowances;
124 
125     uint256 private _totalSupply;
126 
127     string private _name;
128     string private _symbol;
129 
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138 
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150 
151     function balanceOf(address account) public view virtual override returns (uint256) {
152         return _balances[account];
153     }
154 
155     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
156         _transfer(_msgSender(), recipient, amount);
157         return true;
158     }
159 
160     function allowance(address owner, address spender) public view virtual override returns (uint256) {
161         return _allowances[owner][spender];
162     }
163 
164     function approve(address spender, uint256 amount) public virtual override returns (bool) {
165         _approve(_msgSender(), spender, amount);
166         return true;
167     }
168 
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) public virtual override returns (bool) {
174         _transfer(sender, recipient, amount);
175 
176         uint256 currentAllowance = _allowances[sender][_msgSender()];
177         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
178         unchecked {
179             _approve(sender, _msgSender(), currentAllowance - amount);
180         }
181 
182         return true;
183     }
184 
185     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
187         return true;
188     }
189 
190     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
191         uint256 currentAllowance = _allowances[_msgSender()][spender];
192         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
193         unchecked {
194             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
195         }
196 
197         return true;
198     }
199 
200     function _transfer(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) internal virtual {
205         require(sender != address(0), "ERC20: transfer from the zero address");
206         require(recipient != address(0), "ERC20: transfer to the zero address");
207 
208         uint256 senderBalance = _balances[sender];
209         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
210         unchecked {
211             _balances[sender] = senderBalance - amount;
212         }
213         _balances[recipient] += amount;
214 
215         emit Transfer(sender, recipient, amount);
216     }
217 
218     function _createInitialSupply(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: mint to the zero address");
220 
221         _totalSupply += amount;
222         _balances[account] += amount;
223         emit Transfer(address(0), account, amount);
224     }
225 
226     function _burn(address account, uint256 amount) internal virtual {
227         require(account != address(0), "ERC20: burn from the zero address");
228         uint256 accountBalance = _balances[account];
229         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
230         unchecked {
231             _balances[account] = accountBalance - amount;
232             // Overflow not possible: amount <= accountBalance <= totalSupply.
233             _totalSupply -= amount;
234         }
235 
236         emit Transfer(account, address(0), amount);
237     }
238 
239     function _approve(
240         address owner,
241         address spender,
242         uint256 amount
243     ) internal virtual {
244         require(owner != address(0), "ERC20: approve from the zero address");
245         require(spender != address(0), "ERC20: approve to the zero address");
246 
247         _allowances[owner][spender] = amount;
248         emit Approval(owner, spender, amount);
249     }
250 }
251 
252 contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     constructor () {
258         address msgSender = _msgSender();
259         _owner = msgSender;
260         emit OwnershipTransferred(address(0), msgSender);
261     }
262 
263     function owner() public view returns (address) {
264         return _owner;
265     }
266 
267     modifier onlyOwner() {
268         require(_owner == _msgSender(), "Ownable: caller is not the owner");
269         _;
270     }
271 
272     function renounceOwnership() external virtual onlyOwner {
273         emit OwnershipTransferred(_owner, address(0));
274         _owner = address(0);
275     }
276 
277     function transferOwnership(address newOwner) public virtual onlyOwner {
278         require(newOwner != address(0), "Ownable: new owner is the zero address");
279         emit OwnershipTransferred(_owner, newOwner);
280         _owner = newOwner;
281     }
282 }
283 
284 interface IDexRouter {
285     function factory() external pure returns (address);
286     function WETH() external pure returns (address);
287 
288     function swapExactTokensForETHSupportingFeeOnTransferTokens(
289         uint amountIn,
290         uint amountOutMin,
291         address[] calldata path,
292         address to,
293         uint deadline
294     ) external;
295 
296     function swapExactETHForTokensSupportingFeeOnTransferTokens(
297         uint amountOutMin,
298         address[] calldata path,
299         address to,
300         uint deadline
301     ) external payable;
302 
303     function addLiquidityETH(
304         address token,
305         uint256 amountTokenDesired,
306         uint256 amountTokenMin,
307         uint256 amountETHMin,
308         address to,
309         uint256 deadline
310     )
311         external
312         payable
313         returns (
314             uint256 amountToken,
315             uint256 amountETH,
316             uint256 liquidity
317         );
318 }
319 
320 interface IDexFactory {
321     function createPair(address tokenA, address tokenB)
322         external
323         returns (address pair);
324 }
325 
326 contract HexDoge is ERC20, Ownable {
327 
328     uint256 public maxBuyAmount;
329     uint256 public maxSellAmount;
330     uint256 public maxWalletAmount;
331 
332     IDexRouter public dexRouter;
333     address public lpPair;
334 
335     bool private swapping;
336     uint256 public swapTokensAtAmount;
337 
338     address operationsAddress;
339     address devAddress;
340 
341     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
342     uint256 public blockForPenaltyEnd;
343     mapping (address => bool) public boughtEarly;
344     uint256 public botsCaught;
345 
346     bool public limitsInEffect = true;
347     bool public tradingActive = false;
348     bool public swapEnabled = false;
349 
350      // Anti-bot and anti-whale mappings and variables
351     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
352     bool public transferDelayEnabled = true;
353 
354     uint256 public buyTotalFees;
355     uint256 public buyOperationsFee;
356     uint256 public buyLiquidityFee;
357     uint256 public buyDevFee;
358     uint256 public buyBurnFee;
359 
360     uint256 public sellTotalFees;
361     uint256 public sellOperationsFee;
362     uint256 public sellLiquidityFee;
363     uint256 public sellDevFee;
364     uint256 public sellBurnFee;
365 
366     uint256 public tokensForOperations;
367     uint256 public tokensForLiquidity;
368     uint256 public tokensForDev;
369     uint256 public tokensForBurn;
370 
371     /******************/
372 
373     // exlcude from fees and max transaction amount
374     mapping (address => bool) private _isExcludedFromFees;
375     mapping (address => bool) public _isExcludedMaxTransactionAmount;
376 
377     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
378     // could be subject to a maximum transfer amount
379     mapping (address => bool) public automatedMarketMakerPairs;
380 
381     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
382 
383     event EnabledTrading();
384 
385     event RemovedLimits();
386 
387     event ExcludeFromFees(address indexed account, bool isExcluded);
388 
389     event UpdatedMaxBuyAmount(uint256 newAmount);
390 
391     event UpdatedMaxSellAmount(uint256 newAmount);
392 
393     event UpdatedMaxWalletAmount(uint256 newAmount);
394 
395     event UpdatedOperationsAddress(address indexed newWallet);
396 
397     event MaxTransactionExclusion(address _address, bool excluded);
398 
399     event BuyBackTriggered(uint256 amount);
400 
401     event OwnerForcedSwapBack(uint256 timestamp);
402 
403     event CaughtEarlyBuyer(address sniper);
404 
405     event SwapAndLiquify(
406         uint256 tokensSwapped,
407         uint256 ethReceived,
408         uint256 tokensIntoLiquidity
409     );
410 
411     event TransferForeignToken(address token, uint256 amount);
412 
413     constructor() ERC20("Hex Doge", "HEXDOGE") {
414 
415         address newOwner = msg.sender; // can leave alone if owner is deployer.
416 
417         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
418         dexRouter = _dexRouter;
419 
420         // create pair
421         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
422         _excludeFromMaxTransaction(address(lpPair), true);
423         _setAutomatedMarketMakerPair(address(lpPair), true);
424 
425         uint256 totalSupply = 5 * 1e12 * 1e18;
426 
427         maxBuyAmount = totalSupply * 2 / 100;
428         maxSellAmount = totalSupply * 1 / 100;
429         maxWalletAmount = totalSupply * 2 / 100;
430         swapTokensAtAmount = totalSupply * 5 / 10000;
431 
432         buyOperationsFee = 6;
433         buyLiquidityFee = 1;
434         buyDevFee = 0;
435         buyBurnFee = 0;
436         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
437 
438         sellOperationsFee = 6;
439         sellLiquidityFee = 1;
440         sellDevFee = 0;
441         sellBurnFee = 0;
442         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
443 
444         _excludeFromMaxTransaction(newOwner, true);
445         _excludeFromMaxTransaction(address(this), true);
446         _excludeFromMaxTransaction(address(0xdead), true);
447 
448         excludeFromFees(newOwner, true);
449         excludeFromFees(address(this), true);
450         excludeFromFees(address(0xdead), true);
451 
452         operationsAddress = address(newOwner);
453         devAddress = address(newOwner);
454 
455         _createInitialSupply(newOwner, totalSupply);
456         transferOwnership(newOwner);
457     }
458 
459     receive() external payable {}
460 
461     // only enable if no plan to airdrop
462 
463     function enableTrading(uint256 deadBlocks) external onlyOwner {
464         require(!tradingActive, "Cannot reenable trading");
465         tradingActive = true;
466         swapEnabled = true;
467         tradingActiveBlock = block.number;
468         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
469         emit EnabledTrading();
470     }
471 
472     // remove limits after token is stable
473     function removeLimits() external onlyOwner {
474         limitsInEffect = false;
475         transferDelayEnabled = false;
476         emit RemovedLimits();
477     }
478 
479     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
480         boughtEarly[wallet] = flag;
481     }
482 
483     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
484         for(uint256 i = 0; i < wallets.length; i++){
485             boughtEarly[wallets[i]] = flag;
486         }
487     }
488 
489     // disable Transfer delay - cannot be reenabled
490     function disableTransferDelay() external onlyOwner {
491         transferDelayEnabled = false;
492     }
493 
494     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
495         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
496         maxBuyAmount = newNum * (10**18);
497         emit UpdatedMaxBuyAmount(maxBuyAmount);
498     }
499 
500     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
501         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
502         maxSellAmount = newNum * (10**18);
503         emit UpdatedMaxSellAmount(maxSellAmount);
504     }
505 
506     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
507         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
508         maxWalletAmount = newNum * (10**18);
509         emit UpdatedMaxWalletAmount(maxWalletAmount);
510     }
511 
512     // change the minimum amount of tokens to sell from fees
513     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
514   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
515   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
516   	    swapTokensAtAmount = newAmount;
517   	}
518 
519     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
520         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
521         emit MaxTransactionExclusion(updAds, isExcluded);
522     }
523 
524     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
525         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
526         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
527         for(uint256 i = 0; i < wallets.length; i++){
528             address wallet = wallets[i];
529             uint256 amount = amountsInTokens[i];
530             super._transfer(msg.sender, wallet, amount);
531         }
532     }
533 
534     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
535         if(!isEx){
536             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
537         }
538         _isExcludedMaxTransactionAmount[updAds] = isEx;
539     }
540 
541     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
542         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
543 
544         _setAutomatedMarketMakerPair(pair, value);
545         emit SetAutomatedMarketMakerPair(pair, value);
546     }
547 
548     function _setAutomatedMarketMakerPair(address pair, bool value) private {
549         automatedMarketMakerPairs[pair] = value;
550 
551         _excludeFromMaxTransaction(pair, value);
552 
553         emit SetAutomatedMarketMakerPair(pair, value);
554     }
555 
556     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
557         buyOperationsFee = _operationsFee;
558         buyLiquidityFee = _liquidityFee;
559         buyDevFee = _devFee;
560         buyBurnFee = _burnFee;
561         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
562         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
563     }
564 
565     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
566         sellOperationsFee = _operationsFee;
567         sellLiquidityFee = _liquidityFee;
568         sellDevFee = _devFee;
569         sellBurnFee = _burnFee;
570         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
571         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
572     }
573 
574     function returnToNormalTax() external onlyOwner {
575         sellOperationsFee = 6;
576         sellLiquidityFee = 1;
577         sellDevFee = 0;
578         sellBurnFee = 0;
579         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
580         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
581 
582         buyOperationsFee = 6;
583         buyLiquidityFee = 1;
584         buyDevFee = 0;
585         buyBurnFee = 0;
586         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
587         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
588     }
589 
590     function excludeFromFees(address account, bool excluded) public onlyOwner {
591         _isExcludedFromFees[account] = excluded;
592         emit ExcludeFromFees(account, excluded);
593     }
594 
595     function _transfer(address from, address to, uint256 amount) internal override {
596 
597         require(from != address(0), "ERC20: transfer from the zero address");
598         require(to != address(0), "ERC20: transfer to the zero address");
599         require(amount > 0, "amount must be greater than 0");
600 
601         if(!tradingActive){
602             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
603         }
604 
605         if(blockForPenaltyEnd > 0){
606             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
607         }
608 
609         if(limitsInEffect){
610             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
611 
612                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
613                 if (transferDelayEnabled){
614                     if (to != address(dexRouter) && to != address(lpPair)){
615                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
616                         _holderLastTransferTimestamp[tx.origin] = block.number;
617                         _holderLastTransferTimestamp[to] = block.number;
618                     }
619                 }
620 
621                 //when buy
622                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
623                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
624                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
625                 }
626                 //when sell
627                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
628                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
629                 }
630                 else if (!_isExcludedMaxTransactionAmount[to]){
631                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
632                 }
633             }
634         }
635 
636         uint256 contractTokenBalance = balanceOf(address(this));
637 
638         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
639 
640         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
641             swapping = true;
642 
643             swapBack();
644 
645             swapping = false;
646         }
647 
648         bool takeFee = true;
649         // if any account belongs to _isExcludedFromFee account then remove the fee
650         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
651             takeFee = false;
652         }
653 
654         uint256 fees = 0;
655         // only take fees on buys/sells, do not take on wallet transfers
656         if(takeFee){
657             // bot/sniper penalty.
658             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
659 
660                 if(!boughtEarly[to]){
661                     boughtEarly[to] = true;
662                     botsCaught += 1;
663                     emit CaughtEarlyBuyer(to);
664                 }
665 
666                 fees = amount * 99 / 100;
667         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
668                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
669                 tokensForDev += fees * buyDevFee / buyTotalFees;
670                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
671             }
672 
673             // on sell
674             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
675                 fees = amount * sellTotalFees / 100;
676                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
677                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
678                 tokensForDev += fees * sellDevFee / sellTotalFees;
679                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
680             }
681 
682             // on buy
683             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
684         	    fees = amount * buyTotalFees / 100;
685         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
686                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
687                 tokensForDev += fees * buyDevFee / buyTotalFees;
688                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
689             }
690 
691             if(fees > 0){
692                 super._transfer(from, address(this), fees);
693             }
694 
695         	amount -= fees;
696         }
697 
698         super._transfer(from, to, amount);
699     }
700 
701     function earlyBuyPenaltyInEffect() public view returns (bool){
702         return block.number < blockForPenaltyEnd;
703     }
704 
705     function swapTokensForEth(uint256 tokenAmount) private {
706 
707         // generate the uniswap pair path of token -> weth
708         address[] memory path = new address[](2);
709         path[0] = address(this);
710         path[1] = dexRouter.WETH();
711 
712         _approve(address(this), address(dexRouter), tokenAmount);
713 
714         // make the swap
715         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
716             tokenAmount,
717             0, // accept any amount of ETH
718             path,
719             address(this),
720             block.timestamp
721         );
722     }
723 
724     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
725         // approve token transfer to cover all possible scenarios
726         _approve(address(this), address(dexRouter), tokenAmount);
727 
728         // add the liquidity
729         dexRouter.addLiquidityETH{value: ethAmount}(
730             address(this),
731             tokenAmount,
732             0, // slippage is unavoidable
733             0, // slippage is unavoidable
734             address(0xdead),
735             block.timestamp
736         );
737     }
738 
739     function swapBack() private {
740 
741         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
742             _burn(address(this), tokensForBurn);
743         }
744         tokensForBurn = 0;
745 
746         uint256 contractBalance = balanceOf(address(this));
747         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
748 
749         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
750 
751         if(contractBalance > swapTokensAtAmount * 20){
752             contractBalance = swapTokensAtAmount * 20;
753         }
754 
755         bool success;
756 
757         // Halve the amount of liquidity tokens
758         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
759 
760         swapTokensForEth(contractBalance - liquidityTokens);
761 
762         uint256 ethBalance = address(this).balance;
763         uint256 ethForLiquidity = ethBalance;
764 
765         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
766         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
767 
768         ethForLiquidity -= ethForOperations + ethForDev;
769 
770         tokensForLiquidity = 0;
771         tokensForOperations = 0;
772         tokensForDev = 0;
773         tokensForBurn = 0;
774 
775         if(liquidityTokens > 0 && ethForLiquidity > 0){
776             addLiquidity(liquidityTokens, ethForLiquidity);
777         }
778 
779         (success,) = address(devAddress).call{value: ethForDev}("");
780 
781         (success,) = address(operationsAddress).call{value: address(this).balance}("");
782     }
783 
784     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
785         require(_token != address(0), "_token address cannot be 0");
786         require(_token != address(this), "Can't withdraw native tokens");
787         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
788         _sent = IERC20(_token).transfer(_to, _contractBalance);
789         emit TransferForeignToken(_token, _contractBalance);
790     }
791 
792     // withdraw ETH if stuck or someone sends to the address
793     function withdrawStuckETH() external onlyOwner {
794         bool success;
795         (success,) = address(msg.sender).call{value: address(this).balance}("");
796     }
797 
798     function setOperationsAddress(address _operationsAddress) external onlyOwner {
799         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
800         operationsAddress = payable(_operationsAddress);
801     }
802 
803     function setDevAddress(address _devAddress) external onlyOwner {
804         require(_devAddress != address(0), "_devAddress address cannot be 0");
805         devAddress = payable(_devAddress);
806     }
807 
808     // force Swap back if slippage issues.
809     function forceSwapBack() external onlyOwner {
810         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
811         swapping = true;
812         swapBack();
813         swapping = false;
814         emit OwnerForcedSwapBack(block.timestamp);
815     }
816 
817     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
818     function buyBackTokens(uint256 amountInWei) external onlyOwner {
819         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
820 
821         address[] memory path = new address[](2);
822         path[0] = dexRouter.WETH();
823         path[1] = address(this);
824 
825         // make the swap
826         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
827             0, // accept any amount of Ethereum
828             path,
829             address(0xdead),
830             block.timestamp
831         );
832         emit BuyBackTriggered(amountInWei);
833     }
834 }