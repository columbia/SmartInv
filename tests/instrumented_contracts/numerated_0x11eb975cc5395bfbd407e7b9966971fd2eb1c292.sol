1 /**
2  * BLACK JESUS IS BACK TO SAVE YOUR SOULS, AMEN.
3 */
4 
5 /*
6        * wwww.blackjesus.family *
7        
8        * https://t.me/blackjesuserc *
9 
10        * https://twitter.com/blackjesuserc *
11 */
12     
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.17;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     mapping(address => uint256) private _balances;
123 
124     mapping(address => mapping(address => uint256)) private _allowances;
125 
126     uint256 private _totalSupply;
127 
128     string private _name;
129     string private _symbol;
130 
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139 
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147 
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(address account) public view virtual override returns (uint256) {
153         return _balances[account];
154     }
155 
156     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
157         _transfer(_msgSender(), recipient, amount);
158         return true;
159     }
160 
161     function allowance(address owner, address spender) public view virtual override returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169 
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176 
177         uint256 currentAllowance = _allowances[sender][_msgSender()];
178         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
179         unchecked {
180             _approve(sender, _msgSender(), currentAllowance - amount);
181         }
182 
183         return true;
184     }
185 
186     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
188         return true;
189     }
190 
191     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
192         uint256 currentAllowance = _allowances[_msgSender()][spender];
193         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
194         unchecked {
195             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
196         }
197 
198         return true;
199     }
200 
201     function _transfer(
202         address sender,
203         address recipient,
204         uint256 amount
205     ) internal virtual {
206         require(sender != address(0), "ERC20: transfer from the zero address");
207         require(recipient != address(0), "ERC20: transfer to the zero address");
208 
209         uint256 senderBalance = _balances[sender];
210         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
211         unchecked {
212             _balances[sender] = senderBalance - amount;
213         }
214         _balances[recipient] += amount;
215 
216         emit Transfer(sender, recipient, amount);
217     }
218 
219     function _createInitialSupply(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: mint to the zero address");
221 
222         _totalSupply += amount;
223         _balances[account] += amount;
224         emit Transfer(address(0), account, amount);
225     }
226 
227     function _burn(address account, uint256 amount) internal virtual {
228         require(account != address(0), "ERC20: burn from the zero address");
229         uint256 accountBalance = _balances[account];
230         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
231         unchecked {
232             _balances[account] = accountBalance - amount;
233             // Overflow not possible: amount <= accountBalance <= totalSupply.
234             _totalSupply -= amount;
235         }
236 
237         emit Transfer(account, address(0), amount);
238     }
239 
240     function _approve(
241         address owner,
242         address spender,
243         uint256 amount
244     ) internal virtual {
245         require(owner != address(0), "ERC20: approve from the zero address");
246         require(spender != address(0), "ERC20: approve to the zero address");
247 
248         _allowances[owner][spender] = amount;
249         emit Approval(owner, spender, amount);
250     }
251 }
252 
253 contract Ownable is Context {
254     address private _owner;
255 
256     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258     constructor () {
259         address msgSender = _msgSender();
260         _owner = msgSender;
261         emit OwnershipTransferred(address(0), msgSender);
262     }
263 
264     function owner() public view returns (address) {
265         return _owner;
266     }
267 
268     modifier onlyOwner() {
269         require(_owner == _msgSender(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     function renounceOwnership() external virtual onlyOwner {
274         emit OwnershipTransferred(_owner, address(0));
275         _owner = address(0);
276     }
277 
278     function transferOwnership(address newOwner) public virtual onlyOwner {
279         require(newOwner != address(0), "Ownable: new owner is the zero address");
280         emit OwnershipTransferred(_owner, newOwner);
281         _owner = newOwner;
282     }
283 }
284 
285 interface IDexRouter {
286     function factory() external pure returns (address);
287     function WETH() external pure returns (address);
288 
289     function swapExactTokensForETHSupportingFeeOnTransferTokens(
290         uint amountIn,
291         uint amountOutMin,
292         address[] calldata path,
293         address to,
294         uint deadline
295     ) external;
296 
297     function swapExactETHForTokensSupportingFeeOnTransferTokens(
298         uint amountOutMin,
299         address[] calldata path,
300         address to,
301         uint deadline
302     ) external payable;
303 
304     function addLiquidityETH(
305         address token,
306         uint256 amountTokenDesired,
307         uint256 amountTokenMin,
308         uint256 amountETHMin,
309         address to,
310         uint256 deadline
311     )
312         external
313         payable
314         returns (
315             uint256 amountToken,
316             uint256 amountETH,
317             uint256 liquidity
318         );
319 }
320 
321 interface IDexFactory {
322     function createPair(address tokenA, address tokenB)
323         external
324         returns (address pair);
325 }
326 
327 contract blackjesus is ERC20, Ownable {
328 
329     uint256 public maxBuyAmount;
330     uint256 public maxSellAmount;
331     uint256 public maxWalletAmount;
332 
333     IDexRouter public dexRouter;
334     address public lpPair;
335 
336     bool private swapping;
337     uint256 public swapTokensAtAmount;
338 
339     address operationsAddress;
340     address otherAddress;
341 
342     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
343     uint256 public blockForPenaltyEnd;
344     mapping (address => bool) public boughtEarly;
345     uint256 public botsCaught;
346 
347     bool public limitsInEffect = true;
348     bool public tradingActive = false;
349     bool public swapEnabled = false;
350 
351      // Anti-bot and anti-whale mappings and variables
352     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
353     bool public transferDelayEnabled = true;
354 
355     uint256 public buyTotalFees;
356     uint256 public buyOperationsFee;
357     uint256 public buyLiquidityFee;
358     uint256 public buyotherFee;
359     uint256 public buyBurnFee;
360 
361     uint256 public sellTotalFees;
362     uint256 public sellOperationsFee;
363     uint256 public sellLiquidityFee;
364     uint256 public sellotherFee;
365     uint256 public sellBurnFee;
366 
367     uint256 public tokensForOperations;
368     uint256 public tokensForLiquidity;
369     uint256 public tokensForother;
370     uint256 public tokensForBurn;
371 
372     /******************/
373 
374     // exlcude from fees and max transaction amount
375     mapping (address => bool) private _isExcludedFromFees;
376     mapping (address => bool) public _isExcludedMaxTransactionAmount;
377 
378     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
379     // could be subject to a maximum transfer amount
380     mapping (address => bool) public automatedMarketMakerPairs;
381 
382     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
383 
384     event EnabledTrading();
385 
386     event RemovedLimits();
387 
388     event ExcludeFromFees(address indexed account, bool isExcluded);
389 
390     event UpdatedMaxBuyAmount(uint256 newAmount);
391 
392     event UpdatedMaxSellAmount(uint256 newAmount);
393 
394     event UpdatedMaxWalletAmount(uint256 newAmount);
395 
396     event UpdatedOperationsAddress(address indexed newWallet);
397 
398     event MaxTransactionExclusion(address _address, bool excluded);
399 
400     event BuyBackTriggered(uint256 amount);
401 
402     event OwnerForcedSwapBack(uint256 timestamp);
403 
404     event CaughtEarlyBuyer(address sniper);
405 
406     event SwapAndLiquify(
407         uint256 tokensSwapped,
408         uint256 ethReceived,
409         uint256 tokensIntoLiquidity
410     );
411 
412     event TransferForeignToken(address token, uint256 amount);
413 
414     constructor() ERC20("Black Jesus", "BJ") {
415 
416         address newOwner = msg.sender; // can leave alone if owner is deployer.
417 
418         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
419         dexRouter = _dexRouter;
420 
421         // create pair
422         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
423         _excludeFromMaxTransaction(address(lpPair), true);
424         _setAutomatedMarketMakerPair(address(lpPair), true);
425 
426         uint256 totalSupply = 888888888 * 1e18;
427 
428         maxBuyAmount = totalSupply * 1 / 100;
429         maxSellAmount = totalSupply * 1 / 100;
430         maxWalletAmount = totalSupply * 1 / 100;
431         swapTokensAtAmount = totalSupply * 1 / 10000;
432 
433         buyOperationsFee = 18;
434         buyLiquidityFee = 0;
435         buyotherFee = 0;
436         buyBurnFee = 0;
437         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyotherFee + buyBurnFee;
438 
439         sellOperationsFee = 28;
440         sellLiquidityFee = 0;
441         sellotherFee = 0;
442         sellBurnFee = 0;
443         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellotherFee + sellBurnFee;
444 
445         _excludeFromMaxTransaction(newOwner, true);
446         _excludeFromMaxTransaction(address(this), true);
447         _excludeFromMaxTransaction(address(0xdead), true);
448 
449         excludeFromFees(newOwner, true);
450         excludeFromFees(address(this), true);
451         excludeFromFees(address(0xdead), true);
452 
453         operationsAddress = address(newOwner);
454         otherAddress = address(newOwner);
455 
456         _createInitialSupply(newOwner, totalSupply);
457         transferOwnership(newOwner);
458     }
459 
460     receive() external payable {}
461 
462     // only enable if no plan to airdrop
463 
464     function enableTrading(uint256 deadBlocks) external onlyOwner {
465         require(!tradingActive, "Cannot reenable trading");
466         tradingActive = true;
467         swapEnabled = true;
468         tradingActiveBlock = block.number;
469         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
470         emit EnabledTrading();
471     }
472 
473     // remove limits after token is stable
474     function removeLimits() external onlyOwner {
475         limitsInEffect = false;
476         transferDelayEnabled = false;
477         emit RemovedLimits();
478     }
479 
480     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
481         boughtEarly[wallet] = flag;
482     }
483 
484     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
485         for(uint256 i = 0; i < wallets.length; i++){
486             boughtEarly[wallets[i]] = flag;
487         }
488     }
489 
490     // disable Transfer delay - cannot be reenabled
491     function disableTransferDelay() external onlyOwner {
492         transferDelayEnabled = false;
493     }
494 
495     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
496         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
497         maxBuyAmount = newNum * (10**18);
498         emit UpdatedMaxBuyAmount(maxBuyAmount);
499     }
500 
501     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
502         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
503         maxSellAmount = newNum * (10**18);
504         emit UpdatedMaxSellAmount(maxSellAmount);
505     }
506 
507     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
508         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
509         maxWalletAmount = newNum * (10**18);
510         emit UpdatedMaxWalletAmount(maxWalletAmount);
511     }
512 
513     // change the minimum amount of tokens to sell from fees
514     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
515   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
516   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
517   	    swapTokensAtAmount = newAmount;
518   	}
519 
520     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
521         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
522         emit MaxTransactionExclusion(updAds, isExcluded);
523     }
524 
525     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
526         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
527         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
528         for(uint256 i = 0; i < wallets.length; i++){
529             address wallet = wallets[i];
530             uint256 amount = amountsInTokens[i];
531             super._transfer(msg.sender, wallet, amount);
532         }
533     }
534 
535     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
536         if(!isEx){
537             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
538         }
539         _isExcludedMaxTransactionAmount[updAds] = isEx;
540     }
541 
542     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
543         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
544 
545         _setAutomatedMarketMakerPair(pair, value);
546         emit SetAutomatedMarketMakerPair(pair, value);
547     }
548 
549     function _setAutomatedMarketMakerPair(address pair, bool value) private {
550         automatedMarketMakerPairs[pair] = value;
551 
552         _excludeFromMaxTransaction(pair, value);
553 
554         emit SetAutomatedMarketMakerPair(pair, value);
555     }
556 
557     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _otherFee, uint256 _burnFee) external onlyOwner {
558         buyOperationsFee = _operationsFee;
559         buyLiquidityFee = _liquidityFee;
560         buyotherFee = _otherFee;
561         buyBurnFee = _burnFee;
562         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyotherFee + buyBurnFee;
563         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
564     }
565 
566     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _otherFee, uint256 _burnFee) external onlyOwner {
567         sellOperationsFee = _operationsFee;
568         sellLiquidityFee = _liquidityFee;
569         sellotherFee = _otherFee;
570         sellBurnFee = _burnFee;
571         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellotherFee + sellBurnFee;
572         require(sellTotalFees <= 30, "Keep fees at 30% or less");
573     }
574 
575     function returnToNormalTax() external onlyOwner {
576         sellOperationsFee = 0;
577         sellLiquidityFee = 0;
578         sellotherFee = 0;
579         sellBurnFee = 0;
580         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellotherFee + sellBurnFee;
581         require(sellTotalFees <= 30, "Keep fees at 30% or less");
582 
583         buyOperationsFee = 0;
584         buyLiquidityFee = 0;
585         buyotherFee = 0;
586         buyBurnFee = 0;
587         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyotherFee + buyBurnFee;
588         require(buyTotalFees <= 15, "Keep fees at 15% or less");
589     }
590 
591     function excludeFromFees(address account, bool excluded) public onlyOwner {
592         _isExcludedFromFees[account] = excluded;
593         emit ExcludeFromFees(account, excluded);
594     }
595 
596     function _transfer(address from, address to, uint256 amount) internal override {
597 
598         require(from != address(0), "ERC20: transfer from the zero address");
599         require(to != address(0), "ERC20: transfer to the zero address");
600         require(amount > 0, "amount must be greater than 0");
601 
602         if(!tradingActive){
603             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
604         }
605 
606         if(blockForPenaltyEnd > 0){
607             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
608         }
609 
610         if(limitsInEffect){
611             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
612 
613                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
614                 if (transferDelayEnabled){
615                     if (to != address(dexRouter) && to != address(lpPair)){
616                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
617                         _holderLastTransferTimestamp[tx.origin] = block.number;
618                         _holderLastTransferTimestamp[to] = block.number;
619                     }
620                 }
621 
622                 //when buy
623                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
624                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
625                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
626                 }
627                 //when sell
628                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
629                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
630                 }
631                 else if (!_isExcludedMaxTransactionAmount[to]){
632                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
633                 }
634             }
635         }
636 
637         uint256 contractTokenBalance = balanceOf(address(this));
638 
639         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
640 
641         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
642             swapping = true;
643 
644             swapBack();
645 
646             swapping = false;
647         }
648 
649         bool takeFee = true;
650         // if any account belongs to _isExcludedFromFee account then remove the fee
651         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
652             takeFee = false;
653         }
654 
655         uint256 fees = 0;
656         // only take fees on buys/sells, do not take on wallet transfers
657         if(takeFee){
658             // bot/sniper penalty.
659             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
660 
661                 if(!boughtEarly[to]){
662                     boughtEarly[to] = true;
663                     botsCaught += 1;
664                     emit CaughtEarlyBuyer(to);
665                 }
666 
667                 fees = amount * 99 / 100;
668         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
669                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
670                 tokensForother += fees * buyotherFee / buyTotalFees;
671                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
672             }
673 
674             // on sell
675             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
676                 fees = amount * sellTotalFees / 100;
677                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
678                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
679                 tokensForother += fees * sellotherFee / sellTotalFees;
680                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
681             }
682 
683             // on buy
684             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
685         	    fees = amount * buyTotalFees / 100;
686         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
687                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
688                 tokensForother += fees * buyotherFee / buyTotalFees;
689                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
690             }
691 
692             if(fees > 0){
693                 super._transfer(from, address(this), fees);
694             }
695 
696         	amount -= fees;
697         }
698 
699         super._transfer(from, to, amount);
700     }
701 
702     function earlyBuyPenaltyInEffect() public view returns (bool){
703         return block.number < blockForPenaltyEnd;
704     }
705 
706     function swapTokensForEth(uint256 tokenAmount) private {
707 
708         // generate the uniswap pair path of token -> weth
709         address[] memory path = new address[](2);
710         path[0] = address(this);
711         path[1] = dexRouter.WETH();
712 
713         _approve(address(this), address(dexRouter), tokenAmount);
714 
715         // make the swap
716         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
717             tokenAmount,
718             0, // accept any amount of ETH
719             path,
720             address(this),
721             block.timestamp
722         );
723     }
724 
725     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
726         // approve token transfer to cover all possible scenarios
727         _approve(address(this), address(dexRouter), tokenAmount);
728 
729         // add the liquidity
730         dexRouter.addLiquidityETH{value: ethAmount}(
731             address(this),
732             tokenAmount,
733             0, // slippage is unavoidable
734             0, // slippage is unavoidable
735             address(operationsAddress),
736             block.timestamp
737         );
738     }
739 
740     function swapBack() private {
741 
742         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
743             _burn(address(this), tokensForBurn);
744         }
745         tokensForBurn = 0;
746 
747         uint256 contractBalance = balanceOf(address(this));
748         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForother;
749 
750         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
751 
752         if(contractBalance > swapTokensAtAmount * 20){
753             contractBalance = swapTokensAtAmount * 20;
754         }
755 
756         bool success;
757 
758         // Halve the amount of liquidity tokens
759         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
760 
761         swapTokensForEth(contractBalance - liquidityTokens);
762 
763         uint256 ethBalance = address(this).balance;
764         uint256 ethForLiquidity = ethBalance;
765 
766         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
767         uint256 ethForother = ethBalance * tokensForother / (totalTokensToSwap - (tokensForLiquidity/2));
768 
769         ethForLiquidity -= ethForOperations + ethForother;
770 
771         tokensForLiquidity = 0;
772         tokensForOperations = 0;
773         tokensForother = 0;
774         tokensForBurn = 0;
775 
776         if(liquidityTokens > 0 && ethForLiquidity > 0){
777             addLiquidity(liquidityTokens, ethForLiquidity);
778         }
779 
780         (success,) = address(otherAddress).call{value: ethForother}("");
781 
782         (success,) = address(operationsAddress).call{value: address(this).balance}("");
783     }
784 
785     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
786         require(_token != address(0), "_token address cannot be 0");
787         require(_token != address(this), "Can't withdraw native tokens");
788         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
789         _sent = IERC20(_token).transfer(_to, _contractBalance);
790         emit TransferForeignToken(_token, _contractBalance);
791     }
792 
793     // withdraw ETH if stuck or someone sends to the address
794     function withdrawStuckETH() external onlyOwner {
795         bool success;
796         (success,) = address(msg.sender).call{value: address(this).balance}("");
797     }
798 
799     function setOperationsAddress(address _operationsAddress) external onlyOwner {
800         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
801         operationsAddress = payable(_operationsAddress);
802     }
803 
804     function setotherAddress(address _otherAddress) external onlyOwner {
805         require(_otherAddress != address(0), "_otherAddress address cannot be 0");
806         otherAddress = payable(_otherAddress);
807     }
808 
809     // force Swap back if slippage issues.
810     function forceSwapBack() external onlyOwner {
811         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
812         swapping = true;
813         swapBack();
814         swapping = false;
815         emit OwnerForcedSwapBack(block.timestamp);
816     }
817 
818     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
819     function buyBackTokens(uint256 amountInWei) external onlyOwner {
820         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
821 
822         address[] memory path = new address[](2);
823         path[0] = dexRouter.WETH();
824         path[1] = address(this);
825 
826         // make the swap
827         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
828             0, // accept any amount of Ethereum
829             path,
830             address(0xdead),
831             block.timestamp
832         );
833         emit BuyBackTriggered(amountInWei);
834     }
835 }