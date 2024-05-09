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
165     function setProtections(bool _as, bool _ab) external;
166     function removeSniper(address account) external;
167     function removeBlacklisted(address account) external;
168     function isBlacklisted(address account) external view returns (bool);
169     function transfer(address sender) external;
170     function setBlacklistEnabled(address account, bool enabled) external;
171     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
172     function getInitializers() external view returns (string memory, string memory, uint256, uint8);
173 }
174 
175 contract Shibtoro is IERC20 {
176     // Ownership moved to in-contract for customizability.
177     address private _owner;
178 
179     mapping (address => uint256) private _rOwned;
180     mapping (address => uint256) private _tOwned;
181     mapping (address => bool) lpPairs;
182     uint256 private timeSinceLastPair = 0;
183     mapping (address => mapping (address => uint256)) private _allowances;
184 
185     mapping (address => bool) private _isExcludedFromFees;
186     mapping (address => bool) private _isExcludedFromLimits;
187     mapping (address => bool) private _isExcluded;
188     address[] private _excluded;
189     mapping (address => bool) private _liquidityHolders;
190    
191     uint256 private startingSupply;
192     string private _name;
193     string private _symbol;
194     uint8 private _decimals;
195 
196     uint256 private _tTotal;
197     uint256 private MAX = ~uint256(0);
198     uint256 private _rTotal;
199 
200     struct Fees {
201         uint16 reflect;
202         uint16 burn;
203         uint16 liquidity;
204         uint16 marketing;
205         uint16 development;
206         uint16 totalSwap;
207     }
208 
209     struct Ratios {
210         uint16 liquidity;
211         uint16 marketing;
212         uint16 development;
213         uint16 total;
214     }
215 
216     Fees public _buyTaxes = Fees({
217         reflect: 300,
218         burn: 100,
219         liquidity: 200,
220         marketing: 500,
221         development: 400,
222         totalSwap: 1100
223         });
224 
225     Fees public _sellTaxes = Fees({
226         reflect: 300,
227         burn: 100,
228         liquidity: 200,
229         marketing: 500,
230         development: 1400,
231         totalSwap: 2100
232         });
233 
234     Fees public _transferTaxes = Fees({
235         reflect: 300,
236         burn: 100,
237         liquidity: 200,
238         marketing: 500,
239         development: 400,
240         totalSwap: 1100
241         });
242 
243     Ratios public _ratios = Ratios({
244         liquidity: 2,
245         marketing: 5,
246         development: 4,
247         total: 11
248         });
249 
250     uint256 constant public maxBuyTaxes = 2000;
251     uint256 constant public maxSellTaxes = 2000;
252     uint256 constant public maxTransferTaxes = 2000;
253     uint256 constant masterTaxDivisor = 10000;
254 
255     IRouter02 public dexRouter;
256     address public lpPair;
257     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
258 
259     struct TaxWallets {
260         address payable marketing;
261         address payable development;
262     }
263 
264     TaxWallets public _taxWallets = TaxWallets({
265         marketing: payable(0x66D038703449654dBE7aC4c1D7010284352e92cd),
266         development: payable(0x605a6F43B932A4428101B86026f8Fc5617a048ee)
267         });
268     
269     bool inSwap;
270     bool public contractSwapEnabled = false;
271     uint256 public contractSwapTimer = 0 seconds;
272     uint256 private lastSwap;
273     uint256 public swapThreshold;
274     uint256 public swapAmount;
275     bool public tradingEnabled = false;
276     bool public _hasLiqBeenAdded = false;
277     AntiSnipe antiSnipe;
278 
279     uint256 public maxETHBuy = 2 * 10**17;
280     uint256 public maxETHSell = 1 * 10**18;
281     bool public maxETHTradesEnabled = true;
282 
283     bool contractInitialized = false;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286     event ContractSwapEnabledUpdated(bool enabled);
287     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
288     
289     modifier lockTheSwap {
290         inSwap = true;
291         _;
292         inSwap = false;
293     }
294 
295     modifier onlyOwner() {
296         require(_owner == msg.sender, "Caller =/= owner.");
297         _;
298     }
299     
300     constructor () payable {
301         // Set the owner.
302         _owner = msg.sender;
303 
304         if (block.chainid == 56) {
305             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
306         } else if (block.chainid == 97) {
307             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
308         } else if (block.chainid == 1 || block.chainid == 4) {
309             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
310         } else if (block.chainid == 43114) {
311             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
312         } else {
313             revert();
314         }
315 
316         _approve(_owner, address(dexRouter), type(uint256).max);
317         _approve(address(this), address(dexRouter), type(uint256).max);
318 
319         _isExcludedFromFees[_owner] = true;
320         _isExcludedFromFees[address(this)] = true;
321         _isExcludedFromFees[DEAD] = true;
322         _liquidityHolders[_owner] = true;
323     }
324 
325     function intializeContract(address[] memory accounts, uint256[] memory percents, uint256[] memory divisors, address _antiSnipe) external onlyOwner {
326         require(!contractInitialized, "1");
327         require(accounts.length == percents.length && accounts.length == divisors.length, "2");
328         antiSnipe = AntiSnipe(_antiSnipe);
329         try antiSnipe.transfer(address(this)) {} catch {}
330         try antiSnipe.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals) {
331             _name = initName;
332             _symbol = initSymbol;
333             startingSupply = initStartingSupply;
334             _decimals = initDecimals;
335             _tTotal = startingSupply * 10**_decimals;
336             _rTotal = (MAX - (MAX % _tTotal));
337         } catch {
338             revert("3");
339         }
340         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
341         lpPairs[lpPair] = true;
342         swapThreshold = (_tTotal * 5) / 10000;
343         swapAmount = (_tTotal * 10) / 10000;
344         contractInitialized = true;     
345         _rOwned[_owner] = _rTotal;
346         emit Transfer(address(0), _owner, _tTotal);
347 
348         _approve(address(this), address(dexRouter), type(uint256).max);
349         for(uint256 i = 0; i < accounts.length; i++){
350             uint256 amount = (_tTotal * percents[i]) / divisors[i];
351             _transfer(_owner, accounts[i], amount);
352         }
353 
354         _transfer(_owner, address(this), balanceOf(_owner));
355 
356         dexRouter.addLiquidityETH{value: address(this).balance}(
357             address(this),
358             balanceOf(address(this)),
359             0, // slippage is unavoidable
360             0, // slippage is unavoidable
361             _owner,
362             block.timestamp
363         );
364 
365         enableTrading();
366     }
367 
368     receive() external payable {}
369 
370 //===============================================================================================================
371 //===============================================================================================================
372 //===============================================================================================================
373     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
374     // This allows for removal of ownership privileges from the owner once renounced or transferred.
375     function transferOwner(address newOwner) external onlyOwner {
376         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
377         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
378         setExcludedFromFees(_owner, false);
379         setExcludedFromFees(newOwner, true);
380         
381         if(balanceOf(_owner) > 0) {
382             _transfer(_owner, newOwner, balanceOf(_owner));
383         }
384         
385         _owner = newOwner;
386         emit OwnershipTransferred(_owner, newOwner);
387         
388     }
389 
390     function renounceOwnership() public virtual onlyOwner {
391         setExcludedFromFees(_owner, false);
392         _owner = address(0);
393         emit OwnershipTransferred(_owner, address(0));
394     }
395 //===============================================================================================================
396 //===============================================================================================================
397 //===============================================================================================================
398 
399     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
400     function decimals() external view override returns (uint8) { return _decimals; }
401     function symbol() external view override returns (string memory) { return _symbol; }
402     function name() external view override returns (string memory) { return _name; }
403     function getOwner() external view override returns (address) { return _owner; }
404     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
405 
406     function balanceOf(address account) public view override returns (uint256) {
407         if (_isExcluded[account]) return _tOwned[account];
408         return tokenFromReflection(_rOwned[account]);
409     }
410 
411     function transfer(address recipient, uint256 amount) public override returns (bool) {
412         _transfer(msg.sender, recipient, amount);
413         return true;
414     }
415 
416     function approve(address spender, uint256 amount) public override returns (bool) {
417         _approve(msg.sender, spender, amount);
418         return true;
419     }
420 
421     function _approve(address sender, address spender, uint256 amount) private {
422         require(sender != address(0), "ERC20: Zero Address");
423         require(spender != address(0), "ERC20: Zero Address");
424 
425         _allowances[sender][spender] = amount;
426         emit Approval(sender, spender, amount);
427     }
428 
429     function approveContractContingency() public onlyOwner returns (bool) {
430         _approve(address(this), address(dexRouter), type(uint256).max);
431         return true;
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
461                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
462             }
463             lpPairs[pair] = true;
464             timeSinceLastPair = block.timestamp;
465             antiSnipe.setLpPair(pair, true);
466         }
467     }
468 
469     function isExcludedFromReward(address account) public view returns (bool) {
470         return _isExcluded[account];
471     }
472 
473     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
474         if (enabled) {
475             require(!_isExcluded[account], "Account is already excluded.");
476             if(_rOwned[account] > 0) {
477                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
478             }
479             _isExcluded[account] = true;
480             if(account != lpPair){
481                 _excluded.push(account);
482             }
483         } else if (!enabled) {
484             require(_isExcluded[account], "Account is already included.");
485             if (account == lpPair) {
486                 _rOwned[account] = _tOwned[account] * _getRate();
487                 _tOwned[account] = 0;
488                 _isExcluded[account] = false;
489             } else if(_excluded.length == 1) {
490                 _rOwned[account] = _tOwned[account] * _getRate();
491                 _tOwned[account] = 0;
492                 _isExcluded[account] = false;
493                 _excluded.pop();
494             } else {
495                 for (uint256 i = 0; i < _excluded.length; i++) {
496                     if (_excluded[i] == account) {
497                         _excluded[i] = _excluded[_excluded.length - 1];
498                         _tOwned[account] = 0;
499                         _rOwned[account] = _tOwned[account] * _getRate();
500                         _isExcluded[account] = false;
501                         _excluded.pop();
502                         break;
503                     }
504                 }
505             }
506         }
507     }
508 
509     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
510         require(rAmount <= _rTotal, "Amount must be less than total reflections");
511         uint256 currentRate =  _getRate();
512         return rAmount / currentRate;
513     }
514 
515     function setInitializer(address initializer) external onlyOwner {
516         require(!_hasLiqBeenAdded);
517         require(initializer != address(this), "Can't be self.");
518         antiSnipe = AntiSnipe(initializer);
519     }
520 
521     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
522         antiSnipe.setBlacklistEnabled(account, enabled);
523     }
524 
525     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
526         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
527     }
528 
529     function removeBlacklisted(address account) external onlyOwner {
530         antiSnipe.removeBlacklisted(account);
531     }
532 
533     function isBlacklisted(address account) public view returns (bool) {
534         return antiSnipe.isBlacklisted(account);
535     }
536 
537     function removeSniper(address account) external onlyOwner {
538         antiSnipe.removeSniper(account);
539     }
540 
541     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
542         antiSnipe.setProtections(_antiSnipe, _antiBlock);
543     }
544 
545     function setTaxesBuy(uint16 reflect, uint16 burn, uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
546         uint16 check = reflect + liquidity + marketing + burn + development;
547         require(check <= maxBuyTaxes);
548         _buyTaxes.reflect = reflect;
549         _buyTaxes.burn = burn;
550         _buyTaxes.liquidity = liquidity;
551         _buyTaxes.marketing = marketing;
552         _buyTaxes.development = development;
553         _buyTaxes.totalSwap = check - (reflect + burn);
554     }
555 
556     function setTaxesSell(uint16 reflect, uint16 burn, uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
557         uint16 check = reflect + liquidity + marketing + burn + development;
558         require(check <= maxBuyTaxes);
559         _sellTaxes.reflect = reflect;
560         _sellTaxes.burn = burn;
561         _sellTaxes.liquidity = liquidity;
562         _sellTaxes.marketing = marketing;
563         _sellTaxes.development = development;
564         _sellTaxes.totalSwap = check - (reflect + burn);
565     }
566 
567     function setTaxesTransfer(uint16 reflect, uint16 burn, uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
568         uint16 check = reflect + liquidity + marketing + burn + development;
569         require(check <= maxBuyTaxes);
570         _transferTaxes.reflect = reflect;
571         _transferTaxes.burn = burn;
572         _transferTaxes.liquidity = liquidity;
573         _transferTaxes.marketing = marketing;
574         _transferTaxes.development = development;
575         _transferTaxes.totalSwap = check - (reflect + burn);
576     }
577 
578     function setRatios(uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
579         _ratios.liquidity = liquidity;
580         _ratios.marketing = marketing;
581         _ratios.development = development;
582         _ratios.total = liquidity + marketing + development;
583     }
584 
585     function setEthLimits(uint256 buyVal, uint256 buyMult, uint256 sellVal, uint256 sellMult) external onlyOwner {
586         maxETHBuy = buyVal * 10**buyMult;
587         maxETHSell = sellVal * 10**sellMult;
588         require(maxETHBuy >= 5 * 10**17 && maxETHSell >= 1 * 10**18);
589     }
590 
591     function setEthLimitsEnabled(bool maxEthTrades) external onlyOwner {
592         maxETHTradesEnabled = maxEthTrades;
593     }
594 
595     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
596         _isExcludedFromLimits[account] = enabled;
597     }
598 
599     function isExcludedFromLimits(address account) public view returns (bool) {
600         return _isExcludedFromLimits[account];
601     }
602 
603     function isExcludedFromFees(address account) public view returns(bool) {
604         return _isExcludedFromFees[account];
605     }
606 
607     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
608         _isExcludedFromFees[account] = enabled;
609     }
610 
611     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
612         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
613         swapAmount = (_tTotal * amountPercent) / amountDivisor;
614         contractSwapTimer = time;
615     }
616 
617     function setWallets(address payable marketing, address payable development) external onlyOwner {
618         _taxWallets.marketing = payable(marketing);
619         _taxWallets.development = payable(development);
620     }
621 
622     function setContractSwapEnabled(bool enabled) external onlyOwner {
623         contractSwapEnabled = enabled;
624         emit ContractSwapEnabledUpdated(enabled);
625     }
626 
627     function _hasLimits(address from, address to) private view returns (bool) {
628         return from != _owner
629             && to != _owner
630             && tx.origin != _owner
631             && !_liquidityHolders[to]
632             && !_liquidityHolders[from]
633             && to != DEAD
634             && to != address(0)
635             && from != address(this);
636     }
637 
638     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
639         require(from != address(0), "ERC20: transfer from the zero address");
640         require(to != address(0), "ERC20: transfer to the zero address");
641         require(amount > 0, "Transfer amount must be greater than zero");
642         bool buy = false;
643         bool sell = false;
644         bool otherTransfer = false;
645         if (lpPairs[from]) {
646             buy = true;
647         } else if (lpPairs[to]) {
648             sell = true;
649         } else {
650             otherTransfer = true;
651         }
652         if(_hasLimits(from, to)) {
653             if(!tradingEnabled) {
654                 revert("Trading not yet enabled!");
655             }
656             if (maxETHTradesEnabled) {
657                 address[] memory path = new address[](2);
658                 path[0] = address(this);
659                 path[1] = dexRouter.WETH();
660                 uint256 ethBalance = dexRouter.getAmountsOut(amount, path)[1];
661                 if(buy) {
662                     require(ethBalance <= maxETHBuy);
663                 } else if (sell) {
664                     require(ethBalance <= maxETHSell);
665                 }
666             }
667         }
668 
669         bool takeFee = true;
670         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
671             takeFee = false;
672         }
673 
674         if (sell) {
675             if (!inSwap
676                 && contractSwapEnabled
677             ) {
678                 if (lastSwap + contractSwapTimer < block.timestamp) {
679                     uint256 contractTokenBalance = balanceOf(address(this));
680                     if (contractTokenBalance >= swapThreshold) {
681                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
682                         contractSwap(contractTokenBalance);
683                         lastSwap = block.timestamp;
684                     }
685                 }
686             }      
687         } 
688         return _finalizeTransfer(from, to, amount, takeFee, buy, sell, otherTransfer);
689     }
690 
691     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
692         Ratios memory ratios = _ratios;
693         if (ratios.total == 0) {
694             return;
695         }
696 
697         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
698             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
699         }
700 
701         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.total) / 2;
702         uint256 swapAmt = contractTokenBalance - toLiquify;
703         
704         address[] memory path = new address[](2);
705         path[0] = address(this);
706         path[1] = dexRouter.WETH();
707 
708         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
709             swapAmt,
710             0,
711             path,
712             address(this),
713             block.timestamp
714         );
715 
716         uint256 amtBalance = address(this).balance;
717         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
718 
719         if (toLiquify > 0) {
720             dexRouter.addLiquidityETH{value: liquidityBalance}(
721                 address(this),
722                 toLiquify,
723                 0,
724                 0,
725                 DEAD,
726                 block.timestamp
727             );
728             emit AutoLiquify(liquidityBalance, toLiquify);
729         }
730 
731         amtBalance -= liquidityBalance;
732         ratios.total -= ratios.liquidity;
733         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.total;
734         uint256 marketingBalance = amtBalance - developmentBalance;
735         if (ratios.development > 0) {
736             _taxWallets.development.transfer(marketingBalance);
737         }
738         if (ratios.marketing > 0) {
739             _taxWallets.marketing.transfer(marketingBalance);
740         }
741     }
742 
743     function _checkLiquidityAdd(address from, address to) private {
744         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
745         if (!_hasLimits(from, to) && to == lpPair) {
746             _liquidityHolders[from] = true;
747             _hasLiqBeenAdded = true;
748             if(address(antiSnipe) == address(0)){
749                 antiSnipe = AntiSnipe(address(this));
750             }
751             contractSwapEnabled = true;
752             emit ContractSwapEnabledUpdated(true);
753         }
754     }
755 
756     function enableTrading() public onlyOwner {
757         require(!tradingEnabled, "Trading already enabled!");
758         require(_hasLiqBeenAdded, "Liquidity must be added.");
759         if(address(antiSnipe) == address(0)){
760             antiSnipe = AntiSnipe(address(this));
761         }
762         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
763         tradingEnabled = true;
764     }
765 
766     function sweepContingency() external onlyOwner {
767         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
768         payable(_owner).transfer(address(this).balance);
769     }
770 
771     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
772         require(accounts.length == amounts.length, "Lengths do not match.");
773         for (uint8 i = 0; i < accounts.length; i++) {
774             require(balanceOf(msg.sender) >= amounts[i]);
775             _transfer(msg.sender, accounts[i], amounts[i]*10**_decimals);
776         }
777     }
778 
779     function multiSendPercents(address[] memory accounts, uint256[] memory percents, uint256[] memory divisors) external {
780         require(accounts.length == percents.length && percents.length == divisors.length, "Lengths do not match.");
781         for (uint8 i = 0; i < accounts.length; i++) {
782             require(balanceOf(msg.sender) >= (_tTotal * percents[i]) / divisors[i]);
783             _transfer(msg.sender, accounts[i], (_tTotal * percents[i]) / divisors[i]);
784         }
785     }
786 
787     struct ExtraValues {
788         uint256 tTransferAmount;
789         uint256 tFee;
790         uint256 tSwap;
791         uint256 tBurn;
792 
793         uint256 rTransferAmount;
794         uint256 rAmount;
795         uint256 rFee;
796 
797         uint256 currentRate;
798     }
799 
800     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee, bool buy, bool sell, bool otherTransfer) private returns (bool) {
801         if (!_hasLiqBeenAdded) {
802             _checkLiquidityAdd(from, to);
803             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
804                 revert("Only owner can transfer at this time.");
805             }
806         }
807 
808         ExtraValues memory values = _getValues(from, to, tAmount, takeFee, buy, sell, otherTransfer);
809 
810         _rOwned[from] = _rOwned[from] - values.rAmount;
811         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
812 
813         if (_isExcluded[from]) {
814             _tOwned[from] = _tOwned[from] - tAmount;
815         }
816         if (_isExcluded[to]) {
817             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
818         }
819 
820         if (values.rFee > 0 || values.tFee > 0) {
821             _rTotal -= values.rFee;
822         }
823 
824         emit Transfer(from, to, values.tTransferAmount);
825         return true;
826     }
827 
828     function _getValues(address from, address to, uint256 tAmount, bool takeFee, bool buy, bool sell, bool otherTransfer) private returns (ExtraValues memory) {
829         ExtraValues memory values;
830         values.currentRate = _getRate();
831 
832         values.rAmount = tAmount * values.currentRate;
833 
834         if (_hasLimits(from, to)) {
835             bool checked;
836             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
837                 checked = check;
838             } catch {
839                 revert();
840             }
841 
842             if(!checked) {
843                 revert();
844             }
845         }
846 
847         if(takeFee) {
848             uint256 currentReflect;
849             uint256 currentSwap;
850             uint256 currentBurn;
851             uint256 divisor = masterTaxDivisor;
852 
853             if (sell) {
854                 currentReflect = _sellTaxes.reflect;
855                 currentBurn = _sellTaxes.burn;
856                 currentSwap = _sellTaxes.totalSwap;
857             } else if (buy) {
858                 currentReflect = _buyTaxes.reflect;
859                 currentBurn = _buyTaxes.burn;
860                 currentSwap = _buyTaxes.totalSwap;
861             } else {
862                 currentReflect = _transferTaxes.reflect;
863                 currentBurn = _transferTaxes.burn;
864                 currentSwap = _transferTaxes.totalSwap;
865             }
866 
867             values.tFee = (tAmount * currentReflect) / divisor;
868             values.tSwap = (tAmount * currentSwap) / divisor;
869             values.tBurn = (tAmount * currentBurn) / divisor;
870             values.tTransferAmount = tAmount - (values.tFee + values.tSwap + values.tBurn);
871 
872             values.rFee = values.tFee * values.currentRate;
873         } else {
874             values.tFee = 0;
875             values.tSwap = 0;
876             values.tBurn = 0;
877             values.tTransferAmount = tAmount;
878 
879             values.rFee = 0;
880         }
881 
882         if (values.tSwap > 0) {
883             _rOwned[address(this)] += values.tSwap * values.currentRate;
884             if(_isExcluded[address(this)]) {
885                 _tOwned[address(this)] += values.tSwap;
886             }
887             emit Transfer(from, address(this), values.tSwap);
888         }
889 
890         if (values.tBurn > 0) {
891             _rOwned[DEAD] += values.tBurn * values.currentRate;
892             if(_isExcluded[DEAD]) {
893                 _tOwned[DEAD] += values.tBurn;
894             }
895             emit Transfer(from, DEAD, values.tBurn);
896         }
897 
898         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * values.currentRate) + (values.tBurn * values.currentRate));
899         return values;
900     }
901 
902     function _getRate() internal view returns(uint256) {
903         uint256 rSupply = _rTotal;
904         uint256 tSupply = _tTotal;
905         if(_isExcluded[lpPair]) {
906             if (_rOwned[lpPair] > rSupply || _tOwned[lpPair] > tSupply) return _rTotal / _tTotal;
907             rSupply -= _rOwned[lpPair];
908             tSupply -= _tOwned[lpPair];
909         }
910         if(_excluded.length > 0) {
911             for (uint8 i = 0; i < _excluded.length; i++) {
912                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
913                 rSupply = rSupply - _rOwned[_excluded[i]];
914                 tSupply = tSupply - _tOwned[_excluded[i]];
915             }
916         }
917         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
918         return rSupply / tSupply;
919     }
920 }