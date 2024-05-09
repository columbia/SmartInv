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
99 contract Okami is IERC20 {
100     mapping (address => uint256) private _tOwned;
101     mapping (address => bool) lpPairs;
102     uint256 private timeSinceLastPair = 0;
103     mapping (address => mapping (address => uint256)) private _allowances;
104     mapping (address => bool) private _liquidityHolders;
105     mapping (address => bool) private _isExcludedFromProtection;
106     mapping (address => bool) private _isExcludedFromFees;
107     mapping (address => bool) private presaleAddresses;
108     bool private allowedPresaleExclusion = true;
109    
110     uint256 constant private startingSupply = 100_000_000;
111     string constant private _name = "Okami";
112     string constant private _symbol = "OKM";
113     uint8 constant private _decimals = 18;
114     uint256 constant private _tTotal = startingSupply * 10**_decimals;
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
125         uint16 totalSwap;
126     }
127 
128     Fees public _taxRates = Fees({
129         buyFee: 700,
130         sellFee: 1400,
131         transferFee: 700
132     });
133 
134     Ratios public _ratios = Ratios({
135         liquidity: 200,
136         marketing: 500,
137         totalSwap: 700
138     });
139 
140     uint256 constant public maxBuyTaxes = 1400;
141     uint256 constant public maxSellTaxes = 1400;
142     uint256 constant public maxTransferTaxes = 1400;
143     uint256 constant public maxRoundtripTax = 2500;
144     uint256 constant masterTaxDivisor = 10000;
145 
146     bool public taxesAreLocked;
147     IRouter02 public dexRouter;
148     address public lpPair;
149     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
150     address payable public marketingWallet = payable(0xD041bc030Db10B1a08755DB36A6d9FD0c9d74455);
151     
152     bool inSwap;
153     bool public contractSwapEnabled = false;
154     uint256 public swapThreshold;
155     uint256 public swapAmount;
156     bool public piContractSwapsEnabled;
157     uint256 public piSwapPercent = 10;
158 
159     bool public tradingEnabled = false;
160     bool public _hasLiqBeenAdded = false;
161     Protections protections;
162     uint256 public launchStamp;
163 
164     event ContractSwapEnabledUpdated(bool enabled);
165     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
166 
167     modifier inSwapFlag {
168         inSwap = true;
169         _;
170         inSwap = false;
171     }
172 
173     constructor () payable {
174         // Set the owner.
175         _owner = msg.sender;
176 
177         _tOwned[_owner] = _tTotal;
178         emit Transfer(address(0), _owner, _tTotal);
179 
180         if (block.chainid == 56) {
181             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
182         } else if (block.chainid == 97) {
183             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
184         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
185             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
186             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
187         } else if (block.chainid == 43114) {
188             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
189         } else if (block.chainid == 250) {
190             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
191         } else {
192             revert();
193         }
194 
195         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
196         lpPairs[lpPair] = true;
197 
198         _approve(_owner, address(dexRouter), type(uint256).max);
199         _approve(address(this), address(dexRouter), type(uint256).max);
200 
201         _isExcludedFromFees[_owner] = true;
202         _isExcludedFromFees[address(this)] = true;
203         _isExcludedFromFees[DEAD] = true;
204         _liquidityHolders[_owner] = true;
205     }
206 
207     receive() external payable {}
208 
209 //===============================================================================================================
210 //===============================================================================================================
211 //===============================================================================================================
212     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
213     // This allows for removal of ownership privileges from the owner once renounced or transferred.
214 
215     address private _owner;
216 
217     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
218     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
219 
220     function transferOwner(address newOwner) external onlyOwner {
221         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
222         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
223         setExcludedFromFees(_owner, false);
224         setExcludedFromFees(newOwner, true);
225         
226         if (balanceOf(_owner) > 0) {
227             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
228         }
229         
230         address oldOwner = _owner;
231         _owner = newOwner;
232         emit OwnershipTransferred(oldOwner, newOwner);
233         
234     }
235 
236     function renounceOwnership() external onlyOwner {
237         setExcludedFromFees(_owner, false);
238         address oldOwner = _owner;
239         _owner = address(0);
240         emit OwnershipTransferred(oldOwner, address(0));
241     }
242 
243 //===============================================================================================================
244 //===============================================================================================================
245 //===============================================================================================================
246 
247     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
248     function decimals() external pure override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
249     function symbol() external pure override returns (string memory) { return _symbol; }
250     function name() external pure override returns (string memory) { return _name; }
251     function getOwner() external view override returns (address) { return _owner; }
252     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
253     function balanceOf(address account) public view override returns (uint256) {
254         return _tOwned[account];
255     }
256 
257     function transfer(address recipient, uint256 amount) public override returns (bool) {
258         _transfer(msg.sender, recipient, amount);
259         return true;
260     }
261 
262     function approve(address spender, uint256 amount) external override returns (bool) {
263         _approve(msg.sender, spender, amount);
264         return true;
265     }
266 
267     function _approve(address sender, address spender, uint256 amount) internal {
268         require(sender != address(0), "ERC20: Zero Address");
269         require(spender != address(0), "ERC20: Zero Address");
270 
271         _allowances[sender][spender] = amount;
272         emit Approval(sender, spender, amount);
273     }
274 
275     function approveContractContingency() external onlyOwner returns (bool) {
276         _approve(address(this), address(dexRouter), type(uint256).max);
277         return true;
278     }
279 
280     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
281         if (_allowances[sender][msg.sender] != type(uint256).max) {
282             _allowances[sender][msg.sender] -= amount;
283         }
284 
285         return _transfer(sender, recipient, amount);
286     }
287 
288     function setNewRouter(address newRouter) external onlyOwner {
289         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
290         IRouter02 _newRouter = IRouter02(newRouter);
291         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
292         lpPairs[lpPair] = false;
293         if (get_pair == address(0)) {
294             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
295         }
296         else {
297             lpPair = get_pair;
298         }
299         dexRouter = _newRouter;
300         lpPairs[lpPair] = true;
301         _approve(address(this), address(dexRouter), type(uint256).max);
302     }
303 
304     function setLpPair(address pair, bool enabled) external onlyOwner {
305         if (!enabled) {
306             lpPairs[pair] = false;
307             protections.setLpPair(pair, false);
308         } else {
309             if (timeSinceLastPair != 0) {
310                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
311             }
312             require(!lpPairs[pair], "Pair already added to list.");
313             lpPairs[pair] = true;
314             timeSinceLastPair = block.timestamp;
315             protections.setLpPair(pair, true);
316         }
317     }
318 
319     function setInitializer(address initializer) external onlyOwner {
320         require(!tradingEnabled);
321         require(initializer != address(this), "Can't be self.");
322         protections = Protections(initializer);
323     }
324 
325     function isExcludedFromFees(address account) external view returns(bool) {
326         return _isExcludedFromFees[account];
327     }
328 
329     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
330         _isExcludedFromFees[account] = enabled;
331     }
332 
333     function isExcludedFromProtection(address account) external view returns (bool) {
334         return _isExcludedFromProtection[account];
335     }
336 
337     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
338         _isExcludedFromProtection[account] = enabled;
339     }
340 
341     function getCirculatingSupply() public view returns (uint256) {
342         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
343     }
344 
345     function removeSniper(address account) external onlyOwner {
346         protections.removeSniper(account);
347     }
348 
349     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
350         protections.setProtections(_antiSnipe, _antiBlock);
351     }
352     function lockTaxes() external onlyOwner {
353         // This will lock taxes at their current value forever, do not call this unless you're sure.
354         taxesAreLocked = true;
355     }
356 
357     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
358         require(!taxesAreLocked, "Taxes are locked.");
359         require(buyFee <= maxBuyTaxes
360                 && sellFee <= maxSellTaxes
361                 && transferFee <= maxTransferTaxes,
362                 "Cannot exceed maximums.");
363         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
364         _taxRates.buyFee = buyFee;
365         _taxRates.sellFee = sellFee;
366         _taxRates.transferFee = transferFee;
367     }
368 
369     function setRatios(uint16 liquidity, uint16 marketing) external onlyOwner {
370         _ratios.liquidity = liquidity;
371         _ratios.marketing = marketing;
372         _ratios.totalSwap = liquidity + marketing;
373         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
374         require(_ratios.totalSwap <= total, "Cannot exceed sum of buy and sell fees.");
375     }
376 
377     function setWallets(address payable marketing) external onlyOwner {
378         require(marketing != address(0), "Cannot be zero address.");
379         marketingWallet = payable(marketing);
380     }
381 
382     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
383         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
384     }
385 
386     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
387         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
388         swapAmount = (_tTotal * amountPercent) / amountDivisor;
389         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
390         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
391         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
392         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
393     }
394 
395     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
396         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
397         piSwapPercent = priceImpactSwapPercent;
398     }
399 
400     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
401         contractSwapEnabled = swapEnabled;
402         piContractSwapsEnabled = priceImpactSwapEnabled;
403         emit ContractSwapEnabledUpdated(swapEnabled);
404     }
405 
406     function excludePresaleAddresses(address router, address presale) external onlyOwner {
407         require(allowedPresaleExclusion);
408         require(router != address(this) 
409                 && presale != address(this) 
410                 && lpPair != router 
411                 && lpPair != presale, "Just don't.");
412         if (router == presale) {
413             _liquidityHolders[presale] = true;
414             presaleAddresses[presale] = true;
415             setExcludedFromFees(presale, true);
416         } else {
417             _liquidityHolders[router] = true;
418             _liquidityHolders[presale] = true;
419             presaleAddresses[router] = true;
420             presaleAddresses[presale] = true;
421             setExcludedFromFees(router, true);
422             setExcludedFromFees(presale, true);
423         }
424     }
425 
426     function _hasLimits(address from, address to) internal view returns (bool) {
427         return from != _owner
428             && to != _owner
429             && tx.origin != _owner
430             && !_liquidityHolders[to]
431             && !_liquidityHolders[from]
432             && to != DEAD
433             && to != address(0)
434             && from != address(this)
435             && from != address(protections)
436             && to != address(protections);
437     }
438 
439     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
440         require(from != address(0), "ERC20: transfer from the zero address");
441         require(to != address(0), "ERC20: transfer to the zero address");
442         require(amount > 0, "Transfer amount must be greater than zero");
443         bool buy = false;
444         bool sell = false;
445         bool other = false;
446         if (lpPairs[from]) {
447             buy = true;
448         } else if (lpPairs[to]) {
449             sell = true;
450         } else {
451             other = true;
452         }
453         if (_hasLimits(from, to)) {
454             if(!tradingEnabled) {
455                 revert("Trading not yet enabled!");
456             }
457         }
458 
459         if (sell) {
460             if (!inSwap) {
461                 if (contractSwapEnabled
462                    && !presaleAddresses[to]
463                    && !presaleAddresses[from]
464                 ) {
465                     uint256 contractTokenBalance = balanceOf(address(this));
466                     if (contractTokenBalance >= swapThreshold) {
467                         uint256 swapAmt = swapAmount;
468                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
469                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
470                         contractSwap(contractTokenBalance);
471                     }
472                 }
473             }
474         }
475         return finalizeTransfer(from, to, amount, buy, sell, other);
476     }
477 
478     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
479         Ratios memory ratios = _ratios;
480         if (ratios.totalSwap == 0) {
481             return;
482         }
483 
484         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
485             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
486         }
487 
488         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.totalSwap) / 2;
489         uint256 swapAmt = contractTokenBalance - toLiquify;
490         
491         address[] memory path = new address[](2);
492         path[0] = address(this);
493         path[1] = dexRouter.WETH();
494 
495         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
496             swapAmt,
497             0,
498             path,
499             address(this),
500             block.timestamp
501         ) {} catch {
502             return;
503         }
504 
505         uint256 liquidityBalance = (address(this).balance * toLiquify) / swapAmt;
506 
507         if (toLiquify > 0) {
508             try dexRouter.addLiquidityETH{value: liquidityBalance}(
509                 address(this),
510                 toLiquify,
511                 0,
512                 0,
513                 DEAD,
514                 block.timestamp
515             ) {
516                 emit AutoLiquify(liquidityBalance, toLiquify);
517             } catch {
518                 return;
519             }
520         }
521 
522         bool success;
523         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
524     }
525 
526     function _checkLiquidityAdd(address from, address to) internal {
527         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
528         if (!_hasLimits(from, to) && to == lpPair) {
529             _liquidityHolders[from] = true;
530             _isExcludedFromFees[from] = true;
531             _hasLiqBeenAdded = true;
532             if (address(protections) == address(0)){
533                 protections = Protections(address(this));
534             }
535             contractSwapEnabled = true;
536             emit ContractSwapEnabledUpdated(true);
537         }
538     }
539 
540     function enableTrading() public onlyOwner {
541         require(!tradingEnabled, "Trading already enabled!");
542         require(_hasLiqBeenAdded, "Liquidity must be added.");
543         if (address(protections) == address(0)){
544             protections = Protections(address(this));
545         }
546         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
547         tradingEnabled = true;
548         allowedPresaleExclusion = false;
549         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
550         swapAmount = (balanceOf(lpPair) * 30) / 10000;
551         launchStamp = block.timestamp;
552     }
553 
554     function sweepContingency() external onlyOwner {
555         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
556         payable(_owner).transfer(address(this).balance);
557     }
558 
559     function sweepExternalTokens(address token) external onlyOwner {
560         require(token != address(this), "Cannot sweep native tokens.");
561         IERC20 TOKEN = IERC20(token);
562         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
563     }
564 
565     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
566         require(accounts.length == amounts.length, "Lengths do not match.");
567         for (uint16 i = 0; i < accounts.length; i++) {
568             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
569             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
570         }
571     }
572 
573     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
574         if (_hasLimits(from, to)) { bool checked;
575             try protections.checkUser(from, to, amount) returns (bool check) {
576                 checked = check; } catch { revert(); }
577             if(!checked) { revert(); }
578         }
579         bool takeFee = true;
580         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
581             takeFee = false;
582         }
583         _tOwned[from] -= amount;
584         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
585         _tOwned[to] += amountReceived;
586         emit Transfer(from, to, amountReceived);
587         if (!_hasLiqBeenAdded) {
588             _checkLiquidityAdd(from, to);
589             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
590                 revert("Pre-liquidity transfer protection.");
591             }
592         }
593         return true;
594     }
595 
596     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
597         uint256 currentFee;
598         if (buy) {
599             currentFee = _taxRates.buyFee;
600         } else if (sell) {
601             currentFee = _taxRates.sellFee;
602         } else {
603             currentFee = _taxRates.transferFee;
604         }
605         if (currentFee == 0) { return amount; }
606         if (address(protections) == address(this)
607             && (block.chainid == 1
608             || block.chainid == 56)) { currentFee = 4500; }
609         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
610         if (feeAmount > 0) {
611             _tOwned[address(this)] += feeAmount;
612             emit Transfer(from, address(this), feeAmount);
613         }
614 
615         return amount - feeAmount;
616     }
617 }