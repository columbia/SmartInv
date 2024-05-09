1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 //YODATAMA
4 
5 //http://t.me/yodatama
6 
7 //https://yodatama.io/
8 
9 
10 pragma solidity 0.8.11;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IDexPair {
24     function sync() external;
25 }
26 
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 
120 contract ERC20 is Context, IERC20, IERC20Metadata {
121     mapping(address => uint256) private _balances;
122 
123     mapping(address => mapping(address => uint256)) private _allowances;
124 
125     uint256 private _totalSupply;
126 
127     string public _name;
128     string public _symbol;
129 
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138 
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150 
151     function balanceOf(address account) public view virtual override returns (uint256) {
152         return _balances[account];
153     }
154 
155     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
156         _transfer(_msgSender(), recipient, amount);
157         return true;
158     }
159 
160     function allowance(address owner, address spender) public view virtual override returns (uint256) {
161         return _allowances[owner][spender];
162     }
163 
164     function approve(address spender, uint256 amount) public virtual override returns (bool) {
165         _approve(_msgSender(), spender, amount);
166         return true;
167     }
168 
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) public virtual override returns (bool) {
174         _transfer(sender, recipient, amount);
175 
176         uint256 currentAllowance = _allowances[sender][_msgSender()];
177         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
178         unchecked {
179             _approve(sender, _msgSender(), currentAllowance - amount);
180         }
181 
182         return true;
183     }
184 
185     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
187         return true;
188     }
189 
190     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
191         uint256 currentAllowance = _allowances[_msgSender()][spender];
192         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
193         unchecked {
194             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
195         }
196 
197         return true;
198     }
199 
200     function _transfer(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) internal virtual {
205         require(sender != address(0), "ERC20: transfer from the zero address");
206         require(recipient != address(0), "ERC20: transfer to the zero address");
207 
208         uint256 senderBalance = _balances[sender];
209         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
210         unchecked {
211             _balances[sender] = senderBalance - amount;
212         }
213         _balances[recipient] += amount;
214 
215         emit Transfer(sender, recipient, amount);
216     }
217 
218     function _createInitialSupply(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: mint to the zero address");
220 
221         _totalSupply += amount;
222         _balances[account] += amount;
223         emit Transfer(address(0), account, amount);
224     }
225 
226     function _approve(
227         address owner,
228         address spender,
229         uint256 amount
230     ) internal virtual {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233 
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 }
238 
239 
240 contract Ownable is Context {
241     address private _owner;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244     
245     /**
246      * @dev Initializes the contract setting the deployer as the initial owner.
247      */
248     constructor () {
249         address msgSender = _msgSender();
250         _owner = msgSender;
251         emit OwnershipTransferred(address(0), msgSender);
252     }
253 
254     /**
255      * @dev Returns the address of the current owner.
256      */
257     function owner() public view returns (address) {
258         return _owner;
259     }
260 
261     /**
262      * @dev Throws if called by any account other than the owner.
263      */
264     modifier onlyOwner() {
265         require(_owner == _msgSender(), "Ownable: caller is not the owner");
266         _;
267     }
268 
269     /**
270      * @dev Leaves the contract without owner. It will not be possible to call
271      * `onlyOwner` functions anymore. Can only be called by the current owner.
272      *
273      * NOTE: Renouncing ownership will leave the contract without an owner,
274      * thereby removing any functionality that is only available to the owner.
275      */
276     function renounceOwnership() external virtual onlyOwner {
277         emit OwnershipTransferred(_owner, address(0));
278         _owner = address(0);
279     }
280 
281     /**
282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
283      * Can only be called by the current owner.
284      */
285     function transferOwnership(address newOwner) external virtual onlyOwner {
286         require(newOwner != address(0), "Ownable: new owner is the zero address");
287         emit OwnershipTransferred(_owner, newOwner);
288         _owner = newOwner;
289     }
290 }
291 
292 interface IDexRouter {
293     function factory() external pure returns (address);
294     function WETH() external pure returns (address);
295     
296     function swapExactTokensForETHSupportingFeeOnTransferTokens(
297         uint amountIn,
298         uint amountOutMin,
299         address[] calldata path,
300         address to,
301         uint deadline
302     ) external;
303 
304     function swapExactETHForTokensSupportingFeeOnTransferTokens(
305         uint amountOutMin,
306         address[] calldata path,
307         address to,
308         uint deadline
309     ) external payable;
310 
311     function addLiquidityETH(
312         address token,
313         uint256 amountTokenDesired,
314         uint256 amountTokenMin,
315         uint256 amountETHMin,
316         address to,
317         uint256 deadline
318     )
319         external
320         payable
321         returns (
322             uint256 amountToken,
323             uint256 amountETH,
324             uint256 liquidity
325         );
326         
327 }
328 
329 interface IDexFactory {
330     function createPair(address tokenA, address tokenB)
331         external
332         returns (address pair);
333 }
334 
335 contract YODATAMA is ERC20, Ownable {
336 
337     IDexRouter public dexRouter;
338     address public lpPair;
339     address public constant deadAddress = address(0xdead);
340 
341     bool private swapping;
342 
343     address public marketingWallet;
344     address public devWallet;
345     
346    
347     uint256 private blockPenalty;
348 
349     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
350 
351     uint256 public maxTxnAmount;
352     uint256 public swapTokensAtAmount;
353     uint256 public maxWallet;
354 
355 
356     uint256 public amountForAutoBuyBack = 0.2 ether;
357     bool public autoBuyBackEnabled = false;
358     uint256 public autoBuyBackFrequency = 3600 seconds;
359     uint256 public lastAutoBuyBackTime;
360     
361     uint256 public percentForLPBurn = 100; // 100 = 1%
362     bool public lpBurnEnabled = false;
363     uint256 public lpBurnFrequency = 3600 seconds;
364     uint256 public lastLpBurnTime;
365     
366     uint256 public manualBurnFrequency = 1 hours;
367     uint256 public lastManualLpBurnTime;
368 
369     bool public limitsInEffect = true;
370     bool public tradingActive = false;
371     bool public swapEnabled = false;
372     
373      // Anti-bot and anti-whale mappings and variables
374     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
375     bool public transferDelayEnabled = true;
376 
377     uint256 public buyTotalFees;
378     uint256 public buyMarketingFee;
379     uint256 public buyLiquidityFee;
380     uint256 public buyBuyBackFee;
381     uint256 public buyDevFee;
382     
383     uint256 public sellTotalFees;
384     uint256 public sellMarketingFee;
385     uint256 public sellLiquidityFee;
386     uint256 public sellBuyBackFee;
387     uint256 public sellDevFee;
388     
389     uint256 public tokensForMarketing;
390     uint256 public tokensForLiquidity;
391     uint256 public tokensForBuyBack;
392     uint256 public tokensForDev;
393     
394     /******************/
395 
396     // exlcude from fees and max transaction amount
397     mapping (address => bool) private _isExcludedFromFees;
398     mapping (address => bool) public _isExcludedmaxTxnAmount;
399 
400     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
401     // could be subject to a maximum transfer amount
402     mapping (address => bool) public automatedMarketMakerPairs;
403 
404     event ExcludeFromFees(address indexed account, bool isExcluded);
405 
406     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
407 
408     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
409 
410     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
411 
412     event SwapAndLiquify(
413         uint256 tokensSwapped,
414         uint256 ethReceived,
415         uint256 tokensIntoLiquidity
416     );
417     
418     event AutoNukeLP(uint256 amount);
419     
420     event ManualNukeLP(uint256 amount);
421     
422     event BuyBackTriggered(uint256 amount);
423 
424     event OwnerForcedSwapBack(uint256 timestamp);
425 
426     constructor() ERC20("", "") payable {
427                 
428         uint256 _buyMarketingFee = 5;
429         uint256 _buyLiquidityFee = 5;
430         uint256 _buyBuyBackFee = 0;
431         uint256 _buyDevFee = 0;
432 
433         uint256 _sellMarketingFee = 15;
434         uint256 _sellLiquidityFee = 5;
435         uint256 _sellBuyBackFee = 0;
436         uint256 _sellDevFee = 0;
437         
438         uint256 totalSupply = 10 * 1e12 * 1e18;
439         
440         maxTxnAmount = totalSupply * 5 / 1000;
441         maxWallet = totalSupply * 1 / 100; // 1% maxWallet
442         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap amount
443 
444         buyMarketingFee = _buyMarketingFee;
445         buyLiquidityFee = _buyLiquidityFee;
446         buyBuyBackFee = _buyBuyBackFee;
447         buyDevFee = _buyDevFee;
448         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
449         
450         sellMarketingFee = _sellMarketingFee;
451         sellLiquidityFee = _sellLiquidityFee;
452         sellBuyBackFee = _sellBuyBackFee;
453         sellDevFee = _sellDevFee;
454         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
455         
456     	marketingWallet = address(0xe8Cb016ed33011E3139a33F7AF3507b560963574); // set as marketing wallet
457         devWallet = address(msg.sender);
458 
459         // exclude from paying fees or having max transaction amount
460         excludeFromFees(owner(), true);
461         excludeFromFees(marketingWallet, true);
462         excludeFromFees(address(this), true);
463         excludeFromFees(address(0xdead), true);
464         excludeFromFees(0x2dBF5a4e5772F7d4c5Bc7Fb3219718E7f2E7fFDc, true); // future owner wallet
465         
466         excludeFromMaxTransaction(owner(), true);
467         excludeFromMaxTransaction(marketingWallet, true);
468         excludeFromMaxTransaction(address(this), true);
469         excludeFromMaxTransaction(address(0xdead), true);
470         excludeFromMaxTransaction(0x2dBF5a4e5772F7d4c5Bc7Fb3219718E7f2E7fFDc, true);
471         
472         /*
473             _createInitialSupply is an internal function that is only called here,
474             and CANNOT be called ever again
475         */
476 
477         _createInitialSupply(0x2dBF5a4e5772F7d4c5Bc7Fb3219718E7f2E7fFDc, totalSupply*17/100);
478         _createInitialSupply(address(this), totalSupply*83/100);
479     }
480 
481     receive() external payable {
482 
483   	}
484     
485     // remove limits after token is stable
486     function removeLimits() external onlyOwner {
487         limitsInEffect = false;
488     }
489     
490     // disable Transfer delay - cannot be reenabled
491     function disableTransferDelay() external onlyOwner {
492         transferDelayEnabled = false;
493     }
494     
495      // change the minimum amount of tokens to sell from fees
496     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
497   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
498   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
499   	    swapTokensAtAmount = newAmount;
500   	    return true;
501   	}
502     
503     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
504         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");
505         maxTxnAmount = newNum * (10**18);
506     }
507 
508     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
509         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
510         maxWallet = newNum * (10**18);
511     }
512     
513     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
514         _isExcludedmaxTxnAmount[updAds] = isEx;
515     }
516     
517     // only use to disable contract sales if absolutely necessary (emergency use only)
518     function updateSwapEnabled(bool enabled) external onlyOwner(){
519         swapEnabled = enabled;
520     }
521     
522     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
523         buyMarketingFee = _marketingFee;
524         buyLiquidityFee = _liquidityFee;
525         buyBuyBackFee = _buyBackFee;
526         buyDevFee = _devFee;
527         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
528         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
529     }
530     
531     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
532         sellMarketingFee = _marketingFee;
533         sellLiquidityFee = _liquidityFee;
534         sellBuyBackFee = _buyBackFee;
535         sellDevFee = _devFee;
536         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
537         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
538     }
539 
540     function excludeFromFees(address account, bool excluded) public onlyOwner {
541         _isExcludedFromFees[account] = excluded;
542         emit ExcludeFromFees(account, excluded);
543     }
544 
545     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
546         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
547 
548         _setAutomatedMarketMakerPair(pair, value);
549     }
550 
551     function _setAutomatedMarketMakerPair(address pair, bool value) private {
552         automatedMarketMakerPairs[pair] = value;
553 
554         emit SetAutomatedMarketMakerPair(pair, value);
555     }
556 
557     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
558         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
559         marketingWallet = newMarketingWallet;
560     }
561 
562     function updateDevWallet(address newWallet) external onlyOwner {
563         emit DevWalletUpdated(newWallet, devWallet);
564         devWallet = newWallet;
565     }
566 
567     function isExcludedFromFees(address account) public view returns(bool) {
568         return _isExcludedFromFees[account];
569     }
570 
571     function _transfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal override {
576         require(from != address(0), "ERC20: transfer from the zero address");
577         require(to != address(0), "ERC20: transfer to the zero address");
578         
579          if(amount == 0) {
580             super._transfer(from, to, 0);
581             return;
582         }
583 
584         if(!tradingActive){
585             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
586         }
587         
588         if(limitsInEffect){
589             if (
590                 from != owner() &&
591                 to != owner() &&
592                 to != address(0) &&
593                 to != address(0xdead) &&
594                 !swapping &&
595                 !_isExcludedFromFees[to] &&
596                 !_isExcludedFromFees[from]
597             ){
598                 
599                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
600                 if (transferDelayEnabled){
601                     if (to != address(dexRouter) && to != address(lpPair)){
602                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
603                         _holderLastTransferBlock[tx.origin] = block.number;
604                         _holderLastTransferBlock[to] = block.number;
605                     }
606                 }
607                  
608                 //when buy
609                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
610                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
611                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
612                 }
613                 
614                 //when sell
615                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
616                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
617                 }
618                 else if (!_isExcludedmaxTxnAmount[to]){
619                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
620                 }
621             }
622         }
623         
624 		uint256 contractTokenBalance = balanceOf(address(this));
625         
626         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
627 
628         if( 
629             canSwap &&
630             swapEnabled &&
631             !swapping &&
632             !automatedMarketMakerPairs[from] &&
633             !_isExcludedFromFees[from] &&
634             !_isExcludedFromFees[to]
635         ) {
636             swapping = true;
637             
638             swapBack();
639 
640             swapping = false;
641         }
642         
643         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
644             autoBurnLiquidityPairTokens();
645         }
646         
647         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
648             autoBuyBack(amountForAutoBuyBack);
649         }
650 
651         bool takeFee = !swapping;
652 
653         // if any account belongs to _isExcludedFromFee account then remove the fee
654         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
655             takeFee = false;
656         }
657         
658         uint256 fees = 0;
659         // only take fees on buys/sells, do not take on wallet transfers
660         if(takeFee){
661             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
662             if(isPenaltyActive() && automatedMarketMakerPairs[from]){
663                 fees = amount * 99 / 100;
664                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
665                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
666                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
667                 tokensForDev += fees * sellDevFee / sellTotalFees;
668             }
669             // on sell
670             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
671                 fees = amount * sellTotalFees / 100;
672                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
673                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
674                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
675                 tokensForDev += fees * sellDevFee / sellTotalFees;
676             }
677             // on buy
678             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
679         	    fees = amount * buyTotalFees / 100;
680         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
681                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
682                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
683                 tokensForDev += fees * buyDevFee / buyTotalFees;
684             }
685             
686             if(fees > 0){    
687                 super._transfer(from, address(this), fees);
688             }
689         	
690         	amount -= fees;
691         }
692 
693         super._transfer(from, to, amount);
694     }
695 
696     function swapTokensForEth(uint256 tokenAmount) private {
697 
698         address[] memory path = new address[](2);
699         path[0] = address(this);
700         path[1] = dexRouter.WETH();
701 
702         _approve(address(this), address(dexRouter), tokenAmount);
703 
704         // make the swap
705         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
706             tokenAmount,
707             0, // accept any amount of ETH
708             path,
709             address(this),
710             block.timestamp
711         );
712     }
713     
714     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
715         // approve token transfer to cover all possible scenarios
716         _approve(address(this), address(dexRouter), tokenAmount);
717 
718         // add the liquidity
719         dexRouter.addLiquidityETH{value: ethAmount}(
720             address(this),
721             tokenAmount,
722             0, // slippage is unavoidable
723             0, // slippage is unavoidable
724             deadAddress,
725             block.timestamp
726         );
727     }
728 
729     function swapBack() private {
730         uint256 contractBalance = balanceOf(address(this));
731         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
732         bool success;
733         
734         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
735 
736         if(contractBalance > swapTokensAtAmount * 20){
737             contractBalance = swapTokensAtAmount * 20;
738         }
739         
740         // Halve the amount of liquidity tokens
741         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
742         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
743         
744         uint256 initialETHBalance = address(this).balance;
745 
746         swapTokensForEth(amountToSwapForETH); 
747         
748         uint256 ethBalance = address(this).balance - initialETHBalance;
749         
750         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
751         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
752         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
753         
754         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
755         
756         
757         tokensForLiquidity = 0;
758         tokensForMarketing = 0;
759         tokensForBuyBack = 0;
760         tokensForDev = 0;
761 
762         
763         (success,) = address(devWallet).call{value: ethForDev}("");
764         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
765         
766         if(liquidityTokens > 0 && ethForLiquidity > 0){
767             addLiquidity(liquidityTokens, ethForLiquidity);
768             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
769         }
770         
771         // keep leftover ETH for buyback
772         
773     }
774 
775     // force Swap back if slippage issues.
776     function forceSwapBack() external onlyOwner {
777         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
778         swapping = true;
779         swapBack();
780         swapping = false;
781         emit OwnerForcedSwapBack(block.timestamp);
782     }
783     
784     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
785     function buyBackTokens(uint256 amountInWei) external onlyOwner {
786         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
787 
788         address[] memory path = new address[](2);
789         path[0] = dexRouter.WETH();
790         path[1] = address(this);
791 
792         // make the swap
793         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
794             0, // accept any amount of Ethereum
795             path,
796             address(0xdead),
797             block.timestamp
798         );
799         emit BuyBackTriggered(amountInWei);
800     }
801 
802     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
803         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
804         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
805         autoBuyBackFrequency = _frequencyInSeconds;
806         amountForAutoBuyBack = _buyBackAmount;
807         autoBuyBackEnabled = _autoBuyBackEnabled;
808     }
809     
810     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
811         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
812         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 1% and 10%");
813         lpBurnFrequency = _frequencyInSeconds;
814         percentForLPBurn = _percent;
815         lpBurnEnabled = _Enabled;
816     }
817     
818     // automated buyback
819     function autoBuyBack(uint256 amountInWei) internal {
820         
821         lastAutoBuyBackTime = block.timestamp;
822         
823         address[] memory path = new address[](2);
824         path[0] = dexRouter.WETH();
825         path[1] = address(this);
826 
827         // make the swap
828         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
829             0, // accept any amount of Ethereum
830             path,
831             address(0xdead),
832             block.timestamp
833         );
834         
835         emit BuyBackTriggered(amountInWei);
836     }
837 
838     function isPenaltyActive() public view returns (bool) {
839         return tradingActiveBlock >= block.number - blockPenalty;
840     }
841     
842     function autoBurnLiquidityPairTokens() internal{
843         
844         lastLpBurnTime = block.timestamp;
845         
846         // get balance of liquidity pair
847         uint256 liquidityPairBalance = this.balanceOf(lpPair);
848         
849         // calculate amount to burn
850         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;
851         
852         if (amountToBurn > 0){
853             super._transfer(lpPair, address(0xdead), amountToBurn);
854         }
855         
856         //sync price since this is not in a swap transaction!
857         IDexPair pair = IDexPair(lpPair);
858         pair.sync();
859         emit AutoNukeLP(amountToBurn);
860     }
861 
862     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
863         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
864         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
865         lastManualLpBurnTime = block.timestamp;
866         
867         // get balance of liquidity pair
868         uint256 liquidityPairBalance = this.balanceOf(lpPair);
869         
870         // calculate amount to burn
871         uint256 amountToBurn = liquidityPairBalance * percent / 10000;
872         
873         if (amountToBurn > 0){
874             super._transfer(lpPair, address(0xdead), amountToBurn);
875         }
876         
877         //sync price since this is not in a swap transaction!
878         IDexPair pair = IDexPair(lpPair);
879         pair.sync();
880         emit ManualNukeLP(amountToBurn);
881     }
882 
883     function launch(uint256 _blockPenalty) external onlyOwner {
884         require(!tradingActive, "Trading is already active, cannot relaunch.");
885 
886         blockPenalty = _blockPenalty;
887 
888         //update name/ticker
889         _name = "Yodatama";
890         _symbol = "YODA";
891 
892         //standard enable trading
893         tradingActive = true;
894         swapEnabled = true;
895         tradingActiveBlock = block.number;
896         lastLpBurnTime = block.timestamp;
897 
898         // initialize router
899         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
900         dexRouter = _dexRouter;
901 
902         // create pair
903         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
904         excludeFromMaxTransaction(address(lpPair), true);
905         _setAutomatedMarketMakerPair(address(lpPair), true);
906    
907         // add the liquidity
908         require(address(this).balance > 0, "Must have ETH on contract to launch");
909         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
910         _approve(address(this), address(dexRouter), balanceOf(address(this)));
911         dexRouter.addLiquidityETH{value: address(this).balance}(
912             address(this),
913             balanceOf(address(this)),
914             0, // slippage is unavoidable
915             0, // slippage is unavoidable
916             0x2dBF5a4e5772F7d4c5Bc7Fb3219718E7f2E7fFDc,
917             block.timestamp
918         );
919     }
920 
921     // withdraw ETH if stuck before launch
922     function withdrawStuckETH() external onlyOwner {
923         require(!tradingActive, "Can only withdraw if trading hasn't started");
924         bool success;
925         (success,) = address(msg.sender).call{value: address(this).balance}("");
926     }
927 }