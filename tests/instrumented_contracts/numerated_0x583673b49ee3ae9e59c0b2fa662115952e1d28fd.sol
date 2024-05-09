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
90     function setProtections(bool _as, bool _ab) external;
91     function setGasPriceLimit(uint256 gas) external;
92     function removeSniper(address account) external;
93     function isBlacklisted(address account) external view returns (bool);
94     function transfer(address sender) external;
95     function setBlacklistEnabled(address account, bool enabled) external;
96     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
97     function getInitializers() external view returns (string memory, string memory, uint256, uint8);
98 }
99 
100 contract Mintstarter is IERC20 {
101     // Ownership moved to in-contract for customizability.
102     address private _owner;
103     mapping (address => uint256) private _tOwned;
104     mapping (address => bool) lpPairs;
105     uint256 private timeSinceLastPair = 0;
106     mapping (address => mapping (address => uint256)) private _allowances;
107 
108     mapping (address => bool) private _isExcludedFromFees;
109     mapping (address => bool) private _isExcludedFromLimits;
110     mapping (address => bool) private _liquidityHolders;
111    
112     uint256 constant private startingSupply = 100_000_000;
113 
114     string constant private _name = "Mintstarter";
115     string constant private _symbol = "MINT";
116     uint8 constant private _decimals = 18;
117 
118     uint256 constant private _tTotal = startingSupply * 10**_decimals;
119 
120     struct Fees {
121         uint16 buyFee;
122         uint16 sellFee;
123         uint16 transferFee;
124     }
125 
126     struct Ratios {
127         uint16 tokens;
128         uint16 swap;
129         uint16 total;
130     }
131 
132     Fees public _taxRates = Fees({
133         buyFee: 600,
134         sellFee: 1200,
135         transferFee: 600
136         });
137 
138     Ratios public _ratios = Ratios({
139         tokens: 3,
140         swap: 15,
141         total: 18
142         });
143 
144     uint256 constant public maxBuyTaxes = 2000;
145     uint256 constant public maxSellTaxes = 2000;
146     uint256 constant public maxTransferTaxes = 2000;
147     uint256 constant masterTaxDivisor = 10000;
148 
149     IRouter02 public dexRouter;
150     address public lpPair;
151     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
152 
153     struct TaxWallets {
154         address tokens;
155         address payable swap;
156     }
157 
158     TaxWallets public _taxWallets = TaxWallets({
159         tokens: 0xd380308038AE8184Daae37b4BbC5A59608FE9F63,
160         swap: payable(0xd380308038AE8184Daae37b4BbC5A59608FE9F63)
161         });
162     
163     bool inSwap;
164     bool public contractSwapEnabled = false;
165     uint256 public contractSwapTimer = 0 seconds;
166     uint256 private lastSwap;
167     uint256 public swapThreshold;
168     uint256 public swapAmount;
169     
170     uint256 private _maxTxAmount = _tTotal;
171     uint256 private _maxWalletSize = _tTotal;
172 
173     bool public tradingEnabled = false;
174     bool public _hasLiqBeenAdded = false;
175     AntiSnipe antiSnipe;
176 
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178     event ContractSwapEnabledUpdated(bool enabled);
179     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
180     
181     modifier lockTheSwap {
182         inSwap = true;
183         _;
184         inSwap = false;
185     }
186 
187     modifier onlyOwner() {
188         require(_owner == msg.sender, "Caller =/= owner.");
189         _;
190     }
191     
192     constructor () payable {
193         _tOwned[msg.sender] = _tTotal;
194         emit Transfer(address(0), msg.sender, _tTotal);
195 
196         // Set the owner.
197         _owner = msg.sender;
198 
199         if (block.chainid == 56) {
200             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
201         } else if (block.chainid == 97) {
202             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
203         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
204             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
205         } else if (block.chainid == 43114) {
206             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
207         } else if (block.chainid == 250) {
208             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
209         } else {
210             revert();
211         }
212 
213         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
214         lpPairs[lpPair] = true;
215 
216         _approve(_owner, address(dexRouter), type(uint256).max);
217         _approve(address(this), address(dexRouter), type(uint256).max);
218 
219         _isExcludedFromFees[_owner] = true;
220         _isExcludedFromFees[address(this)] = true;
221         _isExcludedFromFees[DEAD] = true;
222         _liquidityHolders[_owner] = true;
223     }
224 
225     receive() external payable {}
226 
227 //===============================================================================================================
228 //===============================================================================================================
229 //===============================================================================================================
230     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
231     // This allows for removal of ownership privileges from the owner once renounced or transferred.
232     function transferOwner(address newOwner) external onlyOwner {
233         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
234         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
235         setExcludedFromFees(_owner, false);
236         setExcludedFromFees(newOwner, true);
237         
238         if(balanceOf(_owner) > 0) {
239             _transfer(_owner, newOwner, balanceOf(_owner));
240         }
241         
242         _owner = newOwner;
243         emit OwnershipTransferred(_owner, newOwner);
244         
245     }
246 
247     function renounceOwnership() public virtual onlyOwner {
248         setExcludedFromFees(_owner, false);
249         _owner = address(0);
250         emit OwnershipTransferred(_owner, address(0));
251     }
252 //===============================================================================================================
253 //===============================================================================================================
254 //===============================================================================================================
255 
256     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
257     function decimals() external pure override returns (uint8) { return _decimals; }
258     function symbol() external pure override returns (string memory) { return _symbol; }
259     function name() external pure override returns (string memory) { return _name; }
260     function getOwner() external view override returns (address) { return _owner; }
261     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
262 
263     function balanceOf(address account) public view override returns (uint256) {
264         return _tOwned[account];
265     }
266 
267     function transfer(address recipient, uint256 amount) public override returns (bool) {
268         _transfer(msg.sender, recipient, amount);
269         return true;
270     }
271 
272     function approve(address spender, uint256 amount) public override returns (bool) {
273         _approve(msg.sender, spender, amount);
274         return true;
275     }
276 
277     function _approve(address sender, address spender, uint256 amount) internal {
278         require(sender != address(0), "ERC20: Zero Address");
279         require(spender != address(0), "ERC20: Zero Address");
280 
281         _allowances[sender][spender] = amount;
282         emit Approval(sender, spender, amount);
283     }
284 
285     function approveContractContingency() public onlyOwner returns (bool) {
286         _approve(address(this), address(dexRouter), type(uint256).max);
287         return true;
288     }
289 
290     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
291         if (_allowances[sender][msg.sender] != type(uint256).max) {
292             _allowances[sender][msg.sender] -= amount;
293         }
294 
295         return _transfer(sender, recipient, amount);
296     }
297 
298     function setNewRouter(address newRouter) public onlyOwner {
299         IRouter02 _newRouter = IRouter02(newRouter);
300         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
301         if (get_pair == address(0)) {
302             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
303         }
304         else {
305             lpPair = get_pair;
306         }
307         dexRouter = _newRouter;
308         _approve(address(this), address(dexRouter), type(uint256).max);
309     }
310 
311     function setLpPair(address pair, bool enabled) external onlyOwner {
312         if (enabled == false) {
313             lpPairs[pair] = false;
314             antiSnipe.setLpPair(pair, false);
315         } else {
316             if (timeSinceLastPair != 0) {
317                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
318             }
319             lpPairs[pair] = true;
320             timeSinceLastPair = block.timestamp;
321             antiSnipe.setLpPair(pair, true);
322         }
323     }
324 
325     function setInitializer(address initializer) external onlyOwner {
326         require(!_hasLiqBeenAdded);
327         require(initializer != address(this), "Can't be self.");
328         antiSnipe = AntiSnipe(initializer);
329     }
330 
331     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
332         antiSnipe.setBlacklistEnabled(account, enabled);
333     }
334 
335     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
336         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
337     }
338 
339     function isBlacklisted(address account) public view returns (bool) {
340         return antiSnipe.isBlacklisted(account);
341     }
342 
343     function removeSniper(address account) external onlyOwner {
344         antiSnipe.removeSniper(account);
345     }
346 
347     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
348         antiSnipe.setProtections(_antiSnipe, _antiBlock);
349     }
350 
351     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
352         require(buyFee <= maxBuyTaxes
353                 && sellFee <= maxSellTaxes
354                 && transferFee <= maxTransferTaxes,
355                 "Cannot exceed maximums.");
356         _taxRates.buyFee = buyFee;
357         _taxRates.sellFee = sellFee;
358         _taxRates.transferFee = transferFee;
359     }
360     
361     function setRatios(uint16 tokens, uint16 swap) external onlyOwner {
362         _ratios.tokens = tokens;
363         _ratios.swap = swap;
364         _ratios.total = tokens + swap;
365     }
366 
367     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
368         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
369         _maxTxAmount = (_tTotal * percent) / divisor;
370     }
371 
372     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
373         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
374         _maxWalletSize = (_tTotal * percent) / divisor;
375     }
376 
377     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
378         _isExcludedFromLimits[account] = enabled;
379     }
380 
381     function isExcludedFromLimits(address account) public view returns (bool) {
382         return _isExcludedFromLimits[account];
383     }
384 
385     function isExcludedFromFees(address account) public view returns(bool) {
386         return _isExcludedFromFees[account];
387     }
388 
389     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
390         _isExcludedFromFees[account] = enabled;
391     }
392 
393     function getMaxTX() public view returns (uint256) {
394         return _maxTxAmount / (10**_decimals);
395     }
396 
397     function getMaxWallet() public view returns (uint256) {
398         return _maxWalletSize / (10**_decimals);
399     }
400 
401     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
402         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
403         swapAmount = (_tTotal * amountPercent) / amountDivisor;
404         contractSwapTimer = time;
405     }
406 
407     function setWallets(address tokens, address payable swap) external onlyOwner {
408         _taxWallets.tokens = tokens;
409         _taxWallets.swap = payable(swap);
410     }
411 
412     function setContractSwapEnabled(bool enabled) external onlyOwner {
413         contractSwapEnabled = enabled;
414         emit ContractSwapEnabledUpdated(enabled);
415     }
416 
417     function _hasLimits(address from, address to) internal view returns (bool) {
418         return from != _owner
419             && to != _owner
420             && tx.origin != _owner
421             && !_liquidityHolders[to]
422             && !_liquidityHolders[from]
423             && to != DEAD
424             && to != address(0)
425             && from != address(this);
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
442         if(_hasLimits(from, to)) {
443             if(!tradingEnabled) {
444                 revert("Trading not yet enabled!");
445             }
446             if(buy || sell){
447                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
448                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
449                 }
450             }
451             if(to != address(dexRouter) && !sell) {
452                 if (!_isExcludedFromLimits[to]) {
453                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
454                 }
455             }
456         }
457 
458         bool takeFee = true;
459         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
460             takeFee = false;
461         }
462 
463         if (sell) {
464             if (!inSwap
465                 && contractSwapEnabled
466             ) {
467                 if (lastSwap + contractSwapTimer < block.timestamp) {
468                     uint256 contractTokenBalance = balanceOf(address(this));
469                     if (contractTokenBalance >= swapThreshold) {
470                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
471                         contractSwap(contractTokenBalance);
472                         lastSwap = block.timestamp;
473                     }
474                 }
475             }      
476         } 
477         return _finalizeTransfer(from, to, amount, takeFee, buy, sell, other);
478     }
479 
480     function contractSwap(uint256 contractTokenBalance) internal lockTheSwap {
481         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
482             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
483         }
484 
485         if (_ratios.swap == 0) {
486             return;
487         }
488 
489         address[] memory path = new address[](2);
490         path[0] = address(this);
491         path[1] = dexRouter.WETH();
492 
493         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
494             contractTokenBalance,
495             0,
496             path,
497             _taxWallets.swap,
498             block.timestamp
499         );
500     }
501 
502     function _checkLiquidityAdd(address from, address to) internal {
503         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
504         if (!_hasLimits(from, to) && to == lpPair) {
505             _liquidityHolders[from] = true;
506             _hasLiqBeenAdded = true;
507             if(address(antiSnipe) == address(0)){
508                 antiSnipe = AntiSnipe(address(this));
509             }
510             contractSwapEnabled = true;
511             emit ContractSwapEnabledUpdated(true);
512         }
513     }
514 
515     function enableTrading() public onlyOwner {
516         require(!tradingEnabled, "Trading already enabled!");
517         require(_hasLiqBeenAdded, "Liquidity must be added.");
518         if(address(antiSnipe) == address(0)){
519             antiSnipe = AntiSnipe(address(this));
520         }
521         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
522         tradingEnabled = true;
523         swapThreshold = (balanceOf(lpPair) * 5) / 10000;
524         swapAmount = (balanceOf(lpPair) * 1) / 1000;
525     }
526 
527     function sweepContingency() external onlyOwner {
528         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
529         payable(_owner).transfer(address(this).balance);
530     }
531 
532     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
533         require(accounts.length == amounts.length, "Lengths do not match.");
534         for (uint8 i = 0; i < accounts.length; i++) {
535             require(balanceOf(msg.sender) >= amounts[i]);
536             _finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, false, true);
537         }
538     }
539 
540     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee, bool buy, bool sell, bool other) internal returns (bool) {
541         if (!_hasLiqBeenAdded) {
542             _checkLiquidityAdd(from, to);
543             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
544                 revert("Only owner can transfer at this time.");
545             }
546         }
547 
548         if (_hasLimits(from, to)) {
549             bool checked;
550             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
551                 checked = check;
552             } catch {
553                 revert();
554             }
555 
556             if(!checked) {
557                 revert();
558             }
559         }
560 
561         _tOwned[from] -= amount;
562         uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
563         _tOwned[to] += amountReceived;
564 
565         emit Transfer(from, to, amountReceived);
566         return true;
567     }
568 
569     function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
570         uint256 currentFee;
571         if (buy) {
572             currentFee = _taxRates.buyFee;
573         } else if (sell) {
574             currentFee = _taxRates.sellFee;
575         } else {
576             currentFee = _taxRates.transferFee;
577         }
578 
579         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
580         uint256 tokenAmount = (feeAmount * _ratios.tokens) / (_ratios.total);
581         if (tokenAmount > 0) {
582             feeAmount -= tokenAmount;
583             address destination = _taxWallets.tokens;
584             _tOwned[destination] += tokenAmount;
585             emit Transfer(from, destination, tokenAmount);
586         }
587         _tOwned[address(this)] += feeAmount;
588         emit Transfer(from, address(this), feeAmount);
589 
590         return amount - (feeAmount + tokenAmount);
591     }
592 }