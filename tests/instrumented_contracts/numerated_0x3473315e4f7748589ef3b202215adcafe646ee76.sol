1 /**
2 
3         h t t p s : / / t . m e / e d g e p o   
4 ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
5                                             |r 
6                                             | 
7                                             |
8                                             |t
9                                             |
10                                             |
11                                             |a
12                                             |
13                                             |
14                                             |
15                                             |l
16                                             |
17                                             |
18                                             |
19                                             |
20                                             |
21                                             |
22 
23 
24 
25 
26 */
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity 0.8.15;
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 interface IERC20 {
44 
45     function totalSupply() external view returns (uint256);
46     function balanceOf(address account) external view returns (uint256);
47     function transfer(address recipient, uint256 amount) external returns (bool);
48     function allowance(address owner, address spender) external view returns (uint256);
49     function approve(address spender, uint256 amount) external returns (bool);
50     function transferFrom(
51         address sender,
52         address recipient,
53         uint256 amount
54     ) external returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57    
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 interface IERC20Metadata is IERC20 {
62     
63     function name() external view returns (string memory);
64     function symbol() external view returns (string memory);
65     function decimals() external view returns (uint8);
66 }
67 
68 contract ERC20 is Context, IERC20, IERC20Metadata {
69     mapping(address => uint256) private _balances;
70     mapping(address => mapping(address => uint256)) private _allowances;
71 
72     uint256 private _totalSupply;
73     string private _name;
74     string private _symbol;
75 
76     constructor(string memory name_, string memory symbol_) {
77         _name = name_;
78         _symbol = symbol_;
79     }
80 
81     function name() public view virtual override returns (string memory) {
82         return _name;
83     }
84 
85     function symbol() public view virtual override returns (string memory) {
86         return _symbol;
87     }
88 
89     function decimals() public view virtual override returns (uint8) {
90         return 18;
91     }
92 
93     function totalSupply() public view virtual override returns (uint256) {
94         return _totalSupply;
95     }
96 
97     function balanceOf(address account) public view virtual override returns (uint256) {
98         return _balances[account];
99     }
100 
101     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
102         _transfer(_msgSender(), recipient, amount);
103         return true;
104     }
105 
106     function allowance(address owner, address spender) public view virtual override returns (uint256) {
107         return _allowances[owner][spender];
108     }
109 
110     function approve(address spender, uint256 amount) public virtual override returns (bool) {
111         _approve(_msgSender(), spender, amount);
112         return true;
113     }
114 
115     function transferFrom(
116         address sender,
117         address recipient,
118         uint256 amount
119     ) public virtual override returns (bool) {
120         _transfer(sender, recipient, amount);
121 
122         uint256 currentAllowance = _allowances[sender][_msgSender()];
123         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
124         unchecked {
125             _approve(sender, _msgSender(), currentAllowance - amount);
126         }
127 
128         return true;
129     }
130 
131     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
132         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
133         return true;
134     }
135 
136     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
137         uint256 currentAllowance = _allowances[_msgSender()][spender];
138         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
139         unchecked {
140             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
141         }
142 
143         return true;
144     }
145 
146     function _transfer(
147         address sender,
148         address recipient,
149         uint256 amount
150     ) internal virtual {
151         require(sender != address(0), "ERC20: transfer from the zero address");
152         require(recipient != address(0), "ERC20: transfer to the zero address");
153 
154         uint256 senderBalance = _balances[sender];
155         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
156         unchecked {
157             _balances[sender] = senderBalance - amount;
158         }
159         _balances[recipient] += amount;
160 
161         emit Transfer(sender, recipient, amount);
162     }
163 
164     function _createInitialSupply(address account, uint256 amount) internal virtual {
165         require(account != address(0), "ERC20: mint to the zero address");
166 
167         _totalSupply += amount;
168         _balances[account] += amount;
169         emit Transfer(address(0), account, amount);
170     }
171 
172     function _burn(address account, uint256 amount) internal virtual {
173         require(account != address(0), "ERC20: burn from the zero address");
174         uint256 accountBalance = _balances[account];
175         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
176         unchecked {
177             _balances[account] = accountBalance - amount;
178             // Overflow not possible: amount <= accountBalance <= totalSupply.
179             _totalSupply -= amount;
180         }
181 
182         emit Transfer(account, address(0), amount);
183     }
184 
185     function _approve(
186         address owner,
187         address spender,
188         uint256 amount
189     ) internal virtual {
190         require(owner != address(0), "ERC20: approve from the zero address");
191         require(spender != address(0), "ERC20: approve to the zero address");
192 
193         _allowances[owner][spender] = amount;
194         emit Approval(owner, spender, amount);
195     }
196 }
197 
198 contract Ownable is Context {
199     address private _owner;
200 
201     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203     constructor () {
204         address msgSender = _msgSender();
205         _owner = msgSender;
206         emit OwnershipTransferred(address(0), msgSender);
207     }
208 
209     function owner() public view returns (address) {
210         return _owner;
211     }
212 
213     modifier onlyOwner() {
214         require(_owner == _msgSender(), "Ownable: caller is not the owner");
215         _;
216     }
217 
218     function renounceOwnership() external virtual onlyOwner {
219         emit OwnershipTransferred(_owner, address(0));
220         _owner = address(0);
221     }
222 
223     function transferOwnership(address newOwner) public virtual onlyOwner {
224         require(newOwner != address(0), "Ownable: new owner is the zero address");
225         emit OwnershipTransferred(_owner, newOwner);
226         _owner = newOwner;
227     }
228 }
229 
230 interface IDexRouter {
231     function factory() external pure returns (address);
232     function WETH() external pure returns (address);
233 
234     function swapExactTokensForETHSupportingFeeOnTransferTokens(
235         uint amountIn,
236         uint amountOutMin,
237         address[] calldata path,
238         address to,
239         uint deadline
240     ) external;
241 
242     function swapExactETHForTokensSupportingFeeOnTransferTokens(
243         uint amountOutMin,
244         address[] calldata path,
245         address to,
246         uint deadline
247     ) external payable;
248 
249     function addLiquidityETH(
250         address token,
251         uint256 amountTokenDesired,
252         uint256 amountTokenMin,
253         uint256 amountETHMin,
254         address to,
255         uint256 deadline
256     )
257         external
258         payable
259         returns (
260             uint256 amountToken,
261             uint256 amountETH,
262             uint256 liquidity
263         );
264 }
265 
266 interface IDexFactory {
267     function createPair(address tokenA, address tokenB)
268         external
269         returns (address pair);
270 }
271 
272 contract EDGE is ERC20, Ownable {
273 
274     uint256 public maxBuyAmount;
275     uint256 public maxSellAmount;
276     uint256 public maxWalletAmount;
277 
278     IDexRouter public dexRouter;
279     address public lpPair;
280 
281     bool private swapping;
282     uint256 public swapTokensAtAmount;
283 
284     address operationsAddress;
285     address devAddress;
286 
287     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
288     uint256 public blockForPenaltyEnd = 0;
289     mapping (address => bool) public boughtEarly;
290     uint256 public botsCaught;
291 
292     bool public limitsInEffect = true;
293     bool public tradingActive = false;
294     bool public swapEnabled = false;
295 
296      // Anti-bot and anti-whale mappings and variables
297     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
298     bool public transferDelayEnabled = true;
299 
300     uint256 public buyTotalFees;
301     uint256 public buyOperationsFee;
302     uint256 public buyLiquidityFee;
303     uint256 public buyDevFee;
304     uint256 public buyBurnFee;
305 
306     uint256 public sellTotalFees;
307     uint256 public sellOperationsFee;
308     uint256 public sellLiquidityFee;
309     uint256 public sellDevFee;
310     uint256 public sellBurnFee;
311 
312     uint256 public tokensForOperations;
313     uint256 public tokensForLiquidity;
314     uint256 public tokensForDev;
315     uint256 public tokensForBurn;
316 
317     /******************/
318 
319     // exlcude from fees and max transaction amount
320     mapping (address => bool) private _isExcludedFromFees;
321     mapping (address => bool) public _isExcludedMaxTransactionAmount;
322 
323     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
324     // could be subject to a maximum transfer amount
325     mapping (address => bool) public automatedMarketMakerPairs;
326 
327     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
328 
329     event EnabledTrading();
330 
331     event RemovedLimits();
332 
333     event ExcludeFromFees(address indexed account, bool isExcluded);
334 
335     event UpdatedMaxBuyAmount(uint256 newAmount);
336 
337     event UpdatedMaxSellAmount(uint256 newAmount);
338 
339     event UpdatedMaxWalletAmount(uint256 newAmount);
340 
341     event UpdatedOperationsAddress(address indexed newWallet);
342 
343     event MaxTransactionExclusion(address _address, bool excluded);
344 
345     event BuyBackTriggered(uint256 amount);
346 
347     event OwnerForcedSwapBack(uint256 timestamp);
348 
349     event CaughtEarlyBuyer(address sniper);
350 
351     event SwapAndLiquify(
352         uint256 tokensSwapped,
353         uint256 ethReceived,
354         uint256 tokensIntoLiquidity
355     );
356 
357     event TransferForeignToken(address token, uint256 amount);
358 
359     constructor() ERC20("The Edge", "ED|GE") {
360 
361         address newOwner = msg.sender; // can leave alone if owner is deployer.
362 
363         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
364         dexRouter = _dexRouter;
365 
366         // create pair
367         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
368         _excludeFromMaxTransaction(address(lpPair), true);
369         _setAutomatedMarketMakerPair(address(lpPair), true);
370 
371         uint256 totalSupply = 1 * 1e9 * 1e18;
372 
373         maxBuyAmount = totalSupply * 2 / 100;
374         maxSellAmount = totalSupply * 2 / 100;
375         maxWalletAmount = totalSupply * 2 / 100;
376         swapTokensAtAmount = totalSupply * 5 / 10000;
377 
378         buyOperationsFee = 0;
379         buyLiquidityFee = 5;
380         buyDevFee = 0;
381         buyBurnFee = 0;
382         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
383 
384         sellOperationsFee = 20;
385         sellLiquidityFee = 5;
386         sellDevFee = 0;
387         sellBurnFee = 0;
388         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
389 
390         _excludeFromMaxTransaction(newOwner, true);
391         _excludeFromMaxTransaction(address(this), true);
392         _excludeFromMaxTransaction(address(0xdead), true);
393 
394         excludeFromFees(newOwner, true);
395         excludeFromFees(address(this), true);
396         excludeFromFees(address(0xdead), true);
397 
398         operationsAddress = address(newOwner);
399         devAddress = address(newOwner);
400 
401         _createInitialSupply(newOwner, totalSupply);
402         transferOwnership(newOwner);
403     }
404 
405     receive() external payable {}
406 
407     // only enable if no plan to airdrop
408 
409     function enableTrading() external onlyOwner {
410         require(!tradingActive, "Cannot reenable trading");
411         tradingActive = true;
412         swapEnabled = true;
413         tradingActiveBlock = block.number;
414         emit EnabledTrading();
415     }
416 
417     // remove limits after token is stable
418     function removeLimits() external onlyOwner {
419         limitsInEffect = false;
420         transferDelayEnabled = false;
421         emit RemovedLimits();
422     }
423 
424     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
425         boughtEarly[wallet] = flag;
426     }
427 
428     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
429         for(uint256 i = 0; i < wallets.length; i++){
430             boughtEarly[wallets[i]] = flag;
431         }
432     }
433 
434     // disable Transfer delay - cannot be reenabled
435     function disableTransferDelay() external onlyOwner {
436         transferDelayEnabled = false;
437     }
438 
439     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
440         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
441         maxBuyAmount = newNum * (10**18);
442         emit UpdatedMaxBuyAmount(maxBuyAmount);
443     }
444 
445     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
446         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
447         maxSellAmount = newNum * (10**18);
448         emit UpdatedMaxSellAmount(maxSellAmount);
449     }
450 
451     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
452         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
453         maxWalletAmount = newNum * (10**18);
454         emit UpdatedMaxWalletAmount(maxWalletAmount);
455     }
456 
457     // change the minimum amount of tokens to sell from fees
458     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
459   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
460   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
461   	    swapTokensAtAmount = newAmount;
462   	}
463 
464     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
465         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
466         emit MaxTransactionExclusion(updAds, isExcluded);
467     }
468 
469     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
470         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
471         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
472         for(uint256 i = 0; i < wallets.length; i++){
473             address wallet = wallets[i];
474             uint256 amount = amountsInTokens[i];
475             super._transfer(msg.sender, wallet, amount);
476         }
477     }
478 
479     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
480         if(!isEx){
481             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
482         }
483         _isExcludedMaxTransactionAmount[updAds] = isEx;
484     }
485 
486     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
487         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
488 
489         _setAutomatedMarketMakerPair(pair, value);
490         emit SetAutomatedMarketMakerPair(pair, value);
491     }
492 
493     function _setAutomatedMarketMakerPair(address pair, bool value) private {
494         automatedMarketMakerPairs[pair] = value;
495 
496         _excludeFromMaxTransaction(pair, value);
497 
498         emit SetAutomatedMarketMakerPair(pair, value);
499     }
500 
501     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
502         buyOperationsFee = _operationsFee;
503         buyLiquidityFee = _liquidityFee;
504         buyDevFee = _DevFee;
505         buyBurnFee = _burnFee;
506         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
507         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
508     }
509 
510     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
511         sellOperationsFee = _operationsFee;
512         sellLiquidityFee = _liquidityFee;
513         sellDevFee = _DevFee;
514         sellBurnFee = _burnFee;
515         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
516         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
517     }
518 
519     function returnToNormalTax() external onlyOwner {
520         sellOperationsFee = 20;
521         sellLiquidityFee = 0;
522         sellDevFee = 0;
523         sellBurnFee = 0;
524         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
525         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
526 
527         buyOperationsFee = 20;
528         buyLiquidityFee = 0;
529         buyDevFee = 0;
530         buyBurnFee = 0;
531         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
532         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
533     }
534 
535     function excludeFromFees(address account, bool excluded) public onlyOwner {
536         _isExcludedFromFees[account] = excluded;
537         emit ExcludeFromFees(account, excluded);
538     }
539 
540     function _transfer(address from, address to, uint256 amount) internal override {
541 
542         require(from != address(0), "ERC20: transfer from the zero address");
543         require(to != address(0), "ERC20: transfer to the zero address");
544         require(amount > 0, "amount must be greater than 0");
545 
546         if(!tradingActive){
547             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
548         }
549 
550         if(blockForPenaltyEnd > 0){
551             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
552         }
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
602             // bot/sniper penalty.
603             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
604 
605                 if(!boughtEarly[to]){
606                     boughtEarly[to] = true;
607                     botsCaught += 1;
608                     emit CaughtEarlyBuyer(to);
609                 }
610 
611                 fees = amount * 99 / 100;
612         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
613                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
614                 tokensForDev += fees * buyDevFee / buyTotalFees;
615                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
616             }
617 
618             // on sell
619             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
620                 fees = amount * sellTotalFees / 100;
621                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
622                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
623                 tokensForDev += fees * sellDevFee / sellTotalFees;
624                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
625             }
626 
627             // on buy
628             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
629         	    fees = amount * buyTotalFees / 100;
630         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
631                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
632                 tokensForDev += fees * buyDevFee / buyTotalFees;
633                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
634             }
635 
636             if(fees > 0){
637                 super._transfer(from, address(this), fees);
638             }
639 
640         	amount -= fees;
641         }
642 
643         super._transfer(from, to, amount);
644     }
645 
646     function earlyBuyPenaltyInEffect() public view returns (bool){
647         return block.number < blockForPenaltyEnd;
648     }
649 
650     function swapTokensForEth(uint256 tokenAmount) private {
651 
652         // generate the uniswap pair path of token -> weth
653         address[] memory path = new address[](2);
654         path[0] = address(this);
655         path[1] = dexRouter.WETH();
656 
657         _approve(address(this), address(dexRouter), tokenAmount);
658 
659         // make the swap
660         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
661             tokenAmount,
662             0, // accept any amount of ETH
663             path,
664             address(this),
665             block.timestamp
666         );
667     }
668 
669     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
670         // approve token transfer to cover all possible scenarios
671         _approve(address(this), address(dexRouter), tokenAmount);
672 
673         // add the liquidity
674         dexRouter.addLiquidityETH{value: ethAmount}(
675             address(this),
676             tokenAmount,
677             0, // slippage is unavoidable
678             0, // slippage is unavoidable
679             address(0xdead),
680             block.timestamp
681         );
682     }
683 
684     function swapBack() private {
685 
686         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
687             _burn(address(this), tokensForBurn);
688         }
689         tokensForBurn = 0;
690 
691         uint256 contractBalance = balanceOf(address(this));
692         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
693 
694         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
695 
696         if(contractBalance > swapTokensAtAmount * 20){
697             contractBalance = swapTokensAtAmount * 20;
698         }
699 
700         bool success;
701 
702         // Halve the amount of liquidity tokens
703         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
704 
705         swapTokensForEth(contractBalance - liquidityTokens);
706 
707         uint256 ethBalance = address(this).balance;
708         uint256 ethForLiquidity = ethBalance;
709 
710         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
711         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
712 
713         ethForLiquidity -= ethForOperations + ethForDev;
714 
715         tokensForLiquidity = 0;
716         tokensForOperations = 0;
717         tokensForDev = 0;
718         tokensForBurn = 0;
719 
720         if(liquidityTokens > 0 && ethForLiquidity > 0){
721             addLiquidity(liquidityTokens, ethForLiquidity);
722         }
723 
724         (success,) = address(devAddress).call{value: ethForDev}("");
725 
726         (success,) = address(operationsAddress).call{value: address(this).balance}("");
727     }
728 
729     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
730         require(_token != address(0), "_token address cannot be 0");
731         require(_token != address(this), "Can't withdraw native tokens");
732         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
733         _sent = IERC20(_token).transfer(_to, _contractBalance);
734         emit TransferForeignToken(_token, _contractBalance);
735     }
736 
737     // withdraw ETH if stuck or someone sends to the address
738     function withdrawStuckETH() external onlyOwner {
739         bool success;
740         (success,) = address(msg.sender).call{value: address(this).balance}("");
741     }
742 
743     function setOperationsAddress(address _operationsAddress) external onlyOwner {
744         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
745         operationsAddress = payable(_operationsAddress);
746     }
747 
748     function setDevAddress(address _devAddress) external onlyOwner {
749         require(_devAddress != address(0), "_devAddress address cannot be 0");
750         devAddress = payable(_devAddress);
751     }
752 
753     // force Swap back if slippage issues.
754     function forceSwapBack() external onlyOwner {
755         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
756         swapping = true;
757         swapBack();
758         swapping = false;
759         emit OwnerForcedSwapBack(block.timestamp);
760     }
761 
762     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
763     function buyBackTokens(uint256 amountInWei) external onlyOwner {
764         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
765 
766         address[] memory path = new address[](2);
767         path[0] = dexRouter.WETH();
768         path[1] = address(this);
769 
770         // make the swap
771         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
772             0, // accept any amount of Ethereum
773             path,
774             address(0xdead),
775             block.timestamp
776         );
777         emit BuyBackTriggered(amountInWei);
778     }
779 }