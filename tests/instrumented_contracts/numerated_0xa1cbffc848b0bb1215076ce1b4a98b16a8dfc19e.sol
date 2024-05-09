1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.11;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 contract ERC20 is Context, IERC20, IERC20Metadata {
109     mapping(address => uint256) private _balances;
110 
111     mapping(address => mapping(address => uint256)) private _allowances;
112 
113     uint256 private _totalSupply;
114 
115     string private _name;
116     string private _symbol;
117 
118     constructor(string memory name_, string memory symbol_) {
119         _name = name_;
120         _symbol = symbol_;
121     }
122 
123     function name() public view virtual override returns (string memory) {
124         return _name;
125     }
126 
127     function symbol() public view virtual override returns (string memory) {
128         return _symbol;
129     }
130 
131     function decimals() public view virtual override returns (uint8) {
132         return 18;
133     }
134 
135     function totalSupply() public view virtual override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(address account) public view virtual override returns (uint256) {
140         return _balances[account];
141     }
142 
143     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
144         _transfer(_msgSender(), recipient, amount);
145         return true;
146     }
147 
148     function allowance(address owner, address spender) public view virtual override returns (uint256) {
149         return _allowances[owner][spender];
150     }
151 
152     function approve(address spender, uint256 amount) public virtual override returns (bool) {
153         _approve(_msgSender(), spender, amount);
154         return true;
155     }
156 
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) public virtual override returns (bool) {
162         _transfer(sender, recipient, amount);
163 
164         uint256 currentAllowance = _allowances[sender][_msgSender()];
165         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
166         unchecked {
167             _approve(sender, _msgSender(), currentAllowance - amount);
168         }
169 
170         return true;
171     }
172 
173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
175         return true;
176     }
177 
178     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
179         uint256 currentAllowance = _allowances[_msgSender()][spender];
180         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
181         unchecked {
182             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
183         }
184 
185         return true;
186     }
187 
188     function _transfer(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) internal virtual {
193         require(sender != address(0), "ERC20: transfer from the zero address");
194         require(recipient != address(0), "ERC20: transfer to the zero address");
195 
196         uint256 senderBalance = _balances[sender];
197         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
198         unchecked {
199             _balances[sender] = senderBalance - amount;
200         }
201         _balances[recipient] += amount;
202 
203         emit Transfer(sender, recipient, amount);
204     }
205 
206     function _createInitialSupply(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _totalSupply += amount;
210         _balances[account] += amount;
211         emit Transfer(address(0), account, amount);
212     }
213 
214     function _approve(
215         address owner,
216         address spender,
217         uint256 amount
218     ) internal virtual {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221 
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 }
226 
227 contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231     
232     constructor () {
233         address msgSender = _msgSender();
234         _owner = msgSender;
235         emit OwnershipTransferred(address(0), msgSender);
236     }
237 
238     function owner() public view returns (address) {
239         return _owner;
240     }
241 
242     modifier onlyOwner() {
243         require(_owner == _msgSender(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     function renounceOwnership() external virtual onlyOwner {
248         emit OwnershipTransferred(_owner, address(0));
249         _owner = address(0);
250     }
251 
252     function transferOwnership(address newOwner) public virtual onlyOwner {
253         require(newOwner != address(0), "Ownable: new owner is the zero address");
254         emit OwnershipTransferred(_owner, newOwner);
255         _owner = newOwner;
256     }
257 }
258 
259 interface IDexRouter {
260     function factory() external pure returns (address);
261     function WETH() external pure returns (address);
262     
263     function swapExactTokensForETHSupportingFeeOnTransferTokens(
264         uint amountIn,
265         uint amountOutMin,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external;
270 
271     function swapExactETHForTokensSupportingFeeOnTransferTokens(
272         uint amountOutMin,
273         address[] calldata path,
274         address to,
275         uint deadline
276     ) external payable;
277 
278     function addLiquidityETH(
279         address token,
280         uint256 amountTokenDesired,
281         uint256 amountTokenMin,
282         uint256 amountETHMin,
283         address to,
284         uint256 deadline
285     )
286         external
287         payable
288         returns (
289             uint256 amountToken,
290             uint256 amountETH,
291             uint256 liquidity
292         );
293 }
294 
295 interface IDexFactory {
296     function createPair(address tokenA, address tokenB)
297         external
298         returns (address pair);
299 }
300 
301 contract MeanTamato is ERC20, Ownable {
302 
303     uint256 public maxBuyAmount;
304     uint256 public maxSellAmount;
305     uint256 public maxWalletAmount;
306 
307     IDexRouter public dexRouter;
308     address public lpPair;
309 
310     bool private swapping;
311     uint256 public swapTokensAtAmount;
312 
313     address public operationsAddress;
314 
315     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
316     uint256 public blockForPenaltyEnd;
317     mapping (address => bool) public boughtEarly;
318     uint256 public botsCaught;
319 
320     bool public limitsInEffect = true;
321     bool public tradingActive = false;
322     bool public swapEnabled = false;
323     
324      // Anti-bot and anti-whale mappings and variables
325     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
326     bool public transferDelayEnabled = true;
327 
328     uint256 public buyTotalFees;
329     uint256 public buyOperationsFee;
330     uint256 public buyLiquidityFee;
331     uint256 public buyBuybackFee;
332     uint256 public buyBurnFee;
333 
334     uint256 public sellTotalFees;
335     uint256 public sellOperationsFee;
336     uint256 public sellLiquidityFee;
337     uint256 public sellBuybackFee;
338     uint256 public sellBurnFee;
339 
340     uint256 public tokensForOperations;
341     uint256 public tokensForLiquidity;
342     uint256 public tokensForBuyback;
343     uint256 public tokensForBurn;
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
387     constructor() ERC20("Mean Tamato", "MEANTAMATO") payable {
388         
389         address newOwner = msg.sender; // can leave alone if owner is deployer.
390 
391         uint256 totalSupply = 5 * 1e12 * 1e18;
392         
393         maxBuyAmount = totalSupply * 25 / 10000;
394         maxSellAmount = totalSupply * 25 / 10000;
395         maxWalletAmount = totalSupply * 1 / 100;
396         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.025% swap amount
397 
398         buyOperationsFee = 3;
399         buyLiquidityFee = 1;
400         buyBuybackFee = 2;
401         buyBurnFee = 4;
402         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyBuybackFee + buyBurnFee;
403 
404         sellOperationsFee = 3;
405         sellLiquidityFee = 1;
406         sellBuybackFee = 2;
407         sellBurnFee = 4;
408         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellBuybackFee + sellBurnFee;
409 
410         _excludeFromMaxTransaction(newOwner, true);
411         _excludeFromMaxTransaction(address(this), true);
412         _excludeFromMaxTransaction(address(0xdead), true);
413 
414         excludeFromFees(newOwner, true);
415         excludeFromFees(address(this), true);
416         excludeFromFees(address(0xdead), true);
417 
418         operationsAddress = address(0x7451C0197489bd35332a5EFb6D2f21F760f0abD8);
419         
420         _createInitialSupply(newOwner, totalSupply*39/100);
421         _createInitialSupply(address(this), totalSupply*61/100);
422         transferOwnership(newOwner);
423     }
424 
425     receive() external payable {}
426 
427     // only enable if no plan to airdrop
428     
429     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
430         require(!tradingActive, "Cannot reenable trading");
431         require(blocksForPenalty < 10, "Cannot make penalty blocks more than 10");
432         // pull any ETH on contract prior to trading to ensure it doesn't get stuck.
433         bool success;
434         (success,) = address(msg.sender).call{value: address(this).balance}("");
435         // initialize router
436         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
437         dexRouter = _dexRouter;
438 
439         // create pair
440         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
441         _excludeFromMaxTransaction(address(lpPair), true);
442         _setAutomatedMarketMakerPair(address(lpPair), true);
443 
444         tradingActive = true;
445         swapEnabled = true;
446         tradingActiveBlock = block.number;
447         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
448         emit EnabledTrading();
449     }
450     
451     // remove limits after token is stable
452     function removeLimits() external onlyOwner {
453         limitsInEffect = false;
454         transferDelayEnabled = false;
455         emit RemovedLimits();
456     }
457 
458     function removeBoughtEarly(address wallet) external onlyOwner {
459         require(boughtEarly[wallet], "Wallet is already not flagged.");
460         boughtEarly[wallet] = false;
461     }
462     
463     // disable Transfer delay - cannot be reenabled
464     function disableTransferDelay() external onlyOwner {
465         transferDelayEnabled = false;
466     }
467     
468     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
469         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
470         maxBuyAmount = newNum * (10**18);
471         emit UpdatedMaxBuyAmount(maxBuyAmount);
472     }
473     
474     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
475         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
476         maxSellAmount = newNum * (10**18);
477         emit UpdatedMaxSellAmount(maxSellAmount);
478     }
479 
480     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
481         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set max wallet amount lower than 0.5%");
482         maxWalletAmount = newNum * (10**18);
483         emit UpdatedMaxWalletAmount(maxWalletAmount);
484     }
485 
486     // change the minimum amount of tokens to sell from fees
487     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
488   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
489   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
490   	    swapTokensAtAmount = newAmount;
491   	}
492     
493     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
494         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
495         emit MaxTransactionExclusion(updAds, isExcluded);
496     }
497 
498     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
499         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
500         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
501         for(uint256 i = 0; i < wallets.length; i++){
502             address wallet = wallets[i];
503             uint256 amount = amountsInTokens[i];
504             super._transfer(msg.sender, wallet, amount);
505         }
506     }
507     
508     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
509         if(!isEx){
510             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
511         }
512         _isExcludedMaxTransactionAmount[updAds] = isEx;
513     }
514 
515     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
516         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
517 
518         _setAutomatedMarketMakerPair(pair, value);
519         emit SetAutomatedMarketMakerPair(pair, value);
520     }
521 
522     function _setAutomatedMarketMakerPair(address pair, bool value) private {
523         automatedMarketMakerPairs[pair] = value;
524         
525         _excludeFromMaxTransaction(pair, value);
526 
527         emit SetAutomatedMarketMakerPair(pair, value);
528     }
529 
530     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _buybackFee, uint256 _burnFee) external onlyOwner {
531         buyOperationsFee = _operationsFee;
532         buyLiquidityFee = _liquidityFee;
533         buyBuybackFee = _buybackFee;
534         buyBurnFee = _burnFee;
535         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyBuybackFee + buyBurnFee;
536         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
537     }
538 
539     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _buybackFee, uint256 _burnFee) external onlyOwner {
540         sellOperationsFee = _operationsFee;
541         sellLiquidityFee = _liquidityFee;
542         sellBuybackFee = _buybackFee;
543         sellBurnFee = _burnFee;
544         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellBuybackFee + sellBurnFee;
545         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
546     }
547 
548     function excludeFromFees(address account, bool excluded) public onlyOwner {
549         _isExcludedFromFees[account] = excluded;
550         emit ExcludeFromFees(account, excluded);
551     }
552 
553     function _transfer(address from, address to, uint256 amount) internal override {
554 
555         require(from != address(0), "ERC20: transfer from the zero address");
556         require(to != address(0), "ERC20: transfer to the zero address");
557         require(amount > 0, "amount must be greater than 0");
558         
559         if(!tradingActive){
560             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
561         }
562 
563         if(!earlyBuyPenaltyInEffect()){
564             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
565         }
566         
567         if(limitsInEffect){
568             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
569                 
570                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
571                 if (transferDelayEnabled){
572                     if (to != address(dexRouter) && to != address(lpPair)){
573                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
574                         _holderLastTransferTimestamp[tx.origin] = block.number;
575                         _holderLastTransferTimestamp[to] = block.number;
576                     }
577                 }
578                  
579                 //when buy
580                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
581                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
582                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
583                 } 
584                 //when sell
585                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
586                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
587                 } 
588                 else if (!_isExcludedMaxTransactionAmount[to]){
589                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
590                 }
591             }
592         }
593 
594         uint256 contractTokenBalance = balanceOf(address(this));
595         
596         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
597 
598         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
599             swapping = true;
600 
601             swapBack();
602 
603             swapping = false;
604         }
605 
606         bool takeFee = true;
607         // if any account belongs to _isExcludedFromFee account then remove the fee
608         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
609             takeFee = false;
610         }
611         
612         uint256 fees = 0;
613         // only take fees on buys/sells, do not take on wallet transfers
614         if(takeFee){
615             // bot/sniper penalty.
616             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
617                 
618                 if(!boughtEarly[to]){
619                     boughtEarly[to] = true;
620                     botsCaught += 1;
621                     emit CaughtEarlyBuyer(to);
622                 }
623 
624                 fees = amount * buyTotalFees / 100;
625         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
626                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
627                 tokensForBuyback += fees * buyBuybackFee / buyTotalFees;
628                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
629             }
630 
631             // on sell
632             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
633                 fees = amount * sellTotalFees / 100;
634                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
635                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
636                 tokensForBuyback += fees * sellBuybackFee / sellTotalFees;
637                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
638             }
639 
640             // on buy
641             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
642         	    fees = amount * buyTotalFees / 100;
643         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
644                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
645                 tokensForBuyback += fees * buyBuybackFee / buyTotalFees;
646                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
647             }
648             
649             if(fees > 0){    
650                 super._transfer(from, address(this), fees);
651             }
652         	
653         	amount -= fees;
654         }
655 
656         super._transfer(from, to, amount);
657     }
658 
659     function earlyBuyPenaltyInEffect() public view returns (bool){
660         return block.number < blockForPenaltyEnd;
661     }
662 
663     function swapTokensForEth(uint256 tokenAmount) private {
664 
665         // generate the uniswap pair path of token -> weth
666         address[] memory path = new address[](2);
667         path[0] = address(this);
668         path[1] = dexRouter.WETH();
669 
670         _approve(address(this), address(dexRouter), tokenAmount);
671 
672         // make the swap
673         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
674             tokenAmount,
675             0, // accept any amount of ETH
676             path,
677             address(this),
678             block.timestamp
679         );
680     }
681     
682     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
683         // approve token transfer to cover all possible scenarios
684         _approve(address(this), address(dexRouter), tokenAmount);
685 
686         // add the liquidity
687         dexRouter.addLiquidityETH{value: ethAmount}(
688             address(this),
689             tokenAmount,
690             0, // slippage is unavoidable
691             0, // slippage is unavoidable
692             address(0xdead),
693             block.timestamp
694         );
695     }
696 
697     function swapBack() private {
698         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
699             _transfer(address(this), address(0xdead), tokensForBurn);
700             tokensForBurn = 0;
701         }
702 
703         uint256 contractBalance = balanceOf(address(this));
704         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForBuyback;
705         
706         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
707 
708         if(contractBalance > swapTokensAtAmount * 20){
709             contractBalance = swapTokensAtAmount * 20;
710         }
711 
712         bool success;
713         
714         // Halve the amount of liquidity tokens
715         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
716         
717         swapTokensForEth(contractBalance - liquidityTokens); 
718         
719         uint256 ethBalance = address(this).balance;
720         uint256 ethForLiquidity = ethBalance;
721 
722         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
723         uint256 ethForBuyback = ethBalance * tokensForBuyback / (totalTokensToSwap - (tokensForLiquidity/2));
724 
725         ethForLiquidity -= ethForOperations + ethForBuyback;
726             
727         tokensForLiquidity = 0;
728         tokensForOperations = 0;
729         tokensForBuyback = 0;
730         
731         if(liquidityTokens > 0 && ethForLiquidity > 0){
732             addLiquidity(liquidityTokens, ethForLiquidity);
733         }
734 
735         (success,) = address(operationsAddress).call{value: ethForOperations}("");
736 
737         // remainder stays on contract for buybacks
738     }
739 
740     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
741         require(_token != address(0), "_token address cannot be 0");
742         require(_token != address(this), "Can't withdraw native tokens");
743         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
744         _sent = IERC20(_token).transfer(_to, _contractBalance);
745         emit TransferForeignToken(_token, _contractBalance);
746     }
747 
748     // withdraw ETH if stuck or someone sends to the address
749     function withdrawStuckETH() external onlyOwner {
750         require(!tradingActive, "Cannot withdraw ETH after launch, it is for buybacks only.");
751         bool success;
752         (success,) = address(msg.sender).call{value: address(this).balance}("");
753     }
754 
755     function setOperationsAddress(address _operationsAddress) external onlyOwner {
756         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
757         operationsAddress = payable(_operationsAddress);
758         emit UpdatedOperationsAddress(_operationsAddress);
759     }
760 
761     // force Swap back if slippage issues.
762     function forceSwapBack() external onlyOwner {
763         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
764         swapping = true;
765         swapBack();
766         swapping = false;
767         emit OwnerForcedSwapBack(block.timestamp);
768     }
769 
770     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
771     function buyBackTokens(uint256 amountInWei) external onlyOwner {
772         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
773 
774         address[] memory path = new address[](2);
775         path[0] = dexRouter.WETH();
776         path[1] = address(this);
777 
778         // make the swap
779         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
780             0, // accept any amount of Ethereum
781             path,
782             address(0xdead),
783             block.timestamp
784         );
785         emit BuyBackTriggered(amountInWei);
786     }
787 
788     function launch(address[] memory wallets, uint256[] memory amountsInTokens, uint256 blocksForPenalty) external onlyOwner {
789         require(!tradingActive, "Trading is already active, cannot relaunch.");
790         require(blocksForPenalty < 10, "Cannot make penalty blocks more than 10");
791 
792         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
793         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
794         for(uint256 i = 0; i < wallets.length; i++){
795             address wallet = wallets[i];
796             uint256 amount = amountsInTokens[i];
797             super._transfer(msg.sender, wallet, amount);
798         }
799 
800         //standard enable trading
801         tradingActive = true;
802         swapEnabled = true;
803         tradingActiveBlock = block.number;
804         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
805         emit EnabledTrading();
806 
807         // initialize router
808         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
809         dexRouter = _dexRouter;
810 
811         // create pair
812         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
813         _excludeFromMaxTransaction(address(lpPair), true);
814         _setAutomatedMarketMakerPair(address(lpPair), true);
815    
816         // add the liquidity
817 
818         require(address(this).balance > 0, "Must have ETH on contract to launch");
819 
820         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
821 
822         _approve(address(this), address(dexRouter), balanceOf(address(this)));
823         dexRouter.addLiquidityETH{value: address(this).balance}(
824             address(this),
825             balanceOf(address(this)),
826             0, // slippage is unavoidable
827             0, // slippage is unavoidable
828             msg.sender,
829             block.timestamp
830         );
831     }
832 }