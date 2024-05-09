1 /**
2 
3 Web: greatestpepe.net  
4 
5 X: https://twitter.com/greatest_pepe 
6 
7 TG: https://t.me/Greatest_Pepe
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.17;
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
224     function _approve(
225         address owner,
226         address spender,
227         uint256 amount
228     ) internal virtual {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231 
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 }
236 
237 contract Ownable is Context {
238     address private _owner;
239 
240     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
241 
242     constructor () {
243         address msgSender = _msgSender();
244         _owner = msgSender;
245         emit OwnershipTransferred(address(0), msgSender);
246     }
247 
248     function owner() public view returns (address) {
249         return _owner;
250     }
251 
252     modifier onlyOwner() {
253         require(_owner == _msgSender(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257     function renounceOwnership() external virtual onlyOwner {
258         emit OwnershipTransferred(_owner, address(0));
259         _owner = address(0);
260     }
261 
262     function transferOwnership(address newOwner) public virtual onlyOwner {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         emit OwnershipTransferred(_owner, newOwner);
265         _owner = newOwner;
266     }
267 }
268 
269 interface IDexRouter {
270     function factory() external pure returns (address);
271     function WETH() external pure returns (address);
272 
273     function swapExactTokensForETHSupportingFeeOnTransferTokens(
274         uint amountIn,
275         uint amountOutMin,
276         address[] calldata path,
277         address to,
278         uint deadline
279     ) external;
280 
281     function swapExactETHForTokensSupportingFeeOnTransferTokens(
282         uint amountOutMin,
283         address[] calldata path,
284         address to,
285         uint deadline
286     ) external payable;
287 
288     function addLiquidityETH(
289         address token,
290         uint256 amountTokenDesired,
291         uint256 amountTokenMin,
292         uint256 amountETHMin,
293         address to,
294         uint256 deadline
295     )
296         external
297         payable
298         returns (
299             uint256 amountToken,
300             uint256 amountETH,
301             uint256 liquidity
302         );
303 }
304 
305 interface IDexFactory {
306     function createPair(address tokenA, address tokenB)
307         external
308         returns (address pair);
309 }
310 
311 contract greatestpepe is ERC20, Ownable {
312 
313     uint256 public maxBuyAmount;
314     uint256 public maxSellAmount;
315     uint256 public maxWalletAmount;
316 
317     IDexRouter public dexRouter;
318     address public lpPair;
319 
320     bool private swapping;
321     uint256 public swapTokensAtAmount;
322 
323     address operationsAddress;
324 
325     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
326     mapping (address => bool) public bot;
327     uint256 public botsCaught;
328 
329     bool public limitsInEffect = true;
330     bool public tradingActive = false;
331     bool public swapEnabled = false;
332 
333      // Anti-bot and anti-whale mappings and variables
334     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
335     bool public transferDelayEnabled = true;
336 
337     uint256 public buyTotalFees;
338     uint256 public buyOperationsFee;
339     uint256 public buyLiquidityFee;
340 
341     uint256 public sellTotalFees;
342     uint256 public sellOperationsFee;
343     uint256 public sellLiquidityFee;
344 
345     uint256 public tokensForOperations;
346     uint256 public tokensForLiquidity;
347 
348     /******************/
349 
350     // exlcude from fees and max transaction amount
351     mapping (address => bool) private _isExcludedFromFees;
352     mapping (address => bool) public _isExcludedMaxTransactionAmount;
353 
354     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
355     // could be subject to a maximum transfer amount
356     mapping (address => bool) public automatedMarketMakerPairs;
357 
358     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
359 
360     event EnabledTrading();
361 
362     event RemovedLimits();
363 
364     event ExcludeFromFees(address indexed account, bool isExcluded);
365 
366     event UpdatedMaxBuyAmount(uint256 newAmount);
367 
368     event UpdatedMaxSellAmount(uint256 newAmount);
369 
370     event UpdatedMaxWalletAmount(uint256 newAmount);
371 
372     event UpdatedOperationsAddress(address indexed newWallet);
373 
374     event MaxTransactionExclusion(address _address, bool excluded);
375 
376     event BuyBackTriggered(uint256 amount);
377 
378     event OwnerForcedSwapBack(uint256 timestamp);
379  
380     event CaughtEarlyBuyer(address sniper);
381 
382     event SwapAndLiquify(
383         uint256 tokensSwapped,
384         uint256 ethReceived,
385         uint256 tokensIntoLiquidity
386     );
387 
388     event TransferForeignToken(address token, uint256 amount);
389 
390     constructor() ERC20(unicode"ǤREAͳESͳ PΞPΞ", unicode"GPEPE") {
391 
392         address newOwner = msg.sender; // can leave alone if owner is deployer.
393 
394         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
395         dexRouter = _dexRouter;
396 
397         // create pair
398         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
399         _excludeFromMaxTransaction(address(lpPair), true);
400         _setAutomatedMarketMakerPair(address(lpPair), true);
401 
402         uint256 totalSupply = 1 * 1e9 * 1e18;
403 
404         maxBuyAmount = totalSupply * 2 / 100;
405         maxSellAmount = totalSupply * 2 / 100;
406         maxWalletAmount = totalSupply * 2 / 100;
407         swapTokensAtAmount = totalSupply * 1 / 1000;
408 
409         buyOperationsFee = 20;
410         buyLiquidityFee = 0;
411         buyTotalFees = buyOperationsFee + buyLiquidityFee;
412 
413         sellOperationsFee = 20;
414         sellLiquidityFee = 0;
415         sellTotalFees = sellOperationsFee + sellLiquidityFee;
416 
417         _excludeFromMaxTransaction(newOwner, true);
418         _excludeFromMaxTransaction(address(this), true);
419         _excludeFromMaxTransaction(address(0xdead), true);
420 
421         excludeFromFees(newOwner, true);
422         excludeFromFees(address(this), true);
423         excludeFromFees(address(0xdead), true);
424 
425         operationsAddress = address(newOwner);
426 
427         _createInitialSupply(newOwner, totalSupply);
428         transferOwnership(newOwner);
429     }
430 
431     receive() external payable {}
432 
433     // only enable if no plan to airdrop
434 
435     function enableTrading() external onlyOwner {
436         require(!tradingActive, "Cannot reenable trading");
437         tradingActive = true;
438         swapEnabled = true;
439         tradingActiveBlock = block.number;
440         emit EnabledTrading();
441     }
442 
443     // remove limits after token is stable
444     function removeLimits() external onlyOwner {
445         limitsInEffect = false;
446         transferDelayEnabled = false;
447         emit RemovedLimits();
448     }
449 
450     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
451         bot[wallet] = flag;
452     }
453 
454     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
455         for(uint256 i = 0; i < wallets.length; i++){
456             bot[wallets[i]] = flag;
457         }
458     }
459 
460     // disable Transfer delay - cannot be reenabled
461     function disableTransferDelay() external onlyOwner {
462         transferDelayEnabled = false;
463     }
464 
465     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
466         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
467         maxBuyAmount = newNum * (10**18);
468         emit UpdatedMaxBuyAmount(maxBuyAmount);
469     }
470 
471     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
472         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
473         maxSellAmount = newNum * (10**18);
474         emit UpdatedMaxSellAmount(maxSellAmount);
475     }
476 
477     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
478         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
479         maxWalletAmount = newNum * (10**18);
480         emit UpdatedMaxWalletAmount(maxWalletAmount);
481     }
482 
483     // change the minimum amount of tokens to sell from fees
484     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
485   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
486   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
487   	    swapTokensAtAmount = newAmount;
488   	}
489 
490     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
491         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
492         emit MaxTransactionExclusion(updAds, isExcluded);
493     }
494 
495     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
496         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
497         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
498         for(uint256 i = 0; i < wallets.length; i++){
499             address wallet = wallets[i];
500             uint256 amount = amountsInTokens[i];
501             super._transfer(msg.sender, wallet, amount);
502         }
503     }
504 
505     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
506         if(!isEx){
507             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
508         }
509         _isExcludedMaxTransactionAmount[updAds] = isEx;
510     }
511 
512     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
513         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
514 
515         _setAutomatedMarketMakerPair(pair, value);
516         emit SetAutomatedMarketMakerPair(pair, value);
517     }
518 
519     function _setAutomatedMarketMakerPair(address pair, bool value) private {
520         automatedMarketMakerPairs[pair] = value;
521 
522         _excludeFromMaxTransaction(pair, value);
523 
524         emit SetAutomatedMarketMakerPair(pair, value);
525     }
526 
527     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
528         buyOperationsFee = _operationsFee;
529         buyLiquidityFee = _liquidityFee;
530         buyTotalFees = buyOperationsFee + buyLiquidityFee;
531         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
532     }
533 
534     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
535         sellOperationsFee = _operationsFee;
536         sellLiquidityFee = _liquidityFee;
537         sellTotalFees = sellOperationsFee + sellLiquidityFee;
538         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
539     }
540 
541     function excludeFromFees(address account, bool excluded) public onlyOwner {
542         _isExcludedFromFees[account] = excluded;
543         emit ExcludeFromFees(account, excluded);
544     }
545 
546     function _transfer(address from, address to, uint256 amount) internal override {
547 
548         require(from != address(0), "ERC20: transfer from the zero address");
549         require(to != address(0), "ERC20: transfer to the zero address");
550         require(amount > 0, "amount must be greater than 0");
551 
552         if(!tradingActive){
553             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
554         }
555 
556         require(!bot[from] && !bot[to], "Bots cannot transfer tokens in or out except to owner or dead address.");
557 
558         if(limitsInEffect){
559             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
560 
561                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
562                 if (transferDelayEnabled){
563                     if (to != address(dexRouter) && to != address(lpPair)){
564                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
565                         _holderLastTransferTimestamp[tx.origin] = block.number;
566                         _holderLastTransferTimestamp[to] = block.number;
567                     }
568                 }
569     
570                 //when buy
571                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
572                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
573                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
574                 }
575                 //when sell
576                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
577                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
578                 }
579                 else if (!_isExcludedMaxTransactionAmount[to]){
580                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
581                 }
582             }
583         }
584 
585         uint256 contractTokenBalance = balanceOf(address(this));
586 
587         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
588 
589         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
590             swapping = true;
591 
592             swapBack();
593 
594             swapping = false;
595         }
596 
597         bool takeFee = true;
598         // if any account belongs to _isExcludedFromFee account then remove the fee
599         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
600             takeFee = false;
601         }
602 
603         uint256 fees = 0;
604         // only take fees on buys/sells, do not take on wallet transfers
605         if(takeFee){
606             // on sell
607             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
608                 fees = amount * sellTotalFees / 100;
609                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
610                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
611             }
612 
613             // on buy
614             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
615         	    fees = amount * buyTotalFees / 100;
616         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
617                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
618             }
619 
620             if(fees > 0){
621                 super._transfer(from, address(this), fees);
622             }
623 
624         	amount -= fees;
625         }
626 
627         super._transfer(from, to, amount);
628     }
629     function swapTokensForEth(uint256 tokenAmount) private {
630 
631         // generate the uniswap pair path of token -> weth
632         address[] memory path = new address[](2);
633         path[0] = address(this);
634         path[1] = dexRouter.WETH();
635 
636         _approve(address(this), address(dexRouter), tokenAmount);
637 
638         // make the swap
639         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
640             tokenAmount,
641             0, // accept any amount of ETH
642             path,
643             address(this),
644             block.timestamp
645         );
646     }
647 
648     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
649         // approve token transfer to cover all possible scenarios
650         _approve(address(this), address(dexRouter), tokenAmount);
651 
652         // add the liquidity
653         dexRouter.addLiquidityETH{value: ethAmount}(
654             address(this),
655             tokenAmount,
656             0, // slippage is unavoidable
657             0, // slippage is unavoidable
658             address(0xdead),
659             block.timestamp
660         );
661     }
662 
663     function swapBack() private {
664         uint256 contractBalance = balanceOf(address(this));
665         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
666 
667         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
668 
669         if(contractBalance > swapTokensAtAmount * 60){
670             contractBalance = swapTokensAtAmount * 60;
671         }
672 
673         bool success;
674 
675         // Halve the amount of liquidity tokens
676         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
677 
678         swapTokensForEth(contractBalance - liquidityTokens);
679 
680         uint256 ethBalance = address(this).balance;
681         uint256 ethForLiquidity = ethBalance;
682 
683         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
684 
685         ethForLiquidity -= ethForOperations;
686 
687         tokensForLiquidity = 0;
688         tokensForOperations = 0;
689 
690         if(liquidityTokens > 0 && ethForLiquidity > 0){
691             addLiquidity(liquidityTokens, ethForLiquidity);
692         }
693 
694         if(address(this).balance > 0){
695             (success,) = address(operationsAddress).call{value: address(this).balance}("");
696         }
697     }
698 
699     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
700         require(_token != address(0), "_token address cannot be 0");
701         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
702         _sent = IERC20(_token).transfer(_to, _contractBalance);
703         emit TransferForeignToken(_token, _contractBalance);
704     }
705 
706     // withdraw ETH if stuck or someone sends to the address
707     function withdrawStuckETH() external onlyOwner {
708         bool success;
709         (success,) = address(msg.sender).call{value: address(this).balance}("");
710     }
711 
712     function setOperationsAddress(address _operationsAddress) external onlyOwner {
713         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
714         operationsAddress = payable(_operationsAddress);
715     }
716 
717     // force Swap back if slippage issues.
718     function forceSwapBack() external onlyOwner {
719         require(balanceOf(address(this)) >= 0, "No tokens to swap");
720         swapping = true;
721         swapBack();
722         swapping = false;
723         emit OwnerForcedSwapBack(block.timestamp);
724     }
725 
726 }