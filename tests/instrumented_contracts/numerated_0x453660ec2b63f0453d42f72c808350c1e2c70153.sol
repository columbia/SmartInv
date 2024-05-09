1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.16;
3 
4 abstract contract Context {
5     function _msgSender() internal view returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16   function totalSupply() external view returns (uint256);
17   function decimals() external view returns (uint8);
18   function symbol() external view returns (string memory);
19   function name() external view returns (string memory);
20   function getOwner() external view returns (address);
21   function balanceOf(address account) external view returns (uint256);
22   function transfer(address recipient, uint256 amount) external returns (bool);
23   function allowance(address _owner, address spender) external view returns (uint256);
24   function approve(address spender, uint256 amount) external returns (bool);
25   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface IUniswapV2Factory {
31     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
32     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
33     function createPair(address tokenA, address tokenB) external returns (address lpPair);
34 }
35 
36 interface IUniswapV2Pair {
37     event Approval(address indexed owner, address indexed spender, uint value);
38     event Transfer(address indexed from, address indexed to, uint value);
39     function name() external pure returns (string memory);
40     function symbol() external pure returns (string memory);
41     function decimals() external pure returns (uint8);
42     function totalSupply() external view returns (uint);
43     function balanceOf(address owner) external view returns (uint);
44     function allowance(address owner, address spender) external view returns (uint);
45     function approve(address spender, uint value) external returns (bool);
46     function transfer(address to, uint value) external returns (bool);
47     function transferFrom(address from, address to, uint value) external returns (bool);
48     function factory() external view returns (address);
49 }
50 
51 interface IUniswapV2Router01 {
52     function factory() external pure returns (address);
53     function WETH() external pure returns (address);
54     function addLiquidityETH(
55         address token,
56         uint amountTokenDesired,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline
61     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
62 }
63 
64 interface IUniswapV2Router02 is IUniswapV2Router01 {
65     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
66         uint amountIn,
67         uint amountOutMin,
68         address[] calldata path,
69         address to,
70         uint deadline
71     ) external;
72     function swapExactETHForTokensSupportingFeeOnTransferTokens(
73         uint amountOutMin,
74         address[] calldata path,
75         address to,
76         uint deadline
77     ) external payable;
78     function swapExactTokensForETHSupportingFeeOnTransferTokens(
79         uint amountIn,
80         uint amountOutMin,
81         address[] calldata path,
82         address to,
83         uint deadline
84     ) external;
85 }
86 
87 contract ERC20AppContract is Context, IERC20 {
88     // Ownership moved to in-contract for customizability.
89     address public _owner;
90 
91     mapping (address => uint256) private _tOwned;
92     mapping (address => bool) lpPairs;
93     uint256 private timeSinceLastPair = 0;
94     mapping (address => mapping (address => uint256)) private _allowances;
95 
96     mapping (address => bool) private _liquidityHolders;
97     mapping (address => bool) private _isExcludedFromFees;
98     mapping (address => bool) public isExcludedFromMaxWalletRestrictions;
99     mapping (address => bool) private _isblacklisted;
100 
101 
102     bool private sameBlockActive = false;
103     mapping (address => uint256) private lastTrade;   
104 
105     bool private isInitialized = false;
106     
107     mapping (address => uint256) firstBuy;
108     
109     uint256 private startingSupply;
110 
111     string private _name;
112     string private _symbol;
113 //==========================
114     // FEES
115     struct taxes {
116     uint buyFee;
117     uint sellFee;
118     uint transferFee;
119     }
120 
121     taxes public Fees = taxes(
122     {buyFee: 1000, sellFee: 3000, transferFee: 100});
123 //==========================
124     // Max Limits
125 
126     struct MaxLimits {
127     uint maxBuy;
128     uint maxSell;
129     uint maxTransfer;
130     }
131 
132     MaxLimits public maxFees = MaxLimits(
133     {maxBuy: 5000, maxSell: 5000, maxTransfer: 5000});
134 //==========================    
135     //Proportions of Taxes
136     struct feeProportions {
137     uint liquidity;
138     uint developer;
139     }
140 
141     feeProportions public Ratios = feeProportions(
142     { liquidity: 30, developer: 70});
143 
144     uint256 private constant masterTaxDivisor = 10000;
145     uint256 private constant MAX = ~uint256(0);
146     uint8 private _decimals;
147  
148     uint256 private _tTotal = startingSupply * 10**_decimals;
149     uint256 private _tFeeTotal;
150 
151     IUniswapV2Router02 public dexRouter;
152     address public lpPair;
153 
154 
155     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
156     
157     address constant public DEAD = 0x000000000000000000000000000000000000dEaD; // Receives tokens, deflates supply, increases price floor.
158     
159     address public _devWallet;
160     
161     bool inSwapAndLiquify;
162     bool public swapAndLiquifyEnabled = false;
163     
164     uint256 private maxTxPercent;
165     uint256 private maxTxDivisor;
166     uint256 private _maxTxAmount;
167     
168     uint256 private maxWalletPercent;
169     uint256 private maxWalletDivisor;
170     uint256 private _maxWalletSize;
171 
172     uint256 private swapThreshold;
173     uint256 private swapAmount;
174 
175     bool public _hasLiqBeenAdded = false;
176     
177     uint256 private _liqAddStatus = 0;
178     uint256 private _liqAddBlock = 0;
179     uint256 private _liqAddStamp = 0;
180     uint256 private _initialLiquidityAmount = 0; // make constant
181 
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
184     event SwapAndLiquifyEnabledUpdated(bool enabled);
185     event SwapAndLiquify(
186         uint256 tokensSwapped,
187         uint256 ethReceived,
188         uint256 tokensIntoLiqudity
189     );
190     
191     modifier lockTheSwap {
192         inSwapAndLiquify = true;
193         _;
194         inSwapAndLiquify = false;
195     }
196 
197     modifier onlyOwner() {
198         require(_owner == _msgSender(), "Caller != owner.");
199         _;
200     }
201     
202     constructor () {
203         _owner = msg.sender;
204     }
205 
206     receive() external payable {}
207 
208 //===============================================================================================================
209 //===============================================================================================================
210 //===============================================================================================================
211     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
212     // This allows for removal of ownership privelages from the owner once renounced or transferred.
213     function owner() public view returns (address) {
214         return _owner;
215     }
216 
217     function transferOwner(address newOwner) external onlyOwner() {
218         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
219         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
220         setExcludedFromFees(_owner, false);
221         setExcludedFromFees(newOwner, true);
222         
223         if (_devWallet == payable(_owner))
224             _devWallet = payable(newOwner);
225         
226         _allowances[_owner][newOwner] = balanceOf(_owner);
227         if(balanceOf(_owner) > 0) {
228             _transfer(_owner, newOwner, balanceOf(_owner));
229         }
230         
231         _owner = newOwner;
232         emit OwnershipTransferred(_owner, newOwner);
233         
234     }
235 
236     function renounceOwnership() public virtual onlyOwner() {
237         setExcludedFromFees(_owner, false);
238         _owner = address(0);
239         emit OwnershipTransferred(_owner, address(0));
240     }
241     
242 //===============================================================================================================
243 //===============================================================================================================
244 //===============================================================================================================
245 
246     function totalSupply() external view override returns (uint256) { return _tTotal; }
247     function decimals() external view override returns (uint8) { return _decimals; }
248     function symbol() external view override returns (string memory) { return _symbol; }
249     function name() external view override returns (string memory) { return _name; }
250     function getOwner() external view override returns (address) { return owner(); }
251     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
252 
253     function balanceOf(address account) public view override returns (uint256) {
254         return _tOwned[account];
255     }
256 
257     function transfer(address recipient, uint256 amount) public override returns (bool) {
258         _transfer(_msgSender(), recipient, amount);
259         return true;
260     }
261 
262     function approve(address spender, uint256 amount) public override returns (bool) {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     function _approve(address sender, address spender, uint256 amount) private {
268         require(sender != address(0), "ERC20: Zero Address");
269         require(spender != address(0), "ERC20: Zero Address");
270 
271         _allowances[sender][spender] = amount;
272         emit Approval(sender, spender, amount);
273     }
274 
275     function approveMax(address spender) public returns (bool) {
276         return approve(spender, type(uint256).max);
277     }
278 
279     function getFirstBuy(address account) public view returns (uint256) {
280         return firstBuy[account];
281     }
282 
283     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
284         if (_allowances[sender][msg.sender] != type(uint256).max) {
285             _allowances[sender][msg.sender] -= amount;
286         }
287 
288         return _transfer(sender, recipient, amount);
289     }
290 
291     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
292         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
293         return true;
294     }
295 
296     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
297         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
298         return true;
299     }
300 
301     function isExcludedFromFees(address account) public view returns(bool) {
302         return _isExcludedFromFees[account];
303     }
304     
305     function setNewRouter(address newRouter) public onlyOwner() {
306         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
307         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
308         if (get_pair == address(0)) {
309             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
310         }
311         else {
312             lpPair = get_pair;
313         }
314         dexRouter = _newRouter;
315     }
316 
317     function setLpPair(address pair, bool enabled) external onlyOwner {
318         if (enabled == false) {
319             lpPairs[pair] = false;
320         } else {
321             if (timeSinceLastPair != 0) {
322                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
323             }
324             lpPairs[pair] = true;
325             timeSinceLastPair = block.timestamp;
326         }
327     }
328 
329     function setupComplete(uint256 rInitializer) private  {
330         require (_liqAddStatus == 0, "Error.");
331         _liqAddStatus = rInitializer;
332     }
333 
334 
335     function finalSetup(string memory initName, string memory initSymbol, uint256 initSupply, address devWallet) external onlyOwner payable {
336         require(!isInitialized, "Contract already initialized.");
337         require(_liqAddStatus == 0);
338         
339         _name = initName;
340         _symbol = initSymbol;
341 
342         startingSupply = initSupply;
343         _decimals = 18;
344         _tTotal = startingSupply * 10**_decimals;
345 
346         dexRouter = IUniswapV2Router02(_routerAddress);
347         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
348         lpPairs[lpPair] = true;
349         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
350 
351         _devWallet = address(devWallet);
352 
353         maxTxPercent = 99; // Max Transaction Amount: 100 = 1%
354         maxTxDivisor = 10000;
355         _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
356         
357         maxWalletPercent = 101; //Max Wallet 100: 1%
358         maxWalletDivisor = 10000;
359         _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
360         
361         swapThreshold = (_tTotal * 5) / 10_000;
362         swapAmount = (_tTotal * 5) / 1_000;
363 
364         _isExcludedFromFees[owner()] = true;
365         _isExcludedFromFees[address(this)] = true;
366         _isExcludedFromFees[DEAD] = true;
367         _liquidityHolders[owner()] = true;
368 
369 
370         approve(_routerAddress, type(uint256).max);
371         approve(owner(), type(uint256).max);
372 
373 
374         isInitialized = true;
375         _tOwned[owner()] = _tTotal;
376         _approve(owner(), _routerAddress, _tTotal);
377         emit Transfer(address(0), owner(), _tTotal);
378  
379         _approve(_owner, address(dexRouter), type(uint256).max);
380         _approve(address(this), address(dexRouter), type(uint256).max);
381 
382     
383         _transfer(_owner, address(this), balanceOf(_owner));
384 
385         dexRouter.addLiquidityETH{value: address(this).balance}(
386             address(this),
387             balanceOf(address(this)),
388             0, // slippage is unavoidable
389             0, // slippage is unavoidable
390             owner(),
391             block.timestamp
392         );
393         setupComplete(1);
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
409 
410     function setRatios(uint _liquidity, uint _developer) external onlyOwner {
411         require ( (_liquidity+_developer) == 1100, "limit taxes");
412         Ratios.liquidity = _liquidity;
413         Ratios.developer = _developer;
414         }
415 
416 
417     function setFees(uint _buyFee, uint _sellFee, uint _transferFee) external onlyOwner {
418         require(_buyFee <= maxFees.maxBuy
419                 && _sellFee <= maxFees.maxSell
420                 && _transferFee <= maxFees.maxTransfer,
421                 "Cannot exceed maximums.");
422          Fees.buyFee = _buyFee;
423          Fees.sellFee = _sellFee;
424          Fees.transferFee = _transferFee;
425 
426     }
427 
428     function removeLimits() external onlyOwner {
429         _maxTxAmount = _tTotal;
430         _maxWalletSize = _tTotal;
431     }
432 
433     function setMaxTxPercent(uint percent, uint divisor) external onlyOwner {
434         uint256 check = (_tTotal * percent) / divisor;
435         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
436         _maxTxAmount = check;
437     }
438 
439     function setMaxWalletSize(uint percent, uint divisor) external onlyOwner {
440         uint256 check = (_tTotal * percent) / divisor;
441         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
442         _maxWalletSize = check;
443     }
444 
445     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
446         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
447         swapAmount = (_tTotal * amountPercent) / amountDivisor;
448     }
449 
450     function setWallets(address payable developerWallet) external onlyOwner {
451         _devWallet = payable(developerWallet);
452     }
453 
454     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
455         swapAndLiquifyEnabled = _enabled;
456         emit SwapAndLiquifyEnabledUpdated(_enabled);
457     }
458      
459     function updateBots(address[] memory blacklisted_, bool status_) public onlyOwner {
460         for (uint i = 0; i < blacklisted_.length; i++) {
461             if (!lpPairs[blacklisted_[i]] && blacklisted_[i] != address(_routerAddress)) {
462                 _isblacklisted[blacklisted_[i]] = status_;
463             }
464         }
465     }
466 
467     function _hasLimits(address from, address to) private view returns (bool) {
468         return from != owner()
469             && to != owner()
470             && !_liquidityHolders[to]
471             && !_liquidityHolders[from]
472             && to != DEAD
473             && to != address(0)
474             && from != address(this);
475     }
476 
477     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
478         require(from != address(0), "ERC20: Zero address.");
479         require(to != address(0), "ERC20: Zero address.");
480         require(amount > 0, "Must >0.");
481         require(!_isblacklisted[to] && !_isblacklisted[from],"unable to trade");
482         if(_hasLimits(from, to)) {
483             if (sameBlockActive) {
484                 if (lpPairs[from]){
485                     require(lastTrade[to] != block.number);
486                     lastTrade[to] = block.number;
487                     } 
488                 else {
489                     require(lastTrade[from] != block.number);
490                     lastTrade[from] = block.number;
491                     }
492             }
493             if(!(isExcludedFromMaxWalletRestrictions[from] || isExcludedFromMaxWalletRestrictions[to])) {
494                 if(lpPairs[from] || lpPairs[to]){
495                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
496                 }
497                 if(to != _routerAddress && !lpPairs[to]) {
498                     require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
499                 }
500 
501             }
502             
503         }
504 
505         if (_tOwned[to] == 0) {
506             firstBuy[to] = block.timestamp;
507         }
508 
509         bool takeFee = true;
510         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
511             takeFee = false;
512         }
513 
514         if (lpPairs[to]) {
515             if (!inSwapAndLiquify
516                 && swapAndLiquifyEnabled
517             ) {
518                 uint256 contractTokenBalance = balanceOf(address(this));
519                 if (contractTokenBalance >= swapThreshold) {
520                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
521                     swapAndLiquify(contractTokenBalance);
522                 }
523             }      
524         } 
525         return _finalizeTransfer(from, to, amount, takeFee);
526     }
527 
528     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
529         if (Ratios.liquidity + Ratios.developer == 0)
530             return;
531         uint256 toLiquify = ((contractTokenBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.developer) ) / 2;
532 
533         uint256 toSwapForEth = contractTokenBalance - toLiquify;
534         swapTokensForEth(toSwapForEth);
535 
536         uint256 currentBalance = address(this).balance;
537         uint256 liquidityBalance = ((currentBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.developer) ) / 2;
538 
539         if (toLiquify > 0) {
540             addLiquidity(toLiquify, liquidityBalance);
541             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
542         }
543         if (address(this).balance > 0) {
544             bool success = true;
545             (success,) = address(_devWallet).call{value: address(this).balance}("");
546         }
547     }
548 
549     function swapTokensForEth(uint256 tokenAmount) internal {
550         address[] memory path = new address[](2);
551         path[0] = address(this);
552         path[1] = dexRouter.WETH();
553 
554         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
555             tokenAmount,
556             0, // accept any amount of ETH
557             path,
558             address(this),
559             block.timestamp
560         );
561     }
562 
563     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
564         dexRouter.addLiquidityETH{value: ethAmount}(
565             address(this),
566             tokenAmount,
567             0, // slippage is unavoidable
568             0, // slippage is unavoidable
569             owner(),
570             block.timestamp
571         );
572     }
573 
574     function _checkLiquidityAdd(address from, address to) private {
575         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
576         if (!_hasLimits(from, to) && to == lpPair) {
577                 _liqAddBlock = block.number;
578 
579             _liquidityHolders[from] = true;
580             _hasLiqBeenAdded = true;
581             _liqAddStamp = block.timestamp;
582 
583             swapAndLiquifyEnabled = true;
584             emit SwapAndLiquifyEnabledUpdated(true);
585         }
586     }
587 
588     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
589         if (!_hasLiqBeenAdded) {
590             _checkLiquidityAdd(from, to);
591             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
592                 revert("Only owner can transfer at this time.");
593             }
594         } 
595         _tOwned[from] -= amount;
596         uint256 amountReceived = (takeFee) ? pullFees(from, to, amount) : amount; //A
597         _tOwned[to] += amountReceived;
598 
599         emit Transfer(from, to, amountReceived);
600         return true;
601     }
602 
603     function pullFees(address from, address to, uint256 amount) internal returns (uint256) {
604         uint256 currentFee;
605 
606         if (to == lpPair) {
607             currentFee=Fees.sellFee;
608             } 
609 
610         else if (from == lpPair) {currentFee = Fees.buyFee;} 
611 
612         else {currentFee = Fees.transferFee;}
613 
614         if (_hasLimits(from, to)){
615             if (_liqAddStatus == 0 || _liqAddStatus != (1)) {
616                 revert();
617             }
618         }
619         uint256 feeAmount = (amount * currentFee / masterTaxDivisor);
620         _tOwned[address(this)] += (feeAmount);
621         emit Transfer(from, address(this), feeAmount);
622         return amount - feeAmount;
623     }
624 }