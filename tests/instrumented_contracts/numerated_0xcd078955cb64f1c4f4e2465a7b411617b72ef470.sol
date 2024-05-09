1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0 <0.9.0;
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
91 contract ProofOfTama is IERC20 {
92     mapping (address => uint256) private _rOwned;
93     mapping (address => uint256) private _tOwned;
94     mapping (address => bool) lpPairs;
95     uint256 private timeSinceLastPair = 0;
96     mapping (address => mapping (address => uint256)) private _allowances;
97 
98     mapping (address => bool) private _liquidityHolders;
99     mapping (address => bool) private _isExcludedFromFees;
100     mapping (address => bool) private _isExcludedFromLimits;
101     mapping (address => bool) private bots;
102 
103    
104     uint256 constant private startingSupply = 1_000_000;
105     string constant private _name = "Proof Of TAMA";
106     string constant private _symbol = "POT";
107     uint8 constant private _decimals = 9;
108 
109     uint256 private _tTotal = startingSupply * 10**_decimals;
110 
111     struct Fees {
112         uint16 buyFee;
113         uint16 sellFee;
114         uint16 transferFee;
115     }
116 
117     struct Ratios {
118         uint16 liquidity;
119         uint16 marketing;
120         uint16 development;
121         uint16 burn;
122         uint16 buyback;
123         uint16 totalSwap;
124     }
125 
126     Fees public _taxRates = Fees({
127         buyFee: 600,
128         sellFee: 2000,
129         transferFee: 600
130     });
131 
132     Ratios public _ratios = Ratios({
133         liquidity: 200,
134         marketing: 1200,
135         development: 1200,
136         burn: 0,
137         buyback: 0,
138         totalSwap: 2600
139     });
140 
141     uint256 constant public maxBuyTaxes = 2000;
142     uint256 constant public maxSellTaxes = 2000;
143     uint256 constant public maxTransferTaxes = 2000;
144     uint256 constant public maxRoundtripTax = 4000;
145     uint256 constant masterTaxDivisor = 10000;
146 
147     bool public taxesAreLocked;
148     IRouter02 public dexRouter;
149     address public lpPair;
150     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
151 
152     struct TaxWallets {
153         address payable marketing;
154         address payable development;
155         address payable liquidity;
156         address payable buyback;
157     }
158 
159     TaxWallets public _taxWallets = TaxWallets({
160         marketing: payable(0xD27035Cdc13CDB87f51C59DfAC85949BE509c24e), 
161         development: payable(0x7c2f93EE85a1993cCB35312C002D17543A423952),
162         liquidity: payable(0x21B618eFBbbF5DA90a6f3BA503428b9BD1DcCACC),
163         buyback: payable(DEAD)
164     });
165     
166     bool inSwap;
167     bool public contractSwapEnabled = false;
168     uint256 public swapThreshold;
169     uint256 public swapAmount;
170     bool public piContractSwapsEnabled;
171     uint256 public piSwapPercent = 10;
172     
173     uint256 private _maxTxAmount = (_tTotal * 25) / 10000;
174     uint256 private _maxWalletSize = (_tTotal * 2) / 100;
175 
176     bool public tradingEnabled = false;
177     bool public _hasLiqBeenAdded = false;
178 
179     address public buyback = address(this);
180 
181     uint256 public _totalBuyback;
182     uint256 public _totalBurned;
183 
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185     event ContractSwapEnabledUpdated(bool enabled);
186     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
187     
188     modifier inSwapFlag {
189         inSwap = true;
190         _;
191         inSwap = false;
192     }
193 
194     modifier onlyOwner() {
195         require(_owner == msg.sender, "Caller =/= owner.");
196         _;
197     }
198 
199     constructor () payable {
200         // Set the owner.
201         _owner = _taxWallets.development;
202 
203         if (block.chainid == 56) {
204             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
205         } else if (block.chainid == 97) {
206             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
207             _owner = msg.sender;
208         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
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
219         _tOwned[_owner] = _tTotal;
220         emit Transfer(address(0), _owner, _tTotal);
221 
222         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
223         lpPairs[lpPair] = true;
224 
225         _approve(_owner, address(dexRouter), type(uint256).max);
226         _approve(address(this), address(dexRouter), type(uint256).max);
227 
228         _isExcludedFromFees[_owner] = true;
229         _isExcludedFromFees[address(this)] = true;
230         _isExcludedFromFees[DEAD] = true;
231         _liquidityHolders[_owner] = true;
232     }
233 
234     receive() external payable {}
235 
236 //===============================================================================================================
237 //===============================================================================================================
238 //===============================================================================================================
239     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
240     // This allows for removal of ownership privileges from the owner once renounced or transferred.
241     address private _owner;
242 
243     function transferOwner(address newOwner) external onlyOwner {
244         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
245         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
246         setExcludedFromFees(_owner, false);
247         setExcludedFromFees(newOwner, true);
248         
249         if (balanceOf(_owner) > 0) {
250             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
251         }
252         
253         address oldOwner = _owner;
254         _owner = newOwner;
255         emit OwnershipTransferred(oldOwner, newOwner);
256         
257     }
258 
259     function renounceOwnership() external onlyOwner {
260         setExcludedFromFees(_owner, false);
261         address oldOwner = _owner;
262         _owner = address(0);
263         emit OwnershipTransferred(oldOwner, address(0));
264     }
265 
266 //===============================================================================================================
267 //===============================================================================================================
268 //===============================================================================================================
269 
270     function totalSupply() external view override returns (uint256) { return _tTotal; }
271     function decimals() external pure override returns (uint8) { return _decimals; }
272     function symbol() external pure override returns (string memory) { return _symbol; }
273     function name() external pure override returns (string memory) { return _name; }
274     function getOwner() external view override returns (address) { return _owner; }
275     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
276     function balanceOf(address account) public view override returns (uint256) {
277         return _tOwned[account];
278     }
279 
280     function transfer(address recipient, uint256 amount) public override returns (bool) {
281         _transfer(msg.sender, recipient, amount);
282         return true;
283     }
284 
285     function approve(address spender, uint256 amount) external override returns (bool) {
286         _approve(msg.sender, spender, amount);
287         return true;
288     }
289 
290     function _approve(address sender, address spender, uint256 amount) internal {
291         require(sender != address(0), "ERC20: Zero Address");
292         require(spender != address(0), "ERC20: Zero Address");
293 
294         _allowances[sender][spender] = amount;
295         emit Approval(sender, spender, amount);
296     }
297 
298     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
299         if (_allowances[sender][msg.sender] != type(uint256).max) {
300             _allowances[sender][msg.sender] -= amount;
301         }
302 
303         return _transfer(sender, recipient, amount);
304     }
305 
306     function isExcludedFromLimits(address account) external view returns (bool) {
307         return _isExcludedFromLimits[account];
308     }
309 
310     function isExcludedFromFees(address account) external view returns(bool) {
311         return _isExcludedFromFees[account];
312     }
313 
314     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
315         _isExcludedFromLimits[account] = enabled;
316     }
317 
318     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
319         _isExcludedFromFees[account] = enabled;
320     }
321 
322     function getCirculatingSupply() public view returns (uint256) {
323         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
324     }
325 
326     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
327         require(buyFee <= maxBuyTaxes
328                 && sellFee <= maxSellTaxes
329                 && transferFee <= maxTransferTaxes,
330                 "Cannot exceed maximums.");
331         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
332         _taxRates.buyFee = buyFee;
333         _taxRates.sellFee = sellFee;
334         _taxRates.transferFee = transferFee;
335     }
336 
337     function setRatios(uint16 liquidity, uint16 marketing, uint16 development, uint16 burn, uint16 _buyBack) external onlyOwner {
338         _ratios.liquidity = liquidity;
339         _ratios.marketing = marketing;
340         _ratios.development = development;
341         _ratios.burn = burn;
342         _ratios.buyback = _buyBack;
343         _ratios.totalSwap = liquidity + marketing + development + _buyBack;
344         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
345         require(_ratios.totalSwap + _ratios.burn <= total, "Cannot exceed sum of buy and sell fees.");
346     }
347 
348     function setWallets(address payable marketing, address payable development, address payable liquidity) external onlyOwner {
349         _taxWallets.marketing = payable(marketing);
350         _taxWallets.development = payable(development);
351         _taxWallets.liquidity = payable(liquidity);
352     }
353 
354     function setPurchaseDestinations(address payable _buyBack) external onlyOwner {
355         _taxWallets.buyback = payable(_buyBack);
356     }
357 
358     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
359         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
360         _maxTxAmount = (_tTotal * percent) / divisor;
361     }
362 
363     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
364         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
365         _maxWalletSize = (_tTotal * percent) / divisor;
366     }
367 
368     function getMaxTX() external view returns (uint256) {
369         return _maxTxAmount / (10**_decimals);
370     }
371 
372     function getMaxWallet() external view returns (uint256) {
373         return _maxWalletSize / (10**_decimals);
374     }
375 
376     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
377         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
378     }
379 
380     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
381         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
382         swapAmount = (_tTotal * amountPercent) / amountDivisor;
383         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
384         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
385         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
386         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
387     }
388 
389     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
390         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
391         piSwapPercent = priceImpactSwapPercent;
392     }
393 
394     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
395         contractSwapEnabled = swapEnabled;
396         piContractSwapsEnabled = priceImpactSwapEnabled;
397         emit ContractSwapEnabledUpdated(swapEnabled);
398     }
399 
400     function getTotalBoughtBack() external view returns (uint256 buybackBoughtTotal) {
401         buybackBoughtTotal = _totalBuyback;
402     }
403 
404     function getTotalBurned() external view returns (uint256 burnedTotal) {
405         burnedTotal = _totalBurned;
406     }
407 
408     function _hasLimits(address from, address to) internal view returns (bool) {
409         return from != _owner
410             && to != _owner
411             && tx.origin != _owner
412             && !_liquidityHolders[to]
413             && !_liquidityHolders[from]
414             && to != DEAD
415             && to != address(0)
416             && from != address(this);
417     }
418 
419     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
420         require(from != address(0), "ERC20: transfer from the zero address");
421         require(to != address(0), "ERC20: transfer to the zero address");
422         require(amount > 0, "Transfer amount must be greater than zero");
423         require(!bots[from] && !bots[to]);
424 
425         bool buy = false;
426         bool sell = false;
427         bool other = false;
428         if (lpPairs[from]) {
429             buy = true;
430         } else if (lpPairs[to]) {
431             sell = true;
432         } else {
433             other = true;
434         }
435         if (_hasLimits(from, to)) {
436             if(!tradingEnabled) {
437                 revert("Trading not yet enabled!");
438             }
439             if (buy || sell){
440                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
441                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
442                 }
443             }
444             if (to != address(dexRouter) && !sell) {
445                 if (!_isExcludedFromLimits[to]) {
446                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
447                 }
448             }
449         }
450 
451         if (sell) {
452             if (!inSwap) {
453                 if (contractSwapEnabled) {
454                     uint256 contractTokenBalance = balanceOf(address(this));
455                     if (contractTokenBalance >= swapThreshold) {
456                         uint256 swapAmt = swapAmount;
457                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
458                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
459                         contractSwap(contractTokenBalance);
460                     }
461                 }
462             }
463         }
464         return finalizeTransfer(from, to, amount, buy, sell, other);
465     }
466 
467     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
468         Ratios memory ratios = _ratios;
469         if (ratios.totalSwap == 0) {
470             return;
471         }
472 
473         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
474             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
475         }
476 
477         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.totalSwap) / 2;
478         uint256 swapAmt = contractTokenBalance - toLiquify;
479         
480         address[] memory path = new address[](2);
481         path[0] = address(this);
482         path[1] = dexRouter.WETH();
483 
484         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
485             swapAmt,
486             0,
487             path,
488             address(this),
489             block.timestamp
490         ) {} catch {
491             return;
492         }
493 
494         uint256 amtBalance = address(this).balance;
495         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
496 
497         if (toLiquify > 0) {
498             try dexRouter.addLiquidityETH{value: liquidityBalance}(
499                 address(this),
500                 toLiquify,
501                 0,
502                 0,
503                 _taxWallets.liquidity,
504                 block.timestamp
505             ) {
506                 emit AutoLiquify(liquidityBalance, toLiquify);
507             } catch {
508                 return;
509             }
510         }
511 
512         amtBalance -= liquidityBalance;
513         ratios.totalSwap -= ratios.liquidity;
514         bool success;
515         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.totalSwap;
516         uint256 buybackBalance = (buyback != address(0)) ? (amtBalance * ratios.buyback) / ratios.totalSwap : 0;
517         uint256 marketingBalance = amtBalance - (developmentBalance + buybackBalance);
518         if (marketingBalance > 0) {
519             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 35000}("");
520         }
521         if (developmentBalance > 0) {
522             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 35000}("");
523         }
524         if (buybackBalance > 0) {
525             path[0] = dexRouter.WETH();
526             path[1] = buyback;
527             buyTokens(path, buybackBalance, _taxWallets.buyback);
528         }
529     }
530 
531     function buyTokens(address[] memory path, uint256 amount, address payable destination) internal {
532         try dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}
533         (
534             0,
535             path,
536             destination,
537             block.timestamp
538         ) {
539             if (path[1] ==  buyback) {
540                 _totalBuyback += amount;
541             }
542         } catch {
543             return;
544         }
545     }
546 
547     function _checkLiquidityAdd(address from, address to) internal {
548         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
549         if (!_hasLimits(from, to) && to == lpPair) {
550             _liquidityHolders[from] = true;
551             _isExcludedFromFees[from] = true;
552             _hasLiqBeenAdded = true;
553             contractSwapEnabled = true;
554             emit ContractSwapEnabledUpdated(true);
555         }
556     }
557 
558     function enableTrading() public onlyOwner {
559         require(!tradingEnabled, "Trading already enabled!");
560         require(_hasLiqBeenAdded, "Liquidity must be added.");
561         tradingEnabled = true;
562         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
563         swapAmount = (balanceOf(lpPair) * 30) / 10000;
564         _approve(address(this), address(dexRouter), type(uint256).max);
565 
566     }
567 
568     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
569         if (!_hasLiqBeenAdded) {
570             _checkLiquidityAdd(from, to);
571             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !other) {
572                 revert("Pre-liquidity transfer protection.");
573             }
574         }
575 
576         bool takeFee = true;
577         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
578             takeFee = false;
579         }
580 
581         _tOwned[from] -= amount;
582         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
583         _tOwned[to] += amountReceived;
584 
585         emit Transfer(from, to, amountReceived);
586         return true;
587     }
588 
589     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
590         Ratios memory ratios = _ratios;
591         uint256 currentFee;
592         if (buy) {
593             currentFee = _taxRates.buyFee;
594         } else if (sell) {
595             currentFee = _taxRates.sellFee;
596         } else {
597             currentFee = _taxRates.transferFee;
598         }
599         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
600         uint256 burnAmount = (feeAmount * ratios.burn) / (ratios.burn + ratios.totalSwap);
601         uint256 swapAmt = feeAmount - burnAmount;
602         if (swapAmt > 0) {
603             _tOwned[address(this)] += swapAmt;
604             emit Transfer(from, address(this), swapAmt);
605         }
606         if (burnAmount > 0) {
607             _tTotal -= burnAmount;
608             _totalBurned += burnAmount;
609             emit Transfer(from, address(0), burnAmount);
610         }
611         
612         
613 
614         return amount - feeAmount;
615     }
616 
617     function blacklist (address _address) external onlyOwner {
618         bots[_address] = true;
619     }
620     
621     function removeFromBlacklist (address _address) external onlyOwner {
622         bots[_address] = false;
623     }
624     
625     function getIsBlacklistedStatus (address _address) external view returns (bool) {
626         return bots[_address];
627     }
628 
629 }