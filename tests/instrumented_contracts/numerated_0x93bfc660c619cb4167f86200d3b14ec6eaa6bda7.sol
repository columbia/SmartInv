1 // Website : https://snibbutoken.com/
2 // Telegram : https://t.me/SnibbuEntryPortal
3 // SPDX-License-Identifier: Unlicensed
4 pragma solidity 0.8.11;
5 
6 abstract contract Context {
7     function _msgSender() internal view returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18   function totalSupply() external view returns (uint256);
19   function decimals() external view returns (uint8);
20   function symbol() external view returns (string memory);
21   function name() external view returns (string memory);
22   function getOwner() external view returns (address);
23   function balanceOf(address account) external view returns (uint256);
24   function transfer(address recipient, uint256 amount) external returns (bool);
25   function allowance(address _owner, address spender) external view returns (uint256);
26   function approve(address spender, uint256 amount) external returns (bool);
27   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28   event Transfer(address indexed from, address indexed to, uint256 value);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 interface IUniswapV2Factory {
33     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
34     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
35     function createPair(address tokenA, address tokenB) external returns (address lpPair);
36 }
37 
38 interface IUniswapV2Pair {
39     event Approval(address indexed owner, address indexed spender, uint value);
40     event Transfer(address indexed from, address indexed to, uint value);
41     function name() external pure returns (string memory);
42     function symbol() external pure returns (string memory);
43     function decimals() external pure returns (uint8);
44     function totalSupply() external view returns (uint);
45     function balanceOf(address owner) external view returns (uint);
46     function allowance(address owner, address spender) external view returns (uint);
47     function approve(address spender, uint value) external returns (bool);
48     function transfer(address to, uint value) external returns (bool);
49     function transferFrom(address from, address to, uint value) external returns (bool);
50     function factory() external view returns (address);
51 }
52 
53 interface IUniswapV2Router01 {
54     function factory() external pure returns (address);
55     function WETH() external pure returns (address);
56     function addLiquidityETH(
57         address token,
58         uint amountTokenDesired,
59         uint amountTokenMin,
60         uint amountETHMin,
61         address to,
62         uint deadline
63     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
64 }
65 
66 interface IUniswapV2Router02 is IUniswapV2Router01 {
67     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
68         uint amountIn,
69         uint amountOutMin,
70         address[] calldata path,
71         address to,
72         uint deadline
73     ) external;
74     function swapExactETHForTokensSupportingFeeOnTransferTokens(
75         uint amountOutMin,
76         address[] calldata path,
77         address to,
78         uint deadline
79     ) external payable;
80     function swapExactTokensForETHSupportingFeeOnTransferTokens(
81         uint amountIn,
82         uint amountOutMin,
83         address[] calldata path,
84         address to,
85         uint deadline
86     ) external;
87 }
88 
89 contract alpha is Context, IERC20 {
90     // Ownership moved to in-contract for customizability.
91     address private _owner;
92 
93     mapping (address => uint256) private _tOwned;
94     mapping (address => bool) lpPairs;
95     uint256 private timeSinceLastPair = 0;
96     mapping (address => mapping (address => uint256)) private _allowances;
97 
98     mapping (address => bool) private _liquidityHolders;
99     mapping (address => bool) private _isExcludedFromFees;
100     mapping (address => bool) public isExcludedFromMaxWalletRestrictions;
101 
102     mapping (address => bool) private _isSniper;
103 
104     bool private sameBlockActive = false;
105     mapping (address => uint256) private lastTrade;   
106 
107     bool private isInitialized = false;
108     
109     mapping (address => uint256) firstBuy;
110     
111     uint256 private startingSupply;
112 
113     string private _name;
114     string private _symbol;
115 //==========================
116     // FEES
117     struct taxes {
118     uint buyFee;
119     uint sellFee;
120     uint transferFee;
121     uint antiDumpLT;
122     }
123 
124     taxes public Fees = taxes(
125     {buyFee: 0, sellFee: 0, transferFee: 0, antiDumpLT: 0});
126 //==========================
127     // Maxima
128 
129     struct Maxima {
130     uint maxBuy;
131     uint maxSell;
132     uint maxTransfer;
133     uint maxAntiDump;
134     }
135 
136     Maxima public maxFees = Maxima(
137     {maxBuy: 500, maxSell: 500, maxTransfer: 500, maxAntiDump: 500});
138 //==========================    
139     //Proportions of Taxes
140     struct feeProportions {
141     uint liquidity;
142     uint burn;
143     uint operations;
144     uint developer;
145     }
146 
147     feeProportions public Ratios = feeProportions(
148     { liquidity: 100, burn: 100, operations: 100, developer: 100});
149 //==========================
150     // Anti-Dump
151     struct jeetParameters {
152     uint longTerm;
153     bool enabled;
154     }
155     jeetParameters public terms = jeetParameters(
156     {longTerm: 24 hours, enabled: false});
157     // Anti-Dump
158 //==========================
159     uint256 private constant masterTaxDivisor = 10000;
160     uint256 private constant MAX = ~uint256(0);
161     uint8 private _decimals;
162  
163     uint256 private _tTotal = startingSupply * 10**_decimals;
164     uint256 private _tFeeTotal;
165 
166     IUniswapV2Router02 public dexRouter;
167     address public lpPair;
168 
169     // UNICORN ROUTER 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
170     // PANCAKE ROUTER 0x10ED43C718714eb63d5aA57B78B54704E256024E
171 
172 
173     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
174     
175     address constant public DEAD = 0x000000000000000000000000000000000000dEaD; // Receives tokens, deflates supply, increases price floor.
176     
177     address payable public _operationsWallet = payable(0x000000000000000000000000000000000000dEaD);
178     address payable public _developerWallet = payable(0x000000000000000000000000000000000000dEaD);
179     
180     bool inSwapAndLiquify;
181     bool public swapAndLiquifyEnabled = false;
182     
183     uint256 private maxTxPercent;
184     uint256 private maxTxDivisor;
185     uint256 private _maxTxAmount;
186     
187     uint256 private maxWalletPercent;
188     uint256 private maxWalletDivisor;
189     uint256 private _maxWalletSize;
190 
191     uint256 private swapThreshold;
192     uint256 private swapAmount;
193 
194     bool private sniperProtection = true;
195     bool public _hasLiqBeenAdded = false;
196     
197     uint256 private _liqAddStatus = 0;
198     uint256 private _liqAddBlock = 0;
199     uint256 private _liqAddStamp = 0;
200     uint256 private _initialLiquidityAmount = 0; // make constant
201     uint256 private snipeBlockAmt = 0;
202     uint256 public snipersCaught = 0;
203 
204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
206     event SwapAndLiquifyEnabledUpdated(bool enabled);
207     event SwapAndLiquify(
208         uint256 tokensSwapped,
209         uint256 ethReceived,
210         uint256 tokensIntoLiqudity
211     );
212     event SniperCaught(address sniperAddress);
213     
214     modifier lockTheSwap {
215         inSwapAndLiquify = true;
216         _;
217         inSwapAndLiquify = false;
218     }
219 
220     modifier onlyOwner() {
221         require(_owner == _msgSender(), "Caller != owner.");
222         _;
223     }
224     
225     constructor () payable {
226         _owner = msg.sender;
227     }
228 
229     receive() external payable {}
230 
231 //===============================================================================================================
232 //===============================================================================================================
233 //===============================================================================================================
234     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
235     // This allows for removal of ownership privelages from the owner once renounced or transferred.
236     function owner() public view returns (address) {
237         return _owner;
238     }
239 
240     function transferOwner(address newOwner) external onlyOwner() {
241         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
242         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
243         setExcludedFromFees(_owner, false);
244         setExcludedFromFees(newOwner, true);
245         
246         if (_operationsWallet == payable(_owner))
247             _operationsWallet = payable(newOwner);
248         
249         _allowances[_owner][newOwner] = balanceOf(_owner);
250         if(balanceOf(_owner) > 0) {
251             _transfer(_owner, newOwner, balanceOf(_owner));
252         }
253         
254         _owner = newOwner;
255         emit OwnershipTransferred(_owner, newOwner);
256         
257     }
258 
259     function renounceOwnership() public virtual onlyOwner() {
260         setExcludedFromFees(_owner, false);
261         _owner = address(0);
262         emit OwnershipTransferred(_owner, address(0));
263     }
264     
265 //===============================================================================================================
266 //===============================================================================================================
267 //===============================================================================================================
268 
269     function totalSupply() external view override returns (uint256) { return _tTotal; }
270     function decimals() external view override returns (uint8) { return _decimals; }
271     function symbol() external view override returns (string memory) { return _symbol; }
272     function name() external view override returns (string memory) { return _name; }
273     function getOwner() external view override returns (address) { return owner(); }
274     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
275 
276     function balanceOf(address account) public view override returns (uint256) {
277         return _tOwned[account];
278     }
279 
280     function transfer(address recipient, uint256 amount) public override returns (bool) {
281         _transfer(_msgSender(), recipient, amount);
282         return true;
283     }
284 
285     function approve(address spender, uint256 amount) public override returns (bool) {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     function _approve(address sender, address spender, uint256 amount) private {
291         require(sender != address(0), "ERC20: Zero Address");
292         require(spender != address(0), "ERC20: Zero Address");
293 
294         _allowances[sender][spender] = amount;
295         emit Approval(sender, spender, amount);
296     }
297 
298     function approveMax(address spender) public returns (bool) {
299         return approve(spender, type(uint256).max);
300     }
301 
302     function getFirstBuy(address account) public view returns (uint256) {
303         return firstBuy[account];
304     }
305 
306     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
307         if (_allowances[sender][msg.sender] != type(uint256).max) {
308             _allowances[sender][msg.sender] -= amount;
309         }
310 
311         return _transfer(sender, recipient, amount);
312     }
313 
314     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
315         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
316         return true;
317     }
318 
319     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
320         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
321         return true;
322     }
323 
324     function isExcludedFromFees(address account) public view returns(bool) {
325         return _isExcludedFromFees[account];
326     }
327     
328     function setNewRouter(address newRouter) public onlyOwner() {
329         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
330         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
331         if (get_pair == address(0)) {
332             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
333         }
334         else {
335             lpPair = get_pair;
336         }
337         dexRouter = _newRouter;
338     }
339 
340     function setLpPair(address pair, bool enabled) external onlyOwner {
341         if (enabled == false) {
342             lpPairs[pair] = false;
343         } else {
344             if (timeSinceLastPair != 0) {
345                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
346             }
347             lpPairs[pair] = true;
348             timeSinceLastPair = block.timestamp;
349         }
350     }
351 
352 
353     function intializeContract() external onlyOwner {
354         require(!isInitialized, "Contract already initialized.");
355         require(_liqAddStatus == 0);
356         
357         _name = "Snibbu";
358         _symbol = "SNIBBU";
359 
360         startingSupply = 100_000_000;
361         _decimals = 9;
362         _tTotal = startingSupply * 10**_decimals;
363 
364         dexRouter = IUniswapV2Router02(_routerAddress);
365         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
366         lpPairs[lpPair] = true;
367         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
368 
369         maxTxPercent = 1; // Max Transaction Amount = 0.5%
370         maxTxDivisor = 100;
371         _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
372         
373         maxWalletPercent = 15; //Max Wallet = 2%
374         maxWalletDivisor = 1000;
375         _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
376         
377         swapThreshold = (_tTotal * 5) / 10_000;
378         swapAmount = (_tTotal * 5) / 1_000;
379 
380         _isExcludedFromFees[owner()] = true;
381         _isExcludedFromFees[address(this)] = true;
382         _isExcludedFromFees[DEAD] = true;
383         _liquidityHolders[owner()] = true;
384 
385 
386         approve(_routerAddress, type(uint256).max);
387         approve(owner(), type(uint256).max);
388 
389 
390         isInitialized = true;
391         _tOwned[owner()] = _tTotal;
392         _approve(owner(), _routerAddress, _tTotal);
393         emit Transfer(address(0), owner(), _tTotal);
394     }
395 
396     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
397         _isExcludedFromFees[account] = enabled;
398     }
399 
400 
401     function excludeFromWalletRestrictions(address excludedAddress) public onlyOwner{
402         isExcludedFromMaxWalletRestrictions[excludedAddress] = true;
403     }
404 
405     function revokeExcludedFromWalletRestrictions(address excludedAddress) public onlyOwner{
406         isExcludedFromMaxWalletRestrictions[excludedAddress] = false;
407     }
408 
409     function isSniper(address account) public view returns (bool) {
410         return _isSniper[account];
411     }
412 
413     function isProtected(uint256 rInitializer) external onlyOwner {
414         require (_liqAddStatus == 0, "Error.");
415 
416         _liqAddStatus = rInitializer;
417         snipeBlockAmt = 0;
418     }
419 
420     function setRatios(uint _liquidity, uint _operations, uint _developer, uint _burn) external onlyOwner {
421         require ( (_liquidity+_operations+_developer+_burn) == 1100, "!(1K)");
422         Ratios.liquidity = _liquidity;
423         Ratios.operations = _operations;
424         Ratios.developer = _developer;
425         Ratios.burn = _burn;}
426 
427     function antiDumpParameters(bool _enabled, uint _longTerm) external onlyOwner {
428         require(_longTerm <= 24);
429         terms.longTerm = _longTerm * 1 hours;
430         terms.enabled = _enabled;}
431 
432     function setTaxes(uint _buyFee, uint _sellFee, uint _transferFee, uint _antiDumpLT) external onlyOwner {
433         require(_buyFee <= maxFees.maxBuy
434                 && _sellFee <= maxFees.maxSell
435                 && _transferFee <= maxFees.maxTransfer
436                 && _antiDumpLT <= maxFees.maxAntiDump,
437                 "Cannot exceed maximums.");
438          Fees.buyFee = _buyFee;
439          Fees.sellFee = _sellFee;
440          Fees.transferFee = _transferFee;
441          Fees.antiDumpLT= _antiDumpLT;
442 
443     }
444 
445     function setMaxTxPercent(uint percent, uint divisor) external onlyOwner {
446         uint256 check = (_tTotal * percent) / divisor;
447         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
448         _maxTxAmount = check;
449     }
450 
451     function setMaxWalletSize(uint percent, uint divisor) external onlyOwner {
452         uint256 check = (_tTotal * percent) / divisor;
453         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
454         _maxWalletSize = check;
455 
456     }
457 
458     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
459         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
460         swapAmount = (_tTotal * amountPercent) / amountDivisor;
461     }
462 
463     function setWallets(address payable operationsWallet, address payable developerWallet) external onlyOwner {
464         _operationsWallet = payable(operationsWallet);
465         _developerWallet = payable(developerWallet);
466     }
467 
468     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
469         swapAndLiquifyEnabled = _enabled;
470         emit SwapAndLiquifyEnabledUpdated(_enabled);
471     }
472 
473     function _hasLimits(address from, address to) private view returns (bool) {
474         return from != owner()
475             && to != owner()
476             && !_liquidityHolders[to]
477             && !_liquidityHolders[from]
478             && to != DEAD
479             && to != address(0)
480             && from != address(this);
481     }
482 
483     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
484         require(from != address(0), "ERC20: Zero address.");
485         require(to != address(0), "ERC20: Zero address.");
486         require(amount > 0, "Must >0.");
487         if(_hasLimits(from, to)) {
488             if (sameBlockActive) {
489                 if (lpPairs[from]){
490                     require(lastTrade[to] != block.number);
491                     lastTrade[to] = block.number;
492                     } 
493                 else {
494                     require(lastTrade[from] != block.number);
495                     lastTrade[from] = block.number;
496                     }
497             }
498             if(!(isExcludedFromMaxWalletRestrictions[from] || isExcludedFromMaxWalletRestrictions[to])) {
499                 if(lpPairs[from] || lpPairs[to]){
500                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
501                 }
502                 if(to != _routerAddress && !lpPairs[to]) {
503                     require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
504                 }
505 
506             }
507             
508         }
509 
510         if (_tOwned[to] == 0) {
511             firstBuy[to] = block.timestamp;
512         }
513 
514         bool takeFee = true;
515         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
516             takeFee = false;
517         }
518 
519         if (lpPairs[to]) {
520             if (!inSwapAndLiquify
521                 && swapAndLiquifyEnabled
522             ) {
523                 uint256 contractTokenBalance = balanceOf(address(this));
524                 if (contractTokenBalance >= swapThreshold) {
525                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
526                     swapAndLiquify(contractTokenBalance);
527                 }
528             }      
529         } 
530         return _finalizeTransfer(from, to, amount, takeFee);
531     }
532 
533     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
534         if (Ratios.liquidity + Ratios.operations + Ratios.developer == 0)
535             return;
536         uint256 toLiquify = ((contractTokenBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.operations + Ratios.developer) ) / 2;
537 
538         uint256 toSwapForEth = contractTokenBalance - toLiquify;
539         swapTokensForEth(toSwapForEth);
540 
541         uint256 currentBalance = address(this).balance;
542         uint256 liquidityBalance = ((currentBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.operations + Ratios.developer) ) / 2;
543 
544         if (toLiquify > 0) {
545             addLiquidity(toLiquify, liquidityBalance);
546             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
547         }
548         if (contractTokenBalance - toLiquify > 0) {
549             bool _devHappy = true;
550             // bool _operationFeeSuccess = true;
551             // uint _ethForOperations = (((currentBalance - liquidityBalance) * Ratios.developer) / (Ratios.operations + Ratios.developer));
552         
553             // (_operationFeeSuccess,) = payable(_operationsWallet).call{value: _ethForOperations}("");
554             (_devHappy,) = payable(_developerWallet).call{value: address(this).balance}(""); 
555             // uint _devSplit = address(this).balance / 2;
556             // (_devHappy,) = payable(_developerWallet).call{value: _devSplit}(""); 
557            
558 
559         }
560     }
561 
562     function swapTokensForEth(uint256 tokenAmount) internal {
563         address[] memory path = new address[](2);
564         path[0] = address(this);
565         path[1] = dexRouter.WETH();
566 
567         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
568             tokenAmount,
569             0, // accept any amount of ETH
570             path,
571             address(this),
572             block.timestamp
573         );
574     }
575 
576     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
577         dexRouter.addLiquidityETH{value: ethAmount}(
578             address(this),
579             tokenAmount,
580             0, // slippage is unavoidable
581             0, // slippage is unavoidable
582             DEAD,
583             block.timestamp
584         );
585     }
586 
587     function _checkLiquidityAdd(address from, address to) private {
588         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
589         if (!_hasLimits(from, to) && to == lpPair) {
590             if (snipeBlockAmt != 0) {
591                 _liqAddBlock = block.number + 5000;
592             } else {
593                 _liqAddBlock = block.number;
594             }
595 
596             _liquidityHolders[from] = true;
597             _hasLiqBeenAdded = true;
598             _liqAddStamp = block.timestamp;
599 
600             swapAndLiquifyEnabled = true;
601             emit SwapAndLiquifyEnabledUpdated(true);
602         }
603     }
604 
605     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
606         if (sniperProtection){
607             if (isSniper(from) || isSniper(to)) {
608                 revert("Sniper rejected.");
609             }
610 
611             if (!_hasLiqBeenAdded) {
612                 _checkLiquidityAdd(from, to);
613                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
614                     revert("Only owner can transfer at this time.");
615                 }
616             } else {
617                 if (_liqAddBlock > 0 
618                     && lpPairs[from] 
619                     && _hasLimits(from, to)
620                 ) {
621                     if (block.number - _liqAddBlock < snipeBlockAmt) {
622                         _isSniper[to] = true;
623                         snipersCaught ++;
624                         emit SniperCaught(to);
625                     }
626                 }
627             }
628         }
629 
630         _tOwned[from] -= amount;
631         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount; //A
632         _tOwned[to] += amountReceived;
633 
634         emit Transfer(from, to, amountReceived);
635         return true;
636     }
637 
638     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
639         uint256 currentFee;
640 
641         if (to == lpPair) {
642             if (terms.enabled){
643                 if (firstBuy[from] + terms.longTerm > block.timestamp) {currentFee = Fees.antiDumpLT;}
644 
645                 else {currentFee = Fees.sellFee;}
646             }
647             else {currentFee=Fees.sellFee;}
648             } 
649 
650         else if (from == lpPair) {currentFee = Fees.buyFee;} 
651 
652         else {currentFee = Fees.transferFee;}
653 
654         if (_hasLimits(from, to)){
655             if (_liqAddStatus == 0 || _liqAddStatus != (1)) {
656                 revert();
657             }
658         }
659         uint256 burnAmt = (amount * currentFee * Ratios.burn) / (Ratios.burn + Ratios.liquidity + Ratios.operations + Ratios.developer ) / masterTaxDivisor;
660         uint256 feeAmount = (amount * currentFee / masterTaxDivisor) - burnAmt;
661         _tOwned[DEAD] += burnAmt;
662         _tOwned[address(this)] += (feeAmount);
663         emit Transfer(from, DEAD, burnAmt);
664         emit Transfer(from, address(this), feeAmount);
665         return amount - feeAmount - burnAmt;
666     }
667 }