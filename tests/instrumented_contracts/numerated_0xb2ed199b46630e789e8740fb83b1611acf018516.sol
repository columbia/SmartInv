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
300     function setProtections(bool _as, bool _ag, bool _ab, bool _aspecial) external;
301     function removeSniper(address account) external;
302     function getSniperAmt() external view returns (uint256);
303     function removeBlacklisted(address account) external;
304     function isBlacklisted(address account) external view returns (bool);
305 }
306 
307 contract GolDInu is Context, IERC20 {
308     // Ownership moved to in-contract for customizability.
309     address private _owner;
310 
311     mapping (address => uint256) private _rOwned;
312     mapping (address => uint256) private _tOwned;
313     mapping (address => bool) lpPairs;
314     uint256 private timeSinceLastPair = 0;
315     mapping (address => mapping (address => uint256)) private _allowances;
316 
317     mapping (address => bool) private _isExcludedFromFees;
318     mapping (address => bool) private _isExcluded;
319     address[] private _excluded;
320 
321     mapping (address => bool) private _liquidityHolders;
322    
323     uint256 private startingSupply = 1_000_000_000_000_000;
324 
325     string constant private _name = "GOL D INU";
326     string constant private _symbol = "GINU";
327 
328     struct FeesStruct {
329         uint16 reflectFee;
330         uint16 treasuryFee;
331         uint16 marketingFee;
332     }
333 
334     struct StaticValuesStruct {
335         uint16 maxReflectFee;
336         uint16 maxLiquidityFee;
337         uint16 maxMarketingFee;
338         uint16 masterTaxDivisor;
339     }
340 
341     struct Ratios {
342         uint16 treasury;
343         uint16 marketing;
344         uint16 total;
345     }
346 
347     FeesStruct private currentTaxes = FeesStruct({
348         reflectFee: 0,
349         treasuryFee: 0,
350         marketingFee: 0
351         });
352 
353     FeesStruct public _buyTaxes = FeesStruct({
354         reflectFee: 100,
355         treasuryFee: 400,
356         marketingFee: 500
357         });
358 
359     FeesStruct public _sellTaxes = FeesStruct({
360         reflectFee: 100,
361         treasuryFee: 400,
362         marketingFee: 500
363         });
364 
365     FeesStruct public _transferTaxes = FeesStruct({
366         reflectFee: 100,
367         treasuryFee: 400,
368         marketingFee: 500
369         });
370 
371     Ratios public _ratios = Ratios({
372         treasury: 4,
373         marketing: 5,
374         total: 9
375         });
376 
377     StaticValuesStruct public staticVals = StaticValuesStruct({
378         maxReflectFee: 800,
379         maxLiquidityFee: 800,
380         maxMarketingFee: 800,
381         masterTaxDivisor: 10000
382         });
383 
384     uint256 private constant MAX = ~uint256(0);
385     uint8 private _decimals = 9;
386     uint256 private _tTotal = startingSupply * 10**_decimals;
387     uint256 private _rTotal = (MAX - (MAX % _tTotal));
388     uint256 private _tFeeTotal;
389 
390     IUniswapV2Router02 public dexRouter;
391     address public lpPair;
392 
393     // UNI ROUTER
394     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
395 
396     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
397     address payable private _marketingWallet = payable(0x905A29d4046E6F534D6c116550a24EB1AB4F715C);
398     address payable private _treasuryWallet = payable(0x2501Fa56De1eC28189F2916c80149b867230345a);
399     
400     bool inSwap;
401     bool public contractSwapEnabled = false;
402     
403     uint256 private maxTxPercent = 25;
404     uint256 private maxTxDivisor = 10000;
405     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
406     uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor;
407 
408     uint256 private maxWalletPercent = 25;
409     uint256 private maxWalletDivisor = 1000;
410     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
411     uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor;
412 
413     uint256 private swapThreshold = (_tTotal * 5) / 10000;
414     uint256 private swapAmount = (_tTotal * 5) / 1000;
415 
416     bool public tradingEnabled = false;
417     bool public _hasLiqBeenAdded = false;
418     AntiSnipe antiSnipe;
419 
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
422     event ContractSwapEnabledUpdated(bool enabled);
423     event SwapAndLiquify(
424         uint256 tokensSwapped,
425         uint256 ethReceived,
426         uint256 tokensIntoLiqudity
427     );
428     event SniperCaught(address sniperAddress);
429     
430     modifier lockTheSwap {
431         inSwap = true;
432         _;
433         inSwap = false;
434     }
435 
436     modifier onlyOwner() {
437         require(_owner == _msgSender(), "Caller =/= owner.");
438         _;
439     }
440     
441     constructor () payable {
442         _rOwned[_msgSender()] = _rTotal;
443 
444         // Set the owner.
445         _owner = msg.sender;
446 
447         dexRouter = IUniswapV2Router02(_routerAddress);
448         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
449         lpPairs[lpPair] = true;
450 
451         _approve(msg.sender, _routerAddress, type(uint256).max);
452         _approve(address(this), _routerAddress, type(uint256).max);
453 
454         _isExcludedFromFees[owner()] = true;
455         _isExcludedFromFees[address(this)] = true;
456         _isExcludedFromFees[DEAD] = true;
457         _liquidityHolders[owner()] = true;
458 
459         emit Transfer(address(0), _msgSender(), _tTotal);
460     }
461 
462     receive() external payable {}
463 
464 //===============================================================================================================
465 //===============================================================================================================
466 //===============================================================================================================
467     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
468     // This allows for removal of ownership privelages from the owner once renounced or transferred.
469     function owner() public view returns (address) {
470         return _owner;
471     }
472 
473     function transferOwner(address newOwner) external onlyOwner() {
474         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
475         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
476         setExcludedFromFees(_owner, false);
477         setExcludedFromFees(newOwner, true);
478         
479         if (_marketingWallet == payable(_owner))
480             _marketingWallet = payable(newOwner);
481         
482         if(balanceOf(_owner) > 0) {
483             _transfer(_owner, newOwner, balanceOf(_owner));
484         }
485         
486         _owner = newOwner;
487         emit OwnershipTransferred(_owner, newOwner);
488         
489     }
490 
491     function renounceOwnership() public virtual onlyOwner() {
492         setExcludedFromFees(_owner, false);
493         _owner = address(0);
494         emit OwnershipTransferred(_owner, address(0));
495     }
496 //===============================================================================================================
497 //===============================================================================================================
498 //===============================================================================================================
499 
500     function totalSupply() external view override returns (uint256) { return _tTotal; }
501     function decimals() external view override returns (uint8) { return _decimals; }
502     function symbol() external pure override returns (string memory) { return _symbol; }
503     function name() external pure override returns (string memory) { return _name; }
504     function getOwner() external view override returns (address) { return owner(); }
505     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
506 
507     function balanceOf(address account) public view override returns (uint256) {
508         if (_isExcluded[account]) return _tOwned[account];
509         return tokenFromReflection(_rOwned[account]);
510     }
511 
512     function transfer(address recipient, uint256 amount) public override returns (bool) {
513         _transfer(_msgSender(), recipient, amount);
514         return true;
515     }
516 
517     function approve(address spender, uint256 amount) public override returns (bool) {
518         _approve(_msgSender(), spender, amount);
519         return true;
520     }
521 
522     function _approve(address sender, address spender, uint256 amount) private {
523         require(sender != address(0), "ERC20: Zero Address");
524         require(spender != address(0), "ERC20: Zero Address");
525 
526         _allowances[sender][spender] = amount;
527         emit Approval(sender, spender, amount);
528     }
529 
530     function approveContractContingency() public onlyOwner returns (bool) {
531         _approve(address(this), address(dexRouter), type(uint256).max);
532         return true;
533     }
534 
535     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
536         if (_allowances[sender][msg.sender] != type(uint256).max) {
537             _allowances[sender][msg.sender] -= amount;
538         }
539 
540         return _transfer(sender, recipient, amount);
541     }
542 
543     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
544         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
545         return true;
546     }
547 
548     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
549         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
550         return true;
551     }
552 
553     function setNewRouter(address newRouter) public onlyOwner() {
554         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
555         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
556         if (get_pair == address(0)) {
557             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
558         }
559         else {
560             lpPair = get_pair;
561         }
562         dexRouter = _newRouter;
563         _approve(address(this), address(dexRouter), type(uint256).max);
564     }
565 
566     function setLpPair(address pair, bool enabled) external onlyOwner {
567         if (enabled == false) {
568             lpPairs[pair] = false;
569             antiSnipe.setLpPair(pair, false);
570         } else {
571             if (timeSinceLastPair != 0) {
572                 require(block.timestamp - timeSinceLastPair > 3 days, "Cannot set a new pair this week!");
573             }
574             lpPairs[pair] = true;
575             timeSinceLastPair = block.timestamp;
576             antiSnipe.setLpPair(pair, true);
577         }
578     }
579 
580     function isExcludedFromFees(address account) public view returns(bool) {
581         return _isExcludedFromFees[account];
582     }
583 
584     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
585         _isExcludedFromFees[account] = enabled;
586     }
587 
588     function isExcludedFromReward(address account) public view returns (bool) {
589         return _isExcluded[account];
590     }
591 
592     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
593         if (enabled == true) {
594             require(!_isExcluded[account], "Account is already excluded.");
595             if(_rOwned[account] > 0) {
596                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
597             }
598             _isExcluded[account] = true;
599             _excluded.push(account);
600         } else if (enabled == false) {
601             require(_isExcluded[account], "Account is already included.");
602             if(_excluded.length == 1){
603                 _tOwned[account] = 0;
604                 _isExcluded[account] = false;
605                 _excluded.pop();
606             } else {
607                 for (uint256 i = 0; i < _excluded.length; i++) {
608                     if (_excluded[i] == account) {
609                         _excluded[i] = _excluded[_excluded.length - 1];
610                         _tOwned[account] = 0;
611                         _isExcluded[account] = false;
612                         _excluded.pop();
613                         break;
614                     }
615                 }
616             }
617         }
618     }
619 
620     function setInitializer(address initializer) external onlyOwner {
621         require(!_hasLiqBeenAdded, "Liquidity is already in.");
622         require(initializer != address(this), "Can't be self.");
623         antiSnipe = AntiSnipe(initializer);
624     }
625 
626     function removeSniper(address account) external onlyOwner {
627         antiSnipe.removeSniper(account);
628     }
629 
630     function isBlacklisted(address account) public view returns (bool) {
631         return antiSnipe.isBlacklisted(account);
632     }
633 
634     function removeBlacklisted(address account) external onlyOwner {
635         antiSnipe.removeBlacklisted(account);
636     }
637 
638     function getSniperAmt() public view returns (uint256) {
639         return antiSnipe.getSniperAmt();
640     }
641 
642     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _antiSpecial) external onlyOwner {
643         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _antiSpecial);
644     }
645 
646     function setTaxesBuy(uint16 reflectFee, uint16 treasuryFee, uint16 marketingFee) external onlyOwner {
647         require(reflectFee <= staticVals.maxReflectFee
648                 && treasuryFee <= staticVals.maxLiquidityFee
649                 && marketingFee <= staticVals.maxMarketingFee);
650         require(treasuryFee + reflectFee + marketingFee <= 3450);
651         _buyTaxes.treasuryFee = treasuryFee;
652         _buyTaxes.reflectFee = reflectFee;
653         _buyTaxes.marketingFee = marketingFee;
654     }
655 
656     function setTaxesSell(uint16 reflectFee, uint16 treasuryFee, uint16 marketingFee) external onlyOwner {
657         require(reflectFee <= staticVals.maxReflectFee
658                 && treasuryFee <= staticVals.maxLiquidityFee
659                 && marketingFee <= staticVals.maxMarketingFee);
660         require(treasuryFee + reflectFee + marketingFee <= 3450);
661         _sellTaxes.treasuryFee = treasuryFee;
662         _sellTaxes.reflectFee = reflectFee;
663         _sellTaxes.marketingFee = marketingFee;
664     }
665 
666     function setTaxesTransfer(uint16 reflectFee, uint16 treasuryFee, uint16 marketingFee) external onlyOwner {
667         require(reflectFee <= staticVals.maxReflectFee
668                 && treasuryFee <= staticVals.maxLiquidityFee
669                 && marketingFee <= staticVals.maxMarketingFee);
670         require(treasuryFee + reflectFee + marketingFee <= 3450);
671         _transferTaxes.treasuryFee = treasuryFee;
672         _transferTaxes.reflectFee = reflectFee;
673         _transferTaxes.marketingFee = marketingFee;
674     }
675 
676     function setRatios(uint16 treasury, uint16 marketing) external onlyOwner {
677         require (treasury + marketing >= 99, "Must add up to 100% or 99%.");
678         _ratios.treasury = treasury;
679         _ratios.marketing = marketing;
680         _ratios.total = treasury + marketing;
681     }
682 
683     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
684         uint256 check = (_tTotal * percent) / divisor;
685         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
686         _maxTxAmount = check;
687         maxTxAmountUI = (startingSupply * percent) / divisor;
688     }
689 
690     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
691         uint256 check = (_tTotal * percent) / divisor;
692         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
693         _maxWalletSize = check;
694         maxWalletSizeUI = (startingSupply * percent) / divisor;
695     }
696 
697     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
698         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
699         swapAmount = (_tTotal * amountPercent) / amountDivisor;
700     }
701 
702     function setWallets(address payable marketingWallet, address payable treasuryWallet) external onlyOwner {
703         _marketingWallet = payable(marketingWallet);
704         _treasuryWallet = payable(treasuryWallet);
705     }
706 
707     function setContractSwapEnabled(bool _enabled) public onlyOwner {
708         contractSwapEnabled = _enabled;
709         emit ContractSwapEnabledUpdated(_enabled);
710     }
711 
712     function _hasLimits(address from, address to) private view returns (bool) {
713         return from != owner()
714             && to != owner()
715             && !_liquidityHolders[to]
716             && !_liquidityHolders[from]
717             && to != DEAD
718             && to != address(0)
719             && from != address(this);
720     }
721 
722     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
723         require(rAmount <= _rTotal, "Amount must be less than total reflections");
724         uint256 currentRate =  _getRate();
725         return rAmount / currentRate;
726     }
727 
728     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
729         require(from != address(0), "ERC20: transfer from the zero address");
730         require(to != address(0), "ERC20: transfer to the zero address");
731         require(amount > 0, "Transfer amount must be greater than zero");
732         if(_hasLimits(from, to)) {
733             if(!tradingEnabled) {
734                 revert("Trading not yet enabled!");
735             }
736             if(lpPairs[from] || lpPairs[to]){
737                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
738             }
739             if(to != _routerAddress && !lpPairs[to]) {
740                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
741             }
742         }
743 
744         bool takeFee = true;
745         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
746             takeFee = false;
747         }
748 
749         if (lpPairs[to]) {
750             if (!inSwap
751                 && contractSwapEnabled
752             ) {
753                 uint256 contractTokenBalance = balanceOf(address(this));
754                 if (contractTokenBalance >= swapThreshold) {
755                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
756                     contractSwap(contractTokenBalance);
757                 }
758             }      
759         } 
760         return _finalizeTransfer(from, to, amount, takeFee);
761     }
762 
763     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
764         if (_ratios.total == 0)
765             return;
766 
767         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
768             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
769         }
770         
771         address[] memory path = new address[](2);
772         path[0] = address(this);
773         path[1] = dexRouter.WETH();
774 
775         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
776             contractTokenBalance,
777             0, // accept any amount of ETH
778             path,
779             address(this),
780             block.timestamp
781         );
782 
783         if (address(this).balance > 0) {
784             _marketingWallet.transfer(address(this).balance * _ratios.marketing / _ratios.total);
785             _treasuryWallet.transfer(address(this).balance);
786         }
787     }
788 
789     function _checkLiquidityAdd(address from, address to) private {
790         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
791         if (!_hasLimits(from, to) && to == lpPair) {
792             _liquidityHolders[from] = true;
793             _hasLiqBeenAdded = true;
794             if(address(antiSnipe) == address(0)){
795                 antiSnipe = AntiSnipe(address(this));
796             }
797             contractSwapEnabled = true;
798             emit ContractSwapEnabledUpdated(true);
799         }
800     }
801 
802     function enableTrading() public onlyOwner {
803         require(!tradingEnabled, "Trading already enabled!");
804         require(_hasLiqBeenAdded, "Liquidity must be added.");
805         setExcludedFromReward(address(this), true);
806         setExcludedFromReward(lpPair, true);
807         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp)) {} catch {}
808         tradingEnabled = true;
809     }
810 
811     function sweepContingency() external onlyOwner {
812         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
813         payable(owner()).transfer(address(this).balance);
814     }
815 
816     struct ExtraValues {
817         uint256 tTransferAmount;
818         uint256 tFee;
819         uint256 tLiquidity;
820 
821         uint256 rTransferAmount;
822         uint256 rAmount;
823         uint256 rFee;
824     }
825 
826     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
827         if (!_hasLiqBeenAdded) {
828             _checkLiquidityAdd(from, to);
829             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
830                 revert("Only owner can transfer at this time.");
831             }
832         }
833 
834         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
835 
836         _rOwned[from] = _rOwned[from] - values.rAmount;
837         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
838 
839         if (_isExcluded[from] && !_isExcluded[to]) {
840             _tOwned[from] = _tOwned[from] - tAmount;
841         } else if (!_isExcluded[from] && _isExcluded[to]) {
842             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
843         } else if (_isExcluded[from] && _isExcluded[to]) {
844             _tOwned[from] = _tOwned[from] - tAmount;
845             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
846         }
847 
848         if (values.tLiquidity > 0)
849             _takeLiquidity(from, values.tLiquidity);
850         if (values.rFee > 0 || values.tFee > 0)
851             _rTotal -= values.rFee;
852             _tFeeTotal += values.tFee;
853 
854         emit Transfer(from, to, values.tTransferAmount);
855         return true;
856     }
857 
858     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
859         ExtraValues memory values;
860         uint256 currentRate = _getRate();
861 
862         values.rAmount = tAmount * currentRate;
863 
864         if (_hasLimits(from, to)) {
865             bool checked;
866             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
867                 checked = check;
868             } catch {
869                 revert();
870             }
871 
872             if(!checked) {
873                 revert();
874             }
875         }
876 
877         if(takeFee) {
878             if (lpPairs[to]) {
879                 currentTaxes.reflectFee = _sellTaxes.reflectFee;
880                 currentTaxes.treasuryFee = _sellTaxes.treasuryFee;
881                 currentTaxes.marketingFee = _sellTaxes.marketingFee;
882             } else if (lpPairs[from]) {
883                 currentTaxes.reflectFee = _buyTaxes.reflectFee;
884                 currentTaxes.treasuryFee = _buyTaxes.treasuryFee;
885                 currentTaxes.marketingFee = _buyTaxes.marketingFee;
886             } else {
887                 currentTaxes.reflectFee = _transferTaxes.reflectFee;
888                 currentTaxes.treasuryFee = _transferTaxes.treasuryFee;
889                 currentTaxes.marketingFee = _transferTaxes.marketingFee;
890             }
891 
892             values.tFee = (tAmount * currentTaxes.reflectFee) / staticVals.masterTaxDivisor;
893             values.tLiquidity = (tAmount * (currentTaxes.treasuryFee + currentTaxes.marketingFee)) / staticVals.masterTaxDivisor;
894             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
895 
896             values.rFee = values.tFee * currentRate;
897         } else {
898             values.tFee = 0;
899             values.tLiquidity = 0;
900             values.tTransferAmount = tAmount;
901 
902             values.rFee = 0;
903         }
904         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
905         return values;
906     }
907 
908     function _getRate() internal view returns(uint256) {
909         uint256 rSupply = _rTotal;
910         uint256 tSupply = _tTotal;
911         for (uint256 i = 0; i < _excluded.length; i++) {
912             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
913             rSupply = rSupply - _rOwned[_excluded[i]];
914             tSupply = tSupply - _tOwned[_excluded[i]];
915         }
916         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
917         return rSupply / tSupply;
918     }
919 
920     function _takeLiquidity(address sender, uint256 tLiquidity) private {
921         _rOwned[address(this)] = _rOwned[address(this)] + (tLiquidity * _getRate());
922         if(_isExcluded[address(this)])
923             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
924         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
925     }
926 }