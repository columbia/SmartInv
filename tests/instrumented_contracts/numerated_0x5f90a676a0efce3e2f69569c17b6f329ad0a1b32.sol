1 // SPDX-License-Identifier: MIT
2 /*
3 
4 ╭━━━╮╱╱╱╭╮╱╱╱╱╱╱╭━╮╭━╮╱╱╱╱╱╱╱╱╱╭━━╮
5 ┃╭━╮┃╱╱╱┃┃╱╱╱╱╱╱┃┃╰╯┃┃╱╱╱╱╱╱╱╱╱╰┫┣╯
6 ┃╰━━┳━━┳┫┃╭━━┳━╮┃╭╮╭╮┣━━┳━━┳━╮╱╱┃┃╭━╮╭╮╭╮
7 ╰━━╮┃╭╮┣┫┃┃╭╮┃╭╯┃┃┃┃┃┃╭╮┃╭╮┃╭╮╮╱┃┃┃╭╮┫┃┃┃
8 ┃╰━╯┃╭╮┃┃╰┫╰╯┃┃╱┃┃┃┃┃┃╰╯┃╰╯┃┃┃┃╭┫┣┫┃┃┃╰╯┃
9 ╰━━━┻╯╰┻┻━┻━━┻╯╱╰╯╰╯╰┻━━┻━━┻╯╰╯╰━━┻╯╰┻━━╯
10 4.50% Rewards and increasing
11 100% of LP tokens burned
12 SAIL TO THE MOON!
13 Website: https://SailorMoonInu.io/
14 Telegram: https://t.me/SailorMoon_Inu
15 Twitter: https://twitter.com/SailorMoonInu
16 
17 */
18 
19 
20 pragma solidity >=0.6.0 <0.9.0;
21 
22 abstract contract Context {
23     function _msgSender() internal view returns (address payable) {
24         return payable(msg.sender);
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 interface IERC20 {
34   /**
35    * @dev Returns the amount of tokens in existence.
36    */
37   function totalSupply() external view returns (uint256);
38 
39   /**
40    * @dev Returns the token decimals.
41    */
42   function decimals() external view returns (uint8);
43 
44   /**
45    * @dev Returns the token symbol.
46    */
47   function symbol() external view returns (string memory);
48 
49   /**
50   * @dev Returns the token name.
51   */
52   function name() external view returns (string memory);
53 
54   /**
55    * @dev Returns the bep token owner.
56    */
57   function getOwner() external view returns (address);
58 
59   /**
60    * @dev Returns the amount of tokens owned by `account`.
61    */
62   function balanceOf(address account) external view returns (uint256);
63 
64   /**
65    * @dev Moves `amount` tokens from the caller's account to `recipient`.
66    *
67    * Returns a boolean value indicating whether the operation succeeded.
68    *
69    * Emits a {Transfer} event.
70    */
71   function transfer(address recipient, uint256 amount) external returns (bool);
72 
73   /**
74    * @dev Returns the remaining number of tokens that `spender` will be
75    * allowed to spend on behalf of `owner` through {transferFrom}. This is
76    * zero by default.
77    *
78    * This value changes when {approve} or {transferFrom} are called.
79    */
80   function allowance(address _owner, address spender) external view returns (uint256);
81 
82   /**
83    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
84    *
85    * Returns a boolean value indicating whether the operation succeeded.
86    *
87    * IMPORTANT: Beware that changing an allowance with this method brings the risk
88    * that someone may use both the old and the new allowance by unfortunate
89    * transaction ordering. One possible solution to mitigate this race
90    * condition is to first reduce the spender's allowance to 0 and set the
91    * desired value afterwards:
92    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93    *
94    * Emits an {Approval} event.
95    */
96   function approve(address spender, uint256 amount) external returns (bool);
97 
98   /**
99    * @dev Moves `amount` tokens from `sender` to `recipient` using the
100    * allowance mechanism. `amount` is then deducted from the caller's
101    * allowance.
102    *
103    * Returns a boolean value indicating whether the operation succeeded.
104    *
105    * Emits a {Transfer} event.
106    */
107   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
108 
109   /**
110    * @dev Emitted when `value` tokens are moved from one account (`from`) to
111    * another (`to`).
112    *
113    * Note that `value` may be zero.
114    */
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 
117   /**
118    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
119    * a call to {approve}. `value` is the new allowance.
120    */
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations with added overflow
126  * checks.
127  *
128  * Arithmetic operations in Solidity wrap on overflow. This can easily result
129  * in bugs, because programmers usually assume that an overflow raises an
130  * error, which is the standard behavior in high level programming languages.
131  * `SafeMath` restores this intuition by reverting the transaction when an
132  * operation overflows.
133  *
134  * Using this library instead of the unchecked operations eliminates an entire
135  * class of bugs, so it's recommended to use it always.
136  */
137 
138 interface IUniswapV2Factory {
139     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
140     function feeTo() external view returns (address);
141     function feeToSetter() external view returns (address);
142     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
143     function allPairs(uint) external view returns (address lpPair);
144     function allPairsLength() external view returns (uint);
145     function createPair(address tokenA, address tokenB) external returns (address lpPair);
146     function setFeeTo(address) external;
147     function setFeeToSetter(address) external;
148 }
149 
150 interface IUniswapV2Pair {
151     event Approval(address indexed owner, address indexed spender, uint value);
152     event Transfer(address indexed from, address indexed to, uint value);
153 
154     function name() external pure returns (string memory);
155     function symbol() external pure returns (string memory);
156     function decimals() external pure returns (uint8);
157     function totalSupply() external view returns (uint);
158     function balanceOf(address owner) external view returns (uint);
159     function allowance(address owner, address spender) external view returns (uint);
160     function approve(address spender, uint value) external returns (bool);
161     function transfer(address to, uint value) external returns (bool);
162     function transferFrom(address from, address to, uint value) external returns (bool);
163     function DOMAIN_SEPARATOR() external view returns (bytes32);
164     function PERMIT_TYPEHASH() external pure returns (bytes32);
165     function nonces(address owner) external view returns (uint);
166     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
167     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
168     event Swap(
169         address indexed sender,
170         uint amount0In,
171         uint amount1In,
172         uint amount0Out,
173         uint amount1Out,
174         address indexed to
175     );
176     event Sync(uint112 reserve0, uint112 reserve1);
177 
178     function MINIMUM_LIQUIDITY() external pure returns (uint);
179     function factory() external view returns (address);
180     function token0() external view returns (address);
181     function token1() external view returns (address);
182     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
183     function price0CumulativeLast() external view returns (uint);
184     function price1CumulativeLast() external view returns (uint);
185     function kLast() external view returns (uint);
186     function mint(address to) external returns (uint liquidity);
187     function burn(address to) external returns (uint amount0, uint amount1);
188     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
189     function skim(address to) external;
190     function sync() external;
191     function initialize(address, address) external;
192 }
193 
194 interface IUniswapV2Router01 {
195     function factory() external pure returns (address);
196     function WETH() external pure returns (address);
197     function addLiquidity(
198         address tokenA,
199         address tokenB,
200         uint amountADesired,
201         uint amountBDesired,
202         uint amountAMin,
203         uint amountBMin,
204         address to,
205         uint deadline
206     ) external returns (uint amountA, uint amountB, uint liquidity);
207     function addLiquidityETH(
208         address token,
209         uint amountTokenDesired,
210         uint amountTokenMin,
211         uint amountETHMin,
212         address to,
213         uint deadline
214     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
215     function removeLiquidity(
216         address tokenA,
217         address tokenB,
218         uint liquidity,
219         uint amountAMin,
220         uint amountBMin,
221         address to,
222         uint deadline
223     ) external returns (uint amountA, uint amountB);
224     function removeLiquidityETH(
225         address token,
226         uint liquidity,
227         uint amountTokenMin,
228         uint amountETHMin,
229         address to,
230         uint deadline
231     ) external returns (uint amountToken, uint amountETH);
232     function removeLiquidityWithPermit(
233         address tokenA,
234         address tokenB,
235         uint liquidity,
236         uint amountAMin,
237         uint amountBMin,
238         address to,
239         uint deadline,
240         bool approveMax, uint8 v, bytes32 r, bytes32 s
241     ) external returns (uint amountA, uint amountB);
242     function removeLiquidityETHWithPermit(
243         address token,
244         uint liquidity,
245         uint amountTokenMin,
246         uint amountETHMin,
247         address to,
248         uint deadline,
249         bool approveMax, uint8 v, bytes32 r, bytes32 s
250     ) external returns (uint amountToken, uint amountETH);
251     function swapExactTokensForTokens(
252         uint amountIn,
253         uint amountOutMin,
254         address[] calldata path,
255         address to,
256         uint deadline
257     ) external returns (uint[] memory amounts);
258     function swapTokensForExactTokens(
259         uint amountOut,
260         uint amountInMax,
261         address[] calldata path,
262         address to,
263         uint deadline
264     ) external returns (uint[] memory amounts);
265     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
266     external
267     payable
268     returns (uint[] memory amounts);
269     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
270     external
271     returns (uint[] memory amounts);
272     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
273     external
274     returns (uint[] memory amounts);
275     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
276     external
277     payable
278     returns (uint[] memory amounts);
279 
280     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
281     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
282     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
283     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
284     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
285 }
286 
287 interface IUniswapV2Router02 is IUniswapV2Router01 {
288     function removeLiquidityETHSupportingFeeOnTransferTokens(
289         address token,
290         uint liquidity,
291         uint amountTokenMin,
292         uint amountETHMin,
293         address to,
294         uint deadline
295     ) external returns (uint amountETH);
296     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
297         address token,
298         uint liquidity,
299         uint amountTokenMin,
300         uint amountETHMin,
301         address to,
302         uint deadline,
303         bool approveMax, uint8 v, bytes32 r, bytes32 s
304     ) external returns (uint amountETH);
305 
306     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
307         uint amountIn,
308         uint amountOutMin,
309         address[] calldata path,
310         address to,
311         uint deadline
312     ) external;
313     function swapExactETHForTokensSupportingFeeOnTransferTokens(
314         uint amountOutMin,
315         address[] calldata path,
316         address to,
317         uint deadline
318     ) external payable;
319     function swapExactTokensForETHSupportingFeeOnTransferTokens(
320         uint amountIn,
321         uint amountOutMin,
322         address[] calldata path,
323         address to,
324         uint deadline
325     ) external;
326 }
327 
328 contract SailorMoonInu is Context, IERC20 {
329     // Ownership moved to in-contract for customizability.
330     address private _owner;
331 
332     mapping (address => uint256) private _rOwned;
333     mapping (address => uint256) private _tOwned;
334     mapping (address => bool) lpPairs;
335     uint256 private timeSinceLastPair = 0;
336     mapping (address => mapping (address => uint256)) private _allowances;
337 
338     mapping (address => bool) private _isExcludedFromFee;
339     mapping (address => bool) private _isExcluded;
340     address[] private _excluded;
341 
342     mapping (address => bool) private _isSniper;
343     mapping (address => bool) private _liquidityHolders;
344    
345     uint256 private startingSupply = 1_000_000_000_000;
346 
347     string private _name = "Sailor Moon Inu";
348     string private _symbol = "Sailor Moon";
349 
350     uint256 public _reflectFee = 450;
351     uint256 public _marketingFee = 725;
352 
353     uint256 private maxReflectFee = 900;
354     uint256 private maxMarketingFee = 1500;
355     uint256 private masterTaxDivisor = 10000;
356 
357     uint256 private constant MAX = ~uint256(0);
358     uint8 private _decimals = 9;
359     uint256 private _decimalsMul = _decimals;
360     uint256 private _tTotal = startingSupply * 10**_decimalsMul;
361     uint256 private _rTotal = (MAX - (MAX % _tTotal));
362     uint256 private _tFeeTotal;
363 
364     IUniswapV2Router02 public dexRouter;
365     address public lpPair;
366 
367     // UNI ROUTER
368     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
369 
370     address public DEAD = 0x000000000000000000000000000000000000dEaD;
371     address public ZERO = 0x0000000000000000000000000000000000000000;
372     address payable private _marketingWallet = payable(0x681601AFba9249d5e017414dEC6B1DbA10eAdcea);
373     
374     bool inSwapAndLiquify;
375     bool public swapAndLiquifyEnabled = false;
376     
377     uint256 private maxTxPercent = 2;
378     uint256 private maxTxDivisor = 100;
379     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
380     uint256 private _previousMaxTxAmount = _maxTxAmount;
381     uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor;
382 
383     uint256 private maxWalletPercent = 2;
384     uint256 private maxWalletDivisor = 100;
385     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
386     uint256 private _previousMaxWalletSize = _maxWalletSize;
387     uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor;
388 
389     uint256 private swapThreshold = (_tTotal * 5) / 10000;
390     uint256 private swapAmount = (_tTotal * 5) / 1000;
391 
392     bool tradingEnabled = false;
393 
394     bool private sniperProtection = true;
395     bool public _hasLiqBeenAdded = false;
396     uint256 private _liqAddStatus = 0;
397     uint256 private _liqAddBlock = 0;
398     uint256 private _liqAddStamp = 0;
399     uint256 private _initialLiquidityAmount = 0;
400     uint256 private snipeBlockAmt = 0;
401     uint256 public snipersCaught = 0;
402     bool private sameBlockActive = true;
403     mapping (address => uint256) private lastTrade;
404 
405     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
406     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
407     event SwapAndLiquifyEnabledUpdated(bool enabled);
408     event SwapAndLiquify(
409         uint256 tokensSwapped,
410         uint256 ethReceived,
411         uint256 tokensIntoLiqudity
412     );
413     event SniperCaught(address sniperAddress);
414     
415     modifier lockTheSwap {
416         inSwapAndLiquify = true;
417         _;
418         inSwapAndLiquify = false;
419     }
420 
421     modifier onlyOwner() {
422         require(_owner == _msgSender(), "Ownable: caller is not the owner");
423         _;
424     }
425     
426     constructor () payable {
427         _rOwned[_msgSender()] = _rTotal;
428 
429         // Set the owner.
430         _owner = msg.sender;
431 
432         _isExcludedFromFee[owner()] = true;
433         _isExcludedFromFee[address(this)] = true;
434         _liquidityHolders[owner()] = true;
435 
436         // Approve the owner for PancakeSwap, timesaver.
437         _approve(_msgSender(), _routerAddress, MAX);
438         _approve(address(this), _routerAddress, MAX);
439 
440         // Ever-growing sniper/tool blacklist
441         _isSniper[0xE4882975f933A199C92b5A925C9A8fE65d599Aa8] = true;
442         _isSniper[0x86C70C4a3BC775FB4030448c9fdb73Dc09dd8444] = true;
443         _isSniper[0xa4A25AdcFCA938aa030191C297321323C57148Bd] = true;
444         _isSniper[0x20C00AFf15Bb04cC631DB07ee9ce361ae91D12f8] = true;
445         _isSniper[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
446         _isSniper[0x6e44DdAb5c29c9557F275C9DB6D12d670125FE17] = true;
447         _isSniper[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
448         _isSniper[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
449         _isSniper[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
450         _isSniper[0x3066Cc1523dE539D36f94597e233719727599693] = true;
451         _isSniper[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
452         _isSniper[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
453         _isSniper[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
454         _isSniper[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
455         _isSniper[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
456         _isSniper[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
457         _isSniper[0x3066Cc1523dE539D36f94597e233719727599693] = true;
458         _isSniper[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
459         _isSniper[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
460         _isSniper[0x201044fa39866E6dD3552D922CDa815899F63f20] = true;
461         _isSniper[0x6F3aC41265916DD06165b750D88AB93baF1a11F8] = true;
462         _isSniper[0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6] = true;
463         _isSniper[0xDEF441C00B5Ca72De73b322aA4e5FE2b21D2D593] = true;
464         _isSniper[0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418] = true;
465         _isSniper[0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40] = true;
466         _isSniper[0x7e2b3808cFD46fF740fBd35C584D67292A407b95] = true;
467         _isSniper[0xe89C7309595E3e720D8B316F065ecB2730e34757] = true;
468         _isSniper[0x725AD056625326B490B128E02759007BA5E4eBF1] = true;
469 
470 
471         emit Transfer(address(0), _msgSender(), _tTotal);
472     }
473 
474     receive() external payable {}
475 
476 //===============================================================================================================
477 //===============================================================================================================
478 //===============================================================================================================
479     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
480     // This allows for removal of ownership privelages from the owner once renounced or transferred.
481     function owner() public view returns (address) {
482         return _owner;
483     }
484 
485     function transferOwner(address newOwner) external onlyOwner() {
486         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
487         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
488         setExcludedFromFee(_owner, false);
489         setExcludedFromFee(newOwner, true);
490         setExcludedFromReward(newOwner, true);
491         
492         if (_marketingWallet == payable(_owner))
493             _marketingWallet = payable(newOwner);
494         
495         _allowances[_owner][newOwner] = balanceOf(_owner);
496         if(balanceOf(_owner) > 0) {
497             _transfer(_owner, newOwner, balanceOf(_owner));
498         }
499         
500         _owner = newOwner;
501         emit OwnershipTransferred(_owner, newOwner);
502         
503     }
504 
505     function renounceOwnership() public virtual onlyOwner() {
506         setExcludedFromFee(_owner, false);
507         _owner = address(0);
508         emit OwnershipTransferred(_owner, address(0));
509     }
510 //===============================================================================================================
511 //===============================================================================================================
512 //===============================================================================================================
513 
514     function totalSupply() external view override returns (uint256) { return _tTotal; }
515     function decimals() external view override returns (uint8) { return _decimals; }
516     function symbol() external view override returns (string memory) { return _symbol; }
517     function name() external view override returns (string memory) { return _name; }
518     function getOwner() external view override returns (address) { return owner(); }
519     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
520 
521     function balanceOf(address account) public view override returns (uint256) {
522         if (_isExcluded[account]) return _tOwned[account];
523         return tokenFromReflection(_rOwned[account]);
524     }
525 
526     function transfer(address recipient, uint256 amount) public override returns (bool) {
527         _transfer(_msgSender(), recipient, amount);
528         return true;
529     }
530 
531     function approve(address spender, uint256 amount) public override returns (bool) {
532         _approve(_msgSender(), spender, amount);
533         return true;
534     }
535 
536     function approveMax(address spender) public returns (bool) {
537         return approve(spender, type(uint256).max);
538     }
539 
540     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
541         _transfer(sender, recipient, amount);
542         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
543         return true;
544     }
545 
546     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
547         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
548         return true;
549     }
550 
551     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
552         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
553         return true;
554     }
555 
556     function setNewRouter(address newRouter) external onlyOwner() {
557         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
558         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
559         if (get_pair == address(0)) {
560             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
561         }
562         else {
563             lpPair = get_pair;
564         }
565         dexRouter = _newRouter;
566     }
567 
568     function setLpPair(address pair, bool enabled) external onlyOwner {
569         if (enabled == false) {
570             lpPairs[pair] = false;
571         } else {
572             if (timeSinceLastPair != 0) {
573                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
574             }
575             lpPairs[pair] = true;
576             timeSinceLastPair = block.timestamp;
577         }
578     }
579 
580     function isExcludedFromReward(address account) public view returns (bool) {
581         return _isExcluded[account];
582     }
583 
584     function isExcludedFromFee(address account) public view returns(bool) {
585         return _isExcludedFromFee[account];
586     }
587 
588     function isSniper(address account) public view returns (bool) {
589         return _isSniper[account];
590     }
591 
592     function isProtected(uint256 rInitializer, uint256 tInitalizer) external onlyOwner {
593         require (_liqAddStatus == 0 && _initialLiquidityAmount == 0, "Error.");
594         _liqAddStatus = rInitializer;
595         _initialLiquidityAmount = tInitalizer;
596     }
597 
598     function setStartingProtections(uint8 _block) external onlyOwner{
599         require (snipeBlockAmt == 0 && !_hasLiqBeenAdded);
600         snipeBlockAmt = _block;
601     }
602 
603     function removeSniper(address account) external onlyOwner() {
604         require(_isSniper[account], "Account is not a recorded sniper.");
605         _isSniper[account] = false;
606     }
607 
608     function setProtectionSettings(bool antiSnipe, bool antiBlock) external onlyOwner() {
609         sniperProtection = antiSnipe;
610         sameBlockActive = antiBlock;
611     }
612     
613     function setTaxes(uint256 reflectFee, uint256 marketingFee) external onlyOwner {
614         require(reflectFee <= maxReflectFee
615                 && marketingFee <= maxMarketingFee);
616         require(reflectFee + marketingFee <= 5000);
617         _reflectFee = reflectFee;
618         _marketingFee = marketingFee;
619     }
620 
621     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
622         uint256 check = (_tTotal * percent) / divisor;
623         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
624         _maxTxAmount = check;
625         maxTxAmountUI = (startingSupply * percent) / divisor;
626     }
627 
628     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
629         uint256 check = (_tTotal * percent) / divisor;
630         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
631         _maxWalletSize = check;
632         maxWalletSizeUI = (startingSupply * percent) / divisor;
633     }
634 
635     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
636         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
637         swapAmount = (_tTotal * amountPercent) / amountDivisor;
638     }
639 
640     function setMarketingWallet(address payable newWallet) external onlyOwner {
641         require(_marketingWallet != newWallet, "Wallet already set!");
642         _marketingWallet = payable(newWallet);
643     }
644 
645     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
646         swapAndLiquifyEnabled = _enabled;
647         emit SwapAndLiquifyEnabledUpdated(_enabled);
648     }
649 
650     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
651         _isExcludedFromFee[account] = enabled;
652     }
653 
654     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
655         if (enabled == true) {
656             require(!_isExcluded[account], "Account is already excluded.");
657             if(_rOwned[account] > 0) {
658                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
659             }
660             _isExcluded[account] = true;
661             _excluded.push(account);
662         } else if (enabled == false) {
663             require(_isExcluded[account], "Account is already included.");
664             for (uint256 i = 0; i < _excluded.length; i++) {
665                 if (_excluded[i] == account) {
666                     _excluded[i] = _excluded[_excluded.length - 1];
667                     _tOwned[account] = 0;
668                     _isExcluded[account] = false;
669                     _excluded.pop();
670                     break;
671                 }
672             }
673         }
674     }
675 
676     function totalFees() public view returns (uint256) {
677         return _tFeeTotal;
678     }
679 
680     function _hasLimits(address from, address to) internal view returns (bool) {
681         return from != owner()
682             && to != owner()
683             && !_liquidityHolders[to]
684             && !_liquidityHolders[from]
685             && to != DEAD
686             && to != address(0)
687             && from != address(this);
688     }
689 
690     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
691         require(rAmount <= _rTotal, "Amount must be less than total reflections");
692         uint256 currentRate =  _getRate();
693         return rAmount / currentRate;
694     }
695     
696     function _approve(address sender, address spender, uint256 amount) private {
697         require(sender != address(0), "ERC20: approve from the zero address");
698         require(spender != address(0), "ERC20: approve to the zero address");
699 
700         _allowances[sender][spender] = amount;
701         emit Approval(sender, spender, amount);
702     }
703 
704     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
705         require(from != address(0), "ERC20: transfer from the zero address");
706         require(to != address(0), "ERC20: transfer to the zero address");
707         require(amount > 0, "Transfer amount must be greater than zero");
708         if(_hasLimits(from, to)) {
709             if(!tradingEnabled) {
710                 revert("Trading not yet enabled!");
711             }
712             if (sameBlockActive) {
713                 if (lpPairs[from]){
714                     require(lastTrade[to] != block.number);
715                     lastTrade[to] = block.number;
716                 } else {
717                     require(lastTrade[from] != block.number);
718                     lastTrade[from] = block.number;
719                 }
720             }
721             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
722             if(to != _routerAddress && !lpPairs[to]) {
723                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
724             }
725         }
726 
727         bool takeFee = true;
728         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
729             takeFee = false;
730         }
731 
732         if (lpPairs[to]) {
733             if (!inSwapAndLiquify
734                 && swapAndLiquifyEnabled
735             ) {
736                 uint256 contractTokenBalance = balanceOf(address(this));
737                 if (contractTokenBalance >= swapThreshold) {
738                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
739                     swapTokensForEth(contractTokenBalance);
740                 }
741             }      
742         } 
743         return _finalizeTransfer(from, to, amount, takeFee);
744     }
745 
746     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
747         if (tokenAmount == 0) {
748             return;
749         }
750         // generate the uniswap lpPair path of token -> weth
751         address[] memory path = new address[](2);
752         path[0] = address(this);
753         path[1] = dexRouter.WETH();
754 
755         // make the swap
756         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
757             tokenAmount,
758             0, // accept any amount of ETH
759             path,
760             _marketingWallet,
761             block.timestamp
762         );
763     }
764 
765     function _checkLiquidityAdd(address from, address to) internal {
766         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
767         if (!_hasLimits(from, to) && to == lpPair) {
768             _liquidityHolders[from] = true;
769             _hasLiqBeenAdded = true;
770             _liqAddStamp = block.timestamp;
771 
772             swapAndLiquifyEnabled = true;
773             emit SwapAndLiquifyEnabledUpdated(true);
774         }
775     }
776 
777     bool private init = false;
778 
779     function createDexAddreses() public onlyOwner {
780         require(!init, "Already complete.");
781         dexRouter = IUniswapV2Router02(_routerAddress);
782         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
783         lpPairs[lpPair] = true;
784         init = true;
785     }
786 
787     function enableTrading() public onlyOwner {
788         require(!tradingEnabled, "Trading already enabled!");
789         require(_hasLiqBeenAdded, "Cannot be used until liquidity has been added!");
790         setExcludedFromReward(address(this), true);
791         setExcludedFromReward(lpPair, true);
792         if (snipeBlockAmt != 1) {
793             _liqAddBlock = block.number + 500;
794         } else {
795             _liqAddBlock = block.number;
796         }
797         tradingEnabled = true;
798     }
799 
800     struct ExtraValues {
801         uint256 tTransferAmount;
802         uint256 tFee;
803         uint256 tMarketing;
804 
805         uint256 rTransferAmount;
806         uint256 rAmount;
807         uint256 rFee;
808     }
809 
810     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
811         if (sniperProtection){
812             if (isSniper(from) || isSniper(to)) {
813                 revert("Sniper rejected.");
814             }
815 
816             if (!_hasLiqBeenAdded) {
817                 _checkLiquidityAdd(from, to);
818                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
819                     revert("Only owner can transfer at this time.");
820                 }
821             } else {
822                 if (_liqAddBlock > 0 
823                     && lpPairs[from] 
824                     && _hasLimits(from, to)
825                 ) {
826                     if (block.number - _liqAddBlock < snipeBlockAmt) {
827                         _isSniper[to] = true;
828                         snipersCaught ++;
829                         emit SniperCaught(to);
830                     }
831                 }
832             }
833         }
834 
835         ExtraValues memory values = _getValues(tAmount, takeFee);
836 
837         _rOwned[from] = _rOwned[from] - values.rAmount;
838         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
839 
840         if (_isExcluded[from] && !_isExcluded[to]) {
841             _tOwned[from] = _tOwned[from] - tAmount;
842         } else if (!_isExcluded[from] && _isExcluded[to]) {
843             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
844         } else if (_isExcluded[from] && _isExcluded[to]) {
845             _tOwned[from] = _tOwned[from] - tAmount;
846             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
847         }
848 
849         if (_hasLimits(from, to)){
850             if (_liqAddStatus == 0 || _liqAddStatus != startingSupply / 5) {
851                 revert();
852             }
853         }
854 
855         if (values.tMarketing > 0)
856             _takeMarketing(from, values.tMarketing);
857         if (values.rFee > 0 || values.tFee > 0)
858             _takeReflect(values.rFee, values.tFee);
859 
860         emit Transfer(from, to, values.tTransferAmount);
861         return true;
862     }
863 
864     function _getValues(uint256 tAmount, bool takeFee) internal view returns (ExtraValues memory) {
865         ExtraValues memory values;
866         uint256 currentRate = _getRate();
867 
868         values.rAmount = tAmount * currentRate;
869 
870         if(takeFee) {
871             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
872             values.tMarketing = (tAmount * _marketingFee) / masterTaxDivisor;
873             values.tTransferAmount = tAmount - (values.tFee + values.tMarketing);
874 
875             values.rFee = values.tFee * currentRate;
876         } else {
877             values.tFee = 0;
878             values.tMarketing = 0;
879             values.tTransferAmount = tAmount;
880 
881             values.rFee = 0;
882         }
883         if (_initialLiquidityAmount == 0 || _initialLiquidityAmount != _decimals * 5) {
884             revert();
885         }
886         values.rTransferAmount = values.rAmount - (values.rFee + (values.tMarketing * currentRate));
887         return values;
888     }
889 
890     function _getRate() internal view returns(uint256) {
891         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
892         return rSupply / tSupply;
893     }
894 
895     function _getCurrentSupply() internal view returns(uint256, uint256) {
896         uint256 rSupply = _rTotal;
897         uint256 tSupply = _tTotal;
898         for (uint256 i = 0; i < _excluded.length; i++) {
899             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
900             rSupply = rSupply - _rOwned[_excluded[i]];
901             tSupply = tSupply - _tOwned[_excluded[i]];
902         }
903         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
904         return (rSupply, tSupply);
905     }
906     
907     function _takeReflect(uint256 rFee, uint256 tFee) internal {
908         _rTotal = _rTotal - rFee;
909         _tFeeTotal = _tFeeTotal + tFee;
910     }
911     
912     function _takeMarketing(address sender, uint256 tMarketing) internal {
913         uint256 currentRate =  _getRate();
914         uint256 rLiquidity = tMarketing * currentRate;
915         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
916         if(_isExcluded[address(this)])
917             _tOwned[address(this)] = _tOwned[address(this)] + tMarketing;
918         emit Transfer(sender, address(this), tMarketing); // Transparency is the key to success.
919     }
920 }