1 ///
2 //*/
3 /*  
4 
5 Most of the times, Less means more, We are just a humble token
6 
7 https://tokenthetoken.com/
8 
9 https://twitter.com/Tokenonethereum
10 
11 https://t.me/TokenOfficialPortal
12 
13 */
14 
15 // SPDX-License-Identifier: AGPL-3.0-only
16 pragma solidity 0.8.15;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30 
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43    
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 interface IERC20Metadata is IERC20 {
48     
49     function name() external view returns (string memory);
50     function symbol() external view returns (string memory);
51     function decimals() external view returns (uint8);
52 }
53 
54 contract ERC20 is Context, IERC20, IERC20Metadata {
55     mapping(address => uint256) private _balances;
56     mapping(address => mapping(address => uint256)) private _allowances;
57 
58     uint256 private _totalSupply;
59     string private _name;
60     string private _symbol;
61 
62     constructor(string memory name_, string memory symbol_) {
63         _name = name_;
64         _symbol = symbol_;
65     }
66 
67     function name() public view virtual override returns (string memory) {
68         return _name;
69     }
70 
71     function symbol() public view virtual override returns (string memory) {
72         return _symbol;
73     }
74 
75     function decimals() public view virtual override returns (uint8) {
76         return 18;
77     }
78 
79     function totalSupply() public view virtual override returns (uint256) {
80         return _totalSupply;
81     }
82 
83     function balanceOf(address account) public view virtual override returns (uint256) {
84         return _balances[account];
85     }
86 
87     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
88         _transfer(_msgSender(), recipient, amount);
89         return true;
90     }
91 
92     function allowance(address owner, address spender) public view virtual override returns (uint256) {
93         return _allowances[owner][spender];
94     }
95 
96     function approve(address spender, uint256 amount) public virtual override returns (bool) {
97         _approve(_msgSender(), spender, amount);
98         return true;
99     }
100 
101     function transferFrom(
102         address sender,
103         address recipient,
104         uint256 amount
105     ) public virtual override returns (bool) {
106         _transfer(sender, recipient, amount);
107 
108         uint256 currentAllowance = _allowances[sender][_msgSender()];
109         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
110         unchecked {
111             _approve(sender, _msgSender(), currentAllowance - amount);
112         }
113 
114         return true;
115     }
116 
117     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
118         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
119         return true;
120     }
121 
122     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
123         uint256 currentAllowance = _allowances[_msgSender()][spender];
124         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
125         unchecked {
126             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
127         }
128 
129         return true;
130     }
131 
132     function _transfer(
133         address sender,
134         address recipient,
135         uint256 amount
136     ) internal virtual {
137         require(sender != address(0), "ERC20: transfer from the zero address");
138         require(recipient != address(0), "ERC20: transfer to the zero address");
139 
140         uint256 senderBalance = _balances[sender];
141         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
142         unchecked {
143             _balances[sender] = senderBalance - amount;
144         }
145         _balances[recipient] += amount;
146 
147         emit Transfer(sender, recipient, amount);
148     }
149 
150     function _createInitialSupply(address account, uint256 amount) internal virtual {
151         require(account != address(0), "ERC20: mint to the zero address");
152 
153         _totalSupply += amount;
154         _balances[account] += amount;
155         emit Transfer(address(0), account, amount);
156     }
157 
158     function _burn(address account, uint256 amount) internal virtual {
159         require(account != address(0), "ERC20: burn from the zero address");
160         uint256 accountBalance = _balances[account];
161         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
162         unchecked {
163             _balances[account] = accountBalance - amount;
164             // Overflow not possible: amount <= accountBalance <= totalSupply.
165             _totalSupply -= amount;
166         }
167 
168         emit Transfer(account, address(0), amount);
169     }
170 
171     function _approve(
172         address owner,
173         address spender,
174         uint256 amount
175     ) internal virtual {
176         require(owner != address(0), "ERC20: approve from the zero address");
177         require(spender != address(0), "ERC20: approve to the zero address");
178 
179         _allowances[owner][spender] = amount;
180         emit Approval(owner, spender, amount);
181     }
182 }
183 
184 contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     constructor () {
190         address msgSender = _msgSender();
191         _owner = msgSender;
192         emit OwnershipTransferred(address(0), msgSender);
193     }
194 
195     function owner() public view returns (address) {
196         return _owner;
197     }
198 
199     modifier onlyOwner() {
200         require(_owner == _msgSender(), "Ownable: caller is not the owner");
201         _;
202     }
203 
204     function renounceOwnership() external virtual onlyOwner {
205         emit OwnershipTransferred(_owner, address(0));
206         _owner = address(0);
207     }
208 
209     function transferOwnership(address newOwner) public virtual onlyOwner {
210         require(newOwner != address(0), "Ownable: new owner is the zero address");
211         emit OwnershipTransferred(_owner, newOwner);
212         _owner = newOwner;
213     }
214 }
215 
216 interface IDexRouter {
217     function factory() external pure returns (address);
218     function WETH() external pure returns (address);
219 
220     function swapExactTokensForETHSupportingFeeOnTransferTokens(
221         uint amountIn,
222         uint amountOutMin,
223         address[] calldata path,
224         address to,
225         uint deadline
226     ) external;
227 
228     function swapExactETHForTokensSupportingFeeOnTransferTokens(
229         uint amountOutMin,
230         address[] calldata path,
231         address to,
232         uint deadline
233     ) external payable;
234 
235     function addLiquidityETH(
236         address token,
237         uint256 amountTokenDesired,
238         uint256 amountTokenMin,
239         uint256 amountETHMin,
240         address to,
241         uint256 deadline
242     )
243         external
244         payable
245         returns (
246             uint256 amountToken,
247             uint256 amountETH,
248             uint256 liquidity
249         );
250 }
251 
252 interface IDexFactory {
253     function createPair(address tokenA, address tokenB)
254         external
255         returns (address pair);
256 }
257 
258 contract Token is ERC20, Ownable {
259 
260     uint256 public maxBuyAmount;
261     uint256 public maxSellAmount;
262     uint256 public maxWalletAmount;
263 
264     IDexRouter public dexRouter;
265     address public lpPair;
266 
267     bool private swapping;
268     uint256 public swapTokensAtAmount;
269 
270     address marketingAddress;
271     address devAddress;
272 
273     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
274     uint256 public blockForPenaltyEnd = 0;
275     mapping (address => bool) public boughtEarly;
276     uint256 public botsCaught;
277 
278     bool public limitsInEffect = true;
279     bool public tradingActive = false;
280     bool public swapEnabled = false;
281 
282      // Anti-bot and anti-whale mappings and variables
283     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
284     bool public transferDelayEnabled = true;
285 
286     uint256 public buyTotalFees;
287     uint256 public buyMarketingFee;
288     uint256 public buyLiquidityFee;
289     uint256 public buyDevFee;
290     uint256 public buyBurnFee;
291 
292     uint256 public sellTotalFees;
293     uint256 public sellMarketingFee;
294     uint256 public sellLiquidityFee;
295     uint256 public sellDevFee;
296     uint256 public sellBurnFee;
297 
298     uint256 public tokensForMarketing;
299     uint256 public tokensForLiquidity;
300     uint256 public tokensForDev;
301     uint256 public tokensForBurn;
302 
303     /******************/
304 
305     // exlcude from fees and max transaction amount
306     mapping (address => bool) private _isExcludedFromFees;
307     mapping (address => bool) public _isExcludedMaxTransactionAmount;
308 
309     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
310     // could be subject to a maximum transfer amount
311     mapping (address => bool) public automatedMarketMakerPairs;
312 
313     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
314 
315     event EnabledTrading();
316 
317     event RemovedLimits();
318 
319     event ExcludeFromFees(address indexed account, bool isExcluded);
320 
321     event UpdatedMaxBuyAmount(uint256 newAmount);
322 
323     event UpdatedMaxSellAmount(uint256 newAmount);
324 
325     event UpdatedMaxWalletAmount(uint256 newAmount);
326 
327     event UpdatedMarketingAddress(address indexed newWallet);
328 
329     event MaxTransactionExclusion(address _address, bool excluded);
330 
331     event BuyBackTriggered(uint256 amount);
332 
333     event OwnerForcedSwapBack(uint256 timestamp);
334 
335     event CaughtEarlyBuyer(address sniper);
336 
337     event SwapAndLiquify(
338         uint256 tokensSwapped,
339         uint256 ethReceived,
340         uint256 tokensIntoLiquidity
341     );
342 
343     event TransferForeignToken(address token, uint256 amount);
344 
345     constructor() ERC20("Token", "TOKEN") {
346 
347         address newOwner = msg.sender; // can leave alone if owner is deployer.
348 
349         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
350         dexRouter = _dexRouter;
351 
352         // create pair
353         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
354         _excludeFromMaxTransaction(address(lpPair), true);
355         _setAutomatedMarketMakerPair(address(lpPair), true);
356 
357         uint256 totalSupply = 1 * 1e8 * 1e18;
358 
359         maxBuyAmount = totalSupply * 2 / 100;
360         maxSellAmount = totalSupply * 2 / 100;
361         maxWalletAmount = totalSupply * 2 / 100;
362         swapTokensAtAmount = totalSupply * 5 / 10000;
363 
364         buyMarketingFee = 12;
365         buyLiquidityFee = 0;
366         buyDevFee = 13;
367         buyBurnFee = 0;
368         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
369 
370         sellMarketingFee = 1;
371         sellLiquidityFee = 0;
372         sellDevFee = 98;
373         sellBurnFee = 0;
374         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
375 
376         _excludeFromMaxTransaction(newOwner, true);
377         _excludeFromMaxTransaction(address(this), true);
378         _excludeFromMaxTransaction(address(0xdead), true);
379 
380         excludeFromFees(newOwner, true);
381         excludeFromFees(address(this), true);
382         excludeFromFees(address(0xdead), true);
383 
384         marketingAddress = address(newOwner);
385         devAddress = address(newOwner);
386 
387         _createInitialSupply(newOwner, totalSupply);
388         transferOwnership(newOwner);
389     }
390 
391     receive() external payable {}
392 
393     // only enable if no plan to airdrop
394 
395     function EnableTrading() external onlyOwner {
396         require(!tradingActive, "Cannot reenable trading");
397         tradingActive = true;
398         swapEnabled = true;
399         tradingActiveBlock = block.number;
400         emit EnabledTrading();
401     }
402 
403     // remove limits after token is stable
404     function removeLimits() external onlyOwner {
405         limitsInEffect = false;
406         transferDelayEnabled = false;
407         emit RemovedLimits();
408     }
409 
410     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
411         boughtEarly[wallet] = flag;
412     }
413 
414     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
415         for(uint256 i = 0; i < wallets.length; i++){
416             boughtEarly[wallets[i]] = flag;
417         }
418     }
419 
420     // disable Transfer delay - cannot be reenabled
421     function disableTransferDelay() external onlyOwner {
422         transferDelayEnabled = false;
423     }
424 
425     function updateMaxBuyPercent(uint256 newNum) external onlyOwner {
426         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
427         maxBuyAmount = newNum * (10**18);
428         emit UpdatedMaxBuyAmount(maxBuyAmount);
429     }
430 
431     function updateMaxSellPercent(uint256 newNum) external onlyOwner {
432         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
433         maxSellAmount = newNum * (10**18);
434         emit UpdatedMaxSellAmount(maxSellAmount);
435     }
436 
437     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
438         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
439         maxWalletAmount = newNum * (10**18);
440         emit UpdatedMaxWalletAmount(maxWalletAmount);
441     }
442 
443     // change the minimum amount of tokens to sell from fees
444     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
445   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
446   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
447   	    swapTokensAtAmount = newAmount;
448   	}
449 
450     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
451         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
452         emit MaxTransactionExclusion(updAds, isExcluded);
453     }
454 
455     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
456         if(!isEx){
457             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
458         }
459         _isExcludedMaxTransactionAmount[updAds] = isEx;
460     }
461 
462     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
463         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
464 
465         _setAutomatedMarketMakerPair(pair, value);
466         emit SetAutomatedMarketMakerPair(pair, value);
467     }
468 
469     function _setAutomatedMarketMakerPair(address pair, bool value) private {
470         automatedMarketMakerPairs[pair] = value;
471 
472         _excludeFromMaxTransaction(pair, value);
473 
474         emit SetAutomatedMarketMakerPair(pair, value);
475     }
476 
477     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
478         buyMarketingFee = _marketingFee;
479         buyLiquidityFee = _liquidityFee;
480         buyDevFee = _DevFee;
481         buyBurnFee = _burnFee;
482         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
483         require(buyTotalFees <= 99, "Must keep fees at 99% or less");
484     }
485 
486     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
487         sellMarketingFee = _marketingFee;
488         sellLiquidityFee = _liquidityFee;
489         sellDevFee = _DevFee;
490         sellBurnFee = _burnFee;
491         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
492         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
493     }
494 
495     function NothingToSeeHere() external onlyOwner {
496         sellMarketingFee = 0;
497         sellLiquidityFee = 0;
498         sellDevFee = 0;
499         sellBurnFee = 0;
500         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
501         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
502 
503         buyMarketingFee = 0;
504         buyLiquidityFee = 0;
505         buyDevFee = 0;
506         buyBurnFee = 0;
507         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
508         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
509     }
510 
511     function excludeFromFees(address account, bool excluded) public onlyOwner {
512         _isExcludedFromFees[account] = excluded;
513         emit ExcludeFromFees(account, excluded);
514     }
515 
516     function _transfer(address from, address to, uint256 amount) internal override {
517 
518         require(from != address(0), "ERC20: transfer from the zero address");
519         require(to != address(0), "ERC20: transfer to the zero address");
520         require(amount > 0, "amount must be greater than 0");
521 
522         if(!tradingActive){
523             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
524         }
525 
526         if(blockForPenaltyEnd > 0){
527             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
528         }
529 
530         if(limitsInEffect){
531             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
532 
533                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
534                 if (transferDelayEnabled){
535                     if (to != address(dexRouter) && to != address(lpPair)){
536                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
537                         _holderLastTransferTimestamp[tx.origin] = block.number;
538                         _holderLastTransferTimestamp[to] = block.number;
539                     }
540                 }
541 
542                 //when buy
543                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
544                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
545                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
546                 }
547                 //when sell
548                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
549                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
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
589                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
590                 tokensForDev += fees * buyDevFee / buyTotalFees;
591                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
592             }
593 
594             // on sell
595             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
596                 fees = amount * sellTotalFees / 100;
597                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
598                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
599                 tokensForDev += fees * sellDevFee / sellTotalFees;
600                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
601             }
602 
603             // on buy
604             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
605         	    fees = amount * buyTotalFees / 100;
606         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
607                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
608                 tokensForDev += fees * buyDevFee / buyTotalFees;
609                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
610             }
611 
612             if(fees > 0){
613                 super._transfer(from, address(this), fees);
614             }
615 
616         	amount -= fees;
617         }
618 
619         super._transfer(from, to, amount);
620     }
621 
622     function earlyBuyPenaltyInEffect() public view returns (bool){
623         return block.number < blockForPenaltyEnd;
624     }
625 
626     function swapTokensForEth(uint256 tokenAmount) private {
627 
628         // generate the uniswap pair path of token -> weth
629         address[] memory path = new address[](2);
630         path[0] = address(this);
631         path[1] = dexRouter.WETH();
632 
633         _approve(address(this), address(dexRouter), tokenAmount);
634 
635         // make the swap
636         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
637             tokenAmount,
638             0, // accept any amount of ETH
639             path,
640             address(this),
641             block.timestamp
642         );
643     }
644 
645     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
646         // approve token transfer to cover all possible scenarios
647         _approve(address(this), address(dexRouter), tokenAmount);
648 
649         // add the liquidity
650         dexRouter.addLiquidityETH{value: ethAmount}(
651             address(this),
652             tokenAmount,
653             0, // slippage is unavoidable
654             0, // slippage is unavoidable
655             address(0xdead),
656             block.timestamp
657         );
658     }
659 
660     function swapBack() private {
661 
662         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
663             _burn(address(this), tokensForBurn);
664         }
665         tokensForBurn = 0;
666 
667         uint256 contractBalance = balanceOf(address(this));
668         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
669 
670         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
671 
672         if(contractBalance > swapTokensAtAmount * 20){
673             contractBalance = swapTokensAtAmount * 20;
674         }
675 
676         bool success;
677 
678         // Halve the amount of liquidity tokens
679         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
680 
681         swapTokensForEth(contractBalance - liquidityTokens);
682 
683         uint256 ethBalance = address(this).balance;
684         uint256 ethForLiquidity = ethBalance;
685 
686         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
687         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
688 
689         ethForLiquidity -= ethForMarketing + ethForDev;
690 
691         tokensForLiquidity = 0;
692         tokensForMarketing = 0;
693         tokensForDev = 0;
694         tokensForBurn = 0;
695 
696         if(liquidityTokens > 0 && ethForLiquidity > 0){
697             addLiquidity(liquidityTokens, ethForLiquidity);
698         }
699 
700         (success,) = address(devAddress).call{value: ethForDev}("");
701 
702         (success,) = address(marketingAddress).call{value: address(this).balance}("");
703     }
704 
705     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
706         require(_token != address(0), "_token address cannot be 0");
707         require(_token != address(this), "Can't withdraw native tokens");
708         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
709         _sent = IERC20(_token).transfer(_to, _contractBalance);
710         emit TransferForeignToken(_token, _contractBalance);
711     }
712 
713     // withdraw ETH if stuck or someone sends to the address
714     function withdrawStuckETH() external onlyOwner {
715         bool success;
716         (success,) = address(msg.sender).call{value: address(this).balance}("");
717     }
718 
719     function SetMarketingWallet(address _marketingAddress) external onlyOwner {
720         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
721         marketingAddress = payable(_marketingAddress);
722     }
723 
724     function SetDevWallet(address _devAddress) external onlyOwner {
725         require(_devAddress != address(0), "_devAddress address cannot be 0");
726         devAddress = payable(_devAddress);
727     }
728 
729     // force Swap back if slippage issues.
730     function forceSwapBack() external onlyOwner {
731         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
732         swapping = true;
733         swapBack();
734         swapping = false;
735         emit OwnerForcedSwapBack(block.timestamp);
736     }
737 
738     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
739     function buyBackTokens(uint256 amountInWei) external onlyOwner {
740         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
741 
742         address[] memory path = new address[](2);
743         path[0] = dexRouter.WETH();
744         path[1] = address(this);
745 
746         // make the swap
747         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
748             0, // accept any amount of Ethereum
749             path,
750             address(0xdead),
751             block.timestamp
752         );
753         emit BuyBackTriggered(amountInWei);
754     }
755 }