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
192     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
193     function setLpPair(address pair, bool enabled) external;
194     function setProtections(bool _as, bool _ab, bool _algo) external;
195     function setGasPriceLimit(uint256 gas) external;
196     function removeSniper(address account) external;
197     function getSniperAmt() external view returns (uint256);
198     function isBlacklisted(address account) external view returns (bool);
199     function setBlacklistEnabled(address account, bool enabled) external;
200     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
201 }
202 
203 contract ROBOSHIB is Context, IERC20 {
204     // Ownership moved to in-contract for customizability.
205     address private _owner;
206 
207     mapping (address => uint256) private _rOwned;
208     mapping (address => uint256) private _tOwned;
209     mapping (address => bool) lpPairs;
210     uint256 private timeSinceLastPair = 0;
211     mapping (address => mapping (address => uint256)) private _allowances;
212 
213     mapping (address => bool) private _isExcludedFromFees;
214     mapping (address => bool) private _isExcluded;
215     address[] private _excluded;
216 
217     mapping (address => bool) private presaleAddresses;
218     bool private allowedPresaleExclusion = true;
219     mapping (address => bool) private _liquidityHolders;
220 
221     uint256 private startingSupply = 1_000_000_000_000;
222 
223     string constant private _name = "ROBOSHIB";
224     string constant private _symbol = "ROBOSHIB";
225     uint8 private _decimals = 9;
226 
227     uint256 private constant MAX = ~uint256(0);
228     uint256 private _tTotal = startingSupply * 10**_decimals;
229     uint256 private _rTotal = (MAX - (MAX % _tTotal));
230 
231     struct CurrentFees {
232         uint16 reflect;
233         uint16 totalSwap;
234     }
235 
236     struct Fees {
237         uint16 reflect;
238         uint16 liquidity;
239         uint16 marketing;
240         uint16 team;
241         uint16 totalSwap;
242     }
243 
244     struct StaticValuesStruct {
245         uint16 maxReflect;
246         uint16 maxLiquidity;
247         uint16 maxMarketing;
248         uint16 maxTeam;
249         uint16 masterTaxDivisor;
250     }
251 
252     struct Ratios {
253         uint16 liquidity;
254         uint16 marketing;
255         uint16 team;
256         uint16 total;
257     }
258 
259     CurrentFees private currentTaxes = CurrentFees({
260         reflect: 0,
261         totalSwap: 0
262         });
263 
264     Fees public _buyTaxes = Fees({
265         reflect: 0,
266         liquidity: 100,
267         marketing: 600,
268         team: 300,
269         totalSwap: 1000
270         });
271 
272     Fees public _sellTaxes = Fees({
273         reflect: 0,
274         liquidity: 100,
275         marketing: 2100,
276         team: 300,
277         totalSwap: 2500
278         });
279 
280     Fees public _transferTaxes = Fees({
281         reflect: 0,
282         liquidity: 100,
283         marketing: 600,
284         team: 300,
285         totalSwap: 1000
286         });
287 
288     Ratios public _ratios = Ratios({
289         liquidity: 2,
290         marketing: 27,
291         team: 6,
292         total: 35
293         });
294 
295     StaticValuesStruct public staticVals = StaticValuesStruct({
296         maxReflect: 800,
297         maxLiquidity: 800,
298         maxMarketing: 800,
299         maxTeam: 800,
300         masterTaxDivisor: 10000
301         });
302 
303     IUniswapV2Router02 public dexRouter;
304     address public lpPair;
305 
306     address public currentRouter;
307     // PCS ROUTER
308     address private pcsV2Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
309     // UNI ROUTER
310     address private uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
311 
312     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
313     address payable public _marketingWallet = payable(0x555A67E126a32421A3875A931c2e4c50B8022c2B);
314     address payable public _teamWallet = payable(0x555A67E126a32421A3875A931c2e4c50B8022c2B);
315     
316     bool inSwap;
317     bool public contractSwapEnabled = false;
318     
319     uint256 private maxTPercent = 1;
320     uint256 private maxTDivisor = 100;
321     uint256 private maxWPercent = 1;
322     uint256 private maxWDivisor = 100;
323 
324     uint256 private _maxTxAmount = (_tTotal * maxTPercent) / maxTDivisor;
325     uint256 public maxTxAmountUI = (startingSupply * maxTPercent) / maxTDivisor;
326     uint256 private _maxWalletSize = (_tTotal * maxWPercent) / maxWDivisor;
327     uint256 public maxWalletSizeUI = (startingSupply * maxWPercent) / maxWDivisor;
328 
329     uint256 private swapThreshold = (_tTotal * 5) / 10000;
330     uint256 private swapAmount = (_tTotal * 25) / 10000;
331 
332     bool public tradingEnabled = false;
333     bool public _hasLiqBeenAdded = false;
334     uint256 public tradingEnabledTime;
335     AntiSnipe antiSnipe;
336 
337     bool public increasedTaxTimeEnabled = true;
338     uint256 public increasedTaxTimeTimer = 24 hours;
339 
340     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
341     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
342     event ContractSwapEnabledUpdated(bool enabled);
343     event SwapAndLiquify(
344         uint256 tokensSwapped,
345         uint256 ethReceived,
346         uint256 tokensIntoLiqudity
347     );
348     event SniperCaught(address sniperAddress);
349     
350     modifier lockTheSwap {
351         inSwap = true;
352         _;
353         inSwap = false;
354     }
355 
356     modifier onlyOwner() {
357         require(_owner == _msgSender(), "Caller =/= owner.");
358         _;
359     }
360     
361     constructor () payable {
362         _rOwned[_msgSender()] = _rTotal;
363 
364         // Set the owner.
365         _owner = msg.sender;
366 
367         if (block.chainid == 56 || block.chainid == 97) {
368             currentRouter = pcsV2Router;
369         } else if (block.chainid == 1) {
370             currentRouter = uniswapV2Router;
371         }
372 
373         dexRouter = IUniswapV2Router02(currentRouter);
374         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
375         lpPairs[lpPair] = true;
376 
377         _approve(msg.sender, currentRouter, type(uint256).max);
378         _approve(address(this), currentRouter, type(uint256).max);
379 
380         _isExcludedFromFees[owner()] = true;
381         _isExcludedFromFees[address(this)] = true;
382         _isExcludedFromFees[DEAD] = true;
383         _liquidityHolders[owner()] = true;
384 
385         emit Transfer(address(0), _msgSender(), _tTotal);
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
423     function totalSupply() external view override returns (uint256) { return _tTotal; }
424     function decimals() external view override returns (uint8) { return _decimals; }
425     function symbol() external pure override returns (string memory) { return _symbol; }
426     function name() external pure override returns (string memory) { return _name; }
427     function getOwner() external view override returns (address) { return owner(); }
428     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
429 
430     function balanceOf(address account) public view override returns (uint256) {
431         if (_isExcluded[account]) return _tOwned[account];
432         return tokenFromReflection(_rOwned[account]);
433     }
434 
435     function transfer(address recipient, uint256 amount) public override returns (bool) {
436         _transfer(_msgSender(), recipient, amount);
437         return true;
438     }
439 
440     function approve(address spender, uint256 amount) public override returns (bool) {
441         _approve(_msgSender(), spender, amount);
442         return true;
443     }
444 
445     function _approve(address sender, address spender, uint256 amount) private {
446         require(sender != address(0), "ERC20: Zero Address");
447         require(spender != address(0), "ERC20: Zero Address");
448 
449         _allowances[sender][spender] = amount;
450         emit Approval(sender, spender, amount);
451     }
452 
453     function approveContractContingency() public onlyOwner returns (bool) {
454         _approve(address(this), address(dexRouter), type(uint256).max);
455         return true;
456     }
457 
458     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
459         if (_allowances[sender][msg.sender] != type(uint256).max) {
460             _allowances[sender][msg.sender] -= amount;
461         }
462 
463         return _transfer(sender, recipient, amount);
464     }
465 
466     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
467         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
468         return true;
469     }
470 
471     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
472         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
473         return true;
474     }
475 
476     function setNewRouter(address newRouter) public onlyOwner() {
477         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
478         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
479         if (get_pair == address(0)) {
480             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
481         }
482         else {
483             lpPair = get_pair;
484         }
485         dexRouter = _newRouter;
486         _approve(address(this), address(dexRouter), type(uint256).max);
487     }
488 
489     function setLpPair(address pair, bool enabled) external onlyOwner {
490         if (enabled == false) {
491             lpPairs[pair] = false;
492             antiSnipe.setLpPair(pair, false);
493         } else {
494             if (timeSinceLastPair != 0) {
495                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
496             }
497             lpPairs[pair] = true;
498             timeSinceLastPair = block.timestamp;
499             antiSnipe.setLpPair(pair, true);
500         }
501     }
502 
503     function changeRouterContingency(address router) external onlyOwner {
504         require(!_hasLiqBeenAdded);
505         currentRouter = router;
506     }
507 
508     function getCirculatingSupply() public view returns (uint256) {
509         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
510     }
511 
512     function isExcludedFromFees(address account) public view returns(bool) {
513         return _isExcludedFromFees[account];
514     }
515 
516     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
517         _isExcludedFromFees[account] = enabled;
518     }
519 
520     function isExcludedFromReward(address account) public view returns (bool) {
521         return _isExcluded[account];
522     }
523 
524     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
525         if (enabled == true) {
526             require(!_isExcluded[account], "Account is already excluded.");
527             if(_rOwned[account] > 0) {
528                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
529             }
530             _isExcluded[account] = true;
531             _excluded.push(account);
532         } else if (enabled == false) {
533             require(_isExcluded[account], "Account is already included.");
534             if(_excluded.length == 1){
535                 _tOwned[account] = 0;
536                 _isExcluded[account] = false;
537                 _excluded.pop();
538             } else {
539                 for (uint256 i = 0; i < _excluded.length; i++) {
540                     if (_excluded[i] == account) {
541                         _excluded[i] = _excluded[_excluded.length - 1];
542                         _tOwned[account] = 0;
543                         _isExcluded[account] = false;
544                         _excluded.pop();
545                         break;
546                     }
547                 }
548             }
549         }
550     }
551 
552     function setInitializer(address initializer) external onlyOwner {
553         require(!_hasLiqBeenAdded, "Liquidity is already in.");
554         require(initializer != address(this), "Can't be self.");
555         antiSnipe = AntiSnipe(initializer);
556     }
557 
558     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
559         antiSnipe.setBlacklistEnabled(account, enabled);
560     }
561 
562     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
563         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
564     }
565 
566     function isBlacklisted(address account) public view returns (bool) {
567         return antiSnipe.isBlacklisted(account);
568     }
569 
570     function getSniperAmt() public view returns (uint256) {
571         return antiSnipe.getSniperAmt();
572     }
573 
574     function removeSniper(address account) external onlyOwner {
575         antiSnipe.removeSniper(account);
576     }
577 
578     function setProtectionSettings(bool _antiSnipe, bool _antiBlock, bool _algo) external onlyOwner {
579         antiSnipe.setProtections(_antiSnipe, _antiBlock, _algo);
580     }
581 
582     function setTaxesBuy(uint16 reflect, uint16 liquidity, uint16 marketing, uint16 team) external onlyOwner {
583         require(reflect <= staticVals.maxReflect
584                 && liquidity <= staticVals.maxLiquidity
585                 && marketing <= staticVals.maxMarketing
586                 && team <= staticVals.maxTeam);
587         uint16 check = reflect + liquidity + marketing + team;
588         require(check <= 3450);
589         _buyTaxes.liquidity = liquidity;
590         _buyTaxes.reflect = reflect;
591         _buyTaxes.marketing = marketing;
592         _buyTaxes.team = team;
593         _buyTaxes.totalSwap = check - reflect;
594     }
595 
596     function setTaxesSell(uint16 reflect, uint16 liquidity, uint16 marketing, uint16 team) external onlyOwner {
597         require(reflect <= staticVals.maxReflect
598                 && liquidity <= staticVals.maxLiquidity
599                 && marketing <= staticVals.maxMarketing
600                 && team <= staticVals.maxTeam);
601         uint16 check = reflect + liquidity + marketing + team;
602         require(check <= 3450);
603         _sellTaxes.liquidity = liquidity;
604         _sellTaxes.reflect = reflect;
605         _sellTaxes.marketing = marketing;
606         _sellTaxes.team = team;
607         _sellTaxes.totalSwap = check - reflect;
608     }
609 
610     function setTaxesTransfer(uint16 reflect, uint16 liquidity, uint16 marketing, uint16 team) external onlyOwner {
611         require(reflect <= staticVals.maxReflect
612                 && liquidity <= staticVals.maxLiquidity
613                 && marketing <= staticVals.maxMarketing
614                 && team <= staticVals.maxTeam);
615         uint16 check = reflect + liquidity + marketing + team;
616         require(check <= 3450);
617         _transferTaxes.liquidity = liquidity;
618         _transferTaxes.reflect = reflect;
619         _transferTaxes.marketing = marketing;
620         _transferTaxes.team = team;
621         _transferTaxes.totalSwap = check - reflect;
622     }
623 
624     function setRatios(uint16 liquidity, uint16 marketing, uint16 team) external onlyOwner {
625         _ratios.liquidity = liquidity;
626         _ratios.marketing = marketing;
627         _ratios.team = team;
628         _ratios.total = liquidity + marketing + team;
629     }
630 
631     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
632         uint256 check = (_tTotal * percent) / divisor;
633         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
634         _maxTxAmount = check;
635         maxTxAmountUI = (startingSupply * percent) / divisor;
636     }
637 
638     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
639         uint256 check = (_tTotal * percent) / divisor;
640         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
641         _maxWalletSize = check;
642         maxWalletSizeUI = (startingSupply * percent) / divisor;
643     }
644 
645     function removeLimits() external onlyOwner {
646         _maxWalletSize = _tTotal;
647         maxWalletSizeUI = startingSupply;
648         _maxTxAmount = _tTotal;
649         maxTxAmountUI = startingSupply;
650     }
651 
652     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
653         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
654         swapAmount = (_tTotal * amountPercent) / amountDivisor;
655     }
656 
657     function setWallets(address payable marketing, address payable team) external onlyOwner {
658         _marketingWallet = payable(marketing);
659         _teamWallet = payable(team);
660     }
661 
662     function setContractSwapEnabled(bool _enabled) public onlyOwner {
663         contractSwapEnabled = _enabled;
664         emit ContractSwapEnabledUpdated(_enabled);
665     }
666 
667     function excludePresaleAddresses(address router, address presale) external onlyOwner {
668         require(allowedPresaleExclusion, "Function already used.");
669         if (router == presale) {
670             _liquidityHolders[presale] = true;
671             presaleAddresses[presale] = true;
672             setExcludedFromFees(presale, true);
673             setExcludedFromReward(presale, true);
674         } else {
675             _liquidityHolders[router] = true;
676             _liquidityHolders[presale] = true;
677             presaleAddresses[router] = true;
678             presaleAddresses[presale] = true;
679             setExcludedFromFees(router, true);
680             setExcludedFromFees(presale, true);
681             setExcludedFromReward(router, true);
682             setExcludedFromReward(presale, true);
683         }
684     }
685 
686     function _hasLimits(address from, address to) private view returns (bool) {
687         return from != owner()
688             && to != owner()
689             && !_liquidityHolders[to]
690             && !_liquidityHolders[from]
691             && to != DEAD
692             && to != address(0)
693             && from != address(this);
694     }
695 
696     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
697         require(rAmount <= _rTotal, "Amount must be less than total reflections");
698         uint256 currentRate =  _getRate();
699         return rAmount / currentRate;
700     }
701 
702     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
703         require(from != address(0), "ERC20: transfer from the zero address");
704         require(to != address(0), "ERC20: transfer to the zero address");
705         require(amount > 0, "Transfer amount must be greater than zero");
706         if(_hasLimits(from, to)) {
707             if(!tradingEnabled) {
708                 revert("Trading not yet enabled!");
709             }
710             if(lpPairs[from] || lpPairs[to]){
711                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
712             }
713             if(to != currentRouter && !lpPairs[to]) {
714                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
715             }
716         }
717 
718         bool takeFee = true;
719         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
720             takeFee = false;
721         }
722 
723         if (lpPairs[to]) {
724             if (!inSwap
725                 && contractSwapEnabled
726                 && !presaleAddresses[to]
727                 && !presaleAddresses[from]
728             ) {
729                 uint256 contractTokenBalance = balanceOf(address(this));
730                 if (contractTokenBalance >= swapThreshold) {
731                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
732                     contractSwap(contractTokenBalance);
733                 }
734             }      
735         } 
736         return _finalizeTransfer(from, to, amount, takeFee);
737     }
738 
739     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
740         if (_ratios.total == 0)
741             return;
742 
743         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
744             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
745         }
746 
747         uint256 toLiquify = ((contractTokenBalance * _ratios.liquidity) / _ratios.total) / 2;
748 
749         uint256 toSwapForEth = contractTokenBalance - toLiquify;
750         
751         address[] memory path = new address[](2);
752         path[0] = address(this);
753         path[1] = dexRouter.WETH();
754 
755         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
756             toSwapForEth,
757             0, // accept any amount of ETH
758             path,
759             address(this),
760             block.timestamp
761         );
762 
763 
764         uint256 liquidityBalance = ((address(this).balance * _ratios.liquidity) / _ratios.total) / 2;
765 
766         if (toLiquify > 0) {
767             dexRouter.addLiquidityETH{value: liquidityBalance}(
768                 address(this),
769                 toLiquify,
770                 0, // slippage is unavoidable
771                 0, // slippage is unavoidable
772                 DEAD,
773                 block.timestamp
774             );
775             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
776         }
777         if (address(this).balance > 0 && _ratios.total - _ratios.liquidity > 0) {
778             _teamWallet.transfer((address(this).balance * _ratios.team) / (_ratios.total - _ratios.liquidity));
779             _marketingWallet.transfer(address(this).balance);
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
806         tradingEnabledTime = block.timestamp;
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
879                 currentTaxes.reflect = _sellTaxes.reflect;
880                 currentTaxes.totalSwap = _sellTaxes.totalSwap;
881             } else if (lpPairs[from]) {
882                 currentTaxes.reflect = _buyTaxes.reflect;
883                 currentTaxes.totalSwap = _buyTaxes.totalSwap;
884             } else {
885                 currentTaxes.reflect = _transferTaxes.reflect;
886                 currentTaxes.totalSwap = _transferTaxes.totalSwap;
887             }
888 
889             values.tFee = (tAmount * currentTaxes.reflect) / staticVals.masterTaxDivisor;
890             values.tSwap = (tAmount * currentTaxes.totalSwap) / staticVals.masterTaxDivisor;
891             values.tTransferAmount = tAmount - (values.tFee + values.tSwap);
892 
893             values.rFee = values.tFee * currentRate;
894         } else {
895             values.tFee = 0;
896             values.tSwap = 0;
897             values.tTransferAmount = tAmount;
898 
899             values.rFee = 0;
900         }
901         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * currentRate));
902         return values;
903     }
904 
905     function _getRate() internal view returns(uint256) {
906         uint256 rSupply = _rTotal;
907         uint256 tSupply = _tTotal;
908         for (uint256 i = 0; i < _excluded.length; i++) {
909             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
910             rSupply = rSupply - _rOwned[_excluded[i]];
911             tSupply = tSupply - _tOwned[_excluded[i]];
912         }
913         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
914         return rSupply / tSupply;
915     }
916 }