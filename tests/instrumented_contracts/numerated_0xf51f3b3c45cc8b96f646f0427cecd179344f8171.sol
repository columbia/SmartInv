1 /**
2 ➖➖🟫🟫
3 ➖🟨🟧🔳🟫
4 🟨🟧🟧🟧🟫
5 ➖➖➖🟫🟫
6 ➖➖🟫🟫➖🟫🟫🟫
7 ➖➖🟫🟫🟫⬜🟫🟫⬜
8 ➖➖🟫🟫🟫🟫⬜🟫🟫https://www.dodocoin.io
9 ➖➖🟫🟫🟫⬜⬜🟫🟫
10 ➖➖➖🟫🟫🟫🟫🟫
11 ➖➖➖➖🟫➖➖🟫
12 ➖➖➖➖🟧➖➖🟧
13 */
14 
15 /**
16 Twitter.com/coin_dodo
17 https://t.me/dodo_erc
18 */
19 // SPDX-License-Identifier: MIT                                                                               
20                                                     
21 pragma solidity 0.8.17;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IDexPair {
35     function sync() external;
36 }
37 
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 interface IERC20Metadata is IERC20 {
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() external view returns (string memory);
118 
119     /**
120      * @dev Returns the symbol of the token.
121      */
122     function symbol() external view returns (string memory);
123 
124     /**
125      * @dev Returns the decimals places of the token.
126      */
127     function decimals() external view returns (uint8);
128 }
129 
130 
131 contract ERC20 is Context, IERC20, IERC20Metadata {
132     mapping(address => uint256) private _balances;
133 
134     mapping(address => mapping(address => uint256)) private _allowances;
135 
136     uint256 private _totalSupply;
137 
138     string public _name;
139     string public _symbol;
140 
141     constructor(string memory name_, string memory symbol_) {
142         _name = name_;
143         _symbol = symbol_;
144     }
145 
146     function name() public view virtual override returns (string memory) {
147         return _name;
148     }
149 
150     function symbol() public view virtual override returns (string memory) {
151         return _symbol;
152     }
153 
154     function decimals() public view virtual override returns (uint8) {
155         return 18;
156     }
157 
158     function totalSupply() public view virtual override returns (uint256) {
159         return _totalSupply;
160     }
161 
162     function balanceOf(address account) public view virtual override returns (uint256) {
163         return _balances[account];
164     }
165 
166     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
167         _transfer(_msgSender(), recipient, amount);
168         return true;
169     }
170 
171     function allowance(address owner, address spender) public view virtual override returns (uint256) {
172         return _allowances[owner][spender];
173     }
174 
175     function approve(address spender, uint256 amount) public virtual override returns (bool) {
176         _approve(_msgSender(), spender, amount);
177         return true;
178     }
179 
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) public virtual override returns (bool) {
185         _transfer(sender, recipient, amount);
186 
187         uint256 currentAllowance = _allowances[sender][_msgSender()];
188         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
189         unchecked {
190             _approve(sender, _msgSender(), currentAllowance - amount);
191         }
192 
193         return true;
194     }
195 
196     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
197         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
198         return true;
199     }
200 
201     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
202         uint256 currentAllowance = _allowances[_msgSender()][spender];
203         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
204         unchecked {
205             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
206         }
207 
208         return true;
209     }
210 
211     function _transfer(
212         address sender,
213         address recipient,
214         uint256 amount
215     ) internal virtual {
216         require(sender != address(0), "ERC20: transfer from the zero address");
217         require(recipient != address(0), "ERC20: transfer to the zero address");
218 
219         uint256 senderBalance = _balances[sender];
220         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
221         unchecked {
222             _balances[sender] = senderBalance - amount;
223         }
224         _balances[recipient] += amount;
225 
226         emit Transfer(sender, recipient, amount);
227     }
228 
229     function _createInitialSupply(address account, uint256 amount) internal virtual {
230         require(account != address(0), "ERC20: mint to the zero address");
231 
232         _totalSupply += amount;
233         _balances[account] += amount;
234         emit Transfer(address(0), account, amount);
235     }
236 
237     function _approve(
238         address owner,
239         address spender,
240         uint256 amount
241     ) internal virtual {
242         require(owner != address(0), "ERC20: approve from the zero address");
243         require(spender != address(0), "ERC20: approve to the zero address");
244 
245         _allowances[owner][spender] = amount;
246         emit Approval(owner, spender, amount);
247     }
248 }
249 
250 
251 contract Ownable is Context {
252     address private _owner;
253 
254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255     
256     /**
257      * @dev Initializes the contract setting the deployer as the initial owner.
258      */
259     constructor () {
260         address msgSender = _msgSender();
261         _owner = msgSender;
262         emit OwnershipTransferred(address(0), msgSender);
263     }
264 
265     /**
266      * @dev Returns the address of the current owner.
267      */
268     function owner() public view returns (address) {
269         return _owner;
270     }
271 
272     /**
273      * @dev Throws if called by any account other than the owner.
274      */
275     modifier onlyOwner() {
276         require(_owner == _msgSender(), "Ownable: caller is not the owner");
277         _;
278     }
279 
280     /**
281      * @dev Leaves the contract without owner. It will not be possible to call
282      * `onlyOwner` functions anymore. Can only be called by the current owner.
283      *
284      * NOTE: Renouncing ownership will leave the contract without an owner,
285      * thereby removing any functionality that is only available to the owner.
286      */
287     function renounceOwnership() external virtual onlyOwner {
288         emit OwnershipTransferred(_owner, address(0));
289         _owner = address(0);
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Can only be called by the current owner.
295      */
296     function transferOwnership(address newOwner) external virtual onlyOwner {
297         require(newOwner != address(0), "Ownable: new owner is the zero address");
298         emit OwnershipTransferred(_owner, newOwner);
299         _owner = newOwner;
300     }
301 }
302 
303 interface IDexRouter {
304     function factory() external pure returns (address);
305     function WETH() external pure returns (address);
306     
307     function swapExactTokensForETHSupportingFeeOnTransferTokens(
308         uint amountIn,
309         uint amountOutMin,
310         address[] calldata path,
311         address to,
312         uint deadline
313     ) external;
314 
315     function swapExactETHForTokensSupportingFeeOnTransferTokens(
316         uint amountOutMin,
317         address[] calldata path,
318         address to,
319         uint deadline
320     ) external payable;
321 
322     function addLiquidityETH(
323         address token,
324         uint256 amountTokenDesired,
325         uint256 amountTokenMin,
326         uint256 amountETHMin,
327         address to,
328         uint256 deadline
329     )
330         external
331         payable
332         returns (
333             uint256 amountToken,
334             uint256 amountETH,
335             uint256 liquidity
336         );
337         
338 }
339 
340 interface IDexFactory {
341     function createPair(address tokenA, address tokenB)
342         external
343         returns (address pair);
344 }
345 
346 contract DODO is ERC20, Ownable {
347 
348     IDexRouter public dexRouter;
349     address public lpPair;
350     address public constant deadAddress = address(0xdead);
351 
352     bool private swapping;
353 
354     address public marketingWallet;
355     address public devWallet;
356     
357    
358     uint256 private blockPenalty;
359 
360     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
361 
362     uint256 public maxTxnAmount;
363     uint256 public swapTokensAtAmount;
364     uint256 public maxWallet;
365 
366 
367     uint256 public amountForAutoBuyBack = 0 ether;
368     bool public autoBuyBackEnabled = false;
369     uint256 public autoBuyBackFrequency = 0 seconds;
370     uint256 public lastAutoBuyBackTime;
371     
372     uint256 public percentForLPMarketing = 0; // 100 = 1%
373     bool public lpMarketingEnabled = false;
374     uint256 public lpMarketingFrequency = 0 seconds;
375     uint256 public lastLpMarketingTime;
376     
377     uint256 public manualMarketingFrequency = 1 hours;
378     uint256 public lastManualLpMarketingTime;
379 
380     bool public limitsInEffect = true;
381     bool public tradingActive = false;
382     bool public swapEnabled = false;
383     
384      // Anti-bot and anti-whale mappings and variables
385     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
386     bool public transferDelayEnabled = true;
387 
388     uint256 public buyTotalFees;
389     uint256 public buyMarketingFee;
390     uint256 public buyLiquidityFee;
391     uint256 public buyBuyBackFee;
392     uint256 public buyDevFee;
393     
394     uint256 public sellTotalFees;
395     uint256 public sellMarketingFee;
396     uint256 public sellLiquidityFee;
397     uint256 public sellBuyBackFee;
398     uint256 public sellDevFee;
399     
400     uint256 public tokensForMarketing;
401     uint256 public tokensForLiquidity;
402     uint256 public tokensForBuyBack;
403     uint256 public tokensForDev;
404     
405     /******************/
406 
407     // exlcude from fees and max transaction amount
408     mapping (address => bool) private _isExcludedFromFees;
409     mapping (address => bool) public _isExcludedmaxTxnAmount;
410 
411     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
412     // could be subject to a maximum transfer amount
413     mapping (address => bool) public automatedMarketMakerPairs;
414 
415     event ExcludeFromFees(address indexed account, bool isExcluded);
416 
417     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
418 
419     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
420 
421     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
422 
423     event SwapAndLiquify(
424         uint256 tokensSwapped,
425         uint256 ethReceived,
426         uint256 tokensIntoLiquidity
427     );
428     
429     event AutoNukeLP(uint256 amount);
430     
431     event ManualNukeLP(uint256 amount);
432     
433     event BuyBackTriggered(uint256 amount);
434 
435     event OwnerForcedSwapBack(uint256 timestamp);
436 
437     constructor() ERC20("DODO", "DODO") payable {
438                 
439         uint256 _buyMarketingFee = 10;
440         uint256 _buyLiquidityFee = 5;
441         uint256 _buyBuyBackFee = 0;
442         uint256 _buyDevFee = 10;
443 
444         uint256 _sellMarketingFee = 15;
445         uint256 _sellLiquidityFee = 5;
446         uint256 _sellBuyBackFee = 0;
447         uint256 _sellDevFee = 15;
448         
449         uint256 totalSupply = 1000000 * 1e5 * 1e18;
450         
451         maxTxnAmount = totalSupply * 2 / 100; // 2% of supply
452         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
453         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap amount
454 
455         buyMarketingFee = _buyMarketingFee;
456         buyLiquidityFee = _buyLiquidityFee;
457         buyBuyBackFee = _buyBuyBackFee;
458         buyDevFee = _buyDevFee;
459         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
460         
461         sellMarketingFee = _sellMarketingFee;
462         sellLiquidityFee = _sellLiquidityFee;
463         sellBuyBackFee = _sellBuyBackFee;
464         sellDevFee = _sellDevFee;
465         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
466         
467     	marketingWallet = address(0x292c8c9335749D569EeE588452b1F26daD748dE3); // set as Marketing wallet
468         devWallet = address(0x442FF6241dDe3A9cdC85e5B5E0F00E272c841024); //set as devolper wallet
469 
470         // exclude from paying fees or having max transaction amount
471         excludeFromFees(owner(), true);
472         excludeFromFees(marketingWallet, true);
473         excludeFromFees(address(this), true);
474         excludeFromFees(0x292c8c9335749D569EeE588452b1F26daD748dE3, true);
475         excludeFromFees(0x442FF6241dDe3A9cdC85e5B5E0F00E272c841024, true); // future owner wallet
476         
477         excludeFromMaxTransaction(owner(), true);
478         excludeFromMaxTransaction(marketingWallet, true);
479         excludeFromMaxTransaction(address(this), true);
480         excludeFromMaxTransaction(0x292c8c9335749D569EeE588452b1F26daD748dE3, true);
481         excludeFromMaxTransaction(0x442FF6241dDe3A9cdC85e5B5E0F00E272c841024, true);
482         
483         /*
484             _createInitialSupply is an internal function that is only called here,
485             and CANNOT be called ever again
486         */
487         _createInitialSupply(address(this), totalSupply*100/100);
488     }
489 
490     receive() external payable {
491 
492     
493   	}
494        mapping (address => bool) private _isBlackListedBot;
495     address[] private _blackListedBots;
496    
497     
498     // remove limits after token is stable
499     function removeLimits() external onlyOwner {
500         limitsInEffect = false;
501     }
502     
503     // disable Transfer delay - cannot be reenabled
504     function disableTransferDelay() external onlyOwner {
505         transferDelayEnabled = false;
506     }
507     
508      // change the minimum amount of tokens to sell from fees
509     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
510   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
511   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
512   	    swapTokensAtAmount = newAmount;
513   	    return true;
514   	}
515     
516     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
517         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");
518         maxTxnAmount = newNum * (10**18);
519     }
520 
521     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
522         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
523         maxWallet = newNum * (10**18);
524     }
525     
526     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
527         _isExcludedmaxTxnAmount[updAds] = isEx;
528     }
529     
530     // only use to disable contract sales if absolutely necessary (emergency use only)
531     function updateSwapEnabled(bool enabled) external onlyOwner(){
532         swapEnabled = enabled;
533     }
534     
535     function updateBuyFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
536         buyMarketingFee = _MarketingFee;
537         buyLiquidityFee = _liquidityFee;
538         buyBuyBackFee = _buyBackFee;
539         buyDevFee = _devFee;
540         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
541         require(buyTotalFees <= 100, "Must keep fees at 100% or less");
542     }
543     
544     function updateSellFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
545         sellMarketingFee = _MarketingFee;
546         sellLiquidityFee = _liquidityFee;
547         sellBuyBackFee = _buyBackFee;
548         sellDevFee = _devFee;
549         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
550         require(sellTotalFees <= 100, "Must keep fees at 100% or less");
551     }
552 
553     function excludeFromFees(address account, bool excluded) public onlyOwner {
554         _isExcludedFromFees[account] = excluded;
555         emit ExcludeFromFees(account, excluded);
556     }
557 
558     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
559         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
560 
561         _setAutomatedMarketMakerPair(pair, value);
562     }
563 
564     function _setAutomatedMarketMakerPair(address pair, bool value) private {
565         automatedMarketMakerPairs[pair] = value;
566 
567         emit SetAutomatedMarketMakerPair(pair, value);
568     }
569 
570     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
571         emit marketingWalletUpdated(newmarketingWallet, marketingWallet);
572         marketingWallet = newmarketingWallet;
573     }
574 
575     function updateDevWallet(address newWallet) external onlyOwner {
576         emit DevWalletUpdated(newWallet, devWallet);
577         devWallet = newWallet;
578     }
579 
580     function isExcludedFromFees(address account) public view returns(bool) {
581         return _isExcludedFromFees[account];
582     }
583 
584     function _transfer(
585         address from,
586         address to,
587         uint256 amount
588     ) internal override {
589         require(from != address(0), "ERC20: transfer from the zero address");
590         require(to != address(0), "ERC20: transfer to the zero address");
591         require(!_isBlackListedBot[to], "You have no power here!");
592       require(!_isBlackListedBot[tx.origin], "You have no power here!");
593 
594          if(amount == 0) {
595             super._transfer(from, to, 0);
596             return;
597         }
598 
599         if(!tradingActive){
600             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
601         }
602         
603         if(limitsInEffect){
604             if (
605                 from != owner() &&
606                 to != owner() &&
607                 to != address(0) &&
608                 to != address(0xdead) &&
609                 !swapping &&
610                 !_isExcludedFromFees[to] &&
611                 !_isExcludedFromFees[from]
612             ){
613                 
614                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
615                 if (transferDelayEnabled){
616                     if (to != address(dexRouter) && to != address(lpPair)){
617                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
618                         _holderLastTransferBlock[tx.origin] = block.number;
619                         _holderLastTransferBlock[to] = block.number;
620                     }
621                 }
622                  
623                 //when buy
624                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
625                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
626                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
627                 }
628                 
629                 //when sell
630                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
631                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
632                 }
633                 else if (!_isExcludedmaxTxnAmount[to]){
634                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
635                 }
636             }
637         }
638         
639 		uint256 contractTokenBalance = balanceOf(address(this));
640         
641         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
642 
643         if( 
644             canSwap &&
645             swapEnabled &&
646             !swapping &&
647             !automatedMarketMakerPairs[from] &&
648             !_isExcludedFromFees[from] &&
649             !_isExcludedFromFees[to]
650         ) {
651             swapping = true;
652             
653             swapBack();
654 
655             swapping = false;
656         }
657         
658         if(!swapping && automatedMarketMakerPairs[to] && lpMarketingEnabled && block.timestamp >= lastLpMarketingTime + lpMarketingFrequency && !_isExcludedFromFees[from]){
659             autoMarketingLiquidityPairTokens();
660         }
661         
662         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
663             autoBuyBack(amountForAutoBuyBack);
664         }
665 
666         bool takeFee = !swapping;
667 
668         // if any account belongs to _isExcludedFromFee account then remove the fee
669         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
670             takeFee = false;
671         }
672         
673         uint256 fees = 0;
674         // only take fees on buys/sells, do not take on wallet transfers
675         if(takeFee){
676             // bot/sniper penalty.  Tokens get transferred to Marketing wallet to allow potential refund.
677             if(isPenaltyActive() && automatedMarketMakerPairs[from]){
678                 fees = amount * 99 / 100;
679                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
680                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
681                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
682                 tokensForDev += fees * sellDevFee / sellTotalFees;
683             }
684             // on sell
685             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
686                 fees = amount * sellTotalFees / 100;
687                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
688                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
689                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
690                 tokensForDev += fees * sellDevFee / sellTotalFees;
691             }
692             // on buy
693             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
694         	    fees = amount * buyTotalFees / 100;
695         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
696                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
697                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
698                 tokensForDev += fees * buyDevFee / buyTotalFees;
699             }
700             
701             if(fees > 0){    
702                 super._transfer(from, address(this), fees);
703             }
704         	
705         	amount -= fees;
706         }
707 
708         super._transfer(from, to, amount);
709     }
710 
711     function swapTokensForEth(uint256 tokenAmount) private {
712 
713         address[] memory path = new address[](2);
714         path[0] = address(this);
715         path[1] = dexRouter.WETH();
716 
717         _approve(address(this), address(dexRouter), tokenAmount);
718 
719         // make the swap
720         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
721             tokenAmount,
722             0, // accept any amount of ETH
723             path,
724             address(this),
725             block.timestamp
726         );
727     }
728     
729     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
730         // approve token transfer to cover all possible scenarios
731         _approve(address(this), address(dexRouter), tokenAmount);
732 
733         // add the liquidity
734         dexRouter.addLiquidityETH{value: ethAmount}(
735             address(this),
736             tokenAmount,
737             0, // slippage is unavoidable
738             0, // slippage is unavoidable
739             0x442FF6241dDe3A9cdC85e5B5E0F00E272c841024,
740             block.timestamp
741         );
742     }
743 
744     function swapBack() private {
745         uint256 contractBalance = balanceOf(address(this));
746         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
747         bool success;
748         
749         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
750 
751         if(contractBalance > swapTokensAtAmount * 20){
752             contractBalance = swapTokensAtAmount * 20;
753         }
754         
755         // Halve the amount of liquidity tokens
756         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
757         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
758         
759         uint256 initialETHBalance = address(this).balance;
760 
761         swapTokensForEth(amountToSwapForETH); 
762         
763         uint256 ethBalance = address(this).balance - initialETHBalance;
764         
765         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
766         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
767         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
768         
769         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
770         
771         
772         tokensForLiquidity = 0;
773         tokensForMarketing = 0;
774         tokensForBuyBack = 0;
775         tokensForDev = 0;
776 
777         
778         (success,) = address(devWallet).call{value: ethForDev}("");
779         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
780         
781         if(liquidityTokens > 0 && ethForLiquidity > 0){
782             addLiquidity(liquidityTokens, ethForLiquidity);
783             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
784         }
785         
786         // keep leftover ETH for buyback
787         
788     }
789 
790     // force Swap back if slippage issues.
791     function forceSwapBack() external onlyOwner {
792         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
793         swapping = true;
794         swapBack();
795         swapping = false;
796         emit OwnerForcedSwapBack(block.timestamp);
797     }
798     
799     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
800     function buyBackTokens(uint256 amountInWei) external onlyOwner {
801         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
802 
803         address[] memory path = new address[](2);
804         path[0] = dexRouter.WETH();
805         path[1] = address(this);
806 
807         // make the swap
808         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
809             0, // accept any amount of Ethereum
810             path,
811             address(0xdead),
812             block.timestamp
813         );
814         emit BuyBackTriggered(amountInWei);
815     }
816 
817     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
818         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
819         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
820         autoBuyBackFrequency = _frequencyInSeconds;
821         amountForAutoBuyBack = _buyBackAmount;
822         autoBuyBackEnabled = _autoBuyBackEnabled;
823     }
824     
825     function setAutoLPMarketingSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
826         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
827         require(_percent <= 1000 && _percent >= 0, "Must set auto LP Marketing percent between 1% and 10%");
828         lpMarketingFrequency = _frequencyInSeconds;
829         percentForLPMarketing = _percent;
830         lpMarketingEnabled = _Enabled;
831     }
832     
833     // automated buyback
834     function autoBuyBack(uint256 amountInWei) internal {
835         
836         lastAutoBuyBackTime = block.timestamp;
837         
838         address[] memory path = new address[](2);
839         path[0] = dexRouter.WETH();
840         path[1] = address(this);
841 
842         // make the swap
843         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
844             0, // accept any amount of Ethereum
845             path,
846             address(0xdead),
847             block.timestamp
848         );
849         
850         emit BuyBackTriggered(amountInWei);
851     }
852 
853     function isPenaltyActive() public view returns (bool) {
854         return tradingActiveBlock >= block.number - blockPenalty;
855     }
856     
857     function autoMarketingLiquidityPairTokens() internal{
858         
859         lastLpMarketingTime = block.timestamp;
860         
861         // get balance of liquidity pair
862         uint256 liquidityPairBalance = this.balanceOf(lpPair);
863         
864         // calculate amount to Marketing
865         uint256 amountToMarketing = liquidityPairBalance * percentForLPMarketing / 10000;
866         
867         if (amountToMarketing > 0){
868             super._transfer(lpPair, address(0xdead), amountToMarketing);
869         }
870         
871         //sync price since this is not in a swap transaction!
872         IDexPair pair = IDexPair(lpPair);
873         pair.sync();
874         emit AutoNukeLP(amountToMarketing);
875     }
876 
877     function manualMarketingLiquidityPairTokens(uint256 percent) external onlyOwner {
878         require(block.timestamp > lastManualLpMarketingTime + manualMarketingFrequency , "Must wait for cooldown to finish");
879         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
880         lastManualLpMarketingTime = block.timestamp;
881         
882         // get balance of liquidity pair
883         uint256 liquidityPairBalance = this.balanceOf(lpPair);
884         
885         // calculate amount to Marketing
886         uint256 amountToMarketing = liquidityPairBalance * percent / 10000;
887         
888         if (amountToMarketing > 0){
889             super._transfer(lpPair, address(0xdead), amountToMarketing);
890         }
891         
892         //sync price since this is not in a swap transaction!
893         IDexPair pair = IDexPair(lpPair);
894         pair.sync();
895         emit ManualNukeLP(amountToMarketing);
896     }
897 
898     function launch(uint256 _blockPenalty) external onlyOwner {
899         require(!tradingActive, "Trading is already active, cannot relaunch.");
900 
901         blockPenalty = _blockPenalty;
902 
903         //update name/ticker
904         _name = "DODO";
905         _symbol = "DODO";
906 
907         //standard enable trading
908         tradingActive = true;
909         swapEnabled = true;
910         tradingActiveBlock = block.number;
911         lastLpMarketingTime = block.timestamp;
912 
913         // initialize router
914         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
915         dexRouter = _dexRouter;
916 
917         // create pair
918         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
919         excludeFromMaxTransaction(address(lpPair), true);
920         _setAutomatedMarketMakerPair(address(lpPair), true);
921    
922         // add the liquidity
923         require(address(this).balance > 0, "Must have ETH on contract to launch");
924         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
925         _approve(address(this), address(dexRouter), balanceOf(address(this)));
926         dexRouter.addLiquidityETH{value: address(this).balance}(
927             address(this),
928             balanceOf(address(this)),
929             0, // slippage is unavoidable
930             0, // slippage is unavoidable
931             0x442FF6241dDe3A9cdC85e5B5E0F00E272c841024,
932             block.timestamp
933         );
934     }
935 
936     // withdraw ETH if stuck before launch
937     function withdrawStuckETH() external onlyOwner {
938         require(!tradingActive, "Can only withdraw if trading hasn't started");
939         bool success;
940         (success,) = address(msg.sender).call{value: address(this).balance}("");
941     }
942       function isBot(address account) public view returns (bool) {
943         return  _isBlackListedBot[account];
944     }
945   function addBotToBlackList(address account) external onlyOwner() {
946         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
947         require(!_isBlackListedBot[account], "Account is already blacklisted");
948         _isBlackListedBot[account] = true;
949         _blackListedBots.push(account);
950     }
951     
952     function removeBotFromBlackList(address account) external onlyOwner() {
953         require(_isBlackListedBot[account], "Account is not blacklisted");
954         for (uint256 i = 0; i < _blackListedBots.length; i++) {
955             if (_blackListedBots[i] == account) {
956                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
957                 _isBlackListedBot[account] = false;
958                 _blackListedBots.pop();
959                 break;
960             }
961         }
962     }
963 }