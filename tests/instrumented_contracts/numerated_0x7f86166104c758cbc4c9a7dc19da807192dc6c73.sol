1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 /*
5 
6 
7 Telegram      https://t.me/nerd_token
8 Website       https://nerdtoken.xyz
9 
10 
11 */
12 
13 
14 interface IERC20 {
15   function totalSupply() external view returns (uint256);
16   function decimals() external view returns (uint8);
17   function symbol() external view returns (string memory);
18   function name() external view returns (string memory);
19   function getOwner() external view returns (address);
20   function balanceOf(address account) external view returns (uint256);
21   function transfer(address recipient, uint256 amount) external returns (bool);
22   function allowance(address _owner, address spender) external view returns (uint256);
23   function approve(address spender, uint256 amount) external returns (bool);
24   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 interface IFactoryV2 {
30     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
31     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
32     function createPair(address tokenA, address tokenB) external returns (address lpPair);
33 }
34 
35 interface IV2Pair {
36     function factory() external view returns (address);
37     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
38     function sync() external;
39 }
40 
41 interface IRouter01 {
42     function factory() external pure returns (address);
43     function WETH() external pure returns (address);
44     function addLiquidityETH(
45         address token,
46         uint amountTokenDesired,
47         uint amountTokenMin,
48         uint amountETHMin,
49         address to,
50         uint deadline
51     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
52     function addLiquidity(
53         address tokenA,
54         address tokenB,
55         uint amountADesired,
56         uint amountBDesired,
57         uint amountAMin,
58         uint amountBMin,
59         address to,
60         uint deadline
61     ) external returns (uint amountA, uint amountB, uint liquidity);
62     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
63     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
64 }
65 
66 interface IRouter02 is IRouter01 {
67     function swapExactTokensForETHSupportingFeeOnTransferTokens(
68         uint amountIn,
69         uint amountOutMin,
70         address[] calldata path,
71         address to,
72         uint deadline
73     ) external;
74     function swapExactETHForTokensSupportingFeeOnTransferTokens(
75         uint amountOutMin,
76         address[] calldata path,
77         address to,
78         uint deadline
79     ) external payable;
80     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
81         uint amountIn,
82         uint amountOutMin,
83         address[] calldata path,
84         address to,
85         uint deadline
86     ) external;
87     function swapExactTokensForTokens(
88         uint amountIn,
89         uint amountOutMin,
90         address[] calldata path,
91         address to,
92         uint deadline
93     ) external returns (uint[] memory amounts);
94 }
95 
96 interface AntiSnipe {
97     function checkUser(address from, address to, uint256 amt) external returns (bool);
98     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
99     function setLpPair(address pair, bool enabled) external;
100     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
101     function setGasPriceLimit(uint256 gas) external;
102     function removeSniper(address account) external;
103     function removeBlacklisted(address account) external;
104     function isBlacklisted(address account) external view returns (bool);
105     function setBlacklistEnabled(address account, bool enabled) external;
106     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
107 }
108 
109 contract NERD is IERC20 {
110     // Ownership moved to in-contract for customizability.
111     address private _owner;
112 
113     mapping (address => uint256) private _rOwned;
114     mapping (address => uint256) private _tOwned;
115     mapping (address => bool) lpPairs;
116     uint256 private timeSinceLastPair = 0;
117     mapping (address => mapping (address => uint256)) private _allowances;
118 
119     mapping (address => bool) private _isExcludedFromFees;
120     mapping (address => bool) private _isExcludedFromLimits;
121     mapping (address => bool) private _liquidityHolders;
122    
123     uint256 constant private startingSupply = 1_000_000_000;
124 
125     string constant private _name = "NERD";
126     string constant private _symbol = "NERD";
127     uint8 constant private _decimals = 18;
128 
129     uint256 constant private _tTotal = startingSupply * 10**_decimals;
130     uint256 constant private MAX = ~uint256(0);
131     uint256 private _rTotal = (MAX - (MAX % _tTotal));
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
143         uint16 total;
144     }
145 
146     Fees public _taxRates = Fees({
147         buyFee: 1000,
148         sellFee: 1500,
149         transferFee: 1000
150         });
151 
152     Ratios public _ratios = Ratios({
153         liquidity: 6,
154         marketing: 15,
155         development: 4,
156         total: 25
157         });
158 
159     uint256 constant public maxBuyTaxes = 2500;
160     uint256 constant public maxSellTaxes = 2500;
161     uint256 constant public maxTransferTaxes = 2500;
162     uint256 constant masterTaxDivisor = 10000;
163 
164     IRouter02 public dexRouter;
165     address public lpPair;
166     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
167 
168     struct TaxWallets {
169         address payable marketing;
170         address payable development;
171     }
172 
173     TaxWallets public _taxWallets = TaxWallets({
174         marketing: payable(0x71f70B247F26F18dCda672757F416D916d6C7f61),
175         development: payable(0x17Ba5701A9E387B86B794CFfDbA76B1cAdD86E66)
176         });
177     
178     bool inSwap;
179     bool public contractSwapEnabled = false;
180     uint256 public contractSwapTimer = 0 seconds;
181     uint256 private lastSwap;
182     uint256 public swapThreshold;
183     uint256 public swapAmount;
184 
185     uint256 private _maxTxAmount = (_tTotal * 25) / 10000;
186     uint256 private _maxWalletSize = (_tTotal * 75) / 10000;
187 
188     bool public tradingEnabled = false;
189     bool public _hasLiqBeenAdded = false;
190     AntiSnipe antiSnipe;
191 
192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193     event ContractSwapEnabledUpdated(bool enabled);
194     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
195     
196     modifier lockTheSwap {
197         inSwap = true;
198         _;
199         inSwap = false;
200     }
201 
202     modifier onlyOwner() {
203         require(_owner == msg.sender, "Caller =/= owner.");
204         _;
205     }
206     
207     constructor () payable {
208         _tOwned[msg.sender] = _tTotal;
209         emit Transfer(address(0), msg.sender, _tTotal);
210 
211         // Set the owner.
212         _owner = msg.sender;
213 
214         if (block.chainid == 56) {
215             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
216         } else if (block.chainid == 97) {
217             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
218         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
219             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
220         } else if (block.chainid == 43114) {
221             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
222         } else if (block.chainid == 250) {
223             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
224         } else {
225             revert();
226         }
227 
228         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
229         lpPairs[lpPair] = true;
230 
231         _approve(_owner, address(dexRouter), type(uint256).max);
232         _approve(address(this), address(dexRouter), type(uint256).max);
233 
234         _isExcludedFromFees[_owner] = true;
235         _isExcludedFromFees[address(this)] = true;
236         _isExcludedFromFees[DEAD] = true;
237         _liquidityHolders[_owner] = true;
238 
239         _finalizeTransfer(_owner, DEAD, _tTotal / 10, false, false, false, true);
240     }
241 
242     receive() external payable {}
243 
244 //===============================================================================================================
245 //===============================================================================================================
246 //===============================================================================================================
247     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
248     // This allows for removal of ownership privileges from the owner once renounced or transferred.
249     function transferOwner(address newOwner) external onlyOwner {
250         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
251         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
252         setExcludedFromFees(_owner, false);
253         setExcludedFromFees(newOwner, true);
254         
255         if(balanceOf(_owner) > 0) {
256             _transfer(_owner, newOwner, balanceOf(_owner));
257         }
258         
259         _owner = newOwner;
260         emit OwnershipTransferred(_owner, newOwner);
261         
262     }
263 
264     function renounceOwnership() public virtual onlyOwner {
265         setExcludedFromFees(_owner, false);
266         _owner = address(0);
267         emit OwnershipTransferred(_owner, address(0));
268     }
269 //===============================================================================================================
270 //===============================================================================================================
271 //===============================================================================================================
272 
273     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
274     function decimals() external pure override returns (uint8) { return _decimals; }
275     function symbol() external pure override returns (string memory) { return _symbol; }
276     function name() external pure override returns (string memory) { return _name; }
277     function getOwner() external view override returns (address) { return _owner; }
278     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
279 
280     function balanceOf(address account) public view override returns (uint256) {
281         return _tOwned[account];
282     }
283 
284     function transfer(address recipient, uint256 amount) public override returns (bool) {
285         _transfer(msg.sender, recipient, amount);
286         return true;
287     }
288 
289     function approve(address spender, uint256 amount) public override returns (bool) {
290         _approve(msg.sender, spender, amount);
291         return true;
292     }
293 
294     function _approve(address sender, address spender, uint256 amount) private {
295         require(sender != address(0), "ERC20: Zero Address");
296         require(spender != address(0), "ERC20: Zero Address");
297 
298         _allowances[sender][spender] = amount;
299         emit Approval(sender, spender, amount);
300     }
301 
302     function approveContractContingency() public onlyOwner returns (bool) {
303         _approve(address(this), address(dexRouter), type(uint256).max);
304         return true;
305     }
306 
307     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
308         if (_allowances[sender][msg.sender] != type(uint256).max) {
309             _allowances[sender][msg.sender] -= amount;
310         }
311 
312         return _transfer(sender, recipient, amount);
313     }
314 
315     function setNewRouter(address newRouter) public onlyOwner {
316         IRouter02 _newRouter = IRouter02(newRouter);
317         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
318         if (get_pair == address(0)) {
319             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
320         }
321         else {
322             lpPair = get_pair;
323         }
324         dexRouter = _newRouter;
325         _approve(address(this), address(dexRouter), type(uint256).max);
326     }
327 
328     function setLpPair(address pair, bool enabled) external onlyOwner {
329         if (enabled == false) {
330             lpPairs[pair] = false;
331             antiSnipe.setLpPair(pair, false);
332         } else {
333             if (timeSinceLastPair != 0) {
334                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
335             }
336             lpPairs[pair] = true;
337             timeSinceLastPair = block.timestamp;
338             antiSnipe.setLpPair(pair, true);
339         }
340     }
341 
342     function setInitializer(address initializer) external onlyOwner {
343         require(!_hasLiqBeenAdded);
344         require(initializer != address(this), "Can't be self.");
345         antiSnipe = AntiSnipe(initializer);
346     }
347 
348     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
349         antiSnipe.setBlacklistEnabled(account, enabled);
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
360     function removeSniper(address account) external onlyOwner {
361         antiSnipe.removeSniper(account);
362     }
363 
364     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
365         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
366     }
367 
368     function setGasPriceLimit(uint256 gas) external onlyOwner {
369         require(gas >= 300, "Too low.");
370         antiSnipe.setGasPriceLimit(gas);
371     }
372 
373     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
374         require(buyFee <= maxBuyTaxes
375                 && sellFee <= maxSellTaxes
376                 && transferFee <= maxTransferTaxes,
377                 "Cannot exceed maximums.");
378         _taxRates.buyFee = buyFee;
379         _taxRates.sellFee = sellFee;
380         _taxRates.transferFee = transferFee;
381     }
382 
383     function setRatios(uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
384         _ratios.liquidity = liquidity;
385         _ratios.marketing = marketing;
386         _ratios.development = development;
387         _ratios.total = liquidity + marketing + development;
388     }
389 
390     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
391         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
392         _maxTxAmount = (_tTotal * percent) / divisor;
393     }
394 
395     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
396         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
397         _maxWalletSize = (_tTotal * percent) / divisor;
398     }
399 
400     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
401         _isExcludedFromLimits[account] = enabled;
402     }
403 
404     function isExcludedFromLimits(address account) public view returns (bool) {
405         return _isExcludedFromLimits[account];
406     }
407 
408     function isExcludedFromFees(address account) public view returns(bool) {
409         return _isExcludedFromFees[account];
410     }
411 
412     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
413         _isExcludedFromFees[account] = enabled;
414     }
415 
416     function getMaxTX() public view returns (uint256) {
417         return _maxTxAmount / (10**_decimals);
418     }
419 
420     function getMaxWallet() public view returns (uint256) {
421         return _maxWalletSize / (10**_decimals);
422     }
423 
424     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
425         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
426         swapAmount = (_tTotal * amountPercent) / amountDivisor;
427         contractSwapTimer = time;
428     }
429 
430     function setWallets(address payable development, address payable marketing) external onlyOwner {
431         _taxWallets.development = payable(development);
432         _taxWallets.marketing = payable(marketing);
433     }
434 
435     function setContractSwapEnabled(bool enabled) external onlyOwner {
436         contractSwapEnabled = enabled;
437         emit ContractSwapEnabledUpdated(enabled);
438     }
439 
440     function _hasLimits(address from, address to) private view returns (bool) {
441         return from != _owner
442             && to != _owner
443             && tx.origin != _owner
444             && !_liquidityHolders[to]
445             && !_liquidityHolders[from]
446             && to != DEAD
447             && to != address(0)
448             && from != address(this);
449     }
450 
451     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
452         require(from != address(0), "ERC20: transfer from the zero address");
453         require(to != address(0), "ERC20: transfer to the zero address");
454         require(amount > 0, "Transfer amount must be greater than zero");
455         bool buy = false;
456         bool sell = false;
457         bool other = false;
458         if (lpPairs[from]) {
459             buy = true;
460         } else if (lpPairs[to]) {
461             sell = true;
462         } else {
463             other = true;
464         }
465         if(_hasLimits(from, to)) {
466             if(!tradingEnabled) {
467                 revert("Trading not yet enabled!");
468             }
469             if(buy || sell){
470                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
471                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
472                 }
473             }
474             if(to != address(dexRouter) && !sell) {
475                 if (!_isExcludedFromLimits[to]) {
476                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
477                 }
478             }
479         }
480 
481         bool takeFee = true;
482         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
483             takeFee = false;
484         }
485 
486         if (sell) {
487             if (!inSwap
488                 && contractSwapEnabled
489             ) {
490                 if (lastSwap + contractSwapTimer < block.timestamp) {
491                     uint256 contractTokenBalance = balanceOf(address(this));
492                     if (contractTokenBalance >= swapThreshold) {
493                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
494                         contractSwap(contractTokenBalance);
495                         lastSwap = block.timestamp;
496                     }
497                 }
498             }      
499         } 
500         return _finalizeTransfer(from, to, amount, takeFee, buy, sell, other);
501     }
502 
503     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
504         Ratios memory ratios = _ratios;
505         if (ratios.total == 0) {
506             return;
507         }
508 
509         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
510             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
511         }
512 
513         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.total) / 2;
514         uint256 swapAmt = contractTokenBalance - toLiquify;
515         
516         address[] memory path = new address[](2);
517         path[0] = address(this);
518         path[1] = dexRouter.WETH();
519 
520         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
521             swapAmt,
522             0,
523             path,
524             address(this),
525             block.timestamp
526         );
527 
528         uint256 amtBalance = address(this).balance;
529         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
530 
531         if (toLiquify > 0) {
532             dexRouter.addLiquidityETH{value: liquidityBalance}(
533                 address(this),
534                 toLiquify,
535                 0,
536                 0,
537                 DEAD,
538                 block.timestamp
539             );
540             emit AutoLiquify(liquidityBalance, toLiquify);
541         }
542 
543         amtBalance -= liquidityBalance;
544         ratios.total -= ratios.liquidity;
545         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.total;
546         uint256 marketingBalance = amtBalance - developmentBalance;
547         if (ratios.development > 0) {
548             _taxWallets.development.transfer(developmentBalance);
549         }
550         if (ratios.marketing > 0) {
551             _taxWallets.marketing.transfer(marketingBalance);
552         }
553     }
554 
555     function _checkLiquidityAdd(address from, address to) private {
556         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
557         if (!_hasLimits(from, to) && to == lpPair) {
558             _liquidityHolders[from] = true;
559             _hasLiqBeenAdded = true;
560             if(address(antiSnipe) == address(0)){
561                 antiSnipe = AntiSnipe(address(this));
562             }
563             contractSwapEnabled = true;
564             emit ContractSwapEnabledUpdated(true);
565         }
566     }
567 
568     function enableTrading() public onlyOwner {
569         require(!tradingEnabled, "Trading already enabled!");
570         require(_hasLiqBeenAdded, "Liquidity must be added.");
571         if(address(antiSnipe) == address(0)){
572             antiSnipe = AntiSnipe(address(this));
573         }
574         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
575         tradingEnabled = true;
576         swapThreshold = (balanceOf(lpPair)) / 1000;
577         swapAmount = (balanceOf(lpPair) * 2) / 1000;
578     }
579 
580     function sweepContingency() external onlyOwner {
581         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
582         payable(_owner).transfer(address(this).balance);
583     }
584 
585     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
586         require(accounts.length == amounts.length, "Lengths do not match.");
587         for (uint8 i = 0; i < accounts.length; i++) {
588             require(balanceOf(msg.sender) >= amounts[i]);
589             _finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, false, true);
590         }
591     }
592 
593     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee, bool buy, bool sell, bool other) private returns (bool) {
594         if (!_hasLiqBeenAdded) {
595             _checkLiquidityAdd(from, to);
596             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
597                 revert("Only owner can transfer at this time.");
598             }
599         }
600 
601         if (_hasLimits(from, to)) {
602             bool checked;
603             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
604                 checked = check;
605             } catch {
606                 revert();
607             }
608 
609             if(!checked) {
610                 revert();
611             }
612         }
613 
614         _tOwned[from] -= amount;
615         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
616         _tOwned[to] += amountReceived;
617 
618         emit Transfer(from, to, amountReceived);
619         return true;
620     }
621 
622     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
623         uint256 currentFee;
624         if (buy) {
625             currentFee = _taxRates.buyFee;
626         } else if (sell) {
627             currentFee = _taxRates.sellFee;
628         } else {
629             currentFee = _taxRates.transferFee;
630         }
631 
632         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
633 
634         _tOwned[address(this)] += feeAmount;
635         emit Transfer(from, address(this), feeAmount);
636 
637         return amount - feeAmount;
638     }
639 }