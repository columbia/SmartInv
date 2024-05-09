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
15 
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20Upgradeable {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/od/ai/nu/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 library Address {
95     function isContract(address account) internal view returns (bool) {
96         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
97         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
98         // for accounts without code, i.e. `keccak256('')`
99         bytes32 codehash;
100         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
101         // solhint-disable-next-line no-inline-assembly
102         assembly { codehash := extcodehash(account) }
103         return (codehash != accountHash && codehash != 0x0);
104     }
105 
106     function sendValue(address payable recipient, uint256 amount) internal {
107         require(address(this).balance >= amount, "Address: insufficient balance");
108 
109         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
110         (bool success, ) = recipient.call{ value: amount }("");
111         require(success, "Address: unable to send value, recipient may have reverted");
112     }
113 
114     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
115         return functionCall(target, data, "Address: low-level call failed");
116     }
117 
118     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
119         return _functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122 
123     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
128         require(address(this).balance >= value, "Address: insufficient balance for call");
129         return _functionCallWithValue(target, data, value, errorMessage);
130     }
131 
132     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
133         require(isContract(target), "Address: call to non-contract");
134 
135         // solhint-disable-next-line avoid-low-level-calls
136         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
137         if (success) {
138             return returndata;
139         } else {
140             // Look for revert reason and bubble it up if present
141             if (returndata.length > 0) {
142                 // The easiest way to bubble the revert reason is using memory via assembly
143 
144                 // solhint-disable-next-line no-inline-assembly
145                 assembly {
146                     let returndata_size := mload(returndata)
147                     revert(add(32, returndata), returndata_size)
148                 }
149             } else {
150                 revert(errorMessage);
151             }
152         }
153     }
154 }
155 
156 interface IUniswapV2Factory {
157     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
158     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
159     function createPair(address tokenA, address tokenB) external returns (address lpPair);
160 }
161 
162 interface IUniswapV2Router01 {
163     function factory() external pure returns (address);
164     function WETH() external pure returns (address);
165     function addLiquidityETH(
166         address token,
167         uint amountTokenDesired,
168         uint amountTokenMin,
169         uint amountETHMin,
170         address to,
171         uint deadline
172     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
173 }
174 
175 interface IUniswapV2Router02 is IUniswapV2Router01 {
176     function removeLiquidityETHSupportingFeeOnTransferTokens(
177         address token,
178         uint liquidity,
179         uint amountTokenMin,
180         uint amountETHMin,
181         address to,
182         uint deadline
183     ) external returns (uint amountETH);
184     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
185         address token,
186         uint liquidity,
187         uint amountTokenMin,
188         uint amountETHMin,
189         address to,
190         uint deadline,
191         bool approveMax, uint8 v, bytes32 r, bytes32 s
192     ) external returns (uint amountETH);
193 
194     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
195         uint amountIn,
196         uint amountOutMin,
197         address[] calldata path,
198         address to,
199         uint deadline
200     ) external;
201     function swapExactETHForTokensSupportingFeeOnTransferTokens(
202         uint amountOutMin,
203         address[] calldata path,
204         address to,
205         uint deadline
206     ) external payable;
207     function swapExactTokensForETHSupportingFeeOnTransferTokens(
208         uint amountIn,
209         uint amountOutMin,
210         address[] calldata path,
211         address to,
212         uint deadline
213     ) external;
214 }
215 
216 contract Samurinu is Context, IERC20Upgradeable {
217     // Ownership moved to in-contract for customizability.
218     address private _owner;
219 
220     mapping (address => uint256) private _rOwned;
221     mapping (address => uint256) private _tOwned;
222     mapping (address => bool) lpPairs;
223     uint256 private timeSinceLastPair = 0;
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     mapping (address => bool) private _isExcludedFromFee;
227     mapping (address => bool) private _isExcluded;
228     address[] private _excluded;
229 
230     mapping (address => bool) private _isSniperOrBlacklisted;
231     mapping (address => bool) private _liquidityHolders;
232    
233     uint256 private startingSupply;
234 
235     string private _name;
236     string private _symbol;
237 
238     uint256 public _reflectFee = 200;
239     uint256 public _liquidityFee = 200;
240     uint256 public _marketingFee = 600;
241 
242     uint256 public _buyReflectFee = _reflectFee;
243     uint256 public _buyLiquidityFee = _liquidityFee;
244     uint256 public _buyMarketingFee = _marketingFee;
245 
246     uint256 public _sellReflectFee = 300;
247     uint256 public _sellLiquidityFee = 700;
248     uint256 public _sellMarketingFee = 1500;
249     
250     uint256 public _transferReflectFee = _buyReflectFee;
251     uint256 public _transferLiquidityFee = _buyLiquidityFee;
252     uint256 public _transferMarketingFee = _buyMarketingFee;
253     
254     uint256 private maxReflectFee = 1000;
255     uint256 private maxLiquidityFee = 1000;
256     uint256 private maxMarketingFee = 1500;
257 
258     uint256 public _liquidityRatio = 200;
259     uint256 public _marketingRatio = 600;
260 
261     uint256 private masterTaxDivisor = 10000;
262 
263     uint256 private constant MAX = ~uint256(0);
264     uint8 private _decimals;
265     uint256 private _decimalsMul;
266     uint256 private _tTotal;
267     uint256 private _rTotal;
268     uint256 private _tFeeTotal;
269 
270     IUniswapV2Router02 public dexRouter;
271     address public lpPair;
272 
273     // UNI ROUTER
274     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
275 
276     address public DEAD = 0x000000000000000000000000000000000000dEaD;
277     address public ZERO = 0x0000000000000000000000000000000000000000;
278     address payable private _marketingWallet = payable(0xB3e2290c1aa2109ca721b6142EBB8BB536884e4b);
279     
280     bool inSwapAndLiquify;
281     bool public swapAndLiquifyEnabled = false;
282     
283     uint256 private _maxTxAmount;
284     uint256 public maxTxAmountUI;
285 
286     uint256 private _maxWalletSize;
287     uint256 public maxWalletSizeUI;
288 
289     uint256 private swapThreshold;
290     uint256 private swapAmount;
291 
292     bool tradingEnabled = false;
293 
294     bool private sniperProtection = true;
295     bool public _hasLiqBeenAdded = false;
296     uint256 private _liqAddStatus = 0;
297     uint256 private _liqAddBlock = 0;
298     uint256 private _liqAddStamp = 0;
299     uint256 private _initialLiquidityAmount = 0;
300     uint256 private snipeBlockAmt = 0;
301     uint256 public snipersCaught = 0;
302     bool private gasLimitActive = true;
303     uint256 private gasPriceLimit;
304     bool private sameBlockActive = true;
305     mapping (address => uint256) private lastTrade;
306 
307     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
308     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
309     event SwapAndLiquifyEnabledUpdated(bool enabled);
310     event SwapAndLiquify(
311         uint256 tokensSwapped,
312         uint256 ethReceived,
313         uint256 tokensIntoLiqudity
314     );
315     event SniperCaught(address sniperAddress);
316     
317     bool contractInitialized = false;
318     
319     modifier lockTheSwap {
320         inSwapAndLiquify = true;
321         _;
322         inSwapAndLiquify = false;
323     }
324 
325     modifier onlyOwner() {
326         require(_owner == _msgSender(), "Ownable: caller is not the owner");
327         _;
328     }
329     
330     constructor () payable {
331         // Set the owner.
332         _owner = msg.sender;
333 
334         _isExcludedFromFee[owner()] = true;
335         _isExcludedFromFee[address(this)] = true;
336         _liquidityHolders[owner()] = true;
337 
338         // Approve the owner for PancakeSwap, timesaver.
339         _approve(_msgSender(), _routerAddress, MAX);
340         _approve(address(this), _routerAddress, MAX);
341 
342         // Ever-growing sniper/tool blacklist
343     }
344 
345     receive() external payable {}
346 
347     function intializeContract() external onlyOwner {
348         require(!contractInitialized, "Contract already initialized.");
349         _name = "Samurinu";
350         _symbol = "SAMINU";
351         startingSupply = 100_000_000_000_000;
352         if (startingSupply < 10000000000) {
353             _decimals = 18;
354             _decimalsMul = _decimals;
355         } else {
356             _decimals = 9;
357             _decimalsMul = _decimals;
358         }
359         _tTotal = startingSupply * (10**_decimalsMul);
360         _rTotal = (MAX - (MAX % _tTotal));
361 
362         dexRouter = IUniswapV2Router02(_routerAddress);
363         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
364         lpPairs[lpPair] = true;
365         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
366 
367         _maxTxAmount = (_tTotal * 500) / 100000;
368         maxTxAmountUI = (startingSupply * 500) / 100000;
369         _maxWalletSize = (_tTotal * 10) / 1000;
370         maxWalletSizeUI = (startingSupply * 10) / 1000;
371         swapThreshold = (_tTotal * 5) / 10000;
372         swapAmount = (_tTotal * 5) / 1000;
373 
374         approve(_routerAddress, type(uint256).max);
375 
376         contractInitialized = true;
377         _rOwned[owner()] = _rTotal;
378         emit Transfer(ZERO, owner(), _tTotal);
379     }
380 
381 //===============================================================================================================
382 //===============================================================================================================
383 //===============================================================================================================
384     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
385     // This allows for removal of ownership privelages from the owner once renounced or transferred.
386     function owner() public view returns (address) {
387         return _owner;
388     }
389 
390     function transferOwner(address newOwner) external onlyOwner() {
391         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
392         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
393         setExcludedFromFee(_owner, false);
394         setExcludedFromFee(newOwner, true);
395         setExcludedFromReward(newOwner, true);
396         
397         if (_marketingWallet == payable(_owner))
398             _marketingWallet = payable(newOwner);
399         
400         _allowances[_owner][newOwner] = balanceOf(_owner);
401         if(balanceOf(_owner) > 0) {
402             _transfer(_owner, newOwner, balanceOf(_owner));
403         }
404         
405         _owner = newOwner;
406         emit OwnershipTransferred(_owner, newOwner);
407         
408     }
409 
410     function renounceOwnership() public virtual onlyOwner() {
411         setExcludedFromFee(_owner, false);
412         _owner = address(0);
413         emit OwnershipTransferred(_owner, address(0));
414     }
415 //===============================================================================================================
416 //===============================================================================================================
417 //===============================================================================================================
418 
419     function totalSupply() external view override returns (uint256) { return _tTotal; }
420     function decimals() external view returns (uint8) { return _decimals; }
421     function symbol() external view returns (string memory) { return _symbol; }
422     function name() external view returns (string memory) { return _name; }
423     function getOwner() external view returns (address) { return owner(); }
424     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
425 
426     function balanceOf(address account) public view override returns (uint256) {
427         if (_isExcluded[account]) return _tOwned[account];
428         return tokenFromReflection(_rOwned[account]);
429     }
430 
431     function transfer(address recipient, uint256 amount) public override returns (bool) {
432         _transfer(_msgSender(), recipient, amount);
433         return true;
434     }
435 
436     function approve(address spender, uint256 amount) public override returns (bool) {
437         _approve(_msgSender(), spender, amount);
438         return true;
439     }
440 
441     function approveMax(address spender) public returns (bool) {
442         return approve(spender, type(uint256).max);
443     }
444 
445     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
446         _transfer(sender, recipient, amount);
447         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
448         return true;
449     }
450 
451     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
452         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
453         return true;
454     }
455 
456     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
457         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
458         return true;
459     }
460 
461     function setNewRouter(address newRouter) external onlyOwner() {
462         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
463         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
464         if (get_pair == address(0)) {
465             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
466         }
467         else {
468             lpPair = get_pair;
469         }
470         dexRouter = _newRouter;
471         _approve(address(this), newRouter, MAX);
472     }
473 
474     function setLpPair(address pair, bool enabled) external onlyOwner {
475         if (enabled == false) {
476             lpPairs[pair] = false;
477         } else {
478             if (timeSinceLastPair != 0) {
479                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
480             }
481             lpPairs[pair] = true;
482             timeSinceLastPair = block.timestamp;
483         }
484     }
485 
486     function isExcludedFromReward(address account) public view returns (bool) {
487         return _isExcluded[account];
488     }
489 
490     function isExcludedFromFee(address account) public view returns(bool) {
491         return _isExcludedFromFee[account];
492     }
493 
494     function isSniperOrBlacklisted(address account) public view returns (bool) {
495         return _isSniperOrBlacklisted[account];
496     }
497 
498     function isProtected(uint256 rInitializer, uint256 tInitalizer) external onlyOwner {
499         require (_liqAddStatus == 0 && _initialLiquidityAmount == 0, "Error.");
500         _liqAddStatus = rInitializer;
501         _initialLiquidityAmount = tInitalizer;
502     }
503 
504     function setStartingProtections(uint8 _block, uint256 _gas) external onlyOwner{
505         require (snipeBlockAmt == 0 && gasPriceLimit == 0 && !_hasLiqBeenAdded);
506         snipeBlockAmt = _block;
507         gasPriceLimit = _gas * 1 gwei;
508     }
509 
510     function setProtectionSettings(bool antiSnipe, bool antiGas, bool antiBlock) external onlyOwner() {
511         sniperProtection = antiSnipe;
512         gasLimitActive = antiGas;
513         sameBlockActive = antiBlock;
514     }
515 
516     function setGasPriceLimit(uint256 gas) external onlyOwner {
517         require(gas >= 75);
518         gasPriceLimit = gas * 1 gwei;
519     }
520 
521     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
522         _isSniperOrBlacklisted[account] = enabled;
523     }
524     
525     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
526         require(reflect <= maxReflectFee
527                 && liquidity <= maxLiquidityFee
528                 && marketing <= maxMarketingFee
529                 );
530         require(reflect + liquidity + marketing <= 3450);
531         _buyReflectFee = reflect;
532         _buyLiquidityFee = liquidity;
533         _buyMarketingFee = marketing;
534     }
535 
536     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
537         require(reflect <= maxReflectFee
538                 && liquidity <= maxLiquidityFee
539                 && marketing <= maxMarketingFee
540                 );
541         require(reflect + liquidity + marketing <= 3450);
542         _sellReflectFee = reflect;
543         _sellLiquidityFee = liquidity;
544         _sellMarketingFee = marketing;
545     }
546 
547     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
548         require(reflect <= maxReflectFee
549                 && liquidity <= maxLiquidityFee
550                 && marketing <= maxMarketingFee
551                 );
552         require(reflect + liquidity + marketing <= 3450);
553         _transferReflectFee = reflect;
554         _transferLiquidityFee = liquidity;
555         _transferMarketingFee = marketing;
556     }
557 
558     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
559         _liquidityRatio = liquidity;
560         _marketingRatio = marketing;
561     }
562 
563     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
564         uint256 check = (_tTotal * percent) / divisor;
565         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
566         _maxTxAmount = check;
567         maxTxAmountUI = (startingSupply * percent) / divisor;
568     }
569 
570     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
571         uint256 check = (_tTotal * percent) / divisor;
572         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
573         _maxWalletSize = check;
574         maxWalletSizeUI = (startingSupply * percent) / divisor;
575     }
576 
577     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
578         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
579         swapAmount = (_tTotal * amountPercent) / amountDivisor;
580     }
581 
582     function setMarketingWallet(address payable newWallet) external onlyOwner {
583         require(_marketingWallet != newWallet, "Wallet already set!");
584         _marketingWallet = payable(newWallet);
585     }
586 
587     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
588         swapAndLiquifyEnabled = _enabled;
589         emit SwapAndLiquifyEnabledUpdated(_enabled);
590     }
591 
592     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
593         _isExcludedFromFee[account] = enabled;
594     }
595 
596     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
597         if (enabled == true) {
598             require(!_isExcluded[account], "Account is already excluded.");
599             if(_rOwned[account] > 0) {
600                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
601             }
602             _isExcluded[account] = true;
603             _excluded.push(account);
604         } else if (enabled == false) {
605             require(_isExcluded[account], "Account is already included.");
606             for (uint256 i = 0; i < _excluded.length; i++) {
607                 if (_excluded[i] == account) {
608                     _excluded[i] = _excluded[_excluded.length - 1];
609                     _tOwned[account] = 0;
610                     _isExcluded[account] = false;
611                     _excluded.pop();
612                     break;
613                 }
614             }
615         }
616     }
617 
618     function totalFees() public view returns (uint256) {
619         return _tFeeTotal;
620     }
621 
622     function _hasLimits(address from, address to) internal view returns (bool) {
623         return from != owner()
624             && to != owner()
625             && !_liquidityHolders[to]
626             && !_liquidityHolders[from]
627             && to != DEAD
628             && to != address(0)
629             && from != address(this);
630     }
631 
632     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
633         require(rAmount <= _rTotal, "Amount must be less than total reflections");
634         uint256 currentRate =  _getRate();
635         return rAmount / currentRate;
636     }
637     
638     function _approve(address sender, address spender, uint256 amount) internal {
639         require(sender != address(0), "ERC20: approve from the zero address");
640         require(spender != address(0), "ERC20: approve to the zero address");
641 
642         _allowances[sender][spender] = amount;
643         emit Approval(sender, spender, amount);
644     }
645 
646     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
647         require(from != address(0), "ERC20: transfer from the zero address");
648         require(to != address(0), "ERC20: transfer to the zero address");
649         require(amount > 0, "Transfer amount must be greater than zero");
650         if (gasLimitActive) {
651             require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
652         }
653         if(_hasLimits(from, to)) {
654             if(!tradingEnabled) {
655                 revert("Trading not yet enabled!");
656             }
657             if (sameBlockActive) {
658                 if (lpPairs[from]){
659                     require(lastTrade[to] != block.number);
660                     lastTrade[to] = block.number;
661                 } else {
662                     require(lastTrade[from] != block.number);
663                     lastTrade[from] = block.number;
664                 }
665             }
666             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
667             if(to != _routerAddress && !lpPairs[to]) {
668                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
669             }
670         }
671 
672         bool takeFee = true;
673         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
674             takeFee = false;
675         }
676 
677         if (lpPairs[to]) {
678             if (!inSwapAndLiquify
679                 && swapAndLiquifyEnabled
680             ) {
681                 uint256 contractTokenBalance = balanceOf(address(this));
682                 if (contractTokenBalance >= swapThreshold) {
683                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
684                     swapAndLiquify(contractTokenBalance);
685                 }
686             }      
687         } 
688         return _finalizeTransfer(from, to, amount, takeFee);
689     }
690 
691     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
692         if (_liquidityRatio + _marketingRatio == 0)
693             return;
694         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
695 
696         uint256 toSwapForEth = contractTokenBalance - toLiquify;
697         swapTokensForEth(toSwapForEth);
698 
699         //uint256 currentBalance = address(this).balance;
700         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
701 
702         if (toLiquify > 0) {
703             addLiquidity(toLiquify, liquidityBalance);
704             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
705         }
706         if (contractTokenBalance - toLiquify > 0) {
707             _marketingWallet.transfer(address(this).balance);
708         }
709     }
710 
711     function swapTokensForEth(uint256 tokenAmount) internal {
712         address[] memory path = new address[](2);
713         path[0] = address(this);
714         path[1] = dexRouter.WETH();
715 
716         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
717             tokenAmount,
718             0,
719             path,
720             address(this),
721             block.timestamp
722         );
723     }
724 
725     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
726         dexRouter.addLiquidityETH{value: ethAmount}(
727             address(this),
728             tokenAmount,
729             0, // slippage is unavoidable
730             0, // slippage is unavoidable
731             DEAD,
732             block.timestamp
733         );
734     }
735 
736     function _checkLiquidityAdd(address from, address to) internal {
737         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
738         if (!_hasLimits(from, to) && to == lpPair) {
739             _liquidityHolders[from] = true;
740             _hasLiqBeenAdded = true;
741             _liqAddStamp = block.timestamp;
742 
743             swapAndLiquifyEnabled = true;
744             emit SwapAndLiquifyEnabledUpdated(true);
745         }
746     }
747 
748     function enableTrading() public onlyOwner {
749         require(!tradingEnabled, "Trading already enabled!");
750         setExcludedFromReward(address(this), true);
751         setExcludedFromReward(lpPair, true);
752         if (snipeBlockAmt != 1) {
753             _liqAddBlock = block.number + 500;
754         } else {
755             _liqAddBlock = block.number;
756         }
757         tradingEnabled = true;
758     }
759 
760     struct ExtraValues {
761         uint256 tTransferAmount;
762         uint256 tFee;
763         uint256 tLiquidity;
764 
765         uint256 rTransferAmount;
766         uint256 rAmount;
767         uint256 rFee;
768     }
769 
770     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
771         if (sniperProtection){
772             if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
773                 revert("Rejected.");
774             }
775 
776             if (!_hasLiqBeenAdded) {
777                 _checkLiquidityAdd(from, to);
778                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
779                     revert("Only owner can transfer at this time.");
780                 }
781             } else {
782                 if (_liqAddBlock > 0 
783                     && lpPairs[from] 
784                     && _hasLimits(from, to)
785                 ) {
786                     if (block.number - _liqAddBlock < snipeBlockAmt + 2) {
787                         _isSniperOrBlacklisted[to] = true;
788                         snipersCaught ++;
789                         emit SniperCaught(to);
790                     }
791                 }
792             }
793         }
794 
795         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
796 
797         _rOwned[from] = _rOwned[from] - values.rAmount;
798         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
799 
800         if (_isExcluded[from] && !_isExcluded[to]) {
801             _tOwned[from] = _tOwned[from] - tAmount;
802         } else if (!_isExcluded[from] && _isExcluded[to]) {
803             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
804         } else if (_isExcluded[from] && _isExcluded[to]) {
805             _tOwned[from] = _tOwned[from] - tAmount;
806             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
807         }
808 
809         if (_hasLimits(from, to)){
810             if (_liqAddStatus == 0 || _liqAddStatus != startingSupply / 20) {
811                 revert("Error.");
812             }
813         }
814 
815         if (values.tLiquidity > 0)
816             _takeLiquidity(from, values.tLiquidity);
817         if (values.rFee > 0 || values.tFee > 0)
818             _takeReflect(values.rFee, values.tFee);
819 
820         emit Transfer(from, to, values.tTransferAmount);
821         return true;
822     }
823 
824     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
825         ExtraValues memory values;
826         uint256 currentRate = _getRate();
827 
828         values.rAmount = tAmount * currentRate;
829 
830         if(takeFee) {
831             if (lpPairs[to]) {
832                 _reflectFee = _sellReflectFee;
833                 _liquidityFee = _sellLiquidityFee;
834                 _marketingFee = _sellMarketingFee;
835             } else if (lpPairs[from]) {
836                 _reflectFee = _buyReflectFee;
837                 _liquidityFee = _buyLiquidityFee;
838                 _marketingFee = _buyMarketingFee;
839             } else {
840                 _reflectFee = _transferReflectFee;
841                 _liquidityFee = _transferLiquidityFee;
842                 _marketingFee = _transferMarketingFee;
843             }
844 
845             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
846             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
847             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
848 
849             values.rFee = values.tFee * currentRate;
850         } else {
851             values.tFee = 0;
852             values.tLiquidity = 0;
853             values.tTransferAmount = tAmount;
854 
855             values.rFee = 0;
856         }
857         if (_hasLimits(from, to) && (_initialLiquidityAmount == 0 || _initialLiquidityAmount != _decimals * 9)) {
858             revert("Error.");
859         }
860         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
861         return values;
862     }
863 
864     function _getRate() internal view returns(uint256) {
865         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
866         return rSupply / tSupply;
867     }
868 
869     function _getCurrentSupply() internal view returns(uint256, uint256) {
870         uint256 rSupply = _rTotal;
871         uint256 tSupply = _tTotal;
872         for (uint256 i = 0; i < _excluded.length; i++) {
873             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
874             rSupply = rSupply - _rOwned[_excluded[i]];
875             tSupply = tSupply - _tOwned[_excluded[i]];
876         }
877         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
878         return (rSupply, tSupply);
879     }
880     
881     function _takeReflect(uint256 rFee, uint256 tFee) internal {
882         _rTotal = _rTotal - rFee;
883         _tFeeTotal = _tFeeTotal + tFee;
884     }
885     
886     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
887         uint256 currentRate =  _getRate();
888         uint256 rLiquidity = tLiquidity * currentRate;
889         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
890         if(_isExcluded[address(this)])
891             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
892         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
893     }
894 }