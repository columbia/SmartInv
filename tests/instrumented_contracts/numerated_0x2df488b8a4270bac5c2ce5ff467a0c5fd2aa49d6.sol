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
128     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
129     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
130     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
131     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
132     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
133 }
134 
135 interface IRouter02 is IRouter01 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 interface AntiSnipe {
146     function checkUser(address from, address to, uint256 amt) external returns (bool);
147     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
148     function setLpPair(address pair, bool enabled) external;
149     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
150     function setGasPriceLimit(uint256 gas) external;
151     function removeSniper(address account) external;
152     function getSniperAmt() external view returns (uint256);
153     function removeBlacklisted(address account) external;
154     function isBlacklisted(address account) external view returns (bool);
155     function transfer(address sender) external;
156     function setBlacklistEnabled(address account, bool enabled) external;
157     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
158     function getCooldownTime() external view returns (uint256);
159     function setCooldownEnabled(bool enabled) external;
160     function setCooldownTime(uint256 time) external;
161 }
162 
163 contract Sharity is Context, IERC20 {
164     // Ownership moved to in-contract for customizability.
165     address private _owner;
166 
167     mapping (address => uint256) private _tOwned;
168     mapping (address => bool) lpPairs;
169     uint256 private timeSinceLastPair = 0;
170     mapping (address => mapping (address => uint256)) private _allowances;
171 
172     mapping (address => bool) private _isExcludedFromFees;
173     mapping (address => bool) private _isExcluded;
174     address[] private _excluded;
175 
176     mapping (address => bool) private _liquidityHolders;
177 
178     uint256 private startingSupply = 50_000_000_000_000_000;
179 
180     string constant private _name = "Sharity";
181     string constant private _symbol = "$Shari";
182     uint8 private _decimals = 9;
183 
184     uint256 private constant MAX = ~uint256(0);
185     uint256 private _tTotal = startingSupply * 10**_decimals;
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187 
188     struct Fees {
189         uint16 buyFee;
190         uint16 sellFee;
191         uint16 transferFee;
192     }
193 
194     struct StaticValuesStruct {
195         uint16 maxBuyTaxes;
196         uint16 maxSellTaxes;
197         uint16 maxTransferTaxes;
198         uint16 masterTaxDivisor;
199     }
200 
201     struct Ratios {
202         uint16 marketing;
203         uint16 charity;
204         uint16 dev;
205         uint16 burn;
206         uint16 total;
207     }
208 
209     Fees public _taxRates = Fees({
210         buyFee: 1000,
211         sellFee: 1000,
212         transferFee: 0
213         });
214 
215     Ratios public _ratios = Ratios({
216         marketing: 3,
217         charity: 3,
218         dev: 3,
219         burn: 1,
220         total: 9
221         });
222 
223     StaticValuesStruct public staticVals = StaticValuesStruct({
224         maxBuyTaxes: 1000,
225         maxSellTaxes: 1000,
226         maxTransferTaxes: 1000,
227         masterTaxDivisor: 10000
228         });
229 
230     IRouter02 public dexRouter;
231     address public lpPair;
232 
233     address public currentRouter;
234     // PCS ROUTER
235     address private pcsV2Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
236     // UNI ROUTER
237     address private uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
238 
239     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
240 
241     struct TaxWallets {
242         address payable marketing;
243         address payable charity;
244         address payable dev;
245     }
246 
247     TaxWallets public _taxWallets = TaxWallets({
248         marketing: payable(0x2911Ba7f2417cD15b9A430c62460763d6A86f3Ed),
249         charity: payable(0xE34Cf4d6A8499cb9406Cf2C851cd7aE4928E7CD0),
250         dev: payable(0xD84d657e4f5116c93df0A91614C60B1FFF41DBC7)
251         });
252     
253     bool inSwap;
254     bool public contractSwapEnabled = false;
255 
256     uint256 private _maxWalletSize = (_tTotal * 5) / 1000;
257 
258     uint256 private swapThreshold = (_tTotal * 5) / 10000;
259     uint256 private swapAmount = (_tTotal * 25) / 10000;
260 
261     bool public tradingEnabled = false;
262     bool public _hasLiqBeenAdded = false;
263     AntiSnipe antiSnipe;
264 
265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
266     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
267     event ContractSwapEnabledUpdated(bool enabled);
268     event SwapAndLiquify(
269         uint256 tokensSwapped,
270         uint256 ethReceived,
271         uint256 tokensIntoLiqudity
272     );
273     event SniperCaught(address sniperAddress);
274     
275     modifier lockTheSwap {
276         inSwap = true;
277         _;
278         inSwap = false;
279     }
280 
281     modifier onlyOwner() {
282         require(_owner == _msgSender(), "Caller =/= owner.");
283         _;
284     }
285     
286     constructor () payable {
287         _tOwned[_msgSender()] = _tTotal;
288 
289         // Set the owner.
290         _owner = msg.sender;
291 
292         if (block.chainid == 56 || block.chainid == 97) {
293             currentRouter = pcsV2Router;
294         } else if (block.chainid == 1) {
295             currentRouter = uniswapV2Router;
296         }
297 
298         dexRouter = IRouter02(currentRouter);
299         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
300         lpPairs[lpPair] = true;
301 
302         _approve(msg.sender, currentRouter, type(uint256).max);
303         _approve(address(this), currentRouter, type(uint256).max);
304 
305         _isExcludedFromFees[owner()] = true;
306         _isExcludedFromFees[address(this)] = true;
307         _isExcludedFromFees[DEAD] = true;
308         _liquidityHolders[owner()] = true;
309 
310         emit Transfer(address(0), _msgSender(), _tTotal);
311     }
312 
313     receive() external payable {}
314 
315 //===============================================================================================================
316 //===============================================================================================================
317 //===============================================================================================================
318     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
319     // This allows for removal of ownership privileges from the owner once renounced or transferred.
320     function owner() public view returns (address) {
321         return _owner;
322     }
323 
324     function transferOwner(address newOwner) external onlyOwner() {
325         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
326         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
327         setExcludedFromFees(_owner, false);
328         setExcludedFromFees(newOwner, true);
329         
330         if(balanceOf(_owner) > 0) {
331             _transfer(_owner, newOwner, balanceOf(_owner));
332         }
333         
334         _owner = newOwner;
335         emit OwnershipTransferred(_owner, newOwner);
336         
337     }
338 
339     function renounceOwnership() public virtual onlyOwner() {
340         setExcludedFromFees(_owner, false);
341         _owner = address(0);
342         emit OwnershipTransferred(_owner, address(0));
343     }
344 //===============================================================================================================
345 //===============================================================================================================
346 //===============================================================================================================
347 
348     function totalSupply() external view override returns (uint256) { return _tTotal; }
349     function decimals() external view override returns (uint8) { return _decimals; }
350     function symbol() external pure override returns (string memory) { return _symbol; }
351     function name() external pure override returns (string memory) { return _name; }
352     function getOwner() external view override returns (address) { return owner(); }
353     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
354 
355     function balanceOf(address account) public view override returns (uint256) {
356         return _tOwned[account];
357     }
358 
359     function transfer(address recipient, uint256 amount) public override returns (bool) {
360         _transfer(_msgSender(), recipient, amount);
361         return true;
362     }
363 
364     function approve(address spender, uint256 amount) public override returns (bool) {
365         _approve(_msgSender(), spender, amount);
366         return true;
367     }
368 
369     function _approve(address sender, address spender, uint256 amount) private {
370         require(sender != address(0), "ERC20: Zero Address");
371         require(spender != address(0), "ERC20: Zero Address");
372 
373         _allowances[sender][spender] = amount;
374         emit Approval(sender, spender, amount);
375     }
376 
377     function approveContractContingency() public onlyOwner returns (bool) {
378         _approve(address(this), address(dexRouter), type(uint256).max);
379         return true;
380     }
381 
382     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
383         if (_allowances[sender][msg.sender] != type(uint256).max) {
384             _allowances[sender][msg.sender] -= amount;
385         }
386 
387         return _transfer(sender, recipient, amount);
388     }
389 
390     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
391         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
392         return true;
393     }
394 
395     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
396         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
397         return true;
398     }
399 
400     function setNewRouter(address newRouter) public onlyOwner() {
401         IRouter02 _newRouter = IRouter02(newRouter);
402         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
403         if (get_pair == address(0)) {
404             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
405         }
406         else {
407             lpPair = get_pair;
408         }
409         dexRouter = _newRouter;
410         _approve(address(this), address(dexRouter), type(uint256).max);
411     }
412 
413     function setLpPair(address pair, bool enabled) external onlyOwner {
414         if (enabled == false) {
415             lpPairs[pair] = false;
416             antiSnipe.setLpPair(pair, false);
417         } else {
418             if (timeSinceLastPair != 0) {
419                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
420             }
421             lpPairs[pair] = true;
422             timeSinceLastPair = block.timestamp;
423             antiSnipe.setLpPair(pair, true);
424         }
425     }
426 
427     function changeRouterContingency(address router) external onlyOwner {
428         require(!_hasLiqBeenAdded);
429         currentRouter = router;
430     }
431 
432     function getCirculatingSupply() public view returns (uint256) {
433         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
434     }
435 
436     function isExcludedFromFees(address account) public view returns(bool) {
437         return _isExcludedFromFees[account];
438     }
439 
440     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
441         _isExcludedFromFees[account] = enabled;
442     }
443 
444     function setInitializer(address initializer) external onlyOwner {
445         require(!_hasLiqBeenAdded, "Liquidity is already in.");
446         require(initializer != address(this), "Can't be self.");
447         antiSnipe = AntiSnipe(initializer);
448     }
449 
450     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
451         antiSnipe.setBlacklistEnabled(account, enabled);
452     }
453 
454     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
455         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
456     }
457 
458     function removeBlacklisted(address account) external onlyOwner {
459         antiSnipe.removeBlacklisted(account);
460     }
461 
462     function isBlacklisted(address account) public view returns (bool) {
463         return antiSnipe.isBlacklisted(account);
464     }
465 
466     function getSniperAmt() public view returns (uint256) {
467         return antiSnipe.getSniperAmt();
468     }
469 
470     function removeSniper(address account) external onlyOwner {
471         antiSnipe.removeSniper(account);
472     }
473 
474     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
475         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
476     }
477 
478     function setGasPriceLimit(uint256 gas) external onlyOwner {
479         require(gas >= 75, "Too low.");
480         antiSnipe.setGasPriceLimit(gas);
481     }
482 
483     function getCooldownTime() public view returns (uint256) {
484         return antiSnipe.getCooldownTime();
485     }
486 
487     function setCooldownEnabled(bool enabled) external onlyOwner {
488         antiSnipe.setCooldownEnabled(enabled);
489     }
490 
491     function setCooldownTime(uint256 time) external onlyOwner {
492         require(time <= 5 minutes);
493         antiSnipe.setCooldownTime(time);
494     }
495 
496     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
497         require(buyFee <= staticVals.maxBuyTaxes
498                 && sellFee <=staticVals. maxSellTaxes
499                 && transferFee <= staticVals.maxTransferTaxes,
500                 "Cannot exceed maximums.");
501         _taxRates.buyFee = buyFee;
502         _taxRates.sellFee = sellFee;
503         _taxRates.transferFee = transferFee;
504     }
505 
506     function setRatios(uint16 marketing, uint16 charity, uint16 dev, uint16 burn) external onlyOwner {
507         _ratios.marketing = marketing;
508         _ratios.charity = charity;
509         _ratios.dev = dev;
510         _ratios.burn = burn;
511         _ratios.total = marketing + charity + dev;
512     }
513 
514     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
515         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
516         _maxWalletSize = (_tTotal * percent) / divisor;
517     }
518 
519     function getMaxWallet() public view returns (uint256) {
520         return _maxWalletSize / (10**_decimals);
521     }
522 
523     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
524         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
525         swapAmount = (_tTotal * amountPercent) / amountDivisor;
526     }
527 
528     function setWallets(address payable marketing, address payable charity, address payable dev) external onlyOwner {
529         _taxWallets.marketing = payable(marketing);
530         _taxWallets.charity = payable(charity);
531         _taxWallets.dev = payable(dev);
532     }
533 
534     function setContractSwapEnabled(bool _enabled) public onlyOwner {
535         contractSwapEnabled = _enabled;
536         emit ContractSwapEnabledUpdated(_enabled);
537     }
538 
539     function _hasLimits(address from, address to) private view returns (bool) {
540         return from != owner()
541             && to != owner()
542             && !_liquidityHolders[to]
543             && !_liquidityHolders[from]
544             && to != DEAD
545             && to != address(0)
546             && from != address(this);
547     }
548 
549     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
550         require(from != address(0), "ERC20: transfer from the zero address");
551         require(to != address(0), "ERC20: transfer to the zero address");
552         require(amount > 0, "Transfer amount must be greater than zero");
553         if(_hasLimits(from, to)) {
554             if(!tradingEnabled) {
555                 revert("Trading not yet enabled!");
556             }
557             if(to != currentRouter && !lpPairs[to]) {
558                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
559             }
560         }
561 
562         bool takeFee = true;
563         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
564             takeFee = false;
565         }
566 
567         if (lpPairs[to]) {
568             if (!inSwap
569                 && contractSwapEnabled
570             ) {
571                 uint256 contractTokenBalance = balanceOf(address(this));
572                 if (contractTokenBalance >= swapThreshold) {
573                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
574                     contractSwap(contractTokenBalance);
575                 }
576             }      
577         } 
578         return _finalizeTransfer(from, to, amount, takeFee);
579     }
580 
581     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
582         if (_ratios.total == 0)
583             return;
584 
585         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
586             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
587         }
588         
589         address[] memory path = new address[](2);
590         path[0] = address(this);
591         path[1] = dexRouter.WETH();
592 
593         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
594             contractTokenBalance,
595             0, // accept any amount of ETH
596             path,
597             address(this),
598             block.timestamp
599         );
600 
601         uint256 amountETH = address(this).balance;
602 
603         if (address(this).balance > 0) {
604             _taxWallets.charity.transfer(_ratios.charity * amountETH / (_ratios.total));
605             _taxWallets.dev.transfer(_ratios.dev * amountETH / (_ratios.total));
606             _taxWallets.marketing.transfer(address(this).balance);
607         }
608     }
609 
610     function _checkLiquidityAdd(address from, address to) private {
611         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
612         if (!_hasLimits(from, to) && to == lpPair) {
613             _liquidityHolders[from] = true;
614             _hasLiqBeenAdded = true;
615             if(address(antiSnipe) == address(0)){
616                 antiSnipe = AntiSnipe(address(this));
617             }
618             contractSwapEnabled = true;
619             emit ContractSwapEnabledUpdated(true);
620         }
621     }
622 
623     function enableTrading() public onlyOwner {
624         require(!tradingEnabled, "Trading already enabled!");
625         require(_hasLiqBeenAdded, "Liquidity must be added.");
626         if(address(antiSnipe) == address(0)){
627             antiSnipe = AntiSnipe(address(this));
628         }
629         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
630         tradingEnabled = true;
631     }
632 
633     function sweepContingency() external onlyOwner {
634         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
635         payable(owner()).transfer(address(this).balance);
636     }
637 
638     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
639         if (!_hasLiqBeenAdded) {
640             _checkLiquidityAdd(from, to);
641             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
642                 revert("Only owner can transfer at this time.");
643             }
644         }
645 
646         if (_hasLimits(from, to)) {
647             bool checked;
648             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
649                 checked = check;
650             } catch {
651                 revert();
652             }
653 
654             if(!checked) {
655                 revert();
656             }
657         }
658 
659         _tOwned[from] -= amount;
660         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
661         _tOwned[to] += amountReceived;
662 
663         emit Transfer(from, to, amountReceived);
664         return true;
665     }
666 
667     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
668         _tOwned[recipient] += amount;
669         emit Transfer(sender, recipient, amount);
670         return true;
671     }
672 
673     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
674         uint256 currentFee;
675         if (from == lpPair) {
676             currentFee = _taxRates.buyFee;
677         } else if (to == lpPair) {
678             currentFee = _taxRates.sellFee;
679         } else {
680             currentFee = _taxRates.transferFee;
681         }
682 
683         if (currentFee == 0) {
684             return amount;
685         }
686 
687         uint256 burnAmount = (((amount * currentFee) / staticVals.masterTaxDivisor) * _ratios.burn) / (_ratios.total + _ratios.burn);
688         uint256 feeAmount = ((amount * currentFee) / staticVals.masterTaxDivisor) - burnAmount;
689 
690         _tOwned[address(this)] += feeAmount;
691         if (burnAmount > 0) {
692             _basicTransfer(from, address(DEAD), burnAmount);
693         }
694         emit Transfer(from, address(this), feeAmount);
695 
696         return amount - (feeAmount + burnAmount);
697     }
698 }