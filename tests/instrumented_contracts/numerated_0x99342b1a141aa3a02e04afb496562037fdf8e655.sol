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
74    * https://github.com/ethereum/EIPs/ps/yd/uc/ki/nu/20#issuecomment-263524729
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
108     function feeTo() external view returns (address);
109     function feeToSetter() external view returns (address);
110     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
111     function allPairs(uint) external view returns (address lpPair);
112     function allPairsLength() external view returns (uint);
113     function createPair(address tokenA, address tokenB) external returns (address lpPair);
114     function setFeeTo(address) external;
115     function setFeeToSetter(address) external;
116 }
117 
118 interface IUniswapV2Pair {
119     event Approval(address indexed owner, address indexed spender, uint value);
120     event Transfer(address indexed from, address indexed to, uint value);
121 
122     function name() external pure returns (string memory);
123     function symbol() external pure returns (string memory);
124     function decimals() external pure returns (uint8);
125     function totalSupply() external view returns (uint);
126     function balanceOf(address owner) external view returns (uint);
127     function allowance(address owner, address spender) external view returns (uint);
128     function approve(address spender, uint value) external returns (bool);
129     function transfer(address to, uint value) external returns (bool);
130     function transferFrom(address from, address to, uint value) external returns (bool);
131     function DOMAIN_SEPARATOR() external view returns (bytes32);
132     function PERMIT_TYPEHASH() external pure returns (bytes32);
133     function nonces(address owner) external view returns (uint);
134     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
135     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
136     event Swap(
137         address indexed sender,
138         uint amount0In,
139         uint amount1In,
140         uint amount0Out,
141         uint amount1Out,
142         address indexed to
143     );
144     event Sync(uint112 reserve0, uint112 reserve1);
145 
146     function MINIMUM_LIQUIDITY() external pure returns (uint);
147     function factory() external view returns (address);
148     function token0() external view returns (address);
149     function token1() external view returns (address);
150     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
151     function price0CumulativeLast() external view returns (uint);
152     function price1CumulativeLast() external view returns (uint);
153     function kLast() external view returns (uint);
154     function mint(address to) external returns (uint liquidity);
155     function burn(address to) external returns (uint amount0, uint amount1);
156     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
157     function skim(address to) external;
158     function sync() external;
159     function initialize(address, address) external;
160 }
161 
162 interface IUniswapV2Router01 {
163     function factory() external pure returns (address);
164     function WETH() external pure returns (address);
165     function addLiquidity(
166         address tokenA,
167         address tokenB,
168         uint amountADesired,
169         uint amountBDesired,
170         uint amountAMin,
171         uint amountBMin,
172         address to,
173         uint deadline
174     ) external returns (uint amountA, uint amountB, uint liquidity);
175     function addLiquidityETH(
176         address token,
177         uint amountTokenDesired,
178         uint amountTokenMin,
179         uint amountETHMin,
180         address to,
181         uint deadline
182     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
183     function removeLiquidity(
184         address tokenA,
185         address tokenB,
186         uint liquidity,
187         uint amountAMin,
188         uint amountBMin,
189         address to,
190         uint deadline
191     ) external returns (uint amountA, uint amountB);
192     function removeLiquidityETH(
193         address token,
194         uint liquidity,
195         uint amountTokenMin,
196         uint amountETHMin,
197         address to,
198         uint deadline
199     ) external returns (uint amountToken, uint amountETH);
200     function removeLiquidityWithPermit(
201         address tokenA,
202         address tokenB,
203         uint liquidity,
204         uint amountAMin,
205         uint amountBMin,
206         address to,
207         uint deadline,
208         bool approveMax, uint8 v, bytes32 r, bytes32 s
209     ) external returns (uint amountA, uint amountB);
210     function removeLiquidityETHWithPermit(
211         address token,
212         uint liquidity,
213         uint amountTokenMin,
214         uint amountETHMin,
215         address to,
216         uint deadline,
217         bool approveMax, uint8 v, bytes32 r, bytes32 s
218     ) external returns (uint amountToken, uint amountETH);
219     function swapExactTokensForTokens(
220         uint amountIn,
221         uint amountOutMin,
222         address[] calldata path,
223         address to,
224         uint deadline
225     ) external returns (uint[] memory amounts);
226     function swapTokensForExactTokens(
227         uint amountOut,
228         uint amountInMax,
229         address[] calldata path,
230         address to,
231         uint deadline
232     ) external returns (uint[] memory amounts);
233     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
234     external
235     payable
236     returns (uint[] memory amounts);
237     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
238     external
239     returns (uint[] memory amounts);
240     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
241     external
242     returns (uint[] memory amounts);
243     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
244     external
245     payable
246     returns (uint[] memory amounts);
247 
248     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
249     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
250     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
251     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
252     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
253 }
254 
255 interface IUniswapV2Router02 is IUniswapV2Router01 {
256     function removeLiquidityETHSupportingFeeOnTransferTokens(
257         address token,
258         uint liquidity,
259         uint amountTokenMin,
260         uint amountETHMin,
261         address to,
262         uint deadline
263     ) external returns (uint amountETH);
264     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
265         address token,
266         uint liquidity,
267         uint amountTokenMin,
268         uint amountETHMin,
269         address to,
270         uint deadline,
271         bool approveMax, uint8 v, bytes32 r, bytes32 s
272     ) external returns (uint amountETH);
273 
274     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
275         uint amountIn,
276         uint amountOutMin,
277         address[] calldata path,
278         address to,
279         uint deadline
280     ) external;
281     function swapExactETHForTokensSupportingFeeOnTransferTokens(
282         uint amountOutMin,
283         address[] calldata path,
284         address to,
285         uint deadline
286     ) external payable;
287     function swapExactTokensForETHSupportingFeeOnTransferTokens(
288         uint amountIn,
289         uint amountOutMin,
290         address[] calldata path,
291         address to,
292         uint deadline
293     ) external;
294 }
295 
296 interface AntiSnipe {
297     function checkUser(address from, address to, uint256 amt) external returns (bool);
298     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp) external;
299     function setLpPair(address pair, bool enabled) external;
300     function setProtections(bool _as, bool _ag, bool _ab) external;
301     function setGasPriceLimit(uint256 gas) external;
302     function removeSniper(address account) external;
303     function setBlacklistEnabled(address account, bool enabled) external;
304 }
305 
306 contract PsyduckInu is Context, IERC20 {
307     // Ownership moved to in-contract for customizability.
308     address private _owner;
309 
310     mapping (address => uint256) private _tOwned;
311     mapping (address => bool) lpPairs;
312     uint256 private timeSinceLastPair = 0;
313     mapping (address => mapping (address => uint256)) private _allowances;
314 
315     mapping (address => bool) private _isExcludedFromFees;
316 
317     mapping (address => bool) private _isSniper;
318     mapping (address => bool) private _liquidityHolders;
319    
320     uint256 private startingSupply = 1_000_000_000;
321 
322     string constant private _name = "Psyduck Inu";
323     string constant private _symbol = "Psyduck";
324 
325     struct FeesStruct {
326         uint16 buyFee;
327         uint16 sellFee;
328         uint16 transferFee;
329     }
330 
331     struct StaticValuesStruct {
332         uint16 maxBuyTaxes;
333         uint16 maxSellTaxes;
334         uint16 maxTransferTaxes;
335         uint16 masterTaxDivisor;
336     }
337 
338     struct Ratios {
339         uint16 liquidity;
340         uint16 marketing;
341         uint16 development;
342         uint16 total;
343     }
344 
345     FeesStruct public _taxRates = FeesStruct({
346         buyFee: 1000,
347         sellFee: 1000,
348         transferFee: 1000
349         });
350 
351     Ratios public _ratios = Ratios({
352         liquidity: 200,
353         marketing: 400,
354         development: 400,
355         total: 1000
356         });
357 
358     StaticValuesStruct public staticVals = StaticValuesStruct({
359         maxBuyTaxes: 2500,
360         maxSellTaxes: 2500,
361         maxTransferTaxes: 2500,
362         masterTaxDivisor: 10000
363         });
364 
365 
366     uint256 private constant MAX = ~uint256(0);
367     uint8 private _decimals = 9;
368     uint256 private _tTotal = startingSupply * 10**_decimals;
369     uint256 private _tFeeTotal;
370 
371     IUniswapV2Router02 public dexRouter;
372     address public lpPair;
373 
374     // UNI ROUTER
375     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
376 
377     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
378     address payable private _marketingWallet = payable(0xf786D6096fAF89fE3dD39eE98a8A13c242E8e37E);
379     address payable private _developmentWallet = payable(0x8104b506Dc5378aa6192b1f544f6CE7D8f7dbCc5);
380     
381     bool inSwap;
382     bool public contractSwapEnabled = false;
383 
384     uint256 private maxTxPercent = 25;
385     uint256 private maxTxDivisor = 10000;
386     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
387     uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor;
388 
389     uint256 private maxWalletPercent = 5;
390     uint256 private maxWalletDivisor = 1000;
391     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
392     uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor;
393 
394     uint256 private swapThreshold = (_tTotal * 5) / 10000;
395     uint256 private swapAmount = (_tTotal * 5) / 1000;
396 
397     bool public tradingEnabled = false;
398     bool public _hasLiqBeenAdded = false;
399     AntiSnipe antiSnipe;
400 
401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
403     event ContractSwapEnabledUpdated(bool enabled);
404     event SwapAndLiquify(
405         uint256 tokensSwapped,
406         uint256 ethReceived,
407         uint256 tokensIntoLiqudity
408     );
409     event SniperCaught(address sniperAddress);
410     
411     modifier lockTheSwap {
412         inSwap = true;
413         _;
414         inSwap = false;
415     }
416 
417     modifier onlyOwner() {
418         require(_owner == _msgSender(), "Caller =/= owner.");
419         _;
420     }
421     
422     constructor () payable {
423         _tOwned[_msgSender()] = _tTotal;
424 
425         // Set the owner.
426         _owner = msg.sender;
427 
428         dexRouter = IUniswapV2Router02(_routerAddress);
429         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
430         lpPairs[lpPair] = true;
431 
432         _approve(_msgSender(), _routerAddress, type(uint256).max);
433         _approve(address(this), _routerAddress, type(uint256).max);
434 
435         _isExcludedFromFees[owner()] = true;
436         _isExcludedFromFees[address(this)] = true;
437         _isExcludedFromFees[DEAD] = true;
438         _liquidityHolders[owner()] = true;
439 
440         emit Transfer(address(0), _msgSender(), _tTotal);
441     }
442 
443     receive() external payable {}
444 
445 //===============================================================================================================
446 //===============================================================================================================
447 //===============================================================================================================
448     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
449     // This allows for removal of ownership privelages from the owner once renounced or transferred.
450     function owner() public view returns (address) {
451         return _owner;
452     }
453 
454     function transferOwner(address newOwner) external onlyOwner() {
455         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
456         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
457         setExcludedFromFees(_owner, false);
458         setExcludedFromFees(newOwner, true);
459         
460         if (_marketingWallet == payable(_owner))
461             _marketingWallet = payable(newOwner);
462         
463         if(balanceOf(_owner) > 0) {
464             _transfer(_owner, newOwner, balanceOf(_owner));
465         }
466         
467         _owner = newOwner;
468         emit OwnershipTransferred(_owner, newOwner);
469         
470     }
471 
472     function renounceOwnership() public virtual onlyOwner() {
473         setExcludedFromFees(_owner, false);
474         _owner = address(0);
475         emit OwnershipTransferred(_owner, address(0));
476     }
477 //===============================================================================================================
478 //===============================================================================================================
479 //===============================================================================================================
480 
481     function totalSupply() external view override returns (uint256) { return _tTotal; }
482     function decimals() external view override returns (uint8) { return _decimals; }
483     function symbol() external pure override returns (string memory) { return _symbol; }
484     function name() external pure override returns (string memory) { return _name; }
485     function getOwner() external view override returns (address) { return owner(); }
486     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
487 
488     function balanceOf(address account) public view override returns (uint256) {
489         return _tOwned[account];
490     }
491 
492     function transfer(address recipient, uint256 amount) public override returns (bool) {
493         _transfer(_msgSender(), recipient, amount);
494         return true;
495     }
496 
497     function approve(address spender, uint256 amount) public override returns (bool) {
498         _approve(_msgSender(), spender, amount);
499         return true;
500     }
501 
502     function _approve(address sender, address spender, uint256 amount) private {
503         require(sender != address(0), "ERC20: Zero Address");
504         require(spender != address(0), "ERC20: Zero Address");
505 
506         _allowances[sender][spender] = amount;
507         emit Approval(sender, spender, amount);
508     }
509 
510     function approveContractContingency() public onlyOwner returns (bool) {
511         _approve(address(this), address(dexRouter), type(uint256).max);
512         return true;
513     }
514 
515     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
516         if (_allowances[sender][msg.sender] != type(uint256).max) {
517             _allowances[sender][msg.sender] -= amount;
518         }
519 
520         return _transfer(sender, recipient, amount);
521     }
522 
523     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
524         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
525         return true;
526     }
527 
528     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
529         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
530         return true;
531     }
532 
533     function setNewRouter(address newRouter) public onlyOwner() {
534         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
535         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
536         if (get_pair == address(0)) {
537             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
538         }
539         else {
540             lpPair = get_pair;
541         }
542         dexRouter = _newRouter;
543         _approve(address(this), address(dexRouter), type(uint256).max);
544     }
545 
546     function setLpPair(address pair, bool enabled) external onlyOwner {
547         if (enabled == false) {
548             lpPairs[pair] = false;
549             antiSnipe.setLpPair(pair, false);
550         } else {
551             if (timeSinceLastPair != 0) {
552                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
553             }
554             lpPairs[pair] = true;
555             timeSinceLastPair = block.timestamp;
556             antiSnipe.setLpPair(pair, true);
557         }
558     }
559 
560     function isExcludedFromFees(address account) public view returns(bool) {
561         return _isExcludedFromFees[account];
562     }
563 
564     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
565         _isExcludedFromFees[account] = enabled;
566     }
567 
568     function setInitializer(address initializer) external onlyOwner {
569         require(!_hasLiqBeenAdded, "Liquidity is already in.");
570         require(initializer != address(this), "Can't be self.");
571         antiSnipe = AntiSnipe(initializer);
572     }
573 
574     function removeSniper(address account) external onlyOwner() {
575         antiSnipe.removeSniper(account);
576     }
577 
578     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock) external onlyOwner() {
579         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock);
580     }
581 
582     function setGasPriceLimit(uint256 gas) external onlyOwner {
583         require(gas >= 75, "Too low.");
584         antiSnipe.setGasPriceLimit(gas);
585     }
586 
587     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {
588         require(buyFee <= staticVals.maxBuyTaxes
589                 && sellFee <=staticVals. maxSellTaxes
590                 && transferFee <= staticVals.maxTransferTaxes,
591                 "Cannot exceed maximums.");
592         _taxRates.buyFee = buyFee;
593         _taxRates.sellFee = sellFee;
594         _taxRates.transferFee = transferFee;
595     }
596 
597     function setRatios(uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
598         require (liquidity + marketing + development == 100, "Must add up to 100%");
599         _ratios.liquidity = liquidity;
600         _ratios.marketing = marketing;
601         _ratios.development = development;
602         _ratios.total = liquidity + marketing;
603     }
604 
605     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
606         uint256 check = (_tTotal * percent) / divisor;
607         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
608         _maxTxAmount = check;
609         maxTxAmountUI = (startingSupply * percent) / divisor;
610     }
611 
612     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
613         uint256 check = (_tTotal * percent) / divisor;
614         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
615         _maxWalletSize = check;
616         maxWalletSizeUI = (startingSupply * percent) / divisor;
617     }
618 
619     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
620         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
621         swapAmount = (_tTotal * amountPercent) / amountDivisor;
622     }
623 
624     function setWallets(address payable marketingWallet) external onlyOwner {
625         _marketingWallet = payable(marketingWallet);
626     }
627 
628     function setContractSwapEnabled(bool _enabled) public onlyOwner {
629         contractSwapEnabled = _enabled;
630         emit ContractSwapEnabledUpdated(_enabled);
631     }
632 
633     function _hasLimits(address from, address to) private view returns (bool) {
634         return from != owner()
635             && to != owner()
636             && !_liquidityHolders[to]
637             && !_liquidityHolders[from]
638             && to != DEAD
639             && to != address(0)
640             && from != address(this);
641     }
642 
643     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
644         require(from != address(0), "ERC20: transfer from the zero address");
645         require(to != address(0), "ERC20: transfer to the zero address");
646         require(amount > 0, "Transfer amount must be greater than zero");
647         if(_hasLimits(from, to)) {
648             if(!tradingEnabled) {
649                 revert("Trading not yet enabled!");
650             }
651             if(lpPairs[from] || lpPairs[to]){
652                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
653             }
654             if(to != _routerAddress && !lpPairs[to]) {
655                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
656             }
657         }
658 
659         bool takeFee = true;
660         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
661             takeFee = false;
662         }
663 
664         if (lpPairs[to]) {
665             if (!inSwap
666                 && contractSwapEnabled
667             ) {
668                 uint256 contractTokenBalance = balanceOf(address(this));
669                 if (contractTokenBalance >= swapThreshold) {
670                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
671                     contractSwap(contractTokenBalance);
672                 }
673             }      
674         } 
675         return _finalizeTransfer(from, to, amount, takeFee);
676     }
677 
678     uint256 public _aAaAmarketBal;
679     uint256 public _aAaAliquidityBal;
680 
681     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
682         if (_ratios.total == 0)
683             return;
684 
685         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
686             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
687         }
688 
689         uint256 toLiquify = ((contractTokenBalance * _ratios.liquidity) / _ratios.total) / 2;
690 
691         uint256 toSwapForEth = contractTokenBalance - toLiquify;
692         
693         address[] memory path = new address[](2);
694         path[0] = address(this);
695         path[1] = dexRouter.WETH();
696 
697         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
698             toSwapForEth,
699             0, // accept any amount of ETH
700             path,
701             address(this),
702             block.timestamp
703         );
704 
705         //uint256 currentBalance = address(this).balance;
706         uint256 liquidityBalance = ((address(this).balance * _ratios.liquidity) / _ratios.total) / 2;
707 
708         if (toLiquify > 0) {
709             dexRouter.addLiquidityETH{value: liquidityBalance}(
710                 address(this),
711                 toLiquify,
712                 0, // slippage is unavoidable
713                 0, // slippage is unavoidable
714                 DEAD,
715                 block.timestamp
716             );
717             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
718         }
719         if (contractTokenBalance - toLiquify > 0) {
720             _marketingWallet.transfer((address(this).balance * _ratios.marketing) / (_ratios.marketing + _ratios.development));
721             _developmentWallet.transfer(address(this).balance);
722         }
723     }
724 
725     function _checkLiquidityAdd(address from, address to) private {
726         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
727         if (!_hasLimits(from, to) && to == lpPair) {
728             _liquidityHolders[from] = true;
729             _hasLiqBeenAdded = true;
730             if(address(antiSnipe) == address(0)){
731                 antiSnipe = AntiSnipe(address(this));
732             }
733             contractSwapEnabled = true;
734             emit ContractSwapEnabledUpdated(true);
735         }
736     }
737 
738     function enableTrading() public onlyOwner {
739         require(!tradingEnabled, "Trading already enabled!");
740         require(_hasLiqBeenAdded, "Liquidity must be added.");
741         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp)) {} catch {}
742         tradingEnabled = true;
743     }
744 
745     function sweepContingency() external onlyOwner {
746         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
747         payable(owner()).transfer(address(this).balance);
748     }
749 
750     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
751         if (!_hasLiqBeenAdded) {
752             _checkLiquidityAdd(from, to);
753             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
754                 revert("Only owner can transfer at this time.");
755             }
756         }
757 
758         if (_hasLimits(from, to)) {
759             bool checked;
760             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
761                 checked = check;
762             } catch {
763                 revert();
764             }
765 
766             if(!checked) {
767                 revert();
768             }
769         }
770 
771         _tOwned[from] -= amount;
772         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
773         _tOwned[to] += amountReceived;
774 
775         emit Transfer(from, to, amountReceived);
776         return true;
777     }
778 
779     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
780         uint256 currentFee;
781         if (from == lpPair) {
782             currentFee = _taxRates.buyFee;
783         } else if (to == lpPair) {
784             currentFee = _taxRates.sellFee;
785         } else {
786             currentFee = _taxRates.transferFee;
787         }
788 
789         uint256 feeAmount = amount * currentFee / staticVals.masterTaxDivisor;
790 
791         _tOwned[address(this)] += feeAmount;
792         emit Transfer(from, address(this), feeAmount);
793 
794         return amount - feeAmount;
795     }
796 }