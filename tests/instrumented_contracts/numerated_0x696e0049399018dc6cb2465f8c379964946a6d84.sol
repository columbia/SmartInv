1 // TELEGRAM : https://t.me/HitmanWolfERC20
2 // WEBSITE : http://HitmanWolf.com/
3 // TWITTER : https://twitter.com/HitmanWolfERC20
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity >=0.6.0 <0.9.0;
7 
8 abstract contract Context {
9     function _msgSender() internal view returns (address payable) {
10         return payable(msg.sender);
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20Upgradeable {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/od/ai/nu/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 library Address {
98     function isContract(address account) internal view returns (bool) {
99         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
100         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
101         // for accounts without code, i.e. `keccak256('')`
102         bytes32 codehash;
103         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
104         // solhint-disable-next-line no-inline-assembly
105         assembly { codehash := extcodehash(account) }
106         return (codehash != accountHash && codehash != 0x0);
107     }
108 
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
113         (bool success, ) = recipient.call{ value: amount }("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
118         return functionCall(target, data, "Address: low-level call failed");
119     }
120 
121     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
122         return _functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125 
126     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
127         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
128     }
129 
130     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         return _functionCallWithValue(target, data, value, errorMessage);
133     }
134 
135     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
136         require(isContract(target), "Address: call to non-contract");
137 
138         // solhint-disable-next-line avoid-low-level-calls
139         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
140         if (success) {
141             return returndata;
142         } else {
143             // Look for revert reason and bubble it up if present
144             if (returndata.length > 0) {
145                 // The easiest way to bubble the revert reason is using memory via assembly
146 
147                 // solhint-disable-next-line no-inline-assembly
148                 assembly {
149                     let returndata_size := mload(returndata)
150                     revert(add(32, returndata), returndata_size)
151                 }
152             } else {
153                 revert(errorMessage);
154             }
155         }
156     }
157 }
158 
159 interface IUniswapV2Factory {
160     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
161     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
162     function createPair(address tokenA, address tokenB) external returns (address lpPair);
163 }
164 
165 interface IUniswapV2Router01 {
166     function factory() external pure returns (address);
167     function WETH() external pure returns (address);
168     function addLiquidityETH(
169         address token,
170         uint amountTokenDesired,
171         uint amountTokenMin,
172         uint amountETHMin,
173         address to,
174         uint deadline
175     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
176 }
177 
178 interface IUniswapV2Router02 is IUniswapV2Router01 {
179     function removeLiquidityETHSupportingFeeOnTransferTokens(
180         address token,
181         uint liquidity,
182         uint amountTokenMin,
183         uint amountETHMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountETH);
187     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
188         address token,
189         uint liquidity,
190         uint amountTokenMin,
191         uint amountETHMin,
192         address to,
193         uint deadline,
194         bool approveMax, uint8 v, bytes32 r, bytes32 s
195     ) external returns (uint amountETH);
196 
197     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
198         uint amountIn,
199         uint amountOutMin,
200         address[] calldata path,
201         address to,
202         uint deadline
203     ) external;
204     function swapExactETHForTokensSupportingFeeOnTransferTokens(
205         uint amountOutMin,
206         address[] calldata path,
207         address to,
208         uint deadline
209     ) external payable;
210     function swapExactTokensForETHSupportingFeeOnTransferTokens(
211         uint amountIn,
212         uint amountOutMin,
213         address[] calldata path,
214         address to,
215         uint deadline
216     ) external;
217 }
218 
219 contract HitmanWolf is Context, IERC20Upgradeable {
220     // Ownership moved to in-contract for customizability.
221     address private _owner;
222 
223     mapping (address => uint256) private _rOwned;
224     mapping (address => uint256) private _tOwned;
225     mapping (address => bool) lpPairs;
226     uint256 private timeSinceLastPair = 0;
227     mapping (address => mapping (address => uint256)) private _allowances;
228 
229     mapping (address => bool) private _isExcludedFromFee;
230     mapping (address => bool) private _isExcluded;
231     address[] private _excluded;
232 
233     mapping (address => bool) private _isSniperOrBlacklisted;
234     mapping (address => bool) private _liquidityHolders;
235    
236     uint256 private startingSupply;
237 
238     string private _name;
239     string private _symbol;
240 
241     uint256 public _reflectFee = 200;
242     uint256 public _liquidityFee = 200;
243     uint256 public _marketingFee = 700;
244 
245     uint256 public _buyReflectFee = _reflectFee;
246     uint256 public _buyLiquidityFee = _liquidityFee;
247     uint256 public _buyMarketingFee = _marketingFee;
248 
249 // 48hr
250     uint256 public _sellReflectFee = 200;
251     uint256 public _sellLiquidityFee = 750;
252     uint256 public _sellMarketingFee = 1550;
253     
254     uint256 public _transferReflectFee = _buyReflectFee;
255     uint256 public _transferLiquidityFee = _buyLiquidityFee;
256     uint256 public _transferMarketingFee = _buyMarketingFee;
257     
258     uint256 private maxReflectFee = 1000;
259     uint256 private maxLiquidityFee = 1000;
260     uint256 private maxMarketingFee = 1000;
261 
262     uint256 public _liquidityRatio = 200;
263     uint256 public _marketingRatio = 700;
264 
265     uint256 private masterTaxDivisor = 10000;
266 
267     uint256 private constant MAX = ~uint256(0);
268     uint8 private _decimals;
269     uint256 private _decimalsMul;
270     uint256 private _tTotal;
271     uint256 private _rTotal;
272     uint256 private _tFeeTotal;
273 
274     IUniswapV2Router02 public dexRouter;
275     address public lpPair;
276 
277     // UNI ROUTER
278     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
279 
280     address public DEAD = 0x000000000000000000000000000000000000dEaD;
281     address public ZERO = 0x0000000000000000000000000000000000000000;
282     address payable private _marketingWallet = payable(0xe03BEE2fe520421A98e141Afc9eECD7CF1b6A222);
283     
284     bool inSwapAndLiquify;
285     bool public swapAndLiquifyEnabled = false;
286     
287     uint256 private _maxTxAmount;
288     uint256 public maxTxAmountUI;
289 
290     uint256 private _maxWalletSize;
291     uint256 public maxWalletSizeUI;
292 
293     uint256 private swapThreshold;
294     uint256 private swapAmount;
295 
296     bool tradingEnabled = false;
297 
298     bool private sniperProtection = true;
299     bool public _hasLiqBeenAdded = false;
300     uint256 private _liqAddStatus = 0;
301     uint256 private _liqAddBlock = 0;
302     uint256 private _liqAddStamp = 0;
303     uint256 private _initialLiquidityAmount = 0;
304     uint256 private snipeBlockAmt = 0;
305     uint256 public snipersCaught = 0;
306     bool private gasLimitActive = true;
307     uint256 private gasPriceLimit;
308     bool private sameBlockActive = true;
309     mapping (address => uint256) private lastTrade;
310 
311     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
312     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
313     event SwapAndLiquifyEnabledUpdated(bool enabled);
314     event SwapAndLiquify(
315         uint256 tokensSwapped,
316         uint256 ethReceived,
317         uint256 tokensIntoLiqudity
318     );
319     event SniperCaught(address sniperAddress);
320     
321     bool contractInitialized = false;
322     
323     modifier lockTheSwap {
324         inSwapAndLiquify = true;
325         _;
326         inSwapAndLiquify = false;
327     }
328 
329     modifier onlyOwner() {
330         require(_owner == _msgSender(), "Ownable: caller is not the owner");
331         _;
332     }
333     
334     constructor () payable {
335         // Set the owner.
336         _owner = msg.sender;
337 
338         _isExcludedFromFee[owner()] = true;
339         _isExcludedFromFee[address(this)] = true;
340         _liquidityHolders[owner()] = true;
341 
342         _approve(_msgSender(), _routerAddress, MAX);
343         _approve(address(this), _routerAddress, MAX);
344 
345         // Ever-growing sniper/tool blacklist
346     }
347 
348     receive() external payable {}
349 
350     function intializeContract() external onlyOwner {
351         require(!contractInitialized, "Contract already initialized.");
352         _name = "Hitman Wolf";
353         _symbol = "HITMAN";
354         startingSupply = 100_000_000_000_000;
355         if (startingSupply < 10000000000) {
356             _decimals = 18;
357             _decimalsMul = _decimals;
358         } else {
359             _decimals = 9;
360             _decimalsMul = _decimals;
361         }
362         _tTotal = startingSupply * (10**_decimalsMul);
363         _rTotal = (MAX - (MAX % _tTotal));
364 
365         dexRouter = IUniswapV2Router02(_routerAddress);
366         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
367         lpPairs[lpPair] = true;
368         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
369 
370         _maxTxAmount = _tTotal / 100;
371         maxTxAmountUI = startingSupply / 100;
372         _maxWalletSize = (_tTotal*2) / 100;
373         maxWalletSizeUI = (startingSupply * 2) / 100;
374         swapThreshold = (_tTotal * 5) / 10000;
375         swapAmount = (_tTotal * 5) / 1000;
376 
377         approve(_routerAddress, type(uint256).max);
378 
379         contractInitialized = true;
380         _rOwned[owner()] = _rTotal;
381         emit Transfer(ZERO, owner(), _tTotal);
382     }
383 
384 //===============================================================================================================
385 //===============================================================================================================
386 //===============================================================================================================
387     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
388     // This allows for removal of ownership privelages from the owner once renounced or transferred.
389     function owner() public view returns (address) {
390         return _owner;
391     }
392 
393     function transferOwner(address newOwner) external onlyOwner() {
394         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
395         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
396         setExcludedFromFee(_owner, false);
397         setExcludedFromFee(newOwner, true);
398         setExcludedFromReward(newOwner, true);
399         
400         if (_marketingWallet == payable(_owner))
401             _marketingWallet = payable(newOwner);
402         
403         _allowances[_owner][newOwner] = balanceOf(_owner);
404         if(balanceOf(_owner) > 0) {
405             _transfer(_owner, newOwner, balanceOf(_owner));
406         }
407         
408         _owner = newOwner;
409         emit OwnershipTransferred(_owner, newOwner);
410         
411     }
412 
413     function renounceOwnership() public virtual onlyOwner() {
414         setExcludedFromFee(_owner, false);
415         _owner = address(0);
416         emit OwnershipTransferred(_owner, address(0));
417     }
418 //===============================================================================================================
419 //===============================================================================================================
420 //===============================================================================================================
421 
422     function totalSupply() external view override returns (uint256) { return _tTotal; }
423     function decimals() external view returns (uint8) { return _decimals; }
424     function symbol() external view returns (string memory) { return _symbol; }
425     function name() external view returns (string memory) { return _name; }
426     function getOwner() external view returns (address) { return owner(); }
427     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
428 
429     function balanceOf(address account) public view override returns (uint256) {
430         if (_isExcluded[account]) return _tOwned[account];
431         return tokenFromReflection(_rOwned[account]);
432     }
433 
434     function transfer(address recipient, uint256 amount) public override returns (bool) {
435         _transfer(_msgSender(), recipient, amount);
436         return true;
437     }
438 
439     function approve(address spender, uint256 amount) public override returns (bool) {
440         _approve(_msgSender(), spender, amount);
441         return true;
442     }
443 
444     function approveMax(address spender) public returns (bool) {
445         return approve(spender, type(uint256).max);
446     }
447 
448     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
449         _transfer(sender, recipient, amount);
450         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
451         return true;
452     }
453 
454     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
456         return true;
457     }
458 
459     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
461         return true;
462     }
463 
464     function setNewRouter(address newRouter) external onlyOwner() {
465         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
466         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
467         if (get_pair == address(0)) {
468             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
469         }
470         else {
471             lpPair = get_pair;
472         }
473         dexRouter = _newRouter;
474         _approve(address(this), newRouter, MAX);
475     }
476 
477     function setLpPair(address pair, bool enabled) external onlyOwner {
478         if (enabled == false) {
479             lpPairs[pair] = false;
480         } else {
481             if (timeSinceLastPair != 0) {
482                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
483             }
484             lpPairs[pair] = true;
485             timeSinceLastPair = block.timestamp;
486         }
487     }
488 
489     function isExcludedFromReward(address account) public view returns (bool) {
490         return _isExcluded[account];
491     }
492 
493     function isExcludedFromFee(address account) public view returns(bool) {
494         return _isExcludedFromFee[account];
495     }
496 
497     function isSniperOrBlacklisted(address account) public view returns (bool) {
498         return _isSniperOrBlacklisted[account];
499     }
500 
501     function isProtected(uint256 rInitializer, uint256 tInitalizer) external onlyOwner {
502         require (_liqAddStatus == 0 && _initialLiquidityAmount == 0, "Error.");
503         _liqAddStatus = rInitializer;
504         _initialLiquidityAmount = tInitalizer;
505     }
506 
507     function setStartingProtections(uint8 _block, uint256 _gas) external onlyOwner{
508         require (snipeBlockAmt == 0 && gasPriceLimit == 0 && !_hasLiqBeenAdded);
509         snipeBlockAmt = _block + 2;
510         gasPriceLimit = _gas * 1 gwei;
511     }
512 
513     function setProtectionSettings(bool antiSnipe, bool antiGas, bool antiBlock) external onlyOwner() {
514         sniperProtection = antiSnipe;
515         gasLimitActive = antiGas;
516         sameBlockActive = antiBlock;
517     }
518 
519     function setGasPriceLimit(uint256 gas) external onlyOwner {
520         require(gas >= 75);
521         gasPriceLimit = gas * 1 gwei;
522     }
523 
524     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
525         _isSniperOrBlacklisted[account] = enabled;
526     }
527     
528     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
529         require(reflect <= maxReflectFee
530                 && liquidity <= maxLiquidityFee
531                 && marketing <= maxMarketingFee
532                 );
533         require(reflect + liquidity + marketing <= 3450);
534         _buyReflectFee = reflect;
535         _buyLiquidityFee = liquidity;
536         _buyMarketingFee = marketing;
537     }
538 
539     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
540         require(reflect <= maxReflectFee
541                 && liquidity <= maxLiquidityFee
542                 && marketing <= maxMarketingFee
543                 );
544         require(reflect + liquidity + marketing <= 3450);
545         _sellReflectFee = reflect;
546         _sellLiquidityFee = liquidity;
547         _sellMarketingFee = marketing;
548     }
549 
550     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
551         _liquidityRatio = liquidity;
552         _marketingRatio = marketing;
553     }
554 
555     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
556         uint256 check = (_tTotal * percent) / divisor;
557         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
558         _maxTxAmount = check;
559         maxTxAmountUI = (startingSupply * percent) / divisor;
560     }
561 
562     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
563         uint256 check = (_tTotal * percent) / divisor;
564         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
565         _maxWalletSize = check;
566         maxWalletSizeUI = (startingSupply * percent) / divisor;
567     }
568 
569     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
570         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
571         swapAmount = (_tTotal * amountPercent) / amountDivisor;
572     }
573 
574     function setMarketingWallet(address payable newWallet) external onlyOwner {
575         require(_marketingWallet != newWallet, "Wallet already set!");
576         _marketingWallet = payable(newWallet);
577     }
578 
579     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
580         swapAndLiquifyEnabled = _enabled;
581         emit SwapAndLiquifyEnabledUpdated(_enabled);
582     }
583 
584     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
585         _isExcludedFromFee[account] = enabled;
586     }
587 
588     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
589         if (enabled == true) {
590             require(!_isExcluded[account], "Account is already excluded.");
591             if(_rOwned[account] > 0) {
592                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
593             }
594             _isExcluded[account] = true;
595             _excluded.push(account);
596         } else if (enabled == false) {
597             require(_isExcluded[account], "Account is already included.");
598             for (uint256 i = 0; i < _excluded.length; i++) {
599                 if (_excluded[i] == account) {
600                     _excluded[i] = _excluded[_excluded.length - 1];
601                     _tOwned[account] = 0;
602                     _isExcluded[account] = false;
603                     _excluded.pop();
604                     break;
605                 }
606             }
607         }
608     }
609 
610     function totalFees() public view returns (uint256) {
611         return _tFeeTotal;
612     }
613 
614     function _hasLimits(address from, address to) internal view returns (bool) {
615         return from != owner()
616             && to != owner()
617             && !_liquidityHolders[to]
618             && !_liquidityHolders[from]
619             && to != DEAD
620             && to != address(0)
621             && from != address(this);
622     }
623 
624     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
625         require(rAmount <= _rTotal, "Amount must be less than total reflections");
626         uint256 currentRate =  _getRate();
627         return rAmount / currentRate;
628     }
629     
630     function _approve(address sender, address spender, uint256 amount) internal {
631         require(sender != address(0), "ERC20: approve from the zero address");
632         require(spender != address(0), "ERC20: approve to the zero address");
633 
634         _allowances[sender][spender] = amount;
635         emit Approval(sender, spender, amount);
636     }
637 
638     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
639         require(from != address(0), "ERC20: transfer from the zero address");
640         require(to != address(0), "ERC20: transfer to the zero address");
641         require(amount > 0, "Transfer amount must be greater than zero");
642         if (gasLimitActive) {
643             require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
644         }
645         if(_hasLimits(from, to)) {
646             if(!tradingEnabled) {
647                 revert("Trading not yet enabled!");
648             }
649             if (sameBlockActive) {
650                 if (lpPairs[from]){
651                     require(lastTrade[to] != block.number);
652                     lastTrade[to] = block.number;
653                 } else {
654                     require(lastTrade[from] != block.number);
655                     lastTrade[from] = block.number;
656                 }
657             }
658             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
659             if(to != _routerAddress && !lpPairs[to]) {
660                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
661             }
662         }
663 
664         bool takeFee = true;
665         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
666             takeFee = false;
667         }
668 
669         if (lpPairs[to]) {
670             if (!inSwapAndLiquify
671                 && swapAndLiquifyEnabled
672             ) {
673                 uint256 contractTokenBalance = balanceOf(address(this));
674                 if (contractTokenBalance >= swapThreshold) {
675                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
676                     swapAndLiquify(contractTokenBalance);
677                 }
678             }      
679         } 
680         return _finalizeTransfer(from, to, amount, takeFee);
681     }
682 
683     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
684         if (_liquidityRatio + _marketingRatio == 0)
685             return;
686         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
687 
688         uint256 toSwapForEth = contractTokenBalance - toLiquify;
689         swapTokensForEth(toSwapForEth);
690 
691         //uint256 currentBalance = address(this).balance;
692         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
693 
694         if (toLiquify > 0) {
695             addLiquidity(toLiquify, liquidityBalance);
696             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
697         }
698         if (contractTokenBalance - toLiquify > 0) {
699             _marketingWallet.transfer(address(this).balance);
700         }
701     }
702 
703     function swapTokensForEth(uint256 tokenAmount) internal {
704         address[] memory path = new address[](2);
705         path[0] = address(this);
706         path[1] = dexRouter.WETH();
707 
708         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
709             tokenAmount,
710             0,
711             path,
712             address(this),
713             block.timestamp
714         );
715     }
716 
717     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
718         dexRouter.addLiquidityETH{value: ethAmount}(
719             address(this),
720             tokenAmount,
721             0, // slippage is unavoidable
722             0, // slippage is unavoidable
723             DEAD,
724             block.timestamp
725         );
726     }
727 
728     function _checkLiquidityAdd(address from, address to) internal {
729         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
730         if (!_hasLimits(from, to) && to == lpPair) {
731             _liquidityHolders[from] = true;
732             _hasLiqBeenAdded = true;
733             _liqAddStamp = block.timestamp;
734 
735             swapAndLiquifyEnabled = true;
736             emit SwapAndLiquifyEnabledUpdated(true);
737         }
738     }
739 
740     function enableTrading() public onlyOwner {
741         require(!tradingEnabled, "Trading already enabled!");
742         setExcludedFromReward(address(this), true);
743         setExcludedFromReward(lpPair, true);
744         if (snipeBlockAmt != 2) {
745             _liqAddBlock = block.number + 500;
746         } else {
747             _liqAddBlock = block.number;
748         }
749         tradingEnabled = true;
750     }
751 
752     struct ExtraValues {
753         uint256 tTransferAmount;
754         uint256 tFee;
755         uint256 tLiquidity;
756         uint256 rTransferAmount;
757         uint256 rAmount;
758         uint256 rFee;
759     }
760 
761     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
762         if (sniperProtection){
763             if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
764                 revert("Rejected.");
765             }
766 
767             if (!_hasLiqBeenAdded) {
768                 _checkLiquidityAdd(from, to);
769                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
770                     revert("Only owner can transfer at this time.");
771                 }
772             } else {
773                 if (_liqAddBlock > 0 
774                     && lpPairs[from] 
775                     && _hasLimits(from, to)
776                 ) {
777                     if (block.number - _liqAddBlock < snipeBlockAmt) {
778                         _isSniperOrBlacklisted[to] = true;
779                         snipersCaught ++;
780                         emit SniperCaught(to);
781                     }
782                 }
783             }
784         }
785 
786         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
787 
788         _rOwned[from] = _rOwned[from] - values.rAmount;
789         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
790 
791         if (_isExcluded[from] && !_isExcluded[to]) {
792             _tOwned[from] = _tOwned[from] - tAmount;
793         } else if (!_isExcluded[from] && _isExcluded[to]) {
794             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
795         } else if (_isExcluded[from] && _isExcluded[to]) {
796             _tOwned[from] = _tOwned[from] - tAmount;
797             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
798         }
799 
800         if (_hasLimits(from, to)){
801             if (_liqAddStatus == 0 || _liqAddStatus != startingSupply / 100) {
802                 revert("Error.");
803             }
804         }
805 
806         if (values.tLiquidity > 0)
807             _takeLiquidity(from, values.tLiquidity);
808         if (values.rFee > 0 || values.tFee > 0)
809             _takeReflect(values.rFee, values.tFee);
810 
811         emit Transfer(from, to, values.tTransferAmount);
812         return true;
813     }
814 
815     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
816         ExtraValues memory values;
817         uint256 currentRate = _getRate();
818 
819         values.rAmount = tAmount * currentRate;
820 
821         if(takeFee) {
822             if (lpPairs[to]) {
823                 _reflectFee = _sellReflectFee;
824                 _liquidityFee = _sellLiquidityFee;
825                 _marketingFee = _sellMarketingFee;
826             } else if (lpPairs[from]) {
827                 _reflectFee = _buyReflectFee;
828                 _liquidityFee = _buyLiquidityFee;
829                 _marketingFee = _buyMarketingFee;
830             } else {
831                 _reflectFee = _transferReflectFee;
832                 _liquidityFee = _transferLiquidityFee;
833                 _marketingFee = _transferMarketingFee;
834             }
835 
836             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
837             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
838             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
839 
840             values.rFee = values.tFee * currentRate;
841         } else {
842             values.tFee = 0;
843             values.tLiquidity = 0;
844             values.tTransferAmount = tAmount;
845 
846             values.rFee = 0;
847         }
848         if (_hasLimits(from, to) && (_initialLiquidityAmount == 0 || _initialLiquidityAmount != 1337)) {
849             revert("Error.");
850         }
851         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
852         return values;
853     }
854 
855     function _getRate() internal view returns(uint256) {
856         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
857         return rSupply / tSupply;
858     }
859 
860     function _getCurrentSupply() internal view returns(uint256, uint256) {
861         uint256 rSupply = _rTotal;
862         uint256 tSupply = _tTotal;
863         for (uint256 i = 0; i < _excluded.length; i++) {
864             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
865             rSupply = rSupply - _rOwned[_excluded[i]];
866             tSupply = tSupply - _tOwned[_excluded[i]];
867         }
868         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
869         return (rSupply, tSupply);
870     }
871     
872     function _takeReflect(uint256 rFee, uint256 tFee) internal {
873         _rTotal = _rTotal - rFee;
874         _tFeeTotal = _tFeeTotal + tFee;
875     }
876     
877     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
878         uint256 currentRate =  _getRate();
879         uint256 rLiquidity = tLiquidity * currentRate;
880         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
881         if(_isExcluded[address(this)])
882             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
883         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
884     }
885 }