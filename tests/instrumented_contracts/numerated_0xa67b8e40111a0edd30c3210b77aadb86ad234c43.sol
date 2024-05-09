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
102     function getInitializers() external view returns (string memory, string memory, uint256, uint8);
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
118 contract AirDropper {
119     address public TOKEN;
120     BananaIndex public IF_TOKEN;
121     uint256 decimals;
122     mapping (address => User) users;
123     uint256 totalNeededTokens;
124 
125     uint256 public claimDelay = 24 hours;
126     bool public delayedClaimEnabled = true;
127 
128     struct User {
129         uint256 claimableTokens;
130         uint256 lastClaimTime;
131         uint256 claimDailyLimit;
132     }
133 
134     constructor (address token, uint256 _decimals) {
135         decimals = _decimals;
136         TOKEN = token;
137         IF_TOKEN = BananaIndex(payable(token));
138     }
139 
140     modifier onlyToken() {
141         require(TOKEN == msg.sender || address(this) == msg.sender, "Ownable: caller is not the token.");
142         _;
143     }
144 
145     function getTotalNeededTokens() public view returns (uint256) {
146         return totalNeededTokens;
147     }
148 
149     function getClaimableTokens(address account) external view returns (uint256) {
150         return users[account].claimableTokens;
151     }
152 
153     function getSecondsUntilNextClaim(address account) external view returns (uint256) {
154         uint256 lastClaim = users[account].lastClaimTime;
155         if (lastClaim + claimDelay < block.timestamp) {
156             return 0;
157         } else {
158             return ((lastClaim + claimDelay) - block.timestamp);
159         }
160     }
161 
162     function setClaimDelay(uint256 time) external onlyToken {
163         require(time <= 24 hours, "Cannot set higher than 24hrs.");
164         claimDelay = time;
165     }
166 
167     function disableDelayedClaim() external onlyToken {
168         delayedClaimEnabled = false;
169     }
170 
171     function setUserToDrop(address account, uint256 tokens) public onlyToken {
172         require(users[account].claimableTokens == 0, "User already set.");
173         tokens *= (10**decimals);
174         users[account].claimableTokens = tokens;
175         users[account].lastClaimTime = 0;
176         users[account].claimDailyLimit = tokens / 20;
177         totalNeededTokens += tokens;
178     }
179 
180     function multiSet(address[] calldata accounts, uint256[] calldata tokens) external onlyToken {
181         for(uint256 i = 0; i < accounts.length; i++){
182             setUserToDrop(accounts[i], tokens[i]);
183         }
184     }
185 
186     function withdrawDailyTokens(address account) external {
187         uint256 timestamp = block.timestamp;
188         User memory user = users[account];
189         require(user.claimableTokens > 0, "No tokens available to claim.");
190         uint256 amount;
191         if (delayedClaimEnabled) {
192             require(user.lastClaimTime + claimDelay <= timestamp, "Cannot claim again yet.");
193             if (user.claimableTokens > user.claimDailyLimit) {
194                 amount = user.claimDailyLimit;
195             } else {
196                 amount = users[account].claimableTokens;
197             }
198             users[account].lastClaimTime = timestamp;
199         } else {
200             amount = users[account].claimableTokens;
201         }
202         users[account].claimableTokens -= amount;
203         totalNeededTokens -= amount;
204         IF_TOKEN._basicTransfer(address(this), account, amount);
205     }
206 
207     function depositTokens() external  onlyToken{
208         address owner = IF_TOKEN.getOwner();
209         uint256 needed = getTotalNeededTokens() - IF_TOKEN.balanceOf(address(this));
210         IF_TOKEN._basicTransfer(owner, address(this), needed);
211     }
212 }
213 
214 contract BananaIndex is IERC20 {
215     // Ownership moved to in-contract for customizability.
216     address private _owner;
217 
218     mapping (address => uint256) _tOwned;
219     mapping (address => bool) lpPairs;
220     uint256 private timeSinceLastPair = 0;
221     mapping (address => mapping (address => uint256)) _allowances;
222     mapping (address => bool) private _isExcludedFromProtection;
223     mapping (address => bool) private _isExcludedFromFees;
224     mapping (address => bool) private _isExcludedFromLimits;
225     mapping (address => bool) private _isExcludedFromDividends;
226     mapping (address => bool) private _liquidityHolders;
227 
228     mapping (address => bool) private presaleAddresses;
229     bool private allowedPresaleExclusion = true;
230 
231     uint256 constant private startingSupply = 1_000_000_000_000;
232 
233     string constant private _name = "Banana Index";
234     string constant private _symbol = "Bandex";
235     uint8 constant private _decimals = 9;
236 
237     uint256 constant private _tTotal = startingSupply * (10 ** _decimals);
238 
239     struct Fees {
240         uint16 buyFee;
241         uint16 sellFee;
242         uint16 transferFee;
243     }
244 
245     struct Ratios {
246         uint16 rewards;
247         uint16 liquidity;
248         uint16 marketing;
249         uint16 dev;
250         uint16 floorSupport;
251         uint16 buybackAndBurn;
252         uint16 total;
253     }
254 
255     Fees public _taxRates = Fees({
256         buyFee: 1400,
257         sellFee: 1400,
258         transferFee: 0
259         });
260 
261     Ratios public _ratios = Ratios({
262         rewards: 200,
263         liquidity: 300,
264         marketing: 300,
265         dev: 200,
266         floorSupport: 200,
267         buybackAndBurn: 200,
268         total: 1400
269         });
270 
271     uint256 constant public maxBuyTaxes = 1500;
272     uint256 constant public maxSellTaxes = 1500;
273     uint256 constant public maxTransferTaxes = 1500;
274     uint256 constant masterTaxDivisor = 10000;
275 
276     IRouter02 public dexRouter;
277     address public lpPair;
278 
279     // BTFA MAINNET ADDRESS
280     address private BTFA = 0xC631bE100F6Cf9A7012C23De5a6ccb990EAFC133;
281     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
282     address constant private ZERO = 0x0000000000000000000000000000000000000000;
283 
284     struct TaxWallets {
285         address payable marketing;
286         address payable dev;
287         address payable floorSupport;
288     }
289 
290     TaxWallets public _taxWallets = TaxWallets({
291         marketing: payable(0x1764041440eD4081Ae361EC9c2245Eb33F023F60),
292         dev: payable(0x4C97047ff011c523f7E7f359784659dC05ca0A91),
293         floorSupport: payable(0x040C3d1B80630ec46627db3d9077255AA52b7e87)
294         });
295 
296     uint256 private _maxTxAmount = (_tTotal * 100) / 100;
297     uint256 private _maxWalletSize = (_tTotal * 100) / 100;
298 
299     Cashier reflector;
300     uint256 reflectorGas = 300000;
301     AirDropper public airdrop;
302 
303     bool inSwap;
304     bool public contractSwapEnabled = false;
305     uint256 public swapThreshold;
306     uint256 public swapAmount;
307     bool public processReflect = false;
308 
309     bool public tradingEnabled = false;
310     bool public _hasLiqBeenAdded = false;
311     AntiSnipe antiSnipe;
312 
313     modifier swapping() {
314         inSwap = true;
315         _;
316         inSwap = false;
317     }
318 
319     modifier onlyOwner() {
320         require(_owner == msg.sender, "Ownable: caller is not the owner");
321         _;
322     }
323 
324     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
325     event ContractSwapEnabledUpdated(bool enabled);
326     event AutoLiquify(uint256 amountBNB, uint256 amount);
327 
328     constructor () payable {
329         // Set the owner.
330         _owner = msg.sender;
331 
332         _tOwned[_owner] = _tTotal;
333         emit Transfer(ZERO, _owner, _tTotal);
334         emit OwnershipTransferred(address(0), _owner);
335 
336         if (block.chainid == 56) {
337             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
338         } else if (block.chainid == 97) {
339             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
340             BTFA = 0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684;
341         } else if (block.chainid == 1 || block.chainid == 4) {
342             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
343         } else if (block.chainid == 43114) {
344             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
345         } else if (block.chainid == 250) {
346             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
347         } else {
348             revert();
349         }
350 
351         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
352         lpPairs[lpPair] = true;
353         airdrop = new AirDropper(address(this), _decimals);
354 
355         _approve(_owner, address(dexRouter), type(uint256).max);
356         _approve(_owner, address(airdrop), type(uint256).max);
357         _approve(address(this), address(dexRouter), type(uint256).max);
358 
359         _isExcludedFromFees[_owner] = true;
360         _isExcludedFromFees[address(this)] = true;
361         _isExcludedFromFees[DEAD] = true;
362         _isExcludedFromDividends[_owner] = true;
363         _isExcludedFromDividends[lpPair] = true;
364         _isExcludedFromDividends[address(this)] = true;
365         _isExcludedFromDividends[DEAD] = true;
366         _isExcludedFromDividends[ZERO] = true;
367     }
368 
369 //===============================================================================================================
370 //===============================================================================================================
371 //===============================================================================================================
372     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
373     // This allows for removal of ownership privileges from the owner once renounced or transferred.
374     function transferOwner(address newOwner) external onlyOwner {
375         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
376         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
377         _isExcludedFromFees[_owner] = false;
378         _isExcludedFromDividends[_owner] = false;
379         _isExcludedFromFees[newOwner] = true;
380         _isExcludedFromDividends[newOwner] = true;
381         
382         if(balanceOf(_owner) > 0) {
383             _finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, false, true);
384         }
385         
386         _owner = newOwner;
387         emit OwnershipTransferred(_owner, newOwner);
388         
389     }
390 
391     function renounceOwnership() public virtual onlyOwner {
392         _isExcludedFromFees[_owner] = false;
393         _isExcludedFromDividends[_owner] = false;
394         _owner = address(0);
395         emit OwnershipTransferred(_owner, address(0));
396     }
397 //===============================================================================================================
398 //===============================================================================================================
399 //===============================================================================================================
400 
401     receive() external payable {}
402 
403     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
404     function decimals() external pure override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
405     function symbol() external pure override returns (string memory) { return _symbol; }
406     function name() external pure override returns (string memory) { return _name; }
407     function getOwner() external view override returns (address) { return _owner; }
408     function balanceOf(address account) public view override returns (uint256) { return _tOwned[account]; }
409     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
410 
411     function approve(address spender, uint256 amount) public override returns (bool) {
412         _allowances[msg.sender][spender] = amount;
413         emit Approval(msg.sender, spender, amount);
414         return true;
415     }
416 
417     function _approve(address sender, address spender, uint256 amount) private {
418         require(sender != address(0), "ERC20: approve from the zero address");
419         require(spender != address(0), "ERC20: approve to the zero address");
420 
421         _allowances[sender][spender] = amount;
422         emit Approval(sender, spender, amount);
423     }
424 
425     function approveContractContingency() public onlyOwner returns (bool) {
426         _approve(address(this), address(dexRouter), type(uint256).max);
427         return true;
428     }
429 
430     function transfer(address recipient, uint256 amount) external override returns (bool) {
431         return _transfer(msg.sender, recipient, amount);
432     }
433 
434     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
435         if (_allowances[sender][msg.sender] != type(uint256).max) {
436             _allowances[sender][msg.sender] -= amount;
437         }
438 
439         return _transfer(sender, recipient, amount);
440     }
441 
442     function setNewRouter(address newRouter) public onlyOwner {
443         IRouter02 _newRouter = IRouter02(newRouter);
444         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
445         if (get_pair == address(0)) {
446             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
447         }
448         else {
449             lpPair = get_pair;
450         }
451         dexRouter = _newRouter;
452         _approve(address(this), address(dexRouter), type(uint256).max);
453     }
454 
455     function setLpPair(address pair, bool enabled) external onlyOwner {
456         if (enabled == false) {
457             lpPairs[pair] = false;
458             antiSnipe.setLpPair(pair, false);
459         } else {
460             if (timeSinceLastPair != 0) {
461                 require(block.timestamp - timeSinceLastPair > 3 days, "Cannot set a new pair this week!");
462             }
463             lpPairs[pair] = true;
464             timeSinceLastPair = block.timestamp;
465             antiSnipe.setLpPair(pair, true);
466         }
467     }
468 
469     function setInitializers(address aInitializer, address cInitializer) external onlyOwner {
470         require(!tradingEnabled);
471         require(cInitializer != address(this) && aInitializer != address(this) && cInitializer != aInitializer);
472         reflector = Cashier(cInitializer);
473         antiSnipe = AntiSnipe(aInitializer);
474     }
475 
476     function isExcludedFromFees(address account) external view returns(bool) {
477         return _isExcludedFromFees[account];
478     }
479 
480     function isExcludedFromDividends(address account) external view returns(bool) {
481         return _isExcludedFromDividends[account];
482     }
483 
484     function isExcludedFromLimits(address account) external view returns (bool) {
485         return _isExcludedFromLimits[account];
486     }
487 
488     function isExcludedFromProtection(address account) external view returns (bool) {
489         return _isExcludedFromProtection[account];
490     }
491 
492     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
493         _isExcludedFromLimits[account] = enabled;
494     }
495 
496     function setDividendExcluded(address holder, bool enabled) public onlyOwner {
497         require(holder != address(this) && holder != lpPair);
498         _isExcludedFromDividends[holder] = enabled;
499         if (enabled) {
500             reflector.tally(holder, 0);
501         } else {
502             reflector.tally(holder, _tOwned[holder]);
503         }
504     }
505 
506     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
507         _isExcludedFromFees[account] = enabled;
508     }
509 
510     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
511         _isExcludedFromProtection[account] = enabled;
512     }
513 
514 //================================================ BLACKLIST
515 
516     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
517         antiSnipe.setBlacklistEnabled(account, enabled);
518         setDividendExcluded(account, enabled);
519     }
520 
521     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
522         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
523         for(uint256 i = 0; i < accounts.length; i++){
524             setDividendExcluded(accounts[i], enabled);
525         }
526     }
527 
528     function isBlacklisted(address account) public view returns (bool) {
529         return antiSnipe.isBlacklisted(account);
530     }
531 
532     function removeSniper(address account) external onlyOwner {
533         antiSnipe.removeSniper(account);
534     }
535 
536     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
537         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
538     }
539 
540     function setGasPriceLimit(uint256 gas) external onlyOwner {
541         require(gas >= 150, "Too low.");
542         antiSnipe.setGasPriceLimit(gas);
543     }
544 
545     function enableTrading() public onlyOwner {
546         require(!tradingEnabled, "Trading already enabled!");
547         require(_hasLiqBeenAdded, "Liquidity must be added.");
548         if(address(antiSnipe) == address(0)){
549             antiSnipe = AntiSnipe(address(this));
550         }
551         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
552         try reflector.initialize() {} catch {}
553         tradingEnabled = true;
554         allowedPresaleExclusion = false;
555         swapThreshold = (balanceOf(lpPair) * 5) / 10000;
556         swapAmount = (balanceOf(lpPair) * 1) / 1000;
557     }
558 
559     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
560         require(buyFee <= maxBuyTaxes
561                 && sellFee <= maxSellTaxes
562                 && transferFee <= maxTransferTaxes);
563         _taxRates.buyFee = buyFee;
564         _taxRates.sellFee = sellFee;
565         _taxRates.transferFee = transferFee;
566     }
567 
568     function setRatios(uint16 rewards, uint16 liquidity, uint16 marketing, uint16 dev, uint16 floorSupport, uint16 buybackAndBurn) external onlyOwner {
569         _ratios.rewards = rewards;
570         _ratios.liquidity = liquidity;
571         _ratios.marketing = marketing;
572         _ratios.dev = dev;
573         _ratios.floorSupport = floorSupport;
574         _ratios.buybackAndBurn = buybackAndBurn;
575         _ratios.total = rewards + liquidity + marketing + dev + floorSupport + buybackAndBurn;
576         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
577         require(_ratios.total <= total, "Cannot exceed sum of buy and sell fees.");
578     }
579 
580     function setWallets(address payable marketing, address payable dev, address payable floorSupport) external onlyOwner {
581         _taxWallets.marketing = payable(marketing);
582         _taxWallets.dev = payable(dev);
583         _taxWallets.floorSupport = payable(floorSupport);
584     }
585 
586     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
587         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
588         _maxTxAmount = (_tTotal * percent) / divisor;
589     }
590 
591     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
592         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
593         _maxWalletSize = (_tTotal * percent) / divisor;
594     }
595 
596     function getMaxTX() public view returns (uint256) {
597         return _maxTxAmount / (10**_decimals);
598     }
599 
600     function getMaxWallet() public view returns (uint256) {
601         return _maxWalletSize / (10**_decimals);
602     }
603 
604     function setContractSwapSettings(bool _enabled, bool processReflectEnabled) external onlyOwner {
605         contractSwapEnabled = _enabled;
606         processReflect = processReflectEnabled;
607     }
608 
609     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
610         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
611         swapAmount = (_tTotal * amountPercent) / amountDivisor;
612     }
613 
614     function setRewardsProperties(uint256 _minPeriod, uint256 _minReflection, uint256 minReflectionMultiplier) external onlyOwner {
615         _minReflection = _minReflection * 10**minReflectionMultiplier;
616         reflector.setRewardsProperties(_minPeriod, _minReflection);
617     }
618 
619     function setReflectorSettings(uint256 gas) external onlyOwner {
620         require(gas < 750000);
621         reflectorGas = gas;
622     }
623 
624     function excludePresaleAddresses(address router, address presale) external onlyOwner {
625         require(allowedPresaleExclusion);
626         if (router == presale) {
627             _liquidityHolders[presale] = true;
628             presaleAddresses[presale] = true;
629             setExcludedFromFees(presale, true);
630             setDividendExcluded(presale, true);
631         } else {
632             _liquidityHolders[router] = true;
633             _liquidityHolders[presale] = true;
634             presaleAddresses[router] = true;
635             presaleAddresses[presale] = true;
636             setExcludedFromFees(router, true);
637             setExcludedFromFees(presale, true);
638             setDividendExcluded(router, true);
639             setDividendExcluded(presale, true);
640         }
641     }
642 
643     function _hasLimits(address from, address to) private view returns (bool) {
644         return from != _owner
645             && to != _owner
646             && tx.origin != _owner
647             && !_liquidityHolders[to]
648             && !_liquidityHolders[from]
649             && to != DEAD
650             && to != address(0)
651             && from != address(this);
652     }
653 
654     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
655         require(from != address(0), "ERC20: transfer from the zero address");
656         require(to != address(0), "ERC20: transfer to the zero address");
657         require(amount > 0, "Transfer amount must be greater than zero");
658         bool buy = false;
659         bool sell = false;
660         bool other = false;
661         if (lpPairs[from]) {
662             buy = true;
663         } else if (lpPairs[to]) {
664             sell = true;
665         } else {
666             other = true;
667         }
668         if(_hasLimits(from, to)) {
669             if(!tradingEnabled) {
670                 revert("Trading not yet enabled!");
671             }
672             if(buy || sell){
673                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
674                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
675                 }
676             }
677             if(to != address(dexRouter) && !sell) {
678                 if (!_isExcludedFromLimits[to]) {
679                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
680                 }
681             }
682         }
683 
684         bool takeFee = true;
685         
686         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
687             takeFee = false;
688         }
689 
690         if (sell) {
691             if (!inSwap
692                 && contractSwapEnabled
693                 && !presaleAddresses[to]
694                 && !presaleAddresses[from]
695             ) {
696                 uint256 contractTokenBalance = balanceOf(address(this));
697                 if (contractTokenBalance >= swapThreshold) {
698                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
699                     contractSwap(contractTokenBalance);
700                 }
701             }      
702         } 
703 
704         return _finalizeTransfer(from, to, amount, takeFee, buy, sell, other);
705     }
706 
707     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee, bool buy, bool sell, bool other) internal returns (bool) {
708         if (!_hasLiqBeenAdded) {
709             _checkLiquidityAdd(from, to);
710             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
711                 revert("Pre-liquidity transfer protection.");
712             }
713         }
714 
715         if(_hasLimits(from, to)) {
716             bool checked;
717             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
718                 checked = check;
719             } catch {
720                 revert();
721             }
722 
723             if(!checked) {
724                 revert();
725             }
726         }
727 
728         _tOwned[from] -= amount;
729         uint256 amountReceived = amount;
730         if (takeFee) {
731             amountReceived = takeTaxes(from, amount, buy, sell, other);
732         }
733         _tOwned[to] += amountReceived;
734 
735         processRewards(from, to);
736 
737         emit Transfer(from, to, amountReceived);
738         return true;
739     }
740 
741     function processRewards(address from, address to) internal {
742         if (!_isExcludedFromDividends[from]) {
743             try reflector.tally(from, _tOwned[from]) {} catch {}
744         }
745         if (!_isExcludedFromDividends[to]) {
746             try reflector.tally(to, _tOwned[to]) {} catch {}
747         }
748         if (processReflect) {
749             try reflector.cashout(reflectorGas) {} catch {}
750         }
751     }
752 
753     function _basicTransfer(address from, address to, uint256 amount) external returns (bool) {
754         require(msg.sender == address(airdrop), "Only airdropper may call.");
755         _tOwned[from] -= amount;
756         _tOwned[to] += amount;
757         emit Transfer(from, to, amount);
758         return true;
759     }
760 
761     function takeTaxes(address from, uint256 amount, bool buy, bool sell, bool other) internal returns (uint256) {
762         uint256 currentFee;
763         if (buy) {
764             currentFee = _taxRates.buyFee;
765         } else if (sell) {
766             currentFee = _taxRates.sellFee;
767         } else {
768             currentFee = _taxRates.transferFee;
769         }
770 
771         if (currentFee == 0) {
772             return amount;
773         }
774 
775         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
776 
777         _tOwned[address(this)] += feeAmount;
778         emit Transfer(from, address(this), feeAmount);
779 
780         return amount - feeAmount;
781     }
782 
783     function contractSwap(uint256 contractTokenBalance) internal swapping {
784         Ratios memory ratios = _ratios;
785         if (ratios.total == 0) {
786             return;
787         }
788         
789         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
790             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
791         }
792 
793         address _WETH = dexRouter.WETH();
794 
795         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / (ratios.total)) / 2;
796         uint256 swapAmt = contractTokenBalance - toLiquify;
797 
798         address[] memory path = new address[](2);
799         path[0] = address(this);
800         path[1] = _WETH;
801 
802         uint256 initial = address(this).balance;
803 
804         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
805             swapAmt,
806             0,
807             path,
808             address(this),
809             block.timestamp
810         );
811 
812         uint256 amtBalance = address(this).balance - initial;
813         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
814 
815         if (toLiquify > 0) {
816             dexRouter.addLiquidityETH{value: liquidityBalance}(
817                 address(this),
818                 toLiquify,
819                 0,
820                 0,
821                 DEAD,
822                 block.timestamp
823             );
824             emit AutoLiquify(liquidityBalance, toLiquify);
825         }
826 
827         amtBalance -= liquidityBalance;
828         ratios.total -= ratios.liquidity;
829         uint256 rewardsBalance = (amtBalance * ratios.rewards) / ratios.total;
830         uint256 devBalance = (amtBalance * ratios.dev) / ratios.total;
831         uint256 floorSupportBalance = (amtBalance * ratios.floorSupport) / ratios.total;
832         uint256 buybackAndBurnBalance = (amtBalance * ratios.buybackAndBurn) / ratios.total;
833         uint256 marketingBalance = amtBalance - (rewardsBalance + devBalance + floorSupportBalance + buybackAndBurnBalance);
834 
835         if (ratios.rewards > 0) {
836             try reflector.load{value: rewardsBalance}() {} catch {}
837         }
838 
839         if(ratios.marketing > 0){
840             _taxWallets.marketing.transfer(marketingBalance);
841         }
842         if(ratios.dev > 0){
843             _taxWallets.dev.transfer(devBalance);
844         }
845         if(ratios.floorSupport > 0){
846             _taxWallets.floorSupport.transfer(floorSupportBalance);
847         }
848     }
849 
850     function buyAndBurnBTFA() external onlyOwner {
851         address[] memory path = new address[](2);
852         path[0] = dexRouter.WETH();
853         path[1] = BTFA;
854 
855         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: address(this).balance}
856         (
857             0,
858             path,
859             DEAD,
860             block.timestamp
861         );
862     }
863 
864     function _checkLiquidityAdd(address from, address to) private {
865         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
866         if (!_hasLimits(from, to) && to == lpPair) {
867             _liquidityHolders[from] = true;
868             _hasLiqBeenAdded = true;
869             if(address(antiSnipe) == address(0)) {
870                 antiSnipe = AntiSnipe(address(this));
871             }
872             if(address(reflector) ==  address(0)) {
873                 reflector = Cashier(address(this));
874             }
875             contractSwapEnabled = true;
876             allowedPresaleExclusion = false;
877             emit ContractSwapEnabledUpdated(true);
878         }
879     }
880 
881     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
882         require(accounts.length == amounts.length, "Lengths do not match.");
883         for (uint8 i = 0; i < accounts.length; i++) {
884             require(balanceOf(msg.sender) >= amounts[i]);
885             _finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, false, true);
886         }
887     }
888 
889     function manualDeposit() external onlyOwner {
890         try reflector.load{value: address(this).balance}() {} catch {}
891     }
892 
893 //=====================================================================================
894 //            Reflector
895 
896     function giveMeWelfarePlease() external {
897         reflector.giveMeWelfarePlease(msg.sender);
898     }
899 
900     function getTotalReflected() external view returns (uint256) {
901         return reflector.getTotalDistributed();
902     }
903 
904     function getUserInfo(address user) external view returns (string memory, string memory, string memory, string memory) {
905         return reflector.getUserInfo(user);
906     }
907 
908     function getUserRealizedGains(address user) external view returns (uint256) {
909         return reflector.getUserRealizedRewards(user);
910     }
911 
912     function getUserUnpaidEarnings(address user) external view returns (uint256) {
913         return reflector.getPendingRewards(user);
914     }
915 
916 //=====================================================================================
917 //            Airdropper
918 
919     function ADgetTotalNeededTokens() external view returns (uint256) {
920         return airdrop.getTotalNeededTokens();
921     }
922 
923     function ADgetClaimableTokens(address account) external view returns (uint256) {
924         return airdrop.getClaimableTokens(account);
925     }
926 
927     function ADgetSecondsUntilNextClaim(address account) external view returns (uint256) {
928         return airdrop.getSecondsUntilNextClaim(account);
929     }
930 
931     function ADsetClaimDelay(uint256 time) external onlyOwner {
932         airdrop.setClaimDelay(time);
933     }
934 
935     function ADdisableDelayedClaim() external onlyOwner {
936         airdrop.disableDelayedClaim();
937     }
938 
939     function ADsetUserToDrop(address account, uint256 tokens) external onlyOwner {
940         airdrop.setUserToDrop(account, tokens);
941     }
942 
943     function ADmultiSet(address[] calldata accounts, uint256[] calldata tokens) external onlyOwner {
944         airdrop.multiSet(accounts, tokens);
945     }
946 
947     bool entry;
948 
949     function ADwithdrawDailyTokens() external {
950         require(entry == false, "Entered.");
951         entry = true;
952         airdrop.withdrawDailyTokens(msg.sender);
953         entry = false;
954     }
955 
956     function ADdepositTokens() external onlyOwner{
957         airdrop.depositTokens();
958     }
959 }