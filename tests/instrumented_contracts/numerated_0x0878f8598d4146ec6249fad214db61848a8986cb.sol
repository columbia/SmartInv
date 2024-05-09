1 // SPDX-License-Identifier: MIT
2  
3 //website: https://kaithefirstinu.io/
4 //twitter: https://twitter.com/KaiInuETH
5 //telegram: https://t.me/kai_inu
6  
7 pragma solidity 0.8.15;
8  
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13  
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19  
20 interface IERC20 {
21  
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32  
33     event Transfer(address indexed from, address indexed to, uint256 value);
34  
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37  
38 interface IERC20Metadata is IERC20 {
39  
40     function name() external view returns (string memory);
41     function symbol() external view returns (string memory);
42     function decimals() external view returns (uint8);
43 }
44  
45 contract ERC20 is Context, IERC20, IERC20Metadata {
46     mapping(address => uint256) private _balances;
47     mapping(address => mapping(address => uint256)) private _allowances;
48  
49     uint256 private _totalSupply;
50     string private _name;
51     string private _symbol;
52  
53     constructor(string memory name_, string memory symbol_) {
54         _name = name_;
55         _symbol = symbol_;
56     }
57  
58     function name() public view virtual override returns (string memory) {
59         return _name;
60     }
61  
62     function symbol() public view virtual override returns (string memory) {
63         return _symbol;
64     }
65  
66     function decimals() public view virtual override returns (uint8) {
67         return 18;
68     }
69  
70     function totalSupply() public view virtual override returns (uint256) {
71         return _totalSupply;
72     }
73  
74     function balanceOf(address account) public view virtual override returns (uint256) {
75         return _balances[account];
76     }
77  
78     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
79         _transfer(_msgSender(), recipient, amount);
80         return true;
81     }
82  
83     function allowance(address owner, address spender) public view virtual override returns (uint256) {
84         return _allowances[owner][spender];
85     }
86  
87     function approve(address spender, uint256 amount) public virtual override returns (bool) {
88         _approve(_msgSender(), spender, amount);
89         return true;
90     }
91  
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) public virtual override returns (bool) {
97         _transfer(sender, recipient, amount);
98  
99         uint256 currentAllowance = _allowances[sender][_msgSender()];
100         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
101         unchecked {
102             _approve(sender, _msgSender(), currentAllowance - amount);
103         }
104  
105         return true;
106     }
107  
108     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
109         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
110         return true;
111     }
112  
113     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
114         uint256 currentAllowance = _allowances[_msgSender()][spender];
115         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
116         unchecked {
117             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
118         }
119  
120         return true;
121     }
122  
123     function _transfer(
124         address sender,
125         address recipient,
126         uint256 amount
127     ) internal virtual {
128         require(sender != address(0), "ERC20: transfer from the zero address");
129         require(recipient != address(0), "ERC20: transfer to the zero address");
130  
131         uint256 senderBalance = _balances[sender];
132         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
133         unchecked {
134             _balances[sender] = senderBalance - amount;
135         }
136         _balances[recipient] += amount;
137  
138         emit Transfer(sender, recipient, amount);
139     }
140  
141     function _createInitialSupply(address account, uint256 amount) internal virtual {
142         require(account != address(0), "ERC20: mint to the zero address");
143  
144         _totalSupply += amount;
145         _balances[account] += amount;
146         emit Transfer(address(0), account, amount);
147     }
148  
149     function _burn(address account, uint256 amount) internal virtual {
150         require(account != address(0), "ERC20: burn from the zero address");
151         uint256 accountBalance = _balances[account];
152         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
153         unchecked {
154             _balances[account] = accountBalance - amount;
155             // Overflow not possible: amount <= accountBalance <= totalSupply.
156             _totalSupply -= amount;
157         }
158  
159         emit Transfer(account, address(0), amount);
160     }
161  
162     function _approve(
163         address owner,
164         address spender,
165         uint256 amount
166     ) internal virtual {
167         require(owner != address(0), "ERC20: approve from the zero address");
168         require(spender != address(0), "ERC20: approve to the zero address");
169  
170         _allowances[owner][spender] = amount;
171         emit Approval(owner, spender, amount);
172     }
173 }
174  
175 contract Ownable is Context {
176     address private _owner;
177  
178     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
179  
180     constructor () {
181         address msgSender = _msgSender();
182         _owner = msgSender;
183         emit OwnershipTransferred(address(0), msgSender);
184     }
185  
186     function owner() public view returns (address) {
187         return _owner;
188     }
189  
190     modifier onlyOwner() {
191         require(_owner == _msgSender(), "Ownable: caller is not the owner");
192         _;
193     }
194  
195     function renounceOwnership() external virtual onlyOwner {
196         emit OwnershipTransferred(_owner, address(0));
197         _owner = address(0);
198     }
199  
200     function transferOwnership(address newOwner) public virtual onlyOwner {
201         require(newOwner != address(0), "Ownable: new owner is the zero address");
202         emit OwnershipTransferred(_owner, newOwner);
203         _owner = newOwner;
204     }
205 }
206  
207 interface IDexRouter {
208     function factory() external pure returns (address);
209     function WETH() external pure returns (address);
210  
211     function swapExactTokensForETHSupportingFeeOnTransferTokens(
212         uint amountIn,
213         uint amountOutMin,
214         address[] calldata path,
215         address to,
216         uint deadline
217     ) external;
218  
219     function swapExactETHForTokensSupportingFeeOnTransferTokens(
220         uint amountOutMin,
221         address[] calldata path,
222         address to,
223         uint deadline
224     ) external payable;
225  
226     function addLiquidityETH(
227         address token,
228         uint256 amountTokenDesired,
229         uint256 amountTokenMin,
230         uint256 amountETHMin,
231         address to,
232         uint256 deadline
233     )
234         external
235         payable
236         returns (
237             uint256 amountToken,
238             uint256 amountETH,
239             uint256 liquidity
240         );
241 }
242  
243 interface IDexFactory {
244     function createPair(address tokenA, address tokenB)
245         external
246         returns (address pair);
247 }
248  
249 contract Kai_Inu is ERC20, Ownable {
250  
251     uint256 public maxBuyAmount;
252     uint256 public maxSellAmount;
253     uint256 public maxWalletAmount;
254  
255     IDexRouter public dexRouter;
256     address public lpPair;
257  
258     bool private swapping;
259     uint256 public swapTokensAtAmount;
260  
261     address operationsAddress;
262     address devAddress; 
263  
264     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
265     uint256 public blockForPenaltyEnd;
266     mapping (address => bool) public boughtEarly;
267     uint256 public botsCaught;
268  
269     bool public limitsInEffect = true;
270     bool public tradingActive = false;
271     bool public swapEnabled = false;
272  
273      // Anti-bot and anti-whale mappings and variables
274     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
275     bool public transferDelayEnabled = true;
276  
277     uint256 public buyTotalFees;
278     uint256 public buyOperationsFee;
279     uint256 public buyLiquidityFee;
280     uint256 public buyDevFee;
281     uint256 public buyBurnFee;
282  
283     uint256 public sellTotalFees;
284     uint256 public sellOperationsFee;
285     uint256 public sellLiquidityFee;
286     uint256 public sellDevFee;
287     uint256 public sellBurnFee;
288  
289     uint256 public tokensForOperations;
290     uint256 public tokensForLiquidity;
291     uint256 public tokensForDev;
292     uint256 public tokensForBurn;
293  
294     /******************/
295  
296     // exlcude from fees and max transaction amount
297     mapping (address => bool) private _isExcludedFromFees;
298     mapping (address => bool) public _isExcludedMaxTransactionAmount;
299  
300     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
301     // could be subject to a maximum transfer amount
302     mapping (address => bool) public automatedMarketMakerPairs;
303  
304     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
305  
306     event EnabledTrading();
307  
308     event RemovedLimits();
309  
310     event ExcludeFromFees(address indexed account, bool isExcluded);
311  
312     event UpdatedMaxBuyAmount(uint256 newAmount);
313  
314     event UpdatedMaxSellAmount(uint256 newAmount);
315  
316     event UpdatedMaxWalletAmount(uint256 newAmount);
317  
318     event UpdatedOperationsAddress(address indexed newWallet);
319  
320     event MaxTransactionExclusion(address _address, bool excluded);
321  
322     event BuyBackTriggered(uint256 amount);
323  
324     event OwnerForcedSwapBack(uint256 timestamp);
325  
326     event CaughtEarlyBuyer(address sniper);
327  
328     event SwapAndLiquify(
329         uint256 tokensSwapped,
330         uint256 ethReceived,
331         uint256 tokensIntoLiquidity
332     );
333  
334     event TransferForeignToken(address token, uint256 amount);
335  
336     constructor() ERC20("Kai Inu", "KAI") {
337  
338         address newOwner = msg.sender; // can leave alone if owner is deployer.
339  
340         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
341         dexRouter = _dexRouter;
342  
343         // create pair
344         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
345         _excludeFromMaxTransaction(address(lpPair), true);
346         _setAutomatedMarketMakerPair(address(lpPair), true);
347  
348         uint256 totalSupply = 1 * 1e6 * 1e18;
349  
350         maxBuyAmount = totalSupply * 1 / 100;
351         maxSellAmount = totalSupply * 1 / 100;
352         maxWalletAmount = totalSupply * 2 / 100;
353         swapTokensAtAmount = totalSupply * 5 / 10000;
354  
355         buyOperationsFee = 10;
356         buyLiquidityFee = 0;
357         buyDevFee = 1;
358         buyBurnFee = 0;
359         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
360  
361         sellOperationsFee = 10;
362         sellLiquidityFee = 0;
363         sellDevFee = 1;
364         sellBurnFee = 0;
365         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
366  
367         _excludeFromMaxTransaction(newOwner, true);
368         _excludeFromMaxTransaction(address(this), true);
369         _excludeFromMaxTransaction(address(0xdead), true);
370  
371         excludeFromFees(newOwner, true);
372         excludeFromFees(address(this), true);
373         excludeFromFees(address(0xdead), true);
374  
375         operationsAddress = address(0x3001eE1f56239d74Dd1948A71548bfD817D2EbB5);
376         devAddress = address(0x72dC1fBAE61C72dD308f4E106E9f3205149F7d1f);
377  
378         _createInitialSupply(newOwner, totalSupply);
379         transferOwnership(newOwner);
380     }
381  
382     receive() external payable {}
383  
384     // only enable if no plan to airdrop
385  
386     function enableTrading(uint256 deadBlocks) external onlyOwner {
387         require(!tradingActive, "Cannot reenable trading");
388         tradingActive = true;
389         swapEnabled = true;
390         tradingActiveBlock = block.number;
391         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
392         emit EnabledTrading();
393     }
394  
395     // remove limits after token is stable
396     function removeLimits() external onlyOwner {
397         limitsInEffect = false;
398         transferDelayEnabled = false;
399         emit RemovedLimits();
400     }
401  
402     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
403         boughtEarly[wallet] = flag;
404     }
405  
406     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
407         for(uint256 i = 0; i < wallets.length; i++){
408             boughtEarly[wallets[i]] = flag;
409         }
410     }
411  
412     // disable Transfer delay - cannot be reenabled
413     function disableTransferDelay() external onlyOwner {
414         transferDelayEnabled = false;
415     }
416  
417     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
418         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
419         maxBuyAmount = newNum * (10**18);
420         emit UpdatedMaxBuyAmount(maxBuyAmount);
421     }
422  
423     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
424         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
425         maxSellAmount = newNum * (10**18);
426         emit UpdatedMaxSellAmount(maxSellAmount);
427     }
428  
429     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
430         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
431         maxWalletAmount = newNum * (10**18);
432         emit UpdatedMaxWalletAmount(maxWalletAmount);
433     }
434  
435     // change the minimum amount of tokens to sell from fees
436     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
437   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
438   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
439   	    swapTokensAtAmount = newAmount;
440   	}
441  
442     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
443         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
444         emit MaxTransactionExclusion(updAds, isExcluded);
445     }
446  
447     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
448         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
449         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
450         for(uint256 i = 0; i < wallets.length; i++){
451             address wallet = wallets[i];
452             uint256 amount = amountsInTokens[i];
453             super._transfer(msg.sender, wallet, amount);
454         }
455     }
456  
457     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
458         if(!isEx){
459             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
460         }
461         _isExcludedMaxTransactionAmount[updAds] = isEx;
462     }
463  
464     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
465         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
466  
467         _setAutomatedMarketMakerPair(pair, value);
468         emit SetAutomatedMarketMakerPair(pair, value);
469     }
470  
471     function _setAutomatedMarketMakerPair(address pair, bool value) private {
472         automatedMarketMakerPairs[pair] = value;
473  
474         _excludeFromMaxTransaction(pair, value);
475  
476         emit SetAutomatedMarketMakerPair(pair, value);
477     }
478  
479     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
480         buyOperationsFee = _operationsFee;
481         buyLiquidityFee = _liquidityFee;
482         buyDevFee = _DevFee;
483         buyBurnFee = _burnFee;
484         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
485         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
486     }
487  
488     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
489         sellOperationsFee = _operationsFee;
490         sellLiquidityFee = _liquidityFee;
491         sellDevFee = _DevFee;
492         sellBurnFee = _burnFee;
493         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
494         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
495     }
496  
497     function returnToNormalTax() external onlyOwner {
498         sellOperationsFee = 20;
499         sellLiquidityFee = 0;
500         sellDevFee = 0;
501         sellBurnFee = 0;
502         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
503         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
504  
505         buyOperationsFee = 20;
506         buyLiquidityFee = 0;
507         buyDevFee = 0;
508         buyBurnFee = 0;
509         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
510         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
511     }
512  
513     function excludeFromFees(address account, bool excluded) public onlyOwner {
514         _isExcludedFromFees[account] = excluded;
515         emit ExcludeFromFees(account, excluded);
516     }
517  
518     function _transfer(address from, address to, uint256 amount) internal override {
519  
520         require(from != address(0), "ERC20: transfer from the zero address");
521         require(to != address(0), "ERC20: transfer to the zero address");
522         require(amount > 0, "amount must be greater than 0");
523  
524         if(!tradingActive){
525             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
526         }
527  
528         if(blockForPenaltyEnd > 0){
529             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
530         }
531  
532         if(limitsInEffect){
533             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
534  
535                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
536                 if (transferDelayEnabled){
537                     if (to != address(dexRouter) && to != address(lpPair)){
538                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
539                         _holderLastTransferTimestamp[tx.origin] = block.number;
540                         _holderLastTransferTimestamp[to] = block.number;
541                     }
542                 }
543  
544                 //when buy
545                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
546                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
547                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
548                 }
549                 //when sell
550                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
551                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
552                 }
553                 else if (!_isExcludedMaxTransactionAmount[to]){
554                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
555                 }
556             }
557         }
558  
559         uint256 contractTokenBalance = balanceOf(address(this));
560  
561         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
562  
563         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
564             swapping = true;
565  
566             swapBack();
567  
568             swapping = false;
569         }
570  
571         bool takeFee = true;
572         // if any account belongs to _isExcludedFromFee account then remove the fee
573         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
574             takeFee = false;
575         }
576  
577         uint256 fees = 0;
578         // only take fees on buys/sells, do not take on wallet transfers
579         if(takeFee){
580             // bot/sniper penalty.
581             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
582  
583                 if(!boughtEarly[to]){
584                     boughtEarly[to] = true;
585                     botsCaught += 1;
586                     emit CaughtEarlyBuyer(to);
587                 }
588  
589                 fees = amount * 99 / 100;
590         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
591                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
592                 tokensForDev += fees * buyDevFee / buyTotalFees;
593                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
594             }
595  
596             // on sell
597             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
598                 fees = amount * sellTotalFees / 100;
599                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
600                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
601                 tokensForDev += fees * sellDevFee / sellTotalFees;
602                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
603             }
604  
605             // on buy
606             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
607         	    fees = amount * buyTotalFees / 100;
608         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
609                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
610                 tokensForDev += fees * buyDevFee / buyTotalFees;
611                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
612             }
613  
614             if(fees > 0){
615                 super._transfer(from, address(this), fees);
616             }
617  
618         	amount -= fees;
619         }
620  
621         super._transfer(from, to, amount);
622     }
623  
624     function earlyBuyPenaltyInEffect() public view returns (bool){
625         return block.number < blockForPenaltyEnd;
626     }
627  
628     function swapTokensForEth(uint256 tokenAmount) private {
629  
630         // generate the uniswap pair path of token -> weth
631         address[] memory path = new address[](2);
632         path[0] = address(this);
633         path[1] = dexRouter.WETH();
634  
635         _approve(address(this), address(dexRouter), tokenAmount);
636  
637         // make the swap
638         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
639             tokenAmount,
640             0, // accept any amount of ETH
641             path,
642             address(this),
643             block.timestamp
644         );
645     }
646  
647     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
648         // approve token transfer to cover all possible scenarios
649         _approve(address(this), address(dexRouter), tokenAmount);
650  
651         // add the liquidity
652         dexRouter.addLiquidityETH{value: ethAmount}(
653             address(this),
654             tokenAmount,
655             0, // slippage is unavoidable
656             0, // slippage is unavoidable
657             address(0xdead),
658             block.timestamp
659         );
660     }
661  
662     function swapBack() private {
663  
664         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
665             _burn(address(this), tokensForBurn);
666         }
667         tokensForBurn = 0;
668  
669         uint256 contractBalance = balanceOf(address(this));
670         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
671  
672         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
673  
674         if(contractBalance > swapTokensAtAmount * 20){
675             contractBalance = swapTokensAtAmount * 20;
676         }
677  
678         bool success;
679  
680         // Halve the amount of liquidity tokens
681         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
682  
683         swapTokensForEth(contractBalance - liquidityTokens);
684  
685         uint256 ethBalance = address(this).balance;
686         uint256 ethForLiquidity = ethBalance;
687  
688         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
689         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
690  
691         ethForLiquidity -= ethForOperations + ethForDev;
692  
693         tokensForLiquidity = 0;
694         tokensForOperations = 0;
695         tokensForDev = 0;
696         tokensForBurn = 0;
697  
698         if(liquidityTokens > 0 && ethForLiquidity > 0){
699             addLiquidity(liquidityTokens, ethForLiquidity);
700         }
701  
702         (success,) = address(devAddress).call{value: ethForDev}("");
703  
704         (success,) = address(operationsAddress).call{value: address(this).balance}("");
705     }
706  
707     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
708         require(_token != address(0), "_token address cannot be 0");
709         require(_token != address(this), "Can't withdraw native tokens");
710         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
711         _sent = IERC20(_token).transfer(_to, _contractBalance);
712         emit TransferForeignToken(_token, _contractBalance);
713     }
714  
715     // withdraw ETH if stuck or someone sends to the address
716     function withdrawStuckETH() external onlyOwner {
717         bool success;
718         (success,) = address(msg.sender).call{value: address(this).balance}("");
719     }
720  
721     function setOperationsAddress(address _operationsAddress) external onlyOwner {
722         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
723         operationsAddress = payable(_operationsAddress);
724     }
725  
726     function setDevAddress(address _devAddress) external onlyOwner {
727         require(_devAddress != address(0), "_devAddress address cannot be 0");
728         devAddress = payable(_devAddress);
729     }
730  
731     // force Swap back if slippage issues.
732     function forceSwapBack() external onlyOwner {
733         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
734         swapping = true;
735         swapBack();
736         swapping = false;
737         emit OwnerForcedSwapBack(block.timestamp);
738     }
739  
740     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
741     function buyBackTokens(uint256 amountInWei) external onlyOwner {
742         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
743  
744         address[] memory path = new address[](2);
745         path[0] = dexRouter.WETH();
746         path[1] = address(this);
747  
748         // make the swap
749         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
750             0, // accept any amount of Ethereum
751             path,
752             address(0xdead),
753             block.timestamp
754         );
755         emit BuyBackTriggered(amountInWei);
756     }
757 }