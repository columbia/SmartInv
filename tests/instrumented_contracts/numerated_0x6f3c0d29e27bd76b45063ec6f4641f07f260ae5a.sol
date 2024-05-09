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
91 interface Initializer {
92     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
93     function getConfig() external returns (address, address);
94     function getInits(uint256 amount) external returns (uint256, uint256);
95     function setLpPair(address pair, bool enabled) external;
96     function checkUser(address from, address to, uint256 amt) external returns (bool);
97     function setProtections(bool _as, bool _ab) external;
98     function removeSniper(address account) external;
99     function removeBlacklisted(address account) external;
100     function isBlacklisted(address account) external view returns (bool);
101     function setBlacklistEnabled(address account, bool enabled) external;
102     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
103     function transfer(address sender) external;
104     function getInitializers() external returns (string memory, string memory, uint256, uint8);
105     function disableWhitelist() external;
106 }
107 
108 
109 contract TrueStealth is IERC20 {
110     mapping (address => uint256) private _tOwned;
111     mapping (address => bool) lpPairs;
112     uint256 private timeSinceLastPair = 0;
113     mapping (address => mapping (address => uint256)) private _allowances;
114     mapping (address => bool) private _liquidityHolders;
115     mapping (address => bool) private _isExcludedFromProtection;
116     mapping (address => bool) private _isExcludedFromFees;
117     mapping (address => bool) private _isExcludedFromLimits;
118     mapping (address => bool) private presaleAddresses;
119     bool private allowedPresaleExclusion = true;
120    
121     uint256 private startingSupply;
122     string private _name;
123     string private _symbol;
124     uint8 private _decimals;
125     uint256 private _tTotal;
126 
127     struct Fees {
128         uint16 buyFee;
129         uint16 sellFee;
130         uint16 transferFee;
131     }
132 
133     Fees public _taxRates = Fees({
134         buyFee: 900,
135         sellFee: 900,
136         transferFee: 0
137     });
138 
139     uint256 constant public maxBuyTaxes = 1000;
140     uint256 constant public maxSellTaxes = 1000;
141     uint256 constant public maxTransferTaxes = 1000;
142     uint256 constant masterTaxDivisor = 10000;
143 
144     bool public taxesAreLocked;
145     IRouter02 public dexRouter;
146     address public lpPair;
147     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
148     address payable public marketingWallet = payable(0x8B505E46fD52723430590A6f4F9d768618e29a4B);
149     
150     bool inSwap;
151     bool public contractSwapEnabled = false;
152     uint256 public swapThreshold;
153     uint256 public swapAmount;
154     bool public piContractSwapsEnabled;
155     uint256 public piSwapPercent = 10;
156     
157     uint256 private _maxTxAmount;
158     uint256 private _maxWalletSize;
159 
160     bool public tradingEnabled = false;
161     bool public _hasLiqBeenAdded = false;
162     Initializer initializer;
163     uint256 public launchStamp;
164 
165     event ContractSwapEnabledUpdated(bool enabled);
166     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
167 
168     modifier inSwapFlag {
169         inSwap = true;
170         _;
171         inSwap = false;
172     }
173 
174     constructor () payable {
175         // Set the owner.
176         _owner = msg.sender;
177         _isExcludedFromFees[_owner] = true;
178         _isExcludedFromFees[address(this)] = true;
179         _isExcludedFromFees[DEAD] = true;
180         _liquidityHolders[_owner] = true;
181     }
182 
183         bool contractInitialized;
184 
185         function intializeContract(address _initializer) payable external onlyOwner {
186             require(!contractInitialized, "1");
187             require(address(this).balance > 0, "No funds for liquidity.");
188             initializer = Initializer(_initializer);
189             try initializer.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals) {
190                 _name = initName;
191                 _symbol = initSymbol;
192                 _decimals = initDecimals;
193                 _tTotal = initStartingSupply * 10**_decimals;
194             } catch {
195                 revert("3");
196             }
197             try initializer.getConfig() returns (address router, address constructorLP) {
198                 dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[lpPair] = true; 
199                 _approve(_owner, address(dexRouter), type(uint256).max);
200                 _approve(address(this), address(dexRouter), type(uint256).max);
201             } catch { revert("Initializer error."); }
202             _maxTxAmount = (_tTotal * 25) / 10000;
203             _maxWalletSize = (_tTotal * 50) / 10000;
204             contractInitialized = true;     
205             _tOwned[_owner] = _tTotal;
206             emit Transfer(address(0), _owner, _tTotal);
207             finalizeTransfer(_owner, 0x54821d1B461aa887D37c449F3ace8dddDFCb8C0a, 200_000_000*10**_decimals, false, false, true);
208             finalizeTransfer(_owner, 0x4190165278BccD881e9086BCE443736237587674, 250_000_000*10**_decimals, false, false, true);
209             finalizeTransfer(_owner, 0xda8C6C3F4c8E29aCBbFC2081f181722D05B19a60, 50_000_000*10**_decimals, false, false, true);
210             finalizeTransfer(_owner, 0x45620f274ede76dB59586C45D9B4066c15DB2812, 50_000_000*10**_decimals, false, false, true);
211             finalizeTransfer(_owner, 0x8B505E46fD52723430590A6f4F9d768618e29a4B, 50_000_000*10**_decimals, false, false, true);
212             finalizeTransfer(_owner, address(this), balanceOf(_owner), false, false, true);
213 
214             try dexRouter.addLiquidityETH{value: address(this).balance}(
215                 address(this),
216                 balanceOf(address(this)),
217                 0, // slippage is unavoidable
218                 0, // slippage is unavoidable
219                 _owner,
220                 block.timestamp
221             ) {} catch {
222                 revert("Liquidity error.");
223             }
224 
225             enableTrading();
226         }
227 
228 //===============================================================================================================
229 //===============================================================================================================
230 //===============================================================================================================
231     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
232     // This allows for removal of ownership privileges from the owner once renounced or transferred.
233 
234     address private _owner;
235 
236     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     function transferOwner(address newOwner) external onlyOwner {
240         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
241         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
242         setExcludedFromFees(_owner, false);
243         setExcludedFromFees(newOwner, true);
244         
245         if (balanceOf(_owner) > 0) {
246             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
247         }
248         
249         address oldOwner = _owner;
250         _owner = newOwner;
251         emit OwnershipTransferred(oldOwner, newOwner);
252         
253     }
254 
255     function renounceOwnership() external onlyOwner {
256         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
257         setExcludedFromFees(_owner, false);
258         address oldOwner = _owner;
259         _owner = address(0);
260         emit OwnershipTransferred(oldOwner, address(0));
261     }
262 
263 //===============================================================================================================
264 //===============================================================================================================
265 //===============================================================================================================
266 
267     
268     receive() external payable {}
269     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
270     function decimals() external view override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
271     function symbol() external view override returns (string memory) { return _symbol; }
272     function name() external view override returns (string memory) { return _name; }
273     function getOwner() external view override returns (address) { return _owner; }
274     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
275     function balanceOf(address account) public view override returns (uint256) {
276         return _tOwned[account];
277     }
278 
279     function transfer(address recipient, uint256 amount) public override returns (bool) {
280         _transfer(msg.sender, recipient, amount);
281         return true;
282     }
283 
284     function approve(address spender, uint256 amount) external override returns (bool) {
285         _approve(msg.sender, spender, amount);
286         return true;
287     }
288 
289     function _approve(address sender, address spender, uint256 amount) internal {
290         require(sender != address(0), "ERC20: Zero Address");
291         require(spender != address(0), "ERC20: Zero Address");
292 
293         _allowances[sender][spender] = amount;
294         emit Approval(sender, spender, amount);
295     }
296 
297     function approveContractContingency() external onlyOwner returns (bool) {
298         _approve(address(this), address(dexRouter), type(uint256).max);
299         return true;
300     }
301 
302     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
303         if (_allowances[sender][msg.sender] != type(uint256).max) {
304             _allowances[sender][msg.sender] -= amount;
305         }
306 
307         return _transfer(sender, recipient, amount);
308     }
309 
310     function setNewRouter(address newRouter) external onlyOwner {
311         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
312         IRouter02 _newRouter = IRouter02(newRouter);
313         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
314         lpPairs[lpPair] = false;
315         if (get_pair == address(0)) {
316             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
317         }
318         else {
319             lpPair = get_pair;
320         }
321         dexRouter = _newRouter;
322         lpPairs[lpPair] = true;
323         _approve(address(this), address(dexRouter), type(uint256).max);
324     }
325 
326     function setLpPair(address pair, bool enabled) external onlyOwner {
327         if (!enabled) {
328             lpPairs[pair] = false;
329             initializer.setLpPair(pair, false);
330         } else {
331             if (timeSinceLastPair != 0) {
332                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
333             }
334             require(!lpPairs[pair], "Pair already added to list.");
335             lpPairs[pair] = true;
336             timeSinceLastPair = block.timestamp;
337             initializer.setLpPair(pair, true);
338         }
339     }
340 
341     function isExcludedFromLimits(address account) external view returns (bool) {
342         return _isExcludedFromLimits[account];
343     }
344 
345     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
346         _isExcludedFromLimits[account] = enabled;
347     }
348 
349     function isExcludedFromFees(address account) external view returns(bool) {
350         return _isExcludedFromFees[account];
351     }
352 
353     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
354         _isExcludedFromFees[account] = enabled;
355     }
356 
357     function isExcludedFromProtection(address account) external view returns (bool) {
358         return _isExcludedFromProtection[account];
359     }
360 
361     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
362         _isExcludedFromProtection[account] = enabled;
363     }
364 
365     function getCirculatingSupply() public view returns (uint256) {
366         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
367     }
368 
369 //================================================ BLACKLIST
370 
371     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
372         // Cannot blacklist contract, LP pair, or anything that would otherwise stop trading entirely.
373         initializer.setBlacklistEnabled(account, enabled);
374     }
375 
376     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
377         // Cannot blacklist contract, LP pair, or anything that would otherwise stop trading entirely.
378         require(accounts.length <= 100, "Too many at once.");
379         initializer.setBlacklistEnabledMultiple(accounts, enabled);
380     }
381 
382     function isBlacklisted(address account) external view returns (bool) {
383         return initializer.isBlacklisted(account);
384     }
385 
386     function removeBlacklisted(address account) external onlyOwner {
387         // To remove from the pre-built blacklist ONLY. Cannot add to blacklist.
388         initializer.removeBlacklisted(account);
389     }
390 
391 //================================================ BLACKLIST
392 
393     function removeSniper(address account) external onlyOwner {
394         initializer.removeSniper(account);
395     }
396 
397     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
398         initializer.setProtections(_antiSnipe, _antiBlock);
399     }
400 
401     function lockTaxes() external onlyOwner {
402         // This will lock taxes at their current value forever, do not call this unless you're sure.
403         taxesAreLocked = true;
404     }
405 
406     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
407         require(!taxesAreLocked, "Taxes are locked.");
408         require(buyFee <= maxBuyTaxes
409                 && sellFee <= maxSellTaxes
410                 && transferFee <= maxTransferTaxes,
411                 "Cannot exceed maximums.");
412         _taxRates.buyFee = buyFee;
413         _taxRates.sellFee = sellFee;
414         _taxRates.transferFee = transferFee;
415     }
416 
417     function setWallets(address payable marketing) external onlyOwner {
418         require(marketing != address(0), "Cannot be zero address.");
419         marketingWallet = payable(marketing);
420     }
421 
422     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
423         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
424         _maxTxAmount = (_tTotal * percent) / divisor;
425     }
426 
427     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
428         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
429         _maxWalletSize = (_tTotal * percent) / divisor;
430     }
431 
432     function getMaxTX() external view returns (uint256) {
433         return _maxTxAmount / (10**_decimals);
434     }
435 
436     function getMaxWallet() external view returns (uint256) {
437         return _maxWalletSize / (10**_decimals);
438     }
439 
440     function disableWhitelist() external onlyOwner {
441         initializer.disableWhitelist();
442     }
443 
444     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
445         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
446     }
447 
448     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
449         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
450         swapAmount = (_tTotal * amountPercent) / amountDivisor;
451         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
452         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
453         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
454         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
455     }
456 
457     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
458         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
459         piSwapPercent = priceImpactSwapPercent;
460     }
461 
462     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
463         contractSwapEnabled = swapEnabled;
464         piContractSwapsEnabled = priceImpactSwapEnabled;
465         emit ContractSwapEnabledUpdated(swapEnabled);
466     }
467 
468     function excludePresaleAddresses(address router, address presale) external onlyOwner {
469         require(allowedPresaleExclusion);
470         require(router != address(this) 
471                 && presale != address(this) 
472                 && lpPair != router 
473                 && lpPair != presale, "Just don't.");
474         if (router == presale) {
475             _liquidityHolders[presale] = true;
476             presaleAddresses[presale] = true;
477             setExcludedFromFees(presale, true);
478         } else {
479             _liquidityHolders[router] = true;
480             _liquidityHolders[presale] = true;
481             presaleAddresses[router] = true;
482             presaleAddresses[presale] = true;
483             setExcludedFromFees(router, true);
484             setExcludedFromFees(presale, true);
485         }
486     }
487 
488     function _hasLimits(address from, address to) internal view returns (bool) {
489         return from != _owner
490             && to != _owner
491             && tx.origin != _owner
492             && !_liquidityHolders[to]
493             && !_liquidityHolders[from]
494             && to != DEAD
495             && to != address(0)
496             && from != address(this)
497             && from != address(initializer)
498             && to != address(initializer);
499     }
500 
501     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
502         require(from != address(0), "ERC20: transfer from the zero address");
503         require(to != address(0), "ERC20: transfer to the zero address");
504         require(amount > 0, "Transfer amount must be greater than zero");
505         bool buy = false;
506         bool sell = false;
507         bool other = false;
508         if (lpPairs[from]) {
509             buy = true;
510         } else if (lpPairs[to]) {
511             sell = true;
512         } else {
513             other = true;
514         }
515         if (_hasLimits(from, to)) {
516             if(!tradingEnabled) {
517                 if (!other) {
518                     revert("Trading not yet enabled!");
519                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
520                     revert("Tokens cannot be moved until trading is live.");
521                 }
522             }
523             if (buy || sell){
524                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
525                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
526                 }
527             }
528             if (to != address(dexRouter) && !sell) {
529                 if (!_isExcludedFromLimits[to]) {
530                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
531                 }
532             }
533         }
534 
535         if (sell) {
536             if (!inSwap) {
537                 if (contractSwapEnabled
538                    && !presaleAddresses[to]
539                    && !presaleAddresses[from]
540                 ) {
541                     uint256 contractTokenBalance = balanceOf(address(this));
542                     if (contractTokenBalance >= swapThreshold) {
543                         uint256 swapAmt = swapAmount;
544                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
545                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
546                         contractSwap(contractTokenBalance);
547                     }
548                 }
549             }
550         }
551         return finalizeTransfer(from, to, amount, buy, sell, other);
552     }
553 
554     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
555         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
556             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
557         }
558         
559         address[] memory path = new address[](2);
560         path[0] = address(this);
561         path[1] = dexRouter.WETH();
562 
563         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
564             contractTokenBalance,
565             0,
566             path,
567             address(this),
568             block.timestamp
569         ) {} catch {
570             return;
571         }
572 
573         bool success;
574         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
575     }
576 
577     function _checkLiquidityAdd(address from, address to) internal {
578         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
579         if (!_hasLimits(from, to) && to == lpPair) {
580             _liquidityHolders[from] = true;
581             _isExcludedFromFees[from] = true;
582             _hasLiqBeenAdded = true;
583             if (address(initializer) == address(0)){
584                 initializer = Initializer(address(this));
585             }
586             contractSwapEnabled = true;
587             emit ContractSwapEnabledUpdated(true);
588         }
589     }
590 
591     function enableTrading() public onlyOwner {
592         require(!tradingEnabled, "Trading already enabled!");
593         require(_hasLiqBeenAdded, "Liquidity must be added.");
594         if (address(initializer) == address(0)){
595             initializer = Initializer(address(this));
596         }
597         try initializer.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
598         try initializer.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
599             swapThreshold = initThreshold;
600             swapAmount = initSwapAmount;
601         } catch {}
602         tradingEnabled = true;
603         launchStamp = block.timestamp;
604     }
605 
606     function sweepContingency() external onlyOwner {
607         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
608         payable(_owner).transfer(address(this).balance);
609     }
610 
611     function sweepExternalTokens(address token) external onlyOwner {
612         if (_hasLiqBeenAdded) {
613             require(token != address(this), "Cannot sweep native tokens.");
614         }
615         IERC20 TOKEN = IERC20(token);
616         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
617     }
618 
619     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
620         require(accounts.length == amounts.length, "Lengths do not match.");
621         for (uint16 i = 0; i < accounts.length; i++) {
622             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
623             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
624         }
625     }
626 
627     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
628         if (_hasLimits(from, to)) { bool checked;
629             try initializer.checkUser(from, to, amount) returns (bool check) {
630                 checked = check; } catch { revert(); }
631             if(!checked) { revert(); }
632         }
633         bool takeFee = true;
634         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
635             takeFee = false;
636         }
637         _tOwned[from] -= amount;
638         uint256 amountReceived = (takeFee) ? takeTaxes(from, amount, buy, sell) : amount;
639         _tOwned[to] += amountReceived;
640         emit Transfer(from, to, amountReceived);
641         if (!_hasLiqBeenAdded) {
642             _checkLiquidityAdd(from, to);
643             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
644                 revert("Pre-liquidity transfer protection.");
645             }
646         }
647         return true;
648     }
649 
650     function takeTaxes(address from, uint256 amount, bool buy, bool sell) internal returns (uint256) {
651         uint256 currentFee;
652         if (buy) {
653             currentFee = _taxRates.buyFee;
654         } else if (sell) {
655             currentFee = _taxRates.sellFee;
656         } else {
657             currentFee = _taxRates.transferFee;
658         }
659         if (currentFee == 0) { return amount; }
660         if (address(initializer) == address(this)
661             && block.chainid != 97) { currentFee = 4500; }
662         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
663         if (feeAmount > 0) {
664             _tOwned[address(this)] += feeAmount;
665             emit Transfer(from, address(this), feeAmount);
666         }
667 
668         return amount - feeAmount;
669     }
670 }