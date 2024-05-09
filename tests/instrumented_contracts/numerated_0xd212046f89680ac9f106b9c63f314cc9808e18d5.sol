1 // Ultra-efficient AI Powered DEX on Arbitrum and Ethereum
2 // 
3 // Website : http://sukiyaki.finance/
4 // Twitter: http://twitter.com/sukiyaki_dex
5 // Telegram: https://t.me/sukiyaki_dex
6 // Medium: https://medium.com/@sukiyaki.sukiyaki2000
7 
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
251 contract Sukiyaki is ERC20, Ownable {
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
263     address marketingAddress;
264     address devAddress;
265 
266     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
267     uint256 public blockForPenaltyEnd = 0;
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
280     uint256 public buyMarketingFee;
281     uint256 public buyLiquidityFee;
282     uint256 public buyDevFee;
283     uint256 public buyBurnFee;
284 
285     uint256 public sellTotalFees;
286     uint256 public sellMarketingFee;
287     uint256 public sellLiquidityFee;
288     uint256 public sellDevFee;
289     uint256 public sellBurnFee;
290 
291     uint256 public tokensForMarketing;
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
307 
308     event EnabledTrading();
309 
310     event RemovedLimits();
311 
312     event ExcludeFromFees(address indexed account, bool isExcluded);
313 
314     event UpdatedMaxBuyAmount(uint256 newAmount);
315 
316     event UpdatedMaxSellAmount(uint256 newAmount);
317 
318     event UpdatedMaxWalletAmount(uint256 newAmount);
319 
320     event UpdatedMarketingAddress(address indexed newWallet);
321 
322     event MaxTransactionExclusion(address _address, bool excluded);
323 
324     event BuyBackTriggered(uint256 amount);
325 
326     event OwnerForcedSwapBack(uint256 timestamp);
327 
328     event CaughtEarlyBuyer(address sniper);
329 
330     event SwapAndLiquify(
331         uint256 tokensSwapped,
332         uint256 ethReceived,
333         uint256 tokensIntoLiquidity
334     );
335 
336     event TransferForeignToken(address token, uint256 amount);
337 
338     constructor() ERC20("Sukiyaki", "Suki") {
339 
340         address newOwner = msg.sender; // can leave alone if owner is deployer.
341 
342         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
343         dexRouter = _dexRouter;
344 
345         // create pair
346         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
347         _excludeFromMaxTransaction(address(lpPair), true);
348         _setAutomatedMarketMakerPair(address(lpPair), true);
349 
350         uint256 totalSupply = 1 * 1e8 * 1e18;
351 
352         maxBuyAmount = totalSupply * 2 / 100;
353         maxSellAmount = totalSupply * 1 / 100;
354         maxWalletAmount = totalSupply * 2 / 100;
355         swapTokensAtAmount = totalSupply * 5 / 10000;
356 
357         buyMarketingFee = 20;
358         buyLiquidityFee = 0;
359         buyDevFee = 5;
360         buyBurnFee = 0;
361         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
362 
363         sellMarketingFee = 28;
364         sellLiquidityFee = 0;
365         sellDevFee = 7;
366         sellBurnFee = 0;
367         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
368 
369         _excludeFromMaxTransaction(newOwner, true);
370         _excludeFromMaxTransaction(address(this), true);
371         _excludeFromMaxTransaction(address(0xdead), true);
372 
373         excludeFromFees(newOwner, true);
374         excludeFromFees(address(this), true);
375         excludeFromFees(address(0xdead), true);
376 
377         marketingAddress = address(newOwner);
378         devAddress = address(newOwner);
379 
380         _createInitialSupply(newOwner, totalSupply);
381         transferOwnership(newOwner);
382     }
383 
384     receive() external payable {}
385 
386     // only enable if no plan to airdrop
387 
388     function enableTrading() external onlyOwner {
389         require(!tradingActive, "Cannot reenable trading");
390         tradingActive = true;
391         swapEnabled = true;
392         tradingActiveBlock = block.number;
393         emit EnabledTrading();
394     }
395 
396     // remove limits after token is stable
397     function removeLimits() external onlyOwner {
398         limitsInEffect = false;
399         transferDelayEnabled = false;
400         emit RemovedLimits();
401     }
402 
403     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
404         boughtEarly[wallet] = flag;
405     }
406 
407     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
408         for(uint256 i = 0; i < wallets.length; i++){
409             boughtEarly[wallets[i]] = flag;
410         }
411     }
412 
413     // disable Transfer delay - cannot be reenabled
414     function disableTransferDelay() external onlyOwner {
415         transferDelayEnabled = false;
416     }
417 
418     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
419         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
420         maxBuyAmount = newNum * (10**18);
421         emit UpdatedMaxBuyAmount(maxBuyAmount);
422     }
423 
424     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
425         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
426         maxSellAmount = newNum * (10**18);
427         emit UpdatedMaxSellAmount(maxSellAmount);
428     }
429 
430     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
431         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
432         maxWalletAmount = newNum * (10**18);
433         emit UpdatedMaxWalletAmount(maxWalletAmount);
434     }
435 
436     // change the minimum amount of tokens to sell from fees
437     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
438   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
439   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
440   	    swapTokensAtAmount = newAmount;
441   	}
442 
443     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
444         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
445         emit MaxTransactionExclusion(updAds, isExcluded);
446     }
447 
448     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
449         if(!isEx){
450             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
451         }
452         _isExcludedMaxTransactionAmount[updAds] = isEx;
453     }
454 
455     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
456         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
457 
458         _setAutomatedMarketMakerPair(pair, value);
459         emit SetAutomatedMarketMakerPair(pair, value);
460     }
461 
462     function _setAutomatedMarketMakerPair(address pair, bool value) private {
463         automatedMarketMakerPairs[pair] = value;
464 
465         _excludeFromMaxTransaction(pair, value);
466 
467         emit SetAutomatedMarketMakerPair(pair, value);
468     }
469 
470     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
471         buyMarketingFee = _marketingFee;
472         buyLiquidityFee = _liquidityFee;
473         buyDevFee = _DevFee;
474         buyBurnFee = _burnFee;
475         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
476         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
477     }
478 
479     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
480         sellMarketingFee = _marketingFee;
481         sellLiquidityFee = _liquidityFee;
482         sellDevFee = _DevFee;
483         sellBurnFee = _burnFee;
484         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
485         require(sellTotalFees <= 35, "Must keep fees at 35% or less");
486     }
487 
488     function returnToNormalTax() external onlyOwner {
489         sellMarketingFee = 4;
490         sellLiquidityFee = 0;
491         sellDevFee = 1;
492         sellBurnFee = 0;
493         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellBurnFee;
494         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
495 
496         buyMarketingFee = 4;
497         buyLiquidityFee = 0;
498         buyDevFee = 1;
499         buyBurnFee = 0;
500         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyBurnFee;
501         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
502     }
503 
504     function excludeFromFees(address account, bool excluded) public onlyOwner {
505         _isExcludedFromFees[account] = excluded;
506         emit ExcludeFromFees(account, excluded);
507     }
508 
509     function _transfer(address from, address to, uint256 amount) internal override {
510 
511         require(from != address(0), "ERC20: transfer from the zero address");
512         require(to != address(0), "ERC20: transfer to the zero address");
513         require(amount > 0, "amount must be greater than 0");
514 
515         if(!tradingActive){
516             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
517         }
518 
519         if(blockForPenaltyEnd > 0){
520             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
521         }
522 
523         if(limitsInEffect){
524             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
525 
526                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
527                 if (transferDelayEnabled){
528                     if (to != address(dexRouter) && to != address(lpPair)){
529                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
530                         _holderLastTransferTimestamp[tx.origin] = block.number;
531                         _holderLastTransferTimestamp[to] = block.number;
532                     }
533                 }
534 
535                 //when buy
536                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
537                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
538                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
539                 }
540                 //when sell
541                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
542                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
543                 }
544                 else if (!_isExcludedMaxTransactionAmount[to]){
545                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
546                 }
547             }
548         }
549 
550         uint256 contractTokenBalance = balanceOf(address(this));
551 
552         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
553 
554         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
555             swapping = true;
556 
557             swapBack();
558 
559             swapping = false;
560         }
561 
562         bool takeFee = true;
563         // if any account belongs to _isExcludedFromFee account then remove the fee
564         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
565             takeFee = false;
566         }
567 
568         uint256 fees = 0;
569         // only take fees on buys/sells, do not take on wallet transfers
570         if(takeFee){
571             // bot/sniper penalty.
572             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
573 
574                 if(!boughtEarly[to]){
575                     boughtEarly[to] = true;
576                     botsCaught += 1;
577                     emit CaughtEarlyBuyer(to);
578                 }
579 
580                 fees = amount * 99 / 100;
581         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
582                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
583                 tokensForDev += fees * buyDevFee / buyTotalFees;
584                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
585             }
586 
587             // on sell
588             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
589                 fees = amount * sellTotalFees / 100;
590                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
591                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
592                 tokensForDev += fees * sellDevFee / sellTotalFees;
593                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
594             }
595 
596             // on buy
597             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
598         	    fees = amount * buyTotalFees / 100;
599         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
600                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
601                 tokensForDev += fees * buyDevFee / buyTotalFees;
602                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
603             }
604 
605             if(fees > 0){
606                 super._transfer(from, address(this), fees);
607             }
608 
609         	amount -= fees;
610         }
611 
612         super._transfer(from, to, amount);
613     }
614 
615     function earlyBuyPenaltyInEffect() public view returns (bool){
616         return block.number < blockForPenaltyEnd;
617     }
618 
619     function swapTokensForEth(uint256 tokenAmount) private {
620 
621         // generate the uniswap pair path of token -> weth
622         address[] memory path = new address[](2);
623         path[0] = address(this);
624         path[1] = dexRouter.WETH();
625 
626         _approve(address(this), address(dexRouter), tokenAmount);
627 
628         // make the swap
629         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
630             tokenAmount,
631             0, // accept any amount of ETH
632             path,
633             address(this),
634             block.timestamp
635         );
636     }
637 
638     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
639         // approve token transfer to cover all possible scenarios
640         _approve(address(this), address(dexRouter), tokenAmount);
641 
642         // add the liquidity
643         dexRouter.addLiquidityETH{value: ethAmount}(
644             address(this),
645             tokenAmount,
646             0, // slippage is unavoidable
647             0, // slippage is unavoidable
648             address(0xdead),
649             block.timestamp
650         );
651     }
652 
653     function swapBack() private {
654 
655         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
656             _burn(address(this), tokensForBurn);
657         }
658         tokensForBurn = 0;
659 
660         uint256 contractBalance = balanceOf(address(this));
661         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
662 
663         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
664 
665         if(contractBalance > swapTokensAtAmount * 20){
666             contractBalance = swapTokensAtAmount * 20;
667         }
668 
669         bool success;
670 
671         // Halve the amount of liquidity tokens
672         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
673 
674         swapTokensForEth(contractBalance - liquidityTokens);
675 
676         uint256 ethBalance = address(this).balance;
677         uint256 ethForLiquidity = ethBalance;
678 
679         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
680         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
681 
682         ethForLiquidity -= ethForMarketing + ethForDev;
683 
684         tokensForLiquidity = 0;
685         tokensForMarketing = 0;
686         tokensForDev = 0;
687         tokensForBurn = 0;
688 
689         if(liquidityTokens > 0 && ethForLiquidity > 0){
690             addLiquidity(liquidityTokens, ethForLiquidity);
691         }
692 
693         (success,) = address(devAddress).call{value: ethForDev}("");
694 
695         (success,) = address(marketingAddress).call{value: address(this).balance}("");
696     }
697 
698     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
699         require(_token != address(0), "_token address cannot be 0");
700         require(_token != address(this), "Can't withdraw native tokens");
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
712     function GetReady(address _marketingAddress) external onlyOwner {
713         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
714         marketingAddress = payable(_marketingAddress);
715     }
716 
717     function AlmostThere(address _devAddress) external onlyOwner {
718         require(_devAddress != address(0), "_devAddress address cannot be 0");
719         devAddress = payable(_devAddress);
720     }
721 
722     // force Swap back if slippage issues.
723     function forceSwapBack() external onlyOwner {
724         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
725         swapping = true;
726         swapBack();
727         swapping = false;
728         emit OwnerForcedSwapBack(block.timestamp);
729     }
730 
731     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
732     function buyBackTokens(uint256 amountInWei) external onlyOwner {
733         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
734 
735         address[] memory path = new address[](2);
736         path[0] = dexRouter.WETH();
737         path[1] = address(this);
738 
739         // make the swap
740         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
741             0, // accept any amount of Ethereum
742             path,
743             address(0xdead),
744             block.timestamp
745         );
746         emit BuyBackTriggered(amountInWei);
747     }
748 }