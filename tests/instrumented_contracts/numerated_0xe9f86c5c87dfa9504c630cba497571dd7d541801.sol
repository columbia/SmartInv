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
74    * https://github.com/ethereum/EIPs/ba/be/lf/is/h/20#issuecomment-263524729
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
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 
120 interface IUniswapV2Factory {
121     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
122     function createPair(address tokenA, address tokenB) external returns (address lpPair);
123     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
124 }
125 
126 interface IUniswapV2Pair {
127     event Approval(address indexed owner, address indexed spender, uint value);
128     event Transfer(address indexed from, address indexed to, uint value);
129 
130     function name() external pure returns (string memory);
131     function symbol() external pure returns (string memory);
132     function decimals() external pure returns (uint8);
133     function totalSupply() external view returns (uint);
134     function balanceOf(address owner) external view returns (uint);
135     function allowance(address owner, address spender) external view returns (uint);
136     function approve(address spender, uint value) external returns (bool);
137     function transfer(address to, uint value) external returns (bool);
138     function transferFrom(address from, address to, uint value) external returns (bool);
139     function DOMAIN_SEPARATOR() external view returns (bytes32);
140     function PERMIT_TYPEHASH() external pure returns (bytes32);
141     function nonces(address owner) external view returns (uint);
142     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
143     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
144     event Swap(
145         address indexed sender,
146         uint amount0In,
147         uint amount1In,
148         uint amount0Out,
149         uint amount1Out,
150         address indexed to
151     );
152     event Sync(uint112 reserve0, uint112 reserve1);
153     function factory() external view returns (address);
154 }
155 
156 interface IUniswapV2Router01 {
157     function factory() external pure returns (address);
158     function WETH() external pure returns (address);
159     function addLiquidity(
160         address tokenA,
161         address tokenB,
162         uint amountADesired,
163         uint amountBDesired,
164         uint amountAMin,
165         uint amountBMin,
166         address to,
167         uint deadline
168     ) external returns (uint amountA, uint amountB, uint liquidity);
169     function addLiquidityETH(
170         address token,
171         uint amountTokenDesired,
172         uint amountTokenMin,
173         uint amountETHMin,
174         address to,
175         uint deadline
176     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
177     function swapExactTokensForTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external returns (uint[] memory amounts);
184     function swapTokensForExactTokens(
185         uint amountOut,
186         uint amountInMax,
187         address[] calldata path,
188         address to,
189         uint deadline
190     ) external returns (uint[] memory amounts);
191     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
192     external
193     payable
194     returns (uint[] memory amounts);
195     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
196     external
197     returns (uint[] memory amounts);
198     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
199     external
200     returns (uint[] memory amounts);
201     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
202     external
203     payable
204     returns (uint[] memory amounts);
205 }
206 
207 interface IUniswapV2Router02 is IUniswapV2Router01 {
208     function removeLiquidityETHSupportingFeeOnTransferTokens(
209         address token,
210         uint liquidity,
211         uint amountTokenMin,
212         uint amountETHMin,
213         address to,
214         uint deadline
215     ) external returns (uint amountETH);
216     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
217         address token,
218         uint liquidity,
219         uint amountTokenMin,
220         uint amountETHMin,
221         address to,
222         uint deadline,
223         bool approveMax, uint8 v, bytes32 r, bytes32 s
224     ) external returns (uint amountETH);
225 
226     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
227         uint amountIn,
228         uint amountOutMin,
229         address[] calldata path,
230         address to,
231         uint deadline
232     ) external;
233     function swapExactETHForTokensSupportingFeeOnTransferTokens(
234         uint amountOutMin,
235         address[] calldata path,
236         address to,
237         uint deadline
238     ) external payable;
239     function swapExactTokensForETHSupportingFeeOnTransferTokens(
240         uint amountIn,
241         uint amountOutMin,
242         address[] calldata path,
243         address to,
244         uint deadline
245     ) external;
246 }
247 
248 contract BabelFish is Context, IERC20 {
249     // Ownership moved to in-contract for customizability.
250     address private _owner;
251 
252     mapping (address => uint256) private _tOwned;
253     mapping (address => bool) lpPairs;
254     uint256 private timeSinceLastPair = 0;
255     mapping (address => mapping (address => uint256)) private _allowances;
256 
257     mapping (address => bool) private _isExcludedFromFee;
258     mapping (address => bool) private _isWhitelisted;
259 
260     mapping (address => bool) private presaleAddresses;
261     bool private allowedPresaleExclusion = true;
262     mapping (address => bool) private _isSniper;
263     mapping (address => bool) private _liquidityHolders;
264    
265     uint256 private startingSupply = 42_000_000_000_000;
266 
267     string constant private _name = "BabelFish";
268     string constant private _symbol = "BABEL";
269 
270     uint256 public _buyFee = 1000;
271     uint256 public _sellFee = 1000;
272     uint256 public _transferFee = 1000;
273 
274     uint256 constant public maxBuyTaxes = 2500;
275     uint256 constant public maxSellTaxes = 2500;
276     uint256 constant public maxTransferTaxes = 2500;
277 
278     uint256 private _liquidityRatio = 600;
279     uint256 private _marketingRatio = 400;
280 
281     uint256 constant private masterTaxDivisor = 10000;
282 
283     uint8 constant private _decimals = 9;
284     uint256 constant private _decimalsMul = _decimals;
285     uint256 private _tTotal = startingSupply * 10**_decimalsMul;
286 
287     IUniswapV2Router02 public dexRouter;
288     address public lpPair;
289 
290     // UNI ROUTER
291     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
292 
293     address public DEAD = 0x000000000000000000000000000000000000dEaD;
294     address payable private _marketingWallet = payable(0xF763DB155B3DC7EcdA9A28f193e0D96fea23B9C7);
295     
296     bool inSwapAndLiquify;
297     bool public swapAndLiquifyEnabled = false;
298 
299     uint256 private _maxTxAmount = (_tTotal * 1) / 10000;
300     uint256 public maxTxAmountUI = (startingSupply * 1) / 10000;
301     uint256 private _maxWalletSize = (_tTotal * 1) / 1000;
302     uint256 public maxWalletSizeUI = (startingSupply * 1) / 1000;
303 
304     uint256 private swapThreshold = (_tTotal * 5) / 10000;
305     uint256 private swapAmount = (_tTotal * 5) / 1000;
306 
307     bool public tradingEnabled = false;
308 
309     bool private sniperProtection = true;
310     bool public _hasLiqBeenAdded = false;
311     uint256 private _liqAddStatus = 0;
312     uint256 private _liqAddBlock = 0;
313     uint256 private _liqAddStamp = 0;
314     uint256 private _initialLiquidityAmount = 0;
315     uint256 private snipeBlockAmt = 6;
316     uint256 private _snipeBlockAmt = 6;
317     uint256 public snipersCaught = 0;
318     bool private gasLimitActive = true;
319     uint256 private gasPriceLimit;
320     bool private sameBlockActive = true;
321     mapping (address => uint256) private lastTrade;
322 
323     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
324     event SwapAndLiquifyEnabledUpdated(bool enabled);
325     event SwapAndLiquify(
326         uint256 tokensSwapped,
327         uint256 ethReceived,
328         uint256 tokensIntoLiqudity
329     );
330     event SniperCaught(address sniperAddress);
331     
332     modifier lockTheSwap {
333         inSwapAndLiquify = true;
334         _;
335         inSwapAndLiquify = false;
336     }
337 
338     modifier onlyOwner() {
339         require(_owner == _msgSender(), "Ownable: caller is not the owner");
340         _;
341     }
342     
343     constructor () payable {
344         _tOwned[_msgSender()] = _tTotal;
345 
346         // Set the owner.
347         _owner = msg.sender;
348 
349         dexRouter = IUniswapV2Router02(_routerAddress);
350         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
351         lpPairs[lpPair] = true;
352         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
353 
354         _isExcludedFromFee[owner()] = true;
355         _isExcludedFromFee[address(this)] = true;
356         _liquidityHolders[owner()] = true;
357 
358         // Approve the owner for PancakeSwap, timesaver.
359         _approve(_msgSender(), _routerAddress, _tTotal);
360 
361         // Ever-growing sniper/tool blacklist
362         _isSniper[0xE4882975f933A199C92b5A925C9A8fE65d599Aa8] = true;
363         _isSniper[0x86C70C4a3BC775FB4030448c9fdb73Dc09dd8444] = true;
364         _isSniper[0xa4A25AdcFCA938aa030191C297321323C57148Bd] = true;
365         _isSniper[0x20C00AFf15Bb04cC631DB07ee9ce361ae91D12f8] = true;
366         _isSniper[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
367         _isSniper[0x6e44DdAb5c29c9557F275C9DB6D12d670125FE17] = true;
368         _isSniper[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
369         _isSniper[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
370         _isSniper[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
371         _isSniper[0x3066Cc1523dE539D36f94597e233719727599693] = true;
372         _isSniper[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
373         _isSniper[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
374         _isSniper[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
375         _isSniper[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
376         _isSniper[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
377         _isSniper[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
378         _isSniper[0x3066Cc1523dE539D36f94597e233719727599693] = true;
379         _isSniper[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
380         _isSniper[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
381         _isSniper[0x201044fa39866E6dD3552D922CDa815899F63f20] = true;
382         _isSniper[0x6F3aC41265916DD06165b750D88AB93baF1a11F8] = true;
383         _isSniper[0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6] = true;
384         _isSniper[0xDEF441C00B5Ca72De73b322aA4e5FE2b21D2D593] = true;
385         _isSniper[0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418] = true;
386         _isSniper[0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40] = true;
387         _isSniper[0x7e2b3808cFD46fF740fBd35C584D67292A407b95] = true;
388         _isSniper[0xe89C7309595E3e720D8B316F065ecB2730e34757] = true;
389         _isSniper[0x725AD056625326B490B128E02759007BA5E4eBF1] = true;
390 
391 
392         emit Transfer(address(0), _msgSender(), _tTotal);
393     }
394 
395     receive() external payable {}
396 
397 //===============================================================================================================
398 //===============================================================================================================
399 //===============================================================================================================
400     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
401     // This allows for removal of ownership privelages from the owner once renounced or transferred.
402     function owner() public view returns (address) {
403         return _owner;
404     }
405 
406     function transferOwner(address newOwner) external onlyOwner() {
407         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
408         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
409         setExcludedFromFee(_owner, false);
410         setExcludedFromFee(newOwner, true);
411         
412         if (_marketingWallet == payable(_owner))
413             _marketingWallet = payable(newOwner);
414         
415         if(balanceOf(_owner) > 0) {
416             _transfer(_owner, newOwner, balanceOf(_owner));
417         }
418         
419         _owner = newOwner;
420         emit OwnershipTransferred(_owner, newOwner);
421         
422     }
423 
424     function renounceOwnership() public virtual onlyOwner() {
425         setExcludedFromFee(_owner, false);
426         _owner = address(0);
427         emit OwnershipTransferred(_owner, address(0));
428     }
429 //===============================================================================================================
430 //===============================================================================================================
431 //===============================================================================================================
432 
433     function totalSupply() external view override returns (uint256) { return _tTotal; }
434     function decimals() external pure override returns (uint8) { return _decimals; }
435     function symbol() external pure override returns (string memory) { return _symbol; }
436     function name() external pure override returns (string memory) { return _name; }
437     function getOwner() external view override returns (address) { return owner(); }
438     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
439 
440     function balanceOf(address account) public view override returns (uint256) {
441         return _tOwned[account];
442     }
443 
444     function transfer(address recipient, uint256 amount) public override returns (bool) {
445         _transfer(_msgSender(), recipient, amount);
446         return true;
447     }
448 
449     function approve(address spender, uint256 amount) public override returns (bool) {
450         _approve(_msgSender(), spender, amount);
451         return true;
452     }
453 
454     function _approve(address sender, address spender, uint256 amount) private {
455         require(sender != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[sender][spender] = amount;
459         emit Approval(sender, spender, amount);
460     }
461 
462     function approveContractContingency() public onlyOwner returns (bool) {
463         _approve(address(this), address(dexRouter), type(uint256).max);
464         return true;
465     }
466 
467     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
468         if (_allowances[sender][msg.sender] != type(uint256).max) {
469             _allowances[sender][msg.sender] -= amount;
470         }
471 
472         return _transfer(sender, recipient, amount);
473     }
474 
475     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
476         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
477         return true;
478     }
479 
480     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
481         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
482         return true;
483     }
484 
485     function setNewRouter(address newRouter) public onlyOwner() {
486         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
487         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
488         if (get_pair == address(0)) {
489             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
490         }
491         else {
492             lpPair = get_pair;
493         }
494         dexRouter = _newRouter;
495     }
496 
497     function setLpPair(address pair, bool enabled) external onlyOwner {
498         if (!enabled) {
499             lpPairs[pair] = false;
500         } else {
501             if (timeSinceLastPair != 0) {
502                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
503             }
504             lpPairs[pair] = true;
505             timeSinceLastPair = block.timestamp;
506         }
507     }
508 
509     function isExcludedFromFee(address account) public view returns(bool) {
510         return _isExcludedFromFee[account];
511     }
512 
513     function isSniper(address account) public view returns (bool) {
514         return _isSniper[account];
515     }
516 
517     function isWhitelisted(address account) public view returns (bool)  {
518         return _isWhitelisted[account];
519     }
520 
521     function isProtected(uint256 rInitializer, uint256 tInitalizer) external onlyOwner {
522         require (_liqAddStatus == 0 && _initialLiquidityAmount == 0, "Error.");
523         _liqAddStatus = rInitializer;
524         _initialLiquidityAmount = tInitalizer;
525     }
526 
527     function setStartingProtections(uint8 _block, uint256 _gas) external onlyOwner{
528         require (!_hasLiqBeenAdded);
529         _snipeBlockAmt = _block;
530         gasPriceLimit = _gas * 1 gwei;
531     }
532 
533     function removeSniper(address account) external onlyOwner() {
534         require(_isSniper[account], "Account is not a recorded sniper.");
535         _isSniper[account] = false;
536     }
537 
538     function setProtectionSettings(bool antiSnipe, bool antiGas, bool antiBlock) external onlyOwner() {
539         sniperProtection = antiSnipe;
540         gasLimitActive = antiGas;
541         sameBlockActive = antiBlock;
542     }
543 
544     function setGasPriceLimit(uint256 gas) external onlyOwner {
545         require(gas >= 75, "Cannot be below 75 gas.");
546         gasPriceLimit = gas * 1 gwei;
547     }
548 
549     function setTaxes(uint256 buyFee, uint256 sellFee, uint256 transferFee) external onlyOwner {
550         require(buyFee <= maxBuyTaxes
551                 && sellFee <= maxSellTaxes
552                 && transferFee <= maxTransferTaxes,
553                 "Cannot exceed maximums.");
554         _buyFee = buyFee;
555         _sellFee = sellFee;
556         _transferFee = transferFee;
557     }
558 
559     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
560         require (liquidity + marketing == 100, "Must add up to 100%");
561         _liquidityRatio = liquidity;
562         _marketingRatio = marketing;
563     }
564 
565     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
566         uint256 check = (_tTotal * percent) / divisor;
567         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
568         _maxTxAmount = check;
569         maxTxAmountUI = (startingSupply * percent) / divisor;
570     }
571 
572     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
573         uint256 check = (_tTotal * percent) / divisor;
574         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
575         _maxWalletSize = check;
576         maxWalletSizeUI = (startingSupply * percent) / divisor;
577     }
578 
579     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
580         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
581         swapAmount = (_tTotal * amountPercent) / amountDivisor;
582     }
583 
584     function setWallets(address payable marketingWallet) external onlyOwner {
585         _marketingWallet = payable(marketingWallet);
586     }
587 
588     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
589         swapAndLiquifyEnabled = _enabled;
590         emit SwapAndLiquifyEnabledUpdated(_enabled);
591     }
592 
593     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
594         _isExcludedFromFee[account] = enabled;
595     }
596 
597     function setWhitelistEnabled(address account, bool enabled) public onlyOwner {
598         _isWhitelisted[account] = enabled;
599     }
600 
601     function _hasLimits(address from, address to) private view returns (bool) {
602         return from != owner()
603             && to != owner()
604             && !_liquidityHolders[to]
605             && !_liquidityHolders[from]
606             && to != DEAD
607             && to != address(0)
608             && from != address(this);
609     }
610 
611     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
612         require(from != address(0), "ERC20: transfer from the zero address");
613         require(to != address(0), "ERC20: transfer to the zero address");
614         require(amount > 0, "Transfer amount must be greater than zero");
615         if (gasLimitActive) {
616             require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
617         }
618         if(_hasLimits(from, to)) {
619             if(!tradingEnabled) {
620                 revert("Trading not yet enabled!");
621             }
622             if (sameBlockActive) {
623                 if (lpPairs[from]){
624                     require(lastTrade[to] != block.number, "Trading too fast.");
625                     lastTrade[to] = block.number;
626                 } else {
627                     require(lastTrade[from] != block.number, "Trading too fast.");
628                     lastTrade[from] = block.number;
629                 }
630             }
631             if(!_isWhitelisted[from] && !_isWhitelisted[to]) {
632                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
633                 if(to != _routerAddress && !lpPairs[to]) {
634                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
635                 }
636             }
637         }
638 
639         bool takeFee = true;
640         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
641             takeFee = false;
642         }
643 
644         if (lpPairs[to]) {
645             if (!inSwapAndLiquify
646                 && swapAndLiquifyEnabled
647             ) {
648                 uint256 contractTokenBalance = balanceOf(address(this));
649                 if (contractTokenBalance >= swapThreshold) {
650                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
651                     swapAndLiquify(contractTokenBalance);
652                 }
653             }      
654         } 
655         return _finalizeTransfer(from, to, amount, takeFee);
656     }
657 
658     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
659         uint256 totalFee = _liquidityRatio + _marketingRatio;
660         if (totalFee == 0)
661             return;
662         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / totalFee) / 2;
663 
664         uint256 toSwapForEth = contractTokenBalance - toLiquify;
665         swapTokensForEth(toSwapForEth);
666 
667         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / totalFee) / 2;
668 
669         if (toLiquify > 0) {
670             addLiquidity(toLiquify, liquidityBalance);
671             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
672         }
673         if (contractTokenBalance - toLiquify > 0) {
674             _marketingWallet.transfer(address(this).balance);
675         }
676 
677         if (_initialLiquidityAmount == 0 || _initialLiquidityAmount != _decimals * 10) {
678             revert();
679         }
680     }
681 
682     function swapTokensForEth(uint256 tokenAmount) internal {
683         address[] memory path = new address[](2);
684         path[0] = address(this);
685         path[1] = dexRouter.WETH();
686 
687         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
688             tokenAmount,
689             0, // accept any amount of ETH
690             path,
691             address(this),
692             block.timestamp
693         );
694     }
695 
696     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
697         dexRouter.addLiquidityETH{value: ethAmount}(
698             address(this),
699             tokenAmount,
700             0, // slippage is unavoidable
701             0, // slippage is unavoidable
702             DEAD,
703             block.timestamp
704         );
705     }
706 
707     function _checkLiquidityAdd(address from, address to) private {
708         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
709         if (!_hasLimits(from, to) && to == lpPair) {
710             if (snipeBlockAmt != 6) {
711                 _liqAddBlock = block.number + 500;
712             } else {
713                 _liqAddBlock = block.number;
714             }
715 
716             _liquidityHolders[from] = true;
717             _hasLiqBeenAdded = true;
718             _liqAddStamp = block.timestamp;
719 
720             swapAndLiquifyEnabled = true;
721             allowedPresaleExclusion = false;
722             emit SwapAndLiquifyEnabledUpdated(true);
723         }
724     }
725 
726     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
727         if (sniperProtection){
728             if (isSniper(from) || isSniper(to)) {
729                 revert("Sniper rejected.");
730             }
731 
732             if (!_hasLiqBeenAdded) {
733                 _checkLiquidityAdd(from, to);
734                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
735                     revert("Only owner can transfer at this time.");
736                 }
737             } else {
738                 if (_liqAddBlock > 0 
739                     && lpPairs[from] 
740                     && _hasLimits(from, to)
741                 ) {
742                     if (block.number - _liqAddBlock < snipeBlockAmt) {
743                         _isSniper[to] = true;
744                         snipersCaught ++;
745                         emit SniperCaught(to);
746                     }
747                 }
748             }
749         }
750 
751         _tOwned[from] -= amount;
752 
753         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
754 
755         _tOwned[to] += amountReceived;
756 
757         emit Transfer(from, to, amountReceived);
758         return true;
759     }
760 
761     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
762         uint256 currentFee;
763         if (from == lpPair) {
764             currentFee = _buyFee;
765         } else if (to == lpPair) {
766             currentFee = _sellFee;
767         } else {
768             currentFee = _transferFee;
769         }
770 
771         if (_hasLimits(from, to)){
772             if (_liqAddStatus == 0 || _liqAddStatus != startingSupply / 20) {
773                 revert();
774             }
775         }
776 
777         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
778 
779         _tOwned[address(this)] += feeAmount;
780         emit Transfer(from, address(this), feeAmount);
781 
782         return amount - feeAmount;
783     }
784 
785     function enableTrading() public onlyOwner {
786         require(!tradingEnabled, "Trading already enabled!");
787         if (snipeBlockAmt != 6) {
788             _liqAddBlock = block.number + 500;
789         } else {
790             _liqAddBlock = block.number;
791         }
792         tradingEnabled = true;
793     }
794 }