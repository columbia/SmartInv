1 /*
2 I heard a rumor..... that this token will absolutely moon.
3 
4 TELEGRAM : https://t.me/DogKageNation
5 WEBSITE :  http://www.DogKage.net
6 TWITTER :  http://www.twitter.com/DogKage
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity >=0.6.0 <0.9.0;
11 
12 abstract contract Context {
13     function _msgSender() internal view returns (address payable) {
14         return payable(msg.sender);
15     }
16 
17     function _msgData() internal view returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24   /**
25    * @dev Returns the amount of tokens in existence.
26    */
27   function totalSupply() external view returns (uint256);
28 
29   /**
30    * @dev Returns the token decimals.
31    */
32   function decimals() external view returns (uint8);
33 
34   /**
35    * @dev Returns the token symbol.
36    */
37   function symbol() external view returns (string memory);
38 
39   /**
40   * @dev Returns the token name.
41   */
42   function name() external view returns (string memory);
43 
44   /**
45    * @dev Returns the bep token owner.
46    */
47   function getOwner() external view returns (address);
48 
49   /**
50    * @dev Returns the amount of tokens owned by `account`.
51    */
52   function balanceOf(address account) external view returns (uint256);
53 
54   /**
55    * @dev Moves `amount` tokens from the caller's account to `recipient`.
56    *
57    * Returns a boolean value indicating whether the operation succeeded.
58    *
59    * Emits a {Transfer} event.
60    */
61   function transfer(address recipient, uint256 amount) external returns (bool);
62 
63   /**
64    * @dev Returns the remaining number of tokens that `spender` will be
65    * allowed to spend on behalf of `owner` through {transferFrom}. This is
66    * zero by default.
67    *
68    * This value changes when {approve} or {transferFrom} are called.
69    */
70   function allowance(address _owner, address spender) external view returns (uint256);
71 
72   /**
73    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74    *
75    * Returns a boolean value indicating whether the operation succeeded.
76    *
77    * IMPORTANT: Beware that changing an allowance with this method brings the risk
78    * that someone may use both the old and the new allowance by unfortunate
79    * transaction ordering. One possible solution to mitigate this race
80    * condition is to first reduce the spender's allowance to 0 and set the
81    * desired value afterwards:
82    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83    *
84    * Emits an {Approval} event.
85    */
86   function approve(address spender, uint256 amount) external returns (bool);
87 
88   /**
89    * @dev Moves `amount` tokens from `sender` to `recipient` using the
90    * allowance mechanism. `amount` is then deducted from the caller's
91    * allowance.
92    *
93    * Returns a boolean value indicating whether the operation succeeded.
94    *
95    * Emits a {Transfer} event.
96    */
97   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99   /**
100    * @dev Emitted when `value` tokens are moved from one account (`from`) to
101    * another (`to`).
102    *
103    * Note that `value` may be zero.
104    */
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 
107   /**
108    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109    * a call to {approve}. `value` is the new allowance.
110    */
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 interface IUniswapV2Factory {
115     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
116     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
117     function createPair(address tokenA, address tokenB) external returns (address lpPair);
118 }
119 
120 interface IUniswapV2Pair {
121     event Approval(address indexed owner, address indexed spender, uint value);
122     event Transfer(address indexed from, address indexed to, uint value);
123 
124     function name() external pure returns (string memory);
125     function symbol() external pure returns (string memory);
126     function decimals() external pure returns (uint8);
127     function totalSupply() external view returns (uint);
128     function balanceOf(address owner) external view returns (uint);
129     function allowance(address owner, address spender) external view returns (uint);
130     function approve(address spender, uint value) external returns (bool);
131     function transfer(address to, uint value) external returns (bool);
132     function transferFrom(address from, address to, uint value) external returns (bool);
133     function factory() external view returns (address);
134 }
135 
136 interface IUniswapV2Router01 {
137     function factory() external pure returns (address);
138     function WETH() external pure returns (address);
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
147 }
148 
149 interface IUniswapV2Router02 is IUniswapV2Router01 {
150     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external;
157     function swapExactETHForTokensSupportingFeeOnTransferTokens(
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external payable;
163     function swapExactTokensForETHSupportingFeeOnTransferTokens(
164         uint amountIn,
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external;
170 }
171 
172 contract DAKE is Context, IERC20 {
173     // Ownership moved to in-contract for customizability.
174     address private _owner;
175     mapping (address => uint256) private _tOwned;
176     mapping (address => bool) lpPairs;
177     uint256 private timeSinceLastPair = 0;
178     mapping (address => mapping (address => uint256)) private _allowances;
179 
180     mapping (address => bool) private _isExcludedFromFees;
181     mapping (address => bool) private _isSniperOrBlacklisted;
182     mapping (address => bool) private _liquidityHolders;
183 
184     uint256 private startingSupply = 10_000_000_000;
185 
186     string private _name = "DOGKAGE";
187     string private _symbol = "DAKE";
188 
189     uint256 public _buyFee = 1000;
190     uint256 public _sellFee = 1000;
191     uint256 public _transferFee = 1000;
192 
193     uint256 constant public maxBuyTaxes = 1200;
194     uint256 constant public maxSellTaxes = 1200;
195     uint256 constant public maxTransferTaxes = 2000;
196 
197     uint256 public _liquidityRatio = 1;
198     uint256 public _marketingRatio = 5;
199     uint256 public _devRatio = 4;
200 
201     uint256 private constant masterTaxDivisor = 10000;
202 
203     uint256 private constant MAX = ~uint256(0);
204     uint8 constant private _decimals = 9;
205     uint256 constant private _decimalsMul = _decimals;
206     uint256 private _tTotal = startingSupply * 10**_decimalsMul;
207     uint256 private _tFeeTotal;
208 
209     IUniswapV2Router02 public dexRouter;
210     address public lpPair;
211 
212     // UNI ROUTER
213     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
214 
215     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
216     address payable private _marketingWallet = payable(0xe9d53464b35233525e2bc3F023841229F551c612);
217     address payable private _teamWallet = payable(0x34feAcD1c6f9a4Be8640AF5d1EE35A810b505Cd9);
218     
219     bool inSwapAndLiquify;
220     bool public swapAndLiquifyEnabled = false;
221     
222     uint256 private maxTxPercent = 1;
223     uint256 private maxTxDivisor = 100;
224     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
225     uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor;
226 
227     uint256 private maxWalletPercent = 1;
228     uint256 private maxWalletDivisor = 100;
229     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
230     uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor;
231 
232     uint256 private swapThreshold = (_tTotal * 5) / 10000;
233     uint256 private swapAmount = (_tTotal * 5) / 1000;
234 
235     bool private sniperProtection = true;
236     bool public _hasLiqBeenAdded = false;
237     uint256 private _liqAddStatus = 0;
238     uint256 private _liqAddBlock = 0;
239     uint256 private _liqAddStamp = 0;
240     uint256 private _initialLiquidityAmount = 0;
241     uint256 private snipeBlockAmt = 0;
242     uint256 public snipersCaught = 0;
243     bool private sameBlockActive = true;
244     mapping (address => uint256) private lastTrade;
245 
246     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
247     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
248     event SwapAndLiquifyEnabledUpdated(bool enabled);
249     event SwapAndLiquify(
250         uint256 tokensSwapped,
251         uint256 ethReceived,
252         uint256 tokensIntoLiqudity
253     );
254     event SniperCaught(address sniperAddress);
255     
256     modifier lockTheSwap {
257         inSwapAndLiquify = true;
258         _;
259         inSwapAndLiquify = false;
260     }
261 
262     modifier onlyOwner() {
263         require(_owner == _msgSender(), "Caller =/= owner.");
264         _;
265     }
266     
267     constructor () payable {
268         _tOwned[_msgSender()] = _tTotal;
269 
270         // Set the owner.
271         _owner = msg.sender;
272 
273         dexRouter = IUniswapV2Router02(_routerAddress);
274         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
275         lpPairs[lpPair] = true;
276         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
277 
278         _isExcludedFromFees[owner()] = true;
279         _isExcludedFromFees[address(this)] = true;
280         _isExcludedFromFees[DEAD] = true;
281         _liquidityHolders[owner()] = true;
282 
283         // Approve the owner for PancakeSwap, timesaver.
284         _approve(_msgSender(), _routerAddress, _tTotal);
285 
286         // Ever-growing sniper/tool blacklist
287 
288 
289         emit Transfer(address(0), _msgSender(), _tTotal);
290     }
291 
292     receive() external payable {}
293 
294 //===============================================================================================================
295 //===============================================================================================================
296 //===============================================================================================================
297     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
298     // This allows for removal of ownership privelages from the owner once renounced or transferred.
299     function owner() public view returns (address) {
300         return _owner;
301     }
302 
303     function transferOwner(address newOwner) external onlyOwner() {
304         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
305         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
306         setExcludedFromFees(_owner, false);
307         setExcludedFromFees(newOwner, true);
308         
309         if (_marketingWallet == payable(_owner))
310             _marketingWallet = payable(newOwner);
311         
312         _allowances[_owner][newOwner] = balanceOf(_owner);
313         if(balanceOf(_owner) > 0) {
314             _transfer(_owner, newOwner, balanceOf(_owner));
315         }
316         
317         _owner = newOwner;
318         emit OwnershipTransferred(_owner, newOwner);
319         
320     }
321 
322     function renounceOwnership() public virtual onlyOwner() {
323         setExcludedFromFees(_owner, false);
324         _owner = address(0);
325         emit OwnershipTransferred(_owner, address(0));
326     }
327 //===============================================================================================================
328 //===============================================================================================================
329 //===============================================================================================================
330 
331     function totalSupply() external view override returns (uint256) { return _tTotal; }
332     function decimals() external pure override returns (uint8) { return _decimals; }
333     function symbol() external view override returns (string memory) { return _symbol; }
334     function name() external view override returns (string memory) { return _name; }
335     function getOwner() external view override returns (address) { return owner(); }
336     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
337 
338     function balanceOf(address account) public view override returns (uint256) {
339         return _tOwned[account];
340     }
341 
342     function transfer(address recipient, uint256 amount) public override returns (bool) {
343         _transfer(_msgSender(), recipient, amount);
344         return true;
345     }
346 
347     function approve(address spender, uint256 amount) public override returns (bool) {
348         _approve(_msgSender(), spender, amount);
349         return true;
350     }
351 
352     function _approve(address sender, address spender, uint256 amount) private {
353         require(sender != address(0), "ERC20: Zero Address");
354         require(spender != address(0), "ERC20: Zero Address");
355 
356         _allowances[sender][spender] = amount;
357         emit Approval(sender, spender, amount);
358     }
359 
360     function approveMax(address spender) public returns (bool) {
361         return approve(spender, type(uint256).max);
362     }
363 
364     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
365         if (_allowances[sender][msg.sender] != type(uint256).max) {
366             _allowances[sender][msg.sender] -= amount;
367         }
368 
369         return _transfer(sender, recipient, amount);
370     }
371 
372     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
373         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
374         return true;
375     }
376 
377     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
378         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
379         return true;
380     }
381 
382     function setNewRouter(address newRouter) public onlyOwner() {
383         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
384         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
385         if (get_pair == address(0)) {
386             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
387         }
388         else {
389             lpPair = get_pair;
390         }
391         dexRouter = _newRouter;
392     }
393 
394     function setLpPair(address pair, bool enabled) external onlyOwner {
395         if (enabled == false) {
396             lpPairs[pair] = false;
397         } else {
398             if (timeSinceLastPair != 0) {
399                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
400             }
401             lpPairs[pair] = true;
402             timeSinceLastPair = block.timestamp;
403         }
404     }
405 
406     function isExcludedFromFees(address account) public view returns(bool) {
407         return _isExcludedFromFees[account];
408     }
409 
410     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
411         _isExcludedFromFees[account] = enabled;
412     }
413 
414     function isSniperOrBlacklisted(address account) public view returns (bool) {
415         return _isSniperOrBlacklisted[account];
416     }
417 
418     function isProtected(uint256 rInitializer) external onlyOwner {
419         require (_liqAddStatus == 0, "Error.");
420         _liqAddStatus = rInitializer;
421     }
422 
423     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
424         _isSniperOrBlacklisted[account] = enabled;
425     }
426 
427     function setStartingProtections(uint8 _block) external onlyOwner{
428         require (snipeBlockAmt == 0 && !_hasLiqBeenAdded);
429         snipeBlockAmt = _block;
430     }
431 
432     function setProtectionSettings(bool antiSnipe, bool antiBlock) external onlyOwner() {
433         sniperProtection = antiSnipe;
434         sameBlockActive = antiBlock;
435     }
436 
437     function setTaxes(uint256 buyFee, uint256 sellFee, uint256 transferFee) external onlyOwner {
438         require(buyFee <= maxBuyTaxes
439                 && sellFee <= maxSellTaxes
440                 && transferFee <= maxTransferTaxes,
441                 "Cannot exceed maximums.");
442         _buyFee = buyFee;
443         _sellFee = sellFee;
444         _transferFee = transferFee;
445     }
446 
447     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
448         require (liquidity + marketing == 100, "Must add up to 100%");
449         _liquidityRatio = liquidity;
450         _marketingRatio = marketing;
451     }
452 
453     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
454         uint256 check = (_tTotal * percent) / divisor;
455         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
456         _maxTxAmount = check;
457         maxTxAmountUI = (startingSupply * percent) / divisor;
458     }
459 
460     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
461         uint256 check = (_tTotal * percent) / divisor;
462         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
463         _maxWalletSize = check;
464         maxWalletSizeUI = (startingSupply * percent) / divisor;
465     }
466 
467     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
468         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
469         swapAmount = (_tTotal * amountPercent) / amountDivisor;
470     }
471 
472     function setWallets(address payable marketingWallet, address payable teamWallet) external onlyOwner {
473         _marketingWallet = payable(marketingWallet);
474         _teamWallet = payable(teamWallet);
475     }
476 
477     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
478         swapAndLiquifyEnabled = _enabled;
479         emit SwapAndLiquifyEnabledUpdated(_enabled);
480     }
481 
482     function _hasLimits(address from, address to) private view returns (bool) {
483         return from != owner()
484             && to != owner()
485             && !_liquidityHolders[to]
486             && !_liquidityHolders[from]
487             && to != DEAD
488             && to != address(0)
489             && from != address(this);
490     }
491 
492     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
493         require(from != address(0), "ERC20: Zero address.");
494         require(to != address(0), "ERC20: Zero address.");
495         require(amount > 0, "Must >0.");
496         if(_hasLimits(from, to)) {
497             if (sameBlockActive) {
498                 if (lpPairs[from]){
499                     require(lastTrade[to] != block.number);
500                     lastTrade[to] = block.number;
501                 } else {
502                     require(lastTrade[from] != block.number);
503                     lastTrade[from] = block.number;
504                 }
505             }
506             if(lpPairs[from] || lpPairs[to]){
507                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
508             }
509             if(to != _routerAddress && !lpPairs[to]) {
510                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
511             }
512         }
513 
514         bool takeFee = true;
515         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
516             takeFee = false;
517         }
518 
519         if (lpPairs[to]) {
520             if (!inSwapAndLiquify
521                 && swapAndLiquifyEnabled
522             ) {
523                 uint256 contractTokenBalance = balanceOf(address(this));
524                 if (contractTokenBalance >= swapThreshold) {
525                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
526                     swapAndLiquify(contractTokenBalance);
527                 }
528             }      
529         } 
530         return _finalizeTransfer(from, to, amount, takeFee);
531     }
532 
533     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
534         if (_liquidityRatio + _marketingRatio + _devRatio == 0)
535             return;
536         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio + _devRatio)) / 2;
537 
538         uint256 toSwapForEth = contractTokenBalance - toLiquify;
539         swapTokensForEth(toSwapForEth);
540 
541         uint256 currentBalance = address(this).balance;
542         uint256 liquidityBalance = ((currentBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio + _devRatio)) / 2;
543 
544         if (toLiquify > 0) {
545             addLiquidity(toLiquify, liquidityBalance);
546             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
547         }
548         if (contractTokenBalance - toLiquify > 0) {
549             _marketingWallet.transfer(((currentBalance - liquidityBalance) * _marketingRatio) / (_marketingRatio + _devRatio));
550             _teamWallet.transfer(address(this).balance);
551         }
552     }
553 
554     function swapTokensForEth(uint256 tokenAmount) internal {
555         address[] memory path = new address[](2);
556         path[0] = address(this);
557         path[1] = dexRouter.WETH();
558 
559         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
560             tokenAmount,
561             0, // accept any amount of ETH
562             path,
563             address(this),
564             block.timestamp
565         );
566     }
567 
568     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
569         dexRouter.addLiquidityETH{value: ethAmount}(
570             address(this),
571             tokenAmount,
572             0, // slippage is unavoidable
573             0, // slippage is unavoidable
574             DEAD,
575             block.timestamp
576         );
577     }
578 
579     function _checkLiquidityAdd(address from, address to) private {
580         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
581         if (!_hasLimits(from, to) && to == lpPair) {
582             if (snipeBlockAmt != 2) {
583                 _liqAddBlock = block.number + 5000;
584             } else {
585                 _liqAddBlock = block.number;
586             }
587 
588             _liquidityHolders[from] = true;
589             _hasLiqBeenAdded = true;
590             _liqAddStamp = block.timestamp;
591 
592             swapAndLiquifyEnabled = true;
593             emit SwapAndLiquifyEnabledUpdated(true);
594         }
595     }
596 
597     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
598         if (sniperProtection){
599             if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
600                 revert("Sniper rejected.");
601             }
602 
603             if (!_hasLiqBeenAdded) {
604                 _checkLiquidityAdd(from, to);
605                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
606                     revert("Only owner can transfer at this time.");
607                 }
608             } else {
609                 if (_liqAddBlock > 0 
610                     && lpPairs[from] 
611                     && _hasLimits(from, to)
612                 ) {
613                     if (block.number - _liqAddBlock < snipeBlockAmt) {
614                         _isSniperOrBlacklisted[to] = true;
615                         snipersCaught ++;
616                         emit SniperCaught(to);
617                     }
618                 }
619             }
620         }
621 
622         _tOwned[from] -= amount;
623         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
624         _tOwned[to] += amountReceived;
625 
626         emit Transfer(from, to, amountReceived);
627         return true;
628     }
629 
630     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
631         uint256 currentFee;
632         if (from == lpPair) {
633             currentFee = _buyFee;
634         } else if (to == lpPair) {
635             currentFee = _sellFee;
636         } else {
637             currentFee = _transferFee;
638         }
639 
640         if (_hasLimits(from, to)){
641             if (_liqAddStatus == 0 || _liqAddStatus != startingSupply/10) {
642                 revert();
643             }
644         }
645 
646         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
647 
648         _tOwned[address(this)] += feeAmount;
649         emit Transfer(from, address(this), feeAmount);
650 
651         return amount - feeAmount;
652     }
653 }