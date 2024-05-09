1 /**
2 
3 ###  ##  ##  ##    ## ##   ### ###  
4   ## ##  ##  ##   ##   ##   ##  ##  
5  # ## #  ##  ##   ####      ##      
6  ## ##    ## ##    #####    ## ##   
7  ##  ##    ##         ###   ##      
8  ##  ##    ##     ##   ##   ##  ##  
9 ###  ##    ##      ## ##   ### ###  
10                                     
11  ## ###   ## ##       ##   ## ##     ## ##   
12 ##   ##   #   ##    # ##   ##  ##   ##   ##  
13 ##       ##   ##   ## ##       ##   ##   ##  
14 ## ###    ## ###  ##  ##      ##    ##   ##  
15 ##   ##       ##  ### ###    ##     ##   ##  
16 ##   ##  ##   ##      ##    #   ##  ##   ##  
17  ## ##    ## ##       ##   ######    ## ##   
18                                             
19 
20 
21 Telegram: https://t.me/nyse69420 
22 Website: https://www.nyse69420.xyz/
23 Twitter: https://twitter.com/NYSE69420 
24 
25 */
26 
27 // SPDX-License-Identifier: MIT
28 
29 pragma solidity 0.8.17;
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
38         return msg.data;
39     }
40 }
41 
42 interface IERC20 {
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `recipient`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address sender,
98         address recipient,
99         uint256 amount
100     ) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 interface IERC20Metadata is IERC20 {
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() external view returns (string memory);
122 
123     /**
124      * @dev Returns the symbol of the token.
125      */
126     function symbol() external view returns (string memory);
127 
128     /**
129      * @dev Returns the decimals places of the token.
130      */
131     function decimals() external view returns (uint8);
132 }
133 
134 contract ERC20 is Context, IERC20, IERC20Metadata {
135     mapping(address => uint256) private _balances;
136 
137     mapping(address => mapping(address => uint256)) private _allowances;
138 
139     uint256 private _totalSupply;
140 
141     string private _name;
142     string private _symbol;
143 
144     constructor(string memory name_, string memory symbol_) {
145         _name = name_;
146         _symbol = symbol_;
147     }
148 
149     function name() public view virtual override returns (string memory) {
150         return _name;
151     }
152 
153     function symbol() public view virtual override returns (string memory) {
154         return _symbol;
155     }
156 
157     function decimals() public view virtual override returns (uint8) {
158         return 18;
159     }
160 
161     function totalSupply() public view virtual override returns (uint256) {
162         return _totalSupply;
163     }
164 
165     function balanceOf(address account) public view virtual override returns (uint256) {
166         return _balances[account];
167     }
168 
169     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
170         _transfer(_msgSender(), recipient, amount);
171         return true;
172     }
173 
174     function allowance(address owner, address spender) public view virtual override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     function approve(address spender, uint256 amount) public virtual override returns (bool) {
179         _approve(_msgSender(), spender, amount);
180         return true;
181     }
182 
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) public virtual override returns (bool) {
188         _transfer(sender, recipient, amount);
189 
190         uint256 currentAllowance = _allowances[sender][_msgSender()];
191         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
192         unchecked {
193             _approve(sender, _msgSender(), currentAllowance - amount);
194         }
195 
196         return true;
197     }
198 
199     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
200         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
201         return true;
202     }
203 
204     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
205         uint256 currentAllowance = _allowances[_msgSender()][spender];
206         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
207         unchecked {
208             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
209         }
210 
211         return true;
212     }
213 
214     function _transfer(
215         address sender,
216         address recipient,
217         uint256 amount
218     ) internal virtual {
219         require(sender != address(0), "ERC20: transfer from the zero address");
220         require(recipient != address(0), "ERC20: transfer to the zero address");
221 
222         uint256 senderBalance = _balances[sender];
223         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
224         unchecked {
225             _balances[sender] = senderBalance - amount;
226         }
227         _balances[recipient] += amount;
228 
229         emit Transfer(sender, recipient, amount);
230     }
231 
232     function _createInitialSupply(address account, uint256 amount) internal virtual {
233         require(account != address(0), "ERC20: mint to the zero address");
234 
235         _totalSupply += amount;
236         _balances[account] += amount;
237         emit Transfer(address(0), account, amount);
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
327 contract NYSE69420 is ERC20, Ownable {
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
340 
341     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
342     mapping (address => bool) public bot;
343     uint256 public botsCaught;
344 
345     bool public limitsInEffect = true;
346     bool public tradingActive = false;
347     bool public swapEnabled = false;
348 
349      // Anti-bot and anti-whale mappings and variables
350     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
351     bool public transferDelayEnabled = true;
352 
353     uint256 public buyTotalFees;
354     uint256 public buyOperationsFee;
355     uint256 public buyLiquidityFee;
356 
357     uint256 public sellTotalFees;
358     uint256 public sellOperationsFee;
359     uint256 public sellLiquidityFee;
360 
361     uint256 public tokensForOperations;
362     uint256 public tokensForLiquidity;
363 
364     /******************/
365 
366     // exlcude from fees and max transaction amount
367     mapping (address => bool) private _isExcludedFromFees;
368     mapping (address => bool) public _isExcludedMaxTransactionAmount;
369 
370     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
371     // could be subject to a maximum transfer amount
372     mapping (address => bool) public automatedMarketMakerPairs;
373 
374     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
375 
376     event EnabledTrading();
377 
378     event RemovedLimits();
379 
380     event ExcludeFromFees(address indexed account, bool isExcluded);
381 
382     event UpdatedMaxBuyAmount(uint256 newAmount);
383 
384     event UpdatedMaxSellAmount(uint256 newAmount);
385 
386     event UpdatedMaxWalletAmount(uint256 newAmount);
387 
388     event UpdatedOperationsAddress(address indexed newWallet);
389 
390     event MaxTransactionExclusion(address _address, bool excluded);
391 
392     event BuyBackTriggered(uint256 amount);
393 
394     event OwnerForcedSwapBack(uint256 timestamp);
395  
396     event CaughtEarlyBuyer(address sniper);
397 
398     event SwapAndLiquify(
399         uint256 tokensSwapped,
400         uint256 ethReceived,
401         uint256 tokensIntoLiquidity
402     );
403 
404     event TransferForeignToken(address token, uint256 amount);
405 
406     constructor() ERC20(unicode"NYSE69420", unicode"NYSE") {
407 
408         address newOwner = msg.sender; // can leave alone if owner is deployer.
409 
410         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
411         dexRouter = _dexRouter;
412 
413         // create pair
414         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
415         _excludeFromMaxTransaction(address(lpPair), true);
416         _setAutomatedMarketMakerPair(address(lpPair), true);
417 
418         uint256 totalSupply = 1 * 1e9 * 1e18;
419 
420         maxBuyAmount = totalSupply * 2 / 100;
421         maxSellAmount = totalSupply * 2 / 100;
422         maxWalletAmount = totalSupply * 2 / 100;
423         swapTokensAtAmount = totalSupply * 1 / 1000;
424 
425         buyOperationsFee = 30;
426         buyLiquidityFee = 0;
427         buyTotalFees = buyOperationsFee + buyLiquidityFee;
428 
429         sellOperationsFee = 30;
430         sellLiquidityFee = 0;
431         sellTotalFees = sellOperationsFee + sellLiquidityFee;
432 
433         _excludeFromMaxTransaction(newOwner, true);
434         _excludeFromMaxTransaction(address(this), true);
435         _excludeFromMaxTransaction(address(0xdead), true);
436 
437         excludeFromFees(newOwner, true);
438         excludeFromFees(address(this), true);
439         excludeFromFees(address(0xdead), true);
440 
441         operationsAddress = address(newOwner);
442 
443         _createInitialSupply(newOwner, totalSupply);
444         transferOwnership(newOwner);
445     }
446 
447     receive() external payable {}
448 
449     // only enable if no plan to airdrop
450 
451     function enableTrading() external onlyOwner {
452         require(!tradingActive, "Cannot reenable trading");
453         tradingActive = true;
454         swapEnabled = true;
455         tradingActiveBlock = block.number;
456         emit EnabledTrading();
457     }
458 
459     // remove limits after token is stable
460     function removeLimits() external onlyOwner {
461         limitsInEffect = false;
462         transferDelayEnabled = false;
463         emit RemovedLimits();
464     }
465 
466     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
467         bot[wallet] = flag;
468     }
469 
470     // disable Transfer delay - cannot be reenabled
471     function disableTransferDelay() external onlyOwner {
472         transferDelayEnabled = false;
473     }
474 
475     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
476         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
477         maxBuyAmount = newNum * (10**18);
478         emit UpdatedMaxBuyAmount(maxBuyAmount);
479     }
480 
481     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
482         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
483         maxSellAmount = newNum * (10**18);
484         emit UpdatedMaxSellAmount(maxSellAmount);
485     }
486 
487     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
488         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
489         maxWalletAmount = newNum * (10**18);
490         emit UpdatedMaxWalletAmount(maxWalletAmount);
491     }
492 
493     // change the minimum amount of tokens to sell from fees
494     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
495   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
496   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
497   	    swapTokensAtAmount = newAmount;
498   	}
499 
500     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
501         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
502         emit MaxTransactionExclusion(updAds, isExcluded);
503     }
504 
505     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
506         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
507         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
508         for(uint256 i = 0; i < wallets.length; i++){
509             address wallet = wallets[i];
510             uint256 amount = amountsInTokens[i];
511             super._transfer(msg.sender, wallet, amount);
512         }
513     }
514 
515     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
516         if(!isEx){
517             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
518         }
519         _isExcludedMaxTransactionAmount[updAds] = isEx;
520     }
521 
522     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
523         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
524 
525         _setAutomatedMarketMakerPair(pair, value);
526         emit SetAutomatedMarketMakerPair(pair, value);
527     }
528 
529     function _setAutomatedMarketMakerPair(address pair, bool value) private {
530         automatedMarketMakerPairs[pair] = value;
531 
532         _excludeFromMaxTransaction(pair, value);
533 
534         emit SetAutomatedMarketMakerPair(pair, value);
535     }
536 
537     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
538         buyOperationsFee = _operationsFee;
539         buyLiquidityFee = _liquidityFee;
540         buyTotalFees = buyOperationsFee + buyLiquidityFee;
541         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
542     }
543 
544     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
545         sellOperationsFee = _operationsFee;
546         sellLiquidityFee = _liquidityFee;
547         sellTotalFees = sellOperationsFee + sellLiquidityFee;
548         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
549     }
550 
551     function excludeFromFees(address account, bool excluded) public onlyOwner {
552         _isExcludedFromFees[account] = excluded;
553         emit ExcludeFromFees(account, excluded);
554     }
555 
556     function _transfer(address from, address to, uint256 amount) internal override {
557 
558         require(from != address(0), "ERC20: transfer from the zero address");
559         require(to != address(0), "ERC20: transfer to the zero address");
560         require(amount > 0, "amount must be greater than 0");
561 
562         if(!tradingActive){
563             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
564         }
565 
566         require(!bot[from] && !bot[to], "Bots cannot transfer tokens in or out except to owner or dead address.");
567 
568         if(limitsInEffect){
569             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
570 
571                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
572                 if (transferDelayEnabled){
573                     if (to != address(dexRouter) && to != address(lpPair)){
574                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
575                         _holderLastTransferTimestamp[tx.origin] = block.number;
576                         _holderLastTransferTimestamp[to] = block.number;
577                     }
578                 }
579     
580                 //when buy
581                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
582                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
583                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
584                 }
585                 //when sell
586                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
587                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
588                 }
589                 else if (!_isExcludedMaxTransactionAmount[to]){
590                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
591                 }
592             }
593         }
594 
595         uint256 contractTokenBalance = balanceOf(address(this));
596 
597         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
598 
599         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
600             swapping = true;
601 
602             swapBack();
603 
604             swapping = false;
605         }
606 
607         bool takeFee = true;
608         // if any account belongs to _isExcludedFromFee account then remove the fee
609         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
610             takeFee = false;
611         }
612 
613         uint256 fees = 0;
614         // only take fees on buys/sells, do not take on wallet transfers
615         if(takeFee){
616             // on sell
617             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
618                 fees = amount * sellTotalFees / 100;
619                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
620                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
621             }
622 
623             // on buy
624             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
625         	    fees = amount * buyTotalFees / 100;
626         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
627                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
628             }
629 
630             if(fees > 0){
631                 super._transfer(from, address(this), fees);
632             }
633 
634         	amount -= fees;
635         }
636 
637         super._transfer(from, to, amount);
638     }
639     function swapTokensForEth(uint256 tokenAmount) private {
640 
641         // generate the uniswap pair path of token -> weth
642         address[] memory path = new address[](2);
643         path[0] = address(this);
644         path[1] = dexRouter.WETH();
645 
646         _approve(address(this), address(dexRouter), tokenAmount);
647 
648         // make the swap
649         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
650             tokenAmount,
651             0, // accept any amount of ETH
652             path,
653             address(this),
654             block.timestamp
655         );
656     }
657 
658     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
659         // approve token transfer to cover all possible scenarios
660         _approve(address(this), address(dexRouter), tokenAmount);
661 
662         // add the liquidity
663         dexRouter.addLiquidityETH{value: ethAmount}(
664             address(this),
665             tokenAmount,
666             0, // slippage is unavoidable
667             0, // slippage is unavoidable
668             address(0xdead),
669             block.timestamp
670         );
671     }
672 
673     function swapBack() private {
674         uint256 contractBalance = balanceOf(address(this));
675         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
676 
677         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
678 
679         if(contractBalance > swapTokensAtAmount * 60){
680             contractBalance = swapTokensAtAmount * 60;
681         }
682 
683         bool success;
684 
685         // Halve the amount of liquidity tokens
686         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
687 
688         swapTokensForEth(contractBalance - liquidityTokens);
689 
690         uint256 ethBalance = address(this).balance;
691         uint256 ethForLiquidity = ethBalance;
692 
693         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
694 
695         ethForLiquidity -= ethForOperations;
696 
697         tokensForLiquidity = 0;
698         tokensForOperations = 0;
699 
700         if(liquidityTokens > 0 && ethForLiquidity > 0){
701             addLiquidity(liquidityTokens, ethForLiquidity);
702         }
703 
704         if(address(this).balance > 0){
705             (success,) = address(operationsAddress).call{value: address(this).balance}("");
706         }
707     }
708 
709     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
710         require(_token != address(0), "_token address cannot be 0");
711         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
712         _sent = IERC20(_token).transfer(_to, _contractBalance);
713         emit TransferForeignToken(_token, _contractBalance);
714     }
715 
716     // withdraw ETH if stuck or someone sends to the address
717     function withdrawStuckETH() external onlyOwner {
718         bool success;
719         (success,) = address(msg.sender).call{value: address(this).balance}("");
720     }
721 
722     function setOperationsAddress(address _operationsAddress) external onlyOwner {
723         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
724         operationsAddress = payable(_operationsAddress);
725     }
726 
727     // force Swap back if slippage issues.
728     function forceSwapBack() external onlyOwner {
729         require(balanceOf(address(this)) >= 0, "No tokens to swap");
730         swapping = true;
731         swapBack();
732         swapping = false;
733         emit OwnerForcedSwapBack(block.timestamp);
734     }
735 
736 }