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
158     function setPrivateLockEnabled(bool enabled) external;
159 }
160 
161 contract LunaFox is Context, IERC20 {
162     // Ownership moved to in-contract for customizability.
163     address private _owner;
164 
165     mapping (address => uint256) private _rOwned;
166     mapping (address => uint256) private _tOwned;
167     mapping (address => bool) lpPairs;
168     uint256 private timeSinceLastPair = 0;
169     mapping (address => mapping (address => uint256)) private _allowances;
170 
171     mapping (address => bool) private _isExcludedFromFees;
172     mapping (address => bool) private _isExcluded;
173     address[] private _excluded;
174 
175     mapping (address => bool) private _liquidityHolders;
176    
177     uint256 private startingSupply;
178     string private _name;
179     string private _symbol;
180     uint8 private _decimals;
181 
182     uint256 private _tTotal;
183     uint256 private _rTotal;
184 
185     struct CurrentFees {
186         uint16 reflect;
187         uint16 totalSwap;
188     }
189 
190     struct Fees {
191         uint16 reflect;
192         uint16 liquidity;
193         uint16 marketing;
194         uint16 totalSwap;
195     }
196 
197     struct Ratios {
198         uint16 liquidity;
199         uint16 marketing;
200         uint16 total;
201     }
202 
203     CurrentFees private currentTaxes = CurrentFees({
204         reflect: 0,
205         totalSwap: 0
206         });
207 
208     Fees public _buyTaxes = Fees({
209         reflect: 300,
210         liquidity: 200,
211         marketing: 600,
212         totalSwap: 800
213         });
214 
215     Fees public _sellTaxes = Fees({
216         reflect: 300,
217         liquidity: 200,
218         marketing: 600,
219         totalSwap: 800
220         });
221 
222     Fees public _transferTaxes = Fees({
223         reflect: 300,
224         liquidity: 200,
225         marketing: 600,
226         totalSwap: 800
227         });
228 
229     Ratios public _ratios = Ratios({
230         liquidity: 2,
231         marketing: 6,
232         total: 8
233         });
234 
235     uint256 public masterTaxDivisor = 10000;
236 
237     IRouter02 public dexRouter;
238     address public lpPair;
239 
240     address public currentRouter;
241     // PCS ROUTER
242     address private pcsV2Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
243     // UNI ROUTER
244     address private uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
245 
246     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
247 
248     struct TaxWallets {
249         address payable marketing;
250     }
251 
252     TaxWallets public _taxWallets = TaxWallets({
253         marketing: payable(0xa64B8f991863f373CdA9cC6A682c312346b7c849)
254         });
255     
256     bool inSwap;
257     bool public contractSwapEnabled = false;
258 
259     uint256 private swapThreshold;
260     uint256 private swapAmount;
261 
262     bool public tradingEnabled = false;
263     bool public _hasLiqBeenAdded = false;
264 
265     AntiSnipe antiSnipe;
266     uint256 public launch;
267     bool contractInitialized = false;
268 
269     address[] path;
270 
271     uint256 public maxEthBuy = 5 * 10**17;
272     uint256 public maxEthSell = 1 * 10**18;
273     bool public timedLimitsEnabled = true;
274     bool public maxEthTradesEnabled = true;
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
278     event ContractSwapEnabledUpdated(bool enabled);
279     event SwapAndLiquify(
280         uint256 tokensSwapped,
281         uint256 ethReceived,
282         uint256 tokensIntoLiqudity
283     );
284     event SniperCaught(address sniperAddress);
285     
286     modifier lockTheSwap {
287         inSwap = true;
288         _;
289         inSwap = false;
290     }
291 
292     modifier onlyOwner() {
293         require(_owner == _msgSender(), "Caller =/= owner.");
294         _;
295     }
296     
297     constructor () payable {
298         // Set the owner.
299         _owner = msg.sender;
300 
301         if (block.chainid == 56 || block.chainid == 97) {
302             currentRouter = pcsV2Router;
303         } else if (block.chainid == 1) {
304             currentRouter = uniswapV2Router;
305         }
306 
307         _approve(msg.sender, currentRouter, type(uint256).max);
308         _approve(address(this), currentRouter, type(uint256).max);
309 
310         _isExcludedFromFees[owner()] = true;
311         _isExcludedFromFees[address(this)] = true;
312         _isExcludedFromFees[DEAD] = true;
313         _liquidityHolders[owner()] = true;
314     }
315 
316     function intializeContract(address[] memory accounts, uint256[] memory amounts, uint256[] memory amountsD, address _antiSnipe) external onlyOwner {
317         require(!contractInitialized, "1");
318         require(accounts.length < 100, "2");
319         require(accounts.length == amounts.length, "3");
320         require(amounts.length == amountsD.length, "4");
321         startingSupply = 69_000_000_000_000_000_000_000;
322         antiSnipe = AntiSnipe(_antiSnipe);
323         if(address(antiSnipe) == address(0)){
324             antiSnipe = AntiSnipe(address(this));
325         }
326         try antiSnipe.transfer(address(this)) {} catch {}
327         if (startingSupply < 10000000000) {
328             _decimals = 18;
329         } else {
330             _decimals = 9;
331         }
332         _tTotal = startingSupply * (10**_decimals);
333         _rTotal = (~uint256(0) - (~uint256(0) % _tTotal));
334         _name = "LunaFox";
335         _symbol = "LUFX";
336         dexRouter = IRouter02(currentRouter);
337         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
338         lpPairs[lpPair] = true;        
339         path = new address[](2);
340         path[0] = address(this);
341         path[1] = dexRouter.WETH();
342         swapThreshold = (_tTotal * 5) / 10000;
343         swapAmount = (_tTotal * 25) / 10000;
344         contractInitialized = true;     
345         _rOwned[owner()] = _rTotal;
346         emit Transfer(address(0), owner(), _tTotal);
347 
348         _approve(address(this), address(dexRouter), type(uint256).max);
349 
350         for(uint256 i = 0; i < accounts.length; i++){
351             uint256 amount = (_tTotal*amounts[i]) / amountsD[i];
352             _transfer(owner(), accounts[i], amount);
353         }
354 
355         _transfer(owner(), address(this), balanceOf(owner()));
356 
357         dexRouter.addLiquidityETH{value: address(this).balance}(
358             address(this),
359             balanceOf(address(this)),
360             0, // slippage is unavoidable
361             0, // slippage is unavoidable
362             owner(),
363             block.timestamp
364         );
365 
366         enableTrading();
367     }
368 
369     receive() external payable {}
370 
371 //===============================================================================================================
372 //===============================================================================================================
373 //===============================================================================================================
374     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
375     // This allows for removal of ownership privileges from the owner once renounced or transferred.
376     function owner() public view returns (address) {
377         return _owner;
378     }
379 
380     function transferOwner(address newOwner) external onlyOwner() {
381         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
382         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
383         setExcludedFromFees(_owner, false);
384         setExcludedFromFees(newOwner, true);
385         
386         if(balanceOf(_owner) > 0) {
387             _transfer(_owner, newOwner, balanceOf(_owner));
388         }
389         
390         _owner = newOwner;
391         emit OwnershipTransferred(_owner, newOwner);
392         
393     }
394 
395     function renounceOwnership() public virtual onlyOwner() {
396         setExcludedFromFees(_owner, false);
397         _owner = address(0);
398         emit OwnershipTransferred(_owner, address(0));
399     }
400 //===============================================================================================================
401 //===============================================================================================================
402 //===============================================================================================================
403 
404     function totalSupply() external view override returns (uint256) {
405         if (_tTotal == 0) {
406             revert();
407         }
408         return _tTotal; 
409     }
410     function decimals() external view override returns (uint8) { return _decimals; }
411     function symbol() external view override returns (string memory) { return _symbol; }
412     function name() external view override returns (string memory) { return _name; }
413     function getOwner() external view override returns (address) { return owner(); }
414     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
415 
416     function balanceOf(address account) public view override returns (uint256) {
417         if (_isExcluded[account]) return _tOwned[account];
418         return tokenFromReflection(_rOwned[account]);
419     }
420 
421     function transfer(address recipient, uint256 amount) public override returns (bool) {
422         _transfer(_msgSender(), recipient, amount);
423         return true;
424     }
425 
426     function approve(address spender, uint256 amount) public override returns (bool) {
427         _approve(_msgSender(), spender, amount);
428         return true;
429     }
430 
431     function _approve(address sender, address spender, uint256 amount) private {
432         require(sender != address(0), "ERC20: Zero Address");
433         require(spender != address(0), "ERC20: Zero Address");
434 
435         _allowances[sender][spender] = amount;
436         emit Approval(sender, spender, amount);
437     }
438 
439     function approveContractContingency() public onlyOwner returns (bool) {
440         _approve(address(this), address(dexRouter), type(uint256).max);
441         return true;
442     }
443 
444     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
445         if (_allowances[sender][msg.sender] != type(uint256).max) {
446             _allowances[sender][msg.sender] -= amount;
447         }
448 
449         return _transfer(sender, recipient, amount);
450     }
451 
452     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
453         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
454         return true;
455     }
456 
457     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
458         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
459         return true;
460     }
461 
462     function setNewRouter(address newRouter) public onlyOwner() {
463         IRouter02 _newRouter = IRouter02(newRouter);
464         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
465         if (get_pair == address(0)) {
466             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
467         }
468         else {
469             lpPair = get_pair;
470         }
471         dexRouter = _newRouter;
472         _approve(address(this), address(dexRouter), type(uint256).max);
473     }
474 
475     function setLpPair(address pair, bool enabled) external onlyOwner {
476         if (enabled == false) {
477             lpPairs[pair] = false;
478             antiSnipe.setLpPair(pair, false);
479         } else {
480             if (timeSinceLastPair != 0) {
481                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
482             }
483             lpPairs[pair] = true;
484             timeSinceLastPair = block.timestamp;
485             antiSnipe.setLpPair(pair, true);
486         }
487     }
488 
489     function changeRouterContingency(address router) external onlyOwner {
490         require(!_hasLiqBeenAdded);
491         currentRouter = router;
492     }
493 
494     function getCirculatingSupply() public view returns (uint256) {
495         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
496     }
497 
498     function isExcludedFromFees(address account) public view returns(bool) {
499         return _isExcludedFromFees[account];
500     }
501 
502     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
503         _isExcludedFromFees[account] = enabled;
504     }
505 
506     function isExcludedFromReward(address account) public view returns (bool) {
507         return _isExcluded[account];
508     }
509 
510     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
511         if (enabled == true) {
512             require(!_isExcluded[account], "Account is already excluded.");
513             if(_rOwned[account] > 0) {
514                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
515             }
516             _isExcluded[account] = true;
517             _excluded.push(account);
518         } else if (enabled == false) {
519             require(_isExcluded[account], "Account is already included.");
520             if(_excluded.length == 1){
521                 _tOwned[account] = 0;
522                 _isExcluded[account] = false;
523                 _excluded.pop();
524             } else {
525                 for (uint256 i = 0; i < _excluded.length; i++) {
526                     if (_excluded[i] == account) {
527                         _excluded[i] = _excluded[_excluded.length - 1];
528                         _tOwned[account] = 0;
529                         _isExcluded[account] = false;
530                         _excluded.pop();
531                         break;
532                     }
533                 }
534             }
535         }
536     }
537 
538     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
539         require(rAmount <= _rTotal, "Amount must be less than total reflections");
540         uint256 currentRate =  _getRate();
541         return rAmount / currentRate;
542     }
543 
544     function setInitializer(address initializer) external onlyOwner {
545         require(!_hasLiqBeenAdded, "Liquidity is already in.");
546         require(initializer != address(this), "Can't be self.");
547         antiSnipe = AntiSnipe(initializer);
548     }
549 
550     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
551         antiSnipe.setBlacklistEnabled(account, enabled);
552     }
553 
554     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
555         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
556     }
557 
558     function removeBlacklisted(address account) external onlyOwner {
559         antiSnipe.removeBlacklisted(account);
560     }
561 
562     function isBlacklisted(address account) public view returns (bool) {
563         return antiSnipe.isBlacklisted(account);
564     }
565 
566     function getSniperAmt() public view returns (uint256) {
567         return antiSnipe.getSniperAmt();
568     }
569 
570     function removeSniper(address account) external onlyOwner {
571         antiSnipe.removeSniper(account);
572     }
573 
574     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
575         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
576     }
577 
578     function setPrivateLockEnabled(bool enabled) external onlyOwner {
579         antiSnipe.setPrivateLockEnabled(enabled);
580     }
581 
582     function setGasPriceLimit(uint256 gas) external onlyOwner {
583         require(gas >= 75, "Too low.");
584         antiSnipe.setGasPriceLimit(gas);
585     }
586     
587     function setTaxesBuy(uint16 reflect, uint16 liquidity, uint16 marketing) external onlyOwner {
588         uint16 check = reflect + liquidity + marketing;
589         require(check <= 2000);
590         _buyTaxes.liquidity = liquidity;
591         _buyTaxes.reflect = reflect;
592         _buyTaxes.marketing = marketing;
593         _buyTaxes.totalSwap = check - reflect;
594     }
595 
596     function setTaxesSell(uint16 reflect, uint16 liquidity, uint16 marketing) external onlyOwner {
597         uint16 check = reflect + liquidity + marketing;
598         require(check <= 2000);
599         _sellTaxes.liquidity = liquidity;
600         _sellTaxes.reflect = reflect;
601         _sellTaxes.marketing = marketing;
602         _sellTaxes.totalSwap = check - reflect;
603     }
604 
605     function setTaxesTransfer(uint16 reflect, uint16 liquidity, uint16 marketing) external onlyOwner {
606         uint16 check = reflect + liquidity + marketing;
607         require(check <= 2000);
608         _transferTaxes.liquidity = liquidity;
609         _transferTaxes.reflect = reflect;
610         _transferTaxes.marketing = marketing;
611         _transferTaxes.totalSwap = check - reflect;
612     }
613 
614     function setRatios(uint16 liquidity, uint16 marketing) external onlyOwner {
615         _ratios.liquidity = liquidity;
616         _ratios.marketing = marketing;
617         _ratios.total = liquidity + marketing;
618     }
619 
620     function setEthLimits(uint256 buyVal, uint256 buyMult, uint256 sellVal, uint256 sellMult) external onlyOwner {
621         maxEthBuy = buyVal * 10**buyMult;
622         maxEthSell = sellVal * 10**sellMult;
623         require(maxEthBuy >= 5 * 10**17 && maxEthSell >= 1 * 10**18);
624     }
625 
626     function setEthLimitsEnabled(bool maxEthTrades) external onlyOwner {
627         maxEthTradesEnabled = maxEthTrades;
628     }
629 
630     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
631         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
632         swapAmount = (_tTotal * amountPercent) / amountDivisor;
633     }
634 
635     function setWallets(address payable marketing) external onlyOwner {
636         _taxWallets.marketing = payable(marketing);
637     }
638 
639     function setContractSwapEnabled(bool _enabled) public onlyOwner {
640         contractSwapEnabled = _enabled;
641         emit ContractSwapEnabledUpdated(_enabled);
642     }
643 
644     function _hasLimits(address from, address to) private view returns (bool) {
645         return from != owner()
646             && to != owner()
647             && !_liquidityHolders[to]
648             && !_liquidityHolders[from]
649             && to != DEAD
650             && to != address(0)
651             && from != address(this);
652     }
653 
654     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
655         require(from != address(0), "ERC20: transfer from the zero address");
656         require(to != address(0), "ERC20: transfer to the zero address");
657         require(amount > 0, "Transfer amount must be greater than zero");
658         bool takeFee = true;
659         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
660             takeFee = false;
661         }
662 
663         if(_hasLimits(from, to)) {
664             if(!tradingEnabled) {
665                 revert("Trading not yet enabled!");
666             }
667             uint256 ethBalance = dexRouter.getAmountsOut(amount, path)[1];
668             if (maxEthTradesEnabled) {
669                 if(lpPairs[from]) {
670                     require(ethBalance <= maxEthBuy);
671                 } else if (lpPairs[to]) {
672                     require(ethBalance <= maxEthSell);
673                 }
674             }
675         }
676 
677         if (lpPairs[to]) {
678             if (!inSwap
679                 && contractSwapEnabled
680             ) {
681                 uint256 contractTokenBalance = balanceOf(address(this));
682                 if (contractTokenBalance >= swapThreshold) {
683                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
684                     contractSwap(contractTokenBalance);
685                 }
686             }      
687         } 
688         return _finalizeTransfer(from, to, amount, takeFee);
689     }
690 
691     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
692         if (_ratios.total == 0)
693             return;
694 
695         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
696             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
697         }
698 
699         uint256 toLiquify = ((contractTokenBalance * _ratios.liquidity) / _ratios.total) / 2;
700 
701         uint256 toSwapForEth = contractTokenBalance - toLiquify;
702 
703         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
704             toSwapForEth,
705             0, // accept any amount of ETH
706             path,
707             address(this),
708             block.timestamp
709         );
710 
711         uint256 liquidityBalance = ((address(this).balance * _ratios.liquidity) / _ratios.total) / 2;
712 
713         if (toLiquify > 0) {
714             dexRouter.addLiquidityETH{value: liquidityBalance}(
715                 address(this),
716                 toLiquify,
717                 0, // slippage is unavoidable
718                 0, // slippage is unavoidable
719                 DEAD,
720                 block.timestamp
721             );
722             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
723         }
724         if (address(this).balance > 0 && _ratios.total - _ratios.liquidity > 0) {
725             _taxWallets.marketing.transfer(address(this).balance);
726         }
727     }
728 
729     function _checkLiquidityAdd(address from, address to) private {
730         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
731         if (!_hasLimits(from, to) && to == lpPair) {
732             _liquidityHolders[from] = true;
733             _hasLiqBeenAdded = true;
734             if(address(antiSnipe) == address(0)){
735                 antiSnipe = AntiSnipe(address(this));
736             }
737             contractSwapEnabled = true;
738             emit ContractSwapEnabledUpdated(true);
739         }
740     }
741 
742     function enableTrading() public onlyOwner {
743         require(!tradingEnabled, "Trading already enabled!");
744         require(_hasLiqBeenAdded, "Liquidity must be added.");
745         setExcludedFromReward(address(this), true);
746         setExcludedFromReward(lpPair, true);
747         if(address(antiSnipe) == address(0)){
748             antiSnipe = AntiSnipe(address(this));
749         }
750         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
751         tradingEnabled = true;
752         launch = block.timestamp;
753     }
754 
755     function sweepContingency() external onlyOwner {
756         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
757         payable(owner()).transfer(address(this).balance);
758     }
759 
760     struct ExtraValues {
761         uint256 tTransferAmount;
762         uint256 tFee;
763         uint256 tSwap;
764 
765         uint256 rTransferAmount;
766         uint256 rAmount;
767         uint256 rFee;
768     }
769 
770     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
771         if (!_hasLiqBeenAdded) {
772             _checkLiquidityAdd(from, to);
773             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
774                 revert("Only owner can transfer at this time.");
775             }
776         }
777 
778         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
779 
780         _rOwned[from] = _rOwned[from] - values.rAmount;
781         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
782 
783         if (_isExcluded[from]) {
784             _tOwned[from] = _tOwned[from] - tAmount;
785         }
786         if (_isExcluded[to]) {
787             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
788         }
789 
790         if (values.tSwap > 0) {
791             _rOwned[address(this)] = _rOwned[address(this)] + (values.tSwap * _getRate());
792             if(_isExcluded[address(this)])
793                 _tOwned[address(this)] = _tOwned[address(this)] + values.tSwap;
794             emit Transfer(from, address(this), values.tSwap); // Transparency is the key to success.
795         }
796         if (values.rFee > 0 || values.tFee > 0) {
797             _rTotal -= values.rFee;
798         }
799 
800 
801         emit Transfer(from, to, values.tTransferAmount);
802         return true;
803     }
804 
805     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
806         ExtraValues memory values;
807         uint256 currentRate = _getRate();
808 
809         values.rAmount = tAmount * currentRate;
810 
811         if (_hasLimits(from, to)) {
812             bool checked;
813             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
814                 checked = check;
815             } catch {
816                 revert();
817             }
818 
819             if(!checked) {
820                 revert();
821             }
822         }
823 
824         if(takeFee) {
825             if (lpPairs[to]) {
826                 currentTaxes.reflect = _sellTaxes.reflect;
827                 currentTaxes.totalSwap = _sellTaxes.totalSwap;
828             } else if (lpPairs[from]) {
829                 currentTaxes.reflect = _buyTaxes.reflect;
830                 currentTaxes.totalSwap = _buyTaxes.totalSwap;
831             } else {
832                 currentTaxes.reflect = _transferTaxes.reflect;
833                 currentTaxes.totalSwap = _transferTaxes.totalSwap;
834             }
835 
836             values.tFee = (tAmount * currentTaxes.reflect) / masterTaxDivisor;
837             values.tSwap = (tAmount * currentTaxes.totalSwap) / masterTaxDivisor;
838             values.tTransferAmount = tAmount - (values.tFee + values.tSwap);
839 
840             values.rFee = values.tFee * currentRate;
841         } else {
842             values.tFee = 0;
843             values.tSwap = 0;
844             values.tTransferAmount = tAmount;
845 
846             values.rFee = 0;
847         }
848         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * currentRate));
849         return values;
850     }
851 
852     function _getRate() internal view returns(uint256) {
853         uint256 rSupply = _rTotal;
854         uint256 tSupply = _tTotal;
855         for (uint8 i = 0; i < _excluded.length; i++) {
856             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
857             rSupply = rSupply - _rOwned[_excluded[i]];
858             tSupply = tSupply - _tOwned[_excluded[i]];
859         }
860         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
861         return rSupply / tSupply;
862     }
863 }