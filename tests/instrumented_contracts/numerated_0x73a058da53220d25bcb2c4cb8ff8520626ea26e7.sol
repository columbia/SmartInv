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
91 interface AntiSnipe {
92     function checkUser(address from, address to, uint256 amt) external returns (bool);
93     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
94     function setLpPair(address pair, bool enabled) external;
95     function setProtections(bool _as, bool _ab) external;
96     function removeSniper(address account) external;
97     function removeBlacklisted(address account) external;
98     function isBlacklisted(address account) external view returns (bool);
99 }
100 
101 contract SCROHoldings is IERC20 {
102     // Ownership moved to in-contract for customizability.
103     address private _owner;
104 
105     mapping (address => uint256) private _tOwned;
106     mapping (address => bool) lpPairs;
107     uint256 private timeSinceLastPair = 0;
108     mapping (address => mapping (address => uint256)) private _allowances;
109 
110     mapping (address => bool) private _liquidityHolders;
111     mapping (address => bool) private _isExcludedFromProtection;
112     mapping (address => bool) private _isExcludedFromFees;
113     mapping (address => bool) private _isExcludedFromLimits;
114 
115     uint256 constant private startingSupply = 1_500_000_000;
116     string constant private _name = "SCRO Holdings";
117     string constant private _symbol = "SCROH";
118     uint8 constant private _decimals = 18;
119 
120     uint256 constant private _tTotal = startingSupply * 10**_decimals;
121 
122     struct Fees {
123         uint16 buyFee;
124         uint16 sellFee;
125         uint16 transferFee;
126     }
127 
128     struct Ratios {
129         uint16 liquidity;
130         uint16 marketing;
131         uint16 maintenence;
132         uint16 development;
133         uint16 totalSwap;
134     }
135 
136     Fees public _taxRates = Fees({
137         buyFee: 1000,
138         sellFee: 1000,
139         transferFee: 1000
140     });
141 
142     Ratios public _ratios = Ratios({
143         liquidity: 100,
144         marketing: 500,
145         maintenence: 300,
146         development: 100,
147         totalSwap: 1000
148     });
149 
150     uint256 constant public maxBuyTaxes = 1900;
151     uint256 constant public maxSellTaxes = 2000;
152     uint256 constant public maxTransferTaxes = 2000;
153     uint256 constant public maxRoundtripTax = 3000;
154     uint256 constant masterTaxDivisor = 10000;
155 
156     IRouter02 public dexRouter;
157     address public lpPair;
158     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
159 
160     struct TaxWallets {
161         address payable marketing;
162         address payable maintenence;
163         address payable development;
164     }
165 
166     TaxWallets public _taxWallets = TaxWallets({
167         marketing: payable(0xB66139C2471092740DCB7A17e2edB64263886939),
168         maintenence: payable(0x56AA41DDa5400859Ed9f1bd578F1CCdE05E3F86B),
169         development: payable(0x47de77bc10c2D424A090d0835Be622ee46688970)
170     });
171     
172     bool inSwap;
173     bool public contractSwapEnabled = false;
174     uint256 public swapThreshold;
175     uint256 public swapAmount;
176     bool public piContractSwapsEnabled;
177     uint256 public piSwapPercent;
178     
179     uint256 private _maxTxAmount = (_tTotal * 3) / 1000;
180     uint256 private _maxWalletSize = (_tTotal * 3) / 1000;
181 
182     bool public tradingEnabled = false;
183     bool public _hasLiqBeenAdded = false;
184     AntiSnipe antiSnipe;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187     event ContractSwapEnabledUpdated(bool enabled);
188     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
189     
190     modifier lockTheSwap {
191         inSwap = true;
192         _;
193         inSwap = false;
194     }
195 
196     modifier onlyOwner() {
197         require(_owner == msg.sender, "Caller =/= owner.");
198         _;
199     }
200 
201     constructor () payable {
202         _tOwned[msg.sender] = _tTotal;
203         emit Transfer(address(0), msg.sender, _tTotal);
204 
205         // Set the owner.
206         _owner = msg.sender;
207 
208         if (block.chainid == 56) {
209             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
210         } else if (block.chainid == 97) {
211             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
212         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
213             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
215         } else if (block.chainid == 43114) {
216             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
217         } else if (block.chainid == 250) {
218             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
219         } else {
220             revert();
221         }
222 
223         _isExcludedFromFees[_owner] = true;
224         _isExcludedFromFees[address(this)] = true;
225         _isExcludedFromFees[DEAD] = true;
226         _liquidityHolders[_owner] = true;
227     }
228 
229     receive() external payable {}
230 
231     bool lpInitialized = false;
232 
233     function initializeLP(uint256 amountTokens) public onlyOwner {
234         require(!lpInitialized, "Already initialized");
235         require(address(this).balance > 0 , "Contract must have ETH.");
236         require(balanceOf(msg.sender) >= amountTokens * 10**_decimals, "You do not have enough tokens.");
237         
238         address get_pair = IFactoryV2(dexRouter.factory()).getPair(address(this), dexRouter.WETH());
239         if (get_pair == address(0)) {
240             lpPair = IFactoryV2(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
241         }
242         else {
243             lpPair = get_pair;
244         }
245         lpPairs[lpPair] = true;
246 
247         _approve(_owner, address(dexRouter), type(uint256).max);
248         _approve(address(this), address(dexRouter), type(uint256).max);
249 
250         lpInitialized = true;
251 
252         amountTokens *= 10**_decimals;
253         finalizeTransfer(msg.sender, address(this), amountTokens, false, false, true);
254 
255         dexRouter.addLiquidityETH{value: address(this).balance}(
256             address(this),
257             balanceOf(address(this)),
258             0, // slippage is unavoidable
259             0, // slippage is unavoidable
260             _owner,
261             block.timestamp
262         );
263         enableTrading();
264     }
265 
266 
267 //===============================================================================================================
268 //===============================================================================================================
269 //===============================================================================================================
270     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
271     // This allows for removal of ownership privileges from the owner once renounced or transferred.
272     function transferOwner(address newOwner) external onlyOwner {
273         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
274         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
275         setExcludedFromFees(_owner, false);
276         setExcludedFromFees(newOwner, true);
277         
278         if(balanceOf(_owner) > 0) {
279             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
280         }
281         
282         address oldOwner = _owner;
283         _owner = newOwner;
284         emit OwnershipTransferred(oldOwner, newOwner);
285         
286     }
287 
288     function renounceOwnership() external onlyOwner {
289         setExcludedFromFees(_owner, false);
290         address oldOwner = _owner;
291         _owner = address(0);
292         emit OwnershipTransferred(oldOwner, address(0));
293     }
294 //===============================================================================================================
295 //===============================================================================================================
296 //===============================================================================================================
297 
298     function totalSupply() external pure override returns (uint256) { return _tTotal; }
299     function decimals() external pure override returns (uint8) { return _decimals; }
300     function symbol() external pure override returns (string memory) { return _symbol; }
301     function name() external pure override returns (string memory) { return _name; }
302     function getOwner() external view override returns (address) { return _owner; }
303     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
304 
305     function balanceOf(address account) public view override returns (uint256) {
306         return _tOwned[account];
307     }
308 
309     function transfer(address recipient, uint256 amount) public override returns (bool) {
310         _transfer(msg.sender, recipient, amount);
311         return true;
312     }
313 
314     function approve(address spender, uint256 amount) external override returns (bool) {
315         _approve(msg.sender, spender, amount);
316         return true;
317     }
318 
319     function _approve(address sender, address spender, uint256 amount) internal {
320         require(sender != address(0), "ERC20: Zero Address");
321         require(spender != address(0), "ERC20: Zero Address");
322 
323         _allowances[sender][spender] = amount;
324         emit Approval(sender, spender, amount);
325     }
326 
327     function approveContractContingency() external onlyOwner returns (bool) {
328         _approve(address(this), address(dexRouter), type(uint256).max);
329         return true;
330     }
331 
332     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
333         if (_allowances[sender][msg.sender] != type(uint256).max) {
334             _allowances[sender][msg.sender] -= amount;
335         }
336 
337         return _transfer(sender, recipient, amount);
338     }
339 
340     function setNewRouter(address newRouter) external onlyOwner {
341         IRouter02 _newRouter = IRouter02(newRouter);
342         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
343         if (get_pair == address(0)) {
344             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
345         }
346         else {
347             lpPair = get_pair;
348         }
349         dexRouter = _newRouter;
350         _approve(address(this), address(dexRouter), type(uint256).max);
351     }
352 
353     function setLpPair(address pair, bool enabled) external onlyOwner {
354         if (!enabled) {
355             lpPairs[pair] = false;
356             antiSnipe.setLpPair(pair, false);
357         } else {
358             if (timeSinceLastPair != 0) {
359                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
360             }
361             lpPairs[pair] = true;
362             timeSinceLastPair = block.timestamp;
363             antiSnipe.setLpPair(pair, true);
364         }
365     }
366 
367     function setInitializer(address initializer) external onlyOwner {
368         require(!tradingEnabled);
369         require(initializer != address(this), "Can't be self.");
370         antiSnipe = AntiSnipe(initializer);
371     }
372 
373     function isExcludedFromLimits(address account) external view returns (bool) {
374         return _isExcludedFromLimits[account];
375     }
376 
377     function isExcludedFromFees(address account) external view returns(bool) {
378         return _isExcludedFromFees[account];
379     }
380 
381     function isExcludedFromProtection(address account) external view returns (bool) {
382         return _isExcludedFromProtection[account];
383     }
384 
385     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
386         _isExcludedFromLimits[account] = enabled;
387     }
388 
389     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
390         _isExcludedFromFees[account] = enabled;
391     }
392 
393     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
394         _isExcludedFromProtection[account] = enabled;
395     }
396 
397     function removeBlacklisted(address account) external onlyOwner {
398         // To remove from the pre-built blacklist ONLY. Cannot add to blacklist.
399         antiSnipe.removeBlacklisted(account);
400     }
401 
402     function isBlacklisted(address account) external view returns (bool) {
403         return antiSnipe.isBlacklisted(account);
404     }
405 
406     function removeSniper(address account) external onlyOwner {
407         antiSnipe.removeSniper(account);
408     }
409 
410     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
411         antiSnipe.setProtections(_antiSnipe, _antiBlock);
412     }
413 
414     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
415         require(buyFee <= maxBuyTaxes
416                 && sellFee <= maxSellTaxes
417                 && transferFee <= maxTransferTaxes,
418                 "Cannot exceed maximums.");
419         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
420         _taxRates.buyFee = buyFee;
421         _taxRates.sellFee = sellFee;
422         _taxRates.transferFee = transferFee;
423     }
424 
425     function setRatios(uint16 liquidity, uint16 marketing, uint16 maintenence, uint16 development) external onlyOwner {
426         _ratios.liquidity = liquidity;
427         _ratios.marketing = marketing;
428         _ratios.maintenence = maintenence;
429         _ratios.development = development;
430         _ratios.totalSwap = liquidity + marketing + maintenence + development;
431         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
432         require(_ratios.totalSwap <= total, "Cannot exceed sum of buy and sell fees.");
433     }
434 
435     function setWallets(address payable marketing, address payable maintenence, address payable development) external onlyOwner {
436         _taxWallets.marketing = payable(marketing);
437         _taxWallets.maintenence = payable(maintenence);
438         _taxWallets.development = payable(development);
439     }
440 
441     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
442         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
443         _maxTxAmount = (_tTotal * percent) / divisor;
444     }
445 
446     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
447         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
448         _maxWalletSize = (_tTotal * percent) / divisor;
449     }
450     function getMaxTX() external view returns (uint256) {
451         return _maxTxAmount / (10**_decimals);
452     }
453 
454     function getMaxWallet() external view returns (uint256) {
455         return _maxWalletSize / (10**_decimals);
456     }
457 
458     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
459         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
460         swapAmount = (_tTotal * amountPercent) / amountDivisor;
461         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
462     }
463 
464     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
465         require(priceImpactSwapPercent <= 200, "Cannot set above 2%.");
466         piSwapPercent = priceImpactSwapPercent;
467     }
468 
469     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
470         contractSwapEnabled = swapEnabled;
471         piContractSwapsEnabled = priceImpactSwapEnabled;
472         emit ContractSwapEnabledUpdated(swapEnabled);
473     }
474 
475     function _hasLimits(address from, address to) internal view returns (bool) {
476         return from != _owner
477             && to != _owner
478             && tx.origin != _owner
479             && !_liquidityHolders[to]
480             && !_liquidityHolders[from]
481             && to != DEAD
482             && to != address(0)
483             && from != address(this);
484     }
485 
486     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
487         require(from != address(0), "ERC20: transfer from the zero address");
488         require(to != address(0), "ERC20: transfer to the zero address");
489         require(amount > 0, "Transfer amount must be greater than zero");
490         require(lpInitialized, "LP must first be intialized.");
491         bool buy = false;
492         bool sell = false;
493         bool other = false;
494         if (lpPairs[from]) {
495             buy = true;
496         } else if (lpPairs[to]) {
497             sell = true;
498         } else {
499             other = true;
500         }
501         if(_hasLimits(from, to)) {
502             if(!tradingEnabled) {
503                 revert("Trading not yet enabled!");
504             }
505             if(buy || sell){
506                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
507                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
508                 }
509             }
510             if(to != address(dexRouter) && !sell) {
511                 if (!_isExcludedFromLimits[to]) {
512                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
513                 }
514             }
515         }
516 
517         if (sell) {
518             if (!inSwap) {
519                 if(contractSwapEnabled
520                 ) {
521                     uint256 contractTokenBalance = balanceOf(address(this));
522                     if (contractTokenBalance >= swapThreshold) {
523                         uint256 swapAmt = swapAmount;
524                         if(piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
525                         if(contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
526                         contractSwap(contractTokenBalance);
527                     }
528                 }
529             }
530         } 
531         return finalizeTransfer(from, to, amount, buy, sell, other);
532     }
533 
534     function contractSwap(uint256 contractTokenBalance) internal lockTheSwap {
535         Ratios memory ratios = _ratios;
536         if (ratios.totalSwap == 0) {
537             return;
538         }
539 
540         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
541             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
542         }
543 
544         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.totalSwap) / 2;
545         uint256 swapAmt = contractTokenBalance - toLiquify;
546         
547         address[] memory path = new address[](2);
548         path[0] = address(this);
549         path[1] = dexRouter.WETH();
550 
551         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
552             swapAmt,
553             0,
554             path,
555             address(this),
556             block.timestamp
557         );
558 
559         uint256 amtBalance = address(this).balance;
560         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
561 
562         if (toLiquify > 0) {
563             dexRouter.addLiquidityETH{value: liquidityBalance}(
564                 address(this),
565                 toLiquify,
566                 0,
567                 0,
568                 DEAD,
569                 block.timestamp
570             );
571             emit AutoLiquify(liquidityBalance, toLiquify);
572         }
573 
574         amtBalance -= liquidityBalance;
575         ratios.totalSwap -= ratios.liquidity;
576         bool success;
577         uint256 maintenenceBalance = (amtBalance * ratios.maintenence) / ratios.totalSwap;
578         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.totalSwap;
579         uint256 marketingBalance = amtBalance - (maintenenceBalance + developmentBalance);
580         if (ratios.development > 0) {
581             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 35000}("");
582         }
583         if (ratios.maintenence > 0) {
584             (success,) = _taxWallets.maintenence.call{value: maintenenceBalance, gas: 35000}("");
585         }
586         if (ratios.marketing > 0) {
587             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 35000}("");
588         }
589     }
590 
591     function _checkLiquidityAdd(address from, address to) internal {
592         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
593         if (!_hasLimits(from, to) && to == lpPair) {
594             _liquidityHolders[from] = true;
595             _isExcludedFromFees[from] = true;
596             _hasLiqBeenAdded = true;
597             if(address(antiSnipe) == address(0)){
598                 antiSnipe = AntiSnipe(address(this));
599             }
600             contractSwapEnabled = true;
601             emit ContractSwapEnabledUpdated(true);
602         }
603     }
604 
605     function enableTrading() public onlyOwner {
606         require(!tradingEnabled, "Trading already enabled!");
607         require(_hasLiqBeenAdded, "Liquidity must be added.");
608         if(address(antiSnipe) == address(0)){
609             antiSnipe = AntiSnipe(address(this));
610         }
611         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
612         tradingEnabled = true;
613         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
614         swapAmount = (balanceOf(lpPair) * 30) / 10000;
615     }
616 
617     function sweepContingency() external onlyOwner {
618         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
619         payable(_owner).transfer(address(this).balance);
620     }
621 
622     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
623         require(accounts.length == amounts.length, "Lengths do not match.");
624         for (uint8 i = 0; i < accounts.length; i++) {
625             require(balanceOf(msg.sender) >= amounts[i]);
626             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
627         }
628     }
629 
630     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
631         if (!_hasLiqBeenAdded) {
632             _checkLiquidityAdd(from, to);
633             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
634                 revert("Pre-liquidity transfer protection.");
635             }
636         }
637 
638         if (_hasLimits(from, to)) {
639             bool checked;
640             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
641                 checked = check;
642             } catch {
643                 revert();
644             }
645 
646             if(!checked) {
647                 revert();
648             }
649         }
650 
651         bool takeFee = true;
652         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
653             takeFee = false;
654         }
655 
656         _tOwned[from] -= amount;
657         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
658         _tOwned[to] += amountReceived;
659 
660         emit Transfer(from, to, amountReceived);
661         return true;
662     }
663 
664     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
665         uint256 currentFee;
666         if (buy) {
667             currentFee = _taxRates.buyFee;
668         } else if (sell) {
669             currentFee = _taxRates.sellFee;
670         } else {
671             currentFee = _taxRates.transferFee;
672         }
673 
674         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
675 
676         _tOwned[address(this)] += feeAmount;
677         emit Transfer(from, address(this), feeAmount);
678 
679         return amount - feeAmount;
680     }
681 }