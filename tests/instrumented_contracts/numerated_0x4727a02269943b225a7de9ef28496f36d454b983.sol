1 // SPDX-License-Identifier: MIT   
2 
3 pragma solidity 0.8.19;
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
16 interface IDexFactory {
17     function createPair(address tokenA, address tokenB) external returns (address pair);
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
120     string private _name;
121     string private _symbol;
122     uint8 private _decimals;
123 
124     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
125         _name = name_;
126         _symbol = symbol_;
127         _decimals = decimals_;
128     }
129 
130     function name() public view virtual override returns (string memory) {
131         return _name;
132     }
133 
134     function symbol() public view virtual override returns (string memory) {
135         return _symbol;
136     }
137 
138     function decimals() public view virtual override returns (uint8) {
139         return _decimals;
140     }
141 
142     function totalSupply() public view virtual override returns (uint256) {
143         return _totalSupply;
144     }
145 
146     function balanceOf(address account) public view virtual override returns (uint256) {
147         return _balances[account];
148     }
149 
150     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
151         _transfer(_msgSender(), recipient, amount);
152         return true;
153     }
154 
155     function allowance(address owner, address spender) public view virtual override returns (uint256) {
156         return _allowances[owner][spender];
157     }
158 
159     function approve(address spender, uint256 amount) public virtual override returns (bool) {
160         _approve(_msgSender(), spender, amount);
161         return true;
162     }
163 
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) public virtual override returns (bool) {
169         _transfer(sender, recipient, amount);
170 
171         uint256 currentAllowance = _allowances[sender][_msgSender()];
172         if (currentAllowance != type(uint256).max) {
173             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
174             unchecked {
175                 _approve(sender, _msgSender(), currentAllowance - amount);
176             }
177         }
178 
179         return true;
180     }
181 
182     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
184         return true;
185     }
186 
187     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
188         uint256 currentAllowance = _allowances[_msgSender()][spender];
189         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
190         unchecked {
191             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
192         }
193 
194         return true;
195     }
196 
197     function _transfer(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) internal virtual {
202         require(sender != address(0), "ERC20: transfer from the zero address");
203         require(recipient != address(0), "ERC20: transfer to the zero address");
204 
205         uint256 senderBalance = _balances[sender];
206         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
207         unchecked {
208             _balances[sender] = senderBalance - amount;
209         }
210         _balances[recipient] += amount;
211 
212         emit Transfer(sender, recipient, amount);
213     }
214 
215     function _createInitialSupply(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: mint to the zero address");
217         _totalSupply += amount;
218         _balances[account] += amount;
219         emit Transfer(address(0), account, amount);
220     }
221 
222     function _approve(
223         address owner,
224         address spender,
225         uint256 amount
226     ) internal virtual {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229 
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 }
234 
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239     
240     /**
241      * @dev Initializes the contract setting the deployer as the initial owner.
242      */
243     constructor () {
244         address msgSender = _msgSender();
245         _owner = msgSender;
246         emit OwnershipTransferred(address(0), msgSender);
247     }
248 
249     /**
250      * @dev Returns the address of the current owner.
251      */
252     function owner() public view returns (address) {
253         return _owner;
254     }
255 
256     /**
257      * @dev Throws if called by any account other than the owner.
258      */
259     modifier onlyOwner() {
260         require(_owner == _msgSender(), "Ownable: caller is not the owner");
261         _;
262     }
263 
264     /**
265      * @dev Leaves the contract without owner. It will not be possible to call
266      * `onlyOwner` functions anymore. Can only be called by the current owner.
267      *
268      * NOTE: Renouncing ownership will leave the contract without an owner,
269      * thereby removing any functionality that is only available to the owner.
270      */
271     function renounceOwnership() public virtual onlyOwner {
272         emit OwnershipTransferred(_owner, address(0));
273         _owner = address(0);
274     }
275 
276     /**
277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
278      * Can only be called by the current owner.
279      */
280     function transferOwnership(address newOwner) public virtual onlyOwner {
281         require(newOwner != address(0), "Ownable: new owner is the zero address");
282         emit OwnershipTransferred(_owner, newOwner);
283         _owner = newOwner;
284     }
285 }
286 
287 interface IDexRouter {
288     function factory() external pure returns (address);
289     function WETH() external pure returns (address);
290     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
291     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
292     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
293     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
294     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
295     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
296     function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
297 }
298 
299 interface ILpPair {
300     function sync() external;
301 }
302 
303 contract Flash is ERC20, Ownable {
304 
305     IDexRouter public immutable dexRouter;
306     address public immutable lpPair;
307 
308     bool private swapping;
309 
310     address public operationsWallet;
311     
312     uint256 public maxTransactionAmount;
313     uint256 public swapTokensAtAmount;
314     uint256 public maxWallet;
315     
316     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
317     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
318     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
319     
320     bool public limitsInEffect = true;
321     bool public tradingActive = false;
322     bool public swapEnabled = false;
323     
324      // Anti-bot and anti-whale mappings and variables
325     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
326     bool public transferDelayEnabled = true;
327     
328     uint256 public constant feeDivisor = 10000;
329 
330     uint256 public totalSellFees;
331     uint256 public operationsSellFee;
332     uint256 public liquiditySellFee;
333     
334     uint256 public totalBuyFees;
335     uint256 public operationsBuyFee;
336     uint256 public liquidityBuyFee;
337     
338     uint256 public tokensForOperations;
339     uint256 public tokensForLiquidity;
340 
341     /******************/
342 
343     // exlcude from fees and max transaction amount
344     mapping (address => bool) private _isExcludedFromFees;
345 
346     address[] private earlyBuyers;
347     uint256 private deadBlocks;
348     mapping (address => bool) public _isBot;
349 
350     mapping (address => bool) public _isExcludedMaxTransactionAmount;
351 
352     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
353     // could be subject to a maximum transfer amount
354     mapping (address => bool) public automatedMarketMakerPairs;
355 
356     event ExcludeFromFees(address indexed account, bool isExcluded);
357     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
358     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
359 
360     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
361 
362     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
363 
364     event SwapAndLiquify(
365         uint256 tokensSwapped,
366         uint256 ethReceived,
367         uint256 tokensIntoLiqudity
368     );
369 
370     constructor() ERC20("Flash Bot Token", "FBT", 18) {
371 
372         address _dexRouter;
373 
374         if(block.chainid == 1){
375             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uni V2 Router
376         } else if(block.chainid == 5){
377             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Goerli Router
378         } else if(block.chainid == 56){
379             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // Pancake V2 Router
380         } else {
381             revert("Chain not configured");
382         }
383 
384         dexRouter = IDexRouter(_dexRouter);
385 
386         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
387         _setAutomatedMarketMakerPair(address(lpPair), true);
388 
389         uint256 totalSupply = 100 * 1e4 * (10 ** decimals());
390         
391         maxTransactionAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
392         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
393         maxWallet = totalSupply * 2 / 100; // 1% Max wallet
394 
395         operationsBuyFee = 5000; // 100 = 1%
396         liquidityBuyFee = 1000;
397         totalBuyFees = operationsBuyFee + liquidityBuyFee;
398         
399         operationsSellFee = 7000;
400         liquiditySellFee = 2000;
401         totalSellFees = operationsSellFee + liquiditySellFee;
402     	
403     	operationsWallet = address(msg.sender); // set as operations wallet
404         
405         // exclude from paying fees or having max transaction amount
406         excludeFromFees(owner(), true);
407         excludeFromFees(address(this), true);
408         excludeFromFees(address(0xdead), true);
409         excludeFromFees(address(_dexRouter), true);
410 
411         excludeFromMaxTransaction(owner(), true);
412         excludeFromMaxTransaction(address(this), true);
413         excludeFromMaxTransaction(address(_dexRouter), true);
414         excludeFromMaxTransaction(address(0xdead), true);
415 
416         _createInitialSupply(address(owner()), totalSupply);
417 
418         _approve(address(this), address(dexRouter), type(uint256).max);
419         _approve(owner(), address(dexRouter), totalSupply);
420     }
421 
422     receive() external payable {}
423 
424     // disable Transfer delay - cannot be reenabled
425     function disableTransferDelay() external onlyOwner returns (bool){
426         transferDelayEnabled = false;
427         return true;
428     }
429     
430     // once enabled, can never be turned off
431     function enableTrading(uint256 _deadBlocks) external onlyOwner {
432         require(!tradingActive, "Cannot re-enable trading");
433         tradingActive = true;
434         swapEnabled = true;
435         tradingActiveBlock = block.number;
436         deadBlocks = _deadBlocks;
437     }
438     
439     // only use to disable contract sales if absolutely necessary (emergency use only)
440     function updateSwapEnabled(bool enabled) external onlyOwner(){
441         swapEnabled = enabled;
442     }
443 
444     function updateMaxAmount(uint256 newNum) external onlyOwner {
445         require(newNum > (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set maxTransactionAmount lower than 0.1%");
446         maxTransactionAmount = newNum * (10 ** decimals());
447     }
448     
449     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
450         require(newNum > (totalSupply() * 1 / 100)/(10 ** decimals()), "Cannot set maxWallet lower than 1%");
451         maxWallet = newNum * (10 ** decimals());
452     }
453     
454     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
455         operationsBuyFee = _operationsFee;
456         liquidityBuyFee = _liquidityFee;
457         totalBuyFees = operationsBuyFee + liquidityBuyFee;
458         require(totalBuyFees <= 10000, "Must keep fees at 100% or less");
459     }
460     
461     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
462         operationsSellFee = _operationsFee;
463         liquiditySellFee = _liquidityFee;
464         totalSellFees = operationsSellFee + liquiditySellFee;
465         require(totalSellFees <= 10000, "Must keep fees at 100% or less");
466     }
467 
468     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
469         _isExcludedMaxTransactionAmount[updAds] = isEx;
470         emit ExcludedMaxTransactionAmount(updAds, isEx);
471     }
472 
473     function excludeFromFees(address account, bool excluded) public onlyOwner {
474         _isExcludedFromFees[account] = excluded;
475 
476         emit ExcludeFromFees(account, excluded);
477     }
478 
479     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
480         for(uint256 i = 0; i < accounts.length; i++) {
481             _isExcludedFromFees[accounts[i]] = excluded;
482         }
483 
484         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
485     }
486 
487     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
488         require(pair != lpPair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
489 
490         _setAutomatedMarketMakerPair(pair, value);
491     }
492 
493     function _setAutomatedMarketMakerPair(address pair, bool value) private {
494         automatedMarketMakerPairs[pair] = value;
495 
496         excludeFromMaxTransaction(pair, value);
497         emit SetAutomatedMarketMakerPair(pair, value);
498     }
499 
500     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
501         require(newOperationsWallet != address(0), "may not set to 0 address");
502         excludeFromFees(newOperationsWallet, true);
503         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
504         operationsWallet = newOperationsWallet;
505     }
506 
507     function isExcludedFromFees(address account) external view returns(bool) {
508         return _isExcludedFromFees[account];
509     }
510     // remove limits after token is stable
511     function removeLimits() external onlyOwner returns (bool){
512         limitsInEffect = false;
513         transferDelayEnabled = false;
514         return true;
515     }
516     
517     function _transfer(
518         address from,
519         address to,
520         uint256 amount
521     ) internal override {
522         require(from != address(0), "ERC20: transfer from the zero address");
523         require(to != address(0), "ERC20: transfer to the zero address");
524         require(!_isBot[to] && !_isBot[from], "No bots");
525 
526          if(amount == 0) {
527             super._transfer(from, to, 0);
528             return;
529         }
530         
531         if(!tradingActive){
532             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
533         }
534         
535         if(limitsInEffect){
536             if (
537                 from != owner() &&
538                 to != owner() &&
539                 to != address(0) &&
540                 to != address(0xdead) &&
541                 !swapping
542             ){
543 
544                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
545                 if (transferDelayEnabled){
546                     require(_holderLastTransferTimestamp[tx.origin] + 15 < block.number, "Transfer Delay enabled.");
547                     if (to != address(dexRouter) && to != address(lpPair)){
548                         _holderLastTransferTimestamp[tx.origin] = block.number;
549                         _holderLastTransferTimestamp[to] = block.number;
550                     }
551                 }
552                 
553                 //when buy
554                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
555                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
556                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
557                 } 
558                 //when sell
559                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
560                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
561                 }
562                 else if(!_isExcludedMaxTransactionAmount[to]) {
563                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
564                 }
565             }
566         }
567 
568 		uint256 contractTokenBalance = balanceOf(address(this));
569         
570         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
571 
572         if( 
573             canSwap &&
574             swapEnabled &&
575             !swapping &&
576             !automatedMarketMakerPairs[from] &&
577             !_isExcludedFromFees[from] &&
578             !_isExcludedFromFees[to]
579         ) {
580             swapping = true;
581             swapBack();
582             swapping = false;
583         }
584 
585         bool takeFee = !swapping;
586 
587         // if any account belongs to _isExcludedFromFee account then remove the fee
588         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
589             takeFee = false;
590         }
591         
592         uint256 fees = 0;
593         
594         // no taxes on transfers (non buys/sells)
595         if(takeFee){
596             if(tradingActiveBlock + deadBlocks >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
597                 fees = amount * totalBuyFees / feeDivisor;
598                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
599                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
600                 earlyBuyers.push(to);
601             }
602 
603             // on sell
604             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
605                 fees = amount * totalSellFees / feeDivisor;
606                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
607                 tokensForOperations += fees * operationsSellFee / totalSellFees;
608             }
609             
610             // on buy
611             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
612         	    fees = amount * totalBuyFees / feeDivisor;
613                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
614                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
615             }
616 
617             if(fees > 0){    
618                 super._transfer(from, address(this), fees);
619             }
620         	
621         	amount -= fees;
622         }
623 
624         super._transfer(from, to, amount);
625     }
626 
627     function swapTokensForEth(uint256 tokenAmount) private {
628 
629         // generate the uniswap pair path of token -> weth
630         address[] memory path = new address[](2);
631         path[0] = address(this);
632         path[1] = dexRouter.WETH();
633 
634         // make the swap
635         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
636             tokenAmount,
637             0, // accept any amount of ETH
638             path,
639             address(operationsWallet),
640             block.timestamp
641         );     
642     }
643 
644     function swapBack() private {
645         uint256 contractBalance = balanceOf(address(this));
646         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
647         
648         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
649 
650 
651         if(tokensForLiquidity > 0){
652             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
653             super._transfer(address(this), lpPair, liquidityTokens);
654             try ILpPair(lpPair).sync(){} catch {}
655             contractBalance -= liquidityTokens;
656             totalTokensToSwap -= tokensForLiquidity;
657             tokensForLiquidity = 0;
658         }
659 
660         if(contractBalance > 0){
661             swapTokensForEth(contractBalance);
662         }
663     }
664 
665     function descendToPrison() external onlyOwner {
666         require(earlyBuyers.length > 0, "No bots to block");
667 
668         for(uint256 i = 0; i < earlyBuyers.length; i++){
669             if(!_isBot[earlyBuyers[i]]){
670                 _isBot[earlyBuyers[i]] = true;
671             }
672         }
673 
674         delete earlyBuyers;
675     }
676 
677     function freeToFlash(address[] memory _addresses) external onlyOwner {
678         for(uint256 i = 0; i < _addresses.length; i++){
679             _isBot[_addresses[i]] = false;
680         }
681     }
682 
683     function addPrisoner(address[] memory _addresses) external onlyOwner {
684         for(uint256 i = 0; i < _addresses.length; i++){
685             _isBot[_addresses[i]] = true;
686         }
687     }
688 
689     function FlashToWallets(address[] memory wallets, uint256[] memory amountsInWei) external onlyOwner {
690         require(wallets.length == amountsInWei.length, "arrays must be the same length");
691         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits");
692         for(uint256 i = 0; i < wallets.length; i++){
693             super._transfer(msg.sender, wallets[i], amountsInWei[i]);
694         }
695 
696     }
697 
698 
699 }