1 /*
2 Telegram-  https://t.me/TheAlchemyOfSoulsPortal
3 Website- https://www.thealchemyofsouls.com
4 Medium- https://thealchemyofsouls.medium.com/the-components-of-essence-97139a56c151
5 */
6 // SPDX-License-Identifier: MIT                                                                                                                        
7 pragma solidity 0.8.11;
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IDexPair {
20     function sync() external;
21 }
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 
115 contract ERC20 is Context, IERC20, IERC20Metadata {
116     mapping(address => uint256) private _balances;
117 
118     mapping(address => mapping(address => uint256)) private _allowances;
119 
120     uint256 private _totalSupply;
121 
122     string public _name;
123     string public _symbol;
124 
125     constructor(string memory name_, string memory symbol_) {
126         _name = name_;
127         _symbol = symbol_;
128     }
129 
130     function name() public view virtual override returns (string memory) {
131         return _name;
132     }
133 
134     function symbol() public view virtual override returns (string memory) {
135         return _symbol;
136     }
137 
138     function decimals() public view virtual override returns (uint8) {
139         return 18;
140     }
141 
142     function totalSupply() public view virtual override returns (uint256) {
143         return _totalSupply;
144     }
145 
146     function balanceOf(address account) public view virtual override returns (uint256) {
147         return _balances[account];
148     }
149 
150     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
151         _transfer(_msgSender(), recipient, amount);
152         return true;
153     }
154 
155     function allowance(address owner, address spender) public view virtual override returns (uint256) {
156         return _allowances[owner][spender];
157     }
158 
159     function approve(address spender, uint256 amount) public virtual override returns (bool) {
160         _approve(_msgSender(), spender, amount);
161         return true;
162     }
163 
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) public virtual override returns (bool) {
169         _transfer(sender, recipient, amount);
170 
171         uint256 currentAllowance = _allowances[sender][_msgSender()];
172         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
173         unchecked {
174             _approve(sender, _msgSender(), currentAllowance - amount);
175         }
176 
177         return true;
178     }
179 
180     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
182         return true;
183     }
184 
185     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
186         uint256 currentAllowance = _allowances[_msgSender()][spender];
187         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
188         unchecked {
189             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
190         }
191 
192         return true;
193     }
194 
195     function _transfer(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202 
203         uint256 senderBalance = _balances[sender];
204         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
205         unchecked {
206             _balances[sender] = senderBalance - amount;
207         }
208         _balances[recipient] += amount;
209 
210         emit Transfer(sender, recipient, amount);
211     }
212 
213     function _createInitialSupply(address account, uint256 amount) internal virtual {
214         require(account != address(0), "ERC20: mint to the zero address");
215 
216         _totalSupply += amount;
217         _balances[account] += amount;
218         emit Transfer(address(0), account, amount);
219     }
220 
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 }
233 
234 
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239     
240     /**
241      * @dev Initializes the contract setting the deployer as the initial owner.
242      */
243     constructor () {
244         address msgSender = _msgSender();
245         _owner = msgSender;
246         emit OwnershipTransferred(address(0), msgSender);
247     }
248 
249     /**
250      * @dev Returns the address of the current owner.
251      */
252     function owner() public view returns (address) {
253         return _owner;
254     }
255 
256     /**
257      * @dev Throws if called by any account other than the owner.
258      */
259     modifier onlyOwner() {
260         require(_owner == _msgSender(), "Ownable: caller is not the owner");
261         _;
262     }
263 
264     /**
265      * @dev Leaves the contract without owner. It will not be possible to call
266      * `onlyOwner` functions anymore. Can only be called by the current owner.
267      *
268      * NOTE: Renouncing ownership will leave the contract without an owner,
269      * thereby removing any functionality that is only available to the owner.
270      */
271     function renounceOwnership() external virtual onlyOwner {
272         emit OwnershipTransferred(_owner, address(0));
273         _owner = address(0);
274     }
275 
276     /**
277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
278      * Can only be called by the current owner.
279      */
280     function transferOwnership(address newOwner) external virtual onlyOwner {
281         require(newOwner != address(0), "Ownable: new owner is the zero address");
282         emit OwnershipTransferred(_owner, newOwner);
283         _owner = newOwner;
284     }
285 }
286 
287 interface IDexRouter {
288     function factory() external pure returns (address);
289     function WETH() external pure returns (address);
290     
291     function swapExactTokensForETHSupportingFeeOnTransferTokens(
292         uint amountIn,
293         uint amountOutMin,
294         address[] calldata path,
295         address to,
296         uint deadline
297     ) external;
298 
299     function swapExactETHForTokensSupportingFeeOnTransferTokens(
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external payable;
305 
306     function addLiquidityETH(
307         address token,
308         uint256 amountTokenDesired,
309         uint256 amountTokenMin,
310         uint256 amountETHMin,
311         address to,
312         uint256 deadline
313     )
314         external
315         payable
316         returns (
317             uint256 amountToken,
318             uint256 amountETH,
319             uint256 liquidity
320         );
321         
322 }
323 
324 interface IDexFactory {
325     function createPair(address tokenA, address tokenB)
326         external
327         returns (address pair);
328 }
329 
330 contract TheAlchemyOfSouls is ERC20, Ownable {
331 
332     IDexRouter public dexRouter;
333     address public lpPair;
334     address public constant deadAddress = address(0xdead);
335 
336     bool private swapping;
337 
338     address public marketingWallet;
339     address public devWallet;
340     address public RouterAddress;
341     address public LiquidityReceiver;
342     
343    
344     uint256 private sniperblocks;
345 
346     uint256 public tradingActiveBlock = 0;
347 
348     uint256 public maxTxnAmount;
349     uint256 public swapTokensAtAmount;
350     uint256 public maxWallet;
351 
352 
353     uint256 public amountForAutoBuyBack = 0 ether;
354     bool public autoBuyBackEnabled = false;
355     uint256 public autoBuyBackFrequency = 0 seconds;
356     uint256 public lastAutoBuyBackTime;
357     
358     uint256 public percentForLPMarketing = 0; // 100 = 1%
359     bool public lpMarketingEnabled = false;
360     uint256 public lpMarketingFrequency = 0 seconds;
361     uint256 public lastLpMarketingTime;
362     
363     uint256 public manualMarketingFrequency = 1 hours;
364     uint256 public lastManualLpMarketingTime;
365 
366     bool public tradingActive = false;
367     bool public swapEnabled = false;
368     
369      // prevent more than 1 buy on same block this may cuz rug check bots to fail but helpful on launches 
370     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
371     bool public transferDelayEnabled = true;
372 
373     uint256 public buyTotalFees;
374     uint256 public buyMarketingFee;
375     uint256 public buyLiquidityFee;
376     uint256 public buyBuyBackFee;
377     uint256 public buyDevFee;
378     
379     uint256 public sellTotalFees;
380     uint256 public sellMarketingFee;
381     uint256 public sellLiquidityFee;
382     uint256 public sellBuyBackFee;
383     uint256 public sellDevFee;
384     
385     uint256 public tokensForMarketing;
386     uint256 public tokensForLiquidity;
387     uint256 public tokensForBuyBack;
388     uint256 public tokensForDev;
389     
390     /******************/
391 
392     // exlcude from fees and max transaction amount
393     mapping (address => bool) private _isExcludedFromFees;
394     mapping (address => bool) public _isExcludedmaxTxnAmount;
395 
396     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
397     // could be subject to a maximum transfer amount
398     mapping (address => bool) public automatedMarketMakerPairs;
399 
400     event ExcludeFromFees(address indexed account, bool isExcluded);
401 
402     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
403 
404     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
405 
406     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
407 
408     event SwapAndLiquify(
409         uint256 tokensSwapped,
410         uint256 ethReceived,
411         uint256 tokensIntoLiquidity
412     );
413     
414     event AutoNukeLP(uint256 amount);
415     
416     event ManualNukeLP(uint256 amount);
417     
418     event BuyBackTriggered(uint256 amount);
419 
420     event OwnerForcedSwapBack(uint256 timestamp);
421 
422     constructor() ERC20("The Alchemy Of Souls", "AOS") payable {
423                 
424         uint256 _buyMarketingFee = 4;
425         uint256 _buyLiquidityFee = 2;
426         uint256 _buyBuyBackFee = 0;
427         uint256 _buyDevFee = 0;
428 
429         uint256 _sellMarketingFee = 20;
430         uint256 _sellLiquidityFee = 5;
431         uint256 _sellBuyBackFee = 0;
432         uint256 _sellDevFee = 0;
433         
434         uint256 totalSupply = 1e8 * 10   * 1e18;
435         
436         maxTxnAmount = totalSupply * 5 / 1000; // 0.5% of supply max tx will be changed to 1%
437         maxWallet = totalSupply * 5 / 1000; // 0.5% maxWallet will be changed to 3%
438         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap amount 
439 
440         buyMarketingFee = _buyMarketingFee;
441         buyLiquidityFee = _buyLiquidityFee;
442         buyBuyBackFee = _buyBuyBackFee;
443         buyDevFee = _buyDevFee;
444         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
445         
446         sellMarketingFee = _sellMarketingFee;
447         sellLiquidityFee = _sellLiquidityFee;
448         sellBuyBackFee = _sellBuyBackFee;
449         sellDevFee = _sellDevFee;
450         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
451         
452     	marketingWallet = address(owner());
453         devWallet = address(owner());
454 
455         // exclude from paying fees or having max transaction amount
456         excludeFromFees(owner(), true);
457         excludeFromFees(address(this), true);
458         
459         
460         excludeFromMaxTransaction(owner(), true);
461         excludeFromMaxTransaction(address(this), true);
462         
463         _createInitialSupply(address(this), totalSupply*100/100);
464     }
465 
466     receive() external payable {
467 
468     
469   	}
470     mapping (address => bool) private _isBlackListedBot;
471     address[] private _blackListedBots;
472    
473        
474     // Toggle Transfer delay
475     function ToggleTransferDelay() external onlyOwner {        
476         if(transferDelayEnabled==true){
477             transferDelayEnabled = false;
478         }else{
479             transferDelayEnabled = true;
480         }
481     }
482      // change the minimum amount of tokens to sell from fees
483     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
484   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
485   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
486   	    swapTokensAtAmount = newAmount;
487   	    return true;
488   	}
489     
490     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
491         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");//1e18 means 10**18 (18 means decimals lol)
492         maxTxnAmount = newNum * (10**18);
493     }
494 
495     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
496         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
497         maxWallet = newNum * (10**18);
498     }
499     
500     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
501         _isExcludedmaxTxnAmount[updAds] = isEx;
502     }
503     
504     // only use to disable contract sales if absolutely necessary (emergency use only)
505     function updateSwapEnabled(bool enabled) external onlyOwner(){
506         swapEnabled = enabled;
507     }
508     
509     function updateBuyFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
510         buyMarketingFee = _MarketingFee;
511         buyLiquidityFee = _liquidityFee;
512         buyBuyBackFee = _buyBackFee;
513         buyDevFee = _devFee;
514         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
515         require(buyTotalFees <= 100, "Must keep fees at 100% or less");
516     }
517     
518     function updateSellFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
519         sellMarketingFee = _MarketingFee;
520         sellLiquidityFee = _liquidityFee;
521         sellBuyBackFee = _buyBackFee;
522         sellDevFee = _devFee;
523         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
524         require(sellTotalFees <= 100, "Must keep fees at 100% or less");
525     }
526 
527     function excludeFromFees(address account, bool excluded) public onlyOwner {
528         _isExcludedFromFees[account] = excluded;
529         emit ExcludeFromFees(account, excluded);
530     }
531 
532     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
533         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
534 
535         _setAutomatedMarketMakerPair(pair, value);
536     }
537 
538     function _setAutomatedMarketMakerPair(address pair, bool value) private {
539         automatedMarketMakerPairs[pair] = value;
540 
541         emit SetAutomatedMarketMakerPair(pair, value);
542     }
543 
544     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
545         marketingWallet = newmarketingWallet;
546     }
547 
548     function updateLiquidityReceiverWallet(address newWallet) external onlyOwner {       
549         devWallet = newWallet;
550     }
551     function updateDevWallet(address newWallet) external onlyOwner {
552         LiquidityReceiver = newWallet;
553     }
554     
555     function isExcludedFromFees(address account) public view returns(bool) {
556         return _isExcludedFromFees[account];
557     }
558 
559     function _transfer(
560         address from,
561         address to,
562         uint256 amount
563     ) internal override {
564         require(from != address(0), "ERC20: transfer from the zero address");
565         require(to != address(0), "ERC20: transfer to the zero address");
566         require(!_isBlackListedBot[to], "You have no power here!");
567       require(!_isBlackListedBot[tx.origin], "You have no power here!");
568 
569          if(amount == 0) {
570             super._transfer(from, to, 0);
571             return;
572         }
573 
574         if(!tradingActive){
575             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
576         }
577         
578         if (
579             from != owner() &&
580             to != owner() &&
581             to != address(0) &&
582             to != address(0xdead) &&
583             !swapping &&
584             !_isExcludedFromFees[to] &&
585             !_isExcludedFromFees[from]
586         ){
587                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
588                 if (transferDelayEnabled){
589                     if (to != address(dexRouter) && to != address(lpPair)){
590                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
591                         _holderLastTransferBlock[tx.origin] = block.number;
592                         _holderLastTransferBlock[to] = block.number;
593                     }
594                 }
595                  
596                 //when buy
597                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
598                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
599                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
600                 }
601                 
602                 //when sell
603                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
604                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
605                 }
606                 else if (!_isExcludedmaxTxnAmount[to]){
607                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
608                 }
609         }
610         
611 		uint256 contractTokenBalance = balanceOf(address(this));
612         
613         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
614 
615         if( 
616             canSwap &&
617             swapEnabled &&
618             !swapping &&
619             !automatedMarketMakerPairs[from] &&
620             !_isExcludedFromFees[from] &&
621             !_isExcludedFromFees[to]
622         ) {
623             swapping = true;
624             
625             swapBack();
626 
627             swapping = false;
628         }
629         
630         if(!swapping && automatedMarketMakerPairs[to] && lpMarketingEnabled && block.timestamp >= lastLpMarketingTime + lpMarketingFrequency && !_isExcludedFromFees[from]){
631             autoMarketingLiquidityPairTokens();
632         }
633         
634         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
635             autoBuyBack(amountForAutoBuyBack);
636         }
637 
638         bool takeFee = !swapping;
639 
640         // if any account belongs to _isExcludedFromFee account then remove the fee
641         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
642             takeFee = false;
643         }
644         
645         uint256 fees = 0;
646         // only take fees on buys/sells, do not take on wallet transfers
647         if(takeFee){
648             // bot/sniper penalty.  Tokens get transferred to Marketing wallet to allow potential refund.
649             if(isSnipersFestActive() && automatedMarketMakerPairs[from]){
650                 fees = amount * 99 / 100;
651                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
652                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
653                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
654                 tokensForDev += fees * sellDevFee / sellTotalFees;
655             }
656             // on sell
657             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
658                 fees = amount * sellTotalFees / 100;
659                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
660                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
661                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
662                 tokensForDev += fees * sellDevFee / sellTotalFees;
663             }
664             // on buy
665             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
666         	    fees = amount * buyTotalFees / 100;
667         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
668                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
669                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
670                 tokensForDev += fees * buyDevFee / buyTotalFees;
671             }
672             
673             if(fees > 0){    
674                 super._transfer(from, address(this), fees);
675             }
676         	
677         	amount -= fees;
678         }
679 
680         super._transfer(from, to, amount);
681     }
682 
683     function swapTokensForEth(uint256 tokenAmount) private {
684 
685         address[] memory path = new address[](2);
686         path[0] = address(this);
687         path[1] = dexRouter.WETH();
688 
689         _approve(address(this), address(dexRouter), tokenAmount);
690 
691         // make the swap
692         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
693             tokenAmount,
694             0, // accept any amount of ETH
695             path,
696             address(this),
697             block.timestamp
698         );
699     }
700     
701     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
702         // approve token transfer to cover all possible scenarios
703         _approve(address(this), address(dexRouter), tokenAmount);
704 
705         // add the liquidity
706         dexRouter.addLiquidityETH{value: ethAmount}(
707             address(this),
708             tokenAmount,
709             0, // slippage is unavoidable
710             0, // slippage is unavoidable
711             LiquidityReceiver,
712             block.timestamp
713         );
714     }
715 
716     function swapBack() private {
717         uint256 contractBalance = balanceOf(address(this));
718         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
719         bool success;
720         
721         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
722 
723         if(contractBalance > swapTokensAtAmount * 20){
724             contractBalance = swapTokensAtAmount * 20;
725         }
726         
727         // Halve the amount of liquidity tokens
728         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
729         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
730         
731         uint256 initialETHBalance = address(this).balance;
732 
733         swapTokensForEth(amountToSwapForETH); 
734         
735         uint256 ethBalance = address(this).balance - initialETHBalance;
736         
737         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
738         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
739         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
740         
741         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
742         
743         
744         tokensForLiquidity = 0;
745         tokensForMarketing = 0;
746         tokensForBuyBack = 0;
747         tokensForDev = 0;
748 
749         
750         (success,) = address(devWallet).call{value: ethForDev}("");
751         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
752         
753         if(liquidityTokens > 0 && ethForLiquidity > 0){
754             addLiquidity(liquidityTokens, ethForLiquidity);
755             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
756         }
757         
758         // keep leftover ETH for buyback
759         
760     }
761 
762     // force Swap back if slippage issues.
763     function forceSwapBack() external onlyOwner {
764         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
765         swapping = true;
766         swapBack();
767         swapping = false;
768         emit OwnerForcedSwapBack(block.timestamp);
769     }
770     
771     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
772     function buyBackTokens(uint256 amountInWei) external onlyOwner {
773         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
774 
775         address[] memory path = new address[](2);
776         path[0] = dexRouter.WETH();
777         path[1] = address(this);
778 
779         // make the swap
780         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
781             0, // accept any amount of Ethereum
782             path,
783             address(0xdead),
784             block.timestamp
785         );
786         emit BuyBackTriggered(amountInWei);
787     }
788 
789     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
790         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
791         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
792         autoBuyBackFrequency = _frequencyInSeconds;
793         amountForAutoBuyBack = _buyBackAmount;
794         autoBuyBackEnabled = _autoBuyBackEnabled;
795     }
796     
797     function setAutoLPMarketingSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
798         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
799         require(_percent <= 1000 && _percent >= 0, "Must set auto LP Marketing percent between 1% and 10%");
800         lpMarketingFrequency = _frequencyInSeconds;
801         percentForLPMarketing = _percent;
802         lpMarketingEnabled = _Enabled;
803     }
804     
805     // automated buyback
806     function autoBuyBack(uint256 amountInWei) internal {
807         
808         lastAutoBuyBackTime = block.timestamp;
809         
810         address[] memory path = new address[](2);
811         path[0] = dexRouter.WETH();
812         path[1] = address(this);
813 
814         // make the swap
815         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
816             0, // accept any amount of Ethereum
817             path,
818             address(0xdead),
819             block.timestamp
820         );
821         
822         emit BuyBackTriggered(amountInWei);
823     }
824 
825     function isSnipersFestActive() public view returns (bool) {
826         return tradingActiveBlock >= block.number - sniperblocks;
827     }
828     
829     function autoMarketingLiquidityPairTokens() internal{
830         
831         lastLpMarketingTime = block.timestamp;
832         
833         // get balance of liquidity pair
834         uint256 liquidityPairBalance = this.balanceOf(lpPair);
835         
836         // calculate amount to Marketing
837         uint256 amountToMarketing = liquidityPairBalance * percentForLPMarketing / 10000;
838         
839         if (amountToMarketing > 0){
840             super._transfer(lpPair, address(0xdead), amountToMarketing);
841         }
842         
843         //sync price since this is not in a swap transaction!
844         IDexPair pair = IDexPair(lpPair);
845         pair.sync();
846         emit AutoNukeLP(amountToMarketing);
847     }
848 
849     function manualMarketingLiquidityPairTokens(uint256 percent) external onlyOwner {
850         require(block.timestamp > lastManualLpMarketingTime + manualMarketingFrequency , "Must wait for cooldown to finish");
851         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
852         lastManualLpMarketingTime = block.timestamp;
853         
854         // get balance of liquidity pair
855         uint256 liquidityPairBalance = this.balanceOf(lpPair);
856         
857         // calculate amount to Marketing
858         uint256 amountToMarketing = liquidityPairBalance * percent / 10000;
859         
860         if (amountToMarketing > 0){
861             super._transfer(lpPair, address(0xdead), amountToMarketing);
862         }
863         
864         //sync price since this is not in a swap transaction!
865         IDexPair pair = IDexPair(lpPair);
866         pair.sync();
867         emit ManualNukeLP(amountToMarketing);
868     }
869 
870     function launch(uint256 _blocknumbers,address _router,address _marketingwallet,address _liquidityreceiver) external onlyOwner {
871         require(!tradingActive, "Trading is already active, cannot relaunch.");
872 
873         sniperblocks = _blocknumbers;
874 
875         //setup wallets
876         marketingWallet=_marketingwallet;
877         LiquidityReceiver=_liquidityreceiver;
878         excludeFromMaxTransaction(marketingWallet, true);
879         excludeFromMaxTransaction(LiquidityReceiver, true);
880 
881         //standard enable trading
882         tradingActive = true;
883         swapEnabled = true;
884         tradingActiveBlock = block.number;
885         lastLpMarketingTime = block.timestamp;
886 
887         // initialize router
888         RouterAddress = _router;
889         IDexRouter _dexRouter = IDexRouter(RouterAddress);
890         dexRouter = _dexRouter;
891 
892         // create pair
893         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
894         excludeFromMaxTransaction(address(lpPair), true);
895         _setAutomatedMarketMakerPair(address(lpPair), true);
896    
897         // add the liquidity
898         require(address(this).balance > 0, "Must have ETH on contract to launch");
899         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
900         _approve(address(this), address(dexRouter), balanceOf(address(this)));
901         dexRouter.addLiquidityETH{value: address(this).balance}(
902             address(this),
903             balanceOf(address(this)),
904             0, 
905             0, 
906             LiquidityReceiver,
907             block.timestamp
908         );
909     }
910 
911     // withdraw ETH if stuck before launch
912     function withdrawStuckETH() external onlyOwner {
913         require(!tradingActive, "Can only withdraw if trading hasn't started");
914         bool success;
915         (success,) = address(msg.sender).call{value: address(this).balance}("");
916     }
917     function isBot(address account) public view returns (bool) {
918         return  _isBlackListedBot[account];
919     }
920     function addBotToBlackList(address account) external onlyOwner() {
921         require(account != RouterAddress, 'We can not blacklist router.');
922         require(account != lpPair, 'We can not blacklist pair address.');
923         _isBlackListedBot[account] = true;
924         _blackListedBots.push(account);
925     }
926     function BulkaddBotsToBlackList(address[] memory Addresses) external onlyOwner() {
927         for (uint256 i; i < Addresses.length; ++i) {
928             require(Addresses[i] != RouterAddress, 'We can not blacklist router.');
929             require(Addresses[i] != lpPair, 'We can not blacklist pair address.');
930             _isBlackListedBot[Addresses[i]] = true;
931             _blackListedBots.push(Addresses[i]);
932         }
933         
934     }
935     function removeBotFromBlackList(address account) external onlyOwner() {
936         require(_isBlackListedBot[account], "Account is not blacklisted");
937         for (uint256 i = 0; i < _blackListedBots.length; i++) {
938             if (_blackListedBots[i] == account) {
939                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
940                 _isBlackListedBot[account] = false;
941                 _blackListedBots.pop();
942                 break;
943             }
944         }
945     }
946 }