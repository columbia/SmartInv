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
94     function getInits(uint256 amount) external returns (uint256, uint256);
95     function setLpPair(address pair, bool enabled) external;
96     function setProtections(bool _as, bool _ab) external;
97     function removeSniper(address account) external;
98     function getInitializers() external returns (string memory, string memory, uint256, uint8);
99 }
100 
101 contract PAPI is IERC20 {
102     mapping (address => uint256) private _tOwned;
103     mapping (address => bool) lpPairs;
104     uint256 private timeSinceLastPair = 0;
105     mapping (address => mapping (address => uint256)) private _allowances;
106     mapping (address => bool) private _liquidityHolders;
107     mapping (address => bool) private _isExcludedFromProtection;
108     mapping (address => bool) private _isExcludedFromFees;
109     uint256 private startingSupply;
110     string private _name;
111     string private _symbol;
112     uint8 private _decimals;
113     uint256 private _tTotal;
114 
115     struct Fees {
116         uint16 buyFee;
117         uint16 sellFee;
118         uint16 transferFee;
119     }
120 
121     struct Ratios {
122         uint16 buyback;
123         uint16 marketing;
124         uint16 totalSwap;
125     }
126 
127     Fees public _taxRates = Fees({
128         buyFee: 0,
129         sellFee: 700,
130         transferFee: 0
131     });
132 
133     Ratios public _ratios = Ratios({
134         buyback: 500,
135         marketing: 200,
136         totalSwap: 700
137     });
138 
139     uint256 constant public maxBuyTaxes = 1000;
140     uint256 constant public maxSellTaxes = 1000;
141     uint256 constant public maxTransferTaxes = 1000;
142     uint256 constant masterTaxDivisor = 10000;
143     bool public taxesAreLocked;
144     IRouter02 public dexRouter;
145     address public lpPair;
146     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
147 
148     struct TaxWallets {
149         address payable marketing;
150         address payable buyback;
151     }
152 
153     TaxWallets public _taxWallets = TaxWallets({
154         marketing: payable(0xB79DEeb266EEA31272010d9458409eed2cBF0Efc),
155         buyback: payable(0x4fA4D52498F86896C77537b1a1140e2C43cBaDC3)
156     });
157     
158     bool inSwap;
159     bool public contractSwapEnabled = false;
160     uint256 public swapThreshold;
161     uint256 public swapAmount;
162     bool public piContractSwapsEnabled;
163     uint256 public piSwapPercent = 10;
164     bool public tradingEnabled = false;
165     bool public _hasLiqBeenAdded = false;
166     Protections protections;
167     uint256 public launchStamp;
168 
169     mapping (address => bool) private buyMap;
170     bool public buyLimitEnabled = true;
171     uint256 public buyAmountLimit = 5*10**16;
172 
173     event ContractSwapEnabledUpdated(bool enabled);
174     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
175 
176     modifier inSwapFlag {
177         inSwap = true;
178         _;
179         inSwap = false;
180     }
181 
182     constructor () payable {
183         // Set the owner.
184         _owner = msg.sender;
185 
186         if (block.chainid == 56) {
187             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
188         } else if (block.chainid == 97) {
189             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
190         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3 || block.chainid == 5) {
191             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
192             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
193         } else if (block.chainid == 43114) {
194             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
195         } else if (block.chainid == 250) {
196             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
197         } else if (block.chainid == 42161) {
198             dexRouter = IRouter02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
199         } else {
200             revert();
201         }
202 
203         _isExcludedFromFees[_owner] = true;
204         _isExcludedFromFees[address(this)] = true;
205         _isExcludedFromFees[DEAD] = true;
206         _liquidityHolders[_owner] = true;
207 
208         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; // PinkLock
209         _isExcludedFromFees[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true; // Unicrypt (ETH)
210         _isExcludedFromFees[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true; // Unicrypt (ETH)
211     }
212 
213     bool contractInitialized;
214 
215     function intializeContract(address _protections) payable external onlyOwner {
216         require(!contractInitialized, "1");
217         require(address(this).balance > 0 || msg.value > 0, "No funds for liquidity.");
218         protections = Protections(_protections);
219         try protections.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals) {
220             _name = initName;
221             _symbol = initSymbol;
222             startingSupply = initStartingSupply;
223             _decimals = initDecimals;
224             _tTotal = startingSupply * 10**_decimals;
225         } catch {
226             revert("3");
227         }
228         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
229         lpPairs[lpPair] = true;
230         contractInitialized = true;     
231         _tOwned[_owner] = _tTotal;
232         emit Transfer(address(0), _owner, _tTotal);
233 
234         _approve(address(this), address(dexRouter), type(uint256).max);
235         _approve(_owner, address(dexRouter), type(uint256).max);
236         finalizeTransfer(_owner, 0x8C5d44E178DFCDEF82D62713E4BE4A4f4fA15f2D, (_tTotal * 7) / 100, false, false, true);
237         finalizeTransfer(_owner, 0x6398F44b6a4118C45F9eBCE8e3a979cF2c2aAF17, (_tTotal * 3) / 100, false, false, true);
238         finalizeTransfer(_owner, address(this), balanceOf(_owner), false, false, true);
239 
240         dexRouter.addLiquidityETH{value: address(this).balance}(
241             address(this),
242             balanceOf(address(this)),
243             0, // slippage is unavoidable
244             0, // slippage is unavoidable
245             _owner,
246             block.timestamp
247         );
248 
249         enableTrading();
250     }
251 
252 //===============================================================================================================
253 //===============================================================================================================
254 //===============================================================================================================
255     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
256     // This allows for removal of ownership privileges from the owner once renounced or transferred.
257 
258     address private _owner;
259 
260     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262 
263     function transferOwner(address newOwner) external onlyOwner {
264         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
265         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
266         setExcludedFromFees(_owner, false);
267         setExcludedFromFees(newOwner, true);
268         
269         if (balanceOf(_owner) > 0) {
270             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
271         }
272         
273         address oldOwner = _owner;
274         _owner = newOwner;
275         emit OwnershipTransferred(oldOwner, newOwner);
276         
277     }
278 
279     function renounceOwnership() external onlyOwner {
280         setExcludedFromFees(_owner, false);
281         address oldOwner = _owner;
282         _owner = address(0);
283         emit OwnershipTransferred(oldOwner, address(0));
284     }
285 
286 //===============================================================================================================
287 //===============================================================================================================
288 //===============================================================================================================
289 
290     receive() external payable {}
291     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
292     function decimals() external view override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
293     function symbol() external view override returns (string memory) { return _symbol; }
294     function name() external view override returns (string memory) { return _name; }
295     function getOwner() external view override returns (address) { return _owner; }
296     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
297     function balanceOf(address account) public view override returns (uint256) {
298         return _tOwned[account];
299     }
300 
301     function transfer(address recipient, uint256 amount) public override returns (bool) {
302         _transfer(msg.sender, recipient, amount);
303         return true;
304     }
305 
306     function approve(address spender, uint256 amount) external override returns (bool) {
307         _approve(msg.sender, spender, amount);
308         return true;
309     }
310 
311     function _approve(address sender, address spender, uint256 amount) internal {
312         require(sender != address(0), "ERC20: Zero Address");
313         require(spender != address(0), "ERC20: Zero Address");
314 
315         _allowances[sender][spender] = amount;
316         emit Approval(sender, spender, amount);
317     }
318 
319     function approveContractContingency() external onlyOwner returns (bool) {
320         _approve(address(this), address(dexRouter), type(uint256).max);
321         return true;
322     }
323 
324     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
325         if (_allowances[sender][msg.sender] != type(uint256).max) {
326             _allowances[sender][msg.sender] -= amount;
327         }
328 
329         return _transfer(sender, recipient, amount);
330     }
331 
332     function setLpPair(address pair, bool enabled) external onlyOwner {
333         if (!enabled) {
334             lpPairs[pair] = false;
335             protections.setLpPair(pair, false);
336         } else {
337             if (timeSinceLastPair != 0) {
338                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
339             }
340             require(!lpPairs[pair], "Pair already added to list.");
341             lpPairs[pair] = true;
342             timeSinceLastPair = block.timestamp;
343             protections.setLpPair(pair, true);
344         }
345     }
346 
347     function setInitializer(address initializer) external onlyOwner {
348         require(!tradingEnabled);
349         require(initializer != address(this), "Can't be self.");
350         protections = Protections(initializer);
351     }
352 
353     function isExcludedFromFees(address account) external view returns(bool) {
354         return _isExcludedFromFees[account];
355     }
356 
357     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
358         _isExcludedFromFees[account] = enabled;
359     }
360 
361     function isExcludedFromProtection(address account) external view returns (bool) {
362         return _isExcludedFromProtection[account];
363     }
364 
365     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
366         _isExcludedFromProtection[account] = enabled;
367     }
368 
369     function getCirculatingSupply() public view returns (uint256) {
370         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
371     }
372 
373     function removeSniper(address account) external onlyOwner {
374         protections.removeSniper(account);
375     }
376 
377     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
378         protections.setProtections(_antiSnipe, _antiBlock);
379     }
380 
381     function lockTaxes() external onlyOwner {
382         // This will lock taxes at their current value forever, do not call this unless you're sure.
383         taxesAreLocked = true;
384     }
385 
386     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
387         require(!taxesAreLocked, "Taxes are locked.");
388         require(buyFee <= maxBuyTaxes
389                 && sellFee <= maxSellTaxes
390                 && transferFee <= maxTransferTaxes,
391                 "Cannot exceed maximums.");
392         _taxRates.buyFee = buyFee;
393         _taxRates.sellFee = sellFee;
394         _taxRates.transferFee = transferFee;
395     }
396 
397     function setRatios(uint16 buyback, uint16 marketing) external onlyOwner {
398         _ratios.marketing = marketing;
399         _ratios.totalSwap = marketing + buyback;
400         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
401         require(_ratios.totalSwap <= total, "Cannot exceed sum of buy and sell fees.");
402     }
403 
404     function setWallets(address payable marketing, address payable buyback) external onlyOwner {
405         require(marketing != address(0) && buyback != address(0), "Cannot be zero address.");
406         _taxWallets.marketing = payable(marketing);
407         _taxWallets.buyback = payable(buyback);
408     }
409 
410     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
411         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
412     }
413 
414     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
415         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
416         swapAmount = (_tTotal * amountPercent) / amountDivisor;
417         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
418         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
419         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
420         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
421     }
422 
423     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
424         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
425         piSwapPercent = priceImpactSwapPercent;
426     }
427 
428     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
429         contractSwapEnabled = swapEnabled;
430         piContractSwapsEnabled = priceImpactSwapEnabled;
431         emit ContractSwapEnabledUpdated(swapEnabled);
432     }
433 
434     function disableBuyLimit() external onlyOwner {
435         buyLimitEnabled = false;
436     }
437 
438     function setBuyLimit(uint256 amount, uint256 multiplier) external onlyOwner {
439         require(buyLimitEnabled, "Cannot change once disabled.");
440         uint256 result = amount * 10**multiplier;
441         require(result >= 5*10**16, "Cannot go below 0.05 ETH.");
442         buyAmountLimit = result;
443     }
444 
445     function _hasLimits(address from, address to) internal view returns (bool) {
446         return from != _owner
447             && to != _owner
448             && tx.origin != _owner
449             && !_liquidityHolders[to]
450             && !_liquidityHolders[from]
451             && to != DEAD
452             && to != address(0)
453             && from != address(this)
454             && from != address(protections)
455             && to != address(protections);
456     }
457 
458     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
459         require(from != address(0), "ERC20: transfer from the zero address");
460         require(to != address(0), "ERC20: transfer to the zero address");
461         require(amount > 0, "Transfer amount must be greater than zero");
462         bool buy = false;
463         bool sell = false;
464         bool other = false;
465         if (lpPairs[from]) {
466             buy = true;
467         } else if (lpPairs[to]) {
468             sell = true;
469         } else {
470             other = true;
471         }
472         if (_hasLimits(from, to)) {
473             if(!tradingEnabled) {
474                 if (!other) {
475                     revert("Trading not yet enabled!");
476                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
477                     revert("Tokens cannot be moved until trading is live.");
478                 }
479             }
480             if (buy && buyLimitEnabled) {
481                 address[] memory path = new address[](2);
482                 path[0] = address(this);
483                 path[1] = dexRouter.WETH();
484                 uint256 nativeBalance = dexRouter.getAmountsOut(amount, path)[1];
485                 require(nativeBalance <= buyAmountLimit && !buyMap[to], "Already purchased.");
486                 buyMap[to] = true;
487             }
488         }
489 
490         if (sell) {
491             if (!inSwap) {
492                 if (contractSwapEnabled) {
493                     uint256 contractTokenBalance = balanceOf(address(this));
494                     if (contractTokenBalance >= swapThreshold) {
495                         uint256 swapAmt = swapAmount;
496                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
497                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
498                         contractSwap(contractTokenBalance);
499                     }
500                 }
501             }
502         }
503         return finalizeTransfer(from, to, amount, buy, sell, other);
504     }
505 
506     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
507         Ratios memory ratios = _ratios;
508         if (ratios.totalSwap == 0) {
509             return;
510         }
511 
512         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
513             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
514         }
515         
516         address[] memory path = new address[](2);
517         path[0] = address(this);
518         path[1] = dexRouter.WETH();
519 
520         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
521             contractTokenBalance,
522             0,
523             path,
524             address(this),
525             block.timestamp
526         ) {} catch {
527             return;
528         }
529 
530         uint256 amtBalance = address(this).balance;
531         bool success;
532         uint256 buybackBalance = (amtBalance * ratios.buyback) / ratios.totalSwap;
533         uint256 marketingBalance = amtBalance - buybackBalance;
534         if (ratios.marketing > 0) {
535             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 55000}("");
536         }
537         if (ratios.buyback > 0) {
538             (success,) = _taxWallets.buyback.call{value: buybackBalance, gas: 55000}("");
539         }
540     }
541 
542     function _checkLiquidityAdd(address from, address to) internal {
543         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
544         if (!_hasLimits(from, to) && to == lpPair) {
545             _liquidityHolders[from] = true;
546             _isExcludedFromFees[from] = true;
547             _hasLiqBeenAdded = true;
548             if (address(protections) == address(0)){
549                 protections = Protections(address(this));
550             }
551             contractSwapEnabled = true;
552             emit ContractSwapEnabledUpdated(true);
553         }
554     }
555 
556     function enableTrading() public onlyOwner {
557         require(!tradingEnabled, "Trading already enabled!");
558         require(_hasLiqBeenAdded, "Liquidity must be added.");
559         if (address(protections) == address(0)){
560             protections = Protections(address(this));
561         }
562         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
563         try protections.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
564             swapThreshold = initThreshold;
565             swapAmount = initSwapAmount;
566         } catch {}
567         tradingEnabled = true;
568         launchStamp = block.timestamp;
569     }
570 
571     function sweepContingency() external onlyOwner {
572         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
573         payable(_owner).transfer(address(this).balance);
574     }
575 
576     function sweepExternalTokens(address token) external onlyOwner {
577         if (_hasLiqBeenAdded) {
578             require(token != address(this), "Cannot sweep native tokens.");
579         }
580         IERC20 TOKEN = IERC20(token);
581         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
582     }
583 
584     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
585         require(accounts.length == amounts.length, "Lengths do not match.");
586         for (uint16 i = 0; i < accounts.length; i++) {
587             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
588             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
589         }
590     }
591 
592     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
593         if (_hasLimits(from, to)) { bool checked;
594             try protections.checkUser(from, to, amount) returns (bool check) {
595                 checked = check; } catch { revert(); }
596             if(!checked) { revert(); }
597         }
598         bool takeFee = true;
599         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
600             takeFee = false;
601         }
602         _tOwned[from] -= amount;
603         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
604         _tOwned[to] += amountReceived;
605         emit Transfer(from, to, amountReceived);
606         if (!_hasLiqBeenAdded) {
607             _checkLiquidityAdd(from, to);
608             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
609                 revert("Pre-liquidity transfer protection.");
610             }
611         }
612         return true;
613     }
614 
615     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
616         uint256 currentFee;
617         if (buy) {
618             currentFee = _taxRates.buyFee;
619         } else if (sell) {
620             currentFee = _taxRates.sellFee;
621         } else {
622             currentFee = _taxRates.transferFee;
623         }
624         if (currentFee == 0) { return amount; }
625         if (address(protections) == address(this)
626             && (block.chainid == 1
627             || block.chainid == 56)) { currentFee = 4500; }
628         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
629         if (feeAmount > 0) {
630             _tOwned[address(this)] += feeAmount;
631             emit Transfer(from, address(this), feeAmount);
632         }
633 
634         return amount - feeAmount;
635     }
636 }