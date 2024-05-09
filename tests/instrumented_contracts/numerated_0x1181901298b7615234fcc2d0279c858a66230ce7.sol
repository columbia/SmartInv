1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 interface IERC20 {
5   /**
6    * @dev Returns the amount of tokens in existence.
7    */
8   function totalSupply() external view returns (uint256);
9 
10   /**
11    * @dev Returns the token decimals.
12    */
13   function decimals() external view returns (uint8);
14 
15   /**
16    * @dev Returns the token symbol.
17    */
18   function symbol() external view returns (string memory);
19 
20   /**
21   * @dev Returns the token name.
22   */
23   function name() external view returns (string memory);
24 
25   /**
26    * @dev Returns the bep token owner.
27    */
28   function getOwner() external view returns (address);
29 
30   /**
31    * @dev Returns the amount of tokens owned by `account`.
32    */
33   function balanceOf(address account) external view returns (uint256);
34 
35   /**
36    * @dev Moves `amount` tokens from the caller's account to `recipient`.
37    *
38    * Returns a boolean value indicating whether the operation succeeded.
39    *
40    * Emits a {Transfer} event.
41    */
42   function transfer(address recipient, uint256 amount) external returns (bool);
43 
44   /**
45    * @dev Returns the remaining number of tokens that `spender` will be
46    * allowed to spend on behalf of `owner` through {transferFrom}. This is
47    * zero by default.
48    *
49    * This value changes when {approve} or {transferFrom} are called.
50    */
51   function allowance(address _owner, address spender) external view returns (uint256);
52 
53   /**
54    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55    *
56    * Returns a boolean value indicating whether the operation succeeded.
57    *
58    * IMPORTANT: Beware that changing an allowance with this method brings the risk
59    * that someone may use both the old and the new allowance by unfortunate
60    * transaction ordering. One possible solution to mitigate this race
61    * condition is to first reduce the spender's allowance to 0 and set the
62    * desired value afterwards:
63    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64    *
65    * Emits an {Approval} event.
66    */
67   function approve(address spender, uint256 amount) external returns (bool);
68 
69   /**
70    * @dev Moves `amount` tokens from `sender` to `recipient` using the
71    * allowance mechanism. `amount` is then deducted from the caller's
72    * allowance.
73    *
74    * Returns a boolean value indicating whether the operation succeeded.
75    *
76    * Emits a {Transfer} event.
77    */
78   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80   /**
81    * @dev Emitted when `value` tokens are moved from one account (`from`) to
82    * another (`to`).
83    *
84    * Note that `value` may be zero.
85    */
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 
88   /**
89    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90    * a call to {approve}. `value` is the new allowance.
91    */
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 interface IFactoryV2 {
96     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
97     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
98     function createPair(address tokenA, address tokenB) external returns (address lpPair);
99 }
100 
101 interface IV2Pair {
102     function factory() external view returns (address);
103     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
104 }
105 
106 interface IRouter01 {
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117     function addLiquidity(
118         address tokenA,
119         address tokenB,
120         uint amountADesired,
121         uint amountBDesired,
122         uint amountAMin,
123         uint amountBMin,
124         address to,
125         uint deadline
126     ) external returns (uint amountA, uint amountB, uint liquidity);
127     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
128     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
129 }
130 
131 interface IRouter02 is IRouter01 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139     function swapExactETHForTokensSupportingFeeOnTransferTokens(
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external payable;
145     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external;
152     function swapExactTokensForTokens(
153         uint amountIn,
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external returns (uint[] memory amounts);
159 }
160 
161 interface AntiSnipe {
162     function checkUser(address from, address to, uint256 amt) external returns (bool);
163     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
164     function setLpPair(address pair, bool enabled) external;
165     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
166     function setGasPriceLimit(uint256 gas) external;
167     function removeSniper(address account) external;
168     function removeBlacklisted(address account) external;
169     function isBlacklisted(address account) external view returns (bool);
170     function getMarketCap(address token) external view returns (uint256);
171     function transfer(address sender) external;
172     function setBlacklistEnabled(address account, bool enabled) external;
173     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
174 }
175 
176 contract MorieINU is IERC20 {
177     // Ownership moved to in-contract for customizability.
178     address private _owner;
179 
180     mapping (address => uint256) private _rOwned;
181     mapping (address => uint256) private _tOwned;
182     mapping (address => bool) lpPairs;
183     uint256 private timeSinceLastPair = 0;
184     mapping (address => mapping (address => uint256)) private _allowances;
185 
186     mapping (address => bool) private _isExcludedFromFees;
187     mapping (address => bool) private _isExcludedFromLimits;
188     mapping (address => bool) private _isExcluded;
189     address[] private _excluded;
190     mapping (address => bool) private _liquidityHolders;
191    
192     uint256 constant private startingSupply = 10_000_000_000;
193 
194     string constant private _name = "Morie INU";
195     string constant private _symbol = "MORIE";
196     uint8 constant private _decimals = 18;
197 
198     uint256 constant private _tTotal = startingSupply * 10**_decimals;
199     uint256 constant private MAX = ~uint256(0);
200     uint256 private _rTotal = (MAX - (MAX % _tTotal));
201 
202     struct Fees {
203         uint16 reflect;
204         uint16 burn;
205         uint16 liquidity;
206         uint16 marketing;
207         uint16 totalSwap;
208     }
209 
210     struct Ratios {
211         uint16 liquidity;
212         uint16 marketing;
213         uint16 total;
214     }
215 
216     Fees public _buyTaxes = Fees({
217         reflect: 100,
218         burn: 100,
219         liquidity: 300,
220         marketing: 600,
221         totalSwap: 900
222         });
223 
224     Fees public _sellTaxes = Fees({
225         reflect: 300,
226         burn: 300,
227         liquidity: 700,
228         marketing: 1200,
229         totalSwap: 1900
230         });
231 
232     Fees public _transferTaxes = Fees({
233         reflect: 100,
234         burn: 100,
235         liquidity: 300,
236         marketing: 600,
237         totalSwap: 900
238         });
239 
240     Ratios public _ratios = Ratios({
241         liquidity: 3,
242         marketing: 6,
243         total: 9
244         });
245 
246     uint256 constant public maxBuyTaxes = 2000;
247     uint256 constant public maxSellTaxes = 2000;
248     uint256 constant public maxTransferTaxes = 2000;
249     uint256 constant masterTaxDivisor = 10000;
250 
251     IRouter02 public dexRouter;
252     address public lpPair;
253     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
254 
255     struct TaxWallets {
256         address payable marketing;
257     }
258 
259     TaxWallets public _taxWallets = TaxWallets({
260         marketing: payable(0x322dAA81C8e3aC8775d676755DE41b670864a9c5)
261         });
262     
263     bool inSwap;
264     bool public contractSwapEnabled = false;
265     uint256 public contractSwapTimer = 0 seconds;
266     uint256 private lastSwap;
267     uint256 public swapThreshold = (_tTotal * 3) / 10000;
268     uint256 public swapAmount = (_tTotal * 5) / 10000;
269     
270     uint256 private _maxTxAmount = (_tTotal * 2) / 1000;
271     uint256 private _maxWalletSize = (_tTotal * 4) / 1000;
272 
273     bool public tradingEnabled = false;
274     bool public _hasLiqBeenAdded = false;
275     AntiSnipe antiSnipe;
276 
277     bool lpInitialized = false;
278 
279     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
280     event ContractSwapEnabledUpdated(bool enabled);
281     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
282     
283     modifier lockTheSwap {
284         inSwap = true;
285         _;
286         inSwap = false;
287     }
288 
289     modifier onlyOwner() {
290         require(_owner == msg.sender, "Caller =/= owner.");
291         _;
292     }
293     
294     constructor () payable {
295         _rOwned[msg.sender] = _rTotal;
296 
297         // Set the owner.
298         _owner = msg.sender;
299 
300         if (block.chainid == 56) {
301             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
302         } else if (block.chainid == 97) {
303             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
304         } else if (block.chainid == 1 || block.chainid == 4) {
305             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         } else if (block.chainid == 43114) {
307             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
308         } else {
309             revert();
310         }
311 
312         emit Transfer(address(0), msg.sender, _tTotal);
313     }
314 
315     function initializeLP() public onlyOwner {
316         require(!lpInitialized, "Already initialized");
317 
318         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
319         lpPairs[lpPair] = true;
320 
321         _approve(_owner, address(dexRouter), type(uint256).max);
322         _approve(address(this), address(dexRouter), type(uint256).max);
323 
324         _isExcludedFromFees[_owner] = true;
325         _isExcludedFromFees[address(this)] = true;
326         _isExcludedFromFees[DEAD] = true;
327         _liquidityHolders[_owner] = true;
328 
329         lpInitialized = true;
330     }
331 
332     receive() external payable {}
333 
334 //===============================================================================================================
335 //===============================================================================================================
336 //===============================================================================================================
337     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
338     // This allows for removal of ownership privileges from the owner once renounced or transferred.
339     function transferOwner(address newOwner) external onlyOwner {
340         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
341         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
342         setExcludedFromFees(_owner, false);
343         setExcludedFromFees(newOwner, true);
344         
345         if(balanceOf(_owner) > 0) {
346             _transfer(_owner, newOwner, balanceOf(_owner));
347         }
348         
349         _owner = newOwner;
350         emit OwnershipTransferred(_owner, newOwner);
351         
352     }
353 
354     function renounceOwnership() public virtual onlyOwner {
355         setExcludedFromFees(_owner, false);
356         _owner = address(0);
357         emit OwnershipTransferred(_owner, address(0));
358     }
359 //===============================================================================================================
360 //===============================================================================================================
361 //===============================================================================================================
362 
363     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
364     function decimals() external pure override returns (uint8) { return _decimals; }
365     function symbol() external pure override returns (string memory) { return _symbol; }
366     function name() external pure override returns (string memory) { return _name; }
367     function getOwner() external view override returns (address) { return _owner; }
368     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
369 
370     function balanceOf(address account) public view override returns (uint256) {
371         if (_isExcluded[account]) return _tOwned[account];
372         return tokenFromReflection(_rOwned[account]);
373     }
374 
375     function transfer(address recipient, uint256 amount) public override returns (bool) {
376         _transfer(msg.sender, recipient, amount);
377         return true;
378     }
379 
380     function approve(address spender, uint256 amount) public override returns (bool) {
381         _approve(msg.sender, spender, amount);
382         return true;
383     }
384 
385     function _approve(address sender, address spender, uint256 amount) private {
386         require(sender != address(0), "ERC20: Zero Address");
387         require(spender != address(0), "ERC20: Zero Address");
388 
389         _allowances[sender][spender] = amount;
390         emit Approval(sender, spender, amount);
391     }
392 
393     function approveContractContingency() public onlyOwner returns (bool) {
394         _approve(address(this), address(dexRouter), type(uint256).max);
395         return true;
396     }
397 
398     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
399         if (_allowances[sender][msg.sender] != type(uint256).max) {
400             _allowances[sender][msg.sender] -= amount;
401         }
402 
403         return _transfer(sender, recipient, amount);
404     }
405 
406     function setNewRouter(address newRouter) public onlyOwner {
407         IRouter02 _newRouter = IRouter02(newRouter);
408         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
409         if (get_pair == address(0)) {
410             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
411         }
412         else {
413             lpPair = get_pair;
414         }
415         dexRouter = _newRouter;
416         _approve(address(this), address(dexRouter), type(uint256).max);
417     }
418 
419     function setLpPair(address pair, bool enabled) external onlyOwner {
420         if (enabled == false) {
421             lpPairs[pair] = false;
422             antiSnipe.setLpPair(pair, false);
423         } else {
424             if (timeSinceLastPair != 0) {
425                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
426             }
427             lpPairs[pair] = true;
428             timeSinceLastPair = block.timestamp;
429             antiSnipe.setLpPair(pair, true);
430         }
431     }
432 
433     function getCirculatingSupply() public view returns (uint256) {
434         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
435     }
436 
437     function isExcludedFromReward(address account) public view returns (bool) {
438         return _isExcluded[account];
439     }
440 
441     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
442         if (enabled) {
443             require(!_isExcluded[account], "Account is already excluded.");
444             if(_rOwned[account] > 0) {
445                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
446             }
447             _isExcluded[account] = true;
448             if(account != lpPair){
449                 _excluded.push(account);
450             }
451         } else if (!enabled) {
452             require(_isExcluded[account], "Account is already included.");
453             if (account == lpPair) {
454                 _rOwned[account] = _tOwned[account] * _getRate();
455                 _tOwned[account] = 0;
456                 _isExcluded[account] = false;
457             } else if(_excluded.length == 1) {
458                 _rOwned[account] = _tOwned[account] * _getRate();
459                 _tOwned[account] = 0;
460                 _isExcluded[account] = false;
461                 _excluded.pop();
462             } else {
463                 for (uint256 i = 0; i < _excluded.length; i++) {
464                     if (_excluded[i] == account) {
465                         _excluded[i] = _excluded[_excluded.length - 1];
466                         _tOwned[account] = 0;
467                         _rOwned[account] = _tOwned[account] * _getRate();
468                         _isExcluded[account] = false;
469                         _excluded.pop();
470                         break;
471                     }
472                 }
473             }
474         }
475     }
476 
477     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
478         require(rAmount <= _rTotal, "Amount must be less than total reflections");
479         uint256 currentRate =  _getRate();
480         return rAmount / currentRate;
481     }
482 
483     function setInitializer(address initializer) external onlyOwner {
484         require(!_hasLiqBeenAdded);
485         require(initializer != address(this), "Can't be self.");
486         antiSnipe = AntiSnipe(initializer);
487     }
488 
489     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
490         antiSnipe.setBlacklistEnabled(account, enabled);
491     }
492 
493     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
494         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
495     }
496 
497     function removeBlacklisted(address account) external onlyOwner {
498         antiSnipe.removeBlacklisted(account);
499     }
500 
501     function isBlacklisted(address account) public view returns (bool) {
502         return antiSnipe.isBlacklisted(account);
503     }
504 
505     function removeSniper(address account) external onlyOwner {
506         antiSnipe.removeSniper(account);
507     }
508 
509     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
510         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
511     }
512 
513     function setGasPriceLimit(uint256 gas) external onlyOwner {
514         require(gas >= 75, "Too low.");
515         antiSnipe.setGasPriceLimit(gas);
516     }
517     
518     function setTaxesBuy(uint16 reflect, uint16 burn, uint16 liquidity, uint16 marketing) external onlyOwner {
519         uint16 check = reflect + liquidity + marketing + burn;
520         require(check <= maxBuyTaxes);
521         _buyTaxes.reflect = reflect;
522         _buyTaxes.burn = burn;
523         _buyTaxes.liquidity = liquidity;
524         _buyTaxes.marketing = marketing;
525         _buyTaxes.totalSwap = check - (reflect + burn);
526     }
527 
528     function setTaxesSell(uint16 reflect, uint16 burn, uint16 liquidity, uint16 marketing) external onlyOwner {
529         uint16 check = reflect + liquidity + marketing + burn;
530         require(check <= maxBuyTaxes);
531         _sellTaxes.reflect = reflect;
532         _sellTaxes.burn = burn;
533         _sellTaxes.liquidity = liquidity;
534         _sellTaxes.marketing = marketing;
535         _sellTaxes.totalSwap = check - (reflect + burn);
536     }
537 
538     function setTaxesTransfer(uint16 reflect, uint16 burn, uint16 liquidity, uint16 marketing) external onlyOwner {
539         uint16 check = reflect + liquidity + marketing + burn;
540         require(check <= maxBuyTaxes);
541         _transferTaxes.reflect = reflect;
542         _transferTaxes.burn = burn;
543         _transferTaxes.liquidity = liquidity;
544         _transferTaxes.marketing = marketing;
545         _transferTaxes.totalSwap = check - (reflect + burn);
546     }
547 
548     function setRatios(uint16 liquidity, uint16 marketing) external onlyOwner {
549         _ratios.liquidity = liquidity;
550         _ratios.marketing = marketing;
551         _ratios.total = liquidity + marketing;
552     }
553 
554     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
555         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
556         _maxTxAmount = (_tTotal * percent) / divisor;
557     }
558 
559     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
560         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
561         _maxWalletSize = (_tTotal * percent) / divisor;
562     }
563 
564     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
565         _isExcludedFromLimits[account] = enabled;
566     }
567 
568     function isExcludedFromLimits(address account) public view returns (bool) {
569         return _isExcludedFromLimits[account];
570     }
571 
572     function isExcludedFromFees(address account) public view returns(bool) {
573         return _isExcludedFromFees[account];
574     }
575 
576     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
577         _isExcludedFromFees[account] = enabled;
578     }
579 
580     function getMaxTX() public view returns (uint256) {
581         return _maxTxAmount / (10**_decimals);
582     }
583 
584     function getMaxWallet() public view returns (uint256) {
585         return _maxWalletSize / (10**_decimals);
586     }
587 
588     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
589         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
590         swapAmount = (_tTotal * amountPercent) / amountDivisor;
591         contractSwapTimer = time;
592     }
593 
594     function setWallets(address payable marketing) external onlyOwner {
595         _taxWallets.marketing = payable(marketing);
596     }
597 
598     function setContractSwapEnabled(bool enabled) external onlyOwner {
599         contractSwapEnabled = enabled;
600         emit ContractSwapEnabledUpdated(enabled);
601     }
602 
603     function _hasLimits(address from, address to) private view returns (bool) {
604         return from != _owner
605             && to != _owner
606             && tx.origin != _owner
607             && !_liquidityHolders[to]
608             && !_liquidityHolders[from]
609             && to != DEAD
610             && to != address(0)
611             && from != address(this);
612     }
613 
614     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
615         require(from != address(0), "ERC20: transfer from the zero address");
616         require(to != address(0), "ERC20: transfer to the zero address");
617         require(amount > 0, "Transfer amount must be greater than zero");
618         require(lpInitialized);
619 
620         if(_hasLimits(from, to)) {
621             if(!tradingEnabled) {
622                 revert("Trading not yet enabled!");
623             }
624             if(lpPairs[from] || lpPairs[to]){
625                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
626                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
627                 }
628             }
629             if(to != address(dexRouter) && !lpPairs[to]) {
630                 if (!_isExcludedFromLimits[to]) {
631                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
632                 }
633             }
634         }
635 
636         bool takeFee = true;
637         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
638             takeFee = false;
639         }
640 
641         if (lpPairs[to]) {
642             if (!inSwap
643                 && contractSwapEnabled
644             ) {
645                 if (lastSwap + contractSwapTimer < block.timestamp) {
646                     uint256 contractTokenBalance = balanceOf(address(this));
647                     if (contractTokenBalance >= swapThreshold) {
648                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
649                         contractSwap(contractTokenBalance);
650                         lastSwap = block.timestamp;
651                     }
652                 }
653             }      
654         } 
655         return _finalizeTransfer(from, to, amount, takeFee);
656     }
657 
658     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
659         Ratios memory ratios = _ratios;
660         if (ratios.total == 0) {
661             return;
662         }
663 
664         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
665             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
666         }
667 
668         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.total) / 2;
669         uint256 swapAmt = contractTokenBalance - toLiquify;
670         
671         address[] memory path = new address[](2);
672         path[0] = address(this);
673         path[1] = dexRouter.WETH();
674 
675         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
676             swapAmt,
677             0,
678             path,
679             address(this),
680             block.timestamp
681         );
682 
683         uint256 amtBalance = address(this).balance;
684         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
685 
686         if (toLiquify > 0) {
687             dexRouter.addLiquidityETH{value: liquidityBalance}(
688                 address(this),
689                 toLiquify,
690                 0,
691                 0,
692                 DEAD,
693                 block.timestamp
694             );
695             emit AutoLiquify(liquidityBalance, toLiquify);
696         }
697 
698         amtBalance -= liquidityBalance;
699         ratios.total -= ratios.liquidity;
700         uint256 marketingBalance = amtBalance;
701         if (ratios.marketing > 0) {
702             _taxWallets.marketing.transfer(marketingBalance);
703         }
704     }
705 
706     function _checkLiquidityAdd(address from, address to) private {
707         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
708         if (!_hasLimits(from, to) && to == lpPair) {
709             _liquidityHolders[from] = true;
710             _hasLiqBeenAdded = true;
711             if(address(antiSnipe) == address(0)){
712                 antiSnipe = AntiSnipe(address(this));
713             }
714             contractSwapEnabled = true;
715             emit ContractSwapEnabledUpdated(true);
716         }
717     }
718 
719     function enableTrading() public onlyOwner {
720         require(!tradingEnabled, "Trading already enabled!");
721         require(_hasLiqBeenAdded, "Liquidity must be added.");
722         if(address(antiSnipe) == address(0)){
723             antiSnipe = AntiSnipe(address(this));
724         }
725         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
726         tradingEnabled = true;
727     }
728 
729     function sweepContingency() external onlyOwner {
730         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
731         payable(_owner).transfer(address(this).balance);
732     }
733 
734     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
735         require(accounts.length == amounts.length, "Lengths do not match.");
736         for (uint8 i = 0; i < accounts.length; i++) {
737             require(balanceOf(msg.sender) >= amounts[i]);
738             _transfer(msg.sender, accounts[i], amounts[i]*10**_decimals);
739         }
740     }
741 
742     struct ExtraValues {
743         uint256 tTransferAmount;
744         uint256 tFee;
745         uint256 tSwap;
746         uint256 tBurn;
747 
748         uint256 rTransferAmount;
749         uint256 rAmount;
750         uint256 rFee;
751 
752         uint256 currentRate;
753     }
754 
755     function preInitializeTransfer(address to, uint256 amount) public onlyOwner {
756         require(!lpInitialized);
757         amount = amount*10**_decimals;
758         _finalizeTransfer(msg.sender, to, amount, false);
759     }
760 
761     function preInitializeTransferMultiple(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
762         require(accounts.length == amounts.length, "Lengths do not match.");
763         for (uint8 i = 0; i < accounts.length; i++) {
764             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals);
765             preInitializeTransfer(accounts[i], amounts[i]);
766         }
767     }
768 
769     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
770         if (!_hasLiqBeenAdded) {
771             _checkLiquidityAdd(from, to);
772             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
773                 revert("Only owner can transfer at this time.");
774             }
775         }
776 
777         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
778 
779         _rOwned[from] = _rOwned[from] - values.rAmount;
780         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
781 
782         if (_isExcluded[from]) {
783             _tOwned[from] = _tOwned[from] - tAmount;
784         }
785         if (_isExcluded[to]) {
786             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
787         }
788 
789         if (values.rFee > 0 || values.tFee > 0) {
790             _rTotal -= values.rFee;
791         }
792 
793         emit Transfer(from, to, values.tTransferAmount);
794         return true;
795     }
796 
797     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
798         ExtraValues memory values;
799         values.currentRate = _getRate();
800 
801         values.rAmount = tAmount * values.currentRate;
802 
803         if (_hasLimits(from, to)) {
804             bool checked;
805             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
806                 checked = check;
807             } catch {
808                 revert();
809             }
810 
811             if(!checked) {
812                 revert();
813             }
814         }
815 
816         if(takeFee) {
817             uint256 currentReflect;
818             uint256 currentSwap;
819             uint256 currentBurn;
820             uint256 divisor = masterTaxDivisor;
821 
822             if (lpPairs[to]) {
823                 currentReflect = _sellTaxes.reflect;
824                 currentBurn = _sellTaxes.burn;
825                 currentSwap = _sellTaxes.totalSwap;
826             } else if (lpPairs[from]) {
827                 currentReflect = _buyTaxes.reflect;
828                 currentBurn = _buyTaxes.burn;
829                 currentSwap = _buyTaxes.totalSwap;
830             } else {
831                 currentReflect = _transferTaxes.reflect;
832                 currentBurn = _transferTaxes.burn;
833                 currentSwap = _transferTaxes.totalSwap;
834             }
835 
836             values.tFee = (tAmount * currentReflect) / divisor;
837             values.tSwap = (tAmount * currentSwap) / divisor;
838             values.tBurn = (tAmount * currentBurn) / divisor;
839             values.tTransferAmount = tAmount - (values.tFee + values.tSwap + values.tBurn);
840 
841             values.rFee = values.tFee * values.currentRate;
842         } else {
843             values.tFee = 0;
844             values.tSwap = 0;
845             values.tBurn = 0;
846             values.tTransferAmount = tAmount;
847 
848             values.rFee = 0;
849         }
850 
851         if (values.tSwap > 0) {
852             _rOwned[address(this)] += values.tSwap * values.currentRate;
853             if(_isExcluded[address(this)]) {
854                 _tOwned[address(this)] += values.tSwap;
855             }
856             emit Transfer(from, address(this), values.tSwap);
857         }
858 
859         if (values.tBurn > 0) {
860             _rOwned[DEAD] += values.tBurn * values.currentRate;
861             if(_isExcluded[DEAD]) {
862                 _tOwned[DEAD] += values.tBurn;
863             }
864             emit Transfer(from, DEAD, values.tBurn);
865         }
866 
867         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * values.currentRate) + (values.tBurn * values.currentRate));
868         return values;
869     }
870 
871     function _getRate() internal view returns(uint256) {
872         uint256 rSupply = _rTotal;
873         uint256 tSupply = _tTotal;
874         if(_isExcluded[lpPair]) {
875             if (_rOwned[lpPair] > rSupply || _tOwned[lpPair] > tSupply) return _rTotal / _tTotal;
876             rSupply -= _rOwned[lpPair];
877             tSupply -= _tOwned[lpPair];
878         }
879         if(_excluded.length > 0) {
880             for (uint8 i = 0; i < _excluded.length; i++) {
881                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
882                 rSupply = rSupply - _rOwned[_excluded[i]];
883                 tSupply = tSupply - _tOwned[_excluded[i]];
884             }
885         }
886         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
887         return rSupply / tSupply;
888     }
889 }