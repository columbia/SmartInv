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
15 interface IERC20Upgradeable {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/od/ai/nu/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 interface IUniswapV2Factory {
91     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
92     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
93     function createPair(address tokenA, address tokenB) external returns (address lpPair);
94 }
95 
96 interface IUniswapV2Pair {
97     event Approval(address indexed owner, address indexed spender, uint value);
98     event Transfer(address indexed from, address indexed to, uint value);
99 
100     function name() external pure returns (string memory);
101     function symbol() external pure returns (string memory);
102     function decimals() external pure returns (uint8);
103     function totalSupply() external view returns (uint);
104     function balanceOf(address owner) external view returns (uint);
105     function allowance(address owner, address spender) external view returns (uint);
106     function approve(address spender, uint value) external returns (bool);
107     function transfer(address to, uint value) external returns (bool);
108     function transferFrom(address from, address to, uint value) external returns (bool);
109     function DOMAIN_SEPARATOR() external view returns (bytes32);
110     function PERMIT_TYPEHASH() external pure returns (bytes32);
111     function nonces(address owner) external view returns (uint);
112     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
113     function factory() external view returns (address);
114 }
115 
116 interface IUniswapV2Router01 {
117     function factory() external pure returns (address);
118     function WETH() external pure returns (address);
119     function addLiquidityETH(
120         address token,
121         uint amountTokenDesired,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline
126     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
127 }
128 
129 interface IUniswapV2Router02 is IUniswapV2Router01 {
130     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137     function swapExactETHForTokensSupportingFeeOnTransferTokens(
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external payable;
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150 }
151 
152 interface AntiSnipe {
153     function checkUser(address from, address to, uint256 amt) external returns (bool);
154     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp) external;
155     function setLpPair(address pair, bool enabled) external;
156     function setProtections(bool _as, bool _ag, bool _ab, bool _aspecial) external;
157     function setGasPriceLimit(uint256 gas) external;
158     function removeSniper(address account) external;
159     function setBlacklistEnabled(address account, bool enabled) external;
160 }
161 
162 contract AaTokenContract is Context, IERC20Upgradeable {
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
176     bool private allowedPresaleExclusion = true;
177     mapping (address => bool) private _isSniper;
178     mapping (address => bool) private _liquidityHolders;
179    
180     uint256 private startingSupply;
181 
182     string private _name;
183     string private _symbol;
184 
185     struct FeesStruct {
186         uint16 reflectFee;
187         uint16 liquidityFee;
188         uint16 marketingFee;
189     }
190 
191     struct StaticValuesStruct {
192         uint16 maxReflectFee;
193         uint16 maxLiquidityFee;
194         uint16 maxMarketingFee;
195         uint16 masterTaxDivisor;
196     }
197 
198     struct Ratios {
199         uint16 liquidityRatio;
200         uint16 marketingRatio;
201         uint16 totalRatio;
202     }
203 
204     FeesStruct private currentTaxes = FeesStruct({
205         reflectFee: 0,
206         liquidityFee: 0,
207         marketingFee: 0
208         });
209 
210     FeesStruct public _buyTaxes = FeesStruct({
211         reflectFee: 300,
212         liquidityFee: 300,
213         marketingFee: 300
214         });
215 
216     FeesStruct public _sellTaxes = FeesStruct({
217         reflectFee: 300,
218         liquidityFee: 300,
219         marketingFee: 300
220         });
221 
222     FeesStruct public _transferTaxes = FeesStruct({
223         reflectFee: 300,
224         liquidityFee: 300,
225         marketingFee: 300
226         });
227 
228     Ratios public _ratios = Ratios({
229         liquidityRatio: _buyTaxes.liquidityFee,
230         marketingRatio: _buyTaxes.marketingFee,
231         totalRatio: _buyTaxes.liquidityFee + _buyTaxes.marketingFee
232         });
233 
234     StaticValuesStruct public staticVals = StaticValuesStruct({
235         maxReflectFee: 800,
236         maxLiquidityFee: 800,
237         maxMarketingFee: 800,
238         masterTaxDivisor: 10000
239         });
240 
241     uint256 private constant MAX = ~uint256(0);
242     uint8 private _decimals;
243     uint256 private _tTotal;
244     uint256 private _rTotal;
245     uint256 private _tFeeTotal;
246 
247     IUniswapV2Router02 public dexRouter;
248     address public lpPair;
249 
250     // UNI ROUTER
251     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
252 
253     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
254     address payable private _marketingWallet = payable(0xFe9EBe595617baf16101A6bd607248d538D7Ec8b);
255     
256     bool inSwap;
257     bool public contractSwapEnabled = false;
258     
259     uint256 private _maxTxAmount;
260     uint256 public maxTxAmountUI;
261 
262     uint256 private _maxWalletSize;
263     uint256 public maxWalletSizeUI;
264 
265     uint256 private swapThreshold;
266     uint256 private swapAmount;
267 
268     bool public tradingEnabled = false;
269     bool public _hasLiqBeenAdded = false;
270     AntiSnipe antiSnipe;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
274     event ContractSwapEnabledUpdated(bool enabled);
275     event SwapAndLiquify(
276         uint256 tokensSwapped,
277         uint256 ethReceived,
278         uint256 tokensIntoLiqudity
279     );
280     event SniperCaught(address sniperAddress);
281     
282     modifier lockTheSwap {
283         inSwap = true;
284         _;
285         inSwap = false;
286     }
287 
288     modifier onlyOwner() {
289         require(_owner == _msgSender(), "Caller =/= owner.");
290         _;
291     }
292     
293     constructor () payable {
294         // Set the owner.
295         _owner = msg.sender;
296         _approve(_msgSender(), _routerAddress, type(uint256).max);
297         _approve(address(this), _routerAddress, type(uint256).max);
298 
299         _isExcludedFromFees[owner()] = true;
300         _isExcludedFromFees[address(this)] = true;
301         _isExcludedFromFees[DEAD] = true;
302         _liquidityHolders[owner()] = true;
303     }
304     
305     bool contractInitialized = false;
306 
307     function intializeContract(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
308         require(!contractInitialized, "Contract already initialized.");
309         require(accounts.length < 50, "Max 50 wallets.");
310         require(accounts.length == amounts.length, "Must be equal lengths.");
311 
312         _name = "Miyazaki Inu";
313         _symbol = "MIYAZAKI";
314         startingSupply = 1_000_000_000_000_000;
315         if (startingSupply < 10000000000) {
316             _decimals = 18;
317         } else {
318             _decimals = 9;
319         }
320         _tTotal = startingSupply * (10**_decimals);
321         _rTotal = (MAX - (MAX % _tTotal));
322 
323         dexRouter = IUniswapV2Router02(_routerAddress);
324         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
325         lpPairs[lpPair] = true;
326 
327         uint256 percent = 2;
328         uint256 divisor = 1000;
329         _maxTxAmount = (_tTotal * percent) / divisor;
330         maxTxAmountUI = (startingSupply * percent) / divisor;
331         percent = 55;
332         divisor = 10000;
333         _maxWalletSize = (_tTotal * percent) / divisor;
334         maxWalletSizeUI = (startingSupply * percent) / divisor;
335         swapThreshold = (_tTotal * 5) / 10000;
336         swapAmount = (_tTotal * 5) / 1000;
337         if(address(antiSnipe) == address(0)){
338             antiSnipe = AntiSnipe(address(this));
339         }
340         contractInitialized = true;     
341         _rOwned[owner()] = _rTotal;
342         emit Transfer(address(0), owner(), _tTotal);
343 
344         _approve(address(this), address(dexRouter), type(uint256).max);
345 
346         for(uint256 i = 0; i < accounts.length; i++){
347             address wallet = accounts[i];
348             uint256 amount = amounts[i]*10**_decimals;
349             _transfer(owner(), wallet, amount);
350         }
351 
352         _transfer(owner(), address(this), balanceOf(owner()));
353 
354         dexRouter.addLiquidityETH{value: address(this).balance}(
355             address(this),
356             balanceOf(address(this)),
357             0, // slippage is unavoidable
358             0, // slippage is unavoidable
359             owner(),
360             block.timestamp
361         );
362 
363         enableTrading();
364     }
365 
366     receive() external payable {}
367 
368 //===============================================================================================================
369 //===============================================================================================================
370 //===============================================================================================================
371     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
372     // This allows for removal of ownership privelages from the owner once renounced or transferred.
373     function owner() public view returns (address) {
374         return _owner;
375     }
376 
377     function transferOwner(address newOwner) external onlyOwner() {
378         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
379         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
380         setExcludedFromFees(_owner, false);
381         setExcludedFromFees(newOwner, true);
382         if (tradingEnabled){
383             setExcludedFromReward(newOwner, true);
384         }
385         
386         if (_marketingWallet == payable(_owner))
387             _marketingWallet = payable(newOwner);
388         
389         if(balanceOf(_owner) > 0) {
390             _transfer(_owner, newOwner, balanceOf(_owner));
391         }
392         
393         _owner = newOwner;
394         emit OwnershipTransferred(_owner, newOwner);
395         
396     }
397 
398     function renounceOwnership() public virtual onlyOwner() {
399         setExcludedFromFees(_owner, false);
400         _owner = address(0);
401         emit OwnershipTransferred(_owner, address(0));
402     }
403 //===============================================================================================================
404 //===============================================================================================================
405 //===============================================================================================================
406 
407     function totalSupply() external view override returns (uint256) { return _tTotal; }
408     function decimals() external view returns (uint8) { return _decimals; }
409     function symbol() external view returns (string memory) { return _symbol; }
410     function name() external view returns (string memory) { return _name; }
411     function getOwner() external view returns (address) { return owner(); }
412     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
413 
414     function balanceOf(address account) public view override returns (uint256) {
415         if (_isExcluded[account]) return _tOwned[account];
416         return tokenFromReflection(_rOwned[account]);
417     }
418 
419     function transfer(address recipient, uint256 amount) public override returns (bool) {
420         _transfer(_msgSender(), recipient, amount);
421         return true;
422     }
423 
424     function approve(address spender, uint256 amount) public override returns (bool) {
425         _approve(_msgSender(), spender, amount);
426         return true;
427     }
428 
429     function _approve(address sender, address spender, uint256 amount) private {
430         require(sender != address(0), "ERC20: Zero Address");
431         require(spender != address(0), "ERC20: Zero Address");
432 
433         _allowances[sender][spender] = amount;
434         emit Approval(sender, spender, amount);
435     }
436 
437     function approveContractContingency() public onlyOwner returns (bool) {
438         _approve(address(this), address(dexRouter), type(uint256).max);
439         return true;
440     }
441 
442     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
443         if (_allowances[sender][msg.sender] != type(uint256).max) {
444             _allowances[sender][msg.sender] -= amount;
445         }
446 
447         return _transfer(sender, recipient, amount);
448     }
449 
450     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
451         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
452         return true;
453     }
454 
455     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
456         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
457         return true;
458     }
459 
460     function setNewRouter(address newRouter) public onlyOwner() {
461         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
462         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
463         if (get_pair == address(0)) {
464             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
465         }
466         else {
467             lpPair = get_pair;
468         }
469         dexRouter = _newRouter;
470         _approve(address(this), address(dexRouter), type(uint256).max);
471     }
472 
473     function setLpPair(address pair, bool enabled) external onlyOwner {
474         if (enabled == false) {
475             lpPairs[pair] = false;
476             antiSnipe.setLpPair(pair, false);
477         } else {
478             if (timeSinceLastPair != 0) {
479                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
480             }
481             lpPairs[pair] = true;
482             timeSinceLastPair = block.timestamp;
483             antiSnipe.setLpPair(pair, true);
484         }
485     }
486 
487     function isExcludedFromFees(address account) public view returns(bool) {
488         return _isExcludedFromFees[account];
489     }
490 
491     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
492         _isExcludedFromFees[account] = enabled;
493     }
494 
495     function isExcludedFromReward(address account) public view returns (bool) {
496         return _isExcluded[account];
497     }
498 
499     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
500         if (enabled == true) {
501             require(!_isExcluded[account], "Account is already excluded.");
502             if(_rOwned[account] > 0) {
503                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
504             }
505             _isExcluded[account] = true;
506             _excluded.push(account);
507         } else if (enabled == false) {
508             require(_isExcluded[account], "Account is already included.");
509             if(_excluded.length == 1){
510                 _tOwned[account] = 0;
511                 _isExcluded[account] = false;
512                 _excluded.pop();
513             } else {
514                 for (uint256 i = 0; i < _excluded.length; i++) {
515                     if (_excluded[i] == account) {
516                         _excluded[i] = _excluded[_excluded.length - 1];
517                         _tOwned[account] = 0;
518                         _isExcluded[account] = false;
519                         _excluded.pop();
520                         break;
521                     }
522                 }
523             }
524         }
525     }
526 
527     function setInitializer(address initializer) external onlyOwner {
528         require(!_hasLiqBeenAdded, "Liquidity is already in.");
529         antiSnipe = AntiSnipe(initializer);
530     }
531 
532     function removeSniper(address account) external onlyOwner() {
533         antiSnipe.removeSniper(account);
534     }
535 
536     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _antiSpecial) external onlyOwner() {
537         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _antiSpecial);
538     }
539 
540     function setGasPriceLimit(uint256 gas) external onlyOwner {
541         require(gas >= 75, "Too low.");
542         antiSnipe.setGasPriceLimit(gas);
543     }
544     
545     function setTaxesBuy(uint16 reflectFee, uint16 liquidityFee, uint16 marketingFee) external onlyOwner {
546         require(reflectFee <= staticVals.maxReflectFee
547                 && liquidityFee <= staticVals.maxLiquidityFee
548                 && marketingFee <= staticVals.maxMarketingFee);
549         require(liquidityFee + reflectFee + marketingFee <= 3450);
550         _buyTaxes.liquidityFee = liquidityFee;
551         _buyTaxes.reflectFee = reflectFee;
552         _buyTaxes.marketingFee = marketingFee;
553     }
554 
555     function setTaxesSell(uint16 reflectFee, uint16 liquidityFee, uint16 marketingFee) external onlyOwner {
556         require(reflectFee <= staticVals.maxReflectFee
557                 && liquidityFee <= staticVals.maxLiquidityFee
558                 && marketingFee <= staticVals.maxMarketingFee);
559         require(liquidityFee + reflectFee + marketingFee <= 3450);
560         _sellTaxes.liquidityFee = liquidityFee;
561         _sellTaxes.reflectFee = reflectFee;
562         _sellTaxes.marketingFee = marketingFee;
563     }
564 
565     function setTaxesTransfer(uint16 reflectFee, uint16 liquidityFee, uint16 marketingFee) external onlyOwner {
566         require(reflectFee <= staticVals.maxReflectFee
567                 && liquidityFee <= staticVals.maxLiquidityFee
568                 && marketingFee <= staticVals.maxMarketingFee);
569         require(liquidityFee + reflectFee + marketingFee <= 3450);
570         _transferTaxes.liquidityFee = liquidityFee;
571         _transferTaxes.reflectFee = reflectFee;
572         _transferTaxes.marketingFee = marketingFee;
573     }
574 
575     function setRatios(uint16 liquidity, uint16 marketing) external onlyOwner {
576         require (liquidity + marketing == 100, "Must add up to 100%");
577         _ratios.liquidityRatio = liquidity;
578         _ratios.marketingRatio = marketing;
579         _ratios.totalRatio = liquidity + marketing;
580     }
581 
582     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
583         uint256 check = (_tTotal * percent) / divisor;
584         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
585         _maxTxAmount = check;
586         maxTxAmountUI = (startingSupply * percent) / divisor;
587     }
588 
589     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
590         uint256 check = (_tTotal * percent) / divisor;
591         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
592         _maxWalletSize = check;
593         maxWalletSizeUI = (startingSupply * percent) / divisor;
594     }
595 
596     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
597         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
598         swapAmount = (_tTotal * amountPercent) / amountDivisor;
599     }
600 
601     function setWallets(address payable marketingWallet) external onlyOwner {
602         _marketingWallet = payable(marketingWallet);
603     }
604 
605     function setContractSwapEnabled(bool _enabled) public onlyOwner {
606         contractSwapEnabled = _enabled;
607         emit ContractSwapEnabledUpdated(_enabled);
608     }
609 
610     function _hasLimits(address from, address to) private view returns (bool) {
611         return from != owner()
612             && to != owner()
613             && !_liquidityHolders[to]
614             && !_liquidityHolders[from]
615             && to != DEAD
616             && to != address(0)
617             && from != address(this);
618     }
619 
620     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
621         require(rAmount <= _rTotal, "Amount must be less than total reflections");
622         uint256 currentRate =  _getRate();
623         return rAmount / currentRate;
624     }
625 
626     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
627         require(from != address(0), "ERC20: transfer from the zero address");
628         require(to != address(0), "ERC20: transfer to the zero address");
629         require(amount > 0, "Transfer amount must be greater than zero");
630         if(_hasLimits(from, to)) {
631             if(!tradingEnabled) {
632                 revert("Trading not yet enabled!");
633             }
634             if(lpPairs[from] || lpPairs[to]){
635                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
636             }
637             if(to != _routerAddress && !lpPairs[to]) {
638                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
639             }
640         }
641 
642         bool takeFee = true;
643         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
644             takeFee = false;
645         }
646 
647         if (lpPairs[to]) {
648             if (!inSwap
649                 && contractSwapEnabled
650             ) {
651                 uint256 contractTokenBalance = balanceOf(address(this));
652                 if (contractTokenBalance >= swapThreshold) {
653                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
654                     contractSwap(contractTokenBalance);
655                 }
656             }      
657         } 
658         return _finalizeTransfer(from, to, amount, takeFee);
659     }
660 
661     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
662         if (_ratios.totalRatio == 0)
663             return;
664 
665         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
666             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
667         }
668 
669         uint256 toLiquify = ((contractTokenBalance * _ratios.liquidityRatio) / _ratios.totalRatio) / 2;
670 
671         uint256 toSwapForEth = contractTokenBalance - toLiquify;
672         
673         address[] memory path = new address[](2);
674         path[0] = address(this);
675         path[1] = dexRouter.WETH();
676 
677         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
678             toSwapForEth,
679             0, // accept any amount of ETH
680             path,
681             address(this),
682             block.timestamp
683         );
684 
685         //uint256 currentBalance = address(this).balance;
686         uint256 liquidityBalance = ((address(this).balance * _ratios.liquidityRatio) / _ratios.totalRatio) / 2;
687 
688         if (toLiquify > 0) {
689             dexRouter.addLiquidityETH{value: liquidityBalance}(
690                 address(this),
691                 toLiquify,
692                 0, // slippage is unavoidable
693                 0, // slippage is unavoidable
694                 DEAD,
695                 block.timestamp
696             );
697             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
698         }
699         if (contractTokenBalance - toLiquify > 0) {
700             _marketingWallet.transfer(address(this).balance);
701         }
702     }
703 
704     function _checkLiquidityAdd(address from, address to) private {
705         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
706         if (!_hasLimits(from, to) && to == lpPair) {
707             if (from == address(this)){
708                 _liquidityHolders[owner()] = true;
709             } else {
710                 _liquidityHolders[from] = true;
711             }
712             _hasLiqBeenAdded = true;
713             if(address(antiSnipe) == address(0)){
714                 antiSnipe = AntiSnipe(address(this));
715             }
716             contractSwapEnabled = true;
717             emit ContractSwapEnabledUpdated(true);
718         }
719     }
720 
721     function enableTrading() public onlyOwner {
722         require(!tradingEnabled, "Trading already enabled!");
723         require(_hasLiqBeenAdded, "Liquidity must be added.");
724         setExcludedFromReward(address(this), true);
725         setExcludedFromReward(lpPair, true);
726         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp)) {} catch {}
727         tradingEnabled = true;
728     }
729 
730     struct ExtraValues {
731         uint256 tTransferAmount;
732         uint256 tFee;
733         uint256 tLiquidity;
734 
735         uint256 rTransferAmount;
736         uint256 rAmount;
737         uint256 rFee;
738     }
739 
740     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
741         if (!_hasLiqBeenAdded) {
742             _checkLiquidityAdd(from, to);
743             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
744                 revert("Only owner can transfer at this time.");
745             }
746         }
747 
748         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
749 
750         _rOwned[from] = _rOwned[from] - values.rAmount;
751         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
752 
753         if (_isExcluded[from] && !_isExcluded[to]) {
754             _tOwned[from] = _tOwned[from] - tAmount;
755         } else if (!_isExcluded[from] && _isExcluded[to]) {
756             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
757         } else if (_isExcluded[from] && _isExcluded[to]) {
758             _tOwned[from] = _tOwned[from] - tAmount;
759             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
760         }
761 
762         if (values.tLiquidity > 0)
763             _takeLiquidity(from, values.tLiquidity);
764         if (values.rFee > 0 || values.tFee > 0)
765             _rTotal -= values.rFee;
766             _tFeeTotal += values.tFee;
767 
768         emit Transfer(from, to, values.tTransferAmount);
769         return true;
770     }
771 
772     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
773         ExtraValues memory values;
774         uint256 currentRate = _getRate();
775 
776         values.rAmount = tAmount * currentRate;
777 
778         if (_hasLimits(from, to)) {
779             bool checked;
780             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
781                 checked = check;
782             } catch {
783                 revert();
784             }
785 
786             if(!checked) {
787                 revert();
788             }
789         }
790 
791         if(takeFee) {
792             if (lpPairs[to]) {
793                 currentTaxes.reflectFee = _sellTaxes.reflectFee;
794                 currentTaxes.liquidityFee = _sellTaxes.liquidityFee;
795                 currentTaxes.marketingFee = _sellTaxes.marketingFee;
796             } else if (lpPairs[from]) {
797                 currentTaxes.reflectFee = _buyTaxes.reflectFee;
798                 currentTaxes.liquidityFee = _buyTaxes.liquidityFee;
799                 currentTaxes.marketingFee = _buyTaxes.marketingFee;
800             } else {
801                 currentTaxes.reflectFee = _transferTaxes.reflectFee;
802                 currentTaxes.liquidityFee = _transferTaxes.liquidityFee;
803                 currentTaxes.marketingFee = _transferTaxes.marketingFee;
804             }
805 
806             values.tFee = (tAmount * currentTaxes.reflectFee) / staticVals.masterTaxDivisor;
807             values.tLiquidity = (tAmount * (currentTaxes.liquidityFee + currentTaxes.marketingFee)) / staticVals.masterTaxDivisor;
808             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
809 
810             values.rFee = values.tFee * currentRate;
811         } else {
812             values.tFee = 0;
813             values.tLiquidity = 0;
814             values.tTransferAmount = tAmount;
815 
816             values.rFee = 0;
817         }
818         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
819         return values;
820     }
821 
822     function _getRate() private view returns(uint256) {
823         uint256 rSupply = _rTotal;
824         uint256 tSupply = _tTotal;
825         for (uint256 i = 0; i < _excluded.length; i++) {
826             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
827             rSupply = rSupply - _rOwned[_excluded[i]];
828             tSupply = tSupply - _tOwned[_excluded[i]];
829         }
830         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
831         return rSupply / tSupply;
832     }
833     
834     function _takeLiquidity(address sender, uint256 tLiquidity) private {
835         _rOwned[address(this)] = _rOwned[address(this)] + (tLiquidity * _getRate());
836         if(_isExcluded[address(this)])
837             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
838         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
839     }
840 
841     function sweepContingency() external onlyOwner {
842         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
843         payable(owner()).transfer(address(this).balance);
844     }
845 }