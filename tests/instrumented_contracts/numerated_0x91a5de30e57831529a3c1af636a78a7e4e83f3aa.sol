1 /**
2 JOIN US AS HULK INU, THE STRONGEST OF ALL INUS!
3 BRINGS NEVER ENDING GREEN CANDLES TO THE CHART AND
4 RESTORES BALANCE TO THE CRYPTO UNIVERSE.
5 
6 t.me/https://t.me/HULKINUPORTAL
7 https://hulk-inu.com/
8 
9 contract by @spearsire
10 */
11 
12 // SPDX-License-Identifier: MIT                                                                               
13                                                     
14 pragma solidity 0.8.11;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 interface IDexPair {
28     function sync() external;
29 }
30 
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 interface IERC20Metadata is IERC20 {
107     /**
108      * @dev Returns the name of the token.
109      */
110     function name() external view returns (string memory);
111 
112     /**
113      * @dev Returns the symbol of the token.
114      */
115     function symbol() external view returns (string memory);
116 
117     /**
118      * @dev Returns the decimals places of the token.
119      */
120     function decimals() external view returns (uint8);
121 }
122 
123 
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     mapping(address => uint256) private _balances;
126 
127     mapping(address => mapping(address => uint256)) private _allowances;
128 
129     uint256 private _totalSupply;
130 
131     string public _name;
132     string public _symbol;
133 
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138 
139     function name() public view virtual override returns (string memory) {
140         return _name;
141     }
142 
143     function symbol() public view virtual override returns (string memory) {
144         return _symbol;
145     }
146 
147     function decimals() public view virtual override returns (uint8) {
148         return 18;
149     }
150 
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address account) public view virtual override returns (uint256) {
156         return _balances[account];
157     }
158 
159     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
160         _transfer(_msgSender(), recipient, amount);
161         return true;
162     }
163 
164     function allowance(address owner, address spender) public view virtual override returns (uint256) {
165         return _allowances[owner][spender];
166     }
167 
168     function approve(address spender, uint256 amount) public virtual override returns (bool) {
169         _approve(_msgSender(), spender, amount);
170         return true;
171     }
172 
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) public virtual override returns (bool) {
178         _transfer(sender, recipient, amount);
179 
180         uint256 currentAllowance = _allowances[sender][_msgSender()];
181         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
182         unchecked {
183             _approve(sender, _msgSender(), currentAllowance - amount);
184         }
185 
186         return true;
187     }
188 
189     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
191         return true;
192     }
193 
194     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
195         uint256 currentAllowance = _allowances[_msgSender()][spender];
196         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
197         unchecked {
198             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
199         }
200 
201         return true;
202     }
203 
204     function _transfer(
205         address sender,
206         address recipient,
207         uint256 amount
208     ) internal virtual {
209         require(sender != address(0), "ERC20: transfer from the zero address");
210         require(recipient != address(0), "ERC20: transfer to the zero address");
211 
212         uint256 senderBalance = _balances[sender];
213         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
214         unchecked {
215             _balances[sender] = senderBalance - amount;
216         }
217         _balances[recipient] += amount;
218 
219         emit Transfer(sender, recipient, amount);
220     }
221 
222     function _createInitialSupply(address account, uint256 amount) internal virtual {
223         require(account != address(0), "ERC20: mint to the zero address");
224 
225         _totalSupply += amount;
226         _balances[account] += amount;
227         emit Transfer(address(0), account, amount);
228     }
229 
230     function _approve(
231         address owner,
232         address spender,
233         uint256 amount
234     ) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237 
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 }
242 
243 
244 contract Ownable is Context {
245     address private _owner;
246 
247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248     
249     /**
250      * @dev Initializes the contract setting the deployer as the initial owner.
251      */
252     constructor () {
253         address msgSender = _msgSender();
254         _owner = msgSender;
255         emit OwnershipTransferred(address(0), msgSender);
256     }
257 
258     /**
259      * @dev Returns the address of the current owner.
260      */
261     function owner() public view returns (address) {
262         return _owner;
263     }
264 
265     /**
266      * @dev Throws if called by any account other than the owner.
267      */
268     modifier onlyOwner() {
269         require(_owner == _msgSender(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions anymore. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby removing any functionality that is only available to the owner.
279      */
280     function renounceOwnership() external virtual onlyOwner {
281         emit OwnershipTransferred(_owner, address(0));
282         _owner = address(0);
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) external virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         emit OwnershipTransferred(_owner, newOwner);
292         _owner = newOwner;
293     }
294 }
295 
296 interface IDexRouter {
297     function factory() external pure returns (address);
298     function WETH() external pure returns (address);
299     
300     function swapExactTokensForETHSupportingFeeOnTransferTokens(
301         uint amountIn,
302         uint amountOutMin,
303         address[] calldata path,
304         address to,
305         uint deadline
306     ) external;
307 
308     function swapExactETHForTokensSupportingFeeOnTransferTokens(
309         uint amountOutMin,
310         address[] calldata path,
311         address to,
312         uint deadline
313     ) external payable;
314 
315     function addLiquidityETH(
316         address token,
317         uint256 amountTokenDesired,
318         uint256 amountTokenMin,
319         uint256 amountETHMin,
320         address to,
321         uint256 deadline
322     )
323         external
324         payable
325         returns (
326             uint256 amountToken,
327             uint256 amountETH,
328             uint256 liquidity
329         );
330         
331 }
332 
333 interface IDexFactory {
334     function createPair(address tokenA, address tokenB)
335         external
336         returns (address pair);
337 }
338 
339 contract HULKINU is ERC20, Ownable {
340 
341     IDexRouter public dexRouter;
342     address public lpPair;
343     address public constant deadAddress = address(0xdead);
344 
345     bool private swapping;
346 
347     address public marketingWallet;
348     address public devWallet;
349     
350    
351     uint256 private blockPenalty;
352 
353     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
354 
355     uint256 public maxTxnAmount;
356     uint256 public swapTokensAtAmount;
357     uint256 public maxWallet;
358 
359 
360     uint256 public amountForAutoBuyBack = 0.2 ether;
361     bool public autoBuyBackEnabled = true;
362     uint256 public autoBuyBackFrequency = 3600 seconds;
363     uint256 public lastAutoBuyBackTime;
364     
365     uint256 public percentForLPBurn = 100; // 100 = 1%
366     bool public lpBurnEnabled = true;
367     uint256 public lpBurnFrequency = 3600 seconds;
368     uint256 public lastLpBurnTime;
369     
370     uint256 public manualBurnFrequency = 1 hours;
371     uint256 public lastManualLpBurnTime;
372 
373     bool public limitsInEffect = true;
374     bool public tradingActive = false;
375     bool public swapEnabled = false;
376     
377      // Anti-bot and anti-whale mappings and variables
378     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
379     bool public transferDelayEnabled = true;
380 
381     uint256 public buyTotalFees;
382     uint256 public buyMarketingFee;
383     uint256 public buyLiquidityFee;
384     uint256 public buyBuyBackFee;
385     uint256 public buyDevFee;
386     
387     uint256 public sellTotalFees;
388     uint256 public sellMarketingFee;
389     uint256 public sellLiquidityFee;
390     uint256 public sellBuyBackFee;
391     uint256 public sellDevFee;
392     
393     uint256 public tokensForMarketing;
394     uint256 public tokensForLiquidity;
395     uint256 public tokensForBuyBack;
396     uint256 public tokensForDev;
397     
398     /******************/
399 
400     // exlcude from fees and max transaction amount
401     mapping (address => bool) private _isExcludedFromFees;
402     mapping (address => bool) public _isExcludedmaxTxnAmount;
403 
404     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
405     // could be subject to a maximum transfer amount
406     mapping (address => bool) public automatedMarketMakerPairs;
407 
408     event ExcludeFromFees(address indexed account, bool isExcluded);
409 
410     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
411 
412     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
413 
414     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
415 
416     event SwapAndLiquify(
417         uint256 tokensSwapped,
418         uint256 ethReceived,
419         uint256 tokensIntoLiquidity
420     );
421     
422     event AutoNukeLP(uint256 amount);
423     
424     event ManualNukeLP(uint256 amount);
425     
426     event BuyBackTriggered(uint256 amount);
427 
428     event OwnerForcedSwapBack(uint256 timestamp);
429 
430     constructor() ERC20("HULK INU", "HULK") payable {
431                 
432         uint256 _buyMarketingFee = 3;
433         uint256 _buyLiquidityFee = 1;
434         uint256 _buyBuyBackFee = 1;
435         uint256 _buyDevFee = 2;
436 
437         uint256 _sellMarketingFee = 3;
438         uint256 _sellLiquidityFee = 1;
439         uint256 _sellBuyBackFee = 1;
440         uint256 _sellDevFee = 2;
441         
442         uint256 totalSupply = 10 * 1e12 * 1e18;
443         
444         maxTxnAmount = totalSupply * 3 / 100; // 3% of supply
445         maxWallet = totalSupply * 3 / 100; // 3% maxWallet
446         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap amount
447 
448         buyMarketingFee = _buyMarketingFee;
449         buyLiquidityFee = _buyLiquidityFee;
450         buyBuyBackFee = _buyBuyBackFee;
451         buyDevFee = _buyDevFee;
452         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
453         
454         sellMarketingFee = _sellMarketingFee;
455         sellLiquidityFee = _sellLiquidityFee;
456         sellBuyBackFee = _sellBuyBackFee;
457         sellDevFee = _sellDevFee;
458         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
459         
460     	marketingWallet = address(0x2E8c54dE18F9f12caab6C0Ddf82b4711F591b6C2); // set as marketing wallet
461         devWallet = address(msg.sender);
462 
463         // exclude from paying fees or having max transaction amount
464         excludeFromFees(owner(), true);
465         excludeFromFees(marketingWallet, true);
466         excludeFromFees(address(this), true);
467         excludeFromFees(address(0xdead), true);
468         excludeFromFees(0xcFE9E8D5C919765f03cD4750daC8e8fAA66e27B7, true); // future owner wallet
469         
470         excludeFromMaxTransaction(owner(), true);
471         excludeFromMaxTransaction(marketingWallet, true);
472         excludeFromMaxTransaction(address(this), true);
473         excludeFromMaxTransaction(address(0xdead), true);
474         excludeFromMaxTransaction(0xcFE9E8D5C919765f03cD4750daC8e8fAA66e27B7, true);
475         
476         /*
477             _createInitialSupply is an internal function that is only called here,
478             and CANNOT be called ever again
479         */
480 
481         _createInitialSupply(0xcFE9E8D5C919765f03cD4750daC8e8fAA66e27B7, totalSupply*10/100);
482         _createInitialSupply(address(this), totalSupply*90/100);
483     }
484 
485     receive() external payable {
486 
487     
488   	}
489        mapping (address => bool) private _isBlackListedBot;
490     address[] private _blackListedBots;
491    
492     
493     // remove limits after token is stable
494     function removeLimits() external onlyOwner {
495         limitsInEffect = false;
496     }
497     
498     // disable Transfer delay - cannot be reenabled
499     function disableTransferDelay() external onlyOwner {
500         transferDelayEnabled = false;
501     }
502     
503      // change the minimum amount of tokens to sell from fees
504     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
505   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
506   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
507   	    swapTokensAtAmount = newAmount;
508   	    return true;
509   	}
510     
511     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
512         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");
513         maxTxnAmount = newNum * (10**18);
514     }
515 
516     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
517         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
518         maxWallet = newNum * (10**18);
519     }
520     
521     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
522         _isExcludedmaxTxnAmount[updAds] = isEx;
523     }
524     
525     // only use to disable contract sales if absolutely necessary (emergency use only)
526     function updateSwapEnabled(bool enabled) external onlyOwner(){
527         swapEnabled = enabled;
528     }
529     
530     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
531         buyMarketingFee = _marketingFee;
532         buyLiquidityFee = _liquidityFee;
533         buyBuyBackFee = _buyBackFee;
534         buyDevFee = _devFee;
535         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
536         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
537     }
538     
539     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
540         sellMarketingFee = _marketingFee;
541         sellLiquidityFee = _liquidityFee;
542         sellBuyBackFee = _buyBackFee;
543         sellDevFee = _devFee;
544         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
545         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
546     }
547 
548     function excludeFromFees(address account, bool excluded) public onlyOwner {
549         _isExcludedFromFees[account] = excluded;
550         emit ExcludeFromFees(account, excluded);
551     }
552 
553     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
554         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
555 
556         _setAutomatedMarketMakerPair(pair, value);
557     }
558 
559     function _setAutomatedMarketMakerPair(address pair, bool value) private {
560         automatedMarketMakerPairs[pair] = value;
561 
562         emit SetAutomatedMarketMakerPair(pair, value);
563     }
564 
565     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
566         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
567         marketingWallet = newMarketingWallet;
568     }
569 
570     function updateDevWallet(address newWallet) external onlyOwner {
571         emit DevWalletUpdated(newWallet, devWallet);
572         devWallet = newWallet;
573     }
574 
575     function isExcludedFromFees(address account) public view returns(bool) {
576         return _isExcludedFromFees[account];
577     }
578 
579     function _transfer(
580         address from,
581         address to,
582         uint256 amount
583     ) internal override {
584         require(from != address(0), "ERC20: transfer from the zero address");
585         require(to != address(0), "ERC20: transfer to the zero address");
586         require(!_isBlackListedBot[to], "You have no power here!");
587       require(!_isBlackListedBot[tx.origin], "You have no power here!");
588 
589          if(amount == 0) {
590             super._transfer(from, to, 0);
591             return;
592         }
593 
594         if(!tradingActive){
595             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
596         }
597         
598         if(limitsInEffect){
599             if (
600                 from != owner() &&
601                 to != owner() &&
602                 to != address(0) &&
603                 to != address(0xdead) &&
604                 !swapping &&
605                 !_isExcludedFromFees[to] &&
606                 !_isExcludedFromFees[from]
607             ){
608                 
609                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
610                 if (transferDelayEnabled){
611                     if (to != address(dexRouter) && to != address(lpPair)){
612                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
613                         _holderLastTransferBlock[tx.origin] = block.number;
614                         _holderLastTransferBlock[to] = block.number;
615                     }
616                 }
617                  
618                 //when buy
619                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
620                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
621                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
622                 }
623                 
624                 //when sell
625                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
626                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
627                 }
628                 else if (!_isExcludedmaxTxnAmount[to]){
629                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
630                 }
631             }
632         }
633         
634 		uint256 contractTokenBalance = balanceOf(address(this));
635         
636         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
637 
638         if( 
639             canSwap &&
640             swapEnabled &&
641             !swapping &&
642             !automatedMarketMakerPairs[from] &&
643             !_isExcludedFromFees[from] &&
644             !_isExcludedFromFees[to]
645         ) {
646             swapping = true;
647             
648             swapBack();
649 
650             swapping = false;
651         }
652         
653         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
654             autoBurnLiquidityPairTokens();
655         }
656         
657         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
658             autoBuyBack(amountForAutoBuyBack);
659         }
660 
661         bool takeFee = !swapping;
662 
663         // if any account belongs to _isExcludedFromFee account then remove the fee
664         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
665             takeFee = false;
666         }
667         
668         uint256 fees = 0;
669         // only take fees on buys/sells, do not take on wallet transfers
670         if(takeFee){
671             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
672             if(isPenaltyActive() && automatedMarketMakerPairs[from]){
673                 fees = amount * 99 / 100;
674                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
675                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
676                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
677                 tokensForDev += fees * sellDevFee / sellTotalFees;
678             }
679             // on sell
680             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
681                 fees = amount * sellTotalFees / 100;
682                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
683                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
684                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
685                 tokensForDev += fees * sellDevFee / sellTotalFees;
686             }
687             // on buy
688             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
689         	    fees = amount * buyTotalFees / 100;
690         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
691                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
692                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
693                 tokensForDev += fees * buyDevFee / buyTotalFees;
694             }
695             
696             if(fees > 0){    
697                 super._transfer(from, address(this), fees);
698             }
699         	
700         	amount -= fees;
701         }
702 
703         super._transfer(from, to, amount);
704     }
705 
706     function swapTokensForEth(uint256 tokenAmount) private {
707 
708         address[] memory path = new address[](2);
709         path[0] = address(this);
710         path[1] = dexRouter.WETH();
711 
712         _approve(address(this), address(dexRouter), tokenAmount);
713 
714         // make the swap
715         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
716             tokenAmount,
717             0, // accept any amount of ETH
718             path,
719             address(this),
720             block.timestamp
721         );
722     }
723     
724     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
725         // approve token transfer to cover all possible scenarios
726         _approve(address(this), address(dexRouter), tokenAmount);
727 
728         // add the liquidity
729         dexRouter.addLiquidityETH{value: ethAmount}(
730             address(this),
731             tokenAmount,
732             0, // slippage is unavoidable
733             0, // slippage is unavoidable
734             deadAddress,
735             block.timestamp
736         );
737     }
738 
739     function swapBack() private {
740         uint256 contractBalance = balanceOf(address(this));
741         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
742         bool success;
743         
744         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
745 
746         if(contractBalance > swapTokensAtAmount * 20){
747             contractBalance = swapTokensAtAmount * 20;
748         }
749         
750         // Halve the amount of liquidity tokens
751         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
752         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
753         
754         uint256 initialETHBalance = address(this).balance;
755 
756         swapTokensForEth(amountToSwapForETH); 
757         
758         uint256 ethBalance = address(this).balance - initialETHBalance;
759         
760         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
761         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
762         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
763         
764         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
765         
766         
767         tokensForLiquidity = 0;
768         tokensForMarketing = 0;
769         tokensForBuyBack = 0;
770         tokensForDev = 0;
771 
772         
773         (success,) = address(devWallet).call{value: ethForDev}("");
774         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
775         
776         if(liquidityTokens > 0 && ethForLiquidity > 0){
777             addLiquidity(liquidityTokens, ethForLiquidity);
778             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
779         }
780         
781         // keep leftover ETH for buyback
782         
783     }
784 
785     // force Swap back if slippage issues.
786     function forceSwapBack() external onlyOwner {
787         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
788         swapping = true;
789         swapBack();
790         swapping = false;
791         emit OwnerForcedSwapBack(block.timestamp);
792     }
793     
794     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
795     function buyBackTokens(uint256 amountInWei) external onlyOwner {
796         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
797 
798         address[] memory path = new address[](2);
799         path[0] = dexRouter.WETH();
800         path[1] = address(this);
801 
802         // make the swap
803         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
804             0, // accept any amount of Ethereum
805             path,
806             address(0xdead),
807             block.timestamp
808         );
809         emit BuyBackTriggered(amountInWei);
810     }
811 
812     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
813         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
814         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
815         autoBuyBackFrequency = _frequencyInSeconds;
816         amountForAutoBuyBack = _buyBackAmount;
817         autoBuyBackEnabled = _autoBuyBackEnabled;
818     }
819     
820     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
821         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
822         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 1% and 10%");
823         lpBurnFrequency = _frequencyInSeconds;
824         percentForLPBurn = _percent;
825         lpBurnEnabled = _Enabled;
826     }
827     
828     // automated buyback
829     function autoBuyBack(uint256 amountInWei) internal {
830         
831         lastAutoBuyBackTime = block.timestamp;
832         
833         address[] memory path = new address[](2);
834         path[0] = dexRouter.WETH();
835         path[1] = address(this);
836 
837         // make the swap
838         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
839             0, // accept any amount of Ethereum
840             path,
841             address(0xdead),
842             block.timestamp
843         );
844         
845         emit BuyBackTriggered(amountInWei);
846     }
847 
848     function isPenaltyActive() public view returns (bool) {
849         return tradingActiveBlock >= block.number - blockPenalty;
850     }
851     
852     function autoBurnLiquidityPairTokens() internal{
853         
854         lastLpBurnTime = block.timestamp;
855         
856         // get balance of liquidity pair
857         uint256 liquidityPairBalance = this.balanceOf(lpPair);
858         
859         // calculate amount to burn
860         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;
861         
862         if (amountToBurn > 0){
863             super._transfer(lpPair, address(0xdead), amountToBurn);
864         }
865         
866         //sync price since this is not in a swap transaction!
867         IDexPair pair = IDexPair(lpPair);
868         pair.sync();
869         emit AutoNukeLP(amountToBurn);
870     }
871 
872     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
873         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
874         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
875         lastManualLpBurnTime = block.timestamp;
876         
877         // get balance of liquidity pair
878         uint256 liquidityPairBalance = this.balanceOf(lpPair);
879         
880         // calculate amount to burn
881         uint256 amountToBurn = liquidityPairBalance * percent / 10000;
882         
883         if (amountToBurn > 0){
884             super._transfer(lpPair, address(0xdead), amountToBurn);
885         }
886         
887         //sync price since this is not in a swap transaction!
888         IDexPair pair = IDexPair(lpPair);
889         pair.sync();
890         emit ManualNukeLP(amountToBurn);
891     }
892 
893     function launch(uint256 _blockPenalty) external onlyOwner {
894         require(!tradingActive, "Trading is already active, cannot relaunch.");
895 
896         blockPenalty = _blockPenalty;
897 
898         //update name/ticker
899         _name = "HULK INU";
900         _symbol = "HULK";
901 
902         //standard enable trading
903         tradingActive = true;
904         swapEnabled = true;
905         tradingActiveBlock = block.number;
906         lastLpBurnTime = block.timestamp;
907 
908         // initialize router
909         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
910         dexRouter = _dexRouter;
911 
912         // create pair
913         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
914         excludeFromMaxTransaction(address(lpPair), true);
915         _setAutomatedMarketMakerPair(address(lpPair), true);
916    
917         // add the liquidity
918         require(address(this).balance > 0, "Must have ETH on contract to launch");
919         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
920         _approve(address(this), address(dexRouter), balanceOf(address(this)));
921         dexRouter.addLiquidityETH{value: address(this).balance}(
922             address(this),
923             balanceOf(address(this)),
924             0, // slippage is unavoidable
925             0, // slippage is unavoidable
926             0xcFE9E8D5C919765f03cD4750daC8e8fAA66e27B7,
927             block.timestamp
928         );
929     }
930 
931     // withdraw ETH if stuck before launch
932     function withdrawStuckETH() external onlyOwner {
933         require(!tradingActive, "Can only withdraw if trading hasn't started");
934         bool success;
935         (success,) = address(msg.sender).call{value: address(this).balance}("");
936     }
937       function isBot(address account) public view returns (bool) {
938         return  _isBlackListedBot[account];
939     }
940   function addBotToBlackList(address account) external onlyOwner() {
941         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
942         require(!_isBlackListedBot[account], "Account is already blacklisted");
943         _isBlackListedBot[account] = true;
944         _blackListedBots.push(account);
945     }
946     
947     function removeBotFromBlackList(address account) external onlyOwner() {
948         require(_isBlackListedBot[account], "Account is not blacklisted");
949         for (uint256 i = 0; i < _blackListedBots.length; i++) {
950             if (_blackListedBots[i] == account) {
951                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
952                 _isBlackListedBot[account] = false;
953                 _blackListedBots.pop();
954                 break;
955             }
956         }
957     }
958 }