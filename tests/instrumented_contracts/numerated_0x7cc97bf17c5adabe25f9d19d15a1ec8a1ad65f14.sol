1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-13
3 */
4 
5 /**
6 The Wolverinu Token
7 Within the first two weeks of launching, Wolverinu has swiftly gained traction. It is currently being listed on Uniswap, Shibaswap, Sushiswap, Fegex, Hotbit, LBank, and Bitmart. The token boasts a growing number of holders thanks to a strong community that is regularly engaged with Youtube videos, AMAs, charity programs, and daily reward contests. An updated Version 2 staking page and NFT marketplace is coming soon and a Wolverinu Play 2 Earn game is also in the works where players can collect exclusive NFTs, and Adamantium rewards; set for release within 2022. A full-time development team, dedicated moderators, and a united community prove that  it is  definitely the right formula
8 to take this project to the moon.
9 */
10 
11 
12 // SPDX-License-Identifier: MIT                                                                               
13                                                     
14 pragma solidity 0.8.11;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 interface IDexPair {
28     function sync() external;
29 }
30 
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 interface IERC20Metadata is IERC20 {
107     /**
108      * @dev Returns the name of the token.
109      */
110     function name() external view returns (string memory);
111 
112     /**
113      * @dev Returns the symbol of the token.
114      */
115     function symbol() external view returns (string memory);
116 
117     /**
118      * @dev Returns the decimals places of the token.
119      */
120     function decimals() external view returns (uint8);
121 }
122 
123 
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     mapping(address => uint256) private _balances;
126 
127     mapping(address => mapping(address => uint256)) private _allowances;
128 
129     uint256 private _totalSupply;
130 
131     string public _name;
132     string public _symbol;
133 
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138 
139     function name() public view virtual override returns (string memory) {
140         return _name;
141     }
142 
143     function symbol() public view virtual override returns (string memory) {
144         return _symbol;
145     }
146 
147     function decimals() public view virtual override returns (uint8) {
148         return 18;
149     }
150 
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address account) public view virtual override returns (uint256) {
156         return _balances[account];
157     }
158 
159     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
160         _transfer(_msgSender(), recipient, amount);
161         return true;
162     }
163 
164     function allowance(address owner, address spender) public view virtual override returns (uint256) {
165         return _allowances[owner][spender];
166     }
167 
168     function approve(address spender, uint256 amount) public virtual override returns (bool) {
169         _approve(_msgSender(), spender, amount);
170         return true;
171     }
172 
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) public virtual override returns (bool) {
178         _transfer(sender, recipient, amount);
179 
180         uint256 currentAllowance = _allowances[sender][_msgSender()];
181         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
182         unchecked {
183             _approve(sender, _msgSender(), currentAllowance - amount);
184         }
185 
186         return true;
187     }
188 
189     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
191         return true;
192     }
193 
194     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
195         uint256 currentAllowance = _allowances[_msgSender()][spender];
196         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
197         unchecked {
198             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
199         }
200 
201         return true;
202     }
203 
204     function _transfer(
205         address sender,
206         address recipient,
207         uint256 amount
208     ) internal virtual {
209         require(sender != address(0), "ERC20: transfer from the zero address");
210         require(recipient != address(0), "ERC20: transfer to the zero address");
211 
212         uint256 senderBalance = _balances[sender];
213         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
214         unchecked {
215             _balances[sender] = senderBalance - amount;
216         }
217         _balances[recipient] += amount;
218 
219         emit Transfer(sender, recipient, amount);
220     }
221 
222     function _createInitialSupply(address account, uint256 amount) internal virtual {
223         require(account != address(0), "ERC20: mint to the zero address");
224 
225         _totalSupply += amount;
226         _balances[account] += amount;
227         emit Transfer(address(0), account, amount);
228     }
229 
230     function _approve(
231         address owner,
232         address spender,
233         uint256 amount
234     ) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237 
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 }
242 
243 
244 contract Ownable is Context {
245     address private _owner;
246 
247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248     
249     /**
250      * @dev Initializes the contract setting the deployer as the initial owner.
251      */
252     constructor () {
253         address msgSender = _msgSender();
254         _owner = msgSender;
255         emit OwnershipTransferred(address(0), msgSender);
256     }
257 
258     /**
259      * @dev Returns the address of the current owner.
260      */
261     function owner() public view returns (address) {
262         return _owner;
263     }
264 
265     /**
266      * @dev Throws if called by any account other than the owner.
267      */
268     modifier onlyOwner() {
269         require(_owner == _msgSender(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions anymore. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby removing any functionality that is only available to the owner.
279      */
280     function renounceOwnership() external virtual onlyOwner {
281         emit OwnershipTransferred(_owner, address(0));
282         _owner = address(0);
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) external virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         emit OwnershipTransferred(_owner, newOwner);
292         _owner = newOwner;
293     }
294 }
295 
296 interface IDexRouter {
297     function factory() external pure returns (address);
298     function WETH() external pure returns (address);
299     
300     function swapExactTokensForETHSupportingFeeOnTransferTokens(
301         uint amountIn,
302         uint amountOutMin,
303         address[] calldata path,
304         address to,
305         uint deadline
306     ) external;
307 
308     function swapExactETHForTokensSupportingFeeOnTransferTokens(
309         uint amountOutMin,
310         address[] calldata path,
311         address to,
312         uint deadline
313     ) external payable;
314 
315     function addLiquidityETH(
316         address token,
317         uint256 amountTokenDesired,
318         uint256 amountTokenMin,
319         uint256 amountETHMin,
320         address to,
321         uint256 deadline
322     )
323         external
324         payable
325         returns (
326             uint256 amountToken,
327             uint256 amountETH,
328             uint256 liquidity
329         );
330         
331 }
332 
333 interface IDexFactory {
334     function createPair(address tokenA, address tokenB)
335         external
336         returns (address pair);
337 }
338 
339 contract WOLVERINU is ERC20, Ownable {
340 
341     IDexRouter public dexRouter;
342     address public lpPair;
343     address public constant deadAddress = address(0xdead);
344 
345     bool private swapping;
346 
347     address public marketingWallet;
348     address public devWallet;
349     
350    
351     uint256 private blockPenalty;
352 
353     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
354 
355     uint256 public maxTxnAmount;
356     uint256 public swapTokensAtAmount;
357     uint256 public maxWallet;
358 
359 
360     uint256 public amountForAutoBuyBack = 0.2 ether;
361     bool public autoBuyBackEnabled = true;
362     uint256 public autoBuyBackFrequency = 3600 seconds;
363     uint256 public lastAutoBuyBackTime;
364     
365     uint256 public percentForLPBurn = 100; // 100 = 1%
366     bool public lpBurnEnabled = true;
367     uint256 public lpBurnFrequency = 3600 seconds;
368     uint256 public lastLpBurnTime;
369     
370     uint256 public manualBurnFrequency = 1 hours;
371     uint256 public lastManualLpBurnTime;
372 
373     bool public limitsInEffect = false;
374     bool public tradingActive = false;
375     bool public swapEnabled = false;
376     
377      // Anti-bot and anti-whale mappings and variables
378     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
379     bool public transferDelayEnabled = true;
380 
381     uint256 public buyTotalFees;
382     uint256 public buyMarketingFee;
383     uint256 public buyLiquidityFee;
384     uint256 public buyBuyBackFee;
385     uint256 public buyDevFee;
386     
387     uint256 public sellTotalFees;
388     uint256 public sellMarketingFee;
389     uint256 public sellLiquidityFee;
390     uint256 public sellBuyBackFee;
391     uint256 public sellDevFee;
392     
393     uint256 public tokensForMarketing;
394     uint256 public tokensForLiquidity;
395     uint256 public tokensForBuyBack;
396     uint256 public tokensForDev;
397     
398     /******************/
399 
400     // exlcude from fees and max transaction amount
401     mapping (address => bool) private _isExcludedFromFees;
402     mapping (address => bool) public _isExcludedmaxTxnAmount;
403 
404     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
405     // could be subject to a maximum transfer amount
406     mapping (address => bool) public automatedMarketMakerPairs;
407 
408     event ExcludeFromFees(address indexed account, bool isExcluded);
409 
410     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
411 
412     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
413 
414     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
415 
416     event SwapAndLiquify(
417         uint256 tokensSwapped,
418         uint256 ethReceived,
419         uint256 tokensIntoLiquidity
420     );
421     
422     event AutoNukeLP(uint256 amount);
423     
424     event ManualNukeLP(uint256 amount);
425     
426     event BuyBackTriggered(uint256 amount);
427 
428     event OwnerForcedSwapBack(uint256 timestamp);
429 
430     constructor() ERC20("WOLVERINU", "WOLVERINU") payable {
431                 
432         uint256 _buyMarketingFee = 4;
433         uint256 _buyLiquidityFee = 1;
434         uint256 _buyBuyBackFee = 1;
435         uint256 _buyDevFee = 4;
436 
437         uint256 _sellMarketingFee = 4;
438         uint256 _sellLiquidityFee = 1;
439         uint256 _sellBuyBackFee = 1;
440         uint256 _sellDevFee = 4;
441         
442         uint256 totalSupply = 20 * 1e15 * 1e18;
443         
444         maxTxnAmount = totalSupply * 3 / 100; // 3% of supply
445         maxWallet = totalSupply * 3 / 100; // 3% maxWallet
446         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap amount
447 
448         buyMarketingFee = _buyMarketingFee;
449         buyLiquidityFee = _buyLiquidityFee;
450         buyBuyBackFee = _buyBuyBackFee;
451         buyDevFee = _buyDevFee;
452         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
453         
454         sellMarketingFee = _sellMarketingFee;
455         sellLiquidityFee = _sellLiquidityFee;
456         sellBuyBackFee = _sellBuyBackFee;
457         sellDevFee = _sellDevFee;
458         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
459         
460     	marketingWallet = address(0x2a14e56d14E2615CB6626B9Dbc90A6f3940F8A4D); // set as marketing wallet
461         devWallet = address(0xcF7DE4C751Ee826f65aed740602AED0EA068AE5f);
462 
463         // exclude from paying fees or having max transaction amount
464         excludeFromFees(owner(), true);
465         excludeFromFees(marketingWallet, true);
466         excludeFromFees(address(this), true);
467         excludeFromFees(address(0xdead), true);
468         excludeFromFees(0x2a14e56d14E2615CB6626B9Dbc90A6f3940F8A4D, true); // future owner wallet
469         
470         excludeFromMaxTransaction(owner(), true);
471         excludeFromMaxTransaction(marketingWallet, true);
472         excludeFromMaxTransaction(address(this), true);
473         excludeFromMaxTransaction(address(0xdead), true);
474         excludeFromMaxTransaction(0x2a14e56d14E2615CB6626B9Dbc90A6f3940F8A4D, true);
475 
476                 // initialize router
477         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
478         dexRouter = _dexRouter;
479 
480         // create pair
481         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
482         excludeFromMaxTransaction(address(lpPair), true);
483         _setAutomatedMarketMakerPair(address(lpPair), true);
484         
485         /*
486             _createInitialSupply is an internal function that is only called here,
487             and CANNOT be called ever again
488         */
489 
490         _createInitialSupply(0x36C31ae01b32c6C4A3A504Ba28A5CF45Ec59ddab, totalSupply*100/100);
491         _createInitialSupply(address(this), totalSupply*0/100);
492     }
493 
494     receive() external payable {
495 
496     
497   	}
498        mapping (address => bool) private _isBlackListedBot;
499     address[] private _blackListedBots;
500    
501     
502     // remove limits after token is stable
503     function removeLimits() external onlyOwner {
504         limitsInEffect = false;
505     }
506     
507     // disable Transfer delay - cannot be reenabled
508     function disableTransferDelay() external onlyOwner {
509         transferDelayEnabled = false;
510     }
511     
512      // change the minimum amount of tokens to sell from fees
513     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
514   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
515   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
516   	    swapTokensAtAmount = newAmount;
517   	    return true;
518   	}
519     
520     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
521         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTxnAmount lower than 0.5%");
522         maxTxnAmount = newNum * (10**18);
523     }
524 
525     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
526         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
527         maxWallet = newNum * (10**18);
528     }
529     
530     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
531         _isExcludedmaxTxnAmount[updAds] = isEx;
532     }
533     
534     // only use to disable contract sales if absolutely necessary (emergency use only)
535     function updateSwapEnabled(bool enabled) external onlyOwner(){
536         swapEnabled = enabled;
537     }
538     
539     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
540         buyMarketingFee = _marketingFee;
541         buyLiquidityFee = _liquidityFee;
542         buyBuyBackFee = _buyBackFee;
543         buyDevFee = _devFee;
544         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee + buyDevFee;
545         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
546     }
547     
548     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee, uint256 _devFee) external onlyOwner {
549         sellMarketingFee = _marketingFee;
550         sellLiquidityFee = _liquidityFee;
551         sellBuyBackFee = _buyBackFee;
552         sellDevFee = _devFee;
553         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee + sellDevFee;
554         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
555     }
556 
557     function excludeFromFees(address account, bool excluded) public onlyOwner {
558         _isExcludedFromFees[account] = excluded;
559         emit ExcludeFromFees(account, excluded);
560     }
561 
562     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
563         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
564 
565         _setAutomatedMarketMakerPair(pair, value);
566     }
567 
568     function _setAutomatedMarketMakerPair(address pair, bool value) private {
569         automatedMarketMakerPairs[pair] = value;
570 
571         emit SetAutomatedMarketMakerPair(pair, value);
572     }
573 
574     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
575         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
576         marketingWallet = newMarketingWallet;
577     }
578 
579     function updateDevWallet(address newWallet) external onlyOwner {
580         emit DevWalletUpdated(newWallet, devWallet);
581         devWallet = newWallet;
582     }
583 
584     function isExcludedFromFees(address account) public view returns(bool) {
585         return _isExcludedFromFees[account];
586     }
587 
588     function _transfer(
589         address from,
590         address to,
591         uint256 amount
592     ) internal override {
593         require(from != address(0), "ERC20: transfer from the zero address");
594         require(to != address(0), "ERC20: transfer to the zero address");
595         require(!_isBlackListedBot[to], "You have no power here!");
596       require(!_isBlackListedBot[tx.origin], "You have no power here!");
597 
598          if(amount == 0) {
599             super._transfer(from, to, 0);
600             return;
601         }
602 
603         if(!tradingActive){
604             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
605         }
606         
607         if(limitsInEffect){
608             if (
609                 from != owner() &&
610                 to != owner() &&
611                 to != address(0) &&
612                 to != address(0xdead) &&
613                 !swapping &&
614                 !_isExcludedFromFees[to] &&
615                 !_isExcludedFromFees[from]
616             ){
617                 
618                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
619                 if (transferDelayEnabled){
620                     if (to != address(dexRouter) && to != address(lpPair)){
621                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
622                         _holderLastTransferBlock[tx.origin] = block.number;
623                         _holderLastTransferBlock[to] = block.number;
624                     }
625                 }
626                  
627                 //when buy
628                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
629                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
630                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
631                 }
632                 
633                 //when sell
634                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
635                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
636                 }
637                 else if (!_isExcludedmaxTxnAmount[to]){
638                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
639                 }
640             }
641         }
642         
643 		uint256 contractTokenBalance = balanceOf(address(this));
644         
645         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
646 
647         if( 
648             canSwap &&
649             swapEnabled &&
650             !swapping &&
651             !automatedMarketMakerPairs[from] &&
652             !_isExcludedFromFees[from] &&
653             !_isExcludedFromFees[to]
654         ) {
655             swapping = true;
656             
657             swapBack();
658 
659             swapping = false;
660         }
661         
662         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
663             autoBurnLiquidityPairTokens();
664         }
665         
666         if(!swapping && automatedMarketMakerPairs[to] && autoBuyBackEnabled && block.timestamp >= lastAutoBuyBackTime + autoBuyBackFrequency && !_isExcludedFromFees[from] && address(this).balance >= amountForAutoBuyBack){
667             autoBuyBack(amountForAutoBuyBack);
668         }
669 
670         bool takeFee = !swapping;
671 
672         // if any account belongs to _isExcludedFromFee account then remove the fee
673         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
674             takeFee = false;
675         }
676         
677         uint256 fees = 0;
678         // only take fees on buys/sells, do not take on wallet transfers
679         if(takeFee){
680             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
681             if(isPenaltyActive() && automatedMarketMakerPairs[from]){
682                 fees = amount * 99 / 100;
683                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
684                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
685                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
686                 tokensForDev += fees * sellDevFee / sellTotalFees;
687             }
688             // on sell
689             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
690                 fees = amount * sellTotalFees / 100;
691                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
692                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
693                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
694                 tokensForDev += fees * sellDevFee / sellTotalFees;
695             }
696             // on buy
697             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
698         	    fees = amount * buyTotalFees / 100;
699         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
700                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
701                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
702                 tokensForDev += fees * buyDevFee / buyTotalFees;
703             }
704             
705             if(fees > 0){    
706                 super._transfer(from, address(this), fees);
707             }
708         	
709         	amount -= fees;
710         }
711 
712         super._transfer(from, to, amount);
713     }
714 
715     function swapTokensForEth(uint256 tokenAmount) private {
716 
717         address[] memory path = new address[](2);
718         path[0] = address(this);
719         path[1] = dexRouter.WETH();
720 
721         _approve(address(this), address(dexRouter), tokenAmount);
722 
723         // make the swap
724         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
725             tokenAmount,
726             0, // accept any amount of ETH
727             path,
728             address(this),
729             block.timestamp
730         );
731     }
732     
733     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
734         // approve token transfer to cover all possible scenarios
735         _approve(address(this), address(dexRouter), tokenAmount);
736 
737         // add the liquidity
738         dexRouter.addLiquidityETH{value: ethAmount}(
739             address(this),
740             tokenAmount,
741             0, // slippage is unavoidable
742             0, // slippage is unavoidable
743             deadAddress,
744             block.timestamp
745         );
746     }
747 
748     function swapBack() private {
749         uint256 contractBalance = balanceOf(address(this));
750         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack + tokensForDev;
751         bool success;
752         
753         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
754 
755         if(contractBalance > swapTokensAtAmount * 20){
756             contractBalance = swapTokensAtAmount * 20;
757         }
758         
759         // Halve the amount of liquidity tokens
760         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
761         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
762         
763         uint256 initialETHBalance = address(this).balance;
764 
765         swapTokensForEth(amountToSwapForETH); 
766         
767         uint256 ethBalance = address(this).balance - initialETHBalance;
768         
769         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
770         uint256 ethForBuyBack = ethBalance * tokensForBuyBack / (totalTokensToSwap - (tokensForLiquidity/2));
771         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
772         
773         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack - ethForDev;
774         
775         
776         tokensForLiquidity = 0;
777         tokensForMarketing = 0;
778         tokensForBuyBack = 0;
779         tokensForDev = 0;
780 
781         
782         (success,) = address(devWallet).call{value: ethForDev}("");
783         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
784         
785         if(liquidityTokens > 0 && ethForLiquidity > 0){
786             addLiquidity(liquidityTokens, ethForLiquidity);
787             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
788         }
789         
790         // keep leftover ETH for buyback
791         
792     }
793 
794     // force Swap back if slippage issues.
795     function forceSwapBack() external onlyOwner {
796         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
797         swapping = true;
798         swapBack();
799         swapping = false;
800         emit OwnerForcedSwapBack(block.timestamp);
801     }
802     
803     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
804     function buyBackTokens(uint256 amountInWei) external onlyOwner {
805         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
806 
807         address[] memory path = new address[](2);
808         path[0] = dexRouter.WETH();
809         path[1] = address(this);
810 
811         // make the swap
812         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
813             0, // accept any amount of Ethereum
814             path,
815             address(0xdead),
816             block.timestamp
817         );
818         emit BuyBackTriggered(amountInWei);
819     }
820 
821     function setAutoBuyBackSettings(uint256 _frequencyInSeconds, uint256 _buyBackAmount, bool _autoBuyBackEnabled) external onlyOwner {
822         require(_frequencyInSeconds >= 30, "cannot set buyback more often than every 30 seconds");
823         require(_buyBackAmount <= 2 ether && _buyBackAmount >= 0.05 ether, "Must set auto buyback amount between .05 and 2 ETH");
824         autoBuyBackFrequency = _frequencyInSeconds;
825         amountForAutoBuyBack = _buyBackAmount;
826         autoBuyBackEnabled = _autoBuyBackEnabled;
827     }
828     
829     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
830         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
831         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 1% and 10%");
832         lpBurnFrequency = _frequencyInSeconds;
833         percentForLPBurn = _percent;
834         lpBurnEnabled = _Enabled;
835     }
836     
837     // automated buyback
838     function autoBuyBack(uint256 amountInWei) internal {
839         
840         lastAutoBuyBackTime = block.timestamp;
841         
842         address[] memory path = new address[](2);
843         path[0] = dexRouter.WETH();
844         path[1] = address(this);
845 
846         // make the swap
847         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
848             0, // accept any amount of Ethereum
849             path,
850             address(0xdead),
851             block.timestamp
852         );
853         
854         emit BuyBackTriggered(amountInWei);
855     }
856 
857     function isPenaltyActive() public view returns (bool) {
858         return tradingActiveBlock >= block.number - blockPenalty;
859     }
860     
861     function autoBurnLiquidityPairTokens() internal{
862         
863         lastLpBurnTime = block.timestamp;
864         
865         // get balance of liquidity pair
866         uint256 liquidityPairBalance = this.balanceOf(lpPair);
867         
868         // calculate amount to burn
869         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;
870         
871         if (amountToBurn > 0){
872             super._transfer(lpPair, address(0xdead), amountToBurn);
873         }
874         
875         //sync price since this is not in a swap transaction!
876         IDexPair pair = IDexPair(lpPair);
877         pair.sync();
878         emit AutoNukeLP(amountToBurn);
879     }
880 
881     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
882         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
883         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
884         lastManualLpBurnTime = block.timestamp;
885         
886         // get balance of liquidity pair
887         uint256 liquidityPairBalance = this.balanceOf(lpPair);
888         
889         // calculate amount to burn
890         uint256 amountToBurn = liquidityPairBalance * percent / 10000;
891         
892         if (amountToBurn > 0){
893             super._transfer(lpPair, address(0xdead), amountToBurn);
894         }
895         
896         //sync price since this is not in a swap transaction!
897         IDexPair pair = IDexPair(lpPair);
898         pair.sync();
899         emit ManualNukeLP(amountToBurn);
900     }
901 
902     function launch(uint256 _blockPenalty) external onlyOwner {
903         require(!tradingActive, "Trading is already active, cannot relaunch.");
904 
905         blockPenalty = _blockPenalty;
906 
907         //standard enable trading
908         tradingActive = true;
909         swapEnabled = true;
910         tradingActiveBlock = block.number;
911         lastLpBurnTime = block.timestamp;
912         limitsInEffect = true;
913 
914    
915       
916     }
917 
918     // withdraw ETH if stuck before launch
919     function withdrawStuckETH() external onlyOwner {
920         require(!tradingActive, "Can only withdraw if trading hasn't started");
921         bool success;
922         (success,) = address(msg.sender).call{value: address(this).balance}("");
923     }
924       function isBot(address account) public view returns (bool) {
925         return  _isBlackListedBot[account];
926     }
927   function addBotToBlackList(address account) external onlyOwner() {
928         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
929         require(!_isBlackListedBot[account], "Account is already blacklisted");
930         _isBlackListedBot[account] = true;
931         _blackListedBots.push(account);
932     }
933     
934     function removeBotFromBlackList(address account) external onlyOwner() {
935         require(_isBlackListedBot[account], "Account is not blacklisted");
936         for (uint256 i = 0; i < _blackListedBots.length; i++) {
937             if (_blackListedBots[i] == account) {
938                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
939                 _isBlackListedBot[account] = false;
940                 _blackListedBots.pop();
941                 break;
942             }
943         }
944     }
945 }