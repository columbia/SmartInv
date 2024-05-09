1 /**
2 
3 https://twitter.com/beeple/status/1702879431373578513?t=R-ZfBJQZHoNVVpK8bBbxcw&s=19
4 */
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.17;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns (string memory);
101 
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns (string memory);
106 
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns (uint8);
111 }
112 
113 contract ERC20 is Context, IERC20, IERC20Metadata {
114     mapping(address => uint256) private _balances;
115 
116     mapping(address => mapping(address => uint256)) private _allowances;
117 
118     uint256 private _totalSupply;
119 
120     string private _name;
121     string private _symbol;
122 
123     constructor(string memory name_, string memory symbol_) {
124         _name = name_;
125         _symbol = symbol_;
126     }
127 
128     function name() public view virtual override returns (string memory) {
129         return _name;
130     }
131 
132     function symbol() public view virtual override returns (string memory) {
133         return _symbol;
134     }
135 
136     function decimals() public view virtual override returns (uint8) {
137         return 18;
138     }
139 
140     function totalSupply() public view virtual override returns (uint256) {
141         return _totalSupply;
142     }
143 
144     function balanceOf(address account) public view virtual override returns (uint256) {
145         return _balances[account];
146     }
147 
148     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
149         _transfer(_msgSender(), recipient, amount);
150         return true;
151     }
152 
153     function allowance(address owner, address spender) public view virtual override returns (uint256) {
154         return _allowances[owner][spender];
155     }
156 
157     function approve(address spender, uint256 amount) public virtual override returns (bool) {
158         _approve(_msgSender(), spender, amount);
159         return true;
160     }
161 
162     function transferFrom(
163         address sender,
164         address recipient,
165         uint256 amount
166     ) public virtual override returns (bool) {
167         _transfer(sender, recipient, amount);
168 
169         uint256 currentAllowance = _allowances[sender][_msgSender()];
170         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
171         unchecked {
172             _approve(sender, _msgSender(), currentAllowance - amount);
173         }
174 
175         return true;
176     }
177 
178     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
180         return true;
181     }
182 
183     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
184         uint256 currentAllowance = _allowances[_msgSender()][spender];
185         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
186         unchecked {
187             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
188         }
189 
190         return true;
191     }
192 
193     function _transfer(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) internal virtual {
198         require(sender != address(0), "ERC20: transfer from the zero address");
199         require(recipient != address(0), "ERC20: transfer to the zero address");
200 
201         uint256 senderBalance = _balances[sender];
202         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
203         unchecked {
204             _balances[sender] = senderBalance - amount;
205         }
206         _balances[recipient] += amount;
207 
208         emit Transfer(sender, recipient, amount);
209     }
210 
211     function _createInitialSupply(address account, uint256 amount) internal virtual {
212         require(account != address(0), "ERC20: mint to the zero address");
213 
214         _totalSupply += amount;
215         _balances[account] += amount;
216         emit Transfer(address(0), account, amount);
217     }
218 
219     function _approve(
220         address owner,
221         address spender,
222         uint256 amount
223     ) internal virtual {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226 
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 }
231 
232 contract Ownable is Context {
233     address private _owner;
234 
235     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237     constructor () {
238         address msgSender = _msgSender();
239         _owner = msgSender;
240         emit OwnershipTransferred(address(0), msgSender);
241     }
242 
243     function owner() public view returns (address) {
244         return _owner;
245     }
246 
247     modifier onlyOwner() {
248         require(_owner == _msgSender(), "Ownable: caller is not the owner");
249         _;
250     }
251 
252     function renounceOwnership() external virtual onlyOwner {
253         emit OwnershipTransferred(_owner, address(0));
254         _owner = address(0);
255     }
256 
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         emit OwnershipTransferred(_owner, newOwner);
260         _owner = newOwner;
261     }
262 }
263 
264 interface IDexRouter {
265     function factory() external pure returns (address);
266     function WETH() external pure returns (address);
267 
268     function swapExactTokensForETHSupportingFeeOnTransferTokens(
269         uint amountIn,
270         uint amountOutMin,
271         address[] calldata path,
272         address to,
273         uint deadline
274     ) external;
275 
276     function swapExactETHForTokensSupportingFeeOnTransferTokens(
277         uint amountOutMin,
278         address[] calldata path,
279         address to,
280         uint deadline
281     ) external payable;
282 
283     function addLiquidityETH(
284         address token,
285         uint256 amountTokenDesired,
286         uint256 amountTokenMin,
287         uint256 amountETHMin,
288         address to,
289         uint256 deadline
290     )
291         external
292         payable
293         returns (
294             uint256 amountToken,
295             uint256 amountETH,
296             uint256 liquidity
297         );
298 }
299 
300 interface IDexFactory {
301     function createPair(address tokenA, address tokenB)
302         external
303         returns (address pair);
304 }
305 
306 contract Contract is ERC20, Ownable {
307 
308     uint256 public maxBuyAmount;
309     uint256 public maxSellAmount;
310     uint256 public maxWalletAmount;
311 
312     IDexRouter public dexRouter;
313     address public lpPair;
314 
315     bool private swapping;
316     uint256 public swapTokensAtAmount;
317 
318     address operationsAddress;
319 
320     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
321     mapping (address => bool) public bot;
322     uint256 public botsCaught;
323 
324     bool public limitsInEffect = true;
325     bool public tradingActive = false;
326     bool public swapEnabled = false;
327 
328      // Anti-bot and anti-whale mappings and variables
329     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
330     bool public transferDelayEnabled = true;
331 
332     uint256 public buyTotalFees;
333     uint256 public buyOperationsFee;
334     uint256 public buyLiquidityFee;
335 
336     uint256 public sellTotalFees;
337     uint256 public sellOperationsFee;
338     uint256 public sellLiquidityFee;
339 
340     uint256 public tokensForOperations;
341     uint256 public tokensForLiquidity;
342 
343     /******************/
344 
345     // exlcude from fees and max transaction amount
346     mapping (address => bool) private _isExcludedFromFees;
347     mapping (address => bool) public _isExcludedMaxTransactionAmount;
348 
349     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
350     // could be subject to a maximum transfer amount
351     mapping (address => bool) public automatedMarketMakerPairs;
352 
353     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
354 
355     event EnabledTrading();
356 
357     event RemovedLimits();
358 
359     event ExcludeFromFees(address indexed account, bool isExcluded);
360 
361     event UpdatedMaxBuyAmount(uint256 newAmount);
362 
363     event UpdatedMaxSellAmount(uint256 newAmount);
364 
365     event UpdatedMaxWalletAmount(uint256 newAmount);
366 
367     event UpdatedOperationsAddress(address indexed newWallet);
368 
369     event MaxTransactionExclusion(address _address, bool excluded);
370 
371     event BuyBackTriggered(uint256 amount);
372 
373     event OwnerForcedSwapBack(uint256 timestamp);
374  
375     event CaughtEarlyBuyer(address sniper);
376 
377     event SwapAndLiquify(
378         uint256 tokensSwapped,
379         uint256 ethReceived,
380         uint256 tokensIntoLiquidity
381     );
382 
383     event TransferForeignToken(address token, uint256 amount);
384 
385     constructor() ERC20(unicode"SAME COIN", unicode"SAME") {
386 
387         address newOwner = msg.sender; // can leave alone if owner is deployer.
388 
389         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
390         dexRouter = _dexRouter;
391 
392         // create pair
393         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
394         _excludeFromMaxTransaction(address(lpPair), true);
395         _setAutomatedMarketMakerPair(address(lpPair), true);
396 
397         uint256 totalSupply = 1 * 1e9 * 1e18;
398 
399         maxBuyAmount = totalSupply * 2 / 100;
400         maxSellAmount = totalSupply * 2 / 100;
401         maxWalletAmount = totalSupply * 2 / 100;
402         swapTokensAtAmount = totalSupply * 1 / 1000;
403 
404         buyOperationsFee = 30;
405         buyLiquidityFee = 0;
406         buyTotalFees = buyOperationsFee + buyLiquidityFee;
407 
408         sellOperationsFee = 30;
409         sellLiquidityFee = 0;
410         sellTotalFees = sellOperationsFee + sellLiquidityFee;
411 
412         _excludeFromMaxTransaction(newOwner, true);
413         _excludeFromMaxTransaction(address(this), true);
414         _excludeFromMaxTransaction(address(0xdead), true);
415 
416         excludeFromFees(newOwner, true);
417         excludeFromFees(address(this), true);
418         excludeFromFees(address(0xdead), true);
419 
420         operationsAddress = address(newOwner);
421 
422         _createInitialSupply(newOwner, totalSupply);
423         transferOwnership(newOwner);
424     }
425 
426     receive() external payable {}
427 
428     // only enable if no plan to airdrop
429 
430     function enableTrading() external onlyOwner {
431         require(!tradingActive, "Cannot reenable trading");
432         tradingActive = true;
433         swapEnabled = true;
434         tradingActiveBlock = block.number;
435         emit EnabledTrading();
436     }
437 
438     // remove limits after token is stable
439     function removeLimits() external onlyOwner {
440         limitsInEffect = false;
441         transferDelayEnabled = false;
442         emit RemovedLimits();
443     }
444 
445     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
446         bot[wallet] = flag;
447     }
448 
449     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
450         for(uint256 i = 0; i < wallets.length; i++){
451             bot[wallets[i]] = flag;
452         }
453     }
454 
455     // disable Transfer delay - cannot be reenabled
456     function disableTransferDelay() external onlyOwner {
457         transferDelayEnabled = false;
458     }
459 
460     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
461         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
462         maxBuyAmount = newNum * (10**18);
463         emit UpdatedMaxBuyAmount(maxBuyAmount);
464     }
465 
466     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
467         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
468         maxSellAmount = newNum * (10**18);
469         emit UpdatedMaxSellAmount(maxSellAmount);
470     }
471 
472     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
473         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
474         maxWalletAmount = newNum * (10**18);
475         emit UpdatedMaxWalletAmount(maxWalletAmount);
476     }
477 
478     // change the minimum amount of tokens to sell from fees
479     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
480   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
481   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
482   	    swapTokensAtAmount = newAmount;
483   	}
484 
485     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
486         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
487         emit MaxTransactionExclusion(updAds, isExcluded);
488     }
489 
490     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
491         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
492         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
493         for(uint256 i = 0; i < wallets.length; i++){
494             address wallet = wallets[i];
495             uint256 amount = amountsInTokens[i];
496             super._transfer(msg.sender, wallet, amount);
497         }
498     }
499 
500     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
501         if(!isEx){
502             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
503         }
504         _isExcludedMaxTransactionAmount[updAds] = isEx;
505     }
506 
507     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
508         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
509 
510         _setAutomatedMarketMakerPair(pair, value);
511         emit SetAutomatedMarketMakerPair(pair, value);
512     }
513 
514     function _setAutomatedMarketMakerPair(address pair, bool value) private {
515         automatedMarketMakerPairs[pair] = value;
516 
517         _excludeFromMaxTransaction(pair, value);
518 
519         emit SetAutomatedMarketMakerPair(pair, value);
520     }
521 
522     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
523         buyOperationsFee = _operationsFee;
524         buyLiquidityFee = _liquidityFee;
525         buyTotalFees = buyOperationsFee + buyLiquidityFee;
526         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
527     }
528 
529     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
530         sellOperationsFee = _operationsFee;
531         sellLiquidityFee = _liquidityFee;
532         sellTotalFees = sellOperationsFee + sellLiquidityFee;
533         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
534     }
535 
536     function excludeFromFees(address account, bool excluded) public onlyOwner {
537         _isExcludedFromFees[account] = excluded;
538         emit ExcludeFromFees(account, excluded);
539     }
540 
541     function _transfer(address from, address to, uint256 amount) internal override {
542 
543         require(from != address(0), "ERC20: transfer from the zero address");
544         require(to != address(0), "ERC20: transfer to the zero address");
545         require(amount > 0, "amount must be greater than 0");
546 
547         if(!tradingActive){
548             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
549         }
550 
551         require(!bot[from] && !bot[to], "Bots cannot transfer tokens in or out except to owner or dead address.");
552 
553         if(limitsInEffect){
554             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
555 
556                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
557                 if (transferDelayEnabled){
558                     if (to != address(dexRouter) && to != address(lpPair)){
559                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
560                         _holderLastTransferTimestamp[tx.origin] = block.number;
561                         _holderLastTransferTimestamp[to] = block.number;
562                     }
563                 }
564     
565                 //when buy
566                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
567                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
568                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
569                 }
570                 //when sell
571                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
572                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
573                 }
574                 else if (!_isExcludedMaxTransactionAmount[to]){
575                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
576                 }
577             }
578         }
579 
580         uint256 contractTokenBalance = balanceOf(address(this));
581 
582         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
583 
584         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
585             swapping = true;
586 
587             swapBack();
588 
589             swapping = false;
590         }
591 
592         bool takeFee = true;
593         // if any account belongs to _isExcludedFromFee account then remove the fee
594         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
595             takeFee = false;
596         }
597 
598         uint256 fees = 0;
599         // only take fees on buys/sells, do not take on wallet transfers
600         if(takeFee){
601             // on sell
602             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
603                 fees = amount * sellTotalFees / 100;
604                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
605                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
606             }
607 
608             // on buy
609             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
610         	    fees = amount * buyTotalFees / 100;
611         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
612                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
613             }
614 
615             if(fees > 0){
616                 super._transfer(from, address(this), fees);
617             }
618 
619         	amount -= fees;
620         }
621 
622         super._transfer(from, to, amount);
623     }
624     function swapTokensForEth(uint256 tokenAmount) private {
625 
626         // generate the uniswap pair path of token -> weth
627         address[] memory path = new address[](2);
628         path[0] = address(this);
629         path[1] = dexRouter.WETH();
630 
631         _approve(address(this), address(dexRouter), tokenAmount);
632 
633         // make the swap
634         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
635             tokenAmount,
636             0, // accept any amount of ETH
637             path,
638             address(this),
639             block.timestamp
640         );
641     }
642 
643     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
644         // approve token transfer to cover all possible scenarios
645         _approve(address(this), address(dexRouter), tokenAmount);
646 
647         // add the liquidity
648         dexRouter.addLiquidityETH{value: ethAmount}(
649             address(this),
650             tokenAmount,
651             0, // slippage is unavoidable
652             0, // slippage is unavoidable
653             address(0xdead),
654             block.timestamp
655         );
656     }
657 
658     function swapBack() private {
659         uint256 contractBalance = balanceOf(address(this));
660         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
661 
662         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
663 
664         if(contractBalance > swapTokensAtAmount * 60){
665             contractBalance = swapTokensAtAmount * 60;
666         }
667 
668         bool success;
669 
670         // Halve the amount of liquidity tokens
671         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
672 
673         swapTokensForEth(contractBalance - liquidityTokens);
674 
675         uint256 ethBalance = address(this).balance;
676         uint256 ethForLiquidity = ethBalance;
677 
678         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
679 
680         ethForLiquidity -= ethForOperations;
681 
682         tokensForLiquidity = 0;
683         tokensForOperations = 0;
684 
685         if(liquidityTokens > 0 && ethForLiquidity > 0){
686             addLiquidity(liquidityTokens, ethForLiquidity);
687         }
688 
689         if(address(this).balance > 0){
690             (success,) = address(operationsAddress).call{value: address(this).balance}("");
691         }
692     }
693 
694     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
695         require(_token != address(0), "_token address cannot be 0");
696         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
697         _sent = IERC20(_token).transfer(_to, _contractBalance);
698         emit TransferForeignToken(_token, _contractBalance);
699     }
700 
701     // withdraw ETH if stuck or someone sends to the address
702     function withdrawStuckETH() external onlyOwner {
703         bool success;
704         (success,) = address(msg.sender).call{value: address(this).balance}("");
705     }
706 
707     function setOperationsAddress(address _operationsAddress) external onlyOwner {
708         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
709         operationsAddress = payable(_operationsAddress);
710     }
711 
712     // force Swap back if slippage issues.
713     function forceSwapBack() external onlyOwner {
714         require(balanceOf(address(this)) >= 0, "No tokens to swap");
715         swapping = true;
716         swapBack();
717         swapping = false;
718         emit OwnerForcedSwapBack(block.timestamp);
719     }
720 
721 }