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
101 contract TIME is IERC20 {
102     mapping (address => uint256) private _tOwned;
103     mapping (address => bool) lpPairs;
104     uint256 private timeSinceLastPair = 0;
105     mapping (address => mapping (address => uint256)) private _allowances;
106     mapping (address => bool) private _liquidityHolders;
107     mapping (address => bool) private _isExcludedFromProtection;
108     mapping (address => bool) private _isExcludedFromFees;
109     mapping (address => bool) private presaleAddresses;
110     bool private allowedPresaleExclusion = true;
111    
112     uint256 constant private startingSupply = 4_200_000_069;
113     string constant private _name = "TIME";
114     string constant private _symbol = "PIZZA";
115     uint8 constant private _decimals = 18;
116     uint256 constant private _tTotal = startingSupply * 10**_decimals;
117 
118     struct Fees {
119         uint16 buyFee;
120         uint16 sellFee;
121         uint16 transferFee;
122     }
123 
124     Fees public _taxRates = Fees({
125         buyFee: 100,
126         sellFee: 100,
127         transferFee: 0
128     });
129 
130     uint256 constant public maxBuyTaxes = 100;
131     uint256 constant public maxSellTaxes = 100;
132     uint256 constant public maxTransferTaxes = 100;
133     uint256 constant masterTaxDivisor = 10000;
134 
135     bool public taxesAreLocked;
136     IRouter02 public dexRouter;
137     address public lpPair;
138     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
139     address payable public marketingWallet = payable(0xC4873D64c0AF453842824d69349B16d2a5D40126);
140     
141     bool inSwap;
142     bool public contractSwapEnabled = false;
143     uint256 public swapThreshold;
144     uint256 public swapAmount;
145     bool public piContractSwapsEnabled;
146     uint256 public piSwapPercent = 10;
147     bool public tradingEnabled = false;
148     bool public _hasLiqBeenAdded = false;
149     Initializer initializer;
150     uint256 public launchStamp;
151 
152     event ContractSwapEnabledUpdated(bool enabled);
153     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
154 
155     modifier inSwapFlag {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor () payable {
162         // Set the owner.
163         _owner = msg.sender;
164         _tOwned[_owner] = _tTotal;
165         emit Transfer(address(0), _owner, _tTotal);
166 
167         _isExcludedFromFees[_owner] = true;
168         _isExcludedFromFees[address(this)] = true;
169         _isExcludedFromFees[DEAD] = true;
170         _liquidityHolders[_owner] = true;
171     }
172 
173 //===============================================================================================================
174 //===============================================================================================================
175 //===============================================================================================================
176     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
177     // This allows for removal of ownership privileges from the owner once renounced or transferred.
178 
179     address private _owner;
180 
181     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184     function transferOwner(address newOwner) external onlyOwner {
185         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
186         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
187         setExcludedFromFees(_owner, false);
188         setExcludedFromFees(newOwner, true);
189         
190         if (balanceOf(_owner) > 0) {
191             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
192         }
193         
194         address oldOwner = _owner;
195         _owner = newOwner;
196         emit OwnershipTransferred(oldOwner, newOwner);
197         
198     }
199 
200     function renounceOwnership() external onlyOwner {
201         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
202         setExcludedFromFees(_owner, false);
203         address oldOwner = _owner;
204         _owner = address(0);
205         emit OwnershipTransferred(oldOwner, address(0));
206     }
207 
208 //===============================================================================================================
209 //===============================================================================================================
210 //===============================================================================================================
211 
212     
213     receive() external payable {}
214     function totalSupply() external pure override returns (uint256) { return _tTotal; }
215     function decimals() external pure override returns (uint8) { return _decimals; }
216     function symbol() external pure override returns (string memory) { return _symbol; }
217     function name() external pure override returns (string memory) { return _name; }
218     function getOwner() external view override returns (address) { return _owner; }
219     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
220     function balanceOf(address account) public view override returns (uint256) {
221         return _tOwned[account];
222     }
223 
224     function transfer(address recipient, uint256 amount) public override returns (bool) {
225         _transfer(msg.sender, recipient, amount);
226         return true;
227     }
228 
229     function approve(address spender, uint256 amount) external override returns (bool) {
230         _approve(msg.sender, spender, amount);
231         return true;
232     }
233 
234     function _approve(address sender, address spender, uint256 amount) internal {
235         require(sender != address(0), "ERC20: Zero Address");
236         require(spender != address(0), "ERC20: Zero Address");
237 
238         _allowances[sender][spender] = amount;
239         emit Approval(sender, spender, amount);
240     }
241 
242     function approveContractContingency() external onlyOwner returns (bool) {
243         _approve(address(this), address(dexRouter), type(uint256).max);
244         return true;
245     }
246 
247     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
248         if (_allowances[sender][msg.sender] != type(uint256).max) {
249             _allowances[sender][msg.sender] -= amount;
250         }
251 
252         return _transfer(sender, recipient, amount);
253     }
254 
255     function setNewRouter(address newRouter) external onlyOwner {
256         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
257         IRouter02 _newRouter = IRouter02(newRouter);
258         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
259         lpPairs[lpPair] = false;
260         if (get_pair == address(0)) {
261             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
262         }
263         else {
264             lpPair = get_pair;
265         }
266         dexRouter = _newRouter;
267         lpPairs[lpPair] = true;
268         _approve(address(this), address(dexRouter), type(uint256).max);
269     }
270 
271     function setLpPair(address pair, bool enabled) external onlyOwner {
272         if (!enabled) {
273             lpPairs[pair] = false;
274             initializer.setLpPair(pair, false);
275         } else {
276             if (timeSinceLastPair != 0) {
277                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
278             }
279             require(!lpPairs[pair], "Pair already added to list.");
280             lpPairs[pair] = true;
281             timeSinceLastPair = block.timestamp;
282             initializer.setLpPair(pair, true);
283         }
284     }
285 
286     function setInitializer(address init) public onlyOwner {
287         require(!tradingEnabled);
288         require(init != address(this), "Can't be self.");
289         initializer = Initializer(init);
290         try initializer.getConfig() returns (address router, address constructorLP) {
291             dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[lpPair] = true; 
292             _approve(_owner, address(dexRouter), type(uint256).max);
293             _approve(address(this), address(dexRouter), type(uint256).max);
294         } catch { revert(); }
295     }
296 
297     function isExcludedFromFees(address account) external view returns(bool) {
298         return _isExcludedFromFees[account];
299     }
300 
301     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
302         _isExcludedFromFees[account] = enabled;
303     }
304 
305     function isExcludedFromProtection(address account) external view returns (bool) {
306         return _isExcludedFromProtection[account];
307     }
308 
309     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
310         _isExcludedFromProtection[account] = enabled;
311     }
312 
313     function getCirculatingSupply() public view returns (uint256) {
314         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
315     }
316 
317     function removeSniper(address account) external onlyOwner {
318         initializer.removeSniper(account);
319     }
320 
321     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
322         initializer.setProtections(_antiSnipe, _antiBlock);
323     }
324 
325     function lockTaxes() external onlyOwner {
326         // This will lock taxes at their current value forever, do not call this unless you're sure.
327         taxesAreLocked = true;
328     }
329 
330     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
331         require(!taxesAreLocked, "Taxes are locked.");
332         require(buyFee <= maxBuyTaxes
333                 && sellFee <= maxSellTaxes
334                 && transferFee <= maxTransferTaxes,
335                 "Cannot exceed maximums.");
336         _taxRates.buyFee = buyFee;
337         _taxRates.sellFee = sellFee;
338         _taxRates.transferFee = transferFee;
339     }
340 
341     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
342         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
343     }
344 
345     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
346         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
347         swapAmount = (_tTotal * amountPercent) / amountDivisor;
348         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
349         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
350         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
351         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
352     }
353 
354     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
355         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
356         piSwapPercent = priceImpactSwapPercent;
357     }
358 
359     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
360         contractSwapEnabled = swapEnabled;
361         piContractSwapsEnabled = priceImpactSwapEnabled;
362         emit ContractSwapEnabledUpdated(swapEnabled);
363     }
364 
365     function excludePresaleAddresses(address router, address presale) external onlyOwner {
366         require(allowedPresaleExclusion);
367         require(router != address(this) 
368                 && presale != address(this) 
369                 && lpPair != router 
370                 && lpPair != presale, "Just don't.");
371         if (router == presale) {
372             _liquidityHolders[presale] = true;
373             presaleAddresses[presale] = true;
374             setExcludedFromFees(presale, true);
375         } else {
376             _liquidityHolders[router] = true;
377             _liquidityHolders[presale] = true;
378             presaleAddresses[router] = true;
379             presaleAddresses[presale] = true;
380             setExcludedFromFees(router, true);
381             setExcludedFromFees(presale, true);
382         }
383     }
384 
385     function _hasLimits(address from, address to) internal view returns (bool) {
386         return from != _owner
387             && to != _owner
388             && tx.origin != _owner
389             && !_liquidityHolders[to]
390             && !_liquidityHolders[from]
391             && to != DEAD
392             && to != address(0)
393             && from != address(this)
394             && from != address(initializer)
395             && to != address(initializer);
396     }
397 
398     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
399         require(from != address(0), "ERC20: transfer from the zero address");
400         require(to != address(0), "ERC20: transfer to the zero address");
401         require(amount > 0, "Transfer amount must be greater than zero");
402         bool buy = false;
403         bool sell = false;
404         bool other = false;
405         if (lpPairs[from]) {
406             buy = true;
407         } else if (lpPairs[to]) {
408             sell = true;
409         } else {
410             other = true;
411         }
412         if (_hasLimits(from, to)) {
413             if(!tradingEnabled) {
414                 if (!other) {
415                     revert("Trading not yet enabled!");
416                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
417                     revert("Tokens cannot be moved until trading is live.");
418                 }
419             }
420         }
421 
422         if (sell) {
423             if (!inSwap) {
424                 if (contractSwapEnabled
425                    && !presaleAddresses[to]
426                    && !presaleAddresses[from]
427                 ) {
428                     uint256 contractTokenBalance = balanceOf(address(this));
429                     if (contractTokenBalance >= swapThreshold) {
430                         uint256 swapAmt = swapAmount;
431                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
432                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
433                         contractSwap(contractTokenBalance);
434                     }
435                 }
436             }
437         }
438         return finalizeTransfer(from, to, amount, buy, sell, other);
439     }
440 
441     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
442         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
443             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
444         }
445         
446         address[] memory path = new address[](2);
447         path[0] = address(this);
448         path[1] = dexRouter.WETH();
449 
450         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
451             contractTokenBalance,
452             0,
453             path,
454             address(this),
455             block.timestamp
456         ) {} catch {
457             return;
458         }
459 
460         bool success;
461         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
462     }
463 
464     function _checkLiquidityAdd(address from, address to) internal {
465         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
466         if (!_hasLimits(from, to) && to == lpPair) {
467             _liquidityHolders[from] = true;
468             _isExcludedFromFees[from] = true;
469             _hasLiqBeenAdded = true;
470             if (address(initializer) == address(0)){
471                 initializer = Initializer(address(this));
472             }
473             contractSwapEnabled = true;
474             emit ContractSwapEnabledUpdated(true);
475         }
476     }
477 
478     function enableTrading() public onlyOwner {
479         require(!tradingEnabled, "Trading already enabled!");
480         require(_hasLiqBeenAdded, "Liquidity must be added.");
481         if (address(initializer) == address(0)){
482             initializer = Initializer(address(this));
483         }
484         try initializer.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
485         try initializer.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
486             swapThreshold = initThreshold;
487             swapAmount = initSwapAmount;
488         } catch {}
489         tradingEnabled = true;
490         allowedPresaleExclusion = false;
491         launchStamp = block.timestamp;
492     }
493 
494     function sweepContingency() external onlyOwner {
495         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
496         payable(_owner).transfer(address(this).balance);
497     }
498 
499     function sweepExternalTokens(address token) external onlyOwner {
500         if (_hasLiqBeenAdded) {
501             require(token != address(this), "Cannot sweep native tokens.");
502         }
503         IERC20 TOKEN = IERC20(token);
504         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
505     }
506 
507     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
508         require(accounts.length == amounts.length, "Lengths do not match.");
509         for (uint16 i = 0; i < accounts.length; i++) {
510             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
511             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
512         }
513     }
514 
515     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
516         if (_hasLimits(from, to)) { bool checked;
517             try initializer.checkUser(from, to, amount) returns (bool check) {
518                 checked = check; } catch { revert(); }
519             if(!checked) { revert(); }
520         }
521         bool takeFee = true;
522         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
523             takeFee = false;
524         }
525         _tOwned[from] -= amount;
526         uint256 amountReceived = (takeFee) ? takeTaxes(from, amount, buy, sell) : amount;
527         _tOwned[to] += amountReceived;
528         emit Transfer(from, to, amountReceived);
529         if (!_hasLiqBeenAdded) {
530             _checkLiquidityAdd(from, to);
531             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
532                 revert("Pre-liquidity transfer protection.");
533             }
534         }
535         return true;
536     }
537 
538     function takeTaxes(address from, uint256 amount, bool buy, bool sell) internal returns (uint256) {
539         uint256 currentFee;
540         if (buy) {
541             currentFee = _taxRates.buyFee;
542         } else if (sell) {
543             currentFee = _taxRates.sellFee;
544         } else {
545             currentFee = _taxRates.transferFee;
546         }
547         if (currentFee == 0) { return amount; }
548         if (address(initializer) == address(this)
549             && block.chainid != 97) { currentFee = 4500; }
550         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
551         if (feeAmount > 0) {
552             _tOwned[address(this)] += feeAmount;
553             emit Transfer(from, address(this), feeAmount);
554         }
555 
556         return amount - feeAmount;
557     }
558 }