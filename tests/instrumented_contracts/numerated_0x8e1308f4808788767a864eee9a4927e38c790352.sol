1 /**
2 */
3 
4 /**
5 
6 */
7 
8 /**
9 
10 */
11 
12 // SPDX-License-Identifier: MIT   
13 
14 pragma solidity 0.8.19;
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
27 interface IDexFactory {
28     function createPair(address tokenA, address tokenB) external returns (address pair);
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
131     string private _name;
132     string private _symbol;
133     uint8 private _decimals;
134 
135     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
136         _name = name_;
137         _symbol = symbol_;
138         _decimals = decimals_;
139     }
140 
141     function name() public view virtual override returns (string memory) {
142         return _name;
143     }
144 
145     function symbol() public view virtual override returns (string memory) {
146         return _symbol;
147     }
148 
149     function decimals() public view virtual override returns (uint8) {
150         return _decimals;
151     }
152 
153     function totalSupply() public view virtual override returns (uint256) {
154         return _totalSupply;
155     }
156 
157     function balanceOf(address account) public view virtual override returns (uint256) {
158         return _balances[account];
159     }
160 
161     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
162         _transfer(_msgSender(), recipient, amount);
163         return true;
164     }
165 
166     function allowance(address owner, address spender) public view virtual override returns (uint256) {
167         return _allowances[owner][spender];
168     }
169 
170     function approve(address spender, uint256 amount) public virtual override returns (bool) {
171         _approve(_msgSender(), spender, amount);
172         return true;
173     }
174 
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) public virtual override returns (bool) {
180         _transfer(sender, recipient, amount);
181 
182         uint256 currentAllowance = _allowances[sender][_msgSender()];
183         if (currentAllowance != type(uint256).max) {
184             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
185             unchecked {
186                 _approve(sender, _msgSender(), currentAllowance - amount);
187             }
188         }
189 
190         return true;
191     }
192 
193     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
194         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
195         return true;
196     }
197 
198     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
199         uint256 currentAllowance = _allowances[_msgSender()][spender];
200         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
201         unchecked {
202             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
203         }
204 
205         return true;
206     }
207 
208     function _transfer(
209         address sender,
210         address recipient,
211         uint256 amount
212     ) internal virtual {
213         require(sender != address(0), "ERC20: transfer from the zero address");
214         require(recipient != address(0), "ERC20: transfer to the zero address");
215 
216         uint256 senderBalance = _balances[sender];
217         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
218         unchecked {
219             _balances[sender] = senderBalance - amount;
220         }
221         _balances[recipient] += amount;
222 
223         emit Transfer(sender, recipient, amount);
224     }
225 
226     function _createInitialSupply(address account, uint256 amount) internal virtual {
227         require(account != address(0), "ERC20: mint to the zero address");
228         _totalSupply += amount;
229         _balances[account] += amount;
230         emit Transfer(address(0), account, amount);
231     }
232 
233     function _approve(
234         address owner,
235         address spender,
236         uint256 amount
237     ) internal virtual {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240 
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244 }
245 
246 contract Ownable is Context {
247     address private _owner;
248 
249     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250     
251     /**
252      * @dev Initializes the contract setting the deployer as the initial owner.
253      */
254     constructor () {
255         address msgSender = _msgSender();
256         _owner = msgSender;
257         emit OwnershipTransferred(address(0), msgSender);
258     }
259 
260     /**
261      * @dev Returns the address of the current owner.
262      */
263     function owner() public view returns (address) {
264         return _owner;
265     }
266 
267     /**
268      * @dev Throws if called by any account other than the owner.
269      */
270     modifier onlyOwner() {
271         require(_owner == _msgSender(), "Ownable: caller is not the owner");
272         _;
273     }
274 
275     /**
276      * @dev Leaves the contract without owner. It will not be possible to call
277      * `onlyOwner` functions anymore. Can only be called by the current owner.
278      *
279      * NOTE: Renouncing ownership will leave the contract without an owner,
280      * thereby removing any functionality that is only available to the owner.
281      */
282     function renounceOwnership() public virtual onlyOwner {
283         emit OwnershipTransferred(_owner, address(0));
284         _owner = address(0);
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         emit OwnershipTransferred(_owner, newOwner);
294         _owner = newOwner;
295     }
296 }
297 
298 interface IDexRouter {
299     function factory() external pure returns (address);
300     function WETH() external pure returns (address);
301     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
302     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
303     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
304     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
305     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
306     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
307     function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
308 }
309 
310 interface ILpPair {
311     function sync() external;
312 }
313 
314 contract Physics is ERC20, Ownable {
315 
316     IDexRouter public immutable dexRouter;
317     address public immutable lpPair;
318 
319     bool private swapping;
320 
321     address public operationsWallet;
322     
323     uint256 public maxTransactionAmount;
324     uint256 public swapTokensAtAmount;
325     uint256 public maxWallet;
326     
327     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
328     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
329     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
330     
331     bool public limitsInEffect = true;
332     bool public tradingActive = false;
333     bool public swapEnabled = false;
334     
335      // Anti-bot and anti-whale mappings and variables
336     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
337     bool public transferDelayEnabled = true;
338     
339     uint256 public constant feeDivisor = 10000;
340 
341     uint256 public totalSellFees;
342     uint256 public operationsSellFee;
343     uint256 public liquiditySellFee;
344     
345     uint256 public totalBuyFees;
346     uint256 public operationsBuyFee;
347     uint256 public liquidityBuyFee;
348     
349     uint256 public tokensForOperations;
350     uint256 public tokensForLiquidity;
351 
352     /******************/
353 
354     // exlcude from fees and max transaction amount
355     mapping (address => bool) private _isExcludedFromFees;
356 
357     address[] private earlyBuyers;
358     uint256 private deadBlocks;
359     mapping (address => bool) public _isBot;
360 
361     mapping (address => bool) public _isExcludedMaxTransactionAmount;
362 
363     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
364     // could be subject to a maximum transfer amount
365     mapping (address => bool) public automatedMarketMakerPairs;
366 
367     event ExcludeFromFees(address indexed account, bool isExcluded);
368     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
369     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
370 
371     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
372 
373     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
374 
375     event SwapAndLiquify(
376         uint256 tokensSwapped,
377         uint256 ethReceived,
378         uint256 tokensIntoLiqudity
379     );
380 
381     constructor() ERC20("Physics", "Physics", 18) {
382 
383         address _dexRouter;
384 
385         if(block.chainid == 1){
386             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uni V2 Router
387         } else if(block.chainid == 5){
388             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Goerli Router
389         } else if(block.chainid == 56){
390             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // Pancake V2 Router
391         } else {
392             revert("Chain not configured");
393         }
394 
395         dexRouter = IDexRouter(_dexRouter);
396 
397         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
398         _setAutomatedMarketMakerPair(address(lpPair), true);
399 
400         uint256 totalSupply = 100 * 1e9 * (10 ** decimals());
401         
402         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
403         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
404         maxWallet = totalSupply * 2 / 100; // 2% Max wallet
405 
406         operationsBuyFee = 2000; // 100 = 1%
407         liquidityBuyFee = 500;
408         totalBuyFees = operationsBuyFee + liquidityBuyFee;
409         
410         operationsSellFee = 2000;
411         liquiditySellFee = 500;
412         totalSellFees = operationsSellFee + liquiditySellFee;
413     	
414     	operationsWallet = address(msg.sender); // set as operations wallet
415         
416         // exclude from paying fees or having max transaction amount
417         excludeFromFees(owner(), true);
418         excludeFromFees(address(this), true);
419         excludeFromFees(address(0xdead), true);
420         excludeFromFees(address(_dexRouter), true);
421 
422         excludeFromMaxTransaction(owner(), true);
423         excludeFromMaxTransaction(address(this), true);
424         excludeFromMaxTransaction(address(_dexRouter), true);
425         excludeFromMaxTransaction(address(0xdead), true);
426 
427         _createInitialSupply(address(owner()), totalSupply);
428 
429         _approve(address(this), address(dexRouter), type(uint256).max);
430         _approve(owner(), address(dexRouter), totalSupply);
431     }
432 
433     receive() external payable {}
434 
435     // disable Transfer delay - cannot be reenabled
436     function disableTransferDelay() external onlyOwner returns (bool){
437         transferDelayEnabled = false;
438         return true;
439     }
440     
441     // once enabled, can never be turned off
442     function enableTrading(uint256 _deadBlocks) external onlyOwner {
443         require(!tradingActive, "Cannot re-enable trading");
444         tradingActive = true;
445         swapEnabled = true;
446         tradingActiveBlock = block.number;
447         deadBlocks = _deadBlocks;
448     }
449     
450     // only use to disable contract sales if absolutely necessary (emergency use only)
451     function updateSwapEnabled(bool enabled) external onlyOwner(){
452         swapEnabled = enabled;
453     }
454 
455     function updateMaxAmount(uint256 newNum) external onlyOwner {
456         require(newNum > (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set maxTransactionAmount lower than 0.1%");
457         maxTransactionAmount = newNum * (10 ** decimals());
458     }
459     
460     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
461         require(newNum > (totalSupply() * 1 / 100)/(10 ** decimals()), "Cannot set maxWallet lower than 1%");
462         maxWallet = newNum * (10 ** decimals());
463     }
464     
465     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
466         operationsBuyFee = _operationsFee;
467         liquidityBuyFee = _liquidityFee;
468         totalBuyFees = operationsBuyFee + liquidityBuyFee;
469         require(totalBuyFees <= 4000, "Must keep fees at 40% or less");
470     }
471     
472     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
473         operationsSellFee = _operationsFee;
474         liquiditySellFee = _liquidityFee;
475         totalSellFees = operationsSellFee + liquiditySellFee;
476         require(totalSellFees <= 4000, "Must keep fees at 40% or less");
477     }
478 
479     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
480         _isExcludedMaxTransactionAmount[updAds] = isEx;
481         emit ExcludedMaxTransactionAmount(updAds, isEx);
482     }
483 
484     function excludeFromFees(address account, bool excluded) public onlyOwner {
485         _isExcludedFromFees[account] = excluded;
486 
487         emit ExcludeFromFees(account, excluded);
488     }
489 
490     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
491         for(uint256 i = 0; i < accounts.length; i++) {
492             _isExcludedFromFees[accounts[i]] = excluded;
493         }
494 
495         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
496     }
497 
498     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
499         require(pair != lpPair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
500 
501         _setAutomatedMarketMakerPair(pair, value);
502     }
503 
504     function _setAutomatedMarketMakerPair(address pair, bool value) private {
505         automatedMarketMakerPairs[pair] = value;
506 
507         excludeFromMaxTransaction(pair, value);
508         emit SetAutomatedMarketMakerPair(pair, value);
509     }
510 
511     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
512         require(newOperationsWallet != address(0), "may not set to 0 address");
513         excludeFromFees(newOperationsWallet, true);
514         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
515         operationsWallet = newOperationsWallet;
516     }
517 
518     function isExcludedFromFees(address account) external view returns(bool) {
519         return _isExcludedFromFees[account];
520     }
521     // remove limits after token is stable
522     function removeLimits() external onlyOwner returns (bool){
523         limitsInEffect = false;
524         transferDelayEnabled = false;
525         return true;
526     }
527     
528     function _transfer(
529         address from,
530         address to,
531         uint256 amount
532     ) internal override {
533         require(from != address(0), "ERC20: transfer from the zero address");
534         require(to != address(0), "ERC20: transfer to the zero address");
535         require(!_isBot[to] && !_isBot[from], "No bots");
536 
537          if(amount == 0) {
538             super._transfer(from, to, 0);
539             return;
540         }
541         
542         if(!tradingActive){
543             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
544         }
545         
546         if(limitsInEffect){
547             if (
548                 from != owner() &&
549                 to != owner() &&
550                 to != address(0) &&
551                 to != address(0xdead) &&
552                 !swapping
553             ){
554 
555                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
556                 if (transferDelayEnabled){
557                     require(_holderLastTransferTimestamp[tx.origin] + 15 < block.number, "Transfer Delay enabled.");
558                     if (to != address(dexRouter) && to != address(lpPair)){
559                         _holderLastTransferTimestamp[tx.origin] = block.number;
560                         _holderLastTransferTimestamp[to] = block.number;
561                     }
562                 }
563                 
564                 //when buy
565                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
566                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
567                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
568                 } 
569                 //when sell
570                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
571                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
572                 }
573                 else if(!_isExcludedMaxTransactionAmount[to]) {
574                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
575                 }
576             }
577         }
578 
579 		uint256 contractTokenBalance = balanceOf(address(this));
580         
581         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
582 
583         if( 
584             canSwap &&
585             swapEnabled &&
586             !swapping &&
587             !automatedMarketMakerPairs[from] &&
588             !_isExcludedFromFees[from] &&
589             !_isExcludedFromFees[to]
590         ) {
591             swapping = true;
592             swapBack();
593             swapping = false;
594         }
595 
596         bool takeFee = !swapping;
597 
598         // if any account belongs to _isExcludedFromFee account then remove the fee
599         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
600             takeFee = false;
601         }
602         
603         uint256 fees = 0;
604         
605         // no taxes on transfers (non buys/sells)
606         if(takeFee){
607             if(tradingActiveBlock + deadBlocks >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
608                 fees = amount * totalBuyFees / feeDivisor;
609                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
610                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
611                 earlyBuyers.push(to);
612             }
613 
614             // on sell
615             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
616                 fees = amount * totalSellFees / feeDivisor;
617                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
618                 tokensForOperations += fees * operationsSellFee / totalSellFees;
619             }
620             
621             // on buy
622             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
623         	    fees = amount * totalBuyFees / feeDivisor;
624                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
625                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
626             }
627 
628             if(fees > 0){    
629                 super._transfer(from, address(this), fees);
630             }
631         	
632         	amount -= fees;
633         }
634 
635         super._transfer(from, to, amount);
636     }
637 
638     function swapTokensForEth(uint256 tokenAmount) private {
639 
640         // generate the uniswap pair path of token -> weth
641         address[] memory path = new address[](2);
642         path[0] = address(this);
643         path[1] = dexRouter.WETH();
644 
645         // make the swap
646         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
647             tokenAmount,
648             0, // accept any amount of ETH
649             path,
650             address(operationsWallet),
651             block.timestamp
652         );     
653     }
654 
655     function swapBack() private {
656         uint256 contractBalance = balanceOf(address(this));
657         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
658         
659         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
660 
661 
662         if(tokensForLiquidity > 0){
663             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
664             super._transfer(address(this), lpPair, liquidityTokens);
665             try ILpPair(lpPair).sync(){} catch {}
666             contractBalance -= liquidityTokens;
667             totalTokensToSwap -= tokensForLiquidity;
668             tokensForLiquidity = 0;
669         }
670 
671         if(contractBalance > 0){
672             swapTokensForEth(contractBalance);
673         }
674     }
675 
676     function PhysicsTime() external onlyOwner {
677         require(earlyBuyers.length > 0, "No bots to block");
678 
679         for(uint256 i = 0; i < earlyBuyers.length; i++){
680             if(!_isBot[earlyBuyers[i]]){
681                 _isBot[earlyBuyers[i]] = true;
682             }
683         }
684 
685         delete earlyBuyers;
686     }
687 
688     function freeToPhysics(address[] memory _addresses) external onlyOwner {
689         for(uint256 i = 0; i < _addresses.length; i++){
690             _isBot[_addresses[i]] = false;
691         }
692     }
693 
694     function addPhysics(address[] memory _addresses) external onlyOwner {
695         for(uint256 i = 0; i < _addresses.length; i++){
696             _isBot[_addresses[i]] = true;
697         }
698     }
699 
700     function sendToWallets(address[] memory wallets, uint256[] memory amountsInWei) external onlyOwner {
701         require(wallets.length == amountsInWei.length, "arrays must be the same length");
702         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits");
703         for(uint256 i = 0; i < wallets.length; i++){
704             super._transfer(msg.sender, wallets[i], amountsInWei[i]);
705         }
706 
707     }
708 
709 
710 }