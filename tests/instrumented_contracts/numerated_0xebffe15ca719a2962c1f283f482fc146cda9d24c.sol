1 // MEDIUM - https://medium.com/@Iamanobody
2 
3 // SPDX-License-Identifier: MIT
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
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20Upgradeable {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/od/ai/nu/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 library Address {
97     function isContract(address account) internal view returns (bool) {
98         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
99         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
100         // for accounts without code, i.e. `keccak256('')`
101         bytes32 codehash;
102         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
103         // solhint-disable-next-line no-inline-assembly
104         assembly { codehash := extcodehash(account) }
105         return (codehash != accountHash && codehash != 0x0);
106     }
107 
108     function sendValue(address payable recipient, uint256 amount) internal {
109         require(address(this).balance >= amount, "Address: insufficient balance");
110 
111         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
112         (bool success, ) = recipient.call{ value: amount }("");
113         require(success, "Address: unable to send value, recipient may have reverted");
114     }
115 
116     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
117         return functionCall(target, data, "Address: low-level call failed");
118     }
119 
120     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
121         return _functionCallWithValue(target, data, 0, errorMessage);
122     }
123 
124 
125     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         return _functionCallWithValue(target, data, value, errorMessage);
132     }
133 
134     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135         require(isContract(target), "Address: call to non-contract");
136 
137         // solhint-disable-next-line avoid-low-level-calls
138         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
139         if (success) {
140             return returndata;
141         } else {
142             // Look for revert reason and bubble it up if present
143             if (returndata.length > 0) {
144                 // The easiest way to bubble the revert reason is using memory via assembly
145 
146                 // solhint-disable-next-line no-inline-assembly
147                 assembly {
148                     let returndata_size := mload(returndata)
149                     revert(add(32, returndata), returndata_size)
150                 }
151             } else {
152                 revert(errorMessage);
153             }
154         }
155     }
156 }
157 
158 interface IUniswapV2Factory {
159     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
160     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
161     function createPair(address tokenA, address tokenB) external returns (address lpPair);
162 }
163 
164 interface IUniswapV2Router01 {
165     function factory() external pure returns (address);
166     function WETH() external pure returns (address);
167     function addLiquidityETH(
168         address token,
169         uint amountTokenDesired,
170         uint amountTokenMin,
171         uint amountETHMin,
172         address to,
173         uint deadline
174     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
175 }
176 
177 interface IUniswapV2Router02 is IUniswapV2Router01 {
178     function removeLiquidityETHSupportingFeeOnTransferTokens(
179         address token,
180         uint liquidity,
181         uint amountTokenMin,
182         uint amountETHMin,
183         address to,
184         uint deadline
185     ) external returns (uint amountETH);
186     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
187         address token,
188         uint liquidity,
189         uint amountTokenMin,
190         uint amountETHMin,
191         address to,
192         uint deadline,
193         bool approveMax, uint8 v, bytes32 r, bytes32 s
194     ) external returns (uint amountETH);
195 
196     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
197         uint amountIn,
198         uint amountOutMin,
199         address[] calldata path,
200         address to,
201         uint deadline
202     ) external;
203     function swapExactETHForTokensSupportingFeeOnTransferTokens(
204         uint amountOutMin,
205         address[] calldata path,
206         address to,
207         uint deadline
208     ) external payable;
209     function swapExactTokensForETHSupportingFeeOnTransferTokens(
210         uint amountIn,
211         uint amountOutMin,
212         address[] calldata path,
213         address to,
214         uint deadline
215     ) external;
216 }
217 
218 contract DEIFANCE is Context, IERC20Upgradeable {
219     // Ownership moved to in-contract for customizability.
220     address private _owner;
221 
222     mapping (address => uint256) private _rOwned;
223     mapping (address => uint256) private _tOwned;
224     mapping (address => bool) lpPairs;
225     uint256 private timeSinceLastPair = 0;
226     mapping (address => mapping (address => uint256)) private _allowances;
227 
228     mapping (address => bool) private _isExcludedFromFee;
229     mapping (address => bool) private _isExcluded;
230     address[] private _excluded;
231 
232     mapping (address => bool) private _liquidityHolders;
233    
234     uint256 private startingSupply;
235 
236     string private _name;
237     string private _symbol;
238 
239     uint256 public _reflectFee = 0;
240     uint256 public _liquidityFee = 0;
241     uint256 public _marketingFee =0;
242 
243     uint256 public _buyReflectFee = _reflectFee;
244     uint256 public _buyLiquidityFee = _liquidityFee;
245     uint256 public _buyMarketingFee = _marketingFee;
246 
247     uint256 public _sellReflectFee = 0;
248     uint256 public _sellLiquidityFee = 0;
249     uint256 public _sellMarketingFee = 0;
250     
251     uint256 public _transferReflectFee = 0;
252     uint256 public _transferLiquidityFee = 0;
253     uint256 public _transferMarketingFee = 0;
254     
255     uint256 private maxReflectFee = 1000;
256     uint256 private maxLiquidityFee = 1000;
257     uint256 private maxMarketingFee = 2200;
258 
259     uint256 public _liquidityRatio = 0;
260     uint256 public _marketingRatio = 0;
261 
262     uint256 private masterTaxDivisor = 10000;
263 
264     uint256 public MarketShare = 1;
265     uint256 public DevShare = 0;
266     uint256 public ValueDivisor = 1;
267 
268     uint256 private constant MAX = ~uint256(0);
269     uint8 private _decimals;
270     uint256 private _decimalsMul;
271     uint256 private _tTotal;
272     uint256 private _rTotal;
273     uint256 private _tFeeTotal;
274 
275     IUniswapV2Router02 public dexRouter;
276     address public lpPair;
277 
278     // UNI ROUTER
279     address public _routerAddress;
280 
281     address public DEAD = 0x000000000000000000000000000000000000dEaD;
282     address public ZERO = 0x0000000000000000000000000000000000000000;
283     address payable private _devWallet;
284     address payable private _marketWallet;
285     
286     bool inSwapAndLiquify;
287     bool public swapAndLiquifyEnabled = false;
288     
289     uint256 private _maxTxAmount;
290     uint256 public maxTxAmountUI;
291 
292     uint256 private _maxWalletSize;
293     uint256 public maxWalletSizeUI;
294 
295     uint256 private swapThreshold;
296     uint256 private swapAmount;
297 
298     bool tradingEnabled = false;
299 
300     bool public _hasLiqBeenAdded = false;
301     uint256 private _liqAddBlock = 0;
302     uint256 private _liqAddStamp = 0;
303     bool private sameBlockActive = true;
304     mapping (address => uint256) private lastTrade;
305 
306     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
307     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
308     event SwapAndLiquifyEnabledUpdated(bool enabled);
309     event SwapAndLiquify(
310         uint256 tokensSwapped,
311         uint256 ethReceived,
312         uint256 tokensIntoLiqudity
313     );
314     event SniperCaught(address sniperAddress);
315     uint256 Planted;
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
334         if (block.chainid == 56) {
335             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
336         } else if (block.chainid == 97) {
337             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
338         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
339             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
340         } else {
341             revert();
342         }
343 
344         _isExcludedFromFee[owner()] = true;
345         _isExcludedFromFee[address(this)] = true;
346         _liquidityHolders[owner()] = true;
347 
348         _approve(_msgSender(), _routerAddress, MAX);
349         _approve(address(this), _routerAddress, MAX);
350 
351     }
352 
353     receive() external payable {}
354 
355     function intializeContract(address payable setMarketWallet, address payable setDevWallet, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
356         require(!contractInitialized);
357 
358         _marketWallet = payable(setMarketWallet);
359         _devWallet = payable(setDevWallet);
360 
361         _name = _tokenname;
362         _symbol = _tokensymbol;
363         startingSupply = 1_000_000_000_000;
364         if (startingSupply < 10000000000000) {
365             _decimals = 18;
366             _decimalsMul = _decimals;
367         } else {
368             _decimals = 9;
369             _decimalsMul = _decimals;
370         }
371         _tTotal = startingSupply * (10**_decimalsMul);
372         _rTotal = (MAX - (MAX % _tTotal));
373 
374         dexRouter = IUniswapV2Router02(_routerAddress);
375         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
376         lpPairs[lpPair] = true;
377         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
378         
379         _maxTxAmount = (_tTotal * 1000) / 100000;
380         maxTxAmountUI = (startingSupply * 1000) / 100000;
381         _maxWalletSize = (_tTotal * 10) / 1000;
382         maxWalletSizeUI = (startingSupply * 10) / 1000;
383         swapThreshold = (_tTotal * 5) / 10000;
384         swapAmount = (_tTotal * 5) / 1000;
385 
386         approve(_routerAddress, type(uint256).max);
387 
388         contractInitialized = true;
389         _rOwned[owner()] = _rTotal;
390         emit Transfer(ZERO, owner(), _tTotal);
391 
392         _approve(address(this), address(dexRouter), type(uint256).max);
393 
394         _transfer(owner(), address(this), balanceOf(owner()));
395 
396 
397         
398 
399         dexRouter.addLiquidityETH{value: address(this).balance}(
400             address(this),
401             balanceOf(address(this)),
402             0, 
403             0, 
404             owner(),
405             block.timestamp
406         );
407         Planted = block.number;
408     }
409 
410 //===============================================================================================================
411 //===============================================================================================================
412 //===============================================================================================================
413     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
414     // This allows for removal of ownership privelages from the owner once renounced or transferred.
415     function owner() public view returns (address) {
416         return _owner;
417     }
418 
419     function transferOwner(address newOwner) external onlyOwner() {
420         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
421         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
422         setExcludedFromFee(_owner, false);
423         setExcludedFromFee(newOwner, true);
424         setExcludedFromReward(newOwner, true);
425         
426         if (_devWallet == payable(_owner))
427             _devWallet = payable(newOwner);
428         
429         _allowances[_owner][newOwner] = balanceOf(_owner);
430         if(balanceOf(_owner) > 0) {
431             _transfer(_owner, newOwner, balanceOf(_owner));
432         }
433         
434         _owner = newOwner;
435         emit OwnershipTransferred(_owner, newOwner);
436         
437     }
438 
439     function renounceOwnership() public virtual onlyOwner() {
440         setExcludedFromFee(_owner, false);
441         _owner = address(0);
442         emit OwnershipTransferred(_owner, address(0));
443     }
444 //===============================================================================================================
445 //===============================================================================================================
446 //===============================================================================================================
447 
448     function totalSupply() external view override returns (uint256) { return _tTotal; }
449     function decimals() external view returns (uint8) { return _decimals; }
450     function symbol() external view returns (string memory) { return _symbol; }
451     function name() external view returns (string memory) { return _name; }
452     function getOwner() external view returns (address) { return owner(); }
453     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
454 
455     function balanceOf(address account) public view override returns (uint256) {
456         if (_isExcluded[account]) return _tOwned[account];
457         return tokenFromReflection(_rOwned[account]);
458     }
459 
460     function transfer(address recipient, uint256 amount) public override returns (bool) {
461         _transfer(_msgSender(), recipient, amount);
462         return true;
463     }
464 
465     function approve(address spender, uint256 amount) public override returns (bool) {
466         _approve(_msgSender(), spender, amount);
467         return true;
468     }
469 
470     function approveMax(address spender) public returns (bool) {
471         return approve(spender, type(uint256).max);
472     }
473 
474     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
475         _transfer(sender, recipient, amount);
476         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
477         return true;
478     }
479 
480     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
481         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
482         return true;
483     }
484 
485     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
486         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
487         return true;
488     }
489 
490     function setNewRouter(address newRouter) external onlyOwner() {
491         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
492         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
493         if (get_pair == address(0)) {
494             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
495         }
496         else {
497             lpPair = get_pair;
498         }
499         dexRouter = _newRouter;
500         _approve(address(this), newRouter, MAX);
501     }
502 
503     function setLpPair(address pair, bool enabled) external onlyOwner {
504         if (enabled == false) {
505             lpPairs[pair] = false;
506         } else {
507             if (timeSinceLastPair != 0) {
508                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
509             }
510             lpPairs[pair] = true;
511             timeSinceLastPair = block.timestamp;
512         }
513     }
514 
515     function isExcludedFromReward(address account) public view returns (bool) {
516         return _isExcluded[account];
517     }
518 
519     function isExcludedFromFee(address account) public view returns(bool) {
520         return _isExcludedFromFee[account];
521     }
522 
523     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
524         require(reflect <= maxReflectFee
525                 && liquidity <= maxLiquidityFee
526                 && marketing <= maxMarketingFee
527                 );
528         require(reflect + liquidity + marketing <= 4900);
529         _buyReflectFee = reflect;
530         _buyLiquidityFee = liquidity;
531         _buyMarketingFee = marketing;
532     }
533 
534     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
535         require(reflect <= maxReflectFee
536                 && liquidity <= maxLiquidityFee
537                 && marketing <= maxMarketingFee
538                 );
539         require(reflect + liquidity + marketing <= 4900);
540         _sellReflectFee = reflect;
541         _sellLiquidityFee = liquidity;
542         _sellMarketingFee = marketing;
543     }
544 
545     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
546         require(reflect <= maxReflectFee
547                 && liquidity <= maxLiquidityFee
548                 && marketing <= maxMarketingFee
549                 );
550         require(reflect + liquidity + marketing <= 4900);
551         _transferReflectFee = reflect;
552         _transferLiquidityFee = liquidity;
553         _transferMarketingFee = marketing;
554     }
555 
556     function setValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
557         MarketShare = ms;
558         DevShare = ds;
559         ValueDivisor = vd;
560     }
561 
562     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
563         _liquidityRatio = liquidity;
564         _marketingRatio = marketing;
565     }
566 
567     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
568         uint256 check = (_tTotal * percent) / divisor;
569         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
570         _maxTxAmount = check;
571         maxTxAmountUI = (startingSupply * percent) / divisor;
572     }
573 
574     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
575         uint256 check = (_tTotal * percent) / divisor;
576         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
577         _maxWalletSize = check;
578         maxWalletSizeUI = (startingSupply * percent) / divisor;
579     }
580 
581     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
582         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
583         swapAmount = (_tTotal * amountPercent) / amountDivisor;
584     }
585 
586     function setNewMarketWallet(address payable newWallet) external onlyOwner {
587         require(_marketWallet != newWallet, "Wallet already set!");
588         _marketWallet = payable(newWallet);
589     }
590 
591     function setNewDevWallet(address payable newWallet) external onlyOwner {
592         require(_devWallet != newWallet, "Wallet already set!");
593         _devWallet = payable(newWallet);
594     }
595     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
596         swapAndLiquifyEnabled = _enabled;
597         emit SwapAndLiquifyEnabledUpdated(_enabled);
598     }
599 
600     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
601         _isExcludedFromFee[account] = enabled;
602     }
603 
604     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
605         if (enabled == true) {
606             require(!_isExcluded[account], "Account is already excluded.");
607             if(_rOwned[account] > 0) {
608                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
609             }
610             _isExcluded[account] = true;
611             _excluded.push(account);
612         } else if (enabled == false) {
613             require(_isExcluded[account], "Account is already included.");
614             for (uint256 i = 0; i < _excluded.length; i++) {
615                 if (_excluded[i] == account) {
616                     _excluded[i] = _excluded[_excluded.length - 1];
617                     _tOwned[account] = 0;
618                     _isExcluded[account] = false;
619                     _excluded.pop();
620                     break;
621                 }
622             }
623         }
624     }
625 
626     function totalFees() public view returns (uint256) {
627         return _tFeeTotal;
628     }
629 
630     function _hasLimits(address from, address to) internal view returns (bool) {
631         return from != owner()
632             && to != owner()
633             && !_liquidityHolders[to]
634             && !_liquidityHolders[from]
635             && to != DEAD
636             && to != address(0)
637             && from != address(this);
638     }
639 
640     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
641         require(rAmount <= _rTotal, "Amount must be less than total reflections");
642         uint256 currentRate =  _getRate();
643         return rAmount / currentRate;
644     }
645     
646     function _approve(address sender, address spender, uint256 amount) internal {
647         require(sender != address(0), "ERC20: approve from the zero address");
648         require(spender != address(0), "ERC20: approve to the zero address");
649 
650         _allowances[sender][spender] = amount;
651         emit Approval(sender, spender, amount);
652     }
653 
654     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
655         require(from != address(0), "ERC20: transfer from the zero address");
656         require(to != address(0), "ERC20: transfer to the zero address");
657         require(amount > 0, "Transfer amount must be greater than zero");
658         if(_hasLimits(from, to)) {
659             if(!tradingEnabled) {
660                 revert("Trading not yet enabled!");
661             }
662             if (sameBlockActive) {
663                 if (lpPairs[from]){
664                     require(lastTrade[to] != block.number);
665                     lastTrade[to] = block.number;
666                 } else {
667                     require(lastTrade[from] != block.number);
668                     lastTrade[from] = block.number;
669                 }
670             }
671             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
672             if(to != _routerAddress && !lpPairs[to]) {
673                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
674             }
675         }
676         bool takeFee = true;
677         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
678             takeFee = false;
679         }
680 
681         if (lpPairs[to]) {
682             if (!inSwapAndLiquify
683                 && swapAndLiquifyEnabled
684             ) {
685                 uint256 contractTokenBalance = balanceOf(address(this));
686                 if (contractTokenBalance >= swapThreshold) {
687                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
688                     swapAndLiquify(contractTokenBalance);
689                 }
690             }      
691         } 
692         return _finalizeTransfer(from, to, amount, takeFee);
693     }
694 
695     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
696         if (_liquidityRatio + _marketingRatio == 0)
697             return;
698         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
699 
700         uint256 toSwapForEth = contractTokenBalance - toLiquify;
701 
702         address[] memory path = new address[](2);
703         path[0] = address(this);
704         path[1] = dexRouter.WETH();
705 
706         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
707             toSwapForEth,
708             0,
709             path,
710             address(this),
711             block.timestamp
712         );
713 
714 
715         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
716 
717         if (toLiquify > 0) {
718             dexRouter.addLiquidityETH{value: liquidityBalance}(
719                 address(this),
720                 toLiquify,
721                 0, 
722                 0, 
723                 DEAD,
724                 block.timestamp
725             );
726             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
727         }
728         if (contractTokenBalance - toLiquify > 0) {
729 
730             uint256 OperationsFee = (address(this).balance);
731             uint256 marketFee = OperationsFee/(ValueDivisor)*(MarketShare);
732             uint256 devfeeshare = OperationsFee/(ValueDivisor)*(DevShare);
733             _marketWallet.transfer(marketFee);
734             _devWallet.transfer(devfeeshare);            
735 
736         }
737     }
738 
739     
740 
741     function _checkLiquidityAdd(address from, address to) internal {
742         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
743         if (!_hasLimits(from, to) && to == lpPair) {
744             _liquidityHolders[from] = true;
745             _hasLiqBeenAdded = true;
746             _liqAddStamp = block.timestamp;
747 
748             swapAndLiquifyEnabled = true;
749             emit SwapAndLiquifyEnabledUpdated(true);
750         }
751     }
752 
753     function enableTrading() public onlyOwner {
754         require(!tradingEnabled, "Trading already enabled!");
755         setExcludedFromReward(address(this), true);
756         setExcludedFromReward(lpPair, true);
757 
758         tradingEnabled = true;
759         swapAndLiquifyEnabled = true;
760     }
761 
762     struct ExtraValues {
763         uint256 tTransferAmount;
764         uint256 tFee;
765         uint256 tLiquidity;
766 
767         uint256 rTransferAmount;
768         uint256 rAmount;
769         uint256 rFee;
770     }
771 
772     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
773 
774 
775         if (!_hasLiqBeenAdded) {
776                 _checkLiquidityAdd(from, to);
777                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
778                     revert("Only owner can transfer at this time.");
779                 }
780         }
781         
782         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
783 
784         _rOwned[from] = _rOwned[from] - values.rAmount;
785         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
786 
787         if (_isExcluded[from] && !_isExcluded[to]) {
788             _tOwned[from] = _tOwned[from] - tAmount;
789         } else if (!_isExcluded[from] && _isExcluded[to]) {
790             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
791         } else if (_isExcluded[from] && _isExcluded[to]) {
792             _tOwned[from] = _tOwned[from] - tAmount;
793             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
794         }
795 
796         if (values.tLiquidity > 0)
797             _takeLiquidity(from, values.tLiquidity);
798         if (values.rFee > 0 || values.tFee > 0)
799             _takeReflect(values.rFee, values.tFee);
800 
801         emit Transfer(from, to, values.tTransferAmount);
802         return true;
803     }
804 
805     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
806         ExtraValues memory values;
807         uint256 currentRate = _getRate();
808 
809         values.rAmount = tAmount * currentRate;
810 
811         if(takeFee) {
812             if (lpPairs[to]) {
813                 _reflectFee = _sellReflectFee;
814                 _liquidityFee = _sellLiquidityFee;
815                 _marketingFee = _sellMarketingFee;
816             } else if (lpPairs[from]) {
817                 _reflectFee = _buyReflectFee;
818                 _liquidityFee = _buyLiquidityFee;
819                 _marketingFee = _buyMarketingFee;
820             } else {
821                 _reflectFee = _transferReflectFee;
822                 _liquidityFee = _transferLiquidityFee;
823                 _marketingFee = _transferMarketingFee;
824             }
825 
826             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
827             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
828             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
829 
830             values.rFee = values.tFee * currentRate;
831         } else {
832             values.tFee = 0;
833             values.tLiquidity = 0;
834             values.tTransferAmount = tAmount;
835 
836             values.rFee = 0;
837         }
838 
839         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
840         return values;
841     }
842 
843     function _getRate() internal view returns(uint256) {
844         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
845         return rSupply / tSupply;
846     }
847 
848     function _getCurrentSupply() internal view returns(uint256, uint256) {
849         uint256 rSupply = _rTotal;
850         uint256 tSupply = _tTotal;
851         for (uint256 i = 0; i < _excluded.length; i++) {
852             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
853             rSupply = rSupply - _rOwned[_excluded[i]];
854             tSupply = tSupply - _tOwned[_excluded[i]];
855         }
856         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
857         return (rSupply, tSupply);
858     }
859     
860     function _takeReflect(uint256 rFee, uint256 tFee) internal {
861         _rTotal = _rTotal - rFee;
862         _tFeeTotal = _tFeeTotal + tFee;
863     }
864 
865     function rescueETH() external onlyOwner {
866         payable(owner()).transfer(address(this).balance);
867     }
868     
869     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
870         uint256 currentRate =  _getRate();
871         uint256 rLiquidity = tLiquidity * currentRate;
872         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
873         if(_isExcluded[address(this)])
874             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
875         emit Transfer(sender, address(this), tLiquidity); 
876     }
877 }