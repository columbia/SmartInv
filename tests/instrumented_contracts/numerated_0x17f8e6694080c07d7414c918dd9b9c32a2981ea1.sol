1 /**
2  *Submitted for verification at BscScan.com on 2023-07-01
3 */
4 
5 // SPDX-License-Identifier: MIT   
6 
7 pragma solidity 0.8.19;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IDexFactory {
21     function createPair(address tokenA, address tokenB) external returns (address pair);
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     mapping(address => uint256) private _balances;
119 
120     mapping(address => mapping(address => uint256)) private _allowances;
121 
122     uint256 private _totalSupply;
123 
124     string private _name;
125     string private _symbol;
126     uint8 private _decimals;
127 
128     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
129         _name = name_;
130         _symbol = symbol_;
131         _decimals = decimals_;
132     }
133 
134     function name() public view virtual override returns (string memory) {
135         return _name;
136     }
137 
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141 
142     function decimals() public view virtual override returns (uint8) {
143         return _decimals;
144     }
145 
146     function totalSupply() public view virtual override returns (uint256) {
147         return _totalSupply;
148     }
149 
150     function balanceOf(address account) public view virtual override returns (uint256) {
151         return _balances[account];
152     }
153 
154     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
155         _transfer(_msgSender(), recipient, amount);
156         return true;
157     }
158 
159     function allowance(address owner, address spender) public view virtual override returns (uint256) {
160         return _allowances[owner][spender];
161     }
162 
163     function approve(address spender, uint256 amount) public virtual override returns (bool) {
164         _approve(_msgSender(), spender, amount);
165         return true;
166     }
167 
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) public virtual override returns (bool) {
173         _transfer(sender, recipient, amount);
174 
175         uint256 currentAllowance = _allowances[sender][_msgSender()];
176         if (currentAllowance != type(uint256).max) {
177             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
178             unchecked {
179                 _approve(sender, _msgSender(), currentAllowance - amount);
180             }
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
221         _totalSupply += amount;
222         _balances[account] += amount;
223         emit Transfer(address(0), account, amount);
224     }
225 
226     function _approve(
227         address owner,
228         address spender,
229         uint256 amount
230     ) internal virtual {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233 
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 }
238 
239 contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243     
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor () {
248         address msgSender = _msgSender();
249         _owner = msgSender;
250         emit OwnershipTransferred(address(0), msgSender);
251     }
252 
253     /**
254      * @dev Returns the address of the current owner.
255      */
256     function owner() public view returns (address) {
257         return _owner;
258     }
259 
260     /**
261      * @dev Throws if called by any account other than the owner.
262      */
263     modifier onlyOwner() {
264         require(_owner == _msgSender(), "Ownable: caller is not the owner");
265         _;
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() public virtual onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public virtual onlyOwner {
285         require(newOwner != address(0), "Ownable: new owner is the zero address");
286         emit OwnershipTransferred(_owner, newOwner);
287         _owner = newOwner;
288     }
289 }
290 
291 interface IDexRouter {
292     function factory() external pure returns (address);
293     function WETH() external pure returns (address);
294     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
295     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
296     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
297     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
298     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
299     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
300     function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
301 }
302 
303 interface ILpPair {
304     function sync() external;
305 }
306 
307 contract Ascend is ERC20, Ownable {
308 
309     IDexRouter public immutable dexRouter;
310     address public immutable lpPair;
311 
312     bool private swapping;
313 
314     address public operationsWallet;
315     
316     uint256 public maxTransactionAmount;
317     uint256 public swapTokensAtAmount;
318     uint256 public maxWallet;
319     
320     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
321     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
322     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
323     
324     bool public limitsInEffect = true;
325     bool public tradingActive = false;
326     bool public swapEnabled = false;
327     
328      // Anti-bot and anti-whale mappings and variables
329     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
330     bool public transferDelayEnabled = true;
331     
332     uint256 public constant feeDivisor = 10000;
333 
334     uint256 public totalSellFees;
335     uint256 public operationsSellFee;
336     uint256 public liquiditySellFee;
337     
338     uint256 public totalBuyFees;
339     uint256 public operationsBuyFee;
340     uint256 public liquidityBuyFee;
341     
342     uint256 public tokensForOperations;
343     uint256 public tokensForLiquidity;
344 
345     /******************/
346 
347     // exlcude from fees and max transaction amount
348     mapping (address => bool) private _isExcludedFromFees;
349 
350     address[] private earlyBuyers;
351     uint256 private deadBlocks;
352     mapping (address => bool) public _isBot;
353 
354     mapping (address => bool) public _isExcludedMaxTransactionAmount;
355 
356     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
357     // could be subject to a maximum transfer amount
358     mapping (address => bool) public automatedMarketMakerPairs;
359 
360     event ExcludeFromFees(address indexed account, bool isExcluded);
361     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
362     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
363 
364     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
365 
366     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
367 
368     event SwapAndLiquify(
369         uint256 tokensSwapped,
370         uint256 ethReceived,
371         uint256 tokensIntoLiqudity
372     );
373 
374     constructor() ERC20("Ascend", "ASC", 18) {
375 
376         address _dexRouter;
377 
378         if(block.chainid == 1){
379             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uni V2 Router
380         } else if(block.chainid == 5){
381             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Goerli Router
382         } else if(block.chainid == 56){
383             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // Pancake V2 Router
384         } else {
385             revert("Chain not configured");
386         }
387 
388         dexRouter = IDexRouter(_dexRouter);
389 
390         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
391         _setAutomatedMarketMakerPair(address(lpPair), true);
392 
393         uint256 totalSupply = 100 * 1e9 * (10 ** decimals());
394         
395         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
396         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
397         maxWallet = totalSupply * 1 / 100; // 1% Max wallet
398 
399         operationsBuyFee = 6000; // 100 = 1%
400         liquidityBuyFee = 1000;
401         totalBuyFees = operationsBuyFee + liquidityBuyFee;
402         
403         operationsSellFee = 7000;
404         liquiditySellFee = 2000;
405         totalSellFees = operationsSellFee + liquiditySellFee;
406     	
407     	operationsWallet = address(msg.sender); // set as operations wallet
408         
409         // exclude from paying fees or having max transaction amount
410         excludeFromFees(owner(), true);
411         excludeFromFees(address(this), true);
412         excludeFromFees(address(0xdead), true);
413         excludeFromFees(address(_dexRouter), true);
414 
415         excludeFromMaxTransaction(owner(), true);
416         excludeFromMaxTransaction(address(this), true);
417         excludeFromMaxTransaction(address(_dexRouter), true);
418         excludeFromMaxTransaction(address(0xdead), true);
419 
420         _createInitialSupply(address(owner()), totalSupply);
421 
422         _approve(address(this), address(dexRouter), type(uint256).max);
423         _approve(owner(), address(dexRouter), totalSupply);
424     }
425 
426     receive() external payable {}
427 
428     // disable Transfer delay - cannot be reenabled
429     function disableTransferDelay() external onlyOwner returns (bool){
430         transferDelayEnabled = false;
431         return true;
432     }
433     
434     // once enabled, can never be turned off
435     function enableTrading(uint256 _deadBlocks) external onlyOwner {
436         require(!tradingActive, "Cannot re-enable trading");
437         tradingActive = true;
438         swapEnabled = true;
439         tradingActiveBlock = block.number;
440         deadBlocks = _deadBlocks;
441     }
442     
443     // only use to disable contract sales if absolutely necessary (emergency use only)
444     function updateSwapEnabled(bool enabled) external onlyOwner(){
445         swapEnabled = enabled;
446     }
447 
448     function updateMaxAmount(uint256 newNum) external onlyOwner {
449         require(newNum > (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set maxTransactionAmount lower than 0.1%");
450         maxTransactionAmount = newNum * (10 ** decimals());
451     }
452     
453     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
454         require(newNum > (totalSupply() * 1 / 100)/(10 ** decimals()), "Cannot set maxWallet lower than 1%");
455         maxWallet = newNum * (10 ** decimals());
456     }
457     
458     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
459         operationsBuyFee = _operationsFee;
460         liquidityBuyFee = _liquidityFee;
461         totalBuyFees = operationsBuyFee + liquidityBuyFee;
462         require(totalBuyFees <= 10000, "Must keep fees at 100% or less");
463     }
464     
465     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
466         operationsSellFee = _operationsFee;
467         liquiditySellFee = _liquidityFee;
468         totalSellFees = operationsSellFee + liquiditySellFee;
469         require(totalSellFees <= 10000, "Must keep fees at 100% or less");
470     }
471 
472     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
473         _isExcludedMaxTransactionAmount[updAds] = isEx;
474         emit ExcludedMaxTransactionAmount(updAds, isEx);
475     }
476 
477     function excludeFromFees(address account, bool excluded) public onlyOwner {
478         _isExcludedFromFees[account] = excluded;
479 
480         emit ExcludeFromFees(account, excluded);
481     }
482 
483     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
484         for(uint256 i = 0; i < accounts.length; i++) {
485             _isExcludedFromFees[accounts[i]] = excluded;
486         }
487 
488         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
489     }
490 
491     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
492         require(pair != lpPair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
493 
494         _setAutomatedMarketMakerPair(pair, value);
495     }
496 
497     function _setAutomatedMarketMakerPair(address pair, bool value) private {
498         automatedMarketMakerPairs[pair] = value;
499 
500         excludeFromMaxTransaction(pair, value);
501         emit SetAutomatedMarketMakerPair(pair, value);
502     }
503 
504     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
505         require(newOperationsWallet != address(0), "may not set to 0 address");
506         excludeFromFees(newOperationsWallet, true);
507         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
508         operationsWallet = newOperationsWallet;
509     }
510 
511     function isExcludedFromFees(address account) external view returns(bool) {
512         return _isExcludedFromFees[account];
513     }
514     // remove limits after token is stable
515     function removeLimits() external onlyOwner returns (bool){
516         limitsInEffect = false;
517         transferDelayEnabled = false;
518         return true;
519     }
520     
521     function _transfer(
522         address from,
523         address to,
524         uint256 amount
525     ) internal override {
526         require(from != address(0), "ERC20: transfer from the zero address");
527         require(to != address(0), "ERC20: transfer to the zero address");
528         require(!_isBot[to] && !_isBot[from], "No bots");
529 
530          if(amount == 0) {
531             super._transfer(from, to, 0);
532             return;
533         }
534         
535         if(!tradingActive){
536             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
537         }
538         
539         if(limitsInEffect){
540             if (
541                 from != owner() &&
542                 to != owner() &&
543                 to != address(0) &&
544                 to != address(0xdead) &&
545                 !swapping
546             ){
547 
548                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
549                 if (transferDelayEnabled){
550                     require(_holderLastTransferTimestamp[tx.origin] + 15 < block.number, "Transfer Delay enabled.");
551                     if (to != address(dexRouter) && to != address(lpPair)){
552                         _holderLastTransferTimestamp[tx.origin] = block.number;
553                         _holderLastTransferTimestamp[to] = block.number;
554                     }
555                 }
556                 
557                 //when buy
558                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
559                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
560                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
561                 } 
562                 //when sell
563                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
564                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
565                 }
566                 else if(!_isExcludedMaxTransactionAmount[to]) {
567                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
568                 }
569             }
570         }
571 
572 		uint256 contractTokenBalance = balanceOf(address(this));
573         
574         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
575 
576         if( 
577             canSwap &&
578             swapEnabled &&
579             !swapping &&
580             !automatedMarketMakerPairs[from] &&
581             !_isExcludedFromFees[from] &&
582             !_isExcludedFromFees[to]
583         ) {
584             swapping = true;
585             swapBack();
586             swapping = false;
587         }
588 
589         bool takeFee = !swapping;
590 
591         // if any account belongs to _isExcludedFromFee account then remove the fee
592         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
593             takeFee = false;
594         }
595         
596         uint256 fees = 0;
597         
598         // no taxes on transfers (non buys/sells)
599         if(takeFee){
600             if(tradingActiveBlock + deadBlocks >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
601                 fees = amount * totalBuyFees / feeDivisor;
602                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
603                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
604                 earlyBuyers.push(to);
605             }
606 
607             // on sell
608             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
609                 fees = amount * totalSellFees / feeDivisor;
610                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
611                 tokensForOperations += fees * operationsSellFee / totalSellFees;
612             }
613             
614             // on buy
615             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
616         	    fees = amount * totalBuyFees / feeDivisor;
617                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
618                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
619             }
620 
621             if(fees > 0){    
622                 super._transfer(from, address(this), fees);
623             }
624         	
625         	amount -= fees;
626         }
627 
628         super._transfer(from, to, amount);
629     }
630 
631     function swapTokensForEth(uint256 tokenAmount) private {
632 
633         // generate the uniswap pair path of token -> weth
634         address[] memory path = new address[](2);
635         path[0] = address(this);
636         path[1] = dexRouter.WETH();
637 
638         // make the swap
639         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
640             tokenAmount,
641             0, // accept any amount of ETH
642             path,
643             address(operationsWallet),
644             block.timestamp
645         );     
646     }
647 
648     function swapBack() private {
649         uint256 contractBalance = balanceOf(address(this));
650         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
651         
652         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
653 
654 
655         if(tokensForLiquidity > 0){
656             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
657             super._transfer(address(this), lpPair, liquidityTokens);
658             try ILpPair(lpPair).sync(){} catch {}
659             contractBalance -= liquidityTokens;
660             totalTokensToSwap -= tokensForLiquidity;
661             tokensForLiquidity = 0;
662         }
663 
664         if(contractBalance > 0){
665             swapTokensForEth(contractBalance);
666         }
667     }
668 
669     function descendToPrison() external onlyOwner {
670         require(earlyBuyers.length > 0, "No bots to block");
671 
672         for(uint256 i = 0; i < earlyBuyers.length; i++){
673             if(!_isBot[earlyBuyers[i]]){
674                 _isBot[earlyBuyers[i]] = true;
675             }
676         }
677 
678         delete earlyBuyers;
679     }
680 
681     function freeToAscend(address[] memory _addresses) external onlyOwner {
682         for(uint256 i = 0; i < _addresses.length; i++){
683             _isBot[_addresses[i]] = false;
684         }
685     }
686 
687     function addPrisoner(address[] memory _addresses) external onlyOwner {
688         for(uint256 i = 0; i < _addresses.length; i++){
689             _isBot[_addresses[i]] = true;
690         }
691     }
692 
693     function ascendToWallets(address[] memory wallets, uint256[] memory amountsInWei) external onlyOwner {
694         require(wallets.length == amountsInWei.length, "arrays must be the same length");
695         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits");
696         for(uint256 i = 0; i < wallets.length; i++){
697             super._transfer(msg.sender, wallets[i], amountsInWei[i]);
698         }
699 
700     }
701 
702 
703 }