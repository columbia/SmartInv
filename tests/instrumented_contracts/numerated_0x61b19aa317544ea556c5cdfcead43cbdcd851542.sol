1 /**
2 YAKUZA INU {$YIN} 
3 
4 Pledge Allegiance To Crypto! 
5 Members of Yakuza gangs cut their family ties and transfer their loyalty to the gang boss. 
6 They refer to each other as family members—fathers, elders and younger brothers.
7 */
8 
9 // SPDX-License-Identifier: MIT                                                                               
10                                                     
11 pragma solidity 0.8.11;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IDexPair {
25     function sync() external;
26 }
27 
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 interface IERC20Metadata is IERC20 {
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() external view returns (string memory);
108 
109     /**
110      * @dev Returns the symbol of the token.
111      */
112     function symbol() external view returns (string memory);
113 
114     /**
115      * @dev Returns the decimals places of the token.
116      */
117     function decimals() external view returns (uint8);
118 }
119 
120 
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     mapping(address => uint256) private _balances;
123 
124     mapping(address => mapping(address => uint256)) private _allowances;
125 
126     uint256 private _totalSupply;
127 
128     string public _name;
129     string public _symbol;
130 
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139 
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147 
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(address account) public view virtual override returns (uint256) {
153         return _balances[account];
154     }
155 
156     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
157         _transfer(_msgSender(), recipient, amount);
158         return true;
159     }
160 
161     function allowance(address owner, address spender) public view virtual override returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169 
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176 
177         uint256 currentAllowance = _allowances[sender][_msgSender()];
178         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
179         unchecked {
180             _approve(sender, _msgSender(), currentAllowance - amount);
181         }
182 
183         return true;
184     }
185 
186     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
188         return true;
189     }
190 
191     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
192         uint256 currentAllowance = _allowances[_msgSender()][spender];
193         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
194         unchecked {
195             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
196         }
197 
198         return true;
199     }
200 
201     function _transfer(
202         address sender,
203         address recipient,
204         uint256 amount
205     ) internal virtual {
206         require(sender != address(0), "ERC20: transfer from the zero address");
207         require(recipient != address(0), "ERC20: transfer to the zero address");
208 
209         uint256 senderBalance = _balances[sender];
210         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
211         unchecked {
212             _balances[sender] = senderBalance - amount;
213         }
214         _balances[recipient] += amount;
215 
216         emit Transfer(sender, recipient, amount);
217     }
218 
219     function _createInitialSupply(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: mint to the zero address");
221 
222         _totalSupply += amount;
223         _balances[account] += amount;
224         emit Transfer(address(0), account, amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234 
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 }
239 
240 
241 contract Ownable is Context {
242     address private _owner;
243 
244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
245     
246     /**
247      * @dev Initializes the contract setting the deployer as the initial owner.
248      */
249     constructor () {
250         address msgSender = _msgSender();
251         _owner = msgSender;
252         emit OwnershipTransferred(address(0), msgSender);
253     }
254 
255     /**
256      * @dev Returns the address of the current owner.
257      */
258     function owner() public view returns (address) {
259         return _owner;
260     }
261 
262     /**
263      * @dev Throws if called by any account other than the owner.
264      */
265     modifier onlyOwner() {
266         require(_owner == _msgSender(), "Ownable: caller is not the owner");
267         _;
268     }
269 
270     /**
271      * @dev Leaves the contract without owner. It will not be possible to call
272      * `onlyOwner` functions anymore. Can only be called by the current owner.
273      *
274      * NOTE: Renouncing ownership will leave the contract without an owner,
275      * thereby removing any functionality that is only available to the owner.
276      */
277     function renounceOwnership() external virtual onlyOwner {
278         emit OwnershipTransferred(_owner, address(0));
279         _owner = address(0);
280     }
281 
282     /**
283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
284      * Can only be called by the current owner.
285      */
286     function transferOwnership(address newOwner) external virtual onlyOwner {
287         require(newOwner != address(0), "Ownable: new owner is the zero address");
288         emit OwnershipTransferred(_owner, newOwner);
289         _owner = newOwner;
290     }
291 }
292 
293 interface IDexRouter {
294     function factory() external pure returns (address);
295     function WETH() external pure returns (address);
296     
297     function swapExactTokensForETHSupportingFeeOnTransferTokens(
298         uint amountIn,
299         uint amountOutMin,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external;
304 
305     function swapExactETHForTokensSupportingFeeOnTransferTokens(
306         uint amountOutMin,
307         address[] calldata path,
308         address to,
309         uint deadline
310     ) external payable;
311 
312     function addLiquidityETH(
313         address token,
314         uint256 amountTokenDesired,
315         uint256 amountTokenMin,
316         uint256 amountETHMin,
317         address to,
318         uint256 deadline
319     )
320         external
321         payable
322         returns (
323             uint256 amountToken,
324             uint256 amountETH,
325             uint256 liquidity
326         );
327         
328 }
329 
330 interface IDexFactory {
331     function createPair(address tokenA, address tokenB)
332         external
333         returns (address pair);
334 }
335 
336 contract YAKUZA is ERC20, Ownable {
337 
338     IDexRouter public dexRouter;
339     address public lpPair;
340     address public constant deadAddress = address(0xdead);
341 
342     bool private swapping;
343 
344     address public marketingWallet;
345     address public devWallet;
346     
347    
348     uint256 private blockPenalty;
349 
350     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
351 
352     uint256 public maxTxnAmount;
353     uint256 public swapTokensAtAmount;
354     uint256 public maxWallet;
355 
356 
357     uint256 public amountForAutoBuyBack = 0.2 ether;
358     bool public autoBuyBackEnabled = true;
359     uint256 public autoBuyBackFrequency = 3600 seconds;
360     uint256 public lastAutoBuyBackTime;
361     
362     uint256 public percentForLPBurn = 100; // 100 = 1%
363     bool public lpBurnEnabled = true;
364     uint256 public lpBurnFrequency = 3600 seconds;
365     uint256 public lastLpBurnTime;
366     
367     uint256 public manualBurnFrequency = 1 hours;
368     uint256 public lastManualLpBurnTime;
369 
370     bool public limitsInEffect = true;
371     bool public tradingActive = false;
372     bool public swapEnabled = false;
373     
374      // Anti-bot and anti-whale mappings and variables
375     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
376     bool public transferDelayEnabled = true;
377 
378     uint256 public buyTotalFees;
379     uint256 public buyMarketingFee;
380     uint256 public buyLiquidityFee;
381     uint256 public buyBuyBackFee;
382     uint256 public buyDevFee;
383     
384     uint256 public sellTotalFees;
385     uint256 public sellMarketingFee;
386     uint256 public sellLiquidityFee;
387     uint256 public sellBuyBackFee;
388     uint256 public sellDevFee;
389     
390     uint256 public tokensForMarketing;
391     uint256 public tokensForLiquidity;
392     uint256 public tokensForBuyBack;
393     uint256 public tokensForDev;
394     
395     /******************/
396 
397     // exlcude from fees and max transaction amount
398     mapping (address => bool) private _isExcludedFromFees;
399     mapping (address => bool) public _isExcludedmaxTxnAmount;
400 
401     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
402     // could be subject to a maximum transfer amount
403     mapping (address => bool) public automatedMarketMakerPairs;
404 
405     event ExcludeFromFees(address indexed account, bool isExcluded);
406 
407     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
408 
409     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
410 
411     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
412 
413     event SwapAndLiquify(
414         uint256 tokensSwapped,
415         uint256 ethReceived,
416         uint256 tokensIntoLiquidity
417     );
418     
419     event AutoNukeLP(uint256 amount);
420     
421     event ManualNukeLP(uint256 amount);
422     
423     event BuyBackTriggered(uint256 amount);
424 
425     event OwnerForcedSwapBack(uint256 timestamp);
426 
427     constructor() ERC20("YAKUZA INU", "YIN") payable {
428                 
429         uint256 _buyMarketingFee = 2;
430         uint256 _buyLiquidityFee = 1;
431         uint256 _buyBuyBackFee = 1;
432         uint256 _buyDevFee = 1;
433 
434         uint256 _sellMarketingFee = 2;
435         uint256 _sellLiquidityFee = 1;
436         uint256 _sellBuyBackFee = 1;
437         uint256 _sellDevFee = 1;
438         
439         uint256 totalSupply = 100 * 1e6 * 1e18;
440         
441         maxTxnAmount = totalSupply * 3 / 100; // 3% of supply
442         maxWallet = totalSupply * 3 / 100; // 3% maxWallet
443         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap amount
444 
445         buyMarketingFee = _buyMarketingFee;
446         buyLiquidityFee = _buyLiquidityFee;
447         buyBuyBackFee = _buyBuyBackFee;
448         buyDevFee = _buyDevFee;
449         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
450         
451         sellMarketingFee = _sellMarketingFee;
452         sellLiquidityFee = _sellLiquidityFee;
453         sellBuyBackFee = _sellBuyBackFee;
454         sellDevFee = _sellDevFee;
455         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
456         
457     	marketingWallet = address(0x47Fee184E376c290b8E30d875Fa2cbC931e206EA); // set as marketing wallet
458         devWallet = address(msg.sender);
459 
460         // exclude from paying fees or having max transaction amount
461         excludeFromFees(owner(), true);
462         excludeFromFees(marketingWallet, true);
463         excludeFromFees(address(this), true);
464         excludeFromFees(address(0xdead), true);
465         excludeFromFees(0x9ea26E87A3D2D6Ea81e5DB144C8eF33804fC097d, true); // future owner wallet
466         
467         excludeFromMaxTransaction(owner(), true);
468         excludeFromMaxTransaction(marketingWallet, true);
469         excludeFromMaxTransaction(address(this), true);
470         excludeFromMaxTransaction(address(0xdead), true);
471         excludeFromMaxTransaction(0x9ea26E87A3D2D6Ea81e5DB144C8eF33804fC097d, true);
472         
473         /*
474             _createInitialSupply is an internal function that is only called here,
475             and CANNOT be called ever again
476         */
477 
478         _createInitialSupply(0x9ea26E87A3D2D6Ea81e5DB144C8eF33804fC097d, totalSupply*10/100);
479         _createInitialSupply(address(this), totalSupply*90/100);
480     }
481 
482     receive() external payable {
483 
484     
485   	}
486        mapping (address => bool) private _isBlackListedBot;
487     address[] private _blackListedBots;
488    
489     
490     // remove limits after token is stable
491     function removeLimits() external onlyOwner {
492         limitsInEffect = false;
493     }
494     
495     // disable Transfer delay - cannot be reenabled
496     function disableTransferDelay() external onlyOwner {
497         transferDelayEnabled = false;
498     }
499     
500      // change the minimum amount of tokens to sell from fees
501     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
502   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
503   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
504   	    swapTokensAtAmount = newAmount;
505   	    return true;
506   	}
507     
508     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
509         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");
510         maxTxnAmount = newNum * (10**18);
511     }
512 
513     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
514         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
515         maxWallet = newNum * (10**18);
516     }
517     
518     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
519         _isExcludedmaxTxnAmount[updAds] = isEx;
520     }
521     
522     // only use to disable contract sales if absolutely necessary (emergency use only)
523     function updateSwapEnabled(bool enabled) external onlyOwner(){
524         swapEnabled = enabled;
525     }
526     
527     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
528         buyMarketingFee = _marketingFee;
529         buyLiquidityFee = _liquidityFee;
530         buyBuyBackFee = _buyBackFee;
531         buyDevFee = _devFee;
532         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
533         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
534     }
535     
536     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
537         sellMarketingFee = _marketingFee;
538         sellLiquidityFee = _liquidityFee;
539         sellBuyBackFee = _buyBackFee;
540         sellDevFee = _devFee;
541         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
542         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
543     }
544 
545     function excludeFromFees(address account, bool excluded) public onlyOwner {
546         _isExcludedFromFees[account] = excluded;
547         emit ExcludeFromFees(account, excluded);
548     }
549 
550     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
551         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
552 
553         _setAutomatedMarketMakerPair(pair, value);
554     }
555 
556     function _setAutomatedMarketMakerPair(address pair, bool value) private {
557         automatedMarketMakerPairs[pair] = value;
558 
559         emit SetAutomatedMarketMakerPair(pair, value);
560     }
561 
562     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
563         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
564         marketingWallet = newMarketingWallet;
565     }
566 
567     function updateDevWallet(address newWallet) external onlyOwner {
568         emit DevWalletUpdated(newWallet, devWallet);
569         devWallet = newWallet;
570     }
571 
572     function isExcludedFromFees(address account) public view returns(bool) {
573         return _isExcludedFromFees[account];
574     }
575 
576     function _transfer(
577         address from,
578         address to,
579         uint256 amount
580     ) internal override {
581         require(from != address(0), "ERC20: transfer from the zero address");
582         require(to != address(0), "ERC20: transfer to the zero address");
583         require(!_isBlackListedBot[to], "You have no power here!");
584       require(!_isBlackListedBot[tx.origin], "You have no power here!");
585 
586          if(amount == 0) {
587             super._transfer(from, to, 0);
588             return;
589         }
590 
591         if(!tradingActive){
592             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
593         }
594         
595         if(limitsInEffect){
596             if (
597                 from != owner() &&
598                 to != owner() &&
599                 to != address(0) &&
600                 to != address(0xdead) &&
601                 !swapping &&
602                 !_isExcludedFromFees[to] &&
603                 !_isExcludedFromFees[from]
604             ){
605                 
606                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
607                 if (transferDelayEnabled){
608                     if (to != address(dexRouter) && to != address(lpPair)){
609                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
610                         _holderLastTransferBlock[tx.origin] = block.number;
611                         _holderLastTransferBlock[to] = block.number;
612                     }
613                 }
614                  
615                 //when buy
616                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
617                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
618                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
619                 }
620                 
621                 //when sell
622                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
623                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
624                 }
625                 else if (!_isExcludedmaxTxnAmount[to]){
626                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
627                 }
628             }
629         }
630         
631 		uint256 contractTokenBalance = balanceOf(address(this));
632         
633         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
634 
635         if( 
636             canSwap &&
637             swapEnabled &&
638             !swapping &&
639             !automatedMarketMakerPairs[from] &&
640             !_isExcludedFromFees[from] &&
641             !_isExcludedFromFees[to]
642         ) {
643             swapping = true;
644             
645             swapBack();
646 
647             swapping = false;
648         }
649         
650         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
651             autoBurnLiquidityPairTokens();
652         }
653         
654         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
655             autoBuyBack(amountForAutoBuyBack);
656         }
657 
658         bool takeFee = !swapping;
659 
660         // if any account belongs to _isExcludedFromFee account then remove the fee
661         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
662             takeFee = false;
663         }
664         
665         uint256 fees = 0;
666         // only take fees on buys/sells, do not take on wallet transfers
667         if(takeFee){
668             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
669             if(isPenaltyActive() && automatedMarketMakerPairs[from]){
670                 fees = amount * 99 / 100;
671                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
672                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
673                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
674                 tokensForDev += fees * sellDevFee / sellTotalFees;
675             }
676             // on sell
677             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
678                 fees = amount * sellTotalFees / 100;
679                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
680                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
681                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
682                 tokensForDev += fees * sellDevFee / sellTotalFees;
683             }
684             // on buy
685             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
686         	    fees = amount * buyTotalFees / 100;
687         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
688                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
689                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
690                 tokensForDev += fees * buyDevFee / buyTotalFees;
691             }
692             
693             if(fees > 0){    
694                 super._transfer(from, address(this), fees);
695             }
696         	
697         	amount -= fees;
698         }
699 
700         super._transfer(from, to, amount);
701     }
702 
703     function swapTokensForEth(uint256 tokenAmount) private {
704 
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
731             deadAddress,
732             block.timestamp
733         );
734     }
735 
736     function swapBack() private {
737         uint256 contractBalance = balanceOf(address(this));
738         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
739         bool success;
740         
741         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
742 
743         if(contractBalance > swapTokensAtAmount * 20){
744             contractBalance = swapTokensAtAmount * 20;
745         }
746         
747         // Halve the amount of liquidity tokens
748         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
749         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
750         
751         uint256 initialETHBalance = address(this).balance;
752 
753         swapTokensForEth(amountToSwapForETH); 
754         
755         uint256 ethBalance = address(this).balance - initialETHBalance;
756         
757         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
758         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
759         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
760         
761         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
762         
763         
764         tokensForLiquidity = 0;
765         tokensForMarketing = 0;
766         tokensForBuyBack = 0;
767         tokensForDev = 0;
768 
769         
770         (success,) = address(devWallet).call{value: ethForDev}("");
771         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
772         
773         if(liquidityTokens > 0 && ethForLiquidity > 0){
774             addLiquidity(liquidityTokens, ethForLiquidity);
775             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
776         }
777         
778         // keep leftover ETH for buyback
779         
780     }
781 
782     // force Swap back if slippage issues.
783     function forceSwapBack() external onlyOwner {
784         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
785         swapping = true;
786         swapBack();
787         swapping = false;
788         emit OwnerForcedSwapBack(block.timestamp);
789     }
790     
791     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
792     function buyBackTokens(uint256 amountInWei) external onlyOwner {
793         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
794 
795         address[] memory path = new address[](2);
796         path[0] = dexRouter.WETH();
797         path[1] = address(this);
798 
799         // make the swap
800         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
801             0, // accept any amount of Ethereum
802             path,
803             address(0xdead),
804             block.timestamp
805         );
806         emit BuyBackTriggered(amountInWei);
807     }
808 
809     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
810         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
811         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
812         autoBuyBackFrequency = _frequencyInSeconds;
813         amountForAutoBuyBack = _buyBackAmount;
814         autoBuyBackEnabled = _autoBuyBackEnabled;
815     }
816     
817     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
818         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
819         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 1% and 10%");
820         lpBurnFrequency = _frequencyInSeconds;
821         percentForLPBurn = _percent;
822         lpBurnEnabled = _Enabled;
823     }
824     
825     // automated buyback
826     function autoBuyBack(uint256 amountInWei) internal {
827         
828         lastAutoBuyBackTime = block.timestamp;
829         
830         address[] memory path = new address[](2);
831         path[0] = dexRouter.WETH();
832         path[1] = address(this);
833 
834         // make the swap
835         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
836             0, // accept any amount of Ethereum
837             path,
838             address(0xdead),
839             block.timestamp
840         );
841         
842         emit BuyBackTriggered(amountInWei);
843     }
844 
845     function isPenaltyActive() public view returns (bool) {
846         return tradingActiveBlock >= block.number - blockPenalty;
847     }
848     
849     function autoBurnLiquidityPairTokens() internal{
850         
851         lastLpBurnTime = block.timestamp;
852         
853         // get balance of liquidity pair
854         uint256 liquidityPairBalance = this.balanceOf(lpPair);
855         
856         // calculate amount to burn
857         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;
858         
859         if (amountToBurn > 0){
860             super._transfer(lpPair, address(0xdead), amountToBurn);
861         }
862         
863         //sync price since this is not in a swap transaction!
864         IDexPair pair = IDexPair(lpPair);
865         pair.sync();
866         emit AutoNukeLP(amountToBurn);
867     }
868 
869     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
870         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
871         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
872         lastManualLpBurnTime = block.timestamp;
873         
874         // get balance of liquidity pair
875         uint256 liquidityPairBalance = this.balanceOf(lpPair);
876         
877         // calculate amount to burn
878         uint256 amountToBurn = liquidityPairBalance * percent / 10000;
879         
880         if (amountToBurn > 0){
881             super._transfer(lpPair, address(0xdead), amountToBurn);
882         }
883         
884         //sync price since this is not in a swap transaction!
885         IDexPair pair = IDexPair(lpPair);
886         pair.sync();
887         emit ManualNukeLP(amountToBurn);
888     }
889 
890     function launch(uint256 _blockPenalty) external onlyOwner {
891         require(!tradingActive, "Trading is already active, cannot relaunch.");
892 
893         blockPenalty = _blockPenalty;
894 
895         //update name/ticker
896         _name = "YAKUZA INU";
897         _symbol = "YIN";
898 
899         //standard enable trading
900         tradingActive = true;
901         swapEnabled = true;
902         tradingActiveBlock = block.number;
903         lastLpBurnTime = block.timestamp;
904 
905         // initialize router
906         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
907         dexRouter = _dexRouter;
908 
909         // create pair
910         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
911         excludeFromMaxTransaction(address(lpPair), true);
912         _setAutomatedMarketMakerPair(address(lpPair), true);
913    
914         // add the liquidity
915         require(address(this).balance > 0, "Must have ETH on contract to launch");
916         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
917         _approve(address(this), address(dexRouter), balanceOf(address(this)));
918         dexRouter.addLiquidityETH{value: address(this).balance}(
919             address(this),
920             balanceOf(address(this)),
921             0, // slippage is unavoidable
922             0, // slippage is unavoidable
923             0xcFE9E8D5C919765f03cD4750daC8e8fAA66e27B7,
924             block.timestamp
925         );
926     }
927 
928     // withdraw ETH if stuck before launch
929     function withdrawStuckETH() external onlyOwner {
930         require(!tradingActive, "Can only withdraw if trading hasn't started");
931         bool success;
932         (success,) = address(msg.sender).call{value: address(this).balance}("");
933     }
934       function isBot(address account) public view returns (bool) {
935         return  _isBlackListedBot[account];
936     }
937   function addBotToBlackList(address account) external onlyOwner() {
938         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
939         require(!_isBlackListedBot[account], "Account is already blacklisted");
940         _isBlackListedBot[account] = true;
941         _blackListedBots.push(account);
942     }
943     
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