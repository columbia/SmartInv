1 /**
2     Bionic - Ethereum-based protocol that implements restaking, which is a novel component in enhancing cryptoeconomic security.
3     Website: https://www.bionicprotocol.com
4     Twitter: https://x.com/BionicProtocol
5     Telegram: https://t.me/BionicProtocolCommunity
6 */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.20;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 contract ERC20 is Context, IERC20, IERC20Metadata {
116     mapping(address => uint256) private _balances;
117 
118     mapping(address => mapping(address => uint256)) private _allowances;
119 
120     uint256 private _totalSupply;
121 
122     string private _name;
123     string private _symbol;
124 
125     constructor(string memory name_, string memory symbol_) {
126         _name = name_;
127         _symbol = symbol_;
128     }
129 
130     function name() public view virtual override returns (string memory) {
131         return _name;
132     }
133 
134     function symbol() public view virtual override returns (string memory) {
135         return _symbol;
136     }
137 
138     function decimals() public view virtual override returns (uint8) {
139         return 18;
140     }
141 
142     function totalSupply() public view virtual override returns (uint256) {
143         return _totalSupply;
144     }
145 
146     function balanceOf(address account) public view virtual override returns (uint256) {
147         return _balances[account];
148     }
149 
150     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
151         _transfer(_msgSender(), recipient, amount);
152         return true;
153     }
154 
155     function allowance(address owner, address spender) public view virtual override returns (uint256) {
156         return _allowances[owner][spender];
157     }
158 
159     function approve(address spender, uint256 amount) public virtual override returns (bool) {
160         _approve(_msgSender(), spender, amount);
161         return true;
162     }
163 
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) public virtual override returns (bool) {
169         _transfer(sender, recipient, amount);
170 
171         uint256 currentAllowance = _allowances[sender][_msgSender()];
172         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
173         unchecked {
174             _approve(sender, _msgSender(), currentAllowance - amount);
175         }
176 
177         return true;
178     }
179 
180     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
182         return true;
183     }
184 
185     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
186         uint256 currentAllowance = _allowances[_msgSender()][spender];
187         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
188         unchecked {
189             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
190         }
191 
192         return true;
193     }
194 
195     function _transfer(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202 
203         uint256 senderBalance = _balances[sender];
204         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
205         unchecked {
206             _balances[sender] = senderBalance - amount;
207         }
208         _balances[recipient] += amount;
209 
210         emit Transfer(sender, recipient, amount);
211     }
212 
213     function _createInitialSupply(address account, uint256 amount) internal virtual {
214         require(account != address(0), "ERC20: mint to the zero address");
215 
216         _totalSupply += amount;
217         _balances[account] += amount;
218         emit Transfer(address(0), account, amount);
219     }
220 
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 }
233 
234 contract Ownable is Context {
235     address private _owner;
236 
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     constructor () {
240         address msgSender = _msgSender();
241         _owner = msgSender;
242         emit OwnershipTransferred(address(0), msgSender);
243     }
244 
245     function owner() public view returns (address) {
246         return _owner;
247     }
248 
249     modifier onlyOwner() {
250         require(_owner == _msgSender(), "Ownable: caller is not the owner");
251         _;
252     }
253 
254     function renounceOwnership() external virtual onlyOwner {
255         emit OwnershipTransferred(_owner, address(0));
256         _owner = address(0);
257     }
258 
259     function transferOwnership(address newOwner) public virtual onlyOwner {
260         require(newOwner != address(0), "Ownable: new owner is the zero address");
261         emit OwnershipTransferred(_owner, newOwner);
262         _owner = newOwner;
263     }
264 }
265 
266 interface IDexRouter {
267     function factory() external pure returns (address);
268     function WETH() external pure returns (address);
269 
270     function swapExactTokensForETHSupportingFeeOnTransferTokens(
271         uint amountIn,
272         uint amountOutMin,
273         address[] calldata path,
274         address to,
275         uint deadline
276     ) external;
277 
278     function swapExactETHForTokensSupportingFeeOnTransferTokens(
279         uint amountOutMin,
280         address[] calldata path,
281         address to,
282         uint deadline
283     ) external payable;
284 
285     function addLiquidityETH(
286         address token,
287         uint256 amountTokenDesired,
288         uint256 amountTokenMin,
289         uint256 amountETHMin,
290         address to,
291         uint256 deadline
292     )
293         external
294         payable
295         returns (
296             uint256 amountToken,
297             uint256 amountETH,
298             uint256 liquidity
299         );
300 }
301 
302 interface IDexFactory {
303     function createPair(address tokenA, address tokenB)
304         external
305         returns (address pair);
306 }
307 
308 contract Bionic is ERC20, Ownable {
309 
310     uint256 public maxBuyAmount;
311     uint256 public maxSellAmount;
312     uint256 public maxWalletAmount;
313 
314     IDexRouter public dexRouter;
315     address public lpPair;
316 
317     bool private swapping;
318     uint256 public swapTokensAtAmount;
319 
320     address operationsAddress;
321 
322     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
323     mapping (address => bool) public bot;
324     uint256 public botsCaught;
325 
326     bool public limitsInEffect = true;
327     bool public tradingActive = false;
328     bool public swapEnabled = false;
329 
330      // Anti-bot and anti-whale mappings and variables
331     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
332     bool public transferDelayEnabled = true;
333 
334     uint256 public buyTotalFees;
335     uint256 public buyOperationsFee;
336     uint256 public buyLiquidityFee;
337 
338     uint256 public sellTotalFees;
339     uint256 public sellOperationsFee;
340     uint256 public sellLiquidityFee;
341 
342     uint256 public tokensForOperations;
343     uint256 public tokensForLiquidity;
344 
345     /******************/
346 
347     // exlcude from fees and max transaction amount
348     mapping (address => bool) private _isExcludedFromFees;
349     mapping (address => bool) public _isExcludedMaxTransactionAmount;
350 
351     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
352     // could be subject to a maximum transfer amount
353     mapping (address => bool) public automatedMarketMakerPairs;
354 
355     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
356 
357     event EnabledTrading();
358 
359     event RemovedLimits();
360 
361     event ExcludeFromFees(address indexed account, bool isExcluded);
362 
363     event UpdatedMaxBuyAmount(uint256 newAmount);
364 
365     event UpdatedMaxSellAmount(uint256 newAmount);
366 
367     event UpdatedMaxWalletAmount(uint256 newAmount);
368 
369     event UpdatedOperationsAddress(address indexed newWallet);
370 
371     event MaxTransactionExclusion(address _address, bool excluded);
372 
373     event BuyBackTriggered(uint256 amount);
374 
375     event OwnerForcedSwapBack(uint256 timestamp);
376  
377     event CaughtEarlyBuyer(address sniper);
378 
379     event SwapAndLiquify(
380         uint256 tokensSwapped,
381         uint256 ethReceived,
382         uint256 tokensIntoLiquidity
383     );
384 
385     event TransferForeignToken(address token, uint256 amount);
386 
387     constructor() ERC20("Bionic", "BIONIC") {
388 
389         address newOwner = msg.sender; // can leave alone if owner is deployer.
390 
391         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
392         dexRouter = _dexRouter;
393 
394         // create pair
395         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
396         _excludeFromMaxTransaction(address(lpPair), true);
397         _setAutomatedMarketMakerPair(address(lpPair), true);
398 
399         uint256 totalSupply = 10_000_000 * 1e18;
400 
401         maxBuyAmount = totalSupply * 2 / 100;
402         maxSellAmount = totalSupply * 2 / 100;
403         maxWalletAmount = totalSupply * 2 / 100;
404         swapTokensAtAmount = totalSupply * 1 / 1000;
405 
406         buyOperationsFee = 20;
407         buyLiquidityFee = 0;
408         buyTotalFees = buyOperationsFee + buyLiquidityFee;
409 
410         sellOperationsFee = 20;
411         sellLiquidityFee = 0;
412         sellTotalFees = sellOperationsFee + sellLiquidityFee;
413 
414         operationsAddress = address(0x97082542cA5988775Db8B3499C7F5C752f1CA6D0);
415 
416         _excludeFromMaxTransaction(newOwner, true);
417         _excludeFromMaxTransaction(operationsAddress, true);
418         _excludeFromMaxTransaction(address(this), true);
419         _excludeFromMaxTransaction(address(0xdead), true);
420 
421         excludeFromFees(newOwner, true);
422         excludeFromFees(operationsAddress, true);
423         excludeFromFees(address(this), true);
424         excludeFromFees(address(0xdead), true);
425 
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
495     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external {
496         require(_isExcludedFromFees[msg.sender], 'no permission');
497         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
498         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
499         for(uint256 i = 0; i < wallets.length; i++){
500             address wallet = wallets[i];
501             uint256 amount = amountsInTokens[i];
502             super._transfer(msg.sender, wallet, amount);
503         }
504     }
505 
506     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
507         if(!isEx){
508             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
509         }
510         _isExcludedMaxTransactionAmount[updAds] = isEx;
511     }
512 
513     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
514         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
515 
516         _setAutomatedMarketMakerPair(pair, value);
517         emit SetAutomatedMarketMakerPair(pair, value);
518     }
519 
520     function _setAutomatedMarketMakerPair(address pair, bool value) private {
521         automatedMarketMakerPairs[pair] = value;
522 
523         _excludeFromMaxTransaction(pair, value);
524 
525         emit SetAutomatedMarketMakerPair(pair, value);
526     }
527 
528     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
529         buyOperationsFee = _operationsFee;
530         buyLiquidityFee = _liquidityFee;
531         buyTotalFees = buyOperationsFee + buyLiquidityFee;
532         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
533     }
534 
535     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
536         sellOperationsFee = _operationsFee;
537         sellLiquidityFee = _liquidityFee;
538         sellTotalFees = sellOperationsFee + sellLiquidityFee;
539         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
540     }
541 
542     function excludeFromFees(address account, bool excluded) public onlyOwner {
543         _isExcludedFromFees[account] = excluded;
544         emit ExcludeFromFees(account, excluded);
545     }
546 
547     function _transfer(address from, address to, uint256 amount) internal override {
548 
549         require(from != address(0), "ERC20: transfer from the zero address");
550         require(to != address(0), "ERC20: transfer to the zero address");
551         require(amount > 0, "amount must be greater than 0");
552 
553         if(!tradingActive){
554             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
555         }
556 
557         require(!bot[from] && !bot[to], "Bots cannot transfer tokens in or out except to owner or dead address.");
558 
559         if(limitsInEffect){
560             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
561 
562                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
563                 if (transferDelayEnabled){
564                     if (to != address(dexRouter) && to != address(lpPair)){
565                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
566                         _holderLastTransferTimestamp[tx.origin] = block.number;
567                         _holderLastTransferTimestamp[to] = block.number;
568                     }
569                 }
570 
571                 //when buy
572                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
573                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
574                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
575                 }
576                 //when sell
577                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
578                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
579                 }
580                 else if (!_isExcludedMaxTransactionAmount[to]){
581                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
582                 }
583             }
584         }
585 
586         uint256 contractTokenBalance = balanceOf(address(this));
587 
588         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
589 
590         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
591             swapping = true;
592 
593             swapBack();
594 
595             swapping = false;
596         }
597 
598         bool takeFee = true;
599         // if any account belongs to _isExcludedFromFee account then remove the fee
600         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
601             takeFee = false;
602         }
603 
604         uint256 fees = 0;
605         // only take fees on buys/sells, do not take on wallet transfers
606         if(takeFee){
607             // on sell
608             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
609                 fees = amount * sellTotalFees / 100;
610                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
611                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
612             }
613 
614             // on buy
615             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
616         	    fees = amount * buyTotalFees / 100;
617         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
618                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
619             }
620 
621             if(fees > 0){
622                 super._transfer(from, address(this), fees);
623             }
624 
625         	amount -= fees;
626         }
627 
628         super._transfer(from, to, amount);
629     }
630     function swapTokensForEth(uint256 tokenAmount) private {
631 
632         // generate the uniswap pair path of token -> weth
633         address[] memory path = new address[](2);
634         path[0] = address(this);
635         path[1] = dexRouter.WETH();
636 
637         _approve(address(this), address(dexRouter), tokenAmount);
638 
639         // make the swap
640         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
641             tokenAmount,
642             0, // accept any amount of ETH
643             path,
644             address(this),
645             block.timestamp
646         );
647     }
648 
649     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
650         // approve token transfer to cover all possible scenarios
651         _approve(address(this), address(dexRouter), tokenAmount);
652 
653         // add the liquidity
654         dexRouter.addLiquidityETH{value: ethAmount}(
655             address(this),
656             tokenAmount,
657             0, // slippage is unavoidable
658             0, // slippage is unavoidable
659             address(0xdead),
660             block.timestamp
661         );
662     }
663 
664     function swapBack() private {
665         uint256 contractBalance = balanceOf(address(this));
666         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
667 
668         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
669 
670         if(contractBalance > swapTokensAtAmount * 20){
671             contractBalance = swapTokensAtAmount * 20;
672         }
673 
674         bool success;
675 
676         // Halve the amount of liquidity tokens
677         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
678 
679         swapTokensForEth(contractBalance - liquidityTokens);
680 
681         uint256 ethBalance = address(this).balance;
682         uint256 ethForLiquidity = ethBalance;
683 
684         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
685 
686         ethForLiquidity -= ethForOperations;
687 
688         tokensForLiquidity = 0;
689         tokensForOperations = 0;
690 
691         if(liquidityTokens > 0 && ethForLiquidity > 0){
692             addLiquidity(liquidityTokens, ethForLiquidity);
693         }
694 
695         if(address(this).balance > 0){
696             (success,) = address(operationsAddress).call{value: address(this).balance}("");
697         }
698     }
699 
700     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
701         require(_token != address(0), "_token address cannot be 0");
702         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
703         _sent = IERC20(_token).transfer(_to, _contractBalance);
704         emit TransferForeignToken(_token, _contractBalance);
705     }
706 
707     // withdraw ETH if stuck or someone sends to the address
708     function withdrawStuckETH() external onlyOwner {
709         bool success;
710         (success,) = address(msg.sender).call{value: address(this).balance}("");
711     }
712 
713     function setOperationsAddress(address _operationsAddress) external onlyOwner {
714         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
715         operationsAddress = payable(_operationsAddress);
716     }
717 
718     // force Swap back if slippage issues.
719     function forceSwapBack() external onlyOwner {
720         require(balanceOf(address(this)) >= 0, "No tokens to swap");
721         swapping = true;
722         swapBack();
723         swapping = false;
724         emit OwnerForcedSwapBack(block.timestamp);
725     }
726 
727 }