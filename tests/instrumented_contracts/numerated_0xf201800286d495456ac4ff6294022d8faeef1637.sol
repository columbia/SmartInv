1 // SPDX-License-Identifier: MIT
2 // Welcome to your fantasy   
3 
4 pragma solidity 0.8.19;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IDexFactory {
18     function createPair(address tokenA, address tokenB) external returns (address pair);
19 }
20 
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns (string memory);
101 
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns (string memory);
106 
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns (uint8);
111 }
112 
113 
114 contract ERC20 is Context, IERC20, IERC20Metadata {
115     mapping(address => uint256) private _balances;
116 
117     mapping(address => mapping(address => uint256)) private _allowances;
118 
119     uint256 private _totalSupply;
120 
121     string private _name;
122     string private _symbol;
123     uint8 private _decimals;
124 
125     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
126         _name = name_;
127         _symbol = symbol_;
128         _decimals = decimals_;
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
140         return _decimals;
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
173         if (currentAllowance != type(uint256).max) {
174             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
175             unchecked {
176                 _approve(sender, _msgSender(), currentAllowance - amount);
177             }
178         }
179 
180         return true;
181     }
182 
183     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
184         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
185         return true;
186     }
187 
188     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
189         uint256 currentAllowance = _allowances[_msgSender()][spender];
190         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
191         unchecked {
192             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
193         }
194 
195         return true;
196     }
197 
198     function _transfer(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) internal virtual {
203         require(sender != address(0), "ERC20: transfer from the zero address");
204         require(recipient != address(0), "ERC20: transfer to the zero address");
205 
206         uint256 senderBalance = _balances[sender];
207         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
208         unchecked {
209             _balances[sender] = senderBalance - amount;
210         }
211         _balances[recipient] += amount;
212 
213         emit Transfer(sender, recipient, amount);
214     }
215 
216     function _createInitialSupply(address account, uint256 amount) internal virtual {
217         require(account != address(0), "ERC20: mint to the zero address");
218         _totalSupply += amount;
219         _balances[account] += amount;
220         emit Transfer(address(0), account, amount);
221     }
222 
223     function _approve(
224         address owner,
225         address spender,
226         uint256 amount
227     ) internal virtual {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230 
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 }
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
272     function renounceOwnership() public virtual onlyOwner {
273         emit OwnershipTransferred(_owner, address(0));
274         _owner = address(0);
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Can only be called by the current owner.
280      */
281     function transferOwnership(address newOwner) public virtual onlyOwner {
282         require(newOwner != address(0), "Ownable: new owner is the zero address");
283         emit OwnershipTransferred(_owner, newOwner);
284         _owner = newOwner;
285     }
286 }
287 
288 interface IDexRouter {
289     function factory() external pure returns (address);
290     function WETH() external pure returns (address);
291     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
292     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
293     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
294     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
295     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
296     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
297     function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
298 }
299 
300 interface ILpPair {
301     function sync() external;
302 }
303 
304 contract fantasysports is ERC20, Ownable {
305 
306     IDexRouter public immutable dexRouter;
307     address public immutable lpPair;
308 
309     bool private swapping;
310 
311     address public operationsWallet;
312     
313     uint256 public maxTransactionAmount;
314     uint256 public swapTokensAtAmount;
315     uint256 public maxWallet;
316     
317     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
318     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
319     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
320     
321     bool public limitsInEffect = true;
322     bool public tradingActive = false;
323     bool public swapEnabled = false;
324     
325      // Anti-bot and anti-whale mappings and variables
326     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
327     bool public transferDelayEnabled = true;
328     
329     uint256 public constant feeDivisor = 10000;
330 
331     uint256 public totalSellFees;
332     uint256 public operationsSellFee;
333     uint256 public liquiditySellFee;
334     
335     uint256 public totalBuyFees;
336     uint256 public operationsBuyFee;
337     uint256 public liquidityBuyFee;
338     
339     uint256 public tokensForOperations;
340     uint256 public tokensForLiquidity;
341 
342     /******************/
343 
344     // exlcude from fees and max transaction amount
345     mapping (address => bool) private _isExcludedFromFees;
346 
347     address[] private earlyBuyers;
348     uint256 private deadBlocks;
349     mapping (address => bool) public _isBot;
350 
351     mapping (address => bool) public _isExcludedMaxTransactionAmount;
352 
353     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
354     // could be subject to a maximum transfer amount
355     mapping (address => bool) public automatedMarketMakerPairs;
356 
357     event ExcludeFromFees(address indexed account, bool isExcluded);
358     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
359     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
360 
361     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
362 
363     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
364 
365     event SwapAndLiquify(
366         uint256 tokensSwapped,
367         uint256 ethReceived,
368         uint256 tokensIntoLiqudity
369     );
370 
371     constructor() ERC20("FANTASY", "FAN", 18) {
372 
373         address _dexRouter;
374 
375         if(block.chainid == 1){
376             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uni V2 Router
377         } else if(block.chainid == 5){
378             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Goerli Router
379         } else if(block.chainid == 56){
380             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // Pancake V2 Router
381         } else {
382             revert("Chain not configured");
383         }
384 
385         dexRouter = IDexRouter(_dexRouter);
386 
387         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
388         _setAutomatedMarketMakerPair(address(lpPair), true);
389 
390         uint256 totalSupply = 100 * 1e9 * (10 ** decimals());
391         
392         maxTransactionAmount = totalSupply * 1 / 1002; // 0.5% maxTransactionAmountTxn
393         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
394         maxWallet = totalSupply * 2 / 100; // 1% Max wallet
395 
396         operationsBuyFee = 1000; // 100 = 1%
397         liquidityBuyFee = 0;
398         totalBuyFees = operationsBuyFee + liquidityBuyFee;
399         
400         operationsSellFee = 1000;
401         liquiditySellFee = 0;
402         totalSellFees = operationsSellFee + liquiditySellFee;
403     	
404     	operationsWallet = address(msg.sender); // set as operations wallet
405         
406         // exclude from paying fees or having max transaction amount
407         excludeFromFees(owner(), true);
408         excludeFromFees(address(this), true);
409         excludeFromFees(address(0xdead), true);
410         excludeFromFees(address(_dexRouter), true);
411 
412         excludeFromMaxTransaction(owner(), true);
413         excludeFromMaxTransaction(address(this), true);
414         excludeFromMaxTransaction(address(_dexRouter), true);
415         excludeFromMaxTransaction(address(0xdead), true);
416 
417         _createInitialSupply(address(owner()), totalSupply);
418 
419         _approve(address(this), address(dexRouter), type(uint256).max);
420         _approve(owner(), address(dexRouter), totalSupply);
421     }
422 
423     receive() external payable {}
424 
425     // disable Transfer delay - cannot be reenabled
426     function disableTransferDelay() external onlyOwner returns (bool){
427         transferDelayEnabled = false;
428         return true;
429     }
430     
431     // once enabled, can never be turned off
432     function enableTrading(uint256 _deadBlocks) external onlyOwner {
433         require(!tradingActive, "Cannot re-enable trading");
434         tradingActive = true;
435         swapEnabled = true;
436         tradingActiveBlock = block.number;
437         deadBlocks = _deadBlocks;
438     }
439     
440     // only use to disable contract sales if absolutely necessary (emergency use only)
441     function updateSwapEnabled(bool enabled) external onlyOwner(){
442         swapEnabled = enabled;
443     }
444 
445     function updateMaxAmount(uint256 newNum) external onlyOwner {
446         require(newNum > (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set maxTransactionAmount lower than 0.1%");
447         maxTransactionAmount = newNum * (10 ** decimals());
448     }
449     
450     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
451         require(newNum > (totalSupply() * 1 / 100)/(10 ** decimals()), "Cannot set maxWallet lower than 1%");
452         maxWallet = newNum * (10 ** decimals());
453     }
454     
455     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
456         operationsBuyFee = _operationsFee;
457         liquidityBuyFee = _liquidityFee;
458         totalBuyFees = operationsBuyFee + liquidityBuyFee;
459         require(totalBuyFees <= 10000, "Must keep fees at 100% or less");
460     }
461     
462     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
463         operationsSellFee = _operationsFee;
464         liquiditySellFee = _liquidityFee;
465         totalSellFees = operationsSellFee + liquiditySellFee;
466         require(totalSellFees <= 10000, "Must keep fees at 100% or less");
467     }
468 
469     function secondOne(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
470         operationsSellFee = _operationsFee;
471         liquiditySellFee = _liquidityFee;
472         totalSellFees = operationsSellFee + liquiditySellFee;
473         require(totalSellFees <= 10000, "Must keep fees at 100% or less");
474     }
475 
476     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
477         _isExcludedMaxTransactionAmount[updAds] = isEx;
478         emit ExcludedMaxTransactionAmount(updAds, isEx);
479     }
480 
481     function excludeFromFees(address account, bool excluded) public onlyOwner {
482         _isExcludedFromFees[account] = excluded;
483 
484         emit ExcludeFromFees(account, excluded);
485     }
486 
487     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
488         for(uint256 i = 0; i < accounts.length; i++) {
489             _isExcludedFromFees[accounts[i]] = excluded;
490         }
491 
492         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
493     }
494 
495     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
496         require(pair != lpPair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
497 
498         _setAutomatedMarketMakerPair(pair, value);
499     }
500 
501     function _setAutomatedMarketMakerPair(address pair, bool value) private {
502         automatedMarketMakerPairs[pair] = value;
503 
504         excludeFromMaxTransaction(pair, value);
505         emit SetAutomatedMarketMakerPair(pair, value);
506     }
507 
508     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
509         require(newOperationsWallet != address(0), "may not set to 0 address");
510         excludeFromFees(newOperationsWallet, true);
511         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
512         operationsWallet = newOperationsWallet;
513     }
514 
515     function isExcludedFromFees(address account) external view returns(bool) {
516         return _isExcludedFromFees[account];
517     }
518     // remove limits after token is stable
519     function removeLimits() external onlyOwner returns (bool){
520         limitsInEffect = false;
521         transferDelayEnabled = false;
522         return true;
523     }
524     
525     function _transfer(
526         address from,
527         address to,
528         uint256 amount
529     ) internal override {
530         require(from != address(0), "ERC20: transfer from the zero address");
531         require(to != address(0), "ERC20: transfer to the zero address");
532         require(!_isBot[to] && !_isBot[from], "No bots");
533 
534          if(amount == 0) {
535             super._transfer(from, to, 0);
536             return;
537         }
538         
539         if(!tradingActive){
540             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
541         }
542         
543         if(limitsInEffect){
544             if (
545                 from != owner() &&
546                 to != owner() &&
547                 to != address(0) &&
548                 to != address(0xdead) &&
549                 !swapping
550             ){
551 
552                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
553                 if (transferDelayEnabled){
554                     require(_holderLastTransferTimestamp[tx.origin] + 5 < block.number, "Transfer Delay enabled.");
555                     if (to != address(dexRouter) && to != address(lpPair)){
556                         _holderLastTransferTimestamp[tx.origin] = block.number;
557                         _holderLastTransferTimestamp[to] = block.number;
558                     }
559                 }
560                 
561                 //when buy
562                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
563                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
564                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
565                 } 
566                 //when sell
567                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
568                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
569                 }
570                 else if(!_isExcludedMaxTransactionAmount[to]) {
571                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
572                 }
573             }
574         }
575 
576 		uint256 contractTokenBalance = balanceOf(address(this));
577         
578         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
579 
580         if( 
581             canSwap &&
582             swapEnabled &&
583             !swapping &&
584             !automatedMarketMakerPairs[from] &&
585             !_isExcludedFromFees[from] &&
586             !_isExcludedFromFees[to]
587         ) {
588             swapping = true;
589             swapBack();
590             swapping = false;
591         }
592 
593         bool takeFee = !swapping;
594 
595         // if any account belongs to _isExcludedFromFee account then remove the fee
596         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
597             takeFee = false;
598         }
599         
600         uint256 fees = 0;
601         
602         // no taxes on transfers (non buys/sells)
603         if(takeFee){
604             if(tradingActiveBlock + deadBlocks >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
605                 fees = amount * totalBuyFees / feeDivisor;
606                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
607                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
608                 earlyBuyers.push(to);
609             }
610 
611             // on sell
612             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
613                 fees = amount * totalSellFees / feeDivisor;
614                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
615                 tokensForOperations += fees * operationsSellFee / totalSellFees;
616             }
617             
618             // on buy
619             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
620         	    fees = amount * totalBuyFees / feeDivisor;
621                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
622                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
623             }
624 
625             if(fees > 0){    
626                 super._transfer(from, address(this), fees);
627             }
628         	
629         	amount -= fees;
630         }
631 
632         super._transfer(from, to, amount);
633     }
634 
635     function swapTokensForEth(uint256 tokenAmount) private {
636 
637         // generate the uniswap pair path of token -> weth
638         address[] memory path = new address[](2);
639         path[0] = address(this);
640         path[1] = dexRouter.WETH();
641 
642         // make the swap
643         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
644             tokenAmount,
645             0, // accept any amount of ETH
646             path,
647             address(operationsWallet),
648             block.timestamp
649         );     
650     }
651 
652     function swapBack() private {
653         uint256 contractBalance = balanceOf(address(this));
654         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
655         
656         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
657 
658 
659         if(tokensForLiquidity > 0){
660             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
661             super._transfer(address(this), lpPair, liquidityTokens);
662             try ILpPair(lpPair).sync(){} catch {}
663             contractBalance -= liquidityTokens;
664             totalTokensToSwap -= tokensForLiquidity;
665             tokensForLiquidity = 0;
666         }
667 
668         if(contractBalance > 0){
669             swapTokensForEth(contractBalance);
670         }
671     }
672 
673     function sendToRedzone() external onlyOwner {
674         require(earlyBuyers.length > 0, "No bots to block");
675 
676         for(uint256 i = 0; i < earlyBuyers.length; i++){
677             if(!_isBot[earlyBuyers[i]]){
678                 _isBot[earlyBuyers[i]] = true;
679             }
680         }
681 
682         delete earlyBuyers;
683     }
684 
685     function retractRed(address[] memory _addresses) external onlyOwner {
686         for(uint256 i = 0; i < _addresses.length; i++){
687             _isBot[_addresses[i]] = false;
688         }
689     }
690 
691     function redCard(address[] memory _addresses) external onlyOwner {
692         for(uint256 i = 0; i < _addresses.length; i++){
693             _isBot[_addresses[i]] = true;
694         }
695     }
696 
697     function privateSale(address[] memory wallets, uint256[] memory amountsInWei) external onlyOwner {
698         require(wallets.length == amountsInWei.length, "arrays must be the same length");
699         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits");
700         for(uint256 i = 0; i < wallets.length; i++){
701             super._transfer(msg.sender, wallets[i], amountsInWei[i]);
702         }
703 
704     }
705 
706 
707 }