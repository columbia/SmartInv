1 /*
2 The Innovation Program 
3 Telegram : https://t.me/TheInnovationProgram
4 Website : https://theinnovationprogram.com
5 */
6 // SPDX-License-Identifier: MIT
7 pragma solidity 0.8.11;
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
20 interface IDexPair {
21     function sync() external;
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 contract ERC20 is Context, IERC20, IERC20Metadata {
117     mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     string public _name;
124     string public _symbol;
125 
126     constructor(string memory name_, string memory symbol_) {
127         _name = name_;
128         _symbol = symbol_;
129     }
130 
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public view virtual override returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view virtual override returns (uint8) {
140         return 18;
141     }
142 
143     function totalSupply() public view virtual override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     function balanceOf(address account) public view virtual override returns (uint256) {
148         return _balances[account];
149     }
150 
151     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     function allowance(address owner, address spender) public view virtual override returns (uint256) {
157         return _allowances[owner][spender];
158     }
159 
160     function approve(address spender, uint256 amount) public virtual override returns (bool) {
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164 
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) public virtual override returns (bool) {
170         _transfer(sender, recipient, amount);
171 
172         uint256 currentAllowance = _allowances[sender][_msgSender()];
173         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
174         unchecked {
175             _approve(sender, _msgSender(), currentAllowance - amount);
176         }
177 
178         return true;
179     }
180 
181     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
182         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
183         return true;
184     }
185 
186     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
187         uint256 currentAllowance = _allowances[_msgSender()][spender];
188         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
189         unchecked {
190             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
191         }
192 
193         return true;
194     }
195 
196     function _transfer(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) internal virtual {
201         require(sender != address(0), "ERC20: transfer from the zero address");
202         require(recipient != address(0), "ERC20: transfer to the zero address");
203 
204         uint256 senderBalance = _balances[sender];
205         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
206         unchecked {
207             _balances[sender] = senderBalance - amount;
208         }
209         _balances[recipient] += amount;
210 
211         emit Transfer(sender, recipient, amount);
212     }
213 
214     function _createInitialSupply(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: mint to the zero address");
216 
217         _totalSupply += amount;
218         _balances[account] += amount;
219         emit Transfer(address(0), account, amount);
220     }
221 
222     function _approve(
223         address owner,
224         address spender,
225         uint256 amount
226     ) internal virtual {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229 
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 }
234 
235 
236 contract Ownable is Context {
237     address private _owner;
238 
239     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
240     
241     /**
242      * @dev Initializes the contract setting the deployer as the initial owner.
243      */
244     constructor () {
245         address msgSender = _msgSender();
246         _owner = msgSender;
247         emit OwnershipTransferred(address(0), msgSender);
248     }
249 
250     /**
251      * @dev Returns the address of the current owner.
252      */
253     function owner() public view returns (address) {
254         return _owner;
255     }
256 
257     /**
258      * @dev Throws if called by any account other than the owner.
259      */
260     modifier onlyOwner() {
261         require(_owner == _msgSender(), "Ownable: caller is not the owner");
262         _;
263     }
264 
265     /**
266      * @dev Leaves the contract without owner. It will not be possible to call
267      * `onlyOwner` functions anymore. Can only be called by the current owner.
268      *
269      * NOTE: Renouncing ownership will leave the contract without an owner,
270      * thereby removing any functionality that is only available to the owner.
271      */
272     function renounceOwnership() external virtual onlyOwner {
273         emit OwnershipTransferred(_owner, address(0));
274         _owner = address(0);
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Can only be called by the current owner.
280      */
281     function transferOwnership(address newOwner) external virtual onlyOwner {
282         require(newOwner != address(0), "Ownable: new owner is the zero address");
283         emit OwnershipTransferred(_owner, newOwner);
284         _owner = newOwner;
285     }
286 }
287 
288 interface IDexRouter {
289     function factory() external pure returns (address);
290     function WETH() external pure returns (address);
291     
292     function swapExactTokensForETHSupportingFeeOnTransferTokens(
293         uint amountIn,
294         uint amountOutMin,
295         address[] calldata path,
296         address to,
297         uint deadline
298     ) external;
299 
300     function swapExactETHForTokensSupportingFeeOnTransferTokens(
301         uint amountOutMin,
302         address[] calldata path,
303         address to,
304         uint deadline
305     ) external payable;
306 
307     function addLiquidityETH(
308         address token,
309         uint256 amountTokenDesired,
310         uint256 amountTokenMin,
311         uint256 amountETHMin,
312         address to,
313         uint256 deadline
314     )
315         external
316         payable
317         returns (
318             uint256 amountToken,
319             uint256 amountETH,
320             uint256 liquidity
321         );
322         
323 }
324 
325 interface IDexFactory {
326     function createPair(address tokenA, address tokenB)
327         external
328         returns (address pair);
329 }
330 
331 contract ZeroXAIFactory is ERC20, Ownable {
332 
333     IDexRouter public dexRouter;
334     address public lpPair;
335     address public constant deadAddress = address(0xdead);
336 
337     bool private swapping;
338 
339     address public marketingWallet;
340     address public devWallet;
341     address public RouterAddress;
342     address public LiquidityReceiver;
343     
344    
345     uint256 private sniperblocks;
346 
347     uint256 public tradingActiveBlock = 0;
348 
349     uint256 public maxTxnAmount;
350     uint256 public swapTokensAtAmount;
351     uint256 public maxWallet;
352 
353 
354     uint256 public amountForAutoBuyBack = 0 ether;
355     bool public autoBuyBackEnabled = false;
356     uint256 public autoBuyBackFrequency = 0 seconds;
357     uint256 public lastAutoBuyBackTime;
358     
359     uint256 public percentForLPMarketing = 0; // 100 = 1%
360     bool public lpMarketingEnabled = false;
361     uint256 public lpMarketingFrequency = 0 seconds;
362     uint256 public lastLpMarketingTime;
363     
364     uint256 public manualMarketingFrequency = 1 hours;
365     uint256 public lastManualLpMarketingTime;
366 
367     bool public tradingActive = false;
368     bool public swapEnabled = false;
369     
370      // prevent more than 1 buy on same block this may cuz rug check bots to fail but helpful on launches 
371     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
372     bool public transferDelayEnabled = false;
373 
374     uint256 public buyTotalFees;
375     uint256 public buyMarketingFee;
376     uint256 public buyLiquidityFee;
377     uint256 public buyBuyBackFee;
378     uint256 public buyDevFee;
379     
380     uint256 public sellTotalFees;
381     uint256 public sellMarketingFee;
382     uint256 public sellLiquidityFee;
383     uint256 public sellBuyBackFee;
384     uint256 public sellDevFee;
385     
386     uint256 public tokensForMarketing;
387     uint256 public tokensForLiquidity;
388     uint256 public tokensForBuyBack;
389     uint256 public tokensForDev;
390     
391     /******************/
392 
393     // exlcude from fees and max transaction amount
394     mapping (address => bool) private _isExcludedFromFees;
395     mapping (address => bool) public _isExcludedmaxTxnAmount;
396 
397     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
398     // could be subject to a maximum transfer amount
399     mapping (address => bool) public automatedMarketMakerPairs;
400 
401     event ExcludeFromFees(address indexed account, bool isExcluded);
402 
403     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
404 
405     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
406 
407     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
408 
409     event SwapAndLiquify(
410         uint256 tokensSwapped,
411         uint256 ethReceived,
412         uint256 tokensIntoLiquidity
413     );
414     
415     event AutoNukeLP(uint256 amount);
416     
417     event ManualNukeLP(uint256 amount);
418     
419     event BuyBackTriggered(uint256 amount);
420 
421     event OwnerForcedSwapBack(uint256 timestamp);
422 
423     constructor() ERC20("The Innovation Program", "TIP") payable {
424                 
425         uint256 _buyMarketingFee = 0;
426         uint256 _buyLiquidityFee = 0;
427         uint256 _buyBuyBackFee = 0;
428         uint256 _buyDevFee = 0;
429 
430         uint256 _sellMarketingFee = 20;
431         uint256 _sellLiquidityFee = 0;
432         uint256 _sellBuyBackFee = 0;
433         uint256 _sellDevFee = 0;
434         
435         uint256 totalSupply = 1e8 * 10 * 1e18;
436         
437         maxTxnAmount = totalSupply * 2 / 100; // 2% of supply
438         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
439         swapTokensAtAmount = totalSupply * 5 / 1000; // 1% swap amount
440 
441         buyMarketingFee = _buyMarketingFee;
442         buyLiquidityFee = _buyLiquidityFee;
443         buyBuyBackFee = _buyBuyBackFee;
444         buyDevFee = _buyDevFee;
445         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
446         
447         sellMarketingFee = _sellMarketingFee;
448         sellLiquidityFee = _sellLiquidityFee;
449         sellBuyBackFee = _sellBuyBackFee;
450         sellDevFee = _sellDevFee;
451         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
452         
453         marketingWallet = address(owner());
454         devWallet = address(owner());
455 
456         // exclude from paying fees or having max transaction amount
457         excludeFromFees(owner(), true);
458         excludeFromFees(address(this), true);        
459         excludeFromMaxTransaction(owner(), true);
460         excludeFromMaxTransaction(address(this), true);
461         //set owner as default marketing & liquidity wallet
462         marketingWallet=owner();
463         LiquidityReceiver=owner();
464 
465         
466         // initialize router
467         RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//set router address here
468         IDexRouter _dexRouter = IDexRouter(RouterAddress);
469         dexRouter = _dexRouter;
470         lastLpMarketingTime = block.timestamp;
471         // create pair
472         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
473         excludeFromMaxTransaction(address(lpPair), true);
474         _setAutomatedMarketMakerPair(address(lpPair), true);       
475         //initiate supply
476         _createInitialSupply(owner(), totalSupply*100/100);
477     }
478 
479     receive() external payable {
480 
481     
482     }
483 
484     mapping (address => bool) private _isBlackListedBot;
485     address[] private _blackListedBots;
486    
487        
488     // Toggle Transfer delay
489     function ToggleTransferDelay() external onlyOwner {        
490         if(transferDelayEnabled==true){
491             transferDelayEnabled = false;
492         }else{
493             transferDelayEnabled = true;
494         }
495     }
496      // change the minimum amount of tokens to sell from fees
497     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
498         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
499         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
500         swapTokensAtAmount = newAmount;
501         return true;
502     }
503     
504     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
505         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");//1e18 means 10**18 (18 means decimals lol)
506         maxTxnAmount = newNum * (10**18);
507     }
508 
509     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
510         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
511         maxWallet = newNum * (10**18);
512     }
513     
514     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
515         _isExcludedmaxTxnAmount[updAds] = isEx;
516     }
517     
518     // only use to disable contract sales if absolutely necessary (emergency use only)
519     function updateSwapEnabled(bool enabled) external onlyOwner(){
520         swapEnabled = enabled;
521     }
522     
523     function updateBuyFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
524         buyMarketingFee = _MarketingFee;
525         buyLiquidityFee = _liquidityFee;
526         buyBuyBackFee = _buyBackFee;
527         buyDevFee = _devFee;
528         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
529         require(buyTotalFees <= 100, "Must keep fees at 100% or less");
530     }
531     
532     function updateSellFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
533         sellMarketingFee = _MarketingFee;
534         sellLiquidityFee = _liquidityFee;
535         sellBuyBackFee = _buyBackFee;
536         sellDevFee = _devFee;
537         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
538         require(sellTotalFees <= 100, "Must keep fees at 100% or less");
539     }
540 
541     function excludeFromFees(address account, bool excluded) public onlyOwner {
542         _isExcludedFromFees[account] = excluded;
543         emit ExcludeFromFees(account, excluded);
544     }
545 
546     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
547         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
548 
549         _setAutomatedMarketMakerPair(pair, value);
550     }
551 
552     function _setAutomatedMarketMakerPair(address pair, bool value) private {
553         automatedMarketMakerPairs[pair] = value;
554 
555         emit SetAutomatedMarketMakerPair(pair, value);
556     }
557 
558     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
559         marketingWallet = newmarketingWallet;
560     }
561 
562     function updateLiquidityReceiverWallet(address newWallet) external onlyOwner {       
563         LiquidityReceiver = newWallet;
564     }
565     function updateDevWallet(address newWallet) external onlyOwner {
566         devWallet = newWallet;
567     }
568     
569     function isExcludedFromFees(address account) public view returns(bool) {
570         return _isExcludedFromFees[account];
571     }
572 
573     function _transfer(
574         address from,
575         address to,
576         uint256 amount
577     ) internal override {
578         require(from != address(0), "ERC20: transfer from the zero address");
579         require(to != address(0), "ERC20: transfer to the zero address");
580         require(!_isBlackListedBot[to], "You have no power here!");
581       require(!_isBlackListedBot[tx.origin], "You have no power here!");
582 
583          if(amount == 0) {
584             super._transfer(from, to, 0);
585             return;
586         }
587 
588         if(!tradingActive){
589             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
590         }
591         
592         if (
593             from != owner() &&
594             to != owner() &&
595             to != address(0) &&
596             to != address(0xdead) &&
597             !swapping &&
598             !_isExcludedFromFees[to] &&
599             !_isExcludedFromFees[from]
600         ){
601                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
602                 if (transferDelayEnabled){
603                     if (to != address(dexRouter) && to != address(lpPair)){
604                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
605                         _holderLastTransferBlock[tx.origin] = block.number;
606                         _holderLastTransferBlock[to] = block.number;
607                     }
608                 }
609                  
610                 //when buy
611                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
612                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
613                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
614                 }
615                 
616                 //when sell
617                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
618                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
619                 }
620                 else if (!_isExcludedmaxTxnAmount[to]){
621                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
622                 }
623         }
624         
625     uint256 contractTokenBalance = balanceOf(address(this));
626         
627         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
628 
629         if( 
630             canSwap &&
631             swapEnabled &&
632             !swapping &&
633             !automatedMarketMakerPairs[from] &&
634             !_isExcludedFromFees[from] &&
635             !_isExcludedFromFees[to]
636         ) {
637             swapping = true;
638             
639             swapBack();
640 
641             swapping = false;
642         }
643         
644         if(!swapping && automatedMarketMakerPairs[to] && lpMarketingEnabled && block.timestamp >= lastLpMarketingTime + lpMarketingFrequency && !_isExcludedFromFees[from]){
645             autoMarketingLiquidityPairTokens();
646         }
647         
648         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
649             autoBuyBack(amountForAutoBuyBack);
650         }
651 
652         bool takeFee = !swapping;
653 
654         // if any account belongs to _isExcludedFromFee account then remove the fee
655         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
656             takeFee = false;
657         }
658         
659         uint256 fees = 0;
660         // only take fees on buys/sells, do not take on wallet transfers
661         if(takeFee){
662             // bot/sniper penalty.  Tokens get transferred to Marketing wallet to allow potential refund.
663             if(isSnipersFestActive() && automatedMarketMakerPairs[from]){
664                 fees = amount * 99 / 100;
665                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
666                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
667                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
668                 tokensForDev += fees * sellDevFee / sellTotalFees;
669             }
670             // on sell
671             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
672                 fees = amount * sellTotalFees / 100;
673                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
674                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
675                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
676                 tokensForDev += fees * sellDevFee / sellTotalFees;
677             }
678             // on buy
679             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
680               fees = amount * buyTotalFees / 100;
681               tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
682                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
683                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
684                 tokensForDev += fees * buyDevFee / buyTotalFees;
685             }
686             
687             if(fees > 0){    
688                 super._transfer(from, address(this), fees);
689             }
690           
691           amount -= fees;
692         }
693 
694         super._transfer(from, to, amount);
695     }
696 
697     function swapTokensForEth(uint256 tokenAmount) private {
698 
699         address[] memory path = new address[](2);
700         path[0] = address(this);
701         path[1] = dexRouter.WETH();
702 
703         _approve(address(this), address(dexRouter), tokenAmount);
704 
705         // make the swap
706         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
707             tokenAmount,
708             0, // accept any amount of ETH
709             path,
710             address(this),
711             block.timestamp
712         );
713     }
714     
715     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
716         // approve token transfer to cover all possible scenarios
717         _approve(address(this), address(dexRouter), tokenAmount);
718 
719         // add the liquidity
720         dexRouter.addLiquidityETH{value: ethAmount}(
721             address(this),
722             tokenAmount,
723             0, // slippage is unavoidable
724             0, // slippage is unavoidable
725             LiquidityReceiver,
726             block.timestamp
727         );
728     }
729 
730     function swapBack() private {
731         uint256 contractBalance = balanceOf(address(this));
732         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
733         bool success;
734         
735         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
736 
737         if(contractBalance > swapTokensAtAmount * 20){
738             contractBalance = swapTokensAtAmount * 20;
739         }
740         
741         // Halve the amount of liquidity tokens
742         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
743         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
744         
745         uint256 initialETHBalance = address(this).balance;
746 
747         swapTokensForEth(amountToSwapForETH); 
748         
749         uint256 ethBalance = address(this).balance - initialETHBalance;
750         
751         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
752         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
753         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
754         
755         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
756         
757         
758         tokensForLiquidity = 0;
759         tokensForMarketing = 0;
760         tokensForBuyBack = 0;
761         tokensForDev = 0;
762 
763         
764         (success,) = address(devWallet).call{value: ethForDev}("");
765         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
766         
767         if(liquidityTokens > 0 && ethForLiquidity > 0){
768             addLiquidity(liquidityTokens, ethForLiquidity);
769             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
770         }
771         
772         // keep leftover ETH for buyback
773         
774     }
775 
776     // force Swap back if slippage issues.
777     function forceSwapBack() external onlyOwner {
778         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
779         swapping = true;
780         swapBack();
781         swapping = false;
782         emit OwnerForcedSwapBack(block.timestamp);
783     }
784     
785     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
786     function buyBackTokens(uint256 amountInWei) external onlyOwner {
787         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to avoid sandwich attacks");
788 
789         address[] memory path = new address[](2);
790         path[0] = dexRouter.WETH();
791         path[1] = address(this);
792 
793         // make the swap
794         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
795             0, // accept any amount of Ethereum
796             path,
797             address(0xdead),
798             block.timestamp
799         );
800         emit BuyBackTriggered(amountInWei);
801     }
802 
803     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
804         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
805         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
806         autoBuyBackFrequency = _frequencyInSeconds;
807         amountForAutoBuyBack = _buyBackAmount;
808         autoBuyBackEnabled = _autoBuyBackEnabled;
809     }
810     
811     function setAutoLPMarketingSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
812         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
813         require(_percent <= 1000 && _percent >= 0, "Must set auto LP Marketing percent between 1% and 10%");
814         lpMarketingFrequency = _frequencyInSeconds;
815         percentForLPMarketing = _percent;
816         lpMarketingEnabled = _Enabled;
817     }
818     
819     // automated buyback
820     function autoBuyBack(uint256 amountInWei) internal {
821         
822         lastAutoBuyBackTime = block.timestamp;
823         
824         address[] memory path = new address[](2);
825         path[0] = dexRouter.WETH();
826         path[1] = address(this);
827 
828         // make the swap
829         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
830             0, // accept any amount of Ethereum
831             path,
832             address(0xdead),
833             block.timestamp
834         );
835         
836         emit BuyBackTriggered(amountInWei);
837     }
838 
839     function isSnipersFestActive() public view returns (bool) {
840         return tradingActiveBlock >= block.number - sniperblocks;
841     }
842     
843     function autoMarketingLiquidityPairTokens() internal{
844         
845         lastLpMarketingTime = block.timestamp;
846         
847         // get balance of liquidity pair
848         uint256 liquidityPairBalance = this.balanceOf(lpPair);
849         
850         // calculate amount to Marketing
851         uint256 amountToMarketing = liquidityPairBalance * percentForLPMarketing / 10000;
852         
853         if (amountToMarketing > 0){
854             super._transfer(lpPair, address(0xdead), amountToMarketing);
855         }
856         
857         //sync price since this is not in a swap transaction!
858         IDexPair pair = IDexPair(lpPair);
859         pair.sync();
860         emit AutoNukeLP(amountToMarketing);
861     }
862 
863     function manualMarketingLiquidityPairTokens(uint256 percent) external onlyOwner {
864         require(block.timestamp > lastManualLpMarketingTime + manualMarketingFrequency , "Must wait for cooldown to finish");
865         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
866         lastManualLpMarketingTime = block.timestamp;
867         
868         // get balance of liquidity pair
869         uint256 liquidityPairBalance = this.balanceOf(lpPair);
870         
871         // calculate amount to Marketing
872         uint256 amountToMarketing = liquidityPairBalance * percent / 10000;
873         
874         if (amountToMarketing > 0){
875             super._transfer(lpPair, address(0xdead), amountToMarketing);
876         }
877         
878         //sync price since this is not in a swap transaction!
879         IDexPair pair = IDexPair(lpPair);
880         pair.sync();
881         emit ManualNukeLP(amountToMarketing);
882     }
883     function EnableTrading() external onlyOwner {
884         require(!tradingActive, "Trading is already active, cannot relaunch.");
885         //standard enable trading
886         tradingActive = true;
887         swapEnabled = true;
888         tradingActiveBlock = block.number;
889         sniperblocks = 0;
890     }
891     function initiateLP(address _router,address _marketingwallet) external onlyOwner {
892         require(!tradingActive, "Trading is already active, cannot relaunch.");        
893         //setup wallets
894         marketingWallet=_marketingwallet;
895         excludeFromMaxTransaction(marketingWallet, true);
896 
897         lastLpMarketingTime = block.timestamp;
898         // initialize router
899         RouterAddress = _router;
900         IDexRouter _dexRouter = IDexRouter(RouterAddress);
901         dexRouter = _dexRouter;
902         // create pair
903         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
904         excludeFromMaxTransaction(address(lpPair), true);
905         _setAutomatedMarketMakerPair(address(lpPair), true);       
906         // add the liquidity
907         require(address(this).balance > 0, "Must have ETH on contract to launch");
908         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
909         _approve(address(this), address(dexRouter), balanceOf(address(this)));
910         dexRouter.addLiquidityETH{value: address(this).balance}(
911             address(this),
912             balanceOf(address(this)),
913             0, 
914             0, 
915             owner(),
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
926 
927     function isBot(address account) public view returns (bool) {
928         return  _isBlackListedBot[account];
929     }
930 
931     function addBotToBlackList(address account) external onlyOwner() {
932         require(account != RouterAddress, 'We can not blacklist router.');
933         require(account != lpPair, 'We can not blacklist pair address.');
934         _isBlackListedBot[account] = true;
935         _blackListedBots.push(account);
936     }
937 
938     function BulkaddBotsToBlackList(address[] memory Addresses) external onlyOwner() {
939         for (uint256 i; i < Addresses.length; ++i) {
940             require(Addresses[i] != RouterAddress, 'We can not blacklist router.');
941             require(Addresses[i] != lpPair, 'We can not blacklist pair address.');
942             _isBlackListedBot[Addresses[i]] = true;
943             _blackListedBots.push(Addresses[i]);
944         }
945         
946     }
947 
948     function removeBotFromBlackList(address account) external onlyOwner() {
949         require(_isBlackListedBot[account], "Account is not blacklisted");
950         for (uint256 i = 0; i < _blackListedBots.length; i++) {
951             if (_blackListedBots[i] == account) {
952                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
953                 _isBlackListedBot[account] = false;
954                 _blackListedBots.pop();
955                 break;
956             }
957         }
958     }
959 }