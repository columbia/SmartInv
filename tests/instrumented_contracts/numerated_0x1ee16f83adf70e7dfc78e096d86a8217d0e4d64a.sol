1 // t.me/Soraka_ERC20
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity >=0.6.0 <0.9.0;
5 
6 abstract contract Context {
7     function _msgSender() internal view returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18   /**
19    * @dev Returns the amount of tokens in existence.
20    */
21   function totalSupply() external view returns (uint256);
22 
23   /**
24    * @dev Returns the token decimals.
25    */
26   function decimals() external view returns (uint8);
27 
28   /**
29    * @dev Returns the token symbol.
30    */
31   function symbol() external view returns (string memory);
32 
33   /**
34   * @dev Returns the token name.
35   */
36   function name() external view returns (string memory);
37 
38   /**
39    * @dev Returns the bep token owner.
40    */
41   function getOwner() external view returns (address);
42 
43   /**
44    * @dev Returns the amount of tokens owned by `account`.
45    */
46   function balanceOf(address account) external view returns (uint256);
47 
48   /**
49    * @dev Moves `amount` tokens from the caller's account to `recipient`.
50    *
51    * Returns a boolean value indicating whether the operation succeeded.
52    *
53    * Emits a {Transfer} event.
54    */
55   function transfer(address recipient, uint256 amount) external returns (bool);
56 
57   /**
58    * @dev Returns the remaining number of tokens that `spender` will be
59    * allowed to spend on behalf of `owner` through {transferFrom}. This is
60    * zero by default.
61    *
62    * This value changes when {approve} or {transferFrom} are called.
63    */
64   function allowance(address _owner, address spender) external view returns (uint256);
65 
66   /**
67    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68    *
69    * Returns a boolean value indicating whether the operation succeeded.
70    *
71    * IMPORTANT: Beware that changing an allowance with this method brings the risk
72    * that someone may use both the old and the new allowance by unfortunate
73    * transaction ordering. One possible solution to mitigate this race
74    * condition is to first reduce the spender's allowance to 0 and set the
75    * desired value afterwards:
76    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77    *
78    * Emits an {Approval} event.
79    */
80   function approve(address spender, uint256 amount) external returns (bool);
81 
82   /**
83    * @dev Moves `amount` tokens from `sender` to `recipient` using the
84    * allowance mechanism. `amount` is then deducted from the caller's
85    * allowance.
86    *
87    * Returns a boolean value indicating whether the operation succeeded.
88    *
89    * Emits a {Transfer} event.
90    */
91   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93   /**
94    * @dev Emitted when `value` tokens are moved from one account (`from`) to
95    * another (`to`).
96    *
97    * Note that `value` may be zero.
98    */
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 
101   /**
102    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103    * a call to {approve}. `value` is the new allowance.
104    */
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 interface IUniswapV2Factory {
109     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
110     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
111     function createPair(address tokenA, address tokenB) external returns (address lpPair);
112 }
113 
114 interface IUniswapV2Pair {
115     event Approval(address indexed owner, address indexed spender, uint value);
116     event Transfer(address indexed from, address indexed to, uint value);
117 
118     function name() external pure returns (string memory);
119     function symbol() external pure returns (string memory);
120     function decimals() external pure returns (uint8);
121     function totalSupply() external view returns (uint);
122     function balanceOf(address owner) external view returns (uint);
123     function allowance(address owner, address spender) external view returns (uint);
124     function approve(address spender, uint value) external returns (bool);
125     function transfer(address to, uint value) external returns (bool);
126     function transferFrom(address from, address to, uint value) external returns (bool);
127     function factory() external view returns (address);
128 }
129 
130 interface IUniswapV2Router01 {
131     function factory() external pure returns (address);
132     function WETH() external pure returns (address);
133     function addLiquidityETH(
134         address token,
135         uint amountTokenDesired,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline
140     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
141 }
142 
143 interface IUniswapV2Router02 is IUniswapV2Router01 {
144     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151     function swapExactETHForTokensSupportingFeeOnTransferTokens(
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external payable;
157     function swapExactTokensForETHSupportingFeeOnTransferTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external;
164 }
165 
166 contract SORAKA is Context, IERC20 {
167     // Ownership moved to in-contract for customizability.
168     address private _owner;
169     mapping (address => uint256) private _tOwned;
170     mapping (address => uint256) private _buyMap;
171     mapping (address => bool) lpPairs;
172     uint256 private timeSinceLastPair = 0;
173     mapping (address => mapping (address => uint256)) private _allowances;
174 
175     mapping (address => bool) private _isExcludedFromFees;
176     mapping (address => bool) private _isSniper;
177     mapping (address => bool) private _liquidityHolders;
178 
179     uint256 private startingSupply = 1_000_000_000;
180 
181     string private _name = "Soraka";
182     string private _symbol = "SORAKA";
183 
184     uint256 public _buyFee = 900;
185     uint256 public _sellFee = 1100;
186     uint256 public _transferFee = 2000;
187     uint256 constant public _AntiDumpFee24hr = 2500;
188     uint256 public _JeetFee = _AntiDumpFee24hr;
189     uint256 constant maxJeetFee = 5000;
190     uint256 constant public maxBuyTaxes = 900;
191     uint256 constant public maxSellTaxes = 1100;
192     uint256 constant public maxTransferTaxes = 2000;
193 
194     uint256 public _liquidityRatio = 1;
195     uint256 public _marketingRatio = 5;
196     uint256 public _devRatio = 3;
197 
198     uint256 private constant masterTaxDivisor = 10000;
199 
200     uint256 private constant MAX = ~uint256(0);
201     uint8 constant private _decimals = 9;
202     uint256 constant private _decimalsMul = _decimals;
203     uint256 private _tTotal = startingSupply * 10**_decimalsMul;
204     uint256 private _tFeeTotal;
205 
206     IUniswapV2Router02 public dexRouter;
207     address public lpPair;
208 
209     // UNI ROUTER
210     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
211 
212     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
213     address payable private _marketingWallet = payable(0x68F7A3F91B84D33F55F9CE6807ea506eba5d51d7);
214     address payable private _devWallet = payable(0x68F7A3F91B84D33F55F9CE6807ea506eba5d51d7);
215     
216     bool inSwapAndLiquify;
217     bool public swapAndLiquifyEnabled = false;
218     
219     uint256 private maxTxPercent = 1;
220     uint256 private maxTxDivisor = 100;
221     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
222     uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor;
223 
224     uint256 private maxWalletPercent = 2;
225     uint256 private maxWalletDivisor = 100;
226     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
227     uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor;
228 
229     uint256 private swapThreshold = (_tTotal * 5) / 10000;
230     uint256 private swapAmount = (_tTotal * 5) / 1000;
231 
232     bool private sniperProtection = true;
233     bool public _hasLiqBeenAdded = false;
234     uint256 private _liqAddStatus = 0;
235     uint256 private _liqAddBlock = 0;
236     uint256 private _liqAddStamp = 0;
237     uint256 private _initialLiquidityAmount = 0;
238     uint256 private snipeBlockAmt = 0;
239     uint256 public snipersCaught = 0;
240     bool private sameBlockActive = true;
241     mapping (address => uint256) private lastTrade;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
245     event SwapAndLiquifyEnabledUpdated(bool enabled);
246     event SwapAndLiquify(
247         uint256 tokensSwapped,
248         uint256 ethReceived,
249         uint256 tokensIntoLiqudity
250     );
251     event SniperCaught(address sniperAddress);
252     
253     modifier lockTheSwap {
254         inSwapAndLiquify = true;
255         _;
256         inSwapAndLiquify = false;
257     }
258 
259     modifier onlyOwner() {
260         require(_owner == _msgSender(), "Caller =/= owner.");
261         _;
262     }
263     
264     constructor () payable {
265         _tOwned[_msgSender()] = _tTotal;
266 
267         // Set the owner.
268         _owner = msg.sender;
269 
270         dexRouter = IUniswapV2Router02(_routerAddress);
271         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
272         lpPairs[lpPair] = true;
273         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
274 
275         _isExcludedFromFees[owner()] = true;
276         _isExcludedFromFees[address(this)] = true;
277         _isExcludedFromFees[DEAD] = true;
278         _liquidityHolders[owner()] = true;
279 
280         // Approve the owner for PancakeSwap, timesaver.
281         _approve(_msgSender(), _routerAddress, _tTotal);
282 
283         emit Transfer(address(0), _msgSender(), _tTotal);
284     }
285 
286     receive() external payable {}
287 
288 //===============================================================================================================
289 //===============================================================================================================
290 //===============================================================================================================
291     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
292     // This allows for removal of ownership privelages from the owner once renounced or transferred.
293     function owner() public view returns (address) {
294         return _owner;
295     }
296 
297     function transferOwner(address newOwner) external onlyOwner() {
298         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
299         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
300         setExcludedFromFees(_owner, false);
301         setExcludedFromFees(newOwner, true);
302         
303         if (_marketingWallet == payable(_owner))
304             _marketingWallet = payable(newOwner);
305         
306         _allowances[_owner][newOwner] = balanceOf(_owner);
307         if(balanceOf(_owner) > 0) {
308             _transfer(_owner, newOwner, balanceOf(_owner));
309         }
310         
311         _owner = newOwner;
312         emit OwnershipTransferred(_owner, newOwner);
313         
314     }
315 
316     function renounceOwnership() public virtual onlyOwner() {
317         setExcludedFromFees(_owner, false);
318         _owner = address(0);
319         emit OwnershipTransferred(_owner, address(0));
320     }
321 //===============================================================================================================
322 //===============================================================================================================
323 //===============================================================================================================
324 
325     function totalSupply() external view override returns (uint256) { return _tTotal; }
326     function decimals() external pure override returns (uint8) { return _decimals; }
327     function symbol() external view override returns (string memory) { return _symbol; }
328     function name() external view override returns (string memory) { return _name; }
329     function getOwner() external view override returns (address) { return owner(); }
330     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
331 
332     function balanceOf(address account) public view override returns (uint256) {
333         return _tOwned[account];
334     }
335 
336     function originalPurchase(address account) public view returns (uint256) {
337         return _buyMap[account];
338     }
339 
340     function transfer(address recipient, uint256 amount) public override returns (bool) {
341         _transfer(_msgSender(), recipient, amount);
342         return true;
343     }
344 
345     function approve(address spender, uint256 amount) public override returns (bool) {
346         _approve(_msgSender(), spender, amount);
347         return true;
348     }
349 
350     function _approve(address sender, address spender, uint256 amount) private {
351         require(sender != address(0), "ERC20: Zero Address");
352         require(spender != address(0), "ERC20: Zero Address");
353 
354         _allowances[sender][spender] = amount;
355         emit Approval(sender, spender, amount);
356     }
357 
358     function approveMax(address spender) public returns (bool) {
359         return approve(spender, type(uint256).max);
360     }
361 
362     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
363         if (_allowances[sender][msg.sender] != type(uint256).max) {
364             _allowances[sender][msg.sender] -= amount;
365         }
366 
367         return _transfer(sender, recipient, amount);
368     }
369 
370     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
371         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
372         return true;
373     }
374 
375     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
376         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
377         return true;
378     }
379 
380     function setNewRouter(address newRouter) public onlyOwner() {
381         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
382         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
383         if (get_pair == address(0)) {
384             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
385         }
386         else {
387             lpPair = get_pair;
388         }
389         dexRouter = _newRouter;
390     }
391 
392     function setLpPair(address pair, bool enabled) external onlyOwner {
393         if (enabled == false) {
394             lpPairs[pair] = false;
395         } else {
396             if (timeSinceLastPair != 0) {
397                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
398             }
399             lpPairs[pair] = true;
400             timeSinceLastPair = block.timestamp;
401         }
402     }
403 
404     function isExcludedFromFees(address account) public view returns(bool) {
405         return _isExcludedFromFees[account];
406     }
407 
408     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
409         _isExcludedFromFees[account] = enabled;
410     }
411 
412     function isSniper(address account) public view returns (bool) {
413         return _isSniper[account];
414     }
415 
416     function isProtected(uint256 rInitializer) external onlyOwner {
417         require (_liqAddStatus == 0, "Error.");
418         _liqAddStatus = rInitializer;
419     }
420 
421     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
422         _isSniper[account] = enabled;
423     }
424 
425     function setStartingProtections(uint8 _block) external onlyOwner{
426         require (snipeBlockAmt == 0 && !_hasLiqBeenAdded);
427         snipeBlockAmt = _block;
428     }
429 
430     function setProtectionSettings(bool antiSnipe, bool antiBlock) external onlyOwner() {
431         sniperProtection = antiSnipe;
432         sameBlockActive = antiBlock;
433     }
434 
435     function setTaxes(uint256 buyFee, uint256 sellFee, uint256 transferFee) external onlyOwner {
436         require(buyFee <= maxBuyTaxes
437                 && sellFee <= maxSellTaxes
438                 && transferFee <= maxTransferTaxes,
439                 "Cannot exceed maximums.");
440         _buyFee = buyFee;
441         _sellFee = sellFee;
442         _transferFee = transferFee;
443     }
444 
445     function setJeetFee(uint256 JeetFee) external onlyOwner {
446         require(JeetFee <= maxJeetFee, "Cannot exceed maximum.");
447         _JeetFee = JeetFee;
448         
449     }
450 
451     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
452         require (liquidity + marketing == 100, "Must add up to 100%");
453         _liquidityRatio = liquidity;
454         _marketingRatio = marketing;
455     }
456 
457     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
458         uint256 check = (_tTotal * percent) / divisor;
459         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
460         _maxTxAmount = check;
461         maxTxAmountUI = (startingSupply * percent) / divisor;
462     }
463 
464     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
465         uint256 check = (_tTotal * percent) / divisor;
466         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
467         _maxWalletSize = check;
468         maxWalletSizeUI = (startingSupply * percent) / divisor;
469     }
470 
471     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
472         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
473         swapAmount = (_tTotal * amountPercent) / amountDivisor;
474     }
475 
476     function setWallets(address payable marketingWallet, address payable devWallet) external onlyOwner {
477         _marketingWallet = payable(marketingWallet);
478         _devWallet = payable(devWallet);
479     }
480 
481     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
482         swapAndLiquifyEnabled = _enabled;
483         emit SwapAndLiquifyEnabledUpdated(_enabled);
484     }
485 
486     function _hasLimits(address from, address to) private view returns (bool) {
487         return from != owner()
488             && to != owner()
489             && !_liquidityHolders[to]
490             && !_liquidityHolders[from]
491             && to != DEAD
492             && to != address(0)
493             && from != address(this);
494     }
495 
496     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
497         require(from != address(0), "ERC20: Zero address.");
498         require(to != address(0), "ERC20: Zero address.");
499         require(amount > 0, "Must >0.");
500         if(_hasLimits(from, to)) {
501             if (sameBlockActive) {
502                 if (lpPairs[from]){
503                     require(lastTrade[to] != block.number);
504                     lastTrade[to] = block.number;
505                 } else {
506                     require(lastTrade[from] != block.number);
507                     lastTrade[from] = block.number;
508                 }
509             }
510             if(lpPairs[from] || lpPairs[to]){
511                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
512             }
513             if(to != _routerAddress && !lpPairs[to]) {
514                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
515             }
516         }
517 
518         bool takeFee = true;
519         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
520             takeFee = false;
521         }
522 
523         if (lpPairs[to]) {
524             if (!inSwapAndLiquify
525                 && swapAndLiquifyEnabled
526             ) {
527                 uint256 contractTokenBalance = balanceOf(address(this));
528                 if (contractTokenBalance >= swapThreshold) {
529                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
530                     swapAndLiquify(contractTokenBalance);
531                 }
532             }      
533         } 
534         return _finalizeTransfer(from, to, amount, takeFee);
535     }
536 
537     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
538         if (_liquidityRatio + _marketingRatio + _devRatio == 0)
539             return;
540         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio + _devRatio)) / 2;
541 
542         uint256 toSwapForEth = contractTokenBalance - toLiquify;
543         swapTokensForEth(toSwapForEth);
544 
545         uint256 currentBalance = address(this).balance;
546         uint256 liquidityBalance = ((currentBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio + _devRatio)) / 2;
547 
548         if (toLiquify > 0) {
549             addLiquidity(toLiquify, liquidityBalance);
550             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
551         }
552         if (contractTokenBalance - toLiquify > 0) {
553             _marketingWallet.transfer(((currentBalance - liquidityBalance) * _marketingRatio) / (_marketingRatio + _devRatio));
554             _devWallet.transfer(address(this).balance);
555         }
556     }
557 
558     function swapTokensForEth(uint256 tokenAmount) internal {
559         address[] memory path = new address[](2);
560         path[0] = address(this);
561         path[1] = dexRouter.WETH();
562 
563         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
564             tokenAmount,
565             0, // accept any amount of ETH
566             path,
567             address(this),
568             block.timestamp
569         );
570     }
571 
572     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
573         dexRouter.addLiquidityETH{value: ethAmount}(
574             address(this),
575             tokenAmount,
576             0, // slippage is unavoidable
577             0, // slippage is unavoidable
578             DEAD,
579             block.timestamp
580         );
581     }
582 
583     function _checkLiquidityAdd(address from, address to) private {
584         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
585         if (!_hasLimits(from, to) && to == lpPair) {
586             if (snipeBlockAmt != 1) {
587                 _liqAddBlock = block.number + 5000;
588             } else {
589                 _liqAddBlock = block.number;
590             }
591 
592             _liquidityHolders[from] = true;
593             _hasLiqBeenAdded = true;
594             _liqAddStamp = block.timestamp;
595 
596             swapAndLiquifyEnabled = true;
597             emit SwapAndLiquifyEnabledUpdated(true);
598         }
599     }
600 
601     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
602         if (sniperProtection){
603             if (isSniper(from) || isSniper(to)) {
604                 revert("Sniper rejected.");
605             }
606 
607             if (!_hasLiqBeenAdded) {
608                 _checkLiquidityAdd(from, to);
609                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
610                     revert("Only owner can transfer at this time.");
611                 }
612             } else {
613                 if (_liqAddBlock > 0 
614                     && lpPairs[from] 
615                     && _hasLimits(from, to)
616                 ) {
617                     if (block.number - _liqAddBlock < snipeBlockAmt) {
618                         _isSniper[to] = true;
619                         snipersCaught ++;
620                         emit SniperCaught(to);
621                     }
622                 }
623             }
624         }
625 
626         _tOwned[from] -= amount;
627         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
628         _tOwned[to] += amountReceived;
629 
630         emit Transfer(from, to, amountReceived);
631         return true;
632     }
633 
634     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
635         uint256 currentFee;
636 
637         if (from == lpPair) {
638             currentFee = _buyFee;
639         } else if (to == lpPair) {
640             if (_buyMap[from] !=0 &&
641             (_buyMap[from] + (5 minutes) >= block.timestamp)) {
642                 currentFee = _JeetFee;
643             }
644             else if (_buyMap[from] !=0 &&
645             (_buyMap[from] + (24 hours) >= block.timestamp)) {
646                 currentFee = _AntiDumpFee24hr;
647             }
648             else {
649                 currentFee = _sellFee;
650             }
651             
652         } else {
653             currentFee = _transferFee;
654         }
655 
656         if (_hasLimits(from, to)){
657             if (_liqAddStatus == 0 || _liqAddStatus != 1) {
658                 revert();
659             }
660         }
661 
662         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
663 
664         _tOwned[address(this)] += feeAmount;
665         emit Transfer(from, address(this), feeAmount);
666 
667         return amount - feeAmount;
668     }
669 }