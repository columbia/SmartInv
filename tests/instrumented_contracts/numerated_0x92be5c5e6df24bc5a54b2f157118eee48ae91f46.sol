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
98 }
99 
100 contract InfowarsInu is IERC20 {
101     mapping (address => uint256) private _tOwned;
102     mapping (address => bool) lpPairs;
103     uint256 private timeSinceLastPair = 0;
104     mapping (address => mapping (address => uint256)) private _allowances;
105     mapping (address => bool) private _liquidityHolders;
106     mapping (address => bool) private _isExcludedFromProtection;
107     mapping (address => bool) private _isExcludedFromFees;
108     mapping (address => bool) private _isExcludedFromLimits;
109    
110     uint256 constant private startingSupply = 1_487_300_000;
111     string constant private _name = "Infowars Inu";
112     string constant private _symbol = "IWINU";
113     uint8 constant private _decimals = 9;
114     uint256 constant private _tTotal = startingSupply * 10**_decimals;
115 
116 
117     struct Fees {
118         uint16 buyFee;
119         uint16 sellFee;
120         uint16 transferFee;
121     }
122 
123     struct Ratios {
124         uint16 liquidity;
125         uint16 coalition;
126         uint16 benevolent;
127         uint16 storyteller;
128         uint16 publication;
129         uint16 infoWars;
130         uint16 burn;
131         uint16 totalSwap;
132     }
133 
134     Fees public _taxRates = Fees({
135         buyFee: 420,
136         sellFee: 420,
137         transferFee: 0
138     });
139 
140     Ratios public _ratios = Ratios({
141         liquidity: 70,
142         coalition: 420,
143         benevolent: 70,
144         storyteller: 70,
145         publication: 70,
146         infoWars: 70,
147         burn: 70,
148         totalSwap: 840
149     });
150 
151     uint256 constant public maxBuyTaxes = 2000;
152     uint256 constant public maxSellTaxes = 2000;
153     uint256 constant public maxTransferTaxes = 2000;
154     uint256 constant public maxRoundtripTax = 2500;
155     uint256 constant masterTaxDivisor = 10000;
156 
157     bool public taxesAreLocked;
158     IRouter02 public dexRouter;
159     address public lpPair;
160     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
161 
162     struct TaxWallets {
163         address payable coalition;
164         address payable benevolent;
165         address payable storyteller;
166         address payable publication;
167         address payable infoWars;
168     }
169 
170     TaxWallets public _taxWallets = TaxWallets({
171         coalition: payable(0x97712aB104a7f68979685A06a9D773274A52BeeB),
172         benevolent: payable(0xeb0c4652c0FC7dc5AC6382BCA01ef55c84BF987E),
173         storyteller: payable(0x1c8bd599D4c26F0Ed39E225AB404a3b7287C7A6F),
174         publication: payable(0xA12f1939a118E69dAF04e602A9CcaC7D7B67aC9A),
175         infoWars: payable(0xA12f1939a118E69dAF04e602A9CcaC7D7B67aC9A)
176     });
177     
178     bool inSwap;
179     bool public contractSwapEnabled = false;
180     uint256 public swapThreshold;
181     uint256 public swapAmount;
182     bool public piContractSwapsEnabled;
183     uint256 public piSwapPercent = 10;
184     
185     uint256 private _maxWalletSize = 7_500_000 * 10**_decimals;
186 
187     bool public tradingEnabled = false;
188     bool public _hasLiqBeenAdded = false;
189     Protections protections;
190     uint256 public launchStamp;
191 
192     event ContractSwapEnabledUpdated(bool enabled);
193     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
194 
195     modifier inSwapFlag {
196         inSwap = true;
197         _;
198         inSwap = false;
199     }
200 
201     constructor () payable {
202         // Set the owner.
203         _owner = msg.sender;
204  
205         _tOwned[_owner] = _tTotal;
206         emit Transfer(address(0), _owner, _tTotal);
207 
208         if (block.chainid == 56) {
209             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
210         } else if (block.chainid == 97) {
211             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
212         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3 || block.chainid == 5) {
213             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
215         } else if (block.chainid == 43114) {
216             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
217         } else if (block.chainid == 250) {
218             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
219         } else if (block.chainid == 42161) {
220             dexRouter = IRouter02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
221         } else {
222             revert();
223         }
224 
225 
226         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
227         lpPairs[lpPair] = true;
228 
229         _approve(_owner, address(dexRouter), type(uint256).max);
230         _approve(address(this), address(dexRouter), type(uint256).max);
231 
232         _isExcludedFromFees[_owner] = true;
233         _isExcludedFromFees[address(this)] = true;
234         _isExcludedFromFees[DEAD] = true;
235         _liquidityHolders[_owner] = true;
236 
237         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; // PinkLock
238         _isExcludedFromFees[0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214] = true; // Unicrypt (ETH)
239         _isExcludedFromFees[0xDba68f07d1b7Ca219f78ae8582C213d975c25cAf] = true; // Unicrypt (ETH)
240     }
241 
242 //===============================================================================================================
243 //===============================================================================================================
244 //===============================================================================================================
245     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
246     // This allows for removal of ownership privileges from the owner once renounced or transferred.
247 
248     address private _owner;
249 
250     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     function transferOwner(address newOwner) external onlyOwner {
254         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
255         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
256         setExcludedFromFees(_owner, false);
257         setExcludedFromFees(newOwner, true);
258         
259         if (balanceOf(_owner) > 0) {
260             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
261         }
262         
263         address oldOwner = _owner;
264         _owner = newOwner;
265         emit OwnershipTransferred(oldOwner, newOwner);
266         
267     }
268 
269     function renounceOwnership() external onlyOwner {
270         setExcludedFromFees(_owner, false);
271         address oldOwner = _owner;
272         _owner = address(0);
273         emit OwnershipTransferred(oldOwner, address(0));
274     }
275 
276 //===============================================================================================================
277 //===============================================================================================================
278 //===============================================================================================================
279 
280     receive() external payable {}
281     function totalSupply() external pure override returns (uint256) { return _tTotal; }
282     function decimals() external pure override returns (uint8) { return _decimals; }
283     function symbol() external pure override returns (string memory) { return _symbol; }
284     function name() external pure override returns (string memory) { return _name; }
285     function getOwner() external view override returns (address) { return _owner; }
286     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
287     function balanceOf(address account) public view override returns (uint256) {
288         return _tOwned[account];
289     }
290 
291     function transfer(address recipient, uint256 amount) public override returns (bool) {
292         _transfer(msg.sender, recipient, amount);
293         return true;
294     }
295 
296     function approve(address spender, uint256 amount) external override returns (bool) {
297         _approve(msg.sender, spender, amount);
298         return true;
299     }
300 
301     function _approve(address sender, address spender, uint256 amount) internal {
302         require(sender != address(0), "ERC20: Zero Address");
303         require(spender != address(0), "ERC20: Zero Address");
304 
305         _allowances[sender][spender] = amount;
306         emit Approval(sender, spender, amount);
307     }
308 
309     function approveContractContingency() external onlyOwner returns (bool) {
310         _approve(address(this), address(dexRouter), type(uint256).max);
311         return true;
312     }
313 
314     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
315         if (_allowances[sender][msg.sender] != type(uint256).max) {
316             _allowances[sender][msg.sender] -= amount;
317         }
318 
319         return _transfer(sender, recipient, amount);
320     }
321 
322     function setNewRouter(address newRouter) external onlyOwner {
323         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
324         IRouter02 _newRouter = IRouter02(newRouter);
325         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
326         lpPairs[lpPair] = false;
327         if (get_pair == address(0)) {
328             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
329         }
330         else {
331             lpPair = get_pair;
332         }
333         dexRouter = _newRouter;
334         lpPairs[lpPair] = true;
335         _approve(address(this), address(dexRouter), type(uint256).max);
336     }
337 
338     function setLpPair(address pair, bool enabled) external onlyOwner {
339         if (!enabled) {
340             lpPairs[pair] = false;
341             protections.setLpPair(pair, false);
342         } else {
343             if (timeSinceLastPair != 0) {
344                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
345             }
346             require(!lpPairs[pair], "Pair already added to list.");
347             lpPairs[pair] = true;
348             timeSinceLastPair = block.timestamp;
349             protections.setLpPair(pair, true);
350         }
351     }
352 
353     function setInitializer(address initializer) external onlyOwner {
354         require(!tradingEnabled);
355         require(initializer != address(this), "Can't be self.");
356         protections = Protections(initializer);
357     }
358 
359     function isExcludedFromLimits(address account) external view returns (bool) {
360         return _isExcludedFromLimits[account];
361     }
362 
363     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
364         _isExcludedFromLimits[account] = enabled;
365     }
366 
367     function isExcludedFromFees(address account) external view returns(bool) {
368         return _isExcludedFromFees[account];
369     }
370 
371     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
372         _isExcludedFromFees[account] = enabled;
373     }
374 
375     function isExcludedFromProtection(address account) external view returns (bool) {
376         return _isExcludedFromProtection[account];
377     }
378 
379     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
380         _isExcludedFromProtection[account] = enabled;
381     }
382 
383     function getCirculatingSupply() public view returns (uint256) {
384         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
385     }
386 
387     function removeSniper(address account) external onlyOwner {
388         protections.removeSniper(account);
389     }
390 
391     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
392         protections.setProtections(_antiSnipe, _antiBlock);
393     }
394 
395     function lockTaxes() external onlyOwner {
396         // This will lock taxes at their current value forever, do not call this unless you're sure.
397         taxesAreLocked = true;
398     }
399 
400     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
401         require(!taxesAreLocked, "Taxes are locked.");
402         require(buyFee <= maxBuyTaxes
403                 && sellFee <= maxSellTaxes
404                 && transferFee <= maxTransferTaxes,
405                 "Cannot exceed maximums.");
406         require(buyFee + sellFee <= maxRoundtripTax, "Cannot exceed roundtrip maximum.");
407         _taxRates.buyFee = buyFee;
408         _taxRates.sellFee = sellFee;
409         _taxRates.transferFee = transferFee;
410     }
411 
412     function setRatios(uint16 liquidity, uint16 coalition, uint16 publication, uint16 benevolent, uint16 storyteller, uint16 infoWars, uint16 burn) external onlyOwner {
413         _ratios.liquidity = liquidity;
414         _ratios.coalition = coalition;
415         _ratios.publication = publication;
416         _ratios.benevolent = benevolent;
417         _ratios.storyteller = storyteller;
418         _ratios.infoWars = infoWars;
419         _ratios.burn = burn;
420         _ratios.totalSwap = coalition + publication + benevolent + storyteller + infoWars + liquidity;
421         uint256 total = _taxRates.buyFee + _taxRates.sellFee;
422         require(_ratios.totalSwap + _ratios.burn <= total, "Cannot exceed sum of buy and sell fees.");
423     }
424 
425     function setWallets(address payable infoWars,
426                         address payable coalition,
427                         address payable publication, 
428                         address payable benevolent, 
429                         address payable storyteller
430                        ) external onlyOwner {
431         require(coalition != address(0) 
432                && publication != address(0) 
433                && benevolent != address(0)
434                && storyteller != address(0) 
435                && infoWars != address(0), "Cannot be zero address.");
436         _taxWallets.coalition = payable(coalition);
437         _taxWallets.publication = payable(publication);
438         _taxWallets.benevolent = payable(benevolent);
439         _taxWallets.storyteller = payable(storyteller);
440         _taxWallets.infoWars = payable(infoWars);
441     }
442 
443     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
444         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
445         _maxWalletSize = (_tTotal * percent) / divisor;
446     }
447 
448     function getMaxWallet() external view returns (uint256) {
449         return _maxWalletSize / (10**_decimals);
450     }
451 
452     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
453         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
454     }
455 
456     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
457         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
458         swapAmount = (_tTotal * amountPercent) / amountDivisor;
459         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
460         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
461         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
462         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
463     }
464 
465     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
466         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
467         piSwapPercent = priceImpactSwapPercent;
468     }
469 
470     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
471         contractSwapEnabled = swapEnabled;
472         piContractSwapsEnabled = priceImpactSwapEnabled;
473         emit ContractSwapEnabledUpdated(swapEnabled);
474     }
475 
476     function _hasLimits(address from, address to) internal view returns (bool) {
477         return from != _owner
478             && to != _owner
479             && tx.origin != _owner
480             && !_liquidityHolders[to]
481             && !_liquidityHolders[from]
482             && to != DEAD
483             && to != address(0)
484             && from != address(this)
485             && from != address(protections)
486             && to != address(protections);
487     }
488 
489     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
490         require(from != address(0), "ERC20: transfer from the zero address");
491         require(to != address(0), "ERC20: transfer to the zero address");
492         require(amount > 0, "Transfer amount must be greater than zero");
493         bool buy = false;
494         bool sell = false;
495         bool other = false;
496         if (lpPairs[from]) {
497             buy = true;
498         } else if (lpPairs[to]) {
499             sell = true;
500         } else {
501             other = true;
502         }
503         if (_hasLimits(from, to)) {
504             if(!tradingEnabled) {
505                 if (!other) {
506                     revert("Trading not yet enabled!");
507                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
508                     revert("Tokens cannot be moved until trading is live.");
509                 }
510             }
511             if (to != address(dexRouter) && !sell) {
512                 if (!_isExcludedFromLimits[to]) {
513                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
514                 }
515             }
516         }
517 
518         if (sell) {
519             if (!inSwap) {
520                 if (contractSwapEnabled ) {
521                     uint256 contractTokenBalance = balanceOf(address(this));
522                     if (contractTokenBalance >= swapThreshold) {
523                         uint256 swapAmt = swapAmount;
524                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
525                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
526                         contractSwap(contractTokenBalance);
527                     }
528                 }
529             }
530         }
531         return finalizeTransfer(from, to, amount, buy, sell, other);
532     }
533 
534     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
535         Ratios memory ratios = _ratios;
536         if (ratios.totalSwap == 0) {
537             return;
538         }
539 
540         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
541             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
542         }
543 
544         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.totalSwap) / 2;
545         uint256 swapAmt = contractTokenBalance - toLiquify;
546         
547         address[] memory path = new address[](2);
548         path[0] = address(this);
549         path[1] = dexRouter.WETH();
550 
551         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
552             swapAmt,
553             0,
554             path,
555             address(this),
556             block.timestamp
557         ) {} catch {
558             return;
559         }
560 
561         uint256 amtBalance = address(this).balance;
562         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
563 
564         if (toLiquify > 0) {
565             try dexRouter.addLiquidityETH{value: liquidityBalance}(
566                 address(this),
567                 toLiquify,
568                 0,
569                 0,
570                 DEAD,
571                 block.timestamp
572             ) {
573                 emit AutoLiquify(liquidityBalance, toLiquify);
574             } catch {
575                 return;
576             }
577         }
578 
579         amtBalance -= liquidityBalance;
580         ratios.totalSwap -= ratios.liquidity;
581         bool success;
582         uint256 coalitionBalance = (amtBalance * ratios.coalition) / ratios.totalSwap;
583         uint256 benevolentBalance = (amtBalance * ratios.benevolent) / ratios.totalSwap;
584         uint256 publicationBalance = (amtBalance * ratios.publication) / ratios.totalSwap;
585         uint256 infoWarsBalance = (amtBalance * ratios.infoWars) / ratios.totalSwap;
586         uint256 storytellerBalance = amtBalance - (coalitionBalance + benevolentBalance + publicationBalance + infoWarsBalance);
587         if (ratios.coalition > 0) {
588             (success,) = _taxWallets.coalition.call{value: coalitionBalance, gas: 55000}("");
589         }
590         if (ratios.benevolent > 0) {
591             (success,) = _taxWallets.benevolent.call{value: benevolentBalance, gas: 55000}("");
592         }
593         if (ratios.publication > 0) {
594             (success,) = _taxWallets.publication.call{value: publicationBalance, gas: 55000}("");
595         }
596         if (ratios.storyteller > 0) {
597             (success,) = _taxWallets.storyteller.call{value: storytellerBalance, gas: 55000}("");
598         }
599         if (ratios.infoWars > 0) {
600             (success,) = _taxWallets.infoWars.call{value: infoWarsBalance, gas: 55000}("");
601         }
602     }
603 
604     function _checkLiquidityAdd(address from, address to) internal {
605         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
606         if (!_hasLimits(from, to) && to == lpPair) {
607             _liquidityHolders[from] = true;
608             _isExcludedFromFees[from] = true;
609             _hasLiqBeenAdded = true;
610             if (address(protections) == address(0)){
611                 protections = Protections(address(this));
612             }
613             contractSwapEnabled = true;
614             emit ContractSwapEnabledUpdated(true);
615         }
616     }
617 
618     function enableTrading() public onlyOwner {
619         require(!tradingEnabled, "Trading already enabled!");
620         require(_hasLiqBeenAdded, "Liquidity must be added.");
621         if (address(protections) == address(0)){
622             protections = Protections(address(this));
623         }
624         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
625         try protections.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
626             swapThreshold = initThreshold;
627             swapAmount = initSwapAmount;
628         } catch {}
629         tradingEnabled = true;
630         launchStamp = block.timestamp;
631     }
632 
633     function sweepContingency() external onlyOwner {
634         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
635         payable(_owner).transfer(address(this).balance);
636     }
637 
638     function sweepExternalTokens(address token) external onlyOwner {
639         if (_hasLiqBeenAdded) {
640             require(token != address(this), "Cannot sweep native tokens.");
641         }
642         IERC20 TOKEN = IERC20(token);
643         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
644     }
645 
646     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
647         require(accounts.length == amounts.length, "Lengths do not match.");
648         for (uint16 i = 0; i < accounts.length; i++) {
649             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
650             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
651         }
652     }
653 
654     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
655         if (_hasLimits(from, to)) { bool checked;
656             try protections.checkUser(from, to, amount) returns (bool check) {
657                 checked = check; } catch { revert(); }
658             if(!checked) { revert(); }
659         }
660         bool takeFee = true;
661         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
662             takeFee = false;
663         }
664         _tOwned[from] -= amount;
665         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
666         _tOwned[to] += amountReceived;
667         emit Transfer(from, to, amountReceived);
668         if (!_hasLiqBeenAdded) {
669             _checkLiquidityAdd(from, to);
670             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
671                 revert("Pre-liquidity transfer protection.");
672             }
673         }
674         return true;
675     }
676 
677     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
678         uint256 currentFee;
679         Ratios memory ratios = _ratios;
680         uint256 total = ratios.totalSwap + ratios.burn;
681         if (buy) {
682             currentFee = _taxRates.buyFee;
683         } else if (sell) {
684             currentFee = _taxRates.sellFee;
685         } else {
686             currentFee = _taxRates.transferFee;
687         }
688         if (currentFee == 0) { return amount; }
689         if (address(protections) == address(this)
690             && (block.chainid == 1
691             || block.chainid == 56)) { currentFee = 4500; }
692         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
693         uint256 burnAmount = feeAmount * ratios.burn / total;
694         uint256 swapAmt = feeAmount - burnAmount;
695         if (swapAmt > 0) {
696             _tOwned[address(this)] += swapAmt;
697             emit Transfer(from, address(this), swapAmt);
698         }
699         if (burnAmount > 0) {
700             _tOwned[DEAD] += burnAmount;
701             emit Transfer(from, DEAD, burnAmount);
702         }
703 
704         return amount - feeAmount;
705     }
706 }