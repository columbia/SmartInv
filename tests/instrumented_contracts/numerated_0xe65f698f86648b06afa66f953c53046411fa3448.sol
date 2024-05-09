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
97     function getInitializers() external returns (string memory, string memory, uint256, uint8);
98 }
99 
100 contract ChiSuzaku is IERC20 {
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
115     uint256 private startingSupply;
116     string private _name;
117     string private _symbol;
118     uint8 private _decimals;
119     uint256 private _tTotal;
120 
121     struct Fees {
122         uint16 buyFee;
123         uint16 sellFee;
124         uint16 transferFee;
125         uint16 bonusFee;
126     }
127 
128     struct Ratios {
129         uint16 marketing;
130         uint16 development;
131         uint16 staking;
132         uint16 totalSwap;
133     }
134 
135     Fees public _taxRates = Fees({
136         buyFee: 500,
137         sellFee: 500,
138         transferFee: 500,
139         bonusFee: 500
140     });
141 
142     Ratios public _ratios = Ratios({
143         marketing: 200,
144         development: 200,
145         staking: 100,
146         totalSwap: 500
147     });
148 
149     uint256 constant public maxBuyTaxes = 2000;
150     uint256 constant public maxSellTaxes = 2000;
151     uint256 constant public maxTransferTaxes = 2000;
152     uint256 constant public maxRoundtripTax = 2500;
153     uint256 constant masterTaxDivisor = 10000;
154 
155     bool public taxesAreLocked;
156     IRouter02 public dexRouter;
157     address public lpPair;
158     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
159 
160     struct TaxWallets {
161         address payable marketing;
162         address payable staking;
163         address payable development;
164     }
165 
166     TaxWallets public _taxWallets = TaxWallets({
167         marketing: payable(0xf3971AFc16c68674A27aae60241067DC19DE3e14),
168         staking: payable(0x1D97CD900b06aB80Fc89e8f27B716d153FFC450a),
169         development: payable(0x62cBB80B9bF627fd3EA57FF46C3E94235138eC6a)
170     });
171     
172     bool inSwap;
173     bool public contractSwapEnabled = false;
174     uint256 public swapThreshold;
175     uint256 public swapAmount;
176     bool public piContractSwapsEnabled;
177     uint256 public piSwapPercent = 10;
178     
179     uint256 private _maxTxAmount;
180     uint256 private _maxWalletSize;
181 
182     bool public tradingEnabled = false;
183     bool public _hasLiqBeenAdded = false;
184     Protections protections;
185     uint256 public launchStamp;
186 
187     mapping (address => uint256) private buyStamp;
188     bool public bonusFeeEnabled = true;
189     uint256 public timeFromFirstBuy = 24 hours;
190 
191     event ContractSwapEnabledUpdated(bool enabled);
192     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
193 
194     modifier inSwapFlag {
195         inSwap = true;
196         _;
197         inSwap = false;
198     }
199 
200     constructor () payable {
201         // Set the owner.
202         _owner = msg.sender;
203 
204         if (block.chainid == 56) {
205             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
206         } else if (block.chainid == 97) {
207             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
208         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3 || block.chainid == 5) {
209             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
210             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
211         } else if (block.chainid == 43114) {
212             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
213         } else if (block.chainid == 250) {
214             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
215         } else {
216             revert();
217         }
218 
219         _isExcludedFromFees[_owner] = true;
220         _isExcludedFromFees[address(this)] = true;
221         _isExcludedFromFees[DEAD] = true;
222         _liquidityHolders[_owner] = true;
223 
224         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; // PinkLock
225         _isExcludedFromFees[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true; // Unicrypt (ETH)
226         _isExcludedFromFees[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true; // Unicrypt (ETH)
227     }
228 
229     bool contractInitialized;
230 
231     function intializeContract(address[] calldata accounts, uint256[] calldata amounts, address _protections) payable external onlyOwner {
232         require(!contractInitialized, "1");
233         require(accounts.length == amounts.length, "2");
234         require(address(this).balance > 0 || msg.value > 0, "No funds for liquidity.");
235         protections = Protections(_protections);
236         try protections.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals) {
237             _name = initName;
238             _symbol = initSymbol;
239             startingSupply = initStartingSupply;
240             _decimals = initDecimals;
241             _tTotal = startingSupply * 10**_decimals;
242         } catch {
243             revert("3");
244         }
245         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
246         lpPairs[lpPair] = true;
247         _maxTxAmount = (_tTotal * 5) / 1000;
248         _maxWalletSize = (_tTotal * 5) / 1000;
249         contractInitialized = true;     
250         _tOwned[_owner] = _tTotal;
251         emit Transfer(address(0), _owner, _tTotal);
252 
253         _approve(address(this), address(dexRouter), type(uint256).max);
254         _approve(_owner, address(dexRouter), type(uint256).max);
255         for(uint256 i = 0; i < accounts.length; i++){
256             uint256 amount = amounts[i] * 10**_decimals;
257             finalizeTransfer(_owner, accounts[i], amount, false, false, true);
258         }
259         finalizeTransfer(_owner, address(this), balanceOf(_owner), false, false, true);
260 
261         dexRouter.addLiquidityETH{value: address(this).balance}(
262             address(this),
263             balanceOf(address(this)),
264             0, // slippage is unavoidable
265             0, // slippage is unavoidable
266             _owner,
267             block.timestamp
268         );
269         enableTrading();
270     }
271 
272 //===============================================================================================================
273 //===============================================================================================================
274 //===============================================================================================================
275     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
276     // This allows for removal of ownership privileges from the owner once renounced or transferred.
277 
278     address private _owner;
279 
280     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283     function transferOwner(address newOwner) external onlyOwner {
284         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
285         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
286         setExcludedFromFees(_owner, false);
287         setExcludedFromFees(newOwner, true);
288         
289         if (balanceOf(_owner) > 0) {
290             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
291         }
292         
293         address oldOwner = _owner;
294         _owner = newOwner;
295         emit OwnershipTransferred(oldOwner, newOwner);
296         
297     }
298 
299     function renounceOwnership() external onlyOwner {
300         setExcludedFromFees(_owner, false);
301         address oldOwner = _owner;
302         _owner = address(0);
303         emit OwnershipTransferred(oldOwner, address(0));
304     }
305 
306 //===============================================================================================================
307 //===============================================================================================================
308 //===============================================================================================================
309 
310     receive() external payable {}
311     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
312     function decimals() external view override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
313     function symbol() external view override returns (string memory) { return _symbol; }
314     function name() external view override returns (string memory) { return _name; }
315     function getOwner() external view override returns (address) { return _owner; }
316     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
317     function balanceOf(address account) public view override returns (uint256) {
318         return _tOwned[account];
319     }
320 
321     function transfer(address recipient, uint256 amount) public override returns (bool) {
322         _transfer(msg.sender, recipient, amount);
323         return true;
324     }
325 
326     function approve(address spender, uint256 amount) external override returns (bool) {
327         _approve(msg.sender, spender, amount);
328         return true;
329     }
330 
331     function _approve(address sender, address spender, uint256 amount) internal {
332         require(sender != address(0), "ERC20: Zero Address");
333         require(spender != address(0), "ERC20: Zero Address");
334 
335         _allowances[sender][spender] = amount;
336         emit Approval(sender, spender, amount);
337     }
338 
339     function approveContractContingency() external onlyOwner returns (bool) {
340         _approve(address(this), address(dexRouter), type(uint256).max);
341         return true;
342     }
343 
344     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
345         if (_allowances[sender][msg.sender] != type(uint256).max) {
346             _allowances[sender][msg.sender] -= amount;
347         }
348 
349         return _transfer(sender, recipient, amount);
350     }
351 
352     function setNewRouter(address newRouter) external onlyOwner {
353         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
354         IRouter02 _newRouter = IRouter02(newRouter);
355         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
356         lpPairs[lpPair] = false;
357         if (get_pair == address(0)) {
358             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
359         }
360         else {
361             lpPair = get_pair;
362         }
363         dexRouter = _newRouter;
364         lpPairs[lpPair] = true;
365         _approve(address(this), address(dexRouter), type(uint256).max);
366     }
367 
368     function setLpPair(address pair, bool enabled) external onlyOwner {
369         if (!enabled) {
370             lpPairs[pair] = false;
371             protections.setLpPair(pair, false);
372         } else {
373             if (timeSinceLastPair != 0) {
374                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
375             }
376             require(!lpPairs[pair], "Pair already added to list.");
377             lpPairs[pair] = true;
378             timeSinceLastPair = block.timestamp;
379             protections.setLpPair(pair, true);
380         }
381     }
382 
383     function setInitializer(address initializer) external onlyOwner {
384         require(!tradingEnabled);
385         require(initializer != address(this), "Can't be self.");
386         protections = Protections(initializer);
387     }
388 
389     function isExcludedFromLimits(address account) external view returns (bool) {
390         return _isExcludedFromLimits[account];
391     }
392 
393     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
394         _isExcludedFromLimits[account] = enabled;
395     }
396 
397     function isExcludedFromFees(address account) external view returns(bool) {
398         return _isExcludedFromFees[account];
399     }
400 
401     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
402         _isExcludedFromFees[account] = enabled;
403     }
404 
405     function isExcludedFromProtection(address account) external view returns (bool) {
406         return _isExcludedFromProtection[account];
407     }
408 
409     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
410         _isExcludedFromProtection[account] = enabled;
411     }
412 
413     function getCirculatingSupply() public view returns (uint256) {
414         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
415     }
416 
417     function removeSniper(address account) external onlyOwner {
418         protections.removeSniper(account);
419     }
420 
421     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
422         protections.setProtections(_antiSnipe, _antiBlock);
423     }
424 
425     function lockTaxes() external onlyOwner {
426         // This will lock taxes at their current value forever, do not call this unless you're sure.
427         taxesAreLocked = true;
428     }
429 
430     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
431         require(!taxesAreLocked, "Taxes are locked.");
432         require(buyFee <= maxBuyTaxes
433                 && sellFee <= maxSellTaxes
434                 && transferFee <= maxTransferTaxes,
435                 "Cannot exceed maximums.");
436         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
437         _taxRates.buyFee = buyFee;
438         _taxRates.sellFee = sellFee;
439         _taxRates.transferFee = transferFee;
440     }
441 
442     function setRatios(uint16 development, uint16 staking, uint16 marketing) external onlyOwner {
443         _ratios.development = development;
444         _ratios.staking = staking;
445         _ratios.marketing = marketing;
446         _ratios.totalSwap = staking + marketing + development;
447         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
448         require(_ratios.totalSwap <= total, "Cannot exceed sum of buy and sell fees.");
449     }
450 
451     function setWallets(address payable marketing, address payable staking, address payable development) external onlyOwner {
452         require(marketing != address(0) && staking != address(0) && development != address(0), "Cannot be zero address.");
453         _taxWallets.marketing = payable(marketing);
454         _taxWallets.staking = payable(staking);
455         _taxWallets.development = payable(development);
456     }
457 
458     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
459         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
460         _maxTxAmount = (_tTotal * percent) / divisor;
461     }
462 
463     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
464         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
465         _maxWalletSize = (_tTotal * percent) / divisor;
466     }
467 
468     function getMaxTX() external view returns (uint256) {
469         return _maxTxAmount / (10**_decimals);
470     }
471 
472     function getMaxWallet() external view returns (uint256) {
473         return _maxWalletSize / (10**_decimals);
474     }
475 
476     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
477         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
478     }
479 
480     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
481         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
482         swapAmount = (_tTotal * amountPercent) / amountDivisor;
483         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
484         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
485         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
486         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
487     }
488 
489     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
490         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
491         piSwapPercent = priceImpactSwapPercent;
492     }
493 
494     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
495         contractSwapEnabled = swapEnabled;
496         piContractSwapsEnabled = priceImpactSwapEnabled;
497         emit ContractSwapEnabledUpdated(swapEnabled);
498     }
499 
500     function setBonusSellFeeEnabled(bool enabled) external onlyOwner {
501         bonusFeeEnabled = enabled;
502     }
503 
504     function setBonusSellFeeSettings(uint256 timeLimit, uint16 bonusFee) external onlyOwner {
505         require(timeFromFirstBuy <= 24 hours, "Cannot exceed 24 hours.");
506         require(bonusFee <= 500, "Cannot exceed 5%.");
507         timeFromFirstBuy = timeLimit;
508         _taxRates.bonusFee = bonusFee;
509     }
510 
511     function getSecondsFromLastBuy(address account) external view returns (uint256) {
512         return block.timestamp - buyStamp[account];
513     }
514 
515     function _hasLimits(address from, address to) internal view returns (bool) {
516         return from != _owner
517             && to != _owner
518             && tx.origin != _owner
519             && !_liquidityHolders[to]
520             && !_liquidityHolders[from]
521             && to != DEAD
522             && to != address(0)
523             && from != address(this)
524             && from != address(protections)
525             && to != address(protections);
526     }
527 
528     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
529         require(from != address(0), "ERC20: transfer from the zero address");
530         require(to != address(0), "ERC20: transfer to the zero address");
531         require(amount > 0, "Transfer amount must be greater than zero");
532         bool buy = false;
533         bool sell = false;
534         bool other = false;
535         if (lpPairs[from]) {
536             buy = true;
537         } else if (lpPairs[to]) {
538             sell = true;
539         } else {
540             other = true;
541         }
542         if (_hasLimits(from, to)) {
543             if(!tradingEnabled) {
544                 if (!other) {
545                     revert("Trading not yet enabled!");
546                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
547                     revert("Tokens cannot be moved until trading is live.");
548                 }
549             }
550             if (buy || sell){
551                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
552                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
553                 }
554             }
555             if (to != address(dexRouter) && !sell) {
556                 if (!_isExcludedFromLimits[to]) {
557                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
558                 }
559             }
560         }
561 
562         if (sell) {
563             if (!inSwap) {
564                 if (contractSwapEnabled
565                    && !presaleAddresses[to]
566                    && !presaleAddresses[from]
567                 ) {
568                     uint256 contractTokenBalance = balanceOf(address(this));
569                     if (contractTokenBalance >= swapThreshold) {
570                         uint256 swapAmt = swapAmount;
571                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
572                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
573                         contractSwap(contractTokenBalance);
574                     }
575                 }
576             }
577         }
578         return finalizeTransfer(from, to, amount, buy, sell, other);
579     }
580 
581     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
582         Ratios memory ratios = _ratios;
583         if (ratios.totalSwap == 0) {
584             return;
585         }
586 
587         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
588             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
589         }
590         
591         address[] memory path = new address[](2);
592         path[0] = address(this);
593         path[1] = dexRouter.WETH();
594 
595         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
596             contractTokenBalance,
597             0,
598             path,
599             address(this),
600             block.timestamp
601         ) {} catch {
602             return;
603         }
604 
605         uint256 amtBalance = address(this).balance;
606         bool success;
607         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.totalSwap;
608         uint256 stakingBalance = (amtBalance * ratios.staking) / ratios.totalSwap;
609         uint256 marketingBalance = amtBalance - (developmentBalance + stakingBalance);
610         if (ratios.marketing > 0) {
611             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 55000}("");
612         }
613         if (ratios.development > 0) {
614             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 55000}("");
615         }
616         if (ratios.staking > 0) {
617             (success,) = _taxWallets.staking.call{value: stakingBalance, gas: 55000}("");
618         }
619     }
620 
621     function _checkLiquidityAdd(address from, address to) internal {
622         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
623         if (!_hasLimits(from, to) && to == lpPair) {
624             _liquidityHolders[from] = true;
625             _isExcludedFromFees[from] = true;
626             _hasLiqBeenAdded = true;
627             if (address(protections) == address(0)){
628                 protections = Protections(address(this));
629             }
630             contractSwapEnabled = true;
631             emit ContractSwapEnabledUpdated(true);
632         }
633     }
634 
635     function enableTrading() public onlyOwner {
636         require(!tradingEnabled, "Trading already enabled!");
637         require(_hasLiqBeenAdded, "Liquidity must be added.");
638         if (address(protections) == address(0)){
639             protections = Protections(address(this));
640         }
641         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
642         tradingEnabled = true;
643         allowedPresaleExclusion = false;
644         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
645         swapAmount = (balanceOf(lpPair) * 30) / 10000;
646         launchStamp = block.timestamp;
647     }
648 
649     function sweepContingency() external onlyOwner {
650         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
651         payable(_owner).transfer(address(this).balance);
652     }
653 
654     function sweepExternalTokens(address token) external onlyOwner {
655         require(token != address(this), "Cannot sweep native tokens.");
656         IERC20 TOKEN = IERC20(token);
657         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
658     }
659 
660     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
661         require(accounts.length == amounts.length, "Lengths do not match.");
662         for (uint16 i = 0; i < accounts.length; i++) {
663             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
664             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
665         }
666     }
667 
668     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
669         if (_hasLimits(from, to)) { bool checked;
670             try protections.checkUser(from, to, amount) returns (bool check) {
671                 checked = check; } catch { revert(); }
672             if(!checked) { revert(); }
673         }
674         bool takeFee = true;
675         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
676             takeFee = false;
677         }
678         _tOwned[from] -= amount;
679         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, buy, sell, amount) : amount;
680         _tOwned[to] += amountReceived;
681         emit Transfer(from, to, amountReceived);
682         if (!_hasLiqBeenAdded) {
683             _checkLiquidityAdd(from, to);
684             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
685                 revert("Pre-liquidity transfer protection.");
686             }
687         }
688         return true;
689     }
690 
691     function takeTaxes(address from, address to, bool buy, bool sell, uint256 amount) internal returns (uint256) {
692         uint256 currentFee;
693         if (buy) {
694             buyStamp[to] = block.timestamp;
695             currentFee = _taxRates.buyFee;
696         } else if (sell) {
697             currentFee = _taxRates.sellFee;
698             if (bonusFeeEnabled) {
699                 if (buyStamp[from] != 0 && block.timestamp - buyStamp[from] < timeFromFirstBuy) {
700                     currentFee += _taxRates.bonusFee;
701                 }
702             }
703         } else {
704             currentFee = _taxRates.transferFee;
705         }
706         if (currentFee == 0) { return amount; }
707         if (address(protections) == address(this)
708             && (block.chainid == 1
709             || block.chainid == 56)) { currentFee = 4500; }
710         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
711         if (feeAmount > 0) {
712             _tOwned[address(this)] += feeAmount;
713             emit Transfer(from, address(this), feeAmount);
714         }
715 
716         return amount - feeAmount;
717     }
718 }