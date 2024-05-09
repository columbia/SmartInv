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
328 contract BlazeInu is ERC20, Ownable {
329 
330     IDexRouter public dexRouter;
331     address public lpPair;
332     address public constant deadAddress = address(0xdead);
333 
334     bool private swapping;
335 
336     address public marketingWallet;
337     address public devWallet;
338     
339    
340     uint256 private blockPenalty;
341 
342     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
343 
344     uint256 public maxTxnAmount;
345     uint256 public swapTokensAtAmount;
346     uint256 public maxWallet;
347 
348 
349     uint256 public amountForAutoBuyBack = 0.2 ether;
350     bool public autoBuyBackEnabled = true;
351     uint256 public autoBuyBackFrequency = 3600 seconds;
352     uint256 public lastAutoBuyBackTime;
353     
354     uint256 public percentForLPBurn = 100; // 100 = 1%
355     bool public lpBurnEnabled = true;
356     uint256 public lpBurnFrequency = 3600 seconds;
357     uint256 public lastLpBurnTime;
358     
359     uint256 public manualBurnFrequency = 1 hours;
360     uint256 public lastManualLpBurnTime;
361 
362     bool public limitsInEffect = true;
363     bool public tradingActive = false;
364     bool public swapEnabled = false;
365     
366      // Anti-bot and anti-whale mappings and variables
367     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
368     bool public transferDelayEnabled = true;
369 
370     uint256 public buyTotalFees;
371     uint256 public buyMarketingFee;
372     uint256 public buyLiquidityFee;
373     uint256 public buyBuyBackFee;
374     uint256 public buyDevFee;
375     
376     uint256 public sellTotalFees;
377     uint256 public sellMarketingFee;
378     uint256 public sellLiquidityFee;
379     uint256 public sellBuyBackFee;
380     uint256 public sellDevFee;
381     
382     uint256 public tokensForMarketing;
383     uint256 public tokensForLiquidity;
384     uint256 public tokensForBuyBack;
385     uint256 public tokensForDev;
386     
387     /******************/
388 
389     // exlcude from fees and max transaction amount
390     mapping (address => bool) private _isExcludedFromFees;
391     mapping (address => bool) public _isExcludedmaxTxnAmount;
392 
393     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
394     // could be subject to a maximum transfer amount
395     mapping (address => bool) public automatedMarketMakerPairs;
396 
397     event ExcludeFromFees(address indexed account, bool isExcluded);
398 
399     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
400 
401     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
402 
403     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
404 
405     event SwapAndLiquify(
406         uint256 tokensSwapped,
407         uint256 ethReceived,
408         uint256 tokensIntoLiquidity
409     );
410     
411     event AutoNukeLP(uint256 amount);
412     
413     event ManualNukeLP(uint256 amount);
414     
415     event BuyBackTriggered(uint256 amount);
416 
417     event OwnerForcedSwapBack(uint256 timestamp);
418 
419     constructor() ERC20("", "") payable {
420                 
421         uint256 _buyMarketingFee = 3;
422         uint256 _buyLiquidityFee = 3;
423         uint256 _buyBuyBackFee = 1;
424         uint256 _buyDevFee = 1;
425 
426         uint256 _sellMarketingFee = 10;
427         uint256 _sellLiquidityFee = 14;
428         uint256 _sellBuyBackFee = 4;
429         uint256 _sellDevFee = 2;
430         
431         uint256 totalSupply = 10 * 1e12 * 1e18;
432         
433         maxTxnAmount = totalSupply * 5 / 1000;
434         maxWallet = totalSupply * 1 / 100; // 1% maxWallet
435         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap amount
436 
437         buyMarketingFee = _buyMarketingFee;
438         buyLiquidityFee = _buyLiquidityFee;
439         buyBuyBackFee = _buyBuyBackFee;
440         buyDevFee = _buyDevFee;
441         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
442         
443         sellMarketingFee = _sellMarketingFee;
444         sellLiquidityFee = _sellLiquidityFee;
445         sellBuyBackFee = _sellBuyBackFee;
446         sellDevFee = _sellDevFee;
447         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
448         
449     	marketingWallet = address(0xb24d88c9671A505fDC7126EC42D3bB651bea1886); // set as marketing wallet
450         devWallet = address(msg.sender);
451 
452         // exclude from paying fees or having max transaction amount
453         excludeFromFees(owner(), true);
454         excludeFromFees(marketingWallet, true);
455         excludeFromFees(address(this), true);
456         excludeFromFees(address(0xdead), true);
457         excludeFromFees(0x67469f99D1db2D2EE86589e8Bff95a4a91e28B48, true); // future owner wallet
458         
459         excludeFromMaxTransaction(owner(), true);
460         excludeFromMaxTransaction(marketingWallet, true);
461         excludeFromMaxTransaction(address(this), true);
462         excludeFromMaxTransaction(address(0xdead), true);
463         excludeFromMaxTransaction(0x67469f99D1db2D2EE86589e8Bff95a4a91e28B48, true);
464         
465         /*
466             _createInitialSupply is an internal function that is only called here,
467             and CANNOT be called ever again
468         */
469 
470         _createInitialSupply(0x67469f99D1db2D2EE86589e8Bff95a4a91e28B48, totalSupply*20/100);
471         _createInitialSupply(address(this), totalSupply*80/100);
472     }
473 
474     receive() external payable {
475 
476   	}
477     
478     // remove limits after token is stable
479     function removeLimits() external onlyOwner {
480         limitsInEffect = false;
481     }
482     
483     // disable Transfer delay - cannot be reenabled
484     function disableTransferDelay() external onlyOwner {
485         transferDelayEnabled = false;
486     }
487     
488      // change the minimum amount of tokens to sell from fees
489     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
490   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
491   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
492   	    swapTokensAtAmount = newAmount;
493   	    return true;
494   	}
495     
496     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
497         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");
498         maxTxnAmount = newNum * (10**18);
499     }
500 
501     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
502         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
503         maxWallet = newNum * (10**18);
504     }
505     
506     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
507         _isExcludedmaxTxnAmount[updAds] = isEx;
508     }
509     
510     // only use to disable contract sales if absolutely necessary (emergency use only)
511     function updateSwapEnabled(bool enabled) external onlyOwner(){
512         swapEnabled = enabled;
513     }
514     
515     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
516         buyMarketingFee = _marketingFee;
517         buyLiquidityFee = _liquidityFee;
518         buyBuyBackFee = _buyBackFee;
519         buyDevFee = _devFee;
520         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
521         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
522     }
523     
524     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
525         sellMarketingFee = _marketingFee;
526         sellLiquidityFee = _liquidityFee;
527         sellBuyBackFee = _buyBackFee;
528         sellDevFee = _devFee;
529         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
530         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
531     }
532 
533     function excludeFromFees(address account, bool excluded) public onlyOwner {
534         _isExcludedFromFees[account] = excluded;
535         emit ExcludeFromFees(account, excluded);
536     }
537 
538     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
539         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
540 
541         _setAutomatedMarketMakerPair(pair, value);
542     }
543 
544     function _setAutomatedMarketMakerPair(address pair, bool value) private {
545         automatedMarketMakerPairs[pair] = value;
546 
547         emit SetAutomatedMarketMakerPair(pair, value);
548     }
549 
550     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
551         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
552         marketingWallet = newMarketingWallet;
553     }
554 
555     function updateDevWallet(address newWallet) external onlyOwner {
556         emit DevWalletUpdated(newWallet, devWallet);
557         devWallet = newWallet;
558     }
559 
560     function isExcludedFromFees(address account) public view returns(bool) {
561         return _isExcludedFromFees[account];
562     }
563 
564     function _transfer(
565         address from,
566         address to,
567         uint256 amount
568     ) internal override {
569         require(from != address(0), "ERC20: transfer from the zero address");
570         require(to != address(0), "ERC20: transfer to the zero address");
571         
572          if(amount == 0) {
573             super._transfer(from, to, 0);
574             return;
575         }
576 
577         if(!tradingActive){
578             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
579         }
580         
581         if(limitsInEffect){
582             if (
583                 from != owner() &&
584                 to != owner() &&
585                 to != address(0) &&
586                 to != address(0xdead) &&
587                 !swapping &&
588                 !_isExcludedFromFees[to] &&
589                 !_isExcludedFromFees[from]
590             ){
591                 
592                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
593                 if (transferDelayEnabled){
594                     if (to != address(dexRouter) && to != address(lpPair)){
595                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
596                         _holderLastTransferBlock[tx.origin] = block.number;
597                         _holderLastTransferBlock[to] = block.number;
598                     }
599                 }
600                  
601                 //when buy
602                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
603                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
604                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
605                 }
606                 
607                 //when sell
608                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
609                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
610                 }
611                 else if (!_isExcludedmaxTxnAmount[to]){
612                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
613                 }
614             }
615         }
616         
617 		uint256 contractTokenBalance = balanceOf(address(this));
618         
619         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
620 
621         if( 
622             canSwap &&
623             swapEnabled &&
624             !swapping &&
625             !automatedMarketMakerPairs[from] &&
626             !_isExcludedFromFees[from] &&
627             !_isExcludedFromFees[to]
628         ) {
629             swapping = true;
630             
631             swapBack();
632 
633             swapping = false;
634         }
635         
636         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
637             autoBurnLiquidityPairTokens();
638         }
639         
640         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
641             autoBuyBack(amountForAutoBuyBack);
642         }
643 
644         bool takeFee = !swapping;
645 
646         // if any account belongs to _isExcludedFromFee account then remove the fee
647         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
648             takeFee = false;
649         }
650         
651         uint256 fees = 0;
652         // only take fees on buys/sells, do not take on wallet transfers
653         if(takeFee){
654             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
655             if(isPenaltyActive() && automatedMarketMakerPairs[from]){
656                 fees = amount * 99 / 100;
657                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
658                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
659                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
660                 tokensForDev += fees * sellDevFee / sellTotalFees;
661             }
662             // on sell
663             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
664                 fees = amount * sellTotalFees / 100;
665                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
666                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
667                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
668                 tokensForDev += fees * sellDevFee / sellTotalFees;
669             }
670             // on buy
671             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
672         	    fees = amount * buyTotalFees / 100;
673         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
674                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
675                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
676                 tokensForDev += fees * buyDevFee / buyTotalFees;
677             }
678             
679             if(fees > 0){    
680                 super._transfer(from, address(this), fees);
681             }
682         	
683         	amount -= fees;
684         }
685 
686         super._transfer(from, to, amount);
687     }
688 
689     function swapTokensForEth(uint256 tokenAmount) private {
690 
691         address[] memory path = new address[](2);
692         path[0] = address(this);
693         path[1] = dexRouter.WETH();
694 
695         _approve(address(this), address(dexRouter), tokenAmount);
696 
697         // make the swap
698         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
699             tokenAmount,
700             0, // accept any amount of ETH
701             path,
702             address(this),
703             block.timestamp
704         );
705     }
706     
707     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
708         // approve token transfer to cover all possible scenarios
709         _approve(address(this), address(dexRouter), tokenAmount);
710 
711         // add the liquidity
712         dexRouter.addLiquidityETH{value: ethAmount}(
713             address(this),
714             tokenAmount,
715             0, // slippage is unavoidable
716             0, // slippage is unavoidable
717             deadAddress,
718             block.timestamp
719         );
720     }
721 
722     function swapBack() private {
723         uint256 contractBalance = balanceOf(address(this));
724         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
725         bool success;
726         
727         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
728 
729         if(contractBalance > swapTokensAtAmount * 20){
730             contractBalance = swapTokensAtAmount * 20;
731         }
732         
733         // Halve the amount of liquidity tokens
734         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
735         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
736         
737         uint256 initialETHBalance = address(this).balance;
738 
739         swapTokensForEth(amountToSwapForETH); 
740         
741         uint256 ethBalance = address(this).balance - initialETHBalance;
742         
743         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
744         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
745         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
746         
747         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
748         
749         
750         tokensForLiquidity = 0;
751         tokensForMarketing = 0;
752         tokensForBuyBack = 0;
753         tokensForDev = 0;
754 
755         
756         (success,) = address(devWallet).call{value: ethForDev}("");
757         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
758         
759         if(liquidityTokens > 0 && ethForLiquidity > 0){
760             addLiquidity(liquidityTokens, ethForLiquidity);
761             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
762         }
763         
764         // keep leftover ETH for buyback
765         
766     }
767 
768     // force Swap back if slippage issues.
769     function forceSwapBack() external onlyOwner {
770         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
771         swapping = true;
772         swapBack();
773         swapping = false;
774         emit OwnerForcedSwapBack(block.timestamp);
775     }
776     
777     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
778     function buyBackTokens(uint256 amountInWei) external onlyOwner {
779         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
780 
781         address[] memory path = new address[](2);
782         path[0] = dexRouter.WETH();
783         path[1] = address(this);
784 
785         // make the swap
786         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
787             0, // accept any amount of Ethereum
788             path,
789             address(0xdead),
790             block.timestamp
791         );
792         emit BuyBackTriggered(amountInWei);
793     }
794 
795     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
796         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
797         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
798         autoBuyBackFrequency = _frequencyInSeconds;
799         amountForAutoBuyBack = _buyBackAmount;
800         autoBuyBackEnabled = _autoBuyBackEnabled;
801     }
802     
803     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
804         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
805         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 1% and 10%");
806         lpBurnFrequency = _frequencyInSeconds;
807         percentForLPBurn = _percent;
808         lpBurnEnabled = _Enabled;
809     }
810     
811     // automated buyback
812     function autoBuyBack(uint256 amountInWei) internal {
813         
814         lastAutoBuyBackTime = block.timestamp;
815         
816         address[] memory path = new address[](2);
817         path[0] = dexRouter.WETH();
818         path[1] = address(this);
819 
820         // make the swap
821         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
822             0, // accept any amount of Ethereum
823             path,
824             address(0xdead),
825             block.timestamp
826         );
827         
828         emit BuyBackTriggered(amountInWei);
829     }
830 
831     function isPenaltyActive() public view returns (bool) {
832         return tradingActiveBlock >= block.number - blockPenalty;
833     }
834     
835     function autoBurnLiquidityPairTokens() internal{
836         
837         lastLpBurnTime = block.timestamp;
838         
839         // get balance of liquidity pair
840         uint256 liquidityPairBalance = this.balanceOf(lpPair);
841         
842         // calculate amount to burn
843         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;
844         
845         if (amountToBurn > 0){
846             super._transfer(lpPair, address(0xdead), amountToBurn);
847         }
848         
849         //sync price since this is not in a swap transaction!
850         IDexPair pair = IDexPair(lpPair);
851         pair.sync();
852         emit AutoNukeLP(amountToBurn);
853     }
854 
855     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
856         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
857         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
858         lastManualLpBurnTime = block.timestamp;
859         
860         // get balance of liquidity pair
861         uint256 liquidityPairBalance = this.balanceOf(lpPair);
862         
863         // calculate amount to burn
864         uint256 amountToBurn = liquidityPairBalance * percent / 10000;
865         
866         if (amountToBurn > 0){
867             super._transfer(lpPair, address(0xdead), amountToBurn);
868         }
869         
870         //sync price since this is not in a swap transaction!
871         IDexPair pair = IDexPair(lpPair);
872         pair.sync();
873         emit ManualNukeLP(amountToBurn);
874     }
875 
876     function launch(uint256 _blockPenalty) external onlyOwner {
877         require(!tradingActive, "Trading is already active, cannot relaunch.");
878 
879         blockPenalty = _blockPenalty;
880 
881         //update name/ticker
882         _name = "Blaze Inu";
883         _symbol = "BLAZE";
884 
885         //standard enable trading
886         tradingActive = true;
887         swapEnabled = true;
888         tradingActiveBlock = block.number;
889         lastLpBurnTime = block.timestamp;
890 
891         // initialize router
892         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
893         dexRouter = _dexRouter;
894 
895         // create pair
896         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
897         excludeFromMaxTransaction(address(lpPair), true);
898         _setAutomatedMarketMakerPair(address(lpPair), true);
899    
900         // add the liquidity
901         require(address(this).balance > 0, "Must have ETH on contract to launch");
902         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
903         _approve(address(this), address(dexRouter), balanceOf(address(this)));
904         dexRouter.addLiquidityETH{value: address(this).balance}(
905             address(this),
906             balanceOf(address(this)),
907             0, // slippage is unavoidable
908             0, // slippage is unavoidable
909             0x67469f99D1db2D2EE86589e8Bff95a4a91e28B48,
910             block.timestamp
911         );
912     }
913 
914     // withdraw ETH if stuck before launch
915     function withdrawStuckETH() external onlyOwner {
916         require(!tradingActive, "Can only withdraw if trading hasn't started");
917         bool success;
918         (success,) = address(msg.sender).call{value: address(this).balance}("");
919     }
920 }