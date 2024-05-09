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
97     function removeBlacklisted(address account) external;
98     function isBlacklisted(address account) external view returns (bool);
99     function transfer(address sender) external;
100     function setBlacklistEnabled(address account, bool enabled) external;
101     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
102     function getInitializers() external returns (string memory, string memory, uint256, uint8);
103 
104     function fullReset() external;
105 }
106 
107 interface NFTContract {
108     function balanceOf(address owner) external view returns (uint256);
109 }
110 
111 interface StakingContract {
112     function balanceOf(address owner) external view returns (uint256);
113 }
114 
115 contract Kudoe is IERC20 {
116     mapping (address => uint256) private _tOwned;
117     mapping (address => bool) lpPairs;
118     uint256 private timeSinceLastPair = 0;
119     mapping (address => mapping (address => uint256)) private _allowances;
120 
121     mapping (address => bool) private _liquidityHolders;
122     mapping (address => bool) private _isExcludedFromProtection;
123     mapping (address => bool) private _isExcludedFromFees;
124     mapping (address => bool) private _isExcludedFromLimits;
125    
126     uint256 constant private startingSupply = 1_000_000_000;
127     string constant private _name = "Kudoe";
128     string constant private _symbol = "KDOE";
129     uint8 constant private _decimals = 18;
130 
131     uint256 constant private _tTotal = startingSupply * 10**_decimals;
132 
133     struct Fees {
134         uint16 buyFee;
135         uint16 sellFee;
136         uint16 transferFee;
137     }
138 
139     struct Ratios {
140         uint16 liquidity;
141         uint16 marketing;
142         uint16 development;
143         uint16 burn;
144         uint16 totalSwap;
145     }
146 
147     Fees public _taxRates = Fees({
148         buyFee: 1000,
149         sellFee: 1000,
150         transferFee: 1000
151         });
152 
153     Fees public _discountRates = Fees({
154         buyFee: 1000,
155         sellFee: 1000,
156         transferFee: 1000
157         });
158 
159     Ratios public _ratios = Ratios({
160         liquidity: 200,
161         marketing: 200,
162         development: 200,
163         burn: 200,
164         totalSwap: 600
165         });
166 
167     uint256 constant public maxBuyTaxes = 2000;
168     uint256 constant public maxSellTaxes = 2000;
169     uint256 constant public maxTransferTaxes = 2000;
170     uint256 constant public maxRoundtripTax = 3000;
171     uint256 constant masterTaxDivisor = 10000;
172 
173     IRouter02 public dexRouter;
174     address public lpPair;
175     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
176 
177     struct TaxWallets {
178         address payable marketing;
179         address payable development;
180         address payable liquidity;
181         address payable burn;
182     }
183 
184     TaxWallets public _taxWallets = TaxWallets({
185         marketing: payable(0x8547353c71837342df9b5F4f6FC51a55FC218e07),
186         development: payable(0x91d556466f0cDEEda28cB459CCd5dc418fe23AB5),
187         liquidity: payable(0xE657e2708974687477DB81F76234aC8efBff1AcA),
188         burn: payable(0x67344FeB46881f237dCcBb18536e7EEE7B28CaC3)
189         });
190     
191     bool inSwap;
192     bool public contractSwapEnabled = false;
193     uint256 public swapThreshold;
194     uint256 public swapAmount;
195     bool public piContractSwapsEnabled;
196     uint256 public piSwapPercent;
197     
198     uint256 private _maxTxAmount;
199     uint256 private _maxWalletSize;
200 
201     bool public tradingEnabled = false;
202     bool public _hasLiqBeenAdded = false;
203     Protections protections;
204     NFTContract nftContract;
205     StakingContract stakingContract;
206 
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208     event ContractSwapEnabledUpdated(bool enabled);
209     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
210     
211     modifier lockTheSwap {
212         inSwap = true;
213         _;
214         inSwap = false;
215     }
216 
217     modifier onlyOwner() {
218         require(_owner == msg.sender, "Caller =/= owner.");
219         _;
220     }
221 
222     constructor () payable {
223         // Set the owner.
224         _owner = msg.sender;
225 
226         _tOwned[_owner] = _tTotal;
227         emit Transfer(address(0), _owner, _tTotal);
228 
229         if (block.chainid == 56) {
230             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
231         } else if (block.chainid == 97) {
232             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
233         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3 || block.chainid == 5) {
234             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
235             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
236         } else if (block.chainid == 43114) {
237             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
238         } else if (block.chainid == 250) {
239             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
240         } else {
241             revert();
242         }
243 
244         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
245         lpPairs[lpPair] = true;
246 
247         _approve(_owner, address(dexRouter), type(uint256).max);
248         _approve(address(this), address(dexRouter), type(uint256).max);
249 
250         _isExcludedFromFees[_owner] = true;
251         _isExcludedFromFees[address(this)] = true;
252         _isExcludedFromFees[DEAD] = true;
253         _liquidityHolders[_owner] = true;
254 
255         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; // PinkLock
256         _isExcludedFromFees[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true; // Unicrypt (ETH)
257         _isExcludedFromFees[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true; // Unicrypt (ETH)
258     }
259 
260 //===============================================================================================================
261 //===============================================================================================================
262 //===============================================================================================================
263     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
264     // This allows for removal of ownership privileges from the owner once renounced or transferred.
265     address private _owner;
266 
267     function transferOwner(address newOwner) external onlyOwner {
268         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
269         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
270         setExcludedFromFees(_owner, false);
271         setExcludedFromFees(newOwner, true);
272         
273         if(balanceOf(_owner) > 0) {
274             _finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
275         }
276         
277         address oldOwner = _owner;
278         _owner = newOwner;
279         emit OwnershipTransferred(oldOwner, newOwner);
280         
281     }
282 
283     function renounceOwnership() external onlyOwner {
284         setExcludedFromFees(_owner, false);
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
295     function totalSupply() external pure override returns (uint256) { return _tTotal; }
296     function decimals() external pure override returns (uint8) { return _decimals; }
297     function symbol() external pure override returns (string memory) { return _symbol; }
298     function name() external pure override returns (string memory) { return _name; }
299     function getOwner() external view override returns (address) { return _owner; }
300     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
301 
302     function balanceOf(address account) public view override returns (uint256) {
303         return _tOwned[account];
304     }
305 
306     function transfer(address recipient, uint256 amount) public override returns (bool) {
307         _transfer(msg.sender, recipient, amount);
308         return true;
309     }
310 
311     function approve(address spender, uint256 amount) public override returns (bool) {
312         _approve(msg.sender, spender, amount);
313         return true;
314     }
315 
316     function _approve(address sender, address spender, uint256 amount) internal {
317         require(sender != address(0), "ERC20: Zero Address");
318         require(spender != address(0), "ERC20: Zero Address");
319 
320         _allowances[sender][spender] = amount;
321         emit Approval(sender, spender, amount);
322     }
323 
324     function approveContractContingency() public onlyOwner returns (bool) {
325         _approve(address(this), address(dexRouter), type(uint256).max);
326         return true;
327     }
328 
329     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
330         if (_allowances[sender][msg.sender] != type(uint256).max) {
331             _allowances[sender][msg.sender] -= amount;
332         }
333 
334         return _transfer(sender, recipient, amount);
335     }
336 
337     function setNewRouter(address newRouter) public onlyOwner {
338         IRouter02 _newRouter = IRouter02(newRouter);
339         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
340         if (get_pair == address(0)) {
341             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
342         }
343         else {
344             lpPair = get_pair;
345         }
346         dexRouter = _newRouter;
347         _approve(address(this), address(dexRouter), type(uint256).max);
348     }
349 
350     function setLpPair(address pair, bool enabled) external onlyOwner {
351         if (enabled == false) {
352             lpPairs[pair] = false;
353             protections.setLpPair(pair, false);
354         } else {
355             if (timeSinceLastPair != 0) {
356                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
357             }
358             lpPairs[pair] = true;
359             timeSinceLastPair = block.timestamp;
360             protections.setLpPair(pair, true);
361         }
362     }
363 
364     function setInitializer(address initializer) external onlyOwner {
365         require(!tradingEnabled);
366         require(initializer != address(this), "Can't be self.");
367         protections = Protections(initializer);
368     }
369 
370     function setExternalContracts(address _nftContract, address _stakingContract) external onlyOwner {
371         nftContract = NFTContract(_nftContract);
372         stakingContract = StakingContract(_stakingContract);
373     }
374 
375     function isExcludedFromLimits(address account) external view returns (bool) {
376         return _isExcludedFromLimits[account];
377     }
378 
379     function isExcludedFromFees(address account) external view returns(bool) {
380         return _isExcludedFromFees[account];
381     }
382 
383     function isExcludedFromProtection(address account) external view returns (bool) {
384         return _isExcludedFromProtection[account];
385     }
386 
387     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
388         _isExcludedFromLimits[account] = enabled;
389     }
390 
391     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
392         _isExcludedFromFees[account] = enabled;
393     }
394 
395     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
396         _isExcludedFromProtection[account] = enabled;
397     }
398 
399 //================================================ BLACKLIST
400 
401     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
402         protections.setBlacklistEnabled(account, enabled);
403     }
404 
405     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
406         protections.setBlacklistEnabledMultiple(accounts, enabled);
407     }
408 
409     function removeBlacklisted(address account) external onlyOwner {
410         // To remove from the pre-built blacklist ONLY. Cannot add to blacklist.
411         protections.removeBlacklisted(account);
412     }
413 
414     function isBlacklisted(address account) public view returns (bool) {
415         return protections.isBlacklisted(account);
416     }
417 
418     function removeSniper(address account) external onlyOwner {
419         protections.removeSniper(account);
420     }
421 
422     function setProtectionSettings(bool _protections, bool _antiBlock) external onlyOwner {
423         protections.setProtections(_protections, _antiBlock);
424     }
425 
426     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
427         require(buyFee <= maxBuyTaxes
428                 && sellFee <= maxSellTaxes
429                 && transferFee <= maxTransferTaxes,
430                 "Cannot exceed maximums.");
431         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
432         _taxRates.buyFee = buyFee;
433         _taxRates.sellFee = sellFee;
434         _taxRates.transferFee = transferFee;
435     }
436 
437     function setDiscountTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
438         require(buyFee <= maxBuyTaxes
439                 && sellFee <= maxSellTaxes
440                 && transferFee <= maxTransferTaxes,
441                 "Cannot exceed maximums.");
442         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
443         _discountRates.buyFee = buyFee;
444         _discountRates.sellFee = sellFee;
445         _discountRates.transferFee = transferFee;
446     }
447 
448     function setRatios(uint16 liquidity, uint16 marketing, uint16 development, uint16 burn) external onlyOwner {
449         _ratios.liquidity = liquidity;
450         _ratios.marketing = marketing;
451         _ratios.development = development;
452         _ratios.burn = burn;
453         _ratios.totalSwap = liquidity + marketing + development;
454         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
455         require(_ratios.totalSwap + _ratios.burn <= total, "Cannot exceed sum of buy and sell fees.");
456     }
457 
458     function setWallets(address payable marketing, address payable liquidity, address payable development, address payable burn) external onlyOwner {
459         _taxWallets.marketing = payable(marketing);
460         _taxWallets.liquidity = payable(liquidity);
461         _taxWallets.development = payable(development);
462         _taxWallets.burn = payable(burn);
463     }
464 
465     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
466         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
467         _maxTxAmount = (_tTotal * percent) / divisor;
468     }
469 
470     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
471         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
472         _maxWalletSize = (_tTotal * percent) / divisor;
473     }
474 
475     function getMaxTX() public view returns (uint256) {
476         return _maxTxAmount / (10**_decimals);
477     }
478 
479     function getMaxWallet() public view returns (uint256) {
480         return _maxWalletSize / (10**_decimals);
481     }
482 
483     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
484         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
485         swapAmount = (_tTotal * amountPercent) / amountDivisor;
486         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
487         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
488         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
489         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
490     }
491 
492     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
493         require(priceImpactSwapPercent <= 200, "Cannot set above 2%.");
494         piSwapPercent = priceImpactSwapPercent;
495     }
496 
497     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
498         contractSwapEnabled = swapEnabled;
499         piContractSwapsEnabled = priceImpactSwapEnabled;
500         emit ContractSwapEnabledUpdated(swapEnabled);
501     }
502 
503     function _hasLimits(address from, address to) internal view returns (bool) {
504         return from != _owner
505             && to != _owner
506             && tx.origin != _owner
507             && !_liquidityHolders[to]
508             && !_liquidityHolders[from]
509             && to != DEAD
510             && to != address(0)
511             && from != address(this);
512     }
513 
514     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
515         require(from != address(0), "ERC20: transfer from the zero address");
516         require(to != address(0), "ERC20: transfer to the zero address");
517         require(amount > 0, "Transfer amount must be greater than zero");
518         bool buy = false;
519         bool sell = false;
520         bool other = false;
521         if (lpPairs[from]) {
522             buy = true;
523         } else if (lpPairs[to]) {
524             sell = true;
525         } else {
526             other = true;
527         }
528         if(_hasLimits(from, to)) {
529             if(!tradingEnabled) {
530                 revert("Trading not yet enabled!");
531             }
532             if(buy || sell){
533                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
534                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
535                 }
536             }
537             if(to != address(dexRouter) && !sell) {
538                 if (!_isExcludedFromLimits[to]) {
539                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
540                 }
541             }
542         }
543 
544         if (sell) {
545             if (!inSwap) {
546                 if (contractSwapEnabled) {
547                     uint256 contractTokenBalance = balanceOf(address(this));
548                     if (contractTokenBalance >= swapThreshold) {
549                         uint256 swapAmt = swapAmount;
550                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
551                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
552                         contractSwap(contractTokenBalance);
553                     }
554                 }
555             }
556         }
557         return _finalizeTransfer(from, to, amount, buy, sell, other);
558     }
559 
560     function contractSwap(uint256 contractTokenBalance) internal lockTheSwap {
561         Ratios memory ratios = _ratios;
562         if (ratios.totalSwap == 0) {
563             return;
564         }
565 
566         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
567             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
568         }
569         
570         address[] memory path = new address[](2);
571         path[0] = address(this);
572         path[1] = dexRouter.WETH();
573 
574         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
575             contractTokenBalance,
576             0,
577             path,
578             address(this),
579             block.timestamp
580         ) {} catch {
581             return;
582         }
583 
584         uint256 amtBalance = address(this).balance;
585         bool success;
586         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.totalSwap;
587         uint256 liquidityBalance = (amtBalance * ratios.liquidity) / ratios.totalSwap;
588         uint256 marketingBalance = amtBalance - (developmentBalance + liquidityBalance);
589         if (ratios.marketing > 0) {
590             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 35000}("");
591         }
592         if (ratios.development > 0) {
593             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 35000}("");
594         }
595         if (ratios.liquidity > 0) {
596             (success,) = _taxWallets.liquidity.call{value: liquidityBalance, gas: 35000}("");
597         }
598     }    
599 
600     function _contractSwap(uint256 contractTokenBalance) external {
601         Ratios memory ratios = _ratios;
602         if (ratios.totalSwap == 0) {
603             return;
604         }
605 
606         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
607             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
608         }
609         
610         address[] memory path = new address[](2);
611         path[0] = address(this);
612         path[1] = dexRouter.WETH();
613 
614         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
615             contractTokenBalance,
616             0,
617             path,
618             address(this),
619             block.timestamp
620         );
621 
622         uint256 amtBalance = address(this).balance;
623         bool success;
624         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.totalSwap;
625         uint256 liquidityBalance = (amtBalance * ratios.liquidity) / ratios.totalSwap;
626         uint256 marketingBalance = amtBalance - (developmentBalance + liquidityBalance);
627         if (ratios.marketing > 0) {
628             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 35000}("");
629         }
630         if (ratios.development > 0) {
631             (success,) = _taxWallets.development.call{value: developmentBalance, gas: 35000}("");
632         }
633         if (ratios.liquidity > 0) {
634             (success,) = _taxWallets.liquidity.call{value: liquidityBalance, gas: 35000}("");
635         }
636     }
637 
638     function _checkLiquidityAdd(address from, address to) internal {
639         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
640         if (!_hasLimits(from, to) && to == lpPair) {
641             _liquidityHolders[from] = true;
642             _isExcludedFromFees[from] = true;
643             _hasLiqBeenAdded = true;
644             if(address(protections) == address(0)){
645                 protections = Protections(address(this));
646             }
647             contractSwapEnabled = true;
648             emit ContractSwapEnabledUpdated(true);
649         }
650     }
651 
652     function enableTrading() public onlyOwner {
653         require(!tradingEnabled, "Trading already enabled!");
654         require(_hasLiqBeenAdded, "Liquidity must be added.");
655         if(address(protections) == address(0)){
656             protections = Protections(address(this));
657         }
658         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
659         tradingEnabled = true;
660         swapThreshold = (balanceOf(lpPair) * 15) / 10000;
661         swapAmount = (balanceOf(lpPair) * 30) / 10000;
662     }
663 
664     function sweepContingency() external onlyOwner {
665         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
666         payable(_owner).transfer(address(this).balance);
667     }
668 
669     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
670         require(accounts.length == amounts.length, "Lengths do not match.");
671         for (uint8 i = 0; i < accounts.length; i++) {
672             require(balanceOf(msg.sender) >= amounts[i]);
673             _finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
674         }
675     }
676 
677     function _finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
678         if (!_hasLiqBeenAdded) {
679             _checkLiquidityAdd(from, to);
680             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
681                 revert("Pre-liquidity transfer protection.");
682             }
683         }
684 
685         if (_hasLimits(from, to)) {
686             bool checked;
687             try protections.checkUser(from, to, amount) returns (bool check) {
688                 checked = check;
689             } catch {
690                 revert();
691             }
692 
693             if(!checked) {
694                 revert();
695             }
696         }
697 
698         bool takeFee = true;
699         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
700             takeFee = false;
701         }
702 
703         _tOwned[from] -= amount;
704         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, buy, sell, amount) : amount;
705         _tOwned[to] += amountReceived;
706 
707         emit Transfer(from, to, amountReceived);
708         return true;
709     }
710 
711     function getDiscountState(address account) public returns (bool) {
712         bool isNftHolder;
713         if(address(nftContract) != address(0)) {
714             try nftContract.balanceOf(account) returns (uint256 balanceAmount) {
715                 isNftHolder = (balanceAmount > 0) ? true : false;
716             } catch {}
717         }
718         if(address(stakingContract) != address(0) && !isNftHolder) {
719             try stakingContract.balanceOf(account) returns (uint256 balanceAmount) {
720                 isNftHolder = (balanceAmount > 0) ? true : false;
721             } catch {}
722         }
723         return isNftHolder;
724     }
725 
726     function takeTaxes(address from, address to, bool buy, bool sell, uint256 amount) internal returns (uint256) {
727         uint256 currentFee;
728         bool isNftHolder;
729         if (buy) {
730             isNftHolder = getDiscountState(to);
731             if(isNftHolder) {
732                 currentFee = _discountRates.buyFee;
733             } else {
734                 currentFee = _taxRates.buyFee;
735             }
736         } else if (sell) {
737             isNftHolder = getDiscountState(from);
738             if(isNftHolder) {
739                 currentFee = _discountRates.sellFee;
740             } else {
741                 currentFee = _taxRates.sellFee;
742             }
743         } else {
744             isNftHolder = getDiscountState(to);
745             if(!isNftHolder) {
746                 isNftHolder = getDiscountState(from);
747             }
748             if(isNftHolder) {
749                 currentFee = _discountRates.transferFee;
750             } else {
751                 currentFee = _taxRates.transferFee;
752             }
753         }
754 
755         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
756         uint256 burnAmount = (feeAmount * _ratios.burn) / (_ratios.totalSwap + _ratios.burn);
757         uint256 swapAmt = feeAmount - burnAmount;
758 
759         _tOwned[address(this)] += swapAmt;
760         emit Transfer(from, address(this), swapAmt);
761 
762         if (burnAmount > 0) {
763             _tOwned[_taxWallets.burn] += burnAmount;
764             emit Transfer(from, _taxWallets.burn, burnAmount);
765         }
766 
767         return amount - feeAmount;
768     }
769 }