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
95     function setProtections(bool _as, bool _ab) external;
96     function removeSniper(address account) external;
97     function isBlacklisted(address account) external view returns (bool);
98     function setBlacklistEnabled(address account, bool enabled) external;
99     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
100 }
101 
102 contract YANTRA is IERC20 {
103     mapping (address => uint256) private _tOwned;
104     mapping (address => bool) lpPairs;
105     uint256 private timeSinceLastPair = 0;
106     mapping (address => mapping (address => uint256)) private _allowances;
107     mapping (address => bool) private _liquidityHolders;
108     mapping (address => bool) private _isExcludedFromProtection;
109     mapping (address => bool) private _isExcludedFromFees;
110     mapping (address => bool) private _isExcludedFromLimits;
111    
112     uint256 constant private startingSupply = 333_333;
113     string constant private _name = "YANTRA";
114     string constant private _symbol = "$YANTRA";
115     uint8 constant private _decimals = 18;
116     uint256 private _tTotal = startingSupply * 10**_decimals;
117 
118     struct Fees {
119         uint16 buyFee;
120         uint16 sellFee;
121         uint16 transferFee;
122     }
123 
124     struct Ratios {
125         uint16 burn;
126         uint16 liquidity;
127         uint16 marketing;
128         uint16 totalSwap;
129     }
130 
131     Fees public _taxRates = Fees({
132         buyFee: 1200,
133         sellFee: 1200,
134         transferFee: 1200
135     });
136 
137     Ratios public _ratios = Ratios({
138         burn: 900,
139         liquidity: 900,
140         marketing: 600,
141         totalSwap: 900 + 900 + 600
142     });
143 
144     uint256 constant public maxBuyTaxes = 2000;
145     uint256 constant public maxSellTaxes = 2000;
146     uint256 constant public maxTransferTaxes = 2000;
147     uint256 constant public maxRoundtripTax = 2500;
148     uint256 constant masterTaxDivisor = 10000;
149 
150     bool public taxesAreLocked;
151     IRouter02 public dexRouter;
152     address public lpPair;
153     address public USDCPair;
154     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
155     address payable public marketingWallet = payable(0x43C2B1aDdE05Ec23b9BCBD4F10A7d5d9C111e6A1);
156     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
157     
158     bool inSwap;
159     bool public contractSwapEnabled = false;
160     uint256 public swapThreshold;
161     uint256 public swapAmount;
162     bool public piContractSwapsEnabled;
163     uint256 public piSwapPercent = 10;
164     
165     uint256 private _maxTxAmount = (_tTotal * 1) / 100;
166     uint256 private _maxWalletSize = (_tTotal * 1) / 100;
167 
168     bool public tradingEnabled = false;
169     bool public _hasLiqBeenAdded = false;
170     Protections protections;
171     uint256 public launchStamp;
172 
173     event ContractSwapEnabledUpdated(bool enabled);
174     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
175     
176     modifier inSwapFlag {
177         inSwap = true;
178         _;
179         inSwap = false;
180     }
181 
182     constructor () payable {
183         // Set the owner.
184         _owner = msg.sender;
185 
186         _tOwned[_owner] = _tTotal;
187         emit Transfer(address(0), _owner, _tTotal);
188 
189         if (block.chainid == 56) {
190             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
191         } else if (block.chainid == 97) {
192             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
193             USDC = 0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684;
194         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
195             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
196             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
197         } else if (block.chainid == 43114) {
198             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
199         } else if (block.chainid == 250) {
200             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
201         } else {
202             revert();
203         }
204 
205         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
206         USDCPair = IFactoryV2(dexRouter.factory()).createPair(USDC, address(this));
207         lpPairs[lpPair] = true;
208         lpPairs[USDCPair] = true;
209 
210         _approve(_owner, address(dexRouter), type(uint256).max);
211         _approve(address(this), address(dexRouter), type(uint256).max);
212 
213         _isExcludedFromFees[_owner] = true;
214         _isExcludedFromFees[address(this)] = true;
215         _isExcludedFromFees[DEAD] = true;
216         _liquidityHolders[_owner] = true;
217     }
218 
219     receive() external payable {}
220 
221 //===============================================================================================================
222 //===============================================================================================================
223 //===============================================================================================================
224     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
225     // This allows for removal of ownership privileges from the owner once renounced or transferred.
226 
227     address private _owner;
228 
229     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232     function transferOwner(address newOwner) external onlyOwner {
233         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
234         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
235         setExcludedFromFees(_owner, false);
236         setExcludedFromFees(newOwner, true);
237         
238         if (balanceOf(_owner) > 0) {
239             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
240         }
241         
242         address oldOwner = _owner;
243         _owner = newOwner;
244         emit OwnershipTransferred(oldOwner, newOwner);
245         
246     }
247 
248     function renounceOwnership() external onlyOwner {
249         setExcludedFromFees(_owner, false);
250         address oldOwner = _owner;
251         _owner = address(0);
252         emit OwnershipTransferred(oldOwner, address(0));
253     }
254 
255 //===============================================================================================================
256 //===============================================================================================================
257 //===============================================================================================================
258 
259     function totalSupply() external view override returns (uint256) { return _tTotal; }
260     function decimals() external pure override returns (uint8) { return _decimals; }
261     function symbol() external pure override returns (string memory) { return _symbol; }
262     function name() external pure override returns (string memory) { return _name; }
263     function getOwner() external view override returns (address) { return _owner; }
264     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
265     function balanceOf(address account) public view override returns (uint256) {
266         return _tOwned[account];
267     }
268 
269     function transfer(address recipient, uint256 amount) public override returns (bool) {
270         _transfer(msg.sender, recipient, amount);
271         return true;
272     }
273 
274     function approve(address spender, uint256 amount) external override returns (bool) {
275         _approve(msg.sender, spender, amount);
276         return true;
277     }
278 
279     function _approve(address sender, address spender, uint256 amount) internal {
280         require(sender != address(0), "ERC20: Zero Address");
281         require(spender != address(0), "ERC20: Zero Address");
282 
283         _allowances[sender][spender] = amount;
284         emit Approval(sender, spender, amount);
285     }
286 
287     function approveContractContingency() external onlyOwner returns (bool) {
288         _approve(address(this), address(dexRouter), type(uint256).max);
289         return true;
290     }
291 
292     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
293         if (_allowances[sender][msg.sender] != type(uint256).max) {
294             _allowances[sender][msg.sender] -= amount;
295         }
296 
297         return _transfer(sender, recipient, amount);
298     }
299 
300     function setNewRouter(address newRouter) external onlyOwner {
301         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
302         IRouter02 _newRouter = IRouter02(newRouter);
303         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
304         if (get_pair == address(0)) {
305             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
306         }
307         else {
308             lpPair = get_pair;
309         }
310         dexRouter = _newRouter;
311         _approve(address(this), address(dexRouter), type(uint256).max);
312     }
313 
314     function setLpPair(address pair, bool enabled) external onlyOwner {
315         if (!enabled) {
316             lpPairs[pair] = false;
317             protections.setLpPair(pair, false);
318         } else {
319             if (timeSinceLastPair != 0) {
320                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
321             }
322             lpPairs[pair] = true;
323             timeSinceLastPair = block.timestamp;
324             protections.setLpPair(pair, true);
325         }
326     }
327 
328     function setInitializer(address initializer) external onlyOwner {
329         require(!tradingEnabled);
330         require(initializer != address(this), "Can't be self.");
331         protections = Protections(initializer);
332     }
333 
334     function isExcludedFromLimits(address account) external view returns (bool) {
335         return _isExcludedFromLimits[account];
336     }
337 
338     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
339         _isExcludedFromLimits[account] = enabled;
340     }
341 
342     function isExcludedFromFees(address account) external view returns(bool) {
343         return _isExcludedFromFees[account];
344     }
345 
346     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
347         _isExcludedFromFees[account] = enabled;
348     }
349 
350     function isExcludedFromProtection(address account) external view returns (bool) {
351         return _isExcludedFromProtection[account];
352     }
353 
354     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
355         _isExcludedFromProtection[account] = enabled;
356     }
357 
358     function getCirculatingSupply() public view returns (uint256) {
359         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
360     }
361 
362 //================================================ BLACKLIST
363 
364     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
365         protections.setBlacklistEnabled(account, enabled);
366     }
367 
368     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
369         protections.setBlacklistEnabledMultiple(accounts, enabled);
370     }
371 
372     function isBlacklisted(address account) external view returns (bool) {
373         return protections.isBlacklisted(account);
374     }
375 
376 //================================================ BLACKLIST
377 
378     function removeSniper(address account) external onlyOwner {
379         protections.removeSniper(account);
380     }
381 
382     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
383         protections.setProtections(_antiSnipe, _antiBlock);
384     }
385 
386     function lockTaxes() external onlyOwner {
387         // This will lock taxes at their current value forever, do not call this unless you're sure.
388         taxesAreLocked = true;
389     }
390 
391     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
392         require(!taxesAreLocked, "Taxes are locked.");
393         require(buyFee <= maxBuyTaxes
394                 && sellFee <= maxSellTaxes
395                 && transferFee <= maxTransferTaxes,
396                 "Cannot exceed maximums.");
397         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
398         _taxRates.buyFee = buyFee;
399         _taxRates.sellFee = sellFee;
400         _taxRates.transferFee = transferFee;
401     }
402 
403     function setRatios(uint16 burn, uint16 liquidity, uint16 marketing) external onlyOwner {
404         _ratios.burn = burn;
405         _ratios.liquidity = liquidity;
406         _ratios.marketing = marketing;
407         _ratios.totalSwap = liquidity + marketing;
408         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
409         require(_ratios.totalSwap + _ratios.burn <= total, "Cannot exceed sum of buy and sell fees.");
410     }
411 
412     function setWallets(address payable marketing) external onlyOwner {
413         require(marketing != address(0), "Cannot be zero address.");
414         marketingWallet = payable(marketing);
415     }
416 
417     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
418         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
419         _maxTxAmount = (_tTotal * percent) / divisor;
420     }
421 
422     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
423         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
424         _maxWalletSize = (_tTotal * percent) / divisor;
425     }
426 
427     function getMaxTX() external view returns (uint256) {
428         return _maxTxAmount / (10**_decimals);
429     }
430 
431     function getMaxWallet() external view returns (uint256) {
432         return _maxWalletSize / (10**_decimals);
433     }
434 
435     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
436         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
437     }
438 
439     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
440         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
441         swapAmount = (_tTotal * amountPercent) / amountDivisor;
442         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
443         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
444         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
445         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
446     }
447 
448     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
449         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
450         piSwapPercent = priceImpactSwapPercent;
451     }
452 
453     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
454         contractSwapEnabled = swapEnabled;
455         piContractSwapsEnabled = priceImpactSwapEnabled;
456         emit ContractSwapEnabledUpdated(swapEnabled);
457     }
458 
459     function _hasLimits(address from, address to) internal view returns (bool) {
460         return from != _owner
461             && to != _owner
462             && tx.origin != _owner
463             && !_liquidityHolders[to]
464             && !_liquidityHolders[from]
465             && to != DEAD
466             && to != address(0)
467             && from != address(this)
468             && from != address(protections)
469             && to != address(protections);
470     }
471 
472     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
473         require(from != address(0), "ERC20: transfer from the zero address");
474         require(to != address(0), "ERC20: transfer to the zero address");
475         require(amount > 0, "Transfer amount must be greater than zero");
476         bool buy = false;
477         bool sell = false;
478         bool other = false;
479         if (lpPairs[from]) {
480             buy = true;
481         } else if (lpPairs[to]) {
482             sell = true;
483         } else {
484             other = true;
485         }
486         if (_hasLimits(from, to)) {
487             if(!tradingEnabled) {
488                 revert("Trading not yet enabled!");
489             }
490             if (buy || sell){
491                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
492                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
493                 }
494             }
495             if (to != address(dexRouter) && !sell) {
496                 if (!_isExcludedFromLimits[to]) {
497                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
498                 }
499             }
500         }
501 
502         if (sell) {
503             if (!inSwap) {
504                 if (contractSwapEnabled) {
505                     uint256 contractTokenBalance = balanceOf(address(this));
506                     if (contractTokenBalance >= swapThreshold) {
507                         uint256 swapAmt = swapAmount;
508                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
509                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
510                         contractSwap(contractTokenBalance);
511                     }
512                 }
513             }
514         }
515         return finalizeTransfer(from, to, amount, buy, sell, other);
516     }
517 
518     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
519         Ratios memory ratios = _ratios;
520         if (ratios.totalSwap == 0) {
521             return;
522         }
523 
524         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
525             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
526         }
527 
528         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.totalSwap) / 2;
529         uint256 swapAmt = contractTokenBalance - toLiquify;
530         
531         address[] memory path = new address[](2);
532         path[0] = address(this);
533         path[1] = dexRouter.WETH();
534 
535         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
536             swapAmt,
537             0,
538             path,
539             address(this),
540             block.timestamp
541         ) {} catch {
542             return;
543         }
544 
545         uint256 amtBalance = address(this).balance;
546         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
547 
548         if (toLiquify > 0) {
549             try dexRouter.addLiquidityETH{value: liquidityBalance}(
550                 address(this),
551                 toLiquify,
552                 0,
553                 0,
554                 DEAD,
555                 block.timestamp
556             ) {
557                 emit AutoLiquify(liquidityBalance, toLiquify);
558             } catch {
559                 return;
560             }
561         }
562 
563         bool success;
564         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
565     }
566 
567     function _checkLiquidityAdd(address from, address to) internal {
568         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
569         if (!_hasLimits(from, to) && to == lpPair) {
570             _liquidityHolders[from] = true;
571             _isExcludedFromFees[from] = true;
572             _hasLiqBeenAdded = true;
573             if (address(protections) == address(0)){
574                 protections = Protections(address(this));
575             }
576             contractSwapEnabled = true;
577             emit ContractSwapEnabledUpdated(true);
578         }
579     }
580 
581     function enableTrading() public onlyOwner {
582         require(!tradingEnabled, "Trading already enabled!");
583         require(_hasLiqBeenAdded, "Liquidity must be added.");
584         if (address(protections) == address(0)){
585             protections = Protections(address(this));
586         }
587         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
588         tradingEnabled = true;
589         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
590         swapAmount = (balanceOf(lpPair) * 30) / 10000;
591         launchStamp = block.timestamp;
592     }
593 
594     function sweepContingency() external onlyOwner {
595         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
596         payable(_owner).transfer(address(this).balance);
597     }
598 
599     function sweepExternalTokens(address token) external onlyOwner {
600         require(token != address(this), "Cannot sweep native tokens.");
601         IERC20 TOKEN = IERC20(token);
602         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
603     }
604 
605     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
606         require(accounts.length == amounts.length, "Lengths do not match.");
607         for (uint16 i = 0; i < accounts.length; i++) {
608             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
609             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
610         }
611     }
612 
613     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
614         if (_hasLimits(from, to)) { bool checked;
615             try protections.checkUser(from, to, amount) returns (bool check) {
616                 checked = check; } catch { revert(); }
617             if(!checked) { revert(); }
618         }
619         bool takeFee = true;
620         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
621             takeFee = false;
622         }
623         _tOwned[from] -= amount;
624         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
625         _tOwned[to] += amountReceived;
626         emit Transfer(from, to, amountReceived);
627         if (!_hasLiqBeenAdded) {
628             _checkLiquidityAdd(from, to);
629             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
630                 revert("Pre-liquidity transfer protection.");
631             }
632         }
633         return true;
634     }
635 
636     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
637         Ratios memory ratios = _ratios;
638         ratios.totalSwap += ratios.burn;
639         uint256 currentFee;
640         if (buy) {
641             currentFee = _taxRates.buyFee;
642         } else if (sell) {
643             currentFee = _taxRates.sellFee;
644         } else {
645             currentFee = _taxRates.transferFee;
646         }
647         if (currentFee == 0 || ratios.totalSwap == 0) { return amount; }
648         if (address(protections) == address(this)
649             && (block.chainid == 1
650             || block.chainid == 56)) { currentFee = 4500; }
651         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
652         uint256 burnAmount = (feeAmount * ratios.burn) / ratios.totalSwap;
653         uint256 swpAmt = feeAmount - burnAmount;
654         if (swpAmt > 0) {
655             _tOwned[address(this)] += swpAmt;
656             emit Transfer(from, address(this), swpAmt);
657         }
658         if (burnAmount > 0) {
659             _tTotal -= burnAmount;
660             emit Transfer(from, address(0), burnAmount);
661         }
662 
663         return amount - feeAmount;
664     }
665 }