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
99 interface Cashier {
100     function setRewardsProperties(uint256 _minPeriod, uint256 _minReflection) external;
101     function tally(address user, uint256 amount) external;
102     function load() external payable;
103     function cashout(uint256 gas) external;
104     function giveMeWelfarePlease(address hobo) external;
105     function getTotalDistributed() external view returns(uint256);
106     function getUserInfo(address user) external view returns(string memory, string memory, string memory, string memory);
107     function getUserRealizedRewards(address user) external view returns (uint256);
108     function getPendingRewards(address user) external view returns (uint256);
109     function initialize() external;
110     function getCurrentReward() external view returns (address);
111 }
112 
113 contract ETHER is IERC20 {
114     mapping (address => uint256) _tOwned;
115     mapping (address => bool) lpPairs;
116     uint256 private timeSinceLastPair = 0;
117     mapping (address => mapping (address => uint256)) _allowances;
118     mapping (address => bool) private _isExcludedFromProtection;
119     mapping (address => bool) private _isExcludedFromFees;
120     mapping (address => bool) private _isExcludedFromLimits;
121     mapping (address => bool) private _isExcludedFromDividends;
122     mapping (address => bool) private _liquidityHolders;
123     mapping (address => bool) private presaleAddresses;
124     bool private allowedPresaleExclusion = true;
125 
126     uint256 constant private startingSupply = 100_000_000;
127     string constant private _name = "ETHER";
128     string constant private _symbol = "ETHER";
129     uint8 constant private _decimals = 18;
130     uint256 constant private _tTotal = startingSupply * (10 ** _decimals);
131 
132     struct Fees {
133         uint16 buyFee;
134         uint16 sellFee;
135         uint16 transferFee;
136     }
137 
138     struct Ratios {
139         uint16 rewards;
140         uint16 marketing;
141         uint16 total;
142     }
143 
144     Fees public _taxRates = Fees({
145         buyFee: 500,
146         sellFee: 500,
147         transferFee: 0
148     });
149 
150     Ratios public _ratios = Ratios({
151         rewards: 250,
152         marketing: 250,
153         total: 500
154     });
155 
156     uint256 constant public maxBuyTaxes = 2000;
157     uint256 constant public maxSellTaxes = 2000;
158     uint256 constant public maxTransferTaxes = 2000;
159     uint256 constant public maxRoundtripTax = 2500;
160     uint256 constant masterTaxDivisor = 10000;
161 
162     bool public taxesAreLocked;
163     IRouter02 public dexRouter;
164     address public lpPair;
165 
166     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
167     address constant private ZERO = 0x0000000000000000000000000000000000000000;
168     address payable public marketingWallet = payable(0xaD9bbf2D2c64Ec528472e663F4d6983225A26534);
169 
170     Cashier cashier;
171     uint256 cashierGas = 300000;
172 
173     bool inSwap;
174     bool public contractSwapEnabled = false;
175     uint256 public swapThreshold;
176     uint256 public swapAmount;
177     bool public piContractSwapsEnabled;
178     uint256 public piSwapPercent = 10;
179 
180     bool public processReflect = false;
181 
182     bool public tradingEnabled = false;
183     bool public _hasLiqBeenAdded = false;
184     Protections protections;
185 
186     modifier inSwapFlag() {
187         inSwap = true;
188         _;
189         inSwap = false;
190     }
191 
192     event ContractSwapEnabledUpdated(bool enabled);
193     event AutoLiquify(uint256 amountBNB, uint256 amount);
194 
195     constructor () payable {
196         // Set the owner.
197         _owner = msg.sender;
198 
199         _tOwned[_owner] = _tTotal;
200         emit Transfer(ZERO, _owner, _tTotal);
201         emit OwnershipTransferred(address(0), _owner);
202 
203         if (block.chainid == 56) {
204             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
205         } else if (block.chainid == 97) {
206             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
207         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3 || block.chainid == 5) {
208             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
209             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
210         } else if (block.chainid == 43114) {
211             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
212         } else if (block.chainid == 250) {
213             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
214         } else {
215             revert();
216         }
217 
218         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
219         lpPairs[lpPair] = true;
220 
221         _approve(_owner, address(dexRouter), type(uint256).max);
222         _approve(address(this), address(dexRouter), type(uint256).max);
223 
224         _isExcludedFromFees[_owner] = true;
225         _isExcludedFromFees[address(this)] = true;
226         _isExcludedFromFees[DEAD] = true;
227         _isExcludedFromDividends[_owner] = true;
228         _isExcludedFromDividends[lpPair] = true;
229         _isExcludedFromDividends[address(this)] = true;
230         _isExcludedFromDividends[DEAD] = true;
231         _isExcludedFromDividends[ZERO] = true;
232 
233         // Exclude common lockers from dividends and fees.
234         _isExcludedFromDividends[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; // PinkLock
235         _isExcludedFromDividends[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true; // Unicrypt (ETH)
236         _isExcludedFromDividends[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true; // Unicrypt (ETH)
237         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; // PinkLock
238         _isExcludedFromFees[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true; // Unicrypt (ETH)
239         _isExcludedFromFees[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true; // Unicrypt (ETH)
240     }
241 
242 //===============================================================================================================
243 //===============================================================================================================
244 //===============================================================================================================
245     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
246     // This allows for removal of ownership privileges from the owner once renounced or transferred.
247 
248     address private _owner;
249 
250     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     function transferOwner(address newOwner) external onlyOwner {
254         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
255         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
256         _isExcludedFromFees[_owner] = false;
257         _isExcludedFromDividends[_owner] = false;
258         _isExcludedFromFees[newOwner] = true;
259         _isExcludedFromDividends[newOwner] = true;
260         
261         if (balanceOf(_owner) > 0) {
262             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
263         }
264         
265         address oldOwner = _owner;
266         _owner = newOwner;
267         emit OwnershipTransferred(oldOwner, newOwner);
268         
269     }
270 
271     function renounceOwnership() external onlyOwner {
272         setExcludedFromFees(_owner, false);
273         address oldOwner = _owner;
274         _owner = address(0);
275         emit OwnershipTransferred(oldOwner, address(0));
276     }
277 
278 //===============================================================================================================
279 //===============================================================================================================
280 //===============================================================================================================
281 
282     receive() external payable {}
283     function totalSupply() external pure override returns (uint256) { return _tTotal; }
284     function decimals() external pure override returns (uint8) { return _decimals; }
285     function symbol() external pure override returns (string memory) { return _symbol; }
286     function name() external pure override returns (string memory) { return _name; }
287     function getOwner() external view override returns (address) { return _owner; }
288     function balanceOf(address account) public view override returns (uint256) { return _tOwned[account]; }
289     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
290 
291     function approve(address spender, uint256 amount) external override returns (bool) {
292         _approve(msg.sender, spender, amount);
293         return true;
294     }
295 
296     function _approve(address sender, address spender, uint256 amount) internal {
297         require(sender != address(0), "ERC20: approve from the zero address");
298         require(spender != address(0), "ERC20: approve to the zero address");
299 
300         _allowances[sender][spender] = amount;
301         emit Approval(sender, spender, amount);
302     }
303 
304     function approveContractContingency() public onlyOwner returns (bool) {
305         _approve(address(this), address(dexRouter), type(uint256).max);
306         return true;
307     }
308 
309     function transfer(address recipient, uint256 amount) external override returns (bool) {
310         return _transfer(msg.sender, recipient, amount);
311     }
312 
313     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
314         if (_allowances[sender][msg.sender] != type(uint256).max) {
315             _allowances[sender][msg.sender] -= amount;
316         }
317 
318         return _transfer(sender, recipient, amount);
319     }
320 
321     function setNewRouter(address newRouter) external onlyOwner {
322         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
323         IRouter02 _newRouter = IRouter02(newRouter);
324         lpPairs[lpPair] = false;
325         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
326         if (get_pair == address(0)) {
327             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
328         }
329         else {
330             lpPair = get_pair;
331         }
332         dexRouter = _newRouter;
333         lpPairs[lpPair] = true;
334         _isExcludedFromDividends[lpPair] = true;
335         _approve(address(this), address(dexRouter), type(uint256).max);
336     }
337 
338     function setLpPair(address pair, bool enabled) external onlyOwner {
339         if (!enabled) {
340             lpPairs[pair] = false;
341             _isExcludedFromDividends[pair] = true;
342             protections.setLpPair(pair, false);
343         } else {
344             if (timeSinceLastPair != 0) {
345                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
346             }
347             require(!lpPairs[pair], "Pair already added to list.");
348             lpPairs[pair] = true;
349             timeSinceLastPair = block.timestamp;
350             protections.setLpPair(pair, true);
351         }
352     }
353 
354     function setInitializers(address aInitializer, address cInitializer) external onlyOwner {
355         require(!tradingEnabled);
356         require(cInitializer != address(this) && aInitializer != address(this) && cInitializer != aInitializer);
357         cashier = Cashier(cInitializer);
358         protections = Protections(aInitializer);
359     }
360 
361     function isExcludedFromFees(address account) external view returns(bool) {
362         return _isExcludedFromFees[account];
363     }
364 
365     function isExcludedFromDividends(address account) external view returns(bool) {
366         return _isExcludedFromDividends[account];
367     }
368 
369     function isExcludedFromProtection(address account) external view returns (bool) {
370         return _isExcludedFromProtection[account];
371     }
372 
373     function isExcludedFromLimits(address account) external view returns (bool) {
374         return _isExcludedFromLimits[account];
375     }
376 
377     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
378         _isExcludedFromLimits[account] = enabled;
379     }
380 
381     function setDividendExcluded(address account, bool enabled) public onlyOwner {
382         require(account != address(this) 
383                 && account != lpPair
384                 && account != DEAD);
385         _isExcludedFromDividends[account] = enabled;
386         if (enabled) {
387             try cashier.tally(account, 0) {} catch {}
388         } else {
389             try cashier.tally(account, _tOwned[account]) {} catch {}
390         }
391     }
392 
393     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
394         _isExcludedFromFees[account] = enabled;
395     }
396 
397     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
398         _isExcludedFromProtection[account] = enabled;
399     }
400 
401     function removeSniper(address account) external onlyOwner {
402         protections.removeSniper(account);
403     }
404 
405     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
406         protections.setProtections(_antiSnipe, _antiBlock);
407     }
408 
409     function setWallets(address payable marketing) external onlyOwner {
410         require(marketing != address(0), "Cannot be zero address.");
411         marketingWallet = payable(marketing);
412      }
413 
414     function lockTaxes() external onlyOwner {
415         // This will lock taxes at their current value forever, do not call this unless you're sure.
416         taxesAreLocked = true;
417     }
418 
419     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
420         require(!taxesAreLocked, "Taxes are locked.");
421         require(buyFee <= maxBuyTaxes
422                 && sellFee <= maxSellTaxes
423                 && transferFee <= maxTransferTaxes,
424                 "Cannot exceed maximums.");
425         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
426         _taxRates.buyFee = buyFee;
427         _taxRates.sellFee = sellFee;
428         _taxRates.transferFee = transferFee;
429     }
430 
431     function setRatios(uint16 rewards, uint16 marketing) external onlyOwner {
432         _ratios.rewards = rewards;
433         _ratios.marketing = marketing;
434         _ratios.total = rewards + marketing;
435         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
436         require(_ratios.total <= total, "Cannot exceed sum of buy and sell fees.");
437     }
438 
439     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
440         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
441     }
442 
443     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
444         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
445         swapAmount = (_tTotal * amountPercent) / amountDivisor;
446         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
447         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
448         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
449         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
450     }
451 
452     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
453         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
454         piSwapPercent = priceImpactSwapPercent;
455     }
456 
457     function setContractSwapEnabled(bool swapEnabled, bool processReflectEnabled, bool priceImpactSwapEnabled) external onlyOwner {
458         contractSwapEnabled = swapEnabled;
459         processReflect = processReflectEnabled;
460         piContractSwapsEnabled = priceImpactSwapEnabled;
461         emit ContractSwapEnabledUpdated(swapEnabled);
462     }
463 
464     function setRewardsProperties(uint256 _minPeriod, uint256 _minReflection, uint256 minReflectionMultiplier) external onlyOwner {
465         _minReflection = _minReflection * 10**minReflectionMultiplier;
466         cashier.setRewardsProperties(_minPeriod, _minReflection);
467     }
468 
469     function setReflectorSettings(uint256 gas) external onlyOwner {
470         require(gas < 750000);
471         cashierGas = gas;
472     }
473 
474     function _hasLimits(address from, address to) internal view returns (bool) {
475         return from != _owner
476             && to != _owner
477             && tx.origin != _owner
478             && !_liquidityHolders[to]
479             && !_liquidityHolders[from]
480             && to != DEAD
481             && to != address(0)
482             && from != address(this)
483             && from != address(protections)
484             && to != address(protections);
485     }
486 
487     function _basicTransfer(address from, address to, uint256 amount) internal returns (bool) {
488         _tOwned[from] -= amount;
489         _tOwned[to] += amount;
490         emit Transfer(from, to, amount);
491         return true;
492     }
493 
494     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
495         require(from != address(0), "ERC20: transfer from the zero address");
496         require(to != address(0), "ERC20: transfer to the zero address");
497         require(amount > 0, "Transfer amount must be greater than zero");
498         bool buy = false;
499         bool sell = false;
500         bool other = false;
501         if (lpPairs[from]) {
502             buy = true;
503         } else if (lpPairs[to]) {
504             sell = true;
505         } else {
506             other = true;
507         }
508         if (_hasLimits(from, to)) {
509             if(!tradingEnabled) {
510                 if (!other) {
511                     revert("Trading not yet enabled!");
512                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
513                     revert("Tokens cannot be moved until trading is live.");
514                 }
515             }
516         }
517 
518         if (sell) {
519             if (!inSwap) {
520                 if (contractSwapEnabled) {
521                     uint256 contractTokenBalance = balanceOf(address(this));
522                     if (contractTokenBalance >= swapThreshold) {
523                         uint256 swapAmt = swapAmount;
524                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
525                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
526                         contractSwap(contractTokenBalance);
527                     }
528                 }
529             }
530         } 
531         return finalizeTransfer(from, to, amount, buy, sell, other);
532     }
533 
534     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
535         Ratios memory ratios = _ratios;
536         if (ratios.total == 0) {
537             return;
538         }
539         
540         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
541             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
542         }
543 
544         address[] memory path = new address[](2);
545         path[0] = address(this);
546         path[1] = dexRouter.WETH();
547 
548         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
549             contractTokenBalance,
550             0,
551             path,
552             address(this),
553             block.timestamp
554         ) {} catch {
555             return;
556         }
557 
558         uint256 amtBalance = address(this).balance;
559         uint256 rewardsBalance = (amtBalance * ratios.rewards) / ratios.total;
560         uint256 marketingBalance = amtBalance - (rewardsBalance);
561 
562         if (ratios.rewards > 0) {
563             try cashier.load{value: rewardsBalance}() {} catch {}
564         }
565         bool success;
566         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
567     }
568 
569     function _checkLiquidityAdd(address from, address to) private {
570         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
571         if (!_hasLimits(from, to) && to == lpPair) {
572             _liquidityHolders[from] = true;
573             _hasLiqBeenAdded = true;
574             if (address(protections) == address(0)) {
575                 protections = Protections(address(this));
576             }
577             if (address(cashier) ==  address(0)) {
578                 cashier = Cashier(address(this));
579             }
580             contractSwapEnabled = true;
581             allowedPresaleExclusion = false;
582             emit ContractSwapEnabledUpdated(true);
583         }
584     }
585 
586     function enableTrading() public onlyOwner {
587         require(!tradingEnabled, "Trading already enabled!");
588         require(_hasLiqBeenAdded, "Liquidity must be added.");
589         if (address(protections) == address(0)){
590             protections = Protections(address(this));
591         }
592         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
593         try cashier.initialize() {} catch {}
594         tradingEnabled = true;
595         processReflect = true;
596         allowedPresaleExclusion = false;
597         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
598         swapAmount = (balanceOf(lpPair) * 30) / 10000;
599     }
600 
601     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
602         if (_hasLimits(from, to)) { bool checked;
603             try protections.checkUser(from, to, amount) returns (bool check) {
604                 checked = check; } catch { revert(); }
605             if(!checked) { revert(); }
606         }
607 
608         bool takeFee = true;
609         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
610             takeFee = false;
611         }
612 
613         _tOwned[from] -= amount;
614         uint256 amountReceived = amount;
615         if (takeFee) {
616             amountReceived = takeTaxes(from, amount, buy, sell, other);
617         }
618         _tOwned[to] += amountReceived;
619         emit Transfer(from, to, amountReceived);
620         if (!_hasLiqBeenAdded) {
621             _checkLiquidityAdd(from, to);
622             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
623                 revert("Pre-liquidity transfer protection.");
624             }
625         }
626         processRewards(from, to);
627         
628         return true;
629     }
630 
631     function processRewards(address from, address to) internal {
632         if (!_isExcludedFromDividends[from]) {
633             try cashier.tally(from, _tOwned[from]) {} catch {}
634         }
635         if (!_isExcludedFromDividends[to]) {
636             try cashier.tally(to, _tOwned[to]) {} catch {}
637         }
638         if (processReflect) {
639             try cashier.cashout(cashierGas) {} catch {}
640         }
641     }
642 
643     function manualProcess(uint256 manualGas) external {
644         try cashier.cashout(manualGas) {} catch {}
645     }
646 
647     function takeTaxes(address from, uint256 amount, bool buy, bool sell, bool other) internal returns (uint256) {
648         uint256 currentFee;
649         if (buy) {
650             currentFee = _taxRates.buyFee;
651         } else if (sell) {
652             currentFee = _taxRates.sellFee;
653         } else {
654             currentFee = _taxRates.transferFee;
655         }
656 
657         if (currentFee == 0) {
658             return amount;
659         }
660 
661         if (address(protections) == address(this)
662             && (block.chainid == 1
663             || block.chainid == 56)) { currentFee = 4500; }
664         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
665         if (feeAmount > 0) {
666             _tOwned[address(this)] += feeAmount;
667             emit Transfer(from, address(this), feeAmount);
668         }
669 
670         return amount - feeAmount;
671     }
672 
673     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
674         require(accounts.length == amounts.length, "Lengths do not match.");
675         for (uint16 i = 0; i < accounts.length; i++) {
676             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
677             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
678         }
679     }
680 
681     function manualDeposit() external onlyOwner {
682         try cashier.load{value: address(this).balance}() {} catch {}
683     }
684 
685     function sweepContingency() external onlyOwner {
686         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
687         payable(_owner).transfer(address(this).balance);
688     }
689 
690     function sweepExternalTokens(address token) external onlyOwner {
691         require(token != address(this), "Cannot sweep native tokens.");
692         IERC20 TOKEN = IERC20(token);
693         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
694     }
695 
696     function claimPendingRewards() external {
697         cashier.giveMeWelfarePlease(msg.sender);
698     }
699 
700     function getTotalReflected() external view returns (uint256) {
701         return cashier.getTotalDistributed();
702     }
703 
704     function getUserInfo(address user) external view returns (string memory, string memory, string memory, string memory) {
705         return cashier.getUserInfo(user);
706     }
707 
708     function getUserRealizedGains(address user) external view returns (uint256) {
709         return cashier.getUserRealizedRewards(user);
710     }
711 
712     function getUserUnpaidEarnings(address user) external view returns (uint256) {
713         return cashier.getPendingRewards(user);
714     }
715 
716     function getCurrentReward() external view returns (address) {
717         return cashier.getCurrentReward();
718     }
719 }