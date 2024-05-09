1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 As the year 2023 approaches, the astrological signs are aligning to bring about a time
6 of great change and transformation. And with the water rabbit year fast approaching,
7 it's no surprise that many are feeling a sense of excitement and anticipation.
8 
9 According to legend, the water rabbit is known for its ability to navigate even the most
10 turbulent of waters with grace and poise. But this year, something mysterious is afoot –
11 and even the most seasoned individuals may find themselves feeling a bit out of their element.
12 
13 Rumors are swirling about a mysterious event that is said to take place
14 during the year of the water rabbit, an event that will shake the foundations
15 of the $WR cryptocurrency market to its very core. Some say it will be a major
16 breakthrough, while others fear it could spell disaster for those who are unprepared.
17 
18 No one knows exactly what will happen, but one thing is certain – the water rabbit year
19 is sure to be full of surprises. So stay alert and stay ready for whatever the future may bring.
20 Whether you burn or shine, one thing is for sure – it's going to be an exciting ride.
21 
22 */
23 
24 
25 pragma solidity >=0.6.0 <0.9.0;
26 
27 abstract contract Context {
28     function _msgSender() internal view returns (address payable) {
29         return payable(msg.sender);
30     }
31 
32     function _msgData() internal view returns (bytes memory) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 interface IERC20 {
39   /**
40    * @dev Returns the amount of tokens in existence.
41    */
42   function totalSupply() external view returns (uint256);
43 
44   /**
45    * @dev Returns the token decimals.
46    */
47   function decimals() external view returns (uint8);
48 
49   /**
50    * @dev Returns the token symbol.
51    */
52   function symbol() external view returns (string memory);
53 
54   /**
55   * @dev Returns the token name.
56   */
57   function name() external view returns (string memory);
58 
59   /**
60    * @dev Returns the bep token owner.
61    */
62   function getOwner() external view returns (address);
63 
64   /**
65    * @dev Returns the amount of tokens owned by `account`.
66    */
67   function balanceOf(address account) external view returns (uint256);
68 
69   /**
70    * @dev Moves `amount` tokens from the caller's account to `recipient`.
71    *
72    * Returns a boolean value indicating whether the operation succeeded.
73    *
74    * Emits a {Transfer} event.
75    */
76   function transfer(address recipient, uint256 amount) external returns (bool);
77 
78   /**
79    * @dev Returns the remaining number of tokens that `spender` will be
80    * allowed to spend on behalf of `owner` through {transferFrom}. This is
81    * zero by default.
82    *
83    * This value changes when {approve} or {transferFrom} are called.
84    */
85   function allowance(address _owner, address spender) external view returns (uint256);
86 
87   /**
88    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
89    *
90    * Returns a boolean value indicating whether the operation succeeded.
91    *
92    * IMPORTANT: Beware that changing an allowance with this method brings the risk
93    * that someone may use both the old and the new allowance by unfortunate
94    * transaction ordering. One possible solution to mitigate this race
95    * condition is to first reduce the spender's allowance to 0 and set the
96    * desired value afterwards:
97    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98    *
99    * Emits an {Approval} event.
100    */
101   function approve(address spender, uint256 amount) external returns (bool);
102 
103   /**
104    * @dev Moves `amount` tokens from `sender` to `recipient` using the
105    * allowance mechanism. `amount` is then deducted from the caller's
106    * allowance.
107    *
108    * Returns a boolean value indicating whether the operation succeeded.
109    *
110    * Emits a {Transfer} event.
111    */
112   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113 
114   /**
115    * @dev Emitted when `value` tokens are moved from one account (`from`) to
116    * another (`to`).
117    *
118    * Note that `value` may be zero.
119    */
120   event Transfer(address indexed from, address indexed to, uint256 value);
121 
122   /**
123    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124    * a call to {approve}. `value` is the new allowance.
125    */
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 /**
130  * @dev Wrappers over Solidity's arithmetic operations with added overflow
131  * checks.
132  *
133  * Arithmetic operations in Solidity wrap on overflow. This can easily result
134  * in bugs, because programmers usually assume that an overflow raises an
135  * error, which is the standard behavior in high level programming languages.
136  * `SafeMath` restores this intuition by reverting the transaction when an
137  * operation overflows.
138  *
139  * Using this library instead of the unchecked operations eliminates an entire
140  * class of bugs, so it's recommended to use it always.
141  */
142 
143 interface IUniswapV2Factory {
144     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
145     function feeTo() external view returns (address);
146     function feeToSetter() external view returns (address);
147     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
148     function allPairs(uint) external view returns (address lpPair);
149     function allPairsLength() external view returns (uint);
150     function createPair(address tokenA, address tokenB) external returns (address lpPair);
151     function setFeeTo(address) external;
152     function setFeeToSetter(address) external;
153 }
154 
155 interface IUniswapV2Pair {
156     event Approval(address indexed owner, address indexed spender, uint value);
157     event Transfer(address indexed from, address indexed to, uint value);
158 
159     function name() external pure returns (string memory);
160     function symbol() external pure returns (string memory);
161     function decimals() external pure returns (uint8);
162     function totalSupply() external view returns (uint);
163     function balanceOf(address owner) external view returns (uint);
164     function allowance(address owner, address spender) external view returns (uint);
165     function approve(address spender, uint value) external returns (bool);
166     function transfer(address to, uint value) external returns (bool);
167     function transferFrom(address from, address to, uint value) external returns (bool);
168     function DOMAIN_SEPARATOR() external view returns (bytes32);
169     function PERMIT_TYPEHASH() external pure returns (bytes32);
170     function nonces(address owner) external view returns (uint);
171     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
172     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
173     event Swap(
174         address indexed sender,
175         uint amount0In,
176         uint amount1In,
177         uint amount0Out,
178         uint amount1Out,
179         address indexed to
180     );
181     event Sync(uint112 reserve0, uint112 reserve1);
182 
183     function MINIMUM_LIQUIDITY() external pure returns (uint);
184     function factory() external view returns (address);
185     function token0() external view returns (address);
186     function token1() external view returns (address);
187     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
188     function price0CumulativeLast() external view returns (uint);
189     function price1CumulativeLast() external view returns (uint);
190     function kLast() external view returns (uint);
191     function mint(address to) external returns (uint liquidity);
192     function burn(address to) external returns (uint amount0, uint amount1);
193     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
194     function skim(address to) external;
195     function sync() external;
196     function initialize(address, address) external;
197 }
198 
199 interface IUniswapV2Router01 {
200     function factory() external pure returns (address);
201     function WETH() external pure returns (address);
202     function addLiquidity(
203         address tokenA,
204         address tokenB,
205         uint amountADesired,
206         uint amountBDesired,
207         uint amountAMin,
208         uint amountBMin,
209         address to,
210         uint deadline
211     ) external returns (uint amountA, uint amountB, uint liquidity);
212     function addLiquidityETH(
213         address token,
214         uint amountTokenDesired,
215         uint amountTokenMin,
216         uint amountETHMin,
217         address to,
218         uint deadline
219     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
220     function removeLiquidity(
221         address tokenA,
222         address tokenB,
223         uint liquidity,
224         uint amountAMin,
225         uint amountBMin,
226         address to,
227         uint deadline
228     ) external returns (uint amountA, uint amountB);
229     function removeLiquidityETH(
230         address token,
231         uint liquidity,
232         uint amountTokenMin,
233         uint amountETHMin,
234         address to,
235         uint deadline
236     ) external returns (uint amountToken, uint amountETH);
237     function removeLiquidityWithPermit(
238         address tokenA,
239         address tokenB,
240         uint liquidity,
241         uint amountAMin,
242         uint amountBMin,
243         address to,
244         uint deadline,
245         bool approveMax, uint8 v, bytes32 r, bytes32 s
246     ) external returns (uint amountA, uint amountB);
247     function removeLiquidityETHWithPermit(
248         address token,
249         uint liquidity,
250         uint amountTokenMin,
251         uint amountETHMin,
252         address to,
253         uint deadline,
254         bool approveMax, uint8 v, bytes32 r, bytes32 s
255     ) external returns (uint amountToken, uint amountETH);
256     function swapExactTokensForTokens(
257         uint amountIn,
258         uint amountOutMin,
259         address[] calldata path,
260         address to,
261         uint deadline
262     ) external returns (uint[] memory amounts);
263     function swapTokensForExactTokens(
264         uint amountOut,
265         uint amountInMax,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external returns (uint[] memory amounts);
270     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
271     external
272     payable
273     returns (uint[] memory amounts);
274     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
275     external
276     returns (uint[] memory amounts);
277     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
278     external
279     returns (uint[] memory amounts);
280     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
281     external
282     payable
283     returns (uint[] memory amounts);
284 
285     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
286     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
287     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
288     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
289     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
290 }
291 
292 interface IUniswapV2Router02 is IUniswapV2Router01 {
293     function removeLiquidityETHSupportingFeeOnTransferTokens(
294         address token,
295         uint liquidity,
296         uint amountTokenMin,
297         uint amountETHMin,
298         address to,
299         uint deadline
300     ) external returns (uint amountETH);
301     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
302         address token,
303         uint liquidity,
304         uint amountTokenMin,
305         uint amountETHMin,
306         address to,
307         uint deadline,
308         bool approveMax, uint8 v, bytes32 r, bytes32 s
309     ) external returns (uint amountETH);
310 
311     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
312         uint amountIn,
313         uint amountOutMin,
314         address[] calldata path,
315         address to,
316         uint deadline
317     ) external;
318     function swapExactETHForTokensSupportingFeeOnTransferTokens(
319         uint amountOutMin,
320         address[] calldata path,
321         address to,
322         uint deadline
323     ) external payable;
324     function swapExactTokensForETHSupportingFeeOnTransferTokens(
325         uint amountIn,
326         uint amountOutMin,
327         address[] calldata path,
328         address to,
329         uint deadline
330     ) external;
331 }
332 
333 contract WaterRabbit is Context, IERC20 {
334     // Ownership moved to in-contract for customizability.
335     address private _owner;
336 
337     mapping (address => uint256) private _rOwned;
338     mapping (address => uint256) private _tOwned;
339     mapping (address => bool) lpPairs;
340     uint256 private timeSinceLastPair = 0;
341     mapping (address => mapping (address => uint256)) private _allowances;
342 
343     mapping (address => bool) private _isExcludedFromFee;
344     mapping (address => bool) private _isExcluded;
345     address[] private _excluded;
346 
347     mapping (address => bool) private _isSniper;
348     mapping (address => bool) private _liquidityHolders;
349    
350     uint256 private startingSupply = 1_000_000_000_000;
351 
352     string private _name = "Water Rabbit";
353     string private _symbol = "WR";
354 
355     uint256 public _reflectFee = 10;
356     uint256 public _marketingFee = 3500;
357 
358     uint256 private maxReflectFee = 90;
359     uint256 private maxMarketingFee = 3500;
360     uint256 private masterTaxDivisor = 10000;
361 
362     uint256 private constant MAX = ~uint256(0);
363     uint8 private _decimals = 9;
364     uint256 private _decimalsMul = _decimals;
365     uint256 private _tTotal = startingSupply * 10**_decimalsMul;
366     uint256 private _rTotal = (MAX - (MAX % _tTotal));
367     uint256 private _tFeeTotal;
368 
369     IUniswapV2Router02 public dexRouter;
370     address public lpPair;
371 
372     // UNI ROUTER
373     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
374 
375     address public DEAD = 0x000000000000000000000000000000000000dEaD;
376     address public ZERO = 0x0000000000000000000000000000000000000000;
377     address payable private _marketingWallet = payable(0x0A4835aB2A9163F4b4e731Aa680bF5Bc23b193c0);
378     
379     bool inSwapAndLiquify;
380     bool public swapAndLiquifyEnabled = false;
381     
382     uint256 private maxTxPercent = 2;
383     uint256 private maxTxDivisor = 100;
384     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
385     uint256 private _previousMaxTxAmount = _maxTxAmount;
386     uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor;
387 
388     uint256 private maxWalletPercent = 2;
389     uint256 private maxWalletDivisor = 100;
390     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
391     uint256 private _previousMaxWalletSize = _maxWalletSize;
392     uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor;
393 
394     uint256 private swapThreshold = (_tTotal * 5) / 10000;
395     uint256 private swapAmount = (_tTotal * 5) / 1000;
396 
397     bool tradingEnabled = false;
398 
399     bool private sniperProtection = true;
400     bool public _hasLiqBeenAdded = false;
401     uint256 private _liqAddStatus = 0;
402     uint256 private _liqAddBlock = 0;
403     uint256 private _liqAddStamp = 0;
404     uint256 private _initialLiquidityAmount = 0;
405     uint256 private snipeBlockAmt = 0;
406     uint256 public snipersCaught = 0;
407     bool private sameBlockActive = true;
408     mapping (address => uint256) private lastTrade;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
412     event SwapAndLiquifyEnabledUpdated(bool enabled);
413     event SwapAndLiquify(
414         uint256 tokensSwapped,
415         uint256 ethReceived,
416         uint256 tokensIntoLiqudity
417     );
418     event SniperCaught(address sniperAddress);
419     
420     modifier lockTheSwap {
421         inSwapAndLiquify = true;
422         _;
423         inSwapAndLiquify = false;
424     }
425 
426     modifier onlyOwner() {
427         require(_owner == _msgSender(), "Ownable: caller is not the owner");
428         _;
429     }
430     
431     constructor () payable {
432         _rOwned[_msgSender()] = _rTotal;
433 
434         // Set the owner.
435         _owner = msg.sender;
436 
437         _isExcludedFromFee[owner()] = true;
438         _isExcludedFromFee[address(this)] = true;
439         _liquidityHolders[owner()] = true;
440 
441         // Approve the owner for PancakeSwap, timesaver.
442         _approve(_msgSender(), _routerAddress, MAX);
443         _approve(address(this), _routerAddress, MAX);
444 
445         // Ever-growing sniper/tool blacklist
446         _isSniper[0xE4882975f933A199C92b5A925C9A8fE65d599Aa8] = true;
447         _isSniper[0x86C70C4a3BC775FB4030448c9fdb73Dc09dd8444] = true;
448         _isSniper[0xa4A25AdcFCA938aa030191C297321323C57148Bd] = true;
449         _isSniper[0x20C00AFf15Bb04cC631DB07ee9ce361ae91D12f8] = true;
450         _isSniper[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
451         _isSniper[0x6e44DdAb5c29c9557F275C9DB6D12d670125FE17] = true;
452         _isSniper[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
453         _isSniper[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
454         _isSniper[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
455         _isSniper[0x3066Cc1523dE539D36f94597e233719727599693] = true;
456         _isSniper[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
457         _isSniper[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
458         _isSniper[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
459         _isSniper[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
460         _isSniper[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
461         _isSniper[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
462         _isSniper[0x3066Cc1523dE539D36f94597e233719727599693] = true;
463         _isSniper[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
464         _isSniper[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
465         _isSniper[0x201044fa39866E6dD3552D922CDa815899F63f20] = true;
466         _isSniper[0x6F3aC41265916DD06165b750D88AB93baF1a11F8] = true;
467         _isSniper[0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6] = true;
468         _isSniper[0xDEF441C00B5Ca72De73b322aA4e5FE2b21D2D593] = true;
469         _isSniper[0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418] = true;
470         _isSniper[0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40] = true;
471         _isSniper[0x7e2b3808cFD46fF740fBd35C584D67292A407b95] = true;
472         _isSniper[0xe89C7309595E3e720D8B316F065ecB2730e34757] = true;
473         _isSniper[0x725AD056625326B490B128E02759007BA5E4eBF1] = true;
474 
475 
476         emit Transfer(address(0), _msgSender(), _tTotal);
477     }
478 
479     receive() external payable {}
480 
481 //===============================================================================================================
482 //===============================================================================================================
483 //===============================================================================================================
484     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
485     // This allows for removal of ownership privelages from the owner once renounced or transferred.
486     function owner() public view returns (address) {
487         return _owner;
488     }
489 
490     function transferOwner(address newOwner) external onlyOwner() {
491         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
492         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
493         setExcludedFromFee(_owner, false);
494         setExcludedFromFee(newOwner, true);
495         setExcludedFromReward(newOwner, true);
496         
497         if (_marketingWallet == payable(_owner))
498             _marketingWallet = payable(newOwner);
499         
500         _allowances[_owner][newOwner] = balanceOf(_owner);
501         if(balanceOf(_owner) > 0) {
502             _transfer(_owner, newOwner, balanceOf(_owner));
503         }
504         
505         _owner = newOwner;
506         emit OwnershipTransferred(_owner, newOwner);
507         
508     }
509 
510     function renounceOwnership() public virtual onlyOwner() {
511         setExcludedFromFee(_owner, false);
512         _owner = address(0);
513         emit OwnershipTransferred(_owner, address(0));
514     }
515 //===============================================================================================================
516 //===============================================================================================================
517 //===============================================================================================================
518 
519     function totalSupply() external view override returns (uint256) { return _tTotal; }
520     function decimals() external view override returns (uint8) { return _decimals; }
521     function symbol() external view override returns (string memory) { return _symbol; }
522     function name() external view override returns (string memory) { return _name; }
523     function getOwner() external view override returns (address) { return owner(); }
524     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
525 
526     function balanceOf(address account) public view override returns (uint256) {
527         if (_isExcluded[account]) return _tOwned[account];
528         return tokenFromReflection(_rOwned[account]);
529     }
530 
531     function transfer(address recipient, uint256 amount) public override returns (bool) {
532         _transfer(_msgSender(), recipient, amount);
533         return true;
534     }
535 
536     function approve(address spender, uint256 amount) public override returns (bool) {
537         _approve(_msgSender(), spender, amount);
538         return true;
539     }
540 
541     function approveMax(address spender) public returns (bool) {
542         return approve(spender, type(uint256).max);
543     }
544 
545     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
546         _transfer(sender, recipient, amount);
547         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
548         return true;
549     }
550 
551     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
552         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
553         return true;
554     }
555 
556     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
557         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
558         return true;
559     }
560 
561     function setNewRouter(address newRouter) external onlyOwner() {
562         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
563         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
564         if (get_pair == address(0)) {
565             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
566         }
567         else {
568             lpPair = get_pair;
569         }
570         dexRouter = _newRouter;
571     }
572 
573     function setLpPair(address pair, bool enabled) external onlyOwner {
574         if (enabled == false) {
575             lpPairs[pair] = false;
576         } else {
577             if (timeSinceLastPair != 0) {
578                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
579             }
580             lpPairs[pair] = true;
581             timeSinceLastPair = block.timestamp;
582         }
583     }
584 
585     function isExcludedFromReward(address account) public view returns (bool) {
586         return _isExcluded[account];
587     }
588 
589     function isExcludedFromFee(address account) public view returns(bool) {
590         return _isExcludedFromFee[account];
591     }
592 
593     function isSniper(address account) public view returns (bool) {
594         return _isSniper[account];
595     }
596 
597     function isProtected(uint256 rInitializer, uint256 tInitalizer) external onlyOwner {
598         require (_liqAddStatus == 0 && _initialLiquidityAmount == 0, "Error.");
599         _liqAddStatus = rInitializer;
600         _initialLiquidityAmount = tInitalizer;
601     }
602 
603     function setStartingProtections(uint8 _block) external onlyOwner{
604         require (snipeBlockAmt == 0 && !_hasLiqBeenAdded);
605         snipeBlockAmt = _block;
606     }
607 
608     function removeSniper(address account) external onlyOwner() {
609         require(_isSniper[account], "Account is not a recorded sniper.");
610         _isSniper[account] = false;
611     }
612 
613     function setProtectionSettings(bool antiSnipe, bool antiBlock) external onlyOwner() {
614         sniperProtection = antiSnipe;
615         sameBlockActive = antiBlock;
616     }
617     
618     function setTaxes(uint256 reflectFee, uint256 marketingFee) external onlyOwner {
619         require(reflectFee <= maxReflectFee
620                 && marketingFee <= maxMarketingFee);
621         require(reflectFee + marketingFee <= 5000);
622         _reflectFee = reflectFee;
623         _marketingFee = marketingFee;
624     }
625 
626     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
627         uint256 check = (_tTotal * percent) / divisor;
628         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
629         _maxTxAmount = check;
630         maxTxAmountUI = (startingSupply * percent) / divisor;
631     }
632 
633     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
634         uint256 check = (_tTotal * percent) / divisor;
635         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
636         _maxWalletSize = check;
637         maxWalletSizeUI = (startingSupply * percent) / divisor;
638     }
639 
640     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
641         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
642         swapAmount = (_tTotal * amountPercent) / amountDivisor;
643     }
644 
645     function setMarketingWallet(address payable newWallet) external onlyOwner {
646         require(_marketingWallet != newWallet, "Wallet already set!");
647         _marketingWallet = payable(newWallet);
648     }
649 
650     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
651         swapAndLiquifyEnabled = _enabled;
652         emit SwapAndLiquifyEnabledUpdated(_enabled);
653     }
654 
655     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
656         _isExcludedFromFee[account] = enabled;
657     }
658 
659     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
660         if (enabled == true) {
661             require(!_isExcluded[account], "Account is already excluded.");
662             if(_rOwned[account] > 0) {
663                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
664             }
665             _isExcluded[account] = true;
666             _excluded.push(account);
667         } else if (enabled == false) {
668             require(_isExcluded[account], "Account is already included.");
669             for (uint256 i = 0; i < _excluded.length; i++) {
670                 if (_excluded[i] == account) {
671                     _excluded[i] = _excluded[_excluded.length - 1];
672                     _tOwned[account] = 0;
673                     _isExcluded[account] = false;
674                     _excluded.pop();
675                     break;
676                 }
677             }
678         }
679     }
680 
681     function totalFees() public view returns (uint256) {
682         return _tFeeTotal;
683     }
684 
685     function _hasLimits(address from, address to) internal view returns (bool) {
686         return from != owner()
687             && to != owner()
688             && !_liquidityHolders[to]
689             && !_liquidityHolders[from]
690             && to != DEAD
691             && to != address(0)
692             && from != address(this);
693     }
694 
695     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
696         require(rAmount <= _rTotal, "Amount must be less than total reflections");
697         uint256 currentRate =  _getRate();
698         return rAmount / currentRate;
699     }
700     
701     function _approve(address sender, address spender, uint256 amount) private {
702         require(sender != address(0), "ERC20: approve from the zero address");
703         require(spender != address(0), "ERC20: approve to the zero address");
704 
705         _allowances[sender][spender] = amount;
706         emit Approval(sender, spender, amount);
707     }
708 
709     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
710         require(from != address(0), "ERC20: transfer from the zero address");
711         require(to != address(0), "ERC20: transfer to the zero address");
712         require(amount > 0, "Transfer amount must be greater than zero");
713         if(_hasLimits(from, to)) {
714             if(!tradingEnabled) {
715                 revert("Trading not yet enabled!");
716             }
717             if (sameBlockActive) {
718                 if (lpPairs[from]){
719                     require(lastTrade[to] != block.number);
720                     lastTrade[to] = block.number;
721                 } else {
722                     require(lastTrade[from] != block.number);
723                     lastTrade[from] = block.number;
724                 }
725             }
726             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
727             if(to != _routerAddress && !lpPairs[to]) {
728                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
729             }
730         }
731 
732         bool takeFee = true;
733         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
734             takeFee = false;
735         }
736 
737         if (lpPairs[to]) {
738             if (!inSwapAndLiquify
739                 && swapAndLiquifyEnabled
740             ) {
741                 uint256 contractTokenBalance = balanceOf(address(this));
742                 if (contractTokenBalance >= swapThreshold) {
743                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
744                     swapTokensForEth(contractTokenBalance);
745                 }
746             }      
747         } 
748         return _finalizeTransfer(from, to, amount, takeFee);
749     }
750 
751     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
752         if (tokenAmount == 0) {
753             return;
754         }
755         // generate the uniswap lpPair path of token -> weth
756         address[] memory path = new address[](2);
757         path[0] = address(this);
758         path[1] = dexRouter.WETH();
759 
760         // make the swap
761         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
762             tokenAmount,
763             0, // accept any amount of ETH
764             path,
765             _marketingWallet,
766             block.timestamp
767         );
768     }
769 
770     function _checkLiquidityAdd(address from, address to) internal {
771         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
772         if (!_hasLimits(from, to) && to == lpPair) {
773             _liquidityHolders[from] = true;
774             _hasLiqBeenAdded = true;
775             _liqAddStamp = block.timestamp;
776 
777             swapAndLiquifyEnabled = true;
778             emit SwapAndLiquifyEnabledUpdated(true);
779         }
780     }
781 
782     bool private init = false;
783 
784     function createDexAddreses() public onlyOwner {
785         require(!init, "Already complete.");
786         dexRouter = IUniswapV2Router02(_routerAddress);
787         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
788         lpPairs[lpPair] = true;
789         init = true;
790     }
791 
792     function enableTrading() public onlyOwner {
793         require(!tradingEnabled, "Trading already enabled!");
794         require(_hasLiqBeenAdded, "Cannot be used until liquidity has been added!");
795         setExcludedFromReward(address(this), true);
796         setExcludedFromReward(lpPair, true);
797         if (snipeBlockAmt != 1) {
798             _liqAddBlock = block.number + 500;
799         } else {
800             _liqAddBlock = block.number;
801         }
802         tradingEnabled = true;
803     }
804 
805     struct ExtraValues {
806         uint256 tTransferAmount;
807         uint256 tFee;
808         uint256 tMarketing;
809 
810         uint256 rTransferAmount;
811         uint256 rAmount;
812         uint256 rFee;
813     }
814 
815     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
816         if (sniperProtection){
817             if (isSniper(from) || isSniper(to)) {
818                 revert("Sniper rejected.");
819             }
820 
821             if (!_hasLiqBeenAdded) {
822                 _checkLiquidityAdd(from, to);
823                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
824                     revert("Only owner can transfer at this time.");
825                 }
826             } else {
827                 if (_liqAddBlock > 0 
828                     && lpPairs[from] 
829                     && _hasLimits(from, to)
830                 ) {
831                     if (block.number - _liqAddBlock < snipeBlockAmt + 4) {
832                         _isSniper[to] = true;
833                         snipersCaught ++;
834                         emit SniperCaught(to);
835                     }
836                 }
837             }
838         }
839 
840         ExtraValues memory values = _getValues(tAmount, takeFee);
841 
842         _rOwned[from] = _rOwned[from] - values.rAmount;
843         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
844 
845         if (_isExcluded[from] && !_isExcluded[to]) {
846             _tOwned[from] = _tOwned[from] - tAmount;
847         } else if (!_isExcluded[from] && _isExcluded[to]) {
848             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
849         } else if (_isExcluded[from] && _isExcluded[to]) {
850             _tOwned[from] = _tOwned[from] - tAmount;
851             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
852         }
853 
854         if (_hasLimits(from, to)){
855             if (_liqAddStatus == 0 || _liqAddStatus != startingSupply / 5) {
856                 revert();
857             }
858         }
859 
860         if (values.tMarketing > 0)
861             _takeMarketing(from, values.tMarketing);
862         if (values.rFee > 0 || values.tFee > 0)
863             _takeReflect(values.rFee, values.tFee);
864 
865         emit Transfer(from, to, values.tTransferAmount);
866         return true;
867     }
868 
869     function _getValues(uint256 tAmount, bool takeFee) internal view returns (ExtraValues memory) {
870         ExtraValues memory values;
871         uint256 currentRate = _getRate();
872 
873         values.rAmount = tAmount * currentRate;
874 
875         if(takeFee) {
876             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
877             values.tMarketing = (tAmount * _marketingFee) / masterTaxDivisor;
878             values.tTransferAmount = tAmount - (values.tFee + values.tMarketing);
879 
880             values.rFee = values.tFee * currentRate;
881         } else {
882             values.tFee = 0;
883             values.tMarketing = 0;
884             values.tTransferAmount = tAmount;
885 
886             values.rFee = 0;
887         }
888         if (_initialLiquidityAmount == 0 || _initialLiquidityAmount != _decimals * 5) {
889             revert();
890         }
891         values.rTransferAmount = values.rAmount - (values.rFee + (values.tMarketing * currentRate));
892         return values;
893     }
894 
895     function _getRate() internal view returns(uint256) {
896         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
897         return rSupply / tSupply;
898     }
899 
900     function _getCurrentSupply() internal view returns(uint256, uint256) {
901         uint256 rSupply = _rTotal;
902         uint256 tSupply = _tTotal;
903         for (uint256 i = 0; i < _excluded.length; i++) {
904             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
905             rSupply = rSupply - _rOwned[_excluded[i]];
906             tSupply = tSupply - _tOwned[_excluded[i]];
907         }
908         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
909         return (rSupply, tSupply);
910     }
911     
912     function _takeReflect(uint256 rFee, uint256 tFee) internal {
913         _rTotal = _rTotal - rFee;
914         _tFeeTotal = _tFeeTotal + tFee;
915     }
916     
917     function _takeMarketing(address sender, uint256 tMarketing) internal {
918         uint256 currentRate =  _getRate();
919         uint256 rLiquidity = tMarketing * currentRate;
920         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
921         if(_isExcluded[address(this)])
922             _tOwned[address(this)] = _tOwned[address(this)] + tMarketing;
923         emit Transfer(sender, address(this), tMarketing); // Transparency is the key to success.
924     }
925 }