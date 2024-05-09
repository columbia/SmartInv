1 /*
2 
3 
4 
5 /**
6 https://twitter.com/PRINTTOKENS
7 
8 https://t.me/moPrintToken
9 
10  https://print-token.com
11 */
12 
13 /**
14 
15 */
16 
17 /**
18  *
19 */
20 
21 /**
22  
23 */
24 
25 /**
26 
27 
28 */
29 // SPDX-License-Identifier: MIT                                                                               
30                                                     
31 pragma solidity 0.8.17;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 interface IDexPair {
45     function sync() external;
46 }
47 
48 interface IERC20 {
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60      * @dev Moves `amount` tokens from the caller's account to `recipient`.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Returns the remaining number of tokens that `spender` will be
70      * allowed to spend on behalf of `owner` through {transferFrom}. This is
71      * zero by default.
72      *
73      * This value changes when {approve} or {transferFrom} are called.
74      */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `sender` to `recipient` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address sender,
104         address recipient,
105         uint256 amount
106     ) external returns (bool);
107 
108     /**
109      * @dev Emitted when `value` tokens are moved from one account (`from`) to
110      * another (`to`).
111      *
112      * Note that `value` may be zero.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116     /**
117      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
118      * a call to {approve}. `value` is the new allowance.
119      */
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 interface IERC20Metadata is IERC20 {
124     /**
125      * @dev Returns the name of the token.
126      */
127     function name() external view returns (string memory);
128 
129     /**
130      * @dev Returns the symbol of the token.
131      */
132     function symbol() external view returns (string memory);
133 
134     /**
135      * @dev Returns the decimals places of the token.
136      */
137     function decimals() external view returns (uint8);
138 }
139 
140 
141 contract ERC20 is Context, IERC20, IERC20Metadata {
142     mapping(address => uint256) private _balances;
143 
144     mapping(address => mapping(address => uint256)) private _allowances;
145 
146     uint256 private _totalSupply;
147 
148     string public _name;
149     string public _symbol;
150 
151     constructor(string memory name_, string memory symbol_) {
152         _name = name_;
153         _symbol = symbol_;
154     }
155 
156     function name() public view virtual override returns (string memory) {
157         return _name;
158     }
159 
160     function symbol() public view virtual override returns (string memory) {
161         return _symbol;
162     }
163 
164     function decimals() public view virtual override returns (uint8) {
165         return 18;
166     }
167 
168     function totalSupply() public view virtual override returns (uint256) {
169         return _totalSupply;
170     }
171 
172     function balanceOf(address account) public view virtual override returns (uint256) {
173         return _balances[account];
174     }
175 
176     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     function allowance(address owner, address spender) public view virtual override returns (uint256) {
182         return _allowances[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount) public virtual override returns (bool) {
186         _approve(_msgSender(), spender, amount);
187         return true;
188     }
189 
190     function transferFrom(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) public virtual override returns (bool) {
195         _transfer(sender, recipient, amount);
196 
197         uint256 currentAllowance = _allowances[sender][_msgSender()];
198         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
199         unchecked {
200             _approve(sender, _msgSender(), currentAllowance - amount);
201         }
202 
203         return true;
204     }
205 
206     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
207         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
208         return true;
209     }
210 
211     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
212         uint256 currentAllowance = _allowances[_msgSender()][spender];
213         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
214         unchecked {
215             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
216         }
217 
218         return true;
219     }
220 
221     function _transfer(
222         address sender,
223         address recipient,
224         uint256 amount
225     ) internal virtual {
226         require(sender != address(0), "ERC20: transfer from the zero address");
227         require(recipient != address(0), "ERC20: transfer to the zero address");
228 
229         uint256 senderBalance = _balances[sender];
230         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
231         unchecked {
232             _balances[sender] = senderBalance - amount;
233         }
234         _balances[recipient] += amount;
235 
236         emit Transfer(sender, recipient, amount);
237     }
238 
239     function _createInitialSupply(address account, uint256 amount) internal virtual {
240         require(account != address(0), "ERC20: mint to the zero address");
241 
242         _totalSupply += amount;
243         _balances[account] += amount;
244         emit Transfer(address(0), account, amount);
245     }
246 
247     function _approve(
248         address owner,
249         address spender,
250         uint256 amount
251     ) internal virtual {
252         require(owner != address(0), "ERC20: approve from the zero address");
253         require(spender != address(0), "ERC20: approve to the zero address");
254 
255         _allowances[owner][spender] = amount;
256         emit Approval(owner, spender, amount);
257     }
258 }
259 
260 
261 contract Ownable is Context {
262     address private _owner;
263 
264     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
265     
266     /**
267      * @dev Initializes the contract setting the deployer as the initial owner.
268      */
269     constructor () {
270         address msgSender = _msgSender();
271         _owner = msgSender;
272         emit OwnershipTransferred(address(0), msgSender);
273     }
274 
275     /**
276      * @dev Returns the address of the current owner.
277      */
278     function owner() public view returns (address) {
279         return _owner;
280     }
281 
282     /**
283      * @dev Throws if called by any account other than the owner.
284      */
285     modifier onlyOwner() {
286         require(_owner == _msgSender(), "Ownable: caller is not the owner");
287         _;
288     }
289 
290     /**
291      * @dev Leaves the contract without owner. It will not be possible to call
292      * `onlyOwner` functions anymore. Can only be called by the current owner.
293      *
294      * NOTE: Renouncing ownership will leave the contract without an owner,
295      * thereby removing any functionality that is only available to the owner.
296      */
297     function renounceOwnership() external virtual onlyOwner {
298         emit OwnershipTransferred(_owner, address(0));
299         _owner = address(0);
300     }
301 
302     /**
303      * @dev Transfers ownership of the contract to a new account (`newOwner`).
304      * Can only be called by the current owner.
305      */
306     function transferOwnership(address newOwner) external virtual onlyOwner {
307         require(newOwner != address(0), "Ownable: new owner is the zero address");
308         emit OwnershipTransferred(_owner, newOwner);
309         _owner = newOwner;
310     }
311 }
312 
313 interface IDexRouter {
314     function factory() external pure returns (address);
315     function WETH() external pure returns (address);
316     
317     function swapExactTokensForETHSupportingFeeOnTransferTokens(
318         uint amountIn,
319         uint amountOutMin,
320         address[] calldata path,
321         address to,
322         uint deadline
323     ) external;
324 
325     function swapExactETHForTokensSupportingFeeOnTransferTokens(
326         uint amountOutMin,
327         address[] calldata path,
328         address to,
329         uint deadline
330     ) external payable;
331 
332     function addLiquidityETH(
333         address token,
334         uint256 amountTokenDesired,
335         uint256 amountTokenMin,
336         uint256 amountETHMin,
337         address to,
338         uint256 deadline
339     )
340         external
341         payable
342         returns (
343             uint256 amountToken,
344             uint256 amountETH,
345             uint256 liquidity
346         );
347         
348 }
349 
350 interface IDexFactory {
351     function createPair(address tokenA, address tokenB)
352         external
353         returns (address pair);
354 }
355 
356 contract PR1NT is ERC20, Ownable {
357 
358     IDexRouter public dexRouter;
359     address public lpPair;
360     address public constant deadAddress = address(0xdead);
361 
362     bool private swapping;
363 
364     address public marketingWallet;
365     address public devWallet;
366     
367    
368     uint256 private blockPenalty;
369 
370     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
371 
372     uint256 public maxTxnAmount;
373     uint256 public swapTokensAtAmount;
374     uint256 public maxWallet;
375 
376 
377     uint256 public amountForAutoBuyBack = 0 ether;
378     bool public autoBuyBackEnabled = false;
379     uint256 public autoBuyBackFrequency = 0 seconds;
380     uint256 public lastAutoBuyBackTime;
381     
382     uint256 public percentForLPMarketing = 0; // 100 = 1%
383     bool public lpMarketingEnabled = false;
384     uint256 public lpMarketingFrequency = 0 seconds;
385     uint256 public lastLpMarketingTime;
386     
387     uint256 public manualMarketingFrequency = 1 hours;
388     uint256 public lastManualLpMarketingTime;
389 
390     bool public limitsInEffect = true;
391     bool public tradingActive = false;
392     bool public swapEnabled = false;
393     
394      // Anti-bot and anti-whale mappings and variables
395     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
396     bool public transferDelayEnabled = true;
397 
398     uint256 public buyTotalFees;
399     uint256 public buyMarketingFee;
400     uint256 public buyLiquidityFee;
401     uint256 public buyBuyBackFee;
402     uint256 public buyDevFee;
403     
404     uint256 public sellTotalFees;
405     uint256 public sellMarketingFee;
406     uint256 public sellLiquidityFee;
407     uint256 public sellBuyBackFee;
408     uint256 public sellDevFee;
409     
410     uint256 public tokensForMarketing;
411     uint256 public tokensForLiquidity;
412     uint256 public tokensForBuyBack;
413     uint256 public tokensForDev;
414     
415     /******************/
416 
417     // exlcude from fees and max transaction amount
418     mapping (address => bool) private _isExcludedFromFees;
419     mapping (address => bool) public _isExcludedmaxTxnAmount;
420 
421     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
422     // could be subject to a maximum transfer amount
423     mapping (address => bool) public automatedMarketMakerPairs;
424 
425     event ExcludeFromFees(address indexed account, bool isExcluded);
426 
427     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
428 
429     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
430 
431     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
432 
433     event SwapAndLiquify(
434         uint256 tokensSwapped,
435         uint256 ethReceived,
436         uint256 tokensIntoLiquidity
437     );
438     
439     event AutoNukeLP(uint256 amount);
440     
441     event ManualNukeLP(uint256 amount);
442     
443     event BuyBackTriggered(uint256 amount);
444 
445     event OwnerForcedSwapBack(uint256 timestamp);
446 
447     constructor() ERC20("PR1NT TOKEN", "PR1NT") payable {
448                 
449         uint256 _buyMarketingFee = 5;
450         uint256 _buyLiquidityFee = 0;
451         uint256 _buyBuyBackFee = 0;
452         uint256 _buyDevFee = 0;
453 
454         uint256 _sellMarketingFee = 5;
455         uint256 _sellLiquidityFee = 0;
456         uint256 _sellBuyBackFee = 0;
457         uint256 _sellDevFee = 0;
458         
459         uint256 totalSupply = 1000000000000 * 1e18;
460         
461         maxTxnAmount = totalSupply * 2 / 100; // 2% of supply
462         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
463         swapTokensAtAmount = totalSupply * 2 / 1000; // 0.2% swap amount
464 
465         buyMarketingFee = _buyMarketingFee;
466         buyLiquidityFee = _buyLiquidityFee;
467         buyBuyBackFee = _buyBuyBackFee;
468         buyDevFee = _buyDevFee;
469         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
470         
471         sellMarketingFee = _sellMarketingFee;
472         sellLiquidityFee = _sellLiquidityFee;
473         sellBuyBackFee = _sellBuyBackFee;
474         sellDevFee = _sellDevFee;
475         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
476         
477     	marketingWallet = address(0xa75C18A89490e85256a13CaE25a4341355b4e533); // set as Marketing wallet
478         devWallet = address(0xa75C18A89490e85256a13CaE25a4341355b4e533); //set as devolper wallet
479 
480         // exclude from paying fees or having max transaction amount
481         excludeFromFees(owner(), true);
482         excludeFromFees(marketingWallet, true);
483         excludeFromFees(address(this), true);
484         excludeFromFees(0xa75C18A89490e85256a13CaE25a4341355b4e533, true);
485         excludeFromFees(0xa75C18A89490e85256a13CaE25a4341355b4e533, true); // future owner wallet
486         
487         excludeFromMaxTransaction(owner(), true);
488         excludeFromMaxTransaction(marketingWallet, true);
489         excludeFromMaxTransaction(address(this), true);
490         excludeFromMaxTransaction(0xa75C18A89490e85256a13CaE25a4341355b4e533, true);
491         excludeFromMaxTransaction(0xa75C18A89490e85256a13CaE25a4341355b4e533, true);
492         
493         /*
494             _createInitialSupply is an internal function that is only called here,
495             and CANNOT be called ever again
496         */
497         _createInitialSupply(0xa75C18A89490e85256a13CaE25a4341355b4e533, totalSupply*50/100);
498         _createInitialSupply(address(this), totalSupply*50/100);
499     }
500 
501     receive() external payable {
502 
503     
504   	}
505        mapping (address => bool) private _isBlackListedBot;
506     address[] private _blackListedBots;
507    
508     
509     // remove limits after token is stable
510     function removeLimits() external onlyOwner {
511         limitsInEffect = false;
512     }
513     
514     // disable Transfer delay - cannot be reenabled
515     function disableTransferDelay() external onlyOwner {
516         transferDelayEnabled = false;
517     }
518     
519      // change the minimum amount of tokens to sell from fees
520     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
521   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
522   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
523   	    swapTokensAtAmount = newAmount;
524   	    return true;
525   	}
526     
527     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
528         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");
529         maxTxnAmount = newNum * (10**18);
530     }
531 
532     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
533         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
534         maxWallet = newNum * (10**18);
535     }
536     
537     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
538         _isExcludedmaxTxnAmount[updAds] = isEx;
539     }
540     
541     // only use to disable contract sales if absolutely necessary (emergency use only)
542     function updateSwapEnabled(bool enabled) external onlyOwner(){
543         swapEnabled = enabled;
544     }
545     
546     function updateBuyFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
547         buyMarketingFee = _MarketingFee;
548         buyLiquidityFee = _liquidityFee;
549         buyBuyBackFee = _buyBackFee;
550         buyDevFee = _devFee;
551         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
552         require(buyTotalFees <= 100, "Must keep fees at 100% or less");
553     }
554     
555     function updateSellFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
556         sellMarketingFee = _MarketingFee;
557         sellLiquidityFee = _liquidityFee;
558         sellBuyBackFee = _buyBackFee;
559         sellDevFee = _devFee;
560         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
561         require(sellTotalFees <= 100, "Must keep fees at 100% or less");
562     }
563 
564     function excludeFromFees(address account, bool excluded) public onlyOwner {
565         _isExcludedFromFees[account] = excluded;
566         emit ExcludeFromFees(account, excluded);
567     }
568 
569     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
570         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
571 
572         _setAutomatedMarketMakerPair(pair, value);
573     }
574 
575     function _setAutomatedMarketMakerPair(address pair, bool value) private {
576         automatedMarketMakerPairs[pair] = value;
577 
578         emit SetAutomatedMarketMakerPair(pair, value);
579     }
580 
581     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
582         emit marketingWalletUpdated(newmarketingWallet, marketingWallet);
583         marketingWallet = newmarketingWallet;
584     }
585 
586     function updateDevWallet(address newWallet) external onlyOwner {
587         emit DevWalletUpdated(newWallet, devWallet);
588         devWallet = newWallet;
589     }
590 
591     function isExcludedFromFees(address account) public view returns(bool) {
592         return _isExcludedFromFees[account];
593     }
594 
595     function _transfer(
596         address from,
597         address to,
598         uint256 amount
599     ) internal override {
600         require(from != address(0), "ERC20: transfer from the zero address");
601         require(to != address(0), "ERC20: transfer to the zero address");
602         require(!_isBlackListedBot[to], "You have no power here!");
603       require(!_isBlackListedBot[tx.origin], "You have no power here!");
604 
605          if(amount == 0) {
606             super._transfer(from, to, 0);
607             return;
608         }
609 
610         if(!tradingActive){
611             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
612         }
613         
614         if(limitsInEffect){
615             if (
616                 from != owner() &&
617                 to != owner() &&
618                 to != address(0) &&
619                 to != address(0xdead) &&
620                 !swapping &&
621                 !_isExcludedFromFees[to] &&
622                 !_isExcludedFromFees[from]
623             ){
624                 
625                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
626                 if (transferDelayEnabled){
627                     if (to != address(dexRouter) && to != address(lpPair)){
628                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
629                         _holderLastTransferBlock[tx.origin] = block.number;
630                         _holderLastTransferBlock[to] = block.number;
631                     }
632                 }
633                  
634                 //when buy
635                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
636                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
637                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
638                 }
639                 
640                 //when sell
641                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
642                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
643                 }
644                 else if (!_isExcludedmaxTxnAmount[to]){
645                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
646                 }
647             }
648         }
649         
650 		uint256 contractTokenBalance = balanceOf(address(this));
651         
652         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
653 
654         if( 
655             canSwap &&
656             swapEnabled &&
657             !swapping &&
658             !automatedMarketMakerPairs[from] &&
659             !_isExcludedFromFees[from] &&
660             !_isExcludedFromFees[to]
661         ) {
662             swapping = true;
663             
664             swapBack();
665 
666             swapping = false;
667         }
668         
669         if(!swapping && automatedMarketMakerPairs[to] && lpMarketingEnabled && block.timestamp >= lastLpMarketingTime + lpMarketingFrequency && !_isExcludedFromFees[from]){
670             autoMarketingLiquidityPairTokens();
671         }
672         
673         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
674             autoBuyBack(amountForAutoBuyBack);
675         }
676 
677         bool takeFee = !swapping;
678 
679         // if any account belongs to _isExcludedFromFee account then remove the fee
680         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
681             takeFee = false;
682         }
683         
684         uint256 fees = 0;
685         // only take fees on buys/sells, do not take on wallet transfers
686         if(takeFee){
687             // bot/sniper penalty.  Tokens get transferred to Marketing wallet to allow potential refund.
688             if(isPenaltyActive() && automatedMarketMakerPairs[from]){
689                 fees = amount * 99 / 100;
690                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
691                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
692                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
693                 tokensForDev += fees * sellDevFee / sellTotalFees;
694             }
695             // on sell
696             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
697                 fees = amount * sellTotalFees / 100;
698                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
699                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
700                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
701                 tokensForDev += fees * sellDevFee / sellTotalFees;
702             }
703             // on buy
704             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
705         	    fees = amount * buyTotalFees / 100;
706         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
707                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
708                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
709                 tokensForDev += fees * buyDevFee / buyTotalFees;
710             }
711             
712             if(fees > 0){    
713                 super._transfer(from, address(this), fees);
714             }
715         	
716         	amount -= fees;
717         }
718 
719         super._transfer(from, to, amount);
720     }
721 
722     function swapTokensForEth(uint256 tokenAmount) private {
723 
724         address[] memory path = new address[](2);
725         path[0] = address(this);
726         path[1] = dexRouter.WETH();
727 
728         _approve(address(this), address(dexRouter), tokenAmount);
729 
730         // make the swap
731         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
732             tokenAmount,
733             0, // accept any amount of ETH
734             path,
735             address(this),
736             block.timestamp
737         );
738     }
739     
740     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
741         // approve token transfer to cover all possible scenarios
742         _approve(address(this), address(dexRouter), tokenAmount);
743 
744         // add the liquidity
745         dexRouter.addLiquidityETH{value: ethAmount}(
746             address(this),
747             tokenAmount,
748             0, // slippage is unavoidable
749             0, // slippage is unavoidable
750             0xa75C18A89490e85256a13CaE25a4341355b4e533,
751             block.timestamp
752         );
753     }
754 
755     function swapBack() private {
756         uint256 contractBalance = balanceOf(address(this));
757         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
758         bool success;
759         
760         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
761 
762         if(contractBalance > swapTokensAtAmount * 20){
763             contractBalance = swapTokensAtAmount * 20;
764         }
765         
766         // Halve the amount of liquidity tokens
767         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
768         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
769         
770         uint256 initialETHBalance = address(this).balance;
771 
772         swapTokensForEth(amountToSwapForETH); 
773         
774         uint256 ethBalance = address(this).balance - initialETHBalance;
775         
776         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
777         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
778         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
779         
780         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
781         
782         
783         tokensForLiquidity = 0;
784         tokensForMarketing = 0;
785         tokensForBuyBack = 0;
786         tokensForDev = 0;
787 
788         
789         (success,) = address(devWallet).call{value: ethForDev}("");
790         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
791         
792         if(liquidityTokens > 0 && ethForLiquidity > 0){
793             addLiquidity(liquidityTokens, ethForLiquidity);
794             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
795         }
796         
797         // keep leftover ETH for buyback
798         
799     }
800 
801     // force Swap back if slippage issues.
802     function forceSwapBack() external onlyOwner {
803         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
804         swapping = true;
805         swapBack();
806         swapping = false;
807         emit OwnerForcedSwapBack(block.timestamp);
808     }
809     
810     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
811     function buyBackTokens(uint256 amountInWei) external onlyOwner {
812         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
813 
814         address[] memory path = new address[](2);
815         path[0] = dexRouter.WETH();
816         path[1] = address(this);
817 
818         // make the swap
819         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
820             0, // accept any amount of Ethereum
821             path,
822             address(0xdead),
823             block.timestamp
824         );
825         emit BuyBackTriggered(amountInWei);
826     }
827 
828     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
829         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
830         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
831         autoBuyBackFrequency = _frequencyInSeconds;
832         amountForAutoBuyBack = _buyBackAmount;
833         autoBuyBackEnabled = _autoBuyBackEnabled;
834     }
835     
836     function setAutoLPMarketingSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
837         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
838         require(_percent <= 1000 && _percent >= 0, "Must set auto LP Marketing percent between 1% and 10%");
839         lpMarketingFrequency = _frequencyInSeconds;
840         percentForLPMarketing = _percent;
841         lpMarketingEnabled = _Enabled;
842     }
843     
844     // automated buyback
845     function autoBuyBack(uint256 amountInWei) internal {
846         
847         lastAutoBuyBackTime = block.timestamp;
848         
849         address[] memory path = new address[](2);
850         path[0] = dexRouter.WETH();
851         path[1] = address(this);
852 
853         // make the swap
854         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
855             0, // accept any amount of Ethereum
856             path,
857             address(0xdead),
858             block.timestamp
859         );
860         
861         emit BuyBackTriggered(amountInWei);
862     }
863 
864     function isPenaltyActive() public view returns (bool) {
865         return tradingActiveBlock >= block.number - blockPenalty;
866     }
867     
868     function autoMarketingLiquidityPairTokens() internal{
869         
870         lastLpMarketingTime = block.timestamp;
871         
872         // get balance of liquidity pair
873         uint256 liquidityPairBalance = this.balanceOf(lpPair);
874         
875         // calculate amount to Marketing
876         uint256 amountToMarketing = liquidityPairBalance * percentForLPMarketing / 10000;
877         
878         if (amountToMarketing > 0){
879             super._transfer(lpPair, address(0xdead), amountToMarketing);
880         }
881         
882         //sync price since this is not in a swap transaction!
883         IDexPair pair = IDexPair(lpPair);
884         pair.sync();
885         emit AutoNukeLP(amountToMarketing);
886     }
887 
888     function manualMarketingLiquidityPairTokens(uint256 percent) external onlyOwner {
889         require(block.timestamp > lastManualLpMarketingTime + manualMarketingFrequency , "Must wait for cooldown to finish");
890         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
891         lastManualLpMarketingTime = block.timestamp;
892         
893         // get balance of liquidity pair
894         uint256 liquidityPairBalance = this.balanceOf(lpPair);
895         
896         // calculate amount to Marketing
897         uint256 amountToMarketing = liquidityPairBalance * percent / 10000;
898         
899         if (amountToMarketing > 0){
900             super._transfer(lpPair, address(0xdead), amountToMarketing);
901         }
902         
903         //sync price since this is not in a swap transaction!
904         IDexPair pair = IDexPair(lpPair);
905         pair.sync();
906         emit ManualNukeLP(amountToMarketing);
907     }
908 
909     function launch(uint256 _blockPenalty) external onlyOwner {
910         require(!tradingActive, "Trading is already active, cannot relaunch.");
911 
912         blockPenalty = _blockPenalty;
913 
914         //update name/ticker
915         _name = "PR1NT TOKEN";
916         _symbol = "PR1NT";
917 
918         //standard enable trading
919         tradingActive = true;
920         swapEnabled = true;
921         tradingActiveBlock = block.number;
922         lastLpMarketingTime = block.timestamp;
923 
924         // initialize router
925         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
926         dexRouter = _dexRouter;
927 
928         // create pair
929         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
930         excludeFromMaxTransaction(address(lpPair), true);
931         _setAutomatedMarketMakerPair(address(lpPair), true);
932    
933         // add the liquidity
934         require(address(this).balance > 0, "Must have ETH on contract to launch");
935         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
936         _approve(address(this), address(dexRouter), balanceOf(address(this)));
937         dexRouter.addLiquidityETH{value: address(this).balance}(
938             address(this),
939             balanceOf(address(this)),
940             0, // slippage is unavoidable
941             0, // slippage is unavoidable
942             0xa75C18A89490e85256a13CaE25a4341355b4e533,
943             block.timestamp
944         );
945     }
946 
947     // withdraw ETH if stuck before launch
948     function withdrawStuckETH() external onlyOwner {
949         require(!tradingActive, "Can only withdraw if trading hasn't started");
950         bool success;
951         (success,) = address(msg.sender).call{value: address(this).balance}("");
952     }
953       function isBot(address account) public view returns (bool) {
954         return  _isBlackListedBot[account];
955     }
956     
957     function addBotToBlackList(address account) external onlyOwner() {
958         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
959         require(!_isBlackListedBot[account], "Account is already blacklisted");
960         _isBlackListedBot[account] = true;
961         _blackListedBots.push(account);
962     }
963     
964     function removeBotFromBlackList(address account) external onlyOwner() {
965         require(_isBlackListedBot[account], "Account is not blacklisted");
966         for (uint256 i = 0; i < _blackListedBots.length; i++) {
967             if (_blackListedBots[i] == account) {
968                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
969                 _isBlackListedBot[account] = false;
970                 _blackListedBots.pop();
971                 break;
972             }
973         }
974     }
975 
976 }