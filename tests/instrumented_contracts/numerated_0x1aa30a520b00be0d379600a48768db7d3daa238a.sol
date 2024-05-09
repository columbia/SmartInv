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
16 interface IDexPair {
17     function sync() external;
18 }
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 
113 contract ERC20 is Context, IERC20, IERC20Metadata {
114     mapping(address => uint256) private _balances;
115 
116     mapping(address => mapping(address => uint256)) private _allowances;
117 
118     uint256 private _totalSupply;
119 
120     string public _name;
121     string public _symbol;
122 
123     constructor(string memory name_, string memory symbol_) {
124         _name = name_;
125         _symbol = symbol_;
126     }
127 
128     function name() public view virtual override returns (string memory) {
129         return _name;
130     }
131 
132     function symbol() public view virtual override returns (string memory) {
133         return _symbol;
134     }
135 
136     function decimals() public view virtual override returns (uint8) {
137         return 18;
138     }
139 
140     function totalSupply() public view virtual override returns (uint256) {
141         return _totalSupply;
142     }
143 
144     function balanceOf(address account) public view virtual override returns (uint256) {
145         return _balances[account];
146     }
147 
148     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
149         _transfer(_msgSender(), recipient, amount);
150         return true;
151     }
152 
153     function allowance(address owner, address spender) public view virtual override returns (uint256) {
154         return _allowances[owner][spender];
155     }
156 
157     function approve(address spender, uint256 amount) public virtual override returns (bool) {
158         _approve(_msgSender(), spender, amount);
159         return true;
160     }
161 
162     function transferFrom(
163         address sender,
164         address recipient,
165         uint256 amount
166     ) public virtual override returns (bool) {
167         _transfer(sender, recipient, amount);
168 
169         uint256 currentAllowance = _allowances[sender][_msgSender()];
170         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
171         unchecked {
172             _approve(sender, _msgSender(), currentAllowance - amount);
173         }
174 
175         return true;
176     }
177 
178     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
180         return true;
181     }
182 
183     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
184         uint256 currentAllowance = _allowances[_msgSender()][spender];
185         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
186         unchecked {
187             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
188         }
189 
190         return true;
191     }
192 
193     function _transfer(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) internal virtual {
198         require(sender != address(0), "ERC20: transfer from the zero address");
199         require(recipient != address(0), "ERC20: transfer to the zero address");
200 
201         uint256 senderBalance = _balances[sender];
202         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
203         unchecked {
204             _balances[sender] = senderBalance - amount;
205         }
206         _balances[recipient] += amount;
207 
208         emit Transfer(sender, recipient, amount);
209     }
210 
211     function _createInitialSupply(address account, uint256 amount) internal virtual {
212         require(account != address(0), "ERC20: mint to the zero address");
213 
214         _totalSupply += amount;
215         _balances[account] += amount;
216         emit Transfer(address(0), account, amount);
217     }
218 
219     function _approve(
220         address owner,
221         address spender,
222         uint256 amount
223     ) internal virtual {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226 
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 }
231 
232 
233 contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237     
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor () {
242         address msgSender = _msgSender();
243         _owner = msgSender;
244         emit OwnershipTransferred(address(0), msgSender);
245     }
246 
247     /**
248      * @dev Returns the address of the current owner.
249      */
250     function owner() public view returns (address) {
251         return _owner;
252     }
253 
254     /**
255      * @dev Throws if called by any account other than the owner.
256      */
257     modifier onlyOwner() {
258         require(_owner == _msgSender(), "Ownable: caller is not the owner");
259         _;
260     }
261 
262     /**
263      * @dev Leaves the contract without owner. It will not be possible to call
264      * `onlyOwner` functions anymore. Can only be called by the current owner.
265      *
266      * NOTE: Renouncing ownership will leave the contract without an owner,
267      * thereby removing any functionality that is only available to the owner.
268      */
269     function renounceOwnership() external virtual onlyOwner {
270         emit OwnershipTransferred(_owner, address(0));
271         _owner = address(0);
272     }
273 
274     /**
275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
276      * Can only be called by the current owner.
277      */
278     function transferOwnership(address newOwner) external virtual onlyOwner {
279         require(newOwner != address(0), "Ownable: new owner is the zero address");
280         emit OwnershipTransferred(_owner, newOwner);
281         _owner = newOwner;
282     }
283 }
284 
285 interface IDexRouter {
286     function factory() external pure returns (address);
287     function WETH() external pure returns (address);
288     
289     function swapExactTokensForETHSupportingFeeOnTransferTokens(
290         uint amountIn,
291         uint amountOutMin,
292         address[] calldata path,
293         address to,
294         uint deadline
295     ) external;
296 
297     function swapExactETHForTokensSupportingFeeOnTransferTokens(
298         uint amountOutMin,
299         address[] calldata path,
300         address to,
301         uint deadline
302     ) external payable;
303 
304     function addLiquidityETH(
305         address token,
306         uint256 amountTokenDesired,
307         uint256 amountTokenMin,
308         uint256 amountETHMin,
309         address to,
310         uint256 deadline
311     )
312         external
313         payable
314         returns (
315             uint256 amountToken,
316             uint256 amountETH,
317             uint256 liquidity
318         );
319         
320 }
321 
322 interface IDexFactory {
323     function createPair(address tokenA, address tokenB)
324         external
325         returns (address pair);
326 }
327 
328 contract FuckTheDevs is ERC20, Ownable {
329 
330     IDexRouter public dexRouter;
331     address public lpPair;
332     address public constant deadAddress = address(0xdead);
333 
334     bool private swapping;
335 
336     address public marketingWallet;
337     address public devWallet;
338     address public RouterAddress;
339     address public LiquidityReceiver;
340     
341    
342     uint256 private sniperblocks;
343 
344     uint256 public tradingActiveBlock = 0;
345 
346     uint256 public maxTxnAmount;
347     uint256 public swapTokensAtAmount;
348     uint256 public maxWallet;
349 
350 
351     uint256 public amountForAutoBuyBack = 0 ether;
352     bool public autoBuyBackEnabled = false;
353     uint256 public autoBuyBackFrequency = 0 seconds;
354     uint256 public lastAutoBuyBackTime;
355     
356     uint256 public percentForLPMarketing = 0; // 100 = 1%
357     bool public lpMarketingEnabled = false;
358     uint256 public lpMarketingFrequency = 0 seconds;
359     uint256 public lastLpMarketingTime;
360     
361     uint256 public manualMarketingFrequency = 1 hours;
362     uint256 public lastManualLpMarketingTime;
363 
364     bool public tradingActive = false;
365     bool public swapEnabled = false;
366     
367      // prevent more than 1 buy on same block this may cuz rug check bots to fail but helpful on launches 
368     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
369     bool public transferDelayEnabled = true;
370 
371     uint256 public buyTotalFees;
372     uint256 public buyMarketingFee;
373     uint256 public buyLiquidityFee;
374     uint256 public buyBuyBackFee;
375     uint256 public buyDevFee;
376     
377     uint256 public sellTotalFees;
378     uint256 public sellMarketingFee;
379     uint256 public sellLiquidityFee;
380     uint256 public sellBuyBackFee;
381     uint256 public sellDevFee;
382     
383     uint256 public tokensForMarketing;
384     uint256 public tokensForLiquidity;
385     uint256 public tokensForBuyBack;
386     uint256 public tokensForDev;
387     
388     /******************/
389 
390     // exlcude from fees and max transaction amount
391     mapping (address => bool) private _isExcludedFromFees;
392     mapping (address => bool) public _isExcludedmaxTxnAmount;
393 
394     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
395     // could be subject to a maximum transfer amount
396     mapping (address => bool) public automatedMarketMakerPairs;
397 
398     event ExcludeFromFees(address indexed account, bool isExcluded);
399 
400     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
401 
402     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
403 
404     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
405 
406     event SwapAndLiquify(
407         uint256 tokensSwapped,
408         uint256 ethReceived,
409         uint256 tokensIntoLiquidity
410     );
411     
412     event AutoNukeLP(uint256 amount);
413     
414     event ManualNukeLP(uint256 amount);
415     
416     event BuyBackTriggered(uint256 amount);
417 
418     event OwnerForcedSwapBack(uint256 timestamp);
419 
420     constructor() ERC20("FuckTheDevs", "$FTD") payable {
421                 
422         uint256 _buyMarketingFee = 4;
423         uint256 _buyLiquidityFee = 1;
424         uint256 _buyBuyBackFee = 0;
425         uint256 _buyDevFee = 0;
426 
427         uint256 _sellMarketingFee = 4;
428         uint256 _sellLiquidityFee = 1;
429         uint256 _sellBuyBackFee = 0;
430         uint256 _sellDevFee = 0;
431         
432         uint256 totalSupply = 1e8 * 10   * 1e18;
433         
434         maxTxnAmount = totalSupply * 1 / 100; // 1% of supply
435         maxWallet = totalSupply * 1 / 100; // 1% maxWallet
436         swapTokensAtAmount = totalSupply * 5 / 1000; // 0.5% swap amount
437 
438         buyMarketingFee = _buyMarketingFee;
439         buyLiquidityFee = _buyLiquidityFee;
440         buyBuyBackFee = _buyBuyBackFee;
441         buyDevFee = _buyDevFee;
442         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
443         
444         sellMarketingFee = _sellMarketingFee;
445         sellLiquidityFee = _sellLiquidityFee;
446         sellBuyBackFee = _sellBuyBackFee;
447         sellDevFee = _sellDevFee;
448         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
449         
450     	marketingWallet = address(owner());
451         devWallet = address(owner());
452 
453         // exclude from paying fees or having max transaction amount
454         excludeFromFees(owner(), true);
455         excludeFromFees(address(this), true);
456         
457         
458         excludeFromMaxTransaction(owner(), true);
459         excludeFromMaxTransaction(address(this), true);
460         
461         _createInitialSupply(address(this), totalSupply*100/100);
462     }
463 
464     receive() external payable {
465 
466     
467   	}
468     mapping (address => bool) private _isBlackListedBot;
469     address[] private _blackListedBots;
470    
471        
472     // Toggle Transfer delay
473     function ToggleTransferDelay() external onlyOwner {        
474         if(transferDelayEnabled==true){
475             transferDelayEnabled = false;
476         }else{
477             transferDelayEnabled = true;
478         }
479     }
480      // change the minimum amount of tokens to sell from fees
481     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
482   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
483   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
484   	    swapTokensAtAmount = newAmount;
485   	    return true;
486   	}
487     
488     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
489         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");//1e18 means 10**18 (18 means decimals lol)
490         maxTxnAmount = newNum * (10**18);
491     }
492 
493     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
494         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
495         maxWallet = newNum * (10**18);
496     }
497     
498     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
499         _isExcludedmaxTxnAmount[updAds] = isEx;
500     }
501     
502     // only use to disable contract sales if absolutely necessary (emergency use only)
503     function updateSwapEnabled(bool enabled) external onlyOwner(){
504         swapEnabled = enabled;
505     }
506     
507     function updateBuyFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
508         buyMarketingFee = _MarketingFee;
509         buyLiquidityFee = _liquidityFee;
510         buyBuyBackFee = _buyBackFee;
511         buyDevFee = _devFee;
512         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
513         require(buyTotalFees <= 100, "Must keep fees at 100% or less");
514     }
515     
516     function updateSellFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
517         sellMarketingFee = _MarketingFee;
518         sellLiquidityFee = _liquidityFee;
519         sellBuyBackFee = _buyBackFee;
520         sellDevFee = _devFee;
521         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
522         require(sellTotalFees <= 100, "Must keep fees at 100% or less");
523     }
524 
525     function excludeFromFees(address account, bool excluded) public onlyOwner {
526         _isExcludedFromFees[account] = excluded;
527         emit ExcludeFromFees(account, excluded);
528     }
529 
530     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
531         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
532 
533         _setAutomatedMarketMakerPair(pair, value);
534     }
535 
536     function _setAutomatedMarketMakerPair(address pair, bool value) private {
537         automatedMarketMakerPairs[pair] = value;
538 
539         emit SetAutomatedMarketMakerPair(pair, value);
540     }
541 
542     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
543         marketingWallet = newmarketingWallet;
544     }
545 
546     function updateLiquidityReceiverWallet(address newWallet) external onlyOwner {       
547         devWallet = newWallet;
548     }
549     function updateDevWallet(address newWallet) external onlyOwner {
550         LiquidityReceiver = newWallet;
551     }
552     
553     function isExcludedFromFees(address account) public view returns(bool) {
554         return _isExcludedFromFees[account];
555     }
556 
557     function _transfer(
558         address from,
559         address to,
560         uint256 amount
561     ) internal override {
562         require(from != address(0), "ERC20: transfer from the zero address");
563         require(to != address(0), "ERC20: transfer to the zero address");
564         require(!_isBlackListedBot[to], "You have no power here!");
565       require(!_isBlackListedBot[tx.origin], "You have no power here!");
566 
567          if(amount == 0) {
568             super._transfer(from, to, 0);
569             return;
570         }
571 
572         if(!tradingActive){
573             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
574         }
575         
576         if (
577             from != owner() &&
578             to != owner() &&
579             to != address(0) &&
580             to != address(0xdead) &&
581             !swapping &&
582             !_isExcludedFromFees[to] &&
583             !_isExcludedFromFees[from]
584         ){
585                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
586                 if (transferDelayEnabled){
587                     if (to != address(dexRouter) && to != address(lpPair)){
588                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
589                         _holderLastTransferBlock[tx.origin] = block.number;
590                         _holderLastTransferBlock[to] = block.number;
591                     }
592                 }
593                  
594                 //when buy
595                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
596                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
597                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
598                 }
599                 
600                 //when sell
601                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
602                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
603                 }
604                 else if (!_isExcludedmaxTxnAmount[to]){
605                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
606                 }
607         }
608         
609 		uint256 contractTokenBalance = balanceOf(address(this));
610         
611         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
612 
613         if( 
614             canSwap &&
615             swapEnabled &&
616             !swapping &&
617             !automatedMarketMakerPairs[from] &&
618             !_isExcludedFromFees[from] &&
619             !_isExcludedFromFees[to]
620         ) {
621             swapping = true;
622             
623             swapBack();
624 
625             swapping = false;
626         }
627         
628         if(!swapping && automatedMarketMakerPairs[to] && lpMarketingEnabled && block.timestamp >= lastLpMarketingTime + lpMarketingFrequency && !_isExcludedFromFees[from]){
629             autoMarketingLiquidityPairTokens();
630         }
631         
632         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
633             autoBuyBack(amountForAutoBuyBack);
634         }
635 
636         bool takeFee = !swapping;
637 
638         // if any account belongs to _isExcludedFromFee account then remove the fee
639         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
640             takeFee = false;
641         }
642         
643         uint256 fees = 0;
644         // only take fees on buys/sells, do not take on wallet transfers
645         if(takeFee){
646             // bot/sniper penalty.  Tokens get transferred to Marketing wallet to allow potential refund.
647             if(isSnipersFestActive() && automatedMarketMakerPairs[from]){
648                 fees = amount * 99 / 100;
649                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
650                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
651                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
652                 tokensForDev += fees * sellDevFee / sellTotalFees;
653             }
654             // on sell
655             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
656                 fees = amount * sellTotalFees / 100;
657                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
658                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
659                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
660                 tokensForDev += fees * sellDevFee / sellTotalFees;
661             }
662             // on buy
663             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
664         	    fees = amount * buyTotalFees / 100;
665         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
666                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
667                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
668                 tokensForDev += fees * buyDevFee / buyTotalFees;
669             }
670             
671             if(fees > 0){    
672                 super._transfer(from, address(this), fees);
673             }
674         	
675         	amount -= fees;
676         }
677 
678         super._transfer(from, to, amount);
679     }
680 
681     function swapTokensForEth(uint256 tokenAmount) private {
682 
683         address[] memory path = new address[](2);
684         path[0] = address(this);
685         path[1] = dexRouter.WETH();
686 
687         _approve(address(this), address(dexRouter), tokenAmount);
688 
689         // make the swap
690         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
691             tokenAmount,
692             0, // accept any amount of ETH
693             path,
694             address(this),
695             block.timestamp
696         );
697     }
698     
699     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
700         // approve token transfer to cover all possible scenarios
701         _approve(address(this), address(dexRouter), tokenAmount);
702 
703         // add the liquidity
704         dexRouter.addLiquidityETH{value: ethAmount}(
705             address(this),
706             tokenAmount,
707             0, // slippage is unavoidable
708             0, // slippage is unavoidable
709             LiquidityReceiver,
710             block.timestamp
711         );
712     }
713 
714     function swapBack() private {
715         uint256 contractBalance = balanceOf(address(this));
716         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
717         bool success;
718         
719         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
720 
721         if(contractBalance > swapTokensAtAmount * 20){
722             contractBalance = swapTokensAtAmount * 20;
723         }
724         
725         // Halve the amount of liquidity tokens
726         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
727         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
728         
729         uint256 initialETHBalance = address(this).balance;
730 
731         swapTokensForEth(amountToSwapForETH); 
732         
733         uint256 ethBalance = address(this).balance - initialETHBalance;
734         
735         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
736         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
737         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
738         
739         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
740         
741         
742         tokensForLiquidity = 0;
743         tokensForMarketing = 0;
744         tokensForBuyBack = 0;
745         tokensForDev = 0;
746 
747         
748         (success,) = address(devWallet).call{value: ethForDev}("");
749         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
750         
751         if(liquidityTokens > 0 && ethForLiquidity > 0){
752             addLiquidity(liquidityTokens, ethForLiquidity);
753             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
754         }
755         
756         // keep leftover ETH for buyback
757         
758     }
759 
760     // force Swap back if slippage issues.
761     function forceSwapBack() external onlyOwner {
762         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
763         swapping = true;
764         swapBack();
765         swapping = false;
766         emit OwnerForcedSwapBack(block.timestamp);
767     }
768     
769     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
770     function buyBackTokens(uint256 amountInWei) external onlyOwner {
771         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
772 
773         address[] memory path = new address[](2);
774         path[0] = dexRouter.WETH();
775         path[1] = address(this);
776 
777         // make the swap
778         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
779             0, // accept any amount of Ethereum
780             path,
781             address(0xdead),
782             block.timestamp
783         );
784         emit BuyBackTriggered(amountInWei);
785     }
786 
787     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
788         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
789         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
790         autoBuyBackFrequency = _frequencyInSeconds;
791         amountForAutoBuyBack = _buyBackAmount;
792         autoBuyBackEnabled = _autoBuyBackEnabled;
793     }
794     
795     function setAutoLPMarketingSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
796         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
797         require(_percent <= 1000 && _percent >= 0, "Must set auto LP Marketing percent between 1% and 10%");
798         lpMarketingFrequency = _frequencyInSeconds;
799         percentForLPMarketing = _percent;
800         lpMarketingEnabled = _Enabled;
801     }
802     
803     // automated buyback
804     function autoBuyBack(uint256 amountInWei) internal {
805         
806         lastAutoBuyBackTime = block.timestamp;
807         
808         address[] memory path = new address[](2);
809         path[0] = dexRouter.WETH();
810         path[1] = address(this);
811 
812         // make the swap
813         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
814             0, // accept any amount of Ethereum
815             path,
816             address(0xdead),
817             block.timestamp
818         );
819         
820         emit BuyBackTriggered(amountInWei);
821     }
822 
823     function isSnipersFestActive() public view returns (bool) {
824         return tradingActiveBlock >= block.number - sniperblocks;
825     }
826     
827     function autoMarketingLiquidityPairTokens() internal{
828         
829         lastLpMarketingTime = block.timestamp;
830         
831         // get balance of liquidity pair
832         uint256 liquidityPairBalance = this.balanceOf(lpPair);
833         
834         // calculate amount to Marketing
835         uint256 amountToMarketing = liquidityPairBalance * percentForLPMarketing / 10000;
836         
837         if (amountToMarketing > 0){
838             super._transfer(lpPair, address(0xdead), amountToMarketing);
839         }
840         
841         //sync price since this is not in a swap transaction!
842         IDexPair pair = IDexPair(lpPair);
843         pair.sync();
844         emit AutoNukeLP(amountToMarketing);
845     }
846 
847     function manualMarketingLiquidityPairTokens(uint256 percent) external onlyOwner {
848         require(block.timestamp > lastManualLpMarketingTime + manualMarketingFrequency , "Must wait for cooldown to finish");
849         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
850         lastManualLpMarketingTime = block.timestamp;
851         
852         // get balance of liquidity pair
853         uint256 liquidityPairBalance = this.balanceOf(lpPair);
854         
855         // calculate amount to Marketing
856         uint256 amountToMarketing = liquidityPairBalance * percent / 10000;
857         
858         if (amountToMarketing > 0){
859             super._transfer(lpPair, address(0xdead), amountToMarketing);
860         }
861         
862         //sync price since this is not in a swap transaction!
863         IDexPair pair = IDexPair(lpPair);
864         pair.sync();
865         emit ManualNukeLP(amountToMarketing);
866     }
867     function ActivateTrading(uint256 _blocknumbers) external onlyOwner {
868         require(!tradingActive, "Trading is already active, cannot relaunch.");
869         //standard enable trading
870         tradingActive = true;
871         swapEnabled = true;
872         tradingActiveBlock = block.number;
873         sniperblocks = _blocknumbers;
874     }
875     function launch(address _router,address _marketingwallet,address _liquidityreceiver) external onlyOwner {
876         require(!tradingActive, "Trading is already active, cannot relaunch.");
877 
878         
879 
880         //setup wallets
881         marketingWallet=_marketingwallet;
882         LiquidityReceiver=_liquidityreceiver;
883         excludeFromMaxTransaction(marketingWallet, true);
884         excludeFromMaxTransaction(LiquidityReceiver, true);
885 
886         
887         lastLpMarketingTime = block.timestamp;
888 
889         // initialize router
890         RouterAddress = _router;
891         IDexRouter _dexRouter = IDexRouter(RouterAddress);
892         dexRouter = _dexRouter;
893 
894         // create pair
895         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
896         excludeFromMaxTransaction(address(lpPair), true);
897         _setAutomatedMarketMakerPair(address(lpPair), true);
898    
899         // add the liquidity
900         require(address(this).balance > 0, "Must have ETH on contract to launch");
901         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
902         _approve(address(this), address(dexRouter), balanceOf(address(this)));
903         dexRouter.addLiquidityETH{value: address(this).balance}(
904             address(this),
905             balanceOf(address(this)),
906             0, 
907             0, 
908             owner(),
909             block.timestamp
910         );
911     }
912 
913     // withdraw ETH if stuck before launch
914     function withdrawStuckETH() external onlyOwner {
915         require(!tradingActive, "Can only withdraw if trading hasn't started");
916         bool success;
917         (success,) = address(msg.sender).call{value: address(this).balance}("");
918     }
919     function isBot(address account) public view returns (bool) {
920         return  _isBlackListedBot[account];
921     }
922     function addBotToBlackList(address account) external onlyOwner() {
923         require(account != RouterAddress, 'We can not blacklist router.');
924         require(account != lpPair, 'We can not blacklist pair address.');
925         _isBlackListedBot[account] = true;
926         _blackListedBots.push(account);
927     }
928     function BulkaddBotsToBlackList(address[] memory Addresses) external onlyOwner() {
929         for (uint256 i; i < Addresses.length; ++i) {
930             require(Addresses[i] != RouterAddress, 'We can not blacklist router.');
931             require(Addresses[i] != lpPair, 'We can not blacklist pair address.');
932             _isBlackListedBot[Addresses[i]] = true;
933             _blackListedBots.push(Addresses[i]);
934         }
935         
936     }
937     function removeBotFromBlackList(address account) external onlyOwner() {
938         require(_isBlackListedBot[account], "Account is not blacklisted");
939         for (uint256 i = 0; i < _blackListedBots.length; i++) {
940             if (_blackListedBots[i] == account) {
941                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
942                 _isBlackListedBot[account] = false;
943                 _blackListedBots.pop();
944                 break;
945             }
946         }
947     }
948 }