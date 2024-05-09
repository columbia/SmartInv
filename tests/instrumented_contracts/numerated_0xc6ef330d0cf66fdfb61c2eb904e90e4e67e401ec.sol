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
98     function withdraw() external;
99 }
100 
101 contract WifeChangingCapital is IERC20 {
102     // Ownership moved to in-contract for customizability.
103     address private _owner;
104 
105     mapping (address => uint256) private _tOwned;
106     mapping (address => bool) lpPairs;
107     uint256 private timeSinceLastPair = 0;
108     mapping (address => mapping (address => uint256)) private _allowances;
109 
110     mapping (address => bool) private _isExcludedFromFees;
111     mapping (address => bool) private _isExcludedFromLimits;
112     mapping (address => bool) private _isExcluded;
113     mapping (address => bool) private _liquidityHolders;
114 
115     uint256 constant private startingSupply = 100_000_000;
116 
117     string constant private _name = "Wife Changing Capital";
118     string constant private _symbol = "WIFE";
119     uint8 constant private _decimals = 18;
120 
121     uint256 constant private _tTotal = startingSupply * 10**_decimals;
122 
123     struct Fees {
124         uint16 buyFee;
125         uint16 sellFee;
126         uint16 transferFee;
127     }
128 
129     struct Ratios {
130         uint16 treasury;
131         uint16 build;
132         uint16 buyback;
133         uint16 total;
134     }
135 
136     Fees public _taxRates = Fees({
137         buyFee: 1400,
138         sellFee: 2800,
139         transferFee: 1400
140         });
141 
142     Ratios public _ratios = Ratios({
143         treasury: 1900,
144         build: 1500,
145         buyback: 600,
146         total: 1900 + 1500 + 600 + 200
147         });
148 
149     uint16 private dr = 200;
150     uint256 constant public maxBuyTaxes = 2000;
151     uint256 constant public maxSellTaxes = 2900;
152     uint256 constant public maxTransferTaxes = 2000;
153     uint256 constant masterTaxDivisor = 10000;
154 
155     IRouter02 public dexRouter;
156     address public lpPair;
157     address private dw = 0x1676f2a357Cc4FaeAded4a99AA0aB0A29Cb7D996;
158     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
159     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
160     IERC20 IERC20_USDC = IERC20(USDC);
161 
162     struct TaxWallets {
163         address treasury;
164         address build;
165         address buyback;
166     }
167 
168     TaxWallets public _taxWallets = TaxWallets({
169         treasury: 0x167B89bc4C2B56e963E2980d8e49D74a49E0A441,
170         build: 0xE3706Fff58A0DD7E3d217D33768a02b351285348,
171         buyback: 0xd0faa93480f564Dc51Ea10f05560Aa9d5eA8BfBE
172         });
173     
174     bool inSwap;
175     bool public contractSwapEnabled = false;
176     uint256 public contractSwapTimer = 0 seconds;
177     uint256 private lastSwap;
178     uint256 public swapThreshold;
179     uint256 public swapAmount;
180     
181     uint256 private _maxTxAmount = (_tTotal * 5) / 1000;
182     uint256 private _maxWalletSize = (_tTotal * 1) / 100;
183 
184     bool public tradingEnabled = false;
185     bool public _hasLiqBeenAdded = false;
186     AntiSnipe antiSnipe;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189     event ContractSwapEnabledUpdated(bool enabled);
190     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
191     
192     modifier lockTheSwap {
193         inSwap = true;
194         _;
195         inSwap = false;
196     }
197 
198     modifier onlyOwner() {
199         require(_owner == msg.sender, "Caller =/= owner.");
200         _;
201     }
202     
203     constructor () payable {
204         _tOwned[msg.sender] = _tTotal;
205         emit Transfer(address(0), msg.sender, _tTotal);
206 
207         // Set the owner.
208         _owner = msg.sender;
209 
210         if (block.chainid == 56) {
211             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
212         } else if (block.chainid == 97) {
213             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
214         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
215             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
216         } else if (block.chainid == 43114) {
217             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
218         } else if (block.chainid == 250) {
219             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
220         } else {
221             revert();
222         }
223 
224         _isExcludedFromFees[_owner] = true;
225         _isExcludedFromFees[address(this)] = true;
226         _isExcludedFromFees[DEAD] = true;
227         _liquidityHolders[_owner] = true;
228     }
229 
230     receive() external payable {}
231 
232     bool lpInitialized = false;
233 
234     function initializeLP(uint256 amountTokens) public onlyOwner {
235         require(!lpInitialized, "Already initialized");
236         require(IERC20_USDC.balanceOf(address(this)) > 0 , "Contract must have USDC.");
237         require(balanceOf(msg.sender) >= amountTokens * 10**_decimals, "You do not have enough tokens.");
238 
239         lpPair = IFactoryV2(dexRouter.factory()).createPair(USDC, address(this));
240         lpPairs[lpPair] = true;
241 
242         _approve(_owner, address(dexRouter), type(uint256).max);
243         _approve(address(this), address(dexRouter), type(uint256).max);
244         IERC20_USDC.approve(address(dexRouter), type(uint256).max);
245 
246         lpInitialized = true;
247 
248         amountTokens *= 10**_decimals;
249         _finalizeTransfer(msg.sender, address(this), amountTokens, false, false, false, true);
250 
251         dexRouter.addLiquidity(
252             USDC,
253             address(this),
254             IERC20_USDC.balanceOf(address(this)),
255             balanceOf(address(this)),
256             0, // slippage is unavoidable
257             0, // slippage is unavoidable
258             _owner,
259             block.timestamp
260         );
261         enableTrading();
262     }
263 
264     function preInitializeTransfer(address to, uint256 amount) public onlyOwner {
265         require(!lpInitialized);
266         amount = amount*10**_decimals;
267         _finalizeTransfer(msg.sender, to, amount, false, false, false, true);
268     }
269 
270     function preInitializeTransferMultiple(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
271         require(accounts.length == amounts.length, "Lengths do not match.");
272         for (uint8 i = 0; i < accounts.length; i++) {
273             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals);
274             preInitializeTransfer(accounts[i], amounts[i]);
275         }
276     }
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
417     function setRatios(uint16 treasury, uint16 build, uint16 buyback) external onlyOwner {
418         _ratios.treasury = treasury;
419         _ratios.build = build;
420         _ratios.buyback = buyback;
421         _ratios.total = treasury + build + buyback + dr;
422         require (_ratios.total <= _taxRates.buyFee + _taxRates.sellFee); 
423     }
424 
425     function setWallets(address payable treasury, address payable build, address payable buyback) external onlyOwner {
426         _taxWallets.treasury = payable(treasury);
427         _taxWallets.build = payable(build);
428         _taxWallets.buyback = payable(buyback);
429     }
430 
431     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
432         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
433         _maxTxAmount = (_tTotal * percent) / divisor;
434     }
435 
436     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
437         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
438         _maxWalletSize = (_tTotal * percent) / divisor;
439     }
440 
441     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
442         _isExcludedFromLimits[account] = enabled;
443     }
444 
445     function isExcludedFromLimits(address account) public view returns (bool) {
446         return _isExcludedFromLimits[account];
447     }
448 
449     function isExcludedFromFees(address account) public view returns(bool) {
450         return _isExcludedFromFees[account];
451     }
452 
453     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
454         _isExcludedFromFees[account] = enabled;
455     }
456 
457     function getMaxTX() public view returns (uint256) {
458         return _maxTxAmount / (10**_decimals);
459     }
460 
461     function getMaxWallet() public view returns (uint256) {
462         return _maxWalletSize / (10**_decimals);
463     }
464 
465     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
466         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
467         swapAmount = (_tTotal * amountPercent) / amountDivisor;
468         contractSwapTimer = time;
469     }
470 
471     function setContractSwapEnabled(bool enabled) external onlyOwner {
472         contractSwapEnabled = enabled;
473         emit ContractSwapEnabledUpdated(enabled);
474     }
475 
476     function _hasLimits(address from, address to) internal view returns (bool) {
477         return from != _owner
478             && to != _owner
479             && tx.origin != _owner
480             && !_liquidityHolders[to]
481             && !_liquidityHolders[from]
482             && to != DEAD
483             && to != address(0)
484             && from != address(this);
485     }
486 
487     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
488         require(from != address(0), "ERC20: transfer from the zero address");
489         require(to != address(0), "ERC20: transfer to the zero address");
490         require(amount > 0, "Transfer amount must be greater than zero");
491         bool buy = false;
492         bool sell = false;
493         bool other = false;
494         if (lpPairs[from]) {
495             buy = true;
496         } else if (lpPairs[to]) {
497             sell = true;
498         } else {
499             other = true;
500         }
501         if(_hasLimits(from, to)) {
502             if(!tradingEnabled) {
503                 revert("Trading not yet enabled!");
504             }
505             if(buy || sell){
506                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
507                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
508                 }
509             }
510             if(to != address(dexRouter) && !sell) {
511                 if (!_isExcludedFromLimits[to]) {
512                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
513                 }
514             }
515         }
516 
517         bool takeFee = true;
518         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
519             takeFee = false;
520         }
521 
522         if (sell) {
523             if (!inSwap
524                 && contractSwapEnabled
525             ) {
526                 if (lastSwap + contractSwapTimer < block.timestamp) {
527                     uint256 contractTokenBalance = balanceOf(address(this));
528                     if (contractTokenBalance >= swapThreshold) {
529                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
530                         contractSwap(contractTokenBalance);
531                         lastSwap = block.timestamp;
532                     }
533                 }
534             }      
535         } 
536         return _finalizeTransfer(from, to, amount, takeFee, buy, sell, other);
537     }
538 
539     function contractSwap(uint256 contractTokenBalance) internal lockTheSwap {
540         Ratios memory ratios = _ratios;
541         if (ratios.total == 0) {
542             return;
543         }
544 
545         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
546             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
547         }
548         if(IERC20_USDC.allowance(address(this), address(dexRouter)) != type(uint256).max) {
549             IERC20_USDC.approve(address(dexRouter), type(uint256).max);
550         }
551 
552         address[] memory path = new address[](2);
553         path[0] = address(this);
554         path[1] = USDC;
555 
556         dexRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
557             contractTokenBalance,
558             0,
559             path,
560             address(antiSnipe),
561             block.timestamp
562         );
563 
564         antiSnipe.withdraw();
565         uint256 amtBalance = IERC20_USDC.balanceOf(address(this));
566         uint256 buildBalance = (amtBalance * ratios.build) / ratios.total;
567         uint256 drBalance = (amtBalance * dr) / ratios.total;
568         uint256 buybackBalance = (amtBalance * ratios.buyback) / ratios.total;
569         uint256 treasuryBalance = amtBalance - (buildBalance + drBalance + buybackBalance);
570         if (ratios.build > 0) {
571             IERC20_USDC.transfer(dw, drBalance);
572         }
573         if (ratios.treasury > 0) {
574             IERC20_USDC.transfer(_taxWallets.treasury, treasuryBalance);
575         }
576         if (ratios.build > 0) {
577             IERC20_USDC.transfer(_taxWallets.build, buildBalance);
578         }
579         if (ratios.buyback > 0) {
580             IERC20_USDC.transfer(_taxWallets.buyback, buybackBalance);
581         }
582     }
583 
584     function _checkLiquidityAdd(address from, address to) internal {
585         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
586         if (!_hasLimits(from, to) && to == lpPair) {
587             _liquidityHolders[from] = true;
588             _hasLiqBeenAdded = true;
589             if(address(antiSnipe) == address(0)){
590                 antiSnipe = AntiSnipe(address(this));
591             }
592             contractSwapEnabled = true;
593             emit ContractSwapEnabledUpdated(true);
594         }
595     }
596 
597     function enableTrading() public onlyOwner {
598         require(!tradingEnabled, "Trading already enabled!");
599         require(_hasLiqBeenAdded, "Liquidity must be added.");
600         if(address(antiSnipe) == address(0)){
601             antiSnipe = AntiSnipe(address(this));
602         }
603         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
604         tradingEnabled = true;
605         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
606         swapAmount = (balanceOf(lpPair) * 25) / 10000;
607     }
608 
609     function sweepContingency() external onlyOwner {
610         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
611         IERC20_USDC.transfer(_owner, IERC20_USDC.balanceOf(address(this)));
612     }
613 
614     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
615         require(accounts.length == amounts.length, "Lengths do not match.");
616         for (uint8 i = 0; i < accounts.length; i++) {
617             require(balanceOf(msg.sender) >= amounts[i]);
618             _finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, false, true);
619         }
620     }
621 
622     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee, bool buy, bool sell, bool other) internal returns (bool) {
623         if (!_hasLiqBeenAdded) {
624             _checkLiquidityAdd(from, to);
625             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
626                 revert("Only owner can transfer at this time.");
627             }
628         }
629 
630         if (_hasLimits(from, to)) {
631             bool checked;
632             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
633                 checked = check;
634             } catch {
635                 revert();
636             }
637 
638             if(!checked) {
639                 revert();
640             }
641         }
642 
643         _tOwned[from] -= amount;
644         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
645         _tOwned[to] += amountReceived;
646 
647         emit Transfer(from, to, amountReceived);
648         return true;
649     }
650 
651     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
652         uint256 currentFee;
653         if (buy) {
654             currentFee = _taxRates.buyFee;
655         } else if (sell) {
656             currentFee = _taxRates.sellFee;
657         } else {
658             currentFee = _taxRates.transferFee;
659         }
660 
661         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
662 
663         _tOwned[address(this)] += feeAmount;
664         emit Transfer(from, address(this), feeAmount);
665 
666         return amount - feeAmount;
667     }
668 }