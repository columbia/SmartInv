1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.19;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface IERC20Metadata is IERC20 {
31     function name() external view returns (string memory);
32     function symbol() external view returns (string memory);
33     function decimals() external view returns (uint8);
34 }
35 
36 contract ERC20 is Context, IERC20, IERC20Metadata {
37     mapping(address => uint256) private _balances;
38 
39     mapping(address => mapping(address => uint256)) private _allowances;
40 
41     uint256 private _totalSupply;
42 
43     string private _name;
44     string private _symbol;
45 
46     constructor(string memory name_, string memory symbol_) {
47         _name = name_;
48         _symbol = symbol_;
49     }
50 
51     function name() public view virtual override returns (string memory) {
52         return _name;
53     }
54 
55     function symbol() public view virtual override returns (string memory) {
56         return _symbol;
57     }
58 
59     function decimals() public view virtual override returns (uint8) {
60         return 18;
61     }
62 
63     function totalSupply() public view virtual override returns (uint256) {
64         return _totalSupply;
65     }
66 
67     function balanceOf(address account) public view virtual override returns (uint256) {
68         return _balances[account];
69     }
70 
71     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
72         _transfer(_msgSender(), recipient, amount);
73         return true;
74     }
75 
76     function allowance(address owner, address spender) public view virtual override returns (uint256) {
77         return _allowances[owner][spender];
78     }
79 
80     function approve(address spender, uint256 amount) public virtual override returns (bool) {
81         _approve(_msgSender(), spender, amount);
82         return true;
83     }
84 
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) public virtual override returns (bool) {
90         _transfer(sender, recipient, amount);
91 
92         uint256 currentAllowance = _allowances[sender][_msgSender()];
93         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
94         unchecked {
95             _approve(sender, _msgSender(), currentAllowance - amount);
96         }
97 
98         return true;
99     }
100 
101     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
102         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
103         return true;
104     }
105 
106     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
107         uint256 currentAllowance = _allowances[_msgSender()][spender];
108         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
109         unchecked {
110             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
111         }
112 
113         return true;
114     }
115 
116     function _transfer(
117         address sender,
118         address recipient,
119         uint256 amount
120     ) internal virtual {
121         require(sender != address(0), "ERC20: transfer from the zero address");
122         require(recipient != address(0), "ERC20: transfer to the zero address");
123 
124         uint256 senderBalance = _balances[sender];
125         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
126         unchecked {
127             _balances[sender] = senderBalance - amount;
128         }
129         _balances[recipient] += amount;
130 
131         emit Transfer(sender, recipient, amount);
132     }
133 
134     function _createInitialSupply(address account, uint256 amount) internal virtual {
135         require(account != address(0), "ERC20: mint to the zero address");
136 
137         _totalSupply += amount;
138         _balances[account] += amount;
139         emit Transfer(address(0), account, amount);
140     }
141 
142     function _burn(address account, uint256 amount) internal virtual {
143         require(account != address(0), "ERC20: burn from the zero address");
144         uint256 accountBalance = _balances[account];
145         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
146         unchecked {
147             _balances[account] = accountBalance - amount;
148             // Overflow not possible: amount <= accountBalance <= totalSupply.
149             _totalSupply -= amount;
150         }
151 
152         emit Transfer(account, address(0), amount);
153     }
154 
155     function _approve(
156         address owner,
157         address spender,
158         uint256 amount
159     ) internal virtual {
160         require(owner != address(0), "ERC20: approve from the zero address");
161         require(spender != address(0), "ERC20: approve to the zero address");
162 
163         _allowances[owner][spender] = amount;
164         emit Approval(owner, spender, amount);
165     }
166 }
167 
168 contract Ownable is Context {
169     address private _owner;
170 
171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
172 
173     constructor () {
174         address msgSender = _msgSender();
175         _owner = msgSender;
176         emit OwnershipTransferred(address(0), msgSender);
177     }
178 
179     function owner() public view returns (address) {
180         return _owner;
181     }
182 
183     modifier onlyOwner() {
184         require(_owner == _msgSender(), "Ownable: caller is not the owner");
185         _;
186     }
187 
188     function renounceOwnership() external virtual onlyOwner {
189         emit OwnershipTransferred(_owner, address(0));
190         _owner = address(0);
191     }
192 
193     function transferOwnership(address newOwner) public virtual onlyOwner {
194         require(newOwner != address(0), "Ownable: new owner is the zero address");
195         emit OwnershipTransferred(_owner, newOwner);
196         _owner = newOwner;
197     }
198 }
199 
200 interface IDexRouter {
201     function factory() external pure returns (address);
202     function WETH() external pure returns (address);
203 
204     function swapExactTokensForETHSupportingFeeOnTransferTokens(
205         uint amountIn,
206         uint amountOutMin,
207         address[] calldata path,
208         address to,
209         uint deadline
210     ) external;
211 
212     function swapExactETHForTokensSupportingFeeOnTransferTokens(
213         uint amountOutMin,
214         address[] calldata path,
215         address to,
216         uint deadline
217     ) external payable;
218 
219     function addLiquidityETH(
220         address token,
221         uint256 amountTokenDesired,
222         uint256 amountTokenMin,
223         uint256 amountETHMin,
224         address to,
225         uint256 deadline
226     )
227         external
228         payable
229         returns (
230             uint256 amountToken,
231             uint256 amountETH,
232             uint256 liquidity
233         );
234 }
235 
236 interface IDexFactory {
237     function createPair(address tokenA, address tokenB)
238         external
239         returns (address pair);
240 }
241 
242 contract Benu is ERC20, Ownable {
243 
244     uint256 public maxBuyAmount;
245     uint256 public maxSellAmount;
246     uint256 public maxWalletAmount;
247 
248     IDexRouter public dexRouter;
249     address public lpPair;
250 
251     bool private swapping;
252     uint256 public swapTokensAtAmount;
253 
254     address operationsAddress;
255     address devAddress;
256 
257     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
258     uint256 public blockForPenaltyEnd;
259     mapping (address => bool) public boughtEarly;
260     uint256 public botsCaught;
261 
262     bool public limitsInEffect = true;
263     bool public tradingActive = false;
264     bool public swapEnabled = false;
265 
266      // Anti-bot and anti-whale mappings and variables
267     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
268     bool public transferDelayEnabled = true;
269 
270     uint256 public buyTotalFees;
271     uint256 public buyOperationsFee;
272     uint256 public buyLiquidityFee;
273     uint256 public buyDevFee;
274     uint256 public buyBurnFee;
275 
276     uint256 public sellTotalFees;
277     uint256 public sellOperationsFee;
278     uint256 public sellLiquidityFee;
279     uint256 public sellDevFee;
280     uint256 public sellBurnFee;
281 
282     uint256 public tokensForOperations;
283     uint256 public tokensForLiquidity;
284     uint256 public tokensForDev;
285     uint256 public tokensForBurn;
286 
287     /******************/
288 
289     // exlcude from fees and max transaction amount
290     mapping (address => bool) private _isExcludedFromFees;
291     mapping (address => bool) public _isExcludedMaxTransactionAmount;
292 
293     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
294     // could be subject to a maximum transfer amount
295     mapping (address => bool) public automatedMarketMakerPairs;
296 
297     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
298 
299     event EnabledTrading();
300 
301     event RemovedLimits();
302 
303     event ExcludeFromFees(address indexed account, bool isExcluded);
304 
305     event UpdatedMaxBuyAmount(uint256 newAmount);
306 
307     event UpdatedMaxSellAmount(uint256 newAmount);
308 
309     event UpdatedMaxWalletAmount(uint256 newAmount);
310 
311     event UpdatedOperationsAddress(address indexed newWallet);
312 
313     event MaxTransactionExclusion(address _address, bool excluded);
314 
315     event BuyBackTriggered(uint256 amount);
316 
317     event OwnerForcedSwapBack(uint256 timestamp);
318 
319     event CaughtEarlyBuyer(address sniper);
320 
321     event SwapAndLiquify(
322         uint256 tokensSwapped,
323         uint256 ethReceived,
324         uint256 tokensIntoLiquidity
325     );
326 
327     event TransferForeignToken(address token, uint256 amount);
328 
329     constructor() ERC20("Benu", "BENU") {
330 
331         address newOwner = msg.sender; // can leave alone if owner is deployer.
332 
333         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
334         dexRouter = _dexRouter;
335 
336         // create pair
337         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
338         _excludeFromMaxTransaction(address(lpPair), true);
339         _setAutomatedMarketMakerPair(address(lpPair), true);
340 
341         uint256 totalSupply = 5 * 1e12 * 1e18;
342 
343         maxBuyAmount = totalSupply * 2 / 100;
344         maxSellAmount = totalSupply * 2 / 100;
345         maxWalletAmount = totalSupply * 2 / 100;
346         swapTokensAtAmount = totalSupply * 1 / 1000;
347 
348         buyOperationsFee = 20;
349         buyLiquidityFee = 0;
350         buyDevFee = 0;
351         buyBurnFee = 0;
352         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
353 
354         sellOperationsFee = 40;
355         sellLiquidityFee = 0;
356         sellDevFee = 0;
357         sellBurnFee = 0;
358         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
359 
360         _excludeFromMaxTransaction(newOwner, true);
361         _excludeFromMaxTransaction(address(this), true);
362         _excludeFromMaxTransaction(address(0xdead), true);
363 
364         excludeFromFees(newOwner, true);
365         excludeFromFees(address(this), true);
366         excludeFromFees(address(0xdead), true);
367 
368         operationsAddress = address(newOwner);
369         devAddress = address(newOwner);
370 
371         _createInitialSupply(newOwner, totalSupply);
372         transferOwnership(newOwner);
373     }
374 
375     receive() external payable {}
376 
377     function enableTrading(uint256 deadBlocks) external onlyOwner {
378         require(!tradingActive, "Cannot reenable trading");
379         tradingActive = true;
380         swapEnabled = true;
381         tradingActiveBlock = block.number;
382         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
383         emit EnabledTrading();
384     }
385 
386     function removeLimits() external onlyOwner {
387         limitsInEffect = false;
388         transferDelayEnabled = false;
389         emit RemovedLimits();
390     }
391 
392     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
393         boughtEarly[wallet] = flag;
394     }
395 
396     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
397         for(uint256 i = 0; i < wallets.length; i++){
398             boughtEarly[wallets[i]] = flag;
399         }
400     }
401 
402     // disable Transfer delay - cannot be reenabled
403     function disableTransferDelay() external onlyOwner {
404         transferDelayEnabled = false;
405     }
406 
407     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
408         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
409         maxBuyAmount = newNum * (10**18);
410         emit UpdatedMaxBuyAmount(maxBuyAmount);
411     }
412 
413     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
414         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
415         maxSellAmount = newNum * (10**18);
416         emit UpdatedMaxSellAmount(maxSellAmount);
417     }
418 
419     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
420         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
421         maxWalletAmount = newNum * (10**18);
422         emit UpdatedMaxWalletAmount(maxWalletAmount);
423     }
424 
425     // change the minimum amount of tokens to sell from fees
426     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
427   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
428   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
429   	    swapTokensAtAmount = newAmount;
430   	}
431 
432     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
433         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
434         emit MaxTransactionExclusion(updAds, isExcluded);
435     }
436 
437     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
438         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
439         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
440         for(uint256 i = 0; i < wallets.length; i++){
441             address wallet = wallets[i];
442             uint256 amount = amountsInTokens[i];
443             super._transfer(msg.sender, wallet, amount);
444         }
445     }
446 
447     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
448         if(!isEx){
449             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
450         }
451         _isExcludedMaxTransactionAmount[updAds] = isEx;
452     }
453 
454     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
455         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
456 
457         _setAutomatedMarketMakerPair(pair, value);
458         emit SetAutomatedMarketMakerPair(pair, value);
459     }
460 
461     function _setAutomatedMarketMakerPair(address pair, bool value) private {
462         automatedMarketMakerPairs[pair] = value;
463 
464         _excludeFromMaxTransaction(pair, value);
465 
466         emit SetAutomatedMarketMakerPair(pair, value);
467     }
468 
469     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
470         buyOperationsFee = _operationsFee;
471         buyLiquidityFee = _liquidityFee;
472         buyDevFee = _devFee;
473         buyBurnFee = _burnFee;
474         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
475         require(buyTotalFees <= 20, "Must keep fees at 10% or less");
476     }
477 
478     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
479         sellOperationsFee = _operationsFee;
480         sellLiquidityFee = _liquidityFee;
481         sellDevFee = _devFee;
482         sellBurnFee = _burnFee;
483         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
484         require(sellTotalFees <= 20, "Must keep fees at 10% or less");
485     }
486 
487     function returnToNormalTax() external onlyOwner {
488         sellOperationsFee = 0;
489         sellLiquidityFee = 0;
490         sellDevFee = 0;
491         sellBurnFee = 0;
492         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
493         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
494 
495         buyOperationsFee = 0;
496         buyLiquidityFee = 0;
497         buyDevFee = 0;
498         buyBurnFee = 0;
499         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
500         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
501     }
502 
503     function excludeFromFees(address account, bool excluded) public onlyOwner {
504         _isExcludedFromFees[account] = excluded;
505         emit ExcludeFromFees(account, excluded);
506     }
507 
508     function _transfer(address from, address to, uint256 amount) internal override {
509 
510         require(from != address(0), "ERC20: transfer from the zero address");
511         require(to != address(0), "ERC20: transfer to the zero address");
512         require(amount > 0, "amount must be greater than 0");
513 
514         if(!tradingActive){
515             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
516         }
517 
518         if(blockForPenaltyEnd > 0){
519             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
520         }
521 
522         if(limitsInEffect){
523             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
524 
525                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
526                 if (transferDelayEnabled){
527                     if (to != address(dexRouter) && to != address(lpPair)){
528                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
529                         _holderLastTransferTimestamp[tx.origin] = block.number;
530                         _holderLastTransferTimestamp[to] = block.number;
531                     }
532                 }
533     
534                 //when buy
535                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
536                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
537                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
538                 }
539                 //when sell
540                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
541                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
542                 }
543                 else if (!_isExcludedMaxTransactionAmount[to]){
544                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
545                 }
546             }
547         }
548 
549         uint256 contractTokenBalance = balanceOf(address(this));
550 
551         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
552 
553         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
554             swapping = true;
555 
556             swapBack();
557 
558             swapping = false;
559         }
560 
561         bool takeFee = true;
562         // if any account belongs to _isExcludedFromFee account then remove the fee
563         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
564             takeFee = false;
565         }
566 
567         uint256 fees = 0;
568         // only take fees on buys/sells, do not take on wallet transfers
569         if(takeFee){
570             // bot/sniper penalty.
571             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
572 
573                 if(!boughtEarly[to]){
574                     boughtEarly[to] = true;
575                     botsCaught += 1;
576                     emit CaughtEarlyBuyer(to);
577                 }
578 
579                 fees = amount * 99 / 100;
580         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
581                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
582                 tokensForDev += fees * buyDevFee / buyTotalFees;
583                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
584             }
585 
586             // on sell
587             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
588                 fees = amount * sellTotalFees / 100;
589                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
590                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
591                 tokensForDev += fees * sellDevFee / sellTotalFees;
592                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
593             }
594 
595             // on buy
596             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
597         	    fees = amount * buyTotalFees / 100;
598         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
599                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
600                 tokensForDev += fees * buyDevFee / buyTotalFees;
601                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
602             }
603 
604             if(fees > 0){
605                 super._transfer(from, address(this), fees);
606             }
607 
608         	amount -= fees;
609         }
610 
611         super._transfer(from, to, amount);
612     }
613 
614     function earlyBuyPenaltyInEffect() public view returns (bool){
615         return block.number < blockForPenaltyEnd;
616     }
617 
618     function swapTokensForEth(uint256 tokenAmount) private {
619 
620         // generate the uniswap pair path of token -> weth
621         address[] memory path = new address[](2);
622         path[0] = address(this);
623         path[1] = dexRouter.WETH();
624 
625         _approve(address(this), address(dexRouter), tokenAmount);
626 
627         // make the swap
628         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
629             tokenAmount,
630             0, // accept any amount of ETH
631             path,
632             address(this),
633             block.timestamp
634         );
635     }
636 
637     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
638         // approve token transfer to cover all possible scenarios
639         _approve(address(this), address(dexRouter), tokenAmount);
640 
641         // add the liquidity
642         dexRouter.addLiquidityETH{value: ethAmount}(
643             address(this),
644             tokenAmount,
645             0, // slippage is unavoidable
646             0, // slippage is unavoidable
647             address(0xdead),
648             block.timestamp
649         );
650     }
651 
652     function swapBack() private {
653 
654         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
655             _burn(address(this), tokensForBurn);
656         }
657         tokensForBurn = 0;
658 
659         uint256 contractBalance = balanceOf(address(this));
660         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
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
679         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
680 
681         ethForLiquidity -= ethForOperations + ethForDev;
682 
683         tokensForLiquidity = 0;
684         tokensForOperations = 0;
685         tokensForDev = 0;
686         tokensForBurn = 0;
687 
688         if(liquidityTokens > 0 && ethForLiquidity > 0){
689             addLiquidity(liquidityTokens, ethForLiquidity);
690         }
691 
692         (success,) = address(devAddress).call{value: ethForDev}("");
693 
694         (success,) = address(operationsAddress).call{value: address(this).balance}("");
695     }
696 
697     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
698         require(_token != address(0), "_token address cannot be 0");
699         require(_token != address(this), "Can't withdraw native tokens");
700         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
701         _sent = IERC20(_token).transfer(_to, _contractBalance);
702         emit TransferForeignToken(_token, _contractBalance);
703     }
704 
705     // withdraw ETH if stuck or someone sends to the address
706     function withdrawStuckETH() external onlyOwner {
707         bool success;
708         (success,) = address(msg.sender).call{value: address(this).balance}("");
709     }
710 
711     function setOperationsAddress(address _operationsAddress) external onlyOwner {
712         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
713         operationsAddress = payable(_operationsAddress);
714     }
715 
716     function setDevAddress(address _devAddress) external onlyOwner {
717         require(_devAddress != address(0), "_devAddress address cannot be 0");
718         devAddress = payable(_devAddress);
719     }
720 
721     function forceSwapBack() external onlyOwner {
722         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
723         swapping = true;
724         swapBack();
725         swapping = false;
726         emit OwnerForcedSwapBack(block.timestamp);
727     }
728 
729     function buyBackTokens(uint256 amountInWei) external onlyOwner {
730         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
731 
732         address[] memory path = new address[](2);
733         path[0] = dexRouter.WETH();
734         path[1] = address(this);
735 
736         // make the swap
737         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
738             0, // accept any amount of Ethereum
739             path,
740             address(0xdead),
741             block.timestamp
742         );
743         emit BuyBackTriggered(amountInWei);
744     }
745 }