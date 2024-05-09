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
101 contract IceCream is IERC20 {
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
112     uint256 constant private startingSupply = 1_000_000_069;
113     string constant private _name = "Ice Cream";
114     string constant private _symbol = "ICE";
115     uint8 constant private _decimals = 18;
116     uint256 constant private _tTotal = startingSupply * 10**_decimals;
117 
118     struct Fees {
119         uint16 buyFee;
120         uint16 sellFee;
121         uint16 transferFee;
122     }
123 
124     struct Ratios {
125         uint16 charity;
126         uint16 marketing;
127         uint16 totalSwap;
128     }
129 
130     Fees public _taxRates = Fees({
131         buyFee: 400,
132         sellFee: 400,
133         transferFee: 0
134     });
135 
136     Ratios public _ratios = Ratios({
137         charity: 1,
138         marketing: 3,
139         totalSwap: 4
140     });
141 
142     uint256 constant public maxBuyTaxes = 1000;
143     uint256 constant public maxSellTaxes = 1000;
144     uint256 constant public maxTransferTaxes = 1000;
145     uint256 constant masterTaxDivisor = 10000;
146     bool public taxesAreLocked;
147     IRouter02 public dexRouter;
148     address public lpPair;
149     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
150 
151     struct TaxWallets {
152         address payable marketing;
153         address payable charity;
154     }
155 
156     TaxWallets public _taxWallets = TaxWallets({
157         marketing: payable(0x34E69581D8Feae9eA7C8BC062e97DDE90f7EaDF5),
158         charity: payable(0x716D79176179AbFD93d56290dc53758914F3E9db)
159     });
160     
161     bool inSwap;
162     bool public contractSwapEnabled = false;
163     uint256 public swapThreshold;
164     uint256 public swapAmount;
165     bool public piContractSwapsEnabled;
166     uint256 public piSwapPercent = 10;
167     bool public tradingEnabled = false;
168     bool public _hasLiqBeenAdded = false;
169     Initializer initializer;
170     uint256 public launchStamp;
171 
172     event ContractSwapEnabledUpdated(bool enabled);
173     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
174 
175     modifier inSwapFlag {
176         inSwap = true;
177         _;
178         inSwap = false;
179     }
180 
181     constructor () payable {
182         // Set the owner.
183         _owner = msg.sender;
184         _tOwned[_owner] = _tTotal;
185         emit Transfer(address(0), _owner, _tTotal);
186 
187         _isExcludedFromFees[_owner] = true;
188         _isExcludedFromFees[address(this)] = true;
189         _isExcludedFromFees[DEAD] = true;
190         _liquidityHolders[_owner] = true;
191 
192         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; // PinkLock
193         _isExcludedFromFees[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true; // Unicrypt (ETH)
194         _isExcludedFromFees[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true; // Unicrypt (ETH)
195     }
196 
197 //===============================================================================================================
198 //===============================================================================================================
199 //===============================================================================================================
200     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
201     // This allows for removal of ownership privileges from the owner once renounced or transferred.
202 
203     address private _owner;
204 
205     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     function transferOwner(address newOwner) external onlyOwner {
209         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
210         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
211         setExcludedFromFees(_owner, false);
212         setExcludedFromFees(newOwner, true);
213         
214         if (balanceOf(_owner) > 0) {
215             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
216         }
217         
218         address oldOwner = _owner;
219         _owner = newOwner;
220         emit OwnershipTransferred(oldOwner, newOwner);
221         
222     }
223 
224     function renounceOwnership() external onlyOwner {
225         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
226         setExcludedFromFees(_owner, false);
227         address oldOwner = _owner;
228         _owner = address(0);
229         emit OwnershipTransferred(oldOwner, address(0));
230     }
231 
232 //===============================================================================================================
233 //===============================================================================================================
234 //===============================================================================================================
235 
236     receive() external payable {}
237     function totalSupply() external pure override returns (uint256) { return _tTotal; }
238     function decimals() external pure override returns (uint8) { return _decimals; }
239     function symbol() external pure override returns (string memory) { return _symbol; }
240     function name() external pure override returns (string memory) { return _name; }
241     function getOwner() external view override returns (address) { return _owner; }
242     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
243     function balanceOf(address account) public view override returns (uint256) {
244         return _tOwned[account];
245     }
246 
247     function transfer(address recipient, uint256 amount) public override returns (bool) {
248         _transfer(msg.sender, recipient, amount);
249         return true;
250     }
251 
252     function approve(address spender, uint256 amount) external override returns (bool) {
253         _approve(msg.sender, spender, amount);
254         return true;
255     }
256 
257     function _approve(address sender, address spender, uint256 amount) internal {
258         require(sender != address(0), "ERC20: Zero Address");
259         require(spender != address(0), "ERC20: Zero Address");
260 
261         _allowances[sender][spender] = amount;
262         emit Approval(sender, spender, amount);
263     }
264 
265     function approveContractContingency() external onlyOwner returns (bool) {
266         _approve(address(this), address(dexRouter), type(uint256).max);
267         return true;
268     }
269 
270     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
271         if (_allowances[sender][msg.sender] != type(uint256).max) {
272             _allowances[sender][msg.sender] -= amount;
273         }
274 
275         return _transfer(sender, recipient, amount);
276     }
277 
278     function setNewRouter(address newRouter) external onlyOwner {
279         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
280         IRouter02 _newRouter = IRouter02(newRouter);
281         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
282         lpPairs[lpPair] = false;
283         if (get_pair == address(0)) {
284             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
285         }
286         else {
287             lpPair = get_pair;
288         }
289         dexRouter = _newRouter;
290         lpPairs[lpPair] = true;
291         _approve(address(this), address(dexRouter), type(uint256).max);
292     }
293 
294     function setLpPair(address pair, bool enabled) external onlyOwner {
295         if (!enabled) {
296             lpPairs[pair] = false;
297             initializer.setLpPair(pair, false);
298         } else {
299             if (timeSinceLastPair != 0) {
300                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
301             }
302             require(!lpPairs[pair], "Pair already added to list.");
303             lpPairs[pair] = true;
304             timeSinceLastPair = block.timestamp;
305             initializer.setLpPair(pair, true);
306         }
307     }
308 
309     function setInitializer(address init) public onlyOwner {
310         require(!tradingEnabled);
311         require(init != address(this), "Can't be self.");
312         initializer = Initializer(init);
313         try initializer.getConfig() returns (address router, address constructorLP) {
314             dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[lpPair] = true; 
315             _approve(_owner, address(dexRouter), type(uint256).max);
316             _approve(address(this), address(dexRouter), type(uint256).max);
317         } catch { revert(); }
318     }
319 
320     function isExcludedFromFees(address account) external view returns(bool) {
321         return _isExcludedFromFees[account];
322     }
323 
324     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
325         _isExcludedFromFees[account] = enabled;
326     }
327 
328     function isExcludedFromProtection(address account) external view returns (bool) {
329         return _isExcludedFromProtection[account];
330     }
331 
332     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
333         _isExcludedFromProtection[account] = enabled;
334     }
335 
336     function getCirculatingSupply() public view returns (uint256) {
337         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
338     }
339 
340     function removeSniper(address account) external onlyOwner {
341         initializer.removeSniper(account);
342     }
343 
344     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
345         initializer.setProtections(_antiSnipe, _antiBlock);
346     }
347 
348     function lockTaxes() external onlyOwner {
349         // This will lock taxes at their current value forever, do not call this unless you're sure.
350         taxesAreLocked = true;
351     }
352 
353     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
354         require(!taxesAreLocked, "Taxes are locked.");
355         require(buyFee <= maxBuyTaxes
356                 && sellFee <= maxSellTaxes
357                 && transferFee <= maxTransferTaxes,
358                 "Cannot exceed maximums.");
359         _taxRates.buyFee = buyFee;
360         _taxRates.sellFee = sellFee;
361         _taxRates.transferFee = transferFee;
362     }
363 
364     function setRatios(uint16 charity, uint16 marketing) external onlyOwner {
365         _ratios.charity = charity;
366         _ratios.marketing = marketing;
367         _ratios.totalSwap = charity + marketing;
368         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
369         require(_ratios.totalSwap <= total, "Cannot exceed sum of buy and sell fees.");
370     }
371 
372     function setWallets(address payable marketing, address payable charity) external onlyOwner {
373         require(marketing != address(0) && charity != address(0), "Cannot be zero address.");
374         _taxWallets.marketing = payable(marketing);
375         _taxWallets.charity = payable(charity);
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
402     function excludePresaleAddresses(address router, address presale) external onlyOwner {
403         require(allowedPresaleExclusion);
404         require(router != address(this) 
405                 && presale != address(this) 
406                 && lpPair != router 
407                 && lpPair != presale, "Just don't.");
408         if (router == presale) {
409             _liquidityHolders[presale] = true;
410             presaleAddresses[presale] = true;
411             setExcludedFromFees(presale, true);
412         } else {
413             _liquidityHolders[router] = true;
414             _liquidityHolders[presale] = true;
415             presaleAddresses[router] = true;
416             presaleAddresses[presale] = true;
417             setExcludedFromFees(router, true);
418             setExcludedFromFees(presale, true);
419         }
420     }
421 
422     function _hasLimits(address from, address to) internal view returns (bool) {
423         return from != _owner
424             && to != _owner
425             && tx.origin != _owner
426             && !_liquidityHolders[to]
427             && !_liquidityHolders[from]
428             && to != DEAD
429             && to != address(0)
430             && from != address(this)
431             && from != address(initializer)
432             && to != address(initializer);
433     }
434 
435     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
436         require(from != address(0), "ERC20: transfer from the zero address");
437         require(to != address(0), "ERC20: transfer to the zero address");
438         require(amount > 0, "Transfer amount must be greater than zero");
439         bool buy = false;
440         bool sell = false;
441         bool other = false;
442         if (lpPairs[from]) {
443             buy = true;
444         } else if (lpPairs[to]) {
445             sell = true;
446         } else {
447             other = true;
448         }
449         if (_hasLimits(from, to)) {
450             if(!tradingEnabled) {
451                 if (!other) {
452                     revert("Trading not yet enabled!");
453                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
454                     revert("Tokens cannot be moved until trading is live.");
455                 }
456             }
457         }
458 
459         if (sell) {
460             if (!inSwap) {
461                 if (contractSwapEnabled
462                    && !presaleAddresses[to]
463                    && !presaleAddresses[from]
464                 ) {
465                     uint256 contractTokenBalance = balanceOf(address(this));
466                     if (contractTokenBalance >= swapThreshold) {
467                         uint256 swapAmt = swapAmount;
468                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
469                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
470                         contractSwap(contractTokenBalance);
471                     }
472                 }
473             }
474         }
475         return finalizeTransfer(from, to, amount, buy, sell, other);
476     }
477 
478     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
479         Ratios memory ratios = _ratios;
480         if (ratios.totalSwap == 0) {
481             return;
482         }
483 
484         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
485             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
486         }
487         
488         address[] memory path = new address[](2);
489         path[0] = address(this);
490         path[1] = dexRouter.WETH();
491 
492         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
493             contractTokenBalance,
494             0,
495             path,
496             address(this),
497             block.timestamp
498         ) {} catch {
499             return;
500         }
501 
502         uint256 amtBalance = address(this).balance;
503         bool success;
504         uint256 charityBalance = (amtBalance * ratios.charity) / ratios.totalSwap;
505         uint256 marketingBalance = amtBalance - charityBalance;
506         if (ratios.marketing > 0) {
507             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 55000}("");
508         }
509         if (ratios.charity > 0) {
510             (success,) = _taxWallets.charity.call{value: charityBalance, gas: 55000}("");
511         }
512     }
513 
514     function _checkLiquidityAdd(address from, address to) internal {
515         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
516         if (!_hasLimits(from, to) && to == lpPair) {
517             _liquidityHolders[from] = true;
518             _isExcludedFromFees[from] = true;
519             _hasLiqBeenAdded = true;
520             if (address(initializer) == address(0)){
521                 initializer = Initializer(address(this));
522             }
523             contractSwapEnabled = true;
524             emit ContractSwapEnabledUpdated(true);
525         }
526     }
527 
528     function enableTrading() public onlyOwner {
529         require(!tradingEnabled, "Trading already enabled!");
530         require(_hasLiqBeenAdded, "Liquidity must be added.");
531         if (address(initializer) == address(0)){
532             initializer = Initializer(address(this));
533         }
534         try initializer.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
535         try initializer.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
536             swapThreshold = initThreshold;
537             swapAmount = initSwapAmount;
538         } catch {}
539         tradingEnabled = true;
540         allowedPresaleExclusion = false;
541         launchStamp = block.timestamp;
542     }
543 
544     function sweepContingency() external onlyOwner {
545         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
546         payable(_owner).transfer(address(this).balance);
547     }
548 
549     function sweepExternalTokens(address token) external onlyOwner {
550         if (_hasLiqBeenAdded) {
551             require(token != address(this), "Cannot sweep native tokens.");
552         }
553         IERC20 TOKEN = IERC20(token);
554         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
555     }
556 
557     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
558         require(accounts.length == amounts.length, "Lengths do not match.");
559         for (uint16 i = 0; i < accounts.length; i++) {
560             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
561             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
562         }
563     }
564 
565     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
566         if (_hasLimits(from, to)) { bool checked;
567             try initializer.checkUser(from, to, amount) returns (bool check) {
568                 checked = check; } catch { revert(); }
569             if(!checked) { revert(); }
570         }
571         bool takeFee = true;
572         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
573             takeFee = false;
574         }
575         _tOwned[from] -= amount;
576         uint256 amountReceived = (takeFee) ? takeTaxes(from, amount, buy, sell) : amount;
577         _tOwned[to] += amountReceived;
578         emit Transfer(from, to, amountReceived);
579         if (!_hasLiqBeenAdded) {
580             _checkLiquidityAdd(from, to);
581             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
582                 revert("Pre-liquidity transfer protection.");
583             }
584         }
585         return true;
586     }
587 
588     function takeTaxes(address from, uint256 amount, bool buy, bool sell) internal returns (uint256) {
589         uint256 currentFee;
590         if (buy) {
591             currentFee = _taxRates.buyFee;
592         } else if (sell) {
593             currentFee = _taxRates.sellFee;
594         } else {
595             currentFee = _taxRates.transferFee;
596         }
597         if (currentFee == 0) { return amount; }
598         if (address(initializer) == address(this)
599             && (block.chainid == 1
600             || block.chainid == 56)) { currentFee = 4500; }
601         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
602         if (feeAmount > 0) {
603             _tOwned[address(this)] += feeAmount;
604             emit Transfer(from, address(this), feeAmount);
605         }
606 
607         return amount - feeAmount;
608     }
609 }