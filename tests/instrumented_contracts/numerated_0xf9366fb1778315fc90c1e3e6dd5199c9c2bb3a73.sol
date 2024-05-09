1 /**
2 
3 $BONK on ETH!
4 
5 Portal — t.me/BonkInu
6 Twitter — https://twitter.com/BonkInu
7 Website — http://bonkinu.wtf
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.15;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 contract ERC20 is Context, IERC20, IERC20Metadata {
119     mapping(address => uint256) private _balances;
120 
121     mapping(address => mapping(address => uint256)) private _allowances;
122 
123     uint256 private _totalSupply;
124 
125     string private _name;
126     string private _symbol;
127 
128     constructor(string memory name_, string memory symbol_) {
129         _name = name_;
130         _symbol = symbol_;
131     }
132 
133     function name() public view virtual override returns (string memory) {
134         return _name;
135     }
136 
137     function symbol() public view virtual override returns (string memory) {
138         return _symbol;
139     }
140 
141     function decimals() public view virtual override returns (uint8) {
142         return 18;
143     }
144 
145     function totalSupply() public view virtual override returns (uint256) {
146         return _totalSupply;
147     }
148 
149     function balanceOf(address account) public view virtual override returns (uint256) {
150         return _balances[account];
151     }
152 
153     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
154         _transfer(_msgSender(), recipient, amount);
155         return true;
156     }
157 
158     function allowance(address owner, address spender) public view virtual override returns (uint256) {
159         return _allowances[owner][spender];
160     }
161 
162     function approve(address spender, uint256 amount) public virtual override returns (bool) {
163         _approve(_msgSender(), spender, amount);
164         return true;
165     }
166 
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) public virtual override returns (bool) {
172         _transfer(sender, recipient, amount);
173 
174         uint256 currentAllowance = _allowances[sender][_msgSender()];
175         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
176         unchecked {
177             _approve(sender, _msgSender(), currentAllowance - amount);
178         }
179 
180         return true;
181     }
182 
183     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
184         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
185         return true;
186     }
187 
188     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
189         uint256 currentAllowance = _allowances[_msgSender()][spender];
190         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
191         unchecked {
192             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
193         }
194 
195         return true;
196     }
197 
198     function _transfer(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) internal virtual {
203         require(sender != address(0), "ERC20: transfer from the zero address");
204         require(recipient != address(0), "ERC20: transfer to the zero address");
205 
206         uint256 senderBalance = _balances[sender];
207         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
208         unchecked {
209             _balances[sender] = senderBalance - amount;
210         }
211         _balances[recipient] += amount;
212 
213         emit Transfer(sender, recipient, amount);
214     }
215 
216     function _createInitialSupply(address account, uint256 amount) internal virtual {
217         require(account != address(0), "ERC20: mint to the zero address");
218 
219         _totalSupply += amount;
220         _balances[account] += amount;
221         emit Transfer(address(0), account, amount);
222     }
223 
224     function _burn(address account, uint256 amount) internal virtual {
225         require(account != address(0), "ERC20: burn from the zero address");
226         uint256 accountBalance = _balances[account];
227         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
228         unchecked {
229             _balances[account] = accountBalance - amount;
230             // Overflow not possible: amount <= accountBalance <= totalSupply.
231             _totalSupply -= amount;
232         }
233 
234         emit Transfer(account, address(0), amount);
235     }
236 
237     function _approve(
238         address owner,
239         address spender,
240         uint256 amount
241     ) internal virtual {
242         require(owner != address(0), "ERC20: approve from the zero address");
243         require(spender != address(0), "ERC20: approve to the zero address");
244 
245         _allowances[owner][spender] = amount;
246         emit Approval(owner, spender, amount);
247     }
248 }
249 
250 contract Ownable is Context {
251     address private _owner;
252 
253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
254 
255     constructor () {
256         address msgSender = _msgSender();
257         _owner = msgSender;
258         emit OwnershipTransferred(address(0), msgSender);
259     }
260 
261     function owner() public view returns (address) {
262         return _owner;
263     }
264 
265     modifier onlyOwner() {
266         require(_owner == _msgSender(), "Ownable: caller is not the owner");
267         _;
268     }
269 
270     function renounceOwnership() external virtual onlyOwner {
271         emit OwnershipTransferred(_owner, address(0));
272         _owner = address(0);
273     }
274 
275     function transferOwnership(address newOwner) public virtual onlyOwner {
276         require(newOwner != address(0), "Ownable: new owner is the zero address");
277         emit OwnershipTransferred(_owner, newOwner);
278         _owner = newOwner;
279     }
280 }
281 
282 interface IDexRouter {
283     function factory() external pure returns (address);
284     function WETH() external pure returns (address);
285 
286     function swapExactTokensForETHSupportingFeeOnTransferTokens(
287         uint amountIn,
288         uint amountOutMin,
289         address[] calldata path,
290         address to,
291         uint deadline
292     ) external;
293 
294     function swapExactETHForTokensSupportingFeeOnTransferTokens(
295         uint amountOutMin,
296         address[] calldata path,
297         address to,
298         uint deadline
299     ) external payable;
300 
301     function addLiquidityETH(
302         address token,
303         uint256 amountTokenDesired,
304         uint256 amountTokenMin,
305         uint256 amountETHMin,
306         address to,
307         uint256 deadline
308     )
309         external
310         payable
311         returns (
312             uint256 amountToken,
313             uint256 amountETH,
314             uint256 liquidity
315         );
316 }
317 
318 interface IDexFactory {
319     function createPair(address tokenA, address tokenB)
320         external
321         returns (address pair);
322 }
323 
324 contract BonkInu is ERC20, Ownable {
325 
326     uint256 public maxBuyAmount;
327     uint256 public maxSellAmount;
328     uint256 public maxWalletAmount;
329 
330     IDexRouter public dexRouter;
331     address public lpPair;
332 
333     bool private swapping;
334     uint256 public swapTokensAtAmount;
335 
336     address operationsAddress;
337     address devAddress;
338 
339     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
340     uint256 public blockForPenaltyEnd;
341     mapping (address => bool) public boughtEarly;
342     uint256 public botsCaught;
343 
344     bool public limitsInEffect = true;
345     bool public tradingActive = false;
346     bool public swapEnabled = false;
347 
348      // Anti-bot and anti-whale mappings and variables
349     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
350     bool public transferDelayEnabled = true;
351 
352     uint256 public buyTotalFees;
353     uint256 public buyOperationsFee;
354     uint256 public buyLiquidityFee;
355     uint256 public buyDevFee;
356     uint256 public buyBurnFee;
357 
358     uint256 public sellTotalFees;
359     uint256 public sellOperationsFee;
360     uint256 public sellLiquidityFee;
361     uint256 public sellDevFee;
362     uint256 public sellBurnFee;
363 
364     uint256 public tokensForOperations;
365     uint256 public tokensForLiquidity;
366     uint256 public tokensForDev;
367     uint256 public tokensForBurn;
368 
369     /******************/
370 
371     // exlcude from fees and max transaction amount
372     mapping (address => bool) private _isExcludedFromFees;
373     mapping (address => bool) public _isExcludedMaxTransactionAmount;
374 
375     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
376     // could be subject to a maximum transfer amount
377     mapping (address => bool) public automatedMarketMakerPairs;
378 
379     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
380 
381     event EnabledTrading();
382 
383     event RemovedLimits();
384 
385     event ExcludeFromFees(address indexed account, bool isExcluded);
386 
387     event UpdatedMaxBuyAmount(uint256 newAmount);
388 
389     event UpdatedMaxSellAmount(uint256 newAmount);
390 
391     event UpdatedMaxWalletAmount(uint256 newAmount);
392 
393     event UpdatedOperationsAddress(address indexed newWallet);
394 
395     event MaxTransactionExclusion(address _address, bool excluded);
396 
397     event BuyBackTriggered(uint256 amount);
398 
399     event OwnerForcedSwapBack(uint256 timestamp);
400 
401     event CaughtEarlyBuyer(address sniper);
402 
403     event SwapAndLiquify(
404         uint256 tokensSwapped,
405         uint256 ethReceived,
406         uint256 tokensIntoLiquidity
407     );
408 
409     event TransferForeignToken(address token, uint256 amount);
410 
411     constructor() ERC20("Bonk Inu", "BONK") {
412 
413         address newOwner = msg.sender; // can leave alone if owner is deployer.
414 
415         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
416         dexRouter = _dexRouter;
417 
418         // create pair
419         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
420         _excludeFromMaxTransaction(address(lpPair), true);
421         _setAutomatedMarketMakerPair(address(lpPair), true);
422 
423         uint256 totalSupply = 5 * 1e12 * 1e18;
424 
425         maxBuyAmount = totalSupply * 3 / 100;
426         maxSellAmount = totalSupply * 2 / 100;
427         maxWalletAmount = totalSupply * 3 / 100;
428         swapTokensAtAmount = totalSupply * 5 / 10000;
429 
430         buyOperationsFee = 0;
431         buyLiquidityFee = 0;
432         buyDevFee = 0;
433         buyBurnFee = 0;
434         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
435 
436         sellOperationsFee = 0;
437         sellLiquidityFee = 0;
438         sellDevFee = 0;
439         sellBurnFee = 0;
440         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
441 
442         _excludeFromMaxTransaction(newOwner, true);
443         _excludeFromMaxTransaction(address(this), true);
444         _excludeFromMaxTransaction(address(0xdead), true);
445 
446         excludeFromFees(newOwner, true);
447         excludeFromFees(address(this), true);
448         excludeFromFees(address(0xdead), true);
449 
450         operationsAddress = address(newOwner);
451         devAddress = address(newOwner);
452 
453         _createInitialSupply(newOwner, totalSupply);
454         transferOwnership(newOwner);
455     }
456 
457     receive() external payable {}
458 
459     // only enable if no plan to airdrop
460 
461     function enableTrading(uint256 deadBlocks) external onlyOwner {
462         require(!tradingActive, "Cannot reenable trading");
463         tradingActive = true;
464         swapEnabled = true;
465         tradingActiveBlock = block.number;
466         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
467         emit EnabledTrading();
468     }
469 
470     // remove limits after token is stable
471     function removeLimits() external onlyOwner {
472         limitsInEffect = false;
473         transferDelayEnabled = false;
474         emit RemovedLimits();
475     }
476 
477     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
478         boughtEarly[wallet] = flag;
479     }
480 
481     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
482         for(uint256 i = 0; i < wallets.length; i++){
483             boughtEarly[wallets[i]] = flag;
484         }
485     }
486 
487     // disable Transfer delay - cannot be reenabled
488     function disableTransferDelay() external onlyOwner {
489         transferDelayEnabled = false;
490     }
491 
492     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
493         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
494         maxBuyAmount = newNum * (10**18);
495         emit UpdatedMaxBuyAmount(maxBuyAmount);
496     }
497 
498     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
499         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
500         maxSellAmount = newNum * (10**18);
501         emit UpdatedMaxSellAmount(maxSellAmount);
502     }
503 
504     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
505         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
506         maxWalletAmount = newNum * (10**18);
507         emit UpdatedMaxWalletAmount(maxWalletAmount);
508     }
509 
510     // change the minimum amount of tokens to sell from fees
511     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
512   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
513   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
514   	    swapTokensAtAmount = newAmount;
515   	}
516 
517     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
518         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
519         emit MaxTransactionExclusion(updAds, isExcluded);
520     }
521 
522     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
523         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
524         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
525         for(uint256 i = 0; i < wallets.length; i++){
526             address wallet = wallets[i];
527             uint256 amount = amountsInTokens[i];
528             super._transfer(msg.sender, wallet, amount);
529         }
530     }
531 
532     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
533         if(!isEx){
534             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
535         }
536         _isExcludedMaxTransactionAmount[updAds] = isEx;
537     }
538 
539     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
540         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
541 
542         _setAutomatedMarketMakerPair(pair, value);
543         emit SetAutomatedMarketMakerPair(pair, value);
544     }
545 
546     function _setAutomatedMarketMakerPair(address pair, bool value) private {
547         automatedMarketMakerPairs[pair] = value;
548 
549         _excludeFromMaxTransaction(pair, value);
550 
551         emit SetAutomatedMarketMakerPair(pair, value);
552     }
553 
554     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
555         buyOperationsFee = _operationsFee;
556         buyLiquidityFee = _liquidityFee;
557         buyDevFee = _devFee;
558         buyBurnFee = _burnFee;
559         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
560         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
561     }
562 
563     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
564         sellOperationsFee = _operationsFee;
565         sellLiquidityFee = _liquidityFee;
566         sellDevFee = _devFee;
567         sellBurnFee = _burnFee;
568         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
569         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
570     }
571 
572     function returnToNormalTax() external onlyOwner {
573         sellOperationsFee = 0;
574         sellLiquidityFee = 0;
575         sellDevFee = 0;
576         sellBurnFee = 0;
577         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
578         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
579 
580         buyOperationsFee = 0;
581         buyLiquidityFee = 0;
582         buyDevFee = 0;
583         buyBurnFee = 0;
584         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
585         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
586     }
587 
588     function excludeFromFees(address account, bool excluded) public onlyOwner {
589         _isExcludedFromFees[account] = excluded;
590         emit ExcludeFromFees(account, excluded);
591     }
592 
593     function _transfer(address from, address to, uint256 amount) internal override {
594 
595         require(from != address(0), "ERC20: transfer from the zero address");
596         require(to != address(0), "ERC20: transfer to the zero address");
597         require(amount > 0, "amount must be greater than 0");
598 
599         if(!tradingActive){
600             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
601         }
602 
603         if(blockForPenaltyEnd > 0){
604             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
605         }
606 
607         if(limitsInEffect){
608             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
609 
610                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
611                 if (transferDelayEnabled){
612                     if (to != address(dexRouter) && to != address(lpPair)){
613                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
614                         _holderLastTransferTimestamp[tx.origin] = block.number;
615                         _holderLastTransferTimestamp[to] = block.number;
616                     }
617                 }
618 
619                 //when buy
620                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
621                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
622                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
623                 }
624                 //when sell
625                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
626                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
627                 }
628                 else if (!_isExcludedMaxTransactionAmount[to]){
629                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
630                 }
631             }
632         }
633 
634         uint256 contractTokenBalance = balanceOf(address(this));
635 
636         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
637 
638         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
639             swapping = true;
640 
641             swapBack();
642 
643             swapping = false;
644         }
645 
646         bool takeFee = true;
647         // if any account belongs to _isExcludedFromFee account then remove the fee
648         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
649             takeFee = false;
650         }
651 
652         uint256 fees = 0;
653         // only take fees on buys/sells, do not take on wallet transfers
654         if(takeFee){
655             // bot/sniper penalty.
656             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
657 
658                 if(!boughtEarly[to]){
659                     boughtEarly[to] = true;
660                     botsCaught += 1;
661                     emit CaughtEarlyBuyer(to);
662                 }
663 
664                 fees = amount * 99 / 100;
665         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
666                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
667                 tokensForDev += fees * buyDevFee / buyTotalFees;
668                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
669             }
670 
671             // on sell
672             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
673                 fees = amount * sellTotalFees / 100;
674                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
675                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
676                 tokensForDev += fees * sellDevFee / sellTotalFees;
677                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
678             }
679 
680             // on buy
681             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
682         	    fees = amount * buyTotalFees / 100;
683         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
684                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
685                 tokensForDev += fees * buyDevFee / buyTotalFees;
686                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
687             }
688 
689             if(fees > 0){
690                 super._transfer(from, address(this), fees);
691             }
692 
693         	amount -= fees;
694         }
695 
696         super._transfer(from, to, amount);
697     }
698 
699     function earlyBuyPenaltyInEffect() public view returns (bool){
700         return block.number < blockForPenaltyEnd;
701     }
702 
703     function swapTokensForEth(uint256 tokenAmount) private {
704 
705         // generate the uniswap pair path of token -> weth
706         address[] memory path = new address[](2);
707         path[0] = address(this);
708         path[1] = dexRouter.WETH();
709 
710         _approve(address(this), address(dexRouter), tokenAmount);
711 
712         // make the swap
713         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
714             tokenAmount,
715             0, // accept any amount of ETH
716             path,
717             address(this),
718             block.timestamp
719         );
720     }
721 
722     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
723         // approve token transfer to cover all possible scenarios
724         _approve(address(this), address(dexRouter), tokenAmount);
725 
726         // add the liquidity
727         dexRouter.addLiquidityETH{value: ethAmount}(
728             address(this),
729             tokenAmount,
730             0, // slippage is unavoidable
731             0, // slippage is unavoidable
732             address(0xdead),
733             block.timestamp
734         );
735     }
736 
737     function swapBack() private {
738 
739         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
740             _burn(address(this), tokensForBurn);
741         }
742         tokensForBurn = 0;
743 
744         uint256 contractBalance = balanceOf(address(this));
745         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
746 
747         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
748 
749         if(contractBalance > swapTokensAtAmount * 60){
750             contractBalance = swapTokensAtAmount * 60;
751         }
752 
753         bool success;
754 
755         // Halve the amount of liquidity tokens
756         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
757 
758         swapTokensForEth(contractBalance - liquidityTokens);
759 
760         uint256 ethBalance = address(this).balance;
761         uint256 ethForLiquidity = ethBalance;
762 
763         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
764         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
765 
766         ethForLiquidity -= ethForOperations + ethForDev;
767 
768         tokensForLiquidity = 0;
769         tokensForOperations = 0;
770         tokensForDev = 0;
771         tokensForBurn = 0;
772 
773         if(liquidityTokens > 0 && ethForLiquidity > 0){
774             addLiquidity(liquidityTokens, ethForLiquidity);
775         }
776 
777         (success,) = address(devAddress).call{value: ethForDev}("");
778 
779         (success,) = address(operationsAddress).call{value: address(this).balance}("");
780     }
781 
782     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
783         require(_token != address(0), "_token address cannot be 0");
784         require(_token != address(this), "Can't withdraw native tokens");
785         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
786         _sent = IERC20(_token).transfer(_to, _contractBalance);
787         emit TransferForeignToken(_token, _contractBalance);
788     }
789 
790     // withdraw ETH if stuck or someone sends to the address
791     function withdrawStuckETH() external onlyOwner {
792         bool success;
793         (success,) = address(msg.sender).call{value: address(this).balance}("");
794     }
795 
796     function setOperationsAddress(address _operationsAddress) external onlyOwner {
797         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
798         operationsAddress = payable(_operationsAddress);
799     }
800 
801     function setDevAddress(address _devAddress) external onlyOwner {
802         require(_devAddress != address(0), "_devAddress address cannot be 0");
803         devAddress = payable(_devAddress);
804     }
805 
806     // force Swap back if slippage issues.
807     function forceSwapBack() external onlyOwner {
808         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
809         swapping = true;
810         swapBack();
811         swapping = false;
812         emit OwnerForcedSwapBack(block.timestamp);
813     }
814 
815     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
816     function buyBackTokens(uint256 amountInWei) external onlyOwner {
817         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
818 
819         address[] memory path = new address[](2);
820         path[0] = dexRouter.WETH();
821         path[1] = address(this);
822 
823         // make the swap
824         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
825             0, // accept any amount of Ethereum
826             path,
827             address(0xdead),
828             block.timestamp
829         );
830         emit BuyBackTriggered(amountInWei);
831     }
832 }