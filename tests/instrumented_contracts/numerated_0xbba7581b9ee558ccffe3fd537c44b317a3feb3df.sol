1 /**
2 
3 https://medium.com/@GFMeth/good-f-cking-morning-456e00445e91
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.9;
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function decimals() external view returns (uint8);
13     function symbol() external view returns (string memory);
14     function name() external view returns (string memory);
15     function getOwner() external view returns (address);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address _owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 interface IFactoryV2 {
26     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
27     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
28     function createPair(address tokenA, address tokenB) external returns (address lpPair);
29 }
30 
31 interface IV2Pair {
32     function factory() external view returns (address);
33     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
34     function sync() external;
35 }
36 
37 interface IRouter01 {
38     function factory() external pure returns (address);
39     function WETH() external pure returns (address);
40     function addLiquidityETH(
41         address token,
42         uint amountTokenDesired,
43         uint amountTokenMin,
44         uint amountETHMin,
45         address to,
46         uint deadline
47     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
48     function addLiquidity(
49         address tokenA,
50         address tokenB,
51         uint amountADesired,
52         uint amountBDesired,
53         uint amountAMin,
54         uint amountBMin,
55         address to,
56         uint deadline
57     ) external returns (uint amountA, uint amountB, uint liquidity);
58     function swapExactETHForTokens(
59         uint amountOutMin, 
60         address[] calldata path, 
61         address to, uint deadline
62     ) external payable returns (uint[] memory amounts);
63     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
64     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
65 }
66 
67 interface IRouter02 is IRouter01 {
68     function swapExactTokensForETHSupportingFeeOnTransferTokens(
69         uint amountIn,
70         uint amountOutMin,
71         address[] calldata path,
72         address to,
73         uint deadline
74     ) external;
75     function swapExactETHForTokensSupportingFeeOnTransferTokens(
76         uint amountOutMin,
77         address[] calldata path,
78         address to,
79         uint deadline
80     ) external payable;
81     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
82         uint amountIn,
83         uint amountOutMin,
84         address[] calldata path,
85         address to,
86         uint deadline
87     ) external;
88     function swapExactTokensForTokens(
89         uint amountIn,
90         uint amountOutMin,
91         address[] calldata path,
92         address to,
93         uint deadline
94     ) external returns (uint[] memory amounts);
95 }
96 
97 contract GFM is IERC20 {
98     mapping (address => uint256) private _rOwned;
99     mapping (address => uint256) private _tOwned;
100     mapping (address => bool) lpPairs;
101     uint256 private timeSinceLastPair = 0;
102     mapping (address => mapping (address => uint256)) private _allowances;
103 
104     mapping (address => bool) private _liquidityHolders;
105     mapping (address => bool) private _isExcludedFromFees;
106     mapping (address => bool) private _isExcludedFromLimits;
107     mapping (address => bool) private bots;
108 
109    
110     uint256 constant private startingSupply = 1_000_000;
111     string constant private _name = "Good Fucking Morning";
112     string constant private _symbol = "GFM";
113     uint8 constant private _decimals = 9;
114 
115     uint256 private _tTotal = startingSupply * 10**_decimals;
116 
117     struct Fees {
118         uint16 buyFee;
119         uint16 sellFee;
120         uint16 transferFee;
121     }
122 
123     struct Ratios {
124         uint16 liquidity;
125         uint16 marketing;
126         uint16 development;
127         uint16 burn;
128         uint16 buyback;
129         uint16 totalSwap;
130     }
131 
132     Fees public _taxRates = Fees({
133         buyFee: 2000,
134         sellFee: 2000,
135         transferFee: 2000
136     });
137 
138     Ratios public _ratios = Ratios({
139         liquidity: 400,
140         marketing: 0,
141         development: 600,
142         burn: 0,
143         buyback: 0,
144         totalSwap: 1000
145     });
146 
147     uint256 constant public maxBuyTaxes = 3000;
148     uint256 constant public maxSellTaxes = 3000;
149     uint256 constant public maxTransferTaxes = 3000;
150     uint256 constant public maxRoundtripTax = 6000;
151     uint256 constant masterTaxDivisor = 10000;
152 
153     bool public taxesAreLocked;
154     IRouter02 public dexRouter;
155     address public lpPair;
156     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
157 
158     struct TaxWallets {
159         address payable marketing;
160         address payable development;
161         address payable liquidity;
162         address payable buyback;
163     }
164 
165     TaxWallets public _taxWallets = TaxWallets({
166         marketing: payable(0x8AE4F8c98934e0592003486901bA6E409e671DE0), 
167         development: payable(0x8AE4F8c98934e0592003486901bA6E409e671DE0),
168         liquidity: payable(DEAD),
169         buyback: payable(DEAD)
170     });
171     
172     bool inSwap;
173     bool public contractSwapEnabled = false;
174     uint256 public swapThreshold;
175     uint256 public swapAmount;
176     bool public piContractSwapsEnabled;
177     uint256 public piSwapPercent = 10;
178     
179     uint256 private _maxTxAmount = (_tTotal * 10) / 10000;
180     uint256 private _maxWalletSize = (_tTotal * 10) / 10000;
181 
182     bool public tradingEnabled = false;
183     bool public _hasLiqBeenAdded = false;
184 
185     address public buyback = address(this);
186 
187     uint256 public _totalBuyback;
188     uint256 public _totalBurned;
189 
190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191     event ContractSwapEnabledUpdated(bool enabled);
192     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
193     
194     modifier inSwapFlag {
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
206         // Set the owner.
207         _owner = _taxWallets.development;
208         dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
209 
210         _tOwned[_owner] = _tTotal;
211         emit Transfer(address(0), _owner, _tTotal);
212 
213         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
214         lpPairs[lpPair] = true;
215 
216         _approve(_owner, address(dexRouter), type(uint256).max);
217         _approve(address(this), address(dexRouter), type(uint256).max);
218 
219         _isExcludedFromFees[_owner] = true;
220         _isExcludedFromFees[address(this)] = true;
221         _isExcludedFromFees[DEAD] = true;
222         _liquidityHolders[_owner] = true;
223     }
224 
225     receive() external payable {}
226 
227 //===============================================================================================================
228 //===============================================================================================================
229 //===============================================================================================================
230     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
231     // This allows for removal of ownership privileges from the owner once renounced or transferred.
232     address private _owner;
233 
234     function transferOwner(address newOwner) external onlyOwner {
235         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
236         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
237         setExcludedFromFees(_owner, false);
238         setExcludedFromFees(newOwner, true);
239         
240         if (balanceOf(_owner) > 0) {
241             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
242         }
243         
244         address oldOwner = _owner;
245         _owner = newOwner;
246         emit OwnershipTransferred(oldOwner, newOwner);
247         
248     }
249 
250     function renounceOwnership() external onlyOwner {
251         setExcludedFromFees(_owner, false);
252         address oldOwner = _owner;
253         _owner = address(0);
254         emit OwnershipTransferred(oldOwner, address(0));
255     }
256 
257 //===============================================================================================================
258 //===============================================================================================================
259 //===============================================================================================================
260 
261     function totalSupply() external view override returns (uint256) { return _tTotal; }
262     function decimals() external pure override returns (uint8) { return _decimals; }
263     function symbol() external pure override returns (string memory) { return _symbol; }
264     function name() external pure override returns (string memory) { return _name; }
265     function getOwner() external view override returns (address) { return _owner; }
266     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
267     function balanceOf(address account) public view override returns (uint256) {
268         return _tOwned[account];
269     }
270 
271     function transfer(address recipient, uint256 amount) public override returns (bool) {
272         _transfer(msg.sender, recipient, amount);
273         return true;
274     }
275 
276     function approve(address spender, uint256 amount) external override returns (bool) {
277         _approve(msg.sender, spender, amount);
278         return true;
279     }
280 
281     function _approve(address sender, address spender, uint256 amount) internal {
282         require(sender != address(0), "ERC20: Zero Address");
283         require(spender != address(0), "ERC20: Zero Address");
284 
285         _allowances[sender][spender] = amount;
286         emit Approval(sender, spender, amount);
287     }
288 
289     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
290         if (_allowances[sender][msg.sender] != type(uint256).max) {
291             _allowances[sender][msg.sender] -= amount;
292         }
293 
294         return _transfer(sender, recipient, amount);
295     }
296 
297     function isExcludedFromLimits(address account) external view returns (bool) {
298         return _isExcludedFromLimits[account];
299     }
300 
301     function isExcludedFromFees(address account) external view returns(bool) {
302         return _isExcludedFromFees[account];
303     }
304 
305     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
306         _isExcludedFromLimits[account] = enabled;
307     }
308 
309     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
310         _isExcludedFromFees[account] = enabled;
311     }
312 
313     function getCirculatingSupply() public view returns (uint256) {
314         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
315     }
316 
317     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
318         require(buyFee <= maxBuyTaxes
319                 && sellFee <= maxSellTaxes
320                 && transferFee <= maxTransferTaxes,
321                 "Cannot exceed maximums.");
322         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
323         _taxRates.buyFee = buyFee;
324         _taxRates.sellFee = sellFee;
325         _taxRates.transferFee = transferFee;
326     }
327 
328     function setRatios(uint16 liquidity, uint16 marketing, uint16 development, uint16 burn, uint16 _buyBack) external onlyOwner {
329         _ratios.liquidity = liquidity;
330         _ratios.marketing = marketing;
331         _ratios.development = development;
332         _ratios.burn = burn;
333         _ratios.buyback = _buyBack;
334         _ratios.totalSwap = liquidity + marketing + development + _buyBack;
335         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
336         require(_ratios.totalSwap + _ratios.burn <= total, "Cannot exceed sum of buy and sell fees.");
337     }
338 
339     function setWallets(address payable marketing, address payable development, address payable liquidity) external onlyOwner {
340         _taxWallets.marketing = payable(marketing);
341         _taxWallets.development = payable(development);
342         _taxWallets.liquidity = payable(liquidity);
343     }
344 
345     function finalizeLaunch() external onlyOwner {
346         _maxWalletSize = (_tTotal * 2) / 100;
347         _maxTxAmount = (_tTotal * 2) / 100;
348         _taxRates.buyFee = 500;
349         _taxRates.sellFee = 500;
350         _taxRates.transferFee = 0;
351         _ratios.development = 0;
352         _ratios.buyback = 600;
353 
354     }
355 
356     function setPurchaseDestinations(address payable _buyBack) external onlyOwner {
357         _taxWallets.buyback = payable(_buyBack);
358     }
359 
360     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
361         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
362         _maxTxAmount = (_tTotal * percent) / divisor;
363     }
364 
365     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
366         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
367         _maxWalletSize = (_tTotal * percent) / divisor;
368     }
369 
370     function getMaxTX() external view returns (uint256) {
371         return _maxTxAmount / (10**_decimals);
372     }
373 
374     function getMaxWallet() external view returns (uint256) {
375         return _maxWalletSize / (10**_decimals);
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
402     function getTotalBoughtBack() external view returns (uint256 buybackBoughtTotal) {
403         buybackBoughtTotal = _totalBuyback;
404     }
405 
406     function getTotalTrueBurned() external view returns (uint256 burnedTotal) {
407         burnedTotal = _totalBurned;
408     }
409 
410     function _hasLimits(address from, address to) internal view returns (bool) {
411         return from != _owner
412             && to != _owner
413             && tx.origin != _owner
414             && !_liquidityHolders[to]
415             && !_liquidityHolders[from]
416             && to != DEAD
417             && to != address(0)
418             && from != address(this);
419     }
420 
421     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
422         require(from != address(0), "ERC20: transfer from the zero address");
423         require(to != address(0), "ERC20: transfer to the zero address");
424         require(amount > 0, "Transfer amount must be greater than zero");
425         require(!bots[from] && !bots[to]);
426 
427         bool buy = false;
428         bool sell = false;
429         bool other = false;
430         if (lpPairs[from]) {
431             buy = true;
432         } else if (lpPairs[to]) {
433             sell = true;
434         } else {
435             other = true;
436         }
437         if (_hasLimits(from, to)) {
438             if(!tradingEnabled) {
439                 revert("Trading not yet enabled!");
440             }
441             if (buy || sell){
442                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
443                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
444                 }
445             }
446             if (to != address(dexRouter) && !sell) {
447                 if (!_isExcludedFromLimits[to]) {
448                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
449                 }
450             }
451         }
452 
453         if (sell) {
454             if (!inSwap) {
455                 if (contractSwapEnabled) {
456                     uint256 contractTokenBalance = balanceOf(address(this));
457                     if (contractTokenBalance >= swapThreshold) {
458                         uint256 swapAmt = swapAmount;
459                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
460                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
461                         contractSwap(contractTokenBalance);
462                     }
463                 }
464             }
465         }
466         return finalizeTransfer(from, to, amount, buy, sell, other);
467     }
468 
469     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
470         Ratios memory ratios = _ratios;
471         if (ratios.totalSwap == 0) {
472             return;
473         }
474 
475         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
476             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
477         }
478 
479         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.totalSwap) / 2;
480         uint256 swapAmt = contractTokenBalance - toLiquify;
481         
482         address[] memory path = new address[](2);
483         path[0] = address(this);
484         path[1] = dexRouter.WETH();
485 
486         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
487             swapAmt,
488             0,
489             path,
490             address(this),
491             block.timestamp
492         ) {} catch {
493             return;
494         }
495 
496         uint256 amtBalance = address(this).balance;
497         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
498 
499         if (toLiquify > 0) {
500             try dexRouter.addLiquidityETH{value: liquidityBalance}(
501                 address(this),
502                 toLiquify,
503                 0,
504                 0,
505                 _taxWallets.liquidity,
506                 block.timestamp
507             ) {
508                 emit AutoLiquify(liquidityBalance, toLiquify);
509             } catch {
510                 return;
511             }
512         }
513 
514         amtBalance -= liquidityBalance;
515         ratios.totalSwap -= ratios.liquidity;
516         bool success;
517         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.totalSwap;
518         uint256 buybackBalance = (buyback != address(0)) ? (amtBalance * ratios.buyback) / ratios.totalSwap : 0;
519         uint256 marketingBalance = amtBalance - (developmentBalance + buybackBalance);
520         if (marketingBalance > 0) {
521             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 35000}("");
522         }
523         if (developmentBalance > 0) {
524             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 35000}("");
525         }
526         if (buybackBalance > 0) {
527             path[0] = dexRouter.WETH();
528             path[1] = buyback;
529             buyTokens(path, buybackBalance, _taxWallets.buyback);
530         }
531     }
532 
533     function buyTokens(address[] memory path, uint256 amount, address payable destination) internal {
534         try dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}
535         (
536             0,
537             path,
538             destination,
539             block.timestamp
540         ) {
541             if (path[1] ==  buyback) {
542                 _totalBuyback += amount;
543             }
544         } catch {
545             return;
546         }
547     }
548 
549     function _checkLiquidityAdd(address from, address to) internal {
550         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
551         if (!_hasLimits(from, to) && to == lpPair) {
552             _liquidityHolders[from] = true;
553             _isExcludedFromFees[from] = true;
554             _hasLiqBeenAdded = true;
555             contractSwapEnabled = true;
556             emit ContractSwapEnabledUpdated(true);
557         }
558     }
559 
560     function enableTrading() public onlyOwner {
561         require(!tradingEnabled, "Trading already enabled!");
562         require(_hasLiqBeenAdded, "Liquidity must be added.");
563         tradingEnabled = true;
564         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
565         swapAmount = (balanceOf(lpPair) * 30) / 10000;
566         _approve(address(this), address(dexRouter), type(uint256).max);
567 
568     }
569 
570     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
571         if (!_hasLiqBeenAdded) {
572             _checkLiquidityAdd(from, to);
573             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !other) {
574                 revert("Pre-liquidity transfer protection.");
575             }
576         }
577 
578         bool takeFee = true;
579         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
580             takeFee = false;
581         }
582 
583         _tOwned[from] -= amount;
584         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
585         _tOwned[to] += amountReceived;
586 
587         emit Transfer(from, to, amountReceived);
588         return true;
589     }
590 
591     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
592         Ratios memory ratios = _ratios;
593         uint256 currentFee;
594         if (buy) {
595             currentFee = _taxRates.buyFee;
596         } else if (sell) {
597             currentFee = _taxRates.sellFee;
598         } else {
599             currentFee = _taxRates.transferFee;
600         }
601         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
602         uint256 burnAmount = (feeAmount * ratios.burn) / (ratios.burn + ratios.totalSwap);
603         uint256 swapAmt = feeAmount - burnAmount;
604         if (swapAmt > 0) {
605             _tOwned[address(this)] += swapAmt;
606             emit Transfer(from, address(this), swapAmt);
607         }
608         if (burnAmount > 0) {
609             _tTotal -= burnAmount;
610             _totalBurned += burnAmount;
611             emit Transfer(from, address(0), burnAmount);
612         }
613         
614         
615 
616         return amount - feeAmount;
617     }
618 
619     function blacklist (address _address) external onlyOwner {
620         bots[_address] = true;
621     }
622     
623     function removeFromBlacklist (address _address) external onlyOwner {
624         bots[_address] = false;
625     }
626     
627     function getIsBlacklistedStatus (address _address) external view returns (bool) {
628         return bots[_address];
629     }
630 
631 }