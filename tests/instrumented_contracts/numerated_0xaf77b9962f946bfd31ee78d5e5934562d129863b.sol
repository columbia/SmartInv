1 /**
2 
3 1/1 tax goes to PBZ, the artist behind of Dork Lord
4 
5 x.com/pbznft
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.17;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 contract ERC20 is Context, IERC20, IERC20Metadata {
117     mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     string private _name;
124     string private _symbol;
125 
126     constructor(string memory name_, string memory symbol_) {
127         _name = name_;
128         _symbol = symbol_;
129     }
130 
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public view virtual override returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view virtual override returns (uint8) {
140         return 18;
141     }
142 
143     function totalSupply() public view virtual override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     function balanceOf(address account) public view virtual override returns (uint256) {
148         return _balances[account];
149     }
150 
151     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     function allowance(address owner, address spender) public view virtual override returns (uint256) {
157         return _allowances[owner][spender];
158     }
159 
160     function approve(address spender, uint256 amount) public virtual override returns (bool) {
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164 
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) public virtual override returns (bool) {
170         _transfer(sender, recipient, amount);
171 
172         uint256 currentAllowance = _allowances[sender][_msgSender()];
173         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
174         unchecked {
175             _approve(sender, _msgSender(), currentAllowance - amount);
176         }
177 
178         return true;
179     }
180 
181     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
182         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
183         return true;
184     }
185 
186     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
187         uint256 currentAllowance = _allowances[_msgSender()][spender];
188         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
189         unchecked {
190             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
191         }
192 
193         return true;
194     }
195 
196     function _transfer(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) internal virtual {
201         require(sender != address(0), "ERC20: transfer from the zero address");
202         require(recipient != address(0), "ERC20: transfer to the zero address");
203 
204         uint256 senderBalance = _balances[sender];
205         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
206         unchecked {
207             _balances[sender] = senderBalance - amount;
208         }
209         _balances[recipient] += amount;
210 
211         emit Transfer(sender, recipient, amount);
212     }
213 
214     function _createInitialSupply(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: mint to the zero address");
216 
217         _totalSupply += amount;
218         _balances[account] += amount;
219         emit Transfer(address(0), account, amount);
220     }
221 
222     function _approve(
223         address owner,
224         address spender,
225         uint256 amount
226     ) internal virtual {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229 
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 }
234 
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239 
240     constructor () {
241         address msgSender = _msgSender();
242         _owner = msgSender;
243         emit OwnershipTransferred(address(0), msgSender);
244     }
245 
246     function owner() public view returns (address) {
247         return _owner;
248     }
249 
250     modifier onlyOwner() {
251         require(_owner == _msgSender(), "Ownable: caller is not the owner");
252         _;
253     }
254 
255     function renounceOwnership() external virtual onlyOwner {
256         emit OwnershipTransferred(_owner, address(0));
257         _owner = address(0);
258     }
259 
260     function transferOwnership(address newOwner) public virtual onlyOwner {
261         require(newOwner != address(0), "Ownable: new owner is the zero address");
262         emit OwnershipTransferred(_owner, newOwner);
263         _owner = newOwner;
264     }
265 }
266 
267 interface IDexRouter {
268     function factory() external pure returns (address);
269     function WETH() external pure returns (address);
270 
271     function swapExactTokensForETHSupportingFeeOnTransferTokens(
272         uint amountIn,
273         uint amountOutMin,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external;
278 
279     function swapExactETHForTokensSupportingFeeOnTransferTokens(
280         uint amountOutMin,
281         address[] calldata path,
282         address to,
283         uint deadline
284     ) external payable;
285 
286     function addLiquidityETH(
287         address token,
288         uint256 amountTokenDesired,
289         uint256 amountTokenMin,
290         uint256 amountETHMin,
291         address to,
292         uint256 deadline
293     )
294         external
295         payable
296         returns (
297             uint256 amountToken,
298             uint256 amountETH,
299             uint256 liquidity
300         );
301 }
302 
303 interface IDexFactory {
304     function createPair(address tokenA, address tokenB)
305         external
306         returns (address pair);
307 }
308 
309 contract PBZ is ERC20, Ownable {
310 
311     uint256 public maxBuyAmount;
312     uint256 public maxSellAmount;
313     uint256 public maxWalletAmount;
314 
315     IDexRouter public dexRouter;
316     address public lpPair;
317 
318     bool private swapping;
319     uint256 public swapTokensAtAmount;
320 
321     address operationsAddress;
322 
323     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
324     mapping (address => bool) public bot;
325     uint256 public botsCaught;
326 
327     bool public limitsInEffect = true;
328     bool public tradingActive = false;
329     bool public swapEnabled = false;
330 
331      // Anti-bot and anti-whale mappings and variables
332     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
333     bool public transferDelayEnabled = true;
334 
335     uint256 public buyTotalFees;
336     uint256 public buyOperationsFee;
337     uint256 public buyLiquidityFee;
338 
339     uint256 public sellTotalFees;
340     uint256 public sellOperationsFee;
341     uint256 public sellLiquidityFee;
342 
343     uint256 public tokensForOperations;
344     uint256 public tokensForLiquidity;
345 
346     /******************/
347 
348     // exlcude from fees and max transaction amount
349     mapping (address => bool) private _isExcludedFromFees;
350     mapping (address => bool) public _isExcludedMaxTransactionAmount;
351 
352     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
353     // could be subject to a maximum transfer amount
354     mapping (address => bool) public automatedMarketMakerPairs;
355 
356     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
357 
358     event EnabledTrading();
359 
360     event RemovedLimits();
361 
362     event ExcludeFromFees(address indexed account, bool isExcluded);
363 
364     event UpdatedMaxBuyAmount(uint256 newAmount);
365 
366     event UpdatedMaxSellAmount(uint256 newAmount);
367 
368     event UpdatedMaxWalletAmount(uint256 newAmount);
369 
370     event UpdatedOperationsAddress(address indexed newWallet);
371 
372     event MaxTransactionExclusion(address _address, bool excluded);
373 
374     event BuyBackTriggered(uint256 amount);
375 
376     event OwnerForcedSwapBack(uint256 timestamp);
377  
378     event CaughtEarlyBuyer(address sniper);
379 
380     event SwapAndLiquify(
381         uint256 tokensSwapped,
382         uint256 ethReceived,
383         uint256 tokensIntoLiquidity
384     );
385 
386     event TransferForeignToken(address token, uint256 amount);
387 
388     constructor() ERC20(unicode"pbz.eth", unicode"PBZ") {
389 
390         address newOwner = msg.sender; // can leave alone if owner is deployer.
391 
392         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
393         dexRouter = _dexRouter;
394 
395         // create pair
396         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
397         _excludeFromMaxTransaction(address(lpPair), true);
398         _setAutomatedMarketMakerPair(address(lpPair), true);
399 
400         uint256 totalSupply = 1 * 1e9 * 1e18;
401 
402         maxBuyAmount = totalSupply * 2 / 100;
403         maxSellAmount = totalSupply * 2 / 100;
404         maxWalletAmount = totalSupply * 2 / 100;
405         swapTokensAtAmount = totalSupply * 3 / 1000;
406 
407         buyOperationsFee = 25;
408         buyLiquidityFee = 0;
409         buyTotalFees = buyOperationsFee + buyLiquidityFee;
410 
411         sellOperationsFee = 25;
412         sellLiquidityFee = 0;
413         sellTotalFees = sellOperationsFee + sellLiquidityFee;
414 
415         _excludeFromMaxTransaction(newOwner, true);
416         _excludeFromMaxTransaction(address(this), true);
417         _excludeFromMaxTransaction(address(0xdead), true);
418 
419         excludeFromFees(newOwner, true);
420         excludeFromFees(address(this), true);
421         excludeFromFees(address(0xdead), true);
422 
423         operationsAddress = address(newOwner);
424 
425         _createInitialSupply(newOwner, totalSupply);
426         transferOwnership(newOwner);
427     }
428 
429     receive() external payable {}
430 
431     // only enable if no plan to airdrop
432 
433     function enableTrading() external onlyOwner {
434         require(!tradingActive, "Cannot reenable trading");
435         tradingActive = true;
436         swapEnabled = true;
437         tradingActiveBlock = block.number;
438         emit EnabledTrading();
439     }
440 
441     // remove limits after token is stable
442     function removeLimits() external onlyOwner {
443         limitsInEffect = false;
444         transferDelayEnabled = false;
445         emit RemovedLimits();
446     }
447 
448     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
449         bot[wallet] = flag;
450     }
451 
452     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
453         for(uint256 i = 0; i < wallets.length; i++){
454             bot[wallets[i]] = flag;
455         }
456     }
457 
458     // disable Transfer delay - cannot be reenabled
459     function disableTransferDelay() external onlyOwner {
460         transferDelayEnabled = false;
461     }
462 
463     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
464         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
465         maxBuyAmount = newNum * (10**18);
466         emit UpdatedMaxBuyAmount(maxBuyAmount);
467     }
468 
469     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
470         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
471         maxSellAmount = newNum * (10**18);
472         emit UpdatedMaxSellAmount(maxSellAmount);
473     }
474 
475     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
476         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
477         maxWalletAmount = newNum * (10**18);
478         emit UpdatedMaxWalletAmount(maxWalletAmount);
479     }
480 
481     // change the minimum amount of tokens to sell from fees
482     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
483   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
484   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
485   	    swapTokensAtAmount = newAmount;
486   	}
487 
488     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
489         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
490         emit MaxTransactionExclusion(updAds, isExcluded);
491     }
492 
493     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
494         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
495         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
496         for(uint256 i = 0; i < wallets.length; i++){
497             address wallet = wallets[i];
498             uint256 amount = amountsInTokens[i];
499             super._transfer(msg.sender, wallet, amount);
500         }
501     }
502 
503     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
504         if(!isEx){
505             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
506         }
507         _isExcludedMaxTransactionAmount[updAds] = isEx;
508     }
509 
510     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
511         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
512 
513         _setAutomatedMarketMakerPair(pair, value);
514         emit SetAutomatedMarketMakerPair(pair, value);
515     }
516 
517     function _setAutomatedMarketMakerPair(address pair, bool value) private {
518         automatedMarketMakerPairs[pair] = value;
519 
520         _excludeFromMaxTransaction(pair, value);
521 
522         emit SetAutomatedMarketMakerPair(pair, value);
523     }
524 
525     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
526         buyOperationsFee = _operationsFee;
527         buyLiquidityFee = _liquidityFee;
528         buyTotalFees = buyOperationsFee + buyLiquidityFee;
529         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
530     }
531 
532     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
533         sellOperationsFee = _operationsFee;
534         sellLiquidityFee = _liquidityFee;
535         sellTotalFees = sellOperationsFee + sellLiquidityFee;
536         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
537     }
538 
539     function excludeFromFees(address account, bool excluded) public onlyOwner {
540         _isExcludedFromFees[account] = excluded;
541         emit ExcludeFromFees(account, excluded);
542     }
543 
544     function _transfer(address from, address to, uint256 amount) internal override {
545 
546         require(from != address(0), "ERC20: transfer from the zero address");
547         require(to != address(0), "ERC20: transfer to the zero address");
548         require(amount > 0, "amount must be greater than 0");
549 
550         if(!tradingActive){
551             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
552         }
553 
554         require(!bot[from] && !bot[to], "Bots cannot transfer tokens in or out except to owner or dead address.");
555 
556         if(limitsInEffect){
557             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
558 
559                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
560                 if (transferDelayEnabled){
561                     if (to != address(dexRouter) && to != address(lpPair)){
562                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
563                         _holderLastTransferTimestamp[tx.origin] = block.number;
564                         _holderLastTransferTimestamp[to] = block.number;
565                     }
566                 }
567     
568                 //when buy
569                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
570                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
571                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
572                 }
573                 //when sell
574                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
575                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
576                 }
577                 else if (!_isExcludedMaxTransactionAmount[to]){
578                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
579                 }
580             }
581         }
582 
583         uint256 contractTokenBalance = balanceOf(address(this));
584 
585         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
586 
587         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
588             swapping = true;
589 
590             swapBack();
591 
592             swapping = false;
593         }
594 
595         bool takeFee = true;
596         // if any account belongs to _isExcludedFromFee account then remove the fee
597         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
598             takeFee = false;
599         }
600 
601         uint256 fees = 0;
602         // only take fees on buys/sells, do not take on wallet transfers
603         if(takeFee){
604             // on sell
605             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
606                 fees = amount * sellTotalFees / 100;
607                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
608                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
609             }
610 
611             // on buy
612             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
613         	    fees = amount * buyTotalFees / 100;
614         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
615                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
616             }
617 
618             if(fees > 0){
619                 super._transfer(from, address(this), fees);
620             }
621 
622         	amount -= fees;
623         }
624 
625         super._transfer(from, to, amount);
626     }
627     function swapTokensForEth(uint256 tokenAmount) private {
628 
629         // generate the uniswap pair path of token -> weth
630         address[] memory path = new address[](2);
631         path[0] = address(this);
632         path[1] = dexRouter.WETH();
633 
634         _approve(address(this), address(dexRouter), tokenAmount);
635 
636         // make the swap
637         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
638             tokenAmount,
639             0, // accept any amount of ETH
640             path,
641             address(this),
642             block.timestamp
643         );
644     }
645 
646     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
647         // approve token transfer to cover all possible scenarios
648         _approve(address(this), address(dexRouter), tokenAmount);
649 
650         // add the liquidity
651         dexRouter.addLiquidityETH{value: ethAmount}(
652             address(this),
653             tokenAmount,
654             0, // slippage is unavoidable
655             0, // slippage is unavoidable
656             address(0xdead),
657             block.timestamp
658         );
659     }
660 
661     function swapBack() private {
662         uint256 contractBalance = balanceOf(address(this));
663         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
664 
665         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
666 
667         if(contractBalance > swapTokensAtAmount * 60){
668             contractBalance = swapTokensAtAmount * 60;
669         }
670 
671         bool success;
672 
673         // Halve the amount of liquidity tokens
674         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
675 
676         swapTokensForEth(contractBalance - liquidityTokens);
677 
678         uint256 ethBalance = address(this).balance;
679         uint256 ethForLiquidity = ethBalance;
680 
681         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
682 
683         ethForLiquidity -= ethForOperations;
684 
685         tokensForLiquidity = 0;
686         tokensForOperations = 0;
687 
688         if(liquidityTokens > 0 && ethForLiquidity > 0){
689             addLiquidity(liquidityTokens, ethForLiquidity);
690         }
691 
692         if(address(this).balance > 0){
693             (success,) = address(operationsAddress).call{value: address(this).balance}("");
694         }
695     }
696 
697     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
698         require(_token != address(0), "_token address cannot be 0");
699         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
700         _sent = IERC20(_token).transfer(_to, _contractBalance);
701         emit TransferForeignToken(_token, _contractBalance);
702     }
703 
704     // withdraw ETH if stuck or someone sends to the address
705     function withdrawStuckETH() external onlyOwner {
706         bool success;
707         (success,) = address(msg.sender).call{value: address(this).balance}("");
708     }
709 
710     function setOperationsAddress(address _operationsAddress) external onlyOwner {
711         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
712         operationsAddress = payable(_operationsAddress);
713     }
714 
715     // force Swap back if slippage issues.
716     function forceSwapBack() external onlyOwner {
717         require(balanceOf(address(this)) >= 0, "No tokens to swap");
718         swapping = true;
719         swapBack();
720         swapping = false;
721         emit OwnerForcedSwapBack(block.timestamp);
722     }
723 
724 }