1 /**
2 
3 https://twitter.com/JoeyPonzi/status/1683600530747146241?s=20
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.17;
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
220     function _approve(
221         address owner,
222         address spender,
223         uint256 amount
224     ) internal virtual {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227 
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 }
232 
233 contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     constructor () {
239         address msgSender = _msgSender();
240         _owner = msgSender;
241         emit OwnershipTransferred(address(0), msgSender);
242     }
243 
244     function owner() public view returns (address) {
245         return _owner;
246     }
247 
248     modifier onlyOwner() {
249         require(_owner == _msgSender(), "Ownable: caller is not the owner");
250         _;
251     }
252 
253     function renounceOwnership() external virtual onlyOwner {
254         emit OwnershipTransferred(_owner, address(0));
255         _owner = address(0);
256     }
257 
258     function transferOwnership(address newOwner) public virtual onlyOwner {
259         require(newOwner != address(0), "Ownable: new owner is the zero address");
260         emit OwnershipTransferred(_owner, newOwner);
261         _owner = newOwner;
262     }
263 }
264 
265 interface IDexRouter {
266     function factory() external pure returns (address);
267     function WETH() external pure returns (address);
268 
269     function swapExactTokensForETHSupportingFeeOnTransferTokens(
270         uint amountIn,
271         uint amountOutMin,
272         address[] calldata path,
273         address to,
274         uint deadline
275     ) external;
276 
277     function swapExactETHForTokensSupportingFeeOnTransferTokens(
278         uint amountOutMin,
279         address[] calldata path,
280         address to,
281         uint deadline
282     ) external payable;
283 
284     function addLiquidityETH(
285         address token,
286         uint256 amountTokenDesired,
287         uint256 amountTokenMin,
288         uint256 amountETHMin,
289         address to,
290         uint256 deadline
291     )
292         external
293         payable
294         returns (
295             uint256 amountToken,
296             uint256 amountETH,
297             uint256 liquidity
298         );
299 }
300 
301 interface IDexFactory {
302     function createPair(address tokenA, address tokenB)
303         external
304         returns (address pair);
305 }
306 
307 contract xeet is ERC20, Ownable {
308 
309     uint256 public maxBuyAmount;
310     uint256 public maxSellAmount;
311     uint256 public maxWalletAmount;
312 
313     IDexRouter public dexRouter;
314     address public lpPair;
315 
316     bool private swapping;
317     uint256 public swapTokensAtAmount;
318 
319     address operationsAddress;
320 
321     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
322     mapping (address => bool) public bot;
323     uint256 public botsCaught;
324 
325     bool public limitsInEffect = true;
326     bool public tradingActive = false;
327     bool public swapEnabled = false;
328 
329      // Anti-bot and anti-whale mappings and variables
330     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
331     bool public transferDelayEnabled = true;
332 
333     uint256 public buyTotalFees;
334     uint256 public buyOperationsFee;
335     uint256 public buyLiquidityFee;
336 
337     uint256 public sellTotalFees;
338     uint256 public sellOperationsFee;
339     uint256 public sellLiquidityFee;
340 
341     uint256 public tokensForOperations;
342     uint256 public tokensForLiquidity;
343 
344     /******************/
345 
346     // exlcude from fees and max transaction amount
347     mapping (address => bool) private _isExcludedFromFees;
348     mapping (address => bool) public _isExcludedMaxTransactionAmount;
349 
350     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
351     // could be subject to a maximum transfer amount
352     mapping (address => bool) public automatedMarketMakerPairs;
353 
354     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
355 
356     event EnabledTrading();
357 
358     event RemovedLimits();
359 
360     event ExcludeFromFees(address indexed account, bool isExcluded);
361 
362     event UpdatedMaxBuyAmount(uint256 newAmount);
363 
364     event UpdatedMaxSellAmount(uint256 newAmount);
365 
366     event UpdatedMaxWalletAmount(uint256 newAmount);
367 
368     event UpdatedOperationsAddress(address indexed newWallet);
369 
370     event MaxTransactionExclusion(address _address, bool excluded);
371 
372     event BuyBackTriggered(uint256 amount);
373 
374     event OwnerForcedSwapBack(uint256 timestamp);
375  
376     event CaughtEarlyBuyer(address sniper);
377 
378     event SwapAndLiquify(
379         uint256 tokensSwapped,
380         uint256 ethReceived,
381         uint256 tokensIntoLiquidity
382     );
383 
384     event TransferForeignToken(address token, uint256 amount);
385 
386     constructor() ERC20("Xeet", "XEET") {
387 
388         address newOwner = msg.sender; // can leave alone if owner is deployer.
389 
390         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
391         dexRouter = _dexRouter;
392 
393         // create pair
394         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
395         _excludeFromMaxTransaction(address(lpPair), true);
396         _setAutomatedMarketMakerPair(address(lpPair), true);
397 
398         uint256 totalSupply = 1 * 1e9 * 1e18;
399 
400         maxBuyAmount = totalSupply * 3 / 100;
401         maxSellAmount = totalSupply * 3 / 100;
402         maxWalletAmount = totalSupply * 3 / 100;
403         swapTokensAtAmount = totalSupply * 5 / 10000;
404 
405         buyOperationsFee = 30;
406         buyLiquidityFee = 0;
407         buyTotalFees = buyOperationsFee + buyLiquidityFee;
408 
409         sellOperationsFee = 30;
410         sellLiquidityFee = 0;
411         sellTotalFees = sellOperationsFee + sellLiquidityFee;
412 
413         _excludeFromMaxTransaction(newOwner, true);
414         _excludeFromMaxTransaction(address(this), true);
415         _excludeFromMaxTransaction(address(0xdead), true);
416 
417         excludeFromFees(newOwner, true);
418         excludeFromFees(address(this), true);
419         excludeFromFees(address(0xdead), true);
420 
421         operationsAddress = address(newOwner);
422 
423         _createInitialSupply(newOwner, totalSupply);
424         transferOwnership(newOwner);
425     }
426 
427     receive() external payable {}
428 
429     // only enable if no plan to airdrop
430 
431     function enableTrading() external onlyOwner {
432         require(!tradingActive, "Cannot reenable trading");
433         tradingActive = true;
434         swapEnabled = true;
435         tradingActiveBlock = block.number;
436         emit EnabledTrading();
437     }
438 
439     // remove limits after token is stable
440     function removeLimits() external onlyOwner {
441         limitsInEffect = false;
442         transferDelayEnabled = false;
443         emit RemovedLimits();
444     }
445 
446     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
447         bot[wallet] = flag;
448     }
449 
450     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
451         for(uint256 i = 0; i < wallets.length; i++){
452             bot[wallets[i]] = flag;
453         }
454     }
455 
456     // disable Transfer delay - cannot be reenabled
457     function disableTransferDelay() external onlyOwner {
458         transferDelayEnabled = false;
459     }
460 
461     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
462         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
463         maxBuyAmount = newNum * (10**18);
464         emit UpdatedMaxBuyAmount(maxBuyAmount);
465     }
466 
467     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
468         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
469         maxSellAmount = newNum * (10**18);
470         emit UpdatedMaxSellAmount(maxSellAmount);
471     }
472 
473     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
474         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
475         maxWalletAmount = newNum * (10**18);
476         emit UpdatedMaxWalletAmount(maxWalletAmount);
477     }
478 
479     // change the minimum amount of tokens to sell from fees
480     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
481   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
482   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
483   	    swapTokensAtAmount = newAmount;
484   	}
485 
486     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
487         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
488         emit MaxTransactionExclusion(updAds, isExcluded);
489     }
490 
491     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
492         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
493         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
494         for(uint256 i = 0; i < wallets.length; i++){
495             address wallet = wallets[i];
496             uint256 amount = amountsInTokens[i];
497             super._transfer(msg.sender, wallet, amount);
498         }
499     }
500 
501     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
502         if(!isEx){
503             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
504         }
505         _isExcludedMaxTransactionAmount[updAds] = isEx;
506     }
507 
508     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
509         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
510 
511         _setAutomatedMarketMakerPair(pair, value);
512         emit SetAutomatedMarketMakerPair(pair, value);
513     }
514 
515     function _setAutomatedMarketMakerPair(address pair, bool value) private {
516         automatedMarketMakerPairs[pair] = value;
517 
518         _excludeFromMaxTransaction(pair, value);
519 
520         emit SetAutomatedMarketMakerPair(pair, value);
521     }
522 
523     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
524         buyOperationsFee = _operationsFee;
525         buyLiquidityFee = _liquidityFee;
526         buyTotalFees = buyOperationsFee + buyLiquidityFee;
527         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
528     }
529 
530     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
531         sellOperationsFee = _operationsFee;
532         sellLiquidityFee = _liquidityFee;
533         sellTotalFees = sellOperationsFee + sellLiquidityFee;
534         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
535     }
536 
537     function excludeFromFees(address account, bool excluded) public onlyOwner {
538         _isExcludedFromFees[account] = excluded;
539         emit ExcludeFromFees(account, excluded);
540     }
541 
542     function _transfer(address from, address to, uint256 amount) internal override {
543 
544         require(from != address(0), "ERC20: transfer from the zero address");
545         require(to != address(0), "ERC20: transfer to the zero address");
546         require(amount > 0, "amount must be greater than 0");
547 
548         if(!tradingActive){
549             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
550         }
551 
552         require(!bot[from] && !bot[to], "Bots cannot transfer tokens in or out except to owner or dead address.");
553 
554         if(limitsInEffect){
555             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
556 
557                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
558                 if (transferDelayEnabled){
559                     if (to != address(dexRouter) && to != address(lpPair)){
560                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
561                         _holderLastTransferTimestamp[tx.origin] = block.number;
562                         _holderLastTransferTimestamp[to] = block.number;
563                     }
564                 }
565     
566                 //when buy
567                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
568                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
569                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
570                 }
571                 //when sell
572                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
573                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
574                 }
575                 else if (!_isExcludedMaxTransactionAmount[to]){
576                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
577                 }
578             }
579         }
580 
581         uint256 contractTokenBalance = balanceOf(address(this));
582 
583         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
584 
585         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
586             swapping = true;
587 
588             swapBack();
589 
590             swapping = false;
591         }
592 
593         bool takeFee = true;
594         // if any account belongs to _isExcludedFromFee account then remove the fee
595         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
596             takeFee = false;
597         }
598 
599         uint256 fees = 0;
600         // only take fees on buys/sells, do not take on wallet transfers
601         if(takeFee){
602             // on sell
603             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
604                 fees = amount * sellTotalFees / 100;
605                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
606                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
607             }
608 
609             // on buy
610             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
611         	    fees = amount * buyTotalFees / 100;
612         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
613                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
614             }
615 
616             if(fees > 0){
617                 super._transfer(from, address(this), fees);
618             }
619 
620         	amount -= fees;
621         }
622 
623         super._transfer(from, to, amount);
624     }
625     function swapTokensForEth(uint256 tokenAmount) private {
626 
627         // generate the uniswap pair path of token -> weth
628         address[] memory path = new address[](2);
629         path[0] = address(this);
630         path[1] = dexRouter.WETH();
631 
632         _approve(address(this), address(dexRouter), tokenAmount);
633 
634         // make the swap
635         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
636             tokenAmount,
637             0, // accept any amount of ETH
638             path,
639             address(this),
640             block.timestamp
641         );
642     }
643 
644     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
645         // approve token transfer to cover all possible scenarios
646         _approve(address(this), address(dexRouter), tokenAmount);
647 
648         // add the liquidity
649         dexRouter.addLiquidityETH{value: ethAmount}(
650             address(this),
651             tokenAmount,
652             0, // slippage is unavoidable
653             0, // slippage is unavoidable
654             address(0xdead),
655             block.timestamp
656         );
657     }
658 
659     function swapBack() private {
660         uint256 contractBalance = balanceOf(address(this));
661         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
662 
663         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
664 
665         if(contractBalance > swapTokensAtAmount * 60){
666             contractBalance = swapTokensAtAmount * 60;
667         }
668 
669         bool success;
670 
671         // Halve the amount of liquidity tokens
672         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
673 
674         swapTokensForEth(contractBalance - liquidityTokens);
675 
676         uint256 ethBalance = address(this).balance;
677         uint256 ethForLiquidity = ethBalance;
678 
679         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
680 
681         ethForLiquidity -= ethForOperations;
682 
683         tokensForLiquidity = 0;
684         tokensForOperations = 0;
685 
686         if(liquidityTokens > 0 && ethForLiquidity > 0){
687             addLiquidity(liquidityTokens, ethForLiquidity);
688         }
689 
690         if(address(this).balance > 0){
691             (success,) = address(operationsAddress).call{value: address(this).balance}("");
692         }
693     }
694 
695     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
696         require(_token != address(0), "_token address cannot be 0");
697         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
698         _sent = IERC20(_token).transfer(_to, _contractBalance);
699         emit TransferForeignToken(_token, _contractBalance);
700     }
701 
702     // withdraw ETH if stuck or someone sends to the address
703     function withdrawStuckETH() external onlyOwner {
704         bool success;
705         (success,) = address(msg.sender).call{value: address(this).balance}("");
706     }
707 
708     function setOperationsAddress(address _operationsAddress) external onlyOwner {
709         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
710         operationsAddress = payable(_operationsAddress);
711     }
712 
713     // force Swap back if slippage issues.
714     function forceSwapBack() external onlyOwner {
715         require(balanceOf(address(this)) >= 0, "No tokens to swap");
716         swapping = true;
717         swapBack();
718         swapping = false;
719         emit OwnerForcedSwapBack(block.timestamp);
720     }
721 
722 }