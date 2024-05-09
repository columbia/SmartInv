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
303 contract AntiSnipe is ERC20, Ownable {
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
370     constructor() ERC20("FreeMasonry", "$MASONRY", 18) {
371 
372         address _dexRouter;
373 
374         if(block.chainid == 1){
375             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uni V2 Router
376         } else if(block.chainid == 5){
377             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Goerli Router
378         } else {
379             revert("Chain not configured");
380         }
381 
382         dexRouter = IDexRouter(_dexRouter);
383 
384         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
385         _setAutomatedMarketMakerPair(address(lpPair), true);
386 
387         uint256 totalSupply = 100 * 1e5 * (10 ** decimals());
388         
389         maxTransactionAmount = totalSupply * 1 / 100; // 0.5% maxTransactionAmountTxn
390         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
391         maxWallet = totalSupply * 1 / 100; // 0.5% Max wallet
392 
393         operationsBuyFee = 2500; // 100 = 1%
394         liquidityBuyFee = 0;
395         totalBuyFees = operationsBuyFee + liquidityBuyFee;
396         
397         operationsSellFee = 2500;
398         liquiditySellFee = 0;
399         totalSellFees = operationsSellFee + liquiditySellFee;
400     	
401     	operationsWallet = address(msg.sender); // set as operations wallet
402         
403         // exclude from paying fees or having max transaction amount
404         excludeFromFees(owner(), true);
405         excludeFromFees(address(this), true);
406         excludeFromFees(address(0xdead), true);
407         excludeFromFees(address(_dexRouter), true);
408 
409         excludeFromMaxTransaction(owner(), true);
410         excludeFromMaxTransaction(address(this), true);
411         excludeFromMaxTransaction(address(_dexRouter), true);
412         excludeFromMaxTransaction(address(0xdead), true);
413 
414         _createInitialSupply(address(owner()), totalSupply);
415 
416         _approve(address(this), address(dexRouter), type(uint256).max);
417         _approve(owner(), address(dexRouter), totalSupply);
418     }
419 
420     receive() external payable {}
421 
422     // disable Transfer delay - cannot be reenabled
423     function disableTransferDelay() external onlyOwner returns (bool){
424         transferDelayEnabled = false;
425         return true;
426     }
427     
428     // once enabled, can never be turned off
429     function enableTrading(uint256 _deadBlocks) external onlyOwner {
430         require(!tradingActive, "Cannot re-enable trading");
431         tradingActive = true;
432         swapEnabled = true;
433         tradingActiveBlock = block.number;
434         deadBlocks = _deadBlocks;
435     }
436     
437     // only use to disable contract sales if absolutely necessary (emergency use only)
438     function updateSwapEnabled(bool enabled) external onlyOwner(){
439         swapEnabled = enabled;
440     }
441 
442     function updateMaxAmount(uint256 newNum) external onlyOwner {
443         require(newNum > (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set maxTransactionAmount lower than 0.1%");
444         maxTransactionAmount = newNum * (10 ** decimals());
445     }
446     
447     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
448         require(newNum > (totalSupply() * 1 / 100)/(10 ** decimals()), "Cannot set maxWallet lower than 1%");
449         maxWallet = newNum * (10 ** decimals());
450     }
451     
452     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
453         operationsBuyFee = _operationsFee;
454         liquidityBuyFee = _liquidityFee;
455         totalBuyFees = operationsBuyFee + liquidityBuyFee;
456         require(totalBuyFees <= 1000, "Must keep fees at 10% or less");
457     }
458     
459     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
460         operationsSellFee = _operationsFee;
461         liquiditySellFee = _liquidityFee;
462         totalSellFees = operationsSellFee + liquiditySellFee;
463         require(totalSellFees <= 1000, "Must keep fees at 10% or less");
464     }
465 
466     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
467         _isExcludedMaxTransactionAmount[updAds] = isEx;
468         emit ExcludedMaxTransactionAmount(updAds, isEx);
469     }
470 
471     function excludeFromFees(address account, bool excluded) public onlyOwner {
472         _isExcludedFromFees[account] = excluded;
473 
474         emit ExcludeFromFees(account, excluded);
475     }
476 
477     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
478         for(uint256 i = 0; i < accounts.length; i++) {
479             _isExcludedFromFees[accounts[i]] = excluded;
480         }
481 
482         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
483     }
484 
485     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
486         require(pair != lpPair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
487 
488         _setAutomatedMarketMakerPair(pair, value);
489     }
490 
491     function _setAutomatedMarketMakerPair(address pair, bool value) private {
492         automatedMarketMakerPairs[pair] = value;
493 
494         excludeFromMaxTransaction(pair, value);
495         emit SetAutomatedMarketMakerPair(pair, value);
496     }
497 
498     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
499         require(newOperationsWallet != address(0), "may not set to 0 address");
500         excludeFromFees(newOperationsWallet, true);
501         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
502         operationsWallet = newOperationsWallet;
503     }
504 
505     function isExcludedFromFees(address account) external view returns(bool) {
506         return _isExcludedFromFees[account];
507     }
508     // remove limits after token is stable
509     function removeLimits() external onlyOwner returns (bool){
510         limitsInEffect = false;
511         transferDelayEnabled = false;
512         return true;
513     }
514     
515     function _transfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal override {
520         require(from != address(0), "ERC20: transfer from the zero address");
521         require(to != address(0), "ERC20: transfer to the zero address");
522         require(!_isBot[to] && !_isBot[from], "No bots");
523 
524          if(amount == 0) {
525             super._transfer(from, to, 0);
526             return;
527         }
528         
529         if(!tradingActive){
530             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
531         }
532         
533         if(limitsInEffect){
534             if (
535                 from != owner() &&
536                 to != owner() &&
537                 to != address(0) &&
538                 to != address(0xdead) &&
539                 !swapping
540             ){
541 
542                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
543                 if (transferDelayEnabled){
544                     require(_holderLastTransferTimestamp[tx.origin] + 10 < block.number, "Transfer Delay enabled.");
545                     if (to != address(dexRouter) && to != address(lpPair)){
546                         _holderLastTransferTimestamp[tx.origin] = block.number;
547                         _holderLastTransferTimestamp[to] = block.number;
548                     }
549                 }
550                 
551                 //when buy
552                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
553                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
554                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
555                 } 
556                 //when sell
557                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
558                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
559                 }
560                 else if(!_isExcludedMaxTransactionAmount[to]) {
561                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
562                 }
563             }
564         }
565 
566 		uint256 contractTokenBalance = balanceOf(address(this));
567         
568         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
569 
570         if( 
571             canSwap &&
572             swapEnabled &&
573             !swapping &&
574             !automatedMarketMakerPairs[from] &&
575             !_isExcludedFromFees[from] &&
576             !_isExcludedFromFees[to]
577         ) {
578             swapping = true;
579             swapBack();
580             swapping = false;
581         }
582 
583         bool takeFee = !swapping;
584 
585         // if any account belongs to _isExcludedFromFee account then remove the fee
586         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
587             takeFee = false;
588         }
589         
590         uint256 fees = 0;
591         
592         // no taxes on transfers (non buys/sells)
593         if(takeFee){
594             if(tradingActiveBlock + deadBlocks >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
595                 fees = amount * totalBuyFees / feeDivisor;
596                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
597                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
598                 earlyBuyers.push(to);
599             }
600 
601             // on sell
602             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
603                 fees = amount * totalSellFees / feeDivisor;
604                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
605                 tokensForOperations += fees * operationsSellFee / totalSellFees;
606             }
607             
608             // on buy
609             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
610         	    fees = amount * totalBuyFees / feeDivisor;
611                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
612                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
613             }
614 
615             if(fees > 0){    
616                 super._transfer(from, address(this), fees);
617             }
618         	
619         	amount -= fees;
620         }
621 
622         super._transfer(from, to, amount);
623     }
624 
625     function swapTokensForEth(uint256 tokenAmount) private {
626 
627         // generate the uniswap pair path of token -> weth
628         address[] memory path = new address[](2);
629         path[0] = address(this);
630         path[1] = dexRouter.WETH();
631 
632         // make the swap
633         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
634             tokenAmount,
635             0, // accept any amount of ETH
636             path,
637             address(operationsWallet),
638             block.timestamp
639         );     
640     }
641 
642     function swapBack() private {
643         uint256 contractBalance = balanceOf(address(this));
644         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
645         
646         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
647 
648 
649         if(tokensForLiquidity > 0){
650             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
651             super._transfer(address(this), lpPair, liquidityTokens);
652             try ILpPair(lpPair).sync(){} catch {}
653             contractBalance -= liquidityTokens;
654             totalTokensToSwap -= tokensForLiquidity;
655             tokensForLiquidity = 0;
656         }
657 
658         if(contractBalance > 0){
659             swapTokensForEth(contractBalance);
660         }
661     }
662 
663     function blockBots() external onlyOwner {
664         require(earlyBuyers.length > 0, "No bots to block");
665 
666         for(uint256 i = 0; i < earlyBuyers.length; i++){
667             if(!_isBot[earlyBuyers[i]]){
668                 _isBot[earlyBuyers[i]] = true;
669             }
670         }
671 
672         delete earlyBuyers;
673     }
674 
675     function removeBots(address[] memory _addresses) external onlyOwner {
676         for(uint256 i = 0; i < _addresses.length; i++){
677             _isBot[_addresses[i]] = false;
678         }
679     }
680 }