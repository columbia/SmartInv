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
97 }
98 
99 contract DejitaruKaida is IERC20 {
100     mapping (address => uint256) private _tOwned;
101     mapping (address => bool) lpPairs;
102     uint256 private timeSinceLastPair = 0;
103     mapping (address => mapping (address => uint256)) private _allowances;
104     mapping (address => bool) private _liquidityHolders;
105     mapping (address => bool) private _isExcludedFromProtection;
106     mapping (address => bool) private _isExcludedFromFees;
107     mapping (address => bool) private _isExcludedFromLimits;
108    
109     uint256 constant private startingSupply = 500_000_000_000;
110     string constant private _name = "Dejitaru Kaida";
111     string constant private _symbol = "Kaida";
112     uint8 constant private _decimals = 9;
113     uint256 constant private _tTotal = startingSupply * 10**_decimals;
114 
115     struct Fees {
116         uint16 buyFee;
117         uint16 sellFee;
118         uint16 transferFee;
119     }
120 
121     struct Ratios {
122         uint16 liquidity;
123         uint16 marketing;
124         uint16 development;
125         uint16 totalSwap;
126     }
127 
128     Fees public _taxRates = Fees({
129         buyFee: 500,
130         sellFee: 500,
131         transferFee: 500
132     });
133 
134     Ratios public _ratios = Ratios({
135         liquidity: 100,
136         marketing: 300,
137         development: 300,
138         totalSwap: 1000
139     });
140 
141     uint256 constant public maxBuyTaxes = 1500;
142     uint256 constant public maxSellTaxes = 1500;
143     uint256 constant public maxTransferTaxes = 1500;
144     uint256 constant public maxRoundtripTax = 2000;
145     uint256 constant masterTaxDivisor = 10000;
146 
147     bool public taxesAreLocked;
148     IRouter02 public dexRouter;
149     address public lpPair;
150     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
151 
152     struct TaxWallets {
153         address payable marketing;
154         address payable development;
155     }
156 
157     TaxWallets public _taxWallets = TaxWallets({
158         marketing: payable(0xb06dD9734396EfF71E6B8dBBc18E2a2d50C4D19B),
159         development: payable(0xB92B369ef7aee93c166584c35c927bcB0249d5D0)
160     });
161     
162     bool inSwap;
163     bool public contractSwapEnabled = false;
164     uint256 public swapThreshold;
165     uint256 public swapAmount;
166     bool public piContractSwapsEnabled;
167     uint256 public piSwapPercent = 10;
168     
169     uint256 private _maxTxAmount = (_tTotal * 5) / 1000;
170     uint256 private _maxWalletSize = (_tTotal * 1) / 100;
171 
172     bool public tradingEnabled = false;
173     bool public _hasLiqBeenAdded = false;
174     Protections protections;
175     uint256 public launchStamp;
176 
177     event ContractSwapEnabledUpdated(bool enabled);
178     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
179     
180     modifier inSwapFlag {
181         inSwap = true;
182         _;
183         inSwap = false;
184     }
185 
186     constructor () payable {
187         // Set the owner.
188         _owner = msg.sender;
189 
190         _tOwned[_owner] = _tTotal;
191         emit Transfer(address(0), _owner, _tTotal);
192 
193         if (block.chainid == 56) {
194             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
195         } else if (block.chainid == 97) {
196             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
197         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
198             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
199             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
200         } else if (block.chainid == 43114) {
201             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
202         } else if (block.chainid == 250) {
203             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
204         } else {
205             revert();
206         }
207 
208         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
209         lpPairs[lpPair] = true;
210 
211         _approve(_owner, address(dexRouter), type(uint256).max);
212         _approve(address(this), address(dexRouter), type(uint256).max);
213 
214         _isExcludedFromFees[_owner] = true;
215         _isExcludedFromFees[address(this)] = true;
216         _isExcludedFromFees[DEAD] = true;
217         _liquidityHolders[_owner] = true;
218     }
219 
220     receive() external payable {}
221 
222 //===============================================================================================================
223 //===============================================================================================================
224 //===============================================================================================================
225     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
226     // This allows for removal of ownership privileges from the owner once renounced or transferred.
227 
228     address private _owner;
229 
230     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233     function transferOwner(address newOwner) external onlyOwner {
234         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
235         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
236         setExcludedFromFees(_owner, false);
237         setExcludedFromFees(newOwner, true);
238         
239         if (balanceOf(_owner) > 0) {
240             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
241         }
242         
243         address oldOwner = _owner;
244         _owner = newOwner;
245         emit OwnershipTransferred(oldOwner, newOwner);
246         
247     }
248 
249     function renounceOwnership() external onlyOwner {
250         setExcludedFromFees(_owner, false);
251         address oldOwner = _owner;
252         _owner = address(0);
253         emit OwnershipTransferred(oldOwner, address(0));
254     }
255 
256 //===============================================================================================================
257 //===============================================================================================================
258 //===============================================================================================================
259 
260     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
261     function decimals() external pure override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
262     function symbol() external pure override returns (string memory) { return _symbol; }
263     function name() external pure override returns (string memory) { return _name; }
264     function getOwner() external view override returns (address) { return _owner; }
265     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
266     function balanceOf(address account) public view override returns (uint256) {
267         return _tOwned[account];
268     }
269 
270     function transfer(address recipient, uint256 amount) public override returns (bool) {
271         _transfer(msg.sender, recipient, amount);
272         return true;
273     }
274 
275     function approve(address spender, uint256 amount) external override returns (bool) {
276         _approve(msg.sender, spender, amount);
277         return true;
278     }
279 
280     function _approve(address sender, address spender, uint256 amount) internal {
281         require(sender != address(0), "ERC20: Zero Address");
282         require(spender != address(0), "ERC20: Zero Address");
283 
284         _allowances[sender][spender] = amount;
285         emit Approval(sender, spender, amount);
286     }
287 
288     function approveContractContingency() external onlyOwner returns (bool) {
289         _approve(address(this), address(dexRouter), type(uint256).max);
290         return true;
291     }
292 
293     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
294         if (_allowances[sender][msg.sender] != type(uint256).max) {
295             _allowances[sender][msg.sender] -= amount;
296         }
297 
298         return _transfer(sender, recipient, amount);
299     }
300 
301     function setNewRouter(address newRouter) external onlyOwner {
302         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
303         IRouter02 _newRouter = IRouter02(newRouter);
304         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
305         if (get_pair == address(0)) {
306             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
307         }
308         else {
309             lpPair = get_pair;
310         }
311         dexRouter = _newRouter;
312         _approve(address(this), address(dexRouter), type(uint256).max);
313     }
314 
315     function setLpPair(address pair, bool enabled) external onlyOwner {
316         if (!enabled) {
317             lpPairs[pair] = false;
318             protections.setLpPair(pair, false);
319         } else {
320             if (timeSinceLastPair != 0) {
321                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
322             }
323             lpPairs[pair] = true;
324             timeSinceLastPair = block.timestamp;
325             protections.setLpPair(pair, true);
326         }
327     }
328 
329     function setInitializer(address initializer) external onlyOwner {
330         require(!tradingEnabled);
331         require(initializer != address(this), "Can't be self.");
332         protections = Protections(initializer);
333     }
334 
335     function isExcludedFromLimits(address account) external view returns (bool) {
336         return _isExcludedFromLimits[account];
337     }
338 
339     function isExcludedFromFees(address account) external view returns(bool) {
340         return _isExcludedFromFees[account];
341     }
342 
343     function isExcludedFromProtection(address account) external view returns (bool) {
344         return _isExcludedFromProtection[account];
345     }
346 
347     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
348         _isExcludedFromLimits[account] = enabled;
349     }
350 
351     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
352         _isExcludedFromFees[account] = enabled;
353     }
354 
355     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
356         _isExcludedFromProtection[account] = enabled;
357     }
358 
359     function getCirculatingSupply() public view returns (uint256) {
360         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
361     }
362 
363     function removeSniper(address account) external onlyOwner {
364         protections.removeSniper(account);
365     }
366 
367     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
368         protections.setProtections(_antiSnipe, _antiBlock);
369     }
370 
371     function lockTaxes() external onlyOwner {
372         // This will lock taxes at their current value forever, do not call this unless you're sure.
373         taxesAreLocked = true;
374     }
375 
376     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
377         require(!taxesAreLocked, "Taxes are locked.");
378         require(buyFee <= maxBuyTaxes
379                 && sellFee <= maxSellTaxes
380                 && transferFee <= maxTransferTaxes,
381                 "Cannot exceed maximums.");
382         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
383         _taxRates.buyFee = buyFee;
384         _taxRates.sellFee = sellFee;
385         _taxRates.transferFee = transferFee;
386     }
387 
388     function setRatios(uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
389         _ratios.liquidity = liquidity;
390         _ratios.marketing = marketing;
391         _ratios.development = development;
392         _ratios.totalSwap = liquidity + marketing + development;
393         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
394         require(_ratios.totalSwap <= total, "Cannot exceed sum of buy and sell fees.");
395     }
396 
397     function setWallets(address payable marketing, address payable development) external onlyOwner {
398         _taxWallets.marketing = payable(marketing);
399         _taxWallets.development = payable(development);
400     }
401 
402     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
403         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
404         _maxTxAmount = (_tTotal * percent) / divisor;
405     }
406 
407     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
408         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
409         _maxWalletSize = (_tTotal * percent) / divisor;
410     }
411 
412     function getMaxTX() external view returns (uint256) {
413         return _maxTxAmount / (10**_decimals);
414     }
415 
416     function getMaxWallet() external view returns (uint256) {
417         return _maxWalletSize / (10**_decimals);
418     }
419 
420     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
421         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
422     }
423 
424     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
425         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
426         swapAmount = (_tTotal * amountPercent) / amountDivisor;
427         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
428         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
429         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
430         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
431     }
432 
433     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
434         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
435         piSwapPercent = priceImpactSwapPercent;
436     }
437 
438     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
439         contractSwapEnabled = swapEnabled;
440         piContractSwapsEnabled = priceImpactSwapEnabled;
441         emit ContractSwapEnabledUpdated(swapEnabled);
442     }
443 
444     function _hasLimits(address from, address to) internal view returns (bool) {
445         return from != _owner
446             && to != _owner
447             && tx.origin != _owner
448             && !_liquidityHolders[to]
449             && !_liquidityHolders[from]
450             && to != DEAD
451             && to != address(0)
452             && from != address(this)
453             && from != address(protections)
454             && to != address(protections);
455     }
456 
457     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
458         require(from != address(0), "ERC20: transfer from the zero address");
459         require(to != address(0), "ERC20: transfer to the zero address");
460         require(amount > 0, "Transfer amount must be greater than zero");
461         bool buy = false;
462         bool sell = false;
463         bool other = false;
464         if (lpPairs[from]) {
465             buy = true;
466         } else if (lpPairs[to]) {
467             sell = true;
468         } else {
469             other = true;
470         }
471         if (_hasLimits(from, to)) {
472             if(!tradingEnabled) {
473                 revert("Trading not yet enabled!");
474             }
475             if (buy || sell){
476                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
477                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
478                 }
479             }
480             if (to != address(dexRouter) && !sell) {
481                 if (!_isExcludedFromLimits[to]) {
482                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
483                 }
484             }
485         }
486 
487         if (sell) {
488             if (!inSwap) {
489                 if (contractSwapEnabled) {
490                     uint256 contractTokenBalance = balanceOf(address(this));
491                     if (contractTokenBalance >= swapThreshold) {
492                         uint256 swapAmt = swapAmount;
493                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
494                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
495                         contractSwap(contractTokenBalance);
496                     }
497                 }
498             }
499         }
500         return finalizeTransfer(from, to, amount, buy, sell, other);
501     }
502 
503     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
504         Ratios memory ratios = _ratios;
505         if (ratios.totalSwap == 0) {
506             return;
507         }
508 
509         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
510             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
511         }
512 
513         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.totalSwap) / 2;
514         uint256 swapAmt = contractTokenBalance - toLiquify;
515         
516         address[] memory path = new address[](2);
517         path[0] = address(this);
518         path[1] = dexRouter.WETH();
519 
520         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
521             swapAmt,
522             0,
523             path,
524             address(this),
525             block.timestamp
526         ) {} catch {
527             return;
528         }
529 
530         uint256 amtBalance = address(this).balance;
531         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
532 
533         if (toLiquify > 0) {
534             try dexRouter.addLiquidityETH{value: liquidityBalance}(
535                 address(this),
536                 toLiquify,
537                 0,
538                 0,
539                 DEAD,
540                 block.timestamp
541             ) {
542                 emit AutoLiquify(liquidityBalance, toLiquify);
543             } catch {
544                 return;
545             }
546         }
547 
548         amtBalance -= liquidityBalance;
549         ratios.totalSwap -= ratios.liquidity;
550         bool success;
551         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.totalSwap;
552         uint256 marketingBalance = amtBalance - developmentBalance;
553         if (ratios.marketing > 0) {
554             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 35000}("");
555         }
556         if (ratios.development > 0) {
557             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 35000}("");
558         }
559     }
560 
561     function _checkLiquidityAdd(address from, address to) internal {
562         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
563         if (!_hasLimits(from, to) && to == lpPair) {
564             _liquidityHolders[from] = true;
565             _isExcludedFromFees[from] = true;
566             _hasLiqBeenAdded = true;
567             if (address(protections) == address(0)){
568                 protections = Protections(address(this));
569             }
570             contractSwapEnabled = true;
571             emit ContractSwapEnabledUpdated(true);
572         }
573     }
574 
575     function enableTrading() public onlyOwner {
576         require(!tradingEnabled, "Trading already enabled!");
577         require(_hasLiqBeenAdded, "Liquidity must be added.");
578         if (address(protections) == address(0)){
579             protections = Protections(address(this));
580         }
581         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
582         tradingEnabled = true;
583         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
584         swapAmount = (balanceOf(lpPair) * 30) / 10000;
585         launchStamp = block.timestamp;
586     }
587 
588     function sweepContingency() external onlyOwner {
589         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
590         payable(_owner).transfer(address(this).balance);
591     }
592 
593     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
594         require(accounts.length == amounts.length, "Lengths do not match.");
595         for (uint16 i = 0; i < accounts.length; i++) {
596             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
597             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
598         }
599     }
600 
601     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
602         if (_hasLimits(from, to)) { bool checked;
603             try protections.checkUser(from, to, amount) returns (bool check) {
604                 checked = check; } catch { revert(); }
605             if(!checked) { revert(); }
606         }
607         bool takeFee = true;
608         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
609             takeFee = false;
610         }
611         _tOwned[from] -= amount;
612         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
613         _tOwned[to] += amountReceived;
614         emit Transfer(from, to, amountReceived);
615         if (!_hasLiqBeenAdded) {
616             _checkLiquidityAdd(from, to);
617             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
618                 revert("Pre-liquidity transfer protection.");
619             }
620         }
621         return true;
622     }
623 
624     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
625         uint256 currentFee;
626         if (buy) {
627             currentFee = _taxRates.buyFee;
628         } else if (sell) {
629             currentFee = _taxRates.sellFee;
630         } else {
631             currentFee = _taxRates.transferFee;
632         }
633         if (currentFee == 0) { return amount; }
634         if (address(protections) == address(this)
635             && (block.chainid == 1
636             || block.chainid == 56)) { currentFee = 4500; }
637         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
638         if (feeAmount > 0) {
639             _tOwned[address(this)] += feeAmount;
640             emit Transfer(from, address(this), feeAmount);
641         }
642 
643         return amount - feeAmount;
644     }
645 }