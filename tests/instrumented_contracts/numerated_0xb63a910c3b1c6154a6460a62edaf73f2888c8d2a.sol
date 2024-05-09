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
98     function getInitializers() external view returns (string memory, string memory, uint256, uint8);
99 
100     function fullReset() external;
101 }
102 
103 interface Cashier {
104     function setReflectionCriteria(uint256 _minPeriod, uint256 _minReflection) external;
105     function tally(address shareholder, uint256 amount) external;
106     function load() external payable;
107     function cashout(uint256 gas) external;
108     function giveMeWelfarePlease(address hobo) external;
109     function getTotalDistributed() external view returns(uint256);
110     function getShareholderInfo(address shareholder) external view returns(string memory, string memory, string memory, string memory);
111     function getShareholderRealized(address shareholder) external view returns (uint256);
112     function getPendingRewards(address shareholder) external view returns (uint256);
113     function initialize() external;
114 }
115 
116 contract KingFlotamalon is IERC20 {
117     // Ownership moved to in-contract for customizability.
118     address private _owner;
119 
120     mapping (address => uint256) _tOwned;
121     mapping (address => bool) lpPairs;
122     uint256 private timeSinceLastPair = 0;
123     mapping (address => mapping (address => uint256)) _allowances;
124     mapping (address => bool) private _isExcludedFromFees;
125     mapping (address => bool) private _isExcludedFromLimits;
126     mapping (address => bool) private _isExcludedFromDividends;
127     mapping (address => bool) private _liquidityHolders;
128 
129     uint256 constant private startingSupply = 1_000_000_000_000;
130 
131     string constant private _name = "King Flotamalon";
132     string constant private _symbol = "KF";
133     uint8 constant private _decimals = 9;
134 
135     uint256 constant private _tTotal = startingSupply * (10 ** _decimals);
136 
137     struct Fees {
138         uint16 buyFee;
139         uint16 sellFee;
140         uint16 transferFee;
141         uint16 boostBuyFee;
142         uint16 boostSellFee;
143         uint16 boostTransferFee;
144     }
145 
146     struct Ratios {
147         uint16 rewards;
148         uint16 liquidity;
149         uint16 marketing;
150         uint16 buyback;
151         uint16 dev;
152         uint16 winner;
153         uint16 total;
154     }
155 
156     Fees public _taxRates = Fees({
157         buyFee: 1500,
158         sellFee: 2500,
159         transferFee: 0,
160         boostBuyFee: 2500,
161         boostSellFee: 2500,
162         boostTransferFee: 2500
163         });
164 
165     Ratios public _ratios = Ratios({
166         rewards: 15,
167         liquidity: 5,
168         marketing: 15,
169         buyback: 5,
170         dev: 0,
171         winner: 0,
172         total: 40
173         });
174 
175     uint256 constant public maxBuyTaxes = 2500;
176     uint256 constant public maxSellTaxes = 2500;
177     uint256 constant public maxTransferTaxes = 2500;
178     uint256 constant masterTaxDivisor = 10000;
179 
180     IRouter02 public dexRouter;
181     address public lpPair;
182 
183     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
184     address constant private ZERO = 0x0000000000000000000000000000000000000000;
185 
186     struct TaxWallets {
187         address payable marketing;
188         address payable dev;
189         address payable winner;
190     }
191 
192     TaxWallets public _taxWallets = TaxWallets({
193         marketing: payable(0x2A034fc3c1552Ab065b152d4560C7eD3e254942C),
194         dev: payable(0x7A24FFFb6d565a3650EEE3aCDA64eA74b1Cc1D0C),
195         winner: payable(address(0))
196         });
197 
198 
199     uint256 private _maxTxAmount = (_tTotal * 100) / 100;
200     uint256 private _maxWalletSize = (_tTotal * 2) / 100;
201 
202     Cashier reflector;
203     uint256 reflectorGas = 300000;
204 
205     bool inSwap;
206     bool public contractSwapEnabled = false;
207     uint256 public contractSwapTimer = 10 seconds;
208     uint256 private lastSwap;
209     uint256 public swapThreshold = (_tTotal * 5) / 10000;
210     uint256 public swapAmount = (_tTotal * 20) / 10000;
211     bool public processReflect = false;
212 
213     bool public tradingEnabled = false;
214     bool public _hasLiqBeenAdded = false;
215     AntiSnipe antiSnipe;
216 
217     bool public boostedTaxesEnabled = false;
218     uint256 public boostedTaxTimestampEnd;
219 
220     modifier swapping() {
221         inSwap = true;
222         _;
223         inSwap = false;
224     }
225 
226     modifier onlyOwner() {
227         require(_owner == msg.sender, "Ownable: caller is not the owner");
228         _;
229     }
230 
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232     event ContractSwapEnabledUpdated(bool enabled);
233     event AutoLiquify(uint256 amountBNB, uint256 amount);
234     event SniperCaught(address sniperAddress);
235 
236     constructor () payable {
237         // Set the owner.
238         _owner = msg.sender;
239 
240         _tOwned[_owner] = _tTotal;
241         emit Transfer(ZERO, _owner, _tTotal);
242         emit OwnershipTransferred(address(0), _owner);
243 
244         if (block.chainid == 56) {
245             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
246         } else if (block.chainid == 97) {
247             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
248         } else if (block.chainid == 1 || block.chainid == 4) {
249             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
250         } else if (block.chainid == 43114) {
251             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
252         } else if (block.chainid == 250) {
253             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
254         } else {
255             revert();
256         }
257 
258         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
259         lpPairs[lpPair] = true;
260 
261         _approve(_owner, address(dexRouter), type(uint256).max);
262         _approve(address(this), address(dexRouter), type(uint256).max);
263 
264         _isExcludedFromFees[_owner] = true;
265         _isExcludedFromFees[address(this)] = true;
266         _isExcludedFromFees[DEAD] = true;
267         _isExcludedFromDividends[_owner] = true;
268         _isExcludedFromDividends[lpPair] = true;
269         _isExcludedFromDividends[address(this)] = true;
270         _isExcludedFromDividends[DEAD] = true;
271         _isExcludedFromDividends[ZERO] = true;
272     }
273 
274 //===============================================================================================================
275 //===============================================================================================================
276 //===============================================================================================================
277     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
278     // This allows for removal of ownership privileges from the owner once renounced or transferred.
279     function transferOwner(address newOwner) external onlyOwner {
280         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
281         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
282         _isExcludedFromFees[_owner] = false;
283         _isExcludedFromDividends[_owner] = false;
284         _isExcludedFromFees[newOwner] = true;
285         _isExcludedFromDividends[newOwner] = true;
286         
287         if(_tOwned[_owner] > 0) {
288             _transfer(_owner, newOwner, _tOwned[_owner]);
289         }
290         
291         _owner = newOwner;
292         emit OwnershipTransferred(_owner, newOwner);
293         
294     }
295 
296     function renounceOwnership() public virtual onlyOwner {
297         _isExcludedFromFees[_owner] = false;
298         _isExcludedFromDividends[_owner] = false;
299         _owner = address(0);
300         emit OwnershipTransferred(_owner, address(0));
301     }
302 //===============================================================================================================
303 //===============================================================================================================
304 //===============================================================================================================
305 
306     receive() external payable {}
307 
308     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
309     function decimals() external pure override returns (uint8) { return _decimals; }
310     function symbol() external pure override returns (string memory) { return _symbol; }
311     function name() external pure override returns (string memory) { return _name; }
312     function getOwner() external view override returns (address) { return _owner; }
313     function balanceOf(address account) public view override returns (uint256) { return _tOwned[account]; }
314     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
315 
316     function approve(address spender, uint256 amount) public override returns (bool) {
317         _allowances[msg.sender][spender] = amount;
318         emit Approval(msg.sender, spender, amount);
319         return true;
320     }
321 
322     function _approve(address sender, address spender, uint256 amount) private {
323         require(sender != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325 
326         _allowances[sender][spender] = amount;
327         emit Approval(sender, spender, amount);
328     }
329 
330     function approveContractContingency() public onlyOwner returns (bool) {
331         _approve(address(this), address(dexRouter), type(uint256).max);
332         return true;
333     }
334 
335     function transfer(address recipient, uint256 amount) external override returns (bool) {
336         return _transfer(msg.sender, recipient, amount);
337     }
338 
339     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
340         if (_allowances[sender][msg.sender] != type(uint256).max) {
341             _allowances[sender][msg.sender] -= amount;
342         }
343 
344         return _transfer(sender, recipient, amount);
345     }
346 
347     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
348         antiSnipe.setBlacklistEnabled(account, enabled);
349         setDividendExcluded(account, enabled);
350     }
351 
352     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
353         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
354     }
355 
356     function isBlacklisted(address account) public view returns (bool) {
357         return antiSnipe.isBlacklisted(account);
358     }
359 
360     function setInitializers(address aInitializer, address cInitializer) external onlyOwner {
361         require(!_hasLiqBeenAdded);
362         require(cInitializer != address(this) && aInitializer != address(this) && cInitializer != aInitializer);
363         reflector = Cashier(cInitializer);
364         antiSnipe = AntiSnipe(aInitializer);
365     }
366 
367     function removeSniper(address account) external onlyOwner {
368         antiSnipe.removeSniper(account);
369     }
370 
371     function removeBlacklisted(address account) external onlyOwner {
372         antiSnipe.removeBlacklisted(account);
373     }
374 
375     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _antiSpecial) external onlyOwner {
376         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _antiSpecial);
377     }
378 
379     function setGasPriceLimit(uint256 gas) external onlyOwner {
380         require(gas >= 250, "Too low.");
381         antiSnipe.setGasPriceLimit(gas);
382     }
383 
384     function enableTrading() public onlyOwner {
385         require(!tradingEnabled, "Trading already enabled!");
386         require(_hasLiqBeenAdded, "Liquidity must be added.");
387         if(address(antiSnipe) == address(0)){
388             antiSnipe = AntiSnipe(address(this));
389         }
390         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
391         try reflector.initialize() {} catch {}
392         tradingEnabled = true;
393         swapThreshold = (balanceOf(lpPair) * 5) / 10000;
394         swapAmount = (balanceOf(lpPair) * 1) / 1000;
395     }
396 
397     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
398         require(buyFee <= maxBuyTaxes
399                 && sellFee <= maxSellTaxes
400                 && transferFee <= maxTransferTaxes);
401         _taxRates.buyFee = buyFee;
402         _taxRates.sellFee = sellFee;
403         _taxRates.transferFee = transferFee;
404     }
405 
406     function setBoostedTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
407         require(buyFee <= maxBuyTaxes
408                 && sellFee <= maxSellTaxes
409                 && transferFee <= maxTransferTaxes);
410         _taxRates.boostBuyFee = buyFee;
411         _taxRates.boostSellFee = sellFee;
412         _taxRates.boostTransferFee = transferFee;
413     }
414 
415     function setRatios(uint16 rewards, uint16 liquidity, uint16 marketing, uint16 dev, uint16 buyback, uint16 winner) external onlyOwner {
416         if(winner > 0) {
417             require(_taxWallets.winner != address(0));
418         }
419         _ratios.rewards = rewards;
420         _ratios.liquidity = liquidity;
421         _ratios.marketing = marketing;
422         _ratios.dev = dev;
423         _ratios.buyback = buyback;
424         _ratios.winner = winner;
425         _ratios.total = rewards + liquidity + marketing + dev + buyback + winner;
426     }
427 
428     function setWallets(address payable marketing, address payable dev) external onlyOwner {
429         _taxWallets.marketing = payable(marketing);
430         _taxWallets.dev = payable(dev);
431     }
432 
433     function setWinnerWallet(address payable wallet) external onlyOwner {
434         _taxWallets.winner = wallet;
435     }
436 
437     function setContractSwapSettings(bool _enabled, bool processReflectEnabled) external onlyOwner {
438         contractSwapEnabled = _enabled;
439         processReflect = processReflectEnabled;
440     }
441 
442     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
443         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
444         swapAmount = (_tTotal * amountPercent) / amountDivisor;
445         contractSwapTimer = time;
446     }
447 
448     function setReflectionCriteria(uint256 _minPeriod, uint256 _minReflection, uint256 minReflectionMultiplier) external onlyOwner {
449         _minReflection = _minReflection * 10**minReflectionMultiplier;
450         reflector.setReflectionCriteria(_minPeriod, _minReflection);
451     }
452 
453     function setReflectorSettings(uint256 gas) external onlyOwner {
454         require(gas < 750000);
455         reflectorGas = gas;
456     }
457 
458     function giveMeWelfarePlease() external {
459         reflector.giveMeWelfarePlease(msg.sender);
460     }
461 
462     function getTotalReflected() external view returns (uint256) {
463         return reflector.getTotalDistributed();
464     }
465 
466     function getUserInfo(address shareholder) external view returns (string memory, string memory, string memory, string memory) {
467         return reflector.getShareholderInfo(shareholder);
468     }
469 
470     function getUserRealizedGains(address shareholder) external view returns (uint256) {
471         return reflector.getShareholderRealized(shareholder);
472     }
473 
474     function getUserUnpaidEarnings(address shareholder) external view returns (uint256) {
475         return reflector.getPendingRewards(shareholder);
476     }
477 
478     function setNewRouter(address newRouter) external onlyOwner {
479         IRouter02 _newRouter = IRouter02(newRouter);
480         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
481         if (get_pair == address(0)) {
482             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
483         }
484         else {
485             lpPair = get_pair;
486         }
487         dexRouter = _newRouter;
488         _approve(address(this), address(dexRouter), type(uint256).max);
489     }
490 
491     function setLpPair(address pair, bool enabled) external onlyOwner {
492         if (enabled == false) {
493             lpPairs[pair] = false;
494             antiSnipe.setLpPair(pair, false);
495         } else {
496             if (timeSinceLastPair != 0) {
497                 require(block.timestamp - timeSinceLastPair > 3 days, "Cannot set a new pair this week!");
498             }
499             lpPairs[pair] = true;
500             timeSinceLastPair = block.timestamp;
501             antiSnipe.setLpPair(pair, true);
502         }
503     }
504 
505     function isExcludedFromFees(address account) public view returns(bool) {
506         return _isExcludedFromFees[account];
507     }
508 
509     function isExcludedFromDividends(address account) public view returns(bool) {
510         return _isExcludedFromDividends[account];
511     }
512 
513     function isExcludedFromLimits(address account) public view returns (bool) {
514         return _isExcludedFromLimits[account];
515     }
516 
517     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
518         _isExcludedFromLimits[account] = enabled;
519     }
520 
521     function setDividendExcluded(address holder, bool enabled) public onlyOwner {
522         require(holder != address(this) && holder != lpPair);
523         _isExcludedFromDividends[holder] = enabled;
524         if (enabled) {
525             reflector.tally(holder, 0);
526         } else {
527             reflector.tally(holder, _tOwned[holder]);
528         }
529     }
530 
531     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
532         _isExcludedFromFees[account] = enabled;
533     }
534 
535     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
536         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
537         _maxTxAmount = (_tTotal * percent) / divisor;
538     }
539 
540     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
541         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
542         _maxWalletSize = (_tTotal * percent) / divisor;
543     }
544 
545     function getMaxTX() public view returns (uint256) {
546         return _maxTxAmount / (10**_decimals);
547     }
548 
549     function getMaxWallet() public view returns (uint256) {
550         return _maxWalletSize / (10**_decimals);
551     }
552 
553     function _hasLimits(address from, address to) internal view returns (bool) {
554         return from != _owner
555             && to != _owner
556             && tx.origin != _owner
557             && !_liquidityHolders[to]
558             && !_liquidityHolders[from]
559             && to != DEAD
560             && to != address(0)
561             && from != address(this);
562     }
563 
564     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
565         require(from != address(0), "ERC20: transfer from the zero address");
566         require(to != address(0), "ERC20: transfer to the zero address");
567         require(amount > 0, "Transfer amount must be greater than zero");
568         bool buy = false;
569         bool sell = false;
570         bool other = false;
571         if (lpPairs[from]) {
572             buy = true;
573         } else if (lpPairs[to]) {
574             sell = true;
575         } else {
576             other = true;
577         }
578         if(_hasLimits(from, to)) {
579             if(!tradingEnabled) {
580                 revert("Trading not yet enabled!");
581             }
582             if(buy || sell){
583                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
584                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
585                 }
586             }
587             if(to != address(dexRouter) && !sell) {
588                 if (!_isExcludedFromLimits[to]) {
589                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
590                 }
591             }
592         }
593 
594         bool takeFee = true;
595         
596         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
597             takeFee = false;
598         }
599 
600         return _finalizeTransfer(from, to, amount, takeFee, buy, sell, other);
601     }
602 
603     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee, bool buy, bool sell, bool other) internal returns (bool) {
604         if (!_hasLiqBeenAdded) {
605             _checkLiquidityAdd(from, to);
606             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
607                 revert("Only owner can transfer at this time.");
608             }
609         }
610 
611         if(_hasLimits(from, to)) {
612             bool checked;
613             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
614                 checked = check;
615             } catch {
616                 revert();
617             }
618 
619             if(!checked) {
620                 revert();
621             }
622         }
623 
624         _tOwned[from] -= amount;
625 
626         if (sell) {
627             if (!inSwap
628                 && contractSwapEnabled
629             ) {
630                 if (lastSwap + contractSwapTimer < block.timestamp) {
631                     uint256 contractTokenBalance = balanceOf(address(this));
632                     if (contractTokenBalance >= swapThreshold) {
633                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
634                         contractSwap(contractTokenBalance);
635                         lastSwap = block.timestamp;
636                     }
637                 }
638             }      
639         } 
640 
641         uint256 amountReceived = amount;
642 
643         if (takeFee) {
644             amountReceived = takeTaxes(from, amount, buy, sell, other);
645         }
646 
647         _tOwned[to] += amountReceived;
648 
649         processTokenReflect(from, to);
650 
651         emit Transfer(from, to, amountReceived);
652         return true;
653     }
654 
655     function processTokenReflect(address from, address to) internal {
656         if (!_isExcludedFromDividends[from]) {
657             try reflector.tally(from, _tOwned[from]) {} catch {}
658         }
659         if (!_isExcludedFromDividends[to]) {
660             try reflector.tally(to, _tOwned[to]) {} catch {}
661         }
662         if (processReflect) {
663             try reflector.cashout(reflectorGas) {} catch {}
664         }
665     }
666 
667     function _basicTransfer(address from, address to, uint256 amount) internal returns (bool) {
668         _tOwned[from] -= amount;
669         _tOwned[to] += amount;
670         emit Transfer(from, to, amount);
671         return true;
672     }
673 
674     function takeTaxes(address from, uint256 amount, bool buy, bool sell, bool other) internal returns (uint256) {
675         uint256 currentFee;
676         if (block.timestamp < boostedTaxTimestampEnd) {
677             if (buy) {
678                 currentFee = _taxRates.boostBuyFee;
679             } else if (sell) {
680                 currentFee = _taxRates.boostSellFee;
681             } else {
682                 currentFee = _taxRates.boostTransferFee;
683             }
684         } else {
685             if (buy) {
686                 currentFee = _taxRates.buyFee;
687             } else if (sell) {
688                 currentFee = _taxRates.sellFee;
689             } else {
690                 currentFee = _taxRates.transferFee;
691             }
692         }
693 
694         if (currentFee == 0) {
695             return amount;
696         }
697 
698         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
699 
700         _tOwned[address(this)] += feeAmount;
701         emit Transfer(from, address(this), feeAmount);
702 
703         return amount - feeAmount;
704     }
705 
706     function contractSwap(uint256 contractTokenBalance) internal swapping {
707         Ratios memory ratios = _ratios;
708         if (ratios.total == 0) {
709             return;
710         }
711         
712         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
713             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
714         }
715 
716         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / (ratios.total)) / 2;
717         uint256 swapAmt = contractTokenBalance - toLiquify;
718 
719         address[] memory path = new address[](2);
720         path[0] = address(this);
721         path[1] = dexRouter.WETH();
722 
723         uint256 initial = address(this).balance;
724 
725         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
726             swapAmt,
727             0,
728             path,
729             address(this),
730             block.timestamp
731         );
732 
733         uint256 amtBalance = address(this).balance - initial;
734         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
735 
736         if (toLiquify > 0) {
737             dexRouter.addLiquidityETH{value: liquidityBalance}(
738                 address(this),
739                 toLiquify,
740                 0,
741                 0,
742                 DEAD,
743                 block.timestamp
744             );
745             emit AutoLiquify(liquidityBalance, toLiquify);
746         }
747 
748         amtBalance -= liquidityBalance;
749         ratios.total -= ratios.liquidity;
750         uint256 rewardsBalance = (amtBalance * ratios.rewards) / ratios.total;
751         uint256 devBalance = (amtBalance * ratios.dev) / ratios.total;
752         uint256 buybackBalance = (amtBalance * ratios.buyback) / ratios.total;
753         uint256 winnerBalance = (amtBalance * ratios.winner) / ratios.total;
754         uint256 marketingBalance = amtBalance - (rewardsBalance + devBalance + buybackBalance + winnerBalance);
755 
756         if (ratios.rewards > 0) {
757             try reflector.load{value: rewardsBalance}() {} catch {}
758         }
759 
760         if(ratios.dev > 0){
761             _taxWallets.dev.transfer(devBalance);
762         }
763         if(ratios.marketing > 0){
764             _taxWallets.marketing.transfer(marketingBalance);
765         }
766         if(ratios.winner > 0) {
767             _taxWallets.winner.transfer(winnerBalance);
768         }
769     }
770 
771     function buybackAndBurn(uint256 boostTime, uint256 amount, uint256 multiplier) external onlyOwner {
772         require(address(this).balance >= amount * 10**multiplier);
773         address[] memory path = new address[](2);
774         path[0] = dexRouter.WETH();
775         path[1] = address(this);
776 
777         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens
778         {value: amount*10**multiplier} (
779             0,
780             path,
781             DEAD,
782             block.timestamp
783         );
784         setBoostedTaxes(boostTime);
785     }
786 
787     function setBoostedTaxesEnabled(bool enabled) external onlyOwner {
788         if(!enabled) {
789             boostedTaxTimestampEnd = 0;
790         }
791         boostedTaxesEnabled = enabled;
792     }
793 
794     function setBoostedTaxes(uint256 timeInSeconds) public {
795         require(msg.sender == address(this) || msg.sender == _owner);
796         require(timeInSeconds <= 24 hours);
797         boostedTaxTimestampEnd = block.timestamp + timeInSeconds;
798     }
799 
800     function _checkLiquidityAdd(address from, address to) private {
801         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
802         if (!_hasLimits(from, to) && to == lpPair) {
803             _liquidityHolders[from] = true;
804             _hasLiqBeenAdded = true;
805             if(address(antiSnipe) == address(0)) {
806                 antiSnipe = AntiSnipe(address(this));
807             }
808             if(address(reflector) ==  address(0)) {
809                 reflector = Cashier(address(this));
810             }
811             contractSwapEnabled = true;
812             emit ContractSwapEnabledUpdated(true);
813         }
814     }
815 
816     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
817         require(accounts.length == amounts.length, "Lengths do not match.");
818         for (uint8 i = 0; i < accounts.length; i++) {
819             require(balanceOf(msg.sender) >= amounts[i]);
820             _finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, false, true);
821         }
822     }
823 
824     function manualDeposit() external onlyOwner {
825         try reflector.load{value: address(this).balance}() {} catch {}
826     }
827 }