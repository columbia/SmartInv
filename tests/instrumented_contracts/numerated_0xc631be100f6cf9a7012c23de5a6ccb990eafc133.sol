1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16   /**
17    * @dev Returns the amount of tokens in existence.
18    */
19   function totalSupply() external view returns (uint256);
20 
21   /**
22    * @dev Returns the token decimals.
23    */
24   function decimals() external view returns (uint8);
25 
26   /**
27    * @dev Returns the token symbol.
28    */
29   function symbol() external view returns (string memory);
30 
31   /**
32   * @dev Returns the token name.
33   */
34   function name() external view returns (string memory);
35 
36   /**
37    * @dev Returns the bep token owner.
38    */
39   function getOwner() external view returns (address);
40 
41   /**
42    * @dev Returns the amount of tokens owned by `account`.
43    */
44   function balanceOf(address account) external view returns (uint256);
45 
46   /**
47    * @dev Moves `amount` tokens from the caller's account to `recipient`.
48    *
49    * Returns a boolean value indicating whether the operation succeeded.
50    *
51    * Emits a {Transfer} event.
52    */
53   function transfer(address recipient, uint256 amount) external returns (bool);
54 
55   /**
56    * @dev Returns the remaining number of tokens that `spender` will be
57    * allowed to spend on behalf of `owner` through {transferFrom}. This is
58    * zero by default.
59    *
60    * This value changes when {approve} or {transferFrom} are called.
61    */
62   function allowance(address _owner, address spender) external view returns (uint256);
63 
64   /**
65    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66    *
67    * Returns a boolean value indicating whether the operation succeeded.
68    *
69    * IMPORTANT: Beware that changing an allowance with this method brings the risk
70    * that someone may use both the old and the new allowance by unfortunate
71    * transaction ordering. One possible solution to mitigate this race
72    * condition is to first reduce the spender's allowance to 0 and set the
73    * desired value afterwards:
74    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75    *
76    * Emits an {Approval} event.
77    */
78   function approve(address spender, uint256 amount) external returns (bool);
79 
80   /**
81    * @dev Moves `amount` tokens from `sender` to `recipient` using the
82    * allowance mechanism. `amount` is then deducted from the caller's
83    * allowance.
84    *
85    * Returns a boolean value indicating whether the operation succeeded.
86    *
87    * Emits a {Transfer} event.
88    */
89   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91   /**
92    * @dev Emitted when `value` tokens are moved from one account (`from`) to
93    * another (`to`).
94    *
95    * Note that `value` may be zero.
96    */
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 
99   /**
100    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101    * a call to {approve}. `value` is the new allowance.
102    */
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 interface IFactoryV2 {
107     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
108     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
109     function createPair(address tokenA, address tokenB) external returns (address lpPair);
110 }
111 
112 interface IV2Pair {
113     function factory() external view returns (address);
114     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
115 }
116 
117 interface IRouter01 {
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128     function addLiquidity(
129         address tokenA,
130         address tokenB,
131         uint amountADesired,
132         uint amountBDesired,
133         uint amountAMin,
134         uint amountBMin,
135         address to,
136         uint deadline
137     ) external returns (uint amountA, uint amountB, uint liquidity);
138     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
139     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
140 }
141 
142 interface IRouter02 is IRouter01 {
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150     function swapExactETHForTokensSupportingFeeOnTransferTokens(
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external payable;
156     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163     function swapExactTokensForTokens(
164         uint amountIn,
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external returns (uint[] memory amounts);
170 }
171 
172 interface AntiSnipe {
173     function checkUser(address from, address to, uint256 amt) external returns (bool);
174     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
175     function setLpPair(address pair, bool enabled) external;
176     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
177     function setGasPriceLimit(uint256 gas) external;
178     function removeSniper(address account) external;
179     function getSniperAmt() external view returns (uint256);
180     function removeBlacklisted(address account) external;
181     function isBlacklisted(address account) external view returns (bool);
182 }
183 
184 contract BananaTaskForceApe is Context, IERC20 {
185     // Ownership moved to in-contract for customizability.
186     address private _owner;
187 
188     mapping (address => uint256) private _tOwned;
189     mapping (address => bool) lpPairs;
190     uint256 private timeSinceLastPair = 0;
191     mapping (address => mapping (address => uint256)) private _allowances;
192 
193     mapping (address => bool) private _isExcludedFromFees;
194     mapping (address => bool) private _isExcludedFromLimits;
195     mapping (address => bool) private presaleAddresses;
196     bool private allowedPresaleExclusion = true;
197     mapping (address => bool) private _liquidityHolders;
198    
199     uint256 constant private startingSupply = 1_000_000_000_000;
200 
201     string constant private _name = "Banana Task Force Ape";
202     string constant private _symbol = "BTFA";
203     uint8 constant private _decimals = 9;
204 
205     uint256 constant private _tTotal = startingSupply * 10**_decimals;
206 
207     struct Fees {
208         uint16 buyFee;
209         uint16 sellFee;
210         uint16 transferFee;
211     }
212 
213     struct Ratios {
214         uint16 liquidity;
215         uint16 marketing;
216         uint16 total;
217     }
218 
219     Fees public _taxRates = Fees({
220         buyFee: 1000,
221         sellFee: 1400,
222         transferFee: 0
223         });
224 
225     Ratios public _ratios = Ratios({
226         liquidity: 2,
227         marketing: 5,
228         total: 7
229         });
230 
231     uint256 constant public maxBuyTaxes = 2000;
232     uint256 constant public maxSellTaxes = 2000;
233     uint256 constant public maxTransferTaxes = 2000;
234     uint256 constant masterTaxDivisor = 10000;
235 
236     IRouter02 public dexRouter;
237     address public lpPair;
238     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
239 
240     struct TaxWallets {
241         address payable marketing;
242     }
243 
244     TaxWallets public _taxWallets = TaxWallets({
245         marketing: payable(0x1764041440eD4081Ae361EC9c2245Eb33F023F60)
246         });
247     
248     bool inSwap;
249     bool public contractSwapEnabled = false;
250     uint256 public contractSwapTimer = 10 seconds;
251     uint256 private lastSwap;
252     uint256 public swapThreshold = (_tTotal * 5) / 10000;
253     uint256 public swapAmount = (_tTotal * 20) / 10000;
254     
255     uint256 private _maxTxAmount = (_tTotal * 100) / 100;
256     uint256 private _maxWalletSize = (_tTotal * 100) / 100;
257 
258     bool public tradingEnabled = false;
259     bool public _hasLiqBeenAdded = false;
260     AntiSnipe antiSnipe;
261 
262     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
263     event ContractSwapEnabledUpdated(bool enabled);
264     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
265     
266     modifier lockTheSwap {
267         inSwap = true;
268         _;
269         inSwap = false;
270     }
271 
272     modifier onlyOwner() {
273         require(_owner == _msgSender(), "Caller =/= owner.");
274         _;
275     }
276     
277     constructor () payable {
278         _tOwned[msg.sender] = _tTotal;
279 
280         // Set the owner.
281         _owner = msg.sender;
282 
283         if (block.chainid == 56) {
284             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
285             contractSwapTimer = 3 seconds;
286         } else if (block.chainid == 97) {
287             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
288             contractSwapTimer = 3 seconds;
289         } else if (block.chainid == 1 || block.chainid == 4) {
290             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
291             contractSwapTimer = 10 seconds;
292         } else {
293             revert();
294         }
295 
296         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
297         lpPairs[lpPair] = true;
298 
299         _approve(msg.sender, address(dexRouter), type(uint256).max);
300         _approve(address(this), address(dexRouter), type(uint256).max);
301 
302         _isExcludedFromFees[owner()] = true;
303         _isExcludedFromFees[address(this)] = true;
304         _isExcludedFromFees[DEAD] = true;
305         _liquidityHolders[owner()] = true;
306 
307         emit Transfer(address(0), _msgSender(), _tTotal);
308     }
309 
310     receive() external payable {}
311 
312 //===============================================================================================================
313 //===============================================================================================================
314 //===============================================================================================================
315     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
316     // This allows for removal of ownership privileges from the owner once renounced or transferred.
317     function owner() public view returns (address) {
318         return _owner;
319     }
320 
321     function transferOwner(address newOwner) external onlyOwner() {
322         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
323         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
324         setExcludedFromFees(_owner, false);
325         setExcludedFromFees(newOwner, true);
326         
327         if(balanceOf(_owner) > 0) {
328             _transfer(_owner, newOwner, balanceOf(_owner));
329         }
330         
331         _owner = newOwner;
332         emit OwnershipTransferred(_owner, newOwner);
333         
334     }
335 
336     function renounceOwnership() public virtual onlyOwner() {
337         setExcludedFromFees(_owner, false);
338         _owner = address(0);
339         emit OwnershipTransferred(_owner, address(0));
340     }
341 //===============================================================================================================
342 //===============================================================================================================
343 //===============================================================================================================
344 
345     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
346     function decimals() external pure override returns (uint8) { return _decimals; }
347     function symbol() external pure override returns (string memory) { return _symbol; }
348     function name() external pure override returns (string memory) { return _name; }
349     function getOwner() external view override returns (address) { return owner(); }
350     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
351 
352     function balanceOf(address account) public view override returns (uint256) {
353         return _tOwned[account];
354     }
355 
356     function transfer(address recipient, uint256 amount) public override returns (bool) {
357         _transfer(_msgSender(), recipient, amount);
358         return true;
359     }
360 
361     function approve(address spender, uint256 amount) public override returns (bool) {
362         _approve(_msgSender(), spender, amount);
363         return true;
364     }
365 
366     function _approve(address sender, address spender, uint256 amount) private {
367         require(sender != address(0), "ERC20: Zero Address");
368         require(spender != address(0), "ERC20: Zero Address");
369 
370         _allowances[sender][spender] = amount;
371         emit Approval(sender, spender, amount);
372     }
373 
374     function approveContractContingency() public onlyOwner returns (bool) {
375         _approve(address(this), address(dexRouter), type(uint256).max);
376         return true;
377     }
378 
379     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
380         if (_allowances[sender][msg.sender] != type(uint256).max) {
381             _allowances[sender][msg.sender] -= amount;
382         }
383 
384         return _transfer(sender, recipient, amount);
385     }
386 
387     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
389         return true;
390     }
391 
392     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
393         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
394         return true;
395     }
396 
397     function setNewRouter(address newRouter) public onlyOwner() {
398         IRouter02 _newRouter = IRouter02(newRouter);
399         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
400         if (get_pair == address(0)) {
401             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
402         }
403         else {
404             lpPair = get_pair;
405         }
406         dexRouter = _newRouter;
407         _approve(address(this), address(dexRouter), type(uint256).max);
408     }
409 
410     function setLpPair(address pair, bool enabled) external onlyOwner {
411         if (enabled == false) {
412             lpPairs[pair] = false;
413             antiSnipe.setLpPair(pair, false);
414         } else {
415             if (timeSinceLastPair != 0) {
416                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
417             }
418             lpPairs[pair] = true;
419             timeSinceLastPair = block.timestamp;
420             antiSnipe.setLpPair(pair, true);
421         }
422     }
423 
424     function setInitializer(address initializer) external onlyOwner {
425         require(!_hasLiqBeenAdded, "Liquidity is already in.");
426         require(initializer != address(this), "Can't be self.");
427         antiSnipe = AntiSnipe(initializer);
428     }
429 
430     function removeBlacklisted(address account) external onlyOwner {
431         antiSnipe.removeBlacklisted(account);
432     }
433 
434     function isBlacklisted(address account) public view returns (bool) {
435         return antiSnipe.isBlacklisted(account);
436     }
437 
438     function getSniperAmt() public view returns (uint256) {
439         return antiSnipe.getSniperAmt();
440     }
441 
442     function removeSniper(address account) external onlyOwner {
443         antiSnipe.removeSniper(account);
444     }
445 
446     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
447         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
448     }
449 
450     function setGasPriceLimit(uint256 gas) external onlyOwner {
451         require(gas >= 75, "Too low.");
452         antiSnipe.setGasPriceLimit(gas);
453     }
454 
455     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
456         require(buyFee <= maxBuyTaxes
457                 && sellFee <= maxSellTaxes
458                 && transferFee <= maxTransferTaxes,
459                 "Cannot exceed maximums.");
460         _taxRates.buyFee = buyFee;
461         _taxRates.sellFee = sellFee;
462         _taxRates.transferFee = transferFee;
463     }
464 
465     function setRatios(uint16 liquidity, uint16 marketing) external onlyOwner {
466         _ratios.liquidity = liquidity;
467         _ratios.marketing = marketing;
468         _ratios.total = liquidity + marketing;
469     }
470 
471     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
472         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
473         _maxTxAmount = (_tTotal * percent) / divisor;
474     }
475 
476     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
477         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
478         _maxWalletSize = (_tTotal * percent) / divisor;
479     }
480 
481     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
482         _isExcludedFromLimits[account] = enabled;
483     }
484 
485     function isExcludedFromLimits(address account) public view returns (bool) {
486         return _isExcludedFromLimits[account];
487     }
488 
489     function isExcludedFromFees(address account) public view returns(bool) {
490         return _isExcludedFromFees[account];
491     }
492 
493     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
494         _isExcludedFromFees[account] = enabled;
495     }
496 
497     function getMaxTX() public view returns (uint256) {
498         return _maxTxAmount / (10**_decimals);
499     }
500 
501     function getMaxWallet() public view returns (uint256) {
502         return _maxWalletSize / (10**_decimals);
503     }
504 
505     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
506         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
507         swapAmount = (_tTotal * amountPercent) / amountDivisor;
508         contractSwapTimer = time;
509     }
510 
511     function setWallets(address payable marketing) external onlyOwner {
512         _taxWallets.marketing = payable(marketing);
513     }
514 
515     function setContractSwapEnabled(bool enabled) external onlyOwner {
516         contractSwapEnabled = enabled;
517         emit ContractSwapEnabledUpdated(enabled);
518     }
519 
520     function excludePresaleAddresses(address router, address presale) external onlyOwner {
521         require(allowedPresaleExclusion);
522         if (router == presale) {
523             _liquidityHolders[presale] = true;
524             presaleAddresses[presale] = true;
525             setExcludedFromFees(presale, true);
526         } else {
527             _liquidityHolders[router] = true;
528             _liquidityHolders[presale] = true;
529             presaleAddresses[router] = true;
530             presaleAddresses[presale] = true;
531             setExcludedFromFees(router, true);
532             setExcludedFromFees(presale, true);
533         }
534     }
535 
536     function _hasLimits(address from, address to) private view returns (bool) {
537         return from != owner()
538             && to != owner()
539             && tx.origin != owner()
540             && !_liquidityHolders[to]
541             && !_liquidityHolders[from]
542             && to != DEAD
543             && to != address(0)
544             && from != address(this);
545     }
546 
547     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
548         require(from != address(0), "ERC20: transfer from the zero address");
549         require(to != address(0), "ERC20: transfer to the zero address");
550         require(amount > 0, "Transfer amount must be greater than zero");
551         if(_hasLimits(from, to)) {
552             if(!tradingEnabled) {
553                 revert("Trading not yet enabled!");
554             }
555             if(lpPairs[from] || lpPairs[to]){
556                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
557                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
558                 }
559             }
560             if(to != address(dexRouter) && !lpPairs[to]) {
561                 if (!_isExcludedFromLimits[to]) {
562                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
563                 }
564             }
565         }
566 
567         bool takeFee = true;
568         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
569             takeFee = false;
570         }
571 
572         if (lpPairs[to]) {
573             if (!inSwap
574                 && contractSwapEnabled
575                 && !presaleAddresses[to]
576                 && !presaleAddresses[from]
577             ) {
578                 if (lastSwap + contractSwapTimer < block.timestamp) {
579                     uint256 contractTokenBalance = balanceOf(address(this));
580                     if (contractTokenBalance >= swapThreshold) {
581                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
582                         contractSwap(contractTokenBalance);
583                         lastSwap = block.timestamp;
584                     }
585                 }
586             }      
587         } 
588         return _finalizeTransfer(from, to, amount, takeFee);
589     }
590 
591     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
592         Ratios memory ratios = _ratios;
593         if (ratios.total == 0) {
594             return;
595         }
596 
597         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
598             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
599         }
600 
601         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.total) / 2;
602         uint256 swapAmt = contractTokenBalance - toLiquify;
603         
604         address[] memory path = new address[](2);
605         path[0] = address(this);
606         path[1] = dexRouter.WETH();
607 
608         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
609             swapAmt,
610             0,
611             path,
612             address(this),
613             block.timestamp
614         );
615 
616         uint256 amtBalance = address(this).balance;
617         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
618 
619         if (toLiquify > 0) {
620             dexRouter.addLiquidityETH{value: liquidityBalance}(
621                 address(this),
622                 toLiquify,
623                 0,
624                 0,
625                 DEAD,
626                 block.timestamp
627             );
628             emit AutoLiquify(liquidityBalance, toLiquify);
629         }
630 
631         amtBalance -= liquidityBalance;
632         ratios.total -= ratios.liquidity;
633         uint256 marketingBalance = amtBalance;
634         if (ratios.marketing > 0) {
635             _taxWallets.marketing.transfer(marketingBalance);
636         }
637     }
638 
639     function _checkLiquidityAdd(address from, address to) private {
640         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
641         if (!_hasLimits(from, to) && to == lpPair) {
642             _liquidityHolders[from] = true;
643             _hasLiqBeenAdded = true;
644             if(address(antiSnipe) == address(0)){
645                 antiSnipe = AntiSnipe(address(this));
646             }
647             contractSwapEnabled = true;
648             emit ContractSwapEnabledUpdated(true);
649         }
650     }
651 
652     function enableTrading() public onlyOwner {
653         require(!tradingEnabled, "Trading already enabled!");
654         require(_hasLiqBeenAdded, "Liquidity must be added.");
655         if(address(antiSnipe) == address(0)){
656             antiSnipe = AntiSnipe(address(this));
657         }
658         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
659         tradingEnabled = true;
660         allowedPresaleExclusion = false;
661     }
662 
663     function sweepContingency() external onlyOwner {
664         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
665         payable(owner()).transfer(address(this).balance);
666     }
667 
668     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
669         require(accounts.length == amounts.length, "Lengths do not match.");
670         for (uint8 i = 0; i < accounts.length; i++) {
671             require(balanceOf(msg.sender) >= amounts[i]);
672             _transfer(msg.sender, accounts[i], amounts[i]*10**_decimals);
673         }
674     }
675 
676     function multiSendPercents(address[] memory accounts, uint256[] memory percents, uint256[] memory divisors) external {
677         require(accounts.length == percents.length && percents.length == divisors.length, "Lengths do not match.");
678         for (uint8 i = 0; i < accounts.length; i++) {
679             require(balanceOf(msg.sender) >= (_tTotal * percents[i]) / divisors[i]);
680             _transfer(msg.sender, accounts[i], (_tTotal * percents[i]) / divisors[i]);
681         }
682     }
683 
684     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
685         if (!_hasLiqBeenAdded) {
686             _checkLiquidityAdd(from, to);
687             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
688                 revert("Only owner can transfer at this time.");
689             }
690         }
691 
692         if (_hasLimits(from, to)) {
693             bool checked;
694             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
695                 checked = check;
696             } catch {
697                 revert();
698             }
699 
700             if(!checked) {
701                 revert();
702             }
703         }
704 
705         _tOwned[from] -= amount;
706         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
707         _tOwned[to] += amountReceived;
708 
709         emit Transfer(from, to, amountReceived);
710         return true;
711     }
712 
713     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
714         uint256 currentFee;
715         if (lpPairs[from]) {
716             currentFee = _taxRates.buyFee;
717         } else if (lpPairs[to]) {
718             currentFee = _taxRates.sellFee;
719         } else {
720             currentFee = _taxRates.transferFee;
721         }
722 
723         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
724 
725         _tOwned[address(this)] += feeAmount;
726         emit Transfer(from, address(this), feeAmount);
727 
728         return amount - feeAmount;
729     }
730 }