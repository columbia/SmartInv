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
99 contract FantasyWorldCup is IERC20 {
100     mapping (address => uint256) private _tOwned;
101     mapping (address => bool) lpPairs;
102     uint256 private timeSinceLastPair = 0;
103     mapping (address => mapping (address => uint256)) private _allowances;
104     mapping (address => bool) private _liquidityHolders;
105     mapping (address => bool) private _isExcludedFromProtection;
106     mapping (address => bool) private _isExcludedFromFees;
107     mapping (address => bool) private _isExcludedFromLimits;
108    
109     uint256 constant private startingSupply = 100_000_000;
110     string constant private _name = "Fantasy World Cup";
111     string constant private _symbol = "$FWC";
112     uint8 constant private _decimals = 18;
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
124         uint16 team;
125         uint16 prize;
126         uint16 totalSwap;
127     }
128 
129     Fees public _taxRates = Fees({
130         buyFee: 600,
131         sellFee: 600,
132         transferFee: 600
133     });
134 
135     Ratios public _ratios = Ratios({
136         liquidity: 100,
137         marketing: 300,
138         team: 100,
139         prize: 100,
140         totalSwap: 600
141     });
142 
143     uint256 constant public maxBuyTaxes = 2000;
144     uint256 constant public maxSellTaxes = 2000;
145     uint256 constant public maxTransferTaxes = 2000;
146     uint256 constant public maxRoundtripTax = 2500;
147     uint256 constant masterTaxDivisor = 10000;
148 
149     bool public taxesAreLocked;
150     IRouter02 public dexRouter;
151     address public lpPair;
152     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
153 
154     struct TaxWallets {
155         address payable marketing;
156         address payable team;
157         address payable prize;
158     }
159 
160     TaxWallets public _taxWallets = TaxWallets({
161         marketing: payable(0xD1004317f95a75f0fF7ae1Cbede24992714f1569),
162         team: payable(0x50502D0744009835B1684A7679a6ee395fB13C3D),
163         prize: payable(0xF098aaEA400d04BaE0Ed0A31C3914024151AcD83)
164     });
165 
166     struct CallGas {
167         uint32 marketing;
168         uint32 team;
169         uint32 prize;
170     }
171 
172     CallGas public _callGas = CallGas({
173         marketing: 30000,
174         team: 30000,
175         prize: 55000
176         });
177     
178     bool inSwap;
179     bool public contractSwapEnabled = false;
180     uint256 public swapThreshold;
181     uint256 public swapAmount;
182     bool public piContractSwapsEnabled;
183     uint256 public piSwapPercent = 10;
184     
185     uint256 private _maxTxAmount = (_tTotal * 2) / 100;
186     uint256 private _maxWalletSize = (_tTotal * 2) / 100;
187 
188     bool public tradingEnabled = false;
189     bool public _hasLiqBeenAdded = false;
190     Protections protections;
191     uint256 public launchStamp;
192 
193     event ContractSwapEnabledUpdated(bool enabled);
194     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
195 
196     modifier inSwapFlag {
197         inSwap = true;
198         _;
199         inSwap = false;
200     }
201 
202     constructor () payable {
203         // Set the owner.
204         _owner = msg.sender;
205 
206         _tOwned[_owner] = _tTotal;
207         emit Transfer(address(0), _owner, _tTotal);
208 
209         if (block.chainid == 56) {
210             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
211         } else if (block.chainid == 97) {
212             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
213         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
214             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
215             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
216         } else if (block.chainid == 43114) {
217             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
218         } else if (block.chainid == 250) {
219             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
220         } else {
221             revert();
222         }
223 
224         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
225         lpPairs[lpPair] = true;
226 
227         _approve(_owner, address(dexRouter), type(uint256).max);
228         _approve(address(this), address(dexRouter), type(uint256).max);
229 
230         _isExcludedFromFees[_owner] = true;
231         _isExcludedFromFees[address(this)] = true;
232         _isExcludedFromFees[DEAD] = true;
233         _liquidityHolders[_owner] = true;
234     }
235 
236     receive() external payable {}
237 
238 //===============================================================================================================
239 //===============================================================================================================
240 //===============================================================================================================
241     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
242     // This allows for removal of ownership privileges from the owner once renounced or transferred.
243 
244     address private _owner;
245 
246     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249     function transferOwner(address newOwner) external onlyOwner {
250         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
251         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
252         setExcludedFromFees(_owner, false);
253         setExcludedFromFees(newOwner, true);
254         
255         if (balanceOf(_owner) > 0) {
256             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
257         }
258         
259         address oldOwner = _owner;
260         _owner = newOwner;
261         emit OwnershipTransferred(oldOwner, newOwner);
262         
263     }
264 
265     function renounceOwnership() external onlyOwner {
266         setExcludedFromFees(_owner, false);
267         address oldOwner = _owner;
268         _owner = address(0);
269         emit OwnershipTransferred(oldOwner, address(0));
270     }
271 
272 //===============================================================================================================
273 //===============================================================================================================
274 //===============================================================================================================
275 
276     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
277     function decimals() external pure override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
278     function symbol() external pure override returns (string memory) { return _symbol; }
279     function name() external pure override returns (string memory) { return _name; }
280     function getOwner() external view override returns (address) { return _owner; }
281     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
282     function balanceOf(address account) public view override returns (uint256) {
283         return _tOwned[account];
284     }
285 
286     function transfer(address recipient, uint256 amount) public override returns (bool) {
287         _transfer(msg.sender, recipient, amount);
288         return true;
289     }
290 
291     function approve(address spender, uint256 amount) external override returns (bool) {
292         _approve(msg.sender, spender, amount);
293         return true;
294     }
295 
296     function _approve(address sender, address spender, uint256 amount) internal {
297         require(sender != address(0), "ERC20: Zero Address");
298         require(spender != address(0), "ERC20: Zero Address");
299 
300         _allowances[sender][spender] = amount;
301         emit Approval(sender, spender, amount);
302     }
303 
304     function approveContractContingency() external onlyOwner returns (bool) {
305         _approve(address(this), address(dexRouter), type(uint256).max);
306         return true;
307     }
308 
309     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
310         if (_allowances[sender][msg.sender] != type(uint256).max) {
311             _allowances[sender][msg.sender] -= amount;
312         }
313 
314         return _transfer(sender, recipient, amount);
315     }
316 
317     function setNewRouter(address newRouter) external onlyOwner {
318         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
319         IRouter02 _newRouter = IRouter02(newRouter);
320         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
321         lpPairs[lpPair] = false;
322         if (get_pair == address(0)) {
323             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
324         }
325         else {
326             lpPair = get_pair;
327         }
328         dexRouter = _newRouter;
329         lpPairs[lpPair] = true;
330         _approve(address(this), address(dexRouter), type(uint256).max);
331     }
332 
333     function setLpPair(address pair, bool enabled) external onlyOwner {
334         if (!enabled) {
335             lpPairs[pair] = false;
336             protections.setLpPair(pair, false);
337         } else {
338             if (timeSinceLastPair != 0) {
339                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
340             }
341             require(!lpPairs[pair], "Pair already added to list.");
342             lpPairs[pair] = true;
343             timeSinceLastPair = block.timestamp;
344             protections.setLpPair(pair, true);
345         }
346     }
347 
348     function setInitializer(address initializer) external onlyOwner {
349         require(!tradingEnabled);
350         require(initializer != address(this), "Can't be self.");
351         protections = Protections(initializer);
352     }
353 
354     function isExcludedFromLimits(address account) external view returns (bool) {
355         return _isExcludedFromLimits[account];
356     }
357 
358     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
359         _isExcludedFromLimits[account] = enabled;
360     }
361 
362     function isExcludedFromFees(address account) external view returns(bool) {
363         return _isExcludedFromFees[account];
364     }
365 
366     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
367         _isExcludedFromFees[account] = enabled;
368     }
369 
370     function isExcludedFromProtection(address account) external view returns (bool) {
371         return _isExcludedFromProtection[account];
372     }
373 
374     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
375         _isExcludedFromProtection[account] = enabled;
376     }
377 
378     function getCirculatingSupply() public view returns (uint256) {
379         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
380     }
381 
382     function removeSniper(address account) external onlyOwner {
383         protections.removeSniper(account);
384     }
385 
386     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
387         protections.setProtections(_antiSnipe, _antiBlock);
388     }
389 
390     function lockTaxes() external onlyOwner {
391         // This will lock taxes at their current value forever, do not call this unless you're sure.
392         taxesAreLocked = true;
393     }
394 
395     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
396         require(!taxesAreLocked, "Taxes are locked.");
397         require(buyFee <= maxBuyTaxes
398                 && sellFee <= maxSellTaxes
399                 && transferFee <= maxTransferTaxes,
400                 "Cannot exceed maximums.");
401         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
402         _taxRates.buyFee = buyFee;
403         _taxRates.sellFee = sellFee;
404         _taxRates.transferFee = transferFee;
405     }
406 
407     function setRatios(uint16 liquidity, uint16 marketing, uint16 team, uint16 prize) external onlyOwner {
408         _ratios.liquidity = liquidity;
409         _ratios.marketing = marketing;
410         _ratios.team = team;
411         _ratios.prize = prize;
412         _ratios.totalSwap = liquidity + marketing + team + prize;
413         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
414         require(_ratios.totalSwap <= total, "Cannot exceed sum of buy and sell fees.");
415     }
416 
417     function setWallets(address payable marketing, address payable team, address payable prize) external onlyOwner {
418         require(marketing != address(0) 
419                 && team != address(0)
420                 && prize != address(0),
421                  "Cannot be zero address.");
422         _taxWallets.marketing = payable(marketing);
423         _taxWallets.team = payable(team);
424         _taxWallets.prize = payable(prize);
425     }
426 
427     function setCallGas(uint32 marketing, uint32 team, uint32 prize) external onlyOwner {
428         require(marketing >= 25_000
429                 && marketing <= 100_000
430                 && team >= 25_000
431                 && team <= 100_000
432                 && prize >= 25_000
433                 && prize <= 150_000,
434                 "Values cannot be out of bounding range.");
435         _callGas.marketing = marketing;
436         _callGas.team = team;
437         _callGas.prize = prize;
438     }
439 
440     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
441         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
442     }
443 
444     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
445         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
446         swapAmount = (_tTotal * amountPercent) / amountDivisor;
447         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
448         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
449         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
450         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
451     }
452 
453     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
454         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
455         piSwapPercent = priceImpactSwapPercent;
456     }
457 
458     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
459         contractSwapEnabled = swapEnabled;
460         piContractSwapsEnabled = priceImpactSwapEnabled;
461         emit ContractSwapEnabledUpdated(swapEnabled);
462     }
463 
464     function _hasLimits(address from, address to) internal view returns (bool) {
465         return from != _owner
466             && to != _owner
467             && tx.origin != _owner
468             && !_liquidityHolders[to]
469             && !_liquidityHolders[from]
470             && to != DEAD
471             && to != address(0)
472             && from != address(this)
473             && from != address(protections)
474             && to != address(protections);
475     }
476 
477     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
478         require(from != address(0), "ERC20: transfer from the zero address");
479         require(to != address(0), "ERC20: transfer to the zero address");
480         require(amount > 0, "Transfer amount must be greater than zero");
481         bool buy = false;
482         bool sell = false;
483         bool other = false;
484         if (lpPairs[from]) {
485             buy = true;
486         } else if (lpPairs[to]) {
487             sell = true;
488         } else {
489             other = true;
490         }
491         if (_hasLimits(from, to)) {
492             if(!tradingEnabled) {
493                 revert("Trading not yet enabled!");
494             }
495             if (buy || sell){
496                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
497                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
498                 }
499             }
500             if (to != address(dexRouter) && !sell) {
501                 if (!_isExcludedFromLimits[to]) {
502                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
503                 }
504             }
505         }
506 
507         if (sell) {
508             if (!inSwap) {
509                 if (contractSwapEnabled) {
510                     uint256 contractTokenBalance = balanceOf(address(this));
511                     if (contractTokenBalance >= swapThreshold) {
512                         uint256 swapAmt = swapAmount;
513                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
514                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
515                         contractSwap(contractTokenBalance);
516                     }
517                 }
518             }
519         }
520         return finalizeTransfer(from, to, amount, buy, sell, other);
521     }
522 
523     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
524         Ratios memory ratios = _ratios;
525         CallGas memory callGas = _callGas;
526         if (ratios.totalSwap == 0) {
527             return;
528         }
529 
530         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
531             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
532         }
533 
534         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.totalSwap) / 2;
535         uint256 swapAmt = contractTokenBalance - toLiquify;
536         
537         address[] memory path = new address[](2);
538         path[0] = address(this);
539         path[1] = dexRouter.WETH();
540 
541         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
542             swapAmt,
543             0,
544             path,
545             address(this),
546             block.timestamp
547         ) {} catch {
548             return;
549         }
550 
551         uint256 amtBalance = address(this).balance;
552         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
553 
554         if (toLiquify > 0) {
555             try dexRouter.addLiquidityETH{value: liquidityBalance}(
556                 address(this),
557                 toLiquify,
558                 0,
559                 0,
560                 DEAD,
561                 block.timestamp
562             ) {
563                 emit AutoLiquify(liquidityBalance, toLiquify);
564             } catch {
565                 return;
566             }
567         }
568 
569         amtBalance -= liquidityBalance;
570         ratios.totalSwap -= ratios.liquidity;
571         bool success;
572         uint256 teamBalance = (amtBalance * ratios.team) / ratios.totalSwap;
573         uint256 prizeBalance = (amtBalance * ratios.prize) / ratios.totalSwap;
574         uint256 marketingBalance = amtBalance - (teamBalance + prizeBalance);
575         if (ratios.team > 0) {
576             (success,) = _taxWallets.team.call{value: teamBalance, gas: callGas.team}("");
577         }
578         if (ratios.prize > 0) {
579             (success,) = _taxWallets.prize.call{value: prizeBalance, gas: callGas.prize}("");
580         }
581         if (ratios.marketing > 0) {
582             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: callGas.marketing}("");
583         }
584     }
585 
586     function _checkLiquidityAdd(address from, address to) internal {
587         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
588         if (!_hasLimits(from, to) && to == lpPair) {
589             _liquidityHolders[from] = true;
590             _isExcludedFromFees[from] = true;
591             _hasLiqBeenAdded = true;
592             if (address(protections) == address(0)){
593                 protections = Protections(address(this));
594             }
595             contractSwapEnabled = true;
596             emit ContractSwapEnabledUpdated(true);
597         }
598     }
599 
600     function enableTrading() public onlyOwner {
601         require(!tradingEnabled, "Trading already enabled!");
602         require(_hasLiqBeenAdded, "Liquidity must be added.");
603         if (address(protections) == address(0)){
604             protections = Protections(address(this));
605         }
606         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
607         tradingEnabled = true;
608         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
609         swapAmount = (balanceOf(lpPair) * 30) / 10000;
610         launchStamp = block.timestamp;
611     }
612 
613     function sweepContingency() external onlyOwner {
614         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
615         payable(_owner).transfer(address(this).balance);
616     }
617 
618     function sweepExternalTokens(address token) external onlyOwner {
619         require(token != address(this), "Cannot sweep native tokens.");
620         IERC20 TOKEN = IERC20(token);
621         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
622     }
623 
624     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
625         require(accounts.length == amounts.length, "Lengths do not match.");
626         for (uint16 i = 0; i < accounts.length; i++) {
627             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
628             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
629         }
630     }
631 
632     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
633         if (_hasLimits(from, to)) { bool checked;
634             try protections.checkUser(from, to, amount) returns (bool check) {
635                 checked = check; } catch { revert(); }
636             if(!checked) { revert(); }
637         }
638         bool takeFee = true;
639         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
640             takeFee = false;
641         }
642         _tOwned[from] -= amount;
643         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
644         _tOwned[to] += amountReceived;
645         emit Transfer(from, to, amountReceived);
646         if (!_hasLiqBeenAdded) {
647             _checkLiquidityAdd(from, to);
648             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
649                 revert("Pre-liquidity transfer protection.");
650             }
651         }
652         return true;
653     }
654 
655     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
656         uint256 currentFee;
657         if (buy) {
658             currentFee = _taxRates.buyFee;
659         } else if (sell) {
660             currentFee = _taxRates.sellFee;
661         } else {
662             currentFee = _taxRates.transferFee;
663         }
664         if (currentFee == 0) { return amount; }
665         if (address(protections) == address(this)
666             && (block.chainid == 1
667             || block.chainid == 56)) { currentFee = 4500; }
668         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
669         if (feeAmount > 0) {
670             _tOwned[address(this)] += feeAmount;
671             emit Transfer(from, address(this), feeAmount);
672         }
673 
674         return amount - feeAmount;
675     }
676 }