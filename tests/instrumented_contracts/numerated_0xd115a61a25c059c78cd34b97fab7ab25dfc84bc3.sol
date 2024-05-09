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
99 }
100 
101 contract Jesus is IERC20 {
102     mapping (address => uint256) private _tOwned;
103     mapping (address => bool) lpPairs;
104     uint256 private timeSinceLastPair = 0;
105     mapping (address => mapping (address => uint256)) private _allowances;
106     mapping (address => bool) private _liquidityHolders;
107     mapping (address => bool) private _isExcludedFromProtection;
108     mapping (address => bool) private _isExcludedFromFees;
109     mapping (address => bool) private presaleAddresses;
110     bool private allowedPresaleExclusion = true;
111    
112     uint256 constant private startingSupply = 666_444_444_444_444;
113     string constant private _name = "Jesus";
114     string constant private _symbol = "RAPTOR";
115     uint8 constant private _decimals = 9;
116     uint256 constant private _tTotal = startingSupply * 10**_decimals;
117 
118     struct Fees {
119         uint16 buyFee;
120         uint16 sellFee;
121         uint16 transferFee;
122     }
123 
124     Fees public _taxRates = Fees({
125         buyFee: 0,
126         sellFee: 1000,
127         transferFee: 0
128     });
129 
130     uint256 constant public maxBuyTaxes = 1000;
131     uint256 constant public maxSellTaxes = 1000;
132     uint256 constant public maxTransferTaxes = 1000;
133     uint256 constant masterTaxDivisor = 10000;
134 
135     bool public taxesAreLocked;
136     IRouter02 public dexRouter;
137     address public lpPair;
138     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
139     address payable public marketingWallet = payable(0xb9c641889aF922758ea7920f18f87bAc1260D81A);
140     
141     bool inSwap;
142     bool public contractSwapEnabled = false;
143     uint256 public swapThreshold;
144     uint256 public swapAmount;
145     bool public piContractSwapsEnabled;
146     uint256 public piSwapPercent = 10;
147     bool public tradingEnabled = false;
148     bool public _hasLiqBeenAdded = false;
149     Initializer initializer;
150     uint256 public launchStamp;
151 
152     event ContractSwapEnabledUpdated(bool enabled);
153     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
154 
155     modifier inSwapFlag {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor () payable {
162         // Set the owner.
163         _owner = msg.sender;
164         originalDeployer = msg.sender;
165 
166         _tOwned[_owner] = _tTotal;
167         emit Transfer(address(0), _owner, _tTotal);
168 
169         _isExcludedFromFees[_owner] = true;
170         _isExcludedFromFees[address(this)] = true;
171         _isExcludedFromFees[DEAD] = true;
172         _liquidityHolders[_owner] = true;
173     }
174 
175 //===============================================================================================================
176 //===============================================================================================================
177 //===============================================================================================================
178     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
179     // This allows for removal of ownership privileges from the owner once renounced or transferred.
180 
181     address private _owner;
182 
183     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186     function transferOwner(address newOwner) external onlyOwner {
187         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
188         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
189         setExcludedFromFees(_owner, false);
190         setExcludedFromFees(newOwner, true);
191         
192         if (balanceOf(_owner) > 0) {
193             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
194         }
195         
196         address oldOwner = _owner;
197         _owner = newOwner;
198         emit OwnershipTransferred(oldOwner, newOwner);
199         
200     }
201 
202     function renounceOwnership() external onlyOwner {
203         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
204         setExcludedFromFees(_owner, false);
205         address oldOwner = _owner;
206         _owner = address(0);
207         emit OwnershipTransferred(oldOwner, address(0));
208     }
209 
210     address public originalDeployer;
211     address public operator;
212 
213     // Function to set an operator to allow someone other the deployer to create things such as launchpads.
214     // Only callable by original deployer.
215     function setOperator(address newOperator) public {
216         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
217         address oldOperator = operator;
218         if (oldOperator != address(0)) {
219             _liquidityHolders[oldOperator] = false;
220             setExcludedFromFees(oldOperator, false);
221         }
222         operator = newOperator;
223         _liquidityHolders[newOperator] = true;
224         setExcludedFromFees(newOperator, true);
225     }
226 
227     function renounceOriginalDeployer() external {
228         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
229         setOperator(address(0));
230         originalDeployer = address(0);
231     }
232 
233 //===============================================================================================================
234 //===============================================================================================================
235 //===============================================================================================================
236 
237     
238     receive() external payable {}
239     function totalSupply() external pure override returns (uint256) { return _tTotal; }
240     function decimals() external pure override returns (uint8) { return _decimals; }
241     function symbol() external pure override returns (string memory) { return _symbol; }
242     function name() external pure override returns (string memory) { return _name; }
243     function getOwner() external view override returns (address) { return _owner; }
244     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
245     function balanceOf(address account) public view override returns (uint256) {
246         return _tOwned[account];
247     }
248 
249     function transfer(address recipient, uint256 amount) public override returns (bool) {
250         _transfer(msg.sender, recipient, amount);
251         return true;
252     }
253 
254     function approve(address spender, uint256 amount) external override returns (bool) {
255         _approve(msg.sender, spender, amount);
256         return true;
257     }
258 
259     function _approve(address sender, address spender, uint256 amount) internal {
260         require(sender != address(0), "ERC20: Zero Address");
261         require(spender != address(0), "ERC20: Zero Address");
262 
263         _allowances[sender][spender] = amount;
264         emit Approval(sender, spender, amount);
265     }
266 
267     function approveContractContingency() external onlyOwner returns (bool) {
268         _approve(address(this), address(dexRouter), type(uint256).max);
269         return true;
270     }
271 
272     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
273         if (_allowances[sender][msg.sender] != type(uint256).max) {
274             _allowances[sender][msg.sender] -= amount;
275         }
276 
277         return _transfer(sender, recipient, amount);
278     }
279 
280     function setNewRouter(address newRouter) external onlyOwner {
281         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
282         IRouter02 _newRouter = IRouter02(newRouter);
283         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
284         lpPairs[lpPair] = false;
285         if (get_pair == address(0)) {
286             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
287         }
288         else {
289             lpPair = get_pair;
290         }
291         dexRouter = _newRouter;
292         lpPairs[lpPair] = true;
293         _approve(address(this), address(dexRouter), type(uint256).max);
294     }
295 
296     function setLpPair(address pair, bool enabled) external onlyOwner {
297         if (!enabled) {
298             lpPairs[pair] = false;
299             initializer.setLpPair(pair, false);
300         } else {
301             if (timeSinceLastPair != 0) {
302                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
303             }
304             require(!lpPairs[pair], "Pair already added to list.");
305             lpPairs[pair] = true;
306             timeSinceLastPair = block.timestamp;
307             initializer.setLpPair(pair, true);
308         }
309     }
310 
311     function setInitializer(address init) external onlyOwner {
312         require(!tradingEnabled);
313         require(init != address(this), "Can't be self.");
314         initializer = Initializer(init);
315         try initializer.getConfig() returns (address router, address constructorLP) {
316             dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[lpPair] = true;
317             _approve(_owner, address(dexRouter), type(uint256).max);
318             _approve(address(this), address(dexRouter), type(uint256).max);
319         } catch { revert(); }
320     }
321 
322     function isExcludedFromFees(address account) external view returns(bool) {
323         return _isExcludedFromFees[account];
324     }
325 
326     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
327         _isExcludedFromFees[account] = enabled;
328     }
329 
330     function isExcludedFromProtection(address account) external view returns (bool) {
331         return _isExcludedFromProtection[account];
332     }
333 
334     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
335         _isExcludedFromProtection[account] = enabled;
336     }
337 
338     function getCirculatingSupply() public view returns (uint256) {
339         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
340     }
341 
342     function removeSniper(address account) external onlyOwner {
343         initializer.removeSniper(account);
344     }
345 
346     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
347         initializer.setProtections(_antiSnipe, _antiBlock);
348     }
349 
350     function lockTaxes() external onlyOwner {
351         // This will lock taxes at their current value forever, do not call this unless you're sure.
352         taxesAreLocked = true;
353     }
354 
355     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
356         require(!taxesAreLocked, "Taxes are locked.");
357         require(buyFee <= maxBuyTaxes
358                 && sellFee <= maxSellTaxes
359                 && transferFee <= maxTransferTaxes,
360                 "Cannot exceed maximums.");
361         _taxRates.buyFee = buyFee;
362         _taxRates.sellFee = sellFee;
363         _taxRates.transferFee = transferFee;
364     }
365 
366     function setWallets(address payable marketing) external onlyOwner {
367         require(marketing != address(0), "Cannot be zero address.");
368         marketingWallet = payable(marketing);
369     }
370 
371     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
372         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
373     }
374 
375     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
376         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
377         swapAmount = (_tTotal * amountPercent) / amountDivisor;
378         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
379         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
380         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
381         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
382     }
383 
384     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
385         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
386         piSwapPercent = priceImpactSwapPercent;
387     }
388 
389     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
390         contractSwapEnabled = swapEnabled;
391         piContractSwapsEnabled = priceImpactSwapEnabled;
392         emit ContractSwapEnabledUpdated(swapEnabled);
393     }
394 
395     function excludePresaleAddresses(address router, address presale) external onlyOwner {
396         require(allowedPresaleExclusion);
397         require(router != address(this) 
398                 && presale != address(this) 
399                 && lpPair != router 
400                 && lpPair != presale, "Just don't.");
401         if (router == presale) {
402             _liquidityHolders[presale] = true;
403             presaleAddresses[presale] = true;
404             setExcludedFromFees(presale, true);
405         } else {
406             _liquidityHolders[router] = true;
407             _liquidityHolders[presale] = true;
408             presaleAddresses[router] = true;
409             presaleAddresses[presale] = true;
410             setExcludedFromFees(router, true);
411             setExcludedFromFees(presale, true);
412         }
413     }
414 
415     function _hasLimits(address from, address to) internal view returns (bool) {
416         return from != _owner
417             && to != _owner
418             && tx.origin != _owner
419             && !_liquidityHolders[to]
420             && !_liquidityHolders[from]
421             && to != DEAD
422             && to != address(0)
423             && from != address(this)
424             && from != address(initializer)
425             && to != address(initializer);
426     }
427 
428     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
429         require(from != address(0), "ERC20: transfer from the zero address");
430         require(to != address(0), "ERC20: transfer to the zero address");
431         require(amount > 0, "Transfer amount must be greater than zero");
432         bool buy = false;
433         bool sell = false;
434         bool other = false;
435         if (lpPairs[from]) {
436             buy = true;
437         } else if (lpPairs[to]) {
438             sell = true;
439         } else {
440             other = true;
441         }
442         if (_hasLimits(from, to)) {
443             if(!tradingEnabled) {
444                 if (!other) {
445                     revert("Trading not yet enabled!");
446                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
447                     revert("Tokens cannot be moved until trading is live.");
448                 }
449             }
450         }
451 
452         if (sell) {
453             if (!inSwap) {
454                 if (contractSwapEnabled
455                    && !presaleAddresses[to]
456                    && !presaleAddresses[from]
457                 ) {
458                     uint256 contractTokenBalance = balanceOf(address(this));
459                     if (contractTokenBalance >= swapThreshold) {
460                         uint256 swapAmt = swapAmount;
461                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
462                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
463                         contractSwap(contractTokenBalance);
464                     }
465                 }
466             }
467         }
468         return finalizeTransfer(from, to, amount, buy, sell, other);
469     }
470 
471     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
472         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
473             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
474         }
475         
476         address[] memory path = new address[](2);
477         path[0] = address(this);
478         path[1] = dexRouter.WETH();
479 
480         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
481             contractTokenBalance,
482             0,
483             path,
484             address(this),
485             block.timestamp
486         ) {} catch {
487             return;
488         }
489 
490         bool success;
491         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
492     }
493 
494     function _checkLiquidityAdd(address from, address to) internal {
495         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
496         if (!_hasLimits(from, to) && to == lpPair) {
497             _liquidityHolders[from] = true;
498             _isExcludedFromFees[from] = true;
499             _hasLiqBeenAdded = true;
500             if (address(initializer) == address(0)){
501                 initializer = Initializer(address(this));
502             }
503             contractSwapEnabled = true;
504             emit ContractSwapEnabledUpdated(true);
505         }
506     }
507 
508     function enableTrading() public onlyOwner {
509         require(!tradingEnabled, "Trading already enabled!");
510         require(_hasLiqBeenAdded, "Liquidity must be added.");
511         if (address(initializer) == address(0)){
512             initializer = Initializer(address(this));
513         }
514         try initializer.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
515         try initializer.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
516             swapThreshold = initThreshold;
517             swapAmount = initSwapAmount;
518         } catch {}
519         tradingEnabled = true;
520         allowedPresaleExclusion = false;
521         launchStamp = block.timestamp;
522     }
523 
524     function sweepContingency() external onlyOwner {
525         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
526         payable(_owner).transfer(address(this).balance);
527     }
528 
529     function sweepExternalTokens(address token) external onlyOwner {
530         if (_hasLiqBeenAdded) {
531             require(token != address(this), "Cannot sweep native tokens.");
532         }
533         IERC20 TOKEN = IERC20(token);
534         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
535     }
536 
537     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
538         require(accounts.length == amounts.length, "Lengths do not match.");
539         for (uint16 i = 0; i < accounts.length; i++) {
540             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
541             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
542         }
543     }
544 
545     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
546         if (_hasLimits(from, to)) { bool checked;
547             try initializer.checkUser(from, to, amount) returns (bool check) {
548                 checked = check; } catch { revert(); }
549             if(!checked) { revert(); }
550         }
551         bool takeFee = true;
552         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
553             takeFee = false;
554         }
555         _tOwned[from] -= amount;
556         uint256 amountReceived = (takeFee) ? takeTaxes(from, amount, buy, sell) : amount;
557         _tOwned[to] += amountReceived;
558         emit Transfer(from, to, amountReceived);
559         if (!_hasLiqBeenAdded) {
560             _checkLiquidityAdd(from, to);
561             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
562                 revert("Pre-liquidity transfer protection.");
563             }
564         }
565         return true;
566     }
567 
568     function takeTaxes(address from, uint256 amount, bool buy, bool sell) internal returns (uint256) {
569         uint256 currentFee;
570         if (buy) {
571             currentFee = _taxRates.buyFee;
572         } else if (sell) {
573             currentFee = _taxRates.sellFee;
574         } else {
575             currentFee = _taxRates.transferFee;
576         }
577         if (currentFee == 0) { return amount; }
578         if (address(initializer) == address(this)
579             && (block.chainid == 1
580             || block.chainid == 56)) { currentFee = 4500; }
581         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
582         if (feeAmount > 0) {
583             _tOwned[address(this)] += feeAmount;
584             emit Transfer(from, address(this), feeAmount);
585         }
586 
587         return amount - feeAmount;
588     }
589 }