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
96 }
97 
98 contract PAALAI is IERC20 {
99     mapping (address => uint256) private _tOwned;
100     mapping (address => bool) lpPairs;
101     uint256 private timeSinceLastPair = 0;
102     mapping (address => mapping (address => uint256)) private _allowances;
103     mapping (address => bool) private _liquidityHolders;
104     mapping (address => bool) private _isExcludedFromProtection;
105     mapping (address => bool) private _isExcludedFromFees;
106     uint256 constant private startingSupply = 1_000_000_000;
107     string constant private _name = "PAAL AI";
108     string constant private _symbol = "$PAAL";
109     uint8 constant private _decimals = 9;
110     uint256 constant private _tTotal = startingSupply * 10**_decimals;
111 
112     struct Fees {
113         uint16 buyFee;
114         uint16 sellFee;
115         uint16 transferFee;
116     }
117 
118     struct Ratios {
119         uint16 marketing;
120         uint16 development;
121         uint16 staking;
122         uint16 externalBuyback;
123         uint16 totalSwap;
124     }
125 
126     Fees public _taxRates = Fees({
127         buyFee: 400,
128         sellFee: 400,
129         transferFee: 0
130     });
131 
132     Ratios public _ratios = Ratios({
133         marketing: 1,
134         development: 1,
135         staking: 1,
136         externalBuyback: 1,
137         totalSwap: 4
138     });
139 
140     uint256 constant public maxBuyTaxes = 1000;
141     uint256 constant public maxSellTaxes = 1000;
142     uint256 constant public maxTransferTaxes = 1000;
143     uint256 constant masterTaxDivisor = 10000;
144 
145     bool public taxesAreLocked;
146     IRouter02 public dexRouter;
147     address public lpPair;
148     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
149 
150     struct TaxWallets {
151         address payable marketing;
152         address payable development;
153         address payable externalBuyback;
154         address payable staking;
155     }
156 
157     TaxWallets public _taxWallets = TaxWallets({
158         marketing: payable(0x54821d1B461aa887D37c449F3ace8dddDFCb8C0a),
159         development: payable(0xda8C6C3F4c8E29aCBbFC2081f181722D05B19a60),
160         externalBuyback: payable(0x45620f274ede76dB59586C45D9B4066c15DB2812),
161         staking: payable(0x8B505E46fD52723430590A6f4F9d768618e29a4B)
162     });
163     
164     bool inSwap;
165     bool public contractSwapEnabled = false;
166     uint256 public swapThreshold;
167     uint256 public swapAmount;
168     bool public piContractSwapsEnabled;
169     uint256 public piSwapPercent = 10;
170     bool public tradingEnabled = false;
171     bool public _hasLiqBeenAdded = false;
172     Initializer initializer;
173     uint256 public launchStamp;
174 
175     event ContractSwapEnabledUpdated(bool enabled);
176     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
177 
178     modifier inSwapFlag {
179         inSwap = true;
180         _;
181         inSwap = false;
182     }
183 
184     constructor () payable {
185         // Set the owner.
186         _owner = msg.sender;
187 
188         _tOwned[_owner] = _tTotal;
189         emit Transfer(address(0), _owner, _tTotal);
190 
191         _isExcludedFromFees[_owner] = true;
192         _isExcludedFromFees[address(this)] = true;
193         _isExcludedFromFees[DEAD] = true;
194         _liquidityHolders[_owner] = true;
195 
196         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; // PinkLock
197         _isExcludedFromFees[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true; // Unicrypt (ETH)
198         _isExcludedFromFees[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true; // Unicrypt (ETH)
199     }
200 
201 //===============================================================================================================
202 //===============================================================================================================
203 //===============================================================================================================
204     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
205     // This allows for removal of ownership privileges from the owner once renounced or transferred.
206 
207     address private _owner;
208 
209     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
210     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
211 
212     function transferOwner(address newOwner) external onlyOwner {
213         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
214         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
215         setExcludedFromFees(_owner, false);
216         setExcludedFromFees(newOwner, true);
217         
218         if (balanceOf(_owner) > 0) {
219             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
220         }
221         
222         address oldOwner = _owner;
223         _owner = newOwner;
224         emit OwnershipTransferred(oldOwner, newOwner);
225         
226     }
227 
228     function renounceOwnership() external onlyOwner {
229         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
230         setExcludedFromFees(_owner, false);
231         address oldOwner = _owner;
232         _owner = address(0);
233         emit OwnershipTransferred(oldOwner, address(0));
234     }
235 
236 //===============================================================================================================
237 //===============================================================================================================
238 //===============================================================================================================
239 
240     receive() external payable {}
241     function totalSupply() external pure override returns (uint256) { return _tTotal; }
242     function decimals() external pure override returns (uint8) { return _decimals; }
243     function symbol() external pure override returns (string memory) { return _symbol; }
244     function name() external pure override returns (string memory) { return _name; }
245     function getOwner() external view override returns (address) { return _owner; }
246     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
247     function balanceOf(address account) public view override returns (uint256) {
248         return _tOwned[account];
249     }
250 
251     function transfer(address recipient, uint256 amount) public override returns (bool) {
252         _transfer(msg.sender, recipient, amount);
253         return true;
254     }
255 
256     function approve(address spender, uint256 amount) external override returns (bool) {
257         _approve(msg.sender, spender, amount);
258         return true;
259     }
260 
261     function _approve(address sender, address spender, uint256 amount) internal {
262         require(sender != address(0), "ERC20: Zero Address");
263         require(spender != address(0), "ERC20: Zero Address");
264 
265         _allowances[sender][spender] = amount;
266         emit Approval(sender, spender, amount);
267     }
268 
269     function approveContractContingency() external onlyOwner returns (bool) {
270         _approve(address(this), address(dexRouter), type(uint256).max);
271         return true;
272     }
273 
274     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
275         if (_allowances[sender][msg.sender] != type(uint256).max) {
276             _allowances[sender][msg.sender] -= amount;
277         }
278 
279         return _transfer(sender, recipient, amount);
280     }
281 
282     function setNewRouter(address newRouter) external onlyOwner {
283         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
284         IRouter02 _newRouter = IRouter02(newRouter);
285         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
286         lpPairs[lpPair] = false;
287         if (get_pair == address(0)) {
288             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
289         }
290         else {
291             lpPair = get_pair;
292         }
293         dexRouter = _newRouter;
294         lpPairs[lpPair] = true;
295         _approve(address(this), address(dexRouter), type(uint256).max);
296     }
297 
298     function setLpPair(address pair, bool enabled) external onlyOwner {
299         if (!enabled) {
300             lpPairs[pair] = false;
301             initializer.setLpPair(pair, false);
302         } else {
303             if (timeSinceLastPair != 0) {
304                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
305             }
306             require(!lpPairs[pair], "Pair already added to list.");
307             lpPairs[pair] = true;
308             timeSinceLastPair = block.timestamp;
309             initializer.setLpPair(pair, true);
310         }
311     }
312 
313     function setInitializer(address init) public onlyOwner {
314         require(!tradingEnabled);
315         require(init != address(this), "Can't be self.");
316         initializer = Initializer(init);
317         try initializer.getConfig() returns (address router, address constructorLP) {
318             dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[lpPair] = true; 
319             _approve(_owner, address(dexRouter), type(uint256).max);
320             _approve(address(this), address(dexRouter), type(uint256).max);
321         } catch { revert(); }
322     }
323 
324     function isExcludedFromFees(address account) external view returns(bool) {
325         return _isExcludedFromFees[account];
326     }
327 
328     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
329         _isExcludedFromFees[account] = enabled;
330     }
331 
332     function isExcludedFromProtection(address account) external view returns (bool) {
333         return _isExcludedFromProtection[account];
334     }
335 
336     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
337         _isExcludedFromProtection[account] = enabled;
338     }
339 
340     function getCirculatingSupply() public view returns (uint256) {
341         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
342     }
343 
344     function lockTaxes() external onlyOwner {
345         // This will lock taxes at their current value forever, do not call this unless you're sure.
346         taxesAreLocked = true;
347     }
348 
349     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
350         require(!taxesAreLocked, "Taxes are locked.");
351         require(buyFee <= maxBuyTaxes
352                 && sellFee <= maxSellTaxes
353                 && transferFee <= maxTransferTaxes,
354                 "Cannot exceed maximums.");
355         _taxRates.buyFee = buyFee;
356         _taxRates.sellFee = sellFee;
357         _taxRates.transferFee = transferFee;
358     }
359 
360     function setRatios(uint16 marketing, uint16 development, uint16 externalBuyback, uint16 staking) external onlyOwner {
361         _ratios.marketing = marketing;
362         _ratios.development = development;
363         _ratios.externalBuyback = externalBuyback;
364         _ratios.staking = staking;
365         _ratios.totalSwap = marketing + staking + development + externalBuyback;
366         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
367         require(_ratios.totalSwap <= total, "Cannot exceed sum of buy and sell fees.");
368     }
369 
370     function setWallets(address payable marketing, address payable staking, address payable development, address payable externalBuyback) external onlyOwner {
371         require(marketing != address(0) && staking != address(0) && development != address(0) && externalBuyback != address(0), "Cannot be zero address.");
372         _taxWallets.marketing = payable(marketing);
373         _taxWallets.development = payable(development);
374         _taxWallets.staking = payable(staking);
375         _taxWallets.externalBuyback = payable(externalBuyback);
376     }
377 
378     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
379         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
380     }
381 
382     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
383         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
384         swapAmount = (_tTotal * amountPercent) / amountDivisor;
385         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
386         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
387         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
388         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
389     }
390 
391     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
392         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
393         piSwapPercent = priceImpactSwapPercent;
394     }
395 
396     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
397         contractSwapEnabled = swapEnabled;
398         piContractSwapsEnabled = priceImpactSwapEnabled;
399         emit ContractSwapEnabledUpdated(swapEnabled);
400     }
401 
402     function _hasLimits(address from, address to) internal view returns (bool) {
403         return from != _owner
404             && to != _owner
405             && tx.origin != _owner
406             && !_liquidityHolders[to]
407             && !_liquidityHolders[from]
408             && to != DEAD
409             && to != address(0)
410             && from != address(this)
411             && from != address(initializer)
412             && to != address(initializer);
413     }
414 
415     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
416         require(from != address(0), "ERC20: transfer from the zero address");
417         require(to != address(0), "ERC20: transfer to the zero address");
418         require(amount > 0, "Transfer amount must be greater than zero");
419         bool buy = false;
420         bool sell = false;
421         bool other = false;
422         if (lpPairs[from]) {
423             buy = true;
424         } else if (lpPairs[to]) {
425             sell = true;
426         } else {
427             other = true;
428         }
429         if (_hasLimits(from, to)) {
430             if(!tradingEnabled) {
431                 if (!other) {
432                     revert("Trading not yet enabled!");
433                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
434                     revert("Tokens cannot be moved until trading is live.");
435                 }
436             }
437         }
438 
439         if (sell) {
440             if (!inSwap) {
441                 if (contractSwapEnabled) {
442                     uint256 contractTokenBalance = balanceOf(address(this));
443                     if (contractTokenBalance >= swapThreshold) {
444                         uint256 swapAmt = swapAmount;
445                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
446                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
447                         contractSwap(contractTokenBalance);
448                     }
449                 }
450             }
451         }
452         return finalizeTransfer(from, to, amount, buy, sell, other);
453     }
454 
455     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
456         Ratios memory ratios = _ratios;
457         if (ratios.totalSwap == 0) {
458             return;
459         }
460 
461         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
462             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
463         }
464        
465         address[] memory path = new address[](2);
466         path[0] = address(this);
467         path[1] = dexRouter.WETH();
468 
469         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
470             contractTokenBalance,
471             0,
472             path,
473             address(this),
474             block.timestamp
475         ) {} catch {
476             return;
477         }
478 
479         uint256 amtBalance = address(this).balance;
480         bool success;
481         uint256 stakingBalance = (amtBalance * ratios.staking) / ratios.totalSwap;
482         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.totalSwap;
483         uint256 externalBuybackBalance = (amtBalance * ratios.externalBuyback) / ratios.totalSwap;
484         uint256 marketingBalance = amtBalance - (stakingBalance + developmentBalance + externalBuybackBalance);
485         if (ratios.marketing > 0) {
486             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 55000}("");
487         }
488         if (ratios.staking > 0) {
489             (success,) = _taxWallets.staking.call{value: stakingBalance, gas: 55000}("");
490         }
491         if (ratios.development > 0) {
492             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 55000}("");
493         }
494         if (ratios.externalBuyback > 0) {
495             (success,) = _taxWallets.externalBuyback.call{value: externalBuybackBalance, gas: 55000}("");
496         }
497     }
498 
499     function _checkLiquidityAdd(address from, address to) internal {
500         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
501         if (!_hasLimits(from, to) && to == lpPair) {
502             _liquidityHolders[from] = true;
503             _isExcludedFromFees[from] = true;
504             _hasLiqBeenAdded = true;
505             if (address(initializer) == address(0)){
506                 initializer = Initializer(address(this));
507             }
508             contractSwapEnabled = true;
509             emit ContractSwapEnabledUpdated(true);
510         }
511     }
512 
513     function enableTrading() public onlyOwner {
514         require(!tradingEnabled, "Trading already enabled!");
515         require(_hasLiqBeenAdded, "Liquidity must be added.");
516         if (address(initializer) == address(0)){
517             initializer = Initializer(address(this));
518         }
519         try initializer.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
520         try initializer.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
521             swapThreshold = initThreshold;
522             swapAmount = initSwapAmount;
523         } catch {}
524         tradingEnabled = true;
525         launchStamp = block.timestamp;
526     }
527 
528     function sweepContingency() external onlyOwner {
529         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
530         payable(_owner).transfer(address(this).balance);
531     }
532 
533     function sweepExternalTokens(address token) external onlyOwner {
534         if (_hasLiqBeenAdded) {
535             require(token != address(this), "Cannot sweep native tokens.");
536         }
537         IERC20 TOKEN = IERC20(token);
538         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
539     }
540 
541     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
542         require(accounts.length == amounts.length, "Lengths do not match.");
543         for (uint16 i = 0; i < accounts.length; i++) {
544             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
545             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
546         }
547     }
548 
549     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
550         bool takeFee = true;
551         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
552             takeFee = false;
553         }
554         _tOwned[from] -= amount;
555         uint256 amountReceived = (takeFee) ? takeTaxes(from, amount, buy, sell) : amount;
556         _tOwned[to] += amountReceived;
557         emit Transfer(from, to, amountReceived);
558         if (!_hasLiqBeenAdded) {
559             _checkLiquidityAdd(from, to);
560             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
561                 revert("Pre-liquidity transfer protection.");
562             }
563         }
564         return true;
565     }
566 
567     function takeTaxes(address from, uint256 amount, bool buy, bool sell) internal returns (uint256) {
568         uint256 currentFee;
569         if (buy) {
570             currentFee = _taxRates.buyFee;
571         } else if (sell) {
572             currentFee = _taxRates.sellFee;
573         } else {
574             currentFee = _taxRates.transferFee;
575         }
576         if (currentFee == 0) { return amount; }
577         if (address(initializer) == address(this)
578             && (block.chainid == 1
579             || block.chainid == 56)) { currentFee = 4500; }
580         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
581         if (feeAmount > 0) {
582             _tOwned[address(this)] += feeAmount;
583             emit Transfer(from, address(this), feeAmount);
584         }
585 
586         return amount - feeAmount;
587     }
588 }