1 /**
2 Website - https://artifylabs.io/
3 Telegram - https://t.me/artifylabs
4 Twitter - https://twitter.com/artifyerc
5 Medium - https://medium.com/@artifylabs
6 Whitepaper - https://artify.gitbook.io/artify-whitepaper/
7  
8 */
9  
10 // SPDX-License-Identifier: MIT
11  
12 pragma solidity 0.8.15;
13  
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18  
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24  
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30  
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35  
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44  
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53  
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69  
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address sender,
81         address recipient,
82         uint256 amount
83     ) external returns (bool);
84  
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92  
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99  
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105  
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110  
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116  
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     mapping(address => uint256) private _balances;
119  
120     mapping(address => mapping(address => uint256)) private _allowances;
121  
122     uint256 private _totalSupply;
123  
124     string private _name;
125     string private _symbol;
126  
127     constructor(string memory name_, string memory symbol_) {
128         _name = name_;
129         _symbol = symbol_;
130     }
131  
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135  
136     function symbol() public view virtual override returns (string memory) {
137         return _symbol;
138     }
139  
140     function decimals() public view virtual override returns (uint8) {
141         return 18;
142     }
143  
144     function totalSupply() public view virtual override returns (uint256) {
145         return _totalSupply;
146     }
147  
148     function balanceOf(address account) public view virtual override returns (uint256) {
149         return _balances[account];
150     }
151  
152     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
153         _transfer(_msgSender(), recipient, amount);
154         return true;
155     }
156  
157     function allowance(address owner, address spender) public view virtual override returns (uint256) {
158         return _allowances[owner][spender];
159     }
160  
161     function approve(address spender, uint256 amount) public virtual override returns (bool) {
162         _approve(_msgSender(), spender, amount);
163         return true;
164     }
165  
166     function transferFrom(
167         address sender,
168         address recipient,
169         uint256 amount
170     ) public virtual override returns (bool) {
171         _transfer(sender, recipient, amount);
172  
173         uint256 currentAllowance = _allowances[sender][_msgSender()];
174         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
175         unchecked {
176             _approve(sender, _msgSender(), currentAllowance - amount);
177         }
178  
179         return true;
180     }
181  
182     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
184         return true;
185     }
186  
187     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
188         uint256 currentAllowance = _allowances[_msgSender()][spender];
189         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
190         unchecked {
191             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
192         }
193  
194         return true;
195     }
196  
197     function _transfer(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) internal virtual {
202         require(sender != address(0), "ERC20: transfer from the zero address");
203         require(recipient != address(0), "ERC20: transfer to the zero address");
204  
205         uint256 senderBalance = _balances[sender];
206         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
207         unchecked {
208             _balances[sender] = senderBalance - amount;
209         }
210         _balances[recipient] += amount;
211  
212         emit Transfer(sender, recipient, amount);
213     }
214  
215     function _createInitialSupply(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: mint to the zero address");
217  
218         _totalSupply += amount;
219         _balances[account] += amount;
220         emit Transfer(address(0), account, amount);
221     }
222  
223     function _burn(address account, uint256 amount) internal virtual {
224         require(account != address(0), "ERC20: burn from the zero address");
225         uint256 accountBalance = _balances[account];
226         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
227         unchecked {
228             _balances[account] = accountBalance - amount;
229             // Overflow not possible: amount <= accountBalance <= totalSupply.
230             _totalSupply -= amount;
231         }
232  
233         emit Transfer(account, address(0), amount);
234     }
235  
236     function _approve(
237         address owner,
238         address spender,
239         uint256 amount
240     ) internal virtual {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243  
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247 }
248  
249 contract Ownable is Context {
250     address private _owner;
251  
252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253  
254     constructor () {
255         address msgSender = _msgSender();
256         _owner = msgSender;
257         emit OwnershipTransferred(address(0), msgSender);
258     }
259  
260     function owner() public view returns (address) {
261         return _owner;
262     }
263  
264     modifier onlyOwner() {
265         require(_owner == _msgSender(), "Ownable: caller is not the owner");
266         _;
267     }
268  
269     function renounceOwnership() external virtual onlyOwner {
270         emit OwnershipTransferred(_owner, address(0));
271         _owner = address(0);
272     }
273  
274     function transferOwnership(address newOwner) public virtual onlyOwner {
275         require(newOwner != address(0), "Ownable: new owner is the zero address");
276         emit OwnershipTransferred(_owner, newOwner);
277         _owner = newOwner;
278     }
279 }
280  
281 interface IDexRouter {
282     function factory() external pure returns (address);
283     function WETH() external pure returns (address);
284  
285     function swapExactTokensForETHSupportingFeeOnTransferTokens(
286         uint amountIn,
287         uint amountOutMin,
288         address[] calldata path,
289         address to,
290         uint deadline
291     ) external;
292  
293     function swapExactETHForTokensSupportingFeeOnTransferTokens(
294         uint amountOutMin,
295         address[] calldata path,
296         address to,
297         uint deadline
298     ) external payable;
299  
300     function addLiquidityETH(
301         address token,
302         uint256 amountTokenDesired,
303         uint256 amountTokenMin,
304         uint256 amountETHMin,
305         address to,
306         uint256 deadline
307     )
308         external
309         payable
310         returns (
311             uint256 amountToken,
312             uint256 amountETH,
313             uint256 liquidity
314         );
315 }
316  
317 interface IDexFactory {
318     function createPair(address tokenA, address tokenB)
319         external
320         returns (address pair);
321 }
322  
323 contract Artify is ERC20, Ownable {
324  
325     uint256 public maxBuyAmount;
326     uint256 public maxSellAmount;
327     uint256 public maxWalletAmount;
328  
329     IDexRouter public dexRouter;
330     address public lpPair;
331  
332     bool private swapping;
333     uint256 public swapTokensAtAmount;
334  
335     address operationsAddress;
336     address devAddress;
337  
338     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
339     uint256 public blockForPenaltyEnd;
340     mapping (address => bool) public boughtEarly;
341     uint256 public botsCaught;
342  
343     bool public limitsInEffect = true;
344     bool public tradingActive = false;
345     bool public swapEnabled = false;
346  
347      // Anti-bot and anti-whale mappings and variables
348     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
349     bool public transferDelayEnabled = true;
350  
351     uint256 public buyTotalFees;
352     uint256 public buyOperationsFee;
353     uint256 public buyLiquidityFee;
354     uint256 public buyDevFee;
355     uint256 public buyBurnFee;
356  
357     uint256 public sellTotalFees;
358     uint256 public sellOperationsFee;
359     uint256 public sellLiquidityFee;
360     uint256 public sellDevFee;
361     uint256 public sellBurnFee;
362  
363     uint256 public tokensForOperations;
364     uint256 public tokensForLiquidity;
365     uint256 public tokensForDev;
366     uint256 public tokensForBurn;
367  
368     /******************/
369  
370     // exlcude from fees and max transaction amount
371     mapping (address => bool) private _isExcludedFromFees;
372     mapping (address => bool) public _isExcludedMaxTransactionAmount;
373  
374     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
375     // could be subject to a maximum transfer amount
376     mapping (address => bool) public automatedMarketMakerPairs;
377  
378     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
379  
380     event EnabledTrading();
381  
382     event RemovedLimits();
383  
384     event ExcludeFromFees(address indexed account, bool isExcluded);
385  
386     event UpdatedMaxBuyAmount(uint256 newAmount);
387  
388     event UpdatedMaxSellAmount(uint256 newAmount);
389  
390     event UpdatedMaxWalletAmount(uint256 newAmount);
391  
392     event UpdatedOperationsAddress(address indexed newWallet);
393  
394     event MaxTransactionExclusion(address _address, bool excluded);
395  
396     event BuyBackTriggered(uint256 amount);
397  
398     event OwnerForcedSwapBack(uint256 timestamp);
399  
400     event CaughtEarlyBuyer(address sniper);
401  
402     event SwapAndLiquify(
403         uint256 tokensSwapped,
404         uint256 ethReceived,
405         uint256 tokensIntoLiquidity
406     );
407  
408     event TransferForeignToken(address token, uint256 amount);
409  
410     constructor() ERC20("Artify", "AFY") {
411  
412         address newOwner = msg.sender; // can leave alone if owner is deployer.
413  
414         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
415         dexRouter = _dexRouter;
416  
417         // create pair
418         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
419         _excludeFromMaxTransaction(address(lpPair), true);
420         _setAutomatedMarketMakerPair(address(lpPair), true);
421  
422         uint256 totalSupply = 5 * 1e12 * 1e18;
423  
424         maxBuyAmount = totalSupply * 1 / 100;
425         maxSellAmount = totalSupply * 1 / 100;
426         maxWalletAmount = totalSupply * 1 / 100;
427         swapTokensAtAmount = totalSupply * 1 / 10000;
428  
429         buyOperationsFee = 5;
430         buyLiquidityFee = 5;
431         buyDevFee = 0;
432         buyBurnFee = 0;
433         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
434  
435         sellOperationsFee = 20;
436         sellLiquidityFee = 20;
437         sellDevFee = 0;
438         sellBurnFee = 0;
439         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
440  
441         _excludeFromMaxTransaction(newOwner, true);
442         _excludeFromMaxTransaction(address(this), true);
443         _excludeFromMaxTransaction(address(0xdead), true);
444  
445         excludeFromFees(newOwner, true);
446         excludeFromFees(address(this), true);
447         excludeFromFees(address(0xdead), true);
448  
449         operationsAddress = address(newOwner);
450         devAddress = address(newOwner);
451  
452         _createInitialSupply(newOwner, totalSupply);
453         transferOwnership(newOwner);
454     }
455  
456     receive() external payable {}
457  
458     // only enable if no plan to airdrop
459  
460     function enableTrading(uint256 deadBlocks) external onlyOwner {
461         require(!tradingActive, "Cannot reenable trading");
462         tradingActive = true;
463         swapEnabled = true;
464         tradingActiveBlock = block.number;
465         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
466         emit EnabledTrading();
467     }
468  
469     // remove limits after token is stable
470     function removeLimits() external onlyOwner {
471         limitsInEffect = false;
472         transferDelayEnabled = false;
473         emit RemovedLimits();
474     }
475  
476     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
477         boughtEarly[wallet] = flag;
478     }
479  
480     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
481         for(uint256 i = 0; i < wallets.length; i++){
482             boughtEarly[wallets[i]] = flag;
483         }
484     }
485  
486     // disable Transfer delay - cannot be reenabled
487     function disableTransferDelay() external onlyOwner {
488         transferDelayEnabled = false;
489     }
490  
491     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
492         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
493         maxBuyAmount = newNum * (10**18);
494         emit UpdatedMaxBuyAmount(maxBuyAmount);
495     }
496  
497     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
498         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
499         maxSellAmount = newNum * (10**18);
500         emit UpdatedMaxSellAmount(maxSellAmount);
501     }
502  
503     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
504         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
505         maxWalletAmount = newNum * (10**18);
506         emit UpdatedMaxWalletAmount(maxWalletAmount);
507     }
508  
509     // change the minimum amount of tokens to sell from fees
510     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
511   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
512   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
513   	    swapTokensAtAmount = newAmount;
514   	}
515  
516     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
517         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
518         emit MaxTransactionExclusion(updAds, isExcluded);
519     }
520  
521     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
522         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
523         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
524         for(uint256 i = 0; i < wallets.length; i++){
525             address wallet = wallets[i];
526             uint256 amount = amountsInTokens[i];
527             super._transfer(msg.sender, wallet, amount);
528         }
529     }
530  
531     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
532         if(!isEx){
533             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
534         }
535         _isExcludedMaxTransactionAmount[updAds] = isEx;
536     }
537  
538     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
539         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
540  
541         _setAutomatedMarketMakerPair(pair, value);
542         emit SetAutomatedMarketMakerPair(pair, value);
543     }
544  
545     function _setAutomatedMarketMakerPair(address pair, bool value) private {
546         automatedMarketMakerPairs[pair] = value;
547  
548         _excludeFromMaxTransaction(pair, value);
549  
550         emit SetAutomatedMarketMakerPair(pair, value);
551     }
552  
553     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
554         buyOperationsFee = _operationsFee;
555         buyLiquidityFee = _liquidityFee;
556         buyDevFee = _devFee;
557         buyBurnFee = _burnFee;
558         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
559         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
560     }
561  
562     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
563         sellOperationsFee = _operationsFee;
564         sellLiquidityFee = _liquidityFee;
565         sellDevFee = _devFee;
566         sellBurnFee = _burnFee;
567         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
568         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
569     }
570  
571     function returnToNormalTax() external onlyOwner {
572         sellOperationsFee = 3;
573         sellLiquidityFee = 2;
574         sellDevFee = 0;
575         sellBurnFee = 0;
576         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
577         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
578  
579         buyOperationsFee = 4;
580         buyLiquidityFee = 1;
581         buyDevFee = 0;
582         buyBurnFee = 0;
583         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
584         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
585     }
586  
587     function excludeFromFees(address account, bool excluded) public onlyOwner {
588         _isExcludedFromFees[account] = excluded;
589         emit ExcludeFromFees(account, excluded);
590     }
591  
592     function _transfer(address from, address to, uint256 amount) internal override {
593  
594         require(from != address(0), "ERC20: transfer from the zero address");
595         require(to != address(0), "ERC20: transfer to the zero address");
596         require(amount > 0, "amount must be greater than 0");
597  
598         if(!tradingActive){
599             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
600         }
601  
602         if(blockForPenaltyEnd > 0){
603             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
604         }
605  
606         if(limitsInEffect){
607             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
608  
609                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
610                 if (transferDelayEnabled){
611                     if (to != address(dexRouter) && to != address(lpPair)){
612                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
613                         _holderLastTransferTimestamp[tx.origin] = block.number;
614                         _holderLastTransferTimestamp[to] = block.number;
615                     }
616                 }
617  
618                 //when buy
619                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
620                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
621                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
622                 }
623                 //when sell
624                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
625                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
626                 }
627                 else if (!_isExcludedMaxTransactionAmount[to]){
628                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
629                 }
630             }
631         }
632  
633         uint256 contractTokenBalance = balanceOf(address(this));
634  
635         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
636  
637         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
638             swapping = true;
639  
640             swapBack();
641  
642             swapping = false;
643         }
644  
645         bool takeFee = true;
646         // if any account belongs to _isExcludedFromFee account then remove the fee
647         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
648             takeFee = false;
649         }
650  
651         uint256 fees = 0;
652         // only take fees on buys/sells, do not take on wallet transfers
653         if(takeFee){
654             // bot/sniper penalty.
655             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
656  
657                 if(!boughtEarly[to]){
658                     boughtEarly[to] = true;
659                     botsCaught += 1;
660                     emit CaughtEarlyBuyer(to);
661                 }
662  
663                 fees = amount * 99 / 100;
664         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
665                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
666                 tokensForDev += fees * buyDevFee / buyTotalFees;
667                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
668             }
669  
670             // on sell
671             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
672                 fees = amount * sellTotalFees / 100;
673                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
674                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
675                 tokensForDev += fees * sellDevFee / sellTotalFees;
676                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
677             }
678  
679             // on buy
680             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
681         	    fees = amount * buyTotalFees / 100;
682         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
683                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
684                 tokensForDev += fees * buyDevFee / buyTotalFees;
685                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
686             }
687  
688             if(fees > 0){
689                 super._transfer(from, address(this), fees);
690             }
691  
692         	amount -= fees;
693         }
694  
695         super._transfer(from, to, amount);
696     }
697  
698     function earlyBuyPenaltyInEffect() public view returns (bool){
699         return block.number < blockForPenaltyEnd;
700     }
701  
702     function swapTokensForEth(uint256 tokenAmount) private {
703  
704         // generate the uniswap pair path of token -> weth
705         address[] memory path = new address[](2);
706         path[0] = address(this);
707         path[1] = dexRouter.WETH();
708  
709         _approve(address(this), address(dexRouter), tokenAmount);
710  
711         // make the swap
712         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
713             tokenAmount,
714             0, // accept any amount of ETH
715             path,
716             address(this),
717             block.timestamp
718         );
719     }
720  
721     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
722         // approve token transfer to cover all possible scenarios
723         _approve(address(this), address(dexRouter), tokenAmount);
724  
725         // add the liquidity
726         dexRouter.addLiquidityETH{value: ethAmount}(
727             address(this),
728             tokenAmount,
729             0, // slippage is unavoidable
730             0, // slippage is unavoidable
731             address(0xdead),
732             block.timestamp
733         );
734     }
735  
736     function swapBack() private {
737  
738         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
739             _burn(address(this), tokensForBurn);
740         }
741         tokensForBurn = 0;
742  
743         uint256 contractBalance = balanceOf(address(this));
744         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
745  
746         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
747  
748         if(contractBalance > swapTokensAtAmount * 60){
749             contractBalance = swapTokensAtAmount * 60;
750         }
751  
752         bool success;
753  
754         // Halve the amount of liquidity tokens
755         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
756  
757         swapTokensForEth(contractBalance - liquidityTokens);
758  
759         uint256 ethBalance = address(this).balance;
760         uint256 ethForLiquidity = ethBalance;
761  
762         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
763         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
764  
765         ethForLiquidity -= ethForOperations + ethForDev;
766  
767         tokensForLiquidity = 0;
768         tokensForOperations = 0;
769         tokensForDev = 0;
770         tokensForBurn = 0;
771  
772         if(liquidityTokens > 0 && ethForLiquidity > 0){
773             addLiquidity(liquidityTokens, ethForLiquidity);
774         }
775  
776         (success,) = address(devAddress).call{value: ethForDev}("");
777  
778         (success,) = address(operationsAddress).call{value: address(this).balance}("");
779     }
780  
781     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
782         require(_token != address(0), "_token address cannot be 0");
783         require(_token != address(this), "Can't withdraw native tokens");
784         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
785         _sent = IERC20(_token).transfer(_to, _contractBalance);
786         emit TransferForeignToken(_token, _contractBalance);
787     }
788  
789     // withdraw ETH if stuck or someone sends to the address
790     function withdrawStuckETH() external onlyOwner {
791         bool success;
792         (success,) = address(msg.sender).call{value: address(this).balance}("");
793     }
794  
795     function setOperationsAddress(address _operationsAddress) external onlyOwner {
796         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
797         operationsAddress = payable(_operationsAddress);
798     }
799  
800     function setDevAddress(address _devAddress) external onlyOwner {
801         require(_devAddress != address(0), "_devAddress address cannot be 0");
802         devAddress = payable(_devAddress);
803     }
804  
805     // force Swap back if slippage issues.
806     function forceSwapBack() external onlyOwner {
807         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
808         swapping = true;
809         swapBack();
810         swapping = false;
811         emit OwnerForcedSwapBack(block.timestamp);
812     }
813  
814     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
815     function buyBackTokens(uint256 amountInWei) external onlyOwner {
816         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
817  
818         address[] memory path = new address[](2);
819         path[0] = dexRouter.WETH();
820         path[1] = address(this);
821  
822         // make the swap
823         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
824             0, // accept any amount of Ethereum
825             path,
826             address(0xdead),
827             block.timestamp
828         );
829         emit BuyBackTriggered(amountInWei);
830     }
831 }