1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.15;
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 abstract contract Context {
79     function _msgSender() internal view virtual returns (address) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view virtual returns (bytes calldata) {
84         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85         return msg.data;
86     }
87 }
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 
105 
106 contract ERC20 is Context, IERC20, IERC20Metadata {
107     mapping(address => uint256) private _balances;
108 
109     mapping(address => mapping(address => uint256)) private _allowances;
110 
111     uint256 private _totalSupply;
112 
113     string private _name;
114     string private _symbol;
115 
116     constructor(string memory name_, string memory symbol_) {
117         _name = name_;
118         _symbol = symbol_;
119     }
120 
121     function name() public view virtual override returns (string memory) {
122         return _name;
123     }
124 
125     function symbol() public view virtual override returns (string memory) {
126         return _symbol;
127     }
128 
129     function decimals() public view virtual override returns (uint8) {
130         return 18;
131     }
132 
133     function totalSupply() public view virtual override returns (uint256) {
134         return _totalSupply;
135     }
136 
137     function balanceOf(address account) public view virtual override returns (uint256) {
138         return _balances[account];
139     }
140 
141     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
142         _transfer(_msgSender(), recipient, amount);
143         return true;
144     }
145 
146     function allowance(address owner, address spender) public view virtual override returns (uint256) {
147         return _allowances[owner][spender];
148     }
149 
150     function approve(address spender, uint256 amount) public virtual override returns (bool) {
151         _approve(_msgSender(), spender, amount);
152         return true;
153     }
154 
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) public virtual override returns (bool) {
160         _transfer(sender, recipient, amount);
161 
162         uint256 currentAllowance = _allowances[sender][_msgSender()];
163         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
164         unchecked {
165             _approve(sender, _msgSender(), currentAllowance - amount);
166         }
167 
168         return true;
169     }
170 
171     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
172         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
173         return true;
174     }
175 
176     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
177         uint256 currentAllowance = _allowances[_msgSender()][spender];
178         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
179         unchecked {
180             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
181         }
182 
183         return true;
184     }
185 
186     function _transfer(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) internal virtual {
191         require(sender != address(0), "ERC20: transfer from the zero address");
192         require(recipient != address(0), "ERC20: transfer to the zero address");
193 
194         uint256 senderBalance = _balances[sender];
195         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
196         unchecked {
197             _balances[sender] = senderBalance - amount;
198         }
199         _balances[recipient] += amount;
200 
201         emit Transfer(sender, recipient, amount);
202     }
203 
204     function _createInitialSupply(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: mint to the zero address");
206 
207         _totalSupply += amount;
208         _balances[account] += amount;
209         emit Transfer(address(0), account, amount);
210     }
211 
212     function _burn(address account, uint256 amount) internal virtual {
213         require(account != address(0), "ERC20: burn from the zero address");
214         uint256 accountBalance = _balances[account];
215         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
216         unchecked {
217             _balances[account] = accountBalance - amount;
218             // Overflow not possible: amount <= accountBalance <= totalSupply.
219             _totalSupply -= amount;
220         }
221 
222         emit Transfer(account, address(0), amount);
223     }
224 
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) internal virtual {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232 
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 }
237 
238 
239 contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     constructor () {
245         address msgSender = _msgSender();
246         _owner = msgSender;
247         emit OwnershipTransferred(address(0), msgSender);
248     }
249 
250     function owner() public view returns (address) {
251         return _owner;
252     }
253 
254     modifier onlyOwner() {
255         require(_owner == _msgSender(), "Ownable: caller is not the owner");
256         _;
257     }
258 
259     function renounceOwnership() external virtual onlyOwner {
260         emit OwnershipTransferred(_owner, address(0));
261         _owner = address(0);
262     }
263 
264     function transferOwnership(address newOwner) public virtual onlyOwner {
265         require(newOwner != address(0), "Ownable: new owner is the zero address");
266         emit OwnershipTransferred(_owner, newOwner);
267         _owner = newOwner;
268     }
269 }
270 
271 interface IDexRouter {
272     function factory() external pure returns (address);
273     function WETH() external pure returns (address);
274 
275     function swapExactTokensForETHSupportingFeeOnTransferTokens(
276         uint amountIn,
277         uint amountOutMin,
278         address[] calldata path,
279         address to,
280         uint deadline
281     ) external;
282 
283     function swapExactETHForTokensSupportingFeeOnTransferTokens(
284         uint amountOutMin,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external payable;
289 
290     function addLiquidityETH(
291         address token,
292         uint256 amountTokenDesired,
293         uint256 amountTokenMin,
294         uint256 amountETHMin,
295         address to,
296         uint256 deadline
297     )
298         external
299         payable
300         returns (
301             uint256 amountToken,
302             uint256 amountETH,
303             uint256 liquidity
304         );
305 }
306 
307 interface IDexFactory {
308     function createPair(address tokenA, address tokenB)
309         external
310         returns (address pair);
311 }
312 
313 contract PEPITA is ERC20, Ownable {
314 
315     uint256 public maxBuyAmount;
316     uint256 public maxSellAmount;
317     uint256 public maxWalletAmount;
318 
319     IDexRouter public dexRouter;
320     address public lpPair;
321 
322     bool private swapping;
323     uint256 public swapTokensAtAmount;
324 
325     address operationsAddress;
326     address devAddress;
327 
328     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
329     uint256 public blockForPenaltyEnd;
330     mapping (address => bool) public boughtEarly;
331     uint256 public botsCaught;
332 
333     bool public limitsInEffect = true;
334     bool public tradingActive = false;
335     bool public swapEnabled = false;
336      // Anti-bot and anti-whale mappings and variables
337     uint256 public buyTotalFees;
338     uint256 public buyOperationsFee;
339     uint256 public buyLiquidityFee;
340     uint256 public buyDevFee;
341     uint256 public buyBurnFee;
342 
343     uint256 public sellTotalFees;
344     uint256 public sellOperationsFee;
345     uint256 public sellLiquidityFee;
346     uint256 public sellDevFee;
347     uint256 public sellBurnFee;
348 
349     uint256 public tokensForOperations;
350     uint256 public tokensForLiquidity;
351     uint256 public tokensForDev;
352     uint256 public tokensForBurn;
353 
354     /******************/
355 
356     // exlcude from fees and max transaction amount
357     mapping (address => bool) private _isExcludedFromFees;
358     mapping (address => bool) public _isExcludedMaxTransactionAmount;
359 
360     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
361     // could be subject to a maximum transfer amount
362     mapping (address => bool) public automatedMarketMakerPairs;
363 
364     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
365 
366     event EnabledTrading();
367 
368     event RemovedLimits();
369 
370     event ExcludeFromFees(address indexed account, bool isExcluded);
371 
372     event UpdatedMaxBuyAmount(uint256 newAmount);
373 
374     event UpdatedMaxSellAmount(uint256 newAmount);
375 
376     event UpdatedMaxWalletAmount(uint256 newAmount);
377 
378     event UpdatedOperationsAddress(address indexed newWallet);
379 
380     event MaxTransactionExclusion(address _address, bool excluded);
381 
382     event BuyBackTriggered(uint256 amount);
383 
384     event OwnerForcedSwapBack(uint256 timestamp);
385 
386     event CaughtEarlyBuyer(address sniper);
387 
388     event SwapAndLiquify(
389         uint256 tokensSwapped,
390         uint256 ethReceived,
391         uint256 tokensIntoLiquidity
392     );
393 
394     event TransferForeignToken(address token, uint256 amount);
395 
396     constructor() ERC20("PEPITA", "PEPITA") {
397 
398         address newOwner = msg.sender; // can leave alone if owner is deployer.
399 
400         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
401         dexRouter = _dexRouter;
402 
403         // create pair
404         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
405         _excludeFromMaxTransaction(address(lpPair), true);
406         _setAutomatedMarketMakerPair(address(lpPair), true);
407 
408         uint256 totalSupply = 5 * 1e6 * 1e18;
409 
410         maxBuyAmount = 150000 *1e18;
411         maxSellAmount = 150000 *1e18;
412         maxWalletAmount = 150000 *1e18;
413         swapTokensAtAmount = totalSupply * 5 / 10000;
414 
415         buyOperationsFee = 5;
416         buyLiquidityFee = 0;
417         buyDevFee = 0;
418         buyBurnFee = 0;
419         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
420 
421         sellOperationsFee = 5;
422         sellLiquidityFee = 0;
423         sellDevFee = 0;
424         sellBurnFee = 5;
425         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
426 
427         _excludeFromMaxTransaction(newOwner, true);
428         _excludeFromMaxTransaction(address(this), true);
429         _excludeFromMaxTransaction(address(0xdead), true);
430 
431         excludeFromFees(newOwner, true);
432         excludeFromFees(address(this), true);
433         excludeFromFees(address(0xdead), true);
434 
435         operationsAddress = 0x1755847E848E61f2f1A63c690d4D566b5ffBc4C2;
436         devAddress = address(newOwner);
437 
438         _createInitialSupply(newOwner, totalSupply);
439         transferOwnership(newOwner);
440     }
441 
442     receive() external payable {}
443 
444     // only enable if no plan to airdrop
445 
446     function enableTrading(uint256 deadBlocks) external onlyOwner {
447         require(!tradingActive, "Cannot reenable trading");
448         tradingActive = true;
449         swapEnabled = true;
450         tradingActiveBlock = block.number;
451         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
452         emit EnabledTrading();
453     }
454 
455     // remove limits after token is stable
456     function removeLimits() external onlyOwner {
457         limitsInEffect = false;
458         emit RemovedLimits();
459     }
460 
461     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
462         boughtEarly[wallet] = flag;
463     }
464 
465     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
466         for(uint256 i = 0; i < wallets.length; i++){
467             boughtEarly[wallets[i]] = flag;
468         }
469     }
470 
471     // change the minimum amount of tokens to sell from fees
472     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
473   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
474   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
475   	    swapTokensAtAmount = newAmount;
476   	}
477 
478     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
479         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
480         emit MaxTransactionExclusion(updAds, isExcluded);
481     }
482 
483 
484     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
485         if(!isEx){
486             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
487         }
488         _isExcludedMaxTransactionAmount[updAds] = isEx;
489     }
490 
491 
492     function _setAutomatedMarketMakerPair(address pair, bool value) private {
493         automatedMarketMakerPairs[pair] = value;
494 
495         _excludeFromMaxTransaction(pair, value);
496 
497         emit SetAutomatedMarketMakerPair(pair, value);
498     }
499 
500     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
501         buyOperationsFee = _operationsFee;
502         buyLiquidityFee = _liquidityFee;
503         buyDevFee = _devFee;
504         buyBurnFee = _burnFee;
505         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
506         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
507     }
508 
509     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
510         sellOperationsFee = _operationsFee;
511         sellLiquidityFee = _liquidityFee;
512         sellDevFee = _devFee;
513         sellBurnFee = _burnFee;
514         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
515         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
516     }
517 
518     function excludeFromFees(address account, bool excluded) public onlyOwner {
519         _isExcludedFromFees[account] = excluded;
520         emit ExcludeFromFees(account, excluded);
521     }
522 
523     function _transfer(address from, address to, uint256 amount) internal override {
524 
525         require(from != address(0), "ERC20: transfer from the zero address");
526         require(to != address(0), "ERC20: transfer to the zero address");
527         require(amount > 0, "amount must be greater than 0");
528 
529         if(!tradingActive){
530             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
531         }
532 
533         if(blockForPenaltyEnd > 0){
534             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
535         }
536 
537         if(limitsInEffect){
538             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){  
539                 
540                 //when buy
541                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
542                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
543                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
544                         
545                 }
546                 //when sell
547                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
548                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
549                         
550                 }
551                 else if (!_isExcludedMaxTransactionAmount[to]){
552                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
553                 }
554             }
555         }
556 
557         uint256 contractTokenBalance = balanceOf(address(this));
558 
559         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
560 
561         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
562             swapping = true;
563 
564             swapBack();
565 
566             swapping = false;
567         }
568 
569         bool takeFee = true;
570         // if any account belongs to _isExcludedFromFee account then remove the fee
571         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
572             takeFee = false;
573         }
574 
575         uint256 fees = 0;
576         // only take fees on buys/sells, do not take on wallet transfers
577         if(takeFee){
578             // bot/sniper penalty.
579             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
580 
581                 if(!boughtEarly[to]){
582                     boughtEarly[to] = true;
583                     botsCaught += 1;
584                     emit CaughtEarlyBuyer(to);
585                 }
586 
587                 fees = amount * 99 / 100;
588         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
589                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
590                 tokensForDev += fees * buyDevFee / buyTotalFees;
591                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
592             }
593 
594             // on sell
595             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
596                 fees = amount * sellTotalFees / 100;
597                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
598                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
599                 tokensForDev += fees * sellDevFee / sellTotalFees;
600                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
601             }
602 
603             // on buy
604             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
605         	    fees = amount * buyTotalFees / 100;
606         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
607                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
608                 tokensForDev += fees * buyDevFee / buyTotalFees;
609                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
610             }
611             //on wallet transfer
612             else{
613                 fees = amount * 5 /100;
614                 tokensForOperations += fees; 
615             }
616 
617             if(fees > 0){
618                 super._transfer(from, address(this), fees);
619             }
620 
621         	amount -= fees;
622         }
623 
624         super._transfer(from, to, amount);
625     }
626 
627     function earlyBuyPenaltyInEffect() public view returns (bool){
628         return block.number < blockForPenaltyEnd;
629     }
630 
631     function swapTokensForEth(uint256 tokenAmount) private {
632 
633         // generate the uniswap pair path of token -> weth
634         address[] memory path = new address[](2);
635         path[0] = address(this);
636         path[1] = dexRouter.WETH();
637 
638         _approve(address(this), address(dexRouter), tokenAmount);
639 
640         // make the swap
641         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
642             tokenAmount,
643             0, // accept any amount of ETH
644             path,
645             address(this),
646             block.timestamp
647         );
648     }
649 
650     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
651         // approve token transfer to cover all possible scenarios
652         _approve(address(this), address(dexRouter), tokenAmount);
653 
654         // add the liquidity
655         dexRouter.addLiquidityETH{value: ethAmount}(
656             address(this),
657             tokenAmount,
658             0, // slippage is unavoidable
659             0, // slippage is unavoidable
660             address(0xdead),
661             block.timestamp
662         );
663     }
664 
665     function swapBack() private {
666 
667         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
668             _burn(address(this), tokensForBurn);
669         }
670         tokensForBurn = 0;
671 
672         uint256 contractBalance = balanceOf(address(this));
673         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
674 
675         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
676 
677         if(contractBalance > swapTokensAtAmount * 20){
678             contractBalance = swapTokensAtAmount * 20;
679         }
680 
681         bool success;
682 
683         // Halve the amount of liquidity tokens
684         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
685 
686         swapTokensForEth(contractBalance - liquidityTokens);
687 
688         uint256 ethBalance = address(this).balance;
689         uint256 ethForLiquidity = ethBalance;
690 
691         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
692         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
693 
694         ethForLiquidity -= ethForOperations + ethForDev;
695 
696         tokensForLiquidity = 0;
697         tokensForOperations = 0;
698         tokensForDev = 0;
699         tokensForBurn = 0;
700 
701         if(liquidityTokens > 0 && ethForLiquidity > 0){
702             addLiquidity(liquidityTokens, ethForLiquidity);
703         }
704 
705         (success,) = address(devAddress).call{value: ethForDev}("");
706 
707         (success,) = address(operationsAddress).call{value: address(this).balance}("");
708     }
709 
710 
711     // withdraw ETH if stuck or someone sends to the address
712     function withdrawStuckETH() external onlyOwner {
713         bool success;
714         (success,) = address(msg.sender).call{value: address(this).balance}("");
715     }
716 
717     function setOperationsAddress(address _operationsAddress) external onlyOwner {
718         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
719         operationsAddress = payable(_operationsAddress);
720     }
721 
722     function setDevAddress(address _devAddress) external onlyOwner {
723         require(_devAddress != address(0), "_devAddress address cannot be 0");
724         devAddress = payable(_devAddress);
725     }
726 
727     // force Swap back if slippage issues.
728     function forceSwapBack() external onlyOwner {
729         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
730         swapping = true;
731         swapBack();
732         swapping = false;
733         emit OwnerForcedSwapBack(block.timestamp);
734     }
735 }