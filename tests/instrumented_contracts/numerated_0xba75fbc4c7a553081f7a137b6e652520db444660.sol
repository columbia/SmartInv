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
158     function getAmountBlockDelay() external view returns (uint8);
159     function setAmountBlocks(uint8 blocks) external;
160 }
161 
162 contract MonstaVerse is Context, IERC20 {
163     // Ownership moved to in-contract for customizability.
164     address private _owner;
165 
166     mapping (address => uint256) private _rOwned;
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
178     uint256 private startingSupply;
179     string private _name;
180     string private _symbol;
181     uint8 private _decimals;
182 
183     uint256 private _tTotal;
184     uint256 private _rTotal;
185 
186     struct CurrentFees {
187         uint16 reflect;
188         uint16 totalSwap;
189     }
190 
191     struct Fees {
192         uint16 reflect;
193         uint16 liquidity;
194         uint16 marketing;
195         uint16 totalSwap;
196     }
197 
198     struct StaticValuesStruct {
199         uint16 maxReflect;
200         uint16 maxLiquidity;
201         uint16 maxMarketing;
202         uint16 masterTaxDivisor;
203     }
204 
205     struct Ratios {
206         uint16 liquidity;
207         uint16 marketing;
208         uint16 total;
209     }
210 
211     CurrentFees private currentTaxes = CurrentFees({
212         reflect: 0,
213         totalSwap: 0
214         });
215 
216     Fees public _buyTaxes = Fees({
217         reflect: 200,
218         liquidity: 400,
219         marketing: 600,
220         totalSwap: 1000
221         });
222 
223     Fees public _sellTaxes = Fees({
224         reflect: 200,
225         liquidity: 400,
226         marketing: 600,
227         totalSwap: 1000
228         });
229 
230     Fees public _transferTaxes = Fees({
231         reflect: 200,
232         liquidity: 400,
233         marketing: 600,
234         totalSwap: 1000
235         });
236 
237     Ratios public _ratios = Ratios({
238         liquidity: 4,
239         marketing: 6,
240         total: 10
241         });
242 
243     StaticValuesStruct public staticVals = StaticValuesStruct({
244         maxReflect: 800,
245         maxLiquidity: 800,
246         maxMarketing: 800,
247         masterTaxDivisor: 10000
248         });
249 
250 
251     IRouter02 public dexRouter;
252     address public lpPair;
253 
254     address public currentRouter;
255     // PCS ROUTER
256     address private pcsV2Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
257     // UNI ROUTER
258     address private uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
259 
260     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
261 
262     struct TaxWallets {
263         address payable marketing;
264     }
265 
266     TaxWallets public _taxWallets = TaxWallets({
267         marketing: payable(0xf958d92F9CBFAf65d2c156C942dCdA485cBd505F)
268         });
269     
270     bool inSwap;
271     bool public contractSwapEnabled = false;
272     
273     uint256 private _maxTxAmount;
274     uint256 private _maxWalletSize;
275 
276     uint256 private swapThreshold;
277     uint256 private swapAmount;
278 
279     bool public tradingEnabled = false;
280     bool public _hasLiqBeenAdded = false;
281 
282     AntiSnipe antiSnipe;
283     uint256 public launch;
284     bool contractInitialized = false;
285 
286     address[] path;
287 
288     uint256 public maxEthBuy = 5 * 10**18;
289     uint256 public maxEthSell = 5 * 10**18;
290     bool public timedLimitsEnabled = true;
291     bool public maxEthTradesEnabled = true;
292 
293     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
295     event ContractSwapEnabledUpdated(bool enabled);
296     event SwapAndLiquify(
297         uint256 tokensSwapped,
298         uint256 ethReceived,
299         uint256 tokensIntoLiqudity
300     );
301     event SniperCaught(address sniperAddress);
302     
303     modifier lockTheSwap {
304         inSwap = true;
305         _;
306         inSwap = false;
307     }
308 
309     modifier onlyOwner() {
310         require(_owner == _msgSender(), "Caller =/= owner.");
311         _;
312     }
313     
314     constructor () payable {
315         // Set the owner.
316         _owner = msg.sender;
317 
318         if (block.chainid == 56 || block.chainid == 97) {
319             currentRouter = pcsV2Router;
320         } else if (block.chainid == 1) {
321             currentRouter = uniswapV2Router;
322         }
323 
324         _approve(msg.sender, currentRouter, type(uint256).max);
325         _approve(address(this), currentRouter, type(uint256).max);
326 
327         _isExcludedFromFees[owner()] = true;
328         _isExcludedFromFees[address(this)] = true;
329         _isExcludedFromFees[DEAD] = true;
330         _liquidityHolders[owner()] = true;
331     }
332 
333     function intializeContract(address[] memory accounts, uint256[] memory amounts, uint256[] memory amountsD, address _antiSnipe) external onlyOwner {
334         require(!contractInitialized, "1");
335         require(accounts.length < 200, "2");
336         require(accounts.length == amounts.length, "3");
337         require(amounts.length == amountsD.length, "4");
338         startingSupply = 666_000_000_000_000;
339         antiSnipe = AntiSnipe(_antiSnipe);
340         if(address(antiSnipe) == address(0)){
341             antiSnipe = AntiSnipe(address(this));
342         }
343         try antiSnipe.transfer(address(this)) {} catch {}
344         if (startingSupply < 10000000000) {
345             _decimals = 18;
346         } else {
347             _decimals = 9;
348         }
349         _tTotal = startingSupply * (10**_decimals);
350         _rTotal = (~uint256(0) - (~uint256(0) % _tTotal));
351         _name = "MonstaVerse";
352         _symbol = "MONSTR";
353         dexRouter = IRouter02(currentRouter);
354         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
355         lpPairs[lpPair] = true;        
356         path = new address[](2);
357         path[0] = address(this);
358         path[1] = dexRouter.WETH();
359         _maxTxAmount = (_tTotal * 5) / 1000;
360         _maxWalletSize = (_tTotal * 15) / 1000;
361         swapThreshold = (_tTotal * 5) / 10000;
362         swapAmount = (_tTotal * 25) / 10000;
363         contractInitialized = true;     
364         _rOwned[owner()] = _rTotal;
365         emit Transfer(address(0), owner(), _tTotal);
366 
367         _approve(address(this), address(dexRouter), type(uint256).max);
368 
369         for(uint256 i = 0; i < accounts.length; i++){
370             uint256 amount = (_tTotal*amounts[i]) / amountsD[i];
371             _transfer(owner(), accounts[i], amount);
372         }
373 
374         _transfer(owner(), address(this), balanceOf(owner()));
375 
376         dexRouter.addLiquidityETH{value: address(this).balance}(
377             address(this),
378             balanceOf(address(this)),
379             0, // slippage is unavoidable
380             0, // slippage is unavoidable
381             owner(),
382             block.timestamp
383         );
384 
385         enableTrading();
386     }
387 
388     receive() external payable {}
389 
390 //===============================================================================================================
391 //===============================================================================================================
392 //===============================================================================================================
393     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
394     // This allows for removal of ownership privileges from the owner once renounced or transferred.
395     function owner() public view returns (address) {
396         return _owner;
397     }
398 
399     function transferOwner(address newOwner) external onlyOwner() {
400         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
401         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
402         setExcludedFromFees(_owner, false);
403         setExcludedFromFees(newOwner, true);
404         
405         if(balanceOf(_owner) > 0) {
406             _transfer(_owner, newOwner, balanceOf(_owner));
407         }
408         
409         _owner = newOwner;
410         emit OwnershipTransferred(_owner, newOwner);
411         
412     }
413 
414     function renounceOwnership() public virtual onlyOwner() {
415         setExcludedFromFees(_owner, false);
416         _owner = address(0);
417         emit OwnershipTransferred(_owner, address(0));
418     }
419 //===============================================================================================================
420 //===============================================================================================================
421 //===============================================================================================================
422 
423     function totalSupply() external view override returns (uint256) {
424         if (_tTotal == 0) {
425             revert();
426         }
427         return _tTotal; 
428     }
429     function decimals() external view override returns (uint8) { return _decimals; }
430     function symbol() external view override returns (string memory) { return _symbol; }
431     function name() external view override returns (string memory) { return _name; }
432     function getOwner() external view override returns (address) { return owner(); }
433     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
434 
435     function balanceOf(address account) public view override returns (uint256) {
436         if (_isExcluded[account]) return _tOwned[account];
437         return tokenFromReflection(_rOwned[account]);
438     }
439 
440     function transfer(address recipient, uint256 amount) public override returns (bool) {
441         _transfer(_msgSender(), recipient, amount);
442         return true;
443     }
444 
445     function approve(address spender, uint256 amount) public override returns (bool) {
446         _approve(_msgSender(), spender, amount);
447         return true;
448     }
449 
450     function _approve(address sender, address spender, uint256 amount) private {
451         require(sender != address(0), "ERC20: Zero Address");
452         require(spender != address(0), "ERC20: Zero Address");
453 
454         _allowances[sender][spender] = amount;
455         emit Approval(sender, spender, amount);
456     }
457 
458     function approveContractContingency() public onlyOwner returns (bool) {
459         _approve(address(this), address(dexRouter), type(uint256).max);
460         return true;
461     }
462 
463     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
464         if (_allowances[sender][msg.sender] != type(uint256).max) {
465             _allowances[sender][msg.sender] -= amount;
466         }
467 
468         return _transfer(sender, recipient, amount);
469     }
470 
471     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
472         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
473         return true;
474     }
475 
476     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
477         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
478         return true;
479     }
480 
481     function setNewRouter(address newRouter) public onlyOwner() {
482         IRouter02 _newRouter = IRouter02(newRouter);
483         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
484         if (get_pair == address(0)) {
485             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
486         }
487         else {
488             lpPair = get_pair;
489         }
490         dexRouter = _newRouter;
491         _approve(address(this), address(dexRouter), type(uint256).max);
492     }
493 
494     function setLpPair(address pair, bool enabled) external onlyOwner {
495         if (enabled == false) {
496             lpPairs[pair] = false;
497             antiSnipe.setLpPair(pair, false);
498         } else {
499             if (timeSinceLastPair != 0) {
500                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
501             }
502             lpPairs[pair] = true;
503             timeSinceLastPair = block.timestamp;
504             antiSnipe.setLpPair(pair, true);
505         }
506     }
507 
508     function changeRouterContingency(address router) external onlyOwner {
509         require(!_hasLiqBeenAdded);
510         currentRouter = router;
511     }
512 
513     function getCirculatingSupply() public view returns (uint256) {
514         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
515     }
516 
517     function isExcludedFromFees(address account) public view returns(bool) {
518         return _isExcludedFromFees[account];
519     }
520 
521     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
522         _isExcludedFromFees[account] = enabled;
523     }
524 
525     function isExcludedFromReward(address account) public view returns (bool) {
526         return _isExcluded[account];
527     }
528 
529     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
530         if (enabled == true) {
531             require(!_isExcluded[account], "Account is already excluded.");
532             if(_rOwned[account] > 0) {
533                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
534             }
535             _isExcluded[account] = true;
536             _excluded.push(account);
537         } else if (enabled == false) {
538             require(_isExcluded[account], "Account is already included.");
539             if(_excluded.length == 1){
540                 _tOwned[account] = 0;
541                 _isExcluded[account] = false;
542                 _excluded.pop();
543             } else {
544                 for (uint256 i = 0; i < _excluded.length; i++) {
545                     if (_excluded[i] == account) {
546                         _excluded[i] = _excluded[_excluded.length - 1];
547                         _tOwned[account] = 0;
548                         _isExcluded[account] = false;
549                         _excluded.pop();
550                         break;
551                     }
552                 }
553             }
554         }
555     }
556 
557     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
558         require(rAmount <= _rTotal, "Amount must be less than total reflections");
559         uint256 currentRate =  _getRate();
560         return rAmount / currentRate;
561     }
562 
563     function setInitializer(address initializer) external onlyOwner {
564         require(!_hasLiqBeenAdded, "Liquidity is already in.");
565         require(initializer != address(this), "Can't be self.");
566         antiSnipe = AntiSnipe(initializer);
567     }
568 
569     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
570         antiSnipe.setBlacklistEnabled(account, enabled);
571     }
572 
573     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
574         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
575     }
576 
577     function removeBlacklisted(address account) external onlyOwner {
578         antiSnipe.removeBlacklisted(account);
579     }
580 
581     function isBlacklisted(address account) public view returns (bool) {
582         return antiSnipe.isBlacklisted(account);
583     }
584 
585     function getSniperAmt() public view returns (uint256) {
586         return antiSnipe.getSniperAmt();
587     }
588 
589     function removeSniper(address account) external onlyOwner {
590         antiSnipe.removeSniper(account);
591     }
592 
593     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
594         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
595     }
596 
597     function setGasPriceLimit(uint256 gas) external onlyOwner {
598         require(gas >= 75, "Too low.");
599         antiSnipe.setGasPriceLimit(gas);
600     }
601 
602     function getAmountBlockDelay() public view returns (uint8) {
603         return antiSnipe.getAmountBlockDelay();
604     }
605 
606     function setAmountBlocks(uint8 blocks) external onlyOwner {
607         require(blocks <= 10);
608         antiSnipe.setAmountBlocks(blocks);
609     }
610     
611     function setTaxesBuy(uint16 reflect, uint16 liquidity, uint16 marketing) external onlyOwner {
612         require(reflect <= staticVals.maxReflect
613                 && liquidity <= staticVals.maxLiquidity
614                 && marketing <= staticVals.maxMarketing);
615         uint16 check = reflect + liquidity + marketing;
616         require(check <= 2000);
617         _buyTaxes.liquidity = liquidity;
618         _buyTaxes.reflect = reflect;
619         _buyTaxes.marketing = marketing;
620         _buyTaxes.totalSwap = check - reflect;
621     }
622 
623     function setTaxesSell(uint16 reflect, uint16 liquidity, uint16 marketing) external onlyOwner {
624         require(reflect <= staticVals.maxReflect
625                 && liquidity <= staticVals.maxLiquidity
626                 && marketing <= staticVals.maxMarketing);
627         uint16 check = reflect + liquidity + marketing;
628         require(check <= 2000);
629         _sellTaxes.liquidity = liquidity;
630         _sellTaxes.reflect = reflect;
631         _sellTaxes.marketing = marketing;
632         _sellTaxes.totalSwap = check - reflect;
633     }
634 
635     function setTaxesTransfer(uint16 reflect, uint16 liquidity, uint16 marketing) external onlyOwner {
636         require(reflect <= staticVals.maxReflect
637                 && liquidity <= staticVals.maxLiquidity
638                 && marketing <= staticVals.maxMarketing);
639         uint16 check = reflect + liquidity + marketing;
640         require(check <= 2000);
641         _transferTaxes.liquidity = liquidity;
642         _transferTaxes.reflect = reflect;
643         _transferTaxes.marketing = marketing;
644         _transferTaxes.totalSwap = check - reflect;
645     }
646 
647     function setRatios(uint16 liquidity, uint16 marketing) external onlyOwner {
648         _ratios.liquidity = liquidity;
649         _ratios.marketing = marketing;
650         _ratios.total = liquidity + marketing;
651     }
652 
653     function setEthLimits(uint256 buyVal, uint256 buyMult, uint256 sellVal, uint256 sellMult) external onlyOwner {
654         maxEthBuy = buyVal * 10**buyMult;
655         maxEthSell = sellVal * 10**sellMult;
656         require(maxEthBuy >= 5 * 10**18 && maxEthSell >= 5 * 10**18);
657     }
658 
659     function setEthLimitsEnabled(bool timeLimits, bool maxEthTrades) external onlyOwner {
660         timedLimitsEnabled = timeLimits;
661         maxEthTradesEnabled = maxEthTrades;
662     }
663 
664     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
665         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
666         swapAmount = (_tTotal * amountPercent) / amountDivisor;
667     }
668 
669     function setWallets(address payable marketing) external onlyOwner {
670         _taxWallets.marketing = payable(marketing);
671     }
672 
673     function setContractSwapEnabled(bool _enabled) public onlyOwner {
674         contractSwapEnabled = _enabled;
675         emit ContractSwapEnabledUpdated(_enabled);
676     }
677 
678     function _hasLimits(address from, address to) private view returns (bool) {
679         return from != owner()
680             && to != owner()
681             && !_liquidityHolders[to]
682             && !_liquidityHolders[from]
683             && to != DEAD
684             && to != address(0)
685             && from != address(this);
686     }
687 
688     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
689         require(from != address(0), "ERC20: transfer from the zero address");
690         require(to != address(0), "ERC20: transfer to the zero address");
691         require(amount > 0, "Transfer amount must be greater than zero");
692         bool takeFee = true;
693         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
694             takeFee = false;
695         }
696 
697         if(_hasLimits(from, to)) {
698             if(!tradingEnabled) {
699                 revert("Trading not yet enabled!");
700             }
701             uint256 _ethBalance = dexRouter.getAmountsOut(amount, path)[1];
702             if (maxEthTradesEnabled) {
703                 if(lpPairs[from]) {
704                     if (timedLimitsEnabled) {
705                         if(block.timestamp <= launch + 2 hours) {
706                             require(_ethBalance <= 25 * 10**16);
707                         } else if (block.timestamp <= launch + 22 hours) {
708                             require(_ethBalance <= 2 * 10**18);
709                         } else {
710                             require(_ethBalance <= maxEthBuy);
711                         }
712                     } else {
713                         require(_ethBalance <= maxEthBuy);
714                     }
715                 } else if (lpPairs[to]) {
716                     if (timedLimitsEnabled) {
717                         if(block.timestamp <= launch + 2 hours) {
718                             require(_ethBalance <= 25 * 10**16);
719                         } else if (block.timestamp <= launch + 22 hours) {
720                             require(_ethBalance <= 2 * 10**18);
721                         } else {
722                             require(_ethBalance <= maxEthSell);
723                         }
724                     } else {
725                         require(_ethBalance <= maxEthSell);
726                     }
727                 }
728             }
729         }
730 
731         if (lpPairs[to]) {
732             if (!inSwap
733                 && contractSwapEnabled
734             ) {
735                 uint256 contractTokenBalance = balanceOf(address(this));
736                 if (contractTokenBalance >= swapThreshold) {
737                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
738                     contractSwap(contractTokenBalance);
739                 }
740             }      
741         } 
742         return _finalizeTransfer(from, to, amount, takeFee);
743     }
744 
745     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
746         if (_ratios.total == 0)
747             return;
748 
749         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
750             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
751         }
752 
753         uint256 toLiquify = ((contractTokenBalance * _ratios.liquidity) / _ratios.total) / 2;
754 
755         uint256 toSwapForEth = contractTokenBalance - toLiquify;
756 
757         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
758             toSwapForEth,
759             0, // accept any amount of ETH
760             path,
761             address(this),
762             block.timestamp
763         );
764 
765         uint256 liquidityBalance = ((address(this).balance * _ratios.liquidity) / _ratios.total) / 2;
766 
767         if (toLiquify > 0) {
768             dexRouter.addLiquidityETH{value: liquidityBalance}(
769                 address(this),
770                 toLiquify,
771                 0, // slippage is unavoidable
772                 0, // slippage is unavoidable
773                 DEAD,
774                 block.timestamp
775             );
776             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
777         }
778         if (address(this).balance > 0 && _ratios.total - _ratios.liquidity > 0) {
779             _taxWallets.marketing.transfer(address(this).balance);
780         }
781     }
782 
783     function _checkLiquidityAdd(address from, address to) private {
784         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
785         if (!_hasLimits(from, to) && to == lpPair) {
786             _liquidityHolders[from] = true;
787             _hasLiqBeenAdded = true;
788             if(address(antiSnipe) == address(0)){
789                 antiSnipe = AntiSnipe(address(this));
790             }
791             contractSwapEnabled = true;
792             emit ContractSwapEnabledUpdated(true);
793         }
794     }
795 
796     function enableTrading() public onlyOwner {
797         require(!tradingEnabled, "Trading already enabled!");
798         require(_hasLiqBeenAdded, "Liquidity must be added.");
799         setExcludedFromReward(address(this), true);
800         setExcludedFromReward(lpPair, true);
801         if(address(antiSnipe) == address(0)){
802             antiSnipe = AntiSnipe(address(this));
803         }
804         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
805         tradingEnabled = true;
806         launch = block.timestamp;
807     }
808 
809     function sweepContingency() external onlyOwner {
810         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
811         payable(owner()).transfer(address(this).balance);
812     }
813 
814     struct ExtraValues {
815         uint256 tTransferAmount;
816         uint256 tFee;
817         uint256 tSwap;
818 
819         uint256 rTransferAmount;
820         uint256 rAmount;
821         uint256 rFee;
822     }
823 
824     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
825         if (!_hasLiqBeenAdded) {
826             _checkLiquidityAdd(from, to);
827             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
828                 revert("Only owner can transfer at this time.");
829             }
830         }
831 
832         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
833 
834         _rOwned[from] = _rOwned[from] - values.rAmount;
835         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
836 
837         if (_isExcluded[from]) {
838             _tOwned[from] = _tOwned[from] - tAmount;
839         }
840         if (_isExcluded[to]) {
841             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
842         }
843 
844         if (values.tSwap > 0) {
845             _rOwned[address(this)] = _rOwned[address(this)] + (values.tSwap * _getRate());
846             if(_isExcluded[address(this)])
847                 _tOwned[address(this)] = _tOwned[address(this)] + values.tSwap;
848             emit Transfer(from, address(this), values.tSwap); // Transparency is the key to success.
849         }
850         if (values.rFee > 0 || values.tFee > 0) {
851             _rTotal -= values.rFee;
852         }
853 
854 
855         emit Transfer(from, to, values.tTransferAmount);
856         return true;
857     }
858 
859     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
860         ExtraValues memory values;
861         uint256 currentRate = _getRate();
862 
863         values.rAmount = tAmount * currentRate;
864 
865         if (_hasLimits(from, to)) {
866             bool checked;
867             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
868                 checked = check;
869             } catch {
870                 revert();
871             }
872 
873             if(!checked) {
874                 revert();
875             }
876         }
877 
878         if(takeFee) {
879             if (lpPairs[to]) {
880                 currentTaxes.reflect = _sellTaxes.reflect;
881                 currentTaxes.totalSwap = _sellTaxes.totalSwap;
882             } else if (lpPairs[from]) {
883                 currentTaxes.reflect = _buyTaxes.reflect;
884                 currentTaxes.totalSwap = _buyTaxes.totalSwap;
885             } else {
886                 currentTaxes.reflect = _transferTaxes.reflect;
887                 currentTaxes.totalSwap = _transferTaxes.totalSwap;
888             }
889 
890             values.tFee = (tAmount * currentTaxes.reflect) / staticVals.masterTaxDivisor;
891             values.tSwap = (tAmount * currentTaxes.totalSwap) / staticVals.masterTaxDivisor;
892             values.tTransferAmount = tAmount - (values.tFee + values.tSwap);
893 
894             values.rFee = values.tFee * currentRate;
895         } else {
896             values.tFee = 0;
897             values.tSwap = 0;
898             values.tTransferAmount = tAmount;
899 
900             values.rFee = 0;
901         }
902         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * currentRate));
903         return values;
904     }
905 
906     function _getRate() internal view returns(uint256) {
907         uint256 rSupply = _rTotal;
908         uint256 tSupply = _tTotal;
909         for (uint8 i = 0; i < _excluded.length; i++) {
910             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
911             rSupply = rSupply - _rOwned[_excluded[i]];
912             tSupply = tSupply - _tOwned[_excluded[i]];
913         }
914         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
915         return rSupply / tSupply;
916     }
917 }