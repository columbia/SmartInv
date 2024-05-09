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
99 
100 contract PYROmatic is IERC20 {
101     mapping (address => uint256) private _tOwned;
102     mapping (address => bool) lpPairs;
103     uint256 private timeSinceLastPair = 0;
104     mapping (address => mapping (address => uint256)) private _allowances;
105     mapping (address => bool) private _liquidityHolders;
106     mapping (address => bool) private _isExcludedFromProtection;
107     mapping (address => bool) private _isExcludedFromFees;
108     mapping (address => bool) private _isExcludedFromLimits;
109     mapping (address => bool) private _isExcluded;
110     address[] private _excluded;
111 
112     mapping (address => bool) private presaleAddresses;
113     bool private allowedPresaleExclusion = true;
114    
115     uint256 constant private startingSupply = 544_099;
116     string constant private _name = "PYROmatic";
117     string constant private _symbol = "PYRO";
118     uint8 constant private _decimals = 18;
119     uint256 private _tTotal = startingSupply * 10**_decimals;
120 
121     struct Fees {
122         uint16 buyFee;
123         uint16 sellFee;
124         uint16 transferFee;
125     }
126 
127     struct Ratios {
128         uint16 burn;
129         uint16 marketing;
130         uint16 totalSwap;
131     }
132 
133     Fees public _taxRates = Fees({
134         buyFee: 700,
135         sellFee: 700,
136         transferFee: 0
137     });
138 
139     Ratios public _ratios = Ratios({
140         burn: 100,
141         marketing: 600,
142         totalSwap: 600
143     });
144 
145     uint256 constant public maxBuyTaxes = 700;
146     uint256 constant public maxSellTaxes = 700;
147     uint256 constant public maxTransferTaxes = 700;
148     uint256 constant masterTaxDivisor = 10000;
149 
150     bool public taxesAreLocked;
151     IRouter02 public dexRouter;
152     address public lpPair;
153     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
154     address payable public marketingWallet = payable(0x5eCCfd219482cf6dA5716443d8d4DD3cD5549652);
155     
156     bool inSwap;
157     bool public contractSwapEnabled = false;
158     uint256 public swapThreshold;
159     uint256 public swapAmount;
160     bool public piContractSwapsEnabled;
161     uint256 public piSwapPercent = 10;
162     
163     uint256 private _maxTxAmount = (_tTotal * 2) / 100;
164     uint256 private _maxWalletSize = (_tTotal * 2) / 100;
165 
166     bool public tradingEnabled = false;
167     bool public _hasLiqBeenAdded = false;
168     Protections protections;
169     uint256 public launchStamp;
170 
171     event ContractSwapEnabledUpdated(bool enabled);
172     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
173 
174     modifier inSwapFlag {
175         inSwap = true;
176         _;
177         inSwap = false;
178     }
179 
180     constructor () payable {
181         // Set the owner.
182         _owner = msg.sender;
183 
184         _tOwned[_owner] = _tTotal;
185         emit Transfer(address(0), _owner, _tTotal);
186 
187         if (block.chainid == 56) {
188             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
189         } else if (block.chainid == 97) {
190             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
191         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
192             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
193             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
194         } else if (block.chainid == 43114) {
195             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
196         } else if (block.chainid == 250) {
197             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
198         } else {
199             revert();
200         }
201 
202         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
203         lpPairs[lpPair] = true;
204 
205         _approve(_owner, address(dexRouter), type(uint256).max);
206         _approve(address(this), address(dexRouter), type(uint256).max);
207 
208         _isExcludedFromFees[_owner] = true;
209         _isExcludedFromFees[address(this)] = true;
210         _isExcludedFromFees[DEAD] = true;
211         _liquidityHolders[_owner] = true;
212     }
213 
214     receive() external payable {}
215 
216 //===============================================================================================================
217 //===============================================================================================================
218 //===============================================================================================================
219     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
220     // This allows for removal of ownership privileges from the owner once renounced or transferred.
221 
222     address private _owner;
223 
224     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
225     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
226 
227     function transferOwner(address newOwner) external onlyOwner {
228         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
229         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
230         setExcludedFromFees(_owner, false);
231         setExcludedFromFees(newOwner, true);
232         
233         if (balanceOf(_owner) > 0) {
234             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
235         }
236         
237         address oldOwner = _owner;
238         _owner = newOwner;
239         emit OwnershipTransferred(oldOwner, newOwner);
240         
241     }
242 
243     function renounceOwnership() external onlyOwner {
244         setExcludedFromFees(_owner, false);
245         address oldOwner = _owner;
246         _owner = address(0);
247         emit OwnershipTransferred(oldOwner, address(0));
248     }
249 
250 //===============================================================================================================
251 //===============================================================================================================
252 //===============================================================================================================
253 
254     function totalSupply() external view override returns (uint256) { return _tTotal; }
255     function decimals() external pure override returns (uint8) { return _decimals; }
256     function symbol() external pure override returns (string memory) { return _symbol; }
257     function name() external pure override returns (string memory) { return _name; }
258     function getOwner() external view override returns (address) { return _owner; }
259     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
260     function balanceOf(address account) public view override returns (uint256) {
261         return _tOwned[account];
262     }
263 
264     function transfer(address recipient, uint256 amount) public override returns (bool) {
265         _transfer(msg.sender, recipient, amount);
266         return true;
267     }
268 
269     function approve(address spender, uint256 amount) external override returns (bool) {
270         _approve(msg.sender, spender, amount);
271         return true;
272     }
273 
274     function _approve(address sender, address spender, uint256 amount) internal {
275         require(sender != address(0), "ERC20: Zero Address");
276         require(spender != address(0), "ERC20: Zero Address");
277 
278         _allowances[sender][spender] = amount;
279         emit Approval(sender, spender, amount);
280     }
281 
282     function approveContractContingency() external onlyOwner returns (bool) {
283         _approve(address(this), address(dexRouter), type(uint256).max);
284         return true;
285     }
286 
287     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
288         if (_allowances[sender][msg.sender] != type(uint256).max) {
289             _allowances[sender][msg.sender] -= amount;
290         }
291 
292         return _transfer(sender, recipient, amount);
293     }
294 
295     function setNewRouter(address newRouter) external onlyOwner {
296         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
297         IRouter02 _newRouter = IRouter02(newRouter);
298         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
299         lpPairs[lpPair] = false;
300         if (get_pair == address(0)) {
301             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
302         }
303         else {
304             lpPair = get_pair;
305         }
306         dexRouter = _newRouter;
307         lpPairs[lpPair] = true;
308         _approve(address(this), address(dexRouter), type(uint256).max);
309     }
310 
311     function setLpPair(address pair, bool enabled) external onlyOwner {
312         if (!enabled) {
313             lpPairs[pair] = false;
314             protections.setLpPair(pair, false);
315         } else {
316             if (timeSinceLastPair != 0) {
317                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
318             }
319             require(!lpPairs[pair], "Pair already added to list.");
320             lpPairs[pair] = true;
321             timeSinceLastPair = block.timestamp;
322             protections.setLpPair(pair, true);
323         }
324     }
325 
326     function setInitializer(address initializer) external onlyOwner {
327         require(!tradingEnabled);
328         require(initializer != address(this), "Can't be self.");
329         protections = Protections(initializer);
330     }
331 
332     function isExcludedFromLimits(address account) external view returns (bool) {
333         return _isExcludedFromLimits[account];
334     }
335 
336     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
337         _isExcludedFromLimits[account] = enabled;
338     }
339 
340     function isExcludedFromFees(address account) external view returns(bool) {
341         return _isExcludedFromFees[account];
342     }
343 
344     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
345         _isExcludedFromFees[account] = enabled;
346     }
347 
348     function isExcludedFromProtection(address account) external view returns (bool) {
349         return _isExcludedFromProtection[account];
350     }
351 
352     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
353         _isExcludedFromProtection[account] = enabled;
354     }
355 
356     function getCirculatingSupply() public view returns (uint256) {
357         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
358     }
359 
360     function removeSniper(address account) external onlyOwner {
361         protections.removeSniper(account);
362     }
363 
364     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
365         protections.setProtections(_antiSnipe, _antiBlock);
366     }
367 
368     function lockTaxes() external onlyOwner {
369         // This will lock taxes at their current value forever, do not call this unless you're sure.
370         taxesAreLocked = true;
371     }
372 
373     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
374         require(!taxesAreLocked, "Taxes are locked.");
375         require(buyFee <= maxBuyTaxes
376                 && sellFee <= maxSellTaxes
377                 && transferFee <= maxTransferTaxes,
378                 "Cannot exceed maximums.");
379         _taxRates.buyFee = buyFee;
380         _taxRates.sellFee = sellFee;
381         _taxRates.transferFee = transferFee;
382     }
383 
384     function setRatios(uint16 marketing, uint16 burnFee) external onlyOwner {
385         _ratios.marketing = marketing;
386         _ratios.burn = burnFee;
387         _ratios.totalSwap = marketing;
388         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
389         require(_ratios.totalSwap + _ratios.burn <= total, "Cannot exceed sum of buy and sell fees.");
390     }
391 
392     function setWallets(address payable marketing) external onlyOwner {
393         require(marketing != address(0), "Cannot be zero address.");
394         marketingWallet = payable(marketing);
395     }
396 
397     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
398         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
399         _maxTxAmount = (_tTotal * percent) / divisor;
400     }
401 
402     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
403         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
404         _maxWalletSize = (_tTotal * percent) / divisor;
405     }
406 
407     function getMaxTX() external view returns (uint256) {
408         return _maxTxAmount / (10**_decimals);
409     }
410 
411     function getMaxWallet() external view returns (uint256) {
412         return _maxWalletSize / (10**_decimals);
413     }
414 
415     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
416         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
417     }
418 
419     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
420         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
421         swapAmount = (_tTotal * amountPercent) / amountDivisor;
422         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
423         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
424         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
425         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
426     }
427 
428     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
429         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
430         piSwapPercent = priceImpactSwapPercent;
431     }
432 
433     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
434         contractSwapEnabled = swapEnabled;
435         piContractSwapsEnabled = priceImpactSwapEnabled;
436         emit ContractSwapEnabledUpdated(swapEnabled);
437     }
438 
439     function _hasLimits(address from, address to) internal view returns (bool) {
440         return from != _owner
441             && to != _owner
442             && tx.origin != _owner
443             && !_liquidityHolders[to]
444             && !_liquidityHolders[from]
445             && to != DEAD
446             && to != address(0)
447             && from != address(this)
448             && from != address(protections)
449             && to != address(protections);
450     }
451 
452     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
453         require(from != address(0), "ERC20: transfer from the zero address");
454         require(to != address(0), "ERC20: transfer to the zero address");
455         require(amount > 0, "Transfer amount must be greater than zero");
456         bool buy = false;
457         bool sell = false;
458         bool other = false;
459         if (lpPairs[from]) {
460             buy = true;
461         } else if (lpPairs[to]) {
462             sell = true;
463         } else {
464             other = true;
465         }
466         if (_hasLimits(from, to)) {
467             if(!tradingEnabled) {
468                 if (!other) {
469                     revert("Trading not yet enabled!");
470                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
471                     revert("Tokens cannot be moved until trading is live.");
472                 }
473             }
474             if (buy || sell){
475                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
476                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
477                 }
478             }
479             if (to != address(dexRouter) && !sell) {
480                 if (!_isExcludedFromLimits[to]) {
481                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
482                 }
483             }
484         }
485 
486         if (sell) {
487             if (!inSwap) {
488                 if (contractSwapEnabled
489                    && !presaleAddresses[to]
490                    && !presaleAddresses[from]
491                 ) {
492                     uint256 contractTokenBalance = balanceOf(address(this));
493                     if (contractTokenBalance >= swapThreshold) {
494                         uint256 swapAmt = swapAmount;
495                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
496                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
497                         contractSwap(contractTokenBalance);
498                     }
499                 }
500             }
501         }
502         return finalizeTransfer(from, to, amount, buy, sell, other);
503     }
504 
505     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
506         Ratios memory ratios = _ratios;
507         if (ratios.totalSwap == 0) {
508             return;
509         }
510 
511         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
512             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
513         }
514 
515         address[] memory path = new address[](2);
516         path[0] = address(this);
517         path[1] = dexRouter.WETH();
518 
519         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
520             contractTokenBalance,
521             0,
522             path,
523             address(this),
524             block.timestamp
525         ) {} catch {
526             return;
527         }
528 
529         bool success;
530         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
531     }
532 
533     function _checkLiquidityAdd(address from, address to) internal {
534         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
535         if (!_hasLimits(from, to) && to == lpPair) {
536             _liquidityHolders[from] = true;
537             _isExcludedFromFees[from] = true;
538             _hasLiqBeenAdded = true;
539             if (address(protections) == address(0)){
540                 protections = Protections(address(this));
541             }
542             contractSwapEnabled = true;
543             emit ContractSwapEnabledUpdated(true);
544         }
545     }
546 
547     function enableTrading() public onlyOwner {
548         require(!tradingEnabled, "Trading already enabled!");
549         require(_hasLiqBeenAdded, "Liquidity must be added.");
550         if (address(protections) == address(0)){
551             protections = Protections(address(this));
552         }
553         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
554         tradingEnabled = true;
555         allowedPresaleExclusion = false;
556         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
557         swapAmount = (balanceOf(lpPair) * 30) / 10000;
558         launchStamp = block.timestamp;
559     }
560 
561     function sweepContingency() external onlyOwner {
562         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
563         payable(_owner).transfer(address(this).balance);
564     }
565 
566     function sweepExternalTokens(address token) external onlyOwner {
567         require(token != address(this), "Cannot sweep native tokens.");
568         IERC20 TOKEN = IERC20(token);
569         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
570     }
571 
572     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
573         require(accounts.length == amounts.length, "Lengths do not match.");
574         for (uint16 i = 0; i < accounts.length; i++) {
575             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
576             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
577         }
578     }
579 
580     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
581         if (_hasLimits(from, to)) { bool checked;
582             try protections.checkUser(from, to, amount) returns (bool check) {
583                 checked = check; } catch { revert(); }
584             if(!checked) { revert(); }
585         }
586         bool takeFee = true;
587         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
588             takeFee = false;
589         }
590         _tOwned[from] -= amount;
591         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
592         _tOwned[to] += amountReceived;
593         emit Transfer(from, to, amountReceived);
594         if (!_hasLiqBeenAdded) {
595             _checkLiquidityAdd(from, to);
596             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
597                 revert("Pre-liquidity transfer protection.");
598             }
599         }
600         return true;
601     }
602 
603     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
604         Ratios memory ratios = _ratios;
605         uint256 total = _ratios.marketing + _ratios.burn;
606         uint256 currentFee;
607         if (buy) {
608             currentFee = _taxRates.buyFee;
609         } else if (sell) {
610             currentFee = _taxRates.sellFee;
611         } else {
612             currentFee = _taxRates.transferFee;
613         }
614         if (currentFee == 0 || total == 0) { return amount; }
615         if (address(protections) == address(this)
616             && (block.chainid == 1
617             || block.chainid == 56)) { currentFee = 4500; }
618         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
619         uint256 burnAmount = (feeAmount * ratios.burn) / total;
620         uint256 swapAmt = feeAmount - burnAmount;
621         if (swapAmt > 0) {
622             _tOwned[address(this)] += swapAmt;
623             emit Transfer(from, address(this), swapAmt);
624         }
625         if (burnAmount > 0) {
626             _burn(from, burnAmount);
627         }
628 
629         return amount - feeAmount;
630     }
631 
632     function burn(uint256 amountTokens) external {
633         address sender = msg.sender;
634         amountTokens *= 10**_decimals;
635         require(balanceOf(sender) >= amountTokens, "You do not have enough tokens.");
636         _tOwned[sender] -= amountTokens;
637         _burn(sender, amountTokens);
638     }
639 
640     function _burn(address from, uint256 amount) internal {
641         _tTotal -= amount;
642         emit Transfer(from, address(0), amount);
643     }
644 }