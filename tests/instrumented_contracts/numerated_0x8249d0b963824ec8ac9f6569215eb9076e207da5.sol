1 /**
2 https://twitter.com/pekingese_erc
3 https://t.me/Pekingese_ERC20
4 https://pekingese.fans/
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.15;
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
23 
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36    
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 interface IERC20Metadata is IERC20 {
41     
42     function name() external view returns (string memory);
43     function symbol() external view returns (string memory);
44     function decimals() external view returns (uint8);
45 }
46 
47 contract ERC20 is Context, IERC20, IERC20Metadata {
48     mapping(address => uint256) private _balances;
49     mapping(address => mapping(address => uint256)) private _allowances;
50 
51     uint256 private _totalSupply;
52     string private _name;
53     string private _symbol;
54 
55     constructor(string memory name_, string memory symbol_) {
56         _name = name_;
57         _symbol = symbol_;
58     }
59 
60     function name() public view virtual override returns (string memory) {
61         return _name;
62     }
63 
64     function symbol() public view virtual override returns (string memory) {
65         return _symbol;
66     }
67 
68     function decimals() public view virtual override returns (uint8) {
69         return 18;
70     }
71 
72     function totalSupply() public view virtual override returns (uint256) {
73         return _totalSupply;
74     }
75 
76     function balanceOf(address account) public view virtual override returns (uint256) {
77         return _balances[account];
78     }
79 
80     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
81         _transfer(_msgSender(), recipient, amount);
82         return true;
83     }
84 
85     function allowance(address owner, address spender) public view virtual override returns (uint256) {
86         return _allowances[owner][spender];
87     }
88 
89     function approve(address spender, uint256 amount) public virtual override returns (bool) {
90         _approve(_msgSender(), spender, amount);
91         return true;
92     }
93 
94     function transferFrom(
95         address sender,
96         address recipient,
97         uint256 amount
98     ) public virtual override returns (bool) {
99         _transfer(sender, recipient, amount);
100 
101         uint256 currentAllowance = _allowances[sender][_msgSender()];
102         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
103         unchecked {
104             _approve(sender, _msgSender(), currentAllowance - amount);
105         }
106 
107         return true;
108     }
109 
110     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
111         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
112         return true;
113     }
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
116         uint256 currentAllowance = _allowances[_msgSender()][spender];
117         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
118         unchecked {
119             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
120         }
121 
122         return true;
123     }
124 
125     function _transfer(
126         address sender,
127         address recipient,
128         uint256 amount
129     ) internal virtual {
130         require(sender != address(0), "ERC20: transfer from the zero address");
131         require(recipient != address(0), "ERC20: transfer to the zero address");
132 
133         uint256 senderBalance = _balances[sender];
134         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
135         unchecked {
136             _balances[sender] = senderBalance - amount;
137         }
138         _balances[recipient] += amount;
139 
140         emit Transfer(sender, recipient, amount);
141     }
142 
143     function _createInitialSupply(address account, uint256 amount) internal virtual {
144         require(account != address(0), "ERC20: mint to the zero address");
145 
146         _totalSupply += amount;
147         _balances[account] += amount;
148         emit Transfer(address(0), account, amount);
149     }
150 
151     function _burn(address account, uint256 amount) internal virtual {
152         require(account != address(0), "ERC20: burn from the zero address");
153         uint256 accountBalance = _balances[account];
154         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
155         unchecked {
156             _balances[account] = accountBalance - amount;
157             // Overflow not possible: amount <= accountBalance <= totalSupply.
158             _totalSupply -= amount;
159         }
160 
161         emit Transfer(account, address(0), amount);
162     }
163 
164     function _approve(
165         address owner,
166         address spender,
167         uint256 amount
168     ) internal virtual {
169         require(owner != address(0), "ERC20: approve from the zero address");
170         require(spender != address(0), "ERC20: approve to the zero address");
171 
172         _allowances[owner][spender] = amount;
173         emit Approval(owner, spender, amount);
174     }
175 }
176 
177 contract Ownable is Context {
178     address private _owner;
179 
180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
181 
182     constructor () {
183         address msgSender = _msgSender();
184         _owner = msgSender;
185         emit OwnershipTransferred(address(0), msgSender);
186     }
187 
188     function owner() public view returns (address) {
189         return _owner;
190     }
191 
192     modifier onlyOwner() {
193         require(_owner == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196 
197     function renounceOwnership() external virtual onlyOwner {
198         emit OwnershipTransferred(_owner, address(0));
199         _owner = address(0);
200     }
201 
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         emit OwnershipTransferred(_owner, newOwner);
205         _owner = newOwner;
206     }
207 }
208 
209 interface IDexRouter {
210     function factory() external pure returns (address);
211     function WETH() external pure returns (address);
212 
213     function swapExactTokensForETHSupportingFeeOnTransferTokens(
214         uint amountIn,
215         uint amountOutMin,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external;
220 
221     function swapExactETHForTokensSupportingFeeOnTransferTokens(
222         uint amountOutMin,
223         address[] calldata path,
224         address to,
225         uint deadline
226     ) external payable;
227 
228     function addLiquidityETH(
229         address token,
230         uint256 amountTokenDesired,
231         uint256 amountTokenMin,
232         uint256 amountETHMin,
233         address to,
234         uint256 deadline
235     )
236         external
237         payable
238         returns (
239             uint256 amountToken,
240             uint256 amountETH,
241             uint256 liquidity
242         );
243 }
244 
245 interface IDexFactory {
246     function createPair(address tokenA, address tokenB)
247         external
248         returns (address pair);
249 }
250 
251 contract Pek is ERC20, Ownable {
252 
253     uint256 public maxBuyAmount;
254     uint256 public maxSellAmount;
255     uint256 public maxWalletAmount;
256 
257     IDexRouter public dexRouter;
258     address public lpPair;
259 
260     bool private swapping;
261     uint256 public swapTokensAtAmount;
262 
263     address operationsAddress;
264     address devAddress;
265 
266     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
267     uint256 public blockForPenaltyEnd;
268     mapping (address => bool) public boughtEarly;
269     uint256 public botsCaught;
270 
271     bool public limitsInEffect = true;
272     bool public tradingActive = false;
273     bool public swapEnabled = false;
274 
275      // Anti-bot and anti-whale mappings and variables
276     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
277     bool public transferDelayEnabled = true;
278 
279     uint256 public buyTotalFees;
280     uint256 public buyOperationsFee;
281     uint256 public buyLiquidityFee;
282     uint256 public buyDevFee;
283     uint256 public buyBurnFee;
284 
285     uint256 public sellTotalFees;
286     uint256 public sellOperationsFee;
287     uint256 public sellLiquidityFee;
288     uint256 public sellDevFee;
289     uint256 public sellBurnFee;
290 
291     uint256 public tokensForOperations;
292     uint256 public tokensForLiquidity;
293     uint256 public tokensForDev;
294     uint256 public tokensForBurn;
295 
296     /******************/
297 
298     // exlcude from fees and max transaction amount
299     mapping (address => bool) private _isExcludedFromFees;
300     mapping (address => bool) public _isExcludedMaxTransactionAmount;
301 
302     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
303     // could be subject to a maximum transfer amount
304     mapping (address => bool) public automatedMarketMakerPairs;
305 
306     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
307     event EnabledTrading();
308     event RemovedLimits();
309     event ExcludeFromFees(address indexed account, bool isExcluded);
310     event UpdatedMaxBuyAmount(uint256 newAmount);
311     event UpdatedMaxSellAmount(uint256 newAmount);
312     event UpdatedMaxWalletAmount(uint256 newAmount);
313     event UpdatedOperationsAddress(address indexed newWallet);
314     event MaxTransactionExclusion(address _address, bool excluded);
315     event BuyBackTriggered(uint256 amount);
316     event OwnerForcedSwapBack(uint256 timestamp);
317     event CaughtEarlyBuyer(address sniper);
318     event SwapAndLiquify(
319         uint256 tokensSwapped,
320         uint256 ethReceived,
321         uint256 tokensIntoLiquidity
322     );
323 
324     event TransferForeignToken(address token, uint256 amount);
325 
326     constructor() ERC20("Pekingese", "Pek") {
327 
328         address newOwner = msg.sender; // can leave alone if owner is deployer.
329 
330         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
331         dexRouter = _dexRouter;
332 
333         // create pair
334         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
335         _excludeFromMaxTransaction(address(lpPair), true);
336         _setAutomatedMarketMakerPair(address(lpPair), true);
337 
338         uint256 totalSupply = 1 * 1e7 * 1e18;
339 
340         maxBuyAmount = totalSupply * 1 / 200;
341         maxSellAmount = totalSupply * 1 / 100;
342         maxWalletAmount = totalSupply * 1 / 100;
343         swapTokensAtAmount = totalSupply * 5 / 10000;
344 
345         buyOperationsFee = 0;
346         buyLiquidityFee = 0;
347         buyDevFee = 0;
348         buyBurnFee = 0;
349         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
350 
351         sellOperationsFee = 0;
352         sellLiquidityFee = 0;
353         sellDevFee = 0;
354         sellBurnFee = 0;
355         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
356 
357         _excludeFromMaxTransaction(newOwner, true);
358         _excludeFromMaxTransaction(address(this), true);
359         _excludeFromMaxTransaction(address(0xdead), true);
360 
361         excludeFromFees(newOwner, true);
362         excludeFromFees(address(this), true);
363         excludeFromFees(address(0xdead), true);
364 
365         operationsAddress = address(newOwner);
366         devAddress = address(newOwner);
367 
368         _createInitialSupply(newOwner, totalSupply);
369         transferOwnership(newOwner);
370     }
371 
372     receive() external payable {}
373 
374 
375     function enableTrading(uint256 deadBlocks) external onlyOwner {
376         require(!tradingActive, "Cannot reenable trading");
377         tradingActive = true;
378         swapEnabled = true;
379         tradingActiveBlock = block.number;
380         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
381         emit EnabledTrading();
382     }
383 
384 
385     function removeLimits() external onlyOwner {
386         limitsInEffect = false;
387         transferDelayEnabled = false;
388         emit RemovedLimits();
389     }
390 
391     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
392         boughtEarly[wallet] = flag;
393     }
394 
395     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
396         for(uint256 i = 0; i < wallets.length; i++){
397             boughtEarly[wallets[i]] = flag;
398         }
399     }
400 
401     // disable Transfer delay - cannot be reenabled
402     function disableTransferDelay() external onlyOwner {
403         transferDelayEnabled = false;
404     }
405 
406     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
407         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
408         maxBuyAmount = newNum * (10**18);
409         emit UpdatedMaxBuyAmount(maxBuyAmount);
410     }
411 
412     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
413         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
414         maxSellAmount = newNum * (10**18);
415         emit UpdatedMaxSellAmount(maxSellAmount);
416     }
417 
418     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
419         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
420         maxWalletAmount = newNum * (10**18);
421         emit UpdatedMaxWalletAmount(maxWalletAmount);
422     }
423 
424     // change the minimum amount of tokens to sell from fees
425     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
426   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
427   	    require(newAmount <= totalSupply() * 1 / 5000, "Swap amount cannot be higher than 0.5% total supply.");
428   	    swapTokensAtAmount = newAmount;
429   	}
430 
431     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
432         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
433         emit MaxTransactionExclusion(updAds, isExcluded);
434     }
435 
436     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
437         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
438         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
439         for(uint256 i = 0; i < wallets.length; i++){
440             address wallet = wallets[i];
441             uint256 amount = amountsInTokens[i];
442             super._transfer(msg.sender, wallet, amount);
443         }
444     }
445 
446     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
447         if(!isEx){
448             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
449         }
450         _isExcludedMaxTransactionAmount[updAds] = isEx;
451     }
452 
453     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
454         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
455 
456         _setAutomatedMarketMakerPair(pair, value);
457         emit SetAutomatedMarketMakerPair(pair, value);
458     }
459 
460     function _setAutomatedMarketMakerPair(address pair, bool value) private {
461         automatedMarketMakerPairs[pair] = value;
462 
463         _excludeFromMaxTransaction(pair, value);
464 
465         emit SetAutomatedMarketMakerPair(pair, value);
466     }
467 
468     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
469         buyOperationsFee = _operationsFee;
470         buyLiquidityFee = _liquidityFee;
471         buyDevFee = _DevFee;
472         buyBurnFee = _burnFee;
473         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
474         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
475     }
476 
477     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
478         sellOperationsFee = _operationsFee;
479         sellLiquidityFee = _liquidityFee;
480         sellDevFee = _DevFee;
481         sellBurnFee = _burnFee;
482         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
483         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
484     }
485 
486     function returnToNormalTax() external onlyOwner {
487         sellOperationsFee = 20;
488         sellLiquidityFee = 0;
489         sellDevFee = 0;
490         sellBurnFee = 0;
491         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
492         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
493 
494         buyOperationsFee = 15;
495         buyLiquidityFee = 0;
496         buyDevFee = 0;
497         buyBurnFee = 0;
498         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
499         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
500     }
501 
502     function excludeFromFees(address account, bool excluded) public onlyOwner {
503         _isExcludedFromFees[account] = excluded;
504         emit ExcludeFromFees(account, excluded);
505     }
506 
507     function _transfer(address from, address to, uint256 amount) internal override {
508 
509         require(from != address(0), "ERC20: transfer from the zero address");
510         require(to != address(0), "ERC20: transfer to the zero address");
511         require(amount > 0, "amount must be greater than 0");
512 
513         if(!tradingActive){
514             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
515         }
516 
517         if(blockForPenaltyEnd > 0){
518             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
519         }
520 
521         if(limitsInEffect){
522             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
523 
524                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
525                 if (transferDelayEnabled){
526                     if (to != address(dexRouter) && to != address(lpPair)){
527                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
528                         _holderLastTransferTimestamp[tx.origin] = block.number;
529                         _holderLastTransferTimestamp[to] = block.number;
530                     }
531                 }
532 
533                 //when buy
534                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
535                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
536                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
537                 }
538                 //when sell
539                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
540                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
541                 }
542                 else if (!_isExcludedMaxTransactionAmount[to]){
543                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
544                 }
545             }
546         }
547 
548         uint256 contractTokenBalance = balanceOf(address(this));
549 
550         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
551 
552         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
553             swapping = true;
554 
555             swapBack();
556 
557             swapping = false;
558         }
559 
560         bool takeFee = true;
561         // if any account belongs to _isExcludedFromFee account then remove the fee
562         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
563             takeFee = false;
564         }
565 
566         uint256 fees = 0;
567         // only take fees on buys/sells, do not take on wallet transfers
568         if(takeFee){
569             // bot/sniper penalty.
570             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
571 
572                 if(!boughtEarly[to]){
573                     boughtEarly[to] = true;
574                     botsCaught += 1;
575                     emit CaughtEarlyBuyer(to);
576                 }
577 
578                 fees = amount * 99 / 100;
579         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
580                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
581                 tokensForDev += fees * buyDevFee / buyTotalFees;
582                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
583             }
584 
585             // on sell
586             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
587                 fees = amount * sellTotalFees / 100;
588                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
589                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
590                 tokensForDev += fees * sellDevFee / sellTotalFees;
591                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
592             }
593 
594             // on buy
595             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
596         	    fees = amount * buyTotalFees / 100;
597         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
598                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
599                 tokensForDev += fees * buyDevFee / buyTotalFees;
600                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
601             }
602 
603             if(fees > 0){
604                 super._transfer(from, address(this), fees);
605             }
606 
607         	amount -= fees;
608         }
609 
610         super._transfer(from, to, amount);
611     }
612 
613     function earlyBuyPenaltyInEffect() public view returns (bool){
614         return block.number < blockForPenaltyEnd;
615     }
616 
617     function swapTokensForEth(uint256 tokenAmount) private {
618 
619         // generate the uniswap pair path of token -> weth
620         address[] memory path = new address[](2);
621         path[0] = address(this);
622         path[1] = dexRouter.WETH();
623 
624         _approve(address(this), address(dexRouter), tokenAmount);
625 
626         // make the swap
627         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
628             tokenAmount,
629             0, // accept any amount of ETH
630             path,
631             address(this),
632             block.timestamp
633         );
634     }
635 
636     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
637         // approve token transfer to cover all possible scenarios
638         _approve(address(this), address(dexRouter), tokenAmount);
639 
640         // add the liquidity
641         dexRouter.addLiquidityETH{value: ethAmount}(
642             address(this),
643             tokenAmount,
644             0, // slippage is unavoidable
645             0, // slippage is unavoidable
646             address(0xdead),
647             block.timestamp
648         );
649     }
650 
651     function swapBack() private {
652 
653         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
654             _burn(address(this), tokensForBurn);
655         }
656         tokensForBurn = 0;
657 
658         uint256 contractBalance = balanceOf(address(this));
659         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
660 
661         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
662 
663         if(contractBalance > swapTokensAtAmount * 20){
664             contractBalance = swapTokensAtAmount * 20;
665         }
666 
667         bool success;
668 
669         // Halve the amount of liquidity tokens
670         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
671 
672         swapTokensForEth(contractBalance - liquidityTokens);
673 
674         uint256 ethBalance = address(this).balance;
675         uint256 ethForLiquidity = ethBalance;
676 
677         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
678         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
679 
680         ethForLiquidity -= ethForOperations + ethForDev;
681 
682         tokensForLiquidity = 0;
683         tokensForOperations = 0;
684         tokensForDev = 0;
685         tokensForBurn = 0;
686 
687         if(liquidityTokens > 0 && ethForLiquidity > 0){
688             addLiquidity(liquidityTokens, ethForLiquidity);
689         }
690 
691         (success,) = address(devAddress).call{value: ethForDev}("");
692 
693         (success,) = address(operationsAddress).call{value: address(this).balance}("");
694     }
695 
696     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
697         require(_token != address(0), "_token address cannot be 0");
698         require(_token != address(this), "Can't withdraw native tokens");
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
715     function setDevAddress(address _devAddress) external onlyOwner {
716         require(_devAddress != address(0), "_devAddress address cannot be 0");
717         devAddress = payable(_devAddress);
718     }
719 
720     // force Swap back if slippage issues.
721     function forceSwapBack() external onlyOwner {
722         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
723         swapping = true;
724         swapBack();
725         swapping = false;
726         emit OwnerForcedSwapBack(block.timestamp);
727     }
728 
729     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
730     function buyBackTokens(uint256 amountInWei) external onlyOwner {
731         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
732 
733         address[] memory path = new address[](2);
734         path[0] = dexRouter.WETH();
735         path[1] = address(this);
736 
737         // make the swap
738         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
739             0, // accept any amount of Ethereum
740             path,
741             address(0xdead),
742             block.timestamp
743         );
744         emit BuyBackTriggered(amountInWei);
745     }
746 }