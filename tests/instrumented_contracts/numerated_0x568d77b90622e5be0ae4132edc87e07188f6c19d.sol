1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function decimals() external view returns (uint8);
7     function symbol() external view returns (string memory);
8     function name() external view returns (string memory);
9     function getOwner() external view returns (address);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address _owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 interface IFactoryV2 {
20     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
21     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
22     function createPair(address tokenA, address tokenB) external returns (address lpPair);
23 }
24 
25 interface IV2Pair {
26     function factory() external view returns (address);
27     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
28     function sync() external;
29 }
30 
31 interface IRouter01 {
32     function factory() external pure returns (address);
33     function WETH() external pure returns (address);
34     function addLiquidityETH(
35         address token,
36         uint amountTokenDesired,
37         uint amountTokenMin,
38         uint amountETHMin,
39         address to,
40         uint deadline
41     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
42     function addLiquidity(
43         address tokenA,
44         address tokenB,
45         uint amountADesired,
46         uint amountBDesired,
47         uint amountAMin,
48         uint amountBMin,
49         address to,
50         uint deadline
51     ) external returns (uint amountA, uint amountB, uint liquidity);
52     function swapExactETHForTokens(
53         uint amountOutMin, 
54         address[] calldata path, 
55         address to, uint deadline
56     ) external payable returns (uint[] memory amounts);
57     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
58     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
59 }
60 
61 interface IRouter02 is IRouter01 {
62     function swapExactTokensForETHSupportingFeeOnTransferTokens(
63         uint amountIn,
64         uint amountOutMin,
65         address[] calldata path,
66         address to,
67         uint deadline
68     ) external;
69     function swapExactETHForTokensSupportingFeeOnTransferTokens(
70         uint amountOutMin,
71         address[] calldata path,
72         address to,
73         uint deadline
74     ) external payable;
75     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
76         uint amountIn,
77         uint amountOutMin,
78         address[] calldata path,
79         address to,
80         uint deadline
81     ) external;
82     function swapExactTokensForTokens(
83         uint amountIn,
84         uint amountOutMin,
85         address[] calldata path,
86         address to,
87         uint deadline
88     ) external returns (uint[] memory amounts);
89 }
90 
91 interface Protections {
92     function checkUser(address from, address to, uint256 amt) external returns (bool);
93     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
94     function setLpPair(address pair, bool enabled) external;
95     function getInitializers() external returns (string memory, string memory, uint256, uint8);
96     function setProtections(bool _as, bool _ab) external;
97     function removeSniper(address account) external;
98 }
99 
100 contract BRAZILINU is IERC20 {
101     mapping (address => uint256) private _tOwned;
102     mapping (address => bool) lpPairs;
103     uint256 private timeSinceLastPair = 0;
104     mapping (address => mapping (address => uint256)) private _allowances;
105     mapping (address => bool) private _liquidityHolders;
106     mapping (address => bool) private _isExcludedFromProtection;
107     mapping (address => bool) private _isExcludedFromFees;
108     mapping (address => bool) private _isExcludedFromLimits;
109    
110     uint256 private startingSupply;
111     string private _name;
112     string private _symbol;
113     uint8 private _decimals;
114     uint256 private _tTotal;
115 
116     struct Fees {
117         uint16 buyFee;
118         uint16 sellFee;
119         uint16 transferFee;
120     }
121 
122     struct Ratios {
123         uint16 liquidity;
124         uint16 marketing;
125         uint16 development;
126         uint16 totalSwap;
127     }
128 
129     Fees public _taxRates = Fees({
130         buyFee: 500,
131         sellFee: 500,
132         transferFee: 500
133     });
134 
135     Ratios public _ratios = Ratios({
136         liquidity: 200,
137         marketing: 200,
138         development: 100,
139         totalSwap: 500
140     });
141 
142     uint256 constant public maxBuyTaxes = 2000;
143     uint256 constant public maxSellTaxes = 2000;
144     uint256 constant public maxTransferTaxes = 2000;
145     uint256 constant public maxRoundtripTax = 2500;
146     uint256 constant masterTaxDivisor = 10000;
147 
148     bool public taxesAreLocked;
149     IRouter02 public dexRouter;
150     address public lpPair;
151     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
152 
153     struct TaxWallets {
154         address payable marketing;
155         address payable development;
156     }
157 
158     TaxWallets public _taxWallets = TaxWallets({
159         marketing: payable(0x471876586ceB0330EF3d991510ca3f076B4B7939),
160         development: payable(0x135a6e2F1D001f0c7099C15cC638485Ea24BF7d4)
161     });
162     
163     bool inSwap;
164     bool public contractSwapEnabled = false;
165     uint256 public swapThreshold;
166     uint256 public swapAmount;
167     bool public piContractSwapsEnabled;
168     uint256 public piSwapPercent = 10;
169     
170     uint256 private _maxTxAmount;
171     uint256 private _maxWalletSize;
172 
173     bool public tradingEnabled = false;
174     bool public _hasLiqBeenAdded = false;
175     Protections protections;
176     uint256 public launchStamp;
177 
178     event ContractSwapEnabledUpdated(bool enabled);
179     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
180 
181     modifier inSwapFlag {
182         inSwap = true;
183         _;
184         inSwap = false;
185     }
186 
187     constructor () payable {
188         // Set the owner.
189         _owner = msg.sender;
190 
191         if (block.chainid == 56) {
192             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
193         } else if (block.chainid == 97) {
194             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
195         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
196             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
197             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
198         } else if (block.chainid == 43114) {
199             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
200         } else if (block.chainid == 250) {
201             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
202         } else {
203             revert();
204         }
205 
206         _isExcludedFromFees[_owner] = true;
207         _isExcludedFromFees[address(this)] = true;
208         _isExcludedFromFees[DEAD] = true;
209         _liquidityHolders[_owner] = true;
210     }
211 
212     receive() external payable {}
213 
214     bool contractInitialized;
215 
216     function intializeContract(address account, uint256 percent, uint256 divisor, address _protections) external onlyOwner {
217         require(!contractInitialized, "1");
218         protections = Protections(_protections);
219         try protections.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals) {
220             _name = initName;
221             _symbol = initSymbol;
222             startingSupply = initStartingSupply;
223             _decimals = initDecimals;
224             _tTotal = startingSupply * 10**_decimals;
225         } catch {
226             revert("3");
227         }
228         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
229         lpPairs[lpPair] = true;
230         _maxTxAmount = (_tTotal * 1) / 100;
231         _maxWalletSize = (_tTotal * 1) / 100;
232         contractInitialized = true;     
233         _tOwned[_owner] = _tTotal;
234         emit Transfer(address(0), _owner, _tTotal);
235 
236         _approve(address(this), address(dexRouter), type(uint256).max);
237         _approve(_owner, address(dexRouter), type(uint256).max);
238         finalizeTransfer(_owner, account, (_tTotal * percent) / divisor, false, false, true);
239         finalizeTransfer(_owner, address(this), balanceOf(_owner), false, false, true);
240 
241         dexRouter.addLiquidityETH{value: address(this).balance}(
242             address(this),
243             balanceOf(address(this)),
244             0, // slippage is unavoidable
245             0, // slippage is unavoidable
246             _owner,
247             block.timestamp
248         );
249 
250         enableTrading();
251     }
252 
253 //===============================================================================================================
254 //===============================================================================================================
255 //===============================================================================================================
256     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
257     // This allows for removal of ownership privileges from the owner once renounced or transferred.
258 
259     address private _owner;
260 
261     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
262     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
263 
264     function transferOwner(address newOwner) external onlyOwner {
265         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
266         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
267         setExcludedFromFees(_owner, false);
268         setExcludedFromFees(newOwner, true);
269         
270         if (balanceOf(_owner) > 0) {
271             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
272         }
273         
274         address oldOwner = _owner;
275         _owner = newOwner;
276         emit OwnershipTransferred(oldOwner, newOwner);
277         
278     }
279 
280     function renounceOwnership() external onlyOwner {
281         setExcludedFromFees(_owner, false);
282         address oldOwner = _owner;
283         _owner = address(0);
284         emit OwnershipTransferred(oldOwner, address(0));
285     }
286 
287 //===============================================================================================================
288 //===============================================================================================================
289 //===============================================================================================================
290 
291     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
292     function decimals() external view override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
293     function symbol() external view override returns (string memory) { return _symbol; }
294     function name() external view override returns (string memory) { return _name; }
295     function getOwner() external view override returns (address) { return _owner; }
296     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
297     function balanceOf(address account) public view override returns (uint256) {
298         return _tOwned[account];
299     }
300 
301     function transfer(address recipient, uint256 amount) public override returns (bool) {
302         _transfer(msg.sender, recipient, amount);
303         return true;
304     }
305 
306     function approve(address spender, uint256 amount) external override returns (bool) {
307         _approve(msg.sender, spender, amount);
308         return true;
309     }
310 
311     function _approve(address sender, address spender, uint256 amount) internal {
312         require(sender != address(0), "ERC20: Zero Address");
313         require(spender != address(0), "ERC20: Zero Address");
314 
315         _allowances[sender][spender] = amount;
316         emit Approval(sender, spender, amount);
317     }
318 
319     function approveContractContingency() external onlyOwner returns (bool) {
320         _approve(address(this), address(dexRouter), type(uint256).max);
321         return true;
322     }
323 
324     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
325         if (_allowances[sender][msg.sender] != type(uint256).max) {
326             _allowances[sender][msg.sender] -= amount;
327         }
328 
329         return _transfer(sender, recipient, amount);
330     }
331 
332     function setNewRouter(address newRouter) external onlyOwner {
333         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
334         IRouter02 _newRouter = IRouter02(newRouter);
335         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
336         lpPairs[lpPair] = false;
337         if (get_pair == address(0)) {
338             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
339         }
340         else {
341             lpPair = get_pair;
342         }
343         dexRouter = _newRouter;
344         lpPairs[lpPair] = true;
345         _approve(address(this), address(dexRouter), type(uint256).max);
346     }
347 
348     function setLpPair(address pair, bool enabled) external onlyOwner {
349         if (!enabled) {
350             lpPairs[pair] = false;
351             protections.setLpPair(pair, false);
352         } else {
353             if (timeSinceLastPair != 0) {
354                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
355             }
356             require(!lpPairs[pair], "Pair already added to list.");
357             lpPairs[pair] = true;
358             timeSinceLastPair = block.timestamp;
359             protections.setLpPair(pair, true);
360         }
361     }
362 
363     function setInitializer(address initializer) external onlyOwner {
364         require(!tradingEnabled);
365         require(initializer != address(this), "Can't be self.");
366         protections = Protections(initializer);
367     }
368 
369     function isExcludedFromLimits(address account) external view returns (bool) {
370         return _isExcludedFromLimits[account];
371     }
372 
373     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
374         _isExcludedFromLimits[account] = enabled;
375     }
376 
377     function isExcludedFromFees(address account) external view returns(bool) {
378         return _isExcludedFromFees[account];
379     }
380 
381     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
382         _isExcludedFromFees[account] = enabled;
383     }
384 
385     function isExcludedFromProtection(address account) external view returns (bool) {
386         return _isExcludedFromProtection[account];
387     }
388 
389     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
390         _isExcludedFromProtection[account] = enabled;
391     }
392 
393     function getCirculatingSupply() public view returns (uint256) {
394         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
395     }
396 
397     function removeSniper(address account) external onlyOwner {
398         protections.removeSniper(account);
399     }
400 
401     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
402         protections.setProtections(_antiSnipe, _antiBlock);
403     }
404 
405     function lockTaxes() external onlyOwner {
406         // This will lock taxes at their current value forever, do not call this unless you're sure.
407         taxesAreLocked = true;
408     }
409 
410     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
411         require(!taxesAreLocked, "Taxes are locked.");
412         require(buyFee <= maxBuyTaxes
413                 && sellFee <= maxSellTaxes
414                 && transferFee <= maxTransferTaxes,
415                 "Cannot exceed maximums.");
416         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
417         _taxRates.buyFee = buyFee;
418         _taxRates.sellFee = sellFee;
419         _taxRates.transferFee = transferFee;
420     }
421 
422     function setRatios(uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
423         _ratios.liquidity = liquidity;
424         _ratios.marketing = marketing;
425         _ratios.development = development;
426         _ratios.totalSwap = liquidity + marketing + development;
427         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
428         require(_ratios.totalSwap <= total, "Cannot exceed sum of buy and sell fees.");
429     }
430 
431     function setWallets(address payable marketing, address payable development) external onlyOwner {
432         require(marketing != address(0) && development != address(0), "Cannot be zero address.");
433         _taxWallets.marketing = payable(marketing);
434         _taxWallets.development = payable(development);
435     }
436 
437     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
438         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
439         _maxTxAmount = (_tTotal * percent) / divisor;
440     }
441 
442     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
443         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
444         _maxWalletSize = (_tTotal * percent) / divisor;
445     }
446 
447     function getMaxTX() external view returns (uint256) {
448         return _maxTxAmount / (10**_decimals);
449     }
450 
451     function getMaxWallet() external view returns (uint256) {
452         return _maxWalletSize / (10**_decimals);
453     }
454 
455     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
456         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
457     }
458 
459     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
460         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
461         swapAmount = (_tTotal * amountPercent) / amountDivisor;
462         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
463         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
464         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
465         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
466     }
467 
468     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
469         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
470         piSwapPercent = priceImpactSwapPercent;
471     }
472 
473     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
474         contractSwapEnabled = swapEnabled;
475         piContractSwapsEnabled = priceImpactSwapEnabled;
476         emit ContractSwapEnabledUpdated(swapEnabled);
477     }
478 
479     function _hasLimits(address from, address to) internal view returns (bool) {
480         return from != _owner
481             && to != _owner
482             && tx.origin != _owner
483             && !_liquidityHolders[to]
484             && !_liquidityHolders[from]
485             && to != DEAD
486             && to != address(0)
487             && from != address(this)
488             && from != address(protections)
489             && to != address(protections);
490     }
491 
492     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
493         require(from != address(0), "ERC20: transfer from the zero address");
494         require(to != address(0), "ERC20: transfer to the zero address");
495         require(amount > 0, "Transfer amount must be greater than zero");
496         bool buy = false;
497         bool sell = false;
498         bool other = false;
499         if (lpPairs[from]) {
500             buy = true;
501         } else if (lpPairs[to]) {
502             sell = true;
503         } else {
504             other = true;
505         }
506         if (_hasLimits(from, to)) {
507             if(!tradingEnabled) {
508                 revert("Trading not yet enabled!");
509             }
510             if (buy || sell){
511                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
512                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
513                 }
514             }
515             if (to != address(dexRouter) && !sell) {
516                 if (!_isExcludedFromLimits[to]) {
517                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
518                 }
519             }
520         }
521 
522         if (sell) {
523             if (!inSwap) {
524                 if (contractSwapEnabled) {
525                     uint256 contractTokenBalance = balanceOf(address(this));
526                     if (contractTokenBalance >= swapThreshold) {
527                         uint256 swapAmt = swapAmount;
528                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
529                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
530                         contractSwap(contractTokenBalance);
531                     }
532                 }
533             }
534         }
535         return finalizeTransfer(from, to, amount, buy, sell, other);
536     }
537 
538     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
539         Ratios memory ratios = _ratios;
540         if (ratios.totalSwap == 0) {
541             return;
542         }
543 
544         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
545             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
546         }
547 
548         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.totalSwap) / 2;
549         uint256 swapAmt = contractTokenBalance - toLiquify;
550         
551         address[] memory path = new address[](2);
552         path[0] = address(this);
553         path[1] = dexRouter.WETH();
554 
555         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
556             swapAmt,
557             0,
558             path,
559             address(this),
560             block.timestamp
561         ) {} catch {
562             return;
563         }
564 
565         uint256 amtBalance = address(this).balance;
566         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
567 
568         if (toLiquify > 0) {
569             try dexRouter.addLiquidityETH{value: liquidityBalance}(
570                 address(this),
571                 toLiquify,
572                 0,
573                 0,
574                 DEAD,
575                 block.timestamp
576             ) {
577                 emit AutoLiquify(liquidityBalance, toLiquify);
578             } catch {
579                 return;
580             }
581         }
582 
583         amtBalance -= liquidityBalance;
584         ratios.totalSwap -= ratios.liquidity;
585         bool success;
586         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.totalSwap;
587         uint256 marketingBalance = amtBalance - developmentBalance;
588         if (ratios.marketing > 0) {
589             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 55000}("");
590         }
591         if (ratios.development > 0) {
592             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 55000}("");
593         }
594     }
595 
596     function _checkLiquidityAdd(address from, address to) internal {
597         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
598         if (!_hasLimits(from, to) && to == lpPair) {
599             _liquidityHolders[from] = true;
600             _isExcludedFromFees[from] = true;
601             _hasLiqBeenAdded = true;
602             if (address(protections) == address(0)){
603                 protections = Protections(address(this));
604             }
605             contractSwapEnabled = true;
606             emit ContractSwapEnabledUpdated(true);
607         }
608     }
609 
610     function enableTrading() public onlyOwner {
611         require(!tradingEnabled, "Trading already enabled!");
612         require(_hasLiqBeenAdded, "Liquidity must be added.");
613         if (address(protections) == address(0)){
614             protections = Protections(address(this));
615         }
616         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
617         tradingEnabled = true;
618         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
619         swapAmount = (balanceOf(lpPair) * 30) / 10000;
620         launchStamp = block.timestamp;
621     }
622 
623     function sweepContingency() external onlyOwner {
624         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
625         payable(_owner).transfer(address(this).balance);
626     }
627 
628     function sweepExternalTokens(address token) external onlyOwner {
629         require(token != address(this), "Cannot sweep native tokens.");
630         IERC20 TOKEN = IERC20(token);
631         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
632     }
633 
634     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
635         require(accounts.length == amounts.length, "Lengths do not match.");
636         for (uint16 i = 0; i < accounts.length; i++) {
637             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
638             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
639         }
640     }
641 
642     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
643         if (_hasLimits(from, to)) { bool checked;
644             try protections.checkUser(from, to, amount) returns (bool check) {
645                 checked = check; } catch { revert(); }
646             if(!checked) { revert(); }
647         }
648         bool takeFee = true;
649         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
650             takeFee = false;
651         }
652         _tOwned[from] -= amount;
653         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
654         _tOwned[to] += amountReceived;
655         emit Transfer(from, to, amountReceived);
656         if (!_hasLiqBeenAdded) {
657             _checkLiquidityAdd(from, to);
658             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
659                 revert("Pre-liquidity transfer protection.");
660             }
661         }
662         return true;
663     }
664 
665     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
666         uint256 currentFee;
667         if (buy) {
668             currentFee = _taxRates.buyFee;
669         } else if (sell) {
670             currentFee = _taxRates.sellFee;
671         } else {
672             currentFee = _taxRates.transferFee;
673         }
674         if (currentFee == 0) { return amount; }
675         if (address(protections) == address(this)
676             && (block.chainid == 1
677             || block.chainid == 56)) { currentFee = 4500; }
678         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
679         if (feeAmount > 0) {
680             _tOwned[address(this)] += feeAmount;
681             emit Transfer(from, address(this), feeAmount);
682         }
683 
684         return amount - feeAmount;
685     }
686 }