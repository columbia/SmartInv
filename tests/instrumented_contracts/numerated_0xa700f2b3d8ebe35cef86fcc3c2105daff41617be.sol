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
74    * https://github.com/ethereum/EIPs/b/u/u/in/u/20#issuecomment-263524729
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
106 interface IUniswapV2Factory {
107     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
108     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
109     function createPair(address tokenA, address tokenB) external returns (address lpPair);
110 }
111 
112 interface IUniswapV2Pair {
113     function factory() external view returns (address);
114     function token0() external view returns (address);
115     function token1() external view returns (address);
116     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
117     function price0CumulativeLast() external view returns (uint);
118     function price1CumulativeLast() external view returns (uint);
119     function kLast() external view returns (uint);
120     function skim(address to) external;
121     function sync() external;
122 }
123 
124 interface IUniswapV2Router01 {
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127     function addLiquidity(
128         address tokenA,
129         address tokenB,
130         uint amountADesired,
131         uint amountBDesired,
132         uint amountAMin,
133         uint amountBMin,
134         address to,
135         uint deadline
136     ) external returns (uint amountA, uint amountB, uint liquidity);
137     function addLiquidityETH(
138         address token,
139         uint amountTokenDesired,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline
144     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
145     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
146     external
147     payable
148     returns (uint[] memory amounts);
149     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
150     external
151     returns (uint[] memory amounts);
152     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
153     external
154     returns (uint[] memory amounts);
155     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
156     external
157     payable
158     returns (uint[] memory amounts);
159 
160     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
161     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
162     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
163     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
164     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
165 }
166 
167 interface IUniswapV2Router02 is IUniswapV2Router01 {
168     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
169         uint amountIn,
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external;
175     function swapExactETHForTokensSupportingFeeOnTransferTokens(
176         uint amountOutMin,
177         address[] calldata path,
178         address to,
179         uint deadline
180     ) external payable;
181     function swapExactTokensForETHSupportingFeeOnTransferTokens(
182         uint amountIn,
183         uint amountOutMin,
184         address[] calldata path,
185         address to,
186         uint deadline
187     ) external;
188 }
189 
190 interface AntiSnipe {
191     function checkUser(address from, address to, uint256 amt) external returns (bool);
192     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp) external;
193     function setLpPair(address pair, bool enabled) external;
194     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
195     function setGasPriceLimit(uint256 gas) external;
196     function removeSniper(address account) external;
197     function getSniperAmt() external view returns (uint256);
198     function isBlacklisted(address account) external view returns (bool);
199     function setBlacklistEnabled(address account, bool enabled) external;
200 }
201 
202 contract BuuInu is Context, IERC20 {
203     // Ownership moved to in-contract for customizability.
204     address private _owner;
205 
206     mapping (address => uint256) private _rOwned;
207     mapping (address => uint256) private _tOwned;
208     mapping (address => bool) lpPairs;
209     uint256 private timeSinceLastPair = 0;
210     mapping (address => mapping (address => uint256)) private _allowances;
211 
212     mapping (address => bool) private _isExcludedFromFees;
213     mapping (address => bool) private _isExcluded;
214     address[] private _excluded;
215 
216     mapping (address => bool) private _liquidityHolders;
217    
218     uint256 private startingSupply;
219     string private _name;
220     string private _symbol;
221 
222     struct FeesStruct {
223         uint16 reflect;
224         uint16 marketing;
225     }
226 
227     struct StaticValuesStruct {
228         uint16 maxReflect;
229         uint16 maxMarketing;
230         uint16 masterTaxDivisor;
231     }
232 
233     FeesStruct private currentTaxes = FeesStruct({
234         reflect: 0,
235         marketing: 0
236         });
237 
238     FeesStruct public _buyTaxes = FeesStruct({
239         reflect: 100,
240         marketing: 600
241         });
242 
243     FeesStruct public _sellTaxes = FeesStruct({
244         reflect: 100,
245         marketing: 600
246         });
247 
248     FeesStruct public _transferTaxes = FeesStruct({
249         reflect: 100,
250         marketing: 600
251         });
252 
253     StaticValuesStruct public staticVals = StaticValuesStruct({
254         maxReflect: 800,
255         maxMarketing: 800,
256         masterTaxDivisor: 10000
257         });
258 
259     uint256 private constant MAX = ~uint256(0);
260     uint8 private _decimals;
261     uint256 private _tTotal;
262     uint256 private _rTotal;
263     uint256 private _tFeeTotal;
264 
265     IUniswapV2Router02 public dexRouter;
266     address public lpPair;
267 
268     // UNI ROUTER
269     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
270 
271     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
272     address payable private _marketingWallet = payable(0x550380c2328FE523E4bc4DEf51e50a2A03524405);
273     
274     bool inSwap;
275     bool public contractSwapEnabled = false;
276     
277     uint256 private _maxTxAmount;
278     uint256 public maxTxAmountUI;
279     uint256 private _maxWalletSize;
280     uint256 public maxWalletSizeUI;
281 
282     uint256 private swapThreshold;
283     uint256 private swapAmount;
284 
285     bool public tradingEnabled = false;
286     bool public _hasLiqBeenAdded = false;
287     AntiSnipe antiSnipe;
288 
289     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
290     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
291     event ContractSwapEnabledUpdated(bool enabled);
292     event SwapAndLiquify(
293         uint256 tokensSwapped,
294         uint256 ethReceived,
295         uint256 tokensIntoLiqudity
296     );
297     event SniperCaught(address sniperAddress);
298     
299     modifier lockTheSwap {
300         inSwap = true;
301         _;
302         inSwap = false;
303     }
304 
305     modifier onlyOwner() {
306         require(_owner == _msgSender(), "Caller =/= owner.");
307         _;
308     }
309     
310     constructor () payable {
311         // Set the owner.
312         _owner = msg.sender;
313 
314         _approve(msg.sender, _routerAddress, type(uint256).max);
315         _approve(address(this), _routerAddress, type(uint256).max);
316 
317         _isExcludedFromFees[owner()] = true;
318         _isExcludedFromFees[address(this)] = true;
319         _isExcludedFromFees[DEAD] = true;
320         _liquidityHolders[owner()] = true;
321     }
322 
323     receive() external payable {}
324 
325     bool contractInitialized = false;
326 
327     function intializeContract(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
328         require(!contractInitialized);
329         require(accounts.length < 50);
330         require(accounts.length == amounts.length);
331         _name = "Buu Inu";
332         _symbol = "BUU";
333         startingSupply = 100_000_000_000;
334         if (startingSupply < 10_000_000_000) {
335             _decimals = 18;
336         } else {
337             _decimals = 9;
338         }
339         _tTotal = startingSupply * (10**_decimals);
340         _rTotal = (MAX - (MAX % _tTotal));
341 
342         dexRouter = IUniswapV2Router02(_routerAddress);
343         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
344         lpPairs[lpPair] = true;
345 
346         maxTxAmountUI = (startingSupply * 3) / 1000;
347         maxWalletSizeUI = (startingSupply * 3) / 100;
348         _maxTxAmount = maxTxAmountUI * (10**_decimals);
349         _maxWalletSize = maxWalletSizeUI * (10**_decimals);
350         swapThreshold = (_tTotal * 5) / 10000;
351         swapAmount = (_tTotal * 5) / 1000;
352         if(address(antiSnipe) == address(0)){
353             antiSnipe = AntiSnipe(address(this));
354         }
355         contractInitialized = true;     
356         _rOwned[owner()] = _rTotal;
357         emit Transfer(address(0), owner(), _tTotal);
358 
359         _approve(address(this), address(dexRouter), type(uint256).max);
360 
361         for(uint256 i = 0; i < accounts.length; i++){
362             address wallet = accounts[i];
363             uint256 amount = amounts[i]*10**_decimals;
364             _transfer(owner(), wallet, amount);
365         }
366 
367         _transfer(owner(), address(this), balanceOf(owner()));
368 
369         dexRouter.addLiquidityETH{value: address(this).balance}(
370             address(this),
371             balanceOf(address(this)),
372             0, // slippage is unavoidable
373             0, // slippage is unavoidable
374             owner(),
375             block.timestamp
376         );
377 
378         enableTrading();
379     }
380 
381 //===============================================================================================================
382 //===============================================================================================================
383 //===============================================================================================================
384     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
385     // This allows for removal of ownership privileges from the owner once renounced or transferred.
386     function owner() public view returns (address) {
387         return _owner;
388     }
389 
390     function transferOwner(address newOwner) external onlyOwner() {
391         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
392         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
393         setExcludedFromFees(_owner, false);
394         setExcludedFromFees(newOwner, true);
395         
396         if (_marketingWallet == payable(_owner))
397             _marketingWallet = payable(newOwner);
398         
399         if(balanceOf(_owner) > 0) {
400             _transfer(_owner, newOwner, balanceOf(_owner));
401         }
402         
403         _owner = newOwner;
404         emit OwnershipTransferred(_owner, newOwner);
405         
406     }
407 
408     function renounceOwnership() public virtual onlyOwner() {
409         setExcludedFromFees(_owner, false);
410         _owner = address(0);
411         emit OwnershipTransferred(_owner, address(0));
412     }
413 //===============================================================================================================
414 //===============================================================================================================
415 //===============================================================================================================
416 
417     function totalSupply() external view override returns (uint256) { return _tTotal; }
418     function decimals() external view override returns (uint8) { return _decimals; }
419     function symbol() external view override returns (string memory) { return _symbol; }
420     function name() external view override returns (string memory) { return _name; }
421     function getOwner() external view override returns (address) { return owner(); }
422     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
423 
424     function balanceOf(address account) public view override returns (uint256) {
425         if (_isExcluded[account]) return _tOwned[account];
426         return tokenFromReflection(_rOwned[account]);
427     }
428 
429     function transfer(address recipient, uint256 amount) public override returns (bool) {
430         _transfer(_msgSender(), recipient, amount);
431         return true;
432     }
433 
434     function approve(address spender, uint256 amount) public override returns (bool) {
435         _approve(_msgSender(), spender, amount);
436         return true;
437     }
438 
439     function _approve(address sender, address spender, uint256 amount) private {
440         require(sender != address(0), "ERC20: Zero Address");
441         require(spender != address(0), "ERC20: Zero Address");
442 
443         _allowances[sender][spender] = amount;
444         emit Approval(sender, spender, amount);
445     }
446 
447     function approveContractContingency() public onlyOwner returns (bool) {
448         _approve(address(this), address(dexRouter), type(uint256).max);
449         return true;
450     }
451 
452     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
453         if (_allowances[sender][msg.sender] != type(uint256).max) {
454             _allowances[sender][msg.sender] -= amount;
455         }
456 
457         return _transfer(sender, recipient, amount);
458     }
459 
460     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
462         return true;
463     }
464 
465     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
466         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
467         return true;
468     }
469 
470     function setNewRouter(address newRouter) public onlyOwner() {
471         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
472         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
473         if (get_pair == address(0)) {
474             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
475         }
476         else {
477             lpPair = get_pair;
478         }
479         dexRouter = _newRouter;
480         _approve(address(this), address(dexRouter), type(uint256).max);
481     }
482 
483     function setLpPair(address pair, bool enabled) external onlyOwner {
484         if (enabled == false) {
485             lpPairs[pair] = false;
486             antiSnipe.setLpPair(pair, false);
487         } else {
488             if (timeSinceLastPair != 0) {
489                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day Cooldown");
490             }
491             lpPairs[pair] = true;
492             timeSinceLastPair = block.timestamp;
493             antiSnipe.setLpPair(pair, true);
494         }
495     }
496 
497     function changeRouterContingency(address router) external onlyOwner {
498         require(!_hasLiqBeenAdded);
499         _routerAddress = router;
500     }
501 
502     function getCirculatingSupply() public view returns (uint256) {
503         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
504     }
505 
506     function isExcludedFromFees(address account) public view returns(bool) {
507         return _isExcludedFromFees[account];
508     }
509 
510     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
511         _isExcludedFromFees[account] = enabled;
512     }
513 
514     function isExcludedFromReward(address account) public view returns (bool) {
515         return _isExcluded[account];
516     }
517 
518     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
519         if (enabled == true) {
520             require(!_isExcluded[account], "Account is already excluded.");
521             if(_rOwned[account] > 0) {
522                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
523             }
524             _isExcluded[account] = true;
525             _excluded.push(account);
526         } else if (enabled == false) {
527             require(_isExcluded[account], "Account is already included.");
528             if(_excluded.length == 1){
529                 _tOwned[account] = 0;
530                 _isExcluded[account] = false;
531                 _excluded.pop();
532             } else {
533                 for (uint256 i = 0; i < _excluded.length; i++) {
534                     if (_excluded[i] == account) {
535                         _excluded[i] = _excluded[_excluded.length - 1];
536                         _tOwned[account] = 0;
537                         _isExcluded[account] = false;
538                         _excluded.pop();
539                         break;
540                     }
541                 }
542             }
543         }
544     }
545 
546     function setInitializer(address initializer) external onlyOwner {
547         require(!_hasLiqBeenAdded, "Liquidity is already in.");
548         require(initializer != address(this), "Can't be self.");
549         antiSnipe = AntiSnipe(initializer);
550     }
551 
552     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
553         antiSnipe.setBlacklistEnabled(account, enabled);
554     }
555 
556     function isBlacklisted(address account) public view returns (bool) {
557         return antiSnipe.isBlacklisted(account);
558     }
559 
560     function getSniperAmt() public view returns (uint256) {
561         return antiSnipe.getSniperAmt();
562     }
563 
564     function removeSniper(address account) external onlyOwner {
565         antiSnipe.removeSniper(account);
566     }
567 
568     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
569         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
570     }
571 
572     function setGasPriceLimit(uint256 gas) external onlyOwner {
573         require(gas >= 75, "Too low.");
574         antiSnipe.setGasPriceLimit(gas);
575     }
576 
577     function setTaxesBuy(uint16 reflect, uint16 marketing) external onlyOwner {
578         require(reflect <= staticVals.maxReflect
579                 && marketing <= staticVals.maxMarketing);
580         require(reflect + marketing <= 3450);
581         _buyTaxes.reflect = reflect;
582         _buyTaxes.marketing = marketing;
583     }
584 
585     function setTaxesSell(uint16 reflect, uint16 marketing) external onlyOwner {
586         require(reflect <= staticVals.maxReflect
587                 && marketing <= staticVals.maxMarketing);
588         require(reflect + marketing <= 3450);
589         _sellTaxes.reflect = reflect;
590         _sellTaxes.marketing = marketing;
591     }
592 
593     function setTaxesTransfer(uint16 reflect, uint16 marketing) external onlyOwner {
594         require(reflect <= staticVals.maxReflect
595                 && marketing <= staticVals.maxMarketing);
596         require(reflect + marketing <= 3450);
597         _transferTaxes.reflect = reflect;
598         _transferTaxes.marketing = marketing;
599     }
600 
601     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
602         uint256 check = (_tTotal * percent) / divisor;
603         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
604         _maxTxAmount = check;
605         maxTxAmountUI = (startingSupply * percent) / divisor;
606     }
607 
608     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
609         uint256 check = (_tTotal * percent) / divisor;
610         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
611         _maxWalletSize = check;
612         maxWalletSizeUI = (startingSupply * percent) / divisor;
613     }
614 
615     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
616         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
617         swapAmount = (_tTotal * amountPercent) / amountDivisor;
618     }
619 
620     function setWallets(address payable marketingWallet) external onlyOwner {
621         _marketingWallet = payable(marketingWallet);
622     }
623 
624     function setContractSwapEnabled(bool _enabled) public onlyOwner {
625         contractSwapEnabled = _enabled;
626         emit ContractSwapEnabledUpdated(_enabled);
627     }
628 
629     function _hasLimits(address from, address to) private view returns (bool) {
630         return from != owner()
631             && to != owner()
632             && !_liquidityHolders[to]
633             && !_liquidityHolders[from]
634             && to != DEAD
635             && to != address(0)
636             && from != address(this);
637     }
638 
639     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
640         require(rAmount <= _rTotal, "Amount must be less than total reflections");
641         uint256 currentRate =  _getRate();
642         return rAmount / currentRate;
643     }
644 
645     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
646         require(from != address(0), "ERC20: transfer from the zero address");
647         require(to != address(0), "ERC20: transfer to the zero address");
648         require(amount > 0, "Transfer amount must be greater than zero");
649         if(_hasLimits(from, to)) {
650             if(!tradingEnabled) {
651                 revert("Trading not yet enabled!");
652             }
653             if(lpPairs[from] || lpPairs[to]){
654                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
655             }
656             if(to != _routerAddress && !lpPairs[to]) {
657                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
658             }
659         }
660 
661         bool takeFee = true;
662         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
663             takeFee = false;
664         }
665 
666         if (lpPairs[to]) {
667             if (!inSwap
668                 && contractSwapEnabled
669             ) {
670                 uint256 contractTokenBalance = balanceOf(address(this));
671                 if (contractTokenBalance >= swapThreshold) {
672                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
673                     contractSwap(contractTokenBalance);
674                 }
675             }      
676         } 
677         return _finalizeTransfer(from, to, amount, takeFee);
678     }
679 
680     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
681         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
682             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
683         }
684         
685         address[] memory path = new address[](2);
686         path[0] = address(this);
687         path[1] = dexRouter.WETH();
688 
689         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
690             contractTokenBalance,
691             0, // accept any amount of ETH
692             path,
693             _marketingWallet,
694             block.timestamp
695         );
696     }
697 
698     function _checkLiquidityAdd(address from, address to) private {
699         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
700         if (!_hasLimits(from, to) && to == lpPair) {
701             _liquidityHolders[from] = true;
702             _hasLiqBeenAdded = true;
703             if(address(antiSnipe) == address(0)){
704                 antiSnipe = AntiSnipe(address(this));
705             }
706             contractSwapEnabled = true;
707             emit ContractSwapEnabledUpdated(true);
708         }
709     }
710 
711     function enableTrading() public onlyOwner {
712         require(!tradingEnabled, "Trading already enabled!");
713         require(_hasLiqBeenAdded, "Liquidity must be added.");
714         setExcludedFromReward(address(this), true);
715         setExcludedFromReward(lpPair, true);
716         if(address(antiSnipe) == address(0)){
717             antiSnipe = AntiSnipe(address(this));
718         }
719         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp)) {} catch {}
720         tradingEnabled = true;
721     }
722 
723     function sweepContingency() external onlyOwner {
724         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
725         payable(owner()).transfer(address(this).balance);
726     }
727 
728 
729     struct ExtraValues {
730         uint256 tTransferAmount;
731         uint256 tFee;
732         uint256 tLiquidity;
733 
734         uint256 rTransferAmount;
735         uint256 rAmount;
736         uint256 rFee;
737     }
738 
739     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
740         if (!_hasLiqBeenAdded) {
741             _checkLiquidityAdd(from, to);
742             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
743                 revert("Only owner can transfer at this time.");
744             }
745         }
746 
747         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
748 
749         _rOwned[from] = _rOwned[from] - values.rAmount;
750         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
751 
752         if (_isExcluded[from] && !_isExcluded[to]) {
753             _tOwned[from] = _tOwned[from] - tAmount;
754         } else if (!_isExcluded[from] && _isExcluded[to]) {
755             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
756         } else if (_isExcluded[from] && _isExcluded[to]) {
757             _tOwned[from] = _tOwned[from] - tAmount;
758             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
759         }
760 
761         if (values.tLiquidity > 0)
762             _takeLiquidity(from, values.tLiquidity);
763         if (values.rFee > 0 || values.tFee > 0)
764             _rTotal -= values.rFee;
765             _tFeeTotal += values.tFee;
766 
767         emit Transfer(from, to, values.tTransferAmount);
768         return true;
769     }
770 
771     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
772         ExtraValues memory values;
773         uint256 currentRate = _getRate();
774 
775         values.rAmount = tAmount * currentRate;
776 
777         if (_hasLimits(from, to)) {
778             bool checked;
779             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
780                 checked = check;
781             } catch {
782                 revert();
783             }
784 
785             if(!checked) {
786                 revert();
787             }
788         }
789 
790         if(takeFee) {
791             if (lpPairs[to]) {
792                 currentTaxes.reflect = _sellTaxes.reflect;
793                 currentTaxes.marketing = _sellTaxes.marketing;
794             } else if (lpPairs[from]) {
795                 currentTaxes.reflect = _buyTaxes.reflect;
796                 currentTaxes.marketing = _buyTaxes.marketing;
797             } else {
798                 currentTaxes.reflect = _transferTaxes.reflect;
799                 currentTaxes.marketing = _transferTaxes.marketing;
800             }
801 
802             values.tFee = (tAmount * currentTaxes.reflect) / staticVals.masterTaxDivisor;
803             values.tLiquidity = (tAmount * (currentTaxes.marketing)) / staticVals.masterTaxDivisor;
804             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
805 
806             values.rFee = values.tFee * currentRate;
807         } else {
808             values.tFee = 0;
809             values.tLiquidity = 0;
810             values.tTransferAmount = tAmount;
811 
812             values.rFee = 0;
813         }
814         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
815         return values;
816     }
817 
818     function _getRate() internal view returns(uint256) {
819         uint256 rSupply = _rTotal;
820         uint256 tSupply = _tTotal;
821         for (uint256 i = 0; i < _excluded.length; i++) {
822             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
823             rSupply = rSupply - _rOwned[_excluded[i]];
824             tSupply = tSupply - _tOwned[_excluded[i]];
825         }
826         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
827         return rSupply / tSupply;
828     }
829 
830     function _takeLiquidity(address sender, uint256 tLiquidity) private {
831         _rOwned[address(this)] = _rOwned[address(this)] + (tLiquidity * _getRate());
832         if(_isExcluded[address(this)])
833             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
834         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
835     }
836 }