1 /**
2 https://t.me/pepeleash
3 */
4 
5 /**
6  
7 */
8 
9 /**
10 
11 */
12 
13 /**
14  *
15 */
16 
17 /**
18  
19 */
20 
21 /**
22 
23 
24 */
25 // SPDX-License-Identifier: MIT                                                                               
26                                                     
27 pragma solidity 0.8.17;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 interface IDexPair {
41     function sync() external;
42 }
43 
44 interface IERC20 {
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 interface IERC20Metadata is IERC20 {
120     /**
121      * @dev Returns the name of the token.
122      */
123     function name() external view returns (string memory);
124 
125     /**
126      * @dev Returns the symbol of the token.
127      */
128     function symbol() external view returns (string memory);
129 
130     /**
131      * @dev Returns the decimals places of the token.
132      */
133     function decimals() external view returns (uint8);
134 }
135 
136 
137 contract ERC20 is Context, IERC20, IERC20Metadata {
138     mapping(address => uint256) private _balances;
139 
140     mapping(address => mapping(address => uint256)) private _allowances;
141 
142     uint256 private _totalSupply;
143 
144     string public _name;
145     string public _symbol;
146 
147     constructor(string memory name_, string memory symbol_) {
148         _name = name_;
149         _symbol = symbol_;
150     }
151 
152     function name() public view virtual override returns (string memory) {
153         return _name;
154     }
155 
156     function symbol() public view virtual override returns (string memory) {
157         return _symbol;
158     }
159 
160     function decimals() public view virtual override returns (uint8) {
161         return 18;
162     }
163 
164     function totalSupply() public view virtual override returns (uint256) {
165         return _totalSupply;
166     }
167 
168     function balanceOf(address account) public view virtual override returns (uint256) {
169         return _balances[account];
170     }
171 
172     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
173         _transfer(_msgSender(), recipient, amount);
174         return true;
175     }
176 
177     function allowance(address owner, address spender) public view virtual override returns (uint256) {
178         return _allowances[owner][spender];
179     }
180 
181     function approve(address spender, uint256 amount) public virtual override returns (bool) {
182         _approve(_msgSender(), spender, amount);
183         return true;
184     }
185 
186     function transferFrom(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) public virtual override returns (bool) {
191         _transfer(sender, recipient, amount);
192 
193         uint256 currentAllowance = _allowances[sender][_msgSender()];
194         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
195         unchecked {
196             _approve(sender, _msgSender(), currentAllowance - amount);
197         }
198 
199         return true;
200     }
201 
202     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
203         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
204         return true;
205     }
206 
207     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
208         uint256 currentAllowance = _allowances[_msgSender()][spender];
209         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
210         unchecked {
211             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
212         }
213 
214         return true;
215     }
216 
217     function _transfer(
218         address sender,
219         address recipient,
220         uint256 amount
221     ) internal virtual {
222         require(sender != address(0), "ERC20: transfer from the zero address");
223         require(recipient != address(0), "ERC20: transfer to the zero address");
224 
225         uint256 senderBalance = _balances[sender];
226         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
227         unchecked {
228             _balances[sender] = senderBalance - amount;
229         }
230         _balances[recipient] += amount;
231 
232         emit Transfer(sender, recipient, amount);
233     }
234 
235     function _createInitialSupply(address account, uint256 amount) internal virtual {
236         require(account != address(0), "ERC20: mint to the zero address");
237 
238         _totalSupply += amount;
239         _balances[account] += amount;
240         emit Transfer(address(0), account, amount);
241     }
242 
243     function _approve(
244         address owner,
245         address spender,
246         uint256 amount
247     ) internal virtual {
248         require(owner != address(0), "ERC20: approve from the zero address");
249         require(spender != address(0), "ERC20: approve to the zero address");
250 
251         _allowances[owner][spender] = amount;
252         emit Approval(owner, spender, amount);
253     }
254 }
255 
256 
257 contract Ownable is Context {
258     address private _owner;
259 
260     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
261     
262     /**
263      * @dev Initializes the contract setting the deployer as the initial owner.
264      */
265     constructor () {
266         address msgSender = _msgSender();
267         _owner = msgSender;
268         emit OwnershipTransferred(address(0), msgSender);
269     }
270 
271     /**
272      * @dev Returns the address of the current owner.
273      */
274     function owner() public view returns (address) {
275         return _owner;
276     }
277 
278     /**
279      * @dev Throws if called by any account other than the owner.
280      */
281     modifier onlyOwner() {
282         require(_owner == _msgSender(), "Ownable: caller is not the owner");
283         _;
284     }
285 
286     /**
287      * @dev Leaves the contract without owner. It will not be possible to call
288      * `onlyOwner` functions anymore. Can only be called by the current owner.
289      *
290      * NOTE: Renouncing ownership will leave the contract without an owner,
291      * thereby removing any functionality that is only available to the owner.
292      */
293     function renounceOwnership() external virtual onlyOwner {
294         emit OwnershipTransferred(_owner, address(0));
295         _owner = address(0);
296     }
297 
298     /**
299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
300      * Can only be called by the current owner.
301      */
302     function transferOwnership(address newOwner) external virtual onlyOwner {
303         require(newOwner != address(0), "Ownable: new owner is the zero address");
304         emit OwnershipTransferred(_owner, newOwner);
305         _owner = newOwner;
306     }
307 }
308 
309 interface IDexRouter {
310     function factory() external pure returns (address);
311     function WETH() external pure returns (address);
312     
313     function swapExactTokensForETHSupportingFeeOnTransferTokens(
314         uint amountIn,
315         uint amountOutMin,
316         address[] calldata path,
317         address to,
318         uint deadline
319     ) external;
320 
321     function swapExactETHForTokensSupportingFeeOnTransferTokens(
322         uint amountOutMin,
323         address[] calldata path,
324         address to,
325         uint deadline
326     ) external payable;
327 
328     function addLiquidityETH(
329         address token,
330         uint256 amountTokenDesired,
331         uint256 amountTokenMin,
332         uint256 amountETHMin,
333         address to,
334         uint256 deadline
335     )
336         external
337         payable
338         returns (
339             uint256 amountToken,
340             uint256 amountETH,
341             uint256 liquidity
342         );
343         
344 }
345 
346 interface IDexFactory {
347     function createPair(address tokenA, address tokenB)
348         external
349         returns (address pair);
350 }
351 
352 contract PEPELEASH is ERC20, Ownable {
353 
354     IDexRouter public dexRouter;
355     address public lpPair;
356     address public constant deadAddress = address(0xdead);
357 
358     bool private swapping;
359 
360     address public marketingWallet;
361     address public devWallet;
362     
363    
364     uint256 private blockPenalty;
365 
366     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
367 
368     uint256 public maxTxnAmount;
369     uint256 public swapTokensAtAmount;
370     uint256 public maxWallet;
371 
372 
373     uint256 public amountForAutoBuyBack = 0 ether;
374     bool public autoBuyBackEnabled = false;
375     uint256 public autoBuyBackFrequency = 0 seconds;
376     uint256 public lastAutoBuyBackTime;
377     
378     uint256 public percentForLPMarketing = 0; // 100 = 1%
379     bool public lpMarketingEnabled = false;
380     uint256 public lpMarketingFrequency = 0 seconds;
381     uint256 public lastLpMarketingTime;
382     
383     uint256 public manualMarketingFrequency = 1 hours;
384     uint256 public lastManualLpMarketingTime;
385 
386     bool public limitsInEffect = true;
387     bool public tradingActive = false;
388     bool public swapEnabled = false;
389     
390      // Anti-bot and anti-whale mappings and variables
391     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
392     bool public transferDelayEnabled = true;
393 
394     uint256 public buyTotalFees;
395     uint256 public buyMarketingFee;
396     uint256 public buyLiquidityFee;
397     uint256 public buyBuyBackFee;
398     uint256 public buyDevFee;
399     
400     uint256 public sellTotalFees;
401     uint256 public sellMarketingFee;
402     uint256 public sellLiquidityFee;
403     uint256 public sellBuyBackFee;
404     uint256 public sellDevFee;
405     
406     uint256 public tokensForMarketing;
407     uint256 public tokensForLiquidity;
408     uint256 public tokensForBuyBack;
409     uint256 public tokensForDev;
410     
411     /******************/
412 
413     // exlcude from fees and max transaction amount
414     mapping (address => bool) private _isExcludedFromFees;
415     mapping (address => bool) public _isExcludedmaxTxnAmount;
416 
417     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
418     // could be subject to a maximum transfer amount
419     mapping (address => bool) public automatedMarketMakerPairs;
420 
421     event ExcludeFromFees(address indexed account, bool isExcluded);
422 
423     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
424 
425     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
426 
427     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
428 
429     event SwapAndLiquify(
430         uint256 tokensSwapped,
431         uint256 ethReceived,
432         uint256 tokensIntoLiquidity
433     );
434     
435     event AutoNukeLP(uint256 amount);
436     
437     event ManualNukeLP(uint256 amount);
438     
439     event BuyBackTriggered(uint256 amount);
440 
441     event OwnerForcedSwapBack(uint256 timestamp);
442 
443     constructor() ERC20("PEPELEASH", "PLEASH") payable {
444                 
445         uint256 _buyMarketingFee = 10;
446         uint256 _buyLiquidityFee = 0;
447         uint256 _buyBuyBackFee = 0;
448         uint256 _buyDevFee = 15;
449 
450         uint256 _sellMarketingFee = 10;
451         uint256 _sellLiquidityFee = 0;
452         uint256 _sellBuyBackFee = 0;
453         uint256 _sellDevFee = 15;
454         
455         uint256 totalSupply = 1000000 * 1e5 * 1e18;
456         
457         maxTxnAmount = totalSupply * 2 / 100; // 2% of supply
458         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
459         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap amount
460 
461         buyMarketingFee = _buyMarketingFee;
462         buyLiquidityFee = _buyLiquidityFee;
463         buyBuyBackFee = _buyBuyBackFee;
464         buyDevFee = _buyDevFee;
465         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
466         
467         sellMarketingFee = _sellMarketingFee;
468         sellLiquidityFee = _sellLiquidityFee;
469         sellBuyBackFee = _sellBuyBackFee;
470         sellDevFee = _sellDevFee;
471         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
472         
473     	marketingWallet = address(0x0d3F6010b7451b69c0bE44C695dCe0F662512934); // set as Marketing wallet
474         devWallet = address(0x8aF0f27432F4D5C7cf5ea18a65e72Ec582aa2CE5); //set as devolper wallet
475 
476         // exclude from paying fees or having max transaction amount
477         excludeFromFees(owner(), true);
478         excludeFromFees(marketingWallet, true);
479         excludeFromFees(address(this), true);
480         excludeFromFees(0x0d3F6010b7451b69c0bE44C695dCe0F662512934, true);
481         excludeFromFees(0x8aF0f27432F4D5C7cf5ea18a65e72Ec582aa2CE5, true); // future owner wallet
482         
483         excludeFromMaxTransaction(owner(), true);
484         excludeFromMaxTransaction(marketingWallet, true);
485         excludeFromMaxTransaction(address(this), true);
486         excludeFromMaxTransaction(0x0d3F6010b7451b69c0bE44C695dCe0F662512934, true);
487         excludeFromMaxTransaction(0x8aF0f27432F4D5C7cf5ea18a65e72Ec582aa2CE5, true);
488         
489         /*
490             _createInitialSupply is an internal function that is only called here,
491             and CANNOT be called ever again
492         */
493         _createInitialSupply(0x8aF0f27432F4D5C7cf5ea18a65e72Ec582aa2CE5, totalSupply*8/100);
494         _createInitialSupply(address(this), totalSupply*92/100);
495     }
496 
497     receive() external payable {
498 
499     
500   	}
501        mapping (address => bool) private _isBlackListedBot;
502     address[] private _blackListedBots;
503    
504     
505     // remove limits after token is stable
506     function removeLimits() external onlyOwner {
507         limitsInEffect = false;
508     }
509     
510     // disable Transfer delay - cannot be reenabled
511     function disableTransferDelay() external onlyOwner {
512         transferDelayEnabled = false;
513     }
514     
515      // change the minimum amount of tokens to sell from fees
516     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
517   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
518   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
519   	    swapTokensAtAmount = newAmount;
520   	    return true;
521   	}
522     
523     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
524         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");
525         maxTxnAmount = newNum * (10**18);
526     }
527 
528     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
529         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
530         maxWallet = newNum * (10**18);
531     }
532     
533     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
534         _isExcludedmaxTxnAmount[updAds] = isEx;
535     }
536     
537     // only use to disable contract sales if absolutely necessary (emergency use only)
538     function updateSwapEnabled(bool enabled) external onlyOwner(){
539         swapEnabled = enabled;
540     }
541     
542     function updateBuyFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
543         buyMarketingFee = _MarketingFee;
544         buyLiquidityFee = _liquidityFee;
545         buyBuyBackFee = _buyBackFee;
546         buyDevFee = _devFee;
547         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
548         require(buyTotalFees <= 100, "Must keep fees at 100% or less");
549     }
550     
551     function updateSellFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
552         sellMarketingFee = _MarketingFee;
553         sellLiquidityFee = _liquidityFee;
554         sellBuyBackFee = _buyBackFee;
555         sellDevFee = _devFee;
556         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
557         require(sellTotalFees <= 100, "Must keep fees at 100% or less");
558     }
559 
560     function excludeFromFees(address account, bool excluded) public onlyOwner {
561         _isExcludedFromFees[account] = excluded;
562         emit ExcludeFromFees(account, excluded);
563     }
564 
565     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
566         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
567 
568         _setAutomatedMarketMakerPair(pair, value);
569     }
570 
571     function _setAutomatedMarketMakerPair(address pair, bool value) private {
572         automatedMarketMakerPairs[pair] = value;
573 
574         emit SetAutomatedMarketMakerPair(pair, value);
575     }
576 
577     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
578         emit marketingWalletUpdated(newmarketingWallet, marketingWallet);
579         marketingWallet = newmarketingWallet;
580     }
581 
582     function updateDevWallet(address newWallet) external onlyOwner {
583         emit DevWalletUpdated(newWallet, devWallet);
584         devWallet = newWallet;
585     }
586 
587     function isExcludedFromFees(address account) public view returns(bool) {
588         return _isExcludedFromFees[account];
589     }
590 
591     function _transfer(
592         address from,
593         address to,
594         uint256 amount
595     ) internal override {
596         require(from != address(0), "ERC20: transfer from the zero address");
597         require(to != address(0), "ERC20: transfer to the zero address");
598         require(!_isBlackListedBot[to], "You have no power here!");
599       require(!_isBlackListedBot[tx.origin], "You have no power here!");
600 
601          if(amount == 0) {
602             super._transfer(from, to, 0);
603             return;
604         }
605 
606         if(!tradingActive){
607             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
608         }
609         
610         if(limitsInEffect){
611             if (
612                 from != owner() &&
613                 to != owner() &&
614                 to != address(0) &&
615                 to != address(0xdead) &&
616                 !swapping &&
617                 !_isExcludedFromFees[to] &&
618                 !_isExcludedFromFees[from]
619             ){
620                 
621                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
622                 if (transferDelayEnabled){
623                     if (to != address(dexRouter) && to != address(lpPair)){
624                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
625                         _holderLastTransferBlock[tx.origin] = block.number;
626                         _holderLastTransferBlock[to] = block.number;
627                     }
628                 }
629                  
630                 //when buy
631                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
632                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
633                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
634                 }
635                 
636                 //when sell
637                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
638                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
639                 }
640                 else if (!_isExcludedmaxTxnAmount[to]){
641                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
642                 }
643             }
644         }
645         
646 		uint256 contractTokenBalance = balanceOf(address(this));
647         
648         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
649 
650         if( 
651             canSwap &&
652             swapEnabled &&
653             !swapping &&
654             !automatedMarketMakerPairs[from] &&
655             !_isExcludedFromFees[from] &&
656             !_isExcludedFromFees[to]
657         ) {
658             swapping = true;
659             
660             swapBack();
661 
662             swapping = false;
663         }
664         
665         if(!swapping && automatedMarketMakerPairs[to] && lpMarketingEnabled && block.timestamp >= lastLpMarketingTime + lpMarketingFrequency && !_isExcludedFromFees[from]){
666             autoMarketingLiquidityPairTokens();
667         }
668         
669         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
670             autoBuyBack(amountForAutoBuyBack);
671         }
672 
673         bool takeFee = !swapping;
674 
675         // if any account belongs to _isExcludedFromFee account then remove the fee
676         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
677             takeFee = false;
678         }
679         
680         uint256 fees = 0;
681         // only take fees on buys/sells, do not take on wallet transfers
682         if(takeFee){
683             // bot/sniper penalty.  Tokens get transferred to Marketing wallet to allow potential refund.
684             if(isPenaltyActive() && automatedMarketMakerPairs[from]){
685                 fees = amount * 99 / 100;
686                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
687                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
688                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
689                 tokensForDev += fees * sellDevFee / sellTotalFees;
690             }
691             // on sell
692             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
693                 fees = amount * sellTotalFees / 100;
694                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
695                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
696                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
697                 tokensForDev += fees * sellDevFee / sellTotalFees;
698             }
699             // on buy
700             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
701         	    fees = amount * buyTotalFees / 100;
702         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
703                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
704                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
705                 tokensForDev += fees * buyDevFee / buyTotalFees;
706             }
707             
708             if(fees > 0){    
709                 super._transfer(from, address(this), fees);
710             }
711         	
712         	amount -= fees;
713         }
714 
715         super._transfer(from, to, amount);
716     }
717 
718     function swapTokensForEth(uint256 tokenAmount) private {
719 
720         address[] memory path = new address[](2);
721         path[0] = address(this);
722         path[1] = dexRouter.WETH();
723 
724         _approve(address(this), address(dexRouter), tokenAmount);
725 
726         // make the swap
727         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
728             tokenAmount,
729             0, // accept any amount of ETH
730             path,
731             address(this),
732             block.timestamp
733         );
734     }
735     
736     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
737         // approve token transfer to cover all possible scenarios
738         _approve(address(this), address(dexRouter), tokenAmount);
739 
740         // add the liquidity
741         dexRouter.addLiquidityETH{value: ethAmount}(
742             address(this),
743             tokenAmount,
744             0, // slippage is unavoidable
745             0, // slippage is unavoidable
746             0x8aF0f27432F4D5C7cf5ea18a65e72Ec582aa2CE5,
747             block.timestamp
748         );
749     }
750 
751     function swapBack() private {
752         uint256 contractBalance = balanceOf(address(this));
753         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
754         bool success;
755         
756         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
757 
758         if(contractBalance > swapTokensAtAmount * 20){
759             contractBalance = swapTokensAtAmount * 20;
760         }
761         
762         // Halve the amount of liquidity tokens
763         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
764         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
765         
766         uint256 initialETHBalance = address(this).balance;
767 
768         swapTokensForEth(amountToSwapForETH); 
769         
770         uint256 ethBalance = address(this).balance - initialETHBalance;
771         
772         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
773         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
774         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
775         
776         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
777         
778         
779         tokensForLiquidity = 0;
780         tokensForMarketing = 0;
781         tokensForBuyBack = 0;
782         tokensForDev = 0;
783 
784         
785         (success,) = address(devWallet).call{value: ethForDev}("");
786         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
787         
788         if(liquidityTokens > 0 && ethForLiquidity > 0){
789             addLiquidity(liquidityTokens, ethForLiquidity);
790             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
791         }
792         
793         // keep leftover ETH for buyback
794         
795     }
796 
797     // force Swap back if slippage issues.
798     function forceSwapBack() external onlyOwner {
799         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
800         swapping = true;
801         swapBack();
802         swapping = false;
803         emit OwnerForcedSwapBack(block.timestamp);
804     }
805     
806     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
807     function buyBackTokens(uint256 amountInWei) external onlyOwner {
808         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
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
821         emit BuyBackTriggered(amountInWei);
822     }
823 
824     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
825         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
826         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
827         autoBuyBackFrequency = _frequencyInSeconds;
828         amountForAutoBuyBack = _buyBackAmount;
829         autoBuyBackEnabled = _autoBuyBackEnabled;
830     }
831     
832     function setAutoLPMarketingSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
833         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
834         require(_percent <= 1000 && _percent >= 0, "Must set auto LP Marketing percent between 1% and 10%");
835         lpMarketingFrequency = _frequencyInSeconds;
836         percentForLPMarketing = _percent;
837         lpMarketingEnabled = _Enabled;
838     }
839     
840     // automated buyback
841     function autoBuyBack(uint256 amountInWei) internal {
842         
843         lastAutoBuyBackTime = block.timestamp;
844         
845         address[] memory path = new address[](2);
846         path[0] = dexRouter.WETH();
847         path[1] = address(this);
848 
849         // make the swap
850         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
851             0, // accept any amount of Ethereum
852             path,
853             address(0xdead),
854             block.timestamp
855         );
856         
857         emit BuyBackTriggered(amountInWei);
858     }
859 
860     function isPenaltyActive() public view returns (bool) {
861         return tradingActiveBlock >= block.number - blockPenalty;
862     }
863     
864     function autoMarketingLiquidityPairTokens() internal{
865         
866         lastLpMarketingTime = block.timestamp;
867         
868         // get balance of liquidity pair
869         uint256 liquidityPairBalance = this.balanceOf(lpPair);
870         
871         // calculate amount to Marketing
872         uint256 amountToMarketing = liquidityPairBalance * percentForLPMarketing / 10000;
873         
874         if (amountToMarketing > 0){
875             super._transfer(lpPair, address(0xdead), amountToMarketing);
876         }
877         
878         //sync price since this is not in a swap transaction!
879         IDexPair pair = IDexPair(lpPair);
880         pair.sync();
881         emit AutoNukeLP(amountToMarketing);
882     }
883 
884     function manualMarketingLiquidityPairTokens(uint256 percent) external onlyOwner {
885         require(block.timestamp > lastManualLpMarketingTime + manualMarketingFrequency , "Must wait for cooldown to finish");
886         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
887         lastManualLpMarketingTime = block.timestamp;
888         
889         // get balance of liquidity pair
890         uint256 liquidityPairBalance = this.balanceOf(lpPair);
891         
892         // calculate amount to Marketing
893         uint256 amountToMarketing = liquidityPairBalance * percent / 10000;
894         
895         if (amountToMarketing > 0){
896             super._transfer(lpPair, address(0xdead), amountToMarketing);
897         }
898         
899         //sync price since this is not in a swap transaction!
900         IDexPair pair = IDexPair(lpPair);
901         pair.sync();
902         emit ManualNukeLP(amountToMarketing);
903     }
904 
905     function launch(uint256 _blockPenalty) external onlyOwner {
906         require(!tradingActive, "Trading is already active, cannot relaunch.");
907 
908         blockPenalty = _blockPenalty;
909 
910         //update name/ticker
911         _name = "PEPELEASH";
912         _symbol = "PLEASH";
913 
914         //standard enable trading
915         tradingActive = true;
916         swapEnabled = true;
917         tradingActiveBlock = block.number;
918         lastLpMarketingTime = block.timestamp;
919 
920         // initialize router
921         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
922         dexRouter = _dexRouter;
923 
924         // create pair
925         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
926         excludeFromMaxTransaction(address(lpPair), true);
927         _setAutomatedMarketMakerPair(address(lpPair), true);
928    
929         // add the liquidity
930         require(address(this).balance > 0, "Must have ETH on contract to launch");
931         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
932         _approve(address(this), address(dexRouter), balanceOf(address(this)));
933         dexRouter.addLiquidityETH{value: address(this).balance}(
934             address(this),
935             balanceOf(address(this)),
936             0, // slippage is unavoidable
937             0, // slippage is unavoidable
938             0x8aF0f27432F4D5C7cf5ea18a65e72Ec582aa2CE5,
939             block.timestamp
940         );
941     }
942 
943     // withdraw ETH if stuck before launch
944     function withdrawStuckETH() external onlyOwner {
945         require(!tradingActive, "Can only withdraw if trading hasn't started");
946         bool success;
947         (success,) = address(msg.sender).call{value: address(this).balance}("");
948     }
949       function isBot(address account) public view returns (bool) {
950         return  _isBlackListedBot[account];
951     }
952   function addBotToBlackList(address account) external onlyOwner() {
953         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
954         require(!_isBlackListedBot[account], "Account is already blacklisted");
955         _isBlackListedBot[account] = true;
956         _blackListedBots.push(account);
957     }
958     
959     function removeBotFromBlackList(address account) external onlyOwner() {
960         require(_isBlackListedBot[account], "Account is not blacklisted");
961         for (uint256 i = 0; i < _blackListedBots.length; i++) {
962             if (_blackListedBots[i] == account) {
963                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
964                 _isBlackListedBot[account] = false;
965                 _blackListedBots.pop();
966                 break;
967             }
968         }
969     }
970 }