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
216 contract Monkey is Context, IERC20Upgradeable {
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
262     uint256 public MarketShare = 8;
263     uint256 public DevShare = 2;
264     uint256 public ValueDivisor = 10;
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
353     function LaunchToken(address payable setMarketWallet, address payable setDevWallet, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
354         require(!contractInitialized);
355 
356         _marketWallet = payable(setMarketWallet);
357         _devWallet = payable(setDevWallet);
358 
359         _name = _tokenname;
360         _symbol = _tokensymbol;
361         startingSupply = 100_000_000;
362         if (startingSupply < 100000000000) {
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
377         _maxTxAmount = (_tTotal * 10) / 10000;
378         maxTxAmountUI = (startingSupply * 10) / 10000;
379         _maxWalletSize = (_tTotal * 10) / 10000;
380         maxWalletSizeUI = (startingSupply * 10) / 10000;
381         swapThreshold = (_tTotal * 5) / 10000000;
382         swapAmount = (_tTotal * 5) / 100000;
383 
384         approve(_routerAddress, type(uint256).max);
385 
386         contractInitialized = true;
387         _rOwned[owner()] = _rTotal;
388         emit Transfer(ZERO, owner(), _tTotal);
389 
390         _approve(address(this), address(dexRouter), type(uint256).max);
391 
392         _transfer(owner(), address(this), ((balanceOf(owner()))*10/100));
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
403 
404         require(!tradingEnabled, "Trading already enabled!");
405         setExcludedFromReward(address(this), true);
406         setExcludedFromReward(lpPair, true);
407 
408         tradingEnabled = true;
409         swapAndLiquifyEnabled = true;
410     }
411 
412     function enableTrade() public onlyOwner {
413         require(!tradingEnabled, "Trading already enabled!");
414         setExcludedFromReward(address(this), true);
415         setExcludedFromReward(lpPair, true);
416 
417         tradingEnabled = true;
418         swapAndLiquifyEnabled = true;
419     }
420 
421 //===============================================================================================================
422 //===============================================================================================================
423 //===============================================================================================================
424     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
425     // This allows for removal of ownership privelages from the owner once renounced or transferred.
426     function owner() public view returns (address) {
427         return _owner;
428     }
429 
430     function transferOwner(address newOwner) external onlyOwner() {
431         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
432         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
433         setExcludedFromFee(_owner, false);
434         setExcludedFromFee(newOwner, true);
435         setExcludedFromReward(newOwner, true);
436         
437         if (_devWallet == payable(_owner))
438             _devWallet = payable(newOwner);
439         
440         _allowances[_owner][newOwner] = balanceOf(_owner);
441         if(balanceOf(_owner) > 0) {
442             _transfer(_owner, newOwner, balanceOf(_owner));
443         }
444         
445         _owner = newOwner;
446         emit OwnershipTransferred(_owner, newOwner);
447         
448     }
449 
450     function renounceOwnership() public virtual onlyOwner() {
451         setExcludedFromFee(_owner, false);
452         _owner = address(0);
453         emit OwnershipTransferred(_owner, address(0));
454     }
455 //===============================================================================================================
456 //===============================================================================================================
457 //===============================================================================================================
458 
459     function totalSupply() external view override returns (uint256) { return _tTotal; }
460     function decimals() external view returns (uint8) { return _decimals; }
461     function symbol() external view returns (string memory) { return _symbol; }
462     function name() external view returns (string memory) { return _name; }
463     function getOwner() external view returns (address) { return owner(); }
464     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
465 
466     function balanceOf(address account) public view override returns (uint256) {
467         if (_isExcluded[account]) return _tOwned[account];
468         return tokenFromReflection(_rOwned[account]);
469     }
470 
471     function transfer(address recipient, uint256 amount) public override returns (bool) {
472         _transfer(_msgSender(), recipient, amount);
473         return true;
474     }
475 
476     function approve(address spender, uint256 amount) public override returns (bool) {
477         _approve(_msgSender(), spender, amount);
478         return true;
479     }
480 
481     function approveMax(address spender) public returns (bool) {
482         return approve(spender, type(uint256).max);
483     }
484 
485     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
486         _transfer(sender, recipient, amount);
487         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
488         return true;
489     }
490 
491     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
492         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
493         return true;
494     }
495 
496     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
497         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
498         return true;
499     }
500 
501     function setNewRouter(address newRouter) external onlyOwner() {
502         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
503         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
504         if (get_pair == address(0)) {
505             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
506         }
507         else {
508             lpPair = get_pair;
509         }
510         dexRouter = _newRouter;
511         _approve(address(this), newRouter, MAX);
512     }
513 
514     function setLpPair(address pair, bool enabled) external onlyOwner {
515         if (enabled == false) {
516             lpPairs[pair] = false;
517         } else {
518             if (timeSinceLastPair != 0) {
519                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
520             }
521             lpPairs[pair] = true;
522             timeSinceLastPair = block.timestamp;
523         }
524     }
525 
526     function isExcludedFromReward(address account) public view returns (bool) {
527         return _isExcluded[account];
528     }
529 
530     function isExcludedFromFee(address account) public view returns(bool) {
531         return _isExcludedFromFee[account];
532     }
533 
534     function setTaxBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
535         require(reflect <= maxReflectFee
536                 && liquidity <= maxLiquidityFee
537                 && marketing <= maxMarketingFee
538                 );
539         require(reflect + liquidity + marketing <= 4900);
540         _buyReflectFee = reflect;
541         _buyLiquidityFee = liquidity;
542         _buyMarketingFee = marketing;
543     }
544 
545     function setTaxSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
546         require(reflect <= maxReflectFee
547                 && liquidity <= maxLiquidityFee
548                 && marketing <= maxMarketingFee
549                 );
550         require(reflect + liquidity + marketing <= 6900);
551         _sellReflectFee = reflect;
552         _sellLiquidityFee = liquidity;
553         _sellMarketingFee = marketing;
554     }
555 
556     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
557         require(reflect <= maxReflectFee
558                 && liquidity <= maxLiquidityFee
559                 && marketing <= maxMarketingFee
560                 );
561         require(reflect + liquidity + marketing <= 4900);
562         _transferReflectFee = reflect;
563         _transferLiquidityFee = liquidity;
564         _transferMarketingFee = marketing;
565     }
566 
567     function setShareValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
568         MarketShare = ms;
569         DevShare = ds;
570         ValueDivisor = vd;
571     }
572 
573     function setLiqandMarketRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
574         _liquidityRatio = liquidity;
575         _marketingRatio = marketing;
576     }
577 
578     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
579         uint256 check = (_tTotal * percent) / divisor;
580         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
581         _maxTxAmount = check;
582         maxTxAmountUI = (startingSupply * percent) / divisor;
583     }
584 
585     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
586         uint256 check = (_tTotal * percent) / divisor;
587         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
588         _maxWalletSize = check;
589         maxWalletSizeUI = (startingSupply * percent) / divisor;
590     }
591 
592     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
593         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
594         swapAmount = (_tTotal * amountPercent) / amountDivisor;
595     }
596 
597     function setMarketWalletNew(address payable newWallet) external onlyOwner {
598         require(_marketWallet != newWallet, "Wallet already set!");
599         _marketWallet = payable(newWallet);
600     }
601 
602     function setDevWalletNew(address payable newWallet) external onlyOwner {
603         require(_devWallet != newWallet, "Wallet already set!");
604         _devWallet = payable(newWallet);
605     }
606     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
607         swapAndLiquifyEnabled = _enabled;
608         emit SwapAndLiquifyEnabledUpdated(_enabled);
609     }
610 
611     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
612         _isExcludedFromFee[account] = enabled;
613     }
614 
615     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
616         if (enabled == true) {
617             require(!_isExcluded[account], "Account is already excluded.");
618             if(_rOwned[account] > 0) {
619                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
620             }
621             _isExcluded[account] = true;
622             _excluded.push(account);
623         } else if (enabled == false) {
624             require(_isExcluded[account], "Account is already included.");
625             for (uint256 i = 0; i < _excluded.length; i++) {
626                 if (_excluded[i] == account) {
627                     _excluded[i] = _excluded[_excluded.length - 1];
628                     _tOwned[account] = 0;
629                     _isExcluded[account] = false;
630                     _excluded.pop();
631                     break;
632                 }
633             }
634         }
635     }
636 
637     function totalFees() public view returns (uint256) {
638         return _tFeeTotal;
639     }
640 
641     function _hasLimits(address from, address to) internal view returns (bool) {
642         return from != owner()
643             && to != owner()
644             && !_liquidityHolders[to]
645             && !_liquidityHolders[from]
646             && to != DEAD
647             && to != address(0)
648             && from != address(this);
649     }
650 
651     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
652         require(rAmount <= _rTotal, "Amount must be less than total reflections");
653         uint256 currentRate =  _getRate();
654         return rAmount / currentRate;
655     }
656     
657     function _approve(address sender, address spender, uint256 amount) internal {
658         require(sender != address(0), "ERC20: approve from the zero address");
659         require(spender != address(0), "ERC20: approve to the zero address");
660 
661         _allowances[sender][spender] = amount;
662         emit Approval(sender, spender, amount);
663     }
664 
665     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
666         require(from != address(0), "ERC20: transfer from the zero address");
667         require(to != address(0), "ERC20: transfer to the zero address");
668         require(amount > 0, "Transfer amount must be greater than zero");
669         if(_hasLimits(from, to)) {
670             if(!tradingEnabled) {
671                 revert("Trading not yet enabled!");
672             }
673             if (sameBlockActive) {
674                 if (lpPairs[from]){
675                     require(lastTrade[to] != block.number);
676                     lastTrade[to] = block.number;
677                 } else {
678                     require(lastTrade[from] != block.number);
679                     lastTrade[from] = block.number;
680                 }
681             }
682             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
683             if(to != _routerAddress && !lpPairs[to]) {
684                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
685             }
686         }
687         bool takeFee = true;
688         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
689             takeFee = false;
690         }
691 
692         if (lpPairs[to]) {
693             if (!inSwapAndLiquify
694                 && swapAndLiquifyEnabled
695             ) {
696                 uint256 contractTokenBalance = balanceOf(address(this));
697                 if (contractTokenBalance >= swapThreshold) {
698                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
699                     swapAndLiquify(contractTokenBalance);
700                 }
701             }      
702         } 
703         return _finalizeTransfer(from, to, amount, takeFee);
704     }
705 
706     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
707         if (_liquidityRatio + _marketingRatio == 0)
708             return;
709         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
710 
711         uint256 toSwapForEth = contractTokenBalance - toLiquify;
712 
713         address[] memory path = new address[](2);
714         path[0] = address(this);
715         path[1] = dexRouter.WETH();
716 
717         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
718             toSwapForEth,
719             0,
720             path,
721             address(this),
722             block.timestamp
723         );
724 
725 
726         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
727 
728         if (toLiquify > 0) {
729             dexRouter.addLiquidityETH{value: liquidityBalance}(
730                 address(this),
731                 toLiquify,
732                 0, 
733                 0, 
734                 DEAD,
735                 block.timestamp
736             );
737             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
738         }
739         if (contractTokenBalance - toLiquify > 0) {
740 
741             uint256 OperationsFee = (address(this).balance);
742             uint256 marketFee = OperationsFee/(ValueDivisor)*(MarketShare);
743             uint256 devfeeshare = OperationsFee/(ValueDivisor)*(DevShare);
744             _marketWallet.transfer(marketFee);
745             _devWallet.transfer(devfeeshare);            
746 
747         }
748     }
749 
750     
751 
752     function _checkLiquidityAdd(address from, address to) internal {
753         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
754         if (!_hasLimits(from, to) && to == lpPair) {
755             _liquidityHolders[from] = true;
756             _hasLiqBeenAdded = true;
757             _liqAddStamp = block.timestamp;
758 
759             swapAndLiquifyEnabled = true;
760             emit SwapAndLiquifyEnabledUpdated(true);
761         }
762     }
763 
764     struct ExtraValues {
765         uint256 tTransferAmount;
766         uint256 tFee;
767         uint256 tLiquidity;
768 
769         uint256 rTransferAmount;
770         uint256 rAmount;
771         uint256 rFee;
772     }
773 
774     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
775 
776 
777         if (!_hasLiqBeenAdded) {
778                 _checkLiquidityAdd(from, to);
779                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
780                     revert("Only owner can transfer at this time.");
781                 }
782         }
783         
784         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
785 
786         _rOwned[from] = _rOwned[from] - values.rAmount;
787         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
788 
789         if (_isExcluded[from] && !_isExcluded[to]) {
790             _tOwned[from] = _tOwned[from] - tAmount;
791         } else if (!_isExcluded[from] && _isExcluded[to]) {
792             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
793         } else if (_isExcluded[from] && _isExcluded[to]) {
794             _tOwned[from] = _tOwned[from] - tAmount;
795             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
796         }
797 
798         if (values.tLiquidity > 0)
799             _takeLiquidity(from, values.tLiquidity);
800         if (values.rFee > 0 || values.tFee > 0)
801             _takeReflect(values.rFee, values.tFee);
802 
803         emit Transfer(from, to, values.tTransferAmount);
804         return true;
805     }
806 
807     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
808         ExtraValues memory values;
809         uint256 currentRate = _getRate();
810 
811         values.rAmount = tAmount * currentRate;
812 
813         if(takeFee) {
814             if (lpPairs[to]) {
815                 _reflectFee = _sellReflectFee;
816                 _liquidityFee = _sellLiquidityFee;
817                 _marketingFee = _sellMarketingFee;
818             } else if (lpPairs[from]) {
819                 _reflectFee = _buyReflectFee;
820                 _liquidityFee = _buyLiquidityFee;
821                 _marketingFee = _buyMarketingFee;
822             } else {
823                 _reflectFee = _transferReflectFee;
824                 _liquidityFee = _transferLiquidityFee;
825                 _marketingFee = _transferMarketingFee;
826             }
827 
828             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
829             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
830             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
831 
832             values.rFee = values.tFee * currentRate;
833         } else {
834             values.tFee = 0;
835             values.tLiquidity = 0;
836             values.tTransferAmount = tAmount;
837 
838             values.rFee = 0;
839         }
840 
841         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
842         return values;
843     }
844 
845     function _getRate() internal view returns(uint256) {
846         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
847         return rSupply / tSupply;
848     }
849 
850     function _getCurrentSupply() internal view returns(uint256, uint256) {
851         uint256 rSupply = _rTotal;
852         uint256 tSupply = _tTotal;
853         for (uint256 i = 0; i < _excluded.length; i++) {
854             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
855             rSupply = rSupply - _rOwned[_excluded[i]];
856             tSupply = tSupply - _tOwned[_excluded[i]];
857         }
858         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
859         return (rSupply, tSupply);
860     }
861     
862     function _takeReflect(uint256 rFee, uint256 tFee) internal {
863         _rTotal = _rTotal - rFee;
864         _tFeeTotal = _tFeeTotal + tFee;
865     }
866 
867     function recoverETH() external onlyOwner {
868         payable(owner()).transfer(address(this).balance);
869     }
870     
871     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
872         uint256 currentRate =  _getRate();
873         uint256 rLiquidity = tLiquidity * currentRate;
874         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
875         if(_isExcluded[address(this)])
876             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
877         emit Transfer(sender, address(this), tLiquidity); 
878     }
879 }