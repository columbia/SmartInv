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
216 contract teleMAID is Context, IERC20Upgradeable {
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
230     mapping (address => bool) private _liquidityHolders;
231    
232     uint256 private startingSupply;
233 
234     string private _name;
235     string private _symbol;
236 
237     uint256 public _reflectFee = 0;
238     uint256 public _liquidityFee = 0;
239     uint256 public _marketingFee = 1000;
240 
241     uint256 public _buyReflectFee = _reflectFee;
242     uint256 public _buyLiquidityFee = _liquidityFee;
243     uint256 public _buyMarketingFee = _marketingFee;
244 
245     uint256 public _sellReflectFee = 0;
246     uint256 public _sellLiquidityFee = 0;
247     uint256 public _sellMarketingFee = 6000;
248     
249     uint256 public _transferReflectFee = 0;
250     uint256 public _transferLiquidityFee = 0;
251     uint256 public _transferMarketingFee = 0;
252     
253     uint256 private maxReflectFee = 1000;
254     uint256 private maxLiquidityFee = 1000;
255     uint256 private maxMarketingFee = 6200;
256 
257     uint256 public _liquidityRatio = 0;
258     uint256 public _marketingRatio = 6000;
259 
260     uint256 private masterTaxDivisor = 10000;
261 
262     uint256 public MarketShare = 0;
263     uint256 public DevShare = 3;
264     uint256 public ValueDivisor = 3;
265 
266     uint256 private constant MAX = ~uint256(0);
267     uint8 private _decimals;
268     uint256 private _decimalsMul;
269     uint256 private _tTotal;
270     uint256 private _rTotal;
271     uint256 private _tFeeTotal;
272 
273     IUniswapV2Router02 public dexRouter;
274     address public lpPair;
275 
276     // UNI ROUTER
277     address public _routerAddress;
278 
279     address public DEAD = 0x000000000000000000000000000000000000dEaD;
280     address public ZERO = 0x0000000000000000000000000000000000000000;
281     address payable private _devWallet;
282     address payable private _marketWallet;
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
298     bool public _hasLiqBeenAdded = false;
299     uint256 private _liqAddBlock = 0;
300     uint256 private _liqAddStamp = 0;
301     bool private sameBlockActive = true;
302     mapping (address => uint256) private lastTrade;
303 
304     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
305     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
306     event SwapAndLiquifyEnabledUpdated(bool enabled);
307     event SwapAndLiquify(
308         uint256 tokensSwapped,
309         uint256 ethReceived,
310         uint256 tokensIntoLiqudity
311     );
312     event SniperCaught(address sniperAddress);
313     uint256 Launched;
314     
315     bool contractInitialized = false;
316     
317     modifier lockTheSwap {
318         inSwapAndLiquify = true;
319         _;
320         inSwapAndLiquify = false;
321     }
322 
323     modifier onlyOwner() {
324         require(_owner == _msgSender(), "Ownable: caller is not the owner");
325         _;
326     }
327     
328     constructor () payable {
329         // Set the owner.
330         _owner = msg.sender;
331 
332         if (block.chainid == 56) {
333             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
334         } else if (block.chainid == 97) {
335             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
336         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
337             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
338         } else {
339             revert();
340         }
341 
342         _isExcludedFromFee[owner()] = true;
343         _isExcludedFromFee[address(this)] = true;
344         _liquidityHolders[owner()] = true;
345 
346         _approve(_msgSender(), _routerAddress, MAX);
347         _approve(address(this), _routerAddress, MAX);
348 
349     }
350 
351     receive() external payable {}
352 
353     function CreateLiquidityPair(address payable setMarketWallet, address payable setDevWallet, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
354         require(!contractInitialized);
355 
356         _marketWallet = payable(setMarketWallet);
357         _devWallet = payable(setDevWallet);
358 
359         _name = _tokenname;
360         _symbol = _tokensymbol;
361         startingSupply = 1_000_000_000;
362         if (startingSupply < 100000000000000000) {
363             _decimals = 18;
364             _decimalsMul = _decimals;
365         } else {
366             _decimals = 9;
367             _decimalsMul = _decimals;
368         }
369         _tTotal = startingSupply * (10**_decimalsMul);
370         _rTotal = (MAX - (MAX % _tTotal));
371 
372         dexRouter = IUniswapV2Router02(_routerAddress);
373         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
374         lpPairs[lpPair] = true;
375         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
376         
377         _maxTxAmount = (_tTotal * 10) / 1000;
378         maxTxAmountUI = (startingSupply * 10) / 1000;
379         _maxWalletSize = (_tTotal * 10) / 1000;
380         maxWalletSizeUI = (startingSupply * 10) / 1000;
381         swapThreshold = (_tTotal * 5) / 100000;
382         swapAmount = (_tTotal * 1) / 1000;
383 
384         approve(_routerAddress, type(uint256).max);
385 
386         contractInitialized = true;
387         _rOwned[owner()] = _rTotal;
388         emit Transfer(ZERO, owner(), _tTotal);
389 
390         _approve(address(this), address(dexRouter), type(uint256).max);
391 
392         _transfer(owner(), address(this), ((balanceOf(owner()))*90/100));
393 
394         dexRouter.addLiquidityETH{value: address(this).balance}(
395             address(this),
396             balanceOf(address(this)),
397             0, 
398             0, 
399             owner(),
400             block.timestamp
401         );
402         Launched = block.number;
403     }
404 
405     function enableTrading() public onlyOwner {
406         require(!tradingEnabled, "Trading already enabled!");
407         setExcludedFromReward(address(this), true);
408         setExcludedFromReward(lpPair, true);
409 
410         tradingEnabled = true;
411         swapAndLiquifyEnabled = true;
412     }
413 
414 //===============================================================================================================
415 //===============================================================================================================
416 //===============================================================================================================
417     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
418     // This allows for removal of ownership privelages from the owner once renounced or transferred.
419     function owner() public view returns (address) {
420         return _owner;
421     }
422 
423     function transferOwner(address newOwner) external onlyOwner() {
424         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
425         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
426         setExcludedFromFee(_owner, false);
427         setExcludedFromFee(newOwner, true);
428         setExcludedFromReward(newOwner, true);
429         
430         if (_devWallet == payable(_owner))
431             _devWallet = payable(newOwner);
432         
433         _allowances[_owner][newOwner] = balanceOf(_owner);
434         if(balanceOf(_owner) > 0) {
435             _transfer(_owner, newOwner, balanceOf(_owner));
436         }
437         
438         _owner = newOwner;
439         emit OwnershipTransferred(_owner, newOwner);
440         
441     }
442 
443     function renounceOwnership() public virtual onlyOwner() {
444         setExcludedFromFee(_owner, false);
445         _owner = address(0);
446         emit OwnershipTransferred(_owner, address(0));
447     }
448 //===============================================================================================================
449 //===============================================================================================================
450 //===============================================================================================================
451 
452     function totalSupply() external view override returns (uint256) { return _tTotal; }
453     function decimals() external view returns (uint8) { return _decimals; }
454     function symbol() external view returns (string memory) { return _symbol; }
455     function name() external view returns (string memory) { return _name; }
456     function getOwner() external view returns (address) { return owner(); }
457     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
458 
459     function balanceOf(address account) public view override returns (uint256) {
460         if (_isExcluded[account]) return _tOwned[account];
461         return tokenFromReflection(_rOwned[account]);
462     }
463 
464     function transfer(address recipient, uint256 amount) public override returns (bool) {
465         _transfer(_msgSender(), recipient, amount);
466         return true;
467     }
468 
469     function approve(address spender, uint256 amount) public override returns (bool) {
470         _approve(_msgSender(), spender, amount);
471         return true;
472     }
473 
474     function approveMax(address spender) public returns (bool) {
475         return approve(spender, type(uint256).max);
476     }
477 
478     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
479         _transfer(sender, recipient, amount);
480         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
481         return true;
482     }
483 
484     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
486         return true;
487     }
488 
489     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
490         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
491         return true;
492     }
493 
494     function setNewRouter(address newRouter) external onlyOwner() {
495         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
496         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
497         if (get_pair == address(0)) {
498             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
499         }
500         else {
501             lpPair = get_pair;
502         }
503         dexRouter = _newRouter;
504         _approve(address(this), newRouter, MAX);
505     }
506 
507     function setLpPair(address pair, bool enabled) external onlyOwner {
508         if (enabled == false) {
509             lpPairs[pair] = false;
510         } else {
511             if (timeSinceLastPair != 0) {
512                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
513             }
514             lpPairs[pair] = true;
515             timeSinceLastPair = block.timestamp;
516         }
517     }
518 
519     function isExcludedFromReward(address account) public view returns (bool) {
520         return _isExcluded[account];
521     }
522 
523     function isExcludedFromFee(address account) public view returns(bool) {
524         return _isExcludedFromFee[account];
525     }
526 
527     function setTaxBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
528         require(reflect <= maxReflectFee
529                 && liquidity <= maxLiquidityFee
530                 && marketing <= maxMarketingFee
531                 );
532         require(reflect + liquidity + marketing <= 4900);
533         _buyReflectFee = reflect;
534         _buyLiquidityFee = liquidity;
535         _buyMarketingFee = marketing;
536     }
537 
538     function setTaxSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
539         require(reflect <= maxReflectFee
540                 && liquidity <= maxLiquidityFee
541                 && marketing <= maxMarketingFee
542                 );
543         require(reflect + liquidity + marketing <= 6900);
544         _sellReflectFee = reflect;
545         _sellLiquidityFee = liquidity;
546         _sellMarketingFee = marketing;
547     }
548 
549     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
550         require(reflect <= maxReflectFee
551                 && liquidity <= maxLiquidityFee
552                 && marketing <= maxMarketingFee
553                 );
554         require(reflect + liquidity + marketing <= 4900);
555         _transferReflectFee = reflect;
556         _transferLiquidityFee = liquidity;
557         _transferMarketingFee = marketing;
558     }
559 
560     function setShareValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
561         MarketShare = ms;
562         DevShare = ds;
563         ValueDivisor = vd;
564     }
565 
566     function setLiqandMarketRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
567         _liquidityRatio = liquidity;
568         _marketingRatio = marketing;
569     }
570 
571     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
572         uint256 check = (_tTotal * percent) / divisor;
573         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
574         _maxTxAmount = check;
575         maxTxAmountUI = (startingSupply * percent) / divisor;
576     }
577 
578     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
579         uint256 check = (_tTotal * percent) / divisor;
580         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
581         _maxWalletSize = check;
582         maxWalletSizeUI = (startingSupply * percent) / divisor;
583     }
584 
585     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
586         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
587         swapAmount = (_tTotal * amountPercent) / amountDivisor;
588     }
589 
590     function setMarketWalletNew(address payable newWallet) external onlyOwner {
591         require(_marketWallet != newWallet, "Wallet already set!");
592         _marketWallet = payable(newWallet);
593     }
594 
595     function setDevWalletNew(address payable newWallet) external onlyOwner {
596         require(_devWallet != newWallet, "Wallet already set!");
597         _devWallet = payable(newWallet);
598     }
599     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
600         swapAndLiquifyEnabled = _enabled;
601         emit SwapAndLiquifyEnabledUpdated(_enabled);
602     }
603 
604     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
605         _isExcludedFromFee[account] = enabled;
606     }
607 
608     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
609         if (enabled == true) {
610             require(!_isExcluded[account], "Account is already excluded.");
611             if(_rOwned[account] > 0) {
612                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
613             }
614             _isExcluded[account] = true;
615             _excluded.push(account);
616         } else if (enabled == false) {
617             require(_isExcluded[account], "Account is already included.");
618             for (uint256 i = 0; i < _excluded.length; i++) {
619                 if (_excluded[i] == account) {
620                     _excluded[i] = _excluded[_excluded.length - 1];
621                     _tOwned[account] = 0;
622                     _isExcluded[account] = false;
623                     _excluded.pop();
624                     break;
625                 }
626             }
627         }
628     }
629 
630     function totalFees() public view returns (uint256) {
631         return _tFeeTotal;
632     }
633 
634     function _hasLimits(address from, address to) internal view returns (bool) {
635         return from != owner()
636             && to != owner()
637             && !_liquidityHolders[to]
638             && !_liquidityHolders[from]
639             && to != DEAD
640             && to != address(0)
641             && from != address(this);
642     }
643 
644     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
645         require(rAmount <= _rTotal, "Amount must be less than total reflections");
646         uint256 currentRate =  _getRate();
647         return rAmount / currentRate;
648     }
649     
650     function _approve(address sender, address spender, uint256 amount) internal {
651         require(sender != address(0), "ERC20: approve from the zero address");
652         require(spender != address(0), "ERC20: approve to the zero address");
653 
654         _allowances[sender][spender] = amount;
655         emit Approval(sender, spender, amount);
656     }
657 
658     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
659         require(from != address(0), "ERC20: transfer from the zero address");
660         require(to != address(0), "ERC20: transfer to the zero address");
661         require(amount > 0, "Transfer amount must be greater than zero");
662         if(_hasLimits(from, to)) {
663             if(!tradingEnabled) {
664                 revert("Trading not yet enabled!");
665             }
666             if (sameBlockActive) {
667                 if (lpPairs[from]){
668                     require(lastTrade[to] != block.number);
669                     lastTrade[to] = block.number;
670                 } else {
671                     require(lastTrade[from] != block.number);
672                     lastTrade[from] = block.number;
673                 }
674             }
675             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
676             if(to != _routerAddress && !lpPairs[to]) {
677                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
678             }
679         }
680         bool takeFee = true;
681         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
682             takeFee = false;
683         }
684 
685         if (lpPairs[to]) {
686             if (!inSwapAndLiquify
687                 && swapAndLiquifyEnabled
688             ) {
689                 uint256 contractTokenBalance = balanceOf(address(this));
690                 if (contractTokenBalance >= swapThreshold) {
691                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
692                     swapAndLiquify(contractTokenBalance);
693                 }
694             }      
695         } 
696         return _finalizeTransfer(from, to, amount, takeFee);
697     }
698 
699     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
700         if (_liquidityRatio + _marketingRatio == 0)
701             return;
702         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
703 
704         uint256 toSwapForEth = contractTokenBalance - toLiquify;
705 
706         address[] memory path = new address[](2);
707         path[0] = address(this);
708         path[1] = dexRouter.WETH();
709 
710         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
711             toSwapForEth,
712             0,
713             path,
714             address(this),
715             block.timestamp
716         );
717 
718 
719         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
720 
721         if (toLiquify > 0) {
722             dexRouter.addLiquidityETH{value: liquidityBalance}(
723                 address(this),
724                 toLiquify,
725                 0, 
726                 0, 
727                 DEAD,
728                 block.timestamp
729             );
730             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
731         }
732         if (contractTokenBalance - toLiquify > 0) {
733 
734             uint256 OperationsFee = (address(this).balance);
735             uint256 marketFee = OperationsFee/(ValueDivisor)*(MarketShare);
736             uint256 devfeeshare = OperationsFee/(ValueDivisor)*(DevShare);
737             _marketWallet.transfer(marketFee);
738             _devWallet.transfer(devfeeshare);            
739 
740         }
741     }
742 
743     
744 
745     function _checkLiquidityAdd(address from, address to) internal {
746         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
747         if (!_hasLimits(from, to) && to == lpPair) {
748             _liquidityHolders[from] = true;
749             _hasLiqBeenAdded = true;
750             _liqAddStamp = block.timestamp;
751 
752             swapAndLiquifyEnabled = true;
753             emit SwapAndLiquifyEnabledUpdated(true);
754         }
755     }
756 
757     struct ExtraValues {
758         uint256 tTransferAmount;
759         uint256 tFee;
760         uint256 tLiquidity;
761 
762         uint256 rTransferAmount;
763         uint256 rAmount;
764         uint256 rFee;
765     }
766 
767     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
768 
769 
770         if (!_hasLiqBeenAdded) {
771                 _checkLiquidityAdd(from, to);
772                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
773                     revert("Only owner can transfer at this time.");
774                 }
775         }
776         
777         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
778 
779         _rOwned[from] = _rOwned[from] - values.rAmount;
780         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
781 
782         if (_isExcluded[from] && !_isExcluded[to]) {
783             _tOwned[from] = _tOwned[from] - tAmount;
784         } else if (!_isExcluded[from] && _isExcluded[to]) {
785             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
786         } else if (_isExcluded[from] && _isExcluded[to]) {
787             _tOwned[from] = _tOwned[from] - tAmount;
788             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
789         }
790 
791         if (values.tLiquidity > 0)
792             _takeLiquidity(from, values.tLiquidity);
793         if (values.rFee > 0 || values.tFee > 0)
794             _takeReflect(values.rFee, values.tFee);
795 
796         emit Transfer(from, to, values.tTransferAmount);
797         return true;
798     }
799 
800     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
801         ExtraValues memory values;
802         uint256 currentRate = _getRate();
803 
804         values.rAmount = tAmount * currentRate;
805 
806         if(takeFee) {
807             if (lpPairs[to]) {
808                 _reflectFee = _sellReflectFee;
809                 _liquidityFee = _sellLiquidityFee;
810                 _marketingFee = _sellMarketingFee;
811             } else if (lpPairs[from]) {
812                 _reflectFee = _buyReflectFee;
813                 _liquidityFee = _buyLiquidityFee;
814                 _marketingFee = _buyMarketingFee;
815             } else {
816                 _reflectFee = _transferReflectFee;
817                 _liquidityFee = _transferLiquidityFee;
818                 _marketingFee = _transferMarketingFee;
819             }
820 
821             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
822             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
823             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
824 
825             values.rFee = values.tFee * currentRate;
826         } else {
827             values.tFee = 0;
828             values.tLiquidity = 0;
829             values.tTransferAmount = tAmount;
830 
831             values.rFee = 0;
832         }
833 
834         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
835         return values;
836     }
837 
838     function _getRate() internal view returns(uint256) {
839         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
840         return rSupply / tSupply;
841     }
842 
843     function _getCurrentSupply() internal view returns(uint256, uint256) {
844         uint256 rSupply = _rTotal;
845         uint256 tSupply = _tTotal;
846         for (uint256 i = 0; i < _excluded.length; i++) {
847             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
848             rSupply = rSupply - _rOwned[_excluded[i]];
849             tSupply = tSupply - _tOwned[_excluded[i]];
850         }
851         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
852         return (rSupply, tSupply);
853     }
854     
855     function _takeReflect(uint256 rFee, uint256 tFee) internal {
856         _rTotal = _rTotal - rFee;
857         _tFeeTotal = _tFeeTotal + tFee;
858     }
859 
860     function recoverETH() external onlyOwner {
861         payable(owner()).transfer(address(this).balance);
862     }
863     
864     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
865         uint256 currentRate =  _getRate();
866         uint256 rLiquidity = tLiquidity * currentRate;
867         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
868         if(_isExcluded[address(this)])
869             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
870         emit Transfer(sender, address(this), tLiquidity); 
871     }
872 }