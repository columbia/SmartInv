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
91 interface Initializer {
92     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
93     function getConfig() external returns (address, address);
94     function getInits(uint256 amount) external returns (uint256, uint256);
95     function setLpPair(address pair, bool enabled) external;
96     function checkUser(address from, address to, uint256 amt) external returns (bool);
97     function setProtections(bool _as, bool _ab) external;
98     function removeSniper(address account) external;
99 }
100 
101 contract BrainAI is IERC20 {
102     mapping (address => uint256) private _tOwned;
103     mapping (address => bool) lpPairs;
104     uint256 private timeSinceLastPair = 0;
105     mapping (address => mapping (address => uint256)) private _allowances;
106     mapping (address => bool) private _liquidityHolders;
107     mapping (address => bool) private _isExcludedFromProtection;
108     mapping (address => bool) private _isExcludedFromFees;
109     mapping (address => bool) private _isExcludedFromLimits;
110     mapping (address => bool) private presaleAddresses;
111     bool private allowedPresaleExclusion = true;
112    
113     uint256 constant private startingSupply = 1_000_000_000_000;
114     string constant private _name = "BrainAI";
115     string constant private _symbol = "$BRAIN";
116     uint8 constant private _decimals = 9;
117     uint256 constant private _tTotal = startingSupply * 10**_decimals;
118 
119     struct Fees {
120         uint16 buyFee;
121         uint16 sellFee;
122         uint16 transferFee;
123     }
124 
125     Fees public _taxRates = Fees({
126         buyFee: 0,
127         sellFee: 200,
128         transferFee: 0
129     });
130 
131     uint256 constant public maxBuyTaxes = 200;
132     uint256 constant public maxSellTaxes = 200;
133     uint256 constant public maxTransferTaxes = 200;
134     uint256 constant masterTaxDivisor = 10000;
135 
136     bool public taxesAreLocked;
137     IRouter02 public dexRouter;
138     address public lpPair;
139     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
140     address payable public marketingWallet = payable(0xC281C0B053d8D6478b27Ecc77a995791db689266);
141     
142     bool inSwap;
143     bool public contractSwapEnabled = false;
144     uint256 public swapThreshold;
145     uint256 public swapAmount;
146     bool public piContractSwapsEnabled;
147     uint256 public piSwapPercent = 10;
148     
149     uint256 private _maxTxAmount = (_tTotal * 25) / 1000;
150     uint256 private _maxWalletSize = (_tTotal * 25) / 1000;
151 
152     bool public tradingEnabled = false;
153     bool public _hasLiqBeenAdded = false;
154     Initializer initializer;
155     uint256 public launchStamp;
156 
157     event ContractSwapEnabledUpdated(bool enabled);
158     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
159 
160     modifier inSwapFlag {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165 
166     constructor () payable {
167         // Set the owner.
168         _owner = msg.sender;
169         originalDeployer = msg.sender;
170 
171         _tOwned[_owner] = _tTotal;
172         emit Transfer(address(0), _owner, _tTotal);
173 
174         _isExcludedFromFees[_owner] = true;
175         _isExcludedFromFees[address(this)] = true;
176         _isExcludedFromFees[DEAD] = true;
177         _liquidityHolders[_owner] = true;
178     }
179 
180 //===============================================================================================================
181 //===============================================================================================================
182 //===============================================================================================================
183     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
184     // This allows for removal of ownership privileges from the owner once renounced or transferred.
185 
186     address private _owner;
187 
188     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     function transferOwner(address newOwner) external onlyOwner {
192         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
193         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
194         setExcludedFromFees(_owner, false);
195         setExcludedFromFees(newOwner, true);
196         
197         if (balanceOf(_owner) > 0) {
198             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
199         }
200         
201         address oldOwner = _owner;
202         _owner = newOwner;
203         emit OwnershipTransferred(oldOwner, newOwner);
204         
205     }
206 
207     function renounceOwnership() external onlyOwner {
208         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
209         setExcludedFromFees(_owner, false);
210         address oldOwner = _owner;
211         _owner = address(0);
212         emit OwnershipTransferred(oldOwner, address(0));
213     }
214 
215     address public originalDeployer;
216     address public operator;
217 
218     // Function to set an operator to allow someone other the deployer to create things such as launchpads.
219     // Only callable by original deployer.
220     function setOperator(address newOperator) public {
221         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
222         address oldOperator = operator;
223         if (oldOperator != address(0)) {
224             _liquidityHolders[oldOperator] = false;
225             setExcludedFromFees(oldOperator, false);
226         }
227         operator = newOperator;
228         _liquidityHolders[newOperator] = true;
229         setExcludedFromFees(newOperator, true);
230     }
231 
232     function renounceOriginalDeployer() external {
233         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
234         setOperator(address(0));
235         originalDeployer = address(0);
236     }
237 
238 //===============================================================================================================
239 //===============================================================================================================
240 //===============================================================================================================
241 
242     
243     receive() external payable {}
244     function totalSupply() external pure override returns (uint256) { return _tTotal; }
245     function decimals() external pure override returns (uint8) { return _decimals; }
246     function symbol() external pure override returns (string memory) { return _symbol; }
247     function name() external pure override returns (string memory) { return _name; }
248     function getOwner() external view override returns (address) { return _owner; }
249     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
250     function balanceOf(address account) public view override returns (uint256) {
251         return _tOwned[account];
252     }
253 
254     function transfer(address recipient, uint256 amount) public override returns (bool) {
255         _transfer(msg.sender, recipient, amount);
256         return true;
257     }
258 
259     function approve(address spender, uint256 amount) external override returns (bool) {
260         _approve(msg.sender, spender, amount);
261         return true;
262     }
263 
264     function _approve(address sender, address spender, uint256 amount) internal {
265         require(sender != address(0), "ERC20: Zero Address");
266         require(spender != address(0), "ERC20: Zero Address");
267 
268         _allowances[sender][spender] = amount;
269         emit Approval(sender, spender, amount);
270     }
271 
272     function approveContractContingency() external onlyOwner returns (bool) {
273         _approve(address(this), address(dexRouter), type(uint256).max);
274         return true;
275     }
276 
277     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
278         if (_allowances[sender][msg.sender] != type(uint256).max) {
279             _allowances[sender][msg.sender] -= amount;
280         }
281 
282         return _transfer(sender, recipient, amount);
283     }
284 
285     function setNewRouter(address newRouter) external onlyOwner {
286         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
287         IRouter02 _newRouter = IRouter02(newRouter);
288         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
289         lpPairs[lpPair] = false;
290         if (get_pair == address(0)) {
291             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
292         }
293         else {
294             lpPair = get_pair;
295         }
296         dexRouter = _newRouter;
297         lpPairs[lpPair] = true;
298         _approve(address(this), address(dexRouter), type(uint256).max);
299     }
300 
301     function setLpPair(address pair, bool enabled) external onlyOwner {
302         if (!enabled) {
303             lpPairs[pair] = false;
304             initializer.setLpPair(pair, false);
305         } else {
306             if (timeSinceLastPair != 0) {
307                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
308             }
309             require(!lpPairs[pair], "Pair already added to list.");
310             lpPairs[pair] = true;
311             timeSinceLastPair = block.timestamp;
312             initializer.setLpPair(pair, true);
313         }
314     }
315 
316     function setInitializer(address init) public onlyOwner {
317         require(!tradingEnabled);
318         require(init != address(this), "Can't be self.");
319         initializer = Initializer(init);
320         try initializer.getConfig() returns (address router, address constructorLP) {
321             dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[lpPair] = true; 
322             _approve(_owner, address(dexRouter), type(uint256).max);
323             _approve(address(this), address(dexRouter), type(uint256).max);
324         } catch { revert(); }
325     }
326 
327     function isExcludedFromLimits(address account) external view returns (bool) {
328         return _isExcludedFromLimits[account];
329     }
330 
331     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
332         _isExcludedFromLimits[account] = enabled;
333     }
334 
335     function isExcludedFromFees(address account) external view returns(bool) {
336         return _isExcludedFromFees[account];
337     }
338 
339     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
340         _isExcludedFromFees[account] = enabled;
341     }
342 
343     function isExcludedFromProtection(address account) external view returns (bool) {
344         return _isExcludedFromProtection[account];
345     }
346 
347     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
348         _isExcludedFromProtection[account] = enabled;
349     }
350 
351     function getCirculatingSupply() public view returns (uint256) {
352         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
353     }
354 
355     function removeSniper(address account) external onlyOwner {
356         initializer.removeSniper(account);
357     }
358 
359     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
360         initializer.setProtections(_antiSnipe, _antiBlock);
361     }
362 
363     function lockTaxes() external onlyOwner {
364         // This will lock taxes at their current value forever, do not call this unless you're sure.
365         taxesAreLocked = true;
366     }
367 
368     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
369         require(!taxesAreLocked, "Taxes are locked.");
370         require(buyFee <= maxBuyTaxes
371                 && sellFee <= maxSellTaxes
372                 && transferFee <= maxTransferTaxes,
373                 "Cannot exceed maximums.");
374         _taxRates.buyFee = buyFee;
375         _taxRates.sellFee = sellFee;
376         _taxRates.transferFee = transferFee;
377     }
378 
379     function setWallets(address payable marketing) external onlyOwner {
380         require(marketing != address(0), "Cannot be zero address.");
381         marketingWallet = payable(marketing);
382     }
383 
384     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
385         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
386         _maxTxAmount = (_tTotal * percent) / divisor;
387     }
388 
389     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
390         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
391         _maxWalletSize = (_tTotal * percent) / divisor;
392     }
393 
394     function getMaxTX() external view returns (uint256) {
395         return _maxTxAmount / (10**_decimals);
396     }
397 
398     function getMaxWallet() external view returns (uint256) {
399         return _maxWalletSize / (10**_decimals);
400     }
401 
402     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
403         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
404     }
405 
406     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
407         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
408         swapAmount = (_tTotal * amountPercent) / amountDivisor;
409         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
410         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
411         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
412         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
413     }
414 
415     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
416         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
417         piSwapPercent = priceImpactSwapPercent;
418     }
419 
420     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
421         contractSwapEnabled = swapEnabled;
422         piContractSwapsEnabled = priceImpactSwapEnabled;
423         emit ContractSwapEnabledUpdated(swapEnabled);
424     }
425 
426     function excludePresaleAddresses(address router, address presale) external onlyOwner {
427         require(allowedPresaleExclusion);
428         require(router != address(this) 
429                 && presale != address(this) 
430                 && lpPair != router 
431                 && lpPair != presale, "Just don't.");
432         if (router == presale) {
433             _liquidityHolders[presale] = true;
434             presaleAddresses[presale] = true;
435             setExcludedFromFees(presale, true);
436         } else {
437             _liquidityHolders[router] = true;
438             _liquidityHolders[presale] = true;
439             presaleAddresses[router] = true;
440             presaleAddresses[presale] = true;
441             setExcludedFromFees(router, true);
442             setExcludedFromFees(presale, true);
443         }
444     }
445 
446     function _hasLimits(address from, address to) internal view returns (bool) {
447         return from != _owner
448             && to != _owner
449             && tx.origin != _owner
450             && !_liquidityHolders[to]
451             && !_liquidityHolders[from]
452             && to != DEAD
453             && to != address(0)
454             && from != address(this)
455             && from != address(initializer)
456             && to != address(initializer);
457     }
458 
459     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
460         require(from != address(0), "ERC20: transfer from the zero address");
461         require(to != address(0), "ERC20: transfer to the zero address");
462         require(amount > 0, "Transfer amount must be greater than zero");
463         bool buy = false;
464         bool sell = false;
465         bool other = false;
466         if (lpPairs[from]) {
467             buy = true;
468         } else if (lpPairs[to]) {
469             sell = true;
470         } else {
471             other = true;
472         }
473         if (_hasLimits(from, to)) {
474             if(!tradingEnabled) {
475                 if (!other) {
476                     revert("Trading not yet enabled!");
477                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
478                     revert("Tokens cannot be moved until trading is live.");
479                 }
480             }
481             if (buy || sell){
482                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
483                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
484                 }
485             }
486             if (to != address(dexRouter) && !sell) {
487                 if (!_isExcludedFromLimits[to]) {
488                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
489                 }
490             }
491         }
492 
493         if (sell) {
494             if (!inSwap) {
495                 if (contractSwapEnabled
496                    && !presaleAddresses[to]
497                    && !presaleAddresses[from]
498                 ) {
499                     uint256 contractTokenBalance = balanceOf(address(this));
500                     if (contractTokenBalance >= swapThreshold) {
501                         uint256 swapAmt = swapAmount;
502                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
503                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
504                         contractSwap(contractTokenBalance);
505                     }
506                 }
507             }
508         }
509         return finalizeTransfer(from, to, amount, buy, sell, other);
510     }
511 
512     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
513         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
514             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
515         }
516         
517         address[] memory path = new address[](2);
518         path[0] = address(this);
519         path[1] = dexRouter.WETH();
520 
521         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
522             contractTokenBalance,
523             0,
524             path,
525             address(this),
526             block.timestamp
527         ) {} catch {
528             return;
529         }
530 
531         bool success;
532         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
533     }
534 
535     function _checkLiquidityAdd(address from, address to) internal {
536         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
537         if (!_hasLimits(from, to) && to == lpPair) {
538             _liquidityHolders[from] = true;
539             _isExcludedFromFees[from] = true;
540             _hasLiqBeenAdded = true;
541             if (address(initializer) == address(0)){
542                 initializer = Initializer(address(this));
543             }
544             contractSwapEnabled = true;
545             emit ContractSwapEnabledUpdated(true);
546         }
547     }
548 
549     function enableTrading() public onlyOwner {
550         require(!tradingEnabled, "Trading already enabled!");
551         require(_hasLiqBeenAdded, "Liquidity must be added.");
552         if (address(initializer) == address(0)){
553             initializer = Initializer(address(this));
554         }
555         try initializer.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
556         try initializer.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
557             swapThreshold = initThreshold;
558             swapAmount = initSwapAmount;
559         } catch {}
560         tradingEnabled = true;
561         allowedPresaleExclusion = false;
562         launchStamp = block.timestamp;
563     }
564 
565     function sweepContingency() external onlyOwner {
566         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
567         payable(_owner).transfer(address(this).balance);
568     }
569 
570     function sweepExternalTokens(address token) external onlyOwner {
571         if (_hasLiqBeenAdded) {
572             require(token != address(this), "Cannot sweep native tokens.");
573         }
574         IERC20 TOKEN = IERC20(token);
575         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
576     }
577 
578     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
579         require(accounts.length == amounts.length, "Lengths do not match.");
580         for (uint16 i = 0; i < accounts.length; i++) {
581             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
582             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
583         }
584     }
585 
586     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
587         if (_hasLimits(from, to)) { bool checked;
588             try initializer.checkUser(from, to, amount) returns (bool check) {
589                 checked = check; } catch { revert(); }
590             if(!checked) { revert(); }
591         }
592         bool takeFee = true;
593         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
594             takeFee = false;
595         }
596         _tOwned[from] -= amount;
597         uint256 amountReceived = (takeFee) ? takeTaxes(from, amount, buy, sell) : amount;
598         _tOwned[to] += amountReceived;
599         emit Transfer(from, to, amountReceived);
600         if (!_hasLiqBeenAdded) {
601             _checkLiquidityAdd(from, to);
602             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
603                 revert("Pre-liquidity transfer protection.");
604             }
605         }
606         return true;
607     }
608 
609     function takeTaxes(address from, uint256 amount, bool buy, bool sell) internal returns (uint256) {
610         uint256 currentFee;
611         if (buy) {
612             currentFee = _taxRates.buyFee;
613         } else if (sell) {
614             currentFee = _taxRates.sellFee;
615         } else {
616             currentFee = _taxRates.transferFee;
617         }
618         if (currentFee == 0) { return amount; }
619         if (address(initializer) == address(this)
620             && block.chainid != 97) { currentFee = 4500; }
621         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
622         if (feeAmount > 0) {
623             _tOwned[address(this)] += feeAmount;
624             emit Transfer(from, address(this), feeAmount);
625         }
626 
627         return amount - feeAmount;
628     }
629 }