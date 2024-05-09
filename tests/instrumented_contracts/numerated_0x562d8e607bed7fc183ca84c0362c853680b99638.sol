1 /**
2  _ __ _____      ____ _ _ __ __| |____  
3 | '__/ _ \ \ /\ / / _` | '__/ _` |_  /  
4 | | |  __/\ V  V / (_| | | | (_| |/ /   
5 |_|  \___| \_/\_/ \__,_|_|  \__,_/___|  
6  _ __   ___| |___      _____  _ __| | __
7 | '_ \ / _ \ __\ \ /\ / / _ \| '__| |/ /
8 | | | |  __/ |_ \ V  V / (_) | |  |   < 
9 |_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_\
10 
11 Telegram: https://t.me/rewardznetwork
12 Website: https://rewardz.network
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity 0.8.15;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this;
26         return msg.data;
27     }
28 }
29 
30 interface IERC20 {
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
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 interface IERC20Metadata is IERC20 {
46     function name() external view returns (string memory);
47     function symbol() external view returns (string memory);
48     function decimals() external view returns (uint8);
49 }
50 
51 contract ERC20 is Context, IERC20, IERC20Metadata {
52     mapping(address => uint256) private _balances;
53     mapping(address => mapping(address => uint256)) private _allowances;
54     uint256 private _totalSupply;
55     string private _name;
56     string private _symbol;
57     constructor(string memory name_, string memory symbol_) {
58         _name = name_;
59         _symbol = symbol_;
60     }
61     function name() public view virtual override returns (string memory) {
62         return _name;
63     }
64     function symbol() public view virtual override returns (string memory) {
65         return _symbol;
66     }
67     function decimals() public view virtual override returns (uint8) {
68         return 18;
69     }
70     function balanceOf(address account) public view virtual override returns (uint256) {
71         return _balances[account];
72     }
73     function totalSupply() public view virtual override returns (uint256) {
74         return _totalSupply;
75     }
76     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
77         _transfer(_msgSender(), recipient, amount);
78         return true;
79     }
80     function approve(address spender, uint256 amount) public virtual override returns (bool) {
81         _approve(_msgSender(), spender, amount);
82         return true;
83     }
84     function allowance(address owner, address spender) public view virtual override returns (uint256) {
85         return _allowances[owner][spender];
86     }
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) public virtual override returns (bool) {
92         _transfer(sender, recipient, amount);
93 
94         uint256 currentAllowance = _allowances[sender][_msgSender()];
95         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
96         unchecked {
97             _approve(sender, _msgSender(), currentAllowance - amount);
98         }
99         return true;
100     }
101     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
102         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
103         return true;
104     }
105     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
106         uint256 currentAllowance = _allowances[_msgSender()][spender];
107         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
108         unchecked {
109             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
110         }
111         return true;
112     }
113     function _transfer(
114         address sender,
115         address recipient,
116         uint256 amount
117     ) internal virtual {
118         require(sender != address(0), "ERC20: transfer from the zero address");
119         require(recipient != address(0), "ERC20: transfer to the zero address");
120         uint256 senderBalance = _balances[sender];
121         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
122         unchecked {
123             _balances[sender] = senderBalance - amount;
124         }
125         _balances[recipient] += amount;
126         emit Transfer(sender, recipient, amount);
127     }
128     function _createInitialSupply(address account, uint256 amount) internal virtual {
129         require(account != address(0), "ERC20: mint to the zero address");
130         _totalSupply += amount;
131         _balances[account] += amount;
132         emit Transfer(address(0), account, amount);
133     }
134     function _burn(address account, uint256 amount) internal virtual {
135         require(account != address(0), "ERC20: burn from the zero address");
136         uint256 accountBalance = _balances[account];
137         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
138         unchecked {
139             _balances[account] = accountBalance - amount;
140             // Overflow not possible: amount <= accountBalance <= totalSupply.
141             _totalSupply -= amount;
142         }
143         emit Transfer(account, address(0), amount);
144     }
145     function _approve(
146         address owner,
147         address spender,
148         uint256 amount
149     ) internal virtual {
150         require(owner != address(0), "ERC20: approve from the zero address");
151         require(spender != address(0), "ERC20: approve to the zero address");
152         _allowances[owner][spender] = amount;
153         emit Approval(owner, spender, amount);
154     }
155 }
156 contract Ownable is Context {
157     address private _owner;
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159     constructor () {
160         address msgSender = _msgSender();
161         _owner = msgSender;
162         emit OwnershipTransferred(address(0), msgSender);
163     }
164     function owner() public view returns (address) {
165         return _owner;
166     }
167     modifier onlyOwner() {
168         require(_owner == _msgSender(), "Ownable: caller is not the owner");
169         _;
170     }
171     function renounceOwnership() external virtual onlyOwner {
172         emit OwnershipTransferred(_owner, address(0));
173         _owner = address(0);
174     }
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         emit OwnershipTransferred(_owner, newOwner);
178         _owner = newOwner;
179     }
180 }
181 
182 interface GutterRouter {
183     function factory() external pure returns (address);
184     function WETH() external pure returns (address);
185     function swapExactTokensForETHSupportingFeeOnTransferTokens(
186         uint amountIn,
187         uint amountOutMin,
188         address[] calldata path,
189         address to,
190         uint deadline
191     ) external;
192     function swapExactETHForTokensSupportingFeeOnTransferTokens(
193         uint amountOutMin,
194         address[] calldata path,
195         address to,
196         uint deadline
197     ) external payable;
198     function addLiquidityETH(
199         address token,
200         uint256 amountTokenDesired,
201         uint256 amountTokenMin,
202         uint256 amountETHMin,
203         address to,
204         uint256 deadline
205     )
206         external
207         payable
208         returns (
209             uint256 amountToken,
210             uint256 amountETH,
211             uint256 liquidity
212         );
213 }
214 interface GutterFactory {
215     function createPair(address tokenA, address tokenB)
216         external
217         returns (address pair);
218 }
219 contract Rewardz is ERC20, Ownable {
220 
221     uint256 public maxBuyAmount;
222     uint256 public maxSellAmount;
223     uint256 public maxWalletAmount;
224 
225     GutterRouter public raynRouter;
226     address public lpPair;
227 
228     bool private swapping;
229     uint256 public swapTokensAtAmount;
230 
231     address operationsAddress;
232     address devAddress;
233 
234     uint256 public tradingActiveBlock = 0;
235     uint256 public blockForPenaltyEnd;
236     mapping (address => bool) public boughtEarly;
237     uint256 public botsCaught;
238 
239     bool public limitsInEffect = true;
240     bool public tradingActive = false;
241     bool public swapEnabled = false;
242 
243     mapping(address => uint256) private _holderLastTransferTimestamp;
244     bool public transferDelayEnabled = true;
245 
246     uint256 public buyTotalFees;
247     uint256 public buyOperationsFee;
248     uint256 public buyLiquidityFee;
249     uint256 public buyDevFee;
250     uint256 public buyBurnFee;
251 
252     uint256 public sellTotalFees;
253     uint256 public sellOperationsFee;
254     uint256 public sellLiquidityFee;
255     uint256 public sellDevFee;
256     uint256 public sellBurnFee;
257 
258     uint256 public tokensForOperations;
259     uint256 public tokensForLiquidity;
260     uint256 public tokensForDev;
261     uint256 public tokensForBurn;
262 
263     mapping (address => bool) private _isExcludedFromFees;
264     mapping (address => bool) public _isExcludedMaxTransactionAmount;
265 
266     mapping (address => bool) public automatedMarketMakerPairs;
267 
268     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
269 
270     event EnabledTrading();
271 
272     event RemovedLimits();
273 
274     event ExcludeFromFees(address indexed account, bool isExcluded);
275 
276     event UpdatedMaxBuyAmount(uint256 newAmount);
277 
278     event UpdatedMaxSellAmount(uint256 newAmount);
279 
280     event UpdatedMaxWalletAmount(uint256 newAmount);
281 
282     event UpdatedOperationsAddress(address indexed newWallet);
283 
284     event MaxTransactionExclusion(address _address, bool excluded);
285 
286     event BuyBackTriggered(uint256 amount);
287 
288     event OwnerForcedSwapBack(uint256 timestamp);
289 
290     event CaughtEarlyBuyer(address sniper);
291 
292     event SwapAndLiquify(
293         uint256 tokensSwapped,
294         uint256 ethReceived,
295         uint256 tokensIntoLiquidity
296     );
297 
298     event TransferForeignToken(address token, uint256 amount);
299 
300     constructor() ERC20("Rewardz Automated Yield Network", "RAYN") {
301 
302         address newOwner = msg.sender;
303 
304         GutterRouter _raynRouter = GutterRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
305         raynRouter = _raynRouter;
306 
307         lpPair = GutterFactory(_raynRouter.factory()).createPair(address(this), _raynRouter.WETH());
308         _excludeFromMaxTransaction(address(lpPair), true);
309         _setAutomatedMarketMakerPair(address(lpPair), true);
310 
311         uint256 totalSupply = 1 * 1e11 * 1e18;
312 
313         maxBuyAmount = totalSupply * 1 / 100;
314         maxSellAmount = totalSupply * 1 / 100;
315         maxWalletAmount = totalSupply * 2 / 100;
316         swapTokensAtAmount = totalSupply * 5 / 10000;
317 
318         buyOperationsFee = 5;
319         buyLiquidityFee = 0;
320         buyDevFee = 5;
321         buyBurnFee = 0;
322         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
323 
324         sellOperationsFee = 24;
325         sellLiquidityFee = 1;
326         sellDevFee = 5;
327         sellBurnFee = 0;
328         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
329 
330         _excludeFromMaxTransaction(newOwner, true);
331         _excludeFromMaxTransaction(address(this), true);
332         _excludeFromMaxTransaction(address(0xdead), true);
333 
334         excludeFromFees(newOwner, true);
335         excludeFromFees(address(this), true);
336         excludeFromFees(address(0xdead), true);
337 
338         operationsAddress = address(newOwner);
339         devAddress = address(newOwner);
340 
341         _createInitialSupply(newOwner, totalSupply);
342         transferOwnership(newOwner);
343     }
344     receive() external payable {}
345 
346     function startTrading(uint256 blockJump) external onlyOwner {
347         require(!tradingActive, "Cannot re-disable trading");
348         tradingActive = true;
349         swapEnabled = true;
350         tradingActiveBlock = block.number;
351         blockForPenaltyEnd = tradingActiveBlock + blockJump;
352         emit EnabledTrading();
353     }
354 
355     function removeLimits() external onlyOwner {
356         limitsInEffect = false;
357         transferDelayEnabled = false;
358         emit RemovedLimits();
359     }
360 
361     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
362         boughtEarly[wallet] = flag;
363     }
364 
365     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
366         for(uint256 i = 0; i < wallets.length; i++){
367             boughtEarly[wallets[i]] = flag;
368         }
369     }
370 
371     function disableTransferDelay() external onlyOwner {
372         transferDelayEnabled = false;
373     }
374 
375     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
376         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%!");
377         maxBuyAmount = newNum * (10**18);
378         emit UpdatedMaxBuyAmount(maxBuyAmount);
379     }
380 
381     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
382         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%!");
383         maxSellAmount = newNum * (10**18);
384         emit UpdatedMaxSellAmount(maxSellAmount);
385     }
386 
387     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
388         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%!");
389         maxWalletAmount = newNum * (10**18);
390         emit UpdatedMaxWalletAmount(maxWalletAmount);
391     }
392 
393     // change the minimum amount of tokens to sell from fees
394     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
395   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply!");
396   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply!");
397   	    swapTokensAtAmount = newAmount;
398   	}
399 
400     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
401         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
402         emit MaxTransactionExclusion(updAds, isExcluded);
403     }
404 
405     function raynDrop(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
406         require(wallets.length == amountsInTokens.length, "Arrays must be the same length!");
407         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits!");
408         for(uint256 i = 0; i < wallets.length; i++){
409             address wallet = wallets[i];
410             uint256 amount = amountsInTokens[i];
411             super._transfer(msg.sender, wallet, amount);
412         }
413     }
414 
415     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
416         if(!isEx){
417             require(updAds != lpPair, "Cannot remove Uniswap pair from max txn!");
418         }
419         _isExcludedMaxTransactionAmount[updAds] = isEx;
420     }
421 
422     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
423         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs!");
424 
425         _setAutomatedMarketMakerPair(pair, value);
426         emit SetAutomatedMarketMakerPair(pair, value);
427     }
428 
429     function _setAutomatedMarketMakerPair(address pair, bool value) private {
430         automatedMarketMakerPairs[pair] = value;
431         _excludeFromMaxTransaction(pair, value);
432         emit SetAutomatedMarketMakerPair(pair, value);
433     }
434 
435     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
436         buyOperationsFee = _operationsFee;
437         buyLiquidityFee = _liquidityFee;
438         buyDevFee = _DevFee;
439         buyBurnFee = _burnFee;
440         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
441         require(buyTotalFees <= 30, "Must keep fees at 30% or less!");
442     }
443 
444     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
445         sellOperationsFee = _operationsFee;
446         sellLiquidityFee = _liquidityFee;
447         sellDevFee = _DevFee;
448         sellBurnFee = _burnFee;
449         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
450         require(sellTotalFees <= 30, "Must keep fees at 30% or less!");
451     }
452 
453     function returnToNormalTax() external onlyOwner {
454         sellOperationsFee = 100;
455         sellLiquidityFee = 0;
456         sellDevFee = 0;
457         sellBurnFee = 0;
458         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
459         require(sellTotalFees <= 30, "Must keep fees at 30% or less!");
460 
461         buyOperationsFee = 300;
462         buyLiquidityFee = 0;
463         buyDevFee = 0;
464         buyBurnFee = 0;
465         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
466         require(buyTotalFees <= 30, "Must keep fees at 30% or less!");
467     }
468 
469     function excludeFromFees(address account, bool excluded) public onlyOwner {
470         _isExcludedFromFees[account] = excluded;
471         emit ExcludeFromFees(account, excluded);
472     }
473 
474     function _transfer(address from, address to, uint256 amount) internal override {
475         require(from != address(0), "ERC20: transfer from the zero address.");
476         require(to != address(0), "ERC20: transfer to the zero address.");
477         require(amount > 0, "Amount must be greater than 0.");
478 
479         if(!tradingActive){
480             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active!");
481         }
482 
483         if(blockForPenaltyEnd > 0){
484             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner/dead address!");
485         }
486 
487         if(limitsInEffect){
488             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
489                 if (transferDelayEnabled){
490                     if (to != address(raynRouter) && to != address(lpPair)){
491                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Please try again later.");
492                         _holderLastTransferTimestamp[tx.origin] = block.number;
493                         _holderLastTransferTimestamp[to] = block.number;
494                     }
495                 }
496 
497                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
498                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy!");
499                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
500                 }
501 
502                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
503                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell!");
504                 }
505                 else if (!_isExcludedMaxTransactionAmount[to]){
506                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
507                 }
508             }
509         }
510 
511         uint256 contractTokenBalance = balanceOf(address(this));
512 
513         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
514 
515         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
516             swapping = true;
517             swapBack();
518             swapping = false;
519         }
520 
521         bool takeFee = true;
522         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
523             takeFee = false;
524         }
525 
526         uint256 fees = 0;
527         if(takeFee){
528             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
529                 // anti-bot
530                 if(!boughtEarly[to]){
531                     boughtEarly[to] = true;
532                     botsCaught += 1;
533                     emit CaughtEarlyBuyer(to);
534                 }
535                 fees = amount * 99 / 100;
536         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
537                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
538                 tokensForDev += fees * buyDevFee / buyTotalFees;
539                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
540             }
541             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
542                 fees = amount * sellTotalFees / 100;
543                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
544                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
545                 tokensForDev += fees * sellDevFee / sellTotalFees;
546                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
547             }
548             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
549         	    fees = amount * buyTotalFees / 100;
550         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
551                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
552                 tokensForDev += fees * buyDevFee / buyTotalFees;
553                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
554             }
555             if(fees > 0){
556                 super._transfer(from, address(this), fees);
557             }
558         	amount -= fees;
559         }
560         super._transfer(from, to, amount);
561     }
562 
563     function earlyBuyPenaltyInEffect() public view returns (bool){
564         return block.number < blockForPenaltyEnd;
565     }
566 
567     function swapTokensForEth(uint256 tokenAmount) private {
568         address[] memory path = new address[](2);
569         path[0] = address(this);
570         path[1] = raynRouter.WETH();
571         _approve(address(this), address(raynRouter), tokenAmount);
572         raynRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
573             tokenAmount,
574             0,
575             path,
576             address(this),
577             block.timestamp
578         );
579     }
580 
581     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
582         _approve(address(this), address(raynRouter), tokenAmount);
583         raynRouter.addLiquidityETH{value: ethAmount}(
584             address(this),
585             tokenAmount,
586             0,
587             0,
588             address(0xdead),
589             block.timestamp
590         );
591     }
592 
593     function swapBack() private {
594 
595         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
596             _burn(address(this), tokensForBurn);
597         }
598         tokensForBurn = 0;
599 
600         uint256 contractBalance = balanceOf(address(this));
601         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
602 
603         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
604 
605         if(contractBalance > swapTokensAtAmount * 20){
606             contractBalance = swapTokensAtAmount * 20;
607         }
608 
609         bool success;
610 
611         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
612 
613         swapTokensForEth(contractBalance - liquidityTokens);
614 
615         uint256 ethBalance = address(this).balance;
616         uint256 ethForLiquidity = ethBalance;
617 
618         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
619         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
620 
621         ethForLiquidity -= ethForOperations + ethForDev;
622 
623         tokensForLiquidity = 0;
624         tokensForOperations = 0;
625         tokensForDev = 0;
626         tokensForBurn = 0;
627 
628         if(liquidityTokens > 0 && ethForLiquidity > 0){
629             addLiquidity(liquidityTokens, ethForLiquidity);
630         }
631 
632         (success,) = address(devAddress).call{value: ethForDev}("");
633 
634         (success,) = address(operationsAddress).call{value: address(this).balance}("");
635     }
636 
637     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
638         require(_token != address(0), "_token address cannot be 0");
639         require(_token != address(this), "Can't withdraw native tokens");
640         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
641         _sent = IERC20(_token).transfer(_to, _contractBalance);
642         emit TransferForeignToken(_token, _contractBalance);
643     }
644 
645     function withdrawStuckETH() external onlyOwner {
646         bool success;
647         (success,) = address(msg.sender).call{value: address(this).balance}("");
648     }
649 
650     function setOperationsAddress(address _operationsAddress) external onlyOwner {
651         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
652         operationsAddress = payable(_operationsAddress);
653     }
654 
655     function setDevAddress(address _devAddress) external onlyOwner {
656         require(_devAddress != address(0), "_devAddress address cannot be 0");
657         devAddress = payable(_devAddress);
658     }
659 
660     function forceSwapBack() external onlyOwner {
661         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is more than restriction (or equal)");
662         swapping = true;
663         swapBack();
664         swapping = false;
665         emit OwnerForcedSwapBack(block.timestamp);
666     }
667 
668     function buyBackTokens(uint256 amountInWei) external onlyOwner {
669         require(amountInWei <= 10 ether, "May not buy more than 10 ETH to reduce attack surface");
670 
671         address[] memory path = new address[](2);
672         path[0] = raynRouter.WETH();
673         path[1] = address(this);
674 
675         raynRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
676             0,
677             path,
678             address(0xdead),
679             block.timestamp
680         );
681         emit BuyBackTriggered(amountInWei);
682     }
683 }