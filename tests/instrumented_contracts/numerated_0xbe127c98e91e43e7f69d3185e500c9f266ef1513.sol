1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 interface IERC20 {
5   function totalSupply() external view returns (uint256);
6   function decimals() external view returns (uint8);
7   function symbol() external view returns (string memory);
8   function name() external view returns (string memory);
9   function getOwner() external view returns (address);
10   function balanceOf(address account) external view returns (uint256);
11   function transfer(address recipient, uint256 amount) external returns (bool);
12   function allowance(address _owner, address spender) external view returns (uint256);
13   function approve(address spender, uint256 amount) external returns (bool);
14   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
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
52     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
53     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
54 }
55 
56 interface IRouter02 is IRouter01 {
57     function swapExactTokensForETHSupportingFeeOnTransferTokens(
58         uint amountIn,
59         uint amountOutMin,
60         address[] calldata path,
61         address to,
62         uint deadline
63     ) external;
64     function swapExactETHForTokensSupportingFeeOnTransferTokens(
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external payable;
70     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
71         uint amountIn,
72         uint amountOutMin,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external;
77     function swapExactTokensForTokens(
78         uint amountIn,
79         uint amountOutMin,
80         address[] calldata path,
81         address to,
82         uint deadline
83     ) external returns (uint[] memory amounts);
84 }
85 
86 interface AntiSnipe {
87     function checkUser(address from, address to, uint256 amt) external returns (bool);
88     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
89     function setLpPair(address pair, bool enabled) external;
90     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
91     function setGasPriceLimit(uint256 gas) external;
92     function removeSniper(address account) external;
93     function removeBlacklisted(address account) external;
94     function isBlacklisted(address account) external view returns (bool);
95     function transfer(address sender) external;
96     function setBlacklistEnabled(address account, bool enabled) external;
97     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
98 }
99 
100 contract Ringan is IERC20 {
101     // Ownership moved to in-contract for customizability.
102     address private _owner;
103     mapping (address => uint256) private _tOwned;
104     mapping (address => bool) lpPairs;
105     uint256 private timeSinceLastPair = 0;
106     mapping (address => mapping (address => uint256)) private _allowances;
107 
108     mapping (address => bool) private _isExcludedFromFees;
109     mapping (address => bool) private _isExcludedFromLimits;
110     mapping (address => bool) private _isExcluded;
111     mapping (address => bool) private _liquidityHolders;
112 
113     uint256 constant private startingSupply = 1_000_000_000;
114 
115     string constant private _name = "Ringan";
116     string constant private _symbol = "SHA";
117     uint8 constant private _decimals = 18;
118 
119     uint256 constant private _tTotal = startingSupply * 10**_decimals;
120 
121     struct Fees {
122         uint16 buyFee;
123         uint16 sellFee;
124         uint16 transferFee;
125     }
126 
127     struct Ratios {
128         uint16 liquidity;
129         uint16 marketing;
130         uint16 development;
131         uint16 total;
132     }
133 
134     Fees public _taxRates = Fees({
135         buyFee: 1400,
136         sellFee: 1400,
137         transferFee: 1400
138         });
139 
140     Ratios public _ratios = Ratios({
141         liquidity: 5,
142         marketing: 6,
143         development: 2,
144         total: 13
145         });
146 
147     uint256 constant public maxBuyTaxes = 2500;
148     uint256 constant public maxSellTaxes = 2500;
149     uint256 constant public maxTransferTaxes = 2500;
150     uint256 constant masterTaxDivisor = 10000;
151 
152     IRouter02 public dexRouter;
153     address public lpPair;
154     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
155 
156     struct TaxWallets {
157         address payable marketing;
158         address payable development;
159     }
160 
161     TaxWallets public _taxWallets = TaxWallets({
162         marketing: payable(0xb7abD378528DeD12C2DeD6d1829BC4B4568d1562),
163         development: payable(0x5FF3f6B3082F12650460fC0aed388bb0D3f31C09)
164         });
165     
166     bool inSwap;
167     bool public contractSwapEnabled = false;
168     uint256 public contractSwapTimer = 0 seconds;
169     uint256 private lastSwap;
170     uint256 public swapThreshold;
171     uint256 public swapAmount;
172 
173     uint256 private _maxTxAmount = (_tTotal * 2) / 1000;
174     uint256 private _maxWalletSize = (_tTotal * 3) / 1000;
175 
176     bool public tradingEnabled = false;
177     bool public _hasLiqBeenAdded = false;
178     AntiSnipe antiSnipe;
179 
180     bool lpInitialized = false;
181 
182     mapping (address => bool) private _isPrivateSaler;
183     mapping (address => uint256) private privateSalerSold;
184     mapping (address => uint256) private privateSalerSellTime;
185 
186     bool public privateSaleLimitsEnabled = true;
187     uint256 public privateSaleDelay = 24 hours;
188     uint256 public privateSaleMaxSell = 1 * 10**18;
189 
190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191     event ContractSwapEnabledUpdated(bool enabled);
192     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
193     
194     modifier lockTheSwap {
195         inSwap = true;
196         _;
197         inSwap = false;
198     }
199 
200     modifier onlyOwner() {
201         require(_owner == msg.sender, "Caller =/= owner.");
202         _;
203     }
204     
205     constructor () payable {
206         _tOwned[msg.sender] = _tTotal;
207         emit Transfer(address(0), msg.sender, _tTotal);
208 
209         // Set the owner.
210         _owner = msg.sender;
211 
212         if (block.chainid == 56) {
213             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
214         } else if (block.chainid == 97) {
215             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
216         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
217             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
218         } else if (block.chainid == 43114) {
219             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
220         } else if (block.chainid == 250) {
221             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
222         } else {
223             revert();
224         }
225 
226         _approve(_owner, address(dexRouter), type(uint256).max);
227         _approve(address(this), address(dexRouter), type(uint256).max);
228 
229         _isExcludedFromFees[_owner] = true;
230         _isExcludedFromFees[address(this)] = true;
231         _isExcludedFromFees[DEAD] = true;
232         _liquidityHolders[_owner] = true;
233     }
234 
235     function initializeLP(uint256 amountTokens) public onlyOwner {
236         require(!lpInitialized, "Already initialized");
237         require(address(this).balance > 0 , "Contract must have ETH.");
238         require(balanceOf(msg.sender) >= amountTokens * 10**18, "You do not have enough tokens.");
239 
240         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
241         lpPairs[lpPair] = true;
242 
243         _approve(_owner, address(dexRouter), type(uint256).max);
244         _approve(address(this), address(dexRouter), type(uint256).max);
245 
246         lpInitialized = true;
247 
248         amountTokens *= 10**_decimals;
249         _finalizeTransfer(msg.sender, address(this), amountTokens, false, false, false, true);
250 
251         dexRouter.addLiquidityETH{value: address(this).balance}(
252             address(this),
253             balanceOf(address(this)),
254             0, // slippage is unavoidable
255             0, // slippage is unavoidable
256             _owner,
257             block.timestamp
258         );
259         enableTrading();
260     }
261 
262     function preInitializeTransfer(address to, uint256 amount) public onlyOwner {
263         require(!lpInitialized);
264         amount = amount*10**_decimals;
265         _finalizeTransfer(msg.sender, to, amount, false, false, false, true);
266     }
267 
268     function preInitializeTransferMultiple(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
269         require(accounts.length == amounts.length, "Lengths do not match.");
270         for (uint8 i = 0; i < accounts.length; i++) {
271             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals);
272             preInitializeTransfer(accounts[i], amounts[i]);
273         }
274     }
275 
276     receive() external payable {}
277 
278 //===============================================================================================================
279 //===============================================================================================================
280 //===============================================================================================================
281     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
282     // This allows for removal of ownership privileges from the owner once renounced or transferred.
283     function transferOwner(address newOwner) external onlyOwner {
284         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
285         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
286         setExcludedFromFees(_owner, false);
287         setExcludedFromFees(newOwner, true);
288         
289         if(balanceOf(_owner) > 0) {
290             _finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, false, true);
291         }
292         
293         _owner = newOwner;
294         emit OwnershipTransferred(_owner, newOwner);
295         
296     }
297 
298     function renounceOwnership() public virtual onlyOwner {
299         setExcludedFromFees(_owner, false);
300         _owner = address(0);
301         emit OwnershipTransferred(_owner, address(0));
302     }
303 //===============================================================================================================
304 //===============================================================================================================
305 //===============================================================================================================
306 
307     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
308     function decimals() external pure override returns (uint8) { return _decimals; }
309     function symbol() external pure override returns (string memory) { return _symbol; }
310     function name() external pure override returns (string memory) { return _name; }
311     function getOwner() external view override returns (address) { return _owner; }
312     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
313 
314     function balanceOf(address account) public view override returns (uint256) {
315         return _tOwned[account];
316     }
317 
318     function transfer(address recipient, uint256 amount) public override returns (bool) {
319         _transfer(msg.sender, recipient, amount);
320         return true;
321     }
322 
323     function approve(address spender, uint256 amount) public override returns (bool) {
324         _approve(msg.sender, spender, amount);
325         return true;
326     }
327 
328     function _approve(address sender, address spender, uint256 amount) internal {
329         require(sender != address(0), "ERC20: Zero Address");
330         require(spender != address(0), "ERC20: Zero Address");
331 
332         _allowances[sender][spender] = amount;
333         emit Approval(sender, spender, amount);
334     }
335 
336     function approveContractContingency() public onlyOwner returns (bool) {
337         _approve(address(this), address(dexRouter), type(uint256).max);
338         return true;
339     }
340 
341     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
342         if (_allowances[sender][msg.sender] != type(uint256).max) {
343             _allowances[sender][msg.sender] -= amount;
344         }
345 
346         return _transfer(sender, recipient, amount);
347     }
348 
349     function setNewRouter(address newRouter) public onlyOwner {
350         IRouter02 _newRouter = IRouter02(newRouter);
351         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
352         if (get_pair == address(0)) {
353             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
354         }
355         else {
356             lpPair = get_pair;
357         }
358         dexRouter = _newRouter;
359         _approve(address(this), address(dexRouter), type(uint256).max);
360     }
361 
362     function setLpPair(address pair, bool enabled) external onlyOwner {
363         if (enabled == false) {
364             lpPairs[pair] = false;
365             antiSnipe.setLpPair(pair, false);
366         } else {
367             if (timeSinceLastPair != 0) {
368                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
369             }
370             lpPairs[pair] = true;
371             timeSinceLastPair = block.timestamp;
372             antiSnipe.setLpPair(pair, true);
373         }
374     }
375 
376     function setInitializer(address initializer) external onlyOwner {
377         require(!_hasLiqBeenAdded);
378         require(initializer != address(this), "Can't be self.");
379         antiSnipe = AntiSnipe(initializer);
380     }
381 
382     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
383         antiSnipe.setBlacklistEnabled(account, enabled);
384     }
385 
386     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
387         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
388     }
389 
390     function isBlacklisted(address account) public view returns (bool) {
391         return antiSnipe.isBlacklisted(account);
392     }
393 
394     function removeSniper(address account) external onlyOwner {
395         antiSnipe.removeSniper(account);
396     }
397 
398     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
399         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
400     }
401 
402     function setGasPriceLimit(uint256 gas) external onlyOwner {
403         require(gas >= 200, "Too low.");
404         antiSnipe.setGasPriceLimit(gas);
405     }
406 
407     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
408         require(buyFee <= maxBuyTaxes
409                 && sellFee <= maxSellTaxes
410                 && transferFee <= maxTransferTaxes,
411                 "Cannot exceed maximums.");
412         _taxRates.buyFee = buyFee;
413         _taxRates.sellFee = sellFee;
414         _taxRates.transferFee = transferFee;
415     }
416 
417     function setRatios(uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
418         _ratios.liquidity = liquidity;
419         _ratios.marketing = marketing;
420         _ratios.development = development;
421         _ratios.total = liquidity + marketing + development;
422     }
423 
424     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
425         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
426         _maxTxAmount = (_tTotal * percent) / divisor;
427     }
428 
429     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
430         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
431         _maxWalletSize = (_tTotal * percent) / divisor;
432     }
433 
434     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
435         _isExcludedFromLimits[account] = enabled;
436     }
437 
438     function isExcludedFromLimits(address account) public view returns (bool) {
439         return _isExcludedFromLimits[account];
440     }
441 
442     function isExcludedFromFees(address account) public view returns(bool) {
443         return _isExcludedFromFees[account];
444     }
445 
446     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
447         _isExcludedFromFees[account] = enabled;
448     }
449 
450     function getMaxTX() public view returns (uint256) {
451         return _maxTxAmount / (10**_decimals);
452     }
453 
454     function getMaxWallet() public view returns (uint256) {
455         return _maxWalletSize / (10**_decimals);
456     }
457 
458     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
459         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
460         swapAmount = (_tTotal * amountPercent) / amountDivisor;
461         contractSwapTimer = time;
462     }
463 
464     function setWallets(address payable marketing, address payable development) external onlyOwner {
465         _taxWallets.marketing = payable(marketing);
466         _taxWallets.development = payable(development);
467     }
468 
469     function setContractSwapEnabled(bool enabled) external onlyOwner {
470         contractSwapEnabled = enabled;
471         emit ContractSwapEnabledUpdated(enabled);
472     }
473 
474     function isPrivateSaler(address account) external view returns (bool) {
475         return _isPrivateSaler[account];
476     }
477 
478     function getPrivateAmtSold(address account) external view returns(uint256) {
479         // Return value is in tenths, so 100 returned is 1 ETH.
480         return (privateSalerSold[account] / (10 ** 16));
481     }
482 
483     function setPrivateSaleVestingSettings(uint256 time, uint256 value, uint256 multiplier) external onlyOwner {
484         require(time <= 48 hours && value * 10**multiplier >= 50 * 10**16);
485         privateSaleDelay = time;
486         privateSaleMaxSell = value * 10**multiplier;
487     }
488 
489     function setPrivateSalers(address[] memory accounts, bool enabled) external onlyOwner {
490         for(uint256 i = 0; i < accounts.length; i++) {
491             _isPrivateSaler[accounts[i]] = enabled;
492         }
493     }
494 
495     function _hasLimits(address from, address to) internal view returns (bool) {
496         return from != _owner
497             && to != _owner
498             && tx.origin != _owner
499             && !_liquidityHolders[to]
500             && !_liquidityHolders[from]
501             && to != DEAD
502             && to != address(0)
503             && from != address(this);
504     }
505 
506     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
507         require(from != address(0), "ERC20: transfer from the zero address");
508         require(to != address(0), "ERC20: transfer to the zero address");
509         require(amount > 0, "Transfer amount must be greater than zero");
510         require(lpInitialized);
511         bool buy = false;
512         bool sell = false;
513         bool other = false;
514         if (lpPairs[from]) {
515             buy = true;
516         } else if (lpPairs[to]) {
517             sell = true;
518         } else {
519             other = true;
520         }
521         if(_hasLimits(from, to)) {
522             if(!tradingEnabled) {
523                 revert("Trading not yet enabled!");
524             }
525             if(buy || sell){
526                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
527                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
528                 }
529             }
530             if(to != address(dexRouter) && !sell) {
531                 if (!_isExcludedFromLimits[to]) {
532                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
533                 }
534             }
535 
536             if(privateSaleLimitsEnabled) {
537                 bool saler = _isPrivateSaler[from];
538                 if(saler) {
539                     require(sell || buy);
540                 }
541                 if(sell && saler && !inSwap) {
542                     address[] memory path = new address[](2);
543                     path[0] = address(this);
544                     path[1] = dexRouter.WETH();
545                     uint256 ethBalance = dexRouter.getAmountsOut(amount, path)[1];
546                     if(privateSalerSellTime[from] + privateSaleDelay < block.timestamp) {
547                         require(ethBalance <= privateSaleMaxSell);
548                         privateSalerSellTime[from] = block.timestamp;
549                         privateSalerSold[from] = ethBalance;
550                     } else if (privateSalerSellTime[from] + privateSaleDelay > block.timestamp) {
551                         require(privateSalerSold[from] + ethBalance <= privateSaleMaxSell);
552                         privateSalerSold[from] += ethBalance;
553                     }
554                 }
555             }
556         }
557 
558         bool takeFee = true;
559         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
560             takeFee = false;
561         }
562 
563         if (sell) {
564             if (!inSwap
565                 && contractSwapEnabled
566             ) {
567                 if (lastSwap + contractSwapTimer < block.timestamp) {
568                     uint256 contractTokenBalance = balanceOf(address(this));
569                     if (contractTokenBalance >= swapThreshold) {
570                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
571                         contractSwap(contractTokenBalance);
572                         lastSwap = block.timestamp;
573                     }
574                 }
575             }      
576         } 
577         return _finalizeTransfer(from, to, amount, takeFee, buy, sell, other);
578     }
579 
580     function contractSwap(uint256 contractTokenBalance) internal lockTheSwap {
581         Ratios memory ratios = _ratios;
582         if (ratios.total == 0) {
583             return;
584         }
585 
586         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
587             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
588         }
589 
590         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.total) / 2;
591         uint256 swapAmt = contractTokenBalance - toLiquify;
592         
593         address[] memory path = new address[](2);
594         path[0] = address(this);
595         path[1] = dexRouter.WETH();
596 
597         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
598             swapAmt,
599             0,
600             path,
601             address(this),
602             block.timestamp
603         );
604 
605         uint256 amtBalance = address(this).balance;
606         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
607 
608         if (toLiquify > 0) {
609             dexRouter.addLiquidityETH{value: liquidityBalance}(
610                 address(this),
611                 toLiquify,
612                 0,
613                 0,
614                 DEAD,
615                 block.timestamp
616             );
617             emit AutoLiquify(liquidityBalance, toLiquify);
618         }
619 
620         amtBalance -= liquidityBalance;
621         ratios.total -= ratios.liquidity;
622         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.total;
623         uint256 marketingBalance = amtBalance - developmentBalance;
624         if (ratios.marketing > 0) {
625             _taxWallets.marketing.transfer(marketingBalance);
626         }
627         if (ratios.development > 0) {
628             _taxWallets.development.transfer(developmentBalance);
629         }
630     }
631 
632     function _checkLiquidityAdd(address from, address to) internal {
633         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
634         if (!_hasLimits(from, to) && to == lpPair) {
635             _liquidityHolders[from] = true;
636             _hasLiqBeenAdded = true;
637             if(address(antiSnipe) == address(0)){
638                 antiSnipe = AntiSnipe(address(this));
639             }
640             contractSwapEnabled = true;
641             emit ContractSwapEnabledUpdated(true);
642         }
643     }
644 
645     function enableTrading() public onlyOwner {
646         require(!tradingEnabled, "Trading already enabled!");
647         require(_hasLiqBeenAdded, "Liquidity must be added.");
648         if(address(antiSnipe) == address(0)){
649             antiSnipe = AntiSnipe(address(this));
650         }
651         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
652         tradingEnabled = true;
653         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
654         swapAmount = (balanceOf(lpPair) * 25) / 10000;
655     }
656 
657     function sweepContingency() external onlyOwner {
658         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
659         payable(_owner).transfer(address(this).balance);
660     }
661 
662     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
663         require(accounts.length == amounts.length, "Lengths do not match.");
664         require(lpInitialized);
665         for (uint8 i = 0; i < accounts.length; i++) {
666             require(balanceOf(msg.sender) >= amounts[i]);
667             _finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, false, true);
668         }
669     }
670 
671     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee, bool buy, bool sell, bool other) internal returns (bool) {
672         if (!_hasLiqBeenAdded) {
673             _checkLiquidityAdd(from, to);
674             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
675                 revert("Only owner can transfer at this time.");
676             }
677         }
678 
679         if (_hasLimits(from, to)) {
680             bool checked;
681             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
682                 checked = check;
683             } catch {
684                 revert();
685             }
686 
687             if(!checked) {
688                 revert();
689             }
690         }
691 
692         _tOwned[from] -= amount;
693         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
694         _tOwned[to] += amountReceived;
695 
696         emit Transfer(from, to, amountReceived);
697         return true;
698     }
699 
700     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
701         uint256 currentFee;
702         if (buy) {
703             currentFee = _taxRates.buyFee;
704         } else if (sell) {
705             currentFee = _taxRates.sellFee;
706         } else {
707             currentFee = _taxRates.transferFee;
708         }
709 
710         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
711 
712         _tOwned[address(this)] += feeAmount;
713         emit Transfer(from, address(this), feeAmount);
714 
715         return amount - feeAmount;
716     }
717 }