1 // SPDX-License-Identifier: MIT
2 
3 /*
4 A journey of 10,000x begins with the first step
5 
6 TELEGRAM : https://t.me/ShibSensei
7 WEBSITE :  http://www.shibsensei.com
8 TWITTER :  http://www.twitter.com/ShibSenseiETH
9 */
10 
11 pragma solidity 0.8.7;
12 
13 abstract contract Context {
14     function _msgSender() internal view returns (address payable) {
15         return payable(msg.sender);
16     }
17 
18     function _msgData() internal view returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25   /**
26    * @dev Returns the amount of tokens in existence.
27    */
28   function totalSupply() external view returns (uint256);
29 
30   /**
31    * @dev Returns the token decimals.
32    */
33   function decimals() external view returns (uint8);
34 
35   /**
36    * @dev Returns the token symbol.
37    */
38   function symbol() external view returns (string memory);
39 
40   /**
41   * @dev Returns the token name.
42   */
43   function name() external view returns (string memory);
44 
45   /**
46    * @dev Returns the bep token owner.
47    */
48   function getOwner() external view returns (address);
49 
50   /**
51    * @dev Returns the amount of tokens owned by `account`.
52    */
53   function balanceOf(address account) external view returns (uint256);
54 
55   /**
56    * @dev Moves `amount` tokens from the caller's account to `recipient`.
57    *
58    * Returns a boolean value indicating whether the operation succeeded.
59    *
60    * Emits a {Transfer} event.
61    */
62   function transfer(address recipient, uint256 amount) external returns (bool);
63 
64   /**
65    * @dev Returns the remaining number of tokens that `spender` will be
66    * allowed to spend on behalf of `owner` through {transferFrom}. This is
67    * zero by default.
68    *
69    * This value changes when {approve} or {transferFrom} are called.
70    */
71   function allowance(address _owner, address spender) external view returns (uint256);
72 
73   /**
74    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75    *
76    * Returns a boolean value indicating whether the operation succeeded.
77    *
78    * IMPORTANT: Beware that changing an allowance with this method brings the risk
79    * that someone may use both the old and the new allowance by unfortunate
80    * transaction ordering. One possible solution to mitigate this race
81    * condition is to first reduce the spender's allowance to 0 and set the
82    * desired value afterwards:
83    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84    *
85    * Emits an {Approval} event.
86    */
87   function approve(address spender, uint256 amount) external returns (bool);
88 
89   /**
90    * @dev Moves `amount` tokens from `sender` to `recipient` using the
91    * allowance mechanism. `amount` is then deducted from the caller's
92    * allowance.
93    *
94    * Returns a boolean value indicating whether the operation succeeded.
95    *
96    * Emits a {Transfer} event.
97    */
98   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100   /**
101    * @dev Emitted when `value` tokens are moved from one account (`from`) to
102    * another (`to`).
103    *
104    * Note that `value` may be zero.
105    */
106   event Transfer(address indexed from, address indexed to, uint256 value);
107 
108   /**
109    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110    * a call to {approve}. `value` is the new allowance.
111    */
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 interface IUniswapV2Factory {
116     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
117     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
118     function createPair(address tokenA, address tokenB) external returns (address lpPair);
119 }
120 
121 interface IUniswapV2Pair {
122     event Approval(address indexed owner, address indexed spender, uint value);
123     event Transfer(address indexed from, address indexed to, uint value);
124 
125     function name() external pure returns (string memory);
126     function symbol() external pure returns (string memory);
127     function decimals() external pure returns (uint8);
128     function totalSupply() external view returns (uint);
129     function balanceOf(address owner) external view returns (uint);
130     function allowance(address owner, address spender) external view returns (uint);
131     function approve(address spender, uint value) external returns (bool);
132     function transfer(address to, uint value) external returns (bool);
133     function transferFrom(address from, address to, uint value) external returns (bool);
134     function factory() external view returns (address);
135 }
136 
137 interface IUniswapV2Router01 {
138     function factory() external pure returns (address);
139     function WETH() external pure returns (address);
140     function addLiquidityETH(
141         address token,
142         uint amountTokenDesired,
143         uint amountTokenMin,
144         uint amountETHMin,
145         address to,
146         uint deadline
147     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
148 }
149 
150 interface IUniswapV2Router02 is IUniswapV2Router01 {
151     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external;
158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external payable;
164     function swapExactTokensForETHSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171 }
172 
173 contract SHIBSENSEI is Context, IERC20 {
174     // Ownership moved to in-contract for customizability.
175     address private _owner;
176     mapping (address => uint256) private _tOwned;
177     mapping (address => bool) lpPairs;
178     uint256 private timeSinceLastPair = 0;
179     mapping (address => mapping (address => uint256)) private _allowances;
180 
181     mapping (address => bool) private _isExcludedFromFees;
182     mapping (address => bool) private _isSniperOrBlacklisted;
183     mapping (address => bool) private _liquidityHolders;
184     
185     mapping (address => uint256) buyLog;
186     uint256 buyCoolDown = 30 seconds;
187 
188     uint256 private startingSupply = 100_000_000;
189 
190     string private _name = "SHIBSENSEI";
191     string private _symbol = "SHIBZEN";
192 
193     uint256 public _buyFee = 1200;
194     uint256 public _sellFee = 1200;
195     uint256 public _transferFee = 1200;
196 
197     uint256 constant public maxBuyTaxes = 1500;
198     uint256 constant public maxSellTaxes = 2500;
199     uint256 constant public maxTransferTaxes = 2500;
200 
201     uint256 public _liquidityRatio = 20;
202     uint256 public _marketingRatio = 50;
203     uint256 public _devRatio = 30;
204 
205     uint256 private constant masterTaxDivisor = 10_000;
206 
207     uint256 private constant MAX = ~uint256(0);
208     uint8 constant private _decimals = 9;
209     uint256 private _tTotal = startingSupply * 10**_decimals;
210     uint256 private _tFeeTotal;
211 
212     IUniswapV2Router02 public dexRouter;
213     address public lpPair;
214 
215     // UNI ROUTER
216     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
217 
218     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
219     address payable private _marketingWallet = payable(0x897396dD7891e5d58f4352eCC0753DA695C8FDc6);
220     address payable private _teamWallet = payable(0x897396dD7891e5d58f4352eCC0753DA695C8FDc6);
221     
222     bool inSwapAndLiquify;
223     bool public swapAndLiquifyEnabled = false;
224     
225     uint256 private maxTxPercent = 2;
226     uint256 private maxTxDivisor = 100;
227     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor; // 2%
228 
229     uint256 private maxWalletPercent = 2;
230     uint256 private maxWalletDivisor = 100;
231     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor; // 2%
232 
233     uint256 private swapThreshold = (_tTotal * 5) / 10_000; // 0.05%
234     uint256 private swapAmount = (_tTotal * 5) / 1_000; // 0.5%
235 
236     bool private sniperProtection = true;
237     bool public _hasLiqBeenAdded = false;
238     uint256 private _liqAddStatus = 0;
239     uint256 private _liqAddBlock = 0;
240     uint256 private _liqAddStamp = 0;
241     uint256 private _initialLiquidityAmount = 0;
242     uint256 private snipeBlockAmt = 0;
243     uint256 public snipersCaught = 0;
244     bool private sameBlockActive = true;
245     mapping (address => uint256) private lastTrade;
246 
247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
249     event SwapAndLiquifyEnabledUpdated(bool enabled);
250     event SwapAndLiquify(
251         uint256 tokensSwapped,
252         uint256 ethReceived,
253         uint256 tokensIntoLiqudity
254     );
255     event SniperCaught(address sniperAddress);
256     
257     modifier lockTheSwap {
258         inSwapAndLiquify = true;
259         _;
260         inSwapAndLiquify = false;
261     }
262 
263     modifier onlyOwner() {
264         require(_owner == _msgSender(), "Caller =/= owner.");
265         _;
266     }
267     
268     constructor () payable {
269         _tOwned[_msgSender()] = _tTotal;
270 
271         // Set the owner.
272         _owner = msg.sender;
273 
274         dexRouter = IUniswapV2Router02(_routerAddress);
275         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
276         lpPairs[lpPair] = true;
277         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
278 
279         _isExcludedFromFees[owner()] = true;
280         _isExcludedFromFees[address(this)] = true;
281         _isExcludedFromFees[DEAD] = true;
282         _liquidityHolders[owner()] = true;
283 
284         // Approve the owner for UniSwap, timesaver.
285         _approve(_msgSender(), _routerAddress, _tTotal);
286 
287         // Transfer tTotal to the _msgSender.
288         emit Transfer(address(0), _msgSender(), _tTotal);
289     }
290 
291     receive() external payable {}
292 
293 //===============================================================================================================
294 //===============================================================================================================
295 //===============================================================================================================
296     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
297     // This allows for removal of ownership privelages from the owner once renounced or transferred.
298     function owner() public view returns (address) {
299         return _owner;
300     }
301 
302     function transferOwner(address newOwner) external onlyOwner() {
303         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
304         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
305         setExcludedFromFees(_owner, false);
306         setExcludedFromFees(newOwner, true);
307         
308         if (_marketingWallet == payable(_owner))
309             _marketingWallet = payable(newOwner);
310         
311         _allowances[_owner][newOwner] = balanceOf(_owner);
312         if(balanceOf(_owner) > 0) {
313             _transfer(_owner, newOwner, balanceOf(_owner));
314         }
315         
316         _owner = newOwner;
317         emit OwnershipTransferred(_owner, newOwner);
318         
319     }
320 
321     function renounceOwnership() public virtual onlyOwner() {
322         setExcludedFromFees(_owner, false);
323         _owner = address(0);
324         emit OwnershipTransferred(_owner, address(0));
325     }
326 //===============================================================================================================
327 //===============================================================================================================
328 //===============================================================================================================
329 
330     function totalSupply() external view override returns (uint256) { return _tTotal; }
331     function decimals() external pure override returns (uint8) { return _decimals; }
332     function symbol() external view override returns (string memory) { return _symbol; }
333     function name() external view override returns (string memory) { return _name; }
334     function getOwner() external view override returns (address) { return owner(); }
335     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
336 
337     function balanceOf(address account) public view override returns (uint256) {
338         return _tOwned[account];
339     }
340 
341     function transfer(address recipient, uint256 amount) public override returns (bool) {
342         _transfer(_msgSender(), recipient, amount);
343         return true;
344     }
345 
346     function approve(address spender, uint256 amount) public override returns (bool) {
347         _approve(_msgSender(), spender, amount);
348         return true;
349     }
350 
351     function _approve(address sender, address spender, uint256 amount) private {
352         require(sender != address(0), "ERC20: Zero Address");
353         require(spender != address(0), "ERC20: Zero Address");
354 
355         _allowances[sender][spender] = amount;
356         emit Approval(sender, spender, amount);
357     }
358 
359     function approveMax(address spender) public returns (bool) {
360         return approve(spender, type(uint256).max);
361     }
362 
363     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
364         if (_allowances[sender][msg.sender] != type(uint256).max) {
365             _allowances[sender][msg.sender] -= amount;
366         }
367 
368         return _transfer(sender, recipient, amount);
369     }
370 
371     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
372         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
373         return true;
374     }
375 
376     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
377         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
378         return true;
379     }
380 
381     function setNewRouter(address newRouter) public onlyOwner() {
382         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
383         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
384         if (get_pair == address(0)) {
385             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
386         }
387         else {
388             lpPair = get_pair;
389         }
390         dexRouter = _newRouter;
391     }
392 
393     function setLpPair(address pair, bool enabled) external onlyOwner {
394         if (enabled == false) {
395             lpPairs[pair] = false;
396         } else {
397             if (timeSinceLastPair != 0) {
398                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
399             }
400             lpPairs[pair] = true;
401             timeSinceLastPair = block.timestamp;
402         }
403     }
404 
405     function isExcludedFromFees(address account) public view returns(bool) {
406         return _isExcludedFromFees[account];
407     }
408 
409     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
410         _isExcludedFromFees[account] = enabled;
411     }
412 
413     function isSniperOrBlacklisted(address account) public view returns (bool) {
414         return _isSniperOrBlacklisted[account];
415     }
416 
417     function setBuyCoolDownTime(uint256 Seconds) public onlyOwner{
418         uint256 timeInSeconds = Seconds * 1 seconds;
419         buyCoolDown = timeInSeconds;
420     }
421 
422     function isProtected(uint256 rInitializer) external onlyOwner {
423         require (_liqAddStatus == 0, "Error.");
424         _liqAddStatus = rInitializer;
425     }
426 
427     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
428         _isSniperOrBlacklisted[account] = enabled;
429     }
430 
431     function setStartingProtections(uint8 _block) external onlyOwner{
432         require (snipeBlockAmt == 0 && !_hasLiqBeenAdded, "Starting Protections have already been executed.");
433         snipeBlockAmt = _block;
434     }
435 
436     function setProtectionSettings(bool antiSnipe, bool antiBlock) external onlyOwner() {
437         sniperProtection = antiSnipe;
438         sameBlockActive = antiBlock;
439     }
440 
441     function setTaxes(uint256 buyFee, uint256 sellFee, uint256 transferFee) external onlyOwner {
442         require(buyFee <= maxBuyTaxes
443                 && sellFee <= maxSellTaxes
444                 && transferFee <= maxTransferTaxes,
445                 "Cannot exceed maximums.");
446         _buyFee = buyFee;
447         _sellFee = sellFee;
448         _transferFee = transferFee;
449     }
450 
451     function setRatios(uint256 liquidity, uint256 marketing, uint256 dev) external onlyOwner {
452         require (liquidity + marketing + dev == 100, "Must add up to 100%");
453         _liquidityRatio = liquidity;
454         _marketingRatio = marketing;
455         _devRatio = dev;
456     }
457 
458     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
459         uint256 check = (_tTotal * percent) / divisor;
460         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
461         _maxTxAmount = check;
462     }
463 
464     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
465         uint256 check = (_tTotal * percent) / divisor;
466         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
467         _maxWalletSize = check;
468     }
469 
470     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
471         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
472         swapAmount = (_tTotal * amountPercent) / amountDivisor;
473     }
474 
475     function setWallets(address payable marketingWallet, address payable teamWallet) external onlyOwner {
476         _marketingWallet = payable(marketingWallet);
477         _teamWallet = payable(teamWallet);
478     }
479 
480     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
481         swapAndLiquifyEnabled = _enabled;
482         emit SwapAndLiquifyEnabledUpdated(_enabled);
483     }
484 
485     function _hasLimits(address from, address to) private view returns (bool) {
486         return from != owner()
487             && to != owner()
488             && !_liquidityHolders[to]
489             && !_liquidityHolders[from]
490             && to != DEAD
491             && to != address(0)
492             && from != address(this);
493     }
494 
495     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
496         require(from != address(0), "ERC20: Zero address.");
497         require(to != address(0), "ERC20: Zero address.");
498         require(amount > 0, "Must >0.");
499         if(_hasLimits(from, to)) {
500             if (sameBlockActive) {
501                 if (lpPairs[from]){
502                     require(lastTrade[to] != block.number);
503                     lastTrade[to] = block.number;
504                 } else {
505                     require(lastTrade[from] != block.number);
506                     lastTrade[from] = block.number;
507                 }
508             }
509             if(lpPairs[from] || lpPairs[to]){
510                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
511             }
512             if(to != _routerAddress && !lpPairs[to]) {
513                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
514             }
515         }
516 
517         bool takeFee = true;
518         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
519             takeFee = false;
520         }
521 
522         if (lpPairs[to]) {
523             if (!inSwapAndLiquify
524                 && swapAndLiquifyEnabled
525             ) {
526                 uint256 contractTokenBalance = balanceOf(address(this));
527                 if (contractTokenBalance >= swapThreshold) {
528                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
529                     swapAndLiquify(contractTokenBalance);
530                 }
531             }      
532         } 
533         return _finalizeTransfer(from, to, amount, takeFee);
534     }
535 
536     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
537         if (_liquidityRatio + _marketingRatio + _devRatio == 0)
538             return;
539         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio + _devRatio)) / 2;
540 
541         uint256 toSwapForEth = contractTokenBalance - toLiquify;
542         swapTokensForEth(toSwapForEth);
543 
544         uint256 currentBalance = address(this).balance;
545         uint256 liquidityBalance = ((currentBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio + _devRatio)) / 2;
546 
547         if (toLiquify > 0) {
548             addLiquidity(toLiquify, liquidityBalance);
549             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
550         }
551         if (contractTokenBalance - toLiquify > 0) {
552             _marketingWallet.transfer(((currentBalance - liquidityBalance) * _marketingRatio) / (_marketingRatio + _devRatio));
553             _teamWallet.transfer(address(this).balance);
554         }
555     }
556 
557     function swapTokensForEth(uint256 tokenAmount) internal {
558         address[] memory path = new address[](2);
559         path[0] = address(this);
560         path[1] = dexRouter.WETH();
561 
562         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
563             tokenAmount,
564             0, // accept any amount of ETH
565             path,
566             address(this),
567             block.timestamp
568         );
569     }
570 
571     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
572         dexRouter.addLiquidityETH{value: ethAmount}(
573             address(this),
574             tokenAmount,
575             0, // slippage is unavoidable
576             0, // slippage is unavoidable
577             DEAD,
578             block.timestamp
579         );
580     }
581 
582     function _checkLiquidityAdd(address from, address to) private {
583         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
584         if (!_hasLimits(from, to) && to == lpPair) {
585             if (snipeBlockAmt != 2) {
586                 _liqAddBlock = block.number + 5000;
587             } else {
588                 _liqAddBlock = block.number;
589             }
590 
591             _liquidityHolders[from] = true;
592             _hasLiqBeenAdded = true;
593             _liqAddStamp = block.timestamp;
594 
595             swapAndLiquifyEnabled = true;
596             emit SwapAndLiquifyEnabledUpdated(true);
597         }
598     }
599 
600     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
601         if (sniperProtection){
602             if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
603                 revert("Sniper rejected.");
604             }
605 
606             if (!_hasLiqBeenAdded) {
607                 _checkLiquidityAdd(from, to);
608                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
609                     revert("Only owner can transfer at this time.");
610                 }
611             } else {
612                 if (_liqAddBlock > 0 
613                     && lpPairs[from] 
614                     && _hasLimits(from, to)
615                 ) {
616                     if (block.number - _liqAddBlock < snipeBlockAmt) {
617                         _isSniperOrBlacklisted[to] = true;
618                         snipersCaught ++;
619                         emit SniperCaught(to);
620                     }
621                 }
622             }
623         }
624 
625         _tOwned[from] -= amount;
626         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
627         _tOwned[to] += amountReceived;
628 
629         emit Transfer(from, to, amountReceived);
630         return true;
631     }
632 
633     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
634         uint256 currentFee;
635         if (from == lpPair) {
636             if (balanceOf(to) > 0){
637                 require(block.timestamp - buyLog[to] >= buyCoolDown, "Buy cooldown");
638             }
639 
640             buyLog[to] = block.timestamp;
641             currentFee = _buyFee;
642 
643         } else if (to == lpPair) {
644             currentFee = _sellFee;
645         } else {
646             currentFee = _transferFee;
647         }
648 
649         if (_hasLimits(from, to)){
650             if (_liqAddStatus == 0 || _liqAddStatus != startingSupply/10) {
651                 revert();
652             }
653         }
654 
655         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
656 
657         _tOwned[address(this)] += feeAmount;
658         emit Transfer(from, address(this), feeAmount);
659 
660         return amount - feeAmount;
661     }
662 }