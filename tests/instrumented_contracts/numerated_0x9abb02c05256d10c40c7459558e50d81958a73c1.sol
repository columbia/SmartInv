1 /**
2 
3 */
4 
5 /**
6 https://twitter.com/MiladyArmy
7 https://t.me/MiladyArmy
8 */
9 // SPDX-License-Identifier: MIT                                                                               
10                                                     
11 pragma solidity 0.8.17;
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
336 contract MILADYARMY is ERC20, Ownable {
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
409     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
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
427     constructor() ERC20("MILADYARMY", "MARMY") payable {
428                 
429         uint256 _buyMarketingFee = 8;
430         uint256 _buyLiquidityFee = 0;
431         uint256 _buyBuyBackFee = 0;
432         uint256 _buyDevFee = 17;
433 
434         uint256 _sellMarketingFee = 10;
435         uint256 _sellLiquidityFee = 0;
436         uint256 _sellBuyBackFee = 0;
437         uint256 _sellDevFee = 25;
438         
439         uint256 totalSupply = 1000000 * 1e5 * 1e18;
440         
441         maxTxnAmount = totalSupply * 2 / 100; // 2% of supply
442         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
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
457     	marketingWallet = address(0x0Aff42Ca6bd687A4CCf1f9499a675d2618Ff156A); // set as Marketing wallet
458         devWallet = address(0x4F1305b56A489d99e18e151947256CF29Ed6172A); //set as devolper wallet
459 
460         // exclude from paying fees or having max transaction amount
461         excludeFromFees(owner(), true);
462         excludeFromFees(marketingWallet, true);
463         excludeFromFees(address(this), true);
464         excludeFromFees(0x0Aff42Ca6bd687A4CCf1f9499a675d2618Ff156A, true);
465         excludeFromFees(0x4F1305b56A489d99e18e151947256CF29Ed6172A, true); // future owner wallet
466         
467         excludeFromMaxTransaction(owner(), true);
468         excludeFromMaxTransaction(marketingWallet, true);
469         excludeFromMaxTransaction(address(this), true);
470         excludeFromMaxTransaction(0x0Aff42Ca6bd687A4CCf1f9499a675d2618Ff156A, true);
471         excludeFromMaxTransaction(0x4F1305b56A489d99e18e151947256CF29Ed6172A, true);
472         
473         /*
474             _createInitialSupply is an internal function that is only called here,
475             and CANNOT be called ever again
476         */
477         _createInitialSupply(address(this), totalSupply*100/100);
478     }
479 
480     receive() external payable {
481 
482     
483   	}
484        mapping (address => bool) private _isBlackListedBot;
485     address[] private _blackListedBots;
486    
487     
488     // remove limits after token is stable
489     function removeLimits() external onlyOwner {
490         limitsInEffect = false;
491     }
492     
493     // disable Transfer delay - cannot be reenabled
494     function disableTransferDelay() external onlyOwner {
495         transferDelayEnabled = false;
496     }
497     
498      // change the minimum amount of tokens to sell from fees
499     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
500   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
501   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
502   	    swapTokensAtAmount = newAmount;
503   	    return true;
504   	}
505     
506     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
507         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");
508         maxTxnAmount = newNum * (10**18);
509     }
510 
511     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
512         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
513         maxWallet = newNum * (10**18);
514     }
515     
516     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
517         _isExcludedmaxTxnAmount[updAds] = isEx;
518     }
519     
520     // only use to disable contract sales if absolutely necessary (emergency use only)
521     function updateSwapEnabled(bool enabled) external onlyOwner(){
522         swapEnabled = enabled;
523     }
524     
525     function updateBuyFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
526         buyMarketingFee = _MarketingFee;
527         buyLiquidityFee = _liquidityFee;
528         buyBuyBackFee = _buyBackFee;
529         buyDevFee = _devFee;
530         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
531         require(buyTotalFees <= 100, "Must keep fees at 100% or less");
532     }
533     
534     function updateSellFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
535         sellMarketingFee = _MarketingFee;
536         sellLiquidityFee = _liquidityFee;
537         sellBuyBackFee = _buyBackFee;
538         sellDevFee = _devFee;
539         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
540         require(sellTotalFees <= 100, "Must keep fees at 100% or less");
541     }
542 
543     function excludeFromFees(address account, bool excluded) public onlyOwner {
544         _isExcludedFromFees[account] = excluded;
545         emit ExcludeFromFees(account, excluded);
546     }
547 
548     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
549         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
550 
551         _setAutomatedMarketMakerPair(pair, value);
552     }
553 
554     function _setAutomatedMarketMakerPair(address pair, bool value) private {
555         automatedMarketMakerPairs[pair] = value;
556 
557         emit SetAutomatedMarketMakerPair(pair, value);
558     }
559 
560     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
561         emit marketingWalletUpdated(newmarketingWallet, marketingWallet);
562         marketingWallet = newmarketingWallet;
563     }
564 
565     function updateDevWallet(address newWallet) external onlyOwner {
566         emit DevWalletUpdated(newWallet, devWallet);
567         devWallet = newWallet;
568     }
569 
570     function isExcludedFromFees(address account) public view returns(bool) {
571         return _isExcludedFromFees[account];
572     }
573 
574     function _transfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal override {
579         require(from != address(0), "ERC20: transfer from the zero address");
580         require(to != address(0), "ERC20: transfer to the zero address");
581         require(!_isBlackListedBot[to], "You have no power here!");
582       require(!_isBlackListedBot[tx.origin], "You have no power here!");
583 
584          if(amount == 0) {
585             super._transfer(from, to, 0);
586             return;
587         }
588 
589         if(!tradingActive){
590             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
591         }
592         
593         if(limitsInEffect){
594             if (
595                 from != owner() &&
596                 to != owner() &&
597                 to != address(0) &&
598                 to != address(0xdead) &&
599                 !swapping &&
600                 !_isExcludedFromFees[to] &&
601                 !_isExcludedFromFees[from]
602             ){
603                 
604                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
605                 if (transferDelayEnabled){
606                     if (to != address(dexRouter) && to != address(lpPair)){
607                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
608                         _holderLastTransferBlock[tx.origin] = block.number;
609                         _holderLastTransferBlock[to] = block.number;
610                     }
611                 }
612                  
613                 //when buy
614                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
615                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
616                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
617                 }
618                 
619                 //when sell
620                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
621                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
622                 }
623                 else if (!_isExcludedmaxTxnAmount[to]){
624                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
625                 }
626             }
627         }
628         
629 		uint256 contractTokenBalance = balanceOf(address(this));
630         
631         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
632 
633         if( 
634             canSwap &&
635             swapEnabled &&
636             !swapping &&
637             !automatedMarketMakerPairs[from] &&
638             !_isExcludedFromFees[from] &&
639             !_isExcludedFromFees[to]
640         ) {
641             swapping = true;
642             
643             swapBack();
644 
645             swapping = false;
646         }
647         
648         if(!swapping && automatedMarketMakerPairs[to] && lpMarketingEnabled && block.timestamp >= lastLpMarketingTime + lpMarketingFrequency && !_isExcludedFromFees[from]){
649             autoMarketingLiquidityPairTokens();
650         }
651         
652         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
653             autoBuyBack(amountForAutoBuyBack);
654         }
655 
656         bool takeFee = !swapping;
657 
658         // if any account belongs to _isExcludedFromFee account then remove the fee
659         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
660             takeFee = false;
661         }
662         
663         uint256 fees = 0;
664         // only take fees on buys/sells, do not take on wallet transfers
665         if(takeFee){
666             // bot/sniper penalty.  Tokens get transferred to Marketing wallet to allow potential refund.
667             if(isPenaltyActive() && automatedMarketMakerPairs[from]){
668                 fees = amount * 99 / 100;
669                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
670                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
671                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
672                 tokensForDev += fees * sellDevFee / sellTotalFees;
673             }
674             // on sell
675             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
676                 fees = amount * sellTotalFees / 100;
677                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
678                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
679                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
680                 tokensForDev += fees * sellDevFee / sellTotalFees;
681             }
682             // on buy
683             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
684         	    fees = amount * buyTotalFees / 100;
685         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
686                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
687                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
688                 tokensForDev += fees * buyDevFee / buyTotalFees;
689             }
690             
691             if(fees > 0){    
692                 super._transfer(from, address(this), fees);
693             }
694         	
695         	amount -= fees;
696         }
697 
698         super._transfer(from, to, amount);
699     }
700 
701     function swapTokensForEth(uint256 tokenAmount) private {
702 
703         address[] memory path = new address[](2);
704         path[0] = address(this);
705         path[1] = dexRouter.WETH();
706 
707         _approve(address(this), address(dexRouter), tokenAmount);
708 
709         // make the swap
710         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
711             tokenAmount,
712             0, // accept any amount of ETH
713             path,
714             address(this),
715             block.timestamp
716         );
717     }
718     
719     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
720         // approve token transfer to cover all possible scenarios
721         _approve(address(this), address(dexRouter), tokenAmount);
722 
723         // add the liquidity
724         dexRouter.addLiquidityETH{value: ethAmount}(
725             address(this),
726             tokenAmount,
727             0, // slippage is unavoidable
728             0, // slippage is unavoidable
729             0x4F1305b56A489d99e18e151947256CF29Ed6172A,
730             block.timestamp
731         );
732     }
733 
734     function swapBack() private {
735         uint256 contractBalance = balanceOf(address(this));
736         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
737         bool success;
738         
739         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
740 
741         if(contractBalance > swapTokensAtAmount * 20){
742             contractBalance = swapTokensAtAmount * 20;
743         }
744         
745         // Halve the amount of liquidity tokens
746         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
747         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
748         
749         uint256 initialETHBalance = address(this).balance;
750 
751         swapTokensForEth(amountToSwapForETH); 
752         
753         uint256 ethBalance = address(this).balance - initialETHBalance;
754         
755         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
756         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
757         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
758         
759         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
760         
761         
762         tokensForLiquidity = 0;
763         tokensForMarketing = 0;
764         tokensForBuyBack = 0;
765         tokensForDev = 0;
766 
767         
768         (success,) = address(devWallet).call{value: ethForDev}("");
769         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
770         
771         if(liquidityTokens > 0 && ethForLiquidity > 0){
772             addLiquidity(liquidityTokens, ethForLiquidity);
773             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
774         }
775         
776         // keep leftover ETH for buyback
777         
778     }
779 
780     // force Swap back if slippage issues.
781     function forceSwapBack() external onlyOwner {
782         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
783         swapping = true;
784         swapBack();
785         swapping = false;
786         emit OwnerForcedSwapBack(block.timestamp);
787     }
788     
789     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
790     function buyBackTokens(uint256 amountInWei) external onlyOwner {
791         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
792 
793         address[] memory path = new address[](2);
794         path[0] = dexRouter.WETH();
795         path[1] = address(this);
796 
797         // make the swap
798         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
799             0, // accept any amount of Ethereum
800             path,
801             address(0xdead),
802             block.timestamp
803         );
804         emit BuyBackTriggered(amountInWei);
805     }
806 
807     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
808         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
809         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
810         autoBuyBackFrequency = _frequencyInSeconds;
811         amountForAutoBuyBack = _buyBackAmount;
812         autoBuyBackEnabled = _autoBuyBackEnabled;
813     }
814     
815     function setAutoLPMarketingSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
816         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
817         require(_percent <= 1000 && _percent >= 0, "Must set auto LP Marketing percent between 1% and 10%");
818         lpMarketingFrequency = _frequencyInSeconds;
819         percentForLPMarketing = _percent;
820         lpMarketingEnabled = _Enabled;
821     }
822     
823     // automated buyback
824     function autoBuyBack(uint256 amountInWei) internal {
825         
826         lastAutoBuyBackTime = block.timestamp;
827         
828         address[] memory path = new address[](2);
829         path[0] = dexRouter.WETH();
830         path[1] = address(this);
831 
832         // make the swap
833         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
834             0, // accept any amount of Ethereum
835             path,
836             address(0xdead),
837             block.timestamp
838         );
839         
840         emit BuyBackTriggered(amountInWei);
841     }
842 
843     function isPenaltyActive() public view returns (bool) {
844         return tradingActiveBlock >= block.number - blockPenalty;
845     }
846     
847     function autoMarketingLiquidityPairTokens() internal{
848         
849         lastLpMarketingTime = block.timestamp;
850         
851         // get balance of liquidity pair
852         uint256 liquidityPairBalance = this.balanceOf(lpPair);
853         
854         // calculate amount to Marketing
855         uint256 amountToMarketing = liquidityPairBalance * percentForLPMarketing / 10000;
856         
857         if (amountToMarketing > 0){
858             super._transfer(lpPair, address(0xdead), amountToMarketing);
859         }
860         
861         //sync price since this is not in a swap transaction!
862         IDexPair pair = IDexPair(lpPair);
863         pair.sync();
864         emit AutoNukeLP(amountToMarketing);
865     }
866 
867     function manualMarketingLiquidityPairTokens(uint256 percent) external onlyOwner {
868         require(block.timestamp > lastManualLpMarketingTime + manualMarketingFrequency , "Must wait for cooldown to finish");
869         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
870         lastManualLpMarketingTime = block.timestamp;
871         
872         // get balance of liquidity pair
873         uint256 liquidityPairBalance = this.balanceOf(lpPair);
874         
875         // calculate amount to Marketing
876         uint256 amountToMarketing = liquidityPairBalance * percent / 10000;
877         
878         if (amountToMarketing > 0){
879             super._transfer(lpPair, address(0xdead), amountToMarketing);
880         }
881         
882         //sync price since this is not in a swap transaction!
883         IDexPair pair = IDexPair(lpPair);
884         pair.sync();
885         emit ManualNukeLP(amountToMarketing);
886     }
887 
888     function launch(uint256 _blockPenalty) external onlyOwner {
889         require(!tradingActive, "Trading is already active, cannot relaunch.");
890 
891         blockPenalty = _blockPenalty;
892 
893         //update name/ticker
894         _name = "MILADYARMY";
895         _symbol = "MARMY";
896 
897         //standard enable trading
898         tradingActive = true;
899         swapEnabled = true;
900         tradingActiveBlock = block.number;
901         lastLpMarketingTime = block.timestamp;
902 
903         // initialize router
904         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
905         dexRouter = _dexRouter;
906 
907         // create pair
908         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
909         excludeFromMaxTransaction(address(lpPair), true);
910         _setAutomatedMarketMakerPair(address(lpPair), true);
911    
912         // add the liquidity
913         require(address(this).balance > 0, "Must have ETH on contract to launch");
914         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
915         _approve(address(this), address(dexRouter), balanceOf(address(this)));
916         dexRouter.addLiquidityETH{value: address(this).balance}(
917             address(this),
918             balanceOf(address(this)),
919             0, // slippage is unavoidable
920             0, // slippage is unavoidable
921             0x4F1305b56A489d99e18e151947256CF29Ed6172A,
922             block.timestamp
923         );
924     }
925 
926     // withdraw ETH if stuck before launch
927     function withdrawStuckETH() external onlyOwner {
928         require(!tradingActive, "Can only withdraw if trading hasn't started");
929         bool success;
930         (success,) = address(msg.sender).call{value: address(this).balance}("");
931     }
932       function isBot(address account) public view returns (bool) {
933         return  _isBlackListedBot[account];
934     }
935   function addBotToBlackList(address account) external onlyOwner() {
936         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
937         require(!_isBlackListedBot[account], "Account is already blacklisted");
938         _isBlackListedBot[account] = true;
939         _blackListedBots.push(account);
940     }
941     
942     function removeBotFromBlackList(address account) external onlyOwner() {
943         require(_isBlackListedBot[account], "Account is not blacklisted");
944         for (uint256 i = 0; i < _blackListedBots.length; i++) {
945             if (_blackListedBots[i] == account) {
946                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
947                 _isBlackListedBot[account] = false;
948                 _blackListedBots.pop();
949                 break;
950             }
951         }
952     }
953 }