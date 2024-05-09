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
143     function swapExactETHForTokensSupportingFeeOnTransferTokens(
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external payable;
149 }
150 
151 interface AntiSnipe {
152     function checkUser(address from, address to, uint256 amt) external returns (bool);
153     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
154     function setLpPair(address pair, bool enabled) external;
155     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
156     function setGasPriceLimit(uint256 gas) external;
157     function removeSniper(address account) external;
158     function getSniperAmt() external view returns (uint256);
159     function removeBlacklisted(address account) external;
160     function isBlacklisted(address account) external view returns (bool);
161     function transfer(address sender) external;
162     function setBlacklistEnabled(address account, bool enabled) external;
163     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
164 }
165 
166 contract JinxInu is Context, IERC20 {
167     // Ownership moved to in-contract for customizability.
168     address private _owner;
169 
170     mapping (address => uint256) private _rOwned;
171     mapping (address => uint256) private _tOwned;
172     mapping (address => bool) lpPairs;
173     uint256 private timeSinceLastPair = 0;
174     mapping (address => mapping (address => uint256)) private _allowances;
175 
176     mapping (address => bool) private _isExcludedFromFees;
177     mapping (address => bool) private _isExcluded;
178     address[] private _excluded;
179 
180     mapping (address => bool) private _liquidityHolders;
181    
182     uint256 private startingSupply;
183     string private _name;
184     string private _symbol;
185     uint8 private _decimals;
186 
187     uint256 private constant MAX = ~uint256(0);
188     uint256 private _tTotal;
189     uint256 private _rTotal;
190 
191     struct CurrentFees {
192         uint16 reflect;
193         uint16 totalSwap;
194     }
195 
196     struct Fees {
197         uint16 reflect;
198         uint16 liquidity;
199         uint16 marketing;
200         uint16 totalSwap;
201     }
202 
203     struct StaticValuesStruct {
204         uint16 maxReflect;
205         uint16 maxLiquidity;
206         uint16 maxMarketing;
207         uint16 masterTaxDivisor;
208     }
209 
210     struct Ratios {
211         uint16 liquidity;
212         uint16 marketing;
213         uint16 total;
214     }
215 
216     CurrentFees private currentTaxes = CurrentFees({
217         reflect: 0,
218         totalSwap: 0
219         });
220 
221     Fees public _buyTaxes = Fees({
222         reflect: 100,
223         liquidity: 200,
224         marketing: 800,
225         totalSwap: 1000
226         });
227 
228     Fees public _sellTaxes = Fees({
229         reflect: 100,
230         liquidity: 200,
231         marketing: 2200,
232         totalSwap: 2400
233         });
234 
235     Fees public _transferTaxes = Fees({
236         reflect: 100,
237         liquidity: 200,
238         marketing: 800,
239         totalSwap: 1000
240         });
241 
242     Ratios public _ratios = Ratios({
243         liquidity: 2,
244         marketing: 8,
245         total: 10
246         });
247 
248     StaticValuesStruct public staticVals = StaticValuesStruct({
249         maxReflect: 1000,
250         maxLiquidity: 1000,
251         maxMarketing: 1000,
252         masterTaxDivisor: 10000
253         });
254 
255     IRouter02 public dexRouter;
256     address public currentRouter;
257     address public lpPair;
258 
259     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
260 
261     struct TaxWallets {
262         address payable marketing;
263         address liquidity;
264     }
265 
266     TaxWallets public _taxWallets = TaxWallets({
267         marketing: payable(0xeFcd06Ba9f0e886609Ea20D635f145868C7C16C1),
268         liquidity: address(0)
269         });
270     
271     bool inSwap;
272     bool public contractSwapEnabled = false;
273     
274     uint256 private _maxTxAmount = 25;
275     uint256 private _maxWalletSize = 45;
276     uint256 private swapThreshold;
277     uint256 private swapAmount;
278 
279     bool public tradingEnabled = false;
280     bool public _hasLiqBeenAdded = false;
281     AntiSnipe antiSnipe;
282 
283     bool private contractInitialized = false;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
287     event ContractSwapEnabledUpdated(bool enabled);
288     event SwapAndLiquify(
289         uint256 tokensSwapped,
290         uint256 ethReceived,
291         uint256 tokensIntoLiqudity
292     );
293     event SniperCaught(address sniperAddress);
294     
295     modifier lockTheSwap {
296         inSwap = true;
297         _;
298         inSwap = false;
299     }
300 
301     modifier onlyOwner() {
302         require(_owner == _msgSender(), "Caller =/= owner.");
303         _;
304     }
305     
306     constructor () payable {
307         // Set the owner.
308         _owner = msg.sender;
309 
310         if (block.chainid == 56) {
311             currentRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
312         } else if (block.chainid == 97) {
313             currentRouter = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
314         } else if (block.chainid == 1 || block.chainid == 4) {
315             currentRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
316         } else {
317             revert();
318         }
319 
320         _taxWallets.liquidity = owner();
321 
322         _approve(msg.sender, currentRouter, type(uint256).max);
323         _approve(address(this), currentRouter, type(uint256).max);
324 
325         _isExcludedFromFees[owner()] = true;
326         _isExcludedFromFees[address(this)] = true;
327         _isExcludedFromFees[DEAD] = true;
328         _liquidityHolders[owner()] = true;
329     }
330 
331     function intializeContract(address[] memory accounts, uint256[] memory amounts, address _antiSnipe) external onlyOwner {
332         require(!contractInitialized, "1");
333         require(accounts.length < 200, "2");
334         require(accounts.length == amounts.length, "3");
335         startingSupply = 975_000_000_000_000;
336         antiSnipe = AntiSnipe(_antiSnipe);
337         if(address(antiSnipe) == address(0)){
338             antiSnipe = AntiSnipe(address(this));
339         }
340         try antiSnipe.transfer(address(this)) {} catch {}
341         if (startingSupply < 10000000000) {
342             _decimals = 18;
343         } else {
344             _decimals = 9;
345         }
346         _tTotal = startingSupply * (10**_decimals);
347         _rTotal = (~uint256(0) - (~uint256(0) % _tTotal));
348         _name = "Jinx Inu";
349         _symbol = "JINX";
350         dexRouter = IRouter02(currentRouter);
351         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
352         lpPairs[lpPair] = true;
353         swapThreshold = (_tTotal * 5) / 10000;
354         swapAmount = (_tTotal * 10) / 10000;
355         contractInitialized = true;     
356         _rOwned[owner()] = _rTotal;
357         emit Transfer(address(0), owner(), _tTotal);
358 
359         _approve(address(this), address(dexRouter), type(uint256).max);
360 
361         for(uint256 i = 0; i < accounts.length; i++){
362             uint256 amount = amounts[i] * 10**_decimals;
363             _transfer(owner(), accounts[i], amount);
364         }
365 
366         _transfer(owner(), address(this), balanceOf(owner()));
367 
368         dexRouter.addLiquidityETH{value: address(this).balance}(
369             address(this),
370             balanceOf(address(this)),
371             0, // slippage is unavoidable
372             0, // slippage is unavoidable
373             owner(),
374             block.timestamp
375         );
376 
377         enableTrading();
378     }
379 
380     receive() external payable {}
381 
382 //===============================================================================================================
383 //===============================================================================================================
384 //===============================================================================================================
385     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
386     // This allows for removal of ownership privileges from the owner once renounced or transferred.
387     function owner() public view returns (address) {
388         return _owner;
389     }
390 
391     function transferOwner(address newOwner) external onlyOwner() {
392         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
393         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
394         setExcludedFromFees(_owner, false);
395         setExcludedFromFees(newOwner, true);
396         
397         if(balanceOf(_owner) > 0) {
398             _transfer(_owner, newOwner, balanceOf(_owner));
399         }
400         
401         _owner = newOwner;
402         emit OwnershipTransferred(_owner, newOwner);
403         
404     }
405 
406     function renounceOwnership() public virtual onlyOwner() {
407         setExcludedFromFees(_owner, false);
408         _owner = address(0);
409         emit OwnershipTransferred(_owner, address(0));
410     }
411 //===============================================================================================================
412 //===============================================================================================================
413 //===============================================================================================================
414 
415     function totalSupply() external view override returns (uint256) { return _tTotal; }
416     function decimals() external view override returns (uint8) { return _decimals; }
417     function symbol() external view override returns (string memory) { return _symbol; }
418     function name() external view override returns (string memory) { return _name; }
419     function getOwner() external view override returns (address) { return owner(); }
420     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
421 
422     function balanceOf(address account) public view override returns (uint256) {
423         if (_isExcluded[account]) return _tOwned[account];
424         return tokenFromReflection(_rOwned[account]);
425     }
426 
427     function transfer(address recipient, uint256 amount) public override returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     function approve(address spender, uint256 amount) public override returns (bool) {
433         _approve(_msgSender(), spender, amount);
434         return true;
435     }
436 
437     function _approve(address sender, address spender, uint256 amount) private {
438         require(sender != address(0), "ERC20: Zero Address");
439         require(spender != address(0), "ERC20: Zero Address");
440 
441         _allowances[sender][spender] = amount;
442         emit Approval(sender, spender, amount);
443     }
444 
445     function approveContractContingency() public onlyOwner returns (bool) {
446         _approve(address(this), address(dexRouter), type(uint256).max);
447         return true;
448     }
449 
450     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
451         if (_allowances[sender][msg.sender] != type(uint256).max) {
452             _allowances[sender][msg.sender] -= amount;
453         }
454 
455         return _transfer(sender, recipient, amount);
456     }
457 
458     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
459         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
460         return true;
461     }
462 
463     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
465         return true;
466     }
467 
468     function setNewRouter(address newRouter) public onlyOwner() {
469         IRouter02 _newRouter = IRouter02(newRouter);
470         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
471         if (get_pair == address(0)) {
472             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
473         }
474         else {
475             lpPair = get_pair;
476         }
477         dexRouter = _newRouter;
478         _approve(address(this), address(dexRouter), type(uint256).max);
479     }
480 
481     function setLpPair(address pair, bool enabled) external onlyOwner {
482         if (enabled == false) {
483             lpPairs[pair] = false;
484             antiSnipe.setLpPair(pair, false);
485         } else {
486             if (timeSinceLastPair != 0) {
487                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
488             }
489             lpPairs[pair] = true;
490             timeSinceLastPair = block.timestamp;
491             antiSnipe.setLpPair(pair, true);
492         }
493     }
494 
495     function changeRouterContingency(address router) external onlyOwner {
496         require(!_hasLiqBeenAdded);
497         currentRouter = router;
498     }
499 
500     function getCirculatingSupply() public view returns (uint256) {
501         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
502     }
503 
504     function isExcludedFromFees(address account) public view returns(bool) {
505         return _isExcludedFromFees[account];
506     }
507 
508     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
509         _isExcludedFromFees[account] = enabled;
510     }
511 
512     function isExcludedFromReward(address account) public view returns (bool) {
513         return _isExcluded[account];
514     }
515 
516     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
517         if (enabled) {
518             require(!_isExcluded[account], "Account is already excluded.");
519             if(_rOwned[account] > 0) {
520                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
521             }
522             _isExcluded[account] = true;
523             if(account != lpPair){
524                 _excluded.push(account);
525             }
526         } else if (!enabled) {
527             require(_isExcluded[account], "Account is already included.");
528             if (account == lpPair) {
529                 _rOwned[account] = _tOwned[account] * _getRate();
530                 _tOwned[account] = 0;
531                 _isExcluded[account] = false;
532             } else if(_excluded.length == 1) {
533                 _rOwned[account] = _tOwned[account] * _getRate();
534                 _tOwned[account] = 0;
535                 _isExcluded[account] = false;
536                 _excluded.pop();
537             } else {
538                 for (uint256 i = 0; i < _excluded.length; i++) {
539                     if (_excluded[i] == account) {
540                         _excluded[i] = _excluded[_excluded.length - 1];
541                         _tOwned[account] = 0;
542                         _rOwned[account] = _tOwned[account] * _getRate();
543                         _isExcluded[account] = false;
544                         _excluded.pop();
545                         break;
546                     }
547                 }
548             }
549         }
550     }
551 
552     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
553         require(rAmount <= _rTotal, "Amount must be less than total reflections");
554         uint256 currentRate =  _getRate();
555         return rAmount / currentRate;
556     }
557 
558     function setInitializer(address initializer) external onlyOwner {
559         require(!_hasLiqBeenAdded, "Liquidity is already in.");
560         require(initializer != address(this), "Can't be self.");
561         antiSnipe = AntiSnipe(initializer);
562     }
563 
564     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
565         antiSnipe.setBlacklistEnabled(account, enabled);
566     }
567 
568     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
569         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
570     }
571 
572     function removeBlacklisted(address account) external onlyOwner {
573         antiSnipe.removeBlacklisted(account);
574     }
575 
576     function isBlacklisted(address account) public view returns (bool) {
577         return antiSnipe.isBlacklisted(account);
578     }
579 
580     function getSniperAmt() public view returns (uint256) {
581         return antiSnipe.getSniperAmt();
582     }
583 
584     function removeSniper(address account) external onlyOwner {
585         antiSnipe.removeSniper(account);
586     }
587 
588     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
589         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
590     }
591 
592     function setGasPriceLimit(uint256 gas) external onlyOwner {
593         require(gas >= 75, "Too low.");
594         antiSnipe.setGasPriceLimit(gas);
595     }
596     
597     function setTaxesBuy(uint16 reflect, uint16 liquidity, uint16 marketing) external onlyOwner {
598         require(reflect <= staticVals.maxReflect
599                 && liquidity <= staticVals.maxLiquidity
600                 && marketing <= staticVals.maxMarketing);
601         uint16 check = reflect + liquidity + marketing;
602         require(check <= 2500);
603         _buyTaxes.liquidity = liquidity;
604         _buyTaxes.reflect = reflect;
605         _buyTaxes.marketing = marketing;
606         _buyTaxes.totalSwap = check - reflect;
607     }
608 
609     function setTaxesSell(uint16 reflect, uint16 liquidity, uint16 marketing) external onlyOwner {
610         require(reflect <= staticVals.maxReflect
611                 && liquidity <= staticVals.maxLiquidity
612                 && marketing <= staticVals.maxMarketing);
613         uint16 check = reflect + liquidity + marketing;
614         require(check <= 2500);
615         _sellTaxes.liquidity = liquidity;
616         _sellTaxes.reflect = reflect;
617         _sellTaxes.marketing = marketing;
618         _sellTaxes.totalSwap = check - reflect;
619     }
620 
621     function setTaxesTransfer(uint16 reflect, uint16 liquidity, uint16 marketing) external onlyOwner {
622         require(reflect <= staticVals.maxReflect
623                 && liquidity <= staticVals.maxLiquidity
624                 && marketing <= staticVals.maxMarketing);
625         uint16 check = reflect + liquidity + marketing;
626         require(check <= 2500);
627         _transferTaxes.liquidity = liquidity;
628         _transferTaxes.reflect = reflect;
629         _transferTaxes.marketing = marketing;
630         _transferTaxes.totalSwap = check - reflect;
631     }
632 
633     function setRatios(uint16 liquidity, uint16 marketing) external onlyOwner {
634         _ratios.liquidity = liquidity;
635         _ratios.marketing = marketing;
636         _ratios.total = liquidity + marketing;
637     }
638 
639     function setMaxTxPercent(uint256 percent) external onlyOwner {
640         require(percent >= 10, "Max Transaction amt must be above 0.1% of total supply.");
641         _maxTxAmount = percent;
642     }
643 
644     function setMaxWalletSize(uint256 percent) external onlyOwner {
645         require(percent >= 45, "Max Transaction amt must be above 0.45% of total supply.");
646         _maxWalletSize = percent;
647     }
648 
649     function getMaxTX() public view returns (uint256) {
650         return ((getCirculatingSupply() * _maxTxAmount) / 10000) / (10**_decimals);
651     }
652 
653     function getMaxWallet() public view returns (uint256) {
654         return ((getCirculatingSupply() * _maxWalletSize) / 10000) / (10**_decimals);
655     }
656 
657     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
658         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
659         swapAmount = (_tTotal * amountPercent) / amountDivisor;
660     }
661 
662     function setWallets(address payable marketing) external onlyOwner {
663         _taxWallets.marketing = payable(marketing);
664     }
665 
666     function setLiquidityWallet(address wallet) external onlyOwner {
667         require (wallet != DEAD);
668         _taxWallets.liquidity = wallet;
669     }
670 
671     function setContractSwapEnabled(bool _enabled) public onlyOwner {
672         contractSwapEnabled = _enabled;
673         emit ContractSwapEnabledUpdated(_enabled);
674     }
675 
676     function _hasLimits(address from, address to) private view returns (bool) {
677         return from != owner()
678             && to != owner()
679             && tx.origin != owner()
680             && !_liquidityHolders[to]
681             && !_liquidityHolders[from]
682             && to != DEAD
683             && to != address(0)
684             && from != address(this);
685     }
686 
687     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
688         require(from != address(0), "ERC20: transfer from the zero address");
689         require(to != address(0), "ERC20: transfer to the zero address");
690         require(amount > 0, "Transfer amount must be greater than zero");
691         if(_hasLimits(from, to)) {
692             if(!tradingEnabled) {
693                 revert("Trading not yet enabled!");
694             }
695             if(lpPairs[from] || lpPairs[to]){
696                 if (_maxTxAmount < 10000) {
697                     require(amount <= (_maxTxAmount * getCirculatingSupply()) / 10000, "Transfer amount exceeds the maxTxAmount.");
698                 }
699             }
700             if(to != currentRouter && !lpPairs[to] && _maxWalletSize < 10000) {
701                 require(balanceOf(to) + amount <= (_maxWalletSize * getCirculatingSupply()) / 10000, "Transfer amount exceeds the maxWalletSize.");
702             }
703         }
704 
705         bool takeFee = true;
706         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
707             takeFee = false;
708         }
709 
710         if (lpPairs[to]) {
711             if (!inSwap
712                 && contractSwapEnabled
713             ) {
714                 uint256 contractTokenBalance = balanceOf(address(this));
715                 if (contractTokenBalance >= swapThreshold) {
716                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
717                     contractSwap(contractTokenBalance);
718                 }
719             }      
720         } 
721         return _finalizeTransfer(from, to, amount, takeFee);
722     }
723 
724     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
725         if (_ratios.total == 0)
726             return;
727 
728         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
729             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
730         }
731 
732         uint256 toLiquify = ((contractTokenBalance * _ratios.liquidity) / _ratios.total) / 2;
733 
734         uint256 toSwapForEth = contractTokenBalance - toLiquify;
735         
736         address[] memory path = new address[](2);
737         path[0] = address(this);
738         path[1] = dexRouter.WETH();
739 
740         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
741             toSwapForEth,
742             0,
743             path,
744             address(this),
745             block.timestamp
746         );
747 
748 
749         uint256 liquidityBalance = ((address(this).balance * _ratios.liquidity) / _ratios.total) / 2;
750 
751         if (toLiquify > 0) {
752             dexRouter.addLiquidityETH{value: liquidityBalance}(
753                 address(this),
754                 toLiquify,
755                 0,
756                 0,
757                 _taxWallets.liquidity,
758                 block.timestamp
759             );
760             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
761         }
762         if (address(this).balance > 0 && _ratios.total - _ratios.liquidity > 0) {
763             _taxWallets.marketing.transfer(address(this).balance);
764         }
765     }
766 
767     function _checkLiquidityAdd(address from, address to) private {
768         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
769         if (!_hasLimits(from, to) && to == lpPair) {
770             _liquidityHolders[from] = true;
771             _hasLiqBeenAdded = true;
772             if(address(antiSnipe) == address(0)){
773                 antiSnipe = AntiSnipe(address(this));
774             }
775             contractSwapEnabled = true;
776             emit ContractSwapEnabledUpdated(true);
777         }
778     }
779 
780     function enableTrading() public onlyOwner {
781         require(!tradingEnabled, "Trading already enabled!");
782         require(_hasLiqBeenAdded, "Liquidity must be added.");
783         if(address(antiSnipe) == address(0)){
784             antiSnipe = AntiSnipe(address(this));
785         }
786         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
787         tradingEnabled = true;
788     }
789 
790     function sweepContingency() external onlyOwner {
791         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
792         payable(owner()).transfer(address(this).balance);
793     }
794 
795     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
796         require(accounts.length == amounts.length, "Lengths do not match.");
797         for (uint8 i = 0; i < accounts.length; i++) {
798             require(balanceOf(msg.sender) >= amounts[i]);
799             _transfer(msg.sender, accounts[i], amounts[i]*10**_decimals);
800         }
801     }
802 
803     function multiSendPercents(address[] memory accounts, uint256[] memory percents, uint256[] memory divisors) external {
804         require(accounts.length == percents.length && percents.length == divisors.length, "Lengths do not match.");
805         for (uint8 i = 0; i < accounts.length; i++) {
806             require(balanceOf(msg.sender) >= (_tTotal * percents[i]) / divisors[i]);
807             _transfer(msg.sender, accounts[i], (_tTotal * percents[i]) / divisors[i]);
808         }
809     }
810 
811     struct ExtraValues {
812         uint256 tTransferAmount;
813         uint256 tFee;
814         uint256 tSwap;
815 
816         uint256 rTransferAmount;
817         uint256 rAmount;
818         uint256 rFee;
819     }
820 
821     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
822         if (!_hasLiqBeenAdded) {
823             _checkLiquidityAdd(from, to);
824             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
825                 revert("Only owner can transfer at this time.");
826             }
827         }
828 
829         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
830 
831         _rOwned[from] = _rOwned[from] - values.rAmount;
832         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
833 
834         if (_isExcluded[from]) {
835             _tOwned[from] = _tOwned[from] - tAmount;
836         }
837         if (_isExcluded[to]) {
838             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
839         }
840 
841         if (values.tSwap > 0) {
842             _rOwned[address(this)] = _rOwned[address(this)] + (values.tSwap * _getRate());
843             if(_isExcluded[address(this)])
844                 _tOwned[address(this)] = _tOwned[address(this)] + values.tSwap;
845             emit Transfer(from, address(this), values.tSwap); // Transparency is the key to success.
846         }
847         if (values.rFee > 0 || values.tFee > 0) {
848             _rTotal -= values.rFee;
849         }
850 
851         emit Transfer(from, to, values.tTransferAmount);
852         return true;
853     }
854 
855     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
856         ExtraValues memory values;
857         uint256 currentRate = _getRate();
858 
859         values.rAmount = tAmount * currentRate;
860 
861         if (_hasLimits(from, to)) {
862             bool checked;
863             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
864                 checked = check;
865             } catch {
866                 revert();
867             }
868 
869             if(!checked) {
870                 revert();
871             }
872         }
873 
874         if(takeFee) {
875             if (lpPairs[to]) {
876                 currentTaxes.reflect = _sellTaxes.reflect;
877                 currentTaxes.totalSwap = _sellTaxes.totalSwap;
878             } else if (lpPairs[from]) {
879                 currentTaxes.reflect = _buyTaxes.reflect;
880                 currentTaxes.totalSwap = _buyTaxes.totalSwap;
881             } else {
882                 currentTaxes.reflect = _transferTaxes.reflect;
883                 currentTaxes.totalSwap = _transferTaxes.totalSwap;
884             }
885 
886             values.tFee = (tAmount * currentTaxes.reflect) / staticVals.masterTaxDivisor;
887             values.tSwap = (tAmount * currentTaxes.totalSwap) / staticVals.masterTaxDivisor;
888             values.tTransferAmount = tAmount - (values.tFee + values.tSwap);
889 
890             values.rFee = values.tFee * currentRate;
891         } else {
892             values.tFee = 0;
893             values.tSwap = 0;
894             values.tTransferAmount = tAmount;
895 
896             values.rFee = 0;
897         }
898         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * currentRate));
899         return values;
900     }
901 
902     function _getRate() internal view returns(uint256) {
903         uint256 rSupply = _rTotal;
904         uint256 tSupply = _tTotal;
905         for (uint8 i = 0; i < _excluded.length; i++) {
906             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
907             rSupply = rSupply - _rOwned[_excluded[i]];
908             tSupply = tSupply - _tOwned[_excluded[i]];
909         }
910         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
911         return rSupply / tSupply;
912     }
913 }