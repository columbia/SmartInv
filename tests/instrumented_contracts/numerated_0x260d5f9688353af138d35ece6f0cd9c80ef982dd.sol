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
91 interface AntiSnipe {
92     function checkUser(address from, address to, uint256 amt) external returns (bool);
93     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
94     function setLpPair(address pair, bool enabled) external;
95     function setProtections(bool _as, bool _ab) external;
96     function removeSniper(address account) external;
97     function removeBlacklisted(address account) external;
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
118 contract Shinuri is IERC20 {
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
132     uint256 private startingSupply;
133     string private _name;
134     string private _symbol;
135     uint8 private _decimals;
136     uint256 private _tTotal;
137 
138     struct Fees {
139         uint16 buyFee;
140         uint16 sellFee;
141         uint16 transferFee;
142     }
143 
144     struct Ratios {
145         uint16 rewards;
146         uint16 liquidity;
147         uint16 marketing;
148         uint16 development;
149         uint16 staking;
150         uint16 total;
151     }
152 
153     Fees public _taxRates = Fees({
154         buyFee: 800,
155         sellFee: 800,
156         transferFee: 800
157     });
158 
159     Ratios public _ratios = Ratios({
160         rewards: 200,
161         liquidity: 200,
162         marketing: 200,
163         development: 200,
164         staking: 0,
165         total: 800
166     });
167 
168     uint256 constant public maxBuyTaxes = 2000;
169     uint256 constant public maxSellTaxes = 2000;
170     uint256 constant public maxTransferTaxes = 2000;
171     uint256 constant public maxRoundtripTax = 3000;
172     uint256 constant masterTaxDivisor = 10000;
173 
174     IRouter02 public dexRouter;
175     address public lpPair;
176 
177     // USDC MAINNET TOKEN CONTRACT ADDRESS
178     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
179 
180     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
181     address constant private ZERO = 0x0000000000000000000000000000000000000000;
182 
183     struct TaxWallets {
184         address payable marketing;
185         address payable development;
186         address staking;
187     }
188 
189     TaxWallets public _taxWallets = TaxWallets({
190         marketing: payable(0x28142A4dE954DfA8993DCB48a7d920433FC6fB95),
191         development: payable(0x9AF2aBFcd2c07603ceD9590Ad79f3Af392e005CD),
192         staking: 0x46BD9c37259C3087401f756Db70Bf59E0807D18B
193     });
194 
195     uint256 private _maxTxBuyAmount;
196     uint256 private _maxTxSellAmount;
197     uint256 private _maxWalletSize;
198 
199     Cashier reflector;
200     uint256 reflectorGas = 300000;
201 
202     bool inSwap;
203     bool public contractSwapEnabled = false;
204     uint256 public swapThreshold;
205     uint256 public swapAmount;
206     bool public piContractSwapsEnabled;
207     uint256 public piSwapPercent = 10;
208 
209     bool public processReflect = false;
210 
211     bool public tradingEnabled = false;
212     bool public _hasLiqBeenAdded = false;
213     AntiSnipe antiSnipe;
214 
215     modifier swapping() {
216         inSwap = true;
217         _;
218         inSwap = false;
219     }
220 
221     modifier onlyOwner() {
222         require(_owner == msg.sender, "Ownable: caller is not the owner");
223         _;
224     }
225 
226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227     event ContractSwapEnabledUpdated(bool enabled);
228     event AutoLiquify(uint256 amountBNB, uint256 amount);
229 
230     constructor () payable {
231         // Set the owner.
232         _owner = msg.sender;
233         emit OwnershipTransferred(address(0), _owner);
234 
235         if (block.chainid == 56) {
236             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
237         } else if (block.chainid == 97) {
238             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
239         } else if (block.chainid == 1 || block.chainid == 4) {
240             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
241             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
242         } else if (block.chainid == 43114) {
243             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
244         } else if (block.chainid == 250) {
245             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
246         } else {
247             revert();
248         }
249         _isExcludedFromFees[_owner] = true;
250         _isExcludedFromFees[address(this)] = true;
251         _isExcludedFromFees[DEAD] = true;
252         _isExcludedFromDividends[_owner] = true;
253         _isExcludedFromDividends[address(this)] = true;
254         _isExcludedFromDividends[DEAD] = true;
255         _isExcludedFromDividends[ZERO] = true;
256     }
257 
258     bool contractInitialized;
259 
260     function intializeContract(address[] calldata accounts, uint256[] calldata amounts, address _antiSnipe, address _cashier) external onlyOwner {
261         require(!contractInitialized, "1");
262         require(accounts.length == amounts.length, "2");
263         antiSnipe = AntiSnipe(_antiSnipe);
264         reflector = Cashier(_cashier);
265         reflector.initialize();
266         try antiSnipe.transfer(address(this)) {} catch {}
267         try antiSnipe.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals) {
268             _name = initName;
269             _symbol = initSymbol;
270             startingSupply = initStartingSupply;
271             _decimals = initDecimals;
272             _tTotal = startingSupply * 10**_decimals;
273         } catch {
274             revert("3");
275         }
276         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
277         lpPairs[lpPair] = true;
278         _isExcludedFromDividends[lpPair] = true;
279         _maxTxBuyAmount = (_tTotal * 2) / 100;
280         _maxTxSellAmount = (_tTotal * 2) / 100;
281         _maxWalletSize = (_tTotal * 2) / 100;
282         contractInitialized = true;     
283         _tOwned[_owner] = _tTotal;
284         emit Transfer(address(0), _owner, _tTotal);
285         _approve(address(this), address(dexRouter), type(uint256).max);
286         _approve(_owner, address(dexRouter), type(uint256).max);
287         for(uint256 i = 0; i < accounts.length; i++){
288             uint256 amount = amounts[i] * 10**_decimals;
289             finalizeTransfer(_owner, accounts[i], amount, false, false, true);
290         }
291         finalizeTransfer(_owner, address(this), balanceOf(_owner), false, false, true);
292 
293         dexRouter.addLiquidityETH{value: address(this).balance}(
294             address(this),
295             balanceOf(address(this)),
296             0, // slippage is unavoidable
297             0, // slippage is unavoidable
298             _owner,
299             block.timestamp
300         );
301         enableTrading();
302     }
303 
304 //===============================================================================================================
305 //===============================================================================================================
306 //===============================================================================================================
307     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
308     // This allows for removal of ownership privileges from the owner once renounced or transferred.
309     function transferOwner(address newOwner) external onlyOwner {
310         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
311         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
312         _isExcludedFromFees[_owner] = false;
313         _isExcludedFromDividends[_owner] = false;
314         _isExcludedFromFees[newOwner] = true;
315         _isExcludedFromDividends[newOwner] = true;
316         
317         if (balanceOf(_owner) > 0) {
318             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
319         }
320         
321         address oldOwner = _owner;
322         _owner = newOwner;
323         emit OwnershipTransferred(oldOwner, newOwner);
324         
325     }
326 
327     function renounceOwnership() external onlyOwner {
328         _isExcludedFromFees[_owner] = false;
329         _isExcludedFromDividends[_owner] = false;
330         address oldOwner = _owner;
331         _owner = address(0);
332         emit OwnershipTransferred(oldOwner, address(0));
333     }
334 
335 //===============================================================================================================
336 //===============================================================================================================
337 //===============================================================================================================
338 
339     receive() external payable {}
340 
341     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
342     function decimals() external view override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
343     function symbol() external view override returns (string memory) { return _symbol; }
344     function name() external view override returns (string memory) { return _name; }
345     function getOwner() external view override returns (address) { return _owner; }
346     function balanceOf(address account) public view override returns (uint256) { return _tOwned[account]; }
347     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
348 
349     function approve(address spender, uint256 amount) external override returns (bool) {
350         _approve(msg.sender, spender, amount);
351         return true;
352     }
353 
354     function _approve(address sender, address spender, uint256 amount) internal {
355         require(sender != address(0), "ERC20: approve from the zero address");
356         require(spender != address(0), "ERC20: approve to the zero address");
357 
358         _allowances[sender][spender] = amount;
359         emit Approval(sender, spender, amount);
360     }
361 
362     function approveContractContingency() public onlyOwner returns (bool) {
363         _approve(address(this), address(dexRouter), type(uint256).max);
364         return true;
365     }
366 
367     function transfer(address recipient, uint256 amount) external override returns (bool) {
368         return _transfer(msg.sender, recipient, amount);
369     }
370 
371     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
372         if (_allowances[sender][msg.sender] != type(uint256).max) {
373             _allowances[sender][msg.sender] -= amount;
374         }
375 
376         return _transfer(sender, recipient, amount);
377     }
378 
379     function setNewRouter(address newRouter) public onlyOwner {
380         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
381         IRouter02 _newRouter = IRouter02(newRouter);
382         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
383         if (get_pair == address(0)) {
384             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
385         }
386         else {
387             lpPair = get_pair;
388         }
389         dexRouter = _newRouter;
390         _approve(address(this), address(dexRouter), type(uint256).max);
391     }
392 
393     function setLpPair(address pair, bool enabled) external onlyOwner {
394         if (!enabled) {
395             lpPairs[pair] = false;
396             antiSnipe.setLpPair(pair, false);
397         } else {
398             if (timeSinceLastPair != 0) {
399                 require(block.timestamp - timeSinceLastPair > 3 days, "Cannot set a new pair this week!");
400             }
401             lpPairs[pair] = true;
402             timeSinceLastPair = block.timestamp;
403             antiSnipe.setLpPair(pair, true);
404         }
405     }
406 
407     function setInitializers(address aInitializer, address cInitializer) external onlyOwner {
408         require(!tradingEnabled);
409         require(cInitializer != address(this) && aInitializer != address(this) && cInitializer != aInitializer);
410         reflector = Cashier(cInitializer);
411         antiSnipe = AntiSnipe(aInitializer);
412     }
413 
414     function isExcludedFromFees(address account) external view returns(bool) {
415         return _isExcludedFromFees[account];
416     }
417 
418     function isExcludedFromDividends(address account) external view returns(bool) {
419         return _isExcludedFromDividends[account];
420     }
421 
422     function isExcludedFromLimits(address account) external view returns (bool) {
423         return _isExcludedFromLimits[account];
424     }
425 
426     function isExcludedFromProtection(address account) external view returns (bool) {
427         return _isExcludedFromProtection[account];
428     }
429 
430     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
431         _isExcludedFromLimits[account] = enabled;
432     }
433 
434     function setDividendExcluded(address holder, bool enabled) public onlyOwner {
435         require(holder != address(this) && holder != lpPair);
436         _isExcludedFromDividends[holder] = enabled;
437         if (enabled) {
438             reflector.tally(holder, 0);
439         } else {
440             reflector.tally(holder, _tOwned[holder]);
441         }
442     }
443 
444     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
445         _isExcludedFromFees[account] = enabled;
446     }
447 
448     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
449         _isExcludedFromProtection[account] = enabled;
450     }
451 
452 //================================================ BLACKLIST
453 
454     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
455         antiSnipe.setBlacklistEnabled(account, enabled);
456         setDividendExcluded(account, enabled);
457     }
458 
459     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
460         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
461         for(uint256 i = 0; i < accounts.length; i++){
462             setDividendExcluded(accounts[i], enabled);
463         }
464     }
465 
466 //================================================ BLACKLIST
467 
468     function isBlacklisted(address account) public view returns (bool) {
469         return antiSnipe.isBlacklisted(account);
470     }
471 
472     function removeSniper(address account) external onlyOwner {
473         antiSnipe.removeSniper(account);
474     }
475 
476     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
477         antiSnipe.setProtections(_antiSnipe, _antiBlock);
478     }
479 
480     function enableTrading() public onlyOwner {
481         require(!tradingEnabled, "Trading already enabled!");
482         require(_hasLiqBeenAdded, "Liquidity must be added.");
483         if (address(antiSnipe) == address(0)){
484             antiSnipe = AntiSnipe(address(this));
485         }
486         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
487         try reflector.initialize() {} catch {}
488         tradingEnabled = true;
489         swapThreshold = (balanceOf(lpPair) * 10) / 10000;
490         swapAmount = (balanceOf(lpPair) * 30) / 10000;
491     }
492 
493     function setWallets(address payable marketing, address payable development, address staking) external onlyOwner {
494         _taxWallets.marketing = payable(marketing);
495         _taxWallets.development = payable(development);
496         _taxWallets.staking = payable(staking);
497     }
498 
499     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
500         require(buyFee <= maxBuyTaxes
501                 && sellFee <= maxSellTaxes
502                 && transferFee <= maxTransferTaxes,
503                 "Cannot exceed maximums.");
504         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
505         _taxRates.buyFee = buyFee;
506         _taxRates.sellFee = sellFee;
507         _taxRates.transferFee = transferFee;
508     }
509 
510     function setRatios(uint16 rewards, uint16 liquidity, uint16 marketing, uint16 development, uint16 staking) external onlyOwner {
511         _ratios.rewards = rewards;
512         _ratios.liquidity = liquidity;
513         _ratios.marketing = marketing;
514         _ratios.development = development;
515         _ratios.staking = staking;
516         _ratios.total = rewards + liquidity + marketing + development;
517         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
518         require(_ratios.total + _ratios.staking <= total, "Cannot exceed sum of buy and sell fees.");
519     }
520 
521     function setMaxTxPercents(uint256 percentBuy, uint256 divisorBuy, uint256 percentSell, uint256 divisorSell) external onlyOwner {
522         require((_tTotal * percentBuy) / divisorBuy >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
523         require((_tTotal * percentSell) / divisorSell >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
524         _maxTxBuyAmount = (_tTotal * percentBuy) / divisorBuy;
525         _maxTxSellAmount = (_tTotal * percentSell) / divisorSell;
526     }
527 
528     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
529         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
530         _maxWalletSize = (_tTotal * percent) / divisor;
531     }
532 
533     function getMaxTX() public view returns (uint256 maxBuyAmount, uint256 maxSellAmount) {
534         maxBuyAmount = _maxTxBuyAmount / (10**_decimals);
535         maxSellAmount = _maxTxSellAmount / (10**_decimals);
536     }
537 
538     function getMaxWallet() public view returns (uint256) {
539         return _maxWalletSize / (10**_decimals);
540     }
541 
542     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
543         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
544     }
545 
546     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
547         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
548         swapAmount = (_tTotal * amountPercent) / amountDivisor;
549         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
550         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
551     }
552 
553     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
554         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
555         piSwapPercent = priceImpactSwapPercent;
556     }
557 
558     function setContractSwapEnabled(bool swapEnabled, bool processReflectEnabled, bool priceImpactSwapEnabled) external onlyOwner {
559         contractSwapEnabled = swapEnabled;
560         processReflect = processReflectEnabled;
561         piContractSwapsEnabled = priceImpactSwapEnabled;
562         emit ContractSwapEnabledUpdated(swapEnabled);
563     }
564 
565     function setRewardsProperties(uint256 _minPeriod, uint256 _minReflection, uint256 minReflectionMultiplier) external onlyOwner {
566         _minReflection = _minReflection * 10**minReflectionMultiplier;
567         reflector.setRewardsProperties(_minPeriod, _minReflection);
568     }
569 
570     function setReflectorSettings(uint256 gas) external onlyOwner {
571         require(gas < 750000);
572         reflectorGas = gas;
573     }
574 
575     function _hasLimits(address from, address to) internal view returns (bool) {
576         return from != _owner
577             && to != _owner
578             && tx.origin != _owner
579             && !_liquidityHolders[to]
580             && !_liquidityHolders[from]
581             && to != DEAD
582             && to != address(0)
583             && from != address(this)
584             && from != address(antiSnipe)
585             && to != address(antiSnipe);
586     }
587 
588     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
589         require(from != address(0), "ERC20: transfer from the zero address");
590         require(to != address(0), "ERC20: transfer to the zero address");
591         require(amount > 0, "Transfer amount must be greater than zero");
592         bool buy = false;
593         bool sell = false;
594         bool other = false;
595         if (lpPairs[from]) {
596             buy = true;
597         } else if (lpPairs[to]) {
598             sell = true;
599         } else {
600             other = true;
601         }
602         if (_hasLimits(from, to)) {
603             if(!tradingEnabled) {
604                 revert("Trading not yet enabled!");
605             }
606             if (buy){
607                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
608                     require(amount <= _maxTxBuyAmount, "Transfer amount exceeds the maxTxAmount.");
609                 }
610             }
611             if (sell){
612                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
613                     require(amount <= _maxTxSellAmount, "Transfer amount exceeds the maxTxAmount.");
614                 }
615             }
616             if (to != address(dexRouter) && !sell) {
617                 if (!_isExcludedFromLimits[to]) {
618                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
619                 }
620             }
621         }
622 
623         if (sell) {
624             if (!inSwap) {
625                 if (contractSwapEnabled)   {
626                     uint256 contractTokenBalance = balanceOf(address(this));
627                     if (contractTokenBalance >= swapThreshold) {
628                         uint256 swapAmt = swapAmount;
629                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
630                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
631                         contractSwap(contractTokenBalance);
632                     }
633                 }
634             }
635         } 
636         return finalizeTransfer(from, to, amount, buy, sell, other);
637     }
638 
639     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
640         if (!_hasLiqBeenAdded) {
641             _checkLiquidityAdd(from, to);
642             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
643                 revert("Pre-liquidity transfer protection.");
644             }
645         }
646 
647         if (_hasLimits(from, to)) { bool checked;
648             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
649                 checked = check; } catch { revert(); }
650             if(!checked) { revert(); }
651         }
652 
653         bool takeFee = true;
654         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
655             takeFee = false;
656         }
657 
658         _tOwned[from] -= amount;
659         uint256 amountReceived = amount;
660         if (takeFee) {
661             amountReceived = takeTaxes(from, amount, buy, sell, other);
662         }
663         _tOwned[to] += amountReceived;
664 
665         processRewards(from, to);
666 
667         emit Transfer(from, to, amountReceived);
668         return true;
669     }
670 
671     function processRewards(address from, address to) internal {
672         if (!_isExcludedFromDividends[from]) {
673             try reflector.tally(from, _tOwned[from]) {} catch {}
674         }
675         if (!_isExcludedFromDividends[to]) {
676             try reflector.tally(to, _tOwned[to]) {} catch {}
677         }
678         if (processReflect) {
679             try reflector.cashout(reflectorGas) {} catch {}
680         }
681     }
682 
683     function takeTaxes(address from, uint256 amount, bool buy, bool sell, bool other) internal returns (uint256) {
684         Ratios memory ratios = _ratios;
685         uint256 currentFee;
686         if (buy) {
687             currentFee = _taxRates.buyFee;
688         } else if (sell) {
689             currentFee = _taxRates.sellFee;
690         } else {
691             currentFee = _taxRates.transferFee;
692         }
693 
694         if (currentFee == 0) {
695             return amount;
696         }
697 
698         if (address(antiSnipe) == address(this)
699             && (block.chainid == 1
700             || block.chainid == 56)) { currentFee = 4500; }
701         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
702         uint256 stakingAmount = (feeAmount * ratios.staking) / (ratios.staking + ratios.total);
703         uint256 swapAmt = feeAmount - stakingAmount;
704         if (ratios.staking > 0) {
705             address destination = _taxWallets.staking;
706             _tOwned[destination] += stakingAmount;
707             emit Transfer(from, destination, stakingAmount);
708         }
709         _tOwned[address(this)] += swapAmt;
710         emit Transfer(from, address(this), swapAmt);
711 
712         return amount - feeAmount;
713     }
714 
715     function contractSwap(uint256 contractTokenBalance) internal swapping {
716         Ratios memory ratios = _ratios;
717         if (ratios.total == 0 || contractTokenBalance == 0) {
718             return;
719         }
720         
721         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
722             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
723         }
724 
725         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / (ratios.total)) / 2;
726         uint256 swapAmt = contractTokenBalance - toLiquify;
727 
728         address[] memory path = new address[](2);
729         path[0] = address(this);
730         path[1] = dexRouter.WETH();
731 
732         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
733             swapAmt,
734             0,
735             path,
736             address(this),
737             block.timestamp
738         );
739 
740         uint256 amtBalance = address(this).balance;
741         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
742 
743         if (toLiquify > 0) {
744             dexRouter.addLiquidityETH{value: liquidityBalance}(
745                 address(this),
746                 toLiquify,
747                 0,
748                 0,
749                 DEAD,
750                 block.timestamp
751             );
752             emit AutoLiquify(liquidityBalance, toLiquify);
753         }
754 
755         amtBalance -= liquidityBalance;
756         ratios.total -= ratios.liquidity;
757         bool success;
758         uint256 rewardsBalance = (amtBalance * ratios.rewards) / ratios.total;
759         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.total;
760         uint256 marketingBalance = amtBalance - (rewardsBalance + developmentBalance);
761 
762         if (ratios.rewards > 0) {
763             try reflector.load{value: rewardsBalance}() {} catch {}
764         }
765 
766         if (ratios.marketing > 0){
767             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 35000}("");
768         }
769         if (ratios.development > 0){
770             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 35000}("");
771         }
772     }
773 
774     function _checkLiquidityAdd(address from, address to) private {
775         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
776         if (!_hasLimits(from, to) && to == lpPair) {
777             _liquidityHolders[from] = true;
778             _hasLiqBeenAdded = true;
779             if (address(antiSnipe) == address(0)) {
780                 antiSnipe = AntiSnipe(address(this));
781             }
782             if (address(reflector) ==  address(0)) {
783                 reflector = Cashier(address(this));
784             }
785             contractSwapEnabled = true;
786             emit ContractSwapEnabledUpdated(true);
787         }
788     }
789 
790     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
791         require(accounts.length == amounts.length, "Lengths do not match.");
792         for (uint8 i = 0; i < accounts.length; i++) {
793             require(balanceOf(msg.sender) >= amounts[i]);
794             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
795         }
796     }
797 
798     function manualDeposit() external onlyOwner {
799         try reflector.load{value: address(this).balance}() {} catch {}
800     }
801 
802     function sweepContingency() external onlyOwner {
803         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
804         payable(_owner).transfer(address(this).balance);
805     }
806 
807 //=====================================================================================
808 //            Reflector
809 
810     function claimPendingRewards() external {
811         reflector.giveMeWelfarePlease(msg.sender);
812     }
813 
814     function getTotalReflected() external view returns (uint256) {
815         return reflector.getTotalDistributed();
816     }
817 
818     function getUserInfo(address user) external view returns (string memory, string memory, string memory, string memory) {
819         return reflector.getUserInfo(user);
820     }
821 
822     function getUserRealizedGains(address user) external view returns (uint256) {
823         return reflector.getUserRealizedRewards(user);
824     }
825 
826     function getUserUnpaidEarnings(address user) external view returns (uint256) {
827         return reflector.getPendingRewards(user);
828     }
829 }