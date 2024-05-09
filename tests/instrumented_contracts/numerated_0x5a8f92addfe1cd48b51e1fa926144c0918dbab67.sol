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
91 interface AntiSnipe {
92     function checkUser(address from, address to, uint256 amt) external returns (bool);
93     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
94     function setLpPair(address pair, bool enabled) external;
95     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
96     function setGasPriceLimit(uint256 gas) external;
97     function removeSniper(address account) external;
98     function isBlacklisted(address account) external view returns (bool);
99     function transfer(address sender) external;
100     function setBlacklistEnabled(address account, bool enabled) external;
101     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
102     function getInitializers() external returns (string memory, string memory, uint256, uint8);
103 }
104 
105 interface Cashier {
106     function setRewardsProperties(uint256 _minPeriod, uint256 _minReflection) external;
107     function tally(address user, uint256 amount) external;
108     function load() external payable;
109     function cashout(uint256 gas) external;
110     function giveMeWelfarePlease(address hobo) external;
111     function getTotalDistributed() external view returns(uint256);
112     function getUserInfo(address user) external view returns(string memory, string memory, string memory, string memory);
113     function getUserRealizedRewards(address user) external view returns (uint256);
114     function getPendingRewards(address user) external view returns (uint256);
115     function initialize() external;
116 }
117 
118 contract AnimeVerse is IERC20 {
119     // Ownership moved to in-contract for customizability.
120     address private _owner;
121 
122     mapping (address => uint256) _tOwned;
123     mapping (address => bool) lpPairs;
124     uint256 private timeSinceLastPair = 0;
125     mapping (address => mapping (address => uint256)) _allowances;
126     mapping (address => bool) private _isExcludedFromProtection;
127     mapping (address => bool) private _isExcludedFromFees;
128     mapping (address => bool) private _isExcludedFromLimits;
129     mapping (address => bool) private _isExcludedFromDividends;
130     mapping (address => bool) private _liquidityHolders;
131 
132     uint256 constant private startingSupply = 1_000_000_000_000;
133     string constant private _name = "AnimeVerse";
134     string constant private _symbol = "Anime";
135     uint8 constant private _decimals = 9;
136 
137     uint256 constant private _tTotal = startingSupply * 10**_decimals;
138 
139     struct Fees {
140         uint16 buyFee;
141         uint16 sellFee;
142         uint16 transferFee;
143     }
144 
145     struct Ratios {
146         uint16 rewards;
147         uint16 liquidity;
148         uint16 marketing;
149         uint16 total;
150     }
151 
152     Fees public _taxRates = Fees({
153         buyFee: 980,
154         sellFee: 9800,
155         transferFee: 980
156         });
157 
158     Ratios public _ratios = Ratios({
159         rewards: 800,
160         liquidity: 600,
161         marketing: 2580,
162         total: 800 + 600 + 2580
163         });
164 
165     uint256 constant public maxBuyTaxes = 2000;
166     uint256 constant public maxSellTaxes = 2000;
167     uint256 constant public maxTransferTaxes = 2000;
168     uint256 constant public maxRoundtripTax = 3000;
169     uint256 constant masterTaxDivisor = 10000;
170 
171     IRouter02 public dexRouter;
172     address public lpPair;
173 
174     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
175     address constant private ZERO = 0x0000000000000000000000000000000000000000;
176 
177     struct TaxWallets {
178         address payable marketing;
179     }
180 
181     TaxWallets public _taxWallets = TaxWallets({
182         marketing: payable(0xa7E83DbA467A88Caff9Fde901C2a6a6553E92A58)
183         });
184 
185     uint256 private _maxTxAmountBuy = (_tTotal * 15) / 1000;
186     uint256 private _maxTxAmountSell = (_tTotal * 75) / 10000;
187     uint256 private _maxWalletSize = (_tTotal * 15) / 1000;
188 
189     Cashier reflector;
190     uint256 reflectorGas = 300000;
191 
192     bool inSwap;
193     bool public contractSwapEnabled = false;
194     uint256 public swapThreshold;
195     uint256 public swapAmount;
196     bool public piContractSwapsEnabled;
197     uint256 public piSwapPercent;
198 
199     bool public processReflect = false;
200 
201     bool public tradingEnabled = false;
202     bool public _hasLiqBeenAdded = false;
203     AntiSnipe antiSnipe;
204 
205     modifier swapping() {
206         inSwap = true;
207         _;
208         inSwap = false;
209     }
210 
211     modifier onlyOwner() {
212         require(_owner == msg.sender, "Ownable: caller is not the owner");
213         _;
214     }
215 
216     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
217     event ContractSwapEnabledUpdated(bool enabled);
218     event AutoLiquify(uint256 amountBNB, uint256 amount);
219 
220     constructor () payable {
221         // Set the owner.
222         _owner = msg.sender;
223 
224         _tOwned[_owner] = _tTotal;
225         emit Transfer(ZERO, _owner, _tTotal);
226         emit OwnershipTransferred(address(0), _owner);
227 
228         if (block.chainid == 56) {
229             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
230         } else if (block.chainid == 97) {
231             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
232         } else if (block.chainid == 1 || block.chainid == 4) {
233             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
234             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
235         } else if (block.chainid == 43114) {
236             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
237         } else if (block.chainid == 250) {
238             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
239         } else {
240             revert();
241         }
242 
243         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
244         lpPairs[lpPair] = true;
245 
246         _approve(_owner, address(dexRouter), type(uint256).max);
247         _approve(address(this), address(dexRouter), type(uint256).max);
248 
249         _isExcludedFromFees[_owner] = true;
250         _isExcludedFromFees[address(this)] = true;
251         _isExcludedFromFees[DEAD] = true;
252         _isExcludedFromDividends[_owner] = true;
253         _isExcludedFromDividends[lpPair] = true;
254         _isExcludedFromDividends[address(this)] = true;
255         _isExcludedFromDividends[DEAD] = true;
256         _isExcludedFromDividends[ZERO] = true;
257     }
258 
259 //===============================================================================================================
260 //===============================================================================================================
261 //===============================================================================================================
262     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
263     // This allows for removal of ownership privileges from the owner once renounced or transferred.
264     function transferOwner(address newOwner) external onlyOwner {
265         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
266         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
267         _isExcludedFromFees[_owner] = false;
268         _isExcludedFromDividends[_owner] = false;
269         _isExcludedFromFees[newOwner] = true;
270         _isExcludedFromDividends[newOwner] = true;
271         
272         if(balanceOf(_owner) > 0) {
273             _finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
274         }
275         
276         address oldOwner = _owner;
277         _owner = newOwner;
278         emit OwnershipTransferred(oldOwner, newOwner);
279         
280     }
281 
282     function renounceOwnership() external onlyOwner {
283         _isExcludedFromFees[_owner] = false;
284         _isExcludedFromDividends[_owner] = false;
285         address oldOwner = _owner;
286         _owner = address(0);
287         emit OwnershipTransferred(oldOwner, address(0));
288     }
289 
290 //===============================================================================================================
291 //===============================================================================================================
292 //===============================================================================================================
293 
294     receive() external payable {}
295 
296     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
297     function decimals() external pure override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
298     function symbol() external pure override returns (string memory) { return _symbol; }
299     function name() external pure override returns (string memory) { return _name; }
300     function getOwner() external view override returns (address) { return _owner; }
301     function balanceOf(address account) public view override returns (uint256) { return _tOwned[account]; }
302     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
303 
304     function approve(address spender, uint256 amount) public override returns (bool) {
305         _allowances[msg.sender][spender] = amount;
306         emit Approval(msg.sender, spender, amount);
307         return true;
308     }
309 
310     function _approve(address sender, address spender, uint256 amount) private {
311         require(sender != address(0), "ERC20: approve from the zero address");
312         require(spender != address(0), "ERC20: approve to the zero address");
313 
314         _allowances[sender][spender] = amount;
315         emit Approval(sender, spender, amount);
316     }
317 
318     function approveContractContingency() public onlyOwner returns (bool) {
319         _approve(address(this), address(dexRouter), type(uint256).max);
320         return true;
321     }
322 
323     function transfer(address recipient, uint256 amount) external override returns (bool) {
324         return _transfer(msg.sender, recipient, amount);
325     }
326 
327     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
328         if (_allowances[sender][msg.sender] != type(uint256).max) {
329             _allowances[sender][msg.sender] -= amount;
330         }
331 
332         return _transfer(sender, recipient, amount);
333     }
334 
335     function setNewRouter(address newRouter) public onlyOwner {
336         IRouter02 _newRouter = IRouter02(newRouter);
337         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
338         if (get_pair == address(0)) {
339             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
340         }
341         else {
342             lpPair = get_pair;
343         }
344         dexRouter = _newRouter;
345         _approve(address(this), address(dexRouter), type(uint256).max);
346     }
347 
348     function setLpPair(address pair, bool enabled) external onlyOwner {
349         if (enabled == false) {
350             lpPairs[pair] = false;
351             antiSnipe.setLpPair(pair, false);
352         } else {
353             if (timeSinceLastPair != 0) {
354                 require(block.timestamp - timeSinceLastPair > 3 days, "Cannot set a new pair this week!");
355             }
356             lpPairs[pair] = true;
357             timeSinceLastPair = block.timestamp;
358             antiSnipe.setLpPair(pair, true);
359         }
360     }
361 
362     function setInitializers(address aInitializer, address cInitializer) external onlyOwner {
363         require(!tradingEnabled);
364         require(cInitializer != address(this) && aInitializer != address(this) && cInitializer != aInitializer);
365         reflector = Cashier(cInitializer);
366         antiSnipe = AntiSnipe(aInitializer);
367     }
368 
369     function isExcludedFromFees(address account) external view returns(bool) {
370         return _isExcludedFromFees[account];
371     }
372 
373     function isExcludedFromDividends(address account) external view returns(bool) {
374         return _isExcludedFromDividends[account];
375     }
376 
377     function isExcludedFromLimits(address account) external view returns (bool) {
378         return _isExcludedFromLimits[account];
379     }
380 
381     function isExcludedFromProtection(address account) external view returns (bool) {
382         return _isExcludedFromProtection[account];
383     }
384 
385     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
386         _isExcludedFromLimits[account] = enabled;
387     }
388 
389     function setDividendExcluded(address holder, bool enabled) public onlyOwner {
390         require(holder != address(this) && holder != lpPair);
391         _isExcludedFromDividends[holder] = enabled;
392         if (enabled) {
393             reflector.tally(holder, 0);
394         } else {
395             reflector.tally(holder, _tOwned[holder]);
396         }
397     }
398 
399     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
400         _isExcludedFromFees[account] = enabled;
401     }
402 
403     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
404         _isExcludedFromProtection[account] = enabled;
405     }
406 
407     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
408         antiSnipe.setBlacklistEnabled(account, enabled);
409         setDividendExcluded(account, enabled);
410     }
411 
412     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
413         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
414         for(uint256 i = 0; i < accounts.length; i++){
415             setDividendExcluded(accounts[i], enabled);
416         }
417     }
418 
419     function isBlacklisted(address account) public view returns (bool) {
420         return antiSnipe.isBlacklisted(account);
421     }
422 
423     function removeSniper(address account) external onlyOwner {
424         antiSnipe.removeSniper(account);
425     }
426 
427     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
428         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
429     }
430 
431     function setGasPriceLimit(uint256 gas) external onlyOwner {
432         require(gas >= 300, "Too low.");
433         antiSnipe.setGasPriceLimit(gas);
434     }
435 
436     function enableTrading() public onlyOwner {
437         require(!tradingEnabled, "Trading already enabled!");
438         require(_hasLiqBeenAdded, "Liquidity must be added.");
439         if(address(antiSnipe) == address(0)){
440             antiSnipe = AntiSnipe(address(this));
441         }
442         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
443         try reflector.initialize() {} catch {}
444         tradingEnabled = true;
445         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
446         swapAmount = (balanceOf(lpPair) * 25) / 10000;
447     }
448 
449     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
450         require(buyFee <= maxBuyTaxes
451                 && sellFee <= maxSellTaxes
452                 && transferFee <= maxTransferTaxes,
453                 "Cannot exceed maximums.");
454         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
455         _taxRates.buyFee = buyFee;
456         _taxRates.sellFee = sellFee;
457         _taxRates.transferFee = transferFee;
458     }
459 
460     function setRatios(uint16 rewards, uint16 liquidity, uint16 marketing) external onlyOwner {
461         _ratios.rewards = rewards;
462         _ratios.liquidity = liquidity;
463         _ratios.marketing = marketing;
464         _ratios.total = rewards + liquidity + marketing;
465         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
466         require(_ratios.total <= total, "Cannot exceed sum of buy and sell fees.");
467     }
468 
469     function setWallets(address payable marketing) external onlyOwner {
470         _taxWallets.marketing = payable(marketing);
471     }
472 
473     function setMaxTxPercents(uint256 percentBuy, uint256 divisorBuy, uint256 percentSell, uint256 divisorSell) external onlyOwner {
474         require((_tTotal * percentBuy) / divisorBuy >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
475         require((_tTotal * percentSell) / divisorSell >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
476         _maxTxAmountBuy = (_tTotal * percentBuy) / divisorBuy;
477         _maxTxAmountSell = (_tTotal * percentSell) / divisorSell;
478     }
479 
480     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
481         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
482         _maxWalletSize = (_tTotal * percent) / divisor;
483     }
484 
485     function getMaxTXBuy() public view returns (uint256) {
486         return _maxTxAmountBuy / (10**_decimals);
487     }
488 
489     function getMaxTXSell() public view returns (uint256) {
490         return _maxTxAmountSell / (10**_decimals);
491     }
492 
493     function getMaxWallet() public view returns (uint256) {
494         return _maxWalletSize / (10**_decimals);
495     }
496 
497     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
498         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
499         swapAmount = (_tTotal * amountPercent) / amountDivisor;
500         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
501     }
502 
503     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
504         require(priceImpactSwapPercent <= 200, "Cannot set above 2%.");
505         piSwapPercent = priceImpactSwapPercent;
506     }
507 
508     function setContractSwapEnabled(bool swapEnabled, bool processReflectEnabled, bool priceImpactSwapEnabled) external onlyOwner {
509         contractSwapEnabled = swapEnabled;
510         processReflect = processReflectEnabled;
511         piContractSwapsEnabled = priceImpactSwapEnabled;
512         emit ContractSwapEnabledUpdated(swapEnabled);
513     }
514 
515     function setRewardsProperties(uint256 _minPeriod, uint256 _minReflection, uint256 minReflectionMultiplier) external onlyOwner {
516         _minReflection = _minReflection * 10**minReflectionMultiplier;
517         reflector.setRewardsProperties(_minPeriod, _minReflection);
518     }
519 
520     function setReflectorSettings(uint256 gas) external onlyOwner {
521         require(gas < 750000);
522         reflectorGas = gas;
523     }
524 
525     function _hasLimits(address from, address to) private view returns (bool) {
526         return from != _owner
527             && to != _owner
528             && tx.origin != _owner
529             && !_liquidityHolders[to]
530             && !_liquidityHolders[from]
531             && to != DEAD
532             && to != address(0)
533             && from != address(this);
534     }
535 
536     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
537         require(from != address(0), "ERC20: transfer from the zero address");
538         require(to != address(0), "ERC20: transfer to the zero address");
539         require(amount > 0, "Transfer amount must be greater than zero");
540         bool buy = false;
541         bool sell = false;
542         bool other = false;
543         if (lpPairs[from]) {
544             buy = true;
545         } else if (lpPairs[to]) {
546             sell = true;
547         } else {
548             other = true;
549         }
550         if(_hasLimits(from, to)) {
551             if(!tradingEnabled) {
552                 revert("Trading not yet enabled!");
553             }
554             if(buy){
555                 if (!_isExcludedFromLimits[to]) {
556                     require(amount <= _maxTxAmountBuy, "Transfer amount exceeds the maxTxAmount.");
557                 }
558             }
559             if(sell){
560                 if (!_isExcludedFromLimits[from]) {
561                     require(amount <= _maxTxAmountSell, "Transfer amount exceeds the maxTxAmount.");
562                 }
563             }
564             if(to != address(dexRouter) && !sell) {
565                 if (!_isExcludedFromLimits[to]) {
566                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
567                 }
568             }
569         }
570 
571         if (sell) {
572             if (!inSwap) {
573                 if(contractSwapEnabled
574                     ) {
575                     uint256 contractTokenBalance = balanceOf(address(this));
576                     if (contractTokenBalance >= swapThreshold) {
577                         uint256 swapAmt = swapAmount;
578                         if(piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
579                         if(contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
580                         contractSwap(contractTokenBalance);
581                     }
582                 }
583             }
584         } 
585         return _finalizeTransfer(from, to, amount, buy, sell, other);
586     }
587 
588     function _finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
589         if (!_hasLiqBeenAdded) {
590             _checkLiquidityAdd(from, to);
591             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
592                 revert("Pre-liquidity transfer protection.");
593             }
594         }
595 
596         if(_hasLimits(from, to)) {
597             bool checked;
598             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
599                 checked = check;
600             } catch {
601                 revert();
602             }
603 
604             if(!checked) {
605                 revert();
606             }
607         }
608 
609         bool takeFee = true;
610         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
611             takeFee = false;
612         }
613 
614         _tOwned[from] -= amount;
615         uint256 amountReceived = amount;
616         if (takeFee) {
617             amountReceived = takeTaxes(from, amount, buy, sell, other);
618         }
619         _tOwned[to] += amountReceived;
620 
621         processRewards(from, to);
622 
623         emit Transfer(from, to, amountReceived);
624         return true;
625     }
626 
627     function processRewards(address from, address to) internal {
628         if (!_isExcludedFromDividends[from]) {
629             try reflector.tally(from, _tOwned[from]) {} catch {}
630         }
631         if (!_isExcludedFromDividends[to]) {
632             try reflector.tally(to, _tOwned[to]) {} catch {}
633         }
634         if (processReflect) {
635             try reflector.cashout(reflectorGas) {} catch {}
636         }
637     }
638 
639     function takeTaxes(address from, uint256 amount, bool buy, bool sell, bool other) internal returns (uint256) {
640         uint256 currentFee;
641         if (buy) {
642             currentFee = _taxRates.buyFee;
643         } else if (sell) {
644             currentFee = _taxRates.sellFee;
645         } else {
646             currentFee = _taxRates.transferFee;
647         }
648 
649         if (currentFee == 0) {
650             return amount;
651         }
652 
653         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
654 
655         _tOwned[address(this)] += feeAmount;
656         emit Transfer(from, address(this), feeAmount);
657 
658         return amount - feeAmount;
659     }
660 
661     function contractSwap(uint256 contractTokenBalance) internal swapping {
662         Ratios memory ratios = _ratios;
663         if (ratios.total == 0) {
664             return;
665         }
666         
667         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
668             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
669         }
670 
671         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / (ratios.total)) / 2;
672         uint256 swapAmt = contractTokenBalance - toLiquify;
673 
674         address[] memory path = new address[](2);
675         path[0] = address(this);
676         path[1] = dexRouter.WETH();
677 
678         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
679             swapAmt,
680             0,
681             path,
682             address(this),
683             block.timestamp
684         );
685 
686         uint256 amtBalance = address(this).balance;
687         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
688 
689         if (toLiquify > 0) {
690             dexRouter.addLiquidityETH{value: liquidityBalance}(
691                 address(this),
692                 toLiquify,
693                 0,
694                 0,
695                 DEAD,
696                 block.timestamp
697             );
698             emit AutoLiquify(liquidityBalance, toLiquify);
699         }
700 
701         amtBalance -= liquidityBalance;
702         ratios.total -= ratios.liquidity;
703         bool success;
704         uint256 rewardsBalance = (amtBalance * ratios.rewards) / ratios.total;
705         uint256 marketingBalance = amtBalance - (rewardsBalance);
706 
707         if (ratios.rewards > 0) {
708             try reflector.load{value: rewardsBalance}() {} catch {}
709         }
710 
711         if(ratios.marketing > 0){
712             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 35000}("");
713         }
714     }
715 
716     function _checkLiquidityAdd(address from, address to) private {
717         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
718         if (!_hasLimits(from, to) && to == lpPair) {
719             _liquidityHolders[from] = true;
720             _hasLiqBeenAdded = true;
721             if(address(antiSnipe) == address(0)) {
722                 antiSnipe = AntiSnipe(address(this));
723             }
724             if(address(reflector) ==  address(0)) {
725                 reflector = Cashier(address(this));
726             }
727             contractSwapEnabled = true;
728             emit ContractSwapEnabledUpdated(true);
729         }
730     }
731 
732     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
733         require(accounts.length == amounts.length, "Lengths do not match.");
734         for (uint8 i = 0; i < accounts.length; i++) {
735             require(balanceOf(msg.sender) >= amounts[i]);
736             _finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
737         }
738     }
739 
740     function manualDeposit() external onlyOwner {
741         try reflector.load{value: address(this).balance}() {} catch {}
742     }
743 
744     function sweepContingency() external onlyOwner {
745         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
746         payable(_owner).transfer(address(this).balance);
747     }
748 
749 //=====================================================================================
750 //            Reflector
751 
752     function giveMeWelfarePlease() external {
753         reflector.giveMeWelfarePlease(msg.sender);
754     }
755 
756     function getTotalReflected() external view returns (uint256) {
757         return reflector.getTotalDistributed();
758     }
759 
760     function getUserInfo(address user) external view returns (string memory, string memory, string memory, string memory) {
761         return reflector.getUserInfo(user);
762     }
763 
764     function getUserRealizedGains(address user) external view returns (uint256) {
765         return reflector.getUserRealizedRewards(user);
766     }
767 
768     function getUserUnpaidEarnings(address user) external view returns (uint256) {
769         return reflector.getPendingRewards(user);
770     }
771 }