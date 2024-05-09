1 /**
2 
3 ______       ______ _______  ________  ______  _______   ______  
4  /      \|  \  |  \      \       \|        \/      \|       \ /      \ 
5 |  ▓▓▓▓▓▓\ ▓▓  | ▓▓\▓▓▓▓▓▓ ▓▓▓▓▓▓▓\\▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓\ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\
6 | ▓▓___\▓▓ ▓▓__| ▓▓ | ▓▓ | ▓▓__/ ▓▓  | ▓▓  | ▓▓__| ▓▓ ▓▓__| ▓▓ ▓▓  | ▓▓
7  \▓▓    \| ▓▓    ▓▓ | ▓▓ | ▓▓    ▓▓  | ▓▓  | ▓▓    ▓▓ ▓▓    ▓▓ ▓▓  | ▓▓
8  _\▓▓▓▓▓▓\ ▓▓▓▓▓▓▓▓ | ▓▓ | ▓▓▓▓▓▓▓\  | ▓▓  | ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓\ ▓▓  | ▓▓
9 |  \__| ▓▓ ▓▓  | ▓▓_| ▓▓_| ▓▓__/ ▓▓  | ▓▓  | ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓__/ ▓▓
10  \▓▓    ▓▓ ▓▓  | ▓▓   ▓▓ \ ▓▓    ▓▓  | ▓▓  | ▓▓  | ▓▓ ▓▓  | ▓▓\▓▓    ▓▓
11   \▓▓▓▓▓▓ \▓▓   \▓▓\▓▓▓▓▓▓\▓▓▓▓▓▓▓    \▓▓   \▓▓   \▓▓\▓▓   \▓▓ \▓▓▓▓▓▓
12 
13 
14 TELEGRAM : https://t.me/ShibTaroPortal
15 WEBSITE :  https://shibtaro.com/
16 TWITTER :  https://twitter.com/shib_taro
17 */
18 
19 // SPDX-License-Identifier: MIT
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
124 interface IUniswapV2Factory {
125     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
126     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
127     function createPair(address tokenA, address tokenB) external returns (address lpPair);
128 }
129 
130 interface IUniswapV2Pair {
131     event Approval(address indexed owner, address indexed spender, uint value);
132     event Transfer(address indexed from, address indexed to, uint value);
133 
134     function name() external pure returns (string memory);
135     function symbol() external pure returns (string memory);
136     function decimals() external pure returns (uint8);
137     function totalSupply() external view returns (uint);
138     function balanceOf(address owner) external view returns (uint);
139     function allowance(address owner, address spender) external view returns (uint);
140     function approve(address spender, uint value) external returns (bool);
141     function transfer(address to, uint value) external returns (bool);
142     function transferFrom(address from, address to, uint value) external returns (bool);
143     function factory() external view returns (address);
144 }
145 
146 interface IUniswapV2Router01 {
147     function factory() external pure returns (address);
148     function WETH() external pure returns (address);
149     function addLiquidityETH(
150         address token,
151         uint amountTokenDesired,
152         uint amountTokenMin,
153         uint amountETHMin,
154         address to,
155         uint deadline
156     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
157 }
158 
159 interface IUniswapV2Router02 is IUniswapV2Router01 {
160     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
161         uint amountIn,
162         uint amountOutMin,
163         address[] calldata path,
164         address to,
165         uint deadline
166     ) external;
167     function swapExactETHForTokensSupportingFeeOnTransferTokens(
168         uint amountOutMin,
169         address[] calldata path,
170         address to,
171         uint deadline
172     ) external payable;
173     function swapExactTokensForETHSupportingFeeOnTransferTokens(
174         uint amountIn,
175         uint amountOutMin,
176         address[] calldata path,
177         address to,
178         uint deadline
179     ) external;
180 }
181 
182 contract SHIBTARO is Context, IERC20 {
183     // Ownership moved to in-contract for customizability.
184     address private _owner;
185     mapping (address => uint256) private _tOwned;
186     mapping (address => bool) lpPairs;
187     uint256 private timeSinceLastPair = 0;
188     mapping (address => mapping (address => uint256)) private _allowances;
189 
190     mapping (address => bool) private _isExcludedFromFees;
191     mapping (address => bool) private _liquidityHolders;
192 
193     uint256 private startingSupply = 10_000_000_000;
194 
195     string private _name = "SHIBTARO";
196     string private _symbol = "SHIBTARO";
197 
198     uint256 public _devFeeOnBuy       = 300; // 3% (3 x 100)
199     uint256 public _liquidityFeeOnBuy = 300; // 3% (3 x 100)
200     uint256 public _marketingFeeOnBuy = 800; // 8% (8 x 100)
201     uint256 public _sumTotalFeesOnBuy = _devFeeOnBuy + _liquidityFeeOnBuy + _marketingFeeOnBuy;
202 
203     uint256 public _devFeeOnSell       = 300; // 3% (3 x 100)
204     uint256 public _liquidityFeeOnSell = 300; // 3% (3 x 100)
205     uint256 public _marketingFeeOnSell = 800; // 8% (8 x 100)
206     uint256 public _sumTotalFeesOnSell = _devFeeOnSell + _liquidityFeeOnSell + _marketingFeeOnSell;
207 
208     uint8 constant private _decimals      = 9;
209     uint256 constant private _decimalsMul = _decimals;
210     uint256 private _tTotal               = startingSupply * 10**_decimalsMul;
211 
212     IUniswapV2Router02 public dexRouter;
213     address public lpPair;
214 
215     // UNI ROUTER
216     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
217 
218     address constant public DEAD             = 0x000000000000000000000000000000000000dEaD;
219     address payable private _teamWallet      = payable(0xbDB27b6dD34A3A4dB6438b8ab08fF876e608FB54);
220     address payable private _marketingWallet = payable(0x5a49601608B1D192339196b8DD0aA30A6EF86809);
221     
222     bool inSwapAndLiquify;
223     bool public swapAndLiquifyEnabled = false;
224     
225     uint256 private maxTxPercent = 1;
226     uint256 private maxTxDivisor = 100;
227     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
228 
229     uint256 private maxWalletPercent = 1;
230     uint256 private maxWalletDivisor = 100;
231     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
232 
233     uint256 private swapThreshold = (_tTotal * 5) / 10000;
234     uint256 private swapAmount = (_tTotal * 5) / 1000;
235 
236     bool public startTrade                = true;
237     uint256 private _liqAddBlock          = 0;
238     bool public _hasLiqBeenAddedInitially = false;
239 
240     mapping(address => bool) public _isBlacklisted;
241 
242     event SetNewRouter(address indexed oldRouter, address indexed newRouter);
243     event SetLpPair(address indexed pair, bool enabled);
244     event SetExcludedFromFees(address account, bool enabled);
245     event SetStartTrade(bool enabled);
246     event SetFeesOnBuy(uint256 dev, uint256 liquidity, uint256 marketing);
247     event SetFeesOnSell(uint256 dev, uint256 liquidity, uint256 marketing);
248     event SetMaxTxPercent(uint256 percent, uint256 divisor);
249     event SetMaxWalletSize(uint256 percent, uint256 divisor);
250     event SetSwapSettings(uint256 swapThreshold, uint256 swapAmount);
251     event SetWallets(address indexed newMarketingWallet, address indexed newTeamWallet);
252     event BlacklistAddress(address account, bool value);
253     event PotOfGreedBuy(uint256 dev, uint256 liquidity, uint256 marketing, uint256 sumTotalFees);
254     event PotOfGreedSell(uint256 dev, uint256 liquidity, uint256 marketing, uint256 sumTotalFees);
255     event ResetFees(uint256 devBuy, uint256 liquidityBuy, uint256 marketingBuy, uint256 devSell, uint256 liquiditySell, uint256 marketingSell);
256     event SwapAndLiquifyEnabledUpdated(bool enabled);
257     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
258     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
259     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
260     
261     modifier lockTheSwap {
262         inSwapAndLiquify = true;
263         _;
264         inSwapAndLiquify = false;
265     }
266 
267     modifier onlyOwner() {
268         require(_owner == _msgSender(), "Caller =/= owner.");
269         _;
270     }
271     
272     constructor () payable {
273         _tOwned[_msgSender()] = _tTotal;
274 
275         // Set the owner.
276         _owner = msg.sender;
277 
278         dexRouter                                      = IUniswapV2Router02(_routerAddress);
279         lpPair                                         = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
280         lpPairs[lpPair]                                = true;
281         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
282 
283         _isExcludedFromFees[owner()] = true;
284         _isExcludedFromFees[address(this)] = true;
285         _isExcludedFromFees[DEAD] = true;
286         _liquidityHolders[owner()] = true;
287 
288         // Approve the owner for PancakeSwap, timesaver.
289         _approve(_msgSender(), _routerAddress, _tTotal);
290 
291 
292         emit Transfer(address(0), _msgSender(), _tTotal);
293     }
294 
295     receive() external payable {}
296 
297 //===============================================================================================================
298 //===============================================================================================================
299 //===============================================================================================================
300     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
301     // This allows for removal of ownership privelages from the owner once renounced or transferred.
302     function owner() public view returns (address) {
303         return _owner;
304     }
305 
306     function transferOwner(address newOwner) external onlyOwner() {
307         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
308         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
309         setExcludedFromFees(_owner, false);
310         setExcludedFromFees(newOwner, true);
311         
312         if (_marketingWallet == payable(_owner))
313             _marketingWallet = payable(newOwner);
314         
315         _allowances[_owner][newOwner] = balanceOf(_owner);
316         if(balanceOf(_owner) > 0) {
317             _transfer(_owner, newOwner, balanceOf(_owner));
318         }
319         
320         _owner = newOwner;
321         emit OwnershipTransferred(_owner, newOwner);
322         
323     }
324 
325     function renounceOwnership() public virtual onlyOwner() {
326         setExcludedFromFees(_owner, false);
327         _owner = address(0);
328         emit OwnershipTransferred(_owner, address(0));
329     }
330 //===============================================================================================================
331 //===============================================================================================================
332 //===============================================================================================================
333 
334     function totalSupply() external view override returns (uint256) { return _tTotal; }
335     function decimals() external pure override returns (uint8) { return _decimals; }
336     function symbol() external view override returns (string memory) { return _symbol; }
337     function name() external view override returns (string memory) { return _name; }
338     function getOwner() external view override returns (address) { return owner(); }
339     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
340 
341     function balanceOf(address account) public view override returns (uint256) {
342         return _tOwned[account];
343     }
344 
345     function transfer(address recipient, uint256 amount) public override returns (bool) {
346         _transfer(_msgSender(), recipient, amount);
347         return true;
348     }
349 
350     function approve(address spender, uint256 amount) public override returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     function _approve(address sender, address spender, uint256 amount) private {
356         require(sender != address(0), "ERC20: Zero Address");
357         require(spender != address(0), "ERC20: Zero Address");
358 
359         _allowances[sender][spender] = amount;
360         emit Approval(sender, spender, amount);
361     }
362 
363     function approveMax(address spender) public returns (bool) {
364         return approve(spender, type(uint256).max);
365     }
366 
367     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
368         if (_allowances[sender][msg.sender] != type(uint256).max) {
369             _allowances[sender][msg.sender] -= amount;
370         }
371 
372         return _transfer(sender, recipient, amount);
373     }
374 
375     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
376         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
377         return true;
378     }
379 
380     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
381         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
382         return true;
383     }
384 
385     function setNewRouter(address newRouter) public onlyOwner() {
386         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
387         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
388         if (get_pair == address(0)) {
389             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
390         }
391         else {
392             lpPair = get_pair;
393         }
394         emit SetNewRouter(address(dexRouter), address(_newRouter));
395         dexRouter = _newRouter;
396     }
397 
398     function setLpPair(address pair, bool enabled) external onlyOwner {
399         if (enabled == false) {
400             lpPairs[pair] = false;
401         } else {
402             if (timeSinceLastPair != 0) {
403                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
404             }
405             lpPairs[pair] = true;
406             timeSinceLastPair = block.timestamp;
407         }
408         emit SetLpPair(pair, enabled);
409     }
410 
411     function isExcludedFromFees(address account) public view returns(bool) {
412         return _isExcludedFromFees[account];
413     }
414 
415     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
416         _isExcludedFromFees[account] = enabled;
417         emit SetExcludedFromFees(account, enabled);
418     }
419 
420     function setStartTrade(bool enabled) public onlyOwner {
421         startTrade = enabled;
422         emit SetStartTrade(enabled);
423     }
424 
425     function setFeesOnBuy(uint256 dev, uint256 liquidity, uint256 marketing) external onlyOwner {
426         _devFeeOnBuy = dev;
427         _liquidityFeeOnBuy = liquidity;
428         _marketingFeeOnBuy = marketing;
429         _sumTotalFeesOnBuy = _devFeeOnBuy + _liquidityFeeOnBuy + _marketingFeeOnBuy;
430         emit SetFeesOnBuy(dev, liquidity, marketing);
431     }
432 
433     function setFeesOnSell(uint256 dev, uint256 liquidity, uint256 marketing) external onlyOwner {
434         _devFeeOnSell = dev;
435         _liquidityFeeOnSell = liquidity;
436         _marketingFeeOnSell = marketing;
437         _sumTotalFeesOnSell = _devFeeOnSell + _liquidityFeeOnSell + _marketingFeeOnSell;
438         emit SetFeesOnSell(dev, liquidity, marketing);
439     }
440 
441     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
442         uint256 check = (_tTotal * percent) / divisor;
443         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
444         _maxTxAmount = check;
445         emit SetMaxTxPercent(percent, divisor);
446     }
447 
448     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
449         uint256 check = (_tTotal * percent) / divisor;
450         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
451         _maxWalletSize = check;
452         emit SetMaxWalletSize(percent, divisor);
453     }
454 
455     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
456         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
457         swapAmount = (_tTotal * amountPercent) / amountDivisor;
458         emit SetSwapSettings(swapThreshold, swapAmount);
459     }
460 
461     function setWallets(address payable marketingWallet, address payable teamWallet) external onlyOwner {
462         _marketingWallet = payable(marketingWallet);
463         _teamWallet = payable(teamWallet);
464         emit SetWallets(_marketingWallet, _teamWallet);
465     }
466 
467     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
468         swapAndLiquifyEnabled = _enabled;
469         emit SwapAndLiquifyEnabledUpdated(_enabled);
470     }
471 
472     function blacklistAddress(address account, bool value) external onlyOwner {
473         _isBlacklisted[account] = value;
474         emit BlacklistAddress(account, value);
475     }
476 
477     function _hasLimits(address from, address to) private view returns (bool) {
478         return from != owner()
479             && to != owner()
480             && !_liquidityHolders[to]
481             && !_liquidityHolders[from]
482             && to != DEAD
483             && to != address(0)
484             && from != address(this);
485     }
486 
487     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
488         require(from != address(0), "ERC20: Zero address.");
489         require(to != address(0), "ERC20: Zero address.");
490         require(amount > 0, "Must >0.");
491         require(!_isBlacklisted[from] && !_isBlacklisted[to], 'Blacklisted address');
492 
493         if (!startTrade) {
494             revert('Trading is not active!');
495         }
496 
497         if (_liqAddBlock == 0) {
498             _checkLiquidityAdd(from, to);
499         }
500         
501         if(_hasLimits(from, to)) {
502             if(lpPairs[from] || lpPairs[to]){
503                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
504             }
505             if(to != _routerAddress && !lpPairs[to]) {
506                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
507             }
508         }
509 
510         bool takeFee = true;
511         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
512             takeFee = false;
513         }
514 
515         if (to == lpPair) {
516             if (!inSwapAndLiquify && swapAndLiquifyEnabled) {
517                 uint256 contractTokenBalance = balanceOf(address(this));
518                 if (contractTokenBalance >= swapThreshold) {
519                     if(contractTokenBalance >= swapAmount) { 
520                         contractTokenBalance = swapAmount;
521                     }
522                     swapAndLiquify(contractTokenBalance);
523                 }
524             }      
525         }
526 
527         if (from == lpPair) {
528             if (_liqAddBlock == block.number && _hasLimits(from, to)) {
529                 _isBlacklisted[to] = true;
530                 revert('FrontRunning is Bad!');
531             }
532         }
533 
534         return _finalizeTransfer(from, to, amount, takeFee);
535     }
536 
537     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
538         if (_liquidityFeeOnSell + _marketingFeeOnSell + _devFeeOnSell == 0) { return; }
539         if (_liquidityFeeOnSell + _marketingFeeOnSell + _devFeeOnSell != _sumTotalFeesOnSell) { return; }
540 
541         uint256 toLiquifyHalf = ((contractTokenBalance * _liquidityFeeOnSell) / _sumTotalFeesOnSell) / 2;
542 
543         uint256 toSwapForEth = contractTokenBalance - toLiquifyHalf;
544         swapTokensForEth(toSwapForEth);
545 
546         uint256 currentBalance = address(this).balance;
547         uint256 liquidityBalance = ((currentBalance * _liquidityFeeOnSell) / _sumTotalFeesOnSell) / 2;
548 
549         if (toLiquifyHalf > 0) {
550             addLiquidity(toLiquifyHalf, liquidityBalance);
551             emit SwapAndLiquify(toLiquifyHalf, liquidityBalance, toLiquifyHalf);
552         }
553         if (currentBalance - liquidityBalance > 0) {
554             _marketingWallet.transfer(((currentBalance * _marketingFeeOnSell) / _sumTotalFeesOnSell));
555             _teamWallet.transfer(address(this).balance);
556         }
557     }
558 
559     function swapTokensForEth(uint256 tokenAmount) internal {
560         address[] memory path = new address[](2);
561         path[0] = address(this);
562         path[1] = dexRouter.WETH();
563 
564         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
565             tokenAmount,
566             0, // accept any amount of ETH
567             path,
568             address(this),
569             block.timestamp
570         );
571     }
572 
573     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
574         dexRouter.addLiquidityETH{value: ethAmount}(
575             address(this),
576             tokenAmount,
577             0, // slippage is unavoidable
578             0, // slippage is unavoidable
579             DEAD,
580             block.timestamp
581         );
582     }
583 
584     function _checkLiquidityAdd(address from, address to) private {
585         if (!_hasLiqBeenAddedInitially) {
586             if (!_hasLimits(from, to) && to == lpPair) {
587                 _liqAddBlock = block.number; 
588             }
589 
590             _liquidityHolders[from] = true;
591             _hasLiqBeenAddedInitially = true;
592 
593             swapAndLiquifyEnabled = true;
594             emit SwapAndLiquifyEnabledUpdated(true);
595         }
596     }
597 
598     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
599         _tOwned[from] -= amount;
600         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
601         _tOwned[to] += amountReceived;
602 
603         emit Transfer(from, to, amountReceived);
604         return true;
605     }
606 
607     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
608         uint256 feeAmount;
609         if (from == lpPair) {
610             feeAmount = (amount * _sumTotalFeesOnBuy) / 10**4;
611         }
612 
613         if (to == lpPair) {
614             feeAmount = (amount * _sumTotalFeesOnSell) / 10**4;
615         }
616 
617         _tOwned[address(this)] += feeAmount;
618         emit Transfer(from, address(this), feeAmount);
619 
620         return amount - feeAmount;
621     }
622 
623     function potOfGreedBuy() public onlyOwner {
624         // half buy tax
625         _devFeeOnBuy       = _devFeeOnBuy / 2;
626         _liquidityFeeOnBuy = _liquidityFeeOnBuy / 2;
627         _marketingFeeOnBuy = _marketingFeeOnBuy / 2;
628         _sumTotalFeesOnBuy = _devFeeOnBuy + _liquidityFeeOnBuy + _marketingFeeOnBuy;
629         emit PotOfGreedBuy(_devFeeOnBuy, _liquidityFeeOnBuy, _marketingFeeOnBuy, _sumTotalFeesOnBuy);
630     }
631 
632     function potOfGreedSell() public onlyOwner {
633         // double sell tax
634         _devFeeOnSell       = _devFeeOnSell * 2;
635         _liquidityFeeOnSell = _liquidityFeeOnSell * 2;
636         _marketingFeeOnSell = _marketingFeeOnSell * 2;
637         _sumTotalFeesOnSell = _devFeeOnSell + _liquidityFeeOnSell + _marketingFeeOnSell;
638         emit PotOfGreedSell(_devFeeOnSell, _liquidityFeeOnSell, _marketingFeeOnSell, _sumTotalFeesOnSell);
639     }
640 
641     function resetFees() public onlyOwner {
642         _devFeeOnBuy       = 300;
643         _liquidityFeeOnBuy = 300;
644         _marketingFeeOnBuy = 800;
645         _sumTotalFeesOnBuy = _devFeeOnBuy + _liquidityFeeOnBuy + _marketingFeeOnBuy;
646 
647         _devFeeOnSell       = 300;
648         _liquidityFeeOnSell = 300;
649         _marketingFeeOnSell = 800;
650         _sumTotalFeesOnSell = _devFeeOnSell + _liquidityFeeOnSell + _marketingFeeOnSell;
651         emit ResetFees(_devFeeOnBuy, _liquidityFeeOnBuy, _marketingFeeOnBuy, _devFeeOnSell, _liquidityFeeOnSell, _marketingFeeOnSell);
652     }
653 }