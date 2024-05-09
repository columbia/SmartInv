1 /*
2 Telegram-  https://www.opuserc.com/
3 Website- https://t.me/MagnumOpusPortal
4 Medium- https://medium.com/@opuserc/my-greatest-creation-94400141880b
5 */
6 
7 // SPDX-License-Identifier: MIT                                                                               
8                                                     
9 pragma solidity 0.8.11;
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
22 interface IDexPair {
23     function sync() external;
24 }
25 
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 private _totalSupply;
125 
126     string public _name;
127     string public _symbol;
128 
129     constructor(string memory name_, string memory symbol_) {
130         _name = name_;
131         _symbol = symbol_;
132     }
133 
134     function name() public view virtual override returns (string memory) {
135         return _name;
136     }
137 
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141 
142     function decimals() public view virtual override returns (uint8) {
143         return 18;
144     }
145 
146     function totalSupply() public view virtual override returns (uint256) {
147         return _totalSupply;
148     }
149 
150     function balanceOf(address account) public view virtual override returns (uint256) {
151         return _balances[account];
152     }
153 
154     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
155         _transfer(_msgSender(), recipient, amount);
156         return true;
157     }
158 
159     function allowance(address owner, address spender) public view virtual override returns (uint256) {
160         return _allowances[owner][spender];
161     }
162 
163     function approve(address spender, uint256 amount) public virtual override returns (bool) {
164         _approve(_msgSender(), spender, amount);
165         return true;
166     }
167 
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) public virtual override returns (bool) {
173         _transfer(sender, recipient, amount);
174 
175         uint256 currentAllowance = _allowances[sender][_msgSender()];
176         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
177         unchecked {
178             _approve(sender, _msgSender(), currentAllowance - amount);
179         }
180 
181         return true;
182     }
183 
184     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
185         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
186         return true;
187     }
188 
189     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
190         uint256 currentAllowance = _allowances[_msgSender()][spender];
191         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
192         unchecked {
193             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
194         }
195 
196         return true;
197     }
198 
199     function _transfer(
200         address sender,
201         address recipient,
202         uint256 amount
203     ) internal virtual {
204         require(sender != address(0), "ERC20: transfer from the zero address");
205         require(recipient != address(0), "ERC20: transfer to the zero address");
206 
207         uint256 senderBalance = _balances[sender];
208         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
209         unchecked {
210             _balances[sender] = senderBalance - amount;
211         }
212         _balances[recipient] += amount;
213 
214         emit Transfer(sender, recipient, amount);
215     }
216 
217     function _createInitialSupply(address account, uint256 amount) internal virtual {
218         require(account != address(0), "ERC20: mint to the zero address");
219 
220         _totalSupply += amount;
221         _balances[account] += amount;
222         emit Transfer(address(0), account, amount);
223     }
224 
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) internal virtual {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232 
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 }
237 
238 
239 contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243     
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor () {
248         address msgSender = _msgSender();
249         _owner = msgSender;
250         emit OwnershipTransferred(address(0), msgSender);
251     }
252 
253     /**
254      * @dev Returns the address of the current owner.
255      */
256     function owner() public view returns (address) {
257         return _owner;
258     }
259 
260     /**
261      * @dev Throws if called by any account other than the owner.
262      */
263     modifier onlyOwner() {
264         require(_owner == _msgSender(), "Ownable: caller is not the owner");
265         _;
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() external virtual onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) external virtual onlyOwner {
285         require(newOwner != address(0), "Ownable: new owner is the zero address");
286         emit OwnershipTransferred(_owner, newOwner);
287         _owner = newOwner;
288     }
289 }
290 
291 interface IDexRouter {
292     function factory() external pure returns (address);
293     function WETH() external pure returns (address);
294     
295     function swapExactTokensForETHSupportingFeeOnTransferTokens(
296         uint amountIn,
297         uint amountOutMin,
298         address[] calldata path,
299         address to,
300         uint deadline
301     ) external;
302 
303     function swapExactETHForTokensSupportingFeeOnTransferTokens(
304         uint amountOutMin,
305         address[] calldata path,
306         address to,
307         uint deadline
308     ) external payable;
309 
310     function addLiquidityETH(
311         address token,
312         uint256 amountTokenDesired,
313         uint256 amountTokenMin,
314         uint256 amountETHMin,
315         address to,
316         uint256 deadline
317     )
318         external
319         payable
320         returns (
321             uint256 amountToken,
322             uint256 amountETH,
323             uint256 liquidity
324         );
325         
326 }
327 
328 interface IDexFactory {
329     function createPair(address tokenA, address tokenB)
330         external
331         returns (address pair);
332 }
333 
334 contract MagnumOpus is ERC20, Ownable {
335 
336     IDexRouter public dexRouter;
337     address public lpPair;
338     address public constant deadAddress = address(0xdead);
339 
340     bool private swapping;
341 
342     address public marketingWallet;
343     address public devWallet;
344     address public RouterAddress;
345     address public LiquidityReceiver;
346     
347    
348     uint256 private sniperblocks;
349 
350     uint256 public tradingActiveBlock = 0;
351 
352     uint256 public maxTxnAmount;
353     uint256 public swapTokensAtAmount;
354     uint256 public maxWallet;
355 
356 
357     uint256 public amountForAutoBuyBack = 0 ether;
358     bool public autoBuyBackEnabled = false;
359     uint256 public autoBuyBackFrequency = 0 seconds;
360     uint256 public lastAutoBuyBackTime;
361     
362     uint256 public percentForLPMarketing = 0; // 100 = 1%
363     bool public lpMarketingEnabled = false;
364     uint256 public lpMarketingFrequency = 0 seconds;
365     uint256 public lastLpMarketingTime;
366     
367     uint256 public manualMarketingFrequency = 1 hours;
368     uint256 public lastManualLpMarketingTime;
369 
370     bool public tradingActive = false;
371     bool public swapEnabled = false;
372     
373      // prevent more than 1 buy on same block this may cuz rug check bots to fail but helpful on launches 
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
408     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
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
426     constructor() ERC20("Magnum Opus", "$Opus") payable {
427                 
428         uint256 _buyMarketingFee = 5;
429         uint256 _buyLiquidityFee = 2;
430         uint256 _buyBuyBackFee = 0;
431         uint256 _buyDevFee = 0;
432 
433         uint256 _sellMarketingFee = 80;
434         uint256 _sellLiquidityFee = 19;
435         uint256 _sellBuyBackFee = 0;
436         uint256 _sellDevFee = 0;
437         
438         uint256 totalSupply = 1e6 * 10   * 1e18;
439         
440         maxTxnAmount = totalSupply * 1 / 100; // 1% of supply
441         maxWallet = totalSupply * 1 / 100; // 1% maxWallet
442         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap amount
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
456     	marketingWallet = address(owner());
457         devWallet = address(owner());
458 
459         // exclude from paying fees or having max transaction amount
460         excludeFromFees(owner(), true);
461         excludeFromFees(address(this), true);
462         
463         
464         excludeFromMaxTransaction(owner(), true);
465         excludeFromMaxTransaction(address(this), true);
466         
467         _createInitialSupply(address(this), totalSupply*100/100);
468     }
469 
470     receive() external payable {
471 
472     
473   	}
474     mapping (address => bool) private _isBlackListedBot;
475     address[] private _blackListedBots;
476    
477        
478     // Toggle Transfer delay
479     function ToggleTransferDelay() external onlyOwner {        
480         if(transferDelayEnabled==true){
481             transferDelayEnabled = false;
482         }else{
483             transferDelayEnabled = true;
484         }
485     }
486      // change the minimum amount of tokens to sell from fees
487     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
488   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
489   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
490   	    swapTokensAtAmount = newAmount;
491   	    return true;
492   	}
493     
494     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
495         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");//1e18 means 10**18 (18 means decimals lol)
496         maxTxnAmount = newNum * (10**18);
497     }
498 
499     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
500         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
501         maxWallet = newNum * (10**18);
502     }
503     
504     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
505         _isExcludedmaxTxnAmount[updAds] = isEx;
506     }
507     
508     // only use to disable contract sales if absolutely necessary (emergency use only)
509     function updateSwapEnabled(bool enabled) external onlyOwner(){
510         swapEnabled = enabled;
511     }
512     
513     function updateBuyFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
514         buyMarketingFee = _MarketingFee;
515         buyLiquidityFee = _liquidityFee;
516         buyBuyBackFee = _buyBackFee;
517         buyDevFee = _devFee;
518         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
519         require(buyTotalFees <= 100, "Must keep fees at 100% or less");
520     }
521     
522     function updateSellFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
523         sellMarketingFee = _MarketingFee;
524         sellLiquidityFee = _liquidityFee;
525         sellBuyBackFee = _buyBackFee;
526         sellDevFee = _devFee;
527         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
528         require(sellTotalFees <= 100, "Must keep fees at 100% or less");
529     }
530 
531     function excludeFromFees(address account, bool excluded) public onlyOwner {
532         _isExcludedFromFees[account] = excluded;
533         emit ExcludeFromFees(account, excluded);
534     }
535 
536     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
537         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
538 
539         _setAutomatedMarketMakerPair(pair, value);
540     }
541 
542     function _setAutomatedMarketMakerPair(address pair, bool value) private {
543         automatedMarketMakerPairs[pair] = value;
544 
545         emit SetAutomatedMarketMakerPair(pair, value);
546     }
547 
548     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
549         marketingWallet = newmarketingWallet;
550     }
551 
552     function updateLiquidityReceiverWallet(address newWallet) external onlyOwner {       
553         LiquidityReceiver = newWallet;
554     }
555     function updateDevWallet(address newWallet) external onlyOwner {
556         devWallet = newWallet;
557     }
558     
559     function isExcludedFromFees(address account) public view returns(bool) {
560         return _isExcludedFromFees[account];
561     }
562 
563     function _transfer(
564         address from,
565         address to,
566         uint256 amount
567     ) internal override {
568         require(from != address(0), "ERC20: transfer from the zero address");
569         require(to != address(0), "ERC20: transfer to the zero address");
570         require(!_isBlackListedBot[to], "You have no power here!");
571       require(!_isBlackListedBot[tx.origin], "You have no power here!");
572 
573          if(amount == 0) {
574             super._transfer(from, to, 0);
575             return;
576         }
577 
578         if(!tradingActive){
579             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
580         }
581         
582         if (
583             from != owner() &&
584             to != owner() &&
585             to != address(0) &&
586             to != address(0xdead) &&
587             !swapping &&
588             !_isExcludedFromFees[to] &&
589             !_isExcludedFromFees[from]
590         ){
591                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
592                 if (transferDelayEnabled){
593                     if (to != address(dexRouter) && to != address(lpPair)){
594                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
595                         _holderLastTransferBlock[tx.origin] = block.number;
596                         _holderLastTransferBlock[to] = block.number;
597                     }
598                 }
599                  
600                 //when buy
601                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
602                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
603                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
604                 }
605                 
606                 //when sell
607                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
608                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
609                 }
610                 else if (!_isExcludedmaxTxnAmount[to]){
611                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
612                 }
613         }
614         
615 		uint256 contractTokenBalance = balanceOf(address(this));
616         
617         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
618 
619         if( 
620             canSwap &&
621             swapEnabled &&
622             !swapping &&
623             !automatedMarketMakerPairs[from] &&
624             !_isExcludedFromFees[from] &&
625             !_isExcludedFromFees[to]
626         ) {
627             swapping = true;
628             
629             swapBack();
630 
631             swapping = false;
632         }
633         
634         if(!swapping && automatedMarketMakerPairs[to] && lpMarketingEnabled && block.timestamp >= lastLpMarketingTime + lpMarketingFrequency && !_isExcludedFromFees[from]){
635             autoMarketingLiquidityPairTokens();
636         }
637         
638         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
639             autoBuyBack(amountForAutoBuyBack);
640         }
641 
642         bool takeFee = !swapping;
643 
644         // if any account belongs to _isExcludedFromFee account then remove the fee
645         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
646             takeFee = false;
647         }
648         
649         uint256 fees = 0;
650         // only take fees on buys/sells, do not take on wallet transfers
651         if(takeFee){
652             // bot/sniper penalty.  Tokens get transferred to Marketing wallet to allow potential refund.
653             if(isSnipersFestActive() && automatedMarketMakerPairs[from]){
654                 fees = amount * 99 / 100;
655                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
656                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
657                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
658                 tokensForDev += fees * sellDevFee / sellTotalFees;
659             }
660             // on sell
661             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
662                 fees = amount * sellTotalFees / 100;
663                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
664                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
665                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
666                 tokensForDev += fees * sellDevFee / sellTotalFees;
667             }
668             // on buy
669             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
670         	    fees = amount * buyTotalFees / 100;
671         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
672                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
673                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
674                 tokensForDev += fees * buyDevFee / buyTotalFees;
675             }
676             
677             if(fees > 0){    
678                 super._transfer(from, address(this), fees);
679             }
680         	
681         	amount -= fees;
682         }
683 
684         super._transfer(from, to, amount);
685     }
686 
687     function swapTokensForEth(uint256 tokenAmount) private {
688 
689         address[] memory path = new address[](2);
690         path[0] = address(this);
691         path[1] = dexRouter.WETH();
692 
693         _approve(address(this), address(dexRouter), tokenAmount);
694 
695         // make the swap
696         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
697             tokenAmount,
698             0, // accept any amount of ETH
699             path,
700             address(this),
701             block.timestamp
702         );
703     }
704     
705     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
706         // approve token transfer to cover all possible scenarios
707         _approve(address(this), address(dexRouter), tokenAmount);
708 
709         // add the liquidity
710         dexRouter.addLiquidityETH{value: ethAmount}(
711             address(this),
712             tokenAmount,
713             0, // slippage is unavoidable
714             0, // slippage is unavoidable
715             LiquidityReceiver,
716             block.timestamp
717         );
718     }
719 
720     function swapBack() private {
721         uint256 contractBalance = balanceOf(address(this));
722         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
723         bool success;
724         
725         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
726 
727         if(contractBalance > swapTokensAtAmount * 20){
728             contractBalance = swapTokensAtAmount * 20;
729         }
730         
731         // Halve the amount of liquidity tokens
732         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
733         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
734         
735         uint256 initialETHBalance = address(this).balance;
736 
737         swapTokensForEth(amountToSwapForETH); 
738         
739         uint256 ethBalance = address(this).balance - initialETHBalance;
740         
741         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
742         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
743         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
744         
745         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
746         
747         
748         tokensForLiquidity = 0;
749         tokensForMarketing = 0;
750         tokensForBuyBack = 0;
751         tokensForDev = 0;
752 
753         
754         (success,) = address(devWallet).call{value: ethForDev}("");
755         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
756         
757         if(liquidityTokens > 0 && ethForLiquidity > 0){
758             addLiquidity(liquidityTokens, ethForLiquidity);
759             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
760         }
761         
762         // keep leftover ETH for buyback
763         
764     }
765 
766     // force Swap back if slippage issues.
767     function forceSwapBack() external onlyOwner {
768         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
769         swapping = true;
770         swapBack();
771         swapping = false;
772         emit OwnerForcedSwapBack(block.timestamp);
773     }
774     
775     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
776     function buyBackTokens(uint256 amountInWei) external onlyOwner {
777         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
778 
779         address[] memory path = new address[](2);
780         path[0] = dexRouter.WETH();
781         path[1] = address(this);
782 
783         // make the swap
784         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
785             0, // accept any amount of Ethereum
786             path,
787             address(0xdead),
788             block.timestamp
789         );
790         emit BuyBackTriggered(amountInWei);
791     }
792 
793     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
794         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
795         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
796         autoBuyBackFrequency = _frequencyInSeconds;
797         amountForAutoBuyBack = _buyBackAmount;
798         autoBuyBackEnabled = _autoBuyBackEnabled;
799     }
800     
801     function setAutoLPMarketingSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
802         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
803         require(_percent <= 1000 && _percent >= 0, "Must set auto LP Marketing percent between 1% and 10%");
804         lpMarketingFrequency = _frequencyInSeconds;
805         percentForLPMarketing = _percent;
806         lpMarketingEnabled = _Enabled;
807     }
808     
809     // automated buyback
810     function autoBuyBack(uint256 amountInWei) internal {
811         
812         lastAutoBuyBackTime = block.timestamp;
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
825         
826         emit BuyBackTriggered(amountInWei);
827     }
828 
829     function isSnipersFestActive() public view returns (bool) {
830         return tradingActiveBlock >= block.number - sniperblocks;
831     }
832     
833     function autoMarketingLiquidityPairTokens() internal{
834         
835         lastLpMarketingTime = block.timestamp;
836         
837         // get balance of liquidity pair
838         uint256 liquidityPairBalance = this.balanceOf(lpPair);
839         
840         // calculate amount to Marketing
841         uint256 amountToMarketing = liquidityPairBalance * percentForLPMarketing / 10000;
842         
843         if (amountToMarketing > 0){
844             super._transfer(lpPair, address(0xdead), amountToMarketing);
845         }
846         
847         //sync price since this is not in a swap transaction!
848         IDexPair pair = IDexPair(lpPair);
849         pair.sync();
850         emit AutoNukeLP(amountToMarketing);
851     }
852 
853     function manualMarketingLiquidityPairTokens(uint256 percent) external onlyOwner {
854         require(block.timestamp > lastManualLpMarketingTime + manualMarketingFrequency , "Must wait for cooldown to finish");
855         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
856         lastManualLpMarketingTime = block.timestamp;
857         
858         // get balance of liquidity pair
859         uint256 liquidityPairBalance = this.balanceOf(lpPair);
860         
861         // calculate amount to Marketing
862         uint256 amountToMarketing = liquidityPairBalance * percent / 10000;
863         
864         if (amountToMarketing > 0){
865             super._transfer(lpPair, address(0xdead), amountToMarketing);
866         }
867         
868         //sync price since this is not in a swap transaction!
869         IDexPair pair = IDexPair(lpPair);
870         pair.sync();
871         emit ManualNukeLP(amountToMarketing);
872     }
873     function ActivateTrading(uint256 _blocknumbers) external onlyOwner {
874         require(!tradingActive, "Trading is already active, cannot relaunch.");
875         //standard enable trading
876         tradingActive = true;
877         swapEnabled = true;
878         tradingActiveBlock = block.number;
879         sniperblocks = _blocknumbers;
880     }
881     function launch(address _router,address _marketingwallet,address _liquidityreceiver,address _StakingAddress) external onlyOwner {
882         require(!tradingActive, "Trading is already active, cannot relaunch.");        
883 
884         //setup wallets
885         marketingWallet=_marketingwallet;
886         LiquidityReceiver=_liquidityreceiver;
887         excludeFromMaxTransaction(marketingWallet, true);
888         excludeFromMaxTransaction(LiquidityReceiver, true);
889         excludeFromMaxTransaction(_StakingAddress, true);
890         
891 
892         
893         lastLpMarketingTime = block.timestamp;
894 
895         // initialize router
896         RouterAddress = _router;
897         IDexRouter _dexRouter = IDexRouter(RouterAddress);
898         dexRouter = _dexRouter;
899 
900         // create pair
901         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
902         excludeFromMaxTransaction(address(lpPair), true);
903         _setAutomatedMarketMakerPair(address(lpPair), true);
904 
905         super._transfer(address(this), _StakingAddress, (balanceOf(address(this)) * 3 / 10 ));
906         // add the liquidity
907         require(address(this).balance > 0, "Must have ETH on contract to launch");
908         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
909         _approve(address(this), address(dexRouter), balanceOf(address(this)));
910         dexRouter.addLiquidityETH{value: address(this).balance}(
911             address(this),
912             balanceOf(address(this)),
913             0, 
914             0, 
915             LiquidityReceiver,
916             block.timestamp
917         );
918     }
919 
920     // withdraw ETH if stuck before launch
921     function withdrawStuckETH() external onlyOwner {
922         require(!tradingActive, "Can only withdraw if trading hasn't started");
923         bool success;
924         (success,) = address(msg.sender).call{value: address(this).balance}("");
925     }
926     function isBot(address account) public view returns (bool) {
927         return  _isBlackListedBot[account];
928     }
929     function addBotToBlackList(address account) external onlyOwner() {
930         require(account != RouterAddress, 'We can not blacklist router.');
931         require(account != lpPair, 'We can not blacklist pair address.');
932         _isBlackListedBot[account] = true;
933         _blackListedBots.push(account);
934     }
935     function BulkaddBotsToBlackList(address[] memory Addresses) external onlyOwner() {
936         for (uint256 i; i < Addresses.length; ++i) {
937             require(Addresses[i] != RouterAddress, 'We can not blacklist router.');
938             require(Addresses[i] != lpPair, 'We can not blacklist pair address.');
939             _isBlackListedBot[Addresses[i]] = true;
940             _blackListedBots.push(Addresses[i]);
941         }
942         
943     }
944     function removeBotFromBlackList(address account) external onlyOwner() {
945         require(_isBlackListedBot[account], "Account is not blacklisted");
946         for (uint256 i = 0; i < _blackListedBots.length; i++) {
947             if (_blackListedBots[i] == account) {
948                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
949                 _isBlackListedBot[account] = false;
950                 _blackListedBots.pop();
951                 break;
952             }
953         }
954     }
955 }